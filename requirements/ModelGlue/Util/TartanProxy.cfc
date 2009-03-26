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


<cfcomponent displayName="TartanProxy" output="false" hint="Acts as a proxy for communicating with Paul Kenney's Tartan Framework.">
  <cffunction name="init" returnType="TartanProxy" output="false" hint="I build a new TartanProxy.">
    <cfargument name="configBean" type="ModelGlue.Bean.CommonBeans.TartanConfiguration" required="true">

    <cfset var temp = structNew() />
	  <cfset temp.configuration = arguments.configBean.getConfig() />
	  <cfset temp.type = arguments.configBean.getType() />

	  <cftry>
		  <cfset variables.serviceLoader = createObject("component", "tartan.ServiceLoader").init(temp) />
			<cfcatch>
				<cfif structKeyExists(cfcatch, "missingFileName") and cfcatch.missingFileName eq "tartan.ServiceLoader">
					<cfthrow message="Oops!  It doesn't look like you have the Tartan framework installed!" detail="Get Tartan at http://www.tartanframework.org" />
				</cfif>
		  </cfcatch>
		</cftry>

    <cfreturn this />
  </cffunction>

	<cffunction name="CreateService" returntype="tartan.service.LocalService" access="public" output="false" hint="I create a Tartan service by name.">
	  <cfargument name="name" type="string" required="true" />
	  <cfreturn variables.serviceLoader.getService(name) />
	</cffunction>

	<cffunction name="InvokeCommand" returntype="any" access="public" output="false" hint="I invoke a command on a given service.">
	  <cfargument name="service" required="true" hint="I am the service to invoke the command upon." />
	  <cfargument name="command" type="string" required="true" hint="I am the command name to invoke." />
    <cfargument name="commandArgs" type="struct" required="true" hint="I am the argument collection for the command." />
    <cfset var result = "" />
		<cfinvoke component="#arguments.service#" method="#arguments.command#" argumentcollection="#arguments.commandArgs#" returnvariable="result"/>
    <cfreturn result />
	</cffunction>
</cfcomponent>