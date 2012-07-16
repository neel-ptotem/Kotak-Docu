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
    
    [Authorize(Users = "NEEL-PC\\Ptotem-Neel")]
    public class AdminController : Controller
    {
        //
        // GET: /Admin/

        private DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
        private ElearningDBDataContext ElearningDB = new ElearningDBDataContext();
        [HttpGet]
        public ActionResult ToggleStatus()
        {
            CaseStudy case_study = DocumentorDB.CaseStudies.Where(cs => cs.id.Equals(Request.Params["case_study_id"])).First();
            case_study.active = !(case_study.active ?? false);
            DocumentorDB.SubmitChanges();
            return RedirectToAction("Index");
        }


        public ActionResult check_case_study()
        {
            CaseStudy case_study = DocumentorDB.CaseStudies.Where(cs => cs.id.Equals(Request.Params["case_study_id"])).First();
            List<Assignment> assignments = case_study.Assignments.Where(a => a.iscomplete.Equals(true)).ToList();
            return View();
        }

        public void SendMail(int student_id,int assignment_id=0)
        {
            string sender_email_id = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_id")).First().val;
            string sender_name = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_sender")).First().val;
            string sender_password = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_password")).First().val;
            Student student = DocumentorDB.Students.Where(s => s.id.Equals(student_id)).First();
            string emp_id=student.emp_id;
            string person_id=student.person_id.ToString();
            Employee employee=ElearningDB.Employees.Where(e=>e.EmpId.Equals(emp_id) || e.PERSON_ID.Equals(person_id)).First();
            string receiver_email_id = employee.Email;
            string receiver_name = employee.FirstName + " " + employee.LastName;
            var fromAddress = new MailAddress(sender_email_id, sender_name);
            var toAddress = new MailAddress(receiver_email_id, receiver_name);
            string fromPassword = sender_password;
            string email_subject = "";
            string email_body = "";
            if (assignment_id == 0)
            {
                email_subject = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_subject_take_test")).First().val;
                email_body = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_body_take_test")).First().val.Replace("<<<name of the user>>>", employee.FirstName);
            }
            else
            {
                Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(assignment_id)).First();
                email_subject = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_subject_result")).First().val;
                if(assignment.score>=60)
                    email_body = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_body_result_pass")).First().val;
                else
                    email_body = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_body_result_fail")).First().val;
                email_subject = email_subject.Replace("<<<name of the user>>>", employee.FirstName).Replace("<<<Name / Number>>>", assignment.CaseStudy.name).Replace("<<<% score>>>", assignment.score.ToString() + "%");
                email_body = email_body.Replace("<<<name of the user>>>", employee.FirstName).Replace("<<<Name / Number>>>", assignment.CaseStudy.name).Replace("<<<% score>>>", assignment.score.ToString() + "%");
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

        [HttpPost]
        public ActionResult SaveSettings()
        {
            KotakSpecificData email_server = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_host")).First();
            KotakSpecificData email_id = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_id")).First();
            KotakSpecificData sender_name = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_sender")).First();
            KotakSpecificData email_password = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_password")).First();
            KotakSpecificData email_port = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_port")).First();
            KotakSpecificData email_ssl = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_ssl")).First();
            KotakSpecificData email_cc = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_cc")).First();

            email_server.val= Request.Params["email_host"];
            email_id.val= Request.Params["email_id"];
            sender_name.val= Request.Params["email_sender"];
            email_password.val= Request.Params["email_password"];
            email_port.val= Request.Params["email_port"];
            email_ssl.val= Request.Params["email_ssl"];
            email_cc.val= Request.Params["email_cc"];



            DocumentorDB.Students.First().last_assignment_score = 0;
            //DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_host")).First().val= "asdasd";// Request.Params["email_host"];
            //DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_id")).First().val= Request.Params["email_id"];
            //DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_sender")).First().val= Request.Params["email_sender"];
            //DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_password")).First().val= Request.Params["email_password"];
            //DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_port")).First().val= Request.Params["email_port"];
            //DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_ssl")).First().val= Request.Params["email_ssl"];
            //DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_cc")).First().val= Request.Params["email_cc"];

            DocumentorDB.SubmitChanges();

            return RedirectToAction("Index");

        }

        public ActionResult Index()
        {
           // SendMail(3);
           // SendMail(3,37);
            //SendMail(3,36);
            Session["student_id"] = "Admin";
            ViewData["x"] = User.Identity.Name;
            List<Student> students = DocumentorDB.Students.ToList();
            List<Employee> employees = new List<Employee>();
            foreach (Student student in students)
                employees.Add(ElearningDB.Employees.Where(e => e.UserLoginName.Equals(student.username) || e.PERSON_ID.Equals(student.person_id) || e.EmpId.Equals(student.emp_id)).First());
            List<string> divisions = employees.Select(e => e.Division).Distinct().ToList();
            List<CaseStudy> assignments = DocumentorDB.CaseStudies.Where(q => q.CaseStudyQuizs.First().Quiz.isonline == true).ToList();
            List<Level> levels = DocumentorDB.Levels.ToList();
            List<Quiz> case_studies = DocumentorDB.Quizs.Where(q => q.isonline == false).ToList();
            ViewData["divisions"] = divisions;
            ViewData["employees"] = employees;
            ViewData["case_studies"] = case_studies;
            ViewData["quizzes"] = assignments;
            ViewData["levels"] = levels;
            ViewData["email_host"] = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_host")).First().val;
            ViewData["email_id"] = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_id")).First().val;
            ViewData["sender_name"] = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_sender")).First().val;
            ViewData["email_password"] = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_password")).First().val;
            ViewData["email_port"] = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_port")).First().val;
            ViewData["email_ssl"] = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_ssl")).First().val;
            ViewData["email_cc"] = DocumentorDB.KotakSpecificDatas.Where(k => k.name.Equals("email_cc")).First().val;
            return View();
        }

        [HttpGet]
        public void GetNewReport()
        {

            List<Student> students = new List<Student>();
            List<CaseStudy> case_studies = new List<CaseStudy>();
            DataTable dt = new DataTable();
            string file_name = "Report";


            if (Request.Params["employee_id"] != null)
            {
                students.Add(DocumentorDB.Students.Where(a => a.username.Equals(Request.Params["employee_id"])).First());
                case_studies.AddRange(DocumentorDB.CaseStudies.Where(a => a.CaseStudyDockets.Count > 0).ToList());

                file_name = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(students.First().username)).Select(b => b.FirstName + " " + b.LastName).First() + DateTime.Now.ToShortDateString();

                dt.Columns.Add("Name of the User", typeof(string));
                dt.Columns.Add("Employee Details", typeof(string));
                dt.Columns.Add("Division", typeof(string));
                dt.Columns.Add("Date of first access to the module", typeof(DateTime));
                dt.Columns.Add("No. of hrs on learning", typeof(int));
                foreach (CaseStudy case_study in case_studies)
                    dt.Columns.Add(case_study.name, typeof(string));
                dt.Columns.Add("Aggregate", typeof(string));
                dt.Columns.Add("No. of tests attempted", typeof(int));
                dt.Columns.Add("No. of tests to go", typeof(int));

                foreach (Student student in students)
                {
                    DataRow new_row = dt.NewRow();
                    new_row[0] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.FirstName + " " + b.LastName).First();
                    new_row[1] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.EmpId).First();
                    new_row[2] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.Division).First();
                    new_row[3] = students.First().first_visit ?? DateTime.Now;
                    new_row[4] = students.First().time_spend / 60;
                    int index = 5;
                    int total_score = 0;
                    foreach (CaseStudy case_study in case_studies)
                    {
                        int score = 0;
                        student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Select(a => score = score + a.get_final_score());
                        if (student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Count() > 0)
                            new_row[index] = (score / student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Count()).ToString() + "%";
                        else
                            new_row[index] = "NA";
                        index = index + 1;
                        total_score = total_score + score;
                    }

                    int total_case_studies = DocumentorDB.CaseStudies.Count();
                    if (student.Assignments.Where(a => a.iscomplete == true).Count() > 0)
                        new_row[index] = ((int)(total_score / student.Assignments.Where(a => a.iscomplete == true).Count())).ToString() + "%";
                    else
                        new_row[index] = "NA";
                    int case_studies_attempted = DocumentorDB.CaseStudies.Where(a => a.Assignments.Where(b => b.student_id.Equals(students.First().id) && b.iscomplete != true).Count() > 0).Count();
                    new_row[index + 1] = case_studies_attempted;
                    new_row[index + 2] = total_case_studies - case_studies_attempted;
                    dt.Rows.Add(new_row);
                }

            }
            else if (Request.Params["division"] != null)
            {
                List<string> division_employees = ElearningDB.Employees.Where(a => a.Division.Equals(Request.Params["division"])).Select(a => a.UserLoginName).ToList();
                students.AddRange(DocumentorDB.Students.Where(a => division_employees.Contains(a.username)).ToList());
                case_studies.AddRange(DocumentorDB.CaseStudies.Where(a => a.CaseStudyDockets.Count > 0).ToList());
            }
            else if (Request.Params["quiz_id"] != null)
            {
                students.AddRange(DocumentorDB.Students.ToList());
                case_studies.Add(DocumentorDB.CaseStudies.Where(a => a.id.Equals(Request.Params["quiz_id"])).First());
            }
            else if (Request.Params["level_id"] != null)
            {
                students.AddRange(DocumentorDB.Students.ToList());
                case_studies.Add(DocumentorDB.CaseStudies.Where(a => a.id.Equals(Request.Params["level_id"])).First());
            }


            string attachment = "attachment; filename=city.xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/octet-stream";
            string tab = "";
            foreach (DataColumn dc in dt.Columns)
            {
                Response.Write(tab + dc.ColumnName);
                tab = "\t";
            }
            Response.Write("\n");
            int i;
            foreach (DataRow dr in dt.Rows)
            {
                tab = "";
                for (i = 0; i < dt.Columns.Count; i++)
                {
                    Response.Write(tab + dr[i].ToString());
                    tab = "\t";
                }
                Response.Write("\r\n");
            }
            Response.End();



            //Excel.ApplicationClass excel = new Excel.ApplicationClass();
            //Excel.Workbook workbook = excel.Application.Workbooks.Add(true); // true for object template???
            //// Add column headings...
            //int iCol = 0;
            //foreach (DataColumn c in dt.Columns)
            //{
            //    iCol++;
            //    excel.Cells[1, iCol] = c.ColumnName;
            //}
            //// for each row of data...
            //int iRow = 0;
            //foreach (DataRow r in dt.Rows)
            //{
            //    iRow++;
            //    // add each row's cell data...
            //    iCol = 0;
            //    foreach (DataColumn c in dt.Columns)
            //    {
            //        iCol++;
            //        excel.Cells[iRow + 1, iCol] = r[c.ColumnName];
            //    }
            //}
            //// Global missing reference for objects we are not defining...
            //object missing = System.Reflection.Missing.Value;
            //// If wanting to Save the workbook...
            //workbook.SaveAs("MyExcelWorkBook.xls",
            //    Excel.XlFileFormat.xlXMLSpreadsheet, missing, missing,
            //    false, false, Excel.XlSaveAsAccessMode.xlNoChange,
            //    missing, missing, missing, missing, missing);
            //// If wanting to make Excel visible and activate the worksheet...
            //excel.Visible = true;
            //Excel.Worksheet worksheet = (Excel.Worksheet)excel.ActiveSheet;
            //((Excel._Worksheet)worksheet).Activate();
            //// If wanting excel to shutdown...
            //((Excel._Application)excel).Quit();






        }

        [HttpGet]
        public void GetReport()
        {
            List<Student> students = new List<Student>();
            List<CaseStudy> case_studies = new List<CaseStudy>();
            DataTable dt = new DataTable();
            string file_name = "Report";


            if (Request.Params["employee_id"] != null)
            {
                students.Add(DocumentorDB.Students.Where(a => a.username.Equals(Request.Params["employee_id"])).First());
                case_studies.AddRange(DocumentorDB.CaseStudies.Where(a => a.CaseStudyDockets.Count > 0).ToList());

                file_name = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(students.First().username)).Select(b => b.FirstName + "_" + b.LastName).First() + "_" + DateTime.Now.ToShortDateString();

                dt.Columns.Add("Name of the User", typeof(string));
                dt.Columns.Add("Employee Details", typeof(string));
                dt.Columns.Add("Division", typeof(string));
                dt.Columns.Add("Date of first access to the module", typeof(DateTime));
                dt.Columns.Add("No. of hrs on learning", typeof(int));
                foreach (CaseStudy case_study in case_studies)
                    dt.Columns.Add(case_study.name, typeof(string));
                dt.Columns.Add("Aggregate", typeof(string));
                dt.Columns.Add("No. of tests attempted", typeof(int));
                dt.Columns.Add("No. of tests to go", typeof(int));

                foreach (Student student in students)
                {
                    DataRow new_row = dt.NewRow();
                    new_row[0] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.FirstName + " " + b.LastName).First();
                    new_row[1] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.EmpId).First();
                    new_row[2] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.Division).First();
                    new_row[3] = students.First().first_visit ?? DateTime.Now;
                    new_row[4] = students.First().time_spend / 60;
                    int index = 5;
                    int total_score = 0;
                    foreach (CaseStudy case_study in case_studies)
                    {
                        int score = 0;
                        student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Select(a => score = score + a.get_final_score());
                        if (student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Count() > 0)
                            new_row[index] = (score / student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Count()).ToString() + "%";
                        else
                            new_row[index] = "NA";
                        index = index + 1;
                        total_score = total_score + score;
                    }

                    int total_case_studies = DocumentorDB.CaseStudies.Count();
                    if (student.Assignments.Where(a => a.iscomplete == true).Count() > 0)
                        new_row[index] = ((int)(total_score / student.Assignments.Where(a => a.iscomplete == true).Count())).ToString() + "%";
                    else
                        new_row[index] = "NA";
                    int case_studies_attempted = DocumentorDB.CaseStudies.Where(a => a.Assignments.Where(b => b.student_id.Equals(students.First().id) && b.iscomplete != true).Count() > 0).Count();
                    new_row[index + 1] = case_studies_attempted;
                    new_row[index + 2] = total_case_studies - case_studies_attempted;
                    dt.Rows.Add(new_row);
                }

            }
            else if (Request.Params["division"] != null)
            {
                List<string> division_employees = ElearningDB.Employees.Where(a => a.Division.Equals(Request.Params["division"])).Select(a => a.UserLoginName).ToList();
                students.AddRange(DocumentorDB.Students.Where(a => division_employees.Contains(a.username)).ToList());
                case_studies.AddRange(DocumentorDB.CaseStudies.Where(a => a.CaseStudyDockets.Count > 0).ToList());

                file_name = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(students.First().username)).Select(b => b.FirstName + " " + b.LastName).First() + DateTime.Now.ToShortDateString();

                dt.Columns.Add("Division", typeof(string));
                dt.Columns.Add("Name of the User", typeof(string));
                dt.Columns.Add("Employee Details", typeof(string));
                dt.Columns.Add("Date of first access to the module", typeof(DateTime));
                dt.Columns.Add("No. of hrs on learning", typeof(int));
                foreach (CaseStudy case_study in case_studies)
                    dt.Columns.Add(case_study.name, typeof(string));
                dt.Columns.Add("Aggregate", typeof(string));
                dt.Columns.Add("No. of tests attempted", typeof(int));
                dt.Columns.Add("No. of tests to go", typeof(int));

                foreach (Student student in students)
                {
                    DataRow new_row = dt.NewRow();
                    new_row[0] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.Division).First();
                    new_row[1] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.EmpId).First();
                    new_row[2] = ElearningDB.Employees.Where(a => a.UserLoginName.Equals(student.username)).Select(b => b.FirstName + " " + b.LastName).First();
                    new_row[3] = students.First().first_visit ?? DateTime.Now;
                    new_row[4] = students.First().time_spend / 60;
                    int index = 5;
                    int total_score = 0;
                    foreach (CaseStudy case_study in case_studies)
                    {
                        int score = 0;
                        student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Select(a => score = score + a.get_final_score());
                        if (student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Count() > 0)
                            new_row[index] = (score / student.Assignments.Where(a => a.case_study_id.Equals(case_study.id) && a.iscomplete == true).Count()).ToString() + "%";
                        else
                            new_row[index] = "NA";
                        index = index + 1;
                        total_score = total_score + score;
                    }

                    int total_case_studies = DocumentorDB.CaseStudies.Count();
                    if (student.Assignments.Where(a => a.iscomplete == true).Count() > 0)
                        new_row[index] = ((int)(total_score / student.Assignments.Where(a => a.iscomplete == true).Count())).ToString() + "%";
                    else
                        new_row[index] = "NA";
                    int case_studies_attempted = DocumentorDB.CaseStudies.Where(a => a.Assignments.Where(b => b.student_id.Equals(students.First().id) && b.iscomplete != true).Count() > 0).Count();
                    new_row[index + 1] = case_studies_attempted;
                    new_row[index + 2] = total_case_studies - case_studies_attempted;
                    dt.Rows.Add(new_row);
                }


            }
            else if (Request.Params["case_study_id"] != null)
            {
                students.AddRange(DocumentorDB.Students.ToList());
                CaseStudy case_study = DocumentorDB.CaseStudies.Where(cs=>cs.id.Equals(Request.Params["case_study_id"])).First();
                List<string> student_emp_ids = DocumentorDB.Students.Select(s => s.emp_id).ToList();
                List<string> divisions = ElearningDB.Employees.Where(e => student_emp_ids.Contains(e.EmpId)).Select(e => e.Division).Distinct().ToList();
                dt.Columns.Add("Quiz", typeof(string));
                dt.Columns.Add("Division", typeof(string));
                dt.Columns.Add("No. of users", typeof(int));
                dt.Columns.Add("Users who have attempted the test", typeof(int));
                dt.Columns.Add("Successful users", typeof(int));
                dt.Columns.Add("Average score", typeof(int));
                foreach (string division in divisions)
                {
                    List<string> division_employee_ids = ElearningDB.Employees.Where(e => e.Division.Equals(division)).Select(e => e.EmpId).ToList();
                    List<Student> division_students = DocumentorDB.Students.Where(s => division_employee_ids.Contains(s.emp_id)).ToList();
                    int total_employees = division_students.Count;
                    int played_case_study = DocumentorDB.Assignments.Where(a => a.istest.Equals(true) && a.iscomplete.Equals(true) && division_students.Contains(a.Student)).Select(a=>a.Student).Distinct().Count();
                    int total_attempts = DocumentorDB.Assignments.Where(a => a.istest.Equals(true) && a.iscomplete.Equals(true) && division_students.Contains(a.Student)).Count();
                    int average_score = 0;
                    if (DocumentorDB.Assignments.Where(a => a.istest.Equals(true) && a.iscomplete.Equals(true) && division_students.Contains(a.Student)).Count()>0)
                        average_score += (int)((DocumentorDB.Assignments.Where(a => a.istest.Equals(true) && a.iscomplete.Equals(true) && division_students.Contains(a.Student)).Sum(s => s.score)) / total_attempts);
                    int successful_users = DocumentorDB.Assignments.Where(a => a.istest.Equals(true) && a.iscomplete.Equals(true) && a.score >= 60 && division_students.Contains(a.Student)).Count();
                    DataRow new_row = dt.NewRow();
                    new_row[0] = case_study.name;
                    new_row[1] = division;
                    new_row[2] = total_employees;
                    new_row[3] = played_case_study;
                    new_row[4] = successful_users;
                    new_row[5] = average_score;
                    dt.Rows.Add(new_row);
                }                
            }
            else if (Request.Params["level_id"] != null)
            {
                students.AddRange(DocumentorDB.Students.ToList());
                case_studies.Add(DocumentorDB.CaseStudies.Where(a => a.id.Equals(Request.Params["level_id"])).First());
            }

            StringWriter sw = new StringWriter();

            sw.WriteLine(string.Join("\t", dt.Columns.Cast<DataColumn>().Select(x => x.ColumnName).ToArray()));

            foreach (DataRow row in dt.Rows)
                sw.WriteLine(string.Join("\t", row.ItemArray));
            Response.Clear();
            Response.ClearHeaders();
            Response.ClearContent();
            Response.AddHeader("Content-Disposition", "attachment; filename=" + file_name + ".txt");
            Response.ContentType = "text";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");
            Response.Write(sw);
            Response.End();
            Response.Flush();


        }


        [HttpGet]
        public ActionResult CheckCaseStudies()
        {
            List<Assignment> assignments = DocumentorDB.Assignments.Where(a => a.CaseStudy.CaseStudyQuizs.Where(cs => cs.quiz_id.Equals(Request.Params["quiz_id"])).Count() > 0).ToList();
            if(assignments.Count>0)
                return RedirectToAction("CheckCaseStudy", new { assignment_id = assignments.First().id });
            else
                return RedirectToAction("Index");

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
        public ActionResult CheckCaseStudy()
        {
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();
            Quiz quiz = assignment.CaseStudy.CaseStudyQuizs.First().Quiz;
            var quiz_questions = new Dictionary<int, QuizAnswers>();
            foreach (Question q in quiz.QuizQuestions.Select(a => a.Question).ToList())
            {
                string resp = "";
                if (DocumentorDB.Responses.Where(r => r.assignment_id.Equals(assignment.id) && r.question_id.Equals(q.id)).Count() > 0)
                    resp = DocumentorDB.Responses.Where(r => r.assignment_id.Equals(assignment.id) && r.question_id.Equals(q.id)).First().response_content;
                quiz_questions.Add(q.id, new QuizAnswers(q.id, q.question_content, q.question_type_id ?? 0, q.AnswerChoices.ToList(), resp));
            }

            ViewData["assignment_id"] = assignment.id;
            ViewData["quiz_questions"] = quiz_questions;
            return View();
        }

        [HttpGet]
        public ActionResult submitCaseResult()
        {
            Assignment assignment = DocumentorDB.Assignments.Where(a => a.id.Equals(Request.Params["assignment_id"])).First();
            int score = int.Parse(Request.Params["score"]);
            assignment.score = score;
            DocumentorDB.SubmitChanges();
            return RedirectToAction("CheckCaseStudies", new { quiz_id = assignment.CaseStudy.CaseStudyQuizs.First().quiz_id });

        }


        [HttpGet]
        public ActionResult NewQuiz()
        {
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CreateCaseStudy(HttpPostedFileBase uploadFile)
        {
            string s = Request.Params["level_id"];
            string filePath;
            if (uploadFile.ContentLength > 0)
            {
                filePath = Path.Combine(HttpContext.Server.MapPath("../Uploads"),
                                               Path.GetFileName(uploadFile.FileName));
                uploadFile.SaveAs(filePath);
                //return View();
                string prjdir = (System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().CodeBase));
                prjdir = prjdir.Substring(6, prjdir.LastIndexOf('\\') - (1 + prjdir.Length - prjdir.LastIndexOf('\\')));
                string Excel_conn_string = "Provider=Microsoft.Jet.OleDb.4.0; data source=" + filePath + "; Extended Properties=Excel 8.0;";
                string row_conn_string = "SELECT * FROM [abc$]";
                OleDbConnection Excel_conn = new OleDbConnection(Excel_conn_string);
                OleDbCommand row_cmd = new OleDbCommand(row_conn_string, Excel_conn);
                try
                {
                    Quiz new_quiz = new Quiz();
                    new_quiz.isonline = false;
                    new_quiz.name = Request.Params["name"];
                    new_quiz.text_content = Request.Params["question"];
                    new_quiz.level_id = int.Parse(Request.Params["level_id"]);
                    DocumentorDB.Quizs.InsertOnSubmit(new_quiz);
                    DocumentorDB.SubmitChanges();

                    CaseStudy cs = new CaseStudy();
                    cs.name = Request.Params["name"];
                    //cs.briefing = Request.Params["briefing"];
                    cs.active = true;
                    cs.level_id = int.Parse(Request.Params["level_id"]);
                    cs.duration = int.Parse(Request.Params["hours"]) * 60 + int.Parse(Request.Params["minutes"]);
                    DocumentorDB.CaseStudies.InsertOnSubmit(cs);
                    DocumentorDB.SubmitChanges();

                    CaseStudyQuiz csq = new CaseStudyQuiz();
                    csq.case_study_id = cs.id;
                    csq.quiz_id = new_quiz.id;
                    DocumentorDB.CaseStudyQuizs.InsertOnSubmit(csq);
                    DocumentorDB.SubmitChanges();

                    Excel_conn.Open();
                    OleDbDataReader row = row_cmd.ExecuteReader();
                    row.Read();
                    while (row.Read())
                    {
                        int no_of_cols = row.FieldCount;
                        Question new_question = new Question();
                        new_question.question_content = row.GetValue(0).ToString();
                        int question_type = int.Parse(row.GetValue(2).ToString());
                        new_question.question_type_id = question_type;
                        DocumentorDB.Questions.InsertOnSubmit(new_question);
                        DocumentorDB.SubmitChanges();

                        QuizQuestion new_quiz_question = new QuizQuestion();
                        new_quiz_question.quiz_id = new_quiz.id;
                        new_quiz_question.question_id = new_question.id;
                        DocumentorDB.QuizQuestions.InsertOnSubmit(new_quiz_question);
                        DocumentorDB.SubmitChanges();
                        int no_of_options = 0;
                        if (question_type == 1)
                            no_of_options = 4;
                        else if (question_type == 3)
                            no_of_options = 2;
                        if (question_type == 1 || question_type == 3)
                        {
                            string all_options = "ABCD";
                            bool[] correct_options = { false, false, false, false };
                            int offset = 3;
                            for (int i = 0; i < no_of_options; i++)
                            {
                                AnswerChoice new_answer_choice = new AnswerChoice();
                                new_answer_choice.answer_content = row.GetValue(i + offset).ToString();
                                new_answer_choice.correct = all_options.ElementAt(i).ToString().Equals(row.GetValue(7).ToString());
                                new_answer_choice.question_id = new_question.id;
                                DocumentorDB.AnswerChoices.InsertOnSubmit(new_answer_choice);
                            }
                            DocumentorDB.SubmitChanges();
                        }
                        else if (question_type == 2)
                        {
                            AnswerChoice new_answer_choice = new AnswerChoice();
                            new_answer_choice.answer_content = row.GetValue(8).ToString();
                            new_answer_choice.correct = true;
                            new_answer_choice.question_id = new_question.id;
                            DocumentorDB.AnswerChoices.InsertOnSubmit(new_answer_choice);
                            DocumentorDB.SubmitChanges();
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
                finally
                {
                    Excel_conn.Dispose();
                }
            }
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CreateQuiz(HttpPostedFileBase uploadFile)
        {
            string s = Request.Params["level_id"];
            string filePath;
            if (uploadFile.ContentLength > 0)
            {
                filePath = Path.Combine(HttpContext.Server.MapPath("../Uploads"),
                                               Path.GetFileName(uploadFile.FileName));
                uploadFile.SaveAs(filePath);
                //return View();
                string prjdir = (System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().CodeBase));
                prjdir = prjdir.Substring(6, prjdir.LastIndexOf('\\') - (1 + prjdir.Length - prjdir.LastIndexOf('\\')));
                string Excel_conn_string = "Provider=Microsoft.Jet.OleDb.4.0; data source=" + filePath + "; Extended Properties=Excel 8.0;";
                string row_conn_string = "SELECT * FROM [abc$]";
                OleDbConnection Excel_conn = new OleDbConnection(Excel_conn_string);
                OleDbCommand row_cmd = new OleDbCommand(row_conn_string, Excel_conn);
                try
                {
                    Quiz new_quiz = new Quiz();
                    new_quiz.isonline = true;
                    new_quiz.name = Request.Params["name"];
                    new_quiz.level_id = int.Parse(Request.Params["level_id"]);
                    DocumentorDB.Quizs.InsertOnSubmit(new_quiz);
                    DocumentorDB.SubmitChanges();

                    CaseStudy cs = new CaseStudy();
                    cs.name = Request.Params["name"];
                    //cs.briefing = Request.Params["briefing"];
                    cs.active = true;
                    cs.level_id = int.Parse(Request.Params["level_id"]);
                    cs.duration = int.Parse(Request.Params["hours"]) * 60 + int.Parse(Request.Params["minutes"]);
                    DocumentorDB.CaseStudies.InsertOnSubmit(cs);
                    DocumentorDB.SubmitChanges();

                    CaseStudyQuiz csq = new CaseStudyQuiz();
                    csq.case_study_id = cs.id;
                    csq.quiz_id = new_quiz.id;
                    DocumentorDB.CaseStudyQuizs.InsertOnSubmit(csq);
                    DocumentorDB.SubmitChanges();

                    Excel_conn.Open();
                    OleDbDataReader row = row_cmd.ExecuteReader();
                    row.Read();
                    while (row.Read())
                    {
                        int no_of_cols = row.FieldCount;
                        Question new_question = new Question();
                        new_question.question_content = row.GetValue(0).ToString();
                        int question_type = int.Parse(row.GetValue(2).ToString());
                        new_question.question_type_id = question_type;
                        DocumentorDB.Questions.InsertOnSubmit(new_question);
                        DocumentorDB.SubmitChanges();

                        QuizQuestion new_quiz_question = new QuizQuestion();
                        new_quiz_question.quiz_id = new_quiz.id;
                        new_quiz_question.question_id = new_question.id;
                        DocumentorDB.QuizQuestions.InsertOnSubmit(new_quiz_question);
                        DocumentorDB.SubmitChanges();
                        int no_of_options = 0;
                        if (question_type == 1)
                            no_of_options = 4;
                        else if (question_type == 3)
                            no_of_options = 2;
                        if (question_type == 1 || question_type == 3)
                        {
                            string all_options = "ABCD";
                            bool[] correct_options = { false, false, false, false };
                            int offset = 3;
                            for (int i = 0; i < no_of_options; i++)
                            {
                                AnswerChoice new_answer_choice = new AnswerChoice();
                                new_answer_choice.answer_content = row.GetValue(i + offset).ToString();
                                new_answer_choice.correct = all_options.ElementAt(i).ToString().Equals(row.GetValue(7).ToString());
                                new_answer_choice.question_id = new_question.id;
                                DocumentorDB.AnswerChoices.InsertOnSubmit(new_answer_choice);
                            }
                            DocumentorDB.SubmitChanges();
                        }
                        else if (question_type == 2)
                        {
                            AnswerChoice new_answer_choice = new AnswerChoice();
                            new_answer_choice.answer_content = row.GetValue(8).ToString();
                            new_answer_choice.correct = true;
                            new_answer_choice.question_id = new_question.id;
                            DocumentorDB.AnswerChoices.InsertOnSubmit(new_answer_choice);
                            DocumentorDB.SubmitChanges();
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
                finally
                {
                    Excel_conn.Dispose();
                }
            }
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
