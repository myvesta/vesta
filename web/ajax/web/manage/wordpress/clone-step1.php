<?php

// Nested sub-script for WordPress cloning

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

echo myvesta_open_form('/ajax/web/manage/step2.php');
echo myvesta_get_hidden_fields();
//  Always use escapeshellarg for all arguments to avoid shell injection
$cmd = VESTA_CMD."v-list-web-domains ".escapeshellarg($myvesta_logged_user) ." json";
$output = '';
$return_var = 0;
exec($cmd, $output, $return_var);
if ($return_var != 0) {
    $output = implode("\n", $output);
    echo __('Error').': <br /><br /><pre>'.$output.'</pre><br /><br />';
    echo myvesta_get_close_button();
    exit;
}
$output = implode("\n", $output);
$domains_output = json_decode($output, true);
$domains = array();
foreach ($domains_output as $domain_key => $domain_data) {
    if ($domain_key == $domain) continue;
    $domains[$domain_key] = $domain_key;
}
echo myvesta_get_element('listbox', __('Select the domain to clone the WordPress to').':', 'domain2', $domains, $domain);

echo myvesta_get_element('button', '', 'clone_wordpress_step2', __('Clone WordPress'), null, 'width: 200px;', 'add');
echo myvesta_close_form();
exit;
