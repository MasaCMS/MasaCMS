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


<cfcomponent displayName="Event" output="false" hint="I am metadata about View scaffold." extends="ModelGlue.unity.eventhandler.EventHandler">
  <cffunction name="init" returnType="ModelGlue.unity.eventhandler.EventHandler" output="false" hint="I build a new event.">
		<cfargument name="objectMetadata" type="struct" required="true" />
		<cfargument name="viewGenerator" type="ModelGlue.unity.view.ViewGenerator" required="true" />
		<cfargument name="generatedViews" type="array" required="true" />

		<cfset var view = "" />
		<cfset var i = "" />
		<cfset var file = "" />
		
  	<cfset super.init() />

		<!--- Set info we'll need for further config --->
		<cfset variables.objectMetadata = arguments.objectMetadata />  	
		<cfset variables.objectName = arguments.objectMetadata.xml.object.alias.xmlText />  	
  	
  	<!--- Set name --->
  	<cfset setName(variables.objectName & ".view") />

  	<!--- Add Views --->
  	<cfloop from="1" to="#arrayLen(arguments.generatedViews)#" index="i">
  		<cfset file = arguments.generatedViews[i].getPrefix() & variables.objectName & arguments.generatedViews[i].getSuffix() />
	  	<cfset arguments.viewGenerator.generate(file, arguments.objectMetadata, arguments.generatedViews[i].getXsl()) />
	  	<cfset view = createObject("component", "ModelGlue.unity.eventhandler.View").init() />
	  	<cfset view.setName("body") />
	  	<cfset view.setTemplate(file) />
	  	<cfset view.setAppend(true) />
	  	<cfswitch expression="#arguments.generatedViews[i].getName()#">
	  		<cfcase value="view">
			  	<cfset view.addValue("xe.list", variables.objectName & ".list", true) />
	  		</cfcase>
	  	</cfswitch>
	  	<cfset addView(view) />
  	</cfloop>
  	
    <cfreturn this />
  </cffunction>

  <cffunction name="doPostConfiguration" returnType="void" output="false" hint="I add the scaffold's implicit messages and result mappings.">
		<cfset var msg = "" />
		<cfset var keyList = arrayToList(variables.objectMetadata.primaryKeys) />

  	<!--- Add Messages --->
  	<cfset msg = createObject("component", "ModelGlue.unity.eventhandler.Message").init() />
  	<cfset msg.setName("ModelGlue.genericRead") />
  	<cfset msg.addArgument("object", variables.objectName) />
  	<cfset msg.addArgument("recordName", variables.objectName & "Record") />
  	<cfset msg.addArgument("criteria", keylist) />
  	<cfset addMessage(msg) />
	</cffunction>
</cfcomponent>
