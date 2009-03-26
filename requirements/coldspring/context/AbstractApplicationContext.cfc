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
		
			
 $Id: AbstractApplicationContext.cfc,v 1.2 2005/11/16 16:16:11 rossd Exp $

	Implements the BeanFactory interface as well as providing an interface for hierarchical 
	bean containers 
--->

<cfcomponent name="Abstract Application Context" hint="I provide an interface for a hierarchical bean factory context.">
	
	<cffunction name="init" access="private">
		<cfthrow type="Method.NotImplemented">
	</cffunction>

	<cffunction name="containsBean" returntype="boolean" hint="checks the bean factory to see if an definition of the given name/id exists" access="public">
		<cfargument name="beanName" required="true" type="string"/>
		<cfthrow type="Method.NotImplemented">
	</cffunction>
	
	<cffunction name="getBean" returntype="any" hint="returns an instance from the bean factory of the supplied name/id. Throws: coldspring.NoSuchBeanDefinitionException if given definition is not found." access="public">
		<cfargument name="beanName" required="true" type="string"/>
		<cfthrow type="Method.NotImplemented">
	</cffunction>	
	
	<cffunction name="isSingleton" access="public" returntype="boolean" hint="I inform the caller whether the definition for the given bean is a 'singleton'. Non-singletons will be returned as new instances. Throws: coldspring.NoSuchBeanDefinitionException if given definition is not found.">
		<cfthrow type="Method.NotImplemented">
	</cffunction>

	<cffunction name="setParent" access="public" returntype="void" output="false">
		<cfargument name="appContext" type="coldspring.context.AbstractApplicationContext">
		<cfthrow type="Method.NotImplemented">
	</cffunction>

	<cffunction name="getParent" access="public" returntype="coldspring.context.AbstractApplicationContext" output="false">
		<cfthrow type="Method.NotImplemented">
	</cffunction>

</cfcomponent>