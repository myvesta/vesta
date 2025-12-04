<?php

// Authentication checks
$authentication_check_required_param['dataset']['domain'] = true;
include($_SERVER['DOCUMENT_ROOT']."/ajax/authentication_check.php");

// Form elements include
include($_SERVER['DOCUMENT_ROOT']."/inc/form-elements.php");

echo myvesta_open_form('/ajax/web/manage/step2.php');

echo myvesta_get_hidden_fields();
//echo myvesta_get_confirtmation_hidden_fields();
echo myvesta_get_element('button', '', 'install_wordpress', __('Install WordPress'), null, 'width: 200px;', 'add');
echo myvesta_close_form();

exit;