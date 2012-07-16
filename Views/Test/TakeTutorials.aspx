<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	TakeTutorials
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>TakeTutorials</h2>
    <table class="table table-bordered">


  <tr>
    <th>Concept Name</th>
    <th></th>

  </tr>
  <% foreach(Documentor_05Mar.Models.Concept concept in (List<Documentor_05Mar.Models.Concept>)ViewData["concepts"]){%>         
  <tr>
    <td><%: concept.name %></td>
    <td><%:  link_to "View Slide",view_slide_path(:concept_id=>concept.id) %></td>
  </tr>
  <% } %>




</table>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>
