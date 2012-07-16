<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	UserStatistics
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>UserStatistics</h2>
    <h3>Docketwise Statistics</h3>
    <table>
    <tr>
    <th>Docket Name</th>
    <th>Number of attempts</th>
    <th>Average Score</th>
    </tr>
    <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.TestManagementController.ResultInfo> docket_stat in ((Dictionary<int, KotakDocuMentor.Controllers.TestManagementController.ResultInfo>)ViewData["DocketStat"]))
       { %>
        <tr>
        <td><%:docket_stat.Value.name %></td>
        <td><%:docket_stat.Value.attempts %></td>
        <td><%:docket_stat.Value.score %></td>
        </tr>
    <%} %>
    </table>
    <h3>Documentwise Statistics</h3>
    <table>
    <tr>
    <th>Document Name</th>
    <th>Number of attempts</th>
    <th>Average Score</th>
    </tr>
    <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.TestManagementController.ResultInfo> doc_stat in ((Dictionary<int, KotakDocuMentor.Controllers.TestManagementController.ResultInfo>)ViewData["DocStat"]))
       { %>
        <tr>
        <td><%:doc_stat.Value.name %></td>
        <td><%:doc_stat.Value.attempts %></td>
        <td><%:doc_stat.Value.score %></td>
        </tr>
    <%} %>
    </table>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

