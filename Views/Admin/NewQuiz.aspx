<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Create
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Create new quiz</h2>
 <% using (Html.BeginForm("CreateQuiz", "Admin",FormMethod.Post, new { enctype = "multipart/form-data" }))
        {%>
        <table>
        <tr>
            <td>
                <b>Quiz type : </b>
            </td>
            <td>
                <select id="isonline" name="isonline">
                <option value="true">Online</option>
                <option value="false">Offline</option>
                </select>
            </td>
        </tr>

        <tr>
            <td>
                <b>Quiz difficulty level : </b>
            </td>
            <td>
                <select id="level_id" name="level_id">
                <option value="1">Level 1</option>
                <option value="2">Level 2</option>
                <option value="3">Level 3</option>
                <option value="4">Level 4</option>
                <option value="5">Level 5</option>
                </select>
            </td>
        </tr>

        <tr>
            <td>
                <b>Select excel file containing questions : </b>
            </td>
            <td>
                <input name="uploadFile" type="file" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <center>
                    <input type="submit" value="            Create              " class="btn-success"/>
                </center>
            </td>
        </tr>
        </table>
        
<%} %>
    

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptHolder" runat="server">
</asp:Content>
