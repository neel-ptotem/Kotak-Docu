using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;

namespace KotakDocuMentor.Controllers
{
    public class ResultManagementController : Controller
    {
        private DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
        //
        // GET: /ResultManagement/

        public ActionResult LandingPage()
        {
            //List<Assignment> assignments = DocumentorDB.Assignments.ToList();
            //int[] doc_score=new int[assignments.Count];
            //foreach (Assignment a in assignments)
            //{
            //    List<Docucheck> docuchecks = a.Docuchecks.ToList();
            //    foreach (Docucheck d in docuchecks)
            //    {
            //        doc_score[a.id] = 0;
            //    }
            //}
            //ViewData["assignments"] = assignments;
            //ViewData["doc_score"] = doc_score;
            //return View(assignments);
            return View();
        }

        [HttpPost]
        public ActionResult ViewActionResult()
        {
         //   ViewData["assignment"] = DocumentorDB.Assignments.Where(a => a.id == Int32.Parse(Request.Params["documrnt_id"])).First();
            return View();
        }



    }
}
