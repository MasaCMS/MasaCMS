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
	$.ajax({
		  type: "GET",
		  url: context + '/tasks/feed/readRSS.cfm',
		  data: 'rssURL=' + escape(dragableBoxesArray[numericId]['rssUrl']) + '&maxRssItems=' + dragableBoxesArray[numericId]['maxRssItems'] + '&siteid=' + siteID + '&cacheBuster=' + Math.random(),
		  success: function(transport){showRSSData(transport,numericId);}
		});	

}

function deleteRssFavorites(userID, siteID)
{
	if (userID != "")
	{
		
	$.ajax({
		   type: "GET",
		   url: context + '/tasks/favorites/deleteRSSFavorite.cfm',
		   data: 'userID=' + userID + '&siteid=' + siteID + "&cacheBuster=" + Math.random()
			  });
			
	} else {
		redirectToLogin();
	}
	return false;
}

function saveRssFavorite(userID, siteID, favoriteName, favoriteLocation, favoriteType, columnNumber, rowNumber, maxRssItems)
{
	if (userID != "")
	{

		$.ajax({
		  	type: "GET",
			 url: context + '/tasks/favorites/saveFavorite.cfm',
			 data: 'userID=' + userID + '&siteid=' + siteID + '&favoriteName=' + favoriteName + '&favoriteLocation=' + escape(favoriteLocation) + '&favoriteType=' + favoriteType + '&columnNumber=' + columnNumber + '&rowNumber=' + rowNumber + '&maxRssItems=' + maxRssItems + "&cacheBuster=" + Math.random()
			 });

	} else {
		redirectToLogin();
	}
	return false;
}