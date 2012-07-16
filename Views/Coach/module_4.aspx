<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>module_i</title>

    
</head>
<body>
<form id="form-module-4" method="get" action="UpdateProgress">
<input class="module-4" type="hidden" name="module_id" value="<%:ViewData["module_id"]%>" />
<input class="module-4" type="hidden" name="student_id" value="<%:ViewData["student_id"]%>" />
<input id="module-4-time-spend" class="module-4" type="hidden" name="time_spend" value="" />
<div style="padding:20px;">
    <div style="padding:40px;">
    <h2>Basics</h2>
    <br>
    Kindly read and mark the checkboxes to indicate that you understand the requirements. In case of any doubts, please contact Commercial Operations for clarifications:  
    <br/>
    <br/>
    <div style="height:300px;overflow:auto;">
        <table class="table condensed-table">
        <tr><th class='header-row' colspan='2'>Request Letter (RL)</th></tr>
        <tr><td>RL should be of latest date, it should not be older than 5 days</td><td><input class="section" type="checkbox" name='1' <%:ViewData["1"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Must include Tenure in days/months, Rate in % plus fix/floating option, Amount to be disbursed and Account in which it need to be disbursed. In case of RTGS details of the same</td><td><input class="section" type="checkbox" name='2' <%:ViewData["2"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Signature verification - Person authorised to sign per BR and SV of the same</td><td><input class="section" type="checkbox" name='3' <%:ViewData["3"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class='header-row' colspan='2'>Rate Approval</th></tr>
        <tr><td>by appropriate authority is in place or not alonwith Rate sheet</td><td><input class="section" type="checkbox" name='4' <%:ViewData["4"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class='header-row' colspan='2'>Board Resolution (BR) </th></tr>
        <tr><td>BR should be latest and cover the transaction processed otherwise revised BR need to taken</td><td><input class="section" type="checkbox" name='5' <%:ViewData["5"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Name of Authorized Signatory incorporated in BR</td><td><input class="section" type="checkbox" name='6' <%:ViewData["6"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Check signature from system or other legible source like Pan Card, Driving Licence, Passport</td><td><input class="section" type="checkbox" name='7' <%:ViewData["7"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class='header-row' colspan='2'>Limit and DP in place</th></tr>
        <tr><td>Limit and DP are in place and in case DP or Limit is expired necessary approval for extension is in place</td><td><input class="section" type="checkbox" name='8' <%:ViewData["8"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>DP approval should be from Monitoring team</td><td><input class="section" type="checkbox" name='9' <%:ViewData["9"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>In case of Limit extension,approval should be required as per approval auhtority matrix of the bank</td><td><input class="section" type="checkbox" name='10' <%:ViewData["10"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class='header-row' colspan='2'>Sanction letter (SL)</th></tr>
        <tr><td>Date of sanction letter - whether it is valid or not, if not extension from appropriate authority is in place. Normally SL is valid of 1year</td><td><input class="section" type="checkbox" name='11' <%:ViewData["11"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Sanction letter should cover the facility requested to be disbursed </td><td><input class="section" type="checkbox" name='12' <%:ViewData["12"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Please check the terms of sanction letter like</td><td><input class="section" type="checkbox" name='13' <%:ViewData["13"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Repayment - PDC (Note UDC. SPDC to be kept with CAD) or A/c Debit. In case of SI, SI mandate</td><td><input class="section" type="checkbox" name='14' <%:ViewData["14"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Tenure of facilities</td><td><input class="section" type="checkbox" name='15' <%:ViewData["15"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Validity of facilities</td><td><input class="section" type="checkbox" name='16' <%:ViewData["16"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Rate applicable</td><td><input class="section" type="checkbox" name='17' <%:ViewData["17"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Mode of disbursement like to kotak a/c or to other bank a/c via RTGS, NEFT, DD, other mode, or directly to vendor / manufacturer / supplier etc</td><td><input class="section" type="checkbox" name='18' <%:ViewData["18"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>CA Certificate required as per Saction</td><td><input class="section" type="checkbox" name='19' <%:ViewData["19"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Reimbursement or Direct payment</td><td><input class="section" type="checkbox" name='20' <%:ViewData["20"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Or any other conditions as stated in the Disbursement conidtion In the SL/TS</td><td><input class="section" type="checkbox" name='21' <%:ViewData["21"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>any specific condition as stated in SL/TS</td><td><input class="section" type="checkbox" name='22' <%:ViewData["22"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Margin as per sanction terms is in place or not, source CAD or CA cert.</td><td><input class="section" type="checkbox" name='23' <%:ViewData["23"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>DP as per sanction terms is in place or not</td><td><input class="section" type="checkbox" name='24' <%:ViewData["24"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>PO/Bills/Invoice </td><td><input class="section" type="checkbox" name='25' <%:ViewData["25"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Penal Rate applicable</td><td><input class="section" type="checkbox" name='26' <%:ViewData["26"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Processing Fees as per sanction collected or not. Amount Collected & Date of collection</td><td><input class="section" type="checkbox" name='27' <%:ViewData["27"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Maximum minimum tranche, maximum funding at certain point of time</td><td><input class="section" type="checkbox" name='28' <%:ViewData["28"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Check Moratorium Period and it's treatment</td><td><input class="section" type="checkbox" name='29' <%:ViewData["29"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Mode of Payment - EMI, Equaited Principal, Bullet or Any other</td><td><input class="section" type="checkbox" name='30' <%:ViewData["30"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Check all terms & conditions applicable to disbursement of facility</td><td><input class="section" type="checkbox" name='31' <%:ViewData["31"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class='header-row' colspan='2'>Term Sheet  </th></tr>
        <tr><td>Term sheet covers the facility to be disbursed and should be latest. Normally SL is valid for 1year</td><td><input class="section" type="checkbox" name='32' <%:ViewData["32"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>It should be signed </td><td><input class="section" type="checkbox" name='33' <%:ViewData["33"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>It termsheet covers more than one facility of same nature - say two STL, It should be confirmed under which facility disbursal is requested.</td><td><input class="section" type="checkbox" name='34' <%:ViewData["34"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>check whether conditions applicable for facility are complied or not. </td><td><input class="section" type="checkbox" name='35' <%:ViewData["35"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>check for internal conditions in term sheet which are not mentioned in sanction letter.</td><td><input class="section" type="checkbox" name='36' <%:ViewData["36"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class='header-row' colspan='2'>PDC</th></tr>
        <tr><td>should be favoring KMBL only Party Name or A/c No on it is not acceptable</td><td><input class="section" type="checkbox" name='37' <%:ViewData["37"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>should be properly dated except in case of UDC/SPDC</td><td><input class="section" type="checkbox" name='38' <%:ViewData["38"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>should be A/c payee only and all blanks to be crossed via horizontal line</td><td><input class="section" type="checkbox" name='39' <%:ViewData["39"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Amount in words and figures match</td><td><input class="section" type="checkbox" name='40' <%:ViewData["40"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>PDC of Cooperative Bank - Not Acceptable</td><td><input class="section" type="checkbox" name='41' <%:ViewData["41"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class='header-row' colspan='2'>CA Certificate</th></tr>
        <tr><td>favouring KMBL preferred generally</td><td><input class="section" type="checkbox" name='42' <%:ViewData["42"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>should support reimbursement / disbursement as per sanction terms</td><td><input class="section" type="checkbox" name='43' <%:ViewData["43"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>should contain membership no. and seal and signature and should be on letter head</td><td><input class="section" type="checkbox" name='44' <%:ViewData["44"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Should contain the contents/format as per sanction.</td><td><input class="section" type="checkbox" name='45' <%:ViewData["45"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><th class='header-row' colspan='2'>PSL/CRE/LOB</th></tr>
        <tr><td>Please provide confirmation from RCH for CRE/Non CRE</td><td><input class="section" type="checkbox" name='46' <%:ViewData["46"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>Confirmation of PSL category</td><td><input class="section" type="checkbox" name='47' <%:ViewData["47"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        <tr><td>LOB to be tagged</td><td><input class="section" type="checkbox" name='48'  <%:ViewData["48"].Equals(1)?"checked='checked' disabled='disabled'":"" %>/></td></tr>
        </table>
    </div>
    </div>
</div>
</form>
</body>
</html>



