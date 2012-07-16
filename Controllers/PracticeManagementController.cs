using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;
using KotakDocuMentor.Controllers;

namespace KotakDocuMentor.Controllers
{
    public class PracticeManagementController : Controller
    {
        private DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
        //
        // GET: /PracticeManagement/

        public ActionResult LandingPage(int student_id)
        {
            return View();//DocumentorDB.Assignments.Where(a=>a.student_id==student_id).ToList());
        }

        [HttpPost]
        public ActionResult ListPracticeDocuments()
        {
            //Assignment assignment = DocumentorDB.Assignments.Where(a => a.id == Int32.Parse(Request.Params["assignment_id"])).First();
            //List<Docucheck> docuchecks = assignment.Docuchecks.ToList();
            //return View(docuchecks);
            return View();
        }

        [HttpPost]
        public ActionResult PracticeDocument()
        {
            Docucheck docucheck = DocumentorDB.Docuchecks.Where(a => a.id == Int32.Parse(Request.Params["docucheck_id"])).First();
            Document document = DocumentorDB.Documents.Where(a => a.id == docucheck.document_id).First();
            List<FilledSection> filled_sections = docucheck.FilledSections.ToList();
            List<Page> pages = document.Pages.ToList();
            int current_page=0;
            if(Request.Params["sequence_number"]==null)
                current_page=Int32.Parse(Request.Params["sequence_number"]);
            ViewData["Page"]= pages[current_page];
            return View();
        }
        [HttpPost]
        public ActionResult PracticeResult()
        {
            //Docucheck docucheck = DocumentorDB.Docuchecks.Where(a => a.id == Int32.Parse(Request.Params["docucheck_id"])).First();
            //Document document = DocumentorDB.Documents.Where(a => a.id == docucheck.document_id).First();
            //List<FilledSection> filled_sections = docucheck.FilledSections.ToList();

            //foreach (FilledSection fs in filled_sections)
            //{
            //    PracticeFilledSection practice_filled_section = new PracticeFilledSection();
            //    practice_filled_section.filled_section_id = fs.id;
            //    practice_filled_section.answer_given = Boolean.Parse(Request.Params[fs.id.ToString()]);
            //    DocumentorDB.PracticeFilledSections.InsertOnSubmit(practice_filled_section);
            //    DocumentorDB.SubmitChanges();
            //}
            //if (Int32.Parse(Request.Params["current_page"]) < document.Pages.Count)
            //    return RedirectToAction("PracticeDocument", new { docucheck_id = docucheck.id, sequence_number = Int32.Parse(Request.Params["sequence_number"]) + 1 });
            //else
                return View();
                //return RedirectToAction("ListPracticeDocuments", new { assignment_id = docucheck.assignment_id});            
        }

    }
}
