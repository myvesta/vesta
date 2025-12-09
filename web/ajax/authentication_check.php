<?php

$authentication_check_loaded = true;

// Main include
include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

function check_if_domain_is_owned_by_user($domain, $user) {
    // Check if domain is owned by the user
    //  Always use escapeshellarg for all arguments to avoid shell injection
    $result = exec(VESTA_CMD."v-check-domain-owner ".escapeshellarg($user)." ".escapeshellarg($domain));
    if ($result !== '1') {
        die('Domain is not owned by '.$user);
    }
}

// Check token
if (isset($_GET['token'])) $_POST['token'] = $_GET['token'];
if (!isset($_SESSION['token']) || !isset($_POST['token']) || ($_SESSION['token'] != $_POST['token'])) die('Wrong token');

if (isset($authentication_check_required_param)) {
    foreach ($authentication_check_required_param as $param => $value) {
        if (is_array($value)) {
            foreach ($value as $key => $value) {
                if (!isset($_REQUEST[$param][$key])) die("[$param][$key] is required. Current value is: ".$_REQUEST[$param][$key]."<br />_REQUEST is: <pre>".print_r($_REQUEST, true)."</pre>");
            }
        }
        else {
            if (!isset($_REQUEST[$param])) die("[$param] is required. Current value is: ".$_REQUEST[$param]."<br />_REQUEST is: <pre>".print_r($_REQUEST, true)."</pre>");
        }
    }
}
if (isset($authentication_check_required_param['dataset']['domain'])) {
    // get $domain from $_REQUEST['dataset']['domain']
    $domain = $_REQUEST['dataset']['domain'];
    // check if domain is owned by the user and die if not
    check_if_domain_is_owned_by_user($domain, $myvesta_logged_user);
}
if (isset($authentication_check_required_param['domain'])) {
    // get $domain from $_REQUEST['domain']
    $domain = $_REQUEST['domain'];
    // check if domain is owned by the user and die if not
    check_if_domain_is_owned_by_user($domain, $myvesta_logged_user);
}

if (isset($authentication_check_match_user)) { // if $authentication_check_match_user is set, check if logged user is the same as the user in $authentication_check_match_user
    if ($myvesta_logged_user != $authentication_check_match_user) {
        die('User is not '.$authentication_check_match_user);
    }
}