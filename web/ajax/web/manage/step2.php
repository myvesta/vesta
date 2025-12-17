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

if (!empty($_POST['lock_wordpress'])) {
    // Nested sub-script for WordPress locking
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/manage/wordpress/lock.php");
    exit;
}

if (!empty($_POST['unlock_wordpress'])) {
    // Nested sub-script for WordPress unlocking
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/manage/wordpress/unlock.php");
    exit;
}

if (!empty($_POST['clone_wordpress_step1'])) {
    // Nested sub-script for WordPress cloning
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/manage/wordpress/clone-step1.php");
    exit;
}

if (!empty($_POST['clone_wordpress_step2'])) {
    // Nested sub-script for WordPress cloning
    include ($_SERVER['DOCUMENT_ROOT']."/ajax/web/manage/wordpress/clone-step2.php");
    exit;
}

echo 'No action selected';
exit;
