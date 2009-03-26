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


<cfcomponent displayName="Controller" output="false" hint="I am the base for any Model-Glue controllers." extends="ModelGlue.unity.controller.Controller">

<!--- Just a shell used for typing for reverse compatibility. --->


<cffunction name="Init" access="public" returnType="ModelGlue.Core.Controller" output="false" hint="I return a new Controller.">
  <cfargument name="ModelGlue" type="ModelGlue.unity.framework.ModelGlue" required="true" hint="I am an instance of ModelGlue.">
  <cfargument name="name" type="string" required="false" default="#createUUID()#" hint="A name for this controller.">

	<cfset super.init(arguments.ModelGlue, arguments.name) />

  <cfreturn this />
</cffunction>
	
</cfcomponent>