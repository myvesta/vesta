<?php

// Authentication checks
$authentication_check_this_is_nested_script = false;
$authentication_check_required_param['dataset']['domain'] = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/include_authentication_check.php");

// Form elements include
include($_SERVER['DOCUMENT_ROOT']."/inc/form-elements.php");

if (!empty($_POST['install_wordpress'])) {
    // Nested sub-script for WordPress installation
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/manage/wordpress/install.php");
    exit;
}

echo 'No action selected';
exit;
