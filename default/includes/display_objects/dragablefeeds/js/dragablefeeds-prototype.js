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


function reloadRSSData(numericId)
{
		var pars = 'rssURL=' + escape(dragableBoxesArray[numericId]['rssUrl']) + '&maxRssItems=' + dragableBoxesArray[numericId]['maxRssItems'] + '&siteid=' + siteID + '&cacheBuster=' + Math.random();
		var myAjax = new Ajax.Request(context + '/tasks/feed/readRSS.cfm', { method: 'get', parameters: pars, onComplete: function(transport){showRSSData(transport,numericId);}});	

}

function deleteRssFavorites(userID, siteID)
{
	if (userID != "")
	{

		var url = context + '/tasks/favorites/deleteRSSFavorite.cfm';
		var pars = 'userID=' + userID + '&siteid=' + siteID + "&cacheBuster=" + Math.random();
		//window.location=url + '?' + pars;
		var myAjax = new Ajax.Request( url, { method: 'get', parameters: pars });
	
	} else {
		redirectToLogin();
	}
	return false;
}

function saveRssFavorite(userID, siteID, favoriteName, favoriteLocation, favoriteType, columnNumber, rowNumber, maxRssItems)
{
	if (userID != "")
	{
		var url = context + '/tasks/favorites/saveFavorite.cfm';
		var pars = 'userID=' + userID + '&siteid=' + siteID + '&favoriteName=' + favoriteName + '&favoriteLocation=' + escape(favoriteLocation) + '&favoriteType=' + favoriteType + '&columnNumber=' + columnNumber + '&rowNumber=' + rowNumber + '&maxRssItems=' + maxRssItems + "&cacheBuster=" + Math.random();
		//location.href=url + "?" + pars;
		var myAjax = new Ajax.Request( url, { method: 'get', parameters: pars });

	} else {
		redirectToLogin();
	}
	return false;
}