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

function loadSiteRSS(siteid)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cRss.loadSite&siteid=' + siteid + '&cacheid=' + Math.random();
		var d = $('contentSelectorContainer');
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
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


