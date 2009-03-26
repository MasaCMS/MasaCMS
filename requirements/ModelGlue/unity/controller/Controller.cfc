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


<cfcomponent displayName="Controller" output="false" hint="I am the base for any Model-Glue controllers.">
	<cffunction name="Init" access="public" returnType="any" output="false" hint="I return a new Controller.">
	  <cfargument name="ModelGlue" type="ModelGlue.unity.framework.ModelGlue" required="true" hint="I am an instance of ModelGlue.">
	  <cfargument name="name" type="string" required="false" hint="A name for this controller." default="#createUUID()#">

	  <cfset variables.ModelGlue = structNew() />
	  <cfset variables.ModelGlue.framework = arguments.ModelGlue />
	  <cfset variables.name = arguments.name />

		<cftry>
		  <cfset variables.ModelGlue.ModelGlueCache = createObject("component", "ModelGlue.Util.TimedCache").init(createTimespan(0,0,GetModelGlue().GetConfigSetting("defaultCacheTimeout"),0)) />
			<cfcatch>
			  <cfset variables.ModelGlue.ModelGlueCache = createObject("component", "ModelGlue.Util.TimedCache").init(createTimespan(0,0,0,0)) />
			</cfcatch>
		</cftry>
		
	  <cfreturn this />
	</cffunction>


	<cffunction name="SetName" access="public" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
	</cffunction>
	<cffunction name="GetName" access="public" returntype="string" output="false">
		<cfreturn variables.name />
	</cffunction>

	<cffunction name="SetModelGlue" access="public" returntype="void" output="false">
		<cfargument name="ModelGlue" type="ModelGlue.unity.framework.ModelGlue" required="true" />
		<cfset variables.ModelGlue.framework = arguments.ModelGlue />
	</cffunction>
	<cffunction name="GetModelGlue" access="public" returnType="ModelGlue.unity.framework.ModelGlue" output="false" hint="I get the instance of ModelGlue this controller is registered with.">
	  <cfreturn variables.ModelGlue.framework>
	</cffunction>

	<cffunction name="AddToCache" access="public" returnType="void" output="false">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
    <cfargument name="value" type="any" required="true" hint="I am the value.">
    <cfargument name="timeout" type="numeric" required="false" hint="I am the [optional] timespan for which this value should be cached." />

		<cfif structKeyExists(arguments, "timeout")>
			<cfset variables.ModelGlue.ModelGlueCache.setValue(arguments.name, arguments.value, arguments.timeout) />
		<cfelse>
			<cfset variables.ModelGlue.ModelGlueCache.setValue(arguments.name, arguments.value) />
		</cfif>
	</cffunction>

	<cffunction name="ExistsInCache" access="public" returnType="boolean" output="false">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">

		<cfreturn variables.ModelGlue.ModelGlueCache.exists(arguments.name) />
	</cffunction>

	<cffunction name="GetFromCache" access="public" returnType="any" output="false">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">

		<cfreturn variables.ModelGlue.ModelGlueCache.getValue(arguments.name) />
	</cffunction>

	<cffunction name="RemoveFromCache" access="public" returnType="boolean" output="false">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">

		<cfreturn variables.ModelGlue.ModelGlueCache.removeValue(arguments.name) />
	</cffunction>
	
	<!---
	<cffunction name="CreateConfigBean" access="public" output="false" hint="I get a configuration bean based on a file in one of the directories listed in the BeanMappings setting.">
	  <cfargument name="filename" type="string" required="true" hint="The filename of the bean.">
	  <cfreturn GetModelGlue().getConfigBean(arguments.filename) />
	</cffunction>

	<cffunction name="CreateSingleton" access="public" output="false" hint="I get a configuration bean based on a file in one of the directories listed in the BeanMappings setting.">
		<cfargument name="type" type="string" required="true" hint="Type of object to create." />
		<cfargument name="name" type="string" required="true" hint="Component name, object name, web service WSDL, etc." />
	  <cfreturn GetModelGlue().getSingleton(arguments.type, arguments.name) />
	</cffunction>
	--->
	
	<cffunction name="OnRequestStart" access="public" returnType="void" output="false">
	  <cfargument name="event">
	</cffunction>

	<cffunction name="OnQueueComplete" access="public" returnType="void" output="false">
	  <cfargument name="event">
	</cffunction>

	<cffunction name="OnRequestEnd" access="public" returnType="void" output="false">
	  <cfargument name="event">
	</cffunction>
</cfcomponent>