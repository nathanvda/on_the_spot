$(document).ready(function() {

    $(".on_the_spot_editing").mouseover(function() {
        $(this).css('background-color', '#EEF2A0');
    });
    $(".on_the_spot_editing").mouseout(function() {
        $(this).css('background-color', 'inherit');
    });
    $('.on_the_spot_editing').editable('http://localhost:3000/couriers/update_attribute', {
        tooltip: 'Click to edit...',
        cancel : 'Cancel',
        submit : 'OK'
    });
/*    
    $(".in_place_editing_ta").mouseover(function() {
        $(this).css('background-color', '#EEF2A0');
    });
    $(".in_place_editing_ta").mouseout(function() {
        $(this).css('background-color', 'inherit');
    });
    $('.in_place_editing_ta').editable('http://localhost:3000/couriers/update_attribute', {
        type   : 'textarea',
        tooltip: 'Click to edit...',
        cancel : 'Cancel',
        submit : 'OK'
    });
 */
});