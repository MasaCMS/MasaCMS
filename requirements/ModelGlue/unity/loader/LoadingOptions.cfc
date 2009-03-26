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


<cfcomponent displayname="LoadingOptions" hint="I contain options related to partial reloading of the framework.">

<cfset variables.rescaffold = false />

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="SetRescaffold" output="false" hint="I set whether or not the framework should re-generate scaffold XML and view code.">
	<cfargument name="rescaffold" type="boolean" required="true" />
	<cfset variables.rescaffold = arguments.rescaffold />
</cffunction>

<cffunction name="GetRescaffold" output="false" hint="I get whether or not the framework should re-generate scaffold XML and view code.">
	<cfreturn variables.rescaffold />
</cffunction>

</cfcomponent>