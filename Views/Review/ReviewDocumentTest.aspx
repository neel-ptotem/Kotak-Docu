<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	PlayDocumentTest
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">



<div class="page-header blocky" style="position:fixed; color:white;font-weight: bold;">
  <form action="ReviewDocumentTest">
  <input type="hidden" name="docucheck_id" id="docucheck_id" value="<%:((KotakDocuMentor.Models.Docucheck)ViewData["docucheck"]).id %>" />
  <input type="hidden" name="sequence_number" id="sequence_number" value="<%: ViewData["sequence_number"] %>" />
  <input type="submit" class="btn-success btn" id ="save_button" value="Next"/>
  </form>
  <br />
  <br />
  <br/>


  <br/>
</div>

<div class="row" style="text-align: center; background: grey">
  <div id="DocumentFrame" class="docuframe">

  
  <% foreach (KotakDocuMentor.Models.FilledSection filled_section in ViewData["filled_sections"] as List<KotakDocuMentor.Models.FilledSection>)
     { %>
<%// KotakDocuMentor.Models.DocumentorDBDataContext DocumentorDB = ViewData["DocumentorDB"] as KotakDocuMentor.Models.DocumentorDBDataContext; %>
      <% KotakDocuMentor.Models.BlankSection blank_section = filled_section.BlankSection; %>
      <% KotakDocuMentor.Models.Example example = filled_section.Example; %>
      <% if (example.is_image == true)
         { %>
          <img src="/Content/images/examples/<%: example.id%>/medium/<%: example.example_image_file_name%>" id="<%:filled_section.id%>" class=" btn-correct option_image" style="position :absolute;top :<%:blank_section.ypos+22%>px;left: <%:blank_section.xpos+70%>px; height:<%:blank_section.height%>px;width:<%:blank_section.width%>px;" alt=""/>
      <% } %>
      <% else
         { %>
          <p class="btn-correct option_image" id="<%= filled_section.id %>"style="position :absolute;z-index:5000;top :<%= blank_section.ypos+22%>px;left:<%=blank_section.xpos+70 %>px;width:<%=blank_section.width %>px;height:<%=blank_section.height %>px;"><%:MvcHtmlString.Create(example.text_content)%></p>
      <% } %>     
      <img src= "/Content/images/general/cross.jpeg" style="position :absolute;z-index:6000;top:<%:blank_section.ypos+22%>px;left:<%:blank_section.xpos+70%>px;visibility:<%:filled_section.has_no_error.Equals(filled_section.marked_correctly)?"hidden":"visible"%>;background:transparent" class="<%:filled_section.id%>" height="32px" width="32px" alt="close"/>
      <% } %>
  </div>

</div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">

<script type="text/javascript">

    $(function () {
    });

</script>

    <style type="text/css">
        .content {
            background: gray;
        }

       .page-header 
       {
         position: fixed;
         height: 600px;
         width: 180px;
         overflow: auto;
         margin:0;
         padding:20px;
         margin-left: -20px;
         text-align: center;
         font-weight: bold;
}

        .docuframe 
        {
            background-color:ThreeDShadow;
            border-radius:20px;
            width: 900px;
            height: 1080px;
            margin: 0 +290px;
            margin-top: 20px;
            background-image: url("/Content/images/blank_forms/<%:((KotakDocuMentor.Models.Page)ViewData["page"]).id %>/medium/<%:((KotakDocuMentor.Models.Page)ViewData["page"]).blank_form_file_name %>");
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
            border: 1px solid black
        }
    </style>

</asp:Content>
