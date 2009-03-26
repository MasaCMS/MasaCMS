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


<cfcomponent displayname="AbstractORMAdapter.cfc" hint="I am a marker for Model-Glue ORM adapters.">

<cffunction name="init" returntype="ModelGlue.unity.orm.AbstractORMAdapter" output="false" access="public">
	<cfreturn this />
</cffunction>

<cffunction name="getObjectMetadata" returntype="struct" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfreturn createObject("component", "ModelGlue.unity.orm.ObjectMetadata").init() />
</cffunction>

<cffunction name="getCriteriaProperties" returntype="string" output="false" access="public">
	<cfreturn "" />
</cffunction>

<cffunction name="list" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="criteria" type="struct" required="false" />
	<cfargument name="orderColumn" type="string" required="false" />
	<cfargument name="orderAscending" type="boolean" required="false" default="true" />
	<cfargument name="gatewayMethod" type="string" required="false" />
	<cfargument name="gatewayBean" type="string" required="false" />
</cffunction>

<cffunction name="new" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
</cffunction>

<cffunction name="read" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="primaryKeys" type="struct" required="true" />
</cffunction>

<cffunction name="validate" returntype="ModelGlue.Util.ValidationErrorCollection" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="record" type="string" required="true" />
</cffunction>

<cffunction name="assemble" returntype="void" output="false" access="public">
	<cfargument name="eventContext" type="ModelGlue.unity.eventrequest.EventContext" required="true" />
	<cfargument name="target" type="any" required="true" />
</cffunction>

<cffunction name="commit" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="record" type="string" required="true" />
	<cfargument name="useTransaction" type="any" required="false" default="true" />
</cffunction>

<cffunction name="delete" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="primaryKeys" type="struct" required="true" />
	<cfargument name="useTransaction" type="any" required="false" default="true" />
</cffunction>

</cfcomponent>