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
		
			
 $Id: ModelGlueBeanFactoryAdapter.cfc,v 1.5 2005/11/16 16:16:11 rossd Exp $
  
  This is the first cut at writing an adapter CFC to allow replacing 
  the ModelGlue framework's internal beanFactory with a coldspring bean
  factory. The following code would be used within a ModelGlue
  controller:
  
  <cfset var beanFactory = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init()/>
  <cfset var mgAdapterFactory = createObject("component","coldspring.modelglue.ModelGlueBeanFactoryAdapter").init()/>
  <cfset super.Init(arguments.ModelGlue) />
  
  <cfset beanFactory.loadBeans(expandPath("./config/beans/allBeans.xml"))>
	
  <cfset mgAdapterFactory.setBeanFactory(beanFactory)/>

  <cfset arguments.ModelGlue.setBeanFactory(mgAdapterFactory)>
  
--->

<cfcomponent
	extends="ModelGlue.Bean.BeanFactory">
		
	<cffunction name="init" returntype="coldspring.modelglue.ModelGlueBeanFactoryAdapter" access="public" output="false">
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="setBeanFactory" access="public" returnType="any" output="false" 
				hint="Dependency: the real coldspring bean factory to use">
   		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true" />
	
   		<cfset variables.myBeanFactory = arguments.beanFactory />		

	</cffunction>

	<cffunction name="getBeanFactory" returntype="coldspring.beans.BeanFactory" access="public" output="false" 
				hint="Return the real coldspring bean factory (used by the autowiring code)">
		
		<cfreturn variables.myBeanFactory />
		
	</cffunction>
	
	<cffunction name="CreateBean" access="public" returnType="any" output="false" hint="I create a bean from an XML file.">
   		<cfargument name="beanFile" type="string" required="true" hint="I am the filename representing the bean to instantiate." />

		<!--- if the bean name ends with .xml (which it should), we'll strip off the extension
			  typically you would register beans in coldspring just by their name  --->

   		<cfset var beanName = arguments.beanFile />
		<cfif right(arguments.beanFile,4) eq ".xml">
			<cfset beanName = mid(arguments.beanFile,1,len(arguments.beanFile)-4) />
		</cfif>


		<!--- now we try to get the bean from coldspring by this adjusted name.
			  If coldspring doesn't recognize, we try with the original "filename"
			   --->
		<cftry>
			<cfreturn variables.myBeanFactory.getBean(beanName)>/>
			
			<cfcatch type="coldspring.NoSuchBeanDefinitionException">
				<cfreturn variables.myBeanFactory.getBean(arguments.beanFile)>/>
			</cfcatch>
			
		</cftry>		
	</cffunction>

</cfcomponent>