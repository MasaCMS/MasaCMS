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
		
			
 $Id: BeanFactoryUtils.cfc,v 1.1 2006/01/28 21:33:41 scottc Exp $

--->
 
<cfcomponent name="BeanFactoryUtils" 
			displayname="BeanFactoryUtils" 
			hint="Utilities for retrieving BeanFactories" 
			output="false">
			
	<cfset this.DEFAULT_FACTORY_KEY = "coldspring.beanfactory.root" />
	
	<cffunction name="init" access="public" returntype="coldspring.beans.util.BeanFactoryUtils" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="defaultFactoryExists" access="public" returntype="boolean" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		<cfreturn StructKeyExists(scopeStruct, this.DEFAULT_FACTORY_KEY) />
	</cffunction>
	
	<cffunction name="namedFactoryExists" access="public" returntype="boolean" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		<cfreturn StructKeyExists(scopeStruct, arguments.name) />
	</cffunction>
	
	<cffunction name="getDefaultFactory" access="public"
				returntype="coldspring.beans.BeanFactory" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		
		<cfif StructKeyExists(scopeStruct, this.DEFAULT_FACTORY_KEY)>
			<cfreturn scopeStruct[this.DEFAULT_FACTORY_KEY] />
		<cfelse>
			<cfthrow type="coldspring.beans.FactoryReadError" message="The default bean factory does not exist in the specified scope, if you do not intend on handling this error, please use defaultFactoryExists(scope) to check for the factory first!" />
		</cfif>
	</cffunction>
	
	<cffunction name="getNamedFactory" access="public"
				returntype="coldspring.beans.BeanFactory" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		
		<cfif StructKeyExists(scopeStruct, arguments.name)>
			<cfreturn scopeStruct[arguments.name] />
		<cfelse>
			<cfthrow type="coldspring.beans.FactoryReadError" message="The requested bean factory does not exist in the specified scope, if you do not intend on handling this error, please use namedFactoryExists(scope, name) to check for the factory first!" />
		</cfif>
	</cffunction>
	
	<cffunction name="setDefaultFactory" access="public" returntype="void" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfargument name="factory" type="coldspring.beans.BeanFactory" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		
		<cfset scopeStruct[this.DEFAULT_FACTORY_KEY] = arguments.factory />
	</cffunction>
	
	<cffunction name="setNamedFactory" access="public" returntype="void" output="false">
		<cfargument name="scope" type="string" required="true" />
		<cfargument name="name" type="string" required="true" />
		<cfargument name="factory" type="coldspring.beans.BeanFactory" required="true" />
		<cfset var scopeStruct = getScope(arguments.scope) />
		
		<cfset scopeStruct[arguments.name] = arguments.factory />
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