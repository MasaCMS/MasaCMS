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

 $Id: AopProxyBean.cfc,v 1.17 2007/01/01 17:41:36 scottc Exp $
 $Log: AopProxyBean.cfc,v $
 Revision 1.17  2007/01/01 17:41:36  scottc
 added support for <alias name="fromName" alias="toName"/> tag

 Revision 1.16  2006/01/13 15:00:12  scottc
 CSP-38 - First pass at RemoteProxyBean, creating remote services for CS managed seriveces through AOP

 Revision 1.15  2005/11/17 21:25:50  scottc
 removed commented out method call in AopProxyBean

 Revision 1.14  2005/11/17 20:59:59  scottc
 Fixed big breaking mistake in AopProxyBean

 Revision 1.13  2005/11/17 19:59:38  scottc
 tweeked aopProxyBean and Method to make the setRunnable a package method

 Revision 1.12  2005/11/16 16:16:10  rossd
 updates to license in all framework code

 Revision 1.11  2005/11/12 19:01:07  scottc
 Many fixes in new advice type Interceptors, which now don't require parameters to be defined for the afterReturning and before methods. Advice objects are now NOT cloned, so they can be used as real objects and retrieved from the factory, if needed. Implemented the afterThrowing advice which now can be used to create a full suite of exception mapping methods. Also afterReturning does not need to (and shouldn't) return or act on the return value

 Revision 1.10  2005/11/01 03:48:21  scottc
 Some fixes to around advice as well as isRunnable in Method class so that advice cannot directly call method.proceed(). also some unitTests

 Revision 1.9  2005/10/10 18:40:10  scottc
 Lots of fixes pertaining to returning and not returning values with afterAdvice, also added the security for method invocation that we discussed

 Revision 1.8  2005/10/09 22:45:25  scottc
 Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="${name}" 
			displayname="AopProxyBean" 
			extends="${extends}"
			hint="Abstract Base Class for Aop Proxy Beans" 
			output="false">
			
	<cffunction name="init" access="public" returntype="${extends}" output="false">
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

	<cffunction name="callMethod" access="private" returntype="any">
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfset var adviceChain = 0 />
		<cfset var methodInvocation = 0 />
		<cfset var rtn = 0 />
		<cfset var method = 0 />
		
		<!--- if an advice chain was created for this method, retrieve a methodInvocation chain from it and proceed --->
		<cfif StructKeyExists(variables.adviceChains, arguments.methodName)>
			<cfset method = CreateObject('component','coldspring.aop.Method').init(variables.target, arguments.methodName, arguments.args) />
			<cfset adviceChain = variables.adviceChains[arguments.methodName] />
			<cfset methodInvocation = adviceChain.getMethodInvocation(method, arguments.args, variables.target) />
			<cfreturn methodInvocation.proceed() />
		<cfelse>
			<!--- if there's no advice chains to execute, just call the method --->
			<cfinvoke component="#variables.target#"
					  method="#arguments.methodName#" 
					  argumentcollection="#arguments.args#" 
					  returnvariable="rtn">
			</cfinvoke>
			<cfif isDefined('rtn')>
				<cfreturn rtn />
			</cfif>
		</cfif>
		
	</cffunction>
	
</cfcomponent>