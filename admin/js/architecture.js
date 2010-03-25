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

	However, as a special exception, the copyright holders of Mura CMS grant you permission 
	to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1. 

	In addition, as a special exception,  the copyright holders of Mura CMS grant you permission 
	to combine Mura CMS  with independent software modules that communicate with Mura CMS solely 
	through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API, 
	provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS 
	plugin installation API, (b) must not alter any default objects in the Mura CMS database 
	and (c) must not alter any files in the following directories except in cases where the code contains 
	a separately distributed license.

	/trunk/www/admin/ 
	/trunk/www/tasks/ 
	/trunk/www/config/ 
	/trunk/www/requirements/mura/ 

	You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include  
	the source code of that other code when and as the GNU GPL requires distribution of source code. 

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception 
	for your modified version; it is your choice whether to do so, or to make such modified version available under 
	the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception 
	to your own modified versions of Mura CMS. */

var formSubmitted = false;
var dirtyRelatedContent = false;

var copyContentID = "";
var copySiteID = "";
var reloadURL = "";

function ckContent(draftremovalnotice){
		
	if (document.contentForm.display.value=='2') {
	var tempStart=document.contentForm.displayStart.value;
	var tempStop=document.contentForm.displayStop.value;
		//alert(tempStart);
		if (isDate(tempStart,'DISPLAY START DATE')==false) {
			alert("Please enter a valid date in the 'Display Start Date' field");
			return false;				
		}
		else if (tempStop != '' && isDate(tempStop,'DISPLAY STOP DATE')==false) {
			alert("Please enter a valid date in the 'Display Stop Date' field");
			return false;				
		}
	}
	else{
		document.contentForm.displayStart.value="";
		document.contentForm.displayStop.value="";
	}
	
	if(document.contentForm.title.value == ''){
		   if(document.contentForm.type.value=='Component'){
				alert("The form field 'Menu Title' is required");
				return false;}
		    else if(document.contentForm.type.value=='Form'){
				alert("The form field 'Title' is required");
				return false;}
			else{
				alert("The form field 'Long Title' is required");
				return false;}
			
	}
	
	 if(document.contentForm.type.value=='Link' && document.contentForm.filename.value == ''){
		alert("The form field 'Url' is required"); 
		return false;
	 }
	
	 if(document.contentForm.approved.value==1 && draftremovalnotice != "" && !confirm(draftremovalnotice)){
		 return false;
	 }	
	
	/*
	if(typeof(FCKeditorAPI) != 'undefined' && (document.contentForm.type.value=='Page' ||
	   document.contentForm.type.value=='Portal' ||
	   document.contentForm.type.value=='Calendar')) 
	{ 
		var content =FCKeditorAPI.GetInstance('body').GetXHTML();
		var contentLength = content.length;
		var pageSize=32000;
		
		if(contentLength > pageSize ){
	
		alert("The content length must be less than 32000 characters.");
		return false;	
		}
		
		// FCKeditorAPI.GetInstance('body').SetHTML(content.substr(0,pageSize),false)
	
	}
	*/
	formSubmitted = true;
	return true;
}
			

//  DHTML Menu for Site Summary
var DHTML = (document.getElementById || document.all || document.layers);
var lastid ="";
function getObj(name)
{
  if (document.getElementById)
  {
  	this.obj = document.getElementById(name);
	this.style = document.getElementById(name).style;
  }
  else if (document.all)
  {
	this.obj = document.all[name];
	this.style = document.all[name].style;
  }
  else if (document.layers)
  {
   	this.obj = document.layers[name];
   	this.style = document.layers[name];
  }
}

function showMenu(id,newcontent,obj,contentid,topid,parentid,siteid,type) {
		
if (window.innerHeight)
	{
		 var posTop = window.pageYOffset
	}
	else if (document.documentElement && document.documentElement.scrollTop)
	{
		var posTop = document.documentElement.scrollTop
	}
	else if (document.body)
	{
		 var posTop = document.body.scrollTop
	}

if (window.innerWidth)
	{
		 var posLeft = window.pageXOffset
	}
	else if (document.documentElement && document.documentElement.scrollLeft)
	{
		var posLeft = document.documentElement.scrollLeft
	}
	else if (document.body)
	{
		 var posLeft = document.body.scrollLeft
	}

var xPos = findPosX(obj);
var yPos = findPosY(obj);

if(navigator.appName=="Microsoft Internet Explorer" && parseInt(navigator.appVersion) != 4){
	xPos = xPos -14;
	yPos = yPos -7;
} else {
	xPos = xPos +17;
	yPos = yPos -9;
	
}

document.getElementById('newZoom').style.display='none';
document.getElementById('newZoomLink').style.display='none';
document.getElementById('newCopy').style.display='none';
document.getElementById('newCopyLink').style.display='none';
document.getElementById('newCopyAllLink').style.display='none';
document.getElementById('newPaste').style.display='none';
document.getElementById('newPasteLink').style.display='none';
document.getElementById('newPageLink').style.display='none';
document.getElementById('newLinkLink').style.display='none';
document.getElementById('newCalendarLink').style.display='none';
document.getElementById('newPortalLink').style.display='none';
document.getElementById('newFileLink').style.display='none';
document.getElementById('newGalleryLink').style.display='none';
document.getElementById('newGalleryItemLink').style.display='none';
document.getElementById('newPage').style.display='none';
document.getElementById('newLink').style.display='none';
document.getElementById('newCalendar').style.display='none';
document.getElementById('newPortal').style.display='none';
document.getElementById('newFile').style.display='none';
document.getElementById('newGallery').style.display='none';
document.getElementById('newGalleryItem').style.display='none';

document.getElementById('newGalleryItemMulti').style.display='none';
document.getElementById('newGalleryItemMultiLink').style.display='none';

//document.getElementById('newFileMulti').style.display='none';
//document.getElementById('newFileMultiLink').style.display='none';

document.getElementById('newZoomLink').href='index.cfm?fuseaction=cArch.list&topid=' + contentid + '&parentid=' + parentid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
document.getElementById('newZoom').style.display='';
document.getElementById('newZoomLink').style.display='';


if(newcontent){

document.getElementById('newPageLink').href=
'index.cfm?fuseaction=cArch.edit&contentid=&parentid=' + contentid + '&type=Page&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
document.getElementById('newLinkLink').href=
'index.cfm?fuseaction=cArch.edit&contentid=&parentid=' + contentid + '&type=Link&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
document.getElementById('newCalendarLink').href=
'index.cfm?fuseaction=cArch.edit&contentid=&parentid=' + contentid + '&type=Calendar&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
document.getElementById('newPortalLink').href=
'index.cfm?fuseaction=cArch.edit&contentid=&parentid=' + contentid + '&type=Portal&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
document.getElementById('newFileLink').href=
'index.cfm?fuseaction=cArch.edit&contentid=&parentid=' + contentid + '&type=File&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
document.getElementById('newGalleryLink').href=
'index.cfm?fuseaction=cArch.edit&contentid=&parentid=' + contentid + '&type=Gallery&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
document.getElementById('newGalleryItemLink').href=
'index.cfm?fuseaction=cArch.edit&contentid=&parentid=' + contentid + '&type=File&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
document.getElementById('newGalleryItemMultiLink').href=
'index.cfm?fuseaction=cArch.multiFileUpload&contentid=&parentid=' + contentid + '&type=File&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;
//document.getElementById('newFileMultiLink').href=
//'index.cfm?fuseaction=cArch.multiFileUpload&contentid=&parentid=' + contentid + '&type=File&topid=' + topid + '&siteid=' + siteid + '&moduleid=00000000000000000000000000000000000&ptype=' + type;


document.getElementById('newCopyLink').href='javascript:copyThis(\'' + siteid + '\', \'' + contentid + '\',\'false\')';
document.getElementById('newCopyAllLink').href='javascript:copyThis(\'' + siteid + '\', \'' + contentid + '\',\'true\')';
document.getElementById('newCopy').style.display='';
document.getElementById('newCopyLink').style.display='';
document.getElementById('newCopyAllLink').style.display='';

if (copySiteID != "" && copyContentID != ""){
	document.getElementById('newPasteLink').href='javascript:pasteThis(\'' + contentid + '\')';
	document.getElementById('newPaste').style.display='';
	document.getElementById('newPasteLink').style.display='';
}

if(type =='Gallery'){
document.getElementById('newGalleryItemLink').style.display='';
document.getElementById('newGalleryItem').style.display='';
document.getElementById('newGalleryItemMulti').style.display='';
document.getElementById('newGalleryItemMultiLink').style.display='';
document.getElementById('newCopy').style.border='';
} else if (type!='File' && type!='Link'){
document.getElementById('newPageLink').style.display='';
document.getElementById('newLinkLink').style.display='';
document.getElementById('newCalendarLink').style.display='';
document.getElementById('newPortalLink').style.display='';
document.getElementById('newFileLink').style.display='';
//document.getElementById('newFileMultiLink').style.display='';
document.getElementById('newGalleryLink').style.display='';
document.getElementById('newGalleryItemLink').style.display='none';
document.getElementById('newGalleryItemMultiLink').style.display='none';
document.getElementById('newPage').style.display='';
document.getElementById('newLink').style.display='';
document.getElementById('newCalendar').style.display='';
document.getElementById('newPortal').style.display='';
document.getElementById('newFile').style.display='';
//document.getElementById('newFileMulti').style.display='';
document.getElementById('newGallery').style.display='';
document.getElementById('newGalleryItem').style.display='none';
document.getElementById('newGalleryItemMulti').style.display='none';
document.getElementById('newCopy').style.border='';
} else {
document.getElementById('newCopy').style.border='0';
document.getElementById('newPaste').style.display='none';
document.getElementById('newZoom').style.display='none';
}	
}

document.getElementById(id).style.top=yPos + "px" ;
document.getElementById(id).style.left=xPos + "px" ;
document.getElementById(id).style.visibility="visible";

if(lastid!="" && lastid !=id){

hideMenu(lastid);
}
navTimer = setTimeout('hideMenu(lastid);',6000);
lastid=id;
}

function findPosX(obj)
{
	var curleft = 0;
	if (obj.offsetParent)
	{
		while (obj.offsetParent)
		{
			curleft += obj.offsetLeft
			obj = obj.offsetParent;
		}
	}
	else if (obj.x)
		curleft += obj.x;
	return curleft;
}

function findPosY(obj)
{
	var curtop = 0;
	if (obj.offsetParent)
	{
		while (obj.offsetParent)
		{
			curtop += obj.offsetTop
			obj = obj.offsetParent;
		}
	}
	else if (obj.y)
		curtop += obj.y;
	return curtop;
}


function keepMenu(id) {
navTimer = setTimeout('hideMenu(lastid);',6000);
document.getElementById(id).style.visibility="visible";
}

function hideMenu(id) {
if(navTimer!=null)clearTimeout(navTimer);
document.getElementById(id).style.visibility="hidden";
}


function addObject(availableList,publicList,privateList){
   if(document.getElementById(availableList)==null
	|| document.getElementById(availableList).selectedIndex ==-1){
	   alert("Please select a display object."); return false;}
   var selectedObjects =document.getElementById(publicList);
   var addIndex = document.getElementById(availableList).selectedIndex;
   
   if(addIndex < 0)return;
   
   var addoption =document.getElementById(availableList).options[addIndex]; 
 
	if(selectedObjects.options.length){
		
		for (var i=0;i < selectedObjects.options.length;i++){ 
		
			if(selectedObjects.options[i].value == addoption.value) {
			selectedObjects.selectedIndex=i;
			return;
			}
		}
	}
	
	var myoption = document.createElement("option");
	document.getElementById(publicList).appendChild(myoption);
	myoption.text     = addoption.text;
	myoption.value    = addoption.value;
	myoption.selected = "selected"
	
	updateList(publicList,privateList);
	
}

function deleteObject(publicList,privateList){
   var selectedObjects =document.getElementById(publicList);
   var deleteIndex =selectedObjects.selectedIndex;
   var len = (selectedObjects.options.length > 1)?selectedObjects.options.length-1:0;
   if(deleteIndex < 0) return;
	
	selectedObjects.options[deleteIndex]=null; 
	updateList(publicList,privateList);
	if(selectedObjects.options.length){
		selectedObjects.options[selectedObjects.options.length-1].selected=true;
	}
	 
}

function updateList(publicList,privateList){
	var selectedObjects =document.getElementById(publicList);
	 var objectList=document.getElementById(privateList)
	 objectList.value=""; 
	for (var i=0;i<selectedObjects.options.length;i++){ 
		if(objectList.value!=""){
			objectList.value += "^" + selectedObjects.options[i].value; 
		}
		else
		{
			objectList.value = selectedObjects.options[i].value; 
		}
	}

}

function moveUp(publicList,privateList){
var selectedObjects=document.getElementById(publicList);
var moverIndex=selectedObjects.selectedIndex;
if(moverIndex<1)return;

var moveroption = document.createElement("option");
var movedoption = document.createElement("option");

moveroption.text = selectedObjects.options[moverIndex].text; 
moveroption.value = selectedObjects.value;
moveroption.selected = "selected"

movedoption.text = selectedObjects.options[moverIndex-1].text;
movedoption.value = selectedObjects.options[moverIndex-1].value;

selectedObjects[moverIndex-1]=moveroption;
selectedObjects[moverIndex]=movedoption;

updateList(publicList,privateList);
}

function moveDown(publicList,privateList){
var selectedObjects=document.getElementById(publicList);
var moverIndex=selectedObjects.selectedIndex;
if(moverIndex ==selectedObjects.length-1)return;

var moveroption = document.createElement("option");
var movedoption = document.createElement("option");

moveroption.text =selectedObjects.options[moverIndex].text; 
moveroption.value = selectedObjects.options[moverIndex].value;
moveroption.selected = "selected"

movedoption.text =  selectedObjects.options[moverIndex+1].text;
movedoption.value = selectedObjects.options[moverIndex+1].value;


selectedObjects.options[moverIndex+1]=moveroption;
selectedObjects.options[moverIndex]=movedoption;

updateList(publicList,privateList);

}

function setTargetParams(frm){
  
 var hp=(!isNaN(frm.height.value) && frm.height.value > 0)?",height="+ frm.height.value:"";
 var wp=(!isNaN(frm.width.value) && frm.width.value > 0)?",width="+ frm.width.value:"";
 var tp=(!isNaN(frm.top.value) && frm.top.value > 0)?",top="+ frm.top.value:"";
 var lp=(!isNaN(frm.left.value) && frm.left.value > 0)?",left="+ frm.left.value:"";
 var tb=(frm.toolbar.value != "")?",toolbar=" + frm.toolbar.value :"";
 var loc=(frm.location.value != "")?",location=" + frm.location.value :"";
 var dir=(frm.directories.value != "")?",directories=" + frm.directories.value :"";
 var st=(frm.status.value != "")?",status=" + frm.status.value :"";
 var mb=(frm.menubar.value != "")?",menubar=" + frm.menubar.value:"";
 var rs=(frm.resizable.value != "")?",resizable=" + frm.resizable.value:"";
 var hist=(frm.copyhistory.value != "")?",copyhistory=" + frm.copyhistory.value:"";
 var sb=(frm.scrollbars.value != "")?",scrollbars=" + frm.scrollbars.value:"";
 
 document.forms["contentForm"].targetParams.value =tb + loc + dir + st + mb +rs + hist + sb + wp + hp + tp + lp;
  }
  

/*function loadSiteParents(siteid,contentid,parentid)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.siteParents&siteid=' + siteid +'&contentid=' + contentid + '&parentid=' +parentid+ '&cacheid=' + Math.random();
		var d = $('move');
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'move'}, url, {method: 'get', parameters: pars});
	}*/
		
function loadSiteParents(siteid,contentid,parentid,keywords,isNew)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.siteParents&compactDisplay=true&siteid=' + siteid +'&contentid=' + contentid + '&parentid=' +parentid+ '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		var d = $('move');
			d.innerHTML='<br/><img src="images/progress_bar.gif"><input type=hidden name=parentid value=' + parentid + ' >';
		var myAjax = new Ajax.Updater({success: 'move'}, url, {method: 'get', parameters: pars});
	}

function loadObjectClass(siteid,classid,subclassid)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadclass&compactDisplay=true&siteid=' + siteid +'&classid=' + classid  +'&subclassid=' + subclassid + '&cacheid=' + Math.random();
		var d = $('classList');
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'classList'}, url, {method: 'get', parameters: pars});
		return false;
	}

function loadNotify(siteid,contentid,parentid)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadNotify&compactDisplay=true&siteid=' + siteid +'&contentid=' + contentid +'&parentid=' + parentid + '&cacheid=' + Math.random();
		var d = $('selectNotify');
		if(d.innerHTML==''){
			d.style.display='';
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'selectNotify'}, url, {method: 'get', parameters: pars});
		}
		else {
			d.style.display = (d.style.display == 'none')?'':'none';  
		}
		
		return false;
	}


function loadRelatedContent(siteid,keywords,isNew)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadRelatedContent&compactDisplay=true&siteid=' + siteid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		/*if(keywords != ''){
		location.href="?" + pars;
		}*/
		var d = $('selectRelatedContent');
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'selectRelatedContent'}, url, {method: 'get', parameters: pars});
	}
	
	
function addRelatedContent(contentID,contentType,title)	{
		var tbody = document.getElementById('relatedContent').getElementsByTagName("TBODY")[0];	
		var row = document.createElement("TR");
			row.id="c" + contentID;
		var name = document.createElement("TD");
			name.appendChild(document.createTextNode(title));
			name.className="varWidth";
		var type = document.createElement("TD");
			type.appendChild (document.createTextNode(contentType));
		var admin = document.createElement("TD");
			admin.className="administration";
		var deleteLink=document.createElement("A");
			deleteLink.setAttribute("href","#");
			deleteLink.onclick=function (){Element.remove("c" + contentID); stripe('stripe');return false;}
			deleteLink.appendChild(document.createTextNode('Delete'));
	
		var deleteUL=document.createElement("UL");
			deleteUL.className="clearfix";

		var deleteLI=document.createElement("LI");
			deleteLI.className="delete";
			deleteLI.appendChild(deleteLink);
			deleteUL.appendChild(deleteLI);
			
		var content = document.createElement("INPUT");
			content.setAttribute("type","hidden");
			content.setAttribute("name","relatedContentID");
			content.setAttribute("value",contentID);
			admin.appendChild(content);
			admin.appendChild(deleteUL);
			row.appendChild(name);
			row.appendChild(type);
			row.appendChild(admin);
   			tbody.appendChild(row);
		 if($('noFilters') != null) $('noFilters').style.display='none';
		
		 stripe('stripe');
		 dirtyRelatedContent = true;
		 
  } 
  
 

function removeRelatedContent(contentID,confirmText){
	if(confirm(confirmText)){
		Element.remove(contentID); 
		stripe('stripe');
		dirtyRelatedContent = true;
		}
	return false;
	}	
	
	


function form_is_modified(oForm)
{
	var el, opt, hasDefault, i = 0, j;
	while (el = oForm.elements[i++]) {
		switch (el.type) {
			case 'text' :
                   	case 'textarea' :
                   	case 'hidden' :
                         	if (!/^\s*$/.test(el.value) && el.value != el.defaultValue) return true;
                         	break;
                   	case 'checkbox' :
                   	case 'radio' :
                         	if (el.checked != el.defaultChecked) return true;
                         	break;
                   	case 'select-one' :
                   	case 'select-multiple' :
                         	j = 0, hasDefault = false;
                         	while (opt = el.options[j++])
                                	if (opt.defaultSelected) hasDefault = true;
                         	j = hasDefault ? 0 : 1;
                         	while (opt = el.options[j++]) 
                                	if (opt.selected != opt.defaultSelected) return true;
                         	break;
		}
		
	}
	if (typeof(FCKeditorAPI) != 'undefined'){
		if (FCKeditorAPI.GetInstance('body') && FCKeditorAPI.GetInstance('body').IsDirty())
			return true;
		if (FCKeditorAPI.GetInstance('summary') && FCKeditorAPI.GetInstance('summary').IsDirty())
			return true;
		if (dirtyRelatedContent)
			return true;
	}
		
	return false;
}

function copyThis(siteID, contentID, _copyAll){
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.saveCopyInfo&siteid=' + siteID +'&contentid=' + contentID + '&copyAll='+ _copyAll + '&cacheid=' + Math.random();
	new Ajax.Request(url, {parameters:pars});
	
	copyContentID = contentID;
	copySiteID = siteID;
	copyAll = _copyAll;
	
	hideMenu('newContentMenu');
}

function pasteThis(parentID){
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.copy&compactDisplay=true&siteid=' + copySiteID +'&copyAll=' + copyAll +'&contentid=' + copyContentID + '&parentid=' + parentID + '&cacheid=' + Math.random();
	var d = $('newPasteLink');
	d.style.background='url(/admin/images/ajax-loader.gif) no-repeat 1px 5px;';
	reloadURL = document.getElementById('newZoomLink').href;

	new Ajax.Request(url, {parameters:pars, onSuccess:reloadPage});	
}

function reloadPage(){
	if (reloadURL == ''){
		window.location.reload();
	} else {
		location.href=reloadURL;
	}
}

function loadExtendedAttributes(contentHistID,type,subType,_siteID,_context,_themeAssetPath)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadExtendedAttributes&contentHistID=' + contentHistID +'&type=' + type  +'&subType=' + subType + '&siteID=' + _siteID + '&cacheid=' + Math.random();

		siteID=_siteID;
		context=_context;
		themeAssetPath=_themeAssetPath;
		//location.href=url + "?" + pars;
		var d = $('extendSetsDefault');
		var b = $('extendSetsBasic');
		if(d != null || b != null){	
			
			if(d != null)
			{d.innerHTML='<br/><img src="images/progress_bar.gif">';}

			if(b != null)
			{b.innerHTML='<br/><img src="images/progress_bar.gif">';}
			
			var myAjax = new Ajax.Request(url, {method: 'get', parameters: pars, onSuccess:setExtendedAttributes});
		}
		
		return false;
	}

function setExtendedAttributes(transport){
	var r=eval("(" + transport.responseText + ")");
	var extended=document.getElementById("extendSetsDefault");
	var basic=document.getElementById("extendSetsBasic");
	
	if(extended != null)
	{extended.innerHTML=r.extended;}
	
	if(basic != null)
	{basic.innerHTML=r.basic;}

	//checkExtendSetTargeting();
	setHTMLEditors(context,themeAssetPath);
}

function checkExtendSetTargeting(){
	var extendSets=document.getElementsByClassName('extendset');
	var found=false;
	var started=false;
	var empty=true;
	
	if (extendSets.length){
		for(var s=0;s<extendSets.length;s++){
			var extendSet=extendSets[s];

			if(extendSet.getAttribute("categoryid") != undefined
			&& extendSet.getAttribute("categoryid") != ""){
				if(!started){
				var categories=$('categoryContainer').getElementsByTagName('select');
				started=true;
				}
				
				for(var c=0;c<categories.length;c++){
					var cat =categories[c];
					var catID=categories[c].getAttribute("categoryid");
					var assignedID=extendSet.getAttribute("categoryid");
					if(!found && catID != null && assignedID.indexOf(catID) > -1){
						found=true;
						membership=cat.value;			
					}
				}
				
				if(found){
					if(membership!=""){
						setFormElementsDisplay(extendSet,'');
						extendSet.style.display='';	
						empty=false;
					} else {
						setFormElementsDisplay(extendSet,'none');
						extendSet.style.display='none';
						
					}
				} else {
					setFormElementsDisplay(extendSet,'none');
					extendSet.style.display='none';
					
				}
			} else {
				setFormElementsDisplay(extendSet,'');
				extendSet.style.display='';
				empty=false;
				
				
			}
			
			
			found=false;
		}
		
		if(empty){
			$('extendMessage').style.display="";
			$('extendDL').style.display="none";
		} else {
			$('extendMessage').style.display="none";
			$('extendDL').style.display="";
		}
	
	}

}

function resetExtendedAttributes(contentHistID,str,_siteID,_context,_themeAssetPath)	{
	var dataArray=str.split("^");
	loadExtendedAttributes(contentHistID,dataArray[0],dataArray[1],_siteID,_context,_themeAssetPath);
	//alert(dataArray[1]);
	document.contentForm.type.value=dataArray[0];
	document.contentForm.subtype.value=dataArray[1];
}

function setFormElementsDisplay(container,display){
	var inputs = container.getElementsByTagName('input');
	//alert(inputs.length);
	if(inputs.length){
		for(var i=0;i < inputs.length;i++){
			inputs[i].style.display=display;
			//alert(inputs[i].style.display);
		}
	}
	
	inputs = container.getElementsByTagName('textarea');
	
	if(inputs.length){
		for(var i=0;i < inputs.length;i++){
			inputs[i].style.display=display;
		}
	}
	
	inputs = container.getElementsByTagName('select');
	
	if(inputs.length){
		for(var i=0;i < inputs.length;i++){
			inputs[i].style.display=display;
		}
	}

}


function loadCategoryFeatureStartStop(id,display,siteID){
 if($(id).innerHTML.length > 10){
  document.getElementById(id).style.display = (display== true)?'':'none';
 } else if (display == true) {
  var url = 'index.cfm';
  var idParam = id;
  var pars = 'fuseaction=cArch.loadCategoryFeatureStartStop&id=' + idParam.replace(/editDates/, "") + '&siteID=' + siteID + '&cacheid=' + Math.random();
  $(id).style.display = '';
  var myAjax = new Ajax.Updater({success: id}, url, {method: 'get', parameters: pars});
  
 }
}



