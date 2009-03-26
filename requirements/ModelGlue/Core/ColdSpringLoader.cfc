<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent displayname="ColdSpringLoader" output="false">
	
<cffunction name="init" returntype="ColdSpringLoader" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="load" returntype="ModelGlue.Bean.BeanFactory" output="false">
	<cfargument name="beanMappings" type="string" required="true" />

  <cfset var beanFactory = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init()/>
  <cfset var mgAdapterFactory = createObject("component","coldspring.modelglue.ModelGlueBeanFactoryAdapter").init()/>
  <cfset var beanFile = ""/>

  <cfloop list="#arguments.beanMappings#" index="beanFile">
    <cfset beanFactory.loadBeans(expandPath(beanFile))>
  </cfloop>

	<cfset mgAdapterFactory.setBeanFactory(beanFactory)/>
	<cfreturn mgAdapterFactory />
</cffunction>

</cfcomponent>