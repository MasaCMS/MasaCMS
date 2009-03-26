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
  <cffunction name="Init" access="public" returnType="ModelGlue.Core.ViewRenderer" output="false" hint="I build a new view renderer.">
    <cfargument name="stateContainer" type="ModelGlue.Util.GenericCollection" required="true" hint="State container available to rendered views.">
    <cfargument name="viewCollection" type="ModelGlue.Core.ViewCollection" required="true" hint="View collection available to rendered views.">
    <cfset variables.viewState = arguments.stateContainer />
    <cfset variables.viewCollection = arguments.viewCollection />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="RenderView" output="false" hint="I render a view and return the resultant HTML.">
    <cfargument name="IncludeUrl" type="string" required="true" hint="I am the template to CFInclude.">
    <cfargument name="StateValues" type="struct" required="true" hint="I am the additional view state values.">
    <cfset var result = "" />
    <cfset var v = "" />
    
    <cfloop collection="#arguments.StateValues#" item="i">
      <cfif arguments.StateValues[i].overwrite or not variables.viewState.exists(i)>
    	  <cfset variables.viewState.SetValue(i,arguments.StateValues[i].value) />
      </cfif>
    </cfloop>
    
    <cfsavecontent variable="result"><cfinclude template="#arguments.includeUrl#"></cfsavecontent>
    
    <cfreturn result />
  </cffunction>
</cfcomponent>