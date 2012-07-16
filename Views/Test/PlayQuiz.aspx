<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	PlayQuiz
</asp:Content>
<asp:Content ID="Timer" ContentPlaceHolderID="TimerHolder" runat="server"><h2 style="width:225px;text-align:left;"><small> Time Remaining </small><span id="time_remaining">00:00</span></h2></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <% if (((KotakDocuMentor.Models.Quiz)ViewData["quiz"]).isonline == true){%>
        <div class="hero-unit blocky">
            <h1 style="color:white">Quiz</h1>
            <p style="color:white">This will test your knowledge about documents !!!</p>
        </div>
    <%}else{ %>
        <div class="hero-unit blocky">
            <h1 style="color:white">Case Study</h1>
            <p style="color:white"></p>
        </div>    
        <div style="border-radius:20px;border:5px solid;background-color:InfoBackground;">
            <p style="padding:25px 25px 25px 25px; text-align:justify;font-size:24px;line-height:28px;"><%:((KotakDocuMentor.Models.Quiz)ViewData["quiz"]).text_content%></p>
        </div>
        <br />
    <%} %>
    <form id="quiz_form" action="SaveQuizData" method='post'>
    <input type="hidden" name="time_spend" id="time_spend" value="0" />
    <input id="quiz_id" type="hidden" name="quiz_id" value="<%=((KotakDocuMentor.Models.Quiz) ViewData["quiz"]).id %>" />
    <input id="assignment_id" type="hidden" name="assignment_id" value="<%: ((KotakDocuMentor.Models.Assignment)ViewData["assignment"]).id %>" />
    <table class="table table-bordered">
    <%int i = 1; %>
    <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.TestController.QuestionAnswers> question in (Dictionary<int, KotakDocuMentor.Controllers.TestController.QuestionAnswers>)ViewData["quiz_questions"])
       { %>  
    <tr>
       <td class="blocky"  style="border:solid; border-radius:8px;" ><h4 style="color:white;">Question <%= i %>:</h4></td>
    </tr>
    <tr>
        <td style="font-size: 14px; border:solid; border-radius:8px; padding:5px 15px 5px 5px;">

          <% if (question.Value.question_type == 1 || question.Value.question_type == 3)
             { %>
          <b><%= "Question : "+ question.Value.question_content %></b><br/><br />
        
          <% foreach (KotakDocuMentor.Models.AnswerChoice option in question.Value.options as List<KotakDocuMentor.Models.AnswerChoice>)
             { %>
         
        <input type="radio" name="<%:option.question_id%>" value="<%:option.answer_content %>"/><%:" "+option.answer_content%><br/>
        <%}
             } %>
             <%else if (question.Value.question_type == 2)
                 { %>
             <br/>
                <b><%= question.Value.question_content.Replace("<blank>", "<input type='text' name='" + question.Value.question_id + "'/>")%></b><br/>                
             <br/>
             <%}
                 else
                 { %>
                 <b><%= "Question : "+ question.Value.question_content %></b><br/><br />
             <textarea id="" name="" rows="3" style="width:100%;resize:none;"></textarea>
             <%} %>
        </td>        
      </tr>
      <tr><td></td></tr>
      <%i = i + 1; %>
  <% } %>
</table><br />
<input style="height:50px;width:250px;margin-left:40%;font-size:x-large;" type="submit" value="Confirm Answers" class="btn btn-success btn-large"/>
</form>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
<script type="text/javascript">
    var remaining_time = 0;
    var time_spend = 0;
    $(function () {
        $.get("/Test/get_remaining_time", { assignment_id: '<%:ViewData["assignment_id"]%>' }, function (data) {
            remaining_time = data;
            var remaining_sec = remaining_time - time_spend;
            hrs = (remaining_time - time_spend) / 3600;
            mins = ((remaining_time - time_spend) % 3600) / 60;
            secs = ((remaining_time - time_spend) % (3600 * 60)) % 60;
            $("#time_remaining").html(hrs.toFixed() + ":" + mins.toFixed() + ":" + secs.toFixed());
        });
        time_updater = setInterval(function () { update_time_spend(); }, 1000);
        $("#quiz_form").submit(function () {
            $(this).find("#time_spend").attr("value", time_spend);
            return true;
        });


        function update_time_spend() {
            time_spend = time_spend + 1;
            var remaining_sec = remaining_time - time_spend;
            hrs = parseInt((remaining_time - time_spend) / 3600);
            mins = parseInt(((remaining_time - time_spend) % 3600) / 60);
            secs = parseInt(((remaining_time - time_spend) % (3600 * 60)) % 60);
            $("#time_remaining").html(hrs + ":" + mins+":" + secs);

            if (time_spend >= remaining_time) {
                clearInterval(time_updater);
                $("#quiz_form").submit();
            }
        }
    });
</script>
</asp:Content>
