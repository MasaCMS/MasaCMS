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


<cfcomponent name="AsyncRequestCollection" output="false" hint="I represent a collection of AsyncRequest instances.">

<cffunction name="Init" output="false" returnType="ModelGlue.Metadata.AsyncRequestCollection" hint="Constructor">
	<cfset variables.req = arrayNew(1) />
	<cfreturn this />
</cffunction>

<cffunction name="Add" output="false" returnType="void">
	<cfargument name="EventRequest" type="ModelGlue.Metadata.AsyncRequest" required="true">
	<cfset arrayAppend(variables.req, arguments.EventRequest) />
</cffunction>

<cffunction name="GetRequests" output="false" returnType="array">
	<cfreturn variables.req />
</cffunction>

<cffunction name="RemoveRequest" output="false" returnType="void">
	<cfargument name="position" type="numeric" required="true" hint="The position of the request to remove in the request array returned by GetRequests()" />

	<cfif arguments.position gt 0 and arguments.position lte arrayLen(variables.req)>
		<cfset arrayDeleteAt(variables.req, arguments.position) />
	</cfif>

	<cfreturn  />
</cffunction>

</cfcomponent>