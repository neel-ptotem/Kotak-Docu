<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Documentor_05Mar.Models.FilledSection>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	PracticeDocument
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="row" style="text-align: center; background: transparent">
  <div id="DocumentFrame" class="docuframe">
  </div>

  <% foreach (Documentor_05Mar.Models.FilledSection filled_section in (IEnumerable<Documentor_05Mar.Models.FilledSection>) ViewData["filled_section"]) { %>

      <% Documentor_05Mar.Models.BlankSection blank_section=filled_section.BlankSection; %>
      <img alt="<%:blank_section.Component.name %>" src="<%:filled_section.Example.example_image.url%>", id="<%:filled_section.id %>", class="btn-success btn option_image", style ="
          position :absolute;
          z-index:5000;
          top :<%:blank_section.ypos%>px;
          left: <%:blank_section.xpos%>px;
          width: <%:blank_section.width%> px;
          height:<%:blank_section.height%>px;
          "
      >
  <% } %>
</div>

<% Html.BeginForm("save_practice_document_results","TestManagementController"){%>
<% foreach (Documentor_05Mar.Models.FilledSection filled_section in (IEnumerable<Documentor_05Mar.Models.FilledSection>)ViewData["filled_sections"]){ %>
    <%= Html.Hidden(filled_section.id.ToString(),0,new{@class=filled_section.id}) %>
    <%= Html.HiddenFor(fillect_section=>filled_section.id,new{@value="0",@class=filled_section.id}) %>
    <%= Html.HiddenFor(fillect_section=>filled_section.id,new{@value="0",@class=filled_section.id}) %>
<% } }%>

<div style="position:fixed; color:white;font-weight: bold;margin-top: 20px;top:50px;left:30px;height: 150px">
  <%= HtmlInputSubmit image_submit_tag('submit_button.jpeg', :size=>'150x140', :class=>"btn-primary span3", :id=>"save_button") %>
  <br/>
  <br/>
</div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
<%:((IEnumerable<Documentor_05Mar.Models.Page>) ViewData["Page"]).First().blank_form_file_name; %>
 <script type="text/javascript">

     $(function () {
         $(".option_image").click(function (event) {

             //if the image is marked correct..mark it incorrect
             if ($(this).attr("class").search("btn-success") != -1) {
                 $(this).addClass("btn-danger");
                 $(this).removeClass("btn-success");
                 $("." + $(this).attr("id")).attr("value", 1);

             }

             //if the image is incorrect...mark is correct
             else {
                 $(this).addClass("btn-success");
                 $(this).removeClass("btn-danger");
                 $("." + $(this).attr("id")).attr("value", 0);
             }


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
            background-image: "<%:((IEnumerable<Documentor_05Mar.Models.Page>) ViewData["Page"]).First().blank_form_file_name; %>";
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

