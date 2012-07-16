<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Index
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div style="background-image: url('/Content/images/general/documents.jpg'); height: 630px; width: 100%;">
        <div style="width: 15%; padding: 10% 5% 5% 5%; float: left;">
            <img src="/Content/images/general/Admin 2.png" alt="coach" width="250" height="250" />
        </div>
        <div style="width: 60%; padding: 5% 5% 5% 5%; float: right;">
            <div id="vtab">
                <ul style="background-color: White; border-right: 10px solid white; border-radius: 10px 10px 10px 10px;">
                    <li class="selected" style="border-radius: 10px 0 0 0;">
                        <div>
                            <img src='/Content/images/general/Test.png' height="100px" width="75px" style="margin: 10px 5px 5px 20px;" /><br />
                            <center>
                                <b>Tests</b></center>
                        </div>
                    </li>
                    <li style="border-radius: 0 0 0 0;">
                        <div>
                            <img src='/Content/images/general/Report.png' height="100px" width="75px" style="margin: 10px 5px 5px 20px;" /><br />
                            <center>
                                <b>Reports</b></center>
                        </div>
                    </li>
                    <li style="border-radius: 0 0 0 10px;">
                        <div>
                            <img src='/Content/images/general/DataEntry.png' height="100px" width="75px" style="margin: 10px 5px 5px 20px;" /><br />
                            <center>
                                <b>Settings</b></center>
                        </div>
                    </li>
                </ul>
                <div id="Test" style="margin-left: 117px; width: 720px; height: 480px; border: 2px solid black;">
                    <ul style="max-height: 35px;">
                        <li>
                            <center>
                                <a style="width: 320px;" href="#tabs-5">Quizzes</a></center>
                        </li>
                        <li>
                            <center>
                                <a style="width: 320px;" href="#tabs-6">Case Studies</a></center>
                        </li>
                        <%--<li><center><a style="width:226px;" href="#tabs-7">Assignments</a></center></li>--%>
                    </ul>
                    <div id="tabs-5" style="overflow-y: auto; overflow-x: hidden; height: 450px;">
                    
                        <div class="top_block" id="top_block" style="visibility: hidden;">
                            <button class="btn-danger btn-large" onclick="close_pop()" style="position: absolute;
                                margin-top: -6%; margin-left: 92%;">
                                <b>X</b>
                            </button>
                            <%Html.RenderPartial("~/Views/Admin/QuizForm.ascx"); %>
                        </div>
                        
                        <a class="btn btn-warning" onclick="pop()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Create New Quiz&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>                        
                        <a href="/Content/Templates/QuizQuestionsTemplate.xlt" class="btn btn-inverse" style="color:White;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Download Template&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>

                        <br />
                        <br />
                        <div style="overflow-y: auto; overflow-x: hidden; height: 380px; width: 100%;">
                            <table id="table_quiz" cellpadding="0" cellspacing="0" width="100%">
                                <thead>
                                    <tr>
                                        <th>
                                            Name
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody style="max-height: 200px; overflow-y: auto;">
                                    <% foreach (KotakDocuMentor.Models.CaseStudy case_study in ViewData["quizzes"] as List<KotakDocuMentor.Models.CaseStudy>)
                                       {%>
                                    
                                    <tr>
                                        <td>
                                            <%= case_study.name%>
                                        </td>
                                        <%if (case_study.active.Equals(true))
                                          {%>
                                        <td>
                                            <%: Html.ActionLink("Deactivate", "ToggleStatus", new { case_study_id = case_study.id }, new { @class = "btn-danger btn btn-mini" })%>
                                        </td>
                                        <%}
                                          else
                                          { %>
                                        <td>
                                            <%: Html.ActionLink("Activate", "ToggleStatus", new { case_study_id = case_study.id }, new { @class = "btn-success btn btn-mini" })%>
                                        </td>
                                        <%} %>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th>
                                            Name
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                        <br />
                    </div>
                    <div id="tabs-6" style="overflow-y: auto; overflow-x: hidden; height: 450px;">
                        
                        <div class="top_block1" id="top_block1" style="visibility: hidden;">
                            <button class="btn-danger btn-large" onclick="close_pop()" style="position: absolute;
                                margin-top: -6%; margin-left: 92%;">
                                <b>X</b>
                            </button>
                            <%Html.RenderPartial("~/Views/Admin/CaseStudyForm.ascx"); %>
                        </div>
                        
                        <a class="btn btn-warning" onclick="pop()">Create New Case Study</a>                        
                        <a href="/Content/Templates/QuizQuestionsTemplate.xlt" class="btn btn-inverse" style="color:White;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Download Template&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>

                        <br />
                        <br />
                        <div style="overflow-y: auto; overflow-x: hidden; height: 380px; width: 100%;">
                            <table id="table_case_study" cellpadding="0" cellspacing="0" width="100%">
                                <thead>
                                    <tr>
                                        <th>
                                            Name
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% foreach (KotakDocuMentor.Models.Quiz case_study in ViewData["case_studies"] as List<KotakDocuMentor.Models.Quiz>)
                                       {%>
                                    <tr>
                                        <td>
                                            <%= case_study.name%>
                                        </td>
                                        <td>
                                            <%: Html.ActionLink("Check Answers", "CheckCaseStudies", new { target = "blank", quiz_id = case_study.id }, new {@class="btn-info btn btn-mini"})%>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th>
                                            Name
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    <%-- <div id="tabs-7">
            
</div>--%>
                </div>
                <div id="Report" style="margin-left: 117px; width: 720px; height: 480px; border: 2px solid black;">
                    <ul style="max-height: 35px;">
                        <li>
                            <center>
                                <a style="width: 203px;" href="#tabs-1">Employee Report</a></center>
                        </li>
                        <li>
                            <center>
                                <a style="width: 203px;" href="#tabs-2">Division Report</a></center>
                        </li>
                        <li>
                            <center>
                                <a style="width: 203px;" href="#tabs-3">Assignment Report</a></center>
                        </li>
                    </ul>
                    <div id="tabs-1" style="overflow-y: auto; overflow-x: hidden; height: 450px;">
                        <br />
                        <br />
                        <div style="overflow-y: auto; overflow-x: hidden; height: 380px;">
                            <table id="table_employee">
                                <thead>
                                    <tr>
                                        <th>
                                            EmpId
                                        </th>
                                        <th>
                                            Name
                                        </th>
                                        <th>
                                            Division
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% foreach (KotakDocuMentor.Models.Employee employee in ViewData["employees"] as List<KotakDocuMentor.Models.Employee>)
                                       {%>
                                    <tr>
                                        <td>
                                            <%= employee.EmpId%>
                                        </td>
                                        <td>
                                            <%= employee.FirstName + " " + employee.LastName%>
                                        </td>
                                        <td>
                                            <%= employee.Division%>
                                        </td>
                                        <td>
                                            <%: Html.ActionLink("Get Report", "GetReport", new { employee_id = employee.UserLoginName }, new {@class="btn-info btn btn-mini"})%>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th>
                                            EmpId
                                        </th>
                                        <th>
                                            Name
                                        </th>
                                        <th>
                                            Division
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    <div id="tabs-2" style="overflow-y: auto; overflow-x: hidden; height: 450px;">
                        <br />
                        <br />
                        <div style="overflow-y: auto; overflow-x: hidden; height: 380px;">
                            <table id="table_division">
                                <thead>
                                    <tr>
                                        <th>
                                            Division
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% foreach (string division in ViewData["divisions"] as List<string>)
                                       {%>
                                    <tr>
                                        <td>
                                            <%= division%>
                                        </td>
                                        <td>
                                            <%: Html.ActionLink("Get Report", "GetReport", new { division = division }, new {@class="btn-info btn btn-mini"})%>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th>
                                            Division
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    <div id="tabs-3" style="overflow-y: auto; overflow-x: hidden; height: 450px;">
                        <br />
                        <br />
                        <div style="overflow-y: auto; overflow-x: hidden; height: 380px;">
                            <table id="table_assignments">
                                <thead>
                                    <tr>
                                        <th>
                                            Quiz
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% foreach (KotakDocuMentor.Models.CaseStudy case_study in ViewData["quizzes"] as List<KotakDocuMentor.Models.CaseStudy>)
                                       {%>
                                    <tr>
                                        <td>
                                            <%= case_study.name%>
                                        </td>
                                        <td>
                                            <%: Html.ActionLink("Get Report", "GetReport", new { case_study_id = case_study.id }, new {@class="btn-info btn btn-mini"})%>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th>
                                            Quiz
                                        </th>
                                        <th>
                                        </th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
                <div id="DataEntry" style="margin-left: 117px; width: 720px; height: 480px; border: 2px solid black;">
                    <ul style="max-height: 35px;">
                        <li>
                            <center>
                                <a style="width: 675px;" href="#tabs-7">Settings</a></center>
                        </li>
                    </ul>
                    <div id="tabs-7">
                        <%Html.RenderPartial("~/Views/Admin/SettingsForm.ascx"); %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
    <script type="text/javascript" src="/Scripts/javascripts/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="/Scripts/javascripts/datatables_scrolling.js"></script>
    <link href="/Scripts/stylesheets/jquery.dataTables.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">        
    $(function () {

        $("#table_case_study").dataTable({"sPaginationType": "full_numbers", "sScrollY": "200px","bScrollCollapse": true});

        $("#table_quiz").dataTable({"sPaginationType": "full_numbers", "sScrollY": "200px","bScrollCollapse": true});        
       
        $("#table_division").dataTable({"sPaginationType": "full_numbers", "sScrollY": "200px","bScrollCollapse": true});

        $("#table_assignments").dataTable({"sPaginationType": "full_numbers", "sScrollY": "200px","bScrollCollapse": true});

        $("#table_employee").dataTable({"sPaginationType": "full_numbers", "sScrollY": "200px","bScrollCollapse": true});

        alert("<%:ViewData["x"] %>");
        alert($("body").width());
        $("#Test ,#Report ,#DataEntry").tabs();
        var $items = $('#vtab>ul>li');
        $items.click(function() {
        $items.removeClass('selected');
        $(this).addClass('selected');
        
        var index = $items.index($(this));
        $('#vtab>div').hide().eq(index).show();
        }).eq(0).click();

        
        
        });
    </script>
    <style type="text/css">
        .top_block, .top_block1
        {
            position: absolute;
            display: block;
            min-height: 100px;
            min-width: 350px;
            z-index: 100;
            background-color: Silver;
            left: 10%;
            border: 3px solid;
            border-radius: 10px 10px;
            -moz-border-radius: 10px 10px;
            padding: 15px;
            opacity: 1;
        }
        
        #vtab > ul > li
        {
            width: 115px;
            height: 123px;
            background-color: Silver;
            list-style-type: none;
            display: block;
            margin: auto;
            padding-bottom: 10px;
            padding-left: 0;
            border: 2px solid;
            position: relative;
            z-index: 1;
        }
        #vtab > ul > li.selected
        {
            border: 2px solid;
            -moz-border-radius: 0 0 0 0;
            z-index: 10;
            border-right: 3px solid white;
            border-collapse: separate;
            background-color: #fafafa !important;
            position: relative;
        }
        
        td
        {
            text-align: center;
            
        }
        
        th
        {
            text-align: center;
        }
        
        #vtab > ul
        {
            float: left;
            width: 118px;
            text-align: left;
            display: block;
            margin: auto 0;
            padding: 0;
            position: relative;
            top: 45px;
        }
    </style>
    <script type="text/JavaScript">
        function close_pop() {

            document.getElementById("top_block").style.visibility = 'hidden';
            document.getElementById("top_block1").style.visibility = 'hidden';
        }

        function pop() {

            document.getElementById("top_block").style.visibility = 'visible';
            document.getElementById("top_block1").style.visibility = 'visible';
        } 
    </script>
</asp:Content>
