<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Documentor
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<div class="row-fluid" style="background: #870c09;">
    <div class="span4">
    <br/>

    <img src="/Content/images/general/logo.png" class="span4"/>
    <img src="/Content/images/general/hourglass.gif" style="margin-top:50px"/>

    <div style="margin-top: -110px;margin-left: 120px;color:white;font-size: 18px">20:36 Hours <br/> elapsed<br/><br/>
        <a href="/TestManagement/Documentor?student_id=<%:ViewData["student_id"] %>&isTest=true&isPractice=false" class="btn btn-warning btn-large">Take the Quiz</a>
    </div>
    </div>
    <div class="span8">
        <div class="slider" style="float:right;margin-bottom:0">
           <ol>
           <% foreach (KotakDocuMentor.Models.Module module in ViewData["modules"] as List<KotakDocuMentor.Models.Module>)
              { %>
                <li id="tes">
                    <h2><span id="test"><%:module.description %></span></h2>
                        <div class="module" id="module-<%:module.id %>"></div>
                </li>
            <%} %>
            </ol>
        </div>
    </div>
</div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
<script type="text/javascript" src="/Scripts/javascripts/exclusions/jquery.easing.1.3.js" language="javascript"></script>
    <script type="text/javascript" src="/Scripts/javascripts/exclusions/jQuery.radmenu.js" language="javascript"></script>
    <script type="text/javascript" src="/Scripts/javascripts/exclusions/liteaccordion.jquery.min.js" language="javascript"></script>
    <script type="text/javascript" src="/Scripts/javascripts/exclusions/svgvml.js" language="javascript"></script>
    <script type="text/javascript" src="/Scripts/javascripts/exclusions/jquery.gridnav.js" language="javascript"></script>
    <link href="/Scripts/stylesheets/liteaccordion.css" rel="stylesheet" type="text/css" />
    <link href="/Scripts/stylesheets/gridNavigation.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(function () {
    var session_start=new Date();
    var module_start,module_end;
    module_start=new Date();

//    alert("<%=Session["student_id"] %>");
    <% foreach (KotakDocuMentor.Models.Module module in ViewData["modules"] as List<KotakDocuMentor.Models.Module>)
      { %>          
            $("#module-<%:module.id %>").load("/Coach/module_content?student_id="+<%:ViewData["student_id"]%>+"&module_id="+<%:module.id %>);        
    <%} %>

    function module_time_spend()
    {
           module_end=new Date();
           var time_spend=Math.round((module_end-module_start)/1000);
           module_start=new Date();
           return time_spend;

    }

    $("h2").click(function(){
        if ($(this).hasClass("selected")==false)
        {
            $(".selected").parent().find("form").submit();
            var module_content_div=$(this).parent().children("div");
            var module_id=module_content_div.attr("id");
            module_id=module_id.charAt(module_id.length-1);
            module_content_div.html("");
            module_content_div.load("/Coach/module_content?student_id="+<%:ViewData["student_id"]%>+"&module_id="+module_id,function(){
                if(module_id==2 || module_id==5 || module_id==6)
                {
                    $('.section').click(function(){$("."+$(this).attr("id")).attr("value","1");});
                }
                $('#form-module-'+module_id).submit(function(){
                $('#module-'+module_id+"-time-spend").attr("value",module_time_spend());
                    var formdata = $(this).serialize();
                    $.ajax({
                        type: "GET",
                        url: "/Coach/UserProgress",
                        data: formdata,
                    });
                    return false;
                });                
            });
     
        }
    });
    
    $('#tj_container').gridnav({
            rows: 4,
            type: {
                mode: 'sequpdown',  // use def | fade | seqfade | updown | sequpdown | showhide | disperse | rows
                speed: 400,      // for fade, seqfade, updown, sequpdown, showhide, disperse, rows
                easing: '',     // for fade, seqfade, updown, sequpdown, showhide, disperse, rows 
                factor: 50,     // for seqfade, sequpdown, rows
                reverse: false     // for sequpdown
            }
        });

        $('.slider').liteAccordion({
            containerWidth: 720, // fixed (px)
            containerHeight: 580, // fixed (px)
            headerWidth: 40, // fixed (px)

            activateOn: 'click', // click or mouseover
            firstSlide: 1, // displays slide (n) on page load
            slideSpeed: 300, // slide animation speed
            onTriggerSlide: function () {
            }, // callback on slide activate
            onSlideAnimComplete: function () {
            }, // callback on slide anim complete

            autoPlay: false, // automatically cycle through slides
            pauseOnHover: false, // pause on hover
            cycleSpeed: 6000, // time between slide cycles
            easing: 'swing', // custom easing function

            theme: 'basic', // basic, dark, light, or stitch
            rounded: true, // square or rounded corners
            enumerateSlides: false, // put numbers on slides
            linkable: false                        // link slides via hash
        });

        $("#radial_container").radmenu({
            listClass: 'list', // the list class to look within for items
            itemClass: 'item', // the items - NOTE: the HTML inside the item is copied into the menu item
            radius: 200, // radius in pixels
            animSpeed: 400, // animation speed in millis
            centerX: -330, // the center x axis offset
            centerY: -250, // the center y axis offset
            selectEvent: "click", // the select event (click)
            onSelect: function ($selected) { // show what is returned
                var themodalname = '#' + $selected.children(":first").attr("id") + '-modal';
                $(themodalname).modal('show');
            },
            angleOffset: 0 // in degrees
        });

        $("#radial_container").radmenu("show")

        $('.my_class').hover(
  function () {
      $(this).children(":last").hide();
      $(this).children(":first").show();
  },
  function () {
      $(this).children(":first").hide();
      $(this).children(":last").show();

  });

});
</script>
</asp:Content>
