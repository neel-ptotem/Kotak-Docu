using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;

namespace KotakDocuMentor.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
        ElearningDBDataContext ElearningDB = new ElearningDBDataContext();
        
        [HttpGet]
        public ActionResult Index()
        {

            if (Request.Params["student_id"] != null)
            {
                string student_username=Request.Params["student_id"];
                Student student;
                if (DocumentorDB.Students.Where(a => a.username.Equals(student_username)).Count() > 0)
                {
                    student= DocumentorDB.Students.Where(a => a.username.Equals(student_username)).First();
                }
                else
                {
                    Student new_student = new Student();
                    Employee employee=ElearningDB.Employees.Where(a=>a.UserLoginName.Equals(student_username)).First();
                    new_student.username = employee.UserLoginName;
                    new_student.emp_id = employee.EmpId;
                    new_student.time_spend = 0;
                    new_student.person_id = employee.PERSON_ID;
                    new_student.first_visit = DateTime.Now;
                    DocumentorDB.Students.InsertOnSubmit(new_student);
                    DocumentorDB.SubmitChanges();
                    student = DocumentorDB.Students.Where(a => a.username.Equals(student_username)).First();
                    student.create_progress_tracker();
                }
                Employee emp = ElearningDB.Employees.Where(e => e.UserLoginName.Equals(student_username)).First();
                Session["student_id"] = emp.FirstName+" "+emp.LastName;
                if (student.Assignments.Where(a => a.iscomplete.Equals(false) && (int)a.time_spend < a.CaseStudy.duration).Count() > 0)
                {
                    int case_study_id=student.Assignments.Where(a => a.iscomplete!=true).First().case_study_id;
                    return RedirectToAction("GoToTest", "Test", new { student_id = student.id, case_study_id = case_study_id });
                }
                else
                {
                    ViewData["modules"] = DocumentorDB.Modules.ToList();
                    List<bool> module_status = new List<bool>();
                    List<Module> modules = DocumentorDB.Modules.ToList();
                    List<UserModuleTimeStatistic> user_time_stats = DocumentorDB.UserModuleTimeStatistics.Where(a => a.student_id.Equals(student.id)).ToList();
                    List<UserProgress> user_progress = DocumentorDB.UserProgresses.Where(a => a.student_id.Equals(student.id)).ToList();
                    int first_module_id = modules.First().id;
                    int selected_module_id = modules.First().id;
                    foreach (Module module in modules.OrderBy(a => a.id))
                    {
                        bool module_time_complete = user_time_stats.Where(a => a.module_id.Equals(module.id)).First().time_spend >= module.time_allocated;
                        bool module_sections_complete = user_progress.Where(a => a.module_id.Equals(module.id) && (a.isComplete == false || a.isComplete == null)).Count() == 0&&user_progress.Where(a => a.module_id.Equals(module.id)).Count()>0;
                        if (module_sections_complete || module_time_complete)
                            if (modules.Where(a => a.id > module.id).OrderBy(a => a.id).Count() > 0)
                                selected_module_id = modules.Where(a => a.id > module.id).OrderBy(a => a.id).First().id;
                            else
                                selected_module_id = module.id;
                    }
                    ViewData["selected_module_id"] = selected_module_id;
                    ViewData["selected_module_index"] = Array.IndexOf(modules.Select(m => m.id).OrderBy(m => m).ToArray(), selected_module_id) + 1;
                    ViewData["first_module_id"] = first_module_id;
                    ViewData["student_id"] = student.id;
                    ViewData["student_username"] = student_username;
                    return View();
                }
            }
            else
            {
                return View("Error");
            }
        }

        public ActionResult About()
        {
            return View();
        }

        [HttpGet]
        public ActionResult Doclauncher()
        {
            ViewData["documents"] = DocumentorDB.Documents.ToList();
            if (Request.Params["id"] != null)
            {

            }
            return View();
        }

        public struct CaseStudyInfo
        {
            public string name;
            public int attempts;
            public int a_score;
            public int m_score;
            public bool active;
            public bool incomplete_assignment;
            public int incomplete_assignment_id;
            public bool passed;
            public CaseStudyInfo(string name_v, int attempts_v, int score_v,int score_m,bool act,bool incomplete,int incomplete_id=0)
            {
                this.name = name_v;
                this.attempts = attempts_v;
                this.a_score = score_v;
                this.m_score = score_m;
                this.active = act;
                this.incomplete_assignment = incomplete;
                this.incomplete_assignment_id = incomplete_id;
                if (m_score >= 60)
                    this.passed = true;
                else
                    this.passed = false;
            }
        }

        [HttpGet]
        public ActionResult ListCaseStudies()
        {
            Student student = DocumentorDB.Students.Where(s => s.id.Equals(Request.Params["student_id"])).First();
            List<CaseStudy> case_studies = DocumentorDB.CaseStudies.Where(cs => cs.Assignments.Where(a => a.student_id.Equals(student.id)).Count() > 0 || cs.active.Equals(true)).ToList();
            var cs_info = new Dictionary<int, CaseStudyInfo>();
            foreach (CaseStudy cs in case_studies)
            {
                int score = 0;
                int attempts = 0;
                if (cs.Assignments.Where(a => a.student_id.Equals(student.id) && a.istest.Equals(true) && a.iscomplete.Equals(true)).Count() > 0)
                {
                    score = (int)cs.Assignments.Where(a => a.student_id.Equals(student.id) && a.istest.Equals(true) && a.iscomplete.Equals(true)).Average(a => a.score);
                    attempts = cs.Assignments.Where(a => a.student_id.Equals(student.id) && a.istest.Equals(true) && a.iscomplete.Equals(true)).Count();
                }
                string name = cs.name;
                bool act = cs.active??false;
                bool inc = cs.Assignments.Where(a => a.student_id.Equals(student.id) && a.istest.Equals(true) && a.iscomplete != true).Count() > 0;
                int max_score = 0;
                if(cs.Assignments.Where(a => a.student_id.Equals(student.id) && a.istest.Equals(true) && a.iscomplete.Equals(true)).Count()>0)
                    max_score = (int)cs.Assignments.Where(a => a.student_id.Equals(student.id) && a.istest.Equals(true) && a.iscomplete.Equals(true)).Max(a => a.score);
                if (inc)
                {
                    int inc_id = cs.Assignments.Where(a => a.student_id.Equals(student.id) && a.istest.Equals(true) && a.iscomplete != true).First().id;
                    cs_info.Add(cs.id, new CaseStudyInfo(cs.name,attempts,score,max_score,act,inc,inc_id));
                }
                else
                {
                    cs_info.Add(cs.id, new CaseStudyInfo(cs.name, attempts, score,max_score, act, inc));
                }
            }
            ViewData["CaseStudyList"] = cs_info;
            ViewData["student_id"] = student.id;
            return View();
        }

        [HttpGet]
        public ActionResult ListAttempts()
        {
            Student student = DocumentorDB.Students.Where(s => s.id.Equals(Request.Params["student_id"])).First();
            CaseStudy case_study = DocumentorDB.CaseStudies.Where(cs => cs.id.Equals(Request.Params["case_study_id"])).First();
            List<Assignment> assignments = case_study.Assignments.Where(a=>a.student_id.Equals(student.id)).OrderBy(a=>a.id).ToList();
            ViewData["student_id"] = student.id;
            ViewData["cs_name"] = case_study.name;
            return View(assignments);
        }

    }
}
