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

function loadSiteRSS(siteid)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cRss.loadSite&siteid=' + siteid + '&cacheid=' + Math.random();
		var d = $('contentSelectorContainer');
			d.innerHTML='<img class="loadProgress" src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'contentSelectorContainer'}, url, {method: 'get', parameters: pars});
	}	
	
function addContentFilter()	{
		var c = $('contentSelector');
		var thePreSelection=c[c.selectedIndex].value;
		var theSelection=thePreSelection.split("^");
			theSelection[2]=c[c.selectedIndex].innerHTML.replace(/&nbsp;/gi,"");
		var tbody = document.getElementById('metadata').getElementsByTagName("TBODY")[0];	
		var row = document.createElement("TR");
			row.id="c" + theSelection[0];
		var name = document.createElement("TD");
			name.appendChild(document.createTextNode(theSelection[2].toString()));
			name.className="title";
		var type = document.createElement("TD");
			type.appendChild (document.createTextNode(theSelection[1].toString()));
		var admin = document.createElement("TD");
			admin.className="administration";
		var deleteLink=document.createElement("A");
			deleteLink.setAttribute("href","#");
			deleteLink.onclick=function (){if(confirm('Delete filter?')){Element.remove("c" + theSelection[0]); stripe('stripe');}return false;}
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
			content.setAttribute("value",theSelection[0]);
			admin.appendChild(content);
			admin.appendChild(deleteUL);
			row.appendChild(name);
			row.appendChild(type);
			row.appendChild(admin);
   			tbody.appendChild(row);
		 if($('noFilters') != null) $('noFilters').style.display='none';
		
		 stripe('stripe');
		 
  } 
  
 

function removeFilter(contentID){
	if(confirm('Delete filter?')){
		Element.remove(contentID); 
		stripe('stripe');
		}
	return false;
	}	


