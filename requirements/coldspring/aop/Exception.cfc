<!---
	  
  Copyright (c) 2005, Chris Scott, David Ross, Kurt Wiersma, Sean Corfield
  All rights reserved.
	
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

 $Id: Exception.cfc,v 1.3 2006/06/25 22:56:30 rossd Exp $
 $Log: Exception.cfc,v $
 Revision 1.3  2006/06/25 22:56:30  rossd
 added lockname

 Revision 1.2  2005/11/16 16:16:10  rossd
 updates to license in all framework code

 Revision 1.1  2005/11/03 02:09:22  scottc
 Initial classes to support throwsAdvice, as well as implementing interceptors to make before and after advice (as well as throws advice) all part of the method invocation chain. This is very much in line with the method invocation used in Spring, seems very necessary for throws advice to be implemented. Also should simplify some issues with not returning null values. These classes are not yet implemented in the AopProxyBean, so nothing works yet!


---> 
 
<cfcomponent name="Exception" 
			displayname="Exception" 
			hint="Base Class for FastException" 
			output="false">
			
	<cffunction name="init" access="public" returntype="coldspring.aop.Exception" output="false">
		<cfargument name="exception" type="any" required="true" />
		<cfset variables.exception = arguments.exception />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getBaseException" access="public" returntype="string" output="false">
		<cfreturn variables.exception />
	</cffunction>

	<cffunction name="getType" access="public" returntype="string" output="false">
		<cfreturn variables.exception.type />
	</cffunction>

	<cffunction name="getMessage" access="public" returntype="string" output="false">
		<cfreturn variables.exception.message />
	</cffunction>

	<cffunction name="getDetail" access="public" returntype="string" output="false">
		<cfreturn variables.exception.detail />
	</cffunction>

	<cffunction name="getTagContext" access="public" returntype="array" output="false">
		<cfreturn variables.exception.tagContext />
	</cffunction>

	<cffunction name="getExtendedInfo" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'extendedInfo')>
			<cfreturn variables.exception.extendedInfo />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getNativeErrorCode" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'nativeErrorCode')>
			<cfreturn variables.exception.nativeErrorCode />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getSqlState" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'sqlState')>
			<cfreturn variables.exception.sqlState />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getSql" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'sql')>
			<cfreturn variables.exception.sql />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getQueryError" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'queryError')>
			<cfreturn variables.exception.queryError />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getWhere" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'where')>
			<cfreturn variables.exception.where />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getErrNumber" access="public" returntype="numeric" output="false">
		<cfif StructKeyExists(variables.exception,'errNumber')>
			<cfreturn variables.exception.errNumber />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getMissingFileName" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'missingFileName')>
			<cfreturn variables.exception.missingFileName />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<cffunction name="getLockName" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'lockName')>
			<cfreturn variables.exception.lockName />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	<cffunction name="getLockOperation" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'lockOperation')>
			<cfreturn variables.exception.lockOperation />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	<cffunction name="getErrorCode" access="public" returntype="string" output="false">
		<cfif StructKeyExists(variables.exception,'errorCode')>
			<cfreturn variables.exception.errorCode />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

</cfcomponent>