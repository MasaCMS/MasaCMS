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
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.configBean="">
<cfset variables.settingsManager="">
<cfset variables.pluginManager="">

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="configBean">
	<cfargument name="settingsManager">
	<cfargument name="pluginManager">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.pluginManager=arguments.pluginManager />
	
<cfreturn this />
</cffunction>

<cffunction name="displayObject" output="true" returntype="any">
<cfargument name="objectID">
<cfargument name="event">
<cfargument name="rsDisplayObject">
<cfargument name="$">
<cfargument name="mura">

	<cfset var rs=""/>
	<cfset var str=""/>
	<cfset var pluginConfig=""/>
	<cfset var tracePoint=0>
	
	<cfset request.pluginConfig=variables.pluginManager.getConfig(arguments.rsDisplayObject.pluginID)>
	<cfset request.pluginConfig.setSetting("pluginMode","object")/>
	<cfset request.scriptEvent=arguments.event />
	<cfset pluginConfig=request.pluginConfig/>
	
	<cfif arguments.rsDisplayObject.location eq "global">
		<cfset pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#pluginConfig.getDirectory()#/")/>
		<cfset tracePoint=initTracePoint("/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#")>
		<cfsavecontent variable="str">
		<cfinclude template="/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#">
		</cfsavecontent>
		<cfset commitTracePoint(tracePoint)>
	<cfelse>
		<cfset pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#pluginConfig.getDirectory()#/")/>
		<cfset tracePoint=initTracePoint("/#variables.configBean.getWebRootMap()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#")>
		<cfsavecontent variable="str">
		<cfinclude template="/#variables.configBean.getWebRootMap()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#">
		</cfsavecontent>
		<cfset commitTracePoint(tracePoint)>
	</cfif>
	
	<cfset structDelete(request,"pluginConfig")>
	<cfset structDelete(request,"scriptEvent")>
	
	<cfreturn trim(str) />
</cffunction>

<cffunction name="executeScript" output="false" returntype="any">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="scriptFile" required="true" default="" type="any">
<cfargument name="pluginConfig" required="true" default="" type="any">
<cfargument name="$">
<cfargument name="mura">
	<cfset var scriptEvent=arguments.event>
	<cfset var tracePoint=0>
	
	<cfset request.pluginConfig=arguments.pluginConfig/>
	<cfset request.scriptEvent=arguments.event/>
	<cfset tracePoint=initTracePoint(arguments.scriptFile)>
	<cfinclude template="#arguments.scriptFile#">
	<cfset commitTracePoint(tracePoint)>
	<cfset structDelete(request,"pluginConfig")>
	<cfset structDelete(request,"scriptEvent")>
	<cfreturn event/>

</cffunction>

<cffunction name="renderScript" output="true" returntype="any">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="scriptFile" required="true" default="" type="any">
<cfargument name="pluginConfig" required="true" default="" type="any">
<cfargument name="$">
<cfargument name="mura">
	<cfset var rs=""/>
	<cfset var str=""/>
	<cfset var tracePoint=0>
	<cfset var attributes=structNew()>
	
	<cfset request.pluginConfig=arguments.pluginConfig/>
	<cfset request.pluginConfig.setSetting("pluginMode","object")/>
	<cfset request.scriptEvent=arguments.event />
	<cfset pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#pluginConfig.getDirectory()#/")/>
	<cfset attributes=arguments.event.getAllValues()/>
	<cfset tracePoint=initTracePoint(arguments.scriptFile)>
	<cfsavecontent variable="str">
	<cfinclude template="#arguments.scriptFile#">
	</cfsavecontent>
	<cfset commitTracePoint(tracePoint)>
	<cfset structDelete(request,"pluginConfig")>
	<cfset structDelete(request,"scriptEvent")>
	
	<cfreturn trim(str) />
</cffunction>

</cfcomponent>