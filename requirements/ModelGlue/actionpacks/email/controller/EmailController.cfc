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


<cfcomponent displayname="Controller" extends="ModelGlue.unity.controller.Controller" output="false">

	<!--- Autowire / private getter --->
	<cffunction name="setEmailService" access="public" returntype="void" output="false">
		<cfargument name="emailService" required="true" type="any" />
		<cfset variables._svc = arguments.emailService />
	</cffunction>
	<cffunction name="getEmailService" access="private" returntype="any" output="false">
		<cfreturn variables._svc />
	</cffunction>


	<!--- Place the service into the viewstate --->
	<cffunction name="loadEmailService" access="public" returnType="void" output="false">
	  <cfargument name="event" type="any">
	  
	  <cfset arguments.event.setValue("emailService", getEmailService()) />
	</cffunction>
</cfcomponent>