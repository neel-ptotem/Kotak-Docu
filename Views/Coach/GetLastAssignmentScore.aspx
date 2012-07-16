<%@ Page Language="C#"%>

<script runat="server">    
private void Page_Load(object sender, EventArgs e)
{
    Response.Clear();
    Response.ClearHeaders();
    Response.ClearContent();
    Response.ContentType = "text/javascript";
    Response.Write(Request.Params["callback"]+"({'score':'"+Session["score"]+"'})");
    Response.End();
    Response.Flush();        
}
</script>
