<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListPracticeAttempts
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">    
     <div class="hero-unit blocky">
        <h1 style="color: white;font-size:40px;">Practice Attempts for : <b><%:ViewData["document_name"] %></b></h1>
        <p style="color: white">
        </p>
        <br />
        <%: Html.ActionLink("Go Back", "Index", "Practice", new { student_id = ViewData["student_id"] }, new { @class = "btn btn-success" })%>    
    </div>
    
    
    
    <table width="100%" border="3px">
    <tr>
        <th class="blocky" style="width:25%; color:White; height:30px;">Attempt #</th>
        <th class="blocky" style="width:25%;color:White; height:30px;">Score</th>
        <th class="blocky" style="width:25%;color:White; height:30px;"></th>
    </tr>        
    <%int count = 1;
        foreach (KotakDocuMentor.Models.Docucheck dchk in ViewData["docuchecks"] as List<KotakDocuMentor.Models.Docucheck>)
      { %>
    
        <tr>
            <td><center><%: "Attempt "+count%></center></td>
            <td><center><%: (int)dchk.score + "%"%></center></td>
            <% if (dchk.Assignment.iscomplete)
               { %>
            <td><center><%: Html.ActionLink("Review", "ReviewPracticeAttempt", "Practice", new { docucheck_id = dchk.id }, new { @class = "btn btn-success" })%></center></td>
            <%}
               else
               { %>
            <td><center><%: Html.ActionLink("Continue", "PracticeDocument", "Practice", new { docucheck_id = dchk.id }, new { @class = "btn btn-success" })%></center></td>
            <%} %>            
        </tr>    
    <%count = count + 1;
      } %>

    </table>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>
