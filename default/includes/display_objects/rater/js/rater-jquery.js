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

function saveRate(id){
	
	var frm=document.getElementById(id);
	$.post(
		   mura.assetpath + "/includes/display_objects/rater/ajax/saveRate.cfm",
		   {contentID: frm.contentID.value, siteID: frm.siteID.value, userID: frm.userID.value, rate:frm.rate.value},
		   function(data){showRatingResponse(data);}
		   );
}
