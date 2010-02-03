<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsilent>
<cfparam name="request.sortBy" default=""/>
<cfparam name="request.sortDirection" default=""/>
<cfparam name="request.day" default="0"/>
<cfparam name="request.pageNum" default="1"/>
<cfparam name="request.startRow" default="1"/>
<cfparam name="request.filterBy" default=""/>
<cfparam name="request.currentNextNID" default=""/>
<cfif nextN.recordsPerPage gt 1>
<cfset paginationKey="startRow">
<cfelse>
<cfset paginationKey="pageNum">
</cfif>
<cfset qrystr="" />
<cfset rbFactory=getSite().getRBFactory() />
<cfif len(request.sortBy)>
	<cfset qrystr="&sortBy=#request.sortBy#&sortDirection=#request.sortDirection#"/>
</cfif>
<cfif len(request.categoryID)>
	<cfset qrystr=qrystr & "&categoryID=#request.categoryID#"/>
</cfif>
<cfif len(request.relatedID)>
	<cfset qrystr=qrystr & "&relatedID=#request.relatedID#"/>
</cfif>
<cfif len(request.currentNextNID)>
	<cfset qrystr=qrystr & "&nextNID=#request.currentNextNID#"/>
</cfif>
<cfif len(request.filterBy)>
<cfif isNumeric(request.day) and request.day>
	<cfset qrystr=qrystr & "&month=#request.month#&year=#request.year#&day=#request.day#&filterBy=#request.filterBy#">
</cfif>
<cfelse>
<cfif isNumeric(request.day) and request.day>
	<cfset qrystr=qrystr & "&month=#request.month#&year=#request.year#&day=#request.day#">
</cfif>
</cfif>
</cfsilent>
<cfoutput>
<dl class="moreResults">
	<cfif nextN.recordsPerPage gt 1><dt>#rbFactory.getKey('list.moreresults')#:</dt></cfif>
	<dd>
		<ul>
		<cfif nextN.currentpagenumber gt 1>
		<li class="navPrev"><a href="#xmlFormat('?#paginationKey#=#nextN.previous##qrystr#')#">&laquo;&nbsp;#rbFactory.getKey('list.previous')#</a></li>
		</cfif>
		<cfloop from="#nextN.firstPage#"  to="#nextN.lastPage#" index="i"><cfif nextn.currentpagenumber eq i><li class="current">#i#</li><cfelse><li><a href="#xmlFormat('?#paginationKey#=#evaluate('(#i#*#nextN.recordsperpage#)-#nextN.recordsperpage#+1')##qrystr#')#">#i#</a></li></cfif></cfloop>
		<cfif nextN.currentpagenumber lt nextN.NumberOfPages>
			<li class="navNext"><a href="#xmlFormat('?#paginationKey#=#nextN.next##qrystr#')#">#rbFactory.getKey('list.next')#&nbsp;&raquo;</a></li>
		</cfif>
		</ul>
	</dd>
</dl>
</cfoutput>