<%@ Page Language="C#" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.IO" %>
<%@ import Namespace="System.Collections.Generic"%>
<script runat="server">    
private void Page_Load(object sender, EventArgs e)
{
    StringWriter sw = new StringWriter();
    sw.WriteLine("\"Col1\",\"Col2\",\"Col3\",\"Col4\"");
    for (int i = 1; i < 10; i++)
        sw.WriteLine(string.Format("\"{0}\",\"{1}\",\"{2}\",\"{3}\"", "Data " + i + "1", "Data " + i + "2", "Data " + i + "3", "Data " + i + "4"));
    Response.Clear();
    Response.ClearHeaders();
    Response.ClearContent();
    Response.AddHeader("Content-Disposition", "attachment; filename=MyFile.csv");
    Response.ContentType = "text/csv";
    Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");
    Response.Write(sw);
    Response.End();
    Response.Flush();        
}
</script>
