using System;
using System.Collections.Generic;
using System.Linq;
namespace KotakDocuMentor.Models
{
    partial class CaseStudy
    {
    }

    partial class Student
    {
        private DocumentorDBDataContext DocumentorDBM = new DocumentorDBDataContext();
        public void create_progress_tracker()
        {
            List<Module> modules = DocumentorDBM.Modules.ToList();
            int total_sections = modules.Sum(x => x.no_of_sections ?? 0);
            List<UserProgress> modules_progress = new List<UserProgress>();
            List<UserModuleTimeStatistic> times_progress = new List<UserModuleTimeStatistic>();
            foreach (Module module in modules)
            {
                if (module.no_of_sections > 0)
                    for (int resource_no = 1; resource_no <= module.no_of_sections; resource_no++)
                    {
                        UserProgress module_progress = new UserProgress();
                        module_progress.student_id = this.id;
                        module_progress.module_id = module.id;
                        module_progress.resource_no = resource_no;
                        modules_progress.Add(module_progress);
                    }

                UserModuleTimeStatistic module_time_stat = new UserModuleTimeStatistic();
                module_time_stat.student_id = this.id;
                module_time_stat.module_id = module.id;
                module_time_stat.time_spend = 0;
                times_progress.Add(module_time_stat);

            }
            DocumentorDBM.UserProgresses.InsertAllOnSubmit(modules_progress);
            DocumentorDBM.UserModuleTimeStatistics.InsertAllOnSubmit(times_progress);
            DocumentorDBM.SubmitChanges();
        }
    }

    partial class Docucheck
    {
        private DocumentorDBDataContext DocumentorDBM = new DocumentorDBDataContext();
        public void create_filled_section()
        {

            if (this.FilledSections.Count == 0)
            {
                Document document = DocumentorDBM.Documents.Where(a => a.id == this.document_id).First();
                Assignment assignment = DocumentorDBM.Assignments.Where(a => a.id == this.assignment_id).First();
                CaseStudy case_study = assignment.CaseStudy;
                List<Page> pages = document.Pages.OrderBy(a => a.sequence_number).ToList();
                List<BlankSection> blank_sections = new List<BlankSection>();
                foreach (Page page in pages)
                {
                    blank_sections.AddRange(page.BlankSections);
                }
                foreach (BlankSection blank_section in blank_sections)
                {

                    FilledSection filled_section = new FilledSection();
                    filled_section.docucheck_id = this.id;
                    filled_section.blank_section_id = blank_section.id;
                    Component component = blank_section.Component;

                    //if the document is a reference document,everything should be correct

                    ReferenceSet reference_set;
                    if (DocumentorDBM.DocketDocuments.Where(a => a.docket_id == this.docket_id && a.document_id == this.document_id).First().reference_document.Equals(true))
                    {
                        reference_set = this.ReferenceSet;
                        //filled_section.has_no_error = true;
                    }
                    else
                    {
                        Random r_id = new Random();
                        int new_no = r_id.Next(100);
                        //decide what reference set to use
                        if (new_no > 75)
                        {
                            reference_set = this.ReferenceSet;
                            //filled_section.has_no_error = true;
                        }
                        else
                        {
                            reference_set = this.Docket.SuperSet.ReferenceSets.Where(a => a.id != this.reference_set_id).ToArray()[r_id.Next(this.Docket.SuperSet.ReferenceSets.ToList().Count - 1)];
                            //filled_section.has_no_error = false;
                        }

                    }

                    if (reference_set.correct == true && reference_set.id == this.reference_set_id)
                        filled_section.has_no_error = true;
                    else
                        filled_section.has_no_error = false;

                    List<Example> examples = DocumentorDBM.Examples.Where(a => a.reference_set_id == reference_set.id && a.component_id == component.id).ToList();
                    Example example;
                    if (examples.Count == 0)
                    {
                        example = DocumentorDBM.Examples.Where(a => a.reference_set_id == this.Docket.SuperSet.ReferenceSets.Where(b => b.name == "blank_set").First().id && a.component_id == component.id).First();
                        filled_section.has_no_error = false;
                    }
                    else
                    {
                        example = examples.First();
                    }
                    filled_section.example_id = example.id;
                    DocumentorDBM.FilledSections.InsertOnSubmit(filled_section);
                    DocumentorDBM.SubmitChanges();
                }
            }
        }

        public void calculate_score()
        {
            int score = 0;
            foreach (FilledSection filled_section in this.FilledSections)
            {
                if (filled_section.has_no_error.Equals(filled_section.marked_correctly))
                    score++;
            }
            score = score * 100 / this.FilledSections.Count;
            DocumentorDBM.Docuchecks.Where(dchk => dchk.id.Equals(this.id)).First().score = score + (this.score ?? 0);
            DocumentorDBM.SubmitChanges();
        }

    }



    partial class Assignment
    {
        private DocumentorDBDataContext DocumentorDBM = new DocumentorDBDataContext();

        public int get_max_quiz_score()
        {
            return this.CaseStudy.CaseStudyQuizs.First().Quiz.QuizQuestions.Count;
        }

        public int get_obtained_docucheck_score()
        {
            return (int)this.Docuchecks.Where(dchk => DocumentorDBM.DocketDocuments.Where(dd => dd.document_id.Equals(dchk.document_id) && dd.docket_id.Equals(dchk.docket_id)).First().reference_document != true).Average(dchk => dchk.score); ;
        }

        public int get_obtained_quiz_score()
        {
            int quiz_score = 0;
            foreach (Response r in this.Responses.ToList())
            {
                if (r.Question.AnswerChoices.Where(b => b.correct == true).Select(a => a.answer_content.ToLower()).Contains(r.response_content.ToLower()))
                    quiz_score = quiz_score + 1;
            }
            return (quiz_score*100) / this.CaseStudy.CaseStudyQuizs.First().Quiz.QuizQuestions.Count;
        }

        public int get_final_score()
        {
            if (this.Docuchecks.Count > 0)
                return (get_obtained_quiz_score() + get_obtained_docucheck_score()) / 2;
            else
                return get_obtained_quiz_score();
        }



        public void create_docuchecks()
        {
            CaseStudy case_study = this.CaseStudy;
            List<CaseStudyDocket> case_study_dockets = case_study.CaseStudyDockets.ToList();
            List<Docket> dockets = new List<Docket>();
            List<Document> documents = new List<Document>();
            foreach (CaseStudyDocket csd in case_study_dockets)
            {
                dockets.Add(csd.Docket);
            }
            foreach (Docket d in dockets)
            {
                foreach (DocketDocument dd in d.DocketDocuments.ToList())
                {
                    Docucheck dchk = new Docucheck();
                    dchk.assignment_id = this.id;
                    dchk.document_id = dd.document_id;
                    dchk.docket_id = dd.docket_id;
                    dchk.score = 0;
                    List<ReferenceSet> reference_sets = d.SuperSet.ReferenceSets.ToList();
                    if (reference_sets.Count(a => a.correct == true) > 1)
                    {
                        Random r_id = new Random();
                        dchk.reference_set_id = reference_sets.Where(a => a.correct == true).ToArray()[r_id.Next(reference_sets.Count(a => a.correct == true))].id;
                    }
                    else
                    {
                        dchk.reference_set_id = reference_sets.Where(a => a.correct == true).First().id;
                    }
                    if (dd.reference_document == true)
                        dchk.played = true;
                    else
                        dchk.played = false;
                    DocumentorDBM.Docuchecks.InsertOnSubmit(dchk);
                    DocumentorDBM.SubmitChanges();
                    dchk.create_filled_section();

                }
            }
        }


        public void create_docuchecks(int document_id, int docket_id)
        {
            Docket docket = DocumentorDBM.Dockets.Where(dkt => dkt.id == docket_id).First();
            foreach (DocketDocument dd in docket.DocketDocuments.Where(x => x.reference_document == true || x.document_id == document_id).ToList())
            {
                Docucheck dchk = new Docucheck();
                dchk.assignment_id = this.id;
                dchk.document_id = dd.document_id;
                dchk.docket_id = dd.docket_id;
                List<ReferenceSet> reference_sets = docket.SuperSet.ReferenceSets.ToList();
                if (reference_sets.Count(a => a.correct == true) > 1)
                {
                    Random r_id = new Random();
                    dchk.reference_set_id = reference_sets[r_id.Next(reference_sets.Count)].id;
                }
                else
                {
                    dchk.reference_set_id = reference_sets.Where(a => a.correct == true).First().id;
                }
                DocumentorDBM.Docuchecks.InsertOnSubmit(dchk);
                DocumentorDBM.SubmitChanges();
                dchk.create_filled_section();
            }
        }


        public void calculate_score()
        {
            foreach (Docucheck dchk in Docuchecks.Where(dchk => dchk.played != true))
            {
                dchk.played = true;
                dchk.calculate_score();
            }
            DocumentorDBM.Assignments.Where(a => a.id.Equals(this.id)).First().score = get_final_score();
            DocumentorDBM.SubmitChanges();
        }

    }
}
