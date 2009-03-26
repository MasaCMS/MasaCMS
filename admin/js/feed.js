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

function loadSiteFilters(siteid,keywords,isNew)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cFeed.loadSite&compactDisplay=true&siteid=' + siteid + '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		var d = $('selectFilter');
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'selectFilter'}, url, {method: 'get', parameters: pars});
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
			content.setAttribute("name","contentID");
			content.setAttribute("value",contentID);
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
	Element.remove(contentID); 
	stripe('stripe');
	return false;
	}	
	

function loadSiteParents(siteid,parentid,keywords,isNew)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cFeed.siteParents&compactDisplay=true&siteid=' + siteid + '&parentid=' +parentid+ '&keywords=' + keywords + '&isNew=' + isNew + '&cacheid=' + Math.random();
		var d = $('move');
			d.innerHTML='<br/><img src="images/progress_bar.gif"><inut type=hidden name=parentid value=' + parentid + ' >';
		var myAjax = new Ajax.Updater({success: 'move'}, url, {method: 'get', parameters: pars});
	}


