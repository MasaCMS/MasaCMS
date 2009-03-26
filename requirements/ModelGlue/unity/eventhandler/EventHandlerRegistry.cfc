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


<cfcomponent displayname="EventHandlerRegistry" hint="I register EventHandlers for messages." output="false">

<cffunction name="init" returntype="ModelGlue.unity.eventhandler.EventHandlerRegistry" access="public" output="false">
	<cfset variables._EventHandlers = structNew() />
	<cfreturn this />
</cffunction>

<cffunction name="addEventHandler" returntype="void" access="public" hint="I register a given Controller instance's method to listen for a given message." output="false">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="eventhandler" type="ModelGlue.unity.eventhandler.EventHandler" required="true" />
	<cfset variables._EventHandlers[arguments.name] = arguments.eventhandler />
</cffunction>

<cffunction name="getEventHandler" access="public" hint="I return EventHandlers for a given message." output="false">
	<cfargument name="name" />
	
	<cftry>
		<cfreturn variables._EventHandlers[arguments.name] />
		<cfcatch>
			<cfthrow message="Model-Glue:  There is no known event handler for ""#arguments.name#""." />
		</cfcatch>
	</cftry>	
</cffunction>

<cffunction name="exists" returntype="boolean" access="public" output="false">
	<cfargument name="name" type="string" required="true" />
	<cfreturn structKeyExists(variables._eventHandlers, arguments.name) />
</cffunction>

</cfcomponent>