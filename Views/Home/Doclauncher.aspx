<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Doclauncher
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


<div style="margin-top: 10px;margin:auto; padding-bottom:50px;">

  <div class="row-fluid">
    <div class="span4">
      <a href="#" class="btn btn-inverse" style="overflow:hidden;margin-top:50px;margin-left: 25px;height:250px;width:420px;border-radius: 20px;">
        <img src="/Content/images/general/family-papers-400.jpg" style="margin-left: 200px;margin-top:-10px;height:270px;width:270px">

        <div style="margin-top: -200px;margin-left: -120px;;color:#ffffff; font-size: 48px;">DocuPedia</div>
        <div style="margin-top: 30px;margin-left: 10px;width:180px;color:white; font-size: 18px;">
          Look through the database of documents to understand the whats and whys of documentation...
        </div>
      </a>
      <br>
      <br>
      <br>
      <h1 style="text-align:center">Choose a Document</h1>

    </div>
    <br>
    <div class="span7" style="height:360px;overflow:auto; margin-left:50px;padding:20px;">
      <ul style="line-height:0px;">
        <% foreach(KotakDocuMentor.Models.Document doc in ViewData["documents"] as List<KotakDocuMentor.Models.Document>){%>
        <li><a target='_blank' href="/Content/html_pages/documents/SanctionLetter.html"><%: doc.name %></a></li>
        
        <% } %>
      </ul>
    </div>
  </div>

</div>




</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
<link href="/Scripts/stylesheets/exclusions/anythingslider.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/Scripts/javascripts/exclusions/jquery.anythingslider.min.js" language="javascript"></script>
<script type="text/javascript" src="/Scripts/javascripts/exclusions/jquery.anythingslider.fx.min.js" language="javascript"></script>

<script type="text/javascript">
    $(function () {
        $(".chzn-select").chosen().change(function () {
        });
        $('#docgal').anythingSlider({
            vertical: true
        });
    });

    function goTo() {
        var sE = null, url;
        if (document.getElementById) {
            sE = document.getElementById('urlList');
        } else if (document.all) {
            sE = document.all['urlList'];
        }
        if (sE && (url = sE.options[sE.selectedIndex].value)) {
            location.href = url;
        }
    }
</script>

<style>
#slide {
  width: 640px;
  height: 500px;

}
li{
  padding:5px;
  border-radius:5px;
  line-height:24px;
  margin-bottom:3px;
  list-style-type:none;
  background: rgb(160,48,48); /* Old browsers */
  background: -moz-linear-gradient(-45deg,  rgb(169,3,41) 0%, rgb(143,2,34) 44%, rgb(109,0,25) 100%); /* FF3.6+ */
  background: -webkit-gradient(linear, left top, right bottom, color-stop(0%,rgb(169,3,41)), color-stop(44%,rgb(143,2,34)), color-stop(100%,rgb(109,0,25))); /* Chrome,Safari4+ */
  background: -webkit-linear-gradient(-45deg,  rgb(169,3,41) 0%,rgb(143,2,34) 44%,rgb(109,0,25) 100%); /* Chrome10+,Safari5.1+ */
  background: -o-linear-gradient(-45deg,  rgb(169,3,41) 0%,rgb(143,2,34) 44%,rgb(109,0,25) 100%); /* Opera 11.10+ */
  background: linear-gradient(-45deg,  rgb(169,3,41) 0%,rgb(143,2,34) 44%,rgb(109,0,25) 100%); /* W3C */
  */

}

a {
  font-size:18px;
  color:goldenrod;
  margin-left:10px;
}
a:visited{
  color:goldenrod;
}

a:hover{
  color:orange;
  font-weight:bolder;
  text-decoration:none;
  font-size:18px;
}

</style>


</asp:Content>
