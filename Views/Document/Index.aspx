<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Documentor_05Mar.Models.Document>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Index</h2>

    <table>
        <tr>
            <th></th>
            <th>
                name
            </th>
        </tr>

    <% foreach (var item in Model) { %>    
        <tr>
            <td>
                <%: Html.ActionLink("View Pages", "ViewDocumentPages", new { id=item.id }) %>
            </td>
            <td>
                <%: item.name %>
            </td>
        </tr>    
    <% } %>
    </table>

    <p>
        <%: Html.ActionLink("Create New", "Create") %>
    </p>

</asp:Content>

