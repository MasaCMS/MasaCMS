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


<cfcomponent displayname="Message" output="false" hint="I'm metadata information about a message that can be broadcast.">
  <cffunction name="init" returnType="ModelGlue.unity.eventhandler.Message" access="public" output="false" hint="I build a new Message.">
    <cfset variables.name = "" />
    <cfset variables.arguments = createObject("component", "ModelGlue.Util.GenericCollection").init() />
    <cfreturn this />
  </cffunction>

  <cffunction name="toStruct" access="public" returntype="struct" output="false">
		<cfset var result = structNew() />
		<cfset result.name = variables.name />
		<cfset result.arguments = getArguments() />
		<cfreturn result />
	</cffunction>

  <cffunction name="setName" access="public" returntype="void" output="false" hint="I set the message's name (is what listeners listen for).">
    <cfargument name="name" type="string" required="true" hint="I am the name.">
    <cfset variables.name = arguments.name />
  </cffunction>
  
  <cffunction name="getName" access="public" returntype="string" output="false" hint="I get the message's name (is what listeners listen for).">
    <cfreturn variables.name />
  </cffunction>
  
  <cffunction name="addArgument" access="public" returntype="void" output="false" hint="I add an argument.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the argument to add.">
    <cfargument name="value" type="string" required="true" hint="I am the value of the argument to add.">
    
    <cfset variables.arguments.setValue(arguments.name, arguments.value) />
  </cffunction>
  
  <cffunction name="getArguments" access="public" output="false" hint="I return the message's arguments (by value)">
    <cfreturn variables.arguments.getAll() />
  </cffunction>
</cfcomponent>