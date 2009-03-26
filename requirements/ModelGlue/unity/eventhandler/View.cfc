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


<cfcomponent displayname="View" output="false" hint="I'm metadata information about an event's views.">
  <cffunction name="Init" returnType="ModelGlue.unity.eventhandler.View" access="public" output="false" hint="I build a new View.">
    <cfset variables.name = "" />
    <cfset variables.template = "" />
    <cfset variables.values = structNew() />
    <cfset variables.append = false />
    <cfreturn this />
  </cffunction>

  <cffunction name="toStruct" access="public" returntype="struct" output="false">
		<cfset var result = structNew() />
		<cfset result.name = variables.name />
		<cfset result.template = variables.template />
		<cfset result.values = variables.values />
		<cfset result.append = variables.append />
		
		<cfreturn result />
	</cffunction>

  <cffunction name="SetName" access="public" returntype="void" output="false" hint="I set the view's name.">
    <cfargument name="name" required="true" type="string" hint="I am the name of the view.">
    <cfset variables.name = arguments.name />
  </cffunction>
  
  <cffunction name="GetName" access="public" returntype="string" output="false" hint="I get the view's name.">
    <cfreturn variables.name />
  </cffunction>

  <cffunction name="AddValue" access="public" returntype="void" output="false" hint="I add a state value to the view.">
    <cfargument name="name" required="true" type="string" hint="I am the name of the state entry.">
    <cfargument name="value" required="true" type="string" hint="I am the value of the state entry.">
    <cfargument name="overwrite" required="true" type="boolean" hint="If I am true, this value overwrites existing values in the viewstate.">
    <cfset variables.values[arguments.name] = structNew() />
    <cfset variables.values[arguments.name].value = arguments.value />
    <cfset variables.values[arguments.name].overwrite = arguments.overwrite />
  </cffunction>
  
  <cffunction name="GetValues" access="public" returntype="struct" output="false" hint="I get the view's additional state values.">
    <cfreturn variables.values />
  </cffunction>

  <cffunction name="SetTemplate" access="public" returntype="void" output="false" hint="I set the view's Template.">
    <cfargument name="Template" required="true" type="string" hint="I am the template of the view.">
    <cfset variables.Template = arguments.Template />
  </cffunction>
  
  <cffunction name="GetTemplate" access="public" returntype="string" output="false" hint="I get the view's Template.">
    <cfreturn variables.Template />
  </cffunction>

  <cffunction name="SetAppend" access="public" returntype="void" output="false" hint="I set the view's Append.">
    <cfargument name="Append" required="true" type="string" hint="Does this view get appended to another of the same name?">
    <cfset variables.Append = arguments.Append />
  </cffunction>
  
  <cffunction name="GetAppend" access="public" returntype="string" output="false" hint="I get the view's Append.">
    <cfreturn variables.Append />
  </cffunction>
</cfcomponent>