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
<cfparam name="local" default="#structNew()#">
<cfif isDefined("arguments.ApplicationScope")>
	<cfparam name="request.muraFrontEndRequest" default="false"/>
	<cfparam name="request.muraChangesetPreview" default="false"/>
	<cfparam name="request.muraChangesetPreviewToolbar" default="false"/>
	<cfparam name="request.muraExportHtml" default="false"/>
	<cfparam name="request.muraMobileRequest" default="false"/>
	<cfparam name="request.muraMobileTemplate" default="false"/>
	<cfparam name="request.muraHandledEvents" default="#structNew()#"/>
	<cfparam name="request.altTHeme" default=""/>
	<cfparam name="request.customMuraScopeKeys" default="#structNew()#"/>
	<cfparam name="request.muraTraceRoute" default="#arrayNew(1)#"/>
	<cfparam name="request.muraRequestStart" default="#getTickCount()#"/>
	<cfparam name="request.muraShowTrace" default="true"/>
	<cfparam name="request.muraValidateDomain" default="true"/>
	<cfparam name="request.muraAppreloaded" default="false"/>
	<cfparam name="request.muratransaction" default="0"/>
	<cfparam name="request.muraDynamicContentError" default="false">
	<cfparam name="request.muraPreviewDomain" default="">
	<cfparam name="request.muraOutputCacheOffset" default="">

	<cfset session=arguments.SessionScope>
	<cfset application=arguments.ApplicationScope>
	<cftry>
		<cfset local.pluginEvent=createObject("component","mura.event").init()>
		<cfset local.pluginEvent.setValue("ApplicationScope",arguments.ApplicationScope)>	 
		<cfset local.pluginEvent.setValue("SessionScope",arguments.SessionScope)>

		<cfif structKeyExists(arguments.SessionScope,"mura") and len(arguments.SessionScope.mura.siteid)>
			<cfset local.pluginEvent.setValue("siteid",arguments.SessionScope.siteid)>
			<cfset arguments.ApplicationScope.pluginManager.announceEvent("onSiteSessionEnd",local.pluginEvent)>
		<cfelse>
			<cfset arguments.ApplicationScope.pluginManager.announceEvent("onGlobalSessionEnd",local.pluginEvent)>
		</cfif>
	<cfcatch></cfcatch>
	</cftry>	
</cfif>

