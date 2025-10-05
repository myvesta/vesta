<?php

if (substr($_SERVER['PHP_SELF'], -10)=='xmlrpc.php') {
    /*
    foreach ($_POST as $var => $val) {
        if (strpos($var, "wp_getUsersBlogs")!==false) {
            header("HTTP/1.1 404 Not Found");
            exit;
        }
    }
    */
    phpgate_cut_request();
}

function phpgate_update_timings($value) {
    global $phpgate_global_counter, $phpgate_global_ip_array, $phpgate_tolerance_time;
    $unixtime=time();
    if ($value===null) {
        $phpgate_global_counter=1;
        $phpgate_global_ip_array=array($unixtime=>1);
        return $phpgate_global_ip_array;
    }

    if (isset($value[$unixtime])) $value[$unixtime]=intval($value[$unixtime])+1;
    else $value[$unixtime]=1;

    $phpgate_global_counter=0;
    foreach ($value as $time => $counter) {
        if ($time<$unixtime-$phpgate_tolerance_time) {unset($value[$time]); continue;}
        $phpgate_global_counter=$phpgate_global_counter+$counter;
    }
    $phpgate_global_ip_array=$value;
    return $value;
}

function phpgate_add_banned($value) {
    global $phpgate_ip, $phpgate_global_banned;
    $unixtime=time();

    if ($value===null) {
        $phpgate_global_banned=array($phpgate_ip=>$unixtime);
        return $phpgate_global_banned;
    }

    $value[$phpgate_ip]=$unixtime;
    $phpgate_global_banned=$value;

    return $value;
}

function phpgate_clear_old_banned($value) {
    global $phpgate_ip, $phpgate_global_banned_time;
    $unixtime=time();

    if ($value===null) return array();

    foreach ($value as $ip => $time) {
        if ($time<$unixtime-$phpgate_global_banned_time) unset($value[$ip]);
    }
    return $value;
}

function phpgate_unban_banned($value) {
    global $phpgate_ip, $phpgate_global_banned;
    if ($value===null) return array();
    if (isset($value[$phpgate_ip])) unset($value[$phpgate_ip]);
    $phpgate_global_banned=$value;
    return $value;
}

function phpgate_memcached_safe_update($key, $update_cb, $ttl=600) {
    global $phpgate_memcached, $phpgate_debug;
    $loop=0;
    while (true) {
        $loop++;
        if ($loop==10) break;
        $result_ok=true;
        if (defined('Memcached::GET_EXTENDED')==false) $value = $phpgate_memcached->get($key, null, $cas);
        else {
            $r = $phpgate_memcached->get($key, null, Memcached::GET_EXTENDED);
            if (isset($r['cas'])) $cas = $r['cas'];
            else $result_ok=false;
            if (isset($r['value'])) $value = $r['value'];
            else $result_ok=false;
        }
        //sleep(5);
        if ($phpgate_memcached->getResultCode() == Memcached::RES_NOTFOUND || $result_ok==false) {
            $value = call_user_func($update_cb, null);
            $phpgate_memcached->add($key, $value, $ttl);
            if ($phpgate_memcached->getResultCode() == Memcached::RES_SUCCESS) break;
        } else {
            $value = call_user_func($update_cb, $value);
            $phpgate_memcached->cas($cas, $key, $value, $ttl);
            if ($phpgate_memcached->getResultCode() == Memcached::RES_SUCCESS) break;
        }
        if ($phpgate_debug) echo "loop<br />\n";
        usleep(100000);
    }
}

function phpgate_log_post_request($action) {
    global $phpgate_global_ip_array, $phpgate_global_banned, $phpgate_ip, $phpgate_banned_key;
    //$b="Found: $where = $key = ".print_r($val, true)."\n\n";
    $b="Action: ".$action."\n";
    $b.="Time: ".date("d M Y H:i:s")."\n";
    if (isset($_SERVER['SERVER_NAME'])) $b.="Domain: ".$_SERVER['SERVER_NAME']."\n";
    if (isset($_SERVER['REQUEST_URI'])) $b.="URL: ".$_SERVER['REQUEST_URI']."\n";
    if (isset($_SERVER['HTTP_USER_AGENT'])) $b.="Agent: ".$_SERVER['HTTP_USER_AGENT']."\n";
    $b.="IP: ".$phpgate_ip."\n";
    $host=@gethostbyaddr($phpgate_ip);
    $b.="Host: ".$host."\n";
    $b.="IP array: ".print_r($phpgate_global_ip_array, true)."\n";
    $b.="Banned key: ".$phpgate_banned_key."\n";
    $b.="Banned array: ".print_r($phpgate_global_banned, true)."\n";

    $b.="GET:\n";
    $b.=print_r ($_GET, true);
    $b.="\n\n";

    $b.="POST:\n";
    $b.=print_r ($_POST, true);
    $b.="\n\n";

    $b.="SERVER:\n";
    $b.=print_r ($_SERVER, true);
    $b.="\n\n";

    $b.="COOKIE:\n";
    $b.=print_r ($_COOKIE, true);

    if (isset($_SERVER['CONTENT_TYPE']) && $_SERVER['CONTENT_TYPE']=="application/json") {
        $json=file_get_contents("php://input");
        $b.="JSON:\n".$json."\n";
        $b.=print_r(json_decode($json), 1);
        $b.="\n\n";
    }
    $b.="\n\n=========================================================================================\n\n";
    
    file_put_contents("/usr/share/phpgate/banned-log.txt", $b, FILE_APPEND);
}

if ($_SERVER['REMOTE_ADDR']!=="127.0.0.1" && $_SERVER['REMOTE_ADDR']!==$_SERVER['SERVER_ADDR']) {
    // main flow if it's request from outside

    //ini_set('display_errors',1); ini_set('display_startup_errors',1); error_reporting(-1);
    $phpgate_global_banned_time=93600;
    $phpgate_tolerance_time=93600;
    $phpgate_debug=false;
    $phpgate_max_fails=6;

    $phpgate_memcached = new Memcached();
    $phpgate_memcached->addServer('localhost', 11211);

    $phpgate_ip=$_SERVER['REMOTE_ADDR'];
    // if (isset($_SERVER['HTTP_CF_CONNECTING_IP'])) $phpgate_ip=$_SERVER['HTTP_CF_CONNECTING_IP'];
    $phpgate_key='phpgate_ip_'.$phpgate_ip;

    $phpgate_ip_last_dot=strrpos($phpgate_ip, '.');
    if ($phpgate_ip_last_dot==false) {
        $phpgate_ip_last_dot=strrpos($phpgate_ip, ':');
        $phpgate_ip=substr($phpgate_ip, 0, $phpgate_ip_last_dot);
        $phpgate_ip=str_replace(':0:0:0', '', $phpgate_ip);
        $phpgate_ip_last_dot=strrpos($phpgate_ip, ':');
    }
    $phpgate_banned_key='phpgate_banned_'.substr($phpgate_ip, 0, $phpgate_ip_last_dot);

    if (isset($_GET['remove_me_from_blacklist'])==false) {
        // *************************** main phpgate processing - log suspicious request or block request if IP is already banned ***************************
        $phpgate_global_banned=$phpgate_memcached->get($phpgate_banned_key);
        if (isset($phpgate_global_banned[$phpgate_ip])) {
            // IP is found in ban list
            if (isset($phpgate_global_banned[$phpgate_ip]) && $phpgate_global_banned[$phpgate_ip] < time()-$phpgate_global_banned_time) {
                // last hit was before 26 hours, unban IP
                phpgate_memcached_safe_update($phpgate_banned_key, 'phpgate_clear_old_banned', 86400); // time to unban IP
            } else {
                // last his was in last 26 hours, so add 24 hours to time_counter and keep it blocked
                phpgate_memcached_safe_update($phpgate_banned_key, 'phpgate_add_banned', 86400);
                phpgate_cut_request("Too many wrong login attempts - or - bot traffic detected - your IP is banned.<br />\nClick <script>document.write('<a href=\"".$_SERVER['PHP_SELF']."?'+'remove'+'_me_from_blacklist=1\">here</a>')</script> to remove you from blacklist.");
            }
        }

        if ($phpgate_should_count==true) {
            // alter the number of suspicious hits
            phpgate_memcached_safe_update($phpgate_key, 'phpgate_update_timings', 600);
            
            if ($phpgate_debug) {
                echo "final: "; print_r($phpgate_memcached->get($phpgate_key)); echo "<br />\n";
                echo "count: ".$phpgate_global_counter."<br />\n";
            }
            
            if ($phpgate_global_counter>=$phpgate_max_fails) {
                // maximum number of suspicious hits reached (4 hits found, fifth is just happening), ban IP, add 24 hours to time_counter, block request
                phpgate_memcached_safe_update($phpgate_banned_key, 'phpgate_add_banned', 86400);
                phpgate_cut_request("Too many wrong login attempts - or - bot traffic detected - your IP is banned now.<br />\nClick <script>document.write('<a href=\"".$_SERVER['PHP_SELF']."?'+'remove'+'_me_from_blacklist=1\">here</a>')</script> to remove you from blacklist.");
                // phpgate_log_post_request('ban');
            }
        }
    } else {
        // *** $_GET['remove_me_from_blacklist'] - manual removing from blacklist ***
        phpgate_memcached_safe_update($phpgate_banned_key, 'phpgate_unban_banned', 86400);
        $phpgate_memcached->delete($phpgate_key);
        // phpgate_log_post_request('unban');
        if ($phpgate_debug) echo "unbanned<br />\n";
    }
    if (isset($phpgate_memcached)) unset($phpgate_memcached);
    if (isset($phpgate_ip)) unset($phpgate_ip);
    if (isset($phpgate_key)) unset($phpgate_key);
    if (isset($phpgate_unban_banned)) unset($phpgate_unixtime);
    if (isset($phpgate_banned_key)) unset($phpgate_banned_key);
    if (isset($phpgate_should_count)) unset($phpgate_should_count);
    if (isset($phpgate_global_counter)) unset($phpgate_global_counter);
}
