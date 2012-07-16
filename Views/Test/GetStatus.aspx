<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ActiveTest
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>ActiveTest</h2>
    <%: ViewData["status"] %>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
<script type="text/javascript" src="../../Scripts/jquery.ba-postmessage.js" language="javascript"></script>
<script type="text/javascript">
    $(document).ready(function() {        
    $.postMessage("<%: ViewData["status"]  %>", 'http://localhost:90', parent);
    });
  
</script>
</asp:Content>
