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
                Document
            </th>
            <th class="blocky" style="color:White; height:30px;">
                Average Score
            </th>
            <th class="blocky" style="color:White; height:30px;">
                No. of Attempts
            </th>
            <th class="blocky" style="color:White; height:30px;">Review Attempts</th>            
            <th class="blocky" style="color:White; height:30px;">Test</th>
        </tr>        
    <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.PracticeController.DocInfo> document in ((Dictionary<int, KotakDocuMentor.Controllers.PracticeController.DocInfo>)ViewData["DocInfo"]))
       { %>
    
        <tr>
            <td>
               <center><%: document.Value.name%></center> 
            </td>
            <td>
               <center> <%: document.Value.score %> %</center>
            </td>
            
            <td>
               <center> <%: document.Value.attempts %></center>
            </td>
            <td>
                <center> <%: Html.ActionLink("Review Attempts", "ListPracticeAttempts", new { document_id = document.Value.id, docket_id = document.Value.docket_id, student_id = ViewData["student_id"] })%></center>
            </td>
            <td>
            <center>
             <% if (document.Value.pending)
               { %>
                <%: Html.ActionLink("Continue Practice", "PracticeDocument", new { docucheck_id = document.Value.docuchek_id, sequence_number = document.Value.seq_no, student_id = ViewData["student_id"] })%>
                <% }%>
                <%else { %>
                <%: Html.ActionLink("Take Practice", "TakePractice", new { document_id = document.Value.id, docket_id = document.Value.docket_id, student_id = ViewData["student_id"] })%>
                <% }%>
            </center>
           
            </td>            
        </tr>
    
    <% } %>    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>

