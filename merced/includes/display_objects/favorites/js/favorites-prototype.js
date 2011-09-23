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


var currentPageFavoriteID = "";
var favoriteExists = false;

function effectFunction()
{
	Effect.toggle($("favoriteListMore"), 'blind', {duration: '.1'});
	return false;
	
}

function saveFavorite(userID, siteID, favoriteName, favoriteLocation, favoriteType)
{
	//if (!favoriteExists){
		new Effect.Fade($("addFavorite"));
		var url = assetpath + '/includes/display_objects/favorites/ajax/saveFavorite.cfm';
		//var pars = 'empID=' + empID + '&year=' + y;
		var pars = 'userID=' + userID + '&siteid=' + siteID + '&favoriteName=' + favoriteName + '&favoriteLocation=' + favoriteLocation + '&favoriteType=' + favoriteType + '&cacheid=' + Math.random();
		//location.href= url + "?" + pars;
		var myAjax = new Ajax.Request( url, { method: 'get', parameters: pars, onComplete: showSaveFavoriteResponse });
	//}
	return false;
}

function showSaveFavoriteResponse(originalRequest)
{
	
	var r = eval( '(' + originalRequest.responseText + ')' );
	var iid = r.lid;
	var mover=document.createElement("DIV");
	var li=document.createElement("LI");
	li.setAttribute("id","favorite" + iid);
	li.setAttribute("style", "display:none");
	li.innerHTML=r.link;
	currentPageFavoriteID=r.favoriteid;
	mover.appendChild(li);
	new Insertion.Before($("favoriteList").childNodes[0], mover.innerHTML);
	new Effect.Fade($("favoriteTip"));
	new Effect.Appear($("favorite" + iid));
	
		
}

function showDeleteFavoriteResponse(originalRequest)
{
	//put returned XML in the textarea
	//$('favoriteStatus').innerHTML = originalRequest.responseText;
}

function deleteFavorite(favoriteID, id)
{
	var url = assetpath + '/includes/display_objects/favorites/ajax/deleteFavorite.cfm';
	//var pars = 'empID=' + empID + '&year=' + y;
	var pars = 'favoriteID=' + favoriteID + '&cacheid=' + Math.random();
	var myAjax = new Ajax.Request( url, { method: 'get', parameters: pars, onComplete: showDeleteFavoriteResponse });

	var menuItems = $(id).parentNode.getElementsByTagName('LI');	// Get an array of all favorite items
	menuLength = (menuItems.length - 1);
	if (menuLength == 0){
		new Effect.Appear($("favoriteTip"));
	}
	new Effect.Fade($(id));
	new Element.remove($(id));
	if (favoriteID == currentPageFavoriteID)
	{	
		currentPageFavoriteID='';
		new Effect.Appear($("addFavorite"));
	}
		
	return false;
}
