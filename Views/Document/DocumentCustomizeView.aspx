<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Documentor_05Mar.Models.Page>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="TitleContent" runat="server">
	Customize
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Customize</h2>

<div class="page-header" style="position:fixed; color:white;font-weight: bold;margin-top: -20px">
<a href="#" id="save_button"><img src="../../Content/images/save.png" width="40px" height="40px" alt="save"/></a>
  <br/>
  <br/>
  <% foreach (Documentor_05Mar.Models.Component component in (IEnumerable<Documentor_05Mar.Models.Component>)ViewData["components"]) { %>
        <div id="<%: component.id %>" title="<%: component.name %>" class="component_icon" style="margin-bottom: 5px;">
        <a href="#" class="span2 primary btn"><%:component.name %></a>
      </div>
  <% } %>
  <br/>
</div>

<div class="row" style="text-align: center; background: transparent">
  <div id="DocumentFrame" class="docuframe">
  </div>

  <% foreach (Documentor_05Mar.Models.BlankSection blank_section in (IEnumerable<Documentor_05Mar.Models.BlankSection>) ViewData["blank_sections"]) { %>
      <div id="<%: blank_section.id %>" class="selectiondiv"
           style="position:absolute;z-index:5000;top:<%: blank_section.ypos %>px;left:<%: blank_section.xpos %>px;width:<%: blank_section.width %>px;height:<%: blank_section.height %>px;">

        <div class='ui-widget-header' title="<%: blank_section.component_id %>" style='margin: 3px;visibility:hidden;'>
          <%: blank_section.Component.name %>
          <a href='#' onclick='javascript:$(this).parent().parent().remove();' class='pull-right' style='font-size: 12px;color:white;margin-right: 3px;'>x</a>
        </div>
      </div>

  <% } %>
  <input type="hidden" id="component_field" name="component_id" value="" />
  

</div>



</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ScriptHolder" runat="server">
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.js"></script>
<link href="../../Content/jquery-ui-1.8.17.custom.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/jquery-ui-1.8.16.custom.min.js" language="javascript"></script>
    <script type="text/javascript" src="../../Scripts/json2.js" language="javascript"></script>
    <script type="text/javascript" src="../../Scripts/svgvml.js" language="javascript"></script>
    <script type="text/javascript" src="../../Content/bootstrap/js/bootstrap.js" language="javascript"></script>
    <link href="../../Content/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(document).ready(function () {


            var component_name = "";
            $('#component_field').attr("value", "empty");

            // Select a Component
            $('.component_icon').click(function () {
                $('.component_icon').removeClass('selected_icon');
                $('.component_icon a').removeClass('error').addClass('primary');
                $(this).addClass('selected_icon');
                $(this).children('a').removeClass('primary').addClass('error');
                $('#component_field').attr("value", $(this).attr('id'));
                component_name = $(this).attr("title");

            });
            
            $('.selectiondiv').draggable();
            $('.selectiondiv').resizable();
            var selection_no = 0;
            $("#DocumentFrame").click(function (e) {
                //                if (e.target.hasClass('xbutton')) {
                //                    $(".xbutton").trigger('click');
                //                }
                //                alert($('#component_field').attr("value"));
                //
                if ($('#component_field').attr("value") != "empty") {
                    var LEFT = e.pageX
                    var TOP = e.pageY
                    var this_selection = "#selection" + selection_no;
                    $('#DocumentFrame').after('<div id="selection' + selection_no + '" class="selectiondiv ui-widget-content">  </div>');
                    $(this_selection).append(" <div class='ui-widget-header' title='" + $('#component_field').attr("value") + "' style='margin: 3px;'>" + component_name + "<a href='#' onclick='javascript:$(this).parent().parent().remove();' class='pull-right' style='font-size: 12px;color:white;margin-right: 3px;'>x</a>" + "</div> ");
                    // Use CSS to place your selection div
                    $("#selection" + selection_no).css({
                        position: 'absolute',
                        zIndex: 5000,
                        left: LEFT,
                        top: TOP,
                        width: 100,
                        height: 40
                    });

                    $(this_selection).show();
                    $(this_selection).draggable();
                    $(this_selection).resizable();
                    selection_no += 1;
                } else {
                    alert("Please pick a component type first!");
                }                
            });

            $('#save_button').click(function () {
                var par = { 'blank_sections': [] };
                var count = $('.selectiondiv').length;
                $('.selectiondiv').each(function () {
                par.blank_sections.push({
                        page_id: <%: ViewData["page_id"]%>,
                        component_id: parseInt($(this).find('div.ui-widget-header').attr("title")),
                        width: $(this).width(),
                        height: $(this).height(),
                        xpos: $(this).position().left,
                        ypos: $(this).position().top
                    })
                });
                $.ajax({
                    url: '/Document/StructureForm/',
                    type: "post",
                    data: JSON.stringify(par.blank_sections),
                    success: function (data) {

                    }
                });
            });

        });


    </script>
    <style type="text/css">
        .content {
            background: transparent;
        }

        .page-header {
            background: transparent;
            position: fixed;
            left: 25px;
            border: none;
        }

        .docuframe {
            width: 800px;
            height: 1080px;
            margin: 0px auto;
            padding: 0px;
            background-image: url("../../Content/images/documents/<%: Model.blank_form_file_name %>");
            background-repeat: no-repeat;
        }

        .component_icon {
            cursor: pointer;
        }

        .selected_icon {
            margin-left: 30px;
        }

        .selectiondiv {
            position: absolute;
            zIndex: 5000;
        }
    </style>

</asp:Content>
