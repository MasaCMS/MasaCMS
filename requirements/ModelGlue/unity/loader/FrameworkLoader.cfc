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


<cfcomponent displayname="FrameworkLoader" hint="I load the Model-Glue framework given a beanFactory." output="false">

<cffunction name="init" returntype="ModelGlue.unity.loader.FrameworkLoader" access="public" output="false">
	<cfset variables._beanFactory = "" />
	<cfreturn this />
</cffunction>

<cffunction name="setBeanFactory" returntype="void" access="public" output="false">
	<cfargument name="beanFactory" type="any" required="true" />
	<cfset variables._beanFactory = arguments.beanFactory />
</cffunction>
<cffunction name="getBeanFactory" returntype="any" access="private" output="false">
	<cfreturn variables._beanFactory />
</cffunction>
<cffunction name="getBean" returntype="any" access="private" output="false">
	<cfargument name="name" type="string" required="true" />
	<cfreturn variables._beanFactory.getBean(arguments.name) />
</cffunction>

<cffunction name="load" returntype="ModelGlue.unity.framework.ModelGlue" access="public" output="true">
	<cfargument name="alternateConfigurationPath" type="string" required="true" default="">
	<cfargument name="loadingOptions" type="ModelGlue.unity.loader.LoadingOptions" required="true" default="">

	<cfset var cfg = getBean("ModelGlueConfiguration") />
	<cfset var mg = getBean("ModelGlue").init() />
	<cfset var beanFactory = getBeanFactory() />
	<cfset var eventLoader = getBean("EventLoader") />
	<cfset var configPath = cfg.getConfigurationPath() />
	<cfset var scaffoldPath = cfg.getScaffoldPath() />
	<cfset var scaffoldConfigPath = cfg.getScaffoldConfigurationPath() />
	<cfset var ormController = "" />
	<cfset var ormBeans = "" />
	<cfset var sessionTestKey = createUUID() />
	
	
	<cfset mg.setConfiguration(cfg) />
	
	<cftry>
		<cfset session[sessionTestKey] = "" />
		<cfset structDelete(session, sessionTestKey) />
		<cfcatch>
			<cfset mg.setUseSession(false) />
		</cfcatch>
	</cftry>
	
	<cfif left(configPath, 1) eq "/">
		<cfset configPath = expandPath(configPath) />
	<cfelse>
		<cfset configPath = expandPath(".") & "/" & configPath />
	</cfif>

	<cfif left(scaffoldPath, 1) eq "/">
		<cfset scaffoldPath = expandPath(scaffoldPath) />
	<cfelse>
		<cfset scaffoldPath = expandPath(".") & "/" & scaffoldPath />
	</cfif>
	
	<cfif len(arguments.alternateConfigurationPath)>
		<cfset configPath = arguments.alternateConfigurationPath />
		<cfset scaffoldPath = getDirectoryFromPath(configPath) & "scaffolds/Scaffolds.xml" />
	</cfif>
	
	<cfif left(scaffoldConfigPath, 1) eq "/">
		<cfset beanFactory.loadBeans(expandPath(scaffoldConfigPath)) />
	<cfelse>
		<cfset beanFactory.loadBeans(expandPath(".") & "/" & expandPath(scaffoldConfigPath)) />
	</cfif>
		
	<cfset eventLoader.setLoadingOptions(arguments.loadingOptions) />
	<cfset eventLoader.setBeanFactory(beanFactory) />
	<cfset mg.setBeanFactory(beanFactory) />
	
	<cfset mg = eventLoader.load(mg, configPath, scaffoldPath) />

	<cfset ormController = getBean("ORMController") />
	
	<cfset mg.addListener("ModelGlue.genericList", ormController, "genericList", false) />
	<cfset mg.addListener("ModelGlue.genericRead", ormController, "genericRead", false) />
	<cfset mg.addListener("ModelGlue.genericCommit", ormController, "genericCommit", false) />
	<cfset mg.addListener("ModelGlue.genericDelete", ormController, "genericDelete", false) />
	
	<cfreturn mg />
</cffunction>

</cfcomponent>