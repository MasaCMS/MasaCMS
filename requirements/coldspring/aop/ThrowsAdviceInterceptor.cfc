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

 $Id: ThrowsAdviceInterceptor.cfc,v 1.3 2005/11/16 16:16:10 rossd Exp $
 $Log: ThrowsAdviceInterceptor.cfc,v $
 Revision 1.3  2005/11/16 16:16:10  rossd
 updates to license in all framework code

 Revision 1.2  2005/11/12 19:01:07  scottc
 Many fixes in new advice type Interceptors, which now don't require parameters to be defined for the afterReturning and before methods. Advice objects are now NOT cloned, so they can be used as real objects and retrieved from the factory, if needed. Implemented the afterThrowing advice which now can be used to create a full suite of exception mapping methods. Also afterReturning does not need to (and shouldn't) return or act on the return value

 Revision 1.1  2005/11/03 02:09:22  scottc
 Initial classes to support throwsAdvice, as well as implementing interceptors to make before and after advice (as well as throws advice) all part of the method invocation chain. This is very much in line with the method invocation used in Spring, seems very necessary for throws advice to be implemented. Also should simplify some issues with not returning null values. These classes are not yet implemented in the AopProxyBean, so nothing works yet!


---> 
 
<cfcomponent name="ThrowsAdviceInterceptor" 
			displayname="ThrowsAdviceInterceptor" 
			extends="coldspring.aop.MethodInterceptor" 
			hint="Interceptor for handling Throws Advice" 
			output="false">
			
	<cfset variables.intentifier = 'afterThrowing' />
	<cfset variables.intentifierLen = Len(variables.intentifier) />
	<cfset variables.adviceType = 'throwsInterceptor' />
	<cfset variables.methods = StructNew() />
			
	<cffunction name="init" access="public" returntype="coldspring.aop.MethodInterceptor" output="false">
		<cfargument name="throwsAdvice" type="coldspring.aop.ThrowsAdvice" required="true" />
		<cfset variables.throwsAdvice = arguments.throwsAdvice />
		<cfset buildMethods() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="invokeMethod" access="public" returntype="any">
		<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="true" />
		<cfset var rtn = 0 />
		<cfset var ex = 0 />
		<cfset var method = '' />
		<cfset var args = 0 />
		<cftry>
			<cfreturn arguments.methodInvocation.proceed()>
			<cfcatch>
				<cfset method = getMethodForExceptionType(cfcatch.Type)>
				<cfif Len(method)>
					<cfset args = StructNew() />
					<cfset args.method = arguments.methodInvocation.getMethod() />
					<cfset args.args = arguments.methodInvocation.getArguments() />
					<cfset args.target = arguments.methodInvocation.getTarget() />
					<cfset args.exception = CreateObject("component", "coldspring.aop.Exception").init(cfcatch) />
					
					<cfinvoke component="#variables.throwsAdvice#"
							  method="#method#" 
							  argumentcollection="#args#" />
				</cfif>
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getMethodForExceptionType" access="private" returntype="string" output="false">
		<cfargument name="exceptionType" type="string" required="true" />
		<cfset var methodCount = StructCount(variables.methods) />
		<cfset var parsedType = Replace(arguments.exceptionType,".","","all") />
		<cfset var reversedType = Reverse(arguments.exceptionType) />
		<cfset var method = '' />
		<cfset var strPos = 0 />
		<cfset var ix = 0 />
		
		<!--- first get the catchAll method --->
		<cfif StructKeyExists(variables.methods,'Any')>
			<cfset method = variables.methods.Any />
		</cfif>
		
		<!--- if there is a method for this exact exeption type, return it
			  if there's only one method, return it if it's for any type
			  if there are lots of methods, strip off the last parts of the exeption type --->
			  
		<cfif StructKeyExists(variables.methods,parsedType)>
			<cfreturn variables.methods[parsedType] />
		<cfelseif methodCount EQ 1>
			<cfreturn method />
		<cfelse>
			<cfset strPos = Find(".",reversedType)>

			<cfloop condition="strPos GT 0">
				<cfset reversedType = Mid(reversedType,strPos+1,Len(reversedType)-strPos) />
				<cfset parsedType = Replace(Reverse(reversedType),".","","all") />
				<cfif StructKeyExists(variables.methods,parsedType)>
					<cfreturn variables.methods[parsedType] />
				</cfif>
				<cfset strPos = Find(".",reversedType)>
			</cfloop>

			<!--- return the all method or nothing --->
			<cfreturn method />
		</cfif>	
	</cffunction>
	
	<cffunction name="buildMethods" access="private" returntype="void" output="false">
		<cfset var md = getMetaData(variables.throwsAdvice) />
		<cfset var function = 0 />
		<cfset var exceptionType = 0 />
		<cfset var ix = 0 />
		<cfloop from="1" to="#ArrayLen(md.functions)#" index="ix">
			<cfset function = md.functions[ix] />
			<cfif function.name.startsWith(variables.intentifier)>
				<cfif ArrayLen(function.parameters) LT 1>
					<cfthrow type="coldspring.aop.ThrowsAdviceError" message="You must define at minumum the excpetion and exeptionType parameters to the afterThrowing methods">
				<cfelse>
					<cfset exceptionType = Mid(function.name,variables.intentifierLen+1,
						   						Len(function.name)-variables.intentifierLen) />
					<cfif exceptionType IS ''>
						<cfset exceptionType = 'Any' />
					</cfif>
					<cfset variables.methods[exceptionType] = function.name />
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>