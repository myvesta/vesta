<?php

include("/usr/local/vesta/func/string.php");

$myvesta_element_buffer = file_get_contents("/usr/local/vesta/web/templates/header.html");
$start_from = strpos($element_buffer, '<div id="confirm-div"');
$myvesta_element_buffer = substr($myvesta_element_buffer, $start_from);
//echo $myvesta_element_buffer;

function myvesta_get_element($element_name, $label=null, $variable_name=null, $variable_value=null, $selected_value=null) {
    global $myvesta_element_buffer;
    if ($element_name == 'input') $id = 'confirm-div-content-input';
    else if ($element_name == 'textarea') $id = 'confirm-div-content-textarea';
    else if ($element_name == 'listbox') $id = 'confirm-div-content-listbox';
    else return '';

    $myvesta_element = myvesta_str_get_between($myvesta_element_buffer, '<div id="'.$id.'"', '</div>', 0, 1, 1);

    $myvesta_element = str_replace('display: none;', '', $myvesta_element);
    $myvesta_element = str_replace('display: none; ', '', $myvesta_element);
    $myvesta_element = str_replace(' display: none;', '', $myvesta_element);

    $myvesta_element = str_replace('Variable 1:', $label, $myvesta_element);
    if ($variable_name != null) {
        if ($element_name == 'input') $myvesta_element = str_replace('confirm-div-content-input-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'textarea') $myvesta_element = str_replace('confirm-div-content-textarea-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'listbox') $myvesta_element = str_replace('confirm-div-content-listbox-variable', $variable_name, $myvesta_element);
    }
    if ($variable_value != null) {
        if ($element_name == 'input') $myvesta_element = str_replace('value1', $variable_value, $myvesta_element);
        else if ($element_name == 'textarea') $myvesta_element = str_replace('</textarea>', $variable_value.'</textarea>', $myvesta_element);
        else if ($element_name == 'listbox') {
            $variable_value_options = '';
            foreach ($variable_value as $key => $value) {
                $variable_value_options .= '<option value="'.$key.'"';
                if ($selected_value == $key) $variable_value_options .= ' selected';
                $variable_value_options .= '>'.$value.'</option>';
            }
            $myvesta_element = str_replace('</select>', $variable_value_options.'</select>', $myvesta_element);
        }
    }

    return $myvesta_element;
}

/*
echo myvesta_get_element('input', 'Variable 1:', 'variable', 'variable value');
echo "\n\n";
echo myvesta_get_element('textarea', 'Variable 2:', 'variable', 'variable value');
echo "\n\n";
echo myvesta_get_element('listbox', 'Variable 3:', 'variable', array('1' => 'Option 1', '2' => 'Option 2', '3' => 'Option 3'), '2');
echo "\n\n";
*/