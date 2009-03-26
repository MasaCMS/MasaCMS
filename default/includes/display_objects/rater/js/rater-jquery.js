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
		   context + "/" + siteid + "/includes/display_objects/rater/ajax/saveRate.cfm",
		   {contentID: frm.contentID.value, siteID: frm.siteID.value, userID: frm.userID.value, rate:frm.rate.value},
		   function(data){showRatingResponse(data);}
		   );
}

function showRatingResponse(resp)
{
	var r= eval( '(' + resp + ')' );
	$("#numvotes").html(r.data.THECOUNT + String(" vote").pluralize(r.data.THECOUNT));
	$("#ratestars").src=starImg(r.data.THEAVG);
	$("#ratestars").alt=r.data.THEAVG + " stars";

	return false;
}