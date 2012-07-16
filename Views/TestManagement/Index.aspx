<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<KotakDocuMentor.Models.Assignment>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListAssignments
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="MainContent" runat="server">

    <div class="hero-unit blocky">
        <h1 style="color:white">Assignments</h1>
        
    </div>
    
    <table width=100% border=3px style="font-size:medium">
        <tr>
             <th class="blocky" style="color:White; height:30px;">
                Name
            </th>
            <th class="blocky" style="color:White; height:30px;">
                Score
            </th>
            <th class="blocky" style="color:White; height:30px;">
                
            </th>            
        </tr>        
     <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <center><%: item.CaseStudy.name %></center>
            </td>
            <td>
                <center><%: item.score %></center>
            </td>
            <td><center>
            <%if (item.iscomplete.Equals(true))
              { %>
                <%: Html.ActionLink("Review Test", "ReviewTest", "Test", new { assignment_id = item.id }, null)%>
                <%}
              else
              { %>
                <%: Html.ActionLink("Take Test", "GoToTest", "Test", new { assignment_id = item.id }, null)%>
                <%} %>
                </center>
            </td>            
        </tr>
    
    <% } %>
    </table>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

