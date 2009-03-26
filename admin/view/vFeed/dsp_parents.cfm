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
<cfparam name="attributes.categoryID" default="">
<cfparam name="attributes.actualParentID" default="">
<cfparam name="attributes.nestLevel" default="0">
<cfset rslist=application.categoryManager.getCategories(attributes.siteID,attributes.ParentID) />
</cfsilent>
<cfif rslist.recordcount>
<cfoutput query="rslist">
 <cfif rslist.categoryID neq attributes.categoryID>
<option value="#rslist.categoryID#" <cfif rslist.categoryID eq attributes.actualParentID>selected</cfif>><cfif attributes.nestlevel><cfloop  from="1" to="#attributes.NestLevel#" index="I">&nbsp;&nbsp;</cfloop></cfif>#rslist.name#</option>
<cf_dsp_parents siteID="#attributes.siteID#" categoryID="#attributes.categoryID#" parentID="#rslist.categoryID#" actualParentID="#attributes.actualParentID#" nestLevel="#evaluate(attributes.nestLevel +1)#" >
 </cfif>
</cfoutput>
</cfif>
