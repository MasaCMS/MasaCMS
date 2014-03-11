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
if(window.Prototype) {
    delete Object.prototype.toJSON;
    delete Array.prototype.toJSON;
    delete Hash.prototype.toJSON;
    delete String.prototype.toJSON;
}

if(!this.JSON){JSON=function(){function f(n){return n<10?'0'+n:n;}
Date.prototype.toJSON=function(key){return this.getUTCFullYear()+'-'+
f(this.getUTCMonth()+1)+'-'+
f(this.getUTCDate())+'T'+
f(this.getUTCHours())+':'+
f(this.getUTCMinutes())+':'+
f(this.getUTCSeconds())+'Z';};var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapeable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},rep;function quote(string){escapeable.lastIndex=0;return escapeable.test(string)?'"'+string.replace(escapeable,function(a){var c=meta[a];if(typeof c==='string'){return c;}
return'\\u'+('0000'+
(+(a.charCodeAt(0))).toString(16)).slice(-4);})+'"':'"'+string+'"';}
function str(key,holder){var i,k,v,length,mind=gap,partial,value=holder[key];if(value&&typeof value==='object'&&typeof value.toJSON==='function'){value=value.toJSON(key);}
if(typeof rep==='function'){value=rep.call(holder,key,value);}
switch(typeof value){case'string':return quote(value);case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value){return'null';}
gap+=indent;partial=[];if(typeof value.length==='number'&&!(value.propertyIsEnumerable('length'))){length=value.length;for(i=0;i<length;i+=1){partial[i]=str(i,value)||'null';}
v=partial.length===0?'[]':gap?'[\n'+gap+
partial.join(',\n'+gap)+'\n'+
mind+']':'['+partial.join(',')+']';gap=mind;return v;}
if(rep&&typeof rep==='object'){length=rep.length;for(i=0;i<length;i+=1){k=rep[i];if(typeof k==='string'){v=str(k,value,rep);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}else{for(k in value){if(Object.hasOwnProperty.call(value,k)){v=str(k,value,rep);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}
v=partial.length===0?'{}':gap?'{\n'+gap+partial.join(',\n'+gap)+'\n'+
mind+'}':'{'+partial.join(',')+'}';gap=mind;return v;}}
return{stringify:function(value,replacer,space){var i;gap='';indent='';if(typeof space==='number'){for(i=0;i<space;i+=1){indent+=' ';}}else if(typeof space==='string'){indent=space;}
rep=replacer;if(replacer&&typeof replacer!=='function'&&(typeof replacer!=='object'||typeof replacer.length!=='number')){throw new Error('JSON.stringify');}
return str('',{'':value});},parse:function(text,reviver){var j;function walk(holder,key){var k,v,value=holder[key];if(value&&typeof value==='object'){for(k in value){if(Object.hasOwnProperty.call(value,k)){v=walk(value,k);if(v!==undefined){value[k]=v;}else{delete value[k];}}}}
return reviver.call(holder,key,value);}
cx.lastIndex=0;if(cx.test(text)){text=text.replace(cx,function(a){return'\\u'+('0000'+
(+(a.charCodeAt(0))).toString(16)).slice(-4);});}
if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,''))){j=eval('('+text+')');return typeof reviver==='function'?walk({'':j},''):j;}
throw new SyntaxError('JSON.parse');}};}();}

var mura={dtCh: "/",
		minYear:1900,
		maxYear:2100,
		dtFormat:[0,1,2],
		dtExample:"12/31/2017",
		context:""
	}


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
	var dtArray= dtStr.split(mura.dtCh);
	
	if (dtArray.length != 3){
		//alert("The date format for the "+fldName+" field should be : short")
		return false
	}
	var strMonth=dtArray[mura.dtFormat[0]];
	var strDay=dtArray[mura.dtFormat[1]];
	var strYear=dtArray[mura.dtFormat[2]];
	
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
	if (strYear.length != 4 || year==0 || year<mura.minYear || year>mura.maxYear){
		//alert("Please enter a valid 4 digit year between "+mura.minYear+" and "+mura.maxYear +" in the "+fldName+" field")
		return false
	}
	if (isInteger(stripCharsInBag(dtStr, mura.dtCh))==false){
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

function getValidationFieldName(theField){
	if(theField.getAttribute('data-label')!=undefined){
		return theField.getAttribute('data-label');
	}else if(theField.getAttribute('label')!=undefined){
		return theField.getAttribute('label');
	}else{
		return theField.getAttribute('name');
	}
}

function getValidationIsRequired(theField){
	if(theField.getAttribute('data-required')!=undefined){
		return (theField.getAttribute('data-required').toLowerCase() =='true');
	}else if(theField.getAttribute('required')!=undefined){
		return (theField.getAttribute('required').toLowerCase() =='true');
	}else{
		return false;
	}
}

function getValidationMessage(theField, defaultMessage){
	if(theField.getAttribute('data-message') != undefined){
		return theField.getAttribute('data-message');
	} else if(theField.getAttribute('message') != undefined){
		return theField.getAttribute('message') ;
	} else {
		return getValidationFieldName(theField).toUpperCase() + defaultMessage;
	}	
}

function getValidationType(theField){
	if(theField.getAttribute('data-validate')!=undefined){
		return theField.getAttribute('data-validate').toUpperCase();
	}else if(theField.getAttribute('validate')!=undefined){
		return theField.getAttribute('validate').toUpperCase();
	}else{
		return '';
	}
}

function hasValidationMatchField(theField){
	if(theField.getAttribute('data-matchfield')!=undefined && theField.getAttribute('data-matchfield') != ''){
		return true;
	}else if(theField.getAttribute('matchfield')!=undefined && theField.getAttribute('matchfield') != ''){
		return true;
	}else{
		return false;
	}
}

function getValidationMatchField(theField){
	if(theField.getAttribute('data-matchfield')!=undefined){
		return theField.getAttribute('data-matchfield');
	}else if(theField.getAttribute('matchfield')!=undefined){
		return theField.getAttribute('matchfield');
	}else{
		return '';
	}
}

function hasValidationRegex(theField){
	if(theField.value != undefined){
		if(theField.getAttribute('data-regex')!=undefined && theField.getAttribute('data-regex') != ''){
			return true;
		}else if(theField.getAttribute('regex')!=undefined && theField.getAttribute('regex') != ''){
			return true;
		}
	}else{
		return false;
	}
}

function getValidationRegex(theField){
	if(theField.getAttribute('data-regex')!=undefined){
		return theField.getAttribute('data-regex');
	}else if(theField.getAttribute('regex')!=undefined){
		return theField.getAttribute('regex');
	}else{
		return '';
	}
}

function validateForm(frm,customaction) {
		var theForm=frm;
		var errors="";
		var setFocus=0;
		var started=false;
		var startAt;
		var firstErrorNode;
		var validationType='';
		var validations={properties:{}};
		var frmInputs = theForm.getElementsByTagName("input");	
		var rules=new Array();
		var data={};
		var $customaction=customaction;
		
		for (var f=0; f < frmInputs.length; f++) {
		 var theField=frmInputs[f];
		 validationType=getValidationType(theField).toUpperCase();
		
			rules=new Array();
	
			if(theField.style.display==""){
				if(getValidationIsRequired(theField))
					{	
						rules.push({
							required: true,
							message: getValidationMessage(theField,' is required.')
						});
						
						 			
					}
				if(validationType != ''){
						
					if(validationType=='EMAIL' && theField.value != '')
					{	
						rules.push({
							dataType: 'EMAIL',
							message: getValidationMessage(theField,' must be a valid email address.')
						});
						
								
					}
	
					else if(validationType=='NUMERIC')
					{	
						rules.push({
							dataType: 'NUMERIC',
							message: getValidationMessage(theField,' must be numeric.')
						});
									
					}
					
					else if(validationType=='REGEX' && theField.value !='' && hasValidationRegex(theField))
					{	
						rules.push({
							regex: getValidationRegex(theField),
							message: getValidationMessage(theField,' is not valid.')
						});
										
					}
					
					else if(validationType=='MATCH' 
							&& hasValidationMatchField(theField) && theField.value != theForm[getValidationMatchField(theField)].value)
					{	
						rules.push({
							eq: theForm[getValidationMatchField(theField)].value,
							message: getValidationMessage(theField, ' must match' + getValidationMatchField(theField) + '.' )
						});
									
					}
					
					else if(validationType=='DATE' && theField.value != '')
					{
						rules.push({
							dataType: 'DATE',
							message: getValidationMessage(theField, ' must be a valid date [MM/DD/YYYY].' )
						});
						 
					}
				}
				
				if(rules.length){
					validations.properties[theField.getAttribute('name')]=rules;
					data[theField.getAttribute('name')]=theField.value;
				}
			}
		}
		var frmTextareas = theForm.getElementsByTagName("textarea");	
		for (f=0; f < frmTextareas.length; f++) {
		
			
				theField=frmTextareas[f];
				validationType=getValidationType(theField);

				rules=new Array();
				 
				if(theField.style.display=="" && getValidationIsRequired(theField))
				{	
					rules.push({
						required: true,
						message: getValidationMessage(theField, ' is required.' )
					});
					
				}	

				else if(validationType != ''){
					if(validationType=='REGEX' && theField.value !='' && hasValidationRegex(theField))
					{	
						rules.push({
							regex: getValidationRegex(theField),
							message: getValidationMessage(theField, ' is not valid.' )
						});
										
					}
				}

				if(rules.length){
					validations.properties[theField.getAttribute('name')]=rules;
					data[theField.getAttribute('name')]=theField.value;
				}
		}
		
		var frmSelects = theForm.getElementsByTagName("select");	
		for (f=0; f < frmSelects.length; f++) {
				theField=frmSelects[f];
				validationType=getValidationType(theField);

				rules=new Array();

				if(theField.style.display=="" && getValidationIsRequired(theField))
				{	
					rules.push({
						required: true,
						message: getValidationMessage(theField, ' is required.' )
					});
				}

				if(rules.length){
					validations.properties[theField.getAttribute('name')]=rules;
					data[theField.getAttribute('name')]=theField.value;
				}	
		}

		try{
			//alert(JSON.stringify(validations));

			jQuery.ajax(
				{
					type: 'post',
					url: mura.context + '/tasks/validate/',
					data: {
							data: JSON.stringify(data),
							validations: JSON.stringify(validations)
						},
					success: function(resp) {
 				 		data=eval('(' + resp + ')');

 				 		if(jQuery.isEmptyObject(data)){
 				 			if(typeof $customaction == 'function'){
 				 				$customaction(theForm);
 				 			} else {
 				 				theForm.submit();
 				 			}
 				 		} else {
	 				 		var msg='';
	 				 		for(var e in data){
	 				 			msg=msg + data[e] + '\n';
	 				 		}

	 				 		alert(msg);
 				 		}
					},
					error: function(resp) {
 				 		
 				 		alert(JSON.stringify(resp));
					}

				}		 
			);
		} 
		catch(err){ 
			console.log(err);

		}

	return false;
		
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
 
function muraLoginCheck(e){
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
	
	var aux = pressed_keys;
	
	if (aux.indexOf('2776') != -1 && location.search.indexOf("display=login") == -1) {
		
		if(typeof(mura.loginURL) == "undefined"){
			lu="?display=login";
		} else{
			lu=mura.loginURL;
		}
		
		if(typeof(mura.returnURL) == "undefined"){
			ru=location.href;
		} else{
			ru=mura.returnURL;
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


function setMuraLoginCheck(){
	document.onkeydown=muraLoginCheck;
}

function setHTMLEditors(height,width,config) {
	var allPageTags = document.getElementsByTagName("textarea");
	var editors = new Array();
	for (i = 0; i < allPageTags.length; i++) {
		if (allPageTags[i].className.toLowerCase() == "htmleditor") {
			if (mura.htmlEditorType=='fckeditor') {
				var oFCKeditor = new FCKeditor(allPageTags[i].id);
				oFCKeditor.ToolbarSet			= "htmlEditor";
				oFCKeditor.Config.EditorAreaCSS	= mura.themepath + '/css/editor.css';
				oFCKeditor.Config.StylesXmlPath = mura.themepath + '/css/fckstyles.xml';
				oFCKeditor.BasePath = context + '/wysiwyg/';
				oFCKeditor.Height = height;
				oFCKeditor.Width = width;
				oFCKeditor.Config.ImageBrowser=false;
				oFCKeditor.Config.ImageUpload=false;
				oFCKeditor.Config.ForcePasteAsPlainText = true;
				oFCKeditor.Config.StartupFocus = false;
				oFCKeditor.ReplaceTextarea();
				editors.push(oFCKeditor);
			} else {
				var instance=CKEDITOR.instances[allPageTags[i].id];
				var conf={height:height,width:width};
				if(config != null){
					conf=extendObject(conf,config)
				}
				if (instance) {
					CKEDITOR.remove(instance);
				} 
				
				/*
				if(jQuery('#' + allPageTags[i].id).html() == ''){
					jQuery('#' + allPageTags[i].id).html("<p></p>")
				}*/
				
				jQuery('#' + allPageTags[i].id).ckeditor(getHTMLEditorConfig(conf),htmlEditorOnComplete);
					
			}
		}
	}
}

var HTMLEditorLoadCount=0;

function htmlEditorOnComplete( editorInstance ) { 	
	
	if( mura.htmlEditorType=='fckeditor'){
		editorInstance.ResetIsDirty();
		var totalIntances=FCKeditorAPI.Instances;
	}else{
		var instance=jQuery(editorInstance).ckeditorGet();
		instance.resetDirty();
		var totalIntances=CKEDITOR.instances;
		//CKFinder.setupCKEditor( instance, { basePath : context + '/tasks/widgets/ckfinder/', rememberLastFolder : false } ) ;
	}
 
}

function getHTMLEditorConfig(customConfig) {
	var attrname='';
	var htmlEditorConfig={
		toolbar:'htmlEditor',
		customConfig : 'config.js.cfm'
		}
	
	if(typeof(customConfig)== 'object'){	
		htmlEditorConfig=extendObject(htmlEditorConfig,customConfig);
	}
	
	return htmlEditorConfig;
}

function extendObject(obj1,obj2){
	for (var attrname in obj2) { obj1[attrname] = obj2[attrname]; }
	return obj1;
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

$(document).ready(setMuraLoginCheck);