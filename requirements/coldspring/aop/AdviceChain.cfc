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

 $Id: AdviceChain.cfc,v 1.7 2005/11/16 16:16:10 rossd Exp $
 $Log: AdviceChain.cfc,v $
 Revision 1.7  2005/11/16 16:16:10  rossd
 updates to license in all framework code

 Revision 1.6  2005/11/12 19:01:07  scottc
 Many fixes in new advice type Interceptors, which now don't require parameters to be defined for the afterReturning and before methods. Advice objects are now NOT cloned, so they can be used as real objects and retrieved from the factory, if needed. Implemented the afterThrowing advice which now can be used to create a full suite of exception mapping methods. Also afterReturning does not need to (and shouldn't) return or act on the return value

 Revision 1.5  2005/10/09 22:45:24  scottc
 Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="AdviceChain" 
			displayname="AdviceChain" 
			hint="Base Class for all Advice Chains" 
			output="false">
			
	<cffunction name="init" access="public" returntype="coldspring.aop.AdviceChain" output="false">
		<cfset variables.beforeAdvice = ArrayNew(1) />
		<cfset variables.afterAdvice = ArrayNew(1) />
		<cfset variables.throwsAdvice = ArrayNew(1) />
		<cfset variables.aroundAdvice = ArrayNew(1) />
		<cfset variables.interceptors = StructNew() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addAdvice" access="public" returntype="void" output="false">
		<cfargument name="advice" type="coldspring.aop.Advice" required="true" />
		<cfset var interceptor = 0 />
		
		<cfswitch expression="#advice.getType()#">
			<cfcase value="before">
				<cfset interceptor = CreateObject('component','coldspring.aop.BeforeAdviceInterceptor').init(arguments.advice) />
			</cfcase>
			<cfcase value="afterReturning">
				<cfset interceptor = CreateObject('component','coldspring.aop.AfterReturningAdviceInterceptor').init(arguments.advice) />
			</cfcase>
			<cfcase value="throws">
				<cfset interceptor = CreateObject('component','coldspring.aop.ThrowsAdviceInterceptor').init(arguments.advice) />
			</cfcase>
			<cfdefaultcase>
				<cfset interceptor = arguments.advice />
			</cfdefaultcase>
		</cfswitch>
		
		<cfset addInterceptor(interceptor) />
	</cffunction>
	
	<cffunction name="addInterceptor" access="public" returntype="void" output="false">
		<cfargument name="advice" type="coldspring.aop.MethodInterceptor" required="true" />
		<cfswitch expression="#advice.getType()#">
			<cfcase value="beforeInterceptor">
				<cfset ArrayAppend(variables.beforeAdvice, arguments.advice) />
			</cfcase>
			<cfcase value="afterReturningInterceptor">
				<cfset ArrayAppend(variables.afterAdvice, arguments.advice) />
			</cfcase>
			<cfcase value="throwsInterceptor">
				<cfset ArrayAppend(variables.throwsAdvice, arguments.advice) />
			</cfcase>
			<cfcase value="aroundInterceptor">
				<cfset ArrayAppend(variables.aroundAdvice, arguments.advice) />
			</cfcase>
			<cfdefaultcase>
				<cfthrow type="coldspring.aop.AdviceTypeError" message="The type of advice you attempted to add to the method was not understood. Please make sure that you extend the proper cfc for the advice type your are trying to use.">
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="getMethodInvocation" access="public" returntype="coldspring.aop.MethodInvocation" output="false">
		<cfargument name="method" type="coldspring.aop.Method" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfargument name="target" type="any" required="true" />
		<cfset var invocation = 0 />
		
		<cfif not StructKeyExists(variables.interceptors,'data')>
			<cfset buildInterceptorChain() />
		</cfif>
		
		<cfset invocation = 
			   CreateObject('component','coldspring.aop.MethodInvocation').init(arguments.method, 
																			arguments.args, 
																			arguments.target, 
																			variables.interceptors) />
		
		<cfreturn invocation>
	</cffunction>
	
	<cffunction name="buildInterceptorChain" access="private" returntype="void" output="false">
		<cfset var ix = 0 />
		
		<cflock name="AdviceChain.Interceptors" timeout="5">
			<cfif not StructKeyExists(variables.interceptors,'data')>
				<cfset variables.interceptors.data = ArrayNew(1) />
				<cfloop from="#ArrayLen(variables.throwsAdvice)#" to="1" index="ix" step="-1">
					<cfset ArrayAppend(variables.interceptors.data, variables.throwsAdvice[ix])>
				</cfloop>
				<cfloop from="1" to="#ArrayLen(variables.beforeAdvice)#" index="ix">
					<cfset ArrayAppend(variables.interceptors.data, variables.beforeAdvice[ix])>
				</cfloop>
				<cfloop from="#ArrayLen(variables.afterAdvice)#" to="1" index="ix" step="-1">
					<cfset ArrayAppend(variables.interceptors.data, variables.afterAdvice[ix])>
				</cfloop>
				<cfloop from="1" to="#ArrayLen(variables.aroundAdvice)#" index="ix">
					<cfset ArrayAppend(variables.interceptors.data, variables.aroundAdvice[ix])>
				</cfloop>
			</cfif> 
		</cflock>
		
	</cffunction>
	
</cfcomponent>