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
		
			
 $Id: BeanDefinition.cfc,v 1.41 2008/04/14 01:30:25 scottc Exp $

--->

<cfcomponent name="BeanDefinition" 
			displayname="BeanDefinition" 
			hint="I model a single bean definition within a ColdSpring bean factory" 
			output="false">

	<cfset variables.instanceData = StructNew() />
	<!--- struct of all the constructor args for this bean definition: --->
	<cfset variables.instanceData.ConstructorArgs = StructNew() />
	<!--- struct of all the properties for this bean definition: --->	
	<cfset variables.instanceData.Properties = StructNew() />
	<!--- whether this bean is a singleton or a prototype: --->
	<cfset variables.instanceData.Singleton = true />
	<!--- whether this bean's instance has actually been constructed by the beanFactory:--->
	<cfset variables.instanceData.Constructed = false />
	<!--- whether this bean is a factory: --->	
	<cfset variables.instanceData.Factory = false />
	<!--- whether this bean is a proxy factory: --->	
	<cfset variables.instanceData.ProxyFactory = false />
	<!--- whether this bean is a factory bean: --->	
	<cfset variables.instanceData.isFactoryBean = false />
	<!--- whether this bean is an inner bean: --->
	<cfset variables.instanceData.InnerBean = false /> 
	<!--- name of an init-method to call on this bean once all dependencies are set: --->
	<cfset variables.instanceData.initMethod = ''/>
	<!--- if the init-method exists, whether it has been called --->
	<cfset variables.instanceData.initMethodWasCalled = false/>	
	
	<!--- whether this bean should be constructed imeediately upon the beanFactory receiving its definition
			OR should the factory wait until someone asks for the bean: --->
	<cfset variables.instanceData.lazyInit = true />
	<!--- list of known dependent beans (by name): --->	
	<cfset variables.instanceData.Dependencies = '' />
	<!--- factory bean to use to get this bean --->
	<cfset variables.instanceData.factoryBean = ''>
	<!--- factory method to use on the factory bean to get this bean --->
	<cfset variables.instanceData.factoryMethod = ''>
	<!--- autowire method, defaults to true (a string) --->
	<cfset variables.instanceData.autowire = 'no'>
	<!--- whether this bean is a factoryPostProcessor --->
	<cfset variables.instanceData.factoryPostProcessor = false/>
	<!--- whether this bean is a beanPostProcessor --->
	<cfset variables.instanceData.beanPostProcessor = false/>
	
	<!--- whether the dependencies have actually been checked already --->
	<cfset variables.instanceData.dependenciesChecked = false />
	<cfset variables.instanceData.dependentBeans = 0 />
	
	<!--- support for 'abstract' and 'parent' bean definitions --->	
	<cfset variables.instanceData.abstract = false>
	<cfset variables.instanceData.parent = ''>
	<cfset variables.instanceData.childDefinition = false>
	<cfset variables.instanceData.merged = false>
	
	
	<cffunction name="init" returntype="coldspring.beans.BeanDefinition" output="false"
				hint="Constructor. Creates a new Bean Definition.">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true" 
					hint="reference to the coldspring BeanFactory who is creating this bean definition."/>					
		<cfset setBeanFactory(arguments.beanFactory) />
		<cfreturn this/>	
	</cffunction>
	
	<cffunction name="initFromParent" returntype="coldspring.beans.BeanDefinition" output="false"
				hint="Constructor. Creates a new Bean Definition as a copy of a parent bean definition.">
		<cfargument name="parent" type="coldspring.beans.BeanDefinition" required="true" 
					hint="reference to a bean definition to copy this definition's properties from"/>	
		
		<cfset setBeanFactory(arguments.parent.getBeanFactory()) />									
		<cfset setBeanClass(arguments.parent.getBeanClass()) />				
		<cfset setAbstract(arguments.parent.isAbstract()) />	
					
		<cfset setConstructorArgs(arguments.parent.getConstructorArgs()) />				
		<cfset setProperties(arguments.parent.getProperties()) />				
		<cfset setDependenciesForCopy(arguments.parent.getDependenciesForCopy()) />	
					
		<cfset getBeanFactory(arguments.parent.getBeanFactory()) />			
		<cfset setSingleton(arguments.parent.isSingleton()) />	
		<cfset setLazyInit(arguments.parent.isLazyInit())> 
		<cfset setIsFactory(arguments.parent.isFactory()) /> 
		<cfset setIsProxyFactory(arguments.parent.isProxyFactory()) /> 	
		<cfset setAutowire(arguments.parent.getAutowire()) />		
		<cfset setFactoryPostProcessor(arguments.parent.isFactoryPostProcessor()) />	
		<cfset setBeanPostProcessor(arguments.parent.isBeanPostProcessor()) />	
		
		<cfset setInitMethod(arguments.parent.getInitMethod()) />	
		<cfif arguments.parent.isFactoryBean()>		
			<cfset setFactoryBean(arguments.parent.getFactoryBean()) />		
		</cfif>
		<cfset setFactoryMethod(arguments.parent.getFactoryMethod()) />	
		
		<cfreturn this/>	
	</cffunction>
	
	<!--- for adding parent bean support. We will first duplicate the parent bean definition with initFromParent, then
		  overwrite the paren't properties (or add constructor args and properties) however some of these rules will need a lot
		  of tweeling, here are those of Java Spring:
		  
		  /**
		 * Override settings in this bean definition from the given bean definition.
		 * <p><ul>
		 * <li>Will override beanClass if specified in the given bean definition.
		 * <li>Will always take abstract, singleton, lazyInit from the given bean definition.
		 * <li>Will add constructorArgumentValues, propertyValues, methodOverrides to
		 * existing ones.
		 * <li>Will override initMethodName, destroyMethodName, staticFactoryMethodName
		 * if specified.
		 * <li>Will always take dependsOn, autowireMode, dependencyCheck from the
		 * given bean definition.
		 * </ul>
		 */
	--->
	
	<cffunction name="overrideProperties" returntype="void" output="false" 
				hint="Overrides bean definition properties with those of supplied bean definition. This is for 'Parent' bean definition support">
		<cfargument name="fromBeanDef" type="coldspring.beans.BeanDefinition" required="true">
		<cfset var constructorArgs = 0 />
		<cfset var properties = 0 />
		<cfset var dependencies = '' />
		<cfset var arg = 0 />
		<cfset var prop = 0 />
		<cfset var dep = "" />
		
		<cfset setBeanID(arguments.fromBeanDef.getBeanID()) />
		
		<cfif len(arguments.fromBeanDef.getBeanClass())>
			<cfset setBeanClass(arguments.fromBeanDef.getBeanClass()) />		
		</cfif>
		
		<cfset setAbstract(arguments.fromBeanDef.isAbstract()) />
		<cfset setSingleton(arguments.fromBeanDef.isSingleton()) />
		<cfset setLazyInit(arguments.fromBeanDef.isLazyInit()) />
		
		<cfset constructorArgs = arguments.fromBeanDef.getConstructorArgs() />	
		<cfloop collection="#constructorArgs#" item="arg">
			<cfset addConstructorArg(constructorArgs[arg]) />
		</cfloop>
			
		<cfset properties = arguments.fromBeanDef.getProperties() />
		<cfloop collection="#properties#" item="prop">
			<cfset addProperty(properties[prop]) />
		</cfloop>
		
		<cfset dependencies = arguments.fromBeanDef.getDependenciesForCopy() />
		<cfloop list="#dependencies#" index="dep">
			<cfset addDependency(dep) />
		</cfloop>
		
		<cfif len(arguments.fromBeanDef.getInitMethod())>
			<cfset setInitMethod(arguments.fromBeanDef.getInitMethod()) />
		</cfif>
		<cfif arguments.fromBeanDef.isFactoryBean()>		
			<cfset setFactoryBean(arguments.fromBeanDef.getFactoryBean()) />		
		</cfif>
		<cfif len(arguments.fromBeanDef.getFactoryMethod())>
			<cfset setFactoryMethod(arguments.fromBeanDef.getFactoryMethod()) />	
		</cfif>
		
		<cfset setAutowire(arguments.fromBeanDef.getAutowire()) />
		
	</cffunction>
	
	<cffunction name="getDebuggData" access="public" returntype="struct" output="false">
		<cfreturn variables.instanceData />
	</cffunction>
	
	<cffunction name="getBeanID" access="public" output="false" returntype="string" 
				hint="I retrieve the BeanID from this instance's data">
		<cfreturn variables.instanceData.BeanID />
	</cffunction>

	<cffunction name="setBeanID" access="public" output="false" returntype="void"  
				hint="I set the BeanID in this instance's data">
		<cfargument name="BeanID" type="string" required="true"/>
		<cfset variables.instanceData.BeanID = arguments.BeanID />
	</cffunction>
	
	<cffunction name="getBeanClass" access="public" output="false" returntype="any"
				hint="I retrieve the BeanClass from this instance's data">
		<cfreturn variables.instanceData.BeanClass />
	</cffunction>

	<cffunction name="setBeanClass" access="public" output="false" returntype="void"  
				hint="I set the BeanClass in this instance's data">
		<cfargument name="BeanClass" type="string" required="true"/>
		<cfset variables.instanceData.BeanClass = arguments.BeanClass />
	</cffunction>
	
	<cffunction name="isAbstract" access="public" output="false" returntype="boolean" 
				hint="Returns the 'abstract' flag for the bean definition">
		<cfreturn variables.instanceData.abstract />
	</cffunction>

	<cffunction name="setAbstract" access="public" output="false" returntype="void"  
				hint="I set the 'abstract' flag for the bean definition">
		<cfargument name="abstract" type="boolean" required="true"/>
		<cfset variables.instanceData.abstract = arguments.abstract />
	</cffunction>
	
	<cffunction name="getParent" access="public" output="false" returntype="string" 
				hint="Returns the parent bean definition (name) for this bean definition">
		<cfreturn variables.instanceData.parent />
	</cffunction>

	<cffunction name="setParent" access="public" output="false" returntype="void"  
				hint="I set the parent bean definition (name) for this bean definition">
		<cfargument name="parent" type="string" required="true"/>
		<cfset variables.instanceData.parent = arguments.parent />
		<cfset variables.instanceData.childDefinition = true />
	</cffunction>
	
	<cffunction name="isChildDefinition" access="public" output="false" returntype="boolean" 
				hint="Returns the 'childDefinition' flag for the bean definition">
		<cfreturn variables.instanceData.childDefinition />
	</cffunction>

	<cffunction name="setMerged" access="public" output="false" returntype="void"  
				hint="I set the 'merged' flag for this bean definition">
		<cfargument name="merged" type="boolean" required="true"/>
		<cfset variables.instanceData.merged = arguments.merged />
	</cffunction>
	
	<cffunction name="isMerged" access="public" output="false" returntype="boolean" 
				hint="Returns the 'merged' flag for the bean definition">
		<cfreturn variables.instanceData.merged />
	</cffunction>
	
	<!--- 4/3/6: adding instanceOf method to beanDefinition, there may bef
		  areas that can be refactored to use this method! --->
	<cffunction name="instanceOf" access="public" output="false" returntype="any"
				hint="I look through bean metadata, extends to see if this class is an insance of or extends a class">
		<cfargument name="className" type="string" required="true" />
		
		<!--- first we need the metadata, but an issue here, are we returning an instance of a factory, or it's bean?? --->
		<cfset var searchMd = getMetaData(getBeanInstance()) />
		<!--- <cfset var searchMd = getMetaData(getInstance(true)) /> --->
		
		<!--- if we extend some class, search through the metadata, down though extends --->
		<cfif structKeyExists(searchMd,'extends')>
			<cfloop condition="StructKeyExists(searchMd,'extends')">
				<cfif searchMd.name IS arguments.className>
					<cfreturn true />
				</cfif>
				<cfset searchMd = searchMd.extends />
			</cfloop>
		<!--- but if we don't extend any class,, just see if we have the required type --->
		<cfelse>
			<cfif searchMd.name IS arguments.className>
				<cfreturn true />
			</cfif>
		</cfif>
		
		<cfreturn false />
	</cffunction>
	
	<!--- bean constructor-arg getters/setters --->
	<cffunction name="getConstructorArgs" access="public" output="false" returntype="struct" 
				hint="I retrieve the ConstructorArgs from this instance's data">
		<cfreturn variables.instanceData.constructorArgs />
	</cffunction>

	<cffunction name="setConstructorArgs" access="public" output="false" returntype="void"  
				hint="I set the ConstructorArgs in this instance's data">
		<cfargument name="constructorArgs" type="struct" required="true"/>
		<cfset variables.instanceData.constructorArgs = StructCopy(arguments.constructorArgs) />
	</cffunction>
	
	<cffunction name="addConstructorArg" access="public" output="false" returntype="void"  
				hint="I add a property to this bean definition">
		<cfargument name="constructorArg" type="coldspring.beans.BeanProperty" required="true"/>
		<cfset variables.instanceData.constructorArgs[arguments.constructorArg.getName()] = arguments.constructorArg />
	</cffunction>
	
	<cffunction name="getConstructorArg" access="public" output="false" returntype="coldspring.beans.BeanProperty">
		<cfargument name="constructorArgName" type="string" required="true"/>
		<cfif structKeyExists(variables.instanceData.constructorArgs,arguments.constructorArgName)>
			<cfreturn variables.instanceData.constructorArgs[arguments.constructorArgName] />
		<cfelse>
			<cfthrow type="coldspring.beanDefException" 
					 message="constructor-arg requested (#arguments.constructorArgName#) does not exist for bean: #getBeanID()# "/>
		</cfif>
	</cffunction>
	
	<!--- bean property getters/setters --->
	<cffunction name="getProperties" access="public" output="false" returntype="struct" 
				hint="I retrieve the Properties from this instance's data">
		<cfreturn variables.instanceData.Properties />
	</cffunction>

	<cffunction name="setProperties" access="public" output="false" returntype="void"  
				hint="I set the Properties in this instance's data">
		<cfargument name="Properties" type="struct" required="true"/>
		<cfset variables.instanceData.Properties = StructCopy(arguments.Properties) />
	</cffunction>
	
	<cffunction name="addProperty" access="public" output="false" returntype="void"  
				hint="I add a property to this bean definition">
		<cfargument name="property" type="coldspring.beans.BeanProperty" required="true"/>
		<cfset variables.instanceData.properties[arguments.property.getName()] = arguments.property />
	</cffunction>
	
	<cffunction name="getProperty" access="public" output="false" returntype="coldspring.beans.BeanProperty">
		<cfargument name="propertyName" type="string" required="true"/>
		<cfif structKeyExists(variables.instanceData.properties,arguments.propertyName)>
			<cfreturn variables.instanceData.properties[arguments.propertyName] />
		<cfelse>
			<cfthrow type="coldspring.beanDefException" 
					 message="property requested (#arguments.propertyName#) does not exist for bean: #getBeanID()# "/>
		</cfif>
	</cffunction>
	
	<cffunction name="addDependency" access="public" output="false" returntype="void"  
				hint="I add a dependency to this bean definition">
		<cfargument name="refName" type="string" required="true" />
		<cfif not ListFindNoCase(variables.instanceData.Dependencies, arguments.refName)>
			<cfset variables.instanceData.Dependencies = ListAppend(variables.instanceData.Dependencies, arguments.refName) />
		</cfif>
	</cffunction>
	
	<cffunction name="setDependenciesForCopy" access="public" output="false" returntype="string"  
				hint="I set the base dependency list for copying the bean definition only (parent bean def support)">
		<cfargument name="dependencies" type="string" required="true"/>
		<cfset variables.instanceData.Dependencies = arguments.dependencies />
	</cffunction>
	
	<cffunction name="getDependenciesForCopy" access="public" output="false" returntype="string"  
				hint="I return the base dependency list for copying the bean definition only (parent bean def support)">
		<cfreturn variables.instanceData.Dependencies />
	</cffunction>
	
	<cffunction name="getDependencies" access="public" output="false" returntype="void"
				hint="I retrieve the full list of dependencies for this bean definition. The BeanFactory will probably ask for this when I'm being constructed, so he can construct my dependencies first!">
		<cfargument name="dependentBeans" type="Struct" required="true" />
		
		<!--- local vars --->
		<cfset var myDependencies = '' />
		<cfset var refName = '' />
		<cfset var md = '' />
		<cfset var functionIndex = '' />
		<cfset var argIndex = '' />
		<cfset var setterName = '' />
		<cfset var setterNameToCall = '' />				
		<cfset var setterType = '' />
		<cfset var temp_xml = '' />
		<cfset var beanInstance = 0/>
		<cfset var beanName = 0/>
		<cfset var autoArg = 0/>
		<cfset var prop = 0/>
		<cfset var argumentName = 0/>
		<cfset var tempProps = arraynew(1)/>		
		<cfset var tempInterceptors = 0 />
		<cfset var access = '' />
		<cfset var currIx = '' />
		<cfset var dependIx = '' />
				
		<!--- this is where the bean is actually created if it hasn't been --->
		<cfif not autoWireChecked()>
		
			<cfif getFactoryBean() neq "">
				<cfset variables.instanceData.Dependencies = 
							ListPrepend(variables.instanceData.Dependencies, getFactoryBean()) />
			<cfelse>	
			
				<cfset  beanInstance = getBeanInstance() />
				<!--- look for autowirable collaborators --->
				<cfset md = getBeanFactory().flattenMetaData(getMetaData(beanInstance)) />

				<cfif structKeyExists(md,"functions")>
					<cfloop from="1" to="#arraylen(md.functions)#" index="functionIndex">
						<!--- for setters, we're getting the access type --->
						<cfif structKeyExists(md.functions[functionIndex],'access')>
							<cfset access = md.functions[functionIndex].access />
						<cfelse>
							<cfset access = 'public' />
						</cfif>
						
						<!--- look for init (constructor) --->
						<!--- todo: respect how we are told to autowire (byName|byType) --->
						<cfif md.functions[functionIndex].name eq "init" 
							  and arraylen(md.functions[functionIndex].parameters)>
							<!--- loop over args --->
							<cfloop from="1" to="#arraylen(md.functions[functionIndex].parameters)#" index="argIndex">
								<cfset autoArg = md.functions[functionIndex].parameters[argIndex]/>
								<!--- is this arg not explicitly defined?
										and (autowiring is 'byName' and the beanFactory knows this bean by name)
										or (autowiring is 'byType' and the beanFactory knows this bean by type)
										then it's a dependency --->
								<cfif not structKeyExists(variables.instanceData.constructorArgs, autoArg.name)
									  and (
											(getAutowire() eq "byName" and getBeanFactory().containsBean(autoArg.name))
										or 
											(getAutowire() eq "byType" and len(getBeanFactory().findBeanNameByType(autoArg.type)))
										  )>
									
									<!--- we are going to add the constructor arg as if it had been defined in the xml --->
									<cfset temp_xml = xmlnew()/>
									<cfset temp_xml.xmlRoot = XmlElemNew(temp_xml,"constructor-arg")/>
									<cfset temp_xml.xmlRoot.xmlAttributes['name'] = autoArg.name />
									<cfset temp_xml.xmlRoot.xmlChildren[1] = XmlElemNew(temp_xml,"ref")/>
									<cfset temp_xml.xmlRoot.xmlChildren[1].xmlAttributes['bean'] = autoArg.name />
										
									<cfset addConstructorArg(createObject("component","coldspring.beans.BeanProperty").init(
																									temp_xml.xmlRoot,this
																										)) />						
									
								</cfif>
								
								<!--- try set the argumentName on this constructor arg if it exists --->
								<cftry>
									<cfset prop = getConstructorArg(autoArg.name) />
									<cfset prop.setArgumentName(autoArg.name) />
									<cfcatch></cfcatch>
								</cftry>
								
							</cfloop>
						<cfelseif left(md.functions[functionIndex].name,3) eq "set" 
								and not structKeyExists(variables.instanceData.properties, mid(md.functions[functionIndex].name,4,len(md.functions[functionIndex].name)-3))
								and arraylen(md.functions[functionIndex].parameters) eq 1 
								and (access is not 'private')>
				
							<!--- look for setters (same as above for constructor-args) --->
							<!--- todo:
									respect how we are told to autowire (byName|byType) --->
									
							<cfset setterName = mid(md.functions[functionIndex].name,4,len(md.functions[functionIndex].name)-3)/>
							
							<!--- ensure a type was actually specified --->
							<cfif structKeyExists(md.functions[functionIndex].parameters[1],"type")>
								<cfset setterType = md.functions[functionIndex].parameters[1].type/>						
							<cfelse>
								<cfset setterType = ""/>
							</cfif>
				
							<!--- so, if we didn't already explicly set this property
								  and (autowiring is 'byName' and the beanFactory knows this bean by name)
										or (autowiring is 'byType' and the beanFactory knows this bean by type)
										then it's a dependency --->
							
							<cfif not structKeyExists(variables.instanceData.properties, setterName)
									  and (
											(getAutowire() eq "byName" and getBeanFactory().containsBean(setterName))
										or 
											(getAutowire() eq "byType" and len(getBeanFactory().findBeanNameByType(setterType)))
										  )>
										  
									<cfset temp_xml = xmlnew()/>							
									<cfset temp_xml.xmlRoot = XmlElemNew(temp_xml,"property")/>
									<cfset temp_xml.xmlRoot.xmlAttributes['name'] = setterName />
									<cfset temp_xml.xmlRoot.xmlChildren[1] = XmlElemNew(temp_xml,"ref")/>
									

									<cfif getAutowire() eq "byType">
										<cfset temp_xml.xmlRoot.xmlChildren[1].xmlAttributes['bean'] = getBeanFactory().findBeanNameByType(setterType) />								
									<cfelse>
										<cfset temp_xml.xmlRoot.xmlChildren[1].xmlAttributes['bean'] = setterName />
									</cfif>
									
									<cfset addProperty(createObject("component","coldspring.beans.BeanProperty").init(
																								temp_xml.xmlRoot,this
																								) ) >
														
							</cfif>	
								
						</cfif>
						
						<!--- try set the argumentName on this property if it exists so we can call the setter
								(the argument name might not always be the name of the property) --->
						<cfif left(md.functions[functionIndex].name,3) eq "set" 
								and arraylen(md.functions[functionIndex].parameters) eq 1>
							<cfset argumentName = md.functions[functionIndex].parameters[1].name />
							<cftry>
								<cfset prop = getProperty(mid(md.functions[functionIndex].name,4,len(md.functions[functionIndex].name)-3)) />
								<cfset prop.setArgumentName(argumentName) />
								
								<cfcatch></cfcatch>
														
							</cftry>
						</cfif>
						
					</cfloop>	
					
				</cfif>	
		
				<!--- 4/2/6 -- here we're looking for an aop factory type bean, so we can add it's interceptors as dependencies.
					This is right after the end of the autowire loop, inside the if statement checking if autowire has been done,
					that way it only happens once! --->
				<cfif instanceOf('coldspring.aop.framework.ProxyFactoryBean')>
					<cftry>
						<cfset tempInterceptors = getProperty('interceptorNames').getValue() />
						<cfcatch></cfcatch>
					</cftry>
					<!--- todo: damn, another try/catch on retrieving properties, we need property exists! --->
					 
					<cfif isArray(tempInterceptors) and ArrayLen(tempInterceptors)>
						<cfset variables.instanceData.Dependencies = 
								ListAppend(variables.instanceData.Dependencies,ArrayToList(tempInterceptors)) />
					</cfif>
				</cfif>	
					
			</cfif>
		
		</cfif>	
		
		<!--- ok, the above code went through and autowired up any dependencies (at the last possible moment)
			  now this bean definition's own dependency list is complete, so we can recurse through
			  that list to get every single possible dependency --->
		
		<cfloop list="#variables.instanceData.Dependencies#" index="refName">
			<cfset dependIx = ListFindNoCase(arguments.dependentBeans.allBeans, refName) />

			<cfif dependIx LT 1>
				
				<cfset arguments.dependentBeans.allBeans = ListAppend(arguments.dependentBeans.allBeans, refName) />
				<cfset getBeanFactory().getMergedBeanDefinition(refName).getDependencies(arguments.dependentBeans) />
				<cfset arguments.dependentBeans.orderedBeans = ListPrepend(arguments.dependentBeans.orderedBeans, refName) />

			</cfif>
			
		</cfloop>
		
		<!--- save the dependent beans 
		<cfset variables.instanceData.dependentBeans = arguments.dependentBeans />
		<cfset variables.instanceData.dependenciesChecked = true /> --->
		
	</cffunction>
	
	<cffunction name="getBeanInstance" access="public" output="false" returntype="any" 
				hint="I retrieve the the actual bean instance (a new one if this is a prototype bean) from this bean definition - or the result of a factory-method invocation">
		
		<cfset var bean = 0 />
		<cfset var additionalInfo = "" />
		<!--- create this if it doesn't exist --->
		<cftry>
			<cfif not structkeyexists(variables,"beanInstance")>
				<cfset variables.beanInstance = createObject("component", getBeanClass()) />
			</cfif>
			
			<cfif isSingleton()>
				<cfset bean = variables.beanInstance />
			<cfelse>
				<cfset bean = createObject("component", getBeanClass())/>
			</cfif>
			
			<cfcatch type="any">
				<cfif StructKeyExists(cfcatch, "line")>
					<cfset additionalInfo = "<br/> Line: " & cfcatch.line />
				</cfif>
				<cfif StructKeyExists(cfcatch, "Snippet")>
					<cfset additionalInfo = additionalInfo & "<br/> Snippet: " & HTMLCodeFormat(cfcatch.Snippet) />
				</cfif>
				<cfthrow type="coldspring.beanCreationException" 
					message="Bean creation exception in #getBeanClass()#" 
					detail="#cfcatch.message#:#cfcatch.detail#:#additionalInfo#">
			</cfcatch>
		</cftry>
		
		<cfreturn bean />
		
	</cffunction>
	
	<cffunction name="autoWireChecked" access="public" output="false" returntype="boolean">
		<cfif not structKeyExists(variables.instanceData,"autoWireChecked")>
			<cfset variables.instanceData.autoWireChecked = true />
			<cfreturn false/>
		<cfelse>
			<cfreturn true/>		
		</cfif>
	</cffunction>
	
	<cffunction name="dependenciesChecked" access="public" output="false" returntype="boolean">
		<cfreturn variables.instanceData.dependenciesChecked />		
	</cffunction>
	
	<cffunction name="getDependentBeans" access="public" output="false" returntype="struct">
		<cfreturn variables.instanceData.dependentBeans />		
	</cffunction>
	
	<cffunction name="getBeanFactory" access="public" output="false" returntype="coldspring.beans.BeanFactory" 
				hint="I retrieve the Bean Factory from this instance's data">
		<cfreturn variables.instanceData.BeanFactory />
	</cffunction>

	<cffunction name="setBeanFactory" access="public" output="false" returntype="void"  
				hint="I set the Bean Factory in this instance's data">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true"/>
		<cfset variables.instanceData.BeanFactory = arguments.beanFactory />
	</cffunction>
	
	<cffunction name="isSingleton" access="public" output="false" returntype="boolean" 
				hint="I retrieve the Singleton flag from this instance's data">
		<cfreturn variables.instanceData.Singleton />
	</cffunction>

	<cffunction name="setSingleton" access="public" output="false" returntype="void"  
				hint="I set the Singleton flag in this instance's data">
		<cfargument name="Singleton" type="boolean" required="true"/>
		<cfset variables.instanceData.Singleton = arguments.Singleton />
	</cffunction>
	
	<cffunction name="isLazyInit" access="public" output="false" returntype="boolean" 
				hint="I retrieve the LazyInit flag from this instance's data">
		<cfreturn variables.instanceData.lazyInit />
	</cffunction>

	<cffunction name="setLazyInit" access="public" output="false" returntype="void"  
				hint="I set the LazyInit flag in this instance's data">
		<cfargument name="LazyInit" type="boolean" required="true"/>
		<cfset variables.instanceData.lazyInit = arguments.LazyInit />
	</cffunction>
	
	<cffunction name="isInnerBean" access="public" output="false" returntype="boolean" 
				hint="I retrieve the InnerBean flag from this instance's data">
		<cfreturn variables.instanceData.InnerBean />
	</cffunction>

	<cffunction name="setInnerBean" access="public" output="false" returntype="void"  
				hint="I set the InnerBean flag in this instance's data">
		<cfargument name="InnerBean" type="boolean" required="true"/>
		<cfset variables.instanceData.InnerBean = arguments.InnerBean />
	</cffunction>
	
	<cffunction name="isConstructed" access="public" output="false" returntype="boolean" 
				hint="I retrieve the Constructed flag from this instance's data">
		<cfreturn variables.instanceData.Constructed />
	</cffunction>

	<cffunction name="setIsConstructed" access="public" output="false" returntype="void"  
				hint="I set the Constructed flag in this instance's data">
		<cfargument name="Constructed" type="boolean" required="true"/>
		<cfset variables.instanceData.Constructed = arguments.Constructed/>
	</cffunction>
	
	<cffunction name="isFactory" access="public" output="false" returntype="boolean" 
				hint="I retrieve the Factory flag from this instance's data">
		<cfreturn variables.instanceData.Factory />
	</cffunction>

	<cffunction name="setIsFactory" access="public" output="false" returntype="void"  
				hint="I set the Factory flag in this instance's data">
		<cfargument name="Factory" type="boolean" required="true"/>
		<cfset variables.instanceData.Factory = arguments.Factory/>
	</cffunction>
	
	<cffunction name="isProxyFactory" access="public" output="false" returntype="boolean" 
				hint="I retrieve the Factory flag from this instance's data">
		<cfreturn variables.instanceData.ProxyFactory />
	</cffunction>

	<cffunction name="setIsProxyFactory" access="public" output="false" returntype="void"  
				hint="I set the Factory flag in this instance's data">
		<cfargument name="ProxyFactory" type="boolean" required="true"/>
		<cfset variables.instanceData.ProxyFactory = arguments.ProxyFactory/>
	</cffunction>
	
	
	
	<cffunction name="getAutowire" access="public" output="false" returntype="string" 
				hint="I retrieve the autowire method from instance's data">
		<cfreturn variables.instanceData.autowire />
	</cffunction>

	<cffunction name="setAutowire" access="public" output="false" returntype="void"  
				hint="I set the the autowire method in this instance's data">
		<cfargument name="autowire" type="string" required="true"/>
		<cfset variables.instanceData.autowire = arguments.autowire/>
	</cffunction>
	
	
	<cffunction name="isFactoryPostProcessor" access="public" output="false" returntype="boolean" 
				hint="I retrieve the factoryPostProcessor flag from instance's data">
		<cfreturn variables.instanceData.factoryPostProcessor />
	</cffunction>

	<cffunction name="setFactoryPostProcessor" access="public" output="false" returntype="void"  
				hint="I set the the factoryPostProcessor flag in this instance's data">
		<cfargument name="factoryPostProcessor" type="boolean" required="true"/>
		<cfset variables.instanceData.factoryPostProcessor = arguments.factoryPostProcessor/>
	</cffunction>
	
	
	<cffunction name="isBeanPostProcessor" access="public" output="false" returntype="boolean" 
				hint="I retrieve the beanPostProcessor flag from instance's data">
		<cfreturn variables.instanceData.beanPostProcessor />
	</cffunction>

	<cffunction name="setBeanPostProcessor" access="public" output="false" returntype="void"  
				hint="I set the the beanPostProcessor flag in this instance's data">
		<cfargument name="beanPostProcessor" type="boolean" required="true"/>
		<cfset variables.instanceData.beanPostProcessor = arguments.beanPostProcessor/>
	</cffunction>
	
	
	
		
	<cffunction name="setInitMethod" access="public" output="false" returntype="void" hint="I set the InitMethod in this instance">
		<cfargument name="InitMethod" type="string" required="true" />
		<cfset variables.instanceData.initMethod = arguments.InitMethod />
	</cffunction>

	<cffunction name="getInitMethod" access="public" output="false" returntype="string" hint="I retrieve the InitMethod from this instance">
		<cfreturn variables.instanceData.initMethod/>
	</cffunction>
	
	<cffunction name="hasInitMethod" access="public" output="false" returntype="boolean" hint="I retrieve whether this bean def contains an init-method attibute, meaning a method that will be called after bean construction and dep. injection (confusiong because 'init()' is the constructor in CF)">
		<cfreturn structKeyExists(variables.instanceData,"initMethod") and len(variables.instanceData.initMethod)/>
	</cffunction>
	
	<cffunction name="setInitMethodWasCalled" access="public" output="false" returntype="void" hint="I set the InitMethod in this instance">
		<cfargument name="InitMethodWasCalled" type="boolean" required="true" />
		<cfset variables.instanceData.initMethodWasCalled = arguments.InitMethodWasCalled />
	</cffunction>

	<cffunction name="getInitMethodWasCalled" access="public" output="false" returntype="boolean" hint="I retrieve the InitMethod from this instance">
		<cfreturn variables.instanceData.initMethodWasCalled/>
	</cffunction>
	
	<cffunction name="getInstance" access="public" output="false" returntype="any" hint="I retrieve the Instance from this instance's data">
		<cfargument name="returnFactory" type="boolean" default="false" />
		<cfif isFactory() and not arguments.returnFactory>
			<cfreturn getBeanFactory().getBeanFromSingletonCache(getBeanID()).getObject() >
		<cfelse>
			<cfreturn getBeanFactory().getBeanFromSingletonCache(getBeanID()) >
		</cfif>
	</cffunction>
	
	<cffunction name="getFactoryBean" access="public" output="false" returntype="string" 
				hint="I retrieve the factoryBean from this instance's data">
		<cfreturn variables.instanceData.factoryBean />
	</cffunction>

	<cffunction name="setFactoryBean" access="public" output="false" returntype="void"  
				hint="I set the BeanID in this instance's data">
		<cfargument name="factoryBean" type="string" required="true"/>
		<cfset variables.instanceData.factoryBean = arguments.factoryBean />
		<!--- adding a bit to check if this is a factory bean, 
			  instead of having to check the length of factoryBean all the time --->
		<cfset variables.instanceData.isFactoryBean = true />
	</cffunction>
	
	<cffunction name="isFactoryBean" access="public" output="false" returntype="boolean" 
				hint="I retrieve the Factory flag from this instance's data">
		<cfreturn variables.instanceData.isFactoryBean />
	</cffunction>

	<cffunction name="getFactoryMethod" access="public" output="false" returntype="string" 
				hint="I retrieve the factoryMethod from this instance's data">
		<cfreturn variables.instanceData.factoryMethod />
	</cffunction>

	<cffunction name="setFactoryMethod" access="public" output="false" returntype="void"  
				hint="I set the factoryMethod in this instance's data">
		<cfargument name="factoryMethod" type="string" required="true"/>
		<cfset variables.instanceData.factoryMethod = arguments.factoryMethod />
	</cffunction>	
</cfcomponent>