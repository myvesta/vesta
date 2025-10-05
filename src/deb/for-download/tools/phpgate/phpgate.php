<?php
function phpgate_cut_request($msg="", $code=404) {
    if ($msg!="") echo $msg;
    http_response_code($code);
    exit;
}

$phpgate_run_counter_or_ban=false;
$phpgate_should_count=true;

if (file_exists('/usr/share/phpgate/phpgate-conf.php')==true) include_once('/usr/share/phpgate/phpgate-conf.php');

if (isset($_REQUEST['wc-api'])==true && $_REQUEST['wc-api']=='wc_allsecureexchange') $phpgate_skip_agent_string_check=true;

if (isset($phpgate_skip_agent_string_check)==false && file_exists('/usr/share/phpgate/phpgate-agent-strings.php')==true) include_once('/usr/share/phpgate/phpgate-agent-strings.php');


if (substr($_SERVER['PHP_SELF'], -10)=='xmlrpc.php') phpgate_cut_request();
if (substr($_SERVER['PHP_SELF'], -16)=='wp-trackback.php') phpgate_cut_request();

if (substr($_SERVER['PHP_SELF'], -12)=='wp-login.php') {
    $phpgate_run_counter_or_ban=true;
    if ($_SERVER['REQUEST_METHOD']=='GET' && substr($_SERVER['PHP_SELF'], -12)=='wp-login.php') $phpgate_should_count=false;
    if (substr($_SERVER['PHP_SELF'], -12)=='wp-login.php' && isset($_POST['post_password'])==true && isset($_POST['log'])==false && isset($_POST['pwd'])==false) $phpgate_should_count=false;
}

if (isset($_GET['remove_me_from_blacklist'])) $phpgate_run_counter_or_ban=true;

if ($phpgate_run_counter_or_ban) include_once('/usr/share/phpgate/phpgate-func.php');
