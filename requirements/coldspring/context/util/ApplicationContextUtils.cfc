<!---
 
  Copyright (c) 2005, David Ross, Chris Scott, Kurt Wiersma, Sean Corfield
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
		
			
 $Id: ApplicationContextUtils.cfc,v 1.1 2006/01/13 14:52:19 scottc Exp $

--->
 
<cfcomponent name="ApplicationContextUtils" 
			displayname="ApplicationContextUtils" 
			hint="Utilities for retrieving the ApplicationContexts" 
			output="false">
			
	<cfset this.DEFAULT_CONTEXT_KEY = "coldspring.appcontext.root" />
	
	<cffunction name="init" access="public" returntype="coldspring.context.util.ApplicationContextUtils" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="defaultContextExists" access="public" returntype="boolean" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		<cfreturn StructKeyExists(scopeStruct, this.DEFAULT_CONTEXT_KEY) />
	</cffunction>
	
	<cffunction name="namedContextExists" access="public" returntype="boolean" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		<cfreturn StructKeyExists(scopeStruct, arguments.name) />
	</cffunction>
	
	<cffunction name="getDefaultApplicationContext" access="public"
				returntype="coldspring.context.AbstractApplicationContext" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		
		<cfif StructKeyExists(scopeStruct, this.DEFAULT_CONTEXT_KEY)>
			<cfreturn scopeStruct[this.DEFAULT_CONTEXT_KEY] />
		<cfelse>
			<cfthrow type="coldspring.context.ContextReadError" message="The default application context does not exist in the specified scope, if you do not intend on handling this error, please use defaultContextExists(scope) to check for the context first!" />
		</cfif>
	</cffunction>
	
	<cffunction name="getNamedApplicationContext" access="public"
				returntype="coldspring.context.AbstractApplicationContext" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		
		<cfif StructKeyExists(scopeStruct, arguments.name)>
			<cfreturn scopeStruct[arguments.name] />
		<cfelse>
			<cfthrow type="coldspring.context.ContextReadError" message="The requested context does not exist in the specified scope, if you do not intend on handling this error, please use namedContextExists(scope, name) to check for the context first!" />
		</cfif>
	</cffunction>
	
	<cffunction name="setDefaultApplicationContext" access="public" returntype="void" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfargument name="appContext" type="coldspring.context.AbstractApplicationContext" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		
		<cfset scopeStruct[this.DEFAULT_CONTEXT_KEY] = arguments.appContext />
	</cffunction>
	
	<cffunction name="setNamedApplicationContext" access="public" returntype="void" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfargument name="appContext" type="coldspring.context.AbstractApplicationContext" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		
		<cfset scopeStruct[arguments.name] = arguments.appContext />
	</cffunction>
	
	<cffunction name="getScope" access="private" returntype="struct" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfswitch expression="#LCase(arguments.scope)#">
			<cfcase value="application">
				<cfreturn application />
			</cfcase>
			<cfcase value="session">
				<cfreturn session />
			</cfcase>
			<cfcase value="server">
				<cfreturn server />
			</cfcase>
		</cfswitch>
	</cffunction>
	
</cfcomponent>