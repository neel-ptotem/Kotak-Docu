<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>module_i</title>

        
</head>
<body>
<form id="form-module-3" method="get" action="UpdateProgress">
<input class="module-3" type="hidden" name="module_id" value="<%:ViewData["module_id"]%>" />
<input class="module-3" type="hidden" name="student_id" value="<%:ViewData["student_id"]%>" />
<input id="module-3-time-spend" class="module-3" type="hidden" name="time_spend" value="" />
<div style="padding:20px;">
    <div style="padding:40px;">
    <h2>Basics</h2>
    <br>
    Kindly read and mark the checkbox to indicate that you understand it. In case of any doubts, please contact RCAD for clarifications:  
    <br/>
    <br/>
    <div style="height:300px;overflow:auto;">
        <table class="table condensed-table">
        <tr>
            <th class="header-row" colspan="2">Requirements</th>
        </tr>
        <tr><td>TS duly signed by Credit / Legal</td><td><input class="section" type="checkbox" name="1" <%:ViewData["1"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Instruction to Docs Signed by Legal</td><td><input class="section" type="checkbox" name="2" <%:ViewData["2"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Accepted Sanction Letter (signed & Rubber stamped on all pages) </td><td><input class="section" type="checkbox" name="3" <%:ViewData["3"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Pricing Sheet</td><td><input class="section" type="checkbox" name="4" <%:ViewData["4"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>PF Confirmation</td><td><input class="section" type="checkbox" name="5" <%:ViewData["5"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Latest Approval mails</td><td><input class="section" type="checkbox" name="6" <%:ViewData["6"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>All documents should be filled completely & dated</td><td><input class="section" type="checkbox" name="7" <%:ViewData["7"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>RCU Report / RCU head approval for FG Business</td><td><input class="section" type="checkbox" name="8" <%:ViewData["8"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Disbursement request letter ( < 5 day old )</td><td><input class="section" type="checkbox" name="9" <%:ViewData["9"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>ROC search report in case of Pvt Ltd - Borrower / Coll. Security owner</td><td><input class="section" type="checkbox" name="10" <%:ViewData["10"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>CIBIL/NCIF report to check ( Except First Group / BBG cases )</td><td><input class="section" type="checkbox" name="11" <%:ViewData["11"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Margin Money receipt available where customer paid directly to dealer . / CA Certificate ( as per SL conditions )</td><td><input class="section" type="checkbox" name="12" <%:ViewData["12"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>

        <tr><th class="header-row" colspan="2">KYC documents with OSV</th></tr>
        <tr><td>Latest self certified copy of partnership deed</td><td><input class="section" type="checkbox" name="13" <%:ViewData["13"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Certified Copy of MOA/AOA - In case of Company</td><td><input class="section" type="checkbox" name="14" <%:ViewData["14"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Latest form 32 filed with ROC  / CA Certified List of Directors- In case of Company</td><td><input class="section" type="checkbox" name="15" <%:ViewData["15"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Schedule V of the last/latest Annual Report as a proof of directorship</td><td><input class="section" type="checkbox" name="16" <%:ViewData["16"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Certified copy of Trust Deed and Resolution - Specific</td><td><input class="section" type="checkbox" name="17" <%:ViewData["17"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>PAN card / Address proof with BCIF Ids</td><td><input class="section" type="checkbox" name="18" <%:ViewData["18"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>

        <tr><th class="header-row" colspan="2">In case of Takeovers</th></tr>
        <tr><td>Joint Letter</td><td><input class="section" type="checkbox" name="19" <%:ViewData["19"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>List of Document</td><td><input class="section" type="checkbox" name="20" <%:ViewData["20"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Over and Above letter</td><td><input class="section" type="checkbox" name="21" <%:ViewData["21"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Latest O/s Balance</td><td><input class="section" type="checkbox" name="22" <%:ViewData["22"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>One Chq of Takeover amt in case of OD takeover and RTGS form alongwith cancelled Chq where RTGS to be done .</td><td><input class="section" type="checkbox" name="23" <%:ViewData["23"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>

        <tr><th class="header-row" colspan="2">Repayment Mode PDC/SI/ECS</th></tr>
        <tr><td><span style="font-weight:bold">In case of PDCs/SPDCs</span></td></tr>
        <tr><td>PDC are crossed as A/c Payee and duly filled</td><td><input class="section" type="checkbox" name="24" <%:ViewData["24"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>PDC favouring " KMBL – Loan a/c <Customer Name ></td><td><input class="section" type="checkbox" name="25" <%:ViewData["25"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>PDC submission form completely filled and signed</td><td><input class="section" type="checkbox" name="26" <%:ViewData["26"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td><span style="font-weight:bold">In Case of SI / ECS</span></td></tr>
        <tr><td>Debit Mandate / SL Form as per format</td><td><input class="section" type="checkbox" name="27" <%:ViewData["27"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>ECS/SI is duly signed and stamped by issuing bank</td><td><input class="section" type="checkbox" name="28" <%:ViewData["28"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class="header-row" colspan="2">Collateral Security Related</th></tr>
        <tr><td>Legal / Title Report</td><td><input class="section" type="checkbox" name="29" <%:ViewData["29"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Valuation Report</td><td><input class="section" type="checkbox" name="30" <%:ViewData["30"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Legal instructions to document / Check list</td><td><input class="section" type="checkbox" name="31" <%:ViewData["31"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Documents are properly numbered and matches with list</td><td><input class="section" type="checkbox" name="32" <%:ViewData["32"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td><span style="font-weight:bold">If Vehicles</span></td></tr>
        <tr><td>Vehicle Number</td><td><input class="section" type="checkbox" name="33" <%:ViewData["33"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>RC</td><td><input class="section" type="checkbox" name="34" <%:ViewData["34"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Insurance</td><td><input class="section" type="checkbox" name="35" <%:ViewData["35"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Valuation</td><td><input class="section" type="checkbox" name="36" <%:ViewData["36"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Form B</td><td><input class="section" type="checkbox" name="37" <%:ViewData["37"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>FC</td><td><input class="section" type="checkbox" name="38" <%:ViewData["38"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>RTO Booklet</td><td><input class="section" type="checkbox" name="39" <%:ViewData["39"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>

        <tr><td><span style="font-weight:bold">If Machineries</span></td></tr>
        <tr><td>Invoices</td><td><input class="section" type="checkbox" name="40" <%:ViewData["40"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Valuation</td><td><input class="section" type="checkbox" name="41" <%:ViewData["41"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Insurance</td><td><input class="section" type="checkbox" name="42" <%:ViewData["42"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class="header-row" colspan="2">Legal Documents - duly executed, filled in & Rubber stamped (whereever applicable)</th></tr>
        <tr><td>Master Facility Agreement with schedule</td><td><input class="section" type="checkbox" name="43" <%:ViewData["43"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Schedule 1 General</td><td><input class="section" type="checkbox" name="44" <%:ViewData["44"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Schedule 2 A OD Facility</td><td><input class="section" type="checkbox" name="45" <%:ViewData["45"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Schedule 2 B DF Facility</td><td><input class="section" type="checkbox" name="46" <%:ViewData["46"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Schedule 2 C CC Facility</td><td><input class="section" type="checkbox" name="47" <%:ViewData["47"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Schedule 2 D PCF facility</td><td><input class="section" type="checkbox" name="48" <%:ViewData["48"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Schedule 2 E Bill Collection/Disc/Purchase Fin</td><td><input class="section" type="checkbox" name="49" <%:ViewData["49"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Letter of Credit Agreement</td><td><input class="section" type="checkbox" name="50" <%:ViewData["50"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Counter Guarantee and Indemnity</td><td><input class="section" type="checkbox" name="51" <%:ViewData["51"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Hypothecation Deed</td><td><input class="section" type="checkbox" name="52" <%:ViewData["52"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Supplemental Deed of Hypothecation</td><td><input class="section" type="checkbox" name="53" <%:ViewData["53"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Power of Attorney - Borrowing.</td><td><input class="section" type="checkbox" name="54" <%:ViewData["54"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Guarantee – Individual</td><td><input class="section" type="checkbox" name="55" <%:ViewData["55"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Guarantee – Corporate</td><td><input class="section" type="checkbox" name="56" <%:ViewData["56"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Demand Promissory note – Fixed /Floating / linked to LIBOR</td><td><input class="section" type="checkbox" name="57" <%:ViewData["57"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Take Delievery Letter</td><td><input class="section" type="checkbox" name="58" <%:ViewData["58"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>TBC undertaking</td><td><input class="section" type="checkbox" name="59" <%:ViewData["59"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>FD appropriation letter</td><td><input class="section" type="checkbox" name="60" <%:ViewData["60"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>General Undertaking</td><td><input class="section" type="checkbox" name="61" <%:ViewData["61"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>End Use Undertaking</td><td><input class="section" type="checkbox" name="62" <%:ViewData["62"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>POA to Mortgage</td><td><input class="section" type="checkbox" name="63" <%:ViewData["63"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Declaration Mortgage</td><td><input class="section" type="checkbox" name="64" <%:ViewData["64"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Property Undertaking</td><td><input class="section" type="checkbox" name="65" <%:ViewData["65"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>MOE/ Registered Mort. Deed / ROM</td><td><input class="section" type="checkbox" name="66" <%:ViewData["66"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Constructive MOE for Enhancement cases</td><td><input class="section" type="checkbox" name="67" <%:ViewData["67"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Sole Proprietorship Letter/SRL</td><td><input class="section" type="checkbox" name="68" <%:ViewData["68"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Parternship Authority Letter</td><td><input class="section" type="checkbox" name="69" <%:ViewData["69"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Board Resolution Borrower Co</td><td><input class="section" type="checkbox" name="70" <%:ViewData["70"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Board Resolution Guarantor Co</td><td><input class="section" type="checkbox" name="71" <%:ViewData["71"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Borrowing Power certificate</td><td><input class="section" type="checkbox" name="72" <%:ViewData["72"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Certificate u/s 372 A</td><td><input class="section" type="checkbox" name="73" <%:ViewData["73"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>HUF declaration </td><td><input class="section" type="checkbox" name="74" <%:ViewData["74"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>HUF undertaking</td><td><input class="section" type="checkbox" name="75" <%:ViewData["75"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Loan cum Hyp. Agreement</td><td><input class="section" type="checkbox" name="76" <%:ViewData["76"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>KMBL Signatures on legal documents.</td><td><input class="section" type="checkbox" name="77" <%:ViewData["77"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        </table>
    </div>
    </div>
</div>
</form>
</body>
</html>



