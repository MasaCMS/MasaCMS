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
<cfparam name="attributes.contentid" default="">
<cfparam name="attributes.parentid" default="">
<cfparam name="attributes.contenthistid" default="">
<cfswitch expression="#attributes.classid#">
	<cfcase value="component">
		<cfinclude template="objectclass/dsp_components.cfm">
	</cfcase>
	<cfcase value="mailingList">
		<cfinclude template="objectclass/dsp_mailinglists.cfm">
	</cfcase>
	<cfcase value="system">
		<cfinclude template="objectclass/dsp_system.cfm">
	</cfcase>
	<cfcase value="form">
		<cfinclude template="objectclass/dsp_forms.cfm">
	</cfcase>
	<cfcase value="adzone">
		<cfinclude template="objectclass/dsp_adzones.cfm">
	</cfcase>
	<cfcase value="portal">
		<cfinclude template="objectclass/dsp_portals.cfm">
	</cfcase>
	<cfcase value="calendar">
		<cfinclude template="objectclass/dsp_calendars.cfm">
	</cfcase>
	<cfcase value="gallery">
		<cfinclude template="objectclass/dsp_galleries.cfm">
	</cfcase>
	<cfcase value="localFeed">
		<cfinclude template="objectclass/dsp_localfeeds.cfm">
	</cfcase>
	<cfcase value="slideshow">
		<cfinclude template="objectclass/dsp_slideshows.cfm">
	</cfcase>
	<cfcase value="remoteFeed">
		<cfinclude template="objectclass/dsp_remotefeeds.cfm">
	</cfcase>
	<cfcase value="plugins">
		<cfinclude template="objectclass/dsp_plugins.cfm">
	</cfcase>
</cfswitch>

<cfif fileExists("#application.configBean.getWebRoot()##application.configBean.getFileDelim()##attributes.siteid##application.configBean.getFileDelim()#includes#application.configBean.getFileDelim()#display_objects#application.configBean.getFileDelim()#custom#application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#dsp_objectClass.cfm")>
	<cfinclude template="/#application.configBean.getWebRootMap()#/#attributes.siteID#/includes/display_objects/custom/admin/dsp_objectClass.cfm">
</cfif>