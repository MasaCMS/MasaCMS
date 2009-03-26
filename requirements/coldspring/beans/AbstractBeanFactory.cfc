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
		
			
 $Id: AbstractBeanFactory.cfc,v 1.9 2008/08/05 20:00:18 bkotek Exp $

--->
 
<cfcomponent name="AbstractBeanFactory" 
			displayname="BeanFactory" 
			extends="coldspring.beans.BeanFactory"
			hint="Abstract Base Class for Bean Factory implimentations" 
			output="false">
	
	<!--- local bean factory id --->
	<cfset variables.beanFactoryId = CreateUUId() />
	<!--- local struct to hold bean definitions --->
	<cfset variables.beanDefs = structnew()/>
	<!--- Optional parent bean factory --->
	<cfset variables.parent = 0>
	<!--- bean cache --->
	<cfset variables.singletonCache = StructNew() />
	<cfset variables.aliasMap = StructNew() />
	<cfset variables.known_bf_postprocessors = "coldspring.beans.factory.config.PropertyPlaceholderConfigurer,coldspring.beans.factory.config.BeanFactoryLocator" />
	<cfset variables.known_bean_postprocessors = "coldspring.aop.framework.autoproxy.BeanNameAutoProxyCreator" />
	
	<!--- ColdSpring Framework Properties --->
	<cfset variables.instanceData.frameworkPropertiesFile = "/coldspring/frameworkProperties.properties" />
	<cfset variables.instanceData.frameworkProperties = loadFrameworkProperties(ExpandPath(variables.instanceData.frameworkPropertiesFile)) />
	
			
	<cffunction name="init" access="private" returntype="void" output="false">
		<cfthrow message="Abstract CFC cannot be initialized" />
	</cffunction>
	
	<cffunction name="getParent" access="public" returntype="coldspring.beans.AbstractBeanFactory" output="false">
		<cfif isObject(variables.parent)>
			<cfreturn variables.parent>
		<cfelse>
			<cfreturn createObject("component", "coldspring.beans.AbstractBeanFactory")>
		</cfif>
	</cffunction>
	
	<cffunction name="setParent" access="public" returntype="void" output="false">
		<cfargument name="parent" type="coldspring.beans.AbstractBeanFactory" required="true">
		<cfset variables.parent = arguments.parent>
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="any" output="false">
		<cfargument name="beanName" type="string" required="true" />
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="containsBean" access="public" returntype="boolean" output="false">
		<cfargument name="beanName" type="string" required="true" />
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="getType" access="public" returntype="string" output="false">
		<cfargument name="beanName" type="string" required="true" />
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="isSingleton" access="public" returntype="boolean" output="false">
		<cfargument name="beanName" type="string" required="true" />
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<!--- begining with ColdSpring 1.5, we will use the abstract bean factory for all base implementations
		  and keep only xml specific processing in DefaultXmlBeanFactory --->
	<cffunction name="singletonCacheContainsBean" access="public" returntype="boolean" output="false">
		<cfargument name="beanName" type="string" required="true" />
		<cfset var objExists = 0 />
		<cflock name="bf_#variables.beanFactoryId#.SingletonCache" type="readonly" timeout="5">
			<cfset objExists = StructKeyExists(variables.singletonCache, beanName) />
		</cflock>
		<cfif not(objExists) AND isObject(variables.parent)>
			<cfset objExists = variables.parent.singletonCacheContainsBean(arguments.beanName)>
		</cfif>
		<cfreturn objExists />
	</cffunction>
	
	<cffunction name="getBeanFromSingletonCache" access="public" returntype="any" output="false">
		<cfargument name="beanName" type="string" required="true" />
		<cfset var objRef = 0 />
		<cfset var objExists = true />
		<cflock name="bf_#variables.beanFactoryId#.SingletonCache" type="readonly" timeout="5">
			<cfif StructKeyExists(variables.singletonCache, beanName)>
				<cfset objRef = variables.singletonCache[beanName] />
			<cfelse>
				<cfset objExists = false />
			</cfif>
		</cflock>
		
		<cfif not(objExists)>
			<cfif isObject(variables.parent)>
				<cfset objRef = variables.parent.getBeanFromSingletonCache(arguments.beanName)>
			<cfelse>
				<cfthrow message="Cache error, #beanName# does not exists">
			</cfif>
		</cfif>
		
		<cfreturn objRef />
	</cffunction>
	
	<cffunction name="addBeanToSingletonCache" access="public" returntype="any" output="false">
		<cfargument name="beanName" type="string" required="true" />
		<cfargument name="beanObject" type="any" required="true" />
		<cfset var error = false />
		
		<cflock name="bf_#variables.beanFactoryId#.SingletonCache" type="exclusive" timeout="5">
			<cfif StructKeyExists(variables.singletonCache, beanName)>
				<cfset error = true />
			<cfelse>
				<cfset variables.singletonCache[beanName] = beanObject />
			</cfif>
		</cflock>
		
		<cfif error>
			<cfthrow message="Cache error, #beanName# already exists in cache">
		</cfif>
	</cffunction>
	
	<cffunction name="getBeanDefinition" access="public" returntype="coldspring.beans.BeanDefinition" output="false"
				hint="retrieves a bean definition for the specified bean">
		<cfargument name="beanName" type="string" required="true" />
		<!--- the supplied 'beanName' could be an alias, so we want to resolve that to the concrete name first --->
		<cfset var resolvedName = resolveBeanName(arguments.beanName) />
		<cfif not StructKeyExists(variables.beanDefs, resolvedName)>
			<cfif isObject(variables.parent)>
				<cfreturn variables.parent.getBeanDefinition(resolvedName)>
			<cfelse>
				<cfthrow type="coldspring.MissingBeanReference" message="There is no bean registered with the factory with the id #arguments.beanName#" />
			</cfif>
		<cfelse>
			<cfreturn variables.beanDefs[resolvedName] />
		</cfif>
	</cffunction>
	
	<cffunction name="beanDefinitionExists" access="public" returntype="boolean" output="false"
				hint="searches all known factories (parents) to see if bean definition for the specified bean exists">
		<cfargument name="beanName" type="string" required="true" />
		<!--- the supplied 'beanName' could be an alias, so we want to resolve that to the concrete name first --->
		<cfset var resolvedName = resolveBeanName(arguments.beanName) />
		<cfif StructKeyExists(variables.beanDefs, resolvedName)>
			<cfreturn true />
		<cfelse>
			<cfif isObject(variables.parent)>
				<cfreturn variables.parent.beanDefinitionExists(resolvedName)>
			<cfelse>
				<cfreturn false />
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="getBeanDefinitionList" access="public" returntype="Struct" output="false">
		<cfreturn variables.beanDefs />
	</cffunction>
	
	<cffunction name="registerAlias" access="public" returntype="void" output="false">
		<cfargument name="beanName" type="string" required="true" />
		<cfargument name="alias" type="string" required="true" />
		<cfset var duplicateAlias = "" />
		<!--- <cfset var sys = CreateObject('java','java.lang.System') /> --->
		<cflock name="bf_#variables.beanFactoryId#.AliasMap" type="exclusive" timeout="5">
			<cfif StructKeyExists(variables.aliasMap, arguments.alias)>
				<cfset duplicateAlias = variables.aliasMap[arguments.alias] />
			<cfelse>
				<cfset variables.aliasMap[arguments.alias] = arguments.beanName />
				<!--- <cfset sys.out.println("Registering alias #arguments.alias# for bean #arguments.beanName#")/> --->
			</cfif>
		</cflock>
		
		<cfif len(duplicateAlias)>
			<cfthrow type="ColdSpring.AliasException" 
					 detail="The alias #arguments.alias# is already registered for bean #duplicateAlias#"/>
		</cfif>
	</cffunction>
	
	<cffunction name="resolveBeanName" access="public" returntype="string" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset var beanName = "" />
		<!--- <cfset var sys = CreateObject('java','java.lang.System') /> --->
		<!--- first look to resolve alias, if we don;t have the alias mapped, return supplied bean name --->
		<cflock name="bf_#variables.beanFactoryId#.AliasMap" type="readonly" timeout="5">
			<cfif StructKeyExists(variables.aliasMap, arguments.name)>
				<cfset beanName = variables.aliasMap[arguments.name] />
			</cfif>
		</cflock>
		
		<cfif len(beanName)>
			<!--- <cfset sys.out.println("Retrieved bean #beanName# for alias #arguments.name#")/> --->
			<cfreturn beanName />
		<cfelse>
			<!--- <cfset sys.out.println("Bean name #arguments.name# is a proper bean")/> --->
			<cfreturn name />
		</cfif>
	</cffunction>
	
	<cffunction name="getMergedBeanDefinition" access="public" returntype="coldspring.beans.BeanDefinition" output="false">
		<cfargument name="beanName" type="string" required="true"/>
		<cfset var beanDefinition = getBeanDefinition(arguments.beanName) />
		<cfif beanDefinition.isChildDefinition() and not beanDefinition.isMerged()>
			<cfreturn buildMergedBeanDefinition(arguments.beanName, beanDefinition) />
		<cfelse>
			<cfreturn beanDefinition />
		</cfif>
	</cffunction>
	
	<cffunction name="buildMergedBeanDefinition" access="private" returntype="coldspring.beans.BeanDefinition" output="false">
		<cfargument name="beanName" type="string" required="true"/>
		<cfargument name="beanDef" type="coldspring.beans.BeanDefinition" required="true"/>
		<cfset var parentDef = 0 />
		<cfset var mergedDef = 0 />
		
		<!---  we need to deal with potential errors, like parent is empty  --->
		<cfset parentDef = getMergedBeanDefinition(arguments.beanDef.getParent()) />
		<!--- create a new def prom parent and merge in child properties --->
		<cfset mergedDef = CreateObject('component', 'coldspring.beans.BeanDefinition').initFromParent(parentDef) />
		<cfset mergedDef.overrideProperties(arguments.beanDef) />
		<cfset mergedDef.setMerged(true) />
		<!--- we need to replace this bean def --->
		<cfset variables.beanDefs[arguments.beanName] = mergedDef />
		
		<cfreturn mergedDef />
		
	</cffunction>
	
	<cffunction name="getVersion" access="public" returntype="string" output="false" hint="I return the version number for the framework.">
		<cfreturn getFrameworkProperties().getProperty('majorVersion') />
	</cffunction>
	
	<cffunction name="getFrameworkProperties" access="public" returntype="any" output="false" hint="I return a Java Properties object containing the Framework properites such as version number.">
		<cfreturn variables.instanceData.frameworkProperties />
	</cffunction>
	
	<cffunction name="loadFrameworkProperties" access="public" returntype="any" output="false" hint="I return a Java Properties object populated from the specified properties file.">
		<cfargument name="propertiesFile" type="string" required="true" />
		<cfset var local = StructNew() />
		<cfset local.fileStream = CreateObject('java', 'java.io.FileInputStream').init(arguments.propertiesFile) />
		<cfset local.properties = CreateObject('java', 'java.util.Properties').init() />
		<cfset local.properties.load(local.fileStream) />
		<cfreturn local.properties />
	</cffunction>
	
</cfcomponent>