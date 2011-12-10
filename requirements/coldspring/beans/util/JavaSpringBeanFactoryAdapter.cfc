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
		
			
 $Id: JavaSpringBeanFactoryAdapter.cfc,v 1.1 2006/07/02 13:38:33 rossd Exp $

---> 

<!--- 
	This component provides an adapter so that a java Spring Bean Factory
	may be set as a parent to a ColdSpring BeanFactory

 --->

<cfcomponent name="JavaSpringBeanFactoryAdapter" extends="coldspring.beans.AbstractBeanFactory" output="false">

	<cffunction name="init" returntype="coldspring.beans.AbstractBeanFactory" output="false">
		<cfargument name="SpringBeanFactory" required="true" hint="A Java Spring BeanFactory implementing org.springframework.beans.AbstractBeanFactory" />
		<cfset variables.SpringBeanFactory = arguments.SpringBeanFactory/>
		<cfreturn this/>
	</cffunction>

	<cffunction name="getBean" returntype="any" output="false">
		<cfargument name="beanName" type="string" required="true"/>
		
		<cfreturn variables.SpringBeanFactory.getBean(arguments.beanName)/>
		
	</cffunction>
	

	<cffunction name="containsBean" returntype="boolean" output="false">
		<cfargument name="beanName" type="string" required="true"/>
		
		<cfreturn variables.SpringBeanFactory.containsBean(arguments.beanName)/>
		
	</cffunction>
	
	<!--- hopefully we can remove the following 3 methods in the future
	  I'm not sure why the parent-child beanFactory relationship
	  requires these - I think we should only rely on 
	  getBean() and containsBean() for parent-child BF communication. --->
	
	<cffunction name="getBeanFromSingletonCache" returntype="any" output="false">
		<cfargument name="beanName" type="string" required="true">
				
		<cfreturn variables.SpringBeanFactory.getBean(arguments.beanName)/>
		
	</cffunction>
		
	<cffunction name="singletonCacheContainsBean" returntype="boolean" output="false">
		<cfargument name="beanName" type="string" required="true"/>
					  
		<cfreturn containsBean(arguments.beanName)/>
		
	</cffunction>

	<cffunction name="getBeanDefinition" returntype="coldspring.beans.BeanDefinition" output="false">
		<cfargument name="beanName" type="string" required="true"/>
		
		<!--- create an adapter that will mimic a CS BeanDef --->		
		<cfset var beanDefinitionAdapter = createObject("component","coldspring.beans.util.JavaSpringBeanDefinitionAdapter").init(this,variables.SpringBeanFactory,arguments.beanName)/>
		
		<!--- set the ID and Class of the def --->
		<cfset var originalSpringBeanDefinition = variables.SpringBeanFactory.getBeanDefinition(arguments.beanName)/>
		<cfset beanDefinitionAdapter.setBeanId(arguments.beanName)/>
		<cfset beanDefinitionAdapter.setBeanClass(originalSpringBeanDefinition.getBeanClassName())/>
		
		<cfreturn beanDefinitionAdapter/>
		
		
	</cffunction>
	
	
	
	




</cfcomponent>