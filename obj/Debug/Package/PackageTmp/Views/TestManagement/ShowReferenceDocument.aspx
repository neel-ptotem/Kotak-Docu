<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ShowReferenceDocument
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>ShowReferenceDocument</h2>
    
<div class="page-header" style="position:fixed; color:white;font-weight: bold;margin-top: 20px">
<%if ((bool)ViewData["islast"])
  { %>
  <%: Html.ActionLink("Next Page", "ShowReferenceDocument", new { docket_id = ViewData["docket_id"], document_id = ViewData["document_id"], seq_no = ViewData["seq_no"] })%>
<%} %>
</div>

<div class="row" style="text-align: center; background: transparent">
  <div id="DocumentFrame" class="docuframe">
  </div>

  <% foreach (KotakDocuMentor.Models.FilledSection filled_section in (List<KotakDocuMentor.Models.FilledSection>)ViewData["filled_sections"])
     { %>
      <% KotakDocuMentor.Models.BlankSection blank_section = filled_section.BlankSection; %>
      <img alt="" src="../../Content/example_images/<%: filled_section.example_id%>/medium/<%: filled_section.Example.example_image_file_name%>" id="<%: filled_section.id %>" class="option_image" style = "position :absolute;z-index:5000;top :<%: blank_section.ypos%>px; left: <%:blank_section.xpos%>px; width: <%:blank_section.width%>px;height:<%:blank_section.height%>px;" />
  <% } %>
</div>


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
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
            background-image: url("../../Content/blank_forms/<%:((KotakDocuMentor.Models.Page)ViewData["page"]).id %>/medium/<%:((KotakDocuMentor.Models.Page)ViewData["page"]).blank_form_file_name %>");
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
