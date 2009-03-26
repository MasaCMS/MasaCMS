/* This file is part of Mura CMS. */

/*    Mura CMS is free software: you can redistribute it and/or modify */
/*    it under the terms of the GNU General Public License as published by */
/*    the Free Software Foundation, Version 2 of the License. */

/*    Mura CMS is distributed in the hope that it will be useful, */
/*    but WITHOUT ANY WARRANTY; without even the implied warranty of */
/*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/*    GNU General Public License for more details. */

/*    You should have received a copy of the GNU General Public License */
/*    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. */


var dtCh= "/";
var dtCh= "/";
var minYear=1900;
var maxYear=2100;
var dtFormat =[0,1,2];
var dtExample ="12/31/2014";


function noSpam(user,domain) {
	locationstring = "mailto:" + user + "@" + domain;
	window.location = locationstring;
	}

function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}


function createDate(str){
					
	var valueArray = str.split("/");
				
	var mon = valueArray[0];
	var dt = valueArray[1];
	var yr = valueArray[2];
			
	var date = new Date(yr, mon-1, dt);
					
	if(!isNaN(date.getMonth())){
		return date;
	} else {
		return new Date();	
	}
						
}
				
function dateToString(date){
	var mon   = date.getMonth()+1;
	var dt  = date.getDate();
	var yr   = date.getFullYear();
			
	if(mon < 10){ mon="0" + mon;}
	if(dt < 10){ dt="0" + dt;}
					
					
	return mon + "/" + dt + "/20" + new String(yr).substring(2,4);			
}
				

function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
		if (i==2) {this[i] = 29}
   } 
   return this
}

function isDate(dtStr,fldName){
	var daysInMonth = DaysArray(12);
	var dtArray= dtStr.split(dtCh);
	
	if (dtArray.length != 3){
		//alert("The date format for the "+fldName+" field should be : short")
		return false
	}
	var strMonth=dtArray[dtFormat[0]];
	var strDay=dtArray[dtFormat[1]];
	var strYear=dtArray[dtFormat[2]];
	
	/*
	if(strYear.length == 2){
		strYear="20" + strYear;
	}
	*/
	strYr=strYear;
	
	if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
	if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
	for (var i = 1; i <= 3; i++) {
		if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
	}
	
	month=parseInt(strMonth)
	day=parseInt(strDay)
	year=parseInt(strYr)
		
	if (month<1 || month>12){
		//alert("Please enter a valid month in the "+fldName+" field")
		return false
	}
	if (day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
		//alert("Please enter a valid day  in the "+fldName+" field")
		return false
	}
	if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
		//alert("Please enter a valid 4 digit year between "+minYear+" and "+maxYear +" in the "+fldName+" field")
		return false
	}
	if (isInteger(stripCharsInBag(dtStr, dtCh))==false){
		//alert("Please enter a valid date in the "+fldName+" field")
		return false
	}
return true;
}

function isEmail(cur){
			var string1=cur
			if (string1.indexOf("@") == -1 || string1.indexOf(".") == -1)
			{
			return false;
			}else{
			return true;}

}

function validate(theForm) {
	return validateForm(theForm);
}

function getFieldName(theField){
	if(theField.getAttribute('label')!=undefined){
		return theField.getAttribute('label');
	}else{
		return theField.getAttribute('name');
	}
}

function validateForm(theForm) {

		var errors="";
		var setFocus=0;
		var started=false;
		var startAt;
		var firstErrorNode;
		var frmInputs = theForm.getElementsByTagName("input");	
		for (f=0; f < frmInputs.length; f++) {
		 theField=frmInputs[f];
			if(theField.style.display==""){
				if(theField.getAttribute('required')=='true' && theField.value == "" )
					{	
						if (!started) {
						started=true;
						startAt=f;
						firstErrorNode="input";
						}
						
						if(theField.getAttribute('message')==undefined){
						 	errors += getFieldName(theField).toUpperCase() + ' is required\n';
							 }
						 else
							 {
							 errors += theField.getAttribute('message') + '\n';
						 }			
					}
				else if(theField.getAttribute('validate') != undefined && theField.value != ''){
						
					if(theField.getAttribute('validate').toUpperCase()=='EMAIL' && !isEmail(theField.value))
					{	
						if (!started) {
						started=true;
						startAt=f;
						firstErrorNode="input";
						}
						
						if(theField.getAttribute('message')==undefined){
						 	 errors += getFieldName(theField).toUpperCase() + ' must be a valid email address\n';
							 }
						 else
							 {
							 errors += theField.getAttribute('message') + '\n';
						 }					
					}
	
					else if(theField.getAttribute('validate').toUpperCase()=='NUMERIC' && isNaN(theField.value))
					{	
						if(!isNaN(theField.value.replace(/\$|\,|\%/g,'')))
						{
							theField.value=theField.value.replace(/\$|\,|\%/g,'');
	
						} else {
							if (!started) {
							started=true;
							startAt=f;
							firstErrorNode="input";
							}
						
							if(theField.getAttribute('message')==undefined){
						 	 	errors += getFieldName(theField).toUpperCase() + ' must be numeric\n';
								 }
							 else
							 	{
								 errors += theField.getAttribute('message') + '\n';
							 }
						}					
					}
					
					else if(theField.getAttribute('validate').toUpperCase()=='REGEX' && theField.getAttribute('regex') != undefined)
					{	
						var re = new RegExp(theField.getAttribute('regex'));
						if(!theField.value.match(re))
						{
							if (!started) {
							started=true;
							startAt=f;
							firstErrorNode="input";
							}
						
							if(theField.getAttribute('message')==undefined){
						 	 	errors += getFieldName(theField).toUpperCase() + ' must be numeric\n';
								 }
							 else
							 	{
								 errors += theField.getAttribute('message') + '\n';
							 }
						}					
					}
					else if(theField.getAttribute('validate').toUpperCase()=='MATCH' 
							&& theField.getAttribute('matchfield') != undefined && theField.value != theForm[theField.getAttribute('matchfield')].value)
					{	
						if (!started) {
						started=true;
						startAt=f;
						firstErrorNode="input";
						}
						
						if(theField.getAttribute('message')==undefined){
						 	 errors += getFieldName(theField).toUpperCase() + ' must match' + theField.getAttribute('matchfield') + '\n';
							 }
						 else
							 {
							 errors += theField.getAttribute('message') + '\n';
						 }					
					}
					else if(theField.getAttribute('validate').toUpperCase()=='DATE' && !isDate(theField.value))
					{
						if (!started) {
						started=true;
						startAt=f;
						firstErrorNode="input";
						}
						
						if(theField.getAttribute('message')==undefined){
						 	 errors += getFieldName(theField).toUpperCase() + ' must be a valid date [MM/DD/YYYY]' + '\n';			
							 }
						 else
							 {
							 errors += theField.getAttribute('message') + '\n';
						 }			 
					}
				}
					
			}
		}
		var frmTextareas = theForm.getElementsByTagName("textarea");	
		for (f=0; f < frmTextareas.length; f++) {
		
			
				theField=frmTextareas[f];
				if(theField.style.display=="" && theField.getAttribute('required')=='true' && theField.value == "" )
				{	
					if (!started) {
					started=true;
					startAt=f;
					firstErrorNode="textarea";
					}
					
					if(theField.getAttribute('message')==undefined){
					 	errors += getFieldName(theField).toUpperCase() + ' is required\n';
						 }
					 else
						 {
						 errors += theField.getAttribute('message') + '\n';
					 }			
				}	
		}
		
		var frmSelects = theForm.getElementsByTagName("select");	
		for (f=0; f < frmSelects.length; f++) {
				theField=frmSelects[f];
				if(theField.style.display=="" && theField.getAttribute('required')=='true' && theField.value == "" )
				{	
					if (!started) {
					started=true;
					startAt=f;
					firstErrorNode="select";
					}
					
					if(theField.getAttribute('message')==undefined){
					 	errors += getFieldName(theField).toUpperCase() + ' is required\n';
						 }
					 else
						 {
						 errors += theField.getAttribute('message') + '\n';
					 }			
				}	
		}
		
		if(errors != ""){	
			alert(errors);
			if(firstErrorNode=="input"){
				frmInputs[startAt].focus();
			}
			else if (firstErrorNode=="textarea"){
				frmTextareas[startAt].focus();
			}
			else if (firstErrorNode=="select"){
				frmSelects[startAt].focus();
			}
			return false;
		}
		else
		{
			return true;
		}

}


// This code was taken from http://techfeed.net/blog/index.cfm/2007/2/6/JavaScript-URL-variables
function getURLVar(urlVarName) {
//divide the URL in half at the '?'
var urlHalves = String(document.location).split('?');
var urlVarValue = '';
if(urlHalves[1]){
//load all the name/value pairs into an array
var urlVars = urlHalves[1].split('&');
//loop over the list, and find the specified url variable
for(i=0; i<=(urlVars.length); i++){
if(urlVars[i]){
//load the name/value pair into an array
var urlVarPair = urlVars[i].split('=');
if (urlVarPair[0] && urlVarPair[0] == urlVarName) {
//I found a variable that matches, load it's value into the return variable
urlVarValue = urlVarPair[1];
}
}
}
}
return unescape(urlVarValue);   
}

function submitForm(frm,action,theClass){

	if(validateForm(frm)){
		
		if(typeof(action) != 'undefined' && (action=='delete' && confirm('Delete ' + theClass +'?') || action!='delete')){
			var frmInputs = frm.getElementsByTagName("input");	
			for (f=0; f < frmInputs.length; f++){
				if(frmInputs[f].getAttribute('name')=='action'){
				frmInputs[f].setAttribute('value',action);
				}
			}
	
		}

		frm.submit();
		formSubmitted = true;
	}	
	return false;
}


function submitForm(frm,doaction,theClass){
	
	if(validate(frm)){
		
		if(typeof(doaction) != 'undefined' && (action=='delete' && confirm('Delete ' + theClass +'?') || action!='delete')){
			var frmInputs = frm.getElementsByTagName("input");	
			for (f=0; f < frmInputs.length; f++){
				if(frmInputs[f].getAttribute('name')=='doaction'){
				frmInputs[f].setAttribute('value',doaction);
				}
			}
	
		}

		frm.submit();
	}	
	return false;
}


function isMacIE5(){
			var agt=navigator.userAgent.toLowerCase(); 
			var ie   = (agt.indexOf("msie") != -1);
			var mac    = (agt.indexOf("mac")!=-1); 
			
				if(mac && ie){
					return false;
				}else{
					return true;
				}	
} 

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length,c.length));
	}
	return "";
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

function setMuraImageOffSets(margin){
	setImageOffSets(margin,"class","syndLocal");
	setImageOffSets(margin,"id","portal");
}

function setImageOffSets(margin,type,selector){

	if(type=="class"){
		var portals=document.getElementsByClassName(selector);
	} else {
		var portals=new Array(1); 
		portals[0]=document.getElementById(selector);
	}
	
	if(portals[0] != null){
	
		for(var p=0;p<portals.length;p++){
			
			var items=portals[p].getElementsByTagName("DL");
			
			for (var i=0;i<items.length;i++){
				var img = null;
				if(items[i].getElementsByTagName("DD").length > 0){
					var dd = items[i].getElementsByTagName("DD")[0];
					if(dd.getElementsByTagName("IMG").length  > 0){
						img=dd.getElementsByTagName("IMG")[0];
					} else if (dd.getElementsByTagName("P").length > 0){
						var pArray=dd.getElementsByTagName("P");
						for(var p=0; p <pArray.length; p++){ 
							if(pArray[p].getElementsByTagName("IMG").length > 0){
								img= pArray[p].getElementsByTagName("IMG")[0];
								break;
							}
						}
					}
					
					if(img != null){
						title=new Element.extend(items[i].getElementsByTagName("DT")[0]);	
						img.onload=function(){
							var hOffset=0;
							if(this.parentNode.parentNode.getElementsByTagName("DT")[0] != undefined){	
								var container=new Element.extend(this.parentNode.parentNode);	
							} else {
								var container=new Element.extend(this.parentNode.parentNode.parentNode);	
							}
							var title=new Element.extend(container.getElementsByTagName("DT")[0]);	
							hOffset=title.getHeight();
							
							var pArray=container.getElementsByTagName("DD")[0].getElementsByTagName("P");
							
							if(pArray.length){;
								for(var p=0; p <pArray.length; p++){ 
										if(pArray[p].getElementsByTagName("IMG").length){
										break;
									}else{											
										var addP= new Element.extend(pArray[p]);
										addP.style.marginLeft=this.width + margin + 'px';
										hOffset=hOffset + addP.getHeight() + addP.style.marginBottom + addP.style.marginTop;
									}
								}
							}
							title.style.marginLeft=this.width + margin + 'px';
							this.style.marginTop=-hOffset + "px";
							this.style.float="left";
						}
					}	
				}				
			} 
		}	
	} 

}

// Son of Suckerfish Dropdowns
sfHover = function() {
	if(document.getElementById("navPrimary") != undefined){
	var sfEls = document.getElementById("navPrimary").getElementsByTagName("LI");
		for (var i=0; i<sfEls.length; i++) {
			sfEls[i].onmouseover=function() {
				this.className+=" sfhover";
			}
			sfEls[i].onmouseout=function() {
				this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
			}
		}
	}
}
if (window.attachEvent) window.attachEvent("onload", sfHover); //Event.observe(window, 'load', sfHover, false); 

function addLoadEvent(func) {
   var oldonload = window.onload;
   if (typeof window.onload != 'function') {
    window.onload = func;
   } else {
    window.onload = function() {
     oldonload();
     func();
    }
   }
  }
  
function addUnloadEvent(func) {
   var oldonunload = window.onunload;
   if (typeof window.onunload != 'function') {
    window.onunload = func;
   } else {
    window.onunload = function() {
     oldonunload();
     func();
    }
   }
  }

function keyCheck(e){
	var key = (window.event) ? event.keyCode : e.keyCode;
	
	if(typeof(pressed_keys)=='undefined'){
		pressed_keys="";
	}
	//alert(key);
	if(key==27){
		pressed_keys = key;
		
	} else if(key == 76){
		pressed_keys = pressed_keys+""+key;
	}

	if (key !=27  && key !=76) {
	pressed_keys = "";
	}

	if (pressed_keys != "") {
	
	aux = new String(pressed_keys);
	
	if (aux.indexOf('2776') != -1 && location.search.indexOf("display=login") == -1) {
		
		if(typeof(loginURL) == "undefined"){
			lu="?display=login";
		} else{
			lu=loginURL;
		}
		
		if(typeof(returnURL) == "undefined"){
			ru=location.href;
		} else{
			ru=returnURL;
		}
		pressed_keys = "";
		
		lu = new String(lu);
		if(lu.indexOf('?') != -1){
			location.href=lu + "&returnUrl=" + escape(ru);
		} else {
			location.href=lu + "?returnUrl=" + escape(ru);
		}
	}
    }
}


function setKeyCheck(){
	document.onkeydown=keyCheck;
}


function fadeToggle(id){
	if(jslib=='jquery'){
		$("#" + id).animate({opacity: 'toggle'});
	}else {	
		Effect.toggle(id, 'appear');
	}

}
addLoadEvent(setKeyCheck);
//Event.observe(window, 'load', setKeyCheck, false);

