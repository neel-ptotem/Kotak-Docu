<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>module_i</title>
    
    <script type="text/javascript">
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
  </script>
</head>
<body>
<span style="position:absolute;top:0; padding:20px; width:50px;font-size:18px;font-weight:bold;">Move your mouse over the circles</span>
<img src="/Content/images/general/cops.png" style="width:250px;margin-top:155px;margin-left:60px;" />
<style type="text/css">
a {
color:black;
}
</style>
<div>
<form id="form-module-2" method="get" action="/Coach/UpdateProgress">
    <input class="module-2" type="hidden" name="module_id" value="<%:ViewData["module_id"]%>" />
    <input class="module-2" type="hidden" name="student_id" value="<%:ViewData["student_id"]%>" />
    <input id="module-2-time-spend" class="module-2" type="hidden" name="time_spend" value="" />
    <div id='radial_container'>

    <ul class='list'>
    <li class='item'>
        <div class='my_class' id="llt">
        <div style="margin-left: 20px;"><br/><br/>
        <input name="1" class="module-2-section-1" type="hidden" value="0" />
        <a class="section" target="_blank" id="module-2-section-1" href="/Content/html_pages/divisions/SanctionLetterTeam/SanctionLetterTeam.html">Limit<br/> Loading <br/>Team</a>
        </div>
        <img src="/Content/images/general/llt.png" height="110" width="110" />
        </div>
    </li>
    <li class='item'>
        <div class='my_class' id="clt">
        <div style="margin-left: 20px;"><br/><br/><br/>
        <input name="2" class="module-2-section-2" type="hidden" value="0" />
        <a class="section" target="_blank" id="module-2-section-2" href="/Content/html_pages/divisions/SanctionLetterTeam/SanctionLetterTeam.html">Commercial Loans Team</a>
        </div>
        <img src="/Content/images/general/knowledge_off.png" height="110" width="110" />
        </div>
    </li>

    <li class='item'>
        <div class='my_class' id="dmt">
        <div style="margin-left: 30px;"><br/><br/><br/>
        <input name="3" class="module-2-section-3" type="hidden" value="0" />
        <a class="section" target="_blank" id="module-2-section-3" href="/Content/html_pages/divisions/SanctionLetterTeam/SanctionLetterTeam.html">Document Maintenance Team</a>
        </div>
        <img src="/Content/images/general/microfinance_off.png" height="110" width="110" />
        </div>
    </li>

    <li class='item'>
        <div class='my_class' id="eam">
        <div style="margin-left: 20px;"><br/><br/><br/>
        <input name="4" class="module-2-section-4" type="hidden" value="0" />
        <a class="section" target="_blank" id="module-2-section-4" href="/Content/html_pages/divisions/SanctionLetterTeam/SanctionLetterTeam.html">Escrow Accounts Maintenance</a>
        </div>
        <img src="/Content/images/general/business-consulting_off.png" height="110" width="110" />
        </div>
    </li>

    <li class='item'>
    </li>
    <li class='item'>
    </li>
    <li class='item'>
    </li>
    <li class='item'>
    </li>
    <li class='item'>
    </li>
    <li class='item'>
        <div class='my_class' id="slt">
        <div><br/><br/><br/>
        <input name="5" class="module-2-section-5" type="hidden" value="0" />
            <a class="section" target="_blank" id="module-2-section-5" href="/Content/html_pages/divisions/SanctionLetterTeam/SanctionLetterTeam.html">Sanction <br> Letter <br> Team</a>
        </div>
        <img src="/Content/images/general/technology_off.png" height="110" width="110" /></div>
        </li>
        <li class='item'>
        <div class='my_class' id="dvu">
            <div><br/><br/><br/>
            <input name="6" class="module-2-section-6" type="hidden" value="0" />
            <a class="section" target="_blank" id="module-2-section-6" href="/Content/html_pages/divisions/SanctionLetterTeam/SanctionLetterTeam.html">Documentation Verification Unit</a>
            </div>
            <img src="/Content/images/general/investment_banking_off.png"  height="110" width="110" />
        </div>
        </li>

    </ul>
    </div>
    <%--<input type="submit" class="btn-success" value="Save Progress" />--%>
    </form>
</div>

</body>
</html>



