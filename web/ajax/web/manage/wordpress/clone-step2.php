<?php

// Nested sub-script for WordPress cloning

// Authentication checks
$authentication_check_this_is_nested_script = true;
$authentication_check_required_param['domain2'] = true;
$authentication_check_required_param['dataset']['domain'] = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/include_authentication_check.php");

//echo '<pre>'; print_r($_POST); echo '</pre>'; exit;

// Get the second domain from the POST request
$domain2 = $_POST['domain2'];

// Check if the domain2 is owned by the user
check_if_domain_is_owned_by_user($domain2, $myvesta_logged_user);

if ($domain == $domain2) {
    echo __('The domain to clone the WordPress to is the same as the domain to clone from').'.<br /><br />';
    echo myvesta_get_close_button();
    exit;
}

// Check if confirmation needed
//  Always use escapeshellarg for all arguments to avoid shell injection
$is_empty_public_html=exec(VESTA_CMD."v-check-if-public-html-is-empty ".escapeshellarg($myvesta_logged_user)." ".escapeshellarg($domain2), $output, $return_var);

$run_action=false;
$canceled=false;

if ($is_empty_public_html=='0') {
    // Directory not empty, ask for confirmation
    if (isset($_POST['Yes'])==false && isset($_POST['No'])==false) {
        echo myvesta_open_form('/ajax/web/manage/step2.php');
        echo __('There are previusly files in the domain directory').' <b style="color: red;">'.$domain2.'</b>.<br />';
        echo __('Are you sure you want to override them').'?<br /><br />';
        echo myvesta_get_hidden_fields(array('clone_wordpress_step2' => '1', 'domain2' => $domain2));
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
    // Always use escapeshellarg for all arguments to avoid shell injection
    $cmd = VESTA_CMD."v-spawn-ajax-process ".escapeshellarg($myvesta_logged_user)." /usr/local/vesta/bin/v-clone-website ".escapeshellarg($domain)." ".escapeshellarg($domain2)." --NO_PROMPT=1";
    $exec_output = shell_exec($cmd);
    $output=__('WordPress cloning output').':';
    echo '<b>'.$output.'</b><br /><br />';
    $hash = trim($exec_output);
    echo myvesta_get_disabled_textarea('', '', true, true, true, $myvesta_logged_user, $hash);
    exit;
}