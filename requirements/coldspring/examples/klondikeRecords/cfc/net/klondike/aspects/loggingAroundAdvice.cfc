<!--- 
	  
  Copyright (c) 2005, Chris Scott, David Ross
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

  $Id: loggingAroundAdvice.cfc,v 1.1 2005/10/09 20:12:06 scottc Exp $
  $Log: loggingAroundAdvice.cfc,v $
  Revision 1.1  2005/10/09 20:12:06  scottc
  First commit of the record store example app. Contains a hopefully detailed readme file on usage.

  Revision 1.2  2005/10/09 19:01:32  chris
  Added proper licensing and switched to MethodInterceptor Araound Advice for logging


--->
 
<cfcomponent name="loggingAroundAdvice" extends="coldspring.aop.MethodInterceptor">

	<!--- setters for dependencies --->
	<cffunction name="setLoggingService" returntype="void" access="public" output="false" hint="Dependency: security service">
		<cfargument name="loggingService" type="net.klondike.service.LoggingService" required="true"/>
		<cfset variables.m_loggingService = arguments.loggingService />
	</cffunction>
	
	<cffunction name="getLoggingService" returntype="net.klondike.service.LoggingService" access="public" output="false" hint="Dependency: security service">
		<cfreturn variables.m_loggingService />
	</cffunction>

	<cffunction name="init" access="public" returntype="net.klondike.aspects.loggingAroundAdvice" output="false">
		<cfset var category = CreateObject("java", "org.apache.log4j.Category") />
		<cfset variables.logger = category.getInstance('net.klondike') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="invokeMethod" access="public" returntype="any">
		<cfargument name="mi" type="coldspring.aop.MethodInvocation" required="true" />
		
		<cfset var args = arguments.mi.getArguments() />
		<cfset var methodName = arguments.mi.getMethod().getMethodName() />
		<cfset var objName = getMetadata(arguments.mi.getTarget()).name />
		<cfset var rtn = '' />
		<cfset var arg = '' />
		<cfset var argString = '' />
		
		<!--- we're just building a string from the arguments, --->
		<cfloop collection="#args#" item="arg">
			<cfif isSimpleValue(args[arg])>
				<cfif len(argString)>
					<cfset argString = argString & ', ' />
				</cfif>
				<cfset argString = argString & arg & '=' & args[arg] >
			</cfif>
		</cfloop>
		
		<cfset variables.m_loggingService.info("[" & objName & "] " & methodName & "(" & argString & ") called!") />
		
		<!--- the MethodInvocation object passed into the invokeMethod method is responsible
			  for calling either the next advice or the method being intercepted through proceed() --->
		<cfset rtn = arguments.mi.proceed() />
		
		<cfset variables.m_loggingService.info("[" & objName & "] " & methodName & "(" & argString & ") complete!") />
		
		<cfif isDefined('rtn')>
			<cfreturn rtn />
		</cfif>
		
	</cffunction>
	
</cfcomponent>