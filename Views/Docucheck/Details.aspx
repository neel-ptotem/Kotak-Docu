<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Documentor_05Mar.Models.Docucheck>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Details
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Details</h2>

    <fieldset>
        <legend>Fields</legend>
        
        <div class="display-label">id</div>
        <div class="display-field"><%: Model.Assignment.CaseStudy.name %></div>
        
        <div class="display-label">assignment_id</div>
        <div class="display-field"><%: Model.Assignment.User.fname+" "+Model.Assignment.User.lname %></div>
        
        <div class="display-label">document_id</div>
        <div class="display-field"><%: Model.Document.name %></div>
        
        <div class="display-label">reference_set_id</div>
        <div class="display-field"><%: Model.ReferenceSet.name %></div>
        
        <div class="display-label">score</div>
        <div class="display-field"><%: Model.score %></div>
        
    </fieldset>
    <p>

        <%: Html.ActionLink("Edit", "Edit", new { id=Model.id }) %> |
        <%: Html.ActionLink("Back to List", "Index") %>
    </p>

</asp:Content>

