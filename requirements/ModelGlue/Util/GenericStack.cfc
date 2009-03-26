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


<cfcomponent displayname="GenericStack" output="false" hint="I am a generic stack.  FIFO by default, FILO through constructor.">
	<cffunction name="init" access="public" returntype="any" output="false" hint="I build a new GenericStack">
    <cfargument name="fifo" type="any" default="true" hint="TRUE - DEFAULT - First in, first out.  FALSE - First in, last out." />
    <cfset variables.fifo = arguments.fifo />
  	<cfset variables.stack = ArrayNew(1) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="Put" access="public" returnType="void" output="false" hint="I add an item to the stack.">
		<cfargument name="item" type="any" hint="I am the item to put." />
		<cfset ArrayAppend(variables.stack, arguments.item) />
	</cffunction>
	
	<cffunction name="Get" access="public" returnType="any" output="false"  hint="I bring out (and remove) the next item in the stack.">
 		<cfset var result = variables.stack[1] />
		<cfif variables.fifo>
		  <cfset ArrayDeleteAt(variables.stack, 1) />
		<cfelse>
  		<cfset result = variables.stack[arrayLen(variables.stack)] />
		  <cfset ArrayDeleteAt(variables.stack, arrayLen(variables.stack)) />
		</cfif>
		<cfreturn result />
	</cffunction>
	
	<cffunction name="Next" access="public" returnType="any" output="false"	hint="I return next item in the stack without removing it.">
		<cfreturn variables.stack[1] />
	</cffunction>
	
	<cffunction name="Empty" access="public" returnType="void" output="false" hint="I empty the stack.">
		<cfset ArrayClear(variables.stack) />
	</cffunction>
	
	<cffunction name="IsEmpty" access="public" returnType="boolean" output="true" hint="I return whether or not the stack is empty.">
		<cfreturn not count() />
	</cffunction>
	
	<cffunction name="Count" access="public" returnType="numeric" output="false" hint="I return the size of the stack.">
		<cfreturn ArrayLen(variables.stack) />
	</cffunction>
  
  <cffunction name="Dump" access="public" returnType="array" output="false" hint="I return the contents of the stack.">
    <cfreturn variables.stack />
  </cffunction>
</cfcomponent>