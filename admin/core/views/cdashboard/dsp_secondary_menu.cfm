<!--- 
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
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfoutput>
<cfset rc.originalfuseaction=listLast(request.action,".")>

<div class="nav-module-specific btn-group">
<!---
<a class="btn<cfif rc.originalfuseaction eq 'main'> active</cfif>" href="./?muraAction=cDashboard.main&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.overview")#</a>
--->
<cfif application.configBean.getSessionHistory()>
	<div class="btn-group">
	  <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
	    #application.rbFactory.getKeyValue(session.rb,"dashboard.siteactivity")#
	    <span class="caret"></span>
	  </a>
	  <ul class="dropdown-menu">
	   	<li><a class="<cfif rc.originalfuseaction eq 'sessionsearch'> active</cfif>" href="./?muraAction=cDashboard.sessionSearch&siteID=#session.siteid#&newSearch=true">#application.rbFactory.getKeyValue(session.rb,"dashboard.sessionsearch")#</a></li>
		<li><a class="<cfif rc.originalfuseaction eq 'topcontent'> active</cfif>"  href="./?muraAction=cDashboard.topContent&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.topcontent")#</a></li>
		<li><a class="<cfif rc.originalfuseaction eq 'topreferers'> active</cfif>"  href="./?muraAction=cDashboard.topReferers&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.topreferrers")#</a></li>
		<li><a class="<cfif rc.originalfuseaction eq 'topsearches'> active</cfif>"  href="./?muraAction=cDashboard.topSearches&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.topsearches")#</a></li>
		<li><a class="<cfif rc.originalfuseaction eq 'toprated'> active</cfif>"  href="./?muraAction=cDashboard.topRated&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.toprated")#</a></li>
		<!---
		<li><a class="<cfif rc.originalfuseaction eq 'recentcomments'> active</cfif>"  href="./?muraAction=cComments.default&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.comments")#</a></li>
		--->
	  </ul>
	</div>
<cfelse>
	<a class="btn <cfif rc.originalfuseaction eq 'toprated'> active</cfif>"  href="./?muraAction=cDashboard.topRated&siteID=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"dashboard.toprated")#</a>
</cfif>

<cfset draftCount=$.getBean('contentManager').getMyDraftsCount(siteid=session.siteid,startdate=dateAdd('m',-3,now()))>
<a class="btn"  href="./?muraAction=cArch.list&moduleid=00000000000000000000000000000000000&activeTab=1&report=mydrafts&siteID=#session.siteid#&reportSortby=lastupdate&reportSortDirection=desc&refreshFlatview=true">#application.rbFactory.getKeyValue(session.rb,"dashboard.mydrafts")#<cfif draftCount> <span class="badge badge-important">#draftCount#</span></cfif></a>

<cfset draftCount=$.getBean('contentManager').getMySubmissionsCount(session.siteid)>
<a class="btn"  href="./?muraAction=cArch.list&moduleid=00000000000000000000000000000000000&activeTab=1&report=mysubmissions&siteID=#session.siteid#&reportSortby=duedate&reportSortDirection=desc&refreshFlatview=true">#application.rbFactory.getKeyValue(session.rb,"dashboard.mysubmissions")#<cfif draftCount> <span class="badge badge-important">#draftCount#</span></cfif></a>

<cfset draftCount=$.getBean('contentManager').getMyApprovalsCount(session.siteid)>
<a class="btn"  href="./?muraAction=cArch.list&moduleid=00000000000000000000000000000000000&activeTab=1&report=myapprovals&siteID=#session.siteid#&reportSortby=duedate&reportSortDirection=desc&refreshFlatview=true">#application.rbFactory.getKeyValue(session.rb,"dashboard.myapprovals")#<cfif draftCount> <span class="badge badge-important">#draftCount#</span></cfif></a>

<cfif $.siteConfig('hasChangesets')
	and application.permUtility.getModulePerm('00000000000000000000000000000000014',rc.siteid) 
	and application.permUtility.getModulePerm('00000000000000000000000000000000000',rc.siteid)>

	<cfset rsChangesets=application.changesetManager.getQuery(siteID=$.event('siteID'),published=0,sortby="PublishDate")>
	
	<cfset queryAddColumn(rsChangesets, "pending", 'integer', [])>

	<cfloop query="rsChangesets">
		<cfset querySetCell(rsChangesets, "pending", $.getBean('changesetManager').hasPendingApprovals(rsChangesets.changesetid), rsChangesets.currentrow)>
	</cfloop>

	<cfquery name="totalpending" dbtype="query">
		select sum(pending) as totalpending from rsChangesets
	</cfquery>

	<cfif rsChangesets.recordcount>	
		<div class="btn-group">
		  <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
		    #application.rbFactory.getKeyValue(session.rb,"dashboard.pendingchangesets")
		    #<cfif totalpending.totalpending> <span class="badge badge-important">#totalpending.totalpending#</span></cfif>
		    <span class="caret"></span>
		  </a>
		  <ul class="dropdown-menu">
		   	<cfloop query="rsChangesets">
				<li>
					<a href="./?muraAction=cChangesets.assignments&changesetID=#rsChangesets.changesetID#&siteid=#session.siteid#">
						#esapiEncode('html',rsChangesets.name)#
						<cfif isDate(rsChangesets.publishDate)> (#LSDateFormat(rsChangesets.publishDate,session.dateKeyFormat)#)</cfif><cfif rsChangesets.pending> <span class="badge badge-important">#rsChangesets.pending#</span></cfif>
					</a>
				</li>
			</cfloop>
		  </ul>
		</div>
	</cfif>
</cfif>

</div>
</cfoutput>
