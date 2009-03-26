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

<cfsilent><cfparam name="attributes.siteID" default="">
<cfparam name="attributes.parentID" default="">
<cfparam name="attributes.groupID" default="">
<cfparam name="attributes.nestLevel" default="1">
<cfset rslist=application.categoryManager.getCategories(attributes.siteID,attributes.ParentID,"",true,true) />
</cfsilent>
<cfif rslist.recordcount><cfset request.hasCats=true>
<ul>
<cfoutput query="rslist">
<li>
<input type="checkbox" name="groupID" class="checkbox" <cfif listfind(attributes.groupID,rslist.categoryID)>checked</cfif> value="#rslist.categoryID#"> #rslist.name#
<cf_dsp_categories_nest siteID="#attributes.siteID#" groupid="#attributes.groupID#" parentID="#rslist.categoryID#" nestLevel="#evaluate(attributes.nestLevel +1)#" >
</li>
</cfoutput>
</ul>
</cfif>
