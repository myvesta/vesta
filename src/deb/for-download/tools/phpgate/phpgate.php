<?php

$phpgate_run_counter_or_ban=false; // entering ban-check functions and counting hit
$phpgate_should_count=true; // if 'false' then hit will not be counted, just ban-check will occur

function phpgate_cut_request($msg="", $code=404) {
    global $phpgate_cut_msg, $phpgate_cut_code, $phpgate_cut_retry_after;
    if (isset($phpgate_cut_msg)) $msg=$phpgate_cut_msg;
    if (isset($phpgate_cut_code)) $code=$phpgate_cut_code;
    http_response_code($code);
    if (isset($phpgate_cut_retry_after)) header('Retry-After: '.$phpgate_cut_retry_after);
    if ($msg!="") echo $msg;
    exit;
}

function phpgate_count_limit_bot($bot) {
    global $phpgate_run_counter_or_ban, $phpgate_cut_msg, $phpgate_cut_code, $phpgate_ip, $phpgate_key, $phpgate_banned_key, $phpgate_cut_retry_after, $phpgate_find_time, $phpgate_ban_time, $phpgate_max_retry, $phpgate_agent_strings, $phpgate_extend_ban_time;
    $phpgate_run_counter_or_ban=true;
    if (isset($phpgate_agent_strings[$bot])) $phpgate_max_retry=$phpgate_agent_strings[$bot];
    else $phpgate_max_retry=3;
    $phpgate_find_time=60;
    $phpgate_ban_time=60;
    $bot=str_replace(' ', '_', $bot);
    $bot=str_replace('/', '_', $bot);
    $bot=str_replace('\\', '_', $bot);
    $bot=str_replace('|', '_', $bot);
    $bot=str_replace('"', '_', $bot);
    $bot=str_replace("'", '_', $bot);
    $phpgate_ip=$bot;
    $phpgate_key='phpgate_ip_'.$bot;
    $phpgate_banned_key='phpgate_banned_'.$bot;
    $phpgate_extend_ban_time=false;
    $phpgate_cut_msg="Slow down. You're crawling too fast and aggressively. Maximum number of requests per minute is ".$phpgate_max_retry.".";
    $phpgate_cut_code=429;
    $phpgate_cut_retry_after=$phpgate_find_time;
}

$phpgate_the_same_ip=false;
if (isset($_SERVER['SERVER_ADDR']) && isset($_SERVER['REMOTE_ADDR'])) {
    if ($_SERVER['REMOTE_ADDR']=="127.0.0.1" || $_SERVER['SERVER_ADDR'] == $_SERVER['REMOTE_ADDR']) $phpgate_the_same_ip=true;
}


if (file_exists('/usr/share/phpgate/phpgate-conf.php')==true) include_once('/usr/share/phpgate/phpgate-conf.php');
if (isset($_REQUEST['wc-api'])==true && $_REQUEST['wc-api']=='wc_allsecureexchange') $phpgate_skip_agent_string_check=true;

if (isset($phpgate_skip_agent_string_check)==false && file_exists('/usr/share/phpgate/phpgate-agent-strings.php')==true) include_once('/usr/share/phpgate/phpgate-agent-strings.php');

if (isset($phpgate_skip_xmlrpc_block)==false && substr($_SERVER['PHP_SELF'], -10)=='xmlrpc.php') phpgate_cut_request();
if (isset($phpgate_skip_wp_trackback_block)==false && substr($_SERVER['PHP_SELF'], -16)=='wp-trackback.php') phpgate_cut_request();
if (isset($_SERVER['REQUEST_URI']) && strpos($_SERVER['REQUEST_URI'], "_rstr_nocache")!==false) phpgate_cut_request();


if (substr($_SERVER['PHP_SELF'], -12)=='wp-login.php') {
    $phpgate_run_counter_or_ban=true;
    if ($_SERVER['REQUEST_METHOD']=='GET' && substr($_SERVER['PHP_SELF'], -12)=='wp-login.php') $phpgate_should_count=false;
    if (substr($_SERVER['PHP_SELF'], -12)=='wp-login.php' && isset($_POST['post_password'])==true && isset($_POST['log'])==false && isset($_POST['pwd'])==false) $phpgate_should_count=false;
}

if (isset($_GET['remove_me_from_blacklist'])) $phpgate_run_counter_or_ban=true;

if ($phpgate_run_counter_or_ban) include_once('/usr/share/phpgate/phpgate-func.php');
