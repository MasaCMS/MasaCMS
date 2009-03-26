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


<cfcomponent displayName="ViewRenderer" output="false" hint="I am the container in which a view is rendered.">
  <cffunction name="Init" access="public" returnType="any" output="false" hint="I build a new view renderer.">
    <cfreturn this />
  </cffunction>
  

  <cffunction name="RenderView" output="false" hint="I render a view and return the resultant HTML.">
    <cfargument name="stateContainer" type="any" hint="State container available to rendered views.">
    <cfargument name="viewCol" type="any" hint="View collection available to rendered views.">
    <cfargument name="IncludeUrl" type="any" hint="I am the template to CFInclude.">
    <cfargument name="StateValues" type="any" hint="I am the additional view state values.">

    <cfset var result = "" />
    <cfset var v = "" />
    <cfset var i = "" />
		<cfset var viewstate = arguments.stateContainer />
		<cfset var viewCollection = arguments.viewCol />
    
    <cfloop collection="#arguments.StateValues#" item="i">
      <cfif arguments.StateValues[i].overwrite or not viewstate.exists(i)>
    	  <cfset viewstate.SetValue(i,arguments.StateValues[i].value) />
      </cfif>
    </cfloop>
    
    <cfsavecontent variable="result"><cfmodule template="/ModelGlue/unity/view/ViewRenderer.cfm" includepath="#arguments.includeUrl#" viewstate="#viewstate#" viewcollection="#viewcollection#"></cfsavecontent>

    <cfreturn result />
  </cffunction>
</cfcomponent>