<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Documentor_05Mar.Models.Assignment>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	LandingPage
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>LandingPage</h2>

    <table>
        <tr>
            <th>
                Assignment Number
            </th>
            <th>
                Case Study Name
            </th>
            <th></th>
            <th></th>
        </tr>
    <% int index=1; %>
    <% foreach (Documentor_05Mar.Models.Assignment item in Model) { %>
    
        <tr>
            <td><%:index %>
            </td>
            <td>
                <%: item.CaseStudy.name %>
            </td>
            <td>                
                <%: Html.ActionLink("View Documents", "ListPracticeDocuments", new { assignment_id=item.id }) %>
            </td>
            <td>            
                <%: Html.ActionLink("Tutorials", "TakeTutorials", "TestManagementController", new { assignment_id = item.id })%>
            </td>
        </tr>
    
    <% } %>

    </table>
    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

