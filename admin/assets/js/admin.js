/* This file is part of Mura CMS. 

	Mura CMS is free software: you can redistribute it and/or modify 
	it under the terms of the GNU General Public License as published by 
	the Free Software Foundation, Version 2 of the License. 

	Mura CMS is distributed in the hope that it will be useful, 
	but WITHOUT ANY WARRANTY; without even the implied warranty of 
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
	GNU General Public License for more details. 

	You should have received a copy of the GNU General Public License 
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. 

	Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
	Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.
	
	However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
	or libraries that are released under the GNU Lesser General Public License version 2.1.
	
	In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
	independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
	Mura CMS under the license of your choice, provided that you follow these specific guidelines: 
	
	Your custom code 
	
	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories.
	
	 /admin/
	 /tasks/
	 /config/
	 /requirements/mura/
	 /Application.cfc
	 /index.cfm
	 /MuraProxy.cfc
	
	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
	requires distribution of source code.
	
	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */

function loadObject(url, target, message) {
	// branch for native XMLHttpRequest object
	var req;
	var tg = target;

	processReqChange = function() {

		if(req.readyState == 4) {
			// only if "OK"
			if(req.status == 200) {
				document.getElementById(tg).innerHTML = req.responseText;
			}
		}
	}

	document.getElementById(tg).innerHTML = message;

	if(window.XMLHttpRequest) {
		req = new XMLHttpRequest();
		req.onreadystatechange = processReqChange;
		req.open("GET", url, true);
		req.send(null);
		// branch for IE/Windows ActiveX version
	} else if(window.ActiveXObject) {
		req = new ActiveXObject("Microsoft.XMLHTTP");
		if(req) {
			req.onreadystatechange = processReqChange;
			req.open("GET", url, true);
			req.send();
		}
	}
}

//content scheduling
var dtCh = "/";
var minYear = 1800;
var maxYear = 2100;
var dtFormat = [0, 1, 2];
var dtExample = "12/31/2016";

function isInteger(s) {
	var i;
	for(i = 0; i < s.length; i++) {
		// Check that current character is number.
		var c = s.charAt(i);
		if(((c < "0") || (c > "9"))) return false;
	}
	// All characters are numbers.
	return true;
}

function stripCharsInBag(s, bag) {
	var i;
	var returnString = "";
	// Search through string's characters one by one.
	// If character is not in bag, append to returnString.
	for(i = 0; i < s.length; i++) {
		var c = s.charAt(i);
		if(bag.indexOf(c) == -1) returnString += c;
	}
	return returnString;
}

function daysInFebruary(year) {
	// February has 29 days in any year evenly divisible by four,
	// EXCEPT for centurial years which are not also divisible by 400.
	return(((year % 4 == 0) && ((!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28);
}

function DaysArray(n) {
	for(var i = 1; i <= n; i++) {
		this[i] = 31
		if(i == 4 || i == 6 || i == 9 || i == 11) {
			this[i] = 30
		}
		if(i == 2) {
			this[i] = 29
		}
	}
	return this
}

function parseDateTimeSelector(id){
	//alert($('.datepicker.mura-datepicker' + id).val())
	if(isDate($('.datepicker.mura-datepicker' + id).val())){
		var dtStr=$('.datepicker.mura-datepicker' + id).val();
		var daysInMonth = DaysArray(12);
		var dtArray = dtStr.split(dtCh);
		var strMonth = dtArray[dtFormat[0]];
		var strDay = dtArray[dtFormat[1]];
		var strYear = dtArray[dtFormat[2]];
	
		var strMinute = ($('#mura-' + id + 'Minute').length) ? $('#mura-' + id + 'Minute').val() : 0;
		var strHour=($('#mura-' + id + 'Hour').length) ? $('#mura-' + id + 'Hour').val() : 0;

		if($('#mura-' + id + 'DayPart').length){
			if($('#mura-' + id + 'DayPart').val().toLowerCase() == 'pm'){
				strHour=parseInt(strHour) + 12;
				if(strHour==24){
					strHour=12;
				}
			} else if (parseInt(strHour) ==12) {
				strHour=0;
			}
		}

		//alert('#mura-' + id + 'Minute');

		if(strHour.length==1){
			strHour='0' + strHour;
		}

		if(strMinute.length==1){
			strMinute='0' + strMinute;
		}

		var newVal="{ts '" + strYear + "-" + strMonth + "-" + strDay + " " + strHour + ":" + strMinute + ":00'}";
		
		$('#mura-' + id).val(newVal);
		//alert($('#mura-' + id).val());
	} else {
		$('#mura-' + id).val('');
	}


}

function isDate(dtStr) {
	var daysInMonth = DaysArray(12);
	var dtArray = dtStr.split(dtCh);

	if(dtArray.length != 3) {
		//alert("The date format for the "+fldName+" field should be : short")
		return false
	}
	var strMonth = dtArray[dtFormat[0]];
	var strDay = dtArray[dtFormat[1]];
	var strYear = dtArray[dtFormat[2]];

	/*
	if(strYear.length == 2){
		strYear="20" + strYear;
	}
	*/

	strYr = strYear;

	if(strDay.charAt(0) == "0" && strDay.length > 1) strDay = strDay.substring(1)
	if(strMonth.charAt(0) == "0" && strMonth.length > 1) strMonth = strMonth.substring(1)
	for(var i = 1; i <= 3; i++) {
		if(strYr.charAt(0) == "0" && strYr.length > 1) strYr = strYr.substring(1)
	}

	month = parseInt(strMonth)
	day = parseInt(strDay)
	year = parseInt(strYr)

	if(month < 1 || month > 12) {
		//alert("Please enter a valid month in the "+fldName+" field")
		return false
	}
	if(day < 1 || day > 31 || (month == 2 && day > daysInFebruary(year)) || day > daysInMonth[month]) {
		//alert("Please enter a valid day  in the "+fldName+" field")
		return false
	}
	if(strYear.length != 4 || year == 0 || year < minYear || year > maxYear) {
		//alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear +" in the "+fldName+" field")
		return false
	}
	if(isInteger(stripCharsInBag(dtStr, dtCh)) == false) {
		//alert("Please enter a valid date in the "+fldName+" field")
		return false
	}
	return true;
}

function isEmail(cur) {
	var string1 = cur
	if(string1.indexOf("@") == -1 || string1.indexOf(".") == -1) {
		return false;
	} else {
		return true;
	}

}

function isColor(c){
    var i= 0, itm,
    M= c.replace(/ +/g, '').match(/(rgba?)|(\d+(\.\d+)?%?)|(\.\d+)/g);
    if(M && M.length> 3){
        while(i<3){
            itm= M[++i];
            if(itm.indexOf('%')!= -1){
                itm= Math.round(parseFloat(itm)*2.55);
            }
            else itm= parseInt(itm);
            if(itm<0 || itm> 255) return NaN;
            M[i]= itm;
        }
        if(c.indexOf('rgba')=== 0){
            if(M[4]==undefined ||M[4]<0 || M[4]> 1) return NaN;
        }
        else if(M[4]) return NaN;
        return M[0]+'('+M.slice(1).join(',')+')';
    }
    return NaN;
}

function isURL(url){
	urlPattern = /(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/

	return url.match(urlPattern);
}

function stripe(theclass) {

	$('table.' + theclass + ' tr').each(

	function(index) {
		if(index % 2) {
			$(this).addClass('alt');
		} else {
			$(this).removeClass('alt');
		}
	});
	$('div.mura-grid.' + theclass + ' dl').each(

	function(index) {
		if(index % 2) {
			$(this).addClass('alt');
		} else {
			$(this).removeClass('alt');
		}
	});
}


// PopUp Windows for Specific Functionality
newWindow = null

function toggleDisplay(id, expand, close) {

	if(document.getElementById(id).style.display == 'none') {

		document.getElementById(id).style.display = '';
		if(document.getElementById(id + 'Link')) {
			var theLink = document.getElementById(id + 'Link');
			theLink.innerHTML = '[' + close + ']';
		}

	} else {
		document.getElementById(id).style.display = 'none';
		if(document.getElementById(id + 'Link')) {
			var theLink = document.getElementById(id + 'Link');
			theLink.innerHTML = '[' + expand + ']';
		}

	}
}

function openDisplay(id, close) {

	if(document.getElementById(id).style.display == 'none') {

		$("#" + id).slideDown();
		if(document.getElementById(id + 'Link')) {
			var theLink = document.getElementById(id + 'Link');
			theLink.innerHTML = '[' + close + ']';
		}
		document.getElementById(id).style.display = "";
	}

}

function toggleDisplay2(id, display) {
	document.getElementById(id).style.display = (display == true) ? '' : 'none';
}

/* These aren't used anymore that I can see

function intuserselect(groupid, route, s2, siteid) {
	newWindow = window.open("view/vPrivateUsers/index.cfm?groupid=" + groupid + "&route=" + route + "&s2=" + s2 + "&siteid=" + siteid, "newWin", "toolbar=no,location=no,scrollbars=yes,resize=yes,width=322,height=302,left=200,top=200")
	newWindow.focus();
}


function extuserselect(groupid, route, s2, siteid) {
	newWindow = window.open("view/vPublicUsers/index.cfm?groupid=" + groupid + "&route=" + route + "&s2=" + s2 + "&siteid=" + siteid, "newWin", "toolbar=no,location=no,scrollbars=yes,resize=yes,width=400,height=400,left=200,top=200")
	newWindow.focus();
}
*/


function validate(theForm) {
	return validateForm(theForm);
}

function getValidationFieldName(theField) {
	if(theField.getAttribute('data-label') != undefined) {
		return theField.getAttribute('data-label');
	} else if(theField.getAttribute('label') != undefined) {
		return theField.getAttribute('label');
	} else {
		return theField.getAttribute('name');
	}
}

function getValidationIsRequired(theField) {
	if(theField.getAttribute('data-required') != undefined) {
		return(theField.getAttribute('data-required').toLowerCase() == 'true');
	} else if(theField.getAttribute('required') != undefined) {
		return(theField.getAttribute('required').toLowerCase() == 'true');
	} else {
		return false;
	}
}

function getValidationMessage(theField, defaultMessage) {
	if(theField.getAttribute('data-message') != undefined) {
		return theField.getAttribute('data-message') + '<br/>';
	} else if(theField.getAttribute('message') != undefined) {
		return theField.getAttribute('message') + '<br/>';
	} else {
		return getValidationFieldName(theField).toUpperCase() + defaultMessage + '<br/>';
	}
}

function getValidationType(theField) {
	if(theField.getAttribute('data-validate') != undefined) {
		return theField.getAttribute('data-validate').toUpperCase();
	} else if(theField.getAttribute('validate') != undefined) {
		return theField.getAttribute('validate').toUpperCase();
	} else {
		return '';
	}
}

function hasValidationMatchField(theField) {
	if(theField.getAttribute('data-matchfield') != undefined && theField.getAttribute('data-matchfield') != '') {
		return true;
	} else if(theField.getAttribute('matchfield') != undefined && theField.getAttribute('matchfield') != '') {
		return true;
	} else {
		return false;
	}
}

function getValidationMatchField(theField) {
	if(theField.getAttribute('data-matchfield') != undefined) {
		return theField.getAttribute('data-matchfield');
	} else if(theField.getAttribute('matchfield') != undefined) {
		return theField.getAttribute('matchfield');
	} else {
		return '';
	}
}

function hasValidationRegex(theField) {
	if(theField.value != undefined) {
		if(theField.getAttribute('data-regex') != undefined && theField.getAttribute('data-regex') != '') {
			return true;
		} else if(theField.getAttribute('regex') != undefined && theField.getAttribute('regex') != '') {
			return true;
		}
	} else {
		return false;
	}
}

function getValidationRegex(theField) {
	if(theField.getAttribute('data-regex') != undefined) {
		return theField.getAttribute('data-regex');
	} else if(theField.getAttribute('regex') != undefined) {
		return theField.getAttribute('regex');
	} else {
		return '';
	}
}

function validateForm(theForm) {
	var errors = "";
	var setFocus = 0;
	var started = false;
	var startAt;
	var firstErrorNode;
	var validationType = '';
	var frmInputs = theForm.getElementsByTagName("input");
	for(f = 0; f < frmInputs.length; f++) {
		theField = frmInputs[f];
		validationType = getValidationType(theField);

		if(theField.style.display == "") {
			if(getValidationIsRequired(theField) && theField.value == "") {
				if(!started) {
					started = true;
					startAt = f;
					firstErrorNode = "input";
				}

				errors += getValidationMessage(theField, ' is required.');

			} else if(validationType != '') {

				if(validationType == 'EMAIL' && theField.value != '' && !isEmail(theField.value)) {
					if(!started) {
						started = true;
						startAt = f;
						firstErrorNode = "input";
					}

					errors += getValidationMessage(theField, ' must be a valid email address.');

				} else if(validationType == 'NUMERIC' && theField.value != '' && isNaN(theField.value)) {
					if(!isNaN(theField.value.replace(/\$|\,|\%/g, ''))) {
						theField.value = theField.value.replace(/\$|\,|\%/g, '');

					} else {
						if(!started) {
							started = true;
							startAt = f;
							firstErrorNode = "input";
						}

						errors += getValidationMessage(theField, ' must be numeric.');
					}
				} else if(validationType == 'COLOR' && theField.value != '') {
					//var re = new RegExp("(^#?([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?$)||");
					if( !isColor(theField.value) ) {
						if(!started) {
							started = true;
							startAt = f;
							firstErrorNode = "input";
						}

						errors += getValidationMessage(theField, ' is not a valid color.');
					}
				} else if(validationType == 'URL' && theField.value != '') {
					//var re = new RegExp("(^#?([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?$)||");
					if( !isURL(theField.value) ) {
						if(!started) {
							started = true;
							startAt = f;
							firstErrorNode = "input";
						}

						errors += getValidationMessage(theField, ' is not a valid URL.');
					}
				} else if(validationType == 'REGEX' && theField.value != '' && hasValidationRegex(theField)) {
					var re = new RegExp(getValidationRegex(theField));
					if(!theField.value.match(re)) {
						if(!started) {
							started = true;
							startAt = f;
							firstErrorNode = "input";
						}

						errors += getValidationMessage(theField, ' is not valid.');
					}
				} else if(validationType == 'MATCH' && hasValidationMatchField(theField) && theField.value != theForm[getValidationMatchField(theField)].value) {
					if(!started) {
						started = true;
						startAt = f;
						firstErrorNode = "input";
					}

					errors += getValidationMessage(theField, ' must match' + getValidationMatchField(theField) + '.');

				} else if((validationType == 'DATE' || validationType == 'DATETIME') && theField.value != '' && !isDate(theField.value)) {
					if(!started) {
						started = true;
						startAt = f;
						firstErrorNode = "input";
					}

					errors += getValidationMessage(theField, ' must be a valid date [MM/DD/YYYY].');

				}
			}

		}
	}
	var frmTextareas = theForm.getElementsByTagName("textarea");
	for(f = 0; f < frmTextareas.length; f++) {


		theField = frmTextareas[f];
		validationType = getValidationType(theField);

		if(theField.style.display == "" && getValidationIsRequired(theField) && theField.value == "") {
			if(!started) {
				started = true;
				startAt = f;
				firstErrorNode = "textarea";
			}

			errors += getValidationMessage(theField, ' is required.');
		} else if(validationType != '') {
			if(validationType == 'REGEX' && theField.value != '' && hasValidationRegex(theField)) {
				var re = new RegExp(getValidationRegex(theField));
				if(!theField.value.match(re)) {
					if(!started) {
						started = true;
						startAt = f;
						firstErrorNode = "input";
					}

					errors += getValidationMessage(theField, ' is not valid.');
				}
			}
		}
	}

	var frmSelects = theForm.getElementsByTagName("select");
	for(f = 0; f < frmSelects.length; f++) {
		theField = frmSelects[f];
		validationType = getValidationType(theField);
		if(theField.style.display == "" && getValidationIsRequired(theField) && theField.options[theField.selectedIndex].value == "") {
			if(!started) {
				started = true;
				startAt = f;
				firstErrorNode = "select";
			}

			errors += getValidationMessage(theField, ' is required.');
		}
	}

	if(errors != "") {

		if(firstErrorNode == "input") {
			frmInputs[startAt].focus();
		} else if(firstErrorNode == "textarea") {
			frmTextareas[startAt].focus();
		} else if(firstErrorNode == "select") {
			frmSelects[startAt].focus();
		}

		$("#alertDialogMessage").html(errors);
		$("#alertDialog").dialog({
			resizable: false,
			modal: true,
			position: getDialogPosition(),
			buttons: {
				Ok: function() {
					$(this).dialog('close');
					if(firstErrorNode == "input") {
						frmInputs[startAt].focus();
					} else if(firstErrorNode == "textarea") {
						frmTextareas[startAt].focus();
					} else if(firstErrorNode == "select") {
						frmSelects[startAt].focus();
					}
				}
			}
		});

		return false;
	} else {
		return true;
	}

}


function submitForm(frm, action, msg) {
	var message = msg;
	var currentFrm = frm;
	if(validateForm(frm)) {

		if(typeof(action) != 'undefined' && action != 'delete') {
			var frmInputs = frm.getElementsByTagName("input");
			for(f = 0; f < frmInputs.length; f++) {
				if(frmInputs[f].getAttribute('name') == 'action') {
					frmInputs[f].setAttribute('value', action);
				}
			}


		} else if(action == 'delete') {
			$("#alertDialogMessage").html(message);
			$("#alertDialog").dialog({
				modal: true,
				position: getDialogPosition(),
				buttons: {
					'Yes': function() {
						$(this).dialog('close');
						var frmInputs = currentFrm.getElementsByTagName("input");
						for(f = 0; f < frmInputs.length; f++) {
							if(frmInputs[f].getAttribute('name') == 'action') {
								frmInputs[f].setAttribute('value', action);
							}
						}
						currentFrm.submit();
					},
					'No': function() {
						$(this).dialog('close');
					}
				}
			});

			return false;
		}

		if(typeof(htmlEditorType) != "undefined") {
			if(htmlEditorType != 'fckeditor') {
				for(var name in CKEDITOR.instances) {
					if(typeof(CKEDITOR.instances[name]) != 'undefined' && CKEDITOR.instances[name] != null) {
						if($('#' + name).length) {
							CKEDITOR.instances[name].updateElement();
						}
					}
				}

			}
		}

		actionModal(

		function() {
			frm.submit();
			formSubmitted = true;
		});


	}
	return false;
}

function actionModal(action) {
	$('body').append('<div id="action-modal" class="modal-backdrop fade in"></div>');
	$('#action-modal').spin(spinnerArgs);
	
	if(action){
		if(typeof(action)=='string'){
			location.href=action;
		} else {
			action();
		}
	}
 
	return false;
}

function preview(url, targetParams) {

	if(targetParams == '') {
		newWindow = window.open(url, 'previewWin');
	} else {
		newWindow = window.open(url, 'previewWin', targetParams);
	}
	newWindow.focus();
	void(0);
	return false;
}

function createCookie(name, value, days) {
	if(days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		var expires = "; expires=" + date.toGMTString();
	} else var expires = "";
	document.cookie = name + "=" + value + expires + "; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while(c.charAt(0) == ' ') c = c.substring(1, c.length);
		if(c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
	}
	return "";
}

function eraseCookie(name) {
	createCookie(name, "", -1);
}

var HTMLEditorLoadCount = 0;

function setHTMLEditors() {
	var allPageTags = document.getElementsByTagName("textarea");
	var editors = new Array();
	for(i = 0; i < allPageTags.length; i++) {
		if(allPageTags[i].className == "htmlEditor") {

			var instance = CKEDITOR.instances[allPageTags[i].id];
			if(typeof(instance) != 'undefined' && instance != null) {
				CKEDITOR.remove(instance);
			}

			if($(document.getElementById(allPageTags[i].id)).val() == '') {
				$(document.getElementById(allPageTags[i].id)).val("<p></p>")
			}

			$(document.getElementById(allPageTags[i].id)).ckeditor({
				toolbar: 'Default',
				customConfig: 'config.js.cfm'
			}, htmlEditorOnComplete);
	
		}
	}
}

function htmlEditorOnComplete(editorInstance) {

	var instance = $(editorInstance).ckeditorGet();
	instance.resetDirty();
	var totalIntances = CKEDITOR.instances;
	CKFinder.setupCKEditor(
	instance, {
		basePath: context + '/requirements/ckfinder/',
		rememberLastFolder: false
	});


	HTMLEditorLoadCount++;

	var count = 0;

	for(k in totalIntances) {
		count++
	}

	try {
		if(HTMLEditorLoadCount >= count) {
			document.getElementById("actionButtons").style.display = "block";
		} else {
			document.getElementById("actionButtons").style.display = "none";
		}
	} catch(err) {}


}

function setDatePickers(target, locale, delim) {

	if($.datepicker.regional[locale] == undefined) {
		var _locale = locale.substring(0, 2);
	} else {
		var _locale = locale;
	}

	if($.datepicker.regional[_locale] != undefined) {
		$(target).each(

		function(index) {
			$(this).datepicker($.datepicker.regional[_locale]).datepicker("option", "changeYear", true).datepicker("option", "changeMonth", true);
		});
	} else {
		$(target).each(

		function(index) {
			$(this).datepicker($.datepicker.regional['']).datepicker("option", "changeYear", true).datepicker("option", "changeMonth", true);
		});
	}
}

function setColorPickers(target) {
	$(target).each(

	function(index) {
		$(this).colorpicker({
			format: 'rgba'
		}).on('changeColor', function(e) {
			var rgb=e.color.toRGB();
			$(this).val('rgba('+rgb.r+','+rgb.g+','+rgb.b+','+rgb.a+')');
		});
	});
}

function setToolTips(target) {
	if(typeof $(target).tooltip =='function'){
		$(target).tooltip({
			selector: "a[rel=tooltip]"
		});
	}

	$(target + ' a[rel=tooltip]').click(function(e) {
		e.preventDefault();
		return false
	});
}

function setTabs(target, activetab) {
	$(".tab-preloader").spin(spinnerArgs2);
	/*
	$(target).each(
		function(index) {			
			$(this).tabs().fadeIn()
			.find(".ui-corner-all")
			.each(
			 function(index){
				 $(this).removeClass("ui-corner-all");
			 	}
			)
		}
	);*/
	$(target + ' a').click(function(e) {
		e.preventDefault();
		$(this).tab('show');
	});

	if(window.location.hash != "") {
		$(target + ' a[href="' + window.location.hash + '"]').tab('show');
	} else if(typeof(activetab) != 'undefined') {
		try{
			$(target + ' li::nth-child(' + (activetab + 1) + ') a').tab('show');
		} 
		catch(err){
			if($(target + ' li:first a').tab){
				$(target + ' li:first a').tab('show');
			}
		}
	} else {
		$(target + ' li:first a').tab('show');
	}

	/*
	$(".ui-tabs .ui-tabs .ui-tabs-nav li").each(
			function(index) {			
				$(this).removeClass("ui-corner-top").addClass("ui-corner-all");
			}
		);
	
	$(".initActiveTab").each(
			function(index) {			
				$(this).tabs("select",activetab);
			}
		);

	*/
	$(".tab-preloader").hide().spin(false);
}

function setAccordions(target, activepanel) {

	$(target).each(

	function(index) {
		if(activepanel != null) {
			$(this).accordion({
				active: activepanel
			})
		} else {
			$(this).accordion();
		}
	});
	//$(target).collapse();
}

function setCheckboxTrees() {
	$('.checkboxTree').each(

	function() {
		$(this).collapsibleCheckboxTree({
			checkParents: false,
			checkChildren: false,
			uncheckChildren: true,
			initialState: 'default'
		});
	});
}

function openFileMetaData(contenthistid,fileid,siteid,property) {

		if (typeof fileMetaDataAssign === 'undefined') {
			fileMetaDataAssign={};
		}

 		$("#newFileMetaContainer").remove();
		$("body").append('<div id="newFileMetaContainer" title="Loading..." style="display:none"><div id="newFileMeta"><div class="load-inline"></div></div></div>');

		var _focusTabbable=$.ui.dialog.prototype._focusTabbable;
		$.ui.dialog.prototype._focusTabbable = function(){};
		$("#newFileMetaContainer").dialog({
			resizable: false,
			modal: true,
			width: 552,
			title: 'Edit Image Properties',
			position: getDialogPosition(),
			buttons: {
				Save:function(){
					var fileData={exifpartial:{}};

					$('.filemeta').each(function(){
						fileData[$(this).attr('data-property')]=$(this).val();
					});

					$('.exif').each(function(){
						fileData.exifpartial[$(this).attr('data-property')]=$(this).val();
					});

					fileData.setasdefault=$('#filemeta-setasdefault').is(':checked');

					fileMetaDataAssign[property]=fileData;
					$('#filemetadataassign').val(JSON.stringify(fileMetaDataAssign));
					//alert($('#filemetadataassign').val());
					$(this).dialog( "close" );

				},
				Cancel: function(){
					 $(this).dialog( "close" );
				}


			},
			open: function() {
				$('.ui-widget-overlay').css('z-index',500);
				$('.ui-dialog').css('z-index',501);
				$("#newFileMetaContainer").html('<div class="ui-dialog-content ui-widget-content"><div class="load-inline"></div></div>');
				var url = 'index.cfm';
				var pars = 'muraAction=cArch.loadfilemetadata&fileid=' + fileid + '&property=' + property  + '&contenthistid=' + contenthistid + '&siteid=' + siteid + '&cacheid=' + Math.random();
				$("#newFileMetaContainer .load-inline").spin(spinnerArgs2);

				$.get(url + "?" + pars).done(function(data) {

					if(data.indexOf('mura-primary-login-token') != -1) {
						location.href = './';
					}
					
					$("#newFileMetaContainer .load-inline").spin(false);
					$('#newFileMetaContainer').html(data);
					
					if(property in fileMetaDataAssign){
						var fileData=fileMetaDataAssign[property];
						for(var p in fileData){
							$('.filemeta[data-property="' + p +'"]').val(fileData[p]);
						}

						$('#filemeta-setasdefault').prop('checked',fileData.setasdefault);
					}
					
					$('#newFileMetaContainer .htmlEditor').ckeditor({
							toolbar: 'Basic',
							height: 100,
							customConfig: 'config.js.cfm'
						}, htmlEditorOnComplete);

					/*
					$('#file-credits').ckeditor({
							toolbar: 'Default',
							customConfig: 'config.js.cfm'
						}, htmlEditorOnComplete);*/

					setTabs("#newFileMetaContainer.tabs",0);
					setDatePickers(".datepicker",dtLocale);

					$("#newFileMetaContainer").dialog("option", "position", getDialogPosition());


					$('.filemeta:first').focus();

				}).error(function(data){
					$('#newFileMetaContainer').html(data.responseText);
					$("#newFileMetaContainer").dialog("option", "position", getDialogPosition());
				});

			},
			close: function() {
				$(this).dialog("destroy");
				$("#newFileMetaContainer").remove();
				$.ui.dialog.prototype._focusTabbable=_focusTabbable;
			}
		});

		return false;
	}
 
(function ($) {

	 /* BUTTON PUBLIC CLASS DEFINITION
	  * ============================== */

	  var FileSelector = function (element, options) {
	    var $elm= this.$element = $(element);
	    var $opts = this.options = $.extend({}, $.fn.fileselector.defaults, options);

	    if($(this.$element).attr('data-name')){
	    	this.options.file=this.$element.attr('data-name');
	    }

	    var loadAssocFiles=function(keywords) {
			var url = 'index.cfm';
			var pars = 'muraAction=cArch.assocfiles&compactDisplay=true&siteid=' + $elm.attr('data-siteid') + '&fileid=' + $elm.attr('data-fileid') + '&type=' + $elm.attr('data-filetype') + '&contentid=' + $elm.attr('data-contentid') +  '&property=' + $elm.attr('data-property') +'&keywords=' + keywords + '&cacheid=' + Math.random();
			$elm.find(".mura-file-existing").html('<div class="load-inline"></div>');
			$elm.find('.load-inline').spin(spinnerArgs2);
			$.ajax(url + "?" + pars)
			.done( 
				function(data) {
					$elm.find('.load-inline').spin(false);
					$elm.find(".mura-file-existing").html(data);
					$elm.find(".mura-file-existing").find('.btn').click(function(){
						loadAssocFiles($elm.find(".mura-file-existing").find(".filesearch").val());
					});

					setTabs('#selectAssocImageResults-' + $elm.attr('data-property'),0);
				}
			)
			.error(
				function(data) {
				$elm.find('.load-inline').spin(false);
				$elm.find(".mura-file-existing").html(data.responseText);
				}
			);
		}
	   

	    var clickHandler=function(){
	    	setTab($(this).val());
	    	if($(this).val().toLowerCase() == 'existing'){
	    		loadAssocFiles('');
	    	} else {
	    		$elm.find(".mura-file-existing").html('<div class="load-inline"></div>')
	    		$elm.find('.load-inline').spin(spinnerArgs2);
	    	}
	    }

	    var setTab=function(tab){
	    	
	    	//if(tab.toLowerCase() != 'upload'){
			$elm.find(".mura-file-option").find('input').val('');
			$elm.find(".mura-file-option").find('.btn').hide();
			//}

	    	$elm.find(".mura-file-option").hide();
	    	$elm.find(".mura-file-" + tab.toLowerCase()).show();
			$elm.find(".mura-file-option").find("input").attr('name','');
			$elm.find(".mura-file-" + tab.toLowerCase()).find("input").attr('name',$opts.file);

	    }
	
	    $(this.$element).find("button.mura-file-type-selector").click(clickHandler);
	   
	    $elm.find(".mura-file-option").find('input').change(
	    	function(){
	    		var reg1 = /^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))+(.jpg|.jpeg|.png|.gif)$/;
	    		var reg2 = /(http(s?):)|([/|.|\w|\s])*\.(?:jpg|gif|png)/;
	    		if(reg1.test( $(this).val().toLowerCase()) || reg2.test( $(this).val().toLowerCase())){
	    			$(this).parent().find('.file-meta-open').show();
	    		}else{
	    			$(this).parent().find('.file-meta-open').hide()
	    		}
	    });

		setTab('Upload');

	  }
	
	  $.fn.fileselector = function (options) {
	    return this.each(function () {
	      var $this = $(this);
	      var data = $this.data('fileselector');
	      
	      if (!data){
	      	 $this.data('fileselector', (data = new FileSelector(this, options)) );
	      }
	  	});
	  }

	  $.fn.fileselector.defaults = {
	    file: 'newfile'
	  }

	  $.fn.fileselector.Constructor = FileSelector;

}(window.jQuery));

function setFileSelectors() {

	$('.mura-file-selector').fileselector();
}

function alertDialog(message) {
	$("#alertDialogMessage").html(message);
	$("#alertDialog").dialog({
		resizable: false,
		modal: true,
		position: getDialogPosition(),
		buttons: {
			Ok: function() {
				$(this).dialog('close');
			}
		}
	});

	return false;
}

function confirmDialog(message, yesAction, noAction) {
	_yesAction = yesAction;
	_noAction = noAction;

	$("#alertDialogMessage").html(message);
	$("#alertDialog").dialog({
		resizable: false,
		modal: true,
		position: getDialogPosition(),
		buttons: {
			'Yes': function() {
				$(this).dialog('close');
				if(typeof(_yesAction) == 'function') {
					_yesAction();
				} else {
					actionModal(_yesAction);
				}

			},
			'No': function() {		
				if(typeof(_noAction) != 'undefined') {
					if(typeof(_noAction) == 'function') {
						_noAction();
					} else {
						actionModal(_noAction);
					}
				} else {
					$(this).dialog('close');
				}
			}
		}
	});

	return false;
}

var start = new Date();
start = Date.parse(start) / 1000;
var sessionTimeout = 10800;

function CountDown() {
	var now = new Date();
	now = Date.parse(now) / 1000;
	var x = parseInt(sessionTimeout - (now - start), 10);
	var hours = Math.floor(x / 3600);
	var minutes = Math.floor((x - (hours * 3600)) / 60);
	var seconds = x - ((hours * 3600) + (minutes * 60));
	minutes = (minutes <= 9) ? '0' + minutes : minutes;
	seconds = (seconds <= 9) ? '0' + seconds : seconds;

	if(document.getElementById('clock').innerHTML != undefined) {
		document.getElementById('clock').innerHTML = hours + ':' + minutes + ':' + seconds;
	}

	if(x > 0) {
		timerID = setTimeout("CountDown()", 100)
	} else {

		if(document.getElementById('clock').innerHTML != undefined) {
			document.getElementById('clock').innerHTML = 0 + ':' + 0 + ':' + 0;
		}
		//location.href=context + "/admin/?muraAction=cLogin.logout"
	}
}

function fileManagerPopUp() {
	var finder = new CKFinder();
	finder.basePath = context + '/requirements/ckfinder/';
	finder.resourceType = '[Advanced] Mura Root';
	finder.popup();
	return false;
}

function fileManagerCreate() {
	var finder = new CKFinder();
	finder.basePath = context + '/requirements/ckfinder/';
	finder.create();
	return false;
}

function loadjscssfile(filename, filetype) {
	if(filetype == "js") { //if filename is a external JavaScript file
		var fileref = document.createElement('script')
		fileref.setAttribute("type", "text/javascript")
		fileref.setAttribute("src", filename)
	} else if(filetype == "css") { //if filename is an external CSS file
		var fileref = document.createElement("link")
		fileref.setAttribute("rel", "stylesheet")
		fileref.setAttribute("type", "text/css")
		fileref.setAttribute("href", filename)
	}
	if(typeof fileref != "undefined") document.getElementsByTagName("head")[0].appendChild(fileref)
}

function getDialogPosition() {

	/*
	if(top.location != self.location) {
		try {
			var windowHeight = $(window.parent).height();
			var dialogHeight = $("#configuratorContainer").height();
			var scrollTop = $(window.parent).scrollTop();
			var editorTop = $("#frontEndToolsModalBody", window.parent.document).position().top;
			var t = Math.floor((windowHeight - dialogHeight) / 2) + scrollTop - editorTop;
			return ["center", t];
		} catch(err) {
			return ["center", 0];
		}
	} else {
		return "center";
	}
	*/
	//["top",20]
	return "center";
}

function openPreviewDialog(previewURL) {

	var $previewURL=previewURL;

	if($previewURL.indexOf("?") == -1) {
		$previewURL = previewURL + '?muraadminpreview';
	} else {
		$previewURL = previewURL + '&muraadminpreview';
	}

	var position=["top",20];

	var $dialog = $('<div id="mura-preview-container"></div>').html('<iframe id="preview-dialog" style="border: 0; background:#fff;" src="' + $previewURL + '&mobileFormat=false" width="1075" height="600" allowfullscreen></iframe>').dialog({
		width: 1105,
		height: 600,
		modal: true,
		title: 'Preview',
		position: position,
		resize: function(event,ui){
			$('#preview-dialog').attr('width',ui.size.width-25);
		},
		close: function(){
			$($dialog).dialog( "destroy" );
			$('#mura-preview-container').remove();
			$('#mura-preview-device-selector').remove();
		},
		open: function(){

			var $tools='<div id="mura-preview-device-selector"><p>Preview Mode</p>';
				$tools=$tools+'<a class="mura-device-standard active" data-height="600" data-width="1075" data-mobileformat="false"><i class="icon-desktop"></i></a>';
				$tools=$tools+'<a class="mura-device-tablet" data-height="600" data-width="768" data-mobileformat="false"><i class="icon-tablet"></i></a>';
				$tools=$tools+'<a class="mura-device-tablet-landscape" data-height="480" data-width="1024" data-mobileformat="false"><i class="icon-tablet icon-rotate-270"></i></a>';
				$tools=$tools+'<a class="mura-device-phone" data-height="480" data-width="320" data-mobileformat="true"><i class="icon-mobile-phone"></i></a>';
				$tools=$tools+'<a class="mura-device-phone-landscape" data-height="250" data-width="520" data-mobileformat="true"><i class="icon-mobile-phone icon-rotate-270"></i></a>';
				$tools=$tools+'</div>';

			var wos=30;
			var hos=85+39;

			$('.ui-dialog').prepend($tools);
			
			$('#mura-preview-device-selector a').bind('click', function () {
				var data=$(this).data();

			    $( $dialog ).dialog( "option", "width", data.width + wos );
			    $( $dialog ).dialog( "option", "height", data.height + hos);

			    $('#preview-dialog')
			    	.attr('width',data.width)
			    	.attr('height',data.height)
			   	 .attr('src',$previewURL + '&mobileFormat=' + data.mobileformat);
			    $( $dialog ).dialog( "option", "position", position );
			    $('#mura-preview-device-selector a').removeClass('active');
			    $(this).addClass('active');

			    return false;
			});
			
		}
	});

	return false;
}

function preloadimages(arr) {
	var newimages = []
	var arr = (typeof arr != "object") ? [arr] : arr //force arr parameter to always be an array
	for(var i = 0; i < arr.length; i++) {
		newimages[i] = new Image()
		newimages[i].src = arr[i]
	}
}


var spinnerArgs = {
	lines: 17,
	// The number of lines to draw
	length: 7,
	// The length of each line
	width: 4,
	// The line thickness
	radius: 13,
	// The radius of the inner circle
	corners: 1,
	// Corner roundness (0..1)
	rotate: 0,
	// The rotation offset
	color: '#fff',
	// #rgb or #rrggbb
	speed: 0.9,
	// Rounds per second
	trail: 60,
	// Afterglow percentage
	shadow: false,
	// Whether to render a shadow
	hwaccel: false,
	// Whether to use hardware acceleration
	className: 'spinner',
	// The CSS class to assign to the spinner
	zIndex: 2e9,	
	// The z-index (defaults to 2000000000)
	top: 'auto',
	// Top position relative to parent in px
	left: 'auto' // Left position relative to parent in px
}

var spinnerArgs2 = {
	lines: 17,
	// The number of lines to draw
	length: 7,
	// The length of each line
	width: 4,
	// The line thickness
	radius: 13,
	// The radius of the inner circle
	corners: 1,
	// Corner roundness (0..1)
	rotate: 0,
	// The rotation offset
	color: '#000',
	// #rgb or #rrggbb
	speed: 0.9,
	// Rounds per second
	trail: 60,
	// Afterglow percentage
	shadow: false,
	// Whether to render a shadow
	hwaccel: false,
	// Whether to use hardware acceleration
	className: 'spinner-alt',
	// The CSS class to assign to the spinner
	zIndex: 2e9,	
	// The z-index (defaults to 2000000000)
	top: 'auto',
	// Top position relative to parent in px
	left: 'auto', // Left position relative to parent in px
    position: 'relative'
}


var spinnerArgs3 = {
	lines: 17,
	// The number of lines to draw
	length: 7,
	// The length of each line
	width: 4,
	// The line thickness
	radius: 13,
	// The radius of the inner circle
	corners: 1,
	// Corner roundness (0..1)
	rotate: 0,
	// The rotation offset
	color: '#fff',
	// #rgb or #rrggbb
	speed: 0.9,
	// Rounds per second
	trail: 60,
	// Afterglow percentage
	shadow: false,
	// Whether to render a shadow
	hwaccel: false,
	// Whether to use hardware acceleration
	className: 'spinner-alt',
	// The CSS class to assign to the spinner
	zIndex: 2e9,	
	// The z-index (defaults to 2000000000)
	top: 'auto',
	// Top position relative to parent in px
	left: 'auto', // Left position relative to parent in px
    position: 'relative'
}


//preloadimages(['./assets/images/ajax-loader.gif']);

function removePunctuation(item){
	$(item).val(
		$(item).val().replace(/[^\w\s-]|/g, "").replace(/\s+/g, "")
	);
}


// search site drop down menu
if(typeof $.ui != 'undefined'){
	$.widget( "custom.muraSiteSelector", $.ui.autocomplete, {
		_suggest: function( items ) {
			// todo: make the ul id an options config (string or object?)
			var ul = this.element.closest("ul");
			ul.children("li").remove();
			
			this._renderMenu( ul, items );
			this.isNewMenu = true;
			this.menu.refresh();

			ul.show();
			this._resizeMenu();

			if ( this.options.autoFocus ) {
				this.menu.next();
			}
		},

		_renderItem: function( ul, item ) {
			return $( "<li>" )
				.append(
					$( "<a>" ).attr(
						"href", "?muraAction=cDashboard.main&siteID=" + item.id
					).append(
						$( "<i>" ).addClass( "icon-globe" )
					).append( item.label )
				).appendTo( ul );
		},

		options: {
			create: function( event ) {
				
				// we clear the results list if search string get is using backspace for example
				$( event.target ).keyup(function( event, ui ) {
					var input = $( this );
					if ( input.val().length < $( this ).data("customMuraSiteSelector").option("minLength") ) {
						var ul = input.closest("ul");
						ul.children("li").remove();
					}
				});
				
			}
		}
	});

	$(function() {
		$( 'input[name="site-search"]' ).muraSiteSelector({
			source: function( request, response ) {
				$.ajax({
					url: "./index.cfm?muraAction=cnav.searchsitedata",
					dataType: "json",
					method: "POST",
					data: {
						searchString: request.term
					},
					success: function( data ) {
						return response( data );
					}
				});
			},
			minLength: 2
		});
	});
}



function setLowerCaseKeys(obj) {
  var keys = Object.keys(obj);
  var n = keys.length;
  while (n--) {
    var key = keys[n]; // "cache" it, for less lookups to the array
    if (key !== key.toLowerCase()) { // might already be in its lower case version
        obj[key.toLowerCase()] = obj[key] // swap the value to a new lower case key
        delete obj[key] // delete the old key
    }
   	if(typeof obj[key.toLowerCase()] == 'object'){
   		setLowerCaseKeys(obj[key.toLowerCase()]);
   	}
  }
  return (obj);
}

function setFinders(selector){

	$(selector).unbind('click').on('click',function(){
		var target=$(this).attr('data-target');
		var finder = new CKFinder();
		finder.basePath = context + '/requirements/ckfinder/';
		var completepath=$(this).attr('data-completepath');

		if(completepath.toLowerCase() == 'true'){
			finder.selectActionFunction = function(fileUrl) {
				jQuery('input[name="' + target + '"]').val(webroot + fileDelim + fileUrl);		
			};
		} else {
			finder.selectActionFunction = function(fileUrl) {
				jQuery('input[name="' + target + '"]').val(fileUrl);		
			};
		}

		if($(this).attr('data-resourcetype') =='root'){
			finder.resourceType='Application_Root';
		} else if($(this).attr('data-resourcetype') == 'site'){
			finder.resourceType=siteid + '_Site_Files';
		} else {
			finder.resourceType=siteid + '_User_Assets';
		}
		
		finder.popup();			

	});
}

$(function(){
	
	setFinders(".mura-ckfinder");
	if(typeof dtLocale != 'undefined'){
		setDatePickers(".datepicker",dtLocale);
	}
	if(typeof activetab != 'undefined'){
		setTabs(".tabs",activetab);
	}
	setHTMLEditors();
	if(typeof activepanel != 'undefined'){
		setAccordions(".accordion",activepanel);
	}
	setCheckboxTrees();
	setColorPickers(".colorpicker");
	setToolTips(".container");
	setFileSelectors();

});

