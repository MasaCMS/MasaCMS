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


<cfcomponent displayname="MessageBroadcaster" output="false">

<cffunction name="init" returntype="any" output="false">
	<cfargument name="listenerRegistry" />
	<cfset variables._listeners = arguments.listenerRegistry />
	<cfreturn this />
</cffunction>

<cffunction name="getListeners" returntype="array" output="false">
	<cfargument name="message" type="string" required="true" />
	<cfreturn variables._listeners.getListeners(arguments.message) />
</cffunction>

<!--- Broadcasts a given message. --->
<cffunction name="Broadcast" returnType="void" output="false" access="public" hint="I broadcast a message.">
  <cfargument name="eventContext" />

	<cfset var messageName = arguments.eventContext.getMessage().getName() />
	<cfset var listeners = getListeners(messageName) />
	<cfset var args = structNew() />
	<cfset var i = "" />
	
	<cfset args.event = arguments.eventContext />
	
	<cfif not arrayLen(listeners)
		and not listFindNoCase("onRequestStart,onRequestEnd,onQueueComplete", messageName)
	>	
		<cfset eventContext.trace("Message with No Listeners", "The message ""<strong>#messageName#</strong>"" is being broadcast, but has no listeners.", "<message name=""#messageName#"" />", "WARNING") />
	</cfif>
	
	<cfloop from="1" to="#arrayLen(listeners)#" index="i">
		<cfset listeners[i].invokeListener(messagename=messagename,parameters=args) />
	</cfloop>
</cffunction>

</cfcomponent>