using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;
using System.IO;
//using Microsoft.Office.Core;
//using Excel = Microsoft.Office.Interop.Excel;

namespace KotakDocuMentor.Controllers
{

    public class StatisticController : Controller
    {
        //
        // GET: /TimeStatistic/
        DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
        
        public ActionResult Index()
        {
            return View();
        }
       
        public ActionResult AddRecord()
        {
            return View();
            //TimeStatistic time_statistic= new TimeStatistic();
            //int source_type = Int32.Parse(Request.Params["source_type"]);
            //int source_id = Int32.Parse(Request.Params["source_id"]);
            //float duration = float.Parse(Request.Params["duration"]);
            //if (DocumentorDB.TimeStatistics.Where(a => a.source_id == source_id && a.source_type == source_type && a.student_id.Equals(Request.Params["student_id"])).Any())
            //{
            //    time_statistic = DocumentorDB.TimeStatistics.Where(a => a.source_id == source_id && a.source_type == source_type && a.student_id.Equals(Request.Params["student_id"])).First();
            //    time_statistic.duration = time_statistic.duration + duration;
            //}
            //else
            //{
            //    time_statistic.student_id = Request.Params["student_id"];
            //    time_statistic.source_type = source_type;
            //    time_statistic.source_id = source_id;
            //    time_statistic.duration = duration;
            //}
            //DocumentorDB.TimeStatistics.InsertOnSubmit(time_statistic);
            //DocumentorDB.SubmitChanges();
        }

        public struct UserInfo
        {
            public string name;
            public string type;
            public int duration;
            public int score;
            public UserInfo(string n,bool t,int d,int s)
            {
                this.name= n;
                this.type= t?"Test" : "Practice";
                this.duration = d;
                this.score = s;
            }
        }

        public static void DownloadExcel(HttpResponse response)
        {
            response.Clear();
            response.Charset = "";

            // set MIME type to be Excel file.
            response.ContentType = "application/vnd.ms-excel";

            // add a header to response to force download (specifying filename)
            response.AddHeader("Content-Disposition", "attachment; filename=\"MyFile.xls\"");

            // Send the data. Tab delimited, with newlines.
            response.Write("Col1\tCol2\tCol3\tCol4\n");

            response.Write("Data 1\tData 2\tData 3\tData 4\n");
            response.Write("Data 1\tData 2\tData 3\tData 4\n");
            response.Write("Data 1\tData 2\tData 3\tData 4\n");
            response.Write("Data 1\tData 2\tData 3\tData 4\n");

            // Close response stream.
            response.End();

        } 

        
        public ActionResult UserStats()
        {
            var user_info = new Dictionary<int, UserInfo>();
            int student_id = int.Parse(Request.Params["student_id"]);
            List<Docucheck> records;
            if ((Request.Params["assignment_type"]).Equals(null))
            {
                List<int> assignment_ids = DocumentorDB.Assignments.Where(a => a.student_id.Equals(student_id)).Select(a => a.id).ToList();
                records = DocumentorDB.Docuchecks.Where(a => assignment_ids.Contains(a.assignment_id??0)).ToList();
            }
            else
            {
                List<int> assignment_ids = DocumentorDB.Assignments.Where(a => a.student_id.Equals(student_id) && a.istest.Equals(bool.Parse(Request.Params["isTest"])) && a.ispractice.Equals(bool.Parse(Request.Params["isPractice"]))).Select(a => a.id).ToList();
                records = DocumentorDB.Docuchecks.Where(a => assignment_ids.Contains(a.assignment_id ?? 0)).ToList();
            }
            if(Request.Params["document_id"]!=null)
            {
                records=records.Where(a=>a.document_id==Int32.Parse(Request.Params["document_id"])).ToList();
            }
            if(Request.Params["docket_id"]!=null)
            {
                records=records.Where(a=>a.document_id==Int32.Parse(Request.Params["document_id"])).ToList();
            }
            foreach (Docucheck record in records)
            {
                
            }
            return View();
        }

    }
}
