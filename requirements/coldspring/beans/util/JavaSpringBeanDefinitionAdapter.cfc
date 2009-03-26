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
		
			
 $Id: JavaSpringBeanDefinitionAdapter.cfc,v 1.1 2006/07/02 13:38:33 rossd Exp $

---> 

<!--- this code provides an adapter so that we can translate Spring bean definitions
	  into ColdSpring BeanDefinitions. The definitions will not expose any 
	  properties or constructor-args - they will only contain a id/name and
	  a class. The getBeanInstance method will simply delegate to the
	  supplied java Spring BeanFactory --->


<cfcomponent extends="coldspring.beans.BeanDefinition" output="false">

	<cffunction name="init" returntype="coldspring.beans.BeanDefinition" output="false">
		<cfargument name="ColdSpringBeanFactory" type="coldspring.beans.AbstractBeanFactory" required="true"/>
		<cfargument name="SpringBeanFactory" type="any" hint="A Java Spring BeanFactory implementing org.springframework.beans.AbstractBeanFactory" required="true"/>
		<cfargument name="BeanName" required="true"/>
		
		
		<cfset setBeanFactory(arguments.ColdSpringBeanFactory)/>		
		<cfset variables.SpringBeanFactory = arguments.SpringBeanFactory/>
		<cfset variables.BeanName = arguments.BeanName/>
		
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="getBeanInstance" returntype="any" output="false">
		
		<cfreturn variables.SpringBeanFactory.getBean(variables.BeanName)/>
		
	</cffunction>
	
	<cffunction name="getDependencies" returntype="void" output="false">
		<!--- do nothing - as far as ColdSpring is concerned this bean has
				no dependencies  --->
	</cffunction>	
	
</cfcomponent>