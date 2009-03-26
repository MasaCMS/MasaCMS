<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent displayname="StateBuilder" output="false" hint="I am the state builder.">

<cffunction name="init" returntype="any" output="false">
  <cfreturn this />
</cffunction>

<cffunction name="setFramework" returntype="void" output="false">
  <cfargument name="framework" type="any" required="true" />
  <cfset variables._framework = arguments.framework />
</cffunction>

<cffunction name="getConfigSetting" returntype="any" access="private" hint="I return a configuration setting.">
	<cfargument name="name" type="string" required="true" />
	<cfreturn variables._framework.getConfigSetting(arguments.name) />
</cffunction>

<cffunction name="createStateContainer" output="false">
	<cfargument name="collection" />
	
	<cfset var stateContainers = "" />
	<cfset var state = "" />
	<cfset var eventValueName = getConfigSetting("eventValue") />
	
	<!--- We need session for redirect forwarding and async requests --->
	<cfif variables._framework.getUseSession()>
		<cfparam name="session._modelglue" default="#structNew()#">
		<cfparam name="session._ModelGlue.asyncRequests" default="#structNew()#">
		<cfparam name="session._ModelGlue.forwardedStateContainer" default="#structNew()#">
	</cfif>

	<!--- Create our viewstate --->
	<cfset stateContainers = arrayNew(1) />
	<cfif variables._framework.getUseSession() and structCount(session._ModelGlue.forwardedStateContainer) and structKeyExists(url, eventValueName)>
		<cfset session._ModelGlue.forwardedStateContainer.setValue(eventValueName, url[eventValueName]) />
		<cfset arrayAppend(stateContainers, session._ModelGlue.forwardedStateContainer.getAll()) /> 
	</cfif>
	<cfif getConfigSetting("statePrecedence") eq "url">
		<cfset arrayAppend(stateContainers, url) />
		<cfset arrayAppend(stateContainers, form) />
	<cfelse>
		<cfset arrayAppend(stateContainers, form) />
		<cfset arrayAppend(stateContainers, url) />
	</cfif>
	
	<cfset state = arguments.collection.init(stateContainers) />

	<!--- Default event --->
	<cfif not len(state.getValue(eventValueName))>
		<cfset state.setValue(eventValueName, getConfigSetting("defaultEvent")) />
	</cfif>

	<!--- "Myself" --->
	<cfset state.setValue("self", getConfigSetting("defaultTemplate")) />
	<cfset state.setValue("eventValue", eventValueName) />
	<cfset state.setValue("myself", getConfigSetting("defaultTemplate") & "?" & eventValueName & "=") />
</cffunction>

<cffunction name="createRequestLog" output="false">
	<cfset var requestLog = "" />
	<cfset var orm = "" />
	
	<cfif variables._framework.getUseSession()>
		<cfparam name="session._ModelGlue.forwardedRequestLog" default="" />
	</cfif>
	
	<cfif not variables._framework.getUseSession() or not isObject(session._ModelGlue.forwardedRequestLog)>
		<cfset requestLog = variables._framework.createRequestLog().init() />
		<cfset requestLog.add(0, "Core", "This is Model-Glue version " & variables._framework.getVersion(), "", "OK") />
		
		<cfset orm = variables._framework.getUseORMAdapter() />
		
		<cfif orm.status>
			<cfset requestLog.add(0, "Core", "Using ORM Adapter: " & variables._framework.getORMAdapterName(), "", "OK") />
		<cfelse>
			<cfset requestLog.add(0, "Core", "Not using an ORM adapter.  You will not be able to do automatic database functions.<br /><br />Cause: #orm.detail#", "", "OK") />
		</cfif>
	<cfelse>
		<cfset requestLog = session._ModelGlue.forwardedRequestLog />
	</cfif>
	
	<cfreturn requestLog />
</cffunction>

</cfcomponent>