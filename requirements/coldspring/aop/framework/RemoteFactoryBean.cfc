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

  $Id: RemoteFactoryBean.cfc,v 1.8 2008/04/17 22:51:21 pjf Exp $
  $Log: RemoteFactoryBean.cfc,v $
  Revision 1.8  2008/04/17 22:51:21  pjf
  - Fixed CSP-96 per discussion with Chris Scott on the issue

  Revision 1.7  2008/03/17 23:53:33  bkotek
  Fix bugs CSP-92, CSP-93, and CSP-94.

  Revision 1.6  2007/09/11 11:41:52  scottc
  Fixed error setting bean factory in the proper scope, moved initialization into setup method in RemoteProxyBean

  Revision 1.5  2007/06/02 21:02:57  scottc
  Removed ALL output from bean factory and aop, no system out, no logging. Added support for placeholders in map and list tags, major restructuring of bean factory, abstract bean factory, bean property

  Revision 1.4  2006/05/14 19:47:10  scottc
  Changed the way that the aop ProxyFactories build the advisor chains, the advisors are now supplied by the bean factory from inside the constructBean method, which handles nonSingletons correctly. Also a small tweek for CSP-52 where the beanFactory wasn't being given to the RemoteFactoryBean

  Revision 1.3  2006/03/09 06:09:39  scorfield
  In order to proxy complex objects, such as Reactor-generated objects, we need to walk the inheritance hierarchy to find methods rather than just the most-derived CFC.

  Revision 1.2  2006/01/28 21:33:41  scottc
  Changed machii.ColdspringPlugin back to using beanFactory instead of applicationContext. Created a beanFactoryUtil class just like the appContextUtils to serve the same function and used in the plugin. Also updated the remoteFactoryBean to use absolute and relative paths for writing the proxied remote service

  Revision 1.1  2006/01/13 15:00:12  scottc
  CSP-38 - First pass at RemoteProxyBean, creating remote services for CS managed seriveces through AOP

  Revision 1.8  2005/11/16 16:16:10  rossd
  updates to license in all framework code

  Revision 1.7  2005/11/12 19:01:07  scottc
  Many fixes in new advice type Interceptors, which now don't require parameters to be defined for the afterReturning and before methods. Advice objects are now NOT cloned, so they can be used as real objects and retrieved from the factory, if needed. Implemented the afterThrowing advice which now can be used to create a full suite of exception mapping methods. Also afterReturning does not need to (and shouldn't) return or act on the return value

  Revision 1.6  2005/11/01 03:48:21  scottc
  Some fixes to around advice as well as isRunnable in Method class so that advice cannot directly call method.proceed(). also some unitTests

  Revision 1.5  2005/10/09 22:45:25  scottc
  Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="RemoteFactoryBean" 
			displayname="RemoteFactoryBean" 
			extends="coldspring.aop.framework.ProxyFactoryBean"
			hint="Concrete Class for RemoteFactoryBean" 
			output="false">
	
	<cfset variables.beanFactoryName = "" />
	<cfset variables.beanFactoryScope = "" />
	<cfset variables.remoteMethodNames = "" />
	<cfset variables.proxyAdviceChains = 0 />
			
	<cffunction name="init" access="public" returntype="coldspring.aop.framework.RemoteFactoryBean" output="false">
		<!--- <cfset var category = CreateObject("java", "org.apache.log4j.Category") />
		<cfset variables.logger = category.getInstance('coldspring.aop') />
		<cfset variables.logger.info("ProxyFactoryBean created") /> --->
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setServiceName" access="public" returntype="void" output="false">
		<cfargument name="serviceName" type="string" required="true" />
		<cfset variables.serviceName = arguments.serviceName />
	</cffunction>
	
	<!--- DEPRECIATED, in favor of absolute and relative path --->
	<cffunction name="setServiceLocation" access="public" returntype="void" output="false">
		<cfargument name="serviceLocation" type="string" required="true" />
		<cfset variables.serviceLocation = arguments.serviceLocation />
	</cffunction>
	
	<cffunction name="setAbsolutePath" access="public" returntype="void" output="false">
		<cfargument name="absolutePath" type="string" required="true" />
		<cfset variables.serviceLocation = arguments.absolutePath />
	</cffunction>
	
	<cffunction name="setRelativePath" access="public" returntype="void" output="false">
		<cfargument name="relativePath" type="string" required="true" />
		<cfif Left(arguments.relativePath,1) IS "/">
			<cfset variables.serviceLocation = expandPath(arguments.relativePath) />
		<cfelse>
			<cfset variables.serviceLocation = expandPath("/" & arguments.relativePath) />
		</cfif>
		<!--- <cfset variables.relativePath = arguments.relativePath /> --->
	</cffunction>
	
	<cffunction name="setRemoteMethodNames" access="public" returntype="void" output="false">
		<cfargument name="remoteMethodNames" type="string" required="true" />
		<cfset variables.remoteMethodNames = arguments.remoteMethodNames />
	</cffunction>
	
	<cffunction name="setFlashUtilityService" returntype="void" access="public" output="false" hint="Dependency: flash utility service">
		<cfargument name="flashUtilityService" type="coldspring.remoting.flash.flashUtilityService" required="true"/>
		<cfset variables.flashUtilityService = arguments.flashUtilityService />
	</cffunction>
	
	<cffunction name="setBeanFactoryName" access="public" returntype="void" output="false">
		<cfargument name="beanFactoryName" type="string" required="true" />
		<cfset variables.beanFactoryName = arguments.beanFactoryName />
	</cffunction>
	
	<cffunction name="setBeanFactoryScope" access="public" returntype="void" output="false">
		<cfargument name="beanFactoryScope" type="string" required="true" />
		<cfset variables.beanFactoryScope = arguments.beanFactoryScope />
	</cffunction>
	
	<cffunction name="setId" access="public" returntype="void" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	
	<cffunction name="getObject" access="public" returntype="any" output="true">
		<cfif not isConstructed()>
			<!--- <cfset variables.logger.info("RemopteFactoryBean.getObject() creating new remote proxy") /> --->
			<cfset createRemoteProxy() />
		</cfif>
		<!--- <cfset variables.logger.info("RemopteFactoryBean.getObject() returning target instance") /> --->
		<cfreturn variables.target />
	</cffunction>
	
	<!--- not used --->
	<cffunction name="getAdviceChain" access="public" returntype="any" output="true">
		<cfreturn variables.methodAdviceChain />
	</cffunction>
	
	<!--- new, full aop support --->
	<cffunction name="getProxyAdviceChains" access="public" returntype="any" output="true">
		<cfreturn variables.proxyAdviceChains />
	</cffunction>
	
	<cffunction name="createRemoteProxy" access="public" returntype="void" output="true">
		<cfset var methodPointcutAdvisor = 0 />
		<cfset var flashMappingsInterceptor = 0 />
		<cfset var methodAdviceChains = StructNew() />
		<cfset var md = getMetaData(variables.target)/>
		<cfset var functionIx = 0 />
		<cfset var functionName = '' />
		<cfset var functionString = '' />
		<cfset var usedFunctions = StructNew() />
		<cfset var advisorIx = 0 />
		<cfset var advice = 0 />
		<cfset var bfUtils = createObject("component","coldspring.beans.util.BeanFactoryUtils").init()/>
		<cfset var bfScope = "application"/>
		
		<!--- ok, very first thing, make sure this factory is going to be accessable to the generated proxies --->
		<cfif len(variables.beanFactoryScope)>
			<cfset bfScope = variables.beanFactoryScope/>
		</cfif>
		<cfif len(variables.beanFactoryName) and not bfUtils.namedFactoryExists(bfScope,variables.beanFactoryName)>
			<cfset bfUtils.setNamedFactory(bfScope,variables.beanFactoryName,variables.beanFactory)/>
		<cfelseif not bfUtils.defaultFactoryExists(bfScope)>
			<cfset bfUtils.setDefaultFactory(bfScope,variables.beanFactory)/>
		</cfif>
		
		<!--- first we need to build the advisor to search for pointcut matches --->
		<cfset methodPointcutAdvisor = 
			   CreateObject('component','coldspring.aop.support.NamedMethodPointcut').init() />
		<cfset methodPointcutAdvisor.setMappedNames(variables.remoteMethodNames) />
			   
		<!--- we'll need the flashMappingsInterceptor for later --->
		<cfif StructKeyExists(variables,'flashUtilityService')>
			<cfset flashMappingsInterceptor = CreateObject('component','coldspring.aop.FlashMappingsInterceptor').init() />
			<cfset flashMappingsInterceptor.setFlashUtilityService(variables.flashUtilityService) />
		</cfif>
		
		<!--- NEW --->
		<!--- first we need to build the advisor chain to search for 
			  pointcut matches inside the methods selected as remote methods --->
		<!--- <cfset buildAdvisorChain() /> --->
		
		<!--- now add the flashMappingsInterceptor above as the last around advice (if it was created) --->
		<cfif isObject(flashMappingsInterceptor)>
			<cfset addAdviceWithDefaultAdvisor(flashMappingsInterceptor) />
		</cfif>
		<cfloop condition="structKeyExists(md,'extends')">
			<cfif structKeyExists(md,'extends')>
				<cfif Left(md.name, 34) neq "coldspring.aop.framework.tmp.bean_">
			
				<!--- now we'll loop through the target's methods and write remote methods for any matched ones --->
				<cfloop from="1" to="#arraylen(md.functions)#" index="functionIx">
					<cfset functionName = md.functions[functionIx].name />
					<cfif not ListFindNoCase('init', functionName) and not StructKeyExists(usedFunctions, functionName)>
					
						<cfset usedFunctions[functionName] = "" />
						<cfif methodPointcutAdvisor.matches(functionName)>
						
							<!--- this type of proxy will be limited to remote methods, so 
								  now we need to look for any advisors to add for this method --->
							<cfloop from="1" to="#ArrayLen(variables.advisorChain)#" index="advisorIx">
								<cfif variables.advisorChain[advisorIx].matches(functionName)>
									<!--- if we found a mathing pointcut in an advisor, make sure this method 
										  has an adviceChain started --->
									<cfif not StructKeyExists(methodAdviceChains, functionName)>
										<cfset methodAdviceChains[functionName] = 
											   CreateObject('component','coldspring.aop.AdviceChain').init() />
									</cfif>
									<cfset advice = variables.advisorChain[advisorIx].getAdvice() />
									<cfset methodAdviceChains[functionName].addAdvice(advice) />
								</cfif>
							</cfloop>
							
							<!--- now we need to generate a remote method --->
							<cfset functionString = functionString & 
								   variables.aopProxyUtils.createRemoteMethod(md.functions[functionIx], functionName, 'remote')  & Chr(10) & Chr(10) />
							
						</cfif>
					</cfif>
				</cfloop>
				
				</cfif>
			</cfif>
			<cfset md = md.extends />
		</cfloop>
		
		<!--- instead of giving the proxy object the advice chains, 
			  we'll store it local and the proxy object will retrieve them --->
		<cfset variables.proxyAdviceChains = methodAdviceChains />
		
		<!--- now give the methods to utils to generate a remote facade --->
		<cfset variables.aopProxyUtils.createRemoteProxyBean(variables.serviceName,
			   											  variables.serviceLocation,
														  variables.beanFactoryName,
														  variables.beanFactoryScope,
														  functionString,
														  variables.id) />
		
		<cfset variables.constructed = true />
		
	</cffunction>
	
	<cffunction name="destroyRemoteProxy" access="public" returntype="void" output="false">
		<!--- now give the methods to utils to generate a remote facade --->
		<cfset variables.aopProxyUtils.removeRemoteProxyBean(variables.serviceName,
			   											  variables.serviceLocation) />
		
		<cfset variables.constructed = false />
	</cffunction>
	
</cfcomponent>