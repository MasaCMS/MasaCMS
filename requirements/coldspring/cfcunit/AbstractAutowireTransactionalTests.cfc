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
		
			
 $Id: AbstractAutowireTransactionalTests.cfc,v 1.4 2007/11/28 02:26:19 scottc Exp $

--->

<cfcomponent displayname="AbstractAutowireTransactionalTests"
			 extends="coldspring.cfcunit.AbstractAutowireTests">
	
	<cfset variables.commit = false />
	<cfset variables.target = 0 />
	
	<cffunction name="setUp" access="public" returntype="void" output="false">
		
		<cfset initProxy() />
		<cfset super.setUp() />
		
	</cffunction>
	
	<cffunction name="setCommit" access="public" returntype="void" output="false">
		<cfargument name="commit" type="boolean" required="false" default="true" />
		<cfset variables.commit = arguments.commit />
	</cffunction>
	
	<cffunction name="getCommit" access="public" returntype="boolean" output="false">
		<cfreturn variables.commit />
	</cffunction>
	
	<cffunction name="initProxy" access="private" 
				returntype="void"
				output="false">
		
		<!--- in order to wrap each test with a transaction, we are going to proxy the unit test --->
		<cfset var factory = CreateObject('component','coldspring.aop.framework.ProxyFactoryBean').init() />
		<cfset var npa = CreateObject('component','coldspring.aop.support.NamedMethodPointcutAdvisor').init() />
		<cfset var adv = CreateObject('component','coldspring.cfcunit.advice.TransactionAdvice') />
		<cfset var proxy = 0 />
		<cfset var md = GetMetaData(this) />
		
		<cfset var functionIndex = 0 />
		<cfset var testMethodName = "" />
		
		<!--- this is going to be CRAZY! I am going to make a new copy of the test class so I can proxy it --->
		<cfset variables.target = CreateObject('component',md.name) />
		
		<!--- setting the pattern to ignore all setters --->
		<cfset npa.setAdvice(adv) />
		<cfset npa.setMappedName('test*') />
		<!--- set the factory's target to this test, and set the advisor --->
		<cfset factory.setTarget(variables.target) />
		<cfset factory.addAdvisor(npa) />
		
		<!--- OK, here we go, I am gonna try to switch pointers to all the test methods on Paul... --->
		<cfset proxy = factory.getObject() />
		
		<cfset md = GetMetaData(variables.target) />
		
		<cfif StructKeyExists(md, "functions")>
			<cfloop from="1" to="#arraylen(md.functions)#" index="functionIndex">
				
				<!--- we are only looking for  test' methods or setters --->
				<cfset testMethodName = md.functions[functionIndex].name />
				<cfif Left(testMethodName, 4) EQ "test" or Left(testMethodName, 3) EQ "set">
					<cfset this[testMethodName] = proxy[testMethodName] />
				</cfif>
				
			</cfloop>		
		</cfif>
		
		<!--- one last things, I need the proxy's advice chains for the local callMethod --->
		<cfset variables.adviceChains = proxy.getAdviceChains() />
		
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