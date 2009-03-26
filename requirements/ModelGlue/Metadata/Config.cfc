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


<cfcomponent displayname="Config" extends="ModelGlue.Util.GenericCollection">

<cffunction name="Init" access="public" output="false" hint="Constructor">
	<cfset super.Init() />

	<cfset setValue("defaultEvent" ,"Home") />
	<cfset setValue("reload" ,"true") />
	<cfset setValue("reloadKey" ,"init") />
	<cfset setValue("reloadPassword" ,"true") />
	<cfset setValue("statePrecedence" ,"Form") />
	<cfset setValue("eventValue" ,"event") />
	<cfset setValue("self" ,"index.cfm") />
	<cfset setValue("defaultExceptionHandler" ,"Exception") />
	<cfset setValue("debug" ,"true") />
	<cfset setValue("defaultCacheTimeout" ,"5") />
	<cfset setValue("stateBuilder" ,"ModelGlue.Util.GenericCollection") />
	<cfset setValue("beanFactoryLoader" ,"ModelGlue.Core.ChiliBeansLoader") />
	<cfset setValue("autowireControllers", "false") />
	<cfreturn this />
</cffunction>

</cfcomponent>