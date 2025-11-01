<?php

// Main include
$required_param['dataset']['domain'] = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/authentication_check.php");

echo 'Ajax script: web / manage, step2, Domain: '.$domain;

echo '<br /><br /><pre>';
print_r($_POST);
echo '</pre>';
