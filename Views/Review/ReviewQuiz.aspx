<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ReviewQuiz
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="hero-unit blocky">
        <h1 style="color: white">
            Quiz Review</h1>
        <p style="color: white">
            Quiz</p>
    </div>
    <table class="table table-bordered">
        <%int i = 1; %>
        <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.ReviewController.QuizAnswers> question in (Dictionary<int, KotakDocuMentor.Controllers.ReviewController.QuizAnswers>)ViewData["quiz_questions"])
           { %>
        <tr>
            <td class="blocky" style="border: solid; border-radius: 8px;">
                <h4 style="color: white;">
                    Question
                    <%= i %>:</h4>
            </td>
        </tr>
        <tr>
            <td style="font-size: 14px; border: solid; border-radius: 8px;">
                <% if (question.Value.question_type == 1 || question.Value.question_type == 3)
                   { %>
                <b>
                    <%= "Question : "+ question.Value.question_content %></b><br />
                <br />
                <table width="100%">
                    <% foreach (KotakDocuMentor.Models.AnswerChoice option in question.Value.options as List<KotakDocuMentor.Models.AnswerChoice>)
                       { %>
                    <tr>
                        <%if (option.correct ?? false)
                          { %>
                        <td style="padding: 0px; background-color: #88ff88">
                            <%}
                          else if (question.Value.response.Equals(option.answer_content))
                          { %>
                            <td style="padding: 0px; background-color: #ff8888">
                                <%}
                          else
                          { %>
                                <td style="padding: 0px;">
                                    <%} %>
                                    <input <%:question.Value.response.Equals(option.answer_content)? "checked=checked style=color:green":"" %>
                                        disabled="disabled" type="radio" name="<%:option.question_id%>" value="<%:option.answer_content %>" /><%:" "+option.answer_content%>
                                </td>
                    </tr>
                    <%}%>
                </table>
                <% } %>
                <%else if (question.Value.question_type == 2)
                    { %>
                <%string correct_answer = ((List<KotakDocuMentor.Models.AnswerChoice>)question.Value.options).First().answer_content; %>
                <b>
                    <%= question.Value.question_content.Replace("<blank>", "<input style='"+(correct_answer.Equals(question.Value.response)?"background-color:#88ff88'":"background-color:#ff8888'") +"type='text' Value='" + question.Value.response + "' name='" + question.Value.question_id + "'/>")%></b>
                <%}
                    else
                    { %>
                <%string correct_answer = ((List<KotakDocuMentor.Models.AnswerChoice>)question.Value.options).First().answer_content; %>
                <textarea id="" name="" rows="3" style="width: 100%; resize: none;" disabled="disabled"
                    readonly="readonly"></textarea>
                <%} %>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
        <%i = i + 1; %>
        <% } %>
        <tr>
            <td>
                <center>
                    <%: Html.ActionLink("Go to Assignments", "ListCaseStudies", "Home", new { student_id = ViewData["student_id"] }, new { @class = "btn btn-success btn-large" })%>
                    <%if ((bool)ViewData["has_docucheck"])
                      {%>
                    <%: Html.ActionLink("Goto Docucheck", "ListDocuments", "Test", new { assignment_id = ViewData["assignment"] }, new { @class = "btn btn-success btn-large"})%>
                    <%}%>
                </center>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
    <script type="text/javascript">   

    </script>
</asp:Content>
