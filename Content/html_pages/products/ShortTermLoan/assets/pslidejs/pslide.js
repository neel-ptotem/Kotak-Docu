/**
 * Created by JetBrains RubyMine.
 * User: arijit
 * Date: 10/3/12
 * Time: 2:13 PM
 * To change this template use File | Settings | File Templates.
 */

function togglemode() {

    if ($('#edit_on').val() == "true") {
        $('#edit_on').val("false");
        $('#edit_on').prev('a').text("Activate Design Mode");
        $('#edit_on').prev('a').removeClass('btn-danger').addClass('btn-success');
        $('.design_buttons').hide();
        $('.non_design_buttons').show().css("display", "block");
        $('.no_pcontents').hide();
        $('.colored_div').css("border", "none");
    }
    else {
        $('#edit_on').val("true");
        $('#edit_on').prev('a').text("Activate View Mode");
        $('#edit_on').prev('a').removeClass('btn-success').addClass('btn-danger');
        $('.no_pcontents').show();
        $('.non_design_buttons').hide();
        $('.design_buttons').show().css("display", "block");
        $('.colored_div').css("border", "1px solid black");

    }
    $("#save_button").show();
}
