<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<KotakDocuMentor.Models.Response>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	PlayRQuiz
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<%:ViewData["len"] %>
    <% foreach (KotakDocuMentor.Models.Response r in (List<KotakDocuMentor.Models.Response>)ViewData["responses"])
       { %>
    
       <%:r.Question.AnswerChoices.first().id %>
    
    <%} %>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>
