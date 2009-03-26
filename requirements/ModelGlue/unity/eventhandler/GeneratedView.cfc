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


<cfcomponent displayname="GeneratedView" output="false">

<cffunction name="init" returntype="ModelGlue.unity.eventhandler.generatedView" output="false">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="xsl" type="string" required="true" />
	<cfargument name="prefix" type="string" required="true" />
	<cfargument name="suffix" type="string" required="true" />
	
	<cfset variables._name = arguments.name />
	<cfset variables._xsl = arguments.xsl />
	<cfset variables._prefix = arguments.prefix />
	<cfset variables._suffix = arguments.suffix />
	
	<cfreturn this />
</cffunction>

<cffunction name="getName" returntype="string" access="public" output="false">
	<cfreturn variables._name />
</cffunction>

<cffunction name="getXsl" returntype="string" access="public" output="false">
	<cfreturn variables._xsl />
</cffunction>

<cffunction name="getPrefix" returntype="string" access="public" output="false">
	<cfreturn variables._prefix />
</cffunction>

<cffunction name="getSuffix" returntype="string" access="public" output="false">
	<cfreturn variables._suffix />
</cffunction>

</cfcomponent>