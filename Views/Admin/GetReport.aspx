<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.IO" %>
<%@ import Namespace="System.Linq" %>
<%@ import Namespace="System.Collections.Generic"%>
<%@ import Namespace="KotakDocuMentor.Models"%>


<script type="text/javascript" runat="server">    
    
private void Page_Load(object sender, EventArgs e)
{
    
        
    //DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
    StringWriter sw = new StringWriter();
    sw.WriteLine("\"Col1\",\"Col2\",\"Col3\",\"Col4\"");
    for (int i = 1; i < 10; i++)
        sw.WriteLine(string.Format("\"{0}\",\"{1}\",\"{2}\",\"{3}\"", "Data " + i + "1", "Data " + i + "2", "Data " + i + "3", "Data " + i + "4"));
    //List<CaseStudy> case_studies=DocumentorDB.CaseStudies.ToList();
    //foreach(CaseStudy cs in case_studies)        
    //    sw.WriteLine(cs.name);
    sw.WriteLine(ViewData["sample"]);
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

