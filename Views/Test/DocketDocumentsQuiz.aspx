<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	DocketDocumentsQuiz
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h3>Select Documents required for</h3><h2><%:ViewData["docket_name"]%></h2>
        <table class="table table-bordered">
        <% int i=0; %>
        <tr>
        <% foreach (KeyValuePair<int, KotakDocuMentor.Controllers.TestManagementController.DocketDocInfo> record in ((Dictionary<int, KotakDocuMentor.Controllers.TestManagementController.DocketDocInfo>)ViewData["record"]))
         {%>
         
         <td style="width:33.33%" class="<%:record.Value.correct%>"><input id="<%:record.Key%>" type="checkbox"/><%:record.Value.name %> </td>
         <%i = i + 1;%>
         <% if (i % 3 == 0)
            { %>
         </tr><tr>
         <%} %>
        <%} %>
        </tr>
        </table>
        <button id="check_btn" onclick="docheck();" class="btn-primary">Check</button>
        <input value="  Go  " type="button" id="go_btn" style="visibility:hidden" class="btn-primary"onclick="window.location.href='/TestManagement/ListDocuments?docket_id=<%: ViewData["docket_id"]%>&assignment_id=<%: ViewData["assignment_id"]%>'"/>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
<script type="text/javascript">
    function docheck() {
        var score = 0;
        $(".correct").each(function () {
            if ($(this).find(">:first-child").attr("checked") == "checked") {
                $(this).css("background-color", "#77ff77");
                score = score + 1;
            }
            else {
                $(this).css("background-color", "#ff7777");
                score = score - 1;
            }
            $(this).find(">:first-child").attr("disabled", "disabled");
        });

        $(".incorrect").each(function () {
            if ($(this).find(">:first-child").attr("checked") == "checked") {
                $(this).css("background-color", "#ff5555");
                score = score - 1;
            }
            else {
                $(this).css("background-color", "#55ff55");
                score = score + 1;
            }
            $(this).find(">:first-child").attr("disabled","disabled");
        });
        $("#check_btn").css("visibility", "hidden");
        $("#go_btn").css("visibility", "visible");
        alert(score.toString());
    }
</script>
</asp:Content>
