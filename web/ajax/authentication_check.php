<?php
error_reporting(NULL);

// Main include
include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

// Check token
if (isset($_GET['token'])) $_POST['token'] = $_GET['token'];
if (!isset($_SESSION['token']) || !isset($_POST['token']) || ($_SESSION['token'] != $_POST['token'])) die('Wrong token');

if (isset($required_param)) {
    foreach ($required_param as $param => $value) {
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
if (isset($required_param['dataset']['domain'])) $domain = $_REQUEST['dataset']['domain'];
if (isset($required_param['domain'])) $domain = $_REQUEST['domain'];

$logged_user = $_SESSION['user'];
if (isset($_SESSION['look']) && !empty($_SESSION['look'])) $logged_user = $_SESSION['look'];

if (isset($domain)) {
    $result = exec(VESTA_CMD."v-check-domain-owner ".$logged_user." ".$domain);
        if ($result !== '1') {
            die('Domain is not owned by '.$logged_user);
        }
}
