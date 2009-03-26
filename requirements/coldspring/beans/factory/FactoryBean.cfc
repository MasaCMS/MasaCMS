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
		
			
 $Id: FactoryBean.cfc,v 1.4 2005/11/16 16:16:11 rossd Exp $

---> 
<cfcomponent name="FactoryBean" 
			displayname="FactoryBean" 
			hint="Interface (Abstract Class) for all FactoryBean implimentations" 
			output="false">
			
	<cffunction name="init" access="private" returntype="void" output="false">
		<cfthrow message="Abstract CFC. Cannot be initialized" />
	</cffunction>
	
	<cffunction name="getObject" access="public" returntype="any" output="false">
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="getObjectType" access="public" returntype="string" output="false">
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="isSingleton" access="public" returntype="boolean" output="false">
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
</cfcomponent>