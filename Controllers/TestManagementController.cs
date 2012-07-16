using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;

namespace KotakDocuMentor.Controllers
{
    public class TestManagementController : Controller
    {
        private ElearningDBDataContext ElearningDB = new ElearningDBDataContext();
        private DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();

        [HttpGet]
        public ActionResult index()
        {
            Student student = DocumentorDB.Students.Where(s => s.id.Equals(Request.Params["student_id"])).First();
            List<CaseStudy> case_studies = DocumentorDB.CaseStudies.Where(cs => cs.Assignments.Where(a => a.student_id.Equals(student.id)).Count() > 0 || cs.active.Equals(true)).ToList();
            List<Assignment> assignments = new List<Assignment>();
            foreach (CaseStudy cs in case_studies)
            {
                if (cs.Assignments.Where(a => a.student_id.Equals(student.id)).Count() > 0)
                    assignments.Add(cs.Assignments.Where(a => a.student_id.Equals(student.id)).First());
                else
                {
                    Assignment a = new Assignment();
                    a.student_id = student.id;
                    a.case_study_id = cs.id;
                    a.level_id = cs.level_id ?? DocumentorDB.Levels.First().id;
                    a.iscomplete = false;
                    a.istest = true;
                    a.ispractice = false;
                    DocumentorDB.Assignments.InsertOnSubmit(a);
                    DocumentorDB.SubmitChanges();
                    if (cs.CaseStudyDockets.Count > 0 || cs.CaseStudyDocuments.Count > 0)
                    {
                        a.create_docuchecks();
                    }
                    assignments.Add(a);
                }
            }
            return View(assignments);
        }

        [HttpGet]
        public ActionResult GetStatus()
        {
            int status = 0;
            int student_id = int.Parse(Request.Params["student_id"]);

            //Active Practice
            if (DocumentorDB.Assignments.Where(a => a.student_id.Equals(student_id) && a.istest == false && a.iscomplete != true).ToList().Count > 0)
            {
                status = 1;
            }

            //Active test
            if (DocumentorDB.Assignments.Where(a => a.student_id.Equals(student_id) && a.istest == true && a.iscomplete == false).ToList().Count > 0)
            {
                status = 2;
            }

            ViewData["status"] = status;
            return View();
        }


        [HttpGet]
        public ActionResult Documentor()
        {
            int student_id = DocumentorDB.Students.Where(a => a.id.Equals(Request.Params["student_id"])).First().id;
            Assignment assignment;
            //If assignment exists
            if (DocumentorDB.Assignments.Where(a => a.student_id == student_id && a.istest.Equals(true) && a.iscomplete != true).ToList().Count != 0)
                assignment = DocumentorDB.Assignments.Where(a => a.student_id == student_id && a.istest.Equals(true) && a.iscomplete != true).First();
            else //If assignment doesn't exists
            {
                Assignment a_new = new Assignment();
                a_new.student_id = student_id;
                CaseStudy new_case_study = DocumentorDB.CaseStudies.Where(cs => cs.active == true).First();
                a_new.case_study_id = new_case_study.id;
                a_new.level_id = new_case_study.level_id??DocumentorDB.Levels.First().id;
                a_new.istest = true;
                DocumentorDB.Assignments.InsertOnSubmit(a_new);
                DocumentorDB.SubmitChanges();
                assignment = DocumentorDB.Assignments.Where(a => a.id== a_new.id).First();
                assignment.create_docuchecks();
            }
            return RedirectToAction("PlayQuiz", new { assignment_id = assignment.id });
            
        }

        public struct QuestionAnswers
        {
            // private DocumentorDBDataContext db = new DocumentorDBDataContext();
            public int question_id;
            public string question_content;
            public int question_type;
            public List<AnswerChoice> options;

            public QuestionAnswers(int id, string content, int q_type, List<AnswerChoice> options)
            {
                //Question q=db.Questions.Where(a=>a.id==id_v).First();
                this.question_id = id;
                this.question_content = content;
                this.question_type = q_type;
                this.options = options;
            }
        }


        [HttpGet]
        public ActionResult PlayQuiz()
        {
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id == Int32.Parse(Request.Params["assignment_id"])).First();
            Quiz quiz = DocumentorDB.Quizs.Where(a => a.id == assignment.CaseStudy.CaseStudyQuizs.First().quiz_id).First();
            var quiz_questions = new Dictionary<int, QuestionAnswers>();
            List<Response> responses = new List<Response>();
            foreach (Question q in quiz.QuizQuestions.Select(a => a.Question).ToList())
            {
                quiz_questions.Add(q.id, new QuestionAnswers(q.id, q.question_content, q.question_type_id??0, q.AnswerChoices.ToList()));
                Response r = new Response();
                r.assignment_id = assignment.id;
                r.question_id = q.id;
                responses.Add(r);
            }
            ViewData["assignment"] = assignment;
            ViewData["quiz"] = quiz;
            //ViewData["quiz_questions"] = quiz.QuizQuestions.Select(a => a.Question).ToList();
            ViewData["quiz_questions"] = quiz_questions;
            ViewData["responses"] = responses;
            ViewData["time_alloted"] = 30;
            return View();
        }

        [HttpPost]
        public ActionResult SaveQuizData()
        {
            Quiz quiz = DocumentorDB.Quizs.Where(a => a.id == Int32.Parse(Request.Params["quiz_id"])).First();
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id == Int32.Parse(Request.Params["assignment_id"])).First();
            List<Question> quiz_questions = quiz.QuizQuestions.Select(a => a.Question).ToList();
            foreach (Question q in quiz_questions)
            {
                if (Request.Params[q.id.ToString()] != null)
                {
                    Response resp = new Response();
                    resp.question_id = q.id;
                    resp.assignment_id = assignment.id;
                    resp.response_content = Request.Params[q.id.ToString()];
                    DocumentorDB.Responses.InsertOnSubmit(resp);
                }
            }
            DocumentorDB.SubmitChanges();
            //assignment.calculate_quiz_score();
            //quiz.score = score;
            //DocumentorDB.SubmitChanges();
            Random r = new Random();
            List<Docket> dockets = DocumentorDB.Dockets.ToList();
            int docket_index = r.Next(dockets.Count);
            return RedirectToAction("ListDocuments", new { assignment_id = assignment.id, docket_id = dockets[docket_index].id });
            //return View();
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
        public ActionResult ListDockets()
        {
            ViewData["assignment_id"] = Request.Params["assignment_id"];
            int assignment_id = Int32.Parse(Request.Params["assignment_id"]);
            List<Docket> dockets = DocumentorDB.Dockets.ToList();
            var DocketList = new Dictionary<int, DocInfo>();
            foreach (Docket docket in dockets)
            {
                int id = docket.id;
                string name = docket.name;
                bool played = (docket.Docuchecks.Where(dkt => dkt.assignment_id == assignment_id).ToList().Count == docket.Docuchecks.Where(docucheck => docucheck.assignment_id == assignment_id && docucheck.played == true).ToList().Count);
                int score = docket.Docuchecks.Where(docucheck => docucheck.assignment_id == assignment_id).Select(a => a.score).Sum() ?? 0;
                DocketList.Add(docket.id, new DocInfo(id, name, played, score));
            }
            ViewData["DocketList"] = DocketList;
            //List<Docket> dockets = DocumentorDB.Dockets.Where(docket => docket.Docuchecks.Where(docucheck => docucheck.docket_id == docket.id && docucheck.played == true).ToList().Count == docket.Docuchecks.Where(docucheck => docucheck.docket_id == docket.id).ToList().Count).ToList();
            return View(dockets);
        }
        public struct DocketDocInfo
        {
            public string name;
            public string correct;
            public DocketDocInfo(string n, string c)
            {
                this.name = n;
                this.correct = c;
            }
        }

        [HttpGet]
        public ActionResult DocketDocumentsQuiz()
        {
            ViewData["assignment_id"] = Request.Params["assignment_id"];
            Docket docket = DocumentorDB.Dockets.Where(a => a.id == Int32.Parse(Request.Params["docket_id"])).First();
            List<Document> documents = DocumentorDB.Documents.ToList();
            var DOCheck = new Dictionary<int, DocketDocInfo>();
            foreach (Document doc in documents)
            {
                bool correct = docket.DocketDocuments.Where(a => a.document_id == doc.id).Count() == 1;
                DOCheck.Add(doc.id, new DocketDocInfo(doc.name, correct ? "correct" : "incorrect"));
            }
            //return RedirectToAction("ListDocuments", new { assignment_id = assignment.id,docket_id=docket.id });
            ViewData["record"] = DOCheck;
            ViewData["docket_id"] = docket.id;
            ViewData["docket_name"] = docket.name;
            return View();
        }


        [HttpGet]
        public ActionResult ListDocuments()
        {
            Assignment assignment=DocumentorDB.Assignments.Where(a=>a.id.Equals(Request.Params["assignment_id"])).First();
            ViewData["assignment"] = assignment.id;
            Docket docket = DocumentorDB.Dockets.Where(d => d.id.Equals(Request.Params["docket_id"])).First();
            List<DocketDocument> docket_documents = docket.DocketDocuments.OrderBy(dd=>dd.sequence_no).ToList();
            List<Docucheck> docuchecks = new List<Docucheck>();
            foreach (DocketDocument dd in docket_documents)
            {
                if (dd.reference_document != true)
                {
                    docuchecks.Add(DocumentorDB.Docuchecks.Where(a => a.assignment_id.Equals(assignment.id) && a.docket_id.Equals(docket.id) && a.document_id.Equals(dd.document_id)).First());
                }
            }
            //int status = 0;
            //foreach (Docucheck docucheck in docuchecks)
            //{
            //    if (docucheck.played == true)
            //    {
            //        status += 1;
            //        break;
            //    }
            //}
            //if (status == docuchecks.Count)
            //    return RedirectToAction("ListDockets", new { assignment_id = Request.Params["assignment_id"] });
            //else
            //{
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
            //}
        }

        [HttpGet]
        public ActionResult PlayDocumentTest()
        {
            Docucheck docucheck = DocumentorDB.Docuchecks.Where(a => a.id == Int32.Parse(Request.Params["docucheck_id"])).First();
            int sequence_number = Int32.Parse(Request.Params["sequence_number"]);
            Docket docket = docucheck.Docket;
            List<Document> reference_documents = docket.DocketDocuments.Where(a => a.reference_document == true).Select(b => b.Document).ToList();
            Document document = docucheck.Document;
            List<Page> pages = document.Pages.ToList();
            Page page = pages.Where(a => a.sequence_number == sequence_number).First();
            List<FilledSection> filled_sections = page.BlankSections.Select(a => a.FilledSections.Where(b => b.docucheck_id == docucheck.id).First()).ToList();
            ViewData["docucheck"] = docucheck;
            ViewData["docket"] = docket;
            ViewData["reference_documents"] = reference_documents;
            ViewData["document"] = document;
            ViewData["pages"] = pages;
            ViewData["page"] = page;
            ViewData["filled_sections"] = filled_sections;
            ViewData["sequence_number"] = sequence_number;
            ViewData["DocumentorDB"] = DocumentorDB;
            return View();
        }

        [HttpGet]
        public ActionResult SaveDocumentResults()
        {
            Docucheck docucheck = DocumentorDB.Docuchecks.Where(a => a.id == Int32.Parse(Request.Params["docucheck_id"])).First();
            Document document = docucheck.Document;
            Page page = document.Pages.Where(a => a.sequence_number == Int32.Parse(Request.Params["sequence_number"])).First();
            List<FilledSection> filled_sections = docucheck.FilledSections.Where(a => a.BlankSection.page_id == page.id).ToList();
            foreach (FilledSection filled_section in filled_sections)
            {
                filled_section.marked_correctly = Boolean.Parse(Request.Params[filled_section.id.ToString()] == "1" ? "true" : "false");
            }
            docucheck.played = true;
            DocumentorDB.SubmitChanges();
            docucheck.calculate_score();
            if (Int32.Parse(Request.Params["sequence_number"]) < document.Pages.Count)
                return RedirectToAction("PlayDocumentTest", new { docucheck_id = docucheck.id, sequence_number = Int32.Parse(Request.Params["sequence_number"]) + 1 });
            else
                return RedirectToAction("ListDocuments", new { assignment_id = docucheck.assignment_id, docket_id = docucheck.docket_id });
        }

      

        [HttpGet]
        public ActionResult ShowReferenceDocument()
        {

            Docucheck docucheck = DocumentorDB.Docuchecks.Where(a => a.docket_id == Int32.Parse(Request.Params["docket_id"]) && a.document_id == Int32.Parse(Request.Params["document_id"]) && (a.ReferenceSet.correct ?? false)).First();
            Document document = docucheck.Document;
            Page page = document.Pages.Where(a => a.sequence_number == int.Parse(Request.Params["seq_no"])).First();
            List<FilledSection> filled_sections = docucheck.FilledSections.ToList();
            ViewData["docket_id"] = Int32.Parse(Request.Params["docket_id"]);
            ViewData["document_id"] = Int32.Parse(Request.Params["document_id"]);
            ViewData["seq_no"] = int.Parse(Request.Params["seq_no"]) + 1;
            ViewData["filled_sections"] = filled_sections;
            ViewData["page"] = page;
            ViewData["islast"] = document.Pages.Where(a => a.sequence_number > int.Parse(Request.Params["seq_no"])).Count() > 0;
            return View();
        }
        [HttpPost]
        public ActionResult StartPractice()
        {
            CaseStudy case_study = DocumentorDB.CaseStudies.Where(a => a.id == Int32.Parse(Request.Params["case_study_id"])).First();
            Assignment assignment = new Assignment();
            assignment.student_id = DocumentorDB.Students.Where(a => a.username.Equals(Request.Params["student_id"])).First().id;
            assignment.case_study_id = case_study.id;
            DocumentorDB.Assignments.InsertOnSubmit(assignment);
            return (RedirectToAction("PlayQuiz", new { assignment_id = assignment.id }));
        }

        //
        // GET: /TestManagement/
        public struct ResultInfo
        {
            public string name;
            public double score;
            public int attempts;

            public ResultInfo(string name_v, double score_v, int att)
            {
                this.name = name_v;
                this.score = score_v;
                this.attempts = att;
            }
        }

        [HttpGet]
        public ActionResult UserStatistics()
        {
            //string student_id = Request.Params["student_id"];
            //List<Docket> dockets = DocumentorDB.Dockets.ToList();
            //List<Document> documents = DocumentorDB.Documents.ToList();
            //var DocketStatistics = new Dictionary<int, ResultInfo>();
            //var DocumentStatistics = new Dictionary<int, ResultInfo>();
            //foreach (Document doc in documents)
            //{
            //    double score=0;
            //    string name = doc.name;
            //    score += double.Parse(doc.Docuchecks.Where(a => a.played == true).Select(a => a.score??0).ToString());
            //    DocumentStatistics.Add(doc.id, new ResultInfo(doc.name, score, doc.Docuchecks.Where(a => a.played == true).ToList().Count));
            //}
            //foreach (Docket doc in dockets)
            //{
            //    double score = 0;
            //    string name = doc.name;
            //    score += double.Parse(doc.Docuchecks.Where(a => a.played == true).Select(a => a.score ?? 0).ToString());
            //    DocketStatistics.Add(doc.id, new ResultInfo(doc.name, score, doc.Docuchecks.Where(a => a.played == true).ToList().Count));
            //}
            //ViewData["DocketStat"] = DocketStatistics;
            //ViewData["DocuStat"] = DocumentStatistics;

            return View();
        }
        //
        // GET: /TestManagement/Details/5       

    }
}

