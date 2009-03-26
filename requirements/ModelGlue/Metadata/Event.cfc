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


<cfcomponent displayName="Event" output="false" hint="I am metadata about an event, including its views, announcements and their arguments." >
  <cffunction name="init" returnType="ModelGlue.Metadata.Event" output="false" hint="I build a new event.">
    <cfset variables.name = "" />
    <cfset variables.access = true />
    <cfset variables.messages = arrayNew(1) />
    <cfset variables.views = arrayNew(1) />
    <cfset variables.resultMappings = structNew() />
    <cfset variables.implicitResults = arrayNew(1) />
    <cfreturn this />
  </cffunction>

  
  <cffunction name="setName" access="public" returnType="void" output="false" hint="I set the event's name.">
    <cfargument name="name" required="true" type="string">
    <cfset variables.name = arguments.name />
  </cffunction>
  
  <cffunction name="getName" access="public" returnType="string" output="false" hint="I get the event's name.">
    <cfreturn variables.name />
  </cffunction>
    
  <cffunction name="setAccess" access="public" returnType="void" output="false" hint="I set the event's ""access"" property.">
    <cfargument name="access" required="true" type="string">
    
    <cfif arguments.access neq "public" and arguments.access neq "private">
      <cfthrow message="Model-Glue:  Bad access value" detail="An &lt;event-handler&gt;'s ACCESS attribute may only be equal to PUBLIC or PRIVATE" />
    </cfif>
    
    <cfset variables.access = arguments.access />
  </cffunction>
  
  <cffunction name="getAccess" access="public" returnType="string" output="false" hint="I get the event's ""access"" property.">
    <cfreturn variables.access />
  </cffunction>

  <cffunction name="addMessage" access="public" returnType="void" output="false" hint="I add a message.">
    <cfargument name="message" required="true" type="ModelGlue.Metadata.Message">
    <cfset arrayAppend(variables.messages, arguments.message) />
  </cffunction>
  
  <cffunction name="getMessages" access="public" returnType="array" output="false" hint="I return messages this event broadcasts.">
    <cfreturn variables.messages />
  </cffunction>
  
  <cffunction name="addView" access="public" returnType="void" output="false" hint="I add a view.">
    <cfargument name="view" required="true" type="ModelGlue.Metadata.View">
    <cfset arrayPrepend(variables.views, arguments.view) />
  </cffunction>
  
  <cffunction name="getViews" access="public" returnType="array" output="false" hint="I return the views this event renders.">
    <cfreturn variables.views />
  </cffunction>

  <cffunction name="addResultMapping" access="public" returnType="void" output="false" hint="I add a ResultMapping.">
    <cfargument name="Name" required="true" type="string">
    <cfargument name="Event" required="true" type="string">
    <cfargument name="Redirect" required="true" type="boolean">
    <cfargument name="Append" required="true" type="string">

		<cfset var mapping = structNew() />
		<cfset mapping.event = arguments.event />
		<cfset mapping.redirect = arguments.redirect />
		<cfset mapping.append = arguments.append />

    <cfparam name="variables.resultMappings[arguments.name]" type="array" default="#arrayNew(1)#" />

    <cfset arrayAppend(variables.resultMappings[arguments.name], mapping) />
  </cffunction>
  
  <cffunction name="getResultMappings" access="public" returnType="struct" output="false" hint="I return the ResultMappings this event renders.">
    <cfreturn structCopy(variables.ResultMappings) />
  </cffunction>

</cfcomponent>
