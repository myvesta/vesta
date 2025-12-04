<?php

// Nested sub-script for WordPress installation

// Authentication checks
if (!isset($authentication_check_loaded)) die('Authentication check not loaded');

// Check if confirmation needed
$is_empty_public_html=exec(VESTA_CMD."v-check-if-public-html-is-empty $user $domain", $output, $return_var);

$run_action=false;
$canceled=false;

if ($is_empty_public_html=='0') {
    // Directory not empty, ask for confirmation
    if (isset($_POST['Yes'])==false && isset($_POST['No'])==false) {
        echo myvesta_open_form('/ajax/web/manage/step2.php');
        echo __('There are previusly files in the domain directory').'.<br />';
        echo __('Are you sure you want to override them').'?<br /><br />';
        echo myvesta_get_hidden_fields(array('install_wordpress' => '1'));
        echo myvesta_get_element('buttons_confirm', '', 'Yes/No', __('Yes').'/'.__('No'));
        echo myvesta_close_form();
        exit;
    } else {
        if (isset($_POST['Yes'])) $run_action=true;
        elseif (isset($_POST['No'])) { myvesta_hide_floating_div(); exit; }
        else die('==== No action selected ====');
    }
}

if ($is_empty_public_html=='1') {
    $run_action=true;
}

if ($run_action) {
    // Execute action using v-spawn-ajax-process for long-running tasks
    $output='';
    $exec_output='';
    $cmd = VESTA_CMD."v-spawn-ajax-process $user /usr/local/vesta/bin/v-install-wordpress $domain";
    $exec_output = shell_exec($cmd);
    $output=__('WordPress installation output').':';
    echo '<b>'.$output.'</b><br /><br />';
    $exec_output = trim($exec_output);
    echo myvesta_get_disabled_textarea('', '', true, true, $myvesta_logged_user, $exec_output);
    exit;
}