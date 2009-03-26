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


<cfcomponent hint="I am a bean ideal for holding config settings." output="false">
  
  <cffunction name="Init" access="public" output="false" hint="I build a new SimpleConfig bean.">
    <cfset variables.config = structNew() />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="SetConfig" access="public" return="void" output="false" hint="Set property: config">
    <cfargument name="value" type="struct"/>
    <cfset variables.config=arguments.value />
  </cffunction>
  
  <cffunction name="GetConfig" access="public" return="struct" output="false" hint="Get property: config">
    <cfreturn duplicate(variables.config) />
  </cffunction>
  
  <cffunction name="GetConfigSetting" access="public" return="any" output="false" hint="I get a config setting from the config by name.">>
    <cfargument name="name" required="true" type="string">
    
    <cfreturn variables.config[arguments.name] />
  </cffunction>
</cfcomponent>