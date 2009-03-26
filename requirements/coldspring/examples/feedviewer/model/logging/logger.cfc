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
		
			
 $Id: logger.cfc,v 1.2 2005/09/26 02:01:07 rossd Exp $

--->

<cfcomponent name="Abstract Logger" output="false">
	
	<cffunction name="init" access="private">
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="setLogLevel" returntype="void" output="false" hint="I set the amount of information to be logged" access="public">
		<cfargument name="logLevel" type="string" required="true"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>
	
	<cffunction name="debug" returntype="void" output="false" hint="I send debug information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>
	
	<cffunction name="info" returntype="void" output="false" hint="I send information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>

	<cffunction name="warning" returntype="void" output="false" hint="I send warning information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>
	
	<cffunction name="fatal" returntype="void" output="false" hint="I send fatal error information to the log" access="public">
		<cfargument name="message" type="string" required="true" hint="I am the message to be logged"/>
		<cfthrow message="Method.NotImplemented"/>
	</cffunction>			
	
	
</cfcomponent>