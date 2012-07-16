using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.OleDb;
using System.Data;
using System.IO;
using KotakDocuMentor.Models;
using System.Net;
using System.Net.Mail;

namespace KotakDocuMentor.Controllers
{
    public class TestController : Controller
    {
        private ElearningDBDataContext ElearningDB = new ElearningDBDataContext();
        private DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();

        public int get_remaining_time()
        {
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();

            return (int)(assignment.CaseStudy.duration * 60 - assignment.time_spend * 60);
        }

        public void add_time_spend()
        {
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();
            float time_spend = float.Parse(Request.Params["time_spend"]) / 60;
            assignment.time_spend = assignment.time_spend + time_spend;
            DocumentorDB.SubmitChanges();
            if (assignment.time_spend >= assignment.CaseStudy.duration)
            {
                foreach (Docucheck dchk in assignment.Docuchecks.Where(d => d.played != true).ToList())
                {
                    dchk.played = true;
                    dchk.score = 0;
                    DocumentorDB.SubmitChanges();
                    DocketDocument dd = DocumentorDB.DocketDocuments.Where(d => d.docket_id.Equals(dchk.docket_id) && d.document_id.Equals(dchk.document_id)).First();
                    if (dd.reference_document != true)
                        dchk.calculate_score();
                }
            }

        }

        public struct CaseStudyInfo
        {
            public string name;
            public int attempts;
            public int score;

            public CaseStudyInfo(string name_v, int attempts_v, int score_v)
            {
                this.name = name_v;
                this.attempts = attempts_v;
                this.score = score_v;
            }
        }

        [HttpGet]
        public ActionResult Index()
        {
            Student student = DocumentorDB.Students.Where(s => s.id.Equals(Request.Params["student_id"])).First();
            List<CaseStudy> case_studies = DocumentorDB.CaseStudies.Where(cs => cs.Assignments.Where(a => a.student_id.Equals(student.id)).Count() > 0 || cs.active.Equals(true)).ToList();
            List<Assignment> assignments = new List<Assignment>();
            foreach (CaseStudy cs in case_studies)
            {
                string cs_name = cs.name;
                List<Assignment> cs_completed_assignments = cs.Assignments.Where(a => a.student_id.Equals(student.id) && a.iscomplete.Equals(true)).ToList();
                int cs_attempts = cs_completed_assignments.Count;
                int cs_score = (int)(cs_completed_assignments.Sum(a => a.score) / cs_completed_assignments.Count);
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
        public ActionResult GoToTest()
        {
            Student student = DocumentorDB.Students.Where(s => s.id.Equals(Request.Params["student_id"])).First();
            CaseStudy case_study = DocumentorDB.CaseStudies.Where(cs => cs.id.Equals(Request.Params["case_study_id"])).First();
            Assignment assignment;
            //If assignment exists
            if (student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.istest.Equals(true) && a.iscomplete != true).ToList().Count != 0)
                assignment = student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.istest.Equals(true) && a.iscomplete != true).First();
            else //If assignment doesn't exists
            {
                Assignment a_new = new Assignment();
                a_new.student_id = student.id;
                a_new.case_study_id = case_study.id;
                a_new.level_id = case_study.level_id ?? DocumentorDB.Levels.First().id;
                a_new.istest = true;
                DocumentorDB.Assignments.InsertOnSubmit(a_new);
                DocumentorDB.SubmitChanges();
                assignment = DocumentorDB.Assignments.Where(a => a.id == a_new.id).First();
                assignment.create_docuchecks();
            }
            if (assignment.CaseStudy.CaseStudyQuizs.Count > 0 && assignment.Responses.Count == 0)
                return RedirectToAction("PlayQuiz", new { assignment_id = assignment.id });
            else
                return RedirectToAction("ListDocuments", new { assignment_id = assignment.id });
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
                quiz_questions.Add(q.id, new QuestionAnswers(q.id, q.question_content, q.question_type_id ?? 0, q.AnswerChoices.ToList()));
                Response r = new Response();
                r.assignment_id = assignment.id;
                r.question_id = q.id;
                responses.Add(r);
            }
            ViewData["assignment"] = assignment;
            ViewData["assignment_id"] = assignment.id;
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
            if (quiz.isonline == true)
            {
                //assignment.calculate_quiz_score();
                //quiz.score = score;
                //DocumentorDB.SubmitChanges();
            }

            double total_time_spend = assignment.time_spend;
            assignment.time_spend = (total_time_spend * 60 + int.Parse(Request.Params["time_spend"])) / 60.0;
            DocumentorDB.SubmitChanges();
            if (assignment.CaseStudy.CaseStudyDockets.Count > 0 || assignment.CaseStudy.CaseStudyDocuments.Count > 0)
                return RedirectToAction("ListDocuments", new { assignment_id = assignment.id });
            else
            {
                assignment.iscomplete = true;
                assignment.score = assignment.get_final_score();
                assignment.Student.last_assignment_score = assignment.get_final_score();
                DocumentorDB.SubmitChanges();
                return RedirectToAction("ListCaseStudies", "Home", new { student_id = assignment.student_id });
            }

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
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();
            ViewData["assignment"] = assignment;
            List<Docket> dockets = assignment.CaseStudy.CaseStudyDockets.Select(csd => csd.Docket).ToList();
            List<Docucheck> docuchecks = new List<Docucheck>();
            foreach (Docket docket in dockets)
            {
                foreach (Document document in docket.DocketDocuments.Where(dd => dd.reference_document != true).OrderBy(dd => dd.sequence_no).Select(dd => dd.Document).ToList())
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
            ViewData["assignment_id"] = docucheck.Assignment.id;
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
        public ActionResult FinishAssignment()
        {
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();
            foreach (Docucheck dchk in assignment.Docuchecks.Where(dchk => DocumentorDB.DocketDocuments.Where(dd => dd.document_id.Equals(dchk.document_id) && dd.docket_id.Equals(dchk.docket_id)).First().reference_document != true))
            {
                dchk.played = true;
                DocumentorDB.SubmitChanges();
                dchk.calculate_score();
            }
            assignment.iscomplete = true;
            assignment.score = assignment.get_final_score();
            DocumentorDB.SubmitChanges();
            SendMail(assignment.student_id, assignment.id);
            return RedirectToAction("ListCaseStudies", "Home", new { student_id = assignment.student_id });
        }


        public void SendMail(int student_id, int assignment_id = 0)
        {
            string sender_email_id = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_id")).First().val;
            string sender_name = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_sender")).First().val;
            string sender_password = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_password")).First().val;
            Student student = DocumentorDB.Students.Where(s => s.id.Equals(student_id)).First();
            string emp_id = student.emp_id;
            string person_id = student.person_id.ToString();
            Employee employee = ElearningDB.Employees.Where(e => e.EmpId.Equals(emp_id) || e.PERSON_ID.Equals(person_id)).First();
            string receiver_email_id = employee.Email;
            string receiver_name = employee.FirstName + " " + employee.LastName;
            var fromAddress = new MailAddress(sender_email_id, sender_name);
            var toAddress = new MailAddress(receiver_email_id, receiver_name);
            string fromPassword = sender_password;
            string email_subject = "";
            string email_body = "";
            string email_cc = "";
            if (assignment_id == 0)
            {
                email_subject = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_subject_take_test")).First().val;
                email_body = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_body_take_test")).First().val.Replace("<<<name of the user>>>", employee.FirstName);
            }
            else
            {
                Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(assignment_id)).First();
                email_subject = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_subject_result")).First().val;
                if (assignment.score >= 60)
                    email_body = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_body_result_pass")).First().val;
                else
                    email_body = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_body_result_fail")).First().val;
                email_subject = email_subject.Replace("<<<name of the user>>>", employee.FirstName).Replace("<<<Name / Number>>>", assignment.CaseStudy.name).Replace("<<<% score>>>", assignment.score.ToString() + "%");
                email_body = email_body.Replace("<<<name of the user>>>", employee.FirstName).Replace("<<<Name / Number>>>", assignment.CaseStudy.name).Replace("<<<% score>>>", assignment.score.ToString() + "%");
                email_cc = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_cc")).First().val;
            }



            var smtp = new SmtpClient
            {
                Host = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_host")).First().val,
                Port = int.Parse(DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_port")).First().val),
                EnableSsl = bool.Parse(DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_ssl")).First().val),
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
            };
            MailMessage email = new MailMessage();
            email.Subject = email_subject;
            AlternateView body_html = AlternateView.CreateAlternateViewFromString(email_body, null, "text/html");
            email.AlternateViews.Add(body_html);
            //email.Body = email_body.Replace("<br/>", "\n");
            email.From = fromAddress;
            email.To.Add(toAddress);
            email.CC.Add("im.neel4u@gmail.com,indraneel.more@gmail.com,neel.ptotem@gmail.com");

            smtp.Send(email);

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
            double total_time_spend = docucheck.Assignment.time_spend;
            docucheck.Assignment.time_spend = (total_time_spend * 60 + int.Parse(Request.Params["time_spend"])) / 60.0;
            docucheck.Assignment.Student.time_spend = (docucheck.Assignment.Student.time_spend * 60 + int.Parse(Request.Params["time_spend"])) / 60;
            DocumentorDB.SubmitChanges();

            docucheck.played = true;
            DocumentorDB.SubmitChanges();
            if (docucheck.Assignment.time_spend < docucheck.Assignment.CaseStudy.duration)
            {
                if (Int32.Parse(Request.Params["sequence_number"]) < document.Pages.Count)
                    return RedirectToAction("PlayDocumentTest", new { docucheck_id = docucheck.id, sequence_number = Int32.Parse(Request.Params["sequence_number"]) + 1 });
                else
                {
                    docucheck.calculate_score();
                    DocumentorDB.SubmitChanges();
                    if (docucheck.Assignment.Docuchecks.Where(dchk => dchk.played != true).Count() == 0)
                        return RedirectToAction("FinishAssignment", new { assignment_id = docucheck.assignment_id });
                    else
                        return RedirectToAction("ListDocuments", new { assignment_id = docucheck.assignment_id });
                }
            }
            else
            {
                return RedirectToAction("FinishAssignment", new { assignment_id = docucheck.assignment_id });
            }

        }

        [HttpGet]
        public ActionResult ShowReferenceDocument()
        {

            Docucheck docucheck = DocumentorDB.Docuchecks.Where(a => a.docket_id == Int32.Parse(Request.Params["docket_id"]) && a.document_id == Int32.Parse(Request.Params["document_id"]) && (a.ReferenceSet.correct ?? false)).First();
            Document document = docucheck.Document;
            Page page = document.Pages.Where(a => a.sequence_number == int.Parse(Request.Params["seq_no"])).First();
            List<FilledSection> filled_sections = docucheck.FilledSections.Where(fs => fs.BlankSection.page_id.Equals(page.id)).ToList();
            ViewData["docket_id"] = Int32.Parse(Request.Params["docket_id"]);
            ViewData["document_id"] = Int32.Parse(Request.Params["document_id"]);
            ViewData["document_name"] = document.name;
            ViewData["seq_no"] = int.Parse(Request.Params["seq_no"]) + 1;
            ViewData["filled_sections"] = filled_sections;
            ViewData["page"] = page;
            ViewData["islast"] = document.Pages.Where(a => a.sequence_number > int.Parse(Request.Params["seq_no"])).Count() > 0;
            return View();
        }

    }
}

