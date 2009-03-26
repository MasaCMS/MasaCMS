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


<cfcomponent hint="I am an example bean that shows how ModelGlue's IoC beans can hold some really complex values.">
  <cffunction name="Init" access="public" output="false" output="false" hint="I build a new example bean.">
    <cfset variables.simpleproperty = "" />
    <cfset variables.arrayproperty = "" />
    <cfset variables.structproperty = "" />
    <cfset variables.complexproperty = "" />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="SetSimpleproperty" access="public" return="void" output="false" hint="Set property: Simpleproperty">
    <cfargument name="value" />
    <cfset variables.Simpleproperty=arguments.value />
  </cffunction>
  
  <cffunction name="GetSimpleproperty" access="public" return="String" output="false" hint="Get property: Simpleproperty">
    <cfreturn variables.Simpleproperty />
  </cffunction>
  
  <cffunction name="SetArrayproperty" access="public" return="void" output="false" hint="Set property: Arrayproperty">
    <cfargument name="value" />
    <cfset variables.Arrayproperty=arguments.value />
  </cffunction>
  
  <cffunction name="GetArrayproperty" access="public" return="array" output="false" hint="Get property: Arrayproperty">
    <cfreturn variables.Arrayproperty />
  </cffunction>
  
  <cffunction name="SetStructproperty" access="public" return="void" output="false" hint="Set property: Structproperty">
    <cfargument name="value" />
    <cfset variables.Structproperty=arguments.value />
  </cffunction>
  
  <cffunction name="GetStructproperty" access="public" return="Struct" output="false" hint="Get property: Structproperty">
    <cfreturn variables.Structproperty />
  </cffunction>
  
  <cffunction name="SetComplexproperty" access="public" return="void" output="false" hint="Set property: Complexproperty">
    <cfargument name="value" />
    <cfset variables.Complexproperty=arguments.value />
  </cffunction>
  
  <cffunction name="GetComplexproperty" access="public" return="array" output="false" hint="Get property: Complexproperty">
    <cfreturn variables.Complexproperty />
  </cffunction>
  
  <cffunction name="SetMegaComplexproperty" access="public" return="void" output="false" hint="Set property: MegaComplexproperty">
    <cfargument name="value" />
    <cfset variables.MegaComplexproperty=arguments.value />
  </cffunction>
  
  <cffunction name="GetMegaComplexproperty" access="public" return="Struct" output="false" hint="Get property: MegaComplexproperty">
    <cfreturn variables.MegaComplexproperty />
  </cffunction>
  
  <cffunction name="GetState">
    <cfreturn variables />
  </cffunction>
</cfcomponent>