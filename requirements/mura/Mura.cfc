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
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent output="false" extends="mura.cfobject">

<cffunction name="doRequest" output="false" returntype="any">
<cfargument name="event">
	<cfset var response=""/>
	<cfset var servlet = "" />
	<cfset var localHandler=""/>
	<cfset var previewData=""/>
	<cfset var trace=""/>
	<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()#/#event.getValue('siteid')#/includes/servlet.cfc"))>
		<cfset servlet=createObject("component","#application.configBean.getWebRootMap()#.#event.getValue('siteid')#.includes.servlet").init(event)>
	<cfelse>
		<cfset servlet=createObject("component","mura.servlet").init(event)>
	</cfif>
	
	<cfset request.muraFrontEndRequest=true>

	<cfif structKeyExists(url,"changesetID")>
		<cfset application.changesetManager.setSessionPreviewData(url.changesetID)>
	</cfif>
	
	<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
	<cfset request.muraChangesetPreview=isStruct(previewData) and previewData.siteID eq arguments.event.getValue("siteID") and len(previewData.contentIDList)>
	
	<cfif request.muraChangesetPreview>
		<cfset request.nocache=1>
	</cfif>
	
	<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()#") & "/#event.getValue('siteid')#/includes/eventHandler.cfc")>
		<cfset localHandler=createObject("component","#application.configBean.getWebRootMap()#.#event.getValue('siteid')#.includes.eventHandler").init()>
		<cfset localHandler._objectName=getMetaData(localHandler).name>
	</cfif>

	<cfset event.setValue("localHandler",localHandler)/>
	
	<cfset application.pluginManager.announceEvent('onSiteRequestStart',event)/>
	<cfset servlet.onRequestStart() />
	<cfset response=servlet.doRequest()>
	<cfset servlet.onRequestEnd() />
	<cfset application.pluginManager.announceEvent('onSiteRequestEnd',event)/>
	<cfif session.mura.showTrace and listFindNoCase(session.mura.memberships,"S2IsPrivate")>
		<cfset response=replaceNoCase(response,"</html>","#application.utility.dumpTrace()#</html>")>
	</cfif>
	<cfreturn response>
</cffunction>


</cfcomponent>