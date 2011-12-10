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
		
			
 $Id: PropertyPlaceholderConfigurer.cfc,v 1.2 2007/06/02 21:02:57 scottc Exp $

---> 

<cfcomponent name="PropertyPlaceholderConfigurer" 
			displayname="PropertyPlaceholderConfigurer" 
			hint="Resolves placeholders in bean property values of context definitions" 
			output="false">
				
	<cfset variables.beanID = "" />
			
	<cffunction name="init" access="public" 
				returntype="coldspring.beans.factory.config.PropertyPlaceholderConfigurer" 
				output="false"
				hint="Constructor. Creates a new PropertyPlaceholderBean.">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setLocation" access="public" returntype="void" output="false"
				hint="Sets the location of the properties file">
		<cfargument name="location" type="string" required="true" hint="Location of the properties file."/>
		<cfset variables.location = arguments.location />
	</cffunction>

	<cffunction name="setBeanID" access="public" output="false" returntype="void"  
				hint="I set the BeanID so that we don't try to resolve any placeholders in the processors own definition">
		<cfargument name="beanID" type="string" required="true"/>
		<cfset variables.beanID = arguments.beanID />
	</cffunction>
	
	<cffunction name="postProcessBeanFactory" access="public" returntype="string" output="false">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true"/>
		<cfset var beanDefinitions = arguments.beanFactory.getBeanDefinitionList() />
		<cfset var bean = 0 />
		
		<cfset loadProperties() />

		<cfloop collection="#beanDefinitions#" item="bean">
			<cfif bean neq variables.beanID>
				<cfset resolveProperties(beanDefinitions[bean]) />
			</cfif>
		</cfloop>
			
	</cffunction>
	
	<cffunction name="resolveProperties" access="private" returntype="void" output="false" hint="Reprocesses the bean definition's properties with the local property data">
		<cfargument name="beanDef" type="coldspring.beans.BeanDefinition" />
		<cfset var arg = 0 />
		<cfset var prop = 0 />
		<cfset var argDefs = beanDef.getConstructorArgs()/>
		<cfset var propDefs = beanDef.getProperties()/>
		
		<!--- loop over constructor-args and tell them to resolvePropertyPlaceholders --->
		<cfloop collection="#argDefs#" item="arg">
			<cfset argDefs[arg].resolvePropertyPlaceholders(variables.properties) />						
		</cfloop>
		<!--- loop over properties and tell them to resolvePropertyPlaceholders --->
		<cfloop collection="#propDefs#" item="prop">
			<cfset propDefs[prop].resolvePropertyPlaceholders(variables.properties) />						
		</cfloop>
	</cffunction>
		
	
	<cffunction name="loadProperties" access="private" returntype="void" output="false" hint="Loads properties into a local struct from the properties file">
		<cfset var inStream = createObject("java","java.io.FileInputStream") />
		<cfset var props = createObject("java","java.util.Properties")/>
		<cfset var propNames = 0/>
		<cfset var prop = 0 />
		<cfset var p = 0 />
		<cfset var propsFile = "" />
		<cfset var fileerror = "" />
		<cfset variables.properties = StructNew() />
		
		<!--- I'll try to load the props file relative, then absolute? --->
		<cftry>
			<cfset propsFile = expandPath(variables.location) />
			<cfset inStream.init(propsFile) />
			<cfset props.load(inStream) />
			<cfcatch>
				<cftry>
					<cfset propsFile = variables.location />
					<cfset inStream.init(propsFile) />
					<cfset props.load(inStream) />
					<cfcatch>
						<cfset fileerror = expandPath(variables.location) & " or " & variables.location />
						<cfthrow type="coldspring.filepath.error" message="Unable to find property file in either #fileerror#" />
					</cfcatch>
				</cftry>
			</cfcatch>
		</cftry>
		
		
		<!--- get the property keys --->
		<cfset propNames = props.keySet().toArray()/>
		
		<!--- loop and get a struct --->	
		<cfloop from="1" to="#arraylen(propNames)#" index="p">
			<cfset prop = propNames[p] />
			<cfset variables.properties[prop] = props.get(prop) />
		</cfloop>
		
		<cfset this.props = variables.properties />
	</cffunction>
	
</cfcomponent>