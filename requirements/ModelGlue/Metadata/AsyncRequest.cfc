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


<cfcomponent name="AsyncRequest" output="false" hint="I represent an AsyncRequest.">

<cffunction name="Init" output="false" returnType="ModelGlue.Metadata.AsyncRequest" hint="Constructor">
	<cfargument name="futureTask" type="Concurrency.FutureTask">
	<cfargument name="event" type="ModelGlue.Core.Event">

	<cfset variables.future = arguments.futureTask />
	<cfset variables.event = arguments.event />
	<cfset variables.createdOn = now() />

	<cfreturn this />
</cffunction>

<cffunction name="GetFuture" output="false" returnType="Concurrency.FutureTask">
	<cfreturn variables.future />
</cffunction>

<cffunction name="GetEvent" output="false" returnType="ModelGlue.Core.Event">
	<cfreturn variables.event />
</cffunction>

<cffunction name="GetCreatedOn" output="false" returnType="date">
	<cfreturn variables.createdOn />
</cffunction>

<cffunction name="IsDone" output="false" returnType="boolean">
	<cfreturn GetFuture().IsDone() />
</cffunction>

</cfcomponent>