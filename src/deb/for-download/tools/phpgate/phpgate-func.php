<?php

// xmlrpc.php block
if (substr($_SERVER['PHP_SELF'], -10)=='xmlrpc.php') {
    if (!isset($phpgate_skip_xmlrpc_block)) {
        foreach ($_POST as $var => $val) {
            if (strpos($var, "wp_getUsersBlogs")!==false) {
                // block requests to xmlrpc.php if POST wp_getUsersBlogs parameter is present
                header("HTTP/1.1 404 Not Found");
                exit;
            }
        }
    } else {
        // block all requests to xmlrpc.php
        phpgate_cut_request();
    }
}

// --- callback functions ---

// callback function to update timings - alter the number of suspicious hits in $arr ($phpgate_current_ip_array) array
function phpgate_update_timings($arr) {
    global $phpgate_current_ip_counter, $phpgate_current_ip_array, $phpgate_ban_time;
    $unixtime=time();
    if ($arr===null) {
        $phpgate_current_ip_counter=1;
        $phpgate_current_ip_array=array($unixtime=>1);
        return $phpgate_current_ip_array;
    }

    if (isset($arr[$unixtime])) $arr[$unixtime]=intval($arr[$unixtime])+1; // increment counter
    else $arr[$unixtime]=1;

    $phpgate_current_ip_counter=0;
    foreach ($arr as $time => $counter) {
        if ($time<$unixtime-$phpgate_ban_time) {unset($arr[$time]); continue;} // remove expired timings
        $phpgate_current_ip_counter+=$counter; // add counter to current ip counter
    }
    $phpgate_current_ip_array=$arr;
    return $arr;
}

// callback function to add banned IP to array
function phpgate_add_banned($arr) {
    global $phpgate_ip, $phpgate_global_banned;
    $unixtime=time();

    if ($arr===null) {
        $phpgate_global_banned=array($phpgate_ip=>$unixtime);
        return $phpgate_global_banned;
    }

    $arr[$phpgate_ip]=$unixtime;
    $phpgate_global_banned=$arr;

    return $arr;
}

// callback function to remove expired banned IPs from array
function phpgate_remove_expired_banned($arr) {
    global $phpgate_ip, $phpgate_ban_time;
    $unixtime=time();

    if ($arr===null) return array();

    foreach ($arr as $ip => $time) {
        if ($time<$unixtime-$phpgate_ban_time) unset($arr[$ip]);
    }
    return $arr;
}

// callback function to remove banned IP from array
function phpgate_unban_banned($arr) {
    global $phpgate_ip, $phpgate_global_banned;
    if ($arr===null) return array();
    if (isset($arr[$phpgate_ip])) unset($arr[$phpgate_ip]);
    $phpgate_global_banned=$arr;
    return $arr;
}

// --- end of callback functions ---


// --- memcached helper functions ---

// function to update memcached safely
// parameters:
// $key - key to update
// $update_cb - callback function to update value
// $ttl - time to live
function phpgate_memcached_safe_update($key, $update_cb, $ttl=600) {
    global $phpgate_memcached; //, $phpgate_debug;
    $loop=0;
    $cas = null;
    while (true) {
        $loop++;
        if ($loop==10) break; // if loop is 10, break
        $result_ok=true;
        if (defined('Memcached::GET_EXTENDED')==false) {
            $value = $phpgate_memcached->get($key, null, $cas);
        } else {
            $r = $phpgate_memcached->get($key, null, Memcached::GET_EXTENDED);
            if (isset($r['cas'])) $cas = $r['cas']; // get cas value
            else $result_ok=false; // if cas is not set, consider it as not found
            if (isset($r['value'])) $value = $r['value']; // get value
            else $result_ok=false; // if value is not set, consider it as not found
        }

        if ($result_ok==false || $phpgate_memcached->getResultCode() == Memcached::RES_NOTFOUND) {
            // not found, add new value
            $value = call_user_func($update_cb, null);
            $phpgate_memcached->add($key, $value, $ttl);
            if ($phpgate_memcached->getResultCode() == Memcached::RES_SUCCESS) break;
        } else {
            // found, update value
            $value = call_user_func($update_cb, $value);
            if (defined('Memcached::GET_EXTENDED')==false || $cas==null) $phpgate_memcached->set($key, $value, $ttl);
            else $phpgate_memcached->cas($cas, $key, $value, $ttl);
            if ($phpgate_memcached->getResultCode() == Memcached::RES_SUCCESS) break;
        }
        //if ($phpgate_debug) echo "loop<br />\n";
        usleep(100000); // sleep for 0.1 seconds
    }
}

// end of memcached helper functions

if ($phpgate_the_same_ip==false) {
    // main flow if it's request from outside

    //ini_set('display_errors',1); ini_set('display_startup_errors',1); error_reporting(-1);

    // set default values
    if (isset($phpgate_ban_time)==false) $phpgate_ban_time=86400; // 24 hours
    if (isset($phpgate_extend_ban_time)==false) $phpgate_extend_ban_time=true;
    if (isset($phpgate_max_retry)==false) $phpgate_max_retry=5;
    if (isset($phpgate_find_time)==false) $phpgate_find_time=600;
    // $phpgate_debug=false;
    if (!class_exists('Memcached')) return;
    $phpgate_memcached = new Memcached();
    $phpgate_memcached->addServer('localhost', 11211);

    if (isset($phpgate_ip)==false) $phpgate_ip=$_SERVER['REMOTE_ADDR'];
    if (isset($phpgate_key)==false) $phpgate_key='phpgate_ip_'.$phpgate_ip;

    if (isset($phpgate_banned_key)==false) {
        $phpgate_ip_last_dot=strrpos($phpgate_ip, '.');
        if ($phpgate_ip_last_dot==false) {
            $phpgate_ip_last_dot=strrpos($phpgate_ip, ':');
            $phpgate_ip=substr($phpgate_ip, 0, $phpgate_ip_last_dot);
            $phpgate_ip=str_replace(':0:0:0', '', $phpgate_ip);
            $phpgate_ip_last_dot=strrpos($phpgate_ip, ':');
        }
        $phpgate_banned_key='phpgate_banned_'.substr($phpgate_ip, 0, $phpgate_ip_last_dot);
    }

    if (isset($_GET['remove_me_from_blacklist'])==false) {
        // *************************** main phpgate processing - log suspicious request or block request if IP is already banned ***************************
        $phpgate_global_banned=$phpgate_memcached->get($phpgate_banned_key);
        if (isset($phpgate_global_banned[$phpgate_ip])) {
            // IP is found in ban list
            if ($phpgate_global_banned[$phpgate_ip] < time()-$phpgate_ban_time) {
                // last hit was before $phpgate_ban_time, unban IP
                phpgate_memcached_safe_update($phpgate_banned_key, 'phpgate_remove_expired_banned', $phpgate_ban_time); // time to unban IP
            } else {
                if ($phpgate_extend_ban_time==true) {
                    // last his was in last $phpgate_ban_time seconds, so add $phpgate_ban_time seconds to time_counter and keep it blocked
                    phpgate_memcached_safe_update($phpgate_banned_key, 'phpgate_add_banned', $phpgate_ban_time);
                }
                // block request
                phpgate_cut_request("Too many wrong login attempts - or - bot traffic detected - your IP is banned.<br />\nClick <script>document.write('<a href=\"".$_SERVER['PHP_SELF']."?'+'remove'+'_me_from_blacklist=1\">here</a>')</script> to remove you from blacklist.");
            }
        }

        if ($phpgate_should_count==true) {
            // alter the number of suspicious hits
            phpgate_memcached_safe_update($phpgate_key, 'phpgate_update_timings', $phpgate_find_time);
            
            /*
            if ($phpgate_debug) {
                echo "final: "; print_r($phpgate_memcached->get($phpgate_key)); echo "<br />\n";
                echo "count: ".$phpgate_current_ip_counter."<br />\n";
            }
            */
            
            if ($phpgate_current_ip_counter>$phpgate_max_retry) {
                // maximum number of suspicious hits reached (five hits found, sixth is just happening), ban IP, add 24 hours to time_counter, block request
                phpgate_memcached_safe_update($phpgate_banned_key, 'phpgate_add_banned', $phpgate_ban_time);
                phpgate_cut_request("Too many wrong login attempts - or - bot traffic detected - your IP is banned now.<br />\nClick <script>document.write('<a href=\"".$_SERVER['PHP_SELF']."?'+'remove'+'_me_from_blacklist=1\">here</a>')</script> to remove you from blacklist.");
                // phpgate_log_post_request('ban');
            }
        }
    } else {
        // *** $_GET['remove_me_from_blacklist'] - manual removing from blacklist ***
        phpgate_memcached_safe_update($phpgate_banned_key, 'phpgate_unban_banned', $phpgate_ban_time);
        $phpgate_memcached->delete($phpgate_key);
        // phpgate_log_post_request('unban');
        // if ($phpgate_debug) echo "unbanned<br />\n";
    }

    if (isset($phpgate_memcached)) unset($phpgate_memcached);
    foreach ($GLOBALS as $key => $value) {
        if (strpos($key, 'phpgate_')!==false) unset($GLOBALS[$key]);
    }
}
