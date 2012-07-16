using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;


namespace KotakDocuMentor.Controllers
{
    public class ReviewController : Controller
    {
        DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
        //
        // GET: /Review/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ReviewAssignment()
        {
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();
            if(assignment.CaseStudy.CaseStudyQuizs.Count>0)
                return RedirectToAction("ReviewQuiz", new { assignment_id = assignment.id });
            else
                return RedirectToAction("ListDocuments", new { assignment_id = assignment.id });
        }

        public struct QuizAnswers
        {
            // private DocumentorDBDataContext db = new DocumentorDBDataContext();
            public int question_id;
            public string question_content;
            public int question_type;
            public List<AnswerChoice> options;
            public string response;

            public QuizAnswers(int id, string content, int q_type, List<AnswerChoice> options, string resp)
            {
                //Question q=db.Questions.Where(a=>a.id==id_v).First();
                this.question_id = id;
                this.question_content = content;
                this.question_type = q_type;
                this.options = options;
                this.response = resp;
            }
        }

        [HttpGet]
        public ActionResult ReviewQuiz()
        {
            Assignment check = DocumentorDB.Assignments.Where(a => a.id.Equals(52)).First();
            check.score=check.get_final_score();
            DocumentorDB.SubmitChanges();
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();
            Quiz quiz = assignment.CaseStudy.CaseStudyQuizs.First().Quiz;
            var quiz_questions = new Dictionary<int, QuizAnswers>();
            foreach (Question q in quiz.QuizQuestions.Select(a => a.Question).ToList())
            {
                string resp="";
                if (DocumentorDB.Responses.Where(r => r.assignment_id.Equals(assignment.id) && r.question_id.Equals(q.id)).Count() > 0)
                {
                    resp = DocumentorDB.Responses.Where(r => r.assignment_id.Equals(assignment.id) && r.question_id.Equals(q.id)).First().response_content;
                }
                quiz_questions.Add(q.id, new QuizAnswers(q.id, q.question_content, q.question_type_id ?? 0, q.AnswerChoices.ToList(), resp));
            }
            ViewData["assignment"] = assignment.id;
            ViewData["student_id"] = assignment.student_id;
            ViewData["quiz_questions"] = quiz_questions;
            bool has_docucheck = assignment.CaseStudy.CaseStudyDockets.Count > 0 || assignment.CaseStudy.CaseStudyDocuments.Count > 0;
            ViewData["has_docucheck"] = has_docucheck;
            return View();
        }

        public struct DocInfo
        {
            public int id;
            public string name;
            public bool played;
            public int score;

            public DocInfo(int id_v, string name_v, bool played_v, int score_v)
            {
                this.id = id_v;
                this.name = name_v;
                this.played = played_v;
                this.score = score_v;
            }
        }

        [HttpGet]
        public ActionResult ListDocuments()
        {
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();
            ViewData["assignment"] = assignment;
            List<Docket> dockets = assignment.CaseStudy.CaseStudyDockets.Select(csd => csd.Docket).ToList();
            List<Docucheck> docuchecks = new List<Docucheck>();
            foreach (Docket docket in dockets)
            {                
                foreach (Document document in docket.DocketDocuments.Where(dd=>dd.reference_document!=true).OrderBy(dd => dd.sequence_no).Select(dd => dd.Document).ToList())
                {
                    docuchecks.Add(DocumentorDB.Docuchecks.Where(a => a.assignment_id.Equals(assignment.id) && a.docket_id.Equals(docket.id) && a.document_id.Equals(document.id)).First());
                }
            }
            var DocumentList = new Dictionary<int, DocInfo>();
            foreach (Docucheck docucheck in docuchecks)
            {
                int id = docucheck.id;
                string name = docucheck.Document.name;
                bool played = docucheck.played ?? false;
                int score = docucheck.score ?? 0;
                DocumentList.Add(docucheck.id, new DocInfo(id, name, played, score));
            }
            ViewData["DocumentList"] = DocumentList;
            return View(docuchecks);         
        }

        [HttpGet]
        public ActionResult ReviewDocumentTest()
        {
            Docucheck docucheck = DocumentorDB.Docuchecks.Where(a => a.id == Int32.Parse(Request.Params["docucheck_id"])).First();
            int sequence_number = 0;
            if (Request.Params["sequence_number"] != null)
                sequence_number = int.Parse(Request.Params["sequence_number"]);
            if (sequence_number < docucheck.Document.Pages.Count)
            {
                Page page = docucheck.Document.Pages.Where(a => a.sequence_number == sequence_number + 1).First();
                List<FilledSection> filled_sections = page.BlankSections.Select(a => a.FilledSections.Where(b => b.docucheck_id == docucheck.id).First()).ToList();
                ViewData["docucheck"] = docucheck;
                ViewData["page"] = page;
                ViewData["filled_sections"] = filled_sections;
                ViewData["sequence_number"] = sequence_number + 1;
                ViewData["DocumentorDB"] = DocumentorDB;
                return View();
            }
            else
            {
                return RedirectToAction("ListDocuments","Test", new { assignment_id = docucheck.assignment_id, docket_id = docucheck.docket_id });
            }
        }


    }
}
