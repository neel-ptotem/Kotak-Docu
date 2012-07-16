using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KotakDocuMentor.Models;
using System.Web.Script.Serialization;

namespace KotakDocuMentor.Controllers
{
    public class DocumentController : Controller
    {
        private DocumentorDBDataContext DocumentorDB = new DocumentorDBDataContext();
        //
        // GET: /Document/

        public ActionResult Index()
        {
            return View(DocumentorDB.Documents.ToList());
        }

        public ActionResult ViewDocumentPages(int id)
        {
            Document doc = DocumentorDB.Documents.Where(a => a.id == id).First();
            return View(doc.Pages.ToList());
        }

        public ActionResult DocumentCustomizeView(int page_id)
        {
            Page pg = DocumentorDB.Pages.Where(a => a.id == page_id).First();
            ViewData["components"]=DocumentorDB.Components.ToList();
            ViewData["blank_sections"] = pg.BlankSections.ToList();
            ViewData["page_id"] = page_id;
            return View(pg);
        }

        [HttpPost]
        public ActionResult StructureForm()
        {
            try
            {
                var js = new JavaScriptSerializer();
                List<BlankSection> blank_sections = js.Deserialize<List<BlankSection>>(Request.Params[0]);
                DocumentorDB.BlankSections.DeleteAllOnSubmit(DocumentorDB.BlankSections.Where(a => a.page_id == blank_sections.First().page_id));
                DocumentorDB.BlankSections.InsertAllOnSubmit(blank_sections);
                DocumentorDB.SubmitChanges();
                return RedirectToAction("Index");
            }
            catch
            {
                return RedirectToAction("Index");
                //return View();
            }
        }


    }
}
