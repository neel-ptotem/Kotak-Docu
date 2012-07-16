<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Documentor_05Mar.Models.Docucheck>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Create
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Create</h2>

    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Fields</legend>
            
            <div class="editor-label">
                Assignment
            </div>
            <div class="editor-field">
                <%= Html.DropDownListFor(model => model.assignment_id, (IEnumerable<SelectListItem>)ViewData["assignments"]) %>
                <%: Html.ValidationMessageFor(model => model.assignment_id) %>
            </div>
            
            <div class="editor-label">
                Document
            </div>
            <div class="editor-field">
                <%= Html.DropDownListFor(model => model.document_id, (IEnumerable<SelectListItem>)ViewData["documents"]) %>
                <%: Html.ValidationMessageFor(model => model.document_id) %>
            </div>
            
            <div class="editor-label">
                Reference Set
            </div>
            <div class="editor-field">
                <%= Html.DropDownListFor(model => model.reference_set_id, (IEnumerable<SelectListItem>)ViewData["reference_sets"]) %>
                <%: Html.ValidationMessageFor(model => model.reference_set_id) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.score) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.score) %>
                <%: Html.ValidationMessageFor(model => model.score) %>
            </div>
            
            <p>
                <input type="submit" value="Create" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

