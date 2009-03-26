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
		
			
 $Id: BeanProperty.cfc,v 1.22 2008/03/07 02:25:04 pjf Exp $

---> 

<cfcomponent name="BeanProperty" 
			displayname="BeanProperty" 
			hint="I model a single bean property within a ColdSpring bean definition. I could be a constructor-arg or a property, but that's not my business (since both are 'properties')" 
			output="false">

	<cfset variables.instanceData = StructNew() />
	<cfset variables.propertyDef = "" />

	<cffunction name="init" returntype="coldspring.beans.BeanProperty" access="public" output="false"
				hint="Constructor. Creates a new Bean Property.">
		<cfargument name="propertyDefinition" type="any" required="true" hint="CF xml object that defines what I am" />
		<cfargument name="parentBeanDefinition" type="coldspring.beans.BeanDefinition" hint="reference to the bean definition that I'm being added to" />
		
		<cfset variables.propertyDefinition = arguments.propertyDefinition />
		<cfset setParentBeanDefinition(arguments.parentBeanDefinition) />
		<cfset parsePropertyDefinition(arguments.propertyDefinition) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="resolvePropertyPlaceholders" access="public" returntype="void" output="false">
		<cfargument name="properties" type="struct" required="true" hint="properties struct, passed in by a postProcessor" />
		<cfset parsePropertyDefinition(variables.propertyDefinition, arguments.properties) />
	</cffunction>
	
	<cffunction name="parsePropertyDefinition" access="private" returntype="void" output="false"
				hint="I parse the CF xml object that defines what I am ">
		<cfargument name="propertyDef" type="any" required="true" hint="property definition xml" />
		<cfargument name="properties" type="struct" required="false" hint="properties struct, passed in by a postProcessor" />
		<cfset var child = 0 />
		<cfset var beanUID = 0 />
		<cfset var propName = ""/>
		
		<!---  not (StructKeyExists(propertyDef.XmlAttributes,'name') and --->
		<cfif not (StructKeyExists(propertyDef,'XmlChildren')
			  	and ArrayLen(arguments.propertyDef.XmlChildren))>
			<cfthrow type="coldspring.MalformedPropertyException" message="Xml properties must contain a 'name' and a child element!">
		</cfif>
		
		<!--- the only things we need to know at this level is the name of the property... --->
		<cfif StructKeyExists(propertyDef.XmlAttributes,'name')>
			<cfset propName = propertyDef.XmlAttributes.name/>
		</cfif>
		<cfset setName(propName) />
		
		<cftry>
			<!--- the should only be one child node --->
			<cfset child = arguments.propertyDef.XmlChildren[1] />
			<cfcatch>
				<cfthrow type="coldspring.MalformedPropertyException"  message="properties/constructor-args must contain a child element!">
			</cfcatch>			
		</cftry>
		
		<!--- and we also need to know what "type" of property it is (e.g. <value/>,<list/>,<bean/> etc etc) --->
		<cfset setType(child.XmlName) />
		
		<!--- ok now parse the definition of my child --->
		<cfif StructKeyExists(arguments, "properties")>
			<cfset parseChildNode(child, arguments.properties)/>
		<cfelse>
			<cfset parseChildNode(child)/>
		</cfif>
			
	</cffunction>

	<cffunction name="parseChildNode" access="private" returntype="void" output="false"
				hint="I parse the child of this property">
		<cfargument name="childNode" type="any" required="true" hint="child xml" />
		<cfargument name="properties" type="struct" required="false" hint="properties struct, passed in by a postProcessor" />
		
		<cfset var child = arguments.childNode />
		<cfset var initMethod = ""/>
		<cfset var entryClass = ""/>
		<cfset var entryFactoryMethod = ""/>
		<cfset var entryFactoryBean = ""/>	
		<cfset var entryAutowire = ""/>
		<cfset var entryParent = "" />
		<cfset var beanUID = "" />
		
		<!--- based on the type of property
			perhaps we should switch on #getType()# instead? --->
		<cfswitch expression="#child.xmlName#">
			
			<cfcase value="ref">
				<!--- just a <ref/> tag, set the internal value of this property to the id of the bean, 
				and add the bean to the bean definition's (the one that encloses me, aka my parent) dependency list --->
				<cfset setValue(child.xmlAttributes.bean) />
				<cfset addParentDefinitionDependency(child.xmlAttributes.bean) />
			</cfcase>
			
			<cfcase value="bean">
				<!--- createInnerBeanDefinition now takes care of all the xml parsing and returns new beanUId --->
				<cfset beanUID = createInnerBeanDefinition(child) />
				<!--- set the internal value of this property to be the inner bean's ID --->
				<cfset setValue(beanUID) />
				<!--- and of course, add it to the dependency list for my parent definition --->
				<cfset addParentDefinitionDependency(beanUID) />
			</cfcase>
			
			<cfcase value="list,map">
				<!--- list + map properties get special parsing, set our internal "value" to be the result --->
				<cfif StructKeyExists(arguments, "properties")>
					<cfif len(child.xmlText) gt 2 and left(child.xmlText,2) eq "${">
						<cfset setValue(parseEntries(child.xmlText,child.xmlName,arguments.properties)) />
					<cfelse>
						<cfset setValue(parseEntries(child.xmlChildren,child.xmlName,arguments.properties)) />
					</cfif>
				<cfelse>
					<cfif len(child.xmlText) gt 2 and left(child.xmlText,2) eq "${">
						<cfset setValue(parseEntries(child.xmlText,child.xmlName)) />
					<cfelse>
						<cfset setValue(parseEntries(child.xmlChildren,child.xmlName)) />
					</cfif>
				</cfif>
			</cfcase>
			
			<cfcase value="value">
				<!--- parse the value and set our internal "value" to be the result --->
				<cfif StructKeyExists(arguments, "properties")>
					<cfset setValue(parseValue(child.xmlText, arguments.properties)) />
				<cfelse>
					<cfset setValue(parseValue(child.xmlText)) />
				</cfif>
			</cfcase>
			
		</cfswitch>
	</cffunction>
	
	<cffunction name="parseValue" access="private" returntype="string" output="false"
				hint="I parse a <value/>">
		<cfargument name="rawValue" type="string" required="true" />
		<cfargument name="properties" type="struct" required="false" hint="properties struct, passed in by a postProcessor" />
		
		<cfset var beanFactoryDefaultProperties = 0 />
		<!--- propertyPlaceholder --->
		<cfset var propertyPlaceholder = ""/>
		
		<!--- resolve anything that looks like it should get replaced with a beanFactory default property --->
		<cfif left(rawValue,2) eq "${" and right(rawValue,1) eq "}">=
			<!--- grab the default properties out of the enclosing bean factory --->
			<cfset beanFactoryDefaultProperties = getParentBeanDefinition().getBeanFactory().getDefaultProperties() />
			<cfset propertyPlaceholder = mid(rawValue,3,len(rawValue)-3)/>
			<!--- look for this property value in the bean factory (using isDefined/evaluate incase of "." in property name)
				OR look for the property in the passed in struct ( do that first, as we may be postProcessing ) --->
			<cfif StructKeyExists(arguments, "properties")>
				<cfif StructKeyExists(arguments.properties, propertyPlaceholder) and isSimpleValue(arguments.properties[propertyPlaceholder])>
					<cfreturn arguments.properties[propertyPlaceholder] />
				<cfelse>
					<cfthrow type="BeanProperty.PlaceholderTypeError" message="The supplied value for property placeholder #propertyPlaceholder# is not a simple type. This error occured while processing a beanFactoryPostProcessor!"/>
				</cfif>
				<!---
				<cfif isDefined("arguments.properties.#mid(rawValue,3,len(rawValue)-3)#")>
					<cfreturn evaluate("arguments.properties.#mid(rawValue,3,len(rawValue)-3)#")/>
				</cfif>	
			<cfelseif isDefined("beanFactoryDefaultProperties.#mid(rawValue,3,len(rawValue)-3)#")>
				<cfreturn evaluate("beanFactoryDefaultProperties.#mid(rawValue,3,len(rawValue)-3)#")/>
			</cfif> --->
			<cfelseif StructKeyExists(beanFactoryDefaultProperties, propertyPlaceholder)>
				<cfif isSimpleValue(beanFactoryDefaultProperties[propertyPlaceholder])>
					<cfreturn beanFactoryDefaultProperties[propertyPlaceholder] />
				<cfelse>
					<cfthrow type="BeanProperty.PlaceholderTypeError" message="The supplied value for property placeholder #propertyPlaceholder# is not a simple type. This error occured while while resolving properties with the default bean factory properties!"/>
				</cfif>
			</cfif>
		</cfif>
		
		<cfreturn rawValue />
	</cffunction>
	
	
	<cffunction name="parseEntries" access="private" returntype="any" output="false"
				hint="parses complex properties, limited to <map/> and <list/>. Should return either an array or an struct.">
		<cfargument name="mapEntries" type="any" required="true" hint="xml of child nodes for this complex type" />
		<cfargument name="returnType" type="string" required="true" hint="type of property (list|map)" />
		<cfargument name="properties" type="struct" required="false" hint="properties struct, passed in by a postProcessor" />
		
		<!--- local vars --->
		<cfset var rtn = 0 />
		<cfset var ix = 0/>
		<cfset var entry = 0/>
		<cfset var entryBeanID = "" />
		<cfset var entryChild = 0 />
		<cfset var entryKey = 0 />
		<cfset var beanFactoryDefaultProperties = 0 />
		<cfset var propertyPlaceholder = "" />
		
		<!--- OK, this is for Peter and MachII, perhapse property placeholders can work for maps and arrays too --->
		<!--- resolve anything that looks like it should get replaced with a beanFactory default property --->
		<cfif isSimpleValue(mapEntries) and left(mapEntries,2) eq "${" and right(mapEntries,1) eq "}">
			<!--- grab the default properties out of the enclosing bean factory --->
			<cfset beanFactoryDefaultProperties = getParentBeanDefinition().getBeanFactory().getDefaultProperties() />
			<cfset propertyPlaceholder = mid(mapEntries,3,len(mapEntries)-3)/>
			<!--- look for this property value in the bean factory (using isDefined/evaluate incase of "." in property name)
				OR look for the property in the passed in struct ( do that first, as we may be postProcessing ) --->
			<cfif StructKeyExists(arguments, "properties")>
				<cfif StructKeyExists(arguments.properties, propertyPlaceholder) and 
						((returnType eq "list" and isArray(arguments.properties[propertyPlaceholder])) or 
						 (returnType eq "map" and isStruct(arguments.properties[propertyPlaceholder])))>
					<cfreturn arguments.properties[propertyPlaceholder] />
				<cfelse>
					<cfthrow type="BeanProperty.PlaceholderTypeError" message="The supplied value for property placeholder #propertyPlaceholder# is not of type #returnType#. This error occured while processing a beanFactoryPostProcessor!"/>
				</cfif>
			<cfelseif StructKeyExists(beanFactoryDefaultProperties, propertyPlaceholder)>
				<cfif (returnType eq "list" and isArray(beanFactoryDefaultProperties[propertyPlaceholder])) or 
					 (returnType eq "map" and isStruct(beanFactoryDefaultProperties[propertyPlaceholder]))>
					<cfreturn beanFactoryDefaultProperties[propertyPlaceholder] />
				<cfelse>
					<cfthrow type="BeanProperty.PlaceholderTypeError" message="The supplied value for property placeholder #propertyPlaceholder# is not of type #returnType#. This error occured while while resolving properties with the default bean factory properties!"/>
				</cfif>
			</cfif>
		</cfif>
	
		<!--- what are we gonna return, a struct or an array (e.g. are we parsing a <map/> or a <list/> --->
		<cfif returnType eq 'map'>
			<cfset rtn = structNew() />
		<cfelseif returnType eq 'list'>
			<cfset rtn = arrayNew(1) />
		<cfelse>
			<cfthrow type="coldspring.UnsupportedPropertyChild" message="Coldspring only supports map and list as complex types">
		</cfif>
			
		<cfloop from="1" to="#ArrayLen(mapEntries)#" index="ix">
			<!--- loop over the children --->
			<cfset entry = arguments.mapEntries[ix]/>
		
			<cfif returnType eq 'map'>
				<!--- right now we only support the <entry key=""> syntax for map entries.
					 this choice was made because CF does not support complex types as struct keys.
					 If it did we would also support <entry><key>*</key><value>*</value></entry> syntax
					 --->
				<cfif not structkeyexists(entry.xmlAttributes,'key')>
					<cfthrow type="coldspring.MalformedMapException" message="Map entries must have an attribute named 'key'">
				</cfif>			
				<cfif arraylen(entry.xmlChildren) neq 1>
					<cfthrow type="coldspring.MalformedMapException" message="Map entries must have one child">
				</cfif>
				<cfset entryChild = entry.xmlChildren[1]/>
				<cfset entryKey = entry.xmlAttributes.key />
			<cfelseif returnType eq 'list'>
				<cfset arrayAppend(rtn,"") />
				<cfset entryChild = entry/>
				<cfset entryKey = arrayLen(rtn) />
			</cfif>
			
			<!--- ok so the above code created a place to put something (e.g. struct[key] or array[n])
				  now lets find out what should placed there --->			
			
			<cfswitch expression="#entryChild.xmlName#">
				
				<cfcase value="value">
					<!--- easy, just put in your parsed value --->
					<cfif StructKeyExists(arguments, "properties")>
						<cfset rtn[entryKey] = parseValue(entryChild.xmlText, arguments.properties) />
					<cfelse>
						<cfset rtn[entryKey] = parseValue(entryChild.xmlText) />
					</cfif>
				</cfcase>
				
				<!--- for <ref/> and <bean/> elements within complex properties, we need make a 'placeholder'
				 		so that the beanFactory can replace this element with an actual bean instance when it 
				 		actually contructs the bean who this property belongs to
				 		coldspring.beans.BeanReference is used for this purpose... it's just a glorified beanID				 		
				 	 --->

				<cfcase value="ref">
					<!--- just put in a beanReference with the id of the bean --->
					<cfset entryBeanID = entryChild.xmlAttributes.bean />
					<cfset rtn[entryKey] = createObject("component", "coldspring.beans.BeanReference").init(
																									entryBeanID
																										)/>
					<cfset addParentDefinitionDependency(entryBeanID) />
				</cfcase>
				
				<cfcase value="bean">
					<!--- createInnerBeanDefinition now takes care of all the xml parsing and returns new beanUId --->
					<cfset entryBeanID = createInnerBeanDefinition(entryChild) />
					<cfset rtn[entryKey] = createObject("component","coldspring.beans.BeanReference").init(
																									entryBeanID
																										)/>
					<cfset addParentDefinitionDependency(entryBeanID) />
				</cfcase>					
				
				<cfcase value="map,list">
					<!--- recurse if we find another complex property --->
					<cfif StructKeyExists(arguments, "properties")>
						<<cfset rtn[entryKey] = parseEntries(entryChild.xmlChildren,entryChild.xmlName, arguments.properties) />
					<cfelse>
						<cfset rtn[entryKey] = parseEntries(entryChild.xmlChildren,entryChild.xmlName) />
					</cfif>										
				</cfcase>
			</cfswitch>
		</cfloop>
		<cfreturn rtn />
	
		
	</cffunction>

	<cffunction name="addParentDefinitionDependency" access="private" returntype="void" output="false"
				hint="Adds a dependency (probably found as a result of this property parsing its children) to the parent bean definition.">
		<cfargument name="refName" type="string" required="true" hint="id of bean who is dependent"/>
		<cfset getParentBeanDefinition().addDependency(arguments.refName) />
	</cffunction>
	
	<cffunction name="getParentBeanDefinition" access="public" returntype="coldspring.beans.BeanDefinition" output="false"
				hint="gets the bean definition who encloses this bean property">
		<cfreturn variables.instanceData.parentBeanDefinition />  
	</cffunction>
	
	<cffunction name="setParentBeanDefinition" access="public" returntype="void" output="false"
				hint="sets the bean definition who encloses this bean property">
		<cfargument name="parentBeanDefinition" type="coldspring.beans.BeanDefinition" />
		<cfset variables.instanceData.parentBeanDefinition = arguments.parentBeanDefinition />
	</cffunction>
	
	<cffunction name="createInnerBeanDefinition" access="public" returntype="uuid" output="false"
				hint="creates a new inner bean within the BeanFactory">
		<cfargument name="beanXml" type="any" required="true" hint="bean xml" />
		<!---
		<cfargument name="beanID" type="string" required="true" />
		<cfargument name="beanClass" type="string" required="true" />
		<cfargument name="children" type="any" required="true" />
		<cfargument name="initMethod" type="string" default="" required="false" />
		<cfargument name="factoryBean" type="string" default="" required="false" />
		<cfargument name="factoryMethod" type="string" default="" required="false" />
		<cfargument name="autoWire" type="string" default="" required="false" />
		<cfargument name="parent" type="string" default="" required="false" /> --->
		
		<cfset var beanProps = StructNew() />
		<!--- create uid for new Bean, store as value for lookup --->
		<cfset beanProps.beanID = CreateUUID() />
		
		<!--- this is an "inner-bean", e.g. a <bean/> tag within a <property/> or <constructor-arg/> 
			  note that inner-beans are "anonymous" prototypes, they are not available to be retrieved from the bean factory
			  this is done via obscurity: we register the bean by a UUID				
		--->								
		<cfif not (StructKeyExists(arguments.beanXml.XmlAttributes,'class'))
			  and not
			  	(
			  		StructKeyExists(arguments.beanXml.XmlAttributes,'factory-bean')
			  	and
			  		StructKeyExists(arguments.beanXml.XmlAttributes,'factory-method')
			  	)  >
			<cfthrow type="coldspring.MalformedInnerBeanException" message="Xml inner bean definitions must contain a 'class' attribute or 'factory-bean'/'factory-method' attributes!">
		</cfif>
		
		<!--- check for an init-method --->
		<cfif StructKeyExists(arguments.beanXml.XmlAttributes,'init-method') and len(arguments.beanXml.XmlAttributes['init-method'])>
			<cfset beanProps.initMethod = arguments.beanXml.XmlAttributes['init-method'] />
		<cfelse>
			<cfset beanProps.initMethod = ""/>
		</cfif>
		
		<!--- since the inner bean may be created via. factory-method, it might not have a class --->
		<cfif StructKeyExists(arguments.beanXml.XmlAttributes,'class') and len(arguments.beanXml.XmlAttributes['class'])>
			<cfset beanProps.class = arguments.beanXml.XmlAttributes['class'] />
		<cfelse>
			<cfset beanProps.class = ""/>
		</cfif>
		
		<cfif StructKeyExists(arguments.beanXml.XmlAttributes,'factory-method') and len(arguments.beanXml.XmlAttributes['factory-method'])>
			<cfset beanProps.factoryMethod = arguments.beanXml.XmlAttributes['factory-method'] />
			<cfset beanProps.factoryBean = arguments.beanXml.XmlAttributes['factory-bean'] />						
		<cfelse>
			<cfset beanProps.factoryMethod = ""/>
			<cfset beanProps.factoryBean = ""/>						
		</cfif>					

		<!--- look for an autowire attribute for this bean def --->
		<cfif StructKeyExists(arguments.beanXml.XmlAttributes,'autowire') and listFind('byName,byType',arguments.beanXml.XmlAttributes['autowire'])>
			<cfset beanProps.autowire = arguments.beanXml.XmlAttributes['autowire'] />
		<cfelse>
			<cfset beanProps.autowire = getParentBeanDefinition().getAutoWire()/>
		</cfif>
		
		<!--- look for a parent attribute --->
		<cfif StructKeyExists(arguments.beanXml.XmlAttributes,'parent')>
			<cfset beanProps.parent = arguments.beanXml.XmlAttributes['parent'] />
		<cfelse>
			<cfset beanProps.parent = "" />
		</cfif>
		
		<!--- call parent's bean factory to create new bean definition (inherit autowiring from it's parent for now)--->
		<cfset getParentBeanDefinition().getBeanFactory().createBeanDefinition(beanProps.beanID, 
																			   beanProps.class, 
																			   arguments.beanXml.XmlChildren, 
																			   false, 
																			   true, 
																			   true,
																			   beanProps.initMethod,
																			   beanProps.factoryBean,
																			   beanProps.factoryMethod,
																			   beanProps.autoWire,
																			   false,
																			   false,
																			   false,
																			   beanProps.parent)/>
		
		<!--- now return the new beanUID --->
		<cfreturn beanProps.beanID />
	</cffunction>
	
	<cffunction name="getName" access="public" output="false" returntype="string" hint="I retrieve the Name from this instance's data">
		<cfreturn variables.instanceData.Name/>
	</cffunction>

	<cffunction name="setName" access="public" output="false" returntype="void"  hint="I set the Name in this instance's data">
		<cfargument name="Name" type="string" required="true"/>
		<cfset variables.instanceData.Name = arguments.Name/>
	</cffunction>

	<cffunction name="getArgumentName" access="public" output="false" returntype="string" hint="I retrieve the Name from this instance's data">
		<cfif structKeyExists(variables.instanceData,"argName")>
			<cfreturn variables.instanceData.argName/>
		<cfelse>
			<cfreturn getName() />
		</cfif>
	</cffunction>

	<cffunction name="setArgumentName" access="public" output="false" returntype="void"  hint="I set the Name in this instance's data">
		<cfargument name="argName" type="string" required="true"/>
		<cfset variables.instanceData.argName = arguments.argName/>
	</cffunction>

	<cffunction name="getType" access="public" output="false" returntype="string" hint="I retrieve the Type from this instance's data">
		<cfreturn variables.instanceData.Type/>
	</cffunction>

	<cffunction name="setType" access="public" output="false" returntype="void"  hint="I set the Type in this instance's data">
		<cfargument name="Type" type="string" required="true"/>
		<cfset variables.instanceData.Type = arguments.Type/>
	</cffunction>
	
	<cffunction name="getValue" access="public" output="false" returntype="any" hint="I retrieve the Value from this instance's data">
		<cfreturn variables.instanceData.Value/>
	</cffunction>

	<cffunction name="setValue" access="public" output="false" returntype="void"  hint="I set the Value in this instance's data">
		<cfargument name="Value" type="any" required="true"/>
		<cfset variables.instanceData.Value = arguments.Value/>
	</cffunction>
	
	
</cfcomponent>