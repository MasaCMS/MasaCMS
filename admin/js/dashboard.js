/* This file is part of Mura CMS. 

	Mura CMS is free software: you can redistribute it and/or modify 
	it under the terms of the GNU General Public License as published by 
	the Free Software Foundation, Version 2 of the License. 

	Mura CMS is distributed in the hope that it will be useful, 
	but WITHOUT ANY WARRANTY; without even the implied warranty of 
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
	GNU General Public License for more details. 

	You should have received a copy of the GNU General Public License 
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. 

	However, as a special exception, the copyright holders of Mura CMS grant you permission 
	to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1. 

	In addition, as a special exception,  the copyright holders of Mura CMS grant you permission 
	to combine Mura CMS  with independent software modules that communicate with Mura CMS solely 
	through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API, 
	provided that these modules (a) may only modify the  /plugins/ directory through the Mura CMS 
	plugin installation API, (b) must not alter any default objects in the Mura CMS database 
	and (c) must not alter any files in the following directories except in cases where the code contains 
	a separately distributed license.

	/admin/ 
	/tasks/ 
	/config/ 
	/requirements/mura/ 

	You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include  
	the source code of that other code when and as the GNU GPL requires distribution of source code. 

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception 
	for your modified version; it is your choice whether to do so, or to make such modified version available under 
	the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception 
	to your own modified versions of Mura CMS. */

function loadUserActivity(siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cDashboard.loadUserActivity&siteID=' + siteID  + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = jQuery('#userActivityData');
			d.html('<img class="loadProgress" src="images/progress_bar.gif">');
			jQuery.get(url + "?" + pars, 
					function(data) {
					d.html(data).animate({'opacity':'hide'},1000,null,
							function(){
								d.animate({'opacity':'show'},1000);
							});
					}
			);
		return false;
	}
	
function loadPopularContent(siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cDashboard.loadPopularContent&siteID=' + siteID  + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = jQuery('#popularContentData');
			d.html('<img class="loadProgress" src="images/progress_bar.gif">');
			jQuery.get(url + "?" + pars, 
					function(data) {
					d.html(data).animate({'opacity':'hide'},1000,null,
							function(){
								d.animate({'opacity':'show'},1000);
							});
					}
			);
		return false;
	}

function loadRecentComments(siteID)	{
	var url = 'index.cfm';
	var pars = 'fuseaction=cDashboard.loadRecentComments&siteID=' + siteID  + '&cacheid=' + Math.random();
	
	//location.href=url + "?" + pars;
	var d = jQuery('#recentCommentsData');
		d.html('<img class="loadProgress" src="images/progress_bar.gif">');
		jQuery.get(url + "?" + pars, 
				function(data) {
				d.html(data).animate({'opacity':'hide'},1000,null,
						function(){
							d.animate({'opacity':'show'},1000);
						});
				}
		);
	return false;
}

	
function loadFormActivity(siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cDashboard.loadFormActivity&siteID=' + siteID  + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = jQuery('#recentFormActivityData');
			d.html('<img class="loadProgress" src="images/progress_bar.gif">');
			jQuery.get(url + "?" + pars, 
					function(data) {
					d.html(data).animate({'opacity':'hide'},1000,null,
							function(){
								d.animate({'opacity':'show'},1000);
							});
					}
			);
		return false;
	}
	
function loadEmailActivity(siteID)	{
		var url = 'index.cfm';
		var pars = 'fuseaction=cDashboard.loadEmailActivity&siteID=' + siteID  + '&cacheid=' + Math.random();
		
		//location.href=url + "?" + pars;
		var d = jQuery('#emailBroadcastsData');
			d.html('<div id="emailBroadcasts" class="separate"><h3>Email Broadcasts</h3><img class="loadProgress" src="images/progress_bar.gif"></div>');
			jQuery.get(url + "?" + pars, 
					function(data) {
					d.html(data).animate({'opacity':'hide'},1000,null,
							function(){
								d.animate({'opacity':'show'},1000);
							});
					}
			);
		return false;
	}
	