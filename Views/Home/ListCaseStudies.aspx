<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ListCaseStudies
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="hero-unit blocky">
        <h1 style="color: white">
            Assignments</h1>
        <p style="color: white">
        </p>
    </div>
    <table width="100%" border="3px">
        <tr>
            <th class="blocky" style="color: White; height: 30px;width:25%;">
                Name
            </th>
            <th class="blocky" style="color: White; height: 30px;width:15%;">
                No. of Attempts
            </th>
            <th class="blocky" style="color: White; height: 30px;width:15%;">
                Average Score
            </th>
            <th class="blocky" style="color: White; height: 30px;width:15%;">
                Maximum Score
            </th>
            <th class="blocky" style="color: White; height: 30px;width:15%;">
            </th>
            <th class="blocky" style="color: White; height: 30px;width:15%;">
            </th>
        </tr>
        <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.HomeController.CaseStudyInfo> cs_info in ((Dictionary<int, KotakDocuMentor.Controllers.HomeController.CaseStudyInfo>)ViewData["CaseStudyList"]))
           {%>
        <tr>
            <td>
                <center>
                    <%:cs_info.Value.name %></center>
            </td>
            <td>
                <center>
                    <%:cs_info.Value.attempts %></center>
            </td>
            <td>
                <center>
                    <%:cs_info.Value.a_score %></center>
            </td>
            <td>
                <center>
                    <%:cs_info.Value.m_score %></center>
            </td>
            <td>
                <center>
                    <%: Html.ActionLink("Review Attempts", "ListAttempts", "Home", new { case_study_id = cs_info.Key,student_id=ViewData["student_id"] }, new { @class = "btn btn-primary" })%></center>
            </td>
            <td>
                <center>
                    <%if (cs_info.Value.active)
                      {
                          if (cs_info.Value.incomplete_assignment)
                          {  %>
                    <%: Html.ActionLink("Continue Test", "GoToTest", "Test", new { case_study_id = cs_info.Key, student_id = ViewData["student_id"] }, new { @class = "btn btn-warning" })%>
                    <%}
                  else if (cs_info.Value.passed == false)
                  { %>
                    <%: Html.ActionLink("Start Test", "GoToTest", "Test", new { case_study_id = cs_info.Key, student_id = ViewData["student_id"] }, new { @class = "btn btn-success" })%>
                    <%}
              }
                    %>
                    </center>
            </td>
        </tr>
        <%} %>
    </table>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>
