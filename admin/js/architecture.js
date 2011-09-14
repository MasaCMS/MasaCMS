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
	provided that these modules (a) may only modify the  /plugins/ directory through the Mura CMS 
	plugin installation API, (b) must not alter any default objects in the Mura CMS database 
	and (c) must not alter any files in the following directories except in cases where the code contains 
	a separately distributed license.

	/admin/ 
	/tasks/ 
	/config/ 
	/requirements/mura/ 

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
	
	if(typeof(saveFormBuilder) != "undefined")
		saveFormBuilder();
	
	if (document.contentForm.display.value=='2') {
	var tempStart=document.contentForm.displayStart.value;
	var tempStop=document.contentForm.displayStop.value;
		//alert(tempStart);
		if (isDate(tempStart,'DISPLAY START DATE')==false) {
			
			alertDialog("Please enter a valid date in the 'Display Start Date' field");
			return false;				
		}
		else if (tempStop != '' && isDate(tempStop,'DISPLAY STOP DATE')==false) {
	
			alertDialog("Please enter a valid date in the 'Display Stop Date' field");
			return false;				
		}
	}
	else{
		document.contentForm.displayStart.value="";
		document.contentForm.displayStop.value="";
	}
	
	if(document.contentForm.title.value == ''){
		   if(document.contentForm.type.value=='Component'){
			    
			    alertDialog("The form field 'Menu Title' is required");
				return false;
				
			} else if(document.contentForm.type.value=='Form'){
		    	
		    	alertDialog("The form field 'Title' is required");
				return false;}
			else{
			
				alertDialog("The form field 'Long Title' is required");
				return false;}
			
	}
	
	 if(document.contentForm.type.value=='Link' 
		 	&& document.contentForm.filename.value == ''){

		alertDialog("The form field 'Url' is required"); 
		return false;
	 }
	
	 if(document.contentForm.approved.value==1 
			&& draftremovalnotice != "" 
			&& !confirm(draftremovalnotice)){
		 return false;
	 }
	 
	 if(document.contentForm.approved.value==1
			&& typeof(currentChangesetID) != 'undefined' 
			&& currentChangesetID != ''){
		 
		 confirmDialog(publishitemfromchangeset, 
				 					function() {
			 						formSubmitted = true;
			 						document.contentForm.submit(); 
			 						});
		 
		 return false;
		 
	 }else {
		 formSubmitted = true;
		 return true;
	 }
	
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

xPos = xPos +20;

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

document.getElementById('newZoomLink').onclick=function(){loadSiteManager(siteid,contentid,'00000000000000000000000000000000000','','',type,1); document.getElementById(id).style.visibility="hidden"; return false};
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



function deleteDisplayObject(regionID){
   var selectedObjects =document.getElementById("selectedObjects" + regionID);
   var deleteIndex =selectedObjects.selectedIndex;
   var len = (selectedObjects.options.length > 1)?selectedObjects.options.length-1:0;
   if(deleteIndex < 0) return;
	
	selectedObjects.options[deleteIndex]=null; 
	updateDisplayObjectList(regionID);
	
	if(selectedObjects.options.length){
		selectedObjects.options[selectedObjects.options.length-1].selected=true;
	}
	 
}

function updateDisplayObjectList(regionID){
	var selectedObjects =document.getElementById("selectedObjects" + regionID);
	var objectList=document.getElementById("objectList" + regionID)
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
	
	initDisplayObjectConfigurators();

}

function moveDisplayObjectUp(regionID){
var selectedObjects=document.getElementById("selectedObjects" + regionID);
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

updateDisplayObjectList(regionID);
}

function moveDisplayObjectDown(regionID){
var selectedObjects=document.getElementById("selectedObjects" + regionID);
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

updateDisplayObjectList(regionID);

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
		
function loadSiteParents(siteid,contentid,parentid,keywords,isNew)	{
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.siteParents&compactDisplay=true&siteid=' + siteid +'&contentid=' + contentid + '&parentid=' +parentid+ '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
	var d = jQuery('#move');
	d.html('<img src="images/progress_bar.gif"><input type=hidden name=parentid value=' + parentid + ' >');
	jQuery.get(url + "?" + pars, 
			function(data) {
			jQuery('#move').html(data);
			}
		);
}

function loadAssocImages(siteid,fileid,contentid,keywords,isNew)	{
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.assocImages&compactDisplay=true&siteid=' + siteid +'&fileid=' + fileid + '&contentid=' + contentid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
	var d = jQuery('#selectAssocImage');
	//d.html('<img class="loadProgress" src="images/progress_bar.gif">');
	jQuery.get(url + "?" + pars, 
			function(data) {
			jQuery('#selectAssocImage').html(data);
			jQuery('#selectAssocImageResults').slideDown();
			}
		);
}

function loadObjectClass(siteid,classid,subclassid,contentid,parentid,contenthistid)	{
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.loadclass&compactDisplay=true&siteid=' + siteid +'&classid=' + classid  +'&subclassid=' + subclassid + '&contentid=' + contentid + '&parentid=' + parentid  +'&cacheid=' + Math.random();
	var d=jQuery('#classList');

	d.html('<img class="loadProgress" src="images/progress_bar.gif">');
	jQuery.get(url + "?" + pars, 
		function(data) {
			jQuery('#classList').html(data);
			availableObjectTemplate="";
			availalbeObjectParams={};
			availableObject={};
		}
	);
	return false;
}

function getDisplayObjectClass(regionID){
	var str=jQuery('#selectedObjects' + regionID).val().toString();
	var a=str.split("~");
	return a[0];
}

function getDisplayObjectID(regionID){
	var str=jQuery('#selectedObjects' + regionID).val().toString();
	var a=str.split("~");
	return a[2];
}

function loadNotify(siteid,contentid,parentid)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadNotify&compactDisplay=true&siteid=' + siteid +'&contentid=' + contentid +'&parentid=' + parentid + '&cacheid=' + Math.random();
		var d = jQuery('#selectNotify');
		if(d.html()==''){
			d.show();
			d.html('<img class="loadProgress" src="images/progress_bar.gif">');
			jQuery.get(url + "?" + pars, 
					function(data) {
					jQuery('#selectNotify').html(data);
					}
			);
		}
		else {
			d.toggle();  
		}
		
		return false;
	}


function loadRelatedContent(siteid,keywords,isNew)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadRelatedContent&compactDisplay=true&siteid=' + siteid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		/*if(keywords != ''){
		location.href="?" + pars;
		}*/
		var d = jQuery('#selectRelatedContent');
			d.html('<img class="loadProgress" src="images/progress_bar.gif">');
			jQuery.get(url + "?" + pars, 
					function(data) {
					jQuery('#selectRelatedContent').html(data);
					}
			);
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
			deleteLink.onclick=function (){jQuery("#c" + contentID).remove(); stripe('stripe');return false;}
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
		 if(jQuery('#noFilters').length) jQuery('#noFilters').hide();
		
		 stripe('stripe');
		 dirtyRelatedContent = true;
		 
  } 
  
 

function removeRelatedContent(contentID,confirmText){
	if(confirm(confirmText)){
		jQuery("#" + contentID).remove(); 
		stripe('stripe');
		dirtyRelatedContent = true;
		}
	return false;
	}	
	
	


function form_is_modified(oForm)
{
	for (var i = 0; i < oForm.elements.length; i++)
    {
        var element = oForm.elements[i];
        var type = element.type;
        if (type == "checkbox" || type == "radio")
        {
            if (element.checked != element.defaultChecked)
            {
            	//alert(type + ":" + element.name)
                return true;
            }
        }
        else if (type == "hidden" || type == "password" || type == "text" ||
                 type == "textarea")
        {
            if (element.value != element.defaultValue)
            {
            	if(element.name !='sdContent'){
            		//alert(type + ":" + element.name)
            		return true;
            	}
            }
        }
        /*
        else if (type == "select-one" || type == "select-multiple")
        {
            for (var j = 0; j < element.options.length; j++)
            {
                if (element.options[j].selected !=
                    element.options[j].defaultSelected)
                {
                    return true;
                } 
            }
        }
        */
    }
	
	if (typeof(FCKeditorAPI) != 'undefined'){
		if (FCKeditorAPI.GetInstance('body') && FCKeditorAPI.GetInstance('body').IsDirty())
			return true;
		if (FCKeditorAPI.GetInstance('summary') && FCKeditorAPI.GetInstance('summary').IsDirty())
			return true;
		if (dirtyRelatedContent)
			return true;
	} else if (typeof(CKEDITOR) != 'undefined' && typeof(CKEDITOR.instances["body"]) != 'undefined'){
		var instance = CKEDITOR.instances["body"];
		if(instance.checkDirty()){
			return true;
		}
		
	}
		
	return false;
}

function copyThis(siteID, contentID, _copyAll){
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.saveCopyInfo&siteid=' + siteID +'&contentid=' + contentID + '&copyAll='+ _copyAll + '&cacheid=' + Math.random();
	
	jQuery.get(url + "?" + pars);
	
	copyContentID = contentID;
	copySiteID = siteID;
	copyAll = _copyAll;
	
	hideMenu('newContentMenu');
}

function pasteThis(parentID){
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.copy&compactDisplay=true&siteid=' + copySiteID +'&copyAll=' + copyAll +'&contentid=' + copyContentID + '&parentid=' + parentID + '&cacheid=' + Math.random();
	var d = jQuery('#newPasteLink');
	d.css('background','url(/admin/images/ajax-loader.gif) no-repeat 1px 5px;');
	reloadURL = jQuery('#newZoomLink').attr("href");

	jQuery.get(url + "?" + pars, 
			function(data) {
				loadSiteManager(copySiteID,parentID,'00000000000000000000000000000000000','','','',1);
				jQuery("#newContentMenu").hide();
			}
	);
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
		var d = jQuery('#extendSetsDefault');
		var b = jQuery('#extendSetsBasic');
		if(d.length || b.length){	
			
			if(d.length)
			{d.html('<img class="loadProgress" src="images/progress_bar.gif">');}

			if(b.length)
			{b.html('<img class="loadProgress" src="images/progress_bar.gif">');}
			
			jQuery.get(url + "?" + pars, 
					function(data) {
					setExtendedAttributes(data);
					}
			);
		}
		
		return false;
	}

function setExtendedAttributes(data){
	var r=eval("(" + data + ")");

	jQuery("#extendSetsDefault").html(r.extended);
	jQuery("#extendSetsBasic").html(r.basic);

	checkExtendSetTargeting();
	setHTMLEditors(context,themeAssetPath);
	setDatePickers("#extendSetsDefault .datepicker",dtLocale);
	setDatePickers("#extendSetsBasic .datepicker",dtLocale);
}

function checkExtendSetTargeting(){
	var extendSets=jQuery('.extendset');
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
			jQuery('#extendMessage').show();
			jQuery('#extendDL').hide();
		} else {
			jQuery('#extendMessage').hide();
			jQuery('#extendDL').show();
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
 var cat=jQuery("#" + id);
 if(cat.html().length > 10){
	 cat.toggle();
 } else if (display == true) {
  var url = 'index.cfm';
  var idParam = id;
  var pars = 'fuseaction=cArch.loadCategoryFeatureStartStop&id=' + idParam.replace(/editDates/, "") + '&siteID=' + siteID + '&cacheid=' + Math.random();
  cat.show();
  jQuery.get(url + "?" + pars, 
			function(data) {
			jQuery("#" + id).html(data);
			setDatePickers("#" + id +" .datepicker",dtLocale)
			}
	);
  
 }
}

activeQuickEdit=false;

function loadSiteManager(siteid,topid,moduleid,sortby,sortdirection,ptype,startrow)	{
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.loadSiteManager&siteid=' + siteid  + '&topid=' + topid  + '&moduleid=' + moduleid  + '&sortby=' + sortby  + '&sortdirection=' + sortdirection  + '&ptype=' + ptype  + '&startrow=' + startrow + '&cacheid=' + Math.random();

	//location.href=url + "?" + pars;
	var d = jQuery('#gridContainer');
		if (!activeQuickEdit) {
			d.html('<img class="loadProgress" src="images/progress_bar.gif">').show();
		}
		jQuery.get(url + "?" + pars, 
				function(data) {
					try{
						var r=eval("(" + data + ")");
						if (!activeQuickEdit) {
							d.hide()
						}
						d.html(r.html);
						document.getElementById("newContentMenu").style.visibility="hidden";
						stripe('stripe');
						initQuickEdits();
						initDraftPrompt();	
						if(r.perm.toLowerCase() == "editor" && r.sortby.toLowerCase() == 'orderno') {
							jQuery("#sortableKids").sortable(
								{
				   					stop: function(event, ui) {
				   					 	stripe('stripe');setAsSorted();
				   					  	$(ui.item).removeClass('ui-draggable-dragging');
				   				 	},
				   					start: function(event, ui) {
				   					 	$(ui.item).addClass('ui-draggable-dragging');
				   				 	}
								}
							);
							jQuery("#sortableKids").disableSelection();
					 	}
					} catch(err){
							d.html(data);
						
					}
					
					if (!activeQuickEdit) {
						d.hide().animate({
							'opacity': 'show'
						}, 1000);
					}
					activeQuickEdit=false;				
				}
		);
		
	
	
	return false;
}

var sectionLoading=false;

function loadSiteSection(node, startrow)	{
	
	if (!sectionLoading) {
		sectionLoading = true;
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadSiteSection&siteid=' + node.attr("data-siteid") + '&contentID=' + node.attr("data-contentid") + '&moduleid=' + node.attr("data-moduleid") + '&sortby=' + node.attr("data-sortby") + '&sortdirection=' + node.attr("data-sortdirection") + '&ptype=' + node.attr("data-type") + '&startrow=' + startrow + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var icon = node.find("span:first");
		
		if (icon.hasClass('hasChildren-closed')) {
		
			icon.removeClass('hasChildren-closed');
			icon.addClass('hasChildren-open');
				
			//d.append('<img class="loadProgress" src="images/progress_bar.gif">');
			//d.find(".loadProgress").show();
			jQuery.get(url + "?" + pars, function(data){
				try {
					var r = eval("(" + data + ")");
					
					//d.find(".loadProgress").remove();
					node.find('.section:first').remove();
					node.append(r.html);
					
					document.getElementById("newContentMenu").style.visibility = "hidden";
					stripe('stripe');
					initDraftPrompt();
					initQuickEdits();
					node.find('.section:first').hide().fadeIn("slow");
					
				} 
				catch (err) {
					node.append(data);
				}
				
				sectionLoading = false;
			});
		}
		else {
		
			icon.removeClass('hasChildren-open');
			icon.addClass('hasChildren-closed');
			
			jQuery.get(url + "?" + pars);
			
			node.find('.section:first').fadeOut("fast",
				function(){
					node.find('.section:first').remove();
				    stripe('stripe');
					document.getElementById("newContentMenu").style.visibility = "hidden";
					sectionLoading = false;
				}
			);	
			
		}
	}
	return false;
}

function refreshSiteSection(node, startrow)	{
	if (!sectionLoading) {
		sectionLoading = true;
		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.refreshSiteSection&siteid=' + node.attr("data-siteid") + '&contentID=' + node.attr("data-contentid") + '&moduleid=' + node.attr("data-moduleid") + '&sortby=' + node.attr("data-sortby") + '&sortdirection=' + node.attr("data-sortdirection") + '&ptype=' + node.attr("data-type") + '&startrow=' + startrow + '&cacheid=' + Math.random();
	
		jQuery.get(url + "?" + pars, function(data){
			try {
				var r = eval("(" + data + ")");
				
				//d.find(".loadProgress").remove();
				node.find('.section:first').remove();
				node.append(r.html);
				
				document.getElementById("newContentMenu").style.visibility = "hidden";
				stripe('stripe');
				initDraftPrompt();
				initQuickEdits();	
			} 
			catch (err) {
				node.append(data);
			}
			
			activeQuickEdit = false;
			sectionLoading = false;
		});
		
	}
	return false;
}
function setAsSorted(){	
		jQuery('#sorted').val('true');	
		jQuery('#submitSort').pulse({
                opacity: [.5,1]
            }, {
                times: 999999,
                duration: 750
            });
        jQuery('#submitSort').addClass('pulse');
}


var quickEditTmpl = '<div class="mura-quickEdit" id="mura-quickEditor">';
	quickEditTmpl += '<img class="loader" src="images/ajax-loader-big.gif" />';
	quickEditTmpl += '</div>';      		
	     
function initQuickEdits(){
	jQuery(".mura-quickEditItem").click(
			function(event){
				event.preventDefault();
				if (!activeQuickEdit) {
					
					var attribute=jQuery(this).attr("data-attribute");
					var node = jQuery(this).parents("li:first");
					var url = 'index.cfm';
					var pars = 'fuseaction=cArch.loadQuickEdit&siteid=' + siteid + '&contentID=' + node.attr("data-contentid") + '&attribute=' + attribute + '&cacheid=' + Math.random();
					
					//location.href='?' + pars;
					//images/icons/template_24x24.png
					
					jQuery("#mura-quickEditor").remove();
					jQuery("#selected").attr("id","");
					jQuery('#selectedIcon').attr("id","").attr("src","images/icons/template_24x24.png");
					jQuery(this).parent().prepend(quickEditTmpl);
					
					var qe = jQuery("#mura-quickEditor")
					var dd = qe.parents("dd:first");
					
					dd.attr("id","selected");
					
					jQuery.get(url + "?" + pars, function(data){
						jQuery("#mura-quickEditor").html(data);
						setDatePickers(".mura-quickEdit-datepicker",dtLocale,dtCh);	
						if(jQuery("#hasDraftsMessage").length){
						   dd.addClass("hasDraft");
						}
						
						if(attribute == 'template'){
							var img= dd.find("img:first");
							if(img.length){
								img.attr("id","selectedIcon").attr("src","images/icons/template_24x24-on.png")
							}
						}
						
					});
				}			
			}
		);
}

function saveQuickEdit(){
	activeQuickEdit=true;
	var attribute=jQuery("#mura-quickEditor").parent().find(".mura-quickEditItem:first").attr("data-attribute");
	var node=jQuery("#mura-quickEditor").parents("li:first");
	var url = 'index.cfm';
	
	var basePars = {
		'fuseaction':'cArch.saveQuickEdit',
		'siteID' : siteID,
		'contentID':  node.attr("data-contentid"),
		'attribute': attribute	
	}
	
	if (attribute == 'isnav') {
		var attributeParams = {
			'isnav': jQuery("#mura-quickEdit-isnav").val()
			}
	} else if (attribute == 'inheritObjects') {
		var attributeParams = {
		'inheritObjects': jQuery("#mura-quickEdit-inheritobjects").val()
		}
	} else if (attribute == 'template') {
		var attributeParams = {
		'template': jQuery("#mura-quickEdit-template").val(),
		'childTemplate': jQuery("#mura-quickEdit-childtemplate").val()
		}
	} else if (attribute == 'display') {
		var attributeParams = {
		'display': jQuery("#mura-quickEdit-display").val(),
		'displayStop': jQuery("#mura-quickEdit-displayStop").val(),
		'stopHour': jQuery("#mura-quickEdit-stopHour").val(),
		'stopMinute': jQuery("#mura-quickEdit-stopMinute").val(),
		'stopDayPart': jQuery("#mura-quickEdit-stopDayPart").val(),
		'displayStart': jQuery("#mura-quickEdit-displayStart").val(),
		'startHour': jQuery("#mura-quickEdit-startHour").val(),
		'startMinute': jQuery("#mura-quickEdit-startMinute").val(),
		'startDayPart': jQuery("#mura-quickEdit-startDayPart").val()
		}
	
	}
	
	var pars=jQuery.extend({},basePars,attributeParams);

	jQuery("#mura-quickEditor").html('<img class="loader" src="images/ajax-loader-big.gif" />');
	
	jQuery.post('index.cfm',pars,
		function(data){		
			var parentNode=node.parents("li:first");
			if (parentNode.length) {
				refreshSiteSection(parentNode,1)
			} else {
				var topNode=jQuery("#top-node").parents("li:first");
				loadSiteManager(topNode.attr("data-siteid"),topNode.attr("data-contentid"),topNode.attr("data-moduleid"),topNode.attr("data-sortby"),topNode.attr("data-sortdirection"),topNode.attr("data-type"),1);
			}
	});	
	
}

function closeQuickEdit(){
	jQuery('#selected').attr("id","");
	jQuery('#selectedIcon').attr("id","").attr("src","images/icons/template_24x24.png");
	jQuery('.mura-quickEdit').remove();
}

var availableObjectTemplate="";
var availalbeObjectParams={};
var availableObject={};
	
function getDisplayObjectConfig(regionID){
		var selectedObjects=jQuery('#selectedObjects' + regionID);
		var str=selectedObjects.val().toString();
		var a=str.split("~");
		var data={};
		
		data.object=a[0];
		data.name=a[1];
		data.objectid=a[2];
		
		if(a.length > 3){
			data.params=a[3];
		}
		
		data.regionID=regionID;
		return data;
}
		

function addDisplayObject(objectToAdd,regionID,configure){
	var tmpObject="";
	var tmpValue="";
	var tmpText="";
	var isUpdate=false;
	//If it's not a js object then it must be an id of a form input or select
	if(typeof(objectToAdd)=="string"){
	
		// return error if the id does not exist.
		if(document.getElementById(objectToAdd)==null){
			
			alertDialog("Please select a display object."); 
			
			return false;
		}
		
		if (document.getElementById(objectToAdd).tagName.toLowerCase() == "select") {
		
			if (document.getElementById(objectToAdd).selectedIndex == -1) {
				alertDialog("Please select a display object.");
				
				return false;
			}
			//alert("Please select a display object."); return false;}
			
			var addIndex = document.getElementById(objectToAdd).selectedIndex;
			
			if (addIndex < 0) 
				return false;
			
			var addoption = document.getElementById(objectToAdd).options[addIndex];
			
			tmpText = addoption.text;
			tmpValue = addoption.value;
			
		} else if(document.getElementById(objectToAdd).tagName.toLowerCase() == "input"){
		  
			var addoption =document.getElementById(objectToAdd);
			tmpValue=addoption.value;

		} else {
			//If it's not a select box then the value must be json object.
			addoption=document.getElementById(objectToAdd);		
		}
		
		try
		  {
			tmpObject=eval('(' + addoption.value + ')');
		  }
		catch(err)
		  {
			tmpObject=addoption.value
		  }
	
	} else {
		//If it's not a select box then the value must be json object.
		tmpObject=objectToAdd;
	}

	//if the tmpValue evaluated into a js object pull out it's values
	var checkSelection=false;
	
	if(typeof(tmpObject) == "object"){
		//object^name^objectID^params
			
		if (tmpObject.object=='feed') {
			if (configure) {
				tmpObject.regionID=regionID;
				if (initFeedConfigurator(tmpObject)){
					return false;
				}
			}
			checkSelection=true;
		}
		
		if (tmpObject.object=='feed_slideshow') {
			if (configure) {
				tmpObject.regionID = regionID;
				initSlideShowConfigurator(tmpObject)
				return false;
			}
			checkSelection=true;
		}
		
		if (tmpObject.object=='category_summary') {
			if (configure) {
				tmpObject.regionID=regionID;
				initCategorySummaryConfigurator(tmpObject)
				return false;
			}
			checkSelection=true;
		}
	
		if ((tmpObject.object == 'related_content' || tmpObject.object == 'related_section_content')) {
			if (configure) {
				tmpObject.regionID=regionID;
				initRelatedContentConfigurator(tmpObject);
				return false;
			}
			checkSelection=true;
		}
		
		tmpValue=tmpObject.object;
		tmpValue=tmpValue + "~" + tmpObject.name;	
		tmpValue=tmpValue + "~" + tmpObject.objectid;
		
		if(typeof(tmpObject.params) == "string"){
			tmpValue   = tmpValue + "~" + tmpObject.params;
		} else if (typeof(tmpObject.params) == "object"){
			tmpValue   = tmpValue + "~" + JSON.stringify( tmpObject.params );
		}
		
		if(checkSelection && document.getElementById('selectedObjects' + regionID).selectedIndex != -1){
			var currentSelection=getDisplayObjectConfig(regionID);
			
			if(currentSelection){
				if(currentSelection.objectid==tmpObject.objectid){
					isUpdate=true
				}
			}
			
		}
		
		
		tmpText=tmpObject.name;	
		
	} 

	if(tmpValue == ""){
			
			alertDialog("Please select a display object."); 
			
			return false;
	}
	
	//get reference to the select where it will go.
	var selectedObjects =document.getElementById("selectedObjects" + regionID);
	
	//double check that it's not already there
	if(selectedObjects.options.length){	
		for (var i=0;i < selectedObjects.options.length;i++){ 
			if(selectedObjects.options[i].value==tmpValue) {
			selectedObjects.selectedIndex=i;
			return false;
			}
		}
	}
	

	// add it.

	
	if (isUpdate) {
		myoption=selectedObjects.options[document.getElementById("selectedObjects" + regionID).selectedIndex];
		myoption.text= tmpText;
		myoption.value=tmpValue;
	}else{
		var myoption = document.createElement("option");
		selectedObjects.appendChild(myoption);
		myoption.text= tmpText;
		myoption.value=tmpValue;
		myoption.selected = "selected"
		
	}
	
	updateDisplayObjectList(regionID);
	
	return true
	
}

	function initCategorySummaryConfigurator(data){
		
		resetAvailableObject();
		resetConfiguratorContainer();
		
		if(typeof(data.object) !='undefined'){	
			if(data.object !='category_summary'){
				return false;
			}
		}

		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + siteid + '&classid=category_summary&contentid=' + contentid + '&parentid=' + parentid + '&contenthistid=' + contenthistid + '&regionid=' + data.regionID  + '&objectid=' +  data.objectid + '&cacheid=' + Math.random();
		var regionID=data.regionID;
		
		//location.href=url + "?" + pars;
		
		jQuery("#configuratorContainer").dialog({
			resizable: true,
			modal: false,
			width: 400,
			position: getDialogPosition(),
			buttons: {
				Save: function() {
					addDisplayObject(availableObject,regionID,false);
					jQuery( this ).dialog( "close" );
							
				},
				Cancel: function() {
					jQuery( this ).dialog( "close" );
				}
			},
			close: function(){
				jQuery(this).dialog("destroy");
			}	
		});
				
		jQuery.post(url + "?" + pars, 
			data,
			function(data) {
	
				jQuery("#configurator").html(data);
				jQuery("#ui-dialog-title-configuratorContainer").html(categorySummaryConfiguratorTitle);	
				jQuery("#configuratorContainer").dialog("option","position",getDialogPosition());
				
				if(availableObjectTemplate==""){
					availableObjectTemplate=eval( "(" + jQuery("#displayObjectTemplate").val() + ")");
					availableObject=jQuery.extend({},availableObjectTemplate);
				}
				
				initConfiguratorParams();
		
			}
		);
		
		return true;
	}
	
	function initFeedConfigurator(data){
		var feedID="";
		
		resetAvailableObject();
		resetConfiguratorContainer();
		
		if(typeof(data.object) !='undefined'){	
			if(data.object !='feed'){
				return false;
			}
			var feedID= data.objectid;
		}
		
		if(feedID ==''){
			return false;
		}

		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + siteid + '&classid=feed&contentid=' + contentid + '&parentid=' + parentid + '&contenthistid=' + contenthistid + '&regionid=' + data.regionID  + '&feedid=' +  feedID + '&cacheid=' + Math.random();
		var regionID=data.regionID;
		
		//location.href=url + "?" + pars;
		
		jQuery("#configuratorContainer").dialog({
					resizable: true,
					modal: false,
					width: 400,
					position: getDialogPosition(),
					buttons: {
						Save: function() {
							addDisplayObject(availableObject,regionID,false);
							jQuery( this ).dialog( "close" );
							
						},
						Cancel: function() {
							jQuery( this ).dialog( "close" );
						}
					},
					close: function(){
						jQuery(this).dialog("destroy");
					}	
				});
		//location.href=url + "?" + pars;
		
		jQuery.post(url + "?" + pars, 
			data,
			function(resp) {
				
				data=eval('(' + resp + ')');
				
				jQuery("#configurator").html(data.html);
				jQuery("#configuratorContainer").dialog("option","position",getDialogPosition());
				
				if(data.type.toLowerCase()=='remote'){
					jQuery("#ui-dialog-title-configuratorContainer").html(remoteFeedConfiguratorTitle);
				} else {
					jQuery("#ui-dialog-title-configuratorContainer").html(localIndexConfiguratorTitle);
				}
				
				if(availableObjectTemplate==""){
					availableObjectTemplate=eval( "(" + jQuery("#displayObjectTemplate").val() + ")");
					availableObject=jQuery.extend({},availableObjectTemplate);
				}
				
				if (jQuery("#availableListSort").length) {
					jQuery("#availableListSort, #displayListSort").sortable({
						connectWith: ".displayListSortOptions",
						update: function(event){
							event.stopPropagation();
							jQuery("#displayList").val("");
							jQuery("#displayListSort > li").each(function(){
								var current = jQuery("#displayList").val();
								
								if (current != '') {
									jQuery("#displayList").val(current + "," + jQuery(this).html());
								}
								else {
									jQuery("#displayList").val(jQuery(this).html());
								}
								
							});
							
							updateAvailableObject();
						}
					}).disableSelection();
				}
				
				initConfiguratorParams();
		
			}
		);
		
		return true;
	}
	
	function initSlideShowConfigurator(data){
		var feedID="";
		
		resetAvailableObject();
		resetConfiguratorContainer();
		
		if(typeof(data.object) !='undefined'){	
			if(data.object !='feed_slideshow'){
				return false;
			}
			var feedID= data.objectid;
		}
		
		if(feedID ==''){
			return false;
		}

		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + siteid + '&classid=feed_slideshow&contentid=' + contentid + '&parentid=' + parentid + '&contenthistid=' + contenthistid + '&regionid=' + data.regionID  + '&feedid=' +  feedID + '&cacheid=' + Math.random();
		var regionID=data.regionID;
		
		//location.href=url + "?" + pars;
		
		jQuery("#configuratorContainer").dialog({
					resizable: true,
					modal: false,
					width: 400,
					position: getDialogPosition(),
					buttons: {
						Save: function() {
							addDisplayObject(availableObject,regionID,false);
							jQuery( this ).dialog( "close" );
							
						},
						Cancel: function() {
							jQuery( this ).dialog( "close" );
						}
					},
					close: function(){
						jQuery(this).dialog("destroy");
					}
				});
		
		jQuery.post(url + "?" + pars,
			data, 
			function(data) {
				
				jQuery("#ui-dialog-title-configuratorContainer").html(slideShowConfiguratorTitle);	
				jQuery("#configurator").html(data);
				jQuery("#configuratorContainer").dialog("option","position",getDialogPosition());
				
				if(availableObjectTemplate==""){
					availableObjectTemplate=eval( "(" + jQuery("#displayObjectTemplate").val() + ")");
					availableObject=jQuery.extend({},availableObjectTemplate);
				}
				
				jQuery( "#availableListSort, #displayListSort" ).sortable({
					connectWith: ".displayListSortOptions",
					update: function(event){
						event.stopPropagation();
						jQuery("#displayList").val("");
						jQuery("#displayListSort > li").each(function(){
							var current = jQuery("#displayList").val();
							
							if (current != '') {
								jQuery("#displayList").val(current + "," + jQuery(this).html());
							}
							else {
								jQuery("#displayList").val(jQuery(this).html());
							}
							
						});
						updateAvailableObject();
					}
				}).disableSelection();
				
				initConfiguratorParams();
		
			}
		);
		
		return true;
	}
	
	function initRelatedContentConfigurator(data){

		resetAvailableObject();
		resetConfiguratorContainer();
		
		if (typeof(data.object) != 'undefined') {
			if (data.object != 'related_content' && data.object != 'related_section_content') {
				return false;
			}
		} else{
			return false;
		}

		var url = 'index.cfm';
		var pars = 'fuseaction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + siteid + '&classid=' + data.object + '&contentid=' + contentid + '&parentid=' + parentid + '&contenthistid=' + contenthistid + '&regionid=' + data.regionID  + '&objectid=' +  data.objectid + '&cacheid=' + Math.random();
		var regionID=data.regionID;
		
		//location.href=url + "?" + pars;
		
		jQuery("#configuratorContainer").dialog({
					resizable: true,
					modal: false,
					width: 400,
					position: getDialogPosition(),
					buttons: {
						Save: function() {
							addDisplayObject(availableObject,regionID,false);
							jQuery( this ).dialog( "close" );
							
						},
						Cancel: function() {
							jQuery( this ).dialog( "close" );
						}
					},
					close: function(){
						jQuery(this).dialog("destroy");
					}
				});
		
		jQuery.post(url + "?" + pars,
			data, 
			function(data) {
				
				jQuery("#ui-dialog-title-configuratorContainer").html(relatedContentConfiguratorTitle);		
				jQuery("#configurator").html(data);
				jQuery("#configuratorContainer").dialog("option","position",getDialogPosition());
				
				if(availableObjectTemplate==""){
					availableObjectTemplate=eval( "(" + jQuery("#displayObjectTemplate").val() + ")");
					availableObject=jQuery.extend({},availableObjectTemplate);
				}
				
				jQuery( "#availableListSort, #displayListSort" ).sortable({
					connectWith: ".displayListSortOptions",
					update: function(event){
						event.stopPropagation();
						jQuery("#displayList").val("");
						jQuery("#displayListSort > li").each(function(){
							var current = jQuery("#displayList").val();
							
							if (current != '') {
								jQuery("#displayList").val(current + "," + jQuery(this).html());
							}
							else {
								jQuery("#displayList").val(jQuery(this).html());
							}
							
						});
						updateAvailableObject();
					}
				}).disableSelection();
				
				initConfiguratorParams();
		
			}
		);
		
		return true;
	}
	
	function initGenericConfigurator(data){
		resetAvailableObject();
		resetConfiguratorContainer();
		//location.href=url + "?" + pars;
		
		jQuery("#configuratorContainer").dialog({
				resizable: true,
				modal: false,
				width: 400,
				position: getDialogPosition(),
				buttons: {
					Cancel: function() {
							jQuery( this ).dialog( "close" );
					}
				},
				open: function(){		
					jQuery("#ui-dialog-title-configuratorContainer").html(genericConfiguratorTitle);
					jQuery("#configurator").html("<p>" + genericConfiguratorMessage +"</p>");
				},
				close: function(){
					jQuery(this).dialog("destroy");
				}	
		});
		
		return true;
	}
	
	jQuery(document).ready(
		function(){
			initDisplayObjectConfigurators()
		}
	);
	
	function updateAvailableObject(){
		availableObjectParams={};
							
		jQuery("#availableObjectParams").find(":input").each(
			function(){
				var item=jQuery(this);
				if (item.attr("type") != "radio" || (item.attr("type") =="radio" && item.is(':checked'))) {
					availableObjectParams[item.attr("data-displayobjectparam")] = item.val();
				}
			}
		)
		availableObject=jQuery.extend({},availableObjectTemplate);
		availableObject.params=availableObjectParams;	
	}
		
	function initDisplayObjectConfigurators(){
		jQuery(".displayRegions").find("option").dblclick(
			function(){
				var regionID=jQuery(this).parents("select:first").attr("data-regionid");
				var data=getDisplayObjectConfig(regionID);
					
				if (data.object == 'feed') {
					initFeedConfigurator(data);
				} else if (data.object == 'feed_slideshow') {
					initSlideShowConfigurator(data);
				} else if (data.object == 'category_summary') {
					initCategorySummaryConfigurator(data);
				} else if (data.object == 'related_content' || data.object == 'related_section_content') {
					initRelatedContentConfigurator(data);
				} else{
					initGenericConfigurator(data);
				}
			}
		);
	}
	
	function resetAvailableObject(){
		availableObjectTemplate="";
		availalbeObjectParams={};
		availableObject={};
	}
	
	function resetConfiguratorContainer(){
		//jQuery(instance).dialog("destroy");
		jQuery("#configuratorContainer").remove();
		jQuery("body").append('<div id="configuratorContainer" title="Loading..." style="display:none"><div id="configurator"><img src="images/progress_bar.gif"></div></div>');
	}
	
	function initConfiguratorParams(){
		jQuery("#availableObjectParams").find(":input").bind(
			"change",
			function(){
				updateAvailableObject();
		});
	}
	
function setContentDisplayListSort(){
	jQuery( "#contentAvailableListSort, #contentDisplayListSort" ).sortable({
		connectWith: ".contentDisplayListSortOptions",
		update: function(event){
				event.stopPropagation();
				jQuery("#contentDisplayList").val("");
				jQuery("#contentDisplayListSort > li").each(function(){
					var current = jQuery("#contentDisplayList").val();
					
					if (current != '') {
						jQuery("#contentDisplayList").val(current + "," + jQuery(this).html());
					}
					else {
						jQuery("#contentDisplayList").val(jQuery(this).html());
					}
							
				});
			}
		}).disableSelection();
}

