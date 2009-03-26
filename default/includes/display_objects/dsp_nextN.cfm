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

<cfsilent>
<cfparam name="request.sortBy" default=""/>
<cfparam name="request.sortDirection" default=""/>
<cfparam name="request.day" default="0"/>
<cfparam name="request.filterBy" default=""/>
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
<cfif isNumeric(request.day) and request.day>
	<cfset qrystr=qrystr & "&month=#request.month#&year=#request.year#&day=#request.day#">
</cfif>
<cfif len(request.filterBy)>
<cfif isNumeric(request.day) and request.day>
	<cfset qrystr=qrystr & "&month=#request.month#&year=#request.year#&day=#request.day#&filterBy=#request.filterBy#">
</cfif>
</cfif>
</cfsilent>
<cfoutput>
<dl class="moreResults">
	<dt>#rbFactory.getKey('list.moreresults')#:</dt> 
	<dd>
		<ul>
		<cfif nextN.currentpagenumber gt 1>
		<li><a href="#xmlFormat('#application.configBean.getIndexFile()#?startrow=#nextN.previous##qrystr#')#">&laquo;&nbsp;#rbFactory.getKey('list.previous')#</a></li>
		</cfif>
		<cfloop from="#nextN.firstPage#"  to="#nextN.lastPage#" index="i"><cfif nextn.currentpagenumber eq i><li class="current">#i#</li><cfelse><li><a href="#xmlFormat('#application.configBean.getIndexFile()#?startrow=#evaluate('(#i#*#nextN.recordsperpage#)-#nextN.recordsperpage#+1')##qrystr#')#">#i#</a></li></cfif></cfloop>
		<cfif nextN.currentpagenumber lt nextN.NumberOfPages>
			<li><a href="#xmlFormat('#application.configBean.getIndexFile()#?startrow=#nextN.next##qrystr#')#">#rbFactory.getKey('list.next')#&nbsp;&raquo;</a></li>
		</cfif>
		</ul>
	</dd>
</dl>
</cfoutput>