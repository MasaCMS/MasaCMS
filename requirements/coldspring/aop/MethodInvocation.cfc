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

 $Id: MethodInvocation.cfc,v 1.6 2005/11/16 16:16:10 rossd Exp $
 $Log: MethodInvocation.cfc,v $
 Revision 1.6  2005/11/16 16:16:10  rossd
 updates to license in all framework code

 Revision 1.5  2005/11/12 19:01:07  scottc
 Many fixes in new advice type Interceptors, which now don't require parameters to be defined for the afterReturning and before methods. Advice objects are now NOT cloned, so they can be used as real objects and retrieved from the factory, if needed. Implemented the afterThrowing advice which now can be used to create a full suite of exception mapping methods. Also afterReturning does not need to (and shouldn't) return or act on the return value

 Revision 1.4  2005/10/10 18:40:10  scottc
 Lots of fixes pertaining to returning and not returning values with afterAdvice, also added the security for method invocation that we discussed

 Revision 1.3  2005/10/09 22:45:24  scottc
 Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="MethodInvocation" 
			displayname="MethodInvocation" 
			hint="Base Class for Method Invokation, joinpoint for Method Interceptors" 
			output="false">
			
	<cffunction name="init" access="public" returntype="coldspring.aop.MethodInvocation" output="false">
		<cfargument name="method" type="coldspring.aop.Method" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfargument name="target" type="any" required="true" />
		<cfargument name="interceptors" type="struct" required="true" />
		
		<cfset variables.method = arguments.method />
		<cfset variables.args = arguments.args />
		<cfset variables.target = arguments.target />
		<cfset variables.interceptors = arguments.interceptors />
		<cfset variables.currentInterceptor = 0 />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="proceed" access="public" returntype="any">
		<cfset var nextInterceptorIndex = 0 />
		<cfset var nextInterceptor = 0 />
		<cflock name="MethodInvocation.nextInterceptorIndex" timeout="5">
			<cfset variables.currentInterceptor = variables.currentInterceptor + 1 />
			<cfset nextInterceptorIndex = variables.currentInterceptor />
		</cflock>
		<cfif nextInterceptorIndex LTE ArrayLen(variables.interceptors.data)>
			<cfset nextInterceptor = variables.interceptors.data[nextInterceptorIndex] />
			<cfreturn nextInterceptor.invokeMethod(this) />
		<cfelse>
			<cfset variables.method.setRunnable() />
			<cfreturn variables.method.proceed() />
		</cfif>
		<!--- <cfset var rtn = 0 />
		
		continue with interceptor chain or call method to proceed
		<cfif StructKeyExists(variables,"methodInterceptor")>
			<cfset rtn = variables.methodInterceptor.invokeMethod(variables.nextInvocation) />
		<cfelse>
			<cfset variables.method.setRunnable() />
			<cfset rtn = variables.method.proceed() />
		</cfif>
		<cfif isDefined('rtn')>
			<cfreturn rtn />
		</cfif> --->
	</cffunction>
	
	<cffunction name="getMethod" access="public" returntype="coldspring.aop.Method" output="false">
		<cfreturn variables.method />
	</cffunction>
	
	<cffunction name="getArguments" access="public" returntype="struct" output="false">
		<cfreturn variables.args />
	</cffunction>
	
	<cffunction name="getTarget" access="public" returntype="struct" output="false">
		<cfreturn variables.target />
	</cffunction>
	
</cfcomponent>