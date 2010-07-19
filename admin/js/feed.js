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

function loadSiteFilters(siteid,keywords,isNew)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cFeed.loadSite&compactDisplay=true&siteid=' + siteid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		var d = jQuery('#selectFilter');
			d.html('<br/><img src="images/progress_bar.gif">');
			jQuery.get(url + "?" + pars, 
					function(data) {
					jQuery("#selectFilter").html(data);
					}
			);
	}
	 
function addContentFilter(contentID,contentType,title)	{
		var tbody = document.getElementById('contentFilters').getElementsByTagName("TBODY")[0];	
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
			content.setAttribute("name","contentID");
			content.setAttribute("value",contentID);
			admin.appendChild(content);
			admin.appendChild(deleteUL);
			row.appendChild(name);
			row.appendChild(type);
			row.appendChild(admin);
   			tbody.appendChild(row);
		 if(jQuery('#noFilters').length) jQuery('#noFilters').hide();
		
		 stripe('stripe');
		 
  } 
  
 

function removeFilter(id){
	jQuery("#" + id).remove(); 
	stripe('stripe');
	return false;
	}	
	

function loadSiteParents(siteid,parentid,keywords,isNew)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cFeed.siteParents&compactDisplay=true&siteid=' + siteid + '&parentid=' +parentid+ '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		var d = jQuery('#move');
			d.html('<br/><img src="images/progress_bar.gif"><inut type=hidden name=parentid value=' + parentid + ' >');
			jQuery.get(url + "?" + pars, 
					function(data) {
					jQuery("#move").html(data);
					}
			);
	}

function confirmImport(){
	
	
	jQuery("#alertDialogMessage").html('Import Selections?');
	jQuery("#alertDialog").dialog({
			resizable: false,
			modal: true,
			buttons: {
				'YES': function() {
					jQuery(this).dialog('close');
					submitForm(document.forms.contentForm,'Import');
					},
				'NO': function() {
					jQuery(this).dialog('close');
				}
			}
		});

	return false;	
}
