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
		
			
 $Id: AbstractAutowireTests.cfc,v 1.4 2007/11/28 02:26:19 scottc Exp $

--->

<cfcomponent displayname="AbstractAutowireTests"
			 extends="org.cfcunit.framework.TestCase">
	
	<cffunction name="setUp" access="public" returntype="void" output="false">
		<cfset initBeanFactory() />
		<cfset onSetUp() />
	</cffunction>
	
	<cffunction name="onSetUp" access="private" returntype="void" output="false">
		<!--- override onSetUp instead of using setUp --->
	</cffunction>
	
	<cffunction name="tearDown" access="private" returntype="void" output="false">
		<cfset onTearDown() />
	</cffunction>
	
	<cffunction name="onTearDown" access="private" returntype="void" output="false">
		<!--- override onTearDown instead of using tearDown --->
	</cffunction>
			 
	<cffunction name="getConfigLocations" access="public" returntype="String">
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="initBeanFactory" access="private" returntype="void" output="false">
		<cfset var configLocations = getConfigLocations() />
		<cfif len(configLocations)>
			<cfset variables.beanFactory = CreateObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
			<!--- todo: add support for multiple config files... --->
			<cfset variables.beanFactory.loadBeans(configLocations) />
			<cfset autowireTestCase() />
		</cfif>
	</cffunction>
	
	<cffunction name="autowireTestCase" access="private" returntype="void" output="false">
		<!--- getMetadata, autowire setters... --->
		<cfset var targetIx = 0 />
		
		<cfset var md = "" />
		<cfset var functionIndex = 0 />
		
		<cfset var setterName = "" />
		<cfset var beanName = "" />
		<cfset var access = "" />

		<!--- Look for autowirable collaborators for any SETTERS --->
		<cfset md = GetMetaData(this) />
		
		<cfif StructKeyExists(md, "functions")>
			<cfloop from="1" to="#arraylen(md.functions)#" index="functionIndex">
				<!--- first get the access type --->
				<cfif StructKeyExists(md.functions[functionIndex], "access")>
					<cfset access = md.functions[functionIndex].access />
				<cfelse>
					<cfset access = "public" />
				</cfif>
				
				<!--- if this is a 'real' setter --->
				<cfif Left(md.functions[functionIndex].name, 3) EQ "set" 
						  AND Arraylen(md.functions[functionIndex].parameters) EQ 1 
						  AND (access IS NOT "private")>
					
					<!--- look for a bean in the factory of the params's type --->	  
					<cfset setterName = Mid(md.functions[functionIndex].name, 4, Len(md.functions[functionIndex].name)-3) />
					
					<!--- Get bean by setter name and if not found then get by type --->
					<cfif beanFactory.containsBean(setterName)>
						<cfset beanName = setterName />
					<cfelse>
						<cfset beanName = beanFactory.findBeanNameByType(md.functions[functionIndex].parameters[1].type) />
					</cfif>
					
					<!--- If we found a bean, put the bean by calling the target object's setter --->
					<cfif Len(beanName)>
						<cfinvoke component="#this#"
								  method="set#setterName#">
							<cfinvokeargument name="#md.functions[functionIndex].parameters[1].name#"
								  	value="#beanFactory.getBean(beanName)#"/>
						</cfinvoke>	
					</cfif>			  
				</cfif>
			</cfloop>		
		</cfif>
		
	</cffunction>


</cfcomponent>