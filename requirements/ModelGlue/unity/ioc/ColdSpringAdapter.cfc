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


<cfcomponent displayname="ColdSpringAdapter" hint="I let Model-Glue use ColdSpring." extends="ModelGlue.unity.ioc.AbstractIOCAdapter">

<cffunction name="init" returntype="ModelGlue.unity.ioc.AbstractIOCAdapter" output="false" access="public">
	<cfset variables._beanFactory = "" />
	<cfreturn this />
</cffunction>

<cffunction name="setFramework" returntype="void" output="false" access="public">
	<cfargument name="framework" type="ModelGlue.unity.framework.ModelGlue" required="true" />
	<cfset variables._framework = arguments.framework />
</cffunction>

<cffunction name="getBeanFactory" returntype="any" output="false" access="public">
	<cfreturn variables._beanFactory />
</cffunction>

<cffunction name="loadBeans" returntype="void" output="false" access="public">
	<cfargument name="beanMappings" type="string" required="true">
	
	<cfset var i = "" />

	<cfif not isObject(variables._beanFactory)>
		<cfset variables._beanFactory = variables._framework.getBeanFactory() />
	</cfif>
	
	<cfloop list="#arguments.beanMappings#" index="i">
		<cfset variables._beanFactory.loadBeans(expandPath(i)) />
	</cfloop>
</cffunction>

<cffunction name="getBean" returntype="any" output="false" access="public">
	<cfargument name="name" type="string" required="true" />
	
	<cfif not isObject(variables._beanFactory)>
		<cfset variables._beanFactory = variables._framework.getBeanFactory() />
	</cfif>
	
	<cfreturn variables._beanFactory.getBean(arguments.name) />
</cffunction>

</cfcomponent>