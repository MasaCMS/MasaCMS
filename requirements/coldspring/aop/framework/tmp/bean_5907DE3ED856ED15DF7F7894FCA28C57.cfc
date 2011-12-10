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

 $Id: bean_5907DE3ED856ED15DF7F7894FCA28C57.cfc,v 1.1 2005/11/12 19:01:07 scottc Exp $
 $Log: bean_5907DE3ED856ED15DF7F7894FCA28C57.cfc,v $
 Revision 1.1  2005/11/12 19:01:07  scottc
 Many fixes in new advice type Interceptors, which now don't require parameters to be defined for the afterReturning and before methods. Advice objects are now NOT cloned, so they can be used as real objects and retrieved from the factory, if needed. Implemented the afterThrowing advice which now can be used to create a full suite of exception mapping methods. Also afterReturning does not need to (and shouldn't) return or act on the return value

 Revision 1.10  2005/11/01 03:48:21  scottc
 Some fixes to around advice as well as isRunnable in Method class so that advice cannot directly call method.proceed(). also some unitTests

 Revision 1.9  2005/10/10 18:40:10  scottc
 Lots of fixes pertaining to returning and not returning values with afterAdvice, also added the security for method invocation that we discussed

 Revision 1.8  2005/10/09 22:45:25  scottc
 Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="coldspring.aop.framework.tmp.bean_5907DE3ED856ED15DF7F7894FCA28C57" 
			displayname="AopProxyBean" 
			extends="net.klondike.component.catalogGateway"
			hint="Abstract Base Class for Aop Proxy Bans" 
			output="false">
			
	<cffunction name="init" access="public" returntype="net.klondike.component.catalogGateway" output="false">
		<cfargument name="target" type="any" required="true" />
		<cfset variables.target = arguments.target />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setAdviceChains" access="public" returntype="void" output="false">
		<cfargument name="adviceChains" type="struct" required="true" />
		<cfset variables.adviceChains = arguments.adviceChains />
	</cffunction>
	
	<cffunction name="getAdviceChains" access="public" returntype="struct" output="false">
		<cfreturn variables.adviceChains />
	</cffunction>

	<cffunction name="callMethod" access="public" returntype="any">
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfset var adviceChain = 0 />
		<cfset var methodInvocation = 0 />
		<cfset var method = 
			   CreateObject('component','coldspring.aop.Method')init(variables.target, arguments.methodName, arguments.args) />
		
		<!--- if an advice chain was created for this method, retrieve a methodInvocation chain from it and proceed --->
		<cfif StructKeyExists(variables.adviceChains, arguments.methodName)>
			<cfset adviceChain = variables.adviceChains[arguments.methodName] />
			<cfset methodInvocation = adviceChain.getNewInterceptorChain(method, args, testObj) />
			<cfreturn methodInvocation.proceed() />
		<cfelse>
			<!--- if there's no advice chains to execute, just call the method --->
			<cfset method.setRunnable() />
			<cfreturn method.proceed() />
		</cfif>
		
	</cffunction>

	<cffunction name="callMethodOld" access="public" returntype="any">
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfset var method = CreateObject('component','coldspring.aop.Method') />
		<cfset var rtn = 0 />
		<cfset var adviceChain = 0 />
		<cfset var advice = 0 />
		<cfset var advIx = 0 />
		
		<!--- first create a method object to pass through advice chain --->
		<cfset method.init(variables.target, arguments.methodName, arguments.args) />
		
		<!--- now find advice chains to call --->
		<cfif StructKeyExists(variables.adviceChains, arguments.methodName)>
			<!--- first call any before methods --->
			<cfset adviceChain = variables.adviceChains[arguments.methodName].getAdvice('before') />
			<cfloop from="1" to="#ArrayLen(adviceChain)#" index="advIx">
				<cfset adviceChain[advIx].before(method, arguments.args, variables.target) />
			</cfloop>
			
			<!---  for methodInterceptors, the advice chain will create a proper interceptorChain --->
			<cfset adviceChain = variables.adviceChains[arguments.methodName].getInterceptorChain(method, arguments.args, variables.target) />
			<cfset rtn = adviceChain.proceed() />
			
			<!--- now any after returning advice --->
			<cfset adviceChain = variables.adviceChains[arguments.methodName].getAdvice('afterReturning') />
			<cfloop from="1" to="#ArrayLen(adviceChain)#" index="advIx">
				<!--- if there's a return value, pass it in to afterReturning, if not, don't --->
				<cfif isDefined('rtn')>
					<cfset rtn = adviceChain[advIx].afterReturning(rtn, method, arguments.args, variables.target) />
				<cfelse>
					<cfset rtn = adviceChain[advIx].afterReturning(method=method, args=arguments.args, target=variables.target) />
				</cfif>
			</cfloop>
		<cfelse>
			<!--- if there's no advice chains to execute, just call the method --->
			<cfset method.setRunnable() />
			<cfset rtn = method.proceed() />
		</cfif>
		
		<cfif isDefined('rtn')>
			<cfreturn rtn />
		</cfif>
	</cffunction>
	
</cfcomponent>
