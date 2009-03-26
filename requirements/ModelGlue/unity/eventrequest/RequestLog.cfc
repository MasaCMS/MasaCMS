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


<cfcomponent displayName="RequestLog" output="false" hint="I am a log populated during the request cycle.">
  <cffunction name="Init" access="public" returnType="any" output="false" hint="I build a new RequestLog.">
    <cfset variables.log = arrayNew(1) />

    <cfreturn this />
  </cffunction>

  <cffunction name="Add" access="public" returnType="void" hint="I add an entry to the log.">
  	<cfargument name="time" type="numeric" required="true" hint="I am the time of this entry." />
  	<cfargument name="type" type="string" required="true" hint="I am the type of this entry." />
  	<cfargument name="message" type="string" required="true" hint="I am the message of this entry." />
  	<cfargument name="tag" type="string" required="true" hint="I am ModelGlue.xml tag related to this entry." />
  	<cfargument name="status" type="string" required="true" hint="I am the status of this entry." />

  	<cfset arrayAppend(variables.log, arguments) />
  </cffunction>

  <cffunction name="getLog" access="public" returnType="array" hint="I return the log's contents.">
  	<cfreturn duplicate(variables.log) />
  </cffunction>
</cfcomponent>