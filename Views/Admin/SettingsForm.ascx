<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<% using (Html.BeginForm("SaveSettings", "Admin", FormMethod.Post))
   {%>
   <%--<table cellspacing="10px" cellpadding="5px" style="width:100%;">
    <tr>
        <th colspan="2">
            <b>Email server : </b>
        
        </td>
    </tr>
    <tr>
        <td  colspan="2">
            <b>Host : </b><input name="email_host" type="text" value="<%:ViewData["email_host"] %>" />
            <b>Post : </b><input maxlength="4" style="width:40px;" name="email_port" type="text" value="<%:ViewData["email_port"] %>" />
            <b>SSL : </b><select name="email_ssl" style="width:70px;" >
                <option value="True" <%: ViewData["email_ssl"].Equals("True")?"selected='selected'":"" %>>True</option>
                <option value="False" <%: ViewData["email_ssl"].Equals("False")?"selected='selected'":"" %>>False</option>
            </select>
        </td>
    </tr>
    
    
    <tr>
        <td style="text-align:right">
            <b>Email id : </b>
        </td>
        <td>
            <input name="email_id" type="text" value="<%:ViewData["email_id"] %>" />
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Password : </b>
        </td>
        <td>
            <input name="email_password" type="password" value="<%:ViewData["email_password"] %>" />
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Email CC : </b>
        </td>
        <td>
            <textarea name="email_cc" rows="3" style="resize:none;"><%:ViewData["email_cc"] %></textarea>
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Email Sender Name : </b>
        </td>
        <td>
            <input name="email_sender" type="text" value="<%:ViewData["sender_name"] %>" />
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <center>
                <input type="submit" value="            Submit              " class="btn-success btn" />
            </center>
        </td>
    </tr>
</table>--%>
<table cellspacing="10px" cellpadding="5px" style="margin:0 125px 0 125px;">
    <tr>
        <td style="text-align:right">
            <b>Email server : </b>
        </td>
        <td>
            <input name="email_host" type="text" value="<%:ViewData["email_host"] %>" />
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Email server port : </b>
        </td>
        <td>
            <input maxlength="4" name="email_port" type="text" value="<%:ViewData["email_port"] %>" />
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Use SSL : </b>
        </td>
        <td>
            <select name="email_ssl">
                <option value="True" <%: ViewData["email_ssl"].Equals("True")?"selected='selected'":"" %>>True</option>
                <option value="False" <%: ViewData["email_ssl"].Equals("False")?"selected='selected'":"" %>>False</option>
            </select>
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Email id : </b>
        </td>
        <td>
            <input name="email_id" type="text" value="<%:ViewData["email_id"] %>" />
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Password : </b>
        </td>
        <td>
            <input name="email_password" type="password" value="<%:ViewData["email_password"] %>" />
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Display Name : </b>
        </td>
        <td>
            <input name="email_sender" type="text" value="<%:ViewData["sender_name"] %>" />
        </td>
    </tr>
    <tr>
        <td style="text-align:right">
            <b>Email CC : </b>
        </td>
        <td>
            <textarea name="email_cc" rows="3" style="resize:none;"><%:ViewData["email_cc"] %></textarea>
        </td>
    </tr>
    
    <tr>
        <td colspan="2">
            <center>
                <input type="submit" value="            Submit              " class="btn-success btn" />
            </center>
        </td>
    </tr>
</table>
<%} %>
