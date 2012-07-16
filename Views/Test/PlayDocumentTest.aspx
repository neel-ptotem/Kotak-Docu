<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	PlayDocumentTest
</asp:Content>
<asp:Content ID="Timer" ContentPlaceHolderID="TimerHolder" runat="server"><h2 style="width:225px;text-align:left;"><small> Time Remaining </small><span id="time_remaining">00:00</span></h2></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-header blocky" style="position:fixed; color:white;font-weight: bold;">
  <form id="docucheck_form" action="SaveDocumentResults">
  <% foreach(KotakDocuMentor.Models.FilledSection filled_section in ViewData["filled_sections"] as List<KotakDocuMentor.Models.FilledSection>){ %>
  <input type="hidden" name="<%:filled_section.id %>" id="<%:filled_section.id %>" value="1" />
  <% } %>
  <input type="hidden" name="docucheck_id" id="docucheck_id" value="<%:((KotakDocuMentor.Models.Docucheck)ViewData["docucheck"]).id %>" />
  <input type="hidden" name="sequence_number" id="sequence_number" value="<%: ViewData["sequence_number"] %>" />
  <input type="hidden" name="time_spend" id="time_spend" value="0" />
  <input type="submit" class="btn-success btn" id ="save_button"/>
  </form>
  <br />
  <br />
  <table style="margin-left:20px;">
  <tr>
  <td style="border:3px solid darkred;">
  <h2>Reference <br />Document</h2>
  </td></tr>
  <%foreach(KotakDocuMentor.Models.Document ref_doc in ViewData["reference_documents"] as List<KotakDocuMentor.Models.Document>){%>
 
  <tr><td style="border:3px solid darkred; background-color:White;">
  <%: Html.ActionLink("View "+ref_doc.name, "ShowReferenceDocument", new {docket_id=((KotakDocuMentor.Models.Docucheck)ViewData["docucheck"]).docket_id,document_id=ref_doc.id,seq_no=1},new { target="_blank" }) %>
      <br />
      <br />
      </td></tr>
  <% } %>
  </table>
  <br/>


  <br/>
</div>

<div class="row" style="text-align: center; background: grey">
  <div id="DocumentFrame" class="docuframe">

  
  <% foreach (KotakDocuMentor.Models.FilledSection filled_section in ViewData["filled_sections"] as List<KotakDocuMentor.Models.FilledSection>)
     { %>
<%// KotakDocuMentor.Models.DocumentorDBDataContext DocumentorDB = ViewData["DocumentorDB"] as KotakDocuMentor.Models.DocumentorDBDataContext; %>
      <% KotakDocuMentor.Models.BlankSection blank_section = filled_section.BlankSection; %>
      <% KotakDocuMentor.Models.Example example = filled_section.Example; %>
      <% if (example.is_image == true)
         { %>
          <img src="/Content/images/examples/<%: example.id%>/medium/<%: example.example_image_file_name%>" id="<%:filled_section.id%>" class=" btn-correct option_image" style="position :absolute;top :<%:blank_section.ypos+15%>px;left: <%:blank_section.xpos+70%>px; height:<%:blank_section.height%>px;width:<%:blank_section.width%>px;" alt=""/>
      <% } %>
      <% else
         { %>
          <p class="btn-correct option_image" id="<%= filled_section.id %>"style="position :absolute;z-index:5000;top :<%= blank_section.ypos+15%>px;left:<%=blank_section.xpos+70 %>px;width:<%=blank_section.width %>px;height:<%=blank_section.height %>px;"><%:MvcHtmlString.Create(example.text_content)%></p>
      <% } %>     
      <img src= "/Content/images/general/cross.jpeg" style="position :absolute;z-index:6000;top:<%:blank_section.ypos+15%>px;left:<%:blank_section.xpos+70%>px;visibility:hidden;background:transparent" class="<%:filled_section.id%>" height="32px" width="32px" alt="close"/>
      <% } %>
  </div>

</div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">

<script type="text/javascript">

    $(function () {
        var remaining_time = 0;
        var time_spend = 0;
        $.get("/Test/get_remaining_time", { assignment_id: '<%:ViewData["assignment_id"]%>' }, function (data) {
            remaining_time = data;
            var remaining_sec = remaining_time - time_spend;
            hrs = parseInt((remaining_time - time_spend) / 3600);
            mins = parseInt(((remaining_time - time_spend) % 3600) / 60);
            secs = parseInt(((remaining_time - time_spend) % (3600 * 60)) % 60);
            $("#time_remaining").html(hrs.toFixed() + ":" + mins.toFixed() + ":" + secs.toFixed());
        });
        time_updater = setInterval(function () { update_time_spend(); }, 1000);
        $("#docucheck_form").submit(function () {
            $(this).find("#time_spend").attr("value", time_spend);
            return true;
        });


        function update_time_spend() {
            time_spend = time_spend + 1;
            var remaining_sec = remaining_time - time_spend;
            hrs = parseInt((remaining_time - time_spend) / 3600);
            mins = parseInt(((remaining_time - time_spend) % 3600) / 60);
            secs = parseInt(((remaining_time - time_spend) % (3600 * 60)) % 60);
            $("#time_remaining").html(hrs + ":" + mins + ":" + secs);
            if (time_spend >= remaining_time) {
                clearInterval(time_updater);
                $("#docucheck_form").submit();
            }
        }
        $(".option_image").click(function (event) {

            //if the image is marked correct..mark it incorrect
            if ($(this).attr("class").search("btn-correct") != -1) {
                $("." + $(this).attr("id")).css("visibility", "visible");
                $("." + $(this).attr("id")).css("background", "transparent");
                $(this).removeClass("btn-correct");
                //   $(this).css("background","red");
                $("#" + $(this).attr("id")).attr("value", "0");

            }

            //if the image is incorrect...mark is correct
            else {
                $(this).addClass("btn-correct");
                $("." + $(this).attr("id")).css("visibility", "hidden");
                //   $(this).css("background","transparent");
                $("#" + $(this).attr("id")).attr("value", "1");
            }


        });

    });

</script>

    <style type="text/css">
        .content {
            background: gray;
        }

       .page-header 
       {
         position: fixed;
         height: 600px;
         width: 180px;
         overflow: auto;
         margin:0;
         padding:20px;
         margin-left: -20px;
         text-align: center;
         font-weight: bold;
}

        .docuframe 
        {
            background-color:ThreeDShadow;
            border-radius:20px;
            width: 900px;
            height: 1080px;
            margin: 0px auto;
            margin-top: 20px;
            background-image: url("/Content/images/blank_forms/<%:((KotakDocuMentor.Models.Page)ViewData["page"]).id %>/medium/<%:((KotakDocuMentor.Models.Page)ViewData["page"]).blank_form_file_name %>");
            background-repeat: no-repeat;
        }

        .component_icon {
            cursor: pointer;
        }

        .selected_icon {
            margin-left: 30px;
        }

        .selectiondiv {
            position: absolute;
            zIndex: 5000;
            border: 1px solid black
        }
    </style>

</asp:Content>
