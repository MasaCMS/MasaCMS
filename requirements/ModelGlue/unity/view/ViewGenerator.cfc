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


<cfcomponent displayname="ViewGenerator" output="false">

<cffunction name="init" returntype="ModelGlue.unity.view.ViewGenerator" output="false">
	<cfargument name="modelGlueConfiguration" type="ModelGlue.unity.framework.ModelGlueConfiguration" required="true">
	
	<cfset variables._outDir = expandPath(arguments.modelGlueConfiguration.getGeneratedViewMapping()) />
	
	<cfif not directoryExists(variables._outDir)>
		<cftry>
			<cfdirectory action="create" directory="#variables._outDir#" />
			<cfcatch>
				<cfthrow message="Model-Glue:  Couldn't create #variables._outDir#." />
			</cfcatch>
		</cftry>
	</cfif>
	<cfreturn this />
</cffunction>

<cffunction name="getOutputDirectory" returntype="string" access="private" output="false">
	<cfreturn variables._outDir />
</cffunction>

<cffunction name="generate" returntype="void" access="public" output="false">
	<cfargument name="filename" type="string" required="true" />
	<cfargument name="objectMetadata" type="struct" required="true" />
	<cfargument name="xslTemplate" type="string" required="true" />
	
	<cfset var md = arguments.objectMetadata.xml />
	<cfset var content = "" />
	<cfset var xsl = "" />
	<cfset var dir = getOutputDirectory() />
	
	<cffile action="read" variable="xsl" file="#expandPath(arguments.xslTemplate)#" />
	
	<cfset content = xmlTransform(md, xsl) />
	
	<cfif not directoryExists(dir)>
		<cfdirectory action="create" directory="#dir#" />
	</cfif>
	
	<cffile action="write" file="#dir & "/" & arguments.filename#" output="#content#" />
</cffunction>

</cfcomponent>