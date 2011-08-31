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

  $Id: ProxyFactoryBean.cfc,v 1.14 2007/06/02 21:02:57 scottc Exp $
  $Log: ProxyFactoryBean.cfc,v $
  Revision 1.14  2007/06/02 21:02:57  scottc
  Removed ALL output from bean factory and aop, no system out, no logging. Added support for placeholders in map and list tags, major restructuring of bean factory, abstract bean factory, bean property

  Revision 1.13  2007/01/01 17:41:36  scottc
  added support for <alias name="fromName" alias="toName"/> tag

  Revision 1.12  2006/05/14 19:47:10  scottc
  Changed the way that the aop ProxyFactories build the advisor chains, the advisors are now supplied by the bean factory from inside the constructBean method, which handles nonSingletons correctly. Also a small tweek for CSP-52 where the beanFactory wasn't being given to the RemoteFactoryBean

  Revision 1.11  2006/04/18 00:49:15  scottc
  CSP-48 - Fixed the issue with aop retrieving the advisors through getBean, but we still have an issue with non-singleton beans now, at least when used as advisors. Right now, that doesn't work

  Revision 1.10  2006/03/07 07:50:10  scorfield
  In order to proxy complex objects, such as Reactor-generated objects, we need to walk the inheritance hierarchy to find methods rather than just the most-derived CFC.

  Revision 1.9  2006/02/14 21:03:29  scottc
  Little fix Simeon found with naming of AopProxyUtils in create object, not linux compatible, oops!

  Revision 1.8  2005/11/16 16:16:10  rossd
  updates to license in all framework code

  Revision 1.7  2005/11/12 19:01:07  scottc
  Many fixes in new advice type Interceptors, which now don't require parameters to be defined for the afterReturning and before methods. Advice objects are now NOT cloned, so they can be used as real objects and retrieved from the factory, if needed. Implemented the afterThrowing advice which now can be used to create a full suite of exception mapping methods. Also afterReturning does not need to (and shouldn't) return or act on the return value

  Revision 1.6  2005/11/01 03:48:21  scottc
  Some fixes to around advice as well as isRunnable in Method class so that advice cannot directly call method.proceed(). also some unitTests

  Revision 1.5  2005/10/09 22:45:25  scottc
  Forgot to add Dave to AOP license

	
---> 
 
<cfcomponent name="ProxyFactoryBean" 
			displayname="ProxyFactoryBean" 
			extends="coldspring.beans.factory.FactoryBean"
			hint="Concrete Class for ProxyFactoryBean" 
			output="false">
	
	<cfset variables.singleton = true />		
	<cfset variables.advisorChain = ArrayNew(1) />
	<cfset variables.interceptorNames = 0 />
	<cfset variables.aopProxyUtils = CreateObject('component','coldspring.aop.framework.AopProxyUtils').init() />
	<cfset variables.proxyObject = 0 />
	<cfset variables.constructed = false />
			
	<cffunction name="init" access="public" returntype="coldspring.aop.framework.ProxyFactoryBean" output="false">
		<!--- <cfset var category = CreateObject("java", "org.apache.log4j.Category") />
		<cfset variables.logger = category.getInstance('coldspring.aop') />
		<cfset variables.logger.info("ProxyFactoryBean created") /> --->
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setTarget" access="public" returntype="void" output="false">
		<cfargument name="target" type="any" required="true" />
		<cfset variables.target = arguments.target />	
	</cffunction>
	
	<cffunction name="setInterceptorNames" access="public" returntype="void" output="false">
		<cfargument name="interceptorNames" type="array" required="true" />
		<cfset variables.interceptorNames = arguments.interceptorNames />
	</cffunction>
	
	<cffunction name="getInterceptorNames" access="public" returntype="array" output="false">
		<cfreturn variables.interceptorNames />
	</cffunction>
	
	<cffunction name="addAdvisor" access="public" returntype="string" output="false">
		<cfargument name="advisor" type="coldspring.aop.Advisor" required="true"/>
		<cfset ArrayAppend(variables.advisorChain, arguments.advisor) />
	</cffunction>
	
	<!--- todo: shouldn't this really be internal? used in addAdvisor? Check the type searching in AdviceChain --->
	<cffunction name="addAdviceWithDefaultAdvisor" access="public" returntype="string" output="false">
		<cfargument name="advice" type="coldspring.aop.Advice" required="true"/>
		<cfset var defaultAdvisor = CreateObject("component", "coldspring.aop.support.DefaultPointcutAdvisor") />
		<cfset defaultAdvisor.setAdvice(arguments.advice) />
		<cfset ArrayAppend(variables.advisorChain, defaultAdvisor) />
	</cffunction>
	
	<cffunction name="getBeanFactory" access="public" output="false" returntype="struct" 
				hint="I retrieve the Bean Factory from this instance's data">
		<cfreturn variables.BeanFactory />
	</cffunction>

	<cffunction name="setBeanFactory" access="public" output="false" returntype="void"  
				hint="I set the Bean Factory in this instance's data">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true"/>
		<cfset variables.BeanFactory = arguments.beanFactory />
	</cffunction>
	
	<cffunction name="getObjectType" access="public" returntype="string" output="false">
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="isSingleton" access="public" returntype="boolean" output="false">
		<cfreturn variables.singleton />
	</cffunction>

	<cffunction name="setSingleton" access="public" output="false" returntype="void">
		<cfargument name="singleton" type="boolean" required="true"/>
		<cfset variables.singleton = arguments.singleton />
	</cffunction>
	
	<cffunction name="isConstructed" access="public" returntype="boolean" output="false">
		<cfreturn variables.constructed />
	</cffunction>
	
	<cffunction name="getObject" access="public" returntype="any" output="true">
		<cfif isSingleton()>
			<cfif not isConstructed()>
				<!--- <cfset variables.logger.info("ProxyFactoryBean.getObject() creating new proxy instance") /> --->
				<cfreturn createProxyInstance() />
			<cfelse>
				<!--- <cfset variables.logger.info("ProxyFactoryBean.getObject() returning cached proxy instance") /> --->
				<cfreturn variables.proxyObject />
			</cfif>
		<cfelse>
			<cfthrow type="Method.NotImplemented" message="Creating non-singleton proxies is not yet supported!">
		</cfif>
	</cffunction>
	
	<cffunction name="createProxyInstance" access="private" returntype="any" output="true">
		<cfset var methodAdviceChains = StructNew() />
		<cfset var md = getMetaData(variables.target)/>
		<cfset var functionSeen = structNew() />
		<cfset var functionIx = 0 />
		<cfset var functionName = '' />
		<cfset var advisorIx = 0 />
		<cfset var createInterceptMethod = false />
		<cfset var advice = 0 />
		<cfset var aopProxyBean = variables.aopProxyUtils.createBaseProxyBean(variables.target) />
		<!--- <cfset var aopProxyBean = CreateObject('component','coldspring.aop.framework.AopProxyBean').init(variables.target) /> --->
		
		<!--- first we need to build the advisor chain to search for pointcut matches
		<cfset buildAdvisorChain() /> --->
		
		<cfloop condition="structKeyExists(md,'extends')">
			<cfif structKeyExists(md,'functions')>
				<!--- now we'll loop through the target's methods and search for advice to add to the advice chain --->
				<cfloop from="1" to="#arraylen(md.functions)#" index="functionIx">
				
					<cfset functionName = md.functions[functionIx].name />
					
					<cfif not structKeyExists(functionSeen,functionName)>

						<cfset functionSeen[functionName] = true />

						<cfif not ListFindNoCase('init', functionName)>
							<cfloop from="1" to="#ArrayLen(variables.advisorChain)#" index="advisorIx">
								<cfif variables.advisorChain[advisorIx].matches(functionName)>
									<!--- if we found a mathing pointcut in an advisor, make sure this method has an adviceChain started --->
									<cfif not StructKeyExists(methodAdviceChains, functionName)>
										<cfset methodAdviceChains[functionName] = CreateObject('component','coldspring.aop.AdviceChain').init() />
									</cfif>
									<cfset advice = variables.advisorChain[advisorIx].getAdvice() />
									<!--- and duplicate the advice to this method's advice chain
									<cfset methodAdviceChains[functionName].addAdvice(
										   variables.aopProxyUtils.clone(variables.advisorChain[advisorIx].getAdvice()) ) /> --->
									<!--- add the advice to this method's advice chain' --->
									<cfset methodAdviceChains[functionName].addAdvice(advice) />
								</cfif>
							</cfloop>
							<!--- now freeze the method invocation chain for this method
							<cfset methodAdviceChains[functionName].buildInterceptorChain() /> --->
							<!--- so here's where we'll inject intercept methods --->
							<cfset variables.aopProxyUtils.createUDF(md.functions[functionIx], aopProxyBean) />
						</cfif>

					</cfif>
									
				</cfloop>
			</cfif>
			<cfset md = md.extends />
		</cfloop>
		
		<!--- now give the proxy object the advice chains --->
		<cfset aopProxyBean.setAdviceChains(methodAdviceChains) />
		
		<!--- store the proxyObject --->
		<cfset variables.proxyObject = aopProxyBean />
		<cfset variables.constructed = true />
		
		<cfreturn aopProxyBean />
		
	</cffunction>
	
	<!--- todo: This is really a method that is specific to ColdSpring, I'm not sure it belongs in this class, gotta think... --->	
	<cffunction name="buildAdvisorChain" access="public" returntype="void" output="false">
		<cfargument name="localBeanCache" type="struct" required="true" hint="non singleton beans, local to constructBean method" />
		<cfset var advisorBeanDef = 0 />
		<cfset var advisorBean = 0 />
		<cfset var advisor = 0 />
		<cfset var ix = 0 />
		<cfif isArray(variables.interceptorNames)>
			<cfloop from="1" to="#ArrayLen(variables.interceptorNames)#" index="ix">
				<!--- <cfif variables.logger.isInfoEnabled()>
					<cfset variables.logger.info("ProxyFactoryBean.getObject() buildAdvisorChain adding Advisor: " & variables.interceptorNames[ix]) />
				</cfif> --->
				<!--- new update, now we'll try to add as type advisor, if that fails
					  we'll try to create a new default advisor and add as an avice --->
				<!--- <cfset advisorBean = getBeanFactory().getBean(variables.interceptorNames[ix]) /> --->
				<!--- 4/2/6: ok, we are going to try to get the advisor from the singleton cache, but a big problem is, what if it's
					  not a singleton?? How would he get the localBeanCache from the constructBean() method which is actually creating
					  this object??
				<cfset advisorBean = getBeanFactory().getBeanFromSingletonCache(variables.interceptorNames[ix]) /> --->
				
				
				<!--- retrieve the advisor's bean def --->
				<cfset advisorBeanDef = getBeanFactory().getMergedBeanDefinition(variables.interceptorNames[ix]) />
				
				<cfif advisorBeanDef.isSingleton()>
					<cfset advisorBean = advisorBeanDef.getInstance() />
				<cfelse>
					<cfset advisorBean = localBeanCache[variables.interceptorNames[ix]] />
				</cfif>
				
				
				<cftry>
					<cfset addAdvisor(advisorBean) />
					<cfcatch>
						<cftry>
							<cfset addAdviceWithDefaultAdvisor(advisorBean) />
						<cfcatch>
							<cfthrow type="coldspring.aop.InvalidAdvisorError" 
									 message="You attempted to add an object which is not of type advice or advisor as an interceptor. This is not allowed!" />
						</cfcatch>
						</cftry>
					</cfcatch>
				</cftry>
			</cfloop>
		</cfif>
	</cffunction>	
	
</cfcomponent>