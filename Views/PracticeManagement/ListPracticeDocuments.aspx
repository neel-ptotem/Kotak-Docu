<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Documentor_05Mar.Models.Docucheck>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListPracticeDocuments
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>ListPracticeDocuments</h2>

    <table>
        <tr>
            <th></th>
            <th>
                Document Name
            </th>
            <th></th>            
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%:item.Document.name %>
            </td>
            <td>
                <%: Html.ActionLink("Practice", "PracticeDocument", new { id=item.id })%>
            </td>            
        </tr>
    
    <% } %>

    </table>
    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

