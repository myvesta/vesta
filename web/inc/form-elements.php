<?php

include("/usr/local/vesta/func/string.php");

$myvesta_element_buffer = file_get_contents("/usr/local/vesta/web/templates/header.html");
$start_from = strpos($element_buffer, '<div id="confirm-div"');
$myvesta_element_buffer = substr($myvesta_element_buffer, $start_from);
//echo $myvesta_element_buffer;

function myvesta_get_element($element_name, $label=null, $variable_name=null, $variable_value=null, $selected_value=null, $style='', $replace_or_add_style='replace') {
    global $myvesta_element_buffer;
    if ($element_name == 'input') $id = 'confirm-div-content-input';
    else if ($element_name == 'textarea') $id = 'confirm-div-content-textarea';
    else if ($element_name == 'listbox') $id = 'confirm-div-content-listbox';
    else if ($element_name == 'button') $id = 'confirm-div-button';
    else return '';

    $myvesta_element = myvesta_str_get_between($myvesta_element_buffer, '<div id="'.$id.'"', '</div>', 0, 1, 1);

    $myvesta_element = str_replace('display: none; ', '', $myvesta_element);
    $myvesta_element = str_replace(' display: none;', '', $myvesta_element);
    $myvesta_element = str_replace('display: none;', '', $myvesta_element);

    $myvesta_element = str_replace("id=\"".$id."\"", "id=\"".$id."-".$variable_name."\"", $myvesta_element);

    $myvesta_element = str_replace('Variable 1:', $label, $myvesta_element);
    if ($variable_name != null) {
        if ($element_name == 'input') $myvesta_element = str_replace('confirm-div-content-input-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'textarea') $myvesta_element = str_replace('confirm-div-content-textarea-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'listbox') $myvesta_element = str_replace('confirm-div-content-listbox-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'button') $myvesta_element = str_replace('confirm-div-button-variable', $variable_name, $myvesta_element);
    }
    if ($variable_value != null) {
        if ($element_name == 'input') $myvesta_element = str_replace('value1', $variable_value, $myvesta_element);
        else if ($element_name == 'button') $myvesta_element = str_replace('OK', $variable_value, $myvesta_element);
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

    if ($style != '') {
        if ($replace_or_add_style == 'replace') $myvesta_element = myvesta_str_replace_once_between_including_borders($myvesta_element, 'data-element-style-begin="1" style="', 'data-element-style-end="1"', 'style="'.$style.'"');
        else if ($replace_or_add_style == 'add') $myvesta_element = str_replace('data-element-style-begin="1" style="', 'data-element-style-begin="1" style="'.$style.' ', $myvesta_element);
    }
    $myvesta_element = str_replace('data-element-style-begin="1"', '', $myvesta_element);
    $myvesta_element = str_replace('data-element-style-end="1"', '', $myvesta_element);

    return $myvesta_element;
}

function myvesta_get_confirtmation_hidden_fields($type = 'confirm', $title = 'Confirm', $content = 'Are you sure you want to continue?', $selected_button = 'yes', $callback = 'TESTFUNCTION') {
    $myvesta_element = '<input type="hidden" name="confirm_required" value="1" id="confirm_required" />
    <input type="hidden" name="confirm_required_type" value="'.$type.'" id="confirm_required_type" />
    <input type="hidden" name="confirm_required_title" value="'.$title.'" id="confirm_required_title" />
    <input type="hidden" name="confirm_required_content" value="'.$content.'" id="confirm_required_content" />
    <input type="hidden" name="confirm_required_selected_button" value="'.$selected_button.'" id="confirm_required_selected_button" />
    <input type="hidden" name="confirm_required_callback" value="'.$callback.'" id="confirm_required_callback" />';
    return $myvesta_element;
}

function myvesta_open_form($action = '') {
    global $_SESSION;
    if ($action == '') $action = $_SERVER['REQUEST_URI'];
    $myvesta_element = '<form id="floating-center-div-form" name="floating-center-div-form" method="post" action="'.$action.'"><input type="hidden" name="token" value="'.$_SESSION['token'].'" />';
    return $myvesta_element;
}

function myvesta_close_form() {
    $myvesta_element = '</form>';
    return $myvesta_element;
}

function myvesta_get_hidden_fields() {
    $myvesta_element = '';
    if (isset($_POST['dataset'])) {
        foreach ($_POST['dataset'] as $key => $value) { 
            $myvesta_element .= '<input type="hidden" name="dataset['.$key.']" value="'.$value.'" />';
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
echo myvesta_get_element('button', 'Button 1:', 'button1', 'OK');
echo "\n\n";
echo myvesta_get_confirtmation_hidden_fields();
*/