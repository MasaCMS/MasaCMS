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
		
			
 $Id: MapFactoryBean.cfc,v 1.2 2007/11/24 21:19:06 scottc Exp $

--->

<cfcomponent displayname="MapFactoryBean" extends="coldspring.beans.factory.FactoryBean">

	<cffunction name="init" access="public" 
				returntype="coldspring.beans.factory.config.MapFactoryBean" 
				output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getObject" access="public" returntype="Struct" output="false">
		<cfif structKeyExists(variables,"sourceMap")>
			<cfreturn variables.sourceMap />
		<cfelse>
			<cfreturn StructNew() />
		</cfif>
	</cffunction>
	
	<cffunction name="setSourceMap" access="public" returntype="void" output="false">
		<cfargument name="sourceMap" type="Struct" required="true" hint="Source Map (Struct) to return from getObject() method."/>
		<cfset variables.sourceMap = arguments.sourceMap />
	</cffunction> 
	
	<cffunction name="getObjectType" access="public" returntype="string" output="false">
		<cfreturn "Struct" />
	</cffunction>
	
	<cffunction name="isSingleton" access="public" returntype="boolean" output="false">
		<cfreturn true />
	</cffunction>
	
</cfcomponent>