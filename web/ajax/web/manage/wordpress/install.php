<?php
if (!isset($authentication_check_loaded)) die('Authentication check not loaded');

if (isset($_POST['Yes'])==false && isset($_POST['No'])==false) {
    echo myvesta_open_form('/ajax/web/manage/step2.php');
    echo __('There are previusly files in the domain directory').'.<br />';
    echo __('Are you sure you want to override them').'?<br /><br />';
    echo myvesta_get_hidden_fields(array('install_wordpress' => '1'));
    echo myvesta_get_element('buttons_confirm', '', 'Yes/No', __('Yes').'/'.__('No'));
    echo myvesta_close_form();
} else {
    if (isset($_POST['Yes'])) echo 'Yes';
    elseif (isset($_POST['No'])) echo 'No';
    else echo '==== No action selected ====';
}