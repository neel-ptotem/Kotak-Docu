<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<KotakDocuMentor.Models.Assignment>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListAttempts
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="hero-unit blocky">
        <h1 style="color:white;font-size:48px;">Attempts of <%:ViewData["cs_name"] %></h1>
        <p style="color:white"></p>
    </div>

    <table width="100%" border="3px">
    <tr>
        <th class="blocky" style="width:25%; color:White; height:30px;">Attempt #</th>
        <th class="blocky" style="width:25%;color:White; height:30px;">Level</th>
        <th class="blocky" style="width:25%;color:White; height:30px;">Score</th>
        <th class="blocky" style="width:25%;color:White; height:30px;"></th>
    </tr>        
    <%int count = 1;
        foreach (var item in Model)
      { %>
    
        <tr>
            <td><center><%: "Attempt "+count%></center></td>
            <td><center><%: item.Level.name %></center></td>
            <td><center><%: (int)item.score + "%"%></center></td>
            <% if (item.iscomplete)
               { %>
            <td><center><%: Html.ActionLink("Review", "ReviewAssignment", "Review", new { assignment_id = item.id }, new { @class = "btn btn-success" })%></center></td>
            <%}
               else
               { %>
            <td><center><%: Html.ActionLink("Continue", "GoToTest", "Test", new { case_study_id = item.CaseStudy.id,student_id=ViewData["student_id"] }, new { @class = "btn btn-success" })%></center></td>
            <%} %>            
        </tr>    
    <%count = count + 1;
      } %>

    </table>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>