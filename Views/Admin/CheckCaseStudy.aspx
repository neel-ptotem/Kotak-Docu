<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ReviewCaseStudy
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="hero-unit blocky">
        <h1 style="color:white">Case Study Review</h1>
        <p style="color:white">Case Study</p>
    </div>
    
    


<table class="table table-bordered">
  <%int i = 1; %>
  
   <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.AdminController.QuizAnswers> question in (Dictionary<int, KotakDocuMentor.Controllers.AdminController.QuizAnswers>)ViewData["quiz_questions"])
       { %>  
       <tr>
       <td class="blocky"  style="border:solid; border-radius:8px;" ><h4 style="color:white;">Question <%= i %>:</h4></td>
       </tr>
      <tr>
        <td style="font-size: 14px; border:solid; border-radius:8px;">

          <% if (question.Value.question_type !=3)
             { %>
                <b><%= "Question : "+ question.Value.question_content %></b><br/><br />
                <table width="100%">
                <% foreach (KotakDocuMentor.Models.AnswerChoice option in question.Value.options as List<KotakDocuMentor.Models.AnswerChoice>) { %>
                    <tr> 
                    <%if(option.correct??false){ %>
                        <td style="padding:0px; background-color:#88ff88">
                    <%}else if(question.Value.response.Equals(option.answer_content)){ %>
                        <td style="padding:0px;background-color:#ff8888">
                    <%}else{ %>
                        <td style="padding:0px;">
                    <%} %>
                    <input <%:question.Value.response.Equals(option.answer_content)? "checked=checked style=color:green":"" %> disabled="disabled" type="radio" name="<%:option.question_id%>" value="<%:option.answer_content %>"/><%:" "+option.answer_content%>
                    </td>
                    </tr>
                <%}%>
                </table>
                <% } %>
            <%else{ %>
                <%string correct_answer=((List<KotakDocuMentor.Models.AnswerChoice>)question.Value.options).First().answer_content; %>                    
                <b><%= question.Value.question_content.Replace("<blank>", "<input style='"+(correct_answer.Equals(question.Value.response)?"background-color:#88ff88'":"background-color:#ff8888'") +"type='text' Value='" + question.Value.response + "' name='" + question.Value.question_id + "'/>")%></b>            
                <%} %>
            </td>              
        </tr>
      <tr><td></td></tr>
      <%i = i + 1; %>
  <% } %>
    <tr>
        <td><center>
        <form id="manual" method="get" action="submitCaseResult">
            <input style="height:22px;" type="text" name="score" />
            <input type="hidden" name="assignment_id" value="<%:ViewData["assignment_id"] %>" />
            <input class="btn btn-primary btn-large" type="submit" value="submit" />
           </form> 
            </center>
        </td>
    </tr>
</table>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
<script type="text/javascript">   

</script>
</asp:Content>
