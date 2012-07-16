<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<KotakDocuMentor.Models.Docucheck>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ListDocuments
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="hero-unit blocky">
        <h1 style="color:white">DocuCheck</h1>
        <p style="color:white">Now for some practical practice. Can you catch all the errors in these documents?</p>
    </div>
    
    <table width=100% border=3px>
        <tr>
             <th class="blocky" style="color:White; height:30px;">
                Type
            </th>
            <th class="blocky" style="color:White; height:30px;">
                name
            </th>
            <th class="blocky" style="color:White; height:30px;">
                score
            </th>
            <th class="blocky" style="color:White; height:30px;">Test</th>            
        </tr>        
    <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.TestManagementController.DocInfo> docucheck in ((Dictionary<int, KotakDocuMentor.Controllers.TestManagementController.DocInfo>)ViewData["DocumentList"]))
       { %>
    
        <tr>
             <td>
               
            </td>
            <td>
               <center><%: docucheck.Value.name%></center> 
            </td>
            <td>
               <center> <%: docucheck.Value.score %></center>
            </td>
            <td>
            <center>
             <% if (!docucheck.Value.played)
                { %>
                <%: Html.ActionLink("Take Test", "PlayDocumentTest", new { docucheck_id = docucheck.Value.id, sequence_number = 1, assignment_id = ViewData["assignment_id"] })%>
                <% }
                else
                {%>
                <%: Html.ActionLink("Review Test", "ReviewDocumentTest", new { docucheck_id = docucheck.Value.id})%>
                <%} %>
            </center>
           
            </td>            
        </tr>
    
    <% } %>    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

