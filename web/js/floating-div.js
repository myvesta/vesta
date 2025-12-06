var FloatingDivLoaded = true;
var FloatingDivOpened = false;
var FloatingEvent = null;

function showFloatingDiv(title, contentHtml) {
    FloatingDivOpened = true;
    //$('#floating-center-div').css('display','block');
    $('#floating-center-div').fadeIn();
    $('#floating-center-div-title').html(title);
    $('#floating-center-div-content').html(contentHtml);
}

function hideFloatingDiv() {
    FloatingDivOpened = false;
    //$('#floating-center-div').css('display','none');
    $('#floating-center-div').fadeOut();
    clearSpawnedAjaxProcessInterval();
}

document.addEventListener('DOMContentLoaded', function () {
    $(document).on('keydown', function(e) {
        var dialogsOpened = false;
        if (typeof ConfirmDivLoaded !== 'undefined' && ConfirmDivLoaded) {
            if (ConfirmDivOpened) dialogsOpened = true;
        }

        if (e.key === "Escape" && FloatingDivOpened && !dialogsOpened) hideFloatingDiv();
    });

    $('#floating-center-div-right-close').on('click', function() {
        hideFloatingDiv();
    });

    $("#floating-center-div").on("submit", "#floating-center-div-form", function(e) {
        FloatingEvent = e;
        e.preventDefault();

        if (typeof ConfirmDivLoaded !== 'undefined' && ConfirmDivLoaded) {
            var result = check_if_confirm_dialog_is_required();
            if (result) return;
        }

        send_ajax_request();
    });
});
  
function more_button_click(id) {
    if (typeof id != 'object') {
        var url=dataset_values[id].url;
        var title = dataset_values[id].title;
    } else {
        var url = id.url;
        var title = id.title;
    }

    $('#floating-center-div-title').html('Loading... Please wait...');
    $('#floating-center-div').css('background','#eee');
    showFloatingDiv('Loading... Please wait...', '');
    $('#floating-center-div-content').css('opacity','0.3');

    $.ajax({
        url: url,
        type: 'POST',
        data: { dataset: dataset_values[id], token: GLOBAL.TOKEN },
        success: function(response) {
            $('#floating-center-div').css('background','#fff');
            showFloatingDiv(title, response);
            $('#floating-center-div-content').css('opacity','1');
        },
        error: function(xhr, status, error) {
            $('#floating-center-div').css('background','#fff');
            showFloatingDiv('Fatal error '+status, error);
            $('#floating-center-div-content').css('opacity','1');
        }
    });
}

function send_ajax_request() {
    var title = $('#floating-center-div-title').html();
    var url = $('#floating-center-div-form').attr('action');

    $('#floating-center-div-title').html('Loading... Please wait...');
    $('#floating-center-div').css('background','#eee');
    $('#floating-center-div-content').css('opacity','0.3');

    var formData = {};
    $("#floating-center-div-form").serializeArray().forEach(function(item) {
        formData[item.name] = item.value;
    });

    e = FloatingEvent;
    const submitter =
    e.originalEvent && e.originalEvent.submitter
        ? e.originalEvent.submitter
        : null; // fallback for older browsers

    const btnName  = submitter ? submitter.name  : null;
    const btnValue = submitter ? submitter.value : null;

    if (btnName) formData[btnName] = btnValue;

    $.ajax({
        url: url,
        type: 'POST',
        data: formData,
        success: function(response) {
            $('#floating-center-div').css('background','#fff');
            showFloatingDiv(title, response);
            $('#floating-center-div-content').css('opacity','1');
        },
        error: function(xhr, status, error) {
            $('#floating-center-div').css('background','#fff');
            showFloatingDiv('Fatal error '+status, error);
            $('#floating-center-div-content').css('opacity','1');
        }
    });
}


var myvesta_interval_id = null;
function startWatchingSpawnedAjaxProcess(user, hash) {
    console.log('= starting ajax interval'); //: user: '+user+', hash: '+hash);
    myvesta_interval_id = setInterval(function() {
        run_ajax_call_for_spawned_ajax_process(user, hash);
    }, 1000); 
    return myvesta_interval_id;
}

var myvesta_ajax_original_output = '';
var myvesta_ajax_exit_code = '';
var myvesta_ajax_code = '';

function clearSpawnedAjaxProcessInterval(code, exit_code, output) {
    if (myvesta_interval_id != null) {
        if (typeof code == 'undefined') code = 8;
        if (typeof exit_code == 'undefined') exit_code = '';
        if (typeof output == 'undefined') output = '';
        //console.log('= clearing ajax interval: code: '+myvesta_ajax_code+', exit_code: '+myvesta_ajax_exit_code+', output: '+myvesta_ajax_original_output);
        clearInterval(myvesta_interval_id);
        myvesta_interval_id = null;
        $('#copy-to-clipboard').show();
        $('#close-floating-div-button').show();
        $('#place-holder-floating-div-button').hide();

        var text = output; // $('#confirm-div-content-textarea-variable').val();
        var startTag = "=========================COPY FROM HERE=========================";
        var endTag   = "=========================COPY -TO- HERE=========================";

        var startPos = text.indexOf(startTag);
        var endPos   = text.indexOf(endTag);

        if (startPos !== -1 && endPos !== -1 && endPos > startPos) {
            var cleaned = text.substring(startPos + startTag.length, endPos).trim();
            $('#confirm-div-content-textarea-variable').val(cleaned);
        }

        console.log('= cleared ajax interval');
    }
}

function is_ajax_process_running() {
    if (myvesta_interval_id != null) return true;
    return false;
}

function run_ajax_call_for_spawned_ajax_process(user, hash) {
    $.ajax({
        url: '/ajax/watch-spawned-ajax-process.php',
        type: 'POST',
        data: { user: user, hash: hash, token: GLOBAL.TOKEN },
        success: function(response) {
            //console.log('= response: ', response);
            response = JSON.parse(response);
            if (typeof response == 'object') {
                //console.log('= response.code: ', response.code);
                if (typeof response.output != 'undefined') myvesta_ajax_original_output = response.output;
                if (typeof response.exit_code != 'undefined') myvesta_ajax_exit_code = response.exit_code;
                if (typeof response.code != 'undefined') myvesta_ajax_code = response.code;
                $('#confirm-div-content-textarea-variable').val(myvesta_ajax_original_output);
                if (response.code > 0) clearSpawnedAjaxProcessInterval(response.code, response.exit_code, response.output);
            } else {
                $('#confirm-div-content-textarea-variable').val(response);
                clearSpawnedAjaxProcessInterval(6, '', response);
            }
        },
        error: function(xhr, status, error) {
            $('#confirm-div-content-textarea-variable').val(error);
            clearSpawnedAjaxProcessInterval(7, '', error);
        }
    });
}
