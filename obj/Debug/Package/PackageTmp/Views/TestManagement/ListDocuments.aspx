<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<KotakDocuMentor.Models.Docucheck>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListDocuments
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>ListDocuments</h2>
    
    <table>
        <tr>
            <th>
                name
            </th>
            <th>
                score
            </th>
            <th></th>            
        </tr>        
    <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.TestManagementController.DocInfo> docucheck in ((Dictionary<int, KotakDocuMentor.Controllers.TestManagementController.DocInfo>)ViewData["DocumentList"]))
       { %>
    
        <tr>
            <td>
                <%: docucheck.Value.name%>
            </td>
            <td>
                <%: docucheck.Value.score %>
            </td>
            <td>
            <% if (!docucheck.Value.played)
               { %>
                <%: Html.ActionLink("Take Test", "PlayDocumentTest", new { docucheck_id = docucheck.Value.id,sequence_number=1,assignment_id=ViewData["assignment_id"] })%>
                <% } %>
            </td>            
        </tr>
    
    <% } %>    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

