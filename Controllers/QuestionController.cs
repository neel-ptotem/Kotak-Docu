using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.OleDb;
using System.IO;
using KotakDocuMentor.Models;

namespace KotakDocuMentor.Controllers
{
    public class QuestionController : Controller
    {
        //
        // GET: /Question/
        DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Question/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /Question/Create

        public ActionResult Create()
        {
           
            return View();
        } 

        //
        // POST: /Question/Create

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create(HttpPostedFileBase uploadFile)
        {
            string s=Request.Params["level_id"];
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
                string row_conn_string = "SELECT * FROM [Questions$]";
                OleDbConnection Excel_conn = new OleDbConnection(Excel_conn_string);
                OleDbCommand row_cmd = new OleDbCommand(row_conn_string, Excel_conn);
                try
                {
                    Quiz new_quiz = new Quiz();
                    new_quiz.isonline = bool.Parse(Request.Params["isonline"]);
                    new_quiz.level_id=int.Parse(Request.Params["level_id"]);
                    DocumentorDB.Quizs.InsertOnSubmit(new_quiz);
                    DocumentorDB.SubmitChanges();
                    Excel_conn.Open();
                    OleDbDataReader row = row_cmd.ExecuteReader();
                    while (row.Read())
                    {
                        int no_of_cols=row.FieldCount;
                        Question new_question=new Question();
                        new_question.question_content= row.GetValue(0).ToString();
                        int question_type = int.Parse(row.GetValue(11).ToString());
                        new_question.question_type_id=question_type;
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
                        else if (question_type == 2)
                            no_of_options = 2;
                        if (question_type == 1 || question_type == 2)
                        {
                            string all_options = "ABCD";
                            bool[] correct_options = { false, false, false, false };
                            int offset = 2;
                            for (int i = 0; i < no_of_options; i++)
                            {
                                AnswerChoice new_answer_choice = new AnswerChoice();
                                new_answer_choice.answer_content=row.GetValue(i + offset).ToString();
                                new_answer_choice.correct=all_options.ElementAt(i).ToString().Equals(row.GetValue(6).ToString());
                                new_answer_choice.question_id = new_question.id;
                                DocumentorDB.AnswerChoices.InsertOnSubmit(new_answer_choice);
                            }
                            DocumentorDB.SubmitChanges();
                        }
                        else if(question_type==3)
                        {
                            AnswerChoice new_answer_choice = new AnswerChoice();
                            new_answer_choice.answer_content = row.GetValue(7).ToString();
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
        
        //
        // GET: /Question/Edit/5
 
        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /Question/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here
 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Question/Delete/5
 
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Question/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here
 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
