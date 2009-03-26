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

 $Id: RemoteProxyBean.cfc,v 1.8 2008/03/07 02:25:04 pjf Exp $
 $Log: RemoteProxyBean.cfc,v $
 Revision 1.8  2008/03/07 02:25:04  pjf
 Var'ed and scope variables caught by a var scope checker

 Revision 1.7  2007/09/11 11:41:52  scottc
 Fixed error setting bean factory in the proper scope, moved initialization into setup method in RemoteProxyBean

 Revision 1.6  2007/01/01 17:41:36  scottc
 added support for <alias name="fromName" alias="toName"/> tag

 Revision 1.5  2006/06/25 13:22:43  rossd
 removing debug code

 Revision 1.4  2006/04/04 03:51:27  simb
 removed duplicate local var bfUtils

 Revision 1.3  2006/01/28 21:44:13  scottc
 Another slight tweek, everything refers to beanFactory, not context

 Revision 1.2  2006/01/28 21:39:57  scottc
 Shoot, the RemoteProxyBean was looking for an applicationContext instead of a bean factory. Updated to look for a beanFactory, but I need to test!

 Revision 1.1  2006/01/13 15:00:12  scottc
 CSP-38 - First pass at RemoteProxyBean, creating remote services for CS managed seriveces through AOP

	
---> 
 
<cfcomponent name="RemoteLanguageService" 
			displayname="RemoteLanguageService:RemoteProxyBean" 
			hint="Abstract Base Class for Aop Based Remote Proxy Beans" 
			output="false">
			
	<cfset variables.proxyId = CreateUUId() />
	<cfset variables.beanFactoryName = "beanFactory" />
	<cfset variables.beanFactoryScope = "" />
	<cfset variables.constructed = false />
	<cfset setup() />
	
	<cffunction name="setup" access="public" returntype="void">
		<cfset var bfUtils = 0 />
		<cfset var bf = 0 />
		<cfset var error = false />
		<cfset var remoteFactory = "" />
		
		<!--- I want to make sure that the proxy id really exists --->
		<cfif not StructKeyExists(variables, "proxyId")>
			<cfset variables.proxyId = CreateUUId() />
		</cfif>
		
		<cflock name="RemoteProxyBean.#variables.proxyId#.Setup" type="readonly" timeout="5">
			<cfif not StructKeyExists(variables, "constructed") or not variables.constructed>
			
				<!--- it looks like there is an issue with setting up the variables scope in a static initializer
					  with remote methods, so we will make sure things are set up --->
				<cfif not StructKeyExists(variables, "constructed")>
					<cfset variables.beanFactoryName = "beanFactory" />
					<cfset variables.beanFactoryScope = "" />
					<cfset variables.constructed = false />
				</cfif>
				<!--- make sure scope is setup (could have been set to '', meaning application, default) --->
				<cfif not len(variables.beanFactoryScope)>
					<cfset variables.beanFactoryScope = 'application' />
				</cfif>
				<cftry>		
					<cfset bfUtils = createObject("component","coldspring.beans.util.BeanFactoryUtils").init()/>
					<cfif not len(variables.beanFactoryName)>
						<cfset bf = bfUtils.getDefaultFactory(variables.beanFactoryScope) />
					<cfelse>
						<cfset bf = bfUtils.getNamedFactory(variables.beanFactoryScope, variables.beanFactoryName) />
					</cfif>
					<cfset remoteFactory = bf.getBean("&remoteLanguageService") />
					<cfset variables.target = bf.getBean("remoteLanguageService") />
					<cfset variables.adviceChains = remoteFactory.getProxyAdviceChains() />
					<cfset variables.constructed = true />
					<cfcatch>
						<cfset error = true />
					</cfcatch>
				</cftry>
			</cfif>
		</cflock>
		
		<cfif error>
			<cfthrow type="coldspring.remoting.ApplicationContextError" 
					 message="Sorry, a ColdSpring BeanFactory named #variables.beanFactoryName# was not found in #variables.beanFactoryScope# scope. Please make sure your bean factory is properly loaded. Perhapse your main application is not running?" />
		</cfif>
		
	</cffunction>

	<cffunction name="callMethod" access="private" returntype="any">
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="args" type="struct" required="true" />
		<cfset var adviceChain = 0 />
		<cfset var methodInvocation = 0 />
		<cfset var rtn = 0 />
		<cfset var method = 0 />
		
		<!--- make sure setup is called --->
		<cfif not StructKeyExists(variables, "constructed") or not variables.constructed>
			<cfset setup() />
		</cfif>
		
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
			
	<cffunction name="reverseString" access="remote" returntype="any" output="false" > 
<cfargument name="string" type="string" required="true" /> 
<cfset var rtn = callMethod('reverseString', arguments) />
<cfif isDefined('rtn')><cfreturn rtn /></cfif>
</cffunction>

<cffunction name="duplicateString" access="remote" returntype="any" output="false" > 
<cfargument name="string" type="string" required="true" /> 
<cfargument name="numberOfDuplicates" type="numeric" required="true" /> 
<cfset var rtn = callMethod('duplicateString', arguments) />
<cfif isDefined('rtn')><cfreturn rtn /></cfif>
</cffunction>


	
</cfcomponent>
