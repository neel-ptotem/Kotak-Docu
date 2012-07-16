<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>module_i</title>

    <script type="text/javascript">
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

    
  </script>
</head>
<body>
<form id="form-module-5" method="get" action="UpdateProgress">
    <input class="module-5" type="hidden" name="module_id" value="<%:ViewData["module_id"]%>" />
    <input class="module-5" type="hidden" name="student_id" value="<%:ViewData["student_id"]%>" />
    <input id="module-5-time-spend" class="module-5" type="hidden" name="time_spend" value="" />
    <input name="1" class="module-5-section-1" type="hidden" value="<%:ViewData["1"] %>" />
    <input name="2" class="module-5-section-2" type="hidden" value="<%:ViewData["2"] %>" />
    <input name="3" class="module-5-section-3" type="hidden" value="<%:ViewData["3"] %>" />
    <input name="4" class="module-5-section-4" type="hidden" value="<%:ViewData["4"] %>" />
    <input name="5" class="module-5-section-5" type="hidden" value="<%:ViewData["5"] %>" />
    <input name="6" class="module-5-section-6" type="hidden" value="<%:ViewData["6"] %>" />
    <input name="7" class="module-5-section-7" type="hidden" value="<%:ViewData["7"] %>" />
    <input name="8" class="module-5-section-8" type="hidden" value="<%:ViewData["8"] %>" />
    <input name="9" class="module-5-section-9" type="hidden" value="<%:ViewData["9"] %>" />
    <input name="10" class="module-5-section-10" type="hidden" value="<%:ViewData["10"] %>" />
    <input name="11" class="module-5-section-11" type="hidden" value="<%:ViewData["11"] %>" />
    <input name="12" class="module-5-section-12" type="hidden" value="<%:ViewData["12"] %>" />
    <input name="13" class="module-5-section-13" type="hidden" value="<%:ViewData["13"] %>" />
    <input name="14" class="module-5-section-14" type="hidden" value="<%:ViewData["14"] %>" />
    <input name="15" class="module-5-section-15" type="hidden" value="<%:ViewData["15"] %>" />
    <input name="16" class="module-5-section-16" type="hidden" value="<%:ViewData["16"] %>" />
</form>
<br/>
<br/>
<h1 style="margin-left:50px;color:black;">The Product Tutorials</h1>  
<br/>
<div class="tj_nav">
    <span id="tj_next" class="tj_next">Next</span>
    <span id="tj_prev" class="tj_prev">Prev</span>
</div>
<div id="tj_container" class="tj_container">
    <div class="tj_wrapper">
        <ul class="tj_gallery" style="list-style:none">
            <li><a class="section" id="module-5-section-1" href="#"><img src="/Content/images/pimg/mediumterm.jpeg" alt="image02" /></a></li>
            <li><a class="section" id="module-5-section-2" href="#"><img src="/Content/images/pimg/bridge.jpeg" alt="image03" /></a></li>
            <li><a class="section" id="module-5-section-3" href="/Content/html_pages/products/ShortTermLoan/ShortTermLoan.html"><img src="/Content/images/pimg/stl.jpeg" alt="image01" /></a></li>
            <li><a class="section" id="module-5-section-4" href="#"><img src="/Content/images/pimg/droplineod.jpeg" alt="image05" /></a></li>
            <li><a class="section" id="module-5-section-5" href="#"><img src="/Content/images/pimg/fcy.jpg" alt="image06" /></a></li>
            <li><a class="section" id="module-5-section-6" href="#"><img src="/Content/images/pimg/portfolio.jpeg" alt="image07" /></a></li>
            <li><a class="section" id="module-5-section-7" href="#"><img src="/Content/images/pimg/gateway.jpg" alt="image08" /></a></li>
            <li><a class="section" id="module-5-section-8" href="#"><img src="/Content/images/pimg/lease.jpg" alt="image09" /></a></li>
            <li><a class="section" id="module-5-section-9" href="#"><img src="/Content/images/pimg/overdraft.jpeg" alt="image10" /></a></li>
            <li><a class="section" id="module-5-section-10" href="#"><img src="/Content/images/pimg/pofinance.jpg" alt="image11" /></a></li>
            <li><a class="section" id="module-5-section-11" href="#"><img src="/Content/images/pimg/commodity.jpeg" alt="image04" /></a></li>
            <li><a class="section" id="module-5-section-12" href="#"><img src="/Content/images/pimg/project.jpeg" alt="image12" /></a></li>
            <li><a class="section" id="module-5-section-13" href="#"><img src="/Content/images/pimg/promofunding.jpeg" alt="image13" /></a></li>
            <li><a class="section" id="module-5-section-14" href="#"><img src="/Content/images/pimg/trade.jpeg" alt="image14" /></a></li>
            <li><a class="section" id="module-5-section-15" href="#"><img src="/Content/images/pimg/wcdl.jpeg" alt="image15" /></a></li>
            <li><a class="section" id="module-5-section-16" href="#"><img src="/Content/images/pimg/wctl.jpeg" alt="image16" /></a></li>
        </ul>
    </div>
</div>

<!-- <div id="product-menu"> 
    <a href="/assets/products/ShortTermLoan/ShortTermLoan.html">Short Term Loan</a> 
    <a href="/">Long Term Loan</a> 
    <a href="/">Project Loan</a> 
    <a href="/">Bridge Loan</a> 
    <a href="/">Working Capital Term Loan</a> 
    <a href="/">Working Capital Demand Loan</a> 
    <a href="/">Purchase Order Financing</a> 
    <a href="/">CC/Overdraft</a> 
    <a href="/">Commodity Funding</a> 
    <a href="/">Promoter Funding</a> 
    <a href="/">Portfolio Buyouts</a> 
    <a href="/">Lease Rental Discounting</a> 
    <a href="/">Foreign Currency Term Loan</a> 
    <a href="/">Drop Line Overdraft</a> 
    <a href="/">Single Payment Gateway</a> 
    <a href="/">Trade Advance</a> 
-->
<!-- </div>  -->

</body>
</html>



