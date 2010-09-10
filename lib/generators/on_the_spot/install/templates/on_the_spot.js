$(document).ready(function() {

    $(".on_the_spot_editing").mouseover(function() {
        $(this).css('background-color', '#EEF2A0');
    });
    $(".on_the_spot_editing").mouseout(function() {
        $(this).css('background-color', 'inherit');
    });
/*    $('.on_the_spot_editing').editable(this.attr('data-url'), {
        tooltip: 'Click to edit...',
        cancel : 'Cancel',
        submit : 'OK'
    });*/
    $('.on_the_spot_editing').each(function(n){
        var el           = $(this),
            data_url     = el.attr('data-url'),
            ok_text      = el.attr('data-ok') || 'OK',
            cancel_text  = el.attr('data-cancel') || 'Cancel',
            tooltip_text = el.attr('data-tooltip') || 'Click to edit ...',
            edit_type    = el.attr('data-edittype');

        var options = {
            tooltip: tooltip_text,
            cancel: cancel_text,
            submit: ok_text
        };
        if (edit_type != null) {
            options.type = edit_type;
        }

        el.editable(data_url, options)
    })

});