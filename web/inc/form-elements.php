<?php

include("/usr/local/vesta/func/string.php");

$myvesta_element_buffer = file_get_contents("/usr/local/vesta/web/templates/header.html");
$start_from = strpos($myvesta_element_buffer, '<div id="confirm-div"');
$myvesta_element_buffer = substr($myvesta_element_buffer, $start_from);
//echo $myvesta_element_buffer;

function myvesta_get_element($element_name, $label=null, $variable_name=null, $variable_value=null, $selected_value=null, $style='', $replace_or_add_style='replace') {
    global $myvesta_element_buffer;

    $variable_name_yes = 'yes';
    $variable_name_no = 'no';
    $variable_value_yes = 'Yes';
    $variable_value_no = 'No';

    if ($element_name == 'input') $id = 'confirm-div-content-input';
    else if ($element_name == 'textarea') $id = 'confirm-div-content-textarea';
    else if ($element_name == 'listbox') $id = 'confirm-div-content-listbox';
    else if ($element_name == 'button') $id = 'confirm-div-button';
    else if ($element_name == 'buttons_confirm') {
        $id = 'confirm-div-buttons-confirm';
        if (strpos($variable_name, '/') !== false) {
            $variable_names = explode('/', $variable_name);
            $variable_name_yes = $variable_names[0];
            $variable_name_no = $variable_names[1];
        }
        if (strpos($variable_value, '/') !== false) {
            $variable_values = explode('/', $variable_value);
            $variable_value_yes = $variable_values[0];
            $variable_value_no = $variable_values[1];
        }
    }
    else if ($element_name == 'checkbox') $id = 'confirm-div-content-checkbox';
    else return '';

    $myvesta_element = myvesta_str_get_between($myvesta_element_buffer, '<div id="'.$id.'"', '</div>', 0, 1, 1);

    $myvesta_element = str_replace('display: none; ', '', $myvesta_element);
    $myvesta_element = str_replace(' display: none;', '', $myvesta_element);
    $myvesta_element = str_replace('display: none;', '', $myvesta_element);

    $myvesta_element = str_replace("id=\"".$id."\"", "id=\"".$id."-".$variable_name."\"", $myvesta_element);

    $myvesta_element = str_replace('Variable 1:', $label, $myvesta_element);
    $myvesta_element = str_replace('Variable 1', $label, $myvesta_element);
    
    if ($variable_name != null) {
        if ($element_name == 'input') $myvesta_element = str_replace('confirm-div-content-input-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'textarea') $myvesta_element = str_replace('confirm-div-content-textarea-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'listbox') $myvesta_element = str_replace('confirm-div-content-listbox-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'button') $myvesta_element = str_replace('confirm-div-button-variable', $variable_name, $myvesta_element);
        else if ($element_name == 'checkbox') $myvesta_element = str_replace('confirm-div-content-checkbox-variable', $variable_name, $myvesta_element);
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
        else if ($element_name == 'checkbox') {
            if ($variable_value === '1') $variable_value = 'yes';
            if ($variable_value === '0') $variable_value = 'no';
            if ($variable_value === 1) $variable_value = 'checked="yes"';
            if ($variable_value === 0) $variable_value = 'checked="no"';
            if ($variable_value === true) $variable_value = 'checked="yes"';
            if ($variable_value === false) $variable_value = 'checked="no"';
            if ($variable_value === 'yes') $variable_value = 'checked="yes"';
            if ($variable_value === 'no') $variable_value = 'checked="no"';
            if ($variable_value === 'checked') $variable_value = 'checked="yes"';
            if ($variable_value === 'unchecked') $variable_value = 'checked="no"';
            if ($variable_value === 'true') $variable_value = 'checked="yes"';
            if ($variable_value === 'false') $variable_value = 'checked="no"';
            if ($variable_value === 'TRUE') $variable_value = 'checked="yes"';
            if ($variable_value === 'FALSE') $variable_value = 'checked="no"';
            if ($variable_value === '') $variable_value = 'checked="no"';
            if ($variable_value === null) $variable_value = 'checked="no"';
            $myvesta_element = str_replace('checked="yes"', $variable_value, $myvesta_element);
        }
        else if ($element_name == 'buttons_confirm') {
            $myvesta_element = str_replace('Yes', $variable_value_yes, $myvesta_element);
            $myvesta_element = str_replace('No', $variable_value_no, $myvesta_element);
            $myvesta_element = str_replace('confirm-div-button-yes', $variable_name_yes, $myvesta_element);
            $myvesta_element = str_replace('confirm-div-button-no', $variable_name_no, $myvesta_element);
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

function myvesta_get_confirtmation_hidden_fields($type = 'confirm', $title = '', $content = '', $selected_button = 'no', $callback = 'TESTFUNCTION') {
    if ($title == '') $title = __('Confirm');
    if ($content == '') $content = __('Are you sure you want to continue?');

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

function myvesta_get_hidden_fields($hidden_fields = array()) {
    $myvesta_element = '';
    if (isset($_POST['dataset'])) {
        foreach ($_POST['dataset'] as $key => $value) { 
            if (isset($hidden_fields['dataset'][$key])) {
                $value = $hidden_fields['dataset'][$key];
            }
            $myvesta_element .= '<input type="hidden" name="dataset['.$key.']" value="'.$value.'" />';
        }
    }
    foreach ($hidden_fields as $key => $value) {
        if ($key == 'dataset') continue;
        $myvesta_element .= '<input type="hidden" name="'.$key.'" value="'.$value.'" />';
    }
    return $myvesta_element;
}

function myvesta_get_disabled_textarea($value = '', $style = '', $copy_to_clipboard = true, $watch_spawned_ajax_process = false, $user = '', $hash = '') {
    if ($style == '') $style = 'width: 680px; height: 380px; resize: none; font-family: monospace; font-size: 13px; white-space: pre;';
    $myvesta_element = '<textarea disabled id="confirm-div-content-textarea-variable" name="confirm-div-content-textarea-variable" class="vst-textinput ajax-newline" data-gramm="false" data-gramm_editor="false" data-enable-grammarly="false" style="'.$style.'">'.$value.'</textarea>';
    if ($copy_to_clipboard) {
        if ($watch_spawned_ajax_process) $display = 'display: none;';
        else $display = '';
        $myvesta_element .= '<button id="copy-to-clipboard" class="button confirm" style="margin-right: 10px; width: 200px; background-color: #27c24c !important; border-color: #27c24c !important; '.$display.'" autofocus>'.__('Copy to clipboard').'</button>';
        $myvesta_element .= '<button id="close-floating-div-button" class="button cancel" style="margin-right: 10px; width: 110px; '.$display.'">'.__('Close').'</button>';
        $myvesta_element .= '<p id="place-holder-floating-div-button" class="button cancel" style="margin-right: 10px; width: 110px;background-color: white; color: white;border: 0;text-shadow: 0 0 0 #fff !important;">&nbsp;</p>';
        $myvesta_element .= '<script>
                document.getElementById("copy-to-clipboard").addEventListener("click", function() {
                    var textarea = document.getElementById("confirm-div-content-textarea-variable");
                    navigator.clipboard.writeText(textarea.value);
                    this.innerHTML = "'.__('Copied to clipboard').'";
                    setTimeout(function() {
                        document.getElementById("copy-to-clipboard").innerHTML = "'.__('Copy to clipboard').'";
                    }, 1000);
                });
                document.getElementById("close-floating-div-button").addEventListener("click", function() {
                    hideFloatingDiv();
                });
        </script>';
    }
    if ($watch_spawned_ajax_process) {
        $myvesta_element .= '<script>
            startWatchingSpawnedAjaxProcess("'.$user.'", "'.$hash.'");
        </script>';
    }
    return $myvesta_element;
}

function myvesta_hide_floating_div() {
    echo '<script>hideFloatingDiv();</script>'; exit;
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
echo myvesta_get_element('checkbox', 'Checkbox 1', 'variable', '1');
echo "\n\n";
*/
