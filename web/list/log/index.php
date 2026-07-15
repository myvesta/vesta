<?php
error_reporting(NULL);
$TAB = 'LOG';

// Main include
include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

// Data
exec (VESTA_CMD."v-list-user-log $user json", $output, $return_var);
check_error($return_var);
$output = implode("\n", $output);
$data = json_decode($output, true);
$data = array_reverse($data);
unset($output);
// Render page
render_page($user, $TAB, 'list_log');
