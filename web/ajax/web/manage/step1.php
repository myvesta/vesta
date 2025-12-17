<?php

// Authentication checks
$authentication_check_this_is_nested_script = false;
$authentication_check_required_param['dataset']['domain'] = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/include_authentication_check.php");

// Form elements include
include($_SERVER['DOCUMENT_ROOT']."/inc/form-elements.php");

echo myvesta_open_form('/ajax/web/manage/step2.php');

echo myvesta_get_hidden_fields();
//echo myvesta_get_confirtmation_hidden_fields();

// install button block
echo myvesta_get_element('button_gray', '', 'install_wordpress', __('Install WordPress'), null, 'width: 200px;', 'add', '['.__("What's this?").']', 'https://forum.myvestacp.com/viewtopic.php?t=386');

$is_wordpress_installed=exec(VESTA_CMD."v-check-if-wordpress-is-installed ".escapeshellarg($myvesta_logged_user)." ".escapeshellarg($domain), $output, $return_var);
if ($is_wordpress_installed == '1') {
    // lock/unlock buttons block
    $is_wordpress_locked=exec(VESTA_CMD."v-check-if-wordpress-is-locked ".escapeshellarg($myvesta_logged_user)." ".escapeshellarg($domain), $output, $return_var);
    if ($is_wordpress_locked == '0') echo myvesta_get_element('button_gray', '', 'lock_wordpress', __('Lock WordPress'), null, 'width: 200px;', 'add', '['.__("What's this?").']', 'https://forum.myvestacp.com/viewtopic.php?t=725');
    if ($is_wordpress_locked == '1') echo myvesta_get_element('button_gray', '', 'unlock_wordpress', __('Unlock WordPress'), null, 'width: 200px;', 'add', '['.__("What's this?").']', 'https://forum.myvestacp.com/viewtopic.php?t=725');

    // Clone
    echo myvesta_get_element('button_gray', '', 'clone_wordpress_step1', __('Clone WordPress'), null, 'width: 200px;', 'add', '['.__("What's this?").']', 'https://forum.myvestacp.com/viewtopic.php?t=385');
}

echo myvesta_close_form();

exit;