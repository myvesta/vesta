<?php

// Main include
$required_param['dataset']['domain'] = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/authentication_check.php");
include($_SERVER['DOCUMENT_ROOT']."/inc/form-elements.php");

//echo '<br /><br /><pre>'; print_r($_POST); echo '</pre>';

if (!empty($_POST['install_wordpress'])) {
    include($_SERVER['DOCUMENT_ROOT']."/ajax/web/manage/wordpress/install.php");
    exit;
}

echo 'No action selected';
exit;
