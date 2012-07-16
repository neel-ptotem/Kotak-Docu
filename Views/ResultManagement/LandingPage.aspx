<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Documentor_05Mar.Models.Assignment>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	LandingPage
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>You have following assignment</h2>

    <table>
        <tr>
            <th>
                Case study name
            </th>
            <th>
                Quiz score
            </th>
            <th>
                Docucheck score
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%: item.CaseStudy.name %>
            </td>
            <td>
                <%: item.Quizs.First().score %>
            </td>
            <td>
                <%: item.Docuchecks.First().score%>
            </td>
        </tr>
    
    <% } %>

    </table>  

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

