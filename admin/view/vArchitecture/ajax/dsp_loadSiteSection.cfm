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
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
<cfparam name="session.openSectionList" default="">
<cfparam name="attributes.sorted" default="false" />

<cfset sectionFound=listFind(session.openSectionList,attributes.contentID)>

<cfif not sectionFound>

<cfset data=structNew()>

<cfif not isDefined("attributes.sortby") or attributes.sortby eq "">
	<cfset attributes.sortBy=request.rstop.sortBy>
</cfif>

<cfif not isDefined("attributes.sortdirection") or attributes.sortdirection eq "">
	<cfset attributes.sortdirection=request.rstop.sortdirection>
</cfif>

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
