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


<cfcomponent displayname="ListenerRegistry" hint="I register listeners for messages." output="false">

<cffunction name="init" returntype="ModelGlue.unity.listener.ListenerRegistry" access="public" output="false">
	<cfset variables._listeners = structNew() />
	<cfreturn this />
</cffunction>

<cffunction name="addListener" returntype="void" access="public" hint="I register a given Controller instance's method to listen for a given message." output="false">
	<cfargument name="message" type="string" required="true" />
	<cfargument name="target" type="any" required="true" />
	<cfargument name="method" type="string" required="true" />
	<cfargument name="async" type="boolean" required="true" />
	
	<cfset var listener = "" />
	
	<cfset listener = createObject("component", "ModelGlue.unity.listener.Listener").init(arguments.target, arguments.method, arguments.async) />
	
	<cfif not structKeyExists(variables._listeners, arguments.message)>
		<cfset variables._listeners[arguments.message] = arrayNew(1) />
	</cfif>

	<cfset arrayAppend(variables._listeners[arguments.message], listener) />
</cffunction>

<cffunction name="getListeners" access="public" hint="I return listeners for a given message." output="false">
	<cfargument name="message" type="string" required="true" />
	
	<cftry>
		<cfreturn variables._listeners[arguments.message] />
		<cfcatch>
			<cfreturn arrayNew(1) />
		</cfcatch>
	</cftry>	
</cffunction>

</cfcomponent>