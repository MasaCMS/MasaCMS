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

function loadUserActivity(siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cDashboard.loadUserActivity&siteID=' + siteID  + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = $('userActivityData');
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'userActivityData'}, url, {method: 'get', parameters: pars});
		return false;
	}
	
function loadPopularContent(siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cDashboard.loadPopularContent&siteID=' + siteID  + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = $('popularContentData');
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'popularContentData'}, url, {method: 'get', parameters: pars});
		return false;
	}
	
function loadFormActivity(siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cDashboard.loadFormActivity&siteID=' + siteID  + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = $('recentFormActivityData');
			d.innerHTML='<br/><img src="images/progress_bar.gif">';
		var myAjax = new Ajax.Updater({success: 'recentFormActivityData'}, url, {method: 'get', parameters: pars});
		return false;
	}
	
function loadEmailActivity(siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cDashboard.loadEmailActivity&siteID=' + siteID  + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = $('emailBroadcastsData');
			d.innerHTML='<div id="emailBroadcasts" class="separate"><h3>Email Broadcasts</h3><br/><img src="images/progress_bar.gif"></div>';
		var myAjax = new Ajax.Updater({success: 'emailBroadcastsData'}, url, {method: 'get', parameters: pars});
		return false;
	}
	