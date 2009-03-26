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
		
			
 $Id: BeanFactoryLocator.cfc,v 1.2 2008/04/19 02:33:11 scottc Exp $

---> 

<cfcomponent name="BeanFactoryLocator" 
			displayname="BeanFactoryLocator" 
			hint="Places the bean factory in a speccified key in app scope (for remoting)" 
			output="false">
				
	<cfset variables.beanFactoryName = "" />
	<cfset variables.beanFactoryScope = "application" />
			
	<cffunction name="init" access="public" 
				returntype="coldspring.beans.factory.config.BeanFactoryLocator" 
				output="false"
				hint="Constructor. Creates a new BeanFactoryLocator.">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setBeanFactoryName" access="public" returntype="void" output="false">
		<cfargument name="beanFactoryName" type="string" required="true" />
		<cfset variables.beanFactoryName = arguments.beanFactoryName />
	</cffunction>
	
	<cffunction name="setBeanFactoryScope" access="public" returntype="void" output="false">
		<cfargument name="beanFactoryScope" type="string" required="true" />
		<cfset variables.beanFactoryScope = arguments.beanFactoryScope />
	</cffunction>
	
	<cffunction name="postProcessBeanFactory" access="public" returntype="string" output="false">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true"/>
		<cfset var bf = 0/>
		<cfset var bfUtils = createObject("component","coldspring.beans.util.BeanFactoryUtils").init()/>
		<cfif not len(variables.beanFactoryName)>
			<cfset bf = bfUtils.setDefaultFactory(variables.beanFactoryScope, arguments.beanFactory) />
		<cfelse>
			<cfset bf = bfUtils.setNamedFactory(variables.beanFactoryScope, variables.beanFactoryName, arguments.beanFactory) />
		</cfif>
	</cffunction>
	
</cfcomponent>