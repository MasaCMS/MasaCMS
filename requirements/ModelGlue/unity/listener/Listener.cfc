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


<cfcomponent displayname="Listener" hint="I define a listener for a message broadcast." output="false">

<cffunction name="init" returntype="ModelGlue.unity.listener.Listener" access="public" output="false">
	<cfargument name="target" type="any" required="true" />
	<cfargument name="method" type="string" required="true" />
	<cfargument name="async" type="boolean" required="true" />
	
	<cfset variables._target = arguments.target />
	<cfset variables._method = arguments.method />
	<cfset variables._async = arguments.async />
	<cfreturn this />
</cffunction>

<cffunction name="invokeListener" returntype="void" access="public" output="false">
	<cfargument name="messageName" />
	<cfargument name="parameters" />

	<cfset var eventContext = parameters.event />
	<cfset var future = "" />
	<cfset var async = "" />
	
	
	<cfif structKeyExists(variables._target, variables._method)>
		<cfif not variables._async>
	    <cfset eventContext.trace("Message-Listener", "Invoking function ""#variables._method#"" in the controller named ""#variables._target.getName()#""" , "&lt;message-listener message=""#arguments.messageName#"" function=""#variables._method#"" /&gt;", "OK") />
			<cfinvoke component="#variables._target#" method="#variables._method#" argumentcollection="#arguments.parameters#" />
		<cfelse>
	    <cfset eventContext.trace("Message-Listener", "Asynchronously invoking function ""#variables._method#""", "", "OK") />
	    <cfset eventContext.getEventRequest().setInvokedAsyncListeners(true) />
			<cfset future = createObject("component","Concurrency.FutureTask").init(task=variables._target, method=variables._method, event=eventContext)>
			<cfset async = createObject("component", "ModelGlue.unity.async.AsyncRequest").init(future, eventContext) />
			<cfset eventContext.getModelGlue().addAsyncRequest(arguments.messagename, async) />
			<cfset future.run()>
		</cfif>
	<cfelse>
		<cfset eventContext.trace("Listener Function Undefined", "The function ""<strong>#variables._method#</strong>"" can't be found in the controller #getMetaData(variables._target).name# (#getMetaData(variables._target).path#).  A common cause of this is mispelling the function name in the &lt;message-listener&gt; tag.", "&lt;message-listener message=""#arguments.messageName#"" function=""#variables._method#"" /&gt;", "WARNING") />
	</cfif>
</cffunction>

</cfcomponent>