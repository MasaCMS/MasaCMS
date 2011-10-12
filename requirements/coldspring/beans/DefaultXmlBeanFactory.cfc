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
		
			
 $Id: DefaultXmlBeanFactory.cfc,v 1.59 2008/08/06 01:56:29 scottc Exp $

---> 

<cfcomponent name="DefaultXmlBeanFactory" 
			displayname="DefaultXmlBeanFactory" 
			extends="coldspring.beans.AbstractBeanFactory"
			hint="XML Bean Factory implimentation" 
			output="false">
	
	<cffunction name="init" access="public" returntype="coldspring.beans.DefaultXmlBeanFactory" output="false"
				hint="Constuctor. Creates a beanFactory">
		<cfargument name="defaultAttributes" type="struct" required="false" default="#structnew()#" hint="default behaviors for undefined bean attributes"/>
		<cfargument name="defaultProperties" type="struct" required="false" default="#structnew()#" hint="any default properties, which can be refernced via ${key} in your bean definitions"/>
		
		<!--- set defaults passed into constructor --->
		<cfset setDefaultAttributes(arguments.defaultAttributes)/>
		<cfset setDefaultProperties(arguments.defaultProperties)/>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="loadBeans" access="public" returntype="void" output="false" hint="loads bean definitions into the bean factory from an xml file location">
		<cfargument name="beanDefinitionFileName" type="string" required="true" />
		<cfset var xmlFiles = structNew()>

		<cfset findImports(xmlFiles,arguments.beanDefinitionFileName)>

		<cfset processLoadBeans(xmlFiles)>
		
		<!--- DEBUG ONLY!!! 
		<cfset this.beanCache = variables.singletonCache /> --->
	</cffunction>

	<cffunction name="findImports" access="public" returntype="void" hint="finds and caches include file paths">
		<cfargument name="importFiles" type="struct" required="true" />
		<cfargument name="importedFilename" type="string" required="true" />
		<cfset var i = 0>
		<cfset var xml = 0>
		<cfset var imports = 0>
		<cfset var currentPath = getDirectoryFromPath(arguments.importedFilename)>
		<cfset var resource = "">
		<cfset var fileContent = "" />

		<cfif not structKeyExists(arguments.importFiles,arguments.importedFilename)>
			<cfif not fileExists(arguments.importedFilename)>
				<cfset arguments.importedFilename = expandPath(arguments.importedFilename)>
			</cfif>

			<cfif not fileExists(arguments.importedFilename)>
				<cfthrow message="The file #arguments.importedFilename# does not exist!"
						detail="You have tried to use or include a file (#arguments.importedFilename#) that does not exist using either absolute, relative, or mapped paths." />
			</cfif>
			
			<cffile action="read" file="#arguments.importedFilename#" variable="fileContent" />
			
			<cfset xml = xmlParse(fileContent)>
			<cfset imports = xmlSearch(xml,"/beans/import")>

			<cfset structInsert(arguments.importFiles,arguments.importedFilename,xml,false)>
	
			<cfif arrayLen(imports) GT 0>
				<cfloop from="1" to="#arrayLen(imports)#" index="i">
					<cfset resource = imports[i].xmlAttributes.resource>
					<cfif left(resource,1) is "/">
						<cfset resource = expandPath(resource)>
					<cfelseif left(resource,1) is ".">
						<cfset resource = shrinkFullRelativePath(currentPath & resource)>
					</cfif>
					<cfset findImports(arguments.importFiles,resource)>
				</cfloop>
			</cfif>
		</cfif>

	</cffunction>

	<cffunction name="findImportsFromXmlObj" access="public" returntype="void" hint="finds and caches include file paths">
		<cfargument name="importFiles" type="struct" required="true" />
		<cfargument name="beanDefinitionXmlObj" type="any" required="true" hint="I am parsed xml bean defs"/>
		<cfset var i = 0>
		<cfset var xml = 0>
		<cfset var imports = 0>
		<cfset var resource = "">

		<cfset xml = xmlParse(arguments.beanDefinitionXmlObj)>
		<cfset imports = xmlSearch(xml,"/beans/import")>
		
		<cfset structInsert(arguments.importFiles,"root",xml,false)>
		
		<cfif arrayLen(imports) GT 0>
			<cfloop from="1" to="#arrayLen(imports)#" index="i">
				<cfset resource = imports[i].xmlAttributes.resource>
				<cfif left(resource,1) is "/">
					<cfset resource = expandPath(resource)>
				<cfelseif left(resource,1) is ".">
					<cfset resource = shrinkFullRelativePath(expandPath(resource))>
				</cfif>
				
				<cfif not fileExists(resource)>
					<cfthrow message="The file #resource# does not exist!"
							detail="You have tried to use or include a file (#resource#) that does not exist using either absolute, relative, or mapped paths." />
				</cfif>

				<cfset findImports(arguments.importFiles,resource)>
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="shrinkFullRelativePath" access="public" output="false" returntype="string">
		<cfargument name="fullPath" type="string" required="true" />
		
		<cfset var newPath = 0>
		<cfset var i = 0>
		<cfset var h = 0>
		<cfset var hits = arrayNew(1)>
		<cfset var offset = 0>
		<cfset var retVal = "">
		<cfset var depth = 0>
	
		<cfset arguments.fullPath = replace(arguments.fullPath,"\","/","all")>
		<cfset arguments.fullPath = replace(arguments.fullPath,"/./","/","all")>
		<cfset newPath = listToArray(arguments.fullPath,"/")>
	
		<cfloop from="1" to="#arrayLen(newPath)#" index="i">
			<cfif newPath[i] IS "..">
				<cfset arrayAppend(hits,i)>
			<cfelseif i LT arrayLen(newPath)>
				<cfset depth = depth+1>
			</cfif>
		</cfloop>
		<cfif arrayLen(hits) GT depth>
			<cfthrow message="The relative path specified is requesting more levels than are available in the directory structure."
					detail="You are trying to use a relative path containing #arrayLen(hits)# levels of nested directories but there are only #depth# levels available." />
		</cfif>
		<cfloop from="1" to="#arrayLen(hits)#" index="h">
			<cfset arrayDeleteAt(newPath,hits[h]-offset)>
			<cfset arrayDeleteAt(newPath,hits[h]-(offset+1))>
			<cfset offset = offset+2>
		</cfloop>
		<cfif left(arguments.fullPath,1) is "/">
			<cfset retVal = "/" & arrayToList(newPath,"/")>
		<cfelse>
			<cfset retVal = arrayToList(newPath,"/")>
		</cfif>
		<cfif right(arguments.fullPath,1) is "/">
			<cfset retVal = retVal & "/">
		</cfif>
		
		<cfif not directoryExists(getDirectoryFrompath(retVal))>
			<cfthrow message="You have specified an invalid directory"
					detail="The directory path specified, #getDirectoryFromPath(retVal)# does not exist." />
		</cfif>
		 
		<cfreturn retVal />
	</cffunction>

	<cffunction name="loadBeansFromXmlFile" returntype="void" access="public" hint="loads bean definitions into the bean factory from an xml file location">
		<cfargument name="beanDefinitionFile" type="string" required="true" hint="I am the location of the bean definition xml file"/>
	
		<cfset var xmlFiles = structNew()/>

		<cfset findImports(xmlFiles,arguments.beanDefinitionFile)>
		
		<cfset processLoadBeans(xmlFiles)>				
	</cffunction>
				
	<cffunction name="loadBeansFromXmlRaw" returntype="void" access="public" hint="loads bean definitions into the bean factory from supplied raw xml">
		<cfargument name="beanDefinitionXml" type="string" required="true" hint="I am raw unparsed xml bean defs"/>
		
		<cfset var xmlParsed = xmlParse(arguments.beanDefinitionXml)>
		
		<cfset loadBeansFromXmlObj(xmlParsed)>
	</cffunction>

	<cffunction name="loadBeansFromXmlObj" returntype="void" access="public" hint="loads bean definitions into the bean factory from supplied cf xml object">
		<cfargument name="beanDefinitionXmlObj" type="any" required="true" hint="I am parsed xml bean defs"/>
		
		<cfset var xmlFiles = structNew()>


		<cfset findImportsFromXmlObj(xmlFiles, arguments.beanDefinitionXmlObj)>
		
		<cfset processLoadBeans(xmlFiles)>
	</cffunction>

	<cffunction name="processLoadBeans" access="private" returntype="void" hint="perfoms the loadBeanDefinations, processFactoryPostProcessors and initNonLazyBeans">
		<cfargument name="beanDefinitions" type="struct" required="true" hint="I am a structure containing the beans definition"/>
		<cfargument name="ConstructNonLazyBeans" type="boolean" required="false" default="false" hint="set me to true to construct any beans, not marked as lazy-init, immediately after processing"/>

		<cfset var i = ""/>
		
		<cfloop collection="#arguments.beanDefinitions#" item="i">
			<cfset loadBeanDefinitions(arguments.beanDefinitions[i])/>
		</cfloop>		
		
		<cfset processFactoryPostProcessors() />
		
		<cfset initNonLazyBeans()/>
	</cffunction>
		
	<cffunction name="loadBeanDefinitions" access="public" returntype="void"
				hint="actually loads the bean definitions by processing the supplied xml data">
		<cfargument name="XmlBeanDefinitions" type="any" required="true" 
					hint="I am a parsed Xml of bean definitions"/>
					
		<cfset var beans = 0 />
		<cfset var beanDef = 0 />
		<cfset var beanIx = 0 />
		<cfset var initMethod = "" />
		<cfset var beanAttributes = 0 />
		<cfset var beanChildren = 0 />
		<cfset var class = "" />
		<cfset var isSingleton = true />
		<cfset var lazyInit = true />
		<cfset var default_lazyInit = "true" />	
		<cfset var factoryBean = "" />
		<cfset var factoryMethod = "" />
		<cfset var autowire = "no" />
		<cfset var default_autowire = "no" />	
		<cfset var factoryPostProcessor = "" />	
		<cfset var beanPostProcessor = "" />	
		<cfset var aliases = 0 />
		<cfset var aliasIx = 0 />
		<cfset var aliasAttributes = 0 />
		<cfset var abstract = false />
		<cfset var parent = "" />
		<cfset var beanMetadata = ""/>
		
		<!--- make sure at least the root beans element exists --->
		<cfif not isDefined("arguments.XmlBeanDefinitions.beans")>
			<cfreturn/>
		</cfif>
		
		<!--- see if default-autowire is set to anything --->
		<cfif structKeyExists(arguments.XmlBeanDefinitions.beans,'XmlAttributes')
			and structKeyExists(arguments.XmlBeanDefinitions.beans.XmlAttributes,'default-autowire')
			and listFind('byName,byType',arguments.XmlBeanDefinitions.beans.XmlAttributes['default-autowire'])>
			<cfset default_autowire = arguments.XmlBeanDefinitions.beans.XmlAttributes['default-autowire']/>			
		</cfif>
		
		<!--- see if default-lazy-init is set to anything --->
		<cfif structKeyExists(arguments.XmlBeanDefinitions.beans,'XmlAttributes')
			and structKeyExists(arguments.XmlBeanDefinitions.beans.XmlAttributes,'default-lazy-init')>
			<cfset default_lazyInit = arguments.XmlBeanDefinitions.beans.XmlAttributes['default-lazy-init']/>			
		</cfif>
		
		<!--- check for beans, if there are none, we'll process aliases later --->
		<cfif isDefined("arguments.XmlBeanDefinitions.beans.bean")>
			<cfset beans = arguments.XmlBeanDefinitions.beans.bean>
		
			<!--- create bean definition objects for each (top level) bean in the xml--->
			<cfloop from="1" to="#ArrayLen(beans)#" index="beanIx">
				
				<cfset beanAttributes = beans[beanIx].XmlAttributes />
				<cfset beanChildren = beans[beanIx].XmlChildren />
				
				<cfif 
					NOT 
						StructKeyExists(beanAttributes, "factory-bean") 
					AND 
					(NOT 
						(StructKeyExists(beanAttributes,'id') 
						AND 
							(StructKeyExists(beanAttributes,'class') 
							OR 
							StructKeyExists(beanAttributes,'parent')
							OR
								(StructKeyExists(beanAttributes, 'abstract')
								AND
								beanAttributes.abstract
								)
							)
						)
					)>
					<cfthrow type="coldspring.MalformedBeanException" 
						message="Bean ID '#beanAttributes.id#': Xml bean definitions must contain 'id' and 'class' attributes!">
				</cfif>
				
				<!--- set the class (it will be blank if we are using parent) --->			
				<cfif StructKeyExists(beanAttributes,'class')>
					<cfset class = beanAttributes.class />
				<cfelse>
					<cfset class = "" />
				</cfif>
				
				<!--- look for an singleton attribute for this bean def --->			
				<cfif StructKeyExists(beanAttributes,'singleton')>
					<cfset isSingleton = beanAttributes.singleton />
				<cfelse>
					<cfset isSingleton = true />
				</cfif>
				
				<!--- look for lazy-init for this bean def --->
				<cfif StructKeyExists(beanAttributes,'lazy-init')>
					<cfset lazyInit = beanAttributes["lazy-init"] />
				<cfelse>
					<cfset lazyInit = default_lazyInit/>
				</cfif>
				
				<!--- look for an factory-bean and factory-method attribute for this bean def --->			
				<cfif StructKeyExists(beanAttributes,'factory-bean')>
					<cfset factoryBean = beanAttributes["factory-bean"] />
				<cfelse>
					<cfset factoryBean = "" />
				</cfif>
				<cfif StructKeyExists(beanAttributes,'factory-method')>
					<cfset factoryMethod = beanAttributes["factory-method"] />
				<cfelse>
					<cfset factoryMethod = "" />
				</cfif>
				
				<!--- look for an init-method attribute for this bean def --->
				<cfif StructKeyExists(beanAttributes,'init-method') and len(beanAttributes['init-method'])>
					<cfset initMethod = beanAttributes['init-method'] />
				<cfelse>
					<cfset initMethod = ""/>
				</cfif>
				
				<!--- first set autowire to default-autowire --->
				<cfset autowire = default_autowire />
				
				<!--- look for an autowire attribute for this bean def --->
				<cfif StructKeyExists(beanAttributes,'autowire') and listFind('byName,byType',beanAttributes['autowire'])>
					<cfset autowire = beanAttributes['autowire'] />
				</cfif>
				
				<!---  todo: CF8 only feature!! 
				<cfif StructKeyExists(beanAttributes,'class')>
					<cfset beanMetadata = getComponentMetadata(beanAttributes.class)>
					<cfif StructKeyExists(beanMetadata,"interface")>
						<cfif ListFindNoCase(beanMetadata, "coldspring.beans.factory.config.BeanFactoryPostProcessor")>
							<cfset factoryPostProcessor = true />
						</cfif>
						<cfif ListFindNoCase(beanMetadata, "coldspring.beans.factory.config.BeanPostProcessor")>
							<cfset beanPostProcessor = true />
						</cfif>
					</cfif>
				</cfif> --->
				
				<!--- look for a factory-post-processor attribute for this bean def --->
				<cfif StructKeyExists(beanAttributes,'class') and listFind(variables.known_bf_postprocessors,beanAttributes.class)>
					<cfset factoryPostProcessor = true />
				<cfelseif StructKeyExists(beanAttributes,'factory-post-processor') and len(beanAttributes['factory-post-processor'])>
					<cfset factoryPostProcessor = beanAttributes['factory-post-processor'] />
				<cfelse>
					<cfset factoryPostProcessor = false />
				</cfif>
				
				<!--- look for a bean-post-processor attribute for this bean def --->
				<cfif StructKeyExists(beanAttributes,'class') and listFind(variables.known_bean_postprocessors,beanAttributes.class)>
					<cfset beanPostProcessor = true />
				<cfelseif StructKeyExists(beanAttributes,'bean-post-processor') and len(beanAttributes['bean-post-processor'])>
					<cfset beanPostProcessor = beanAttributes['bean-post-processor'] />
				<cfelse>
					<cfset beanPostProcessor = false />
				</cfif>
				
				<!--- look for abstract flag, and parent bean def --->			
				<cfif StructKeyExists(beanAttributes,'abstract')>
					<cfset abstract = beanAttributes.abstract />
				<cfelse>
					<cfset abstract = false />
				</cfif>
				
				<cfif StructKeyExists(beanAttributes,'parent')>
					<cfset parent = beanAttributes.parent />
				<cfelse>
					<cfset parent = ""/>
				</cfif>
				
				<!--- call function to create bean definition and add to store --->
				<cfif not structKeyExists(beanAttributes, "factory-bean")> 
					<cfset createBeanDefinition(beanAttributes.id, 
											class, 
											beanChildren, 
											isSingleton, 
											false,
											lazyInit,
											initMethod,
											factoryBean, 
											factoryMethod,
											autowire,
											factoryPostProcessor,
											beanPostProcessor,
											abstract,
											parent) />
				<cfelse>
					<cfset createBeanDefinition(beanAttributes.id, 
											"", 
											beanChildren, 
											isSingleton, 
											false,
											lazyInit,
											initMethod,
											factoryBean, 
											factoryMethod,
											autowire,
											false,
											false,
											abstract,
											parent) />
				</cfif>
			
			</cfloop>
		</cfif>
		
		<!--- now register aliases --->
		<cfif isDefined("arguments.XmlBeanDefinitions.beans.alias")>
			<cfset aliases = arguments.XmlBeanDefinitions.beans.alias>
			
			<!--- create bean definition objects for each (top level) bean in the xml--->
			<cfloop from="1" to="#ArrayLen(aliases)#" index="aliasIx">
				
				<cfset aliasAttributes = aliases[aliasIx].XmlAttributes />
				
				<cfif not (StructKeyExists(aliasAttributes,'name') and StructKeyExists(aliasAttributes,'alias'))>
					<cfthrow type="coldspring.MalformedAliasException" 
						message="Xml alias definitions must contain 'name' and 'alias' attributes!">
				</cfif>
				
				<cfset registerAlias(aliasAttributes.name, aliasAttributes.alias)>
			</cfloop>
		</cfif>
		
	</cffunction>
	
	<cffunction name="createBeanDefinition" access="public" returntype="void" output="false"
				hint="creates a bean definition within this bean factory.">
		<cfargument name="beanID" type="string" required="true" />
		<cfargument name="beanClass" type="string" required="true" />
		<cfargument name="children" type="any" required="true" />
		<cfargument name="isSingleton" type="boolean" required="true" />
		<cfargument name="isInnerBean" type="boolean" required="true" />
		<cfargument name="isLazyInit" type="boolean" default="false" required="false" />
		<cfargument name="initMethod" type="string" default="" required="false" />
		<cfargument name="factoryBean" type="string" default="" required="false" />
		<cfargument name="factoryMethod" type="string" default="" required="false" />
		<cfargument name="autowire" type="string" default="no" required="false" />
		<cfargument name="factoryPostProcessor" type="boolean" default="false" required="false" />
		<cfargument name="beanPostProcessor" type="boolean" default="false" required="false" />
		<cfargument name="abstract" type="boolean" default="false" required="false" />
		<cfargument name="parent" type="string" default="" required="false" />
		
		<cfset var childIx = 0 />
		<cfset var child = '' />
	
		<!--- construct a bean definition file for this bean --->
		<cfset variables.beanDefs[arguments.beanID] = 
				   	CreateObject('component', 'coldspring.beans.BeanDefinition').init(this) />
		
		<cfset variables.beanDefs[arguments.beanID].setBeanID(arguments.beanID) />
		<cfset variables.beanDefs[arguments.beanID].setBeanClass(arguments.beanClass) />
		<cfset variables.beanDefs[arguments.beanID].setSingleton(arguments.isSingleton) />
		<cfset variables.beanDefs[arguments.beanID].setInnerBean(arguments.isInnerBean) />
		<cfset variables.beanDefs[arguments.beanID].setLazyInit(arguments.isLazyInit) />
		<cfset variables.beanDefs[arguments.beanID].setFactoryBean(arguments.factoryBean) />
		<cfset variables.beanDefs[arguments.beanID].setFactoryMethod(arguments.factoryMethod) />
		<cfset variables.beanDefs[arguments.beanID].setAutowire(arguments.autowire) />
		<cfset variables.beanDefs[arguments.beanID].setFactoryPostProcessor(arguments.factoryPostProcessor) />
		<cfset variables.beanDefs[arguments.beanID].setBeanPostProcessor(arguments.beanPostProcessor) />
		<cfset variables.beanDefs[arguments.beanID].setAbstract(arguments.abstract) />
		
		<cfif len(arguments.parent)>
			<cfset variables.beanDefs[arguments.beanID].setParent(arguments.parent) />
		</cfif>
		
		<cfif len(arguments.initMethod)>
			<cfset variables.beanDefs[arguments.beanID].setInitMethod(arguments.initMethod) />		
		</cfif>
		
		<!--- add properties/constructor-args to this beanDefinition 
			  each property/constructor arg is responsible for its own configuration--->
		<cfloop from="1" to="#ArrayLen(arguments.children)#" index="childIx">
			<cfset child = arguments.children[childIx] />
			<cfif child.XmlName eq "property">
				<cfset variables.beanDefs[arguments.beanID].addProperty(createObject("component","coldspring.beans.BeanProperty").init(child, variables.beanDefs[arguments.beanID]))/>
			</cfif>
			<cfif child.XmlName eq "constructor-arg">
				<cfset variables.beanDefs[arguments.beanID].addConstructorArg(createObject("component","coldspring.beans.BeanProperty").init(child, variables.beanDefs[arguments.beanID]))/>
			</cfif>			
		</cfloop>
		
	</cffunction>
	

	<cffunction name="localFactoryContainsBean" access="public" output="false" returntype="boolean"
				hint="returns true if the BeanFactory contains a bean definition or bean instance that matches the given name">
		<cfargument name="beanName" required="true" type="string" hint="name of bean to look for"/>
		<cfreturn structKeyExists(variables.beanDefs, arguments.beanName)/>
	</cffunction>
	

	<cffunction name="containsBean" access="public" output="false" returntype="boolean"
				hint="returns true if the BeanFactory contains a bean definition or bean instance that matches the given name">
		<cfargument name="beanName" required="true" type="string" hint="name of bean to look for"/>
		<!--- the supplied 'beanName' could be an alias, so we want to resolve that to the concrete name first --->
		<cfset var resolvedName = resolveBeanName(arguments.beanName) />
		<cfif structKeyExists(variables.beanDefs, resolvedName)>
			<cfreturn true />
		<cfelse>
			<cfif isObject(variables.parent)>
				<cfreturn variables.parent.containsBean(resolvedName)>
			<cfelse>
				<cfreturn false />
			</cfif>
		</cfif>
		
	</cffunction>
	
	<!---
	AUTOWIRE HELPERS
	--->
	<cffunction name="findBeanNameByType" access="public" returntype="string" output="false"
		hint="Finds the name of the first bean that matches the specified type in the bean factory. Returns '' if no match is found.">
		<cfargument name="typeName" type="string" required="true" 
			hint="Type of bean to find in the bean factory."/>
		<cfargument name="checkParent" type="boolean" required="false" default="true"
			hint="Boolean to indicate whether or not to check parent. Defaults to 'true'." />

		<cfset var bean = "" />
		<cfset var key = "" />

		<!--- Loop through the local factory --->
		<cfloop collection="#variables.beanDefs#" item="key">
			<cfif variables.beanDefs[key].getBeanClass() EQ arguments.typeName
				AND NOT variables.beanDefs[key].isInnerBean()>
				<cfset bean = key />
				<cfbreak />
			</cfif>
		</cfloop>

		<!--- Check the parent factory if available and no bean found yet --->
		<cfif NOT Len(bean) AND IsObject(variables.parent) AND arguments.checkParent>
			<cfset bean = variables.parent.findBeanNameByType(arguments.typeName) />
		</cfif>
		
		<cfreturn bean />
	</cffunction>
	
	<cffunction name="findAllBeanNamesByType" access="public" returntype="array" output="false"
		hint="Finds the all the names of the bean that match the specified type in the bean factory.">
		<cfargument name="typeName" type="string" required="true" 
			hint="Type of bean to find in the bean factory."/>
		<cfargument name="checkParent" type="boolean" required="false" default="true"
			hint="Boolean to indicate whether or not to check parent. Defaults to 'true'." />

		<cfset var beans = ArrayNew(1) />
		<cfset var parentBeans = ArrayNew(1) />
		<cfset var key = "" />
		<cfset var i = 0 />

		<!--- Loop through the local factory --->
		<cfloop collection="#variables.beanDefs#" item="key">
			<cfif variables.beanDefs[key].getBeanClass() EQ arguments.typeName
				AND NOT variables.beanDefs[key].isInnerBean()>
				<cfset ArrayAppend(beans, key) />
			</cfif>
		</cfloop>

		<!--- Check the parent factory if available --->
		<cfif IsObject(variables.parent) AND arguments.checkParent>
			<cfset parentBeans = variables.parent.findBeanNameByType(arguments.typeName) />
			
			<!--- Merg the parent bean names array into the local names --->
			<cfloop from="1" to="#ArrayLen(parentBeans)#" index="i">
				<cfset ArrayAppend(beans, parentBeans[i]) />
			</cfloop>
		</cfif>
		
		<cfreturn beans />
	</cffunction>
	
	<!--- DEPRECIATED?? IS THIS METHOD USED EVER??? --->
	<cffunction name="isSingleton" access="public" returntype="boolean" output="false"
				hint="returns whether the bean with the specified name is a singleton">
		<cfargument name="beanName" type="string" required="true" hint="the bean name to look for"/>
		<cfif localFactoryContainsBean(arguments.beanName)>
			<cfreturn variables.beanDefs[arguments.beanName].isSingleton() />
		<cfelseif isObject(variables.parent) AND variables.parent.localFactoryContainsBean(arguments.beanName)>
			<cfreturn variables.parent.isSingleton(arguments.beanName)>
		<cfelse>
			<cfthrow type="coldspring.NoSuchBeanDefinitionException" detail="Bean definition for bean named: #arguments.beanName# could not be found."/>
		</cfif>
	</cffunction>
	
	<cffunction name="getBean" access="public" output="false" returntype="any" 
				hint="returns an instance of the bean registered under the given name. Depending on how the bean was configured, either a singleton and thus shared instance or a newly created bean will be returned. A BeansException will be thrown when either the bean could not be found (in which case it'll be a NoSuchBeanDefinitionException), or an exception occurred while instantiating and preparing the bean">
		<cfargument name="beanName" required="true" type="string" hint="name of bean to look for"/>
		<cfset var returnFactory = Left(arguments.beanName,1) IS '&'>
		<cfset var resolvedName = "" />
		<cfset var beanDef = 0 />
		<cfset var bean = 0 />
		
		<cfif returnFactory>
			<cfset arguments.beanName = Right(arguments.beanName,Len(arguments.beanName)-1) />
		</cfif>
		<!--- the supplied 'beanName' could be an alias, so we want to resolve that to the concrete name first --->
		<cfset resolvedName = resolveBeanName(arguments.beanName) />
		
		<cfif localFactoryContainsBean(resolvedName)>
			<!--- now get the merged bean definition (this all would be better if we could circumvent this by directly 
				  checking the cache first) all instances of variables.beanDefs[resolvedName] changed to beanDef --->
			<cfset beanDef = getMergedBeanDefinition(resolvedName)/>
			<cfif beanDef.isAbstract()>
				<cfthrow type="coldspring.BeanCreationException" 
						 detail="Abstract Beans cannot be instanciated. Did you really meen to define: #resolvedName# as 'Abstract'?"/>
			</cfif>
			
			<!--- moving the lock out so a second thread will wait for a constructed bean --->
				
			<!--- BEGIN CUSTOM --->
			<cfif beanDef.isSingleton()>
				<cflock name="bf_#variables.beanFactoryId#.bean_#resolvedName#" throwontimeout="true" timeout="60">
					<cfif not beanDef.isConstructed()>
						<!--- lazy-init happens here --->
						<cfset constructBean(resolvedName)/>
					</cfif>
					<cfset bean =  beanDef.getInstance(returnFactory) />
				</cflock>
			<cfelse>
				<cfset bean = constructBean(resolvedName,true)/>
			</cfif>
			<!--- END CUSTOM --->
				
			<cfreturn bean />
			
		<cfelseif isObject(variables.parent)> <!--- AND variables.parent.containsBean(arguments.beanName)> --->
			<cfreturn variables.parent.getBean(resolvedName)>			
		<cfelse>
			<cfthrow type="coldspring.NoSuchBeanDefinitionException" detail="Bean definition for bean named: #resolvedName# could not be found."/>
		</cfif>		
		
	</cffunction>	
	
	<cffunction name="processFactoryPostProcessors" access="private" output="false" returntype="void"
				hint="constructs and calls postProcessBeanFactory(this) for all factory post processor beans">
		
		<cfset var beanName = "" />
		<cfset var bean = 0 />
					
		<cfloop collection="#variables.beanDefs#" item="beanName">
			<cfif variables.beanDefs[beanName].isFactoryPostProcessor() >
				<cfset bean = getBean(beanName) />
				<cftry>
					<cfset bean.setBeanID(bean) />
					<cfcatch></cfcatch>
				</cftry>
				<cfset bean.postProcessBeanFactory(this) />
			</cfif>
		</cfloop>
		
	</cffunction>	
	
	
	<cffunction name="initNonLazyBeans" access="private" output="false" returntype="void"
				hint="constructs all non-lazy beans">
				
		<cfset var beanName = "" />
		<cfset var bean = 0 />
		<!--- <cfset var sys = CreateObject('java','java.lang.System') /> --->
					
		<cfloop collection="#variables.beanDefs#" item="beanName">
			<cfif variables.beanDefs[beanName].isSingleton() 
				  and not variables.beanDefs[beanName].isLazyInit() 
				  and not variables.beanDefs[beanName].isConstructed() 
				  and not variables.beanDefs[beanName].isInnerBean() 
				  and not variables.beanDefs[beanName].isFactory()>
				<cfset bean = getBean(beanName) />
				<!--- <cfset sys.out.println("NON_LAZY LOADING BEAN: " & beanName & " ON FACTORY LOAD!!") /> --->
			</cfif>
		</cfloop>
		
	</cffunction>	
	
	<cffunction name="constructBean" access="private" returntype="any">
		<cfargument name="beanName" type="string" required="true"/>
		<cfargument name="returnInstance" type="boolean" required="false" default="false" 
					hint="true when constructing a non-singleton bean (aka a prototype)"/>
					
		<cfset var localBeanCache = StructNew() />
		<cfset var dependentBeanDefs = ArrayNew(1) />
		<!--- first get list of beans including this bean and it's dependencies
		<cfset var dependentBeanNames = getMergedBeanDefinition(arguments.beanName).getDependencies(arguments.beanName) /> --->
		<cfset var beanDefIx = 0 />
		<cfset var beanDef = 0 />
		<cfset var beanInstance = 0 />
		<cfset var dependentBeanDef = 0 />
		<cfset var dependentBeanInstance = 0 />
		<cfset var propDefs = 0 />
		<cfset var propType = 0 />
		<cfset var prop = 0/>
		<cfset var argDefs = 0 />
		<cfset var argType = "" />
		<cfset var arg = 0/>
		<cfset var md = '' />
		<cfset var functionIndex = '' />
		<!--- new, for faster factoryBean lookup --->
		<cfset var searchMd = '' />
		<cfset var instanceType = '' />
		<cfset var factoryBeanDef = '' />
		<cfset var factoryBean = 0>
		
		<cfset var dependentBeanNames = "" />
		<cfset var dependentBeans = StructNew() />
		
		<cfset var mergedBeanDefinition = getMergedBeanDefinition(arguments.beanName) />
		
		<!--- <cfif mergedBeanDefinition.dependenciesChecked()>
			<cfset dependentBeans = mergedBeanDefinition.getDependentBeans()>
		<cfelse>
		</cfif> --->
		<cfset dependentBeans.allBeans = arguments.beanName />
		<cfset dependentBeans.orderedBeans = "" />
		<cfset mergedBeanDefinition.getDependencies(dependentBeans) />
			
		<cfset dependentBeanNames = ListPrepend(dependentBeans.orderedBeans, arguments.beanName) />
		
		<!--- DEBUGGING DEP LIST
		DEPENDECY LIST:<BR/>
		<cfdump var="#dependentBeanNames#" label="DEPENDENCY LIST"/><cfabort/> --->
		
		<!--- put them all in an array, and while we're at it, make sure they're in the singleton cache, or the localbean cache --->
		
		<cfloop from="1" to="#ListLen(dependentBeanNames)#" index="beanDefIx">
			<cfset beanDef = getMergedBeanDefinition(ListGetAt(dependentBeanNames,beanDefIx)) />
			<cfset ArrayAppend(dependentBeanDefs,beanDef) />
			
			<cfif beanDef.getFactoryBean() eq "">
				<!--- Factory beans are a special situation, and we actually don't want to create them in this way, because
					their constructor args may be dependencies, so we will create them in the NEXT loop, along with
					init methods --->
				<cfif beanDef.isAbstract()>
					<cfthrow type="coldspring.BeanCreationException" 
							 detail="Abstract Beans cannot be instanciated. Did you really meen to define: #beanDef.getBeanID()# as 'Abstract'?"/>
				</cfif>
				
				<!--- there are only two places where we check then create objects in the singletone cache, we need to 
					  introduce a mutually exclusive lock around this --->
				<!--- BEGIN CUSTOM --->
				<cfif beanDef.isSingleton()>
					<cflock name="bf_#variables.beanFactoryId#.bean_#beanDef.getBeanID()#" throwontimeout="true" timeout="10">
						<cfif not(singletonCacheContainsBean(beanDef.getBeanID()))>
							<cfset beanDef.getBeanFactory().addBeanToSingletonCache(beanDef.getBeanID(), beanDef.getBeanInstance() ) />
						<cfelse>
							<cfset localBeanCache[beanDef.getBeanID()] = beanDef.getBeanInstance() />
						</cfif>
					</cflock>
				<cfelse>
					<cfset localBeanCache[beanDef.getBeanID()] = beanDef.getBeanInstance() />
				</cfif>
				<!--- END CUSTOM --->
			</cfif>
		</cfloop>
	
		<!--- now resolve all dependencies by looping through list backwards, causing the "most dependent" beans to get created first  --->
		<cfloop from="#ArrayLen(dependentBeanDefs)#" to="1" index="beanDefIx" step="-1">
			<cfset beanDef = dependentBeanDefs[beanDefIx] />
			
			<!--- this is the second place we need to lock --->
			<cflock name="bf_#variables.beanFactoryId#.bean_#beanDef.getBeanID()#" throwontimeout="true" timeout="10">
				
				<cfif not beanDef.isConstructed()>
				
					<cfset argDefs = beanDef.getConstructorArgs()/>
					<cfset propDefs = beanDef.getProperties()/>
					
					<!--- if this is a 'normal' bean, we can just get the created reference
						but if it's a factory bean, we have to create it now --->
					<cfif beanDef.getFactoryBean() eq "">
					
						<cfif beanDef.isSingleton()>
							<cfset beanInstance = getBeanFromSingletonCache(beanDef.getBeanID())>
						<cfelse>
							<cfset beanInstance = localBeanCache[beanDef.getBeanID()] />
						</cfif>
						
						<!--- make sure the beanInstance is an object if we are gonna look at it
							  (beanInstance could be anything)  --->
						<cfif isCFC(beanInstance)>
							<cfset md = flattenMetaData(getMetaData(beanInstance))/>
						<cfelse>
							<cfset md = structnew()/>
							<cfset md.name = ""/>
						</cfif>
		
						
					<cfelse>
						
						<!--- retrieve the factoryBeanDef, then the factory bean --->
						<cfset factoryBeanDef = getMergedBeanDefinition(beanDef.getFactoryBean()) />
						
						<cfif factoryBeanDef.isAbstract()>
							<cfthrow type="coldspring.BeanCreationException" 
									 detail="Abstract Beans cannot be instanciated. Did you really meen to define: #beanDef.getBeanID()# as 'Abstract'?"/>
						</cfif>
						
						<cfif factoryBeanDef.isSingleton()>
							<cfset factoryBean = factoryBeanDef.getInstance() />
						<cfelse>
							<cfif factoryBeanDef.isFactory()>
								<cfset factoryBean = localBeanCache[factoryBeanDef.getBeanID()].getObject() />
							<cfelse>
								<cfset factoryBean = localBeanCache[factoryBeanDef.getBeanID()] />
							</cfif>
						</cfif>
						
						<cftry>
							<!--- now call the 'constructor' to generate the bean, which is the factoryMethod --->
							<cfinvoke component="#factoryBean#" method="#beanDef.getFactoryMethod()#" 
								returnvariable="beanInstance">
								<!--- loop over constructor-args and pass them into the factoryMethod --->
								<cfloop collection="#argDefs#" item="arg">
									<cfset argType = argDefs[arg].getType() />
									<cfif argType eq "value">
										<cfinvokeargument name="#argDefs[arg].getArgumentName()#" value="#argDefs[arg].getValue()#"/>
									<cfelseif argType eq "list" or argType eq "map">
										<cfinvokeargument name="#argDefs[arg].getArgumentName()#" value="#constructComplexProperty(argDefs[arg].getValue(),argDefs[arg].getType(), localBeanCache)#"/>
									<cfelseif argType eq "ref" or argType eq "bean">
										<cfset dependentBeanDef = getMergedBeanDefinition(argDefs[arg].getValue()) />
											<cfif dependentBeanDef.isSingleton()>
												<cfset dependentBeanInstance = dependentBeanDef.getInstance() />
											<cfelse>
												<cfif dependentBeanDef.isFactory()>
													<cfset dependentBeanInstance = localBeanCache[dependentBeanDef.getBeanID()].getObject() />
												<cfelse>
													<cfset dependentBeanInstance = localBeanCache[dependentBeanDef.getBeanID()] />
												</cfif>
											</cfif>
											<cfinvokeargument name="#argDefs[arg].getArgumentName()#" value="#dependentBeanInstance#"/>
									</cfif>	  								
								</cfloop>
							</cfinvoke>
							<cfcatch type="any">
								<cfthrow type="coldspring.beanCreationException" 
									message="Bean creation exception during factory-method call (trying to call #beanDef.getFactoryMethod()# on #factoryBeanDef.getBeanClass()#)" 
									detail="#cfcatch.message#:#cfcatch.detail#">							
							</cfcatch>						
						</cftry>					
						<!--- since we skipped factory beans in the bean creation loop, we need to store a reference to the bean now --->
						<cfif beanDef.isSingleton() and not(singletonCacheContainsBean(beanDef.getBeanID()))>
							<cfset beanDef.getBeanFactory().addBeanToSingletonCache(beanDef.getBeanID(), beanInstance ) />
						<cfelse>
							<cfset localBeanCache[beanDef.getBeanID()] = beanInstance /> 
						</cfif>
						<!--- make sure the beanInstance is an object if we are gonna look at it
							  (beanInstance could be anything returned from a factory-method call)  --->
						<cfif isCFC(beanInstance)>
							<cfset md = flattenMetaData(getMetaData(beanInstance))/>
						<cfelse>
							<cfset md = structnew()/>
							<cfset md.name = ""/>
						</cfif>
					</cfif>
					
					<cfif structKeyExists(md, "functions")>
						<!--- we need to call init method if it exists --->
						<cfloop from="1" to="#arraylen(md.functions)#" index="functionIndex">
							<cfif md.functions[functionIndex].name eq "init"
									and beanDef.getFactoryBean() eq "">
								
								<cftry>
								<cfinvoke component="#beanInstance#" method="init">
									<!--- loop over any bean constructor-args and pass them into the init() --->
									<cfloop collection="#argDefs#" item="arg">
										<cfset argType = argDefs[arg].getType() />
										<cfif argType eq "value">
											<cfinvokeargument name="#argDefs[arg].getArgumentName()#"
													    	  value="#argDefs[arg].getValue()#"/>
										<cfelseif argType eq "list" or argType eq "map">
											<cfinvokeargument name="#argDefs[arg].getArgumentName()#"
													    	  value="#constructComplexProperty(argDefs[arg].getValue(),argDefs[arg].getType(), localBeanCache)#"/>
										<cfelseif argType eq "ref" or argType eq "bean">
											<cfinvokeargument name="#argDefs[arg].getArgumentName()#"
															  value="#getBean(argDefs[arg].getValue())#"/>
										</cfif>			  								
									</cfloop>
								</cfinvoke>
								
								<cfcatch type="any">
									<cfthrow type="coldspring.beanCreationException" 
										message="Bean creation exception during init() of #beanDef.getBeanClass()#" 
										detail="#cfcatch.message#:#cfcatch.detail#">
								</cfcatch>
							</cftry>
							
							<cfelseif md.functions[functionIndex].name eq "setBeanFactory"
									  and arraylen(md.functions[functionIndex].parameters) eq 1
									  and structKeyExists(md.functions[functionIndex].parameters[1],"type")
									  and md.functions[functionIndex].parameters[1].type eq "coldspring.beans.BeanFactory">
								<!--- call setBeanFactory() if it exists and is a beanFactory --->
								<cfset beanInstance.setBeanFactory(beanDef.getBeanFactory()) />	
								
							</cfif>
						</cfloop>
					</cfif>				
					
					<!--- if this is a bean that extends the factory bean, set IsFactory, and give it a ref to the beanFactory --->
					<cfset searchMd = md />
					<cfif searchMd.name IS 'coldspring.aop.framework.RemoteFactoryBean'>
						<cfset beanInstance.setId(arguments.beanName) />
					</cfif>
					<cfif searchMd.name IS 'coldspring.aop.framework.ProxyFactoryBean'>
						<cfset beanDef.setIsProxyFactory(true) />
					</cfif>
					
					<cfloop condition="#StructKeyExists(searchMd,"extends")#">
						<cfset searchMd = searchMd.extends />
						<cfif searchMd.name IS 'coldspring.aop.framework.RemoteFactoryBean'>
							<cfset beanInstance.setId(arguments.beanName) />
						</cfif>
						<cfif searchMd.name IS 'coldspring.aop.framework.ProxyFactoryBean'>
							<cfset beanDef.setIsProxyFactory(true) />
						</cfif>
						<cfif searchMd.name IS 'coldspring.beans.factory.FactoryBean'>
							<cfset beanDef.setIsFactory(true) />
							<!--- SO, We did this already (duck typing, above)
							<cfset beanInstance.setBeanFactory(this) /> --->
							<cfbreak />
						</cfif>
					</cfloop>
			
					<!--- now do dependency injection via setters --->		
					<cfloop collection="#propDefs#" item="prop">
						<cfset propType = propDefs[prop].getType() />
						<cfif propType eq "value">
							<cfinvoke component="#beanInstance#"
									  method="set#propDefs[prop].getName()#">
								<cfinvokeargument name="#propDefs[prop].getArgumentName()#"
									  	value="#propDefs[prop].getValue()#"/>
							</cfinvoke>			
						<cfelseif propType eq "map" or propType eq "list">
							<cfinvoke component="#beanInstance#"
									  method="set#propDefs[prop].getName()#">
								<cfinvokeargument name="#propDefs[prop].getArgumentName()#"
									  	value="#constructComplexProperty(propDefs[prop].getValue(), propDefs[prop].getType(), localBeanCache)#"/>
							</cfinvoke>				
						<cfelseif propType eq "ref" or propType eq "bean">
							<cfset dependentBeanDef = getMergedBeanDefinition(propDefs[prop].getValue()) />
							<cfif dependentBeanDef.isSingleton()>
								<cfset dependentBeanInstance = dependentBeanDef.getInstance() />
							<cfelse>
								<cfif dependentBeanDef.isFactory()>
									<cfset dependentBeanInstance = localBeanCache[dependentBeanDef.getBeanID()].getObject() />
								<cfelse>
									<cfset dependentBeanInstance = localBeanCache[dependentBeanDef.getBeanID()] />
								</cfif>
							</cfif>
							
							<cfinvoke component="#beanInstance#"
									  method="set#propDefs[prop].getName()#">
								<cfinvokeargument name="#propDefs[prop].getArgumentName()#"
												  value="#dependentBeanInstance#"/>
							</cfinvoke>
						</cfif>
					</cfloop>
					
					<!--- in order to inject the proper advisors into the aop proxy factories, we should do this now, 
						  instead of letting them lookup their own objects --->
					<cfif beanDef.isProxyFactory()>
						<cfset beanInstance.buildAdvisorChain(localBeanCache) />
					</cfif>
						
					<cfif beanDef.isSingleton()>
						<cfset beanDef.setIsConstructed(true)/>
					</cfif>
					
				</cfif>
			
			</cflock>
		</cfloop>
		
		<!--- now loop again (same direction: backwards) for init-methods --->
		<cfloop from="#ArrayLen(dependentBeanDefs)#" to="1" index="beanDefIx" step="-1">
			<cfset beanDef = dependentBeanDefs[beanDefIx] />
			
			<cfif beanDef.isSingleton()>
				<cfset beanInstance = getBeanFromSingletonCache(beanDef.getBeanID())>
			<cfelse>
				<cfset beanInstance = localBeanCache[beanDef.getBeanID()] />
			</cfif>
			
			<!--- now call an init-method if it's defined --->
			<cfif beanDef.hasInitMethod() and not beanDef.getInitMethodWasCalled()>
								
				<cfinvoke component="#beanInstance#"
						  method="#beanDef.getInitMethod()#"/>
				
				<!--- make sure it only gets called once --->
				<cfset beanDef.setInitMethodWasCalled(true) />
						  
			</cfif>
			
		</cfloop>

		<!--- if we're supposed to return the new object, do it --->
		<cfif arguments.returnInstance>
			<cfif dependentBeanDefs[1].isSingleton()>
				<cfreturn getBeanFromSingletonCache(dependentBeanDefs[1].getBeanID())>
			<cfelse>
				<cfreturn localBeanCache[dependentBeanDefs[1].getBeanID()]>
			</cfif>	
		</cfif>	
		
	</cffunction>
	
	<cffunction name="constructComplexProperty" access="private" output="false" returntype="any"
				hint="recurses through properties/constructor-args that are complex, resolving dependencies along the way">
		<cfargument name="ComplexProperty" type="any" required="true"/>
		<cfargument name="type" type="string" required="true"/>
		<cfargument name="localBeanCache" type="struct" required="true"/>
		<cfset var rtn = 0 />	
		
		<cfif arguments.type eq 'map'>
			<!--- just return the struct because it's passed by ref --->
			<cfset findComplexPropertyRefs(arguments.ComplexProperty,arguments.type, arguments.localBeanCache)/> 
			<cfreturn arguments.ComplexProperty/>		
		<cfelseif arguments.type eq 'list'>
			<!--- tail recursion for the array (and return the result) --->			
			<cfreturn findComplexPropertyRefs(arguments.ComplexProperty,arguments.type, arguments.localBeanCache)/> 			
		</cfif>
		
		
	</cffunction>
	
	<cffunction name="findComplexPropertyRefs" access="private" output="false" returntype="any">
		<cfargument name="ComplexProperty" type="any" required="true"/>	
		<cfargument name="type" type="string" required="true"/>
		<cfargument name="localBeanCache" type="struct" required="true"/>
		<cfset var entry=0/>
		<cfset var tmp_ref=0/>
		<cfset var dependentBeanDef = "" />
		
		<!--- based on the the type of property/con-arg --->
		<cfswitch expression="#arguments.type#">
			<cfcase value="map">
				<cfloop collection="#arguments.ComplexProperty#" item="entry">
					<!--- loop thru the map (struct) --->			
					<cfif isObject(arguments.ComplexProperty[entry]) and getMetaData(arguments.ComplexProperty[entry]).name eq "coldspring.beans.BeanReference">
						<!--- this key's value is a beanReference, basically a placeholder that we replace
							  with the actual bean, right now --->
						<cfset dependentBeanDef = getMergedBeanDefinition(arguments.ComplexProperty[entry].getBeanID()) />
						<cfif dependentBeanDef.isSingleton()>
							<cfset arguments.ComplexProperty[entry] = getBeanFromSingletonCache(dependentBeanDef.getBeanID())>
						<cfelse>
							<cfset arguments.ComplexProperty[entry] = localBeanCache[dependentBeanDef.getBeanID()] />
						</cfif>						
					<cfelseif isStruct(arguments.ComplexProperty[entry])>
						<!--- ok, we found a map within this map, so recurse --->
						<cfset findComplexPropertyRefs(arguments.ComplexProperty[entry],"map",arguments.localBeanCache)/>
					<cfelseif isArray(arguments.ComplexProperty[entry])>
						<!--- ok, we found a list within this map, so recurse --->						
						<cfset arguments.ComplexProperty[entry] = findComplexPropertyRefs(arguments.ComplexProperty[entry],"list",arguments.localBeanCache)/>						
					</cfif>	
				</cfloop>	
			</cfcase>
			<cfcase value="list">
				<cfloop from="1" to="#arraylen(arguments.ComplexProperty)#" index="entry">
					<!--- loop thru the list (array) --->			
					<cfif isObject(arguments.ComplexProperty[entry]) and getMetaData(arguments.ComplexProperty[entry]).name eq "coldspring.beans.BeanReference">
						<!--- same as above, this key's value is a beanReference, basically a placeholder that we replace
							  with the actual bean, right now --->
						<cfset dependentBeanDef = getMergedBeanDefinition(arguments.ComplexProperty[entry].getBeanID()) />
						<cfif dependentBeanDef.isSingleton()>
							<cfset arguments.ComplexProperty[entry] = getBeanFromSingletonCache(dependentBeanDef.getBeanID())>
						<cfelse>
							<cfset arguments.ComplexProperty[entry] = localBeanCache[dependentBeanDef.getBeanID()] />
						</cfif>						
					<cfelseif isStruct(arguments.ComplexProperty[entry])>
						<!--- ok, we found a map within this list, so recurse --->
						<cfset findComplexPropertyRefs(arguments.ComplexProperty[entry],"map",arguments.localBeanCache)/>
					<cfelseif isArray(arguments.ComplexProperty[entry])>
						<!--- ok, we found a list within this list, so recurse --->
						<cfset arguments.ComplexProperty[entry] = findComplexPropertyRefs(arguments.ComplexProperty[entry],"list",arguments.localBeanCache)/>
					</cfif>	
				</cfloop>			
				<cfreturn arguments.ComplexProperty />
			</cfcase>
		</cfswitch>
		
	</cffunction>	
	
	<cffunction name="isCFC" access="public" returntype="boolean">
		<cfargument name="objectToCheck" type="any" required="true"/>
		
		<cfset var md = getMetaData(arguments.objectToCheck)/>
		<cfreturn isObject(arguments.objectToCheck) and structKeyExists(md,'type') and md.type eq 'component'/>
		
	</cffunction>
	
	<cffunction name="flattenMetaData" access="public" output="false" hint="takes metadata, copies inherited methods into the top level function array, and returns it" returntype="struct">
		<cfargument name="md" type="struct" required="true" />
		<cfset var i = "" />
		<cfset var flattenedMetaData = duplicate(arguments.md)/>
		<cfset var foundFunctions = ""/>
		<cfset var access = "" />
		
		<cfset flattenedMetaData.functions = arraynew(1)/>
		
		<cfloop condition="true">
			<cfif structKeyExists(arguments.md, "functions")>
				<cfloop from="1" to="#arrayLen(arguments.md.functions)#" index="i">
					<!--- get the access type, so we can skip private methods --->
					<cfif structKeyExists(arguments.md.functions[i],'access')>
						<cfset access = arguments.md.functions[i].access />
					<cfelse>
						<cfset access = 'public' />
					</cfif>
					<cfif not listFind(foundFunctions,arguments.md.functions[i].name)>
						<cfset foundFunctions = listAppend(foundFunctions,arguments.md.functions[i].name)/>
						<cfif access is not 'private'>
							<cfset arrayAppend(flattenedMetaData.functions,duplicate(arguments.md.functions[i]))/>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
			<cfif structKeyExists(arguments.md, "extends")>
				<cfset arguments.md = arguments.md.extends />
			<cfelse>
				<cfbreak />
			</cfif>
		</cfloop>
		<cfreturn flattenedMetaData/>
		
	</cffunction>	
	
	<cffunction name="getDefaultProperties" access="public" output="false" returntype="struct">
		<cfreturn variables.DefaultProperties/>
	</cffunction>

	<cffunction name="setDefaultProperties" access="public" output="false" returntype="void">
		<cfargument name="DefaultProperties" type="struct" required="true"/>
		<cfset variables.DefaultProperties = arguments.DefaultProperties/>
	</cffunction>
	
	<cffunction name="getDefaultAttributes" access="public" output="false" returntype="struct">
		<cfreturn variables.DefaultAttributes/>
	</cffunction>

	<cffunction name="setDefaultAttributes" access="public" output="false" returntype="void">
		<cfargument name="DefaultAttributes" type="struct" required="true"/>
		<cfset variables.DefaultAttributes = arguments.DefaultAttributes/>
	</cffunction>	
	

	<cffunction name="getDefaultValue" access="private">
		<cfargument name="attributeName" required="true" type="string"/>
		<cfargument name="attributeValue" required="true" type="any"/>
		
		<cfif arguments.attributeValue eq "default">
			<cfif structKeyExists(variables.defaultAttributes, arguments.attributeName)>
				<cfreturn variables.defaultAttributes[arguments.attributeName]/>		
			<cfelse>
				<cfswitch expression="#arguments.attributeName#">
					<cfcase value="autowire">
						<cfreturn "byName"/>
					</cfcase>
					<cfcase value="singleton">
						<cfreturn true/>
					</cfcase>					
					<cfdefaultcase>
						<cfreturn false/>					
					</cfdefaultcase>
				</cfswitch>
			</cfif>			
		<cfelse>
			<cfreturn arguments.attributeValue/>		
		</cfif>				
	</cffunction>


</cfcomponent>