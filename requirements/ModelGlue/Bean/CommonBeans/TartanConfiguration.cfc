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


<cfcomponent output="false" hint="I am an example bean that could represent Tartan settings.">
  <cffunction name="Init" access="public" output="false" hint="I build a new TartanConfiguration bean.">
    <cfset variables.config = "" />
    <cfset variables.type = "" />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="SetConfig" access="public" return="void" output="false" hint="Set property: Config">
    <cfargument name="value" />
    <cfset variables.Config=arguments.value />
  </cffunction>
  
  <cffunction name="GetConfig" access="public" return="string" output="false" hint="Get property: Config">
    <cfreturn variables.Config />
  </cffunction>
  
  <cffunction name="SetType" access="public" return="void" output="false" hint="Set property: Type">
    <cfargument name="value" />
    <cfset variables.Type=arguments.value />
  </cffunction>
  
  <cffunction name="GetType" access="public" return="string" output="false" hint="Get property: Type">
    <cfreturn variables.Type />
  </cffunction>
</cfcomponent>