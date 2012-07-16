<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	LandingPage
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Docucheck</h2>
    <table>
    <tr>
    <th>Docket</th>
    <th>Score</th>
    </tr>    
    <% foreach (Documentor_05Mar.Models.Docket docket in ViewData["PlayedDockets"] as List<Documentor_05Mar.Models.Docket>) { %>
    <tr>
    <td><%:docket.name%></td>
    <td><%:((int[])ViewData["PlayedDocketScore"])[docket.id] %></td>
    </tr>
    <%} %>
    <% foreach (Documentor_05Mar.Models.Docket docket in ViewData["UnplayedDockets"] as List<Documentor_05Mar.Models.Docket>) { %>
    <tr>
    <td><%:docket.name %></td>
    <td><%: Html.ActionLink("Play", "ListDocuments", new { assignment_id = (int)ViewData["assignment_id"] })%></td>
    </tr>
    <%} %>
    </table>

    <h2>Quiz</h2>
    <table>
    <tr>
    <th>Docket</th>
    <th>Score</th>
    </tr>    
    <% foreach (Documentor_05Mar.Models.Quiz quiz in (IEnumerable<Documentor_05Mar.Models.Quiz>)ViewData["PlayedQuizzes"]) { %>
    <tr>
    <td><%:"quiz_name" %></td>
    <td><%:((int[])ViewData["PlayedQuizScore"])[quiz.id] %></td>
    </tr>
    <%} %>
    <% foreach (Documentor_05Mar.Models.Quiz quiz in (IEnumerable<Documentor_05Mar.Models.Quiz>)ViewData["UnplayedQuizzes"]) { %>
    <tr>
    <td><%:"quiz_name" %></td>
    <td><%: Html.ActionLink("Play", "PlayQuiz", new { quiz_id = quiz.id,employee_id=(int)ViewData["employee_id"] })%></td>
    </tr>
    <%} %>
    </table>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>
