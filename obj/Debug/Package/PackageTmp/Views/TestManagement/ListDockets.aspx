<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<KotakDocuMentor.Models.Docket>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListDockets
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>ListDockets</h2>

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
    <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.TestManagementController.DocInfo> docket in ((Dictionary<int, KotakDocuMentor.Controllers.TestManagementController.DocInfo>)ViewData["DocketList"]))
       { %>
    
        <tr>
            <td>
                <%: docket.Value.name %>
            </td>
            <td>
                <%: docket.Value.score %>
            </td>
            <td>
            <% if (!docket.Value.played)
               { %>
                <%: Html.ActionLink("ListDocuments", "DocketDocumentsQuiz", new { docket_id = docket.Value.id, assignment_id = ViewData["assignment_id"] })%>
                <% } %>
            </td>            
        </tr>
    
    <% } %>

    </table>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

