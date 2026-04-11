<?php

$phpgate_run_counter_or_ban=false; // entering ban-check functions and counting hit
$phpgate_should_count=true; // if 'false' then hit will not be counted, just ban-check will occur

function phpgate_cut_request($msg="", $code=404) {
    global $phpgate_cut_msg, $phpgate_cut_code, $phpgate_cut_retry_after;
    if (isset($phpgate_cut_msg)) $msg=$phpgate_cut_msg;
    if (isset($phpgate_cut_code)) $code=$phpgate_cut_code;
    http_response_code($code);
    if (isset($phpgate_cut_retry_after)) header('Retry-After: '.$phpgate_cut_retry_after);
    if ($msg!="") {
        if (strpos($msg, '<html')!==false) echo $msg;
        else echo phpgate_make_html_page('Bot traffic detected', $msg);
    }
    exit;
}

function phpgate_make_html_page($title, $msg) {
    $html = "<html><head><title>".$title."</title></head><body><center><h1>".$title."</h1><br /><p>".$msg."</p></center></body></html>";
    return $html;
}

function phpgate_convert_ip_to_key($ip) {
    $ip_last_dot=strrpos($ip, '.');
    if ($ip_last_dot==false) {
        // IPv6 truncating
        $ip_last_dot=strrpos($ip, ':');
        $ip=substr($ip, 0, $ip_last_dot);
        $ip=str_replace(':0:0:0', '', $ip);
        $ip_last_dot=strrpos($ip, ':');
    }
    // banned_key is the C class of the IPv4 address (first 3 octets)
    $banned_key='phpgate_banned_'.substr($ip, 0, $ip_last_dot);
    return $banned_key;
}

// Limit AI bots per Agent string/specific_endpoint
function phpgate_count_limit_bot($name, $is_it_bot_or_specific_endpoint=1, $max_retry=3, $find_time=60, $ban_time=60) { 
    // is_it_bot_or_specific_endpoint: 1 = bot, 2 = specific_endpoint
    global $phpgate_run_counter_or_ban, $phpgate_cut_msg, $phpgate_cut_code, $phpgate_ip, $phpgate_counter_key, $phpgate_banned_key, $phpgate_cut_retry_after, $phpgate_find_time, $phpgate_ban_time, $phpgate_max_retry, $phpgate_agent_strings, $phpgate_extend_ban_time;
    $phpgate_run_counter_or_ban=true;
    if ($is_it_bot_or_specific_endpoint==1 && isset($phpgate_agent_strings[$name])) $phpgate_max_retry=$phpgate_agent_strings[$name];
    else $phpgate_max_retry=$max_retry;
    $phpgate_find_time=$find_time;
    $phpgate_ban_time=$ban_time;
    $name=str_replace(' ', '_', $name);
    $name=str_replace('/', '_', $name);
    $name=str_replace('\\', '_', $name);
    $name=str_replace('|', '_', $name);
    $name=str_replace('"', '_', $name);
    $name=str_replace("'", '_', $name);
    $phpgate_ip=$name;
    $phpgate_counter_key='phpgate_ip_'.$name; // we don't want to count hits for this IP separately, that's why we are using the same 'IP value' for this 'name' (agent string/specific_endpoint), so it will count hits for this 'name' whatever IP is used
    $phpgate_banned_key='phpgate_banned_'.$name; // we don't want to ban this IP separately, that's why we are using the same 'key value' for this 'name' (agent string/specific_endpoint), so it will ban this 'name' whatever IP is used
    $phpgate_extend_ban_time=false;
    $phpgate_cut_msg="Slow down. You're crawling too fast and aggressively. Maximum number of requests per minute is ".$phpgate_max_retry.".";
    $phpgate_cut_code=429;
    $phpgate_cut_retry_after=$phpgate_find_time;
}

// Limit DDoS bots per IP address
function phpgate_count_limit_ip($max_retry=3, $find_time=60, $ban_time=86400) {
    global $phpgate_run_counter_or_ban, $phpgate_cut_msg, $phpgate_cut_code, $phpgate_ip, $phpgate_counter_key, $phpgate_banned_key, $phpgate_cut_retry_after, $phpgate_find_time, $phpgate_ban_time, $phpgate_max_retry, $phpgate_extend_ban_time;
    $phpgate_run_counter_or_ban=true;
    $phpgate_max_retry=$max_retry;
    $phpgate_find_time=$find_time;
    $phpgate_ban_time=$ban_time;
    $phpgate_ip=$_SERVER['REMOTE_ADDR'];
    $phpgate_counter_key='phpgate_ip_'.$phpgate_ip; // look for this IP in memcached
    $phpgate_banned_key=phpgate_convert_ip_to_key($phpgate_ip); // look for this key in memcached
    $phpgate_extend_ban_time=false;
    $phpgate_cut_msg="Slow down. You're crawling too fast and aggressively.";
    $phpgate_cut_code=429;
    $phpgate_cut_retry_after=$phpgate_find_time;
}
// if ( strpos($_SERVER['REQUEST_URI'], "amplifier-en?tags=") !== false ) phpgate_count_limit_ip(); // example of hit specific URL detection
// if ( strpos($_SERVER['REQUEST_URI'], "?p=1") !== false ) phpgate_count_limit_ip(3, 60, 60); // example of hit specific URL detection

$phpgate_the_same_ip=false;
if (isset($_SERVER['SERVER_ADDR']) && isset($_SERVER['REMOTE_ADDR'])) {
    if ($_SERVER['REMOTE_ADDR']=="127.0.0.1" || $_SERVER['SERVER_ADDR'] == $_SERVER['REMOTE_ADDR']) $phpgate_the_same_ip=true;
}


if (file_exists('/usr/share/phpgate/phpgate-conf.php')==true) include_once('/usr/share/phpgate/phpgate-conf.php');
if (isset($_REQUEST['wc-api'])==true && $_REQUEST['wc-api']=='wc_allsecureexchange') $phpgate_skip_agent_string_check=true;

if (isset($_GET['sharing'])==false && isset($phpgate_skip_agent_string_check)==false && file_exists('/usr/share/phpgate/phpgate-agent-strings.php')==true) include_once('/usr/share/phpgate/phpgate-agent-strings.php');

if (isset($phpgate_skip_xmlrpc_block)==false && substr($_SERVER['PHP_SELF'], -10)=='xmlrpc.php') phpgate_cut_request();
if (isset($phpgate_skip_wp_trackback_block)==false && substr($_SERVER['PHP_SELF'], -16)=='wp-trackback.php') phpgate_cut_request();
// if (isset($_SERVER['REQUEST_URI']) && strpos($_SERVER['REQUEST_URI'], "_rstr_nocache")!==false) phpgate_cut_request();


if (substr($_SERVER['PHP_SELF'], -12)=='wp-login.php') {
    $phpgate_run_counter_or_ban=true;
    if ($_SERVER['REQUEST_METHOD']=='GET' && substr($_SERVER['PHP_SELF'], -12)=='wp-login.php') $phpgate_should_count=false;
    if (substr($_SERVER['PHP_SELF'], -12)=='wp-login.php' && isset($_POST['post_password'])==true && isset($_POST['log'])==false && isset($_POST['pwd'])==false) $phpgate_should_count=false;
}

if (isset($_GET['remove_me_from_blacklist'])) $phpgate_run_counter_or_ban=true;

if ($phpgate_run_counter_or_ban) include_once('/usr/share/phpgate/phpgate-func.php');
