<?php

function return_ajax_result($code, $exit_code, $output) {
    echo json_encode(['code' => $code, 'exit_code' => $exit_code, 'output' => $output]);
    exit($code);
}

if (!isset($_POST['user']) || !isset($_POST['hash'])) {
    return_ajax_result(1, '', "User and hash are required");
}

// Authentication checks
$authentication_check_match_user = $_POST['user'];
include($_SERVER['DOCUMENT_ROOT']."/ajax/authentication_check.php");

$user = $_POST['user'];
$hash = $_POST['hash'];

if (empty($user)) {
    return_ajax_result(5, '', "User is required");
}

if (empty($hash)) {
    return_ajax_result(4, '', "Hash is required");
}

if (!is_dir("/home/$user")) {
    return_ajax_result(3, '', "User doesn't exist");
}

$log_file  = "/home/admin/tmp/$user-$hash.log";
$lock_file = "/home/admin/tmp/$user-$hash.lock";
$exit_code_file = "/home/admin/tmp/$user-$hash.exit_code";

if (!is_file($log_file)) {
    return_ajax_result(2, '', "Log file doesn't exist");
}

//----------------------------------------------------------//
//                      Execution                            //
//----------------------------------------------------------//

// Output log content
$output = file_get_contents($log_file);

// Get exit code of command and save it to file
if (is_file($exit_code_file)) {
    $exit_code = file_get_contents($exit_code_file);
} else {
    $exit_code = '';
}

if (!is_file($lock_file)) $code = 1;
else $code = 0;

return_ajax_result($code, $exit_code, $output);
