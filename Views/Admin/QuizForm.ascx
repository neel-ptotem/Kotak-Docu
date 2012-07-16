<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<% using (Html.BeginForm("CreateQuiz", "Admin", FormMethod.Post, new { enctype = "multipart/form-data" })){%>

<table style="border:0;">

<tr style="border:0;">
    <td style="border:0;">
        Name:
    </td>
    <td style="border:0;">
        <input type="text" name="name" />
    </td>
</tr>

<tr style="border:0;">
    <td style="border:0;">
        Upload Questions
    </td>
    <td style="border:0;">
        <input type="file" name="uploadFile" />
    </td>
</tr>
<tr style="border:0;">
    <td style="border:0;">
        Level:
    </td>
    <td style="border:0;">
        <select id="level_id" name="level_id">
            <% foreach (KotakDocuMentor.Models.Level level in ViewData["levels"] as List<KotakDocuMentor.Models.Level>)
               {%>
            <option value="<%= level.id %>">
                <%= level.name %>
            </option>
            <% } %>
        </select>
    </td>
</tr>
<tr style="border:0;">
    <td style="border:0;">
        Hours:
        <select name="hours" style="width: 80px;">
            <option>1</option>
            <option>2</option>
            <option>3</option>
            <option>4</option>
            <option>5</option>
            <option>6</option>
        </select>
    </td>
    <td style="border:0;">
        Minutes:
        <select name="minutes" style="width: 80px;">
            <option>00</option>
            <option>10</option>
            <option>20</option>
            <option>30</option>
            <option>40</option>
            <option>50</option>
        </select>
    </td>
</tr>
<tr style="border:0;">
    <td colspan=2 style="border:0;">
        <input type="hidden" name="isonline" value="true" />
        <center><input style="margin:15px 200px 5px 200px;" class="btn-success btn-large" type="submit" value="Submit" /></center>
    </td>
</tr>
</table>
<%} %>

