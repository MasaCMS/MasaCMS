<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfparam name="useRss" default="false">
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#request.siteid#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1</cfquery>
<cfif rsSection.recordcount>
<cfsilent>
<cfif rsSection.type neq "Calendar">
<cfset today=now() />
<cfelse>
<cfset today=createDate(request.year,request.month,1) />
</cfif>
<cfset rs=application.contentGateway.getKidsCategorySummary(request.siteid,arguments.objectid,request.relatedID,today,rsSection.type)>
</cfsilent>
<cfif rs.recordcount>
<cfoutput>
<div id="catSummary">
<h3>Categories</h3>
<ul class="navSecondary"><cfloop query="rs">
	<cfset class=iif(rs.currentrow eq 1,de('first'),de(''))>
		<li class="#class# <cfif listFind(request.categoryID,rs.categoryID)>current</cfif>"><a href="#application.configBean.getContext()##getURLStem(request.siteid,rsSection.filename)#?categoryID=#rs.categoryID#&relatedID=#request.relatedID#">#rs.name# (#rs.count#)</a><cfif useRss><a  class="rssFeed" target="_blank" href="#application.configBean.getContext()#/tasks/feed/index.cfm?siteid=#request.siteid#&contentID=#rsSection.contentid#&categoryID=#rs.categoryID#" <cfif listFind(request.categoryID,rs.categoryID)>class=current</cfif>>RSS</a></cfif></li>
	</cfloop><li class="last"><a href="#application.configBean.getContext()##getURLStem(request.siteid,rsSection.filename)#?relatedID=#request.relatedID#">View All</a><cfif useRss><a class="rssFeed" target="_blank" href="#application.configBean.getContext()#/tasks/feed/index.cfm?siteid=#request.siteid#&contentID=#rsSection.contentid#">RSS</a></cfif></li>
</ul>
</div>
</cfoutput>
</cfif></cfif>