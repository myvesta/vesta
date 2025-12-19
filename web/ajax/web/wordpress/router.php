<?php

// Authentication checks
$authentication_check_this_is_nested_script = false;
$authentication_check_required_param['dataset']['domain'] = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/include_authentication_check.php");

// Form elements include
include($_SERVER['DOCUMENT_ROOT']."/inc/form-elements.php");

if (!empty($_POST['wordpress_install'])) {
    // Nested sub-script for WordPress installation
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/wordpress/actions/install.php");
    exit;
}

if (!empty($_POST['wordpress_lock'])) {
    // Nested sub-script for WordPress locking
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/wordpress/actions/lock.php");
    exit;
}

if (!empty($_POST['wordpress_unlock'])) {
    // Nested sub-script for WordPress unlocking
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/wordpress/actions/unlock.php");
    exit;
}

if (!empty($_POST['wordpress_clone_step1'])) {
    // Nested sub-script for WordPress cloning
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/wordpress/actions/clone_step1.php");
    exit;
}

if (!empty($_POST['wordpress_clone_step2'])) {
    // Nested sub-script for WordPress cloning
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/wordpress/actions/clone_step2.php");
    exit;
}

if (!empty($_POST['wordpress_add_admin_user'])) {
    // Nested sub-script for WordPress adding admin user
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/wordpress/actions/add_admin_user.php");
    exit;
}

echo 'No action selected';
exit;
