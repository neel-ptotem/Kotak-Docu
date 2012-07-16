<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Home Page
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Welcome to DocuMentor</h2>
    <%: Html.ActionLink("Take Quiz", "Documentor", "TestManagement", new { employee_id = ViewData["emp_id"], istest = false, ispractice = false }, new { @class = "btn" })%>
    <br /><br /><br />
    <%: Html.ActionLink("Docucheck", "Documentor", "TestManagement", new { employee_id = ViewData["emp_id"], istest = false, ispractice = true }, new { @class = "btn" })%>
    
</asp:Content>
