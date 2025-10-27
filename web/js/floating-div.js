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
        var object = dataset_values[id].object;
        var action = dataset_values[id].action;
        var step = dataset_values[id].step;
        var script='step'+step+'.php';
        var title = dataset_values[id].title;
        var subaction = dataset_values[id].subaction;
    } else {
        var object = id.object;
        var action = id.action;
        var step = id.step;
        var script='step'+step+'.php';
        var title = id.title;
        var subaction = id.subaction;
    }
    if (subaction) {
        var url = '/ajax/'+object+'/'+action+'/'+subaction+'/'+script;
    } else {
        var url = '/ajax/'+object+'/'+action+'/'+script;
    }

    $('#floating-center-div-title').html('Loading... Please wait...');
    $('#floating-center-div').css('background','#eee');
    showFloatingDiv('Loading... Please wait...', '');

    $.ajax({
        url: url,
        type: 'POST',
        data: { dataset: dataset_values[id], token: GLOBAL.TOKEN },
        success: function(response) {
            $('#floating-center-div').css('background','#fff');
            showFloatingDiv(title, response);
        },
        error: function(xhr, status, error) {
            $('#floating-center-div').css('background','#fff');
            showFloatingDiv('Fatal error '+status, error);
        }
    });
}

function send_ajax_request() {
    var title = $('#floating-center-div-title').html();
    var url = $('#floating-center-div-form').attr('action');

    $('#floating-center-div-title').html('Loading... Please wait...');
    $('#floating-center-div').css('background','#eee');

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
        },
        error: function(xhr, status, error) {
            $('#floating-center-div').css('background','#fff');
            showFloatingDiv('Fatal error '+status, error);
        }
    });
}
