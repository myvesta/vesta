<?php

// Authentication checks
$authentication_check_this_is_nested_script = true;
$authentication_check_required_param['dataset']['domain'] = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/include_authentication_check.php");

// Check if WordPress is installed
//  Always use escapeshellarg for all arguments to avoid shell injection
$is_wordpress_installed=exec(VESTA_CMD."v-check-if-wordpress-is-installed ".escapeshellarg($myvesta_logged_user)." ".escapeshellarg($domain), $output, $return_var);
if ($is_wordpress_installed == '0') {
    // WordPress is not installed
    echo __('The WordPress is not installed').'.<br /><br />';
    echo myvesta_get_close_button();
    exit;
}

if (isset($_POST['wordpress_username']) == false) {
    // Form
    echo myvesta_open_form('/ajax/web/wordpress/router.php'); // send form to router.php
    echo myvesta_get_hidden_fields(array(
        "wordpress_add_admin_user" => "1"
    ));
    echo myvesta_get_element('input', __('WordPress Admin Username').':', 'wordpress_username', '', null, 'width: 300px;');
    echo myvesta_get_element('input', __('WordPress Admin Password').':', 'wordpress_password', '', null, 'width: 300px;');
    echo myvesta_get_element('input', __('WordPress Admin Email').':', 'wordpress_email', '', null, 'width: 300px;');
    echo myvesta_get_element('button', '', 'wordpress_add_admin_user_submit', __('Add WordPress Admin User'), null, 'width: 250px;', 'add');
    echo myvesta_close_form();
    exit;
} else {
    // Action to add admin user
    $username = $_POST['wordpress_username'];
    $password = $_POST['wordpress_password'];
    $email = $_POST['wordpress_email'];
    
    if (empty($username) || empty($password) || empty($email)) {
        echo '<span style="color: #ff6b6b; font-weight: bold;">'.__('Error').':</span> <br />'.__('Please fill in all fields').'.<br /><br />';
        echo myvesta_get_close_button(); exit;
    }
    die_if_variable_contains_single_quote($username);
    die_if_variable_contains_single_quote($password);
    die_if_variable_contains_single_quote($email);
    
    $output = '';
    $return_var = 0;
    // Always use escapeshellarg for all arguments to avoid shell injection
    $cmd = VESTA_CMD."v-add-wordpress-admin ".escapeshellarg($domain)." ".escapeshellarg($username)." ".escapeshellarg($password)." ".escapeshellarg($email);
    exec($cmd, $output, $return_var);
    if ($return_var != 0) {
        $output = implode("\n", $output);
        echo '<span style="color: #ff6b6b; font-weight: bold;">'.__('Error').':</span><br /><pre>'.$output.'</pre><br />';
        echo myvesta_get_close_button(); exit;
    }
    echo '<span style="color: #00b90a; font-weight: bold;">'.__('WordPress admin user added successfully').'.</span><br /><br />';
    echo '<strong>'.__('Username').':</strong> '.$username.'<br />';
    echo '<strong>'.__('Password').':</strong> '.$password.'<br />';
    echo '<strong>'.__('Email').':</strong> '.$email.'<br /><br />';
    echo __('Try to login to WordPress at').': <a style="color: #007bff !important;" href="https://'.$domain.'/wp-admin/" target="_blank">https://'.$domain.'/wp-admin/</a><br /><br /><br />';
    echo myvesta_get_close_button(); exit;
}
