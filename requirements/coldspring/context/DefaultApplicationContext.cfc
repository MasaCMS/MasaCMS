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
		
			
 $Id: DefaultApplicationContext.cfc,v 1.3 2006/01/13 14:52:19 scottc Exp $

	Implements the AbstractApplicationContext interface with support for having a hierarchical 
	set of configs bean containers 
		
--->

<cfcomponent name="Default Application Context" 
 	extends="coldspring.context.AbstractApplicationContext"
	hint="I implement interface for a hierarchical bean factory context.">
	
	<cfset variables.parent = 0>
	<cfset variables.beanFactory = 0>
			
	<cffunction name="init" access="public" returntype="coldspring.context.DefaultApplicationContext" output="false">
		<cfargument name="beanFactory" required="yes" type="coldspring.beans.BeanFactory">
		<cfset variables.beanFactory = arguments.beanFactory>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setBeanFactory" access="public" returntype="void" output="false">
		<cfargument name="beanFactory" required="yes" type="coldspring.beans.BeanFactory">
		<cfset variables.beanFactory = arguments.beanFactory>
	</cffunction>
	
	<cffunction name="setParent" access="public" returntype="void" output="false">
		<cfargument name="appContext" type="coldspring.context.AbstractApplicationContext">
		<cfset variables.parent = arguments.appContext>
	</cffunction>

	<cffunction name="getParent" access="public" returntype="coldspring.context.AbstractApplicationContext" output="false">
		<cfreturn variables.parent>
	</cffunction>
	
	<cffunction name="getBeanFactory" access="public" returntype="coldspring.beans.BeanFactory" output="false">
		<cfreturn variables.beanFactory>
	</cffunction>

	<cffunction name="containsBean" returntype="boolean" hint="checks the bean factory to see if an definition of the given name/id exists" access="public">
		<cfargument name="beanName" required="true" type="string"/>
		<cfset var test = variables.beanFactory.containsBean(arguments.beanName)>
		<cfif NOT test AND isObject(variables.parent)>
			<cfset test = variables.parent.containsBean(arguments.beanName)>
		</cfif>
		<cfreturn test>
	</cffunction>
	
	<cffunction name="getBean" returntype="any" hint="returns an instance from the bean factory of the supplied name/id. Throws: coldspring.NoSuchBeanDefinitionException if given definition is not found." access="public">
		<cfargument name="beanName" required="true" type="string"/>
		<cfset var bean = 0>
		<cftry>
			<cfset bean = variables.beanFactory.getBean(arguments.beanName)>
			<cfcatch type="coldspring.NoSuchBeanDefinitionException">
				<cfif isObject(variables.parent)>
					<cfset bean = variables.parent.getBean(arguments.beanName)>
				<cfelse>
					<cfrethrow> 
				</cfif>
			</cfcatch>
		</cftry>
		<cfreturn bean>
	</cffunction>	
	
	<cffunction name="isSingleton" access="public" returntype="boolean" hint="I inform the caller whether the definition for the given bean is a 'singleton'. Non-singletons will be returned as new instances. Throws: coldspring.NoSuchBeanDefinitionException if given definition is not found.">
		<cfargument name="beanName" required="true" type="string" hint="name of bean to look for"/>
		<cfset var test = false>
		<cftry>
			<cfset test = variables.beanFactory.isSingleton(arguments.beanName)>
			<cfcatch type="coldspring.NoSuchBeanDefinitionException">
				<cfif isObject(variables.parent)>
					<cfset test = variables.parent.isSingleton(arguments.beanName)>
				<cfelse>
					<cfrethrow> 
				</cfif>
			</cfcatch>
		</cftry>
		<cfreturn test>
	</cffunction>

</cfcomponent>