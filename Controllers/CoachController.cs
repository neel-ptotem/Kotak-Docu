using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;
using System.Net;
using System.Net.Mail;


namespace KotakDocuMentor.Controllers
{
    public class CoachController : Controller
    {
        DocumentorDBDataContext CoachDB = new DocumentorDBDataContext();
        ElearningDBDataContext EmpDB = new ElearningDBDataContext();

        [HttpGet]
        public ActionResult module_content()
        {
            //ViewData["body_content"]=CoachDB.Modules.Where(a => a.id.Equals(Request.Params["module_id"])).First().body_content;
            //ViewData["script_content"] = CoachDB.Modules.Where(a => a.id.Equals(Request.Params["module_id"])).First().script_content;
            Module module = CoachDB.Modules.Where(a => a.id.Equals(Request.Params["module_id"])).First();
            Student student = CoachDB.Students.Where(a => a.id.Equals(Request.Params["student_id"])).First();
            ViewData["module_id"] = module.id;
            ViewData["student_id"] = student.id;
            ViewData["progress_tracker"] = CoachDB.UserProgresses.Where(a => a.student_id == student.id && a.module_id == module.id).ToList();
            bool module_time_complete = true;
            bool module_sections_complete = true;
            if (CoachDB.Modules.Where(m => m.id < module.id).Count() > 0)
            {
                Module prev_module = CoachDB.Modules.Where(m => m.id < module.id).OrderByDescending(m => m.id).First();
                module_time_complete = CoachDB.UserModuleTimeStatistics.Where(a => a.student_id.Equals(student.id) && a.module_id.Equals(prev_module.id)).First().time_spend >= prev_module.time_allocated;
                module_sections_complete = student.UserProgresses.Where(a => a.module_id.Equals(prev_module.id) && (a.isComplete == false || a.isComplete == null)).Count() == 0 && student.UserProgresses.Where(a => a.module_id.Equals(prev_module.id)).Count()>0;
            }
            if (module_sections_complete || module_time_complete)
            {
                foreach (UserProgress up in student.UserProgresses.Where(u => u.module_id.Equals(module.id)))
                    ViewData[up.resource_no.ToString()] = up.isComplete.Equals(true) ? 1 : 0;
                return View("module_" + Request.Params["module_id"]);
            }
            else
                return View("module_content");
        }

        [HttpGet]
        public ActionResult Documentor()
        {
            Session["student_id"] = "Indraneel More";
            ViewData["modules"] = CoachDB.Modules.ToList();
            ViewData["student_id"] = Request.Params["student_id"];
            return View();
        }

        [HttpGet]
        public void UpdateProgress()
        {
            Student student = CoachDB.Students.Where(a => a.id.Equals(Request.Params["student_id"])).First();
            Module module = CoachDB.Modules.Where(a => a.id.Equals(Request.Params["module_id"])).First();
            List<UserProgress> user_progress_list = CoachDB.UserProgresses.Where(a => a.module_id == module.id && a.student_id == student.id).ToList();
            foreach (UserProgress user_progress in user_progress_list)
            {
                //user_progress.isComplete = true;
                if (Request.Params[user_progress.resource_no.ToString()] != null)
                {
                    bool resource_progress = Request.Params[user_progress.resource_no.ToString()].ToString().Contains("1") || Request.Params[user_progress.resource_no.ToString()].ToString().Contains("on");
                    if (resource_progress && user_progress.isComplete != true)
                        user_progress.isComplete = true;
                }
            }
            UserModuleTimeStatistic time_stat = CoachDB.UserModuleTimeStatistics.Where(a => a.student_id == student.id && a.module_id == module.id).First();
            time_stat.time_spend = int.Parse(Request.Params["time_spend"])/60 + time_stat.time_spend ?? 0;
            CoachDB.SubmitChanges();
            
        }

        [HttpGet]
        public string GetProgress()
        {
            Student student = CoachDB.Students.Where(a => a.id.Equals(Request.Params["student_id"])).First();
            List<Module> modules=CoachDB.Modules.ToList();
            int progress = 0;
            foreach(Module m in modules)
            {
                int total_module_sections = student.UserProgresses.Where(up=>up.module_id.Equals(m.id)).Count();
                if(total_module_sections>0)
                    progress=progress+((student.UserProgresses.Where(up=>up.module_id.Equals(m.id) && up.isComplete.Equals(true)).Count()*100)/(total_module_sections*modules.Count));
                else
                    progress=progress+(100/modules.Count);
            }
            return progress.ToString()+"%";
        }


        [HttpGet]
        public int GetTotalTime()
        {
            Student student = CoachDB.Students.Where(a => a.id.Equals(Request.Params["student_id"])).First();
            return student.time_spend;
        }

        [HttpGet]
        public string UpdateTotalTime()
        {
            Student student = CoachDB.Students.Where(a => a.id.Equals(Request.Params["student_id"])).First();
            int time_spend = student.time_spend;
            student.time_spend = time_spend + int.Parse(Request.Params["time_spend"])/60;
            CoachDB.SubmitChanges();
            if (time_spend<2400 && student.time_spend >= 2400)
            {
                SendMailToStudent(student);
            }
            return "Updated";
        }

        public void SendMailToStudent(Student student)
        {
            Employee employee = EmpDB.Employees.Where(e=>e.UserLoginName.Equals(student.username)||e.PERSON_ID.Equals(student.person_id)||e.EmpId.Equals(student.emp_id)).First();
            var fromAddress = new MailAddress("neel@ptotem.com", "LMS-ADMIN");
            var toAddress = new MailAddress(employee.Email, employee.FirstName+" "+employee.LastName);
            const string fromPassword = "p20o20e13";
            const string subject = "Checking system generated mail subject";
            const string body = "Checking system generated mail body";

            var smtp = new SmtpClient
            {
                Host = "mail.ptotem.com",
                Port = 26,
                EnableSsl = false,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
            };
            using (var message = new MailMessage(fromAddress, toAddress)
            {
                Subject = subject,
                Body = body
            })
            {
                smtp.Send(message);
            }
        }


        [HttpGet]
        public ActionResult GetLastAssignmentScore()
        {
            Student student = CoachDB.Students.Where(s => s.username.Equals(Request.Params["user_login_name"])).First();
            //Session["score"] = student.last_assignment_score??0;
            Session["score"] = 85;
            ViewData["score"]= "1234567";
            ViewData["fn_name"] = Request.Params["callback"];
            return View();
        }

        [HttpGet]
        public void SetLastAssignmentScore()
        {
            Student student = CoachDB.Students.Where(s => s.username.Equals(Request.Params["user_login_name"])).First();
            student.last_assignment_score = 100+(student.last_assignment_score ?? 0);
            CoachDB.SubmitChanges();
        }

        public ActionResult Index()
        {
            return View();
        }

    }
}
