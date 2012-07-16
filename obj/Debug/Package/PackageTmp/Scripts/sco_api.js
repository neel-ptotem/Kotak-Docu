/*
* SCORM DEVELOPER'S TOOLKIT
* Copyright 2007 e-Learning Consulting All Rights Reserved
* www.e-learningconsulting.com
* The use of this code is specified by the End-User License Agreement
*/

// Set to true to turn on the debug window
var _bDebug = false;

/* Global variables start with an underscore "_" */
var _sAPI = ""; /* the name of the SCORM API "API" or "API_1484_11" */
var apiHandle = null; /* SCORM API */

/*
* call getAPI() to make sure we have set the apiHandle and _sAPI
*/
getAPI();

/* SESSION FUNCTIONS */

/*
* initilize the communications with the LMS
*/
function initCommunications() {
	scormInitialize();
}

/*
* terminate the communications with the LMS
*/
function termCommunications() {
	scormTerminate();
}

/*
* tell the LMS to restore the bookmark, suspend_data and other SCORM data items when the next session starts
*/
function learnerWillReturn(bWillReturn) {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, set the exit data */
		if (bWillReturn)
			scormSetValue("cmi.exit", "suspend");
		else
			scormSetValue("cmi.exit", "normal");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, set the exit data */
		if (bWillReturn)
			scormSetValue("cmi.core.exit", "suspend");
		else
			scormSetValue("cmi.core.exit", "");
	}
}

/* LAUNCH CONDITIONS */

/*
* return true if this is the first launch of the SCO for the learner
*/
function isFirstLaunch() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, get the entry value */
		var sReturn = scormGetValue("cmi.entry");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, get the entry value */
		var sReturn = scormGetValue("cmi.core.entry");
	} else {
		/* no SCORM communications, this will always be the first launch */
		return true;
	}
	
	/* see if this is the first launch */
	if (sReturn != "ab-initio") {
		/* it is not the first laucnh */
		return false;
	}
	
	/* must be the first launch launch */
	return true;
}

/*
* return true if this is the first launch of the SCO for the learner
*/
function getLaunchData() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the launch data */
		return scormGetValue("cmi.launch_data");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, return the launch data */
		return scormGetValue("cmi.launch_data");
	
	} else {
		/* no SCORM communications */
		return "";
	}
}

/*
* return the credit value, "credit" or "no-credit"
*/
function getCredit() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the launch data */
		return scormGetValue("cmi.credit");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, return the launch data */
		return scormGetValue("cmi.core.credit");
	} else {
		/* no SCORM communications */
		return "credit";
	}
}

/*
* return the mode value, "browse", "normal" or "review"
*/
function getMode() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the launch data */
		return scormGetValue("cmi.mode");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, return the launch data */
		return scormGetValue("cmi.core.lesson_mode");
	} else {
		/* no SCORM communications */
		return "normal";
	}
}

/* TIME FUNCTIONS */

/* This global is set by a call to startSessionTime() - it contains the start time of this session */
_timeSessionStart = null;

/*
* Start the session time
*
*	Returns: the session start time in milliseconds
*/
function startSessionTime() {
	/* set a global to the start time, we will use this later to get the session time */
	_timeSessionStart = new Date();
	
	return _timeSessionStart;
}

/*
* set the session time
*	timeStart - the session start time in milliseconds
*/
function setSessionTime(timeStart) {
	/* get the current date and time */
	var dateNow = new Date();
	var timeNow = dateNow.getTime();
	
	/* calculate the elapsed time from the session start time to now */
	var timeElapsed = Math.round((timeNow - timeStart) / 1000);
	
	/* format the elapsed time */
	var sTime = formatTime(timeElapsed);
	
	/* see if this is SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is, set the session time */
		scormSetValue("cmi.session_time", sTime);
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, set the session time */
		scormSetValue("cmi.core.session_time", sTime);
	}
}

/*
* get the maximum time allowed for this SCO, this will return a time in seconds or an empty string ""
*/
function getMaxTimeAllowed() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the maximum time allowed */
		return scormGetValue("cmi.max_time_allowed");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, get the maximum time allowed */
		var sReturn = scormGetValue("cmi.student_data.max_time_allowed");
		
		/* see if this string is empty */
		if (sReturn == "") {
			/* it is, return it */
			return "";
		} else {
			/* this is a hhhh:mm:ss value, convert it */
			var aParts = sReturn.split(':');
			if (aParts.length == 3) {
				return "PT" + aParts[0] * 3600 + aParts[1] * 60 + (aParts[2] - 0) + "S";
			} else {
				return "";
			}
		}
	} else {
		/* no SCORM communications, return as if max time was not set in the manifest */
		return "";
	}
}

/*
* get the time limit action, returns
*	"exit,message"
*	"continue,message"
*	"exit,no message"
*	"continue,no message" (default)
*/
function getTimeLimitAction() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the data */
		return scormGetValue("cmi.time_limit_action");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, return the data */
		return scormGetValue("cmi.student_data.time_limit_action");
	} else {
		/* no SCORM communications */
		return "continue,no message";
	}
}

/*
* get the total time for all sessions
*/
function getTotalTime() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the total time */
		return scormGetValue("cmi.total_time");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, get the total time */
		var sReturn = scormGetValue("cmi.core.total_time");
		
		/* see if this string is empty */
		if (sReturn == "") {
			/* it is, return it */
			return "";
		} else {
			/* this is a hhhh:mm:ss value, convert it */
			var aParts = sReturn.split(':');
			if (aParts.length == 3) {
				return "PT" + aParts[0] * 3600 + aParts[1] * 60 + (aParts[2] - 0) + "S";
			} else {
				return "";
			}
		}
	} else {
		/* no SCORM communications */
		return "";
	}
}

/* STATE MANAGEMENT FUNCTIONS */

/*
* get the bookmark string, previously set
*/
function getBookmark() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the bookmark data */
		return scormGetValue("cmi.location");
		alert("SCORM 2004");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, return the bookmark data */
		return scormGetValue("cmi.core.lesson_location");
		alert("SCORM 1.2");
	} else {
		/* no SCORM communications */
		return "";
	}
}

/*
* set the bookmark string
*/
function setBookmark(sLocation) {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, set the bookmark data */
		scormSetValue("cmi.location", sLocation+"");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, set the bookmark data */
		scormSetValue("cmi.core.lesson_location", sLocation+"");
	}
}

/*
* get the suspend data string, previously set
*/
function getSuspendData() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11" || _sAPI == "API") {
		/* it is SCORM 2004 or SCORM 1.2, return the suspend data */
		return scormGetValue("cmi.suspend_data");
	} else {
		/* no SCORM communications */
		return "";
	}
}

/*
* set the suspend data string
*/
function setSuspendData(sSuspend) {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11" || _sAPI == "API") {
		/* it is SCORM 2004, set the suspend data */
		scormSetValue("cmi.suspend_data", sSuspend+"");
	}
}

/* COMPLETION FUNCTIONS */

/*
* set the completion status to "completed", "incomplete", "not attempted", "unknown"
*/
function setCompletionStatus(sCompletion) {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, set the completion status */
		scormSetValue("cmi.completion_status", sCompletion+"");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, see if this is a valid completion status for SCORM 1.2 */
		if (sCompletion == "completed" || sCompletion == "incomplete" || sCompletion == "not attempted") {
			/* this is a valid value, get the current value */
			var sReturn = scormGetValue("cmi.core.lesson_status");
			
			/* see it the completion value is already set to passed or failed (this is done with setPassFail())*/
			if (sReturn == "passed" || sReturn == "failed") {
				/* it is, see if we are trying to set the value to something other than completed */
				/* we do not want to replace pass/fail with completed */
				if (sCompletion == "incomplete" || sCompletion == "not attempted") {
					/* we are, set it */
					scormSetValue("cmi.core.lesson_status", sCompletion+"");
				}
			} else {
				/* not passed or failed, so OK to set */
				scormSetValue("cmi.core.lesson_status", sCompletion+"");
			}
		}
	}
}

/*
* get the completion status, "completed", "incomplete", "not attempted", "unknown"
*/
function getCompletionStatus() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the completion status data */
		return scormGetValue("cmi.completion_status");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, get the compltetion status */
		var sCompletion = scormGetValue("cmi.core.lesson_status");
		
		/* SCORM 1.2 only has a single data item to store completion and pass/fail */
		/* so check to see if we have a failed or passed status, if so return the status as completed */
		if (sCompletion == "passed" || sCompletion == "failed") {
			return "completed";
		} else {
			return sCompletion;
		}
	} else {
		/* no SCORM communications */
		return "not attempted";
	}
}

/*
* set the completion status to a value between 0 and 1
*/
function setCompletionPercentage(sProgress) {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, set the completion percentage data */
		scormSetValue("cmi.progress_measure", sProgress+"");
	}
}

/*
* get the completion status, a value between 0 and 1 or "" if never set by the SCO
*/
function getCompletionPercentage() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the completion percentage data */
		return scormSetValue("cmi.progress_measure");
	}
	
	/* not defined in SCORM 1.2 so return "" */
	return "";
}

/*
* get the completion threshold, a value between 0 and 1 or "" if not defined
*/
function getCompletionThreshold() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the completion theshold data */
		return scormSetValue("cmi.completion_threshold");
	}
	
	/* not defined in SCORM 1.2 so return "" */
	return "";
}


/* PASS-FAIL FUNCTIONS */

/*
* set the completion status to "passed, "failed", "unknown"
*/
function setPassFail(sPassFail) {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, set the success status */
		scormSetValue("cmi.success_status", sPassFail+"");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2,set the completion status */
		scormSetValue("cmi.core.lesson_status", sPassFail+"");
	}
}

/*
* get the completion status, "passed, "failed", "unknown"
*/
function getPassFail() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the success status data */
		return scormGetValue("cmi.success_status");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, get the completion status data */
		var sReturn = scormGetValue("cmi.core.lesson_status");
		
		/* see if the status is passed or failed */
		if (sReturn == "passed" || sReturn == "failed") {
			/* it is, return it */
			return sReturn;
		} else {
			/* another status, so return "unknown" */
			return "unknown";
		}
	} else {
		/* no SCORM communications */
		return "unknown";
	}
}


/* SCORE FUNCTIONS */

/*
* get the passing score string, -1 to 1 */
function getPassingScore() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the passing score data */
		return scormGetValue("cmi.scaled_passing_score");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, get the mastery score data */
		var sReturn = scormGetValue("cmi.student_data.mastery_score");
		
		/* see if we have a value */
		if (sReturn == "") {
			/* we do not, return the default of 1.0 */
			return "1.0";
		} else {
			/* we do, divide by 100 ot make it a value between 0 and 1 */
			sReturn = (sReturn / 100) + "";
			
			/* return it */
			return sReturn;
		}
	} else {
		/* no SCORM communications */
		return "1.0";
	}
}

/*
* set the score from a value of -1 to 1
*/
function setScore(sScore) {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, set the scaled score data */
		scormSetValue("cmi.score.scaled", sScore+"");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, set the min and max scores */
		scormSetValue("cmi.core.score.min", "0");
		scormSetValue("cmi.core.score.max", "100");
		
		/* see if this is a negative value */
		if ((sScore - 0) < 0) {
			/* it is, SCORM cannot handle a negative value so set the score to 0 */
			scormSetValue("cmi.core.score.raw", "0");
		} else {
			/* multiply by 100 to get it in the range from 0 to 100 */
			scormSetValue("cmi.core.score.raw", (sScore * 100)+"");
		}
	}
}

/*
* get the score string, previously set
*/
function getScore() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return the scaled score data */
		return scormGetValue("cmi.scaled.score");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, return the score in a range from 0 to 100 data */
		return (scormGetValue("cmi.core.score.raw") / 100) + "";
	} else {
		/* no SCORM communications */
		return "";
	}
}

/*
* get the Learner Name string
*/
function getLearnerName() {
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is SCORM 2004, return name */
		return scormGetValue("cmi.learner_name");
	} else if (_sAPI == "API") {
		/* it is SCORM 1.2, return the name */
		return (scormGetValue("cmi.core.student_name")) + "";
	} else {
		/* no SCORM communications */
		return "";
	}
}

/* INTERACTION FUNCTIONS */

/*
* set the interaction data except for the objective information
*	sNum - the # of the interaction to set. If this is null, the interaction will be added to the end of the collection (list) of interactions.
*	sId - the id of the interaction
*	sType - the type of the interaction, "true-false, "choice", "fill-in" "long-fill-in", "likert", "matching", "performance", "sequencing", "numeric", "other"
*	sResponse - the response provided by the learner
*	sCorrect - the correct answer
*	sResult - "correct", "incorrect", "unanticipated", "neutral" or "x.y" a character string containing a real number
*	sWeight - the weight of this question, can be null
*	nLatency - the time the learner took to respond to the question in milliseconds, can be null
*	sDescription - the description of this interaction, can be null
*	sIdObjective - the id of the objective, can be null
*/
function setInteraction(sNum,sId,sType,sResponse,sCorrect,sResult,sWeight,nLatency,sDescription,sIdObjective) {
	var nLen, aPairs;
	
	// see if we have a # of an interaction to set
	if (sNum == null) {
		// we do not, get the count of interactions from the LMS */
		sNum = scormGetValue("cmi.interactions._count");
	}

	/* see if this is SCORM 1.2 */
	if (_sAPI == "API") {
		/* it is, modify the responses from SCORM 2004 format to SCORM 1.2 format */
		
		/* see if the result is set to the word "incorrect" */
		if (sResult == "incorrect") {
			/* it is, set it to wrong */
			sResult = "wrong";
		}
		
		/* see if this is true-false */
		if (sType == "true-false") {
			/* it is, modify the responses from "true to "t", "false" to "f" */
			if (sResponse == "true") sResponse = "t";
			else if (sResponse == "false") sResponse = "f";
			
			/* modify the correct answer from "t" or "1" to "true, "f" or "0" to "false" */
			if (sCorrect == "true") sCorrect = "t";
			else if (sCorrect == "false") sCorrect = "f";
		} else if (sType == "choice" || sType == "sequencing") {
			/* this is a choice or sequencing interaction, see if there are [,] separators */
			if (sResponse.indexOf('[,]') != -1) {
				/* there are, replace [.] with commas */
				var aResponses = sResponse.split('[,]');
				sResponse = aResponses.join(',');
			}
			
			/* see if there are [,] separators for the correct answer */
			if (sCorrect.indexOf('[,]') != -1) {
				/* there are, replace them with commas */
				var aCorrect = sCorrect.split('[,]');
				sCorrect = aCorrect.join(',');
			}
		} else if (sType == "matching") {
			/* this is a matching interaction, see if there are [,] separators for the response */
			if (sResponse.indexOf('[,]') != -1) {
				/* there are, break them apart */
				var aResponses = sResponse.split('[,]');
				
				/* loop through the responses */
				nLen = aResponses.length;
				for (var i=0; i<nLen; i++) {
					/* see if the responses are separated by a [.] */
					if (aResponses[i].indexOf("[.]") != -1) {
						/* there are, replace them with a period */
						aPairs = aResponses[i].split("[.]");
						aResponses[i] = aPairs.join(".");
					}
				}
				
				/* recombine with commas */
				sResponse = aResponses.join(',');
			}
			
			/* see if there are [,] separators for the correct answer */
			if (sCorrect.indexOf('[,]') != -1) {
				/* there are, break them apart */
				var aCorrect = sCorrect.split('[,]');
				
				/* loop through the responses */
				nLen = aCorrect.length;
				for (var i=0; i<nLen; i++) {
					/* see if the responses are separated by a [.] */
					if (aCorrect[i].indexOf("[.]") != -1) {
						/* there are, replace them with a period */
						aPairs = aCorrect[i].split("[.]");
						aCorrect[i] = aPairs.join(".");
					}
				}
				
				/* recombine with commas */
				sCorrect = aCorrect.join(',');
			}
		} else if (sType == "numeric") {
			/* this is a numeric interaction, see if find a colon in the correct answer */
			if (sCorrect.indexOf() != -1) {
				/* we did, break it apart */
				aPairs = sCorrect.split("[:]");
				
				/* see if the first part contains a number */
				if (aPairs[0] != "") {
					/* it does, use it as the correct response */
					sCorrect = aPairs[0];
				} else {
					/* use the second number */
					sCorrect = aPairs[1];
				}
			}
		}
	}
		
	/* tell the LMS about the interaction */
	var sInt = "cmi.interactions." + sNum + ".";
	scormSetValue(sInt + "id", sId);
	scormSetValue(sInt + "type", sType);
	if (_sAPI == "API_1484_11")
		scormSetValue(sInt + "learner_response", sResponse);		
	else
		scormSetValue(sInt + "student_response", sResponse);
	scormSetValue(sInt + "correct_responses.0.pattern", sCorrect);
	scormSetValue(sInt + "result", sResult);
	var dateNow = new Date();
	if (_sAPI == "API_1484_11")
		scormSetValue(sInt + "timestamp", dateToTimestamp(dateNow));	
	else
		scormSetValue(sInt + "time", getHMS(dateNow));
				
	if (sWeight!=null) scormSetValue(sInt + "weighting", sWeight);
	if (nLatency!=null)   scormSetValue(sInt + "latency", nLatency+"");
	if (sDescription != null && _sAPI == "API_1484_11") scormSetValue(sInt + "description", sDescription);
	if (sIdObjective != null) scormSetValue(sInt + "objectives.0.id", sIdObjective);
}

/*
* Get the index of an interaction from its ID
*	sStart - the starting index - use "0" if you want to start from the beginning
*	sId - the ID of the interaction that you would like to find
*
*	RETURNS: always null for SCORM 1.2 (SCORM 1.2 cannot read interactions). The index of the interaction if we find a match, else null
*/
function getInteractionIndex(sStart, sId) {
	/* see if this is SCORM 1.2 */
	if (_sAPI == "API") {
		/* it is, we cannot read interactions in SCORM 1.2 so return a null */
		return null;
	}
	
	/* get the count of interactions */
	var nTotal = scormGetValue("cmi.interactions._count") - 0;
	
	/* the start number is a character value, convert to integer */
	var nStart = sStart - 0;
	
	/* see if the number of interactions is less than the starting index */
	if ((nTotal-1) < nStart) {
		/* it is, no more interactions past this start index */
		return null;
	}	
	
	/* loop through the collection of interactions */
	for (; nStart < nTotal; nStart++) {
		/* get the interaction ID */
		var sIdCurrent = scormGetValue("cmi.interactions." + nStart + ".id");
		
		/* see if this is a match */
		if (sIdCurrent == sId) {
			/* it is, return the index */
			return nStart + "";
		}
	}
	
	/* we did not find a match for the ID so return a NULL */
	return null;
}

/* OBJECTIVE FUNCTIONS */

/*
* Set an objective
*	sNum - the # of the objective to set. If this is null, the objective will be added at the end of the collection (list) of objectives.
*	sId - the ID of this objective
*	sCompletion - the completion status of the objective - "completed", "incomplete", "not attempted", "unknown"
*	sPercentComplete - the percent complete as a decimal value, 0 is 0% complete, 0.5 is 50% complete, 1 is 100% complete, can be null
*	sPassFail - the pass/fail status (progress measure) - "passed", "failed", "unknown", can be null
*	sScore - the score of the objective - a decimal value from -1 to 1, can be null
*	sDescription - the description of the SCO, can be null
*/
function setObjective(sNum,sId,sCompletion,sPercentComplete,sPassFail,sScore,sDescription) {
	// see if we have a # of an objective to set
	if (sNum == null) {
		// we do not, get the count of objectives from the LMS */
		sNum = scormGetValue("cmi.objectives._count");
	}
	
	/* tell the LMS about the objective */
	var sObj = "cmi.objectives." + sNum + ".";
	scormSetValue(sObj + "id", sId);
	
	/* see if this SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is, set the SCORM 2004 items for this objective */
		scormSetValue(sObj + "completion_status", sCompletion);
		if (sPercentComplete != null) scormSetValue(sObj + "progress_measure", sPercentComplete);
		if (sPassFail != null) scormSetValue(sObj + "success_status", sPassFail);
		if (sScore != null) scormSetValue(sObj + "score.scaled", sScore);
		if (sDescription != null) scormSetValue(sObj + "description", sDescription);
	} else if (_sAPI == "API") {
		/* set the SCORM 1.2 items for this objective */
		if (sCompletion == "unknown") sCompletion = "incomplete";		
		scormSetValue(sObj + "status", sCompletion);
		if (sPassFail == "passed" || sPassFail == "failed") scormSetValue(sObj + "status", sPassFail);
		if (sScore != null) {
			scormSetValue(sObj + "score.min", "0");
			scormSetValue(sObj + "score.max", "100");
			scormSetValue(sObj + "score.raw", (Math.round(sScore * 100000)/1000)+"");
		}
	}
}
	
/*
* Get the index of an objective from its ID
*	sStart - the starting index - use "0" if you want to start from the beginning
*	sId - the ID of the objective that you would like to find
*
*	RETURNS: The index of the objective if we find a match, else null
*/
function getObjectiveIndex(sStart, sId) {
	/* get the count of objectives */
	var nTotal = scormGetValue("cmi.objectives._count") - 0;
	
	/* the start number is a character value, convert to integer */
	var nStart = sStart - 0;
	
	/* see if the number of objectives is less than the starting index */
	if ((nTotal-1) < nStart) {
		/* it is, no more interactions past this start index */
		return null;
	}	
	
	/* loop through the collection of objectives */
	for (; nStart < nTotal; nStart++) {
		/* get the objective ID */
		var sIdCurrent = scormGetValue("cmi.objectives." + nStart + ".id");
		
		/* see if this is a match */
		if (sIdCurrent == sId) {
			/* it is, return the index */
			return nStart + "";
		}
	}
	
	/* we did not find a match for the ID so return a NULL */
	return null;
}

/*
* Get the count of objectives
*/
function getObjectiveCount() {
	/* return the count */
	return scormGetValue("cmi.objectives._count") - 0;
}

/*
* Get the objective score
*/
function getObjectiveScore(sIndex) {
	if (_sAPI == "API") {
		/* get the score as a number */
		var nScore = scormGetValue("cmi.objectives." + sIndex + ".score.raw") - 0;
		
		/* return the number to a fraction between 0 and 1 and round it to the nearest 1/1000th */
		nScore = (Math.round(nScore * 1000) / 100000);
		return nScore + "";
	} else {
		return scormGetValue("cmi.objectives." + sIndex + ".score.scaled");
	}
}

/*
* get the objective completion status
*/
function getObjectiveCompletionStatus(sIndex) {
	/* see if this is 1.2 */
	if (_sAPI == "API") {
		/* it is */
		return scormGetValue("cmi.objectives." + sIndex + ".status");
	} else {
		/* SCORM 2004 */
		return scormGetValue("cmi.objectives." + sIndex + ".completion_status");
	}
}

/*
* Get the objective progress measure
*/
function getObjectiveCompletionPercentage(sIndex) {
	if (_sAPI == "API") {
		return "";
	} else {
		return scormGetValue("cmi.objectives." + sIndex + ".progress_measure");
	}
}

/*
* get the objective success status
* 	returns passed, failed or unknown
*/
function getObjectivePassFail(sIndex) {
	if (_sAPI == "API") {
			return "";
	} else {
		return scormSetValue("cmi.objectives." + sIndex + ".success_status");
	}
}


/*
* Get the objective description
*/
function getObjectiveDescription(sIndex) {
	if (_sAPI == "API") {
		return "";
	} else {
		return scormGetValue("cmi.objectives." + sIndex + ".description");
	}
}

/* TYPE OF COMMUNICATION FUNCTIONS */

/*
* return true if we can communicate with the LMS, else false
*/
function canCommunicateWithLMS() {
	if (apiHandle != null) {
		/* we found a SCORM API adapter */
		return true;
	}
	
	/* did not find the adapter */
	return false;
}

/*
* return the type of communications with the LMS
*/
function getCommunicationsType() {
	/* see if this is SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* this is SCORM 2004 */
		return "SCORM 2004";
	} else if (_sAPI == "API") {
		/* it is */
		return "SCORM 1.2";
	}
	
	/* no adapter found */
	return "none";
}


/* LOWER LEVEL FUNCTIONS DIRECT COMMUNICATIONS WITH THE SCORM 1.2 and SCORM 2004 RUNTIME API */

/*
* call the SCORM initialize function
*/
function scormInitialize() {
	var API = getAPI();
	if (API == null)
		return "false";

	/* call the correct SCORM function */
	if (_sAPI == "API")
		var result = API.LMSInitialize("");
	else
		var result = API.Initialize("");
		
	showDebug('called Initialize, return=' + result);
		
	return result;
}

/*
* call the SCORM finish function
*/
function scormTerminate() {
	var API = getAPI();
	if (API == null)
		return "false";
		
	/* call the correct SCORM function */
	if (_sAPI == "API")
		var result = API.LMSFinish("");
	else
		var result = API.Terminate("");
		
	showDebug('called Finish/Terminate, return=' + result);
	return result;
}

/*
* call the SCORM commit function
*/
function scormCommit() {
	var API = getAPI();
	if (API == null)
		return "false";
		
	/* call the correct SCORM function */
	if (_sAPI == "API")
		var result = API.LMSCommit("");
	else
		var result = API.Commit("");
	
	showDebug('called Commit, return=' + result);
	return result;
}

/*
* call the SCORM GetValue function
*/
function scormGetValue(name) {
	var API = getAPI();
	if (API == null)
		return "";

	/* call the correct SCORM function */
	if (_sAPI == "API") {
		var value = API.LMSGetValue(name);
		var errCode = API.LMSGetLastError();
	} else {
		var value = API.GetValue(name);
		var errCode = API.GetLastError();
	}
	
	showDebug('called GetValue:' + name+ ', return=' + value + ' error code=' + errCode);
	
	/* see if there is an error */
	if (errCode != "0") {
		/* there is, return an empty string */
		return "";
	} else {
		return value;
	}
}

/*
* call the SCORM SetValue function
*/
function scormSetValue(name, value) {
	var API = getAPI();
	if (API == null)
		return "true";

	/* call the correct SCORM function */
	if (_sAPI == "API")
		var result = API.LMSSetValue(name, value);
	else
		var result = API.SetValue(name, value);
	showDebug('called SetValue:' + name+ ', value=' + value + ' return =' + result);
	return result;
}

/*
* call the SCORM GetLastError function
*/
function scormGetLastError() {
	var API = getAPI();
	if (API == null) {
		/* there is no API available, by returning a not implemented
		*  error code, we let caller assume that the last SCORM
		*  function failed */
		return "401";
	}

	/* call the correct SCORM function */
	if (_sAPI == "API")
		return API.LMSGetLastError();
	else
		return API.GetLastError();
}

/*
* call the SCORM GetErrorString function
*/
function scormGetErrorString() {
	var API = getAPI();
	if (API == null)
		return "";

	/* call the correct SCORM function */
	if (_sAPI == "API")
		return API.LMSGetErrorString();
	else
		return API.GetErrorString();
}

/*
* call the SCORM GetDiagnostic function
*/
function scormGetDiagnostic() {
	var API = getAPI();
	if (API == null)
		return "";

	/* call the correct SCORM function */
	if (_sAPI == "API")
		return API.LMSGetDiagnostic();
	else
		return API.GetDiagnostic();
}



/*** PRIVATE FUNCTIONS USED TO SUPPORT THE TOOLKIT'S PUBLIC FUNCTIONS ***/

/*
* return an ISO 8601 time stamp given a JavaScript date object. The time stamp is in the format required for SCORM 2004.
*/
function dateToTimestamp(date) {
	/* get the parts of the date in UTC time */
	var year    = date.getUTCFullYear();
	var month   = date.getUTCMonth() + 1;
	var day     = date.getUTCDate();
	var hours   = date.getUTCHours();
	var minutes = date.getUTCMinutes();
	var seconds = date.getUTCSeconds();
	var milli   = Math.round(date.getUTCMilliseconds() / 10);

	/* pad a zero if the value is a single digit */
	month   = (month < 10)   ? "0" + month   : month;
	day     = (day < 10)     ? "0" + day     : day;
	hours   = (hours < 10)   ? "0" + hours   : hours;
	minutes = (minutes < 10) ? "0" + minutes : minutes;
	seconds = (seconds < 10) ? "0" + seconds : seconds;
	milli   = (milli < 10)   ? "0" + milli   : milli;

	/* assemble the 8601 timestamp and return it */
	return year + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds + "." + milli + "Z";
}

/*
* return the current hours:minutes:seconds given a date object for SCORM 1.2
*/
function getHMS(dateNow) {
	var hh = dateNow.getHours();
	var mm = dateNow.getMinutes();
	var ss = dateNow.getSeconds();
	if (hh<10) hh = "0" + hh;
	if (mm<10) mm = "0" + mm;
	if (ss<10) ss = "0" + ss;
	
	if (_sAPI == "API") {
		return hh + ":" + mm + ":" + ss;
	} else {
		var month = dateNow.getMonth() + 1;
		if (month<10) month = "0" + month;
		var day = dateNow.getDate();
		if (day<10)   day   = "0" + day;
		return dateNow.getFullYear() + "-" + month + "-" + day + 
	           "T" + hh + ":" + mm + ":" + ss;
	}
}

/*
* Convert elapsed time in milliseconds to the correct SCORM format
*	timeRaw - the time returned by the JavaScript function date.getTime()
*/
function formatTime(timeRaw) {
	/* get the hours, minutes and seconds from the raw time */
	var hh = Math.floor(timeRaw / 3600);
	timeRaw -= hh * 3600;
	var mm = Math.floor(timeRaw / 60);
	timeRaw -= mm * 60;
	var ss = timeRaw;
	
	/* see if this is SCORM 2004 */
	if (_sAPI == "API_1484_11") {
		/* it is, return the correct value */
		return "PT" + hh + "H" + mm + "M" + ss + "S";
	} else if (_sAPI == "API") {	
		/* this is SCORM 1.2 pad the time values with a 0 if needed */
		if (hh<10) hh = "0" + hh;
		if (mm<10) mm = "0" + mm;
		if (ss<10) ss = "0" + ss;
		
		/* return the correct value */
		return hh + ":" + mm +":" + ss;
	}	
	
	/* no SCORM so return an empty string */
	return "";
}

/*
* get the index of an objective from its id
*/
function getIndexFromId(sId) {
	/* get the count of objectives */
	var nCount = scormGetValue("cmi.objectives._count") - 0;
	
	/* see if there is a count */
	if (nCount > 0) {
		/* there is, loop through the objective ids */
		for (var i=0; i<nCount; i++) {
			/* see if this is the index of the id */
			if (scormGetValue("cmi.objectives." + i + ".id") == sId) {
				/* it does, return the index */
				return i+"";
			}
		}
		
		/* no match, return null */
		return null;
	} else {
		/* not children, return null */
		return null;
	}
}

/*
* look up through the frameset hierarchy for the SCORM API
*/
function findAPI(win, apiName) {
	/* see if the API is not in this window AND the parent is not null AND there is a parent window */
	while ((win[apiName] == null) && (win.parent != null) && (win.parent != win)) {
		/* did not find the API in this window, get the parent */
		win = win.parent;
	}
	
	/* we found the API or ran out of parent windows, set the result */
	apiHandle = win[apiName];
}

/*
* return the SCORM 1.2 or SCORM 2004 API
*/
function getAPI() {
	/* return the API if we already found it */
	if (apiHandle != null)
		return apiHandle;

	/* look for the SCORM 20004 API up in the frameset */
	findAPI(window, 'API_1484_11');

	/* if we still have not found the SCORM 2004 API, look at the opener and it's frameset */
	if ((apiHandle == null) && (window.opener != null)) {
		findAPI(window.opener, 'API_1484_11');
	}
	
	/* see if we found the SCORM 2004 API */
	if (apiHandle == null) {
		/* we did not, look for the SCORM 1.2 API in the frameset */
		findAPI(window, 'API');
	
		/* if we still have not found the SCORM 2004 API, look at the opener and it's frameset */
		if ((apiHandle == null) && (window.opener != null)) {
			findAPI(window.opener, 'API');
		}
		
		/* see if we found the API */
		if (apiHandle != null) {
			/* we did, remember that we found the SCORM 1.2 API */
			_sAPI = 'API';
		}
	} else {
		/* we found the SCOM 2004 API, remember it */
		_sAPI = 'API_1484_11';
	}
	
	/* return it */
	return apiHandle;
}

var _wDebug;

function showDebug(sDebug) {

	// see if debug is turned on
	if (_bDebug) {
		// it is, see if we have created the debug window
		if (_wDebug && !_wDebug.closed) {
			
		} else {
			// we have not, create the window
			_wDebug=open('','debugwindow','width=800,height=700,scrollbars=yes,resizable=yes');
			_wDebug.document.write('<html><head><title>Debug window</title></head><body>');
		}
		
		// write out the debug information

		_wDebug.document.write(sDebug + "<br>");

	}
}
