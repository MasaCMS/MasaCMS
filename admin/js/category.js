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

function showMenu(id,obj,parentid,siteid) {
		
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

document.getElementById(id).style.top=yPos + "px" ;
document.getElementById(id).style.left=xPos + "px" ;
document.getElementById(id).style.visibility="visible";

document.getElementById('newCategoryLink').href=
'index.cfm?fuseaction=cCategory.edit&parentid=' + parentid + '&siteid=' + siteid;


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