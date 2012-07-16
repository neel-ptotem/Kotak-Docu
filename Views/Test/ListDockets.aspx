<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<KotakDocuMentor.Models.Docket>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListDockets
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

   <div class="hero-unit blocky">
        <h1 style="color:white">DocuCheck</h1>
        <p style="color:white">Now for some practical practice. Can you catch all the errors in these documents?</p>
   </div>
    <table width="100%" border=3px>
        <tr>
            <th class="blocky" style="color:White; height:30px;">
                name
            </th>
            <th  class="blocky"  style="color:White;">
                score
            </th>
            <th  class="blocky"  style="color:White;">Test</th>            
        </tr> <br />       
    <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.TestManagementController.DocInfo> docket in ((Dictionary<int, KotakDocuMentor.Controllers.TestManagementController.DocInfo>)ViewData["DocketList"]))
       { %>
    
        <tr>
            <td>
               <center> <%: docket.Value.name %></center>
            </td>
            <td>
               <center><%: docket.Value.score %></center> 
            </td>
            <td>
            <center>
              <% if (!docket.Value.played)
               { %>
                <%: Html.ActionLink("ListDocuments", "DocketDocumentsQuiz", new { docket_id = docket.Value.id, assignment_id = ViewData["assignment_id"] })%>
                <% } %>
            </center>
          
            </td>            
        </tr>
    
    <% } %>

    </table>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

