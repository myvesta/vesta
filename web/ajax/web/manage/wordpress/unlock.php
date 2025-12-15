<?php

// Nested sub-script for WordPress unlocking

// Authentication checks
$authentication_check_this_is_nested_script = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/include_authentication_check.php");

// Check if WordPress is installed
//  Always use escapeshellarg for all arguments to avoid shell injection
$is_wordpress_installed=exec(VESTA_CMD."v-check-if-wordpress-is-installed ".escapeshellarg($user)." ".escapeshellarg($domain), $output, $return_var);
if ($is_wordpress_installed == '0') {
    // WordPress is not installed
    echo __('The WordPress is not installed').'.<br /><br />';
    echo myvesta_get_close_button();
    exit;
}

// Check if WordPress is locked
//  Always use escapeshellarg for all arguments to avoid shell injection
$is_wordpress_locked=exec(VESTA_CMD."v-check-if-wordpress-is-locked ".escapeshellarg($user)." ".escapeshellarg($domain), $output, $return_var);
if ($is_wordpress_locked=='0') {
    // WordPress is not locked
    echo __('The WordPress is already unlocked').'.<br /><br />';
    echo myvesta_get_close_button();
    exit;
}

// Execute action using v-spawn-ajax-process for long-running tasks
$output='';
$exec_output='';
// Always use escapeshellarg for all arguments to avoid shell injection
$cmd = VESTA_CMD."v-spawn-ajax-process ".escapeshellarg($myvesta_logged_user)." /usr/local/vesta/bin/v-unlock-wordpress ".escapeshellarg($domain);
$exec_output = shell_exec($cmd);
$output=__('WordPress unlocking output').':';
echo '<b>'.$output.'</b><br /><br />';
$hash = trim($exec_output);
echo myvesta_get_disabled_textarea('', '', false, true, true, $myvesta_logged_user, $hash, 100);
exit;
