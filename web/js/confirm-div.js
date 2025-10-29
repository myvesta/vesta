var ConfirmDivLoaded = true;
var ConfirmDivOpened = false;
var ConfirmDivAction = '';
var ConfirmDivFocused = 'no';
var ConfirmDivType = 'confirm';

let ConfirmDivCallback = "";
let ConfirmDivCallbacks = {
    default: function(event) {
      console.log("=== Confirm Div Default Callback, OK button clicked ===");
    },
    yes: function(event) {
      console.log("=== Confirm Div Yes Callback, Yes button clicked ===");
    },
    no: function(event) {
      console.log("=== Confirm Div No Callback, No button clicked ===");
    },
    notify: function(event) {
      console.log("=== Confirm Div Notify Callback, OK button clicked ===");
    }
};

ConfirmDivCallbacks.TESTFUNCTION = function(event, variableValue) {
  //alert("=== TESTFUNCTION Callback, "+event+" button clicked, variableValue: "+variableValue+" ===");
  console.log("=== TESTFUNCTION Callback, "+event+" button clicked, variableValue: "+variableValue+" ===");
};

function showConfirmDiv(title, contentHtml, type = 'confirm', variableLabel = '', variableName = '', variableValue = '', selectedValue = '', selectedButton = '', callback = '', buttonLabels = '') {
    ConfirmDivType = type;
    if (type == 'confirm' && selectedButton == '') selectedButton = 'no';
    if (type == 'notify' && buttonLabels != '') $('#confirm-div-button-notify').html(buttonLabels);
    if ((type == 'input' || type == 'confirm' || type == 'textarea' || type == 'checkbox') && buttonLabels != '') {
        if (buttonLabels.includes('/')) {
            buttonLabels = buttonLabels.split('/');
            $('#confirm-div-button-yes').html(buttonLabels[0]);
            $('#confirm-div-button-no').html(buttonLabels[1]);
        } else {
            $('#confirm-div-button-yes').html(buttonLabels);
        }
    }
    ConfirmDivCallback = callback;

    ConfirmDivOpened = true;
    $('#confirm-div-buttons-confirm').css('display','none');
    $('#confirm-div-buttons-notify').css('display','none');
    $('#confirm-div-content-input').css('display','none');
    $('#confirm-div-content-textarea').css('display','none');
    $('#confirm-div-content-listbox').css('display','none');
    $('#confirm-div-content-checkbox').css('display','none');

    $('#confirm-div-title').html(title);
    $('#confirm-div-content').html(contentHtml);
    $('#confirm-div').fadeIn();


    if (type == 'confirm' || type == 'input' || type == 'textarea' || type == 'listbox' || type == 'checkbox') {
        $('#confirm-div-buttons-confirm').css('display','flex');
        if (type == 'confirm') {
            if (selectedButton == 'no') {
                ConfirmDivFocused = 'no';
                $('#confirm-div-button-no').focus();
            } else {
                ConfirmDivFocused = 'yes';
                $('#confirm-div-button-yes').focus();
            }
        }
    }
    if (type == 'notify') {
        $('#confirm-div-buttons-notify').css('display','flex');
        $('#confirm-div-button-notify').focus();
    }
    if (type == 'input') {
        $('#confirm-div-content-input').css('display','block');
        $('#confirm-div-content-input-label').html(variableLabel);
        $('#confirm-div-content-input-variable').attr('name', variableName);
        $('#confirm-div-content-input-variable').val(variableValue);
        $('#confirm-div-content-input-variable').attr('placeholder', variableValue);
        $('#confirm-div-content-input-variable').focus();
    }
    if (type == 'textarea') {
        $('#confirm-div-content-textarea').css('display','block');
        $('#confirm-div-content-textarea-label').html(variableLabel);
        $('#confirm-div-content-textarea-variable').attr('name', variableName);
        $('#confirm-div-content-textarea-variable').val(variableValue);
        $('#confirm-div-content-textarea-variable').attr('placeholder', variableValue);
        $('#confirm-div-content-textarea-variable').focus();
    }
    if (type == 'listbox') {
        $('#confirm-div-content-listbox').css('display','block');
        $('#confirm-div-content-listbox-label').html(variableLabel);
        $('#confirm-div-content-listbox-variable').attr('name', variableName);
        $('#confirm-div-content-listbox-variable').focus();
        if (Array.isArray(variableValue)) {
            for (let i = 0; i < variableValue.length; i++) {
                $('#confirm-div-content-listbox-variable').append('<option value="'+variableValue[i].key+'">'+variableValue[i].value+'</option>');
            }
        }
        $('#confirm-div-content-listbox-variable').val(selectedValue);
    }
    if (type == 'checkbox') {
        $('#confirm-div-content-checkbox').css('display','block');
        $('#confirm-div-content-checkbox-variable').attr('name', variableName);
        currentCheckboxLabel = $('#confirm-div-content-checkbox-label').html();
        currentCheckboxLabel = currentCheckboxLabel.replace(' Variable 1', ' '+variableLabel);
        $('#confirm-div-content-checkbox-label').html(currentCheckboxLabel);
        $('#confirm-div-content-checkbox-variable').focus();
        if (variableValue === '1' || variableValue === 1 || variableValue === true || variableValue === 'true' || variableValue === 'TRUE' || variableValue === 'checked' || variableValue === 'CHECKED' || variableValue === 'YES' || variableValue === 'yes') {
            $('#confirm-div-content-checkbox-variable').prop('checked', true);
        } else {
            $('#confirm-div-content-checkbox-variable').prop('checked', false);
        }
    }
}

function hideConfirmDiv(event) {
    ConfirmDivOpened = false;
    if (typeof FloatingDivLoaded !== 'undefined' && FloatingDivLoaded) $('#floating-center-div').css('background','#fff');
    $('#confirm-div').fadeOut();
}

document.addEventListener('DOMContentLoaded', function () {
    //showConfirmDiv('Confirm', 'Are you sure you want to continue?', 'confirm', '', '', '', '', 'yes', 'TESTFUNCTION');
    //showConfirmDiv('Notification!!!', 'You have a new notification!!!', 'notify', '', '', '', '', '', 'TESTFUNCTION', 'OK !!!');
    //showConfirmDiv('Notification!!!', 'You have a new notification!!!', 'input', 'Enter name', 'name', 'Some name', '', '', 'TESTFUNCTION', 'OK/Cancel');
    //showConfirmDiv('Notification!!!', 'You have a new notification!!!', 'textarea', 'Enter name', 'name', 'Some name', '', '', 'TESTFUNCTION', 'OK/Cancel');
    //showConfirmDiv('Notification', 'You have a new notification', 'checkbox', 'On/Off', 'onoff', '1', '', '', 'TESTFUNCTION', 'OK/Cancel');
    /*
    let options = [
        { key: "1", value: "Option 1" },
        { key: "2", value: "Option 2" },
        { key: "3", value: "Option 3" }
      ];
    showConfirmDiv('Notification!!!', 'You have a new notification!!!', 'listbox', 'Select an option', 'option', options, '3', 'OK !!!', 'TESTFUNCTION', 'OK/Cancel');
    */
    $(document).on('keydown', function(e) {
        if (ConfirmDivOpened) {
            if (ConfirmDivType == 'input') {
                if (e.key === "Enter") {
                    $("#confirm-div-button-yes").click();
                    e.preventDefault();
                    return;
                }
            }
            if (e.key === "Escape") {
                hideConfirmDiv('escape');
                if ( ConfirmDivCallback != '') {
                    ConfirmDivCallbacks[ConfirmDivCallback]('escape');
                }
                e.preventDefault();
                return;
            }
            if (e.key === "ArrowLeft") {
                $("#confirm-div-button-yes").focus();
                ConfirmDivFocused = 'yes';
                console.log("Focus Yes");
                e.preventDefault();
                return;
            }
            if (e.key === "ArrowRight") {
                $("#confirm-div-button-no").focus();
                ConfirmDivFocused = 'no';
                console.log("Focus No");
                e.preventDefault();
                return;
            }
            if (e.key === "Tab") {
                if (ConfirmDivFocused == 'yes') {
                    $("#confirm-div-button-no").focus();
                    ConfirmDivFocused = 'no';
                    console.log("Focus No");
                } else {
                    $("#confirm-div-button-yes").focus();
                    ConfirmDivFocused = 'yes';
                    console.log("Focus Yes");
                }
                e.preventDefault();
                return;
            }
        }
    });

    $('#confirm-div-button-yes').on('click', function() {
        if (typeof FloatingDivLoaded !== 'undefined' && FloatingDivLoaded) $('#floating-center-div').css('background','#fff');
        hideConfirmDiv();
        if ( ConfirmDivCallback != '') {
            var variableValue = '';
            if (ConfirmDivType == 'input') variableValue = $('#confirm-div-content-input-variable').val();
            if (ConfirmDivType == 'textarea') variableValue = $('#confirm-div-content-textarea-variable').val();
            if (ConfirmDivType == 'listbox') variableValue = $('#confirm-div-content-listbox-variable').val();
            if (ConfirmDivType == 'checkbox') if ($('#confirm-div-content-checkbox-variable').prop('checked')) variableValue = '1'; else variableValue = '0';
            ConfirmDivCallbacks[ConfirmDivCallback]('yes', variableValue);
        }
        if (ConfirmDivAction == 'send_ajax_request') {send_ajax_request();}
    });
    $('#confirm-div-button-no').on('click', function() {
        if (FloatingDivLoaded) $('#floating-center-div').css('background','#fff');
        hideConfirmDiv();
        if ( ConfirmDivCallback != '') {
            var variableValue = '';
            if (ConfirmDivType == 'input') variableValue = $('#confirm-div-content-input-variable').val();
            if (ConfirmDivType == 'textarea') variableValue = $('#confirm-div-content-textarea-variable').val();
            if (ConfirmDivType == 'listbox') variableValue = $('#confirm-div-content-listbox-variable').val();
            if (ConfirmDivType == 'checkbox') if ($('#confirm-div-content-checkbox-variable').prop('checked')) variableValue = '1'; else variableValue = '0';
            ConfirmDivCallbacks[ConfirmDivCallback]('no', variableValue);
        }
    });
    $('#confirm-div-button-notify').on('click', function() {
        if (typeof FloatingDivLoaded !== 'undefined' && FloatingDivLoaded) $('#floating-center-div').css('background','#fff');
        hideConfirmDiv('ok');
        if ( ConfirmDivCallback != '') {
            ConfirmDivCallbacks[ConfirmDivCallback]('ok');
        }
    });
});

function check_if_confirm_dialog_is_required() {
    if ($('#confirm_required').length > 0) {
        if ($('#confirm_required').val() == "1") {
            ConfirmDivAction = 'send_ajax_request';
            if (typeof FloatingDivLoaded !== 'undefined' && FloatingDivLoaded) $('#floating-center-div').css('background','#eee');
            var selectedValue = 'no';
            var type = 'confirm';
            if ($('#confirm_required_default_value').length > 0) {
                selectedValue = $('#confirm_required_default_value').val();
            }
            if ($('#confirm_required_type').length > 0) {
                type = $('#confirm_required_type').val();
            }
            var title = 'Confirm';
            if (type == 'notification') {
                title = 'Notification';
            }
            if ($('#confirm_required_title').length > 0) {
                title = $('#confirm_required_title').val();
            }
            var content = 'Are you sure you want to continue?';
            if ($('#confirm_required_content').length > 0) {
                content = $('#confirm_required_content').val();
            }
            var variableLabel = '';
            if ($('#confirm_required_variable_label').length > 0) {
                variableLabel = $('#confirm_required_variable_label').val();
            }
            var variableName = '';
            if ($('#confirm_required_variable_name').length > 0) {
                variableName = $('#confirm_required_variable_name').val();
            }
            var variableValue = '';
            if ($('#confirm_required_variable_value').length > 0) {
                variableValue = $('#confirm_required_variable_value').val();
            }
            var selectedValue = '';
            if ($('#confirm_required_selected_value').length > 0) {
                selectedValue = $('#confirm_required_selected_value').val();
            }
            var selectedButton = '';
            if ($('#confirm_required_selected_button').length > 0) {
                selectedButton = $('#confirm_required_selected_button').val();
            }
            var callback = '';
            if ($('#confirm_required_callback').length > 0) {
                callback = $('#confirm_required_callback').val();
            }
            showConfirmDiv(title, content, type, variableLabel, variableName, variableValue, selectedValue, selectedButton, callback);
            return true;
        }
    }
    return false;
}