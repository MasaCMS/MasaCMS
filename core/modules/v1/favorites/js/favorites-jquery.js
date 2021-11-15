/* 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.
Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

*/


var currentPageFavoriteID = "";
var favoriteExists = false;

function effectFunction()
{
	$("#favoriteListMore").animate({opacity: 'toggle'});
	return false;

}

function saveFavorite(userID, siteID, favoriteName, favoriteLocation, favoriteType)
{
	//if (!favoriteExists){
		$("#addFavorite").fadeOut();
		//location.href= url + "?" + pars;

		$.ajax({
		   type: "GET",
		   url: Mura.corepath + '/modules/v1/favorites/ajax/saveFavorite.cfm',
		   data: 'userID=' + userID + '&siteid=' + siteID + '&favoriteName=' + favoriteName + '&favoriteLocation=' + favoriteLocation + '&favoriteType=' + favoriteType + '&cacheid=' + Math.random(),
		   success: showSaveFavoriteResponse
		   });
	//}
	return false;
}

function showSaveFavoriteResponse(originalRequest)
{
	var r = eval( '(' + originalRequest + ')' );
	var iid = r.lid;
	var mover=document.createElement("DIV");
	var li=document.createElement("LI");
	li.setAttribute("id","favorite" + iid);
	li.setAttribute("style", "display:none");
	li.innerHTML=r.link;
	currentPageFavoriteID=r.favoriteid;
	mover.appendChild(li);

	$("#favoriteList").prepend(mover.innerHTML);
	$("#favoriteTip").fadeOut();
	$("#favorite" + iid).fadeIn();

}

function showDeleteFavoriteResponse(originalRequest)
{
	//put returned XML in the textarea
	//$('favoriteStatus').innerHTML = originalRequest.responseText;
}

function deleteFavorite(favoriteID, id)
{
	$.ajax({
		  type: "GET",
		   url: Mura.corepath + '/modules/v1/favorites/ajax/deleteFavorite.cfm',
		   data: 'favoriteID=' + favoriteID  + '&cacheid=' + Math.random(),
		   });

	var menuItems = document.getElementById('favoriteList').parentNode.getElementsByTagName('LI');	// Get an array of all favorite items
	menuLength = (menuItems.length - 1);
	if (menuLength == 1){
		$("#favoriteTip").fadeIn();
	}
	$("#" +id).fadeOut();
	$("#" +id).remove();
	if (favoriteID == currentPageFavoriteID)
	{
		$("#addFavorite").fadeIn();
	}

	return false;
}
