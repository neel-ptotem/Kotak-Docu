using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;

namespace KotakDocuMentor.Controllers
{
    public class DocucheckController : Controller
    {
        private DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
        //
        // GET: /Docucheck/

        public ActionResult Index()
        {
            return View(DocumentorDB.Docuchecks.ToList());
        }

        //
        // GET: /Docucheck/Details/5

        public ActionResult Details(int id)
        {
            return View(DocumentorDB.Docuchecks.Where(a=>a.id==id).First());
        }

        //
        // GET: /Docucheck/Create

        public ActionResult Create()
        {
            //ViewData["assignments"] = new SelectList(DocumentorDB.Assignments, "id", "id");
            //ViewData["documents"] = new SelectList(DocumentorDB.Documents, "id", "name");
            //ViewData["reference_sets"] = new SelectList(DocumentorDB.ReferenceSets, "id", "name");
            return View();
        } 

        //
        // POST: /Docucheck/Create

        [HttpPost]
        public ActionResult Create(Docucheck dc)
        {
            try
            {
                // TODO: Add insert logic here
                DocumentorDB.Docuchecks.InsertOnSubmit(dc);
                DocumentorDB.SubmitChanges();
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
        
        //
        // GET: /Docucheck/Edit/5
 
        public ActionResult Edit(int id)
        {
            Docucheck dc = DocumentorDB.Docuchecks.Where(a => a.id == id).First();
            //ViewData["assignments"] = new SelectList(DocumentorDB.Assignments, "id", "name",dc.assignment_id);
            ViewData["documents"] = new SelectList(DocumentorDB.Documents, "id", "name",dc.document_id);
            ViewData["reference_sets"] = new SelectList(DocumentorDB.ReferenceSets, "id", "name",dc.reference_set_id);
            return View(dc);
        }

        //
        // POST: /Docucheck/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, Docucheck dc)
        {
            try
            {
                // TODO: Add update logic here
                Docucheck old = DocumentorDB.Docuchecks.Where(a => a.id == id).First();
                //old.assignment_id = dc.assignment_id;
                old.document_id = dc.document_id;
                old.reference_set_id = dc.reference_set_id;
                DocumentorDB.SubmitChanges(); 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Docucheck/Delete/5
 
        public ActionResult Delete(int id)
        {
            return View(DocumentorDB.Docuchecks.Where(a => a.id == id).First());
        }

        //
        // POST: /Docucheck/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, Docucheck dc)
        {
            try
            {
                // TODO: Add delete logic here
                DocumentorDB.Docuchecks.DeleteOnSubmit(dc);
                DocumentorDB.SubmitChanges(); 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
