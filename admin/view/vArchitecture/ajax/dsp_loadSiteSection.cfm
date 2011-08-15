<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
<cfparam name="session.openSectionList" default="">

<cfset sectionFound=listFind(session.openSectionList,attributes.contentID)>

<cfif not sectionFound>

<cfset data=structNew()>

<cfif not isDefined("attributes.sortby") or attributes.sortby eq "">
	<cfset attributes.sortBy=request.rstop.sortBy>
</cfif>

<cfif not isDefined("attributes.sortdirection") or attributes.sortdirection eq "">
	<cfset attributes.sortdirection=request.rstop.sortdirection>
</cfif>
<cfparam name="attributes.sorted" default="false" />

<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>	
<cfset request.rowNum=0>
<cfset request.menulist=attributes.contentID>
<cfset crumbdata=application.contentManager.getCrumbList(attributes.contentID,attributes.siteid)>
<cfset perm=application.permUtility.getnodePerm(crumbdata)>
<cfset r=application.permUtility.setRestriction(crumbdata).restrict>
<cfset rsNext=application.contentManager.getNest(attributes.contentID,attributes.siteid,attributes.sortBy,attributes.sortDirection)>

<cfset session.openSectionList=listAppend(session.openSectionList,attributes.contentID)>

<cfsavecontent variable="data.html">
<cf_dsp_nest topid="#attributes.contentID#" parentid="#attributes.contentID#"  rsnest="#rsNext#" locking="#application.settingsManager.getSite(attributes.siteid).getlocking()#" nestlevel="1" perm="#perm#" siteid="#attributes.siteid#" moduleid="#attributes.moduleid#" restricted="#r#" viewdepth="1" nextn="#session.mura.nextN#" startrow="#attributes.startrow#" sortBy="#attributes.sortBy#" sortDirection="#attributes.sortDirection#" pluginEvent="#pluginEvent#" isSectionRequest="true">
</cfsavecontent>

<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>

<cfelse>
	<cfset session.openSectionList=listDeleteAt(session.openSectionList,sectionFound)>
</cfif>