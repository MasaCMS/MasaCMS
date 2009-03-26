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
<cfparam name="attributes.nestLevel" default="1">
<cfset rslist=application.categoryManager.getCategories(attributes.siteID,attributes.ParentID) />
</cfsilent>
<cfif rslist.recordcount>
<ul class="categories">
<cfoutput query="rslist">
<li>
<cfif rslist.isOpen eq 1><input type="checkbox" name="categoryID" class="checkbox" <cfif listfind(attributes.extendSetBean.getCategoryID(),rslist.categoryID) or listfind(attributes.categoryID,rslist.CategoryID)>checked</cfif> value="#rslist.categoryID#"> </cfif>#rslist.name#
<cf_dsp_categories_nest siteID="#attributes.siteID#" parentID="#rslist.categoryID#" categoryID="#attributes.categoryID#" nestLevel="#evaluate(attributes.nestLevel +1)#" extendSetBean="#attributes.extendSetBean#">
</li>
</cfoutput>
</ul>
</cfif>
