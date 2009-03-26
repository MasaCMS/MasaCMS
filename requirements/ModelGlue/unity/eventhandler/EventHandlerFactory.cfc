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


<cfcomponent displayname="EventHandlerFactory" output="false">

<cffunction name="init" returntype="ModelGlue.unity.eventhandler.EventHandlerFactory" output="false">
	<cfargument name="EventHandlerTypes" type="struct" required="true" />
	<cfargument name="ViewGenerator" type="ModelGlue.unity.view.ViewGenerator" required="true" />
	<cfargument name="Framework" type="ModelGlue.unity.framework.ModelGlue" required="true" />
	
	<cfset variables._ehTypes = arguments.eventHandlerTypes />
	<cfset variables._viewGenerator = arguments.ViewGenerator />
	<cfset variables._ormAdapterLoaded = true />
	
	<cftry>
		<cfset variables._ormAdapter = arguments.Framework.getormAdapter()/>	
		<cfcatch type="coldspring.NoSuchBeanDefinitionException">
			<cfset variables._ormAdapterLoaded = false />
		</cfcatch>
	</cftry>
		
	<cfreturn this />
</cffunction>

<cffunction name="create" returntype="ModelGlue.unity.eventhandler.EventHandler" output="true">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="table" type="string" required="false" default="" />
	<cfargument name="rescaffold" type="boolean" required="false" default="false" />
		
	<cfset var handler = "" />
	<cfset var view = "" />
	<cfset var genViews = "" />
	<cfset var views = arrayNew(1) />
	<cfset var md = structNew() />
	
	<cfif len(arguments.table) and variables._ormAdapterLoaded>
		<cfset md = variables._ormAdapter.getObjectMetadata(arguments.table) />
	</cfif>

	<cfif not structKeyExists(variables._ehTypes, arguments.type)>
		<cfthrow message="Model-Glue:  The EventHandler type ""#arguments.type#"" is not defined in your configuration file." />
	</cfif>
	
	<cfset genViews = variables._ehTypes[arguments.type].views />
	
	<cfloop from="1" to="#arrayLen(genViews)#" index="i">
		<cfset view = createObject("component", "ModelGlue.unity.eventhandler.GeneratedView").init(genViews[i].name, genViews[i].xsl, genViews[i].prefix, genViews[i].suffix) />
		<cfset arrayAppend(views, view) />
	</cfloop>
	<cfset handler = createObject("component", variables._ehTypes[arguments.type].class).init(md, variables._viewGenerator, views) />
		
	<cfreturn handler />
</cffunction>

</cfcomponent>
