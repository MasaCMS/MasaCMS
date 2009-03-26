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


<cfcomponent output="false" hint="I am an example bean that could represent datasource settings.">
  <cffunction name="Init" access="public" output="false" hint="I build a new datasource bean.">
    <cfset variables.datasource = "" />
    <cfset variables.username = "" />
    <cfset variables.password = "" />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="SetDSN" access="public" return="void" output="false" hint="Set property: DSN">
    <cfargument name="value" type="string" />
    <cfset variables.datasource=arguments.value />
  </cffunction>
  
  <cffunction name="GetDSN" access="public" return="string" output="false" hint="Get property: DSN">
    <cfreturn variables.datasource />
  </cffunction>
  
  <cffunction name="SetUsername" access="public" return="void" output="false" hint="Set property: Username">
    <cfargument name="value" type="string" />
    <cfset variables.Username=arguments.value />
  </cffunction>
  
  <cffunction name="GetUsername" access="public" return="string" output="false" hint="Get property: Username">
    <cfreturn variables.Username />
  </cffunction>
  
  <cffunction name="SetPassword" access="public" return="void" output="false" hint="Set property: Password">
    <cfargument name="value" type="string" />
    <cfset variables.Password=arguments.value />
  </cffunction>
  
  <cffunction name="GetPassword" access="public" return="string" output="false" hint="Get property: Password">
    <cfreturn variables.Password />
  </cffunction>
  
</cfcomponent>