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


<cfcomponent displayName="Event" output="false" hint="I am metadata about Commit scaffold." extends="ModelGlue.unity.eventhandler.EventHandler">
  <cffunction name="init" returnType="ModelGlue.unity.eventhandler.EventHandler" output="false" hint="I build a new event.">
		<cfargument name="objectMetadata" type="struct" required="true" />
		<cfargument name="viewGenerator" type="ModelGlue.unity.view.ViewGenerator" required="true" />
		<cfargument name="generatedViews" type="array" required="true" />

  	<cfset super.init() />

		<!--- Set info we'll need for further config --->
		<cfset variables.objectMetadata = arguments.objectMetadata />  	
		<cfset variables.objectName = arguments.objectMetadata.xml.object.alias.xmlText />  	
  	
  	<!--- Set name --->
  	<cfset setName(variables.objectName & ".Commit") />
  	
    <cfreturn this />
  </cffunction>

  <cffunction name="doPostConfiguration" returnType="void" output="false" hint="I add the scaffold's implicit messages and result mappings.">
		<cfset var msg = "" />
		<cfset var keyList = arrayToList(variables.objectMetadata.primaryKeys) />

  	<!--- Add Messages --->
  	<cfset msg = createObject("component", "ModelGlue.unity.eventhandler.Message").init() />
  	<cfset msg.setName("ModelGlue.genericCommit") />
  	<cfset msg.addArgument("object", variables.objectName) />
		<cfset msg.addArgument("criteria", keyList) />
  	<cfset msg.addArgument("recordName", variables.objectName & "Record") />
  	<cfset msg.addArgument("validationName", variables.objectName & "Validation") />
  	<cfset addMessage(msg) />
  	
  	<!--- Add Results --->
		<cfif not resultMappingExists("commit")>
	  	<cfset addResultMapping("commit", variables.objectName & ".list", true, "", "", false, false) />
	  </cfif>
		<cfif not resultMappingExists("validationError")>
	  	<cfset addResultMapping("validationError", variables.objectName & ".edit", false, keyList, "", false, false) />
	  </cfif>
	</cffunction>

</cfcomponent>
