<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<KotakDocuMentor.Models.Question>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Create
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <% using (Html.BeginForm("Create", "Question",FormMethod.Post, new { enctype = "multipart/form-data" }))
        {%>
        <select id="isonline" name="isonline">
        <option value="true">Online</option>
        <option value="false">Offline</option>
        </select>

        <select id="level_id" name="level_id">
        <option value="1">Level 1</option>
        <option value="2">Level 2</option>
        <option value="3">Level 3</option>
        <option value="4">Level 4</option>
        <option value="5">Level 5</option>
        </select>

        <input name="uploadFile" type="file" />
        <input type="submit" value="Create" />
<%} %>
    

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>
