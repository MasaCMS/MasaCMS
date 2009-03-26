<!---
 
  Copyright (c) 2002-2005	David Ross,	Chris Scott
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: event.cfc,v 1.2 2005/09/26 02:01:04 rossd Exp $

--->

<cfcomponent name="Event" hint="I mimic the encapsulation provided by a mach-ii event for use in other frameworks">
	<cffunction name="init" returntype="Event" output="false" access="public" hint="I initialize the event">
		<cfargument name="initialArgs" type="struct" required="false" default="#structnew()#"/>
		
		<cfset variables.args = arguments.initialArgs/>
	
		<cfreturn this/>
	</cffunction>
	
	
	<cffunction name="getArg" returntype="any" access="public" output="false">
		<cfargument name="argName" type="string" required="true"/>
		<cfargument name="defaultValue" type="any" required="false" default=""/>		
		
		<cfif isArgDefined(arguments.argName)>
			<cfreturn variables.args[arguments.argName]/>
		<cfelse>
			<cfreturn arguments.defaultValue/>
		</cfif>
	
	</cffunction>	

	<cffunction name="getArgs" returntype="struct" access="public" output="false">
			<cfreturn variables.args/>
	</cffunction>	
	
	<cffunction name="isArgDefined" returntype="boolean" access="public" output="false">
		<cfargument name="argName" type="string" required="true"/>
		
		<cfreturn structKeyExists(variables.args,arguments.argName)/>
	
	</cffunction>	
	
	<cffunction name="setArg" returntype="void" access="public" output="false">
		<cfargument name="argName" type="string" required="true"/>
		<cfargument name="argValue" type="any" required="true" />		
		<cfargument name="argType" type="any" required="false" />		
		
		<!--- I'm gonna ignore the type' --->
		
		<cfset variables.args[arguments.argName] = arguments.argValue/>

	</cffunction>	
	
	<cffunction name="removeAll" returntype="struct" access="public" output="false">
			<cfset variables.args = structnew()/>
	</cffunction>	
	
</cfcomponent>