<?php

// Main include
$required_dataset_param = 'domain';
include($_SERVER['DOCUMENT_ROOT']."/ajax/authentication_check.php");
include($_SERVER['DOCUMENT_ROOT']."/inc/form-elements.php");

echo 'Ajax script: web / manage, step1, Domain: '.$domain;

echo '<br /><br />';
echo myvesta_open_form('/ajax/web/manage/step2.php');

echo myvesta_get_hidden_fields();
//echo myvesta_get_confirtmation_hidden_fields();
echo myvesta_get_element('button', '', 'button1', 'Hello World', null, 'width: 200px;', 'add');
echo myvesta_get_element('input', 'Variable 1:', 'var1', 'val1');
echo myvesta_get_element('textarea', 'Variable 2:', 'var2', 'val2'); 
echo myvesta_get_element('listbox', 'Variable 3:', 'var3', array('1' => 'Option 1', '2' => 'Option 2', '3' => 'Option 3'), '2');
echo myvesta_get_element('button', '', 'submit', 'Submit');
echo myvesta_close_form();