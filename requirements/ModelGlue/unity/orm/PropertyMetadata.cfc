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


<cfcomponent displayname="PropertyMetadata" output="false">

<cffunction name="init" returntype="ModelGlue.unity.orm.PropertyMetadata" access="public" output="false">
	<cfset variables._name = "" />
	<cfset variables._physicalName = "" />
	<cfset variables._label = "" />
	<cfset variables._description = "" />
	<cfset variables._maxlength = 0 />
	<cfset variables._required = false />
	<cfset variables._default = "" />
	<cfset variables._key = false />
	<cfset variables._relation = false />
	<cfset variables._source = "" />
	<cfset variables._sourceColumn = "" />
	<cfset variables._sourceColumnLabel = "" />
	<cfset variables._sourceKey = "" />
	<cfset variables._plural = false />
	<cfset variables._virtual = false />
	<cfset variables._linkTable = "" />
	<cfset variables._linkFrom = "" />
	<cfset variables._linkTo = "" />
	<cfset variables._isLink = false />
	<cfreturn this />
</cffunction>

<cffunction name="setName" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true" />
	<cfset variables._name = arguments.name />
</cffunction>
<cffunction name="getName" returntype="string" access="public" output="false">
	<cfreturn variables._name />
</cffunction>

<cffunction name="setPhysicalName" returntype="void" access="public" output="false">
	<cfargument name="physicalName" type="string" required="true" />
	<cfset variables._physicalName = arguments.physicalName />
</cffunction>
<cffunction name="getPhysicalName" returntype="string" access="public" output="false">
	<cfreturn variables._physicalName />
</cffunction>


<cffunction name="setLabel" returntype="void" access="public" output="false">
	<cfargument name="Label" type="string" required="true" />
	<cfset variables._Label = arguments.Label />
</cffunction>
<cffunction name="getLabel" returntype="string" access="public" output="false">
	<cfreturn variables._Label />
</cffunction>

<cffunction name="setDescription" returntype="void" access="public" output="false">
	<cfargument name="Description" type="string" required="true" />
	<cfset variables._Description = arguments.Description />
</cffunction>
<cffunction name="getDescription" returntype="string" access="public" output="false">
	<cfreturn variables._Description />
</cffunction>

<cffunction name="setMaxlength" returntype="void" access="public" output="false">
	<cfargument name="maxlength" type="numeric" required="true" />
	<cfset variables._maxlength = arguments.maxlength />
</cffunction>
<cffunction name="getMaxlength" returntype="numeric" access="public" output="false">
	<cfreturn variables._maxlength />
</cffunction>

<cffunction name="setRequired" returntype="void" access="public" output="false">
	<cfargument name="Required" type="boolean" required="true" />
	<cfset variables._required = arguments.required />
</cffunction>
<cffunction name="getRequired" returntype="boolean" access="public" output="false">
	<cfreturn variables._required />
</cffunction>

<cffunction name="setKey" returntype="void" access="public" output="false">
	<cfargument name="Key" type="boolean" required="true" />
	<cfset variables._Key = arguments.Key />
</cffunction>
<cffunction name="getKey" returntype="boolean" access="public" output="false">
	<cfreturn variables._Key />
</cffunction>

<cffunction name="setDefault" returntype="void" access="public" output="false">
	<cfargument name="Default" type="string" required="true" />
	<cfset variables._Default = arguments.Default />
</cffunction>
<cffunction name="getDefault" returntype="string" access="public" output="false">
	<cfreturn variables._Default />
</cffunction>

<cffunction name="setRelation" returntype="void" access="public" output="false">
	<cfargument name="Relation" type="boolean" required="true" />
	<cfset variables._relation = arguments.Relation />
</cffunction>
<cffunction name="getRelation" returntype="boolean" access="public" output="false">
	<cfreturn variables._relation />
</cffunction>

<cffunction name="setSource" returntype="void" access="public" output="false">
	<cfargument name="Source" type="string" required="true" />
	<cfset variables._source = arguments.Source />
</cffunction>
<cffunction name="getSource" returntype="string" access="public" output="false">
	<cfreturn variables._source />
</cffunction>

<cffunction name="setSourceColumn" returntype="void" access="public" output="false">
	<cfargument name="SourceColumn" type="string" required="true" />
	<cfset variables._sourceColumn = arguments.SourceColumn />
</cffunction>
<cffunction name="getSourceColumn" returntype="string" access="public" output="false">
	<cfreturn variables._sourceColumn />
</cffunction>

<cffunction name="setSourceColumnLabel" returntype="void" access="public" output="false">
	<cfargument name="SourceColumnLabel" type="string" required="true" />
	<cfset variables._sourceColumnLabel = arguments.SourceColumnLabel />
</cffunction>
<cffunction name="getSourceColumnLabel" returntype="string" access="public" output="false">
	<cfreturn variables._sourceColumnLabel />
</cffunction>

<cffunction name="setSourceKey" returntype="void" access="public" output="false">
	<cfargument name="SourceKey" type="string" required="true" />
	<cfset variables._sourceKey = arguments.SourceKey />
</cffunction>
<cffunction name="getSourceKey" returntype="string" access="public" output="false">
	<cfreturn variables._sourceKey />
</cffunction>

<cffunction name="setPlural" returntype="void" access="public" output="false">
	<cfargument name="Plural" type="boolean" required="true" />
	<cfset variables._plural = arguments.Plural />
</cffunction>
<cffunction name="getPlural" returntype="boolean" access="public" output="false">
	<cfreturn variables._plural />
</cffunction>

<cffunction name="setVirtual" returntype="void" access="public" output="false">
	<cfargument name="virtual" type="boolean" required="true" />
	<cfset variables._virtual = arguments.Virtual />
</cffunction>
<cffunction name="getVirtual" returntype="boolean" access="public" output="false">
	<cfreturn variables._virtual />
</cffunction>

<cffunction name="setLinkTable" returntype="void" access="public" output="false">
	<cfargument name="LinkTable" type="string" required="true" />
	<cfset variables._linkTable = arguments.LinkTable />
</cffunction>
<cffunction name="getLinkTable" returntype="string" access="public" output="false">
	<cfreturn variables._linkTable />
</cffunction>

<cffunction name="setLinkFrom" returntype="void" access="public" output="false">
	<cfargument name="LinkFrom" type="string" required="true" />
	<cfset variables._linkFrom = arguments.LinkFrom />
</cffunction>
<cffunction name="getLinkFrom" returntype="string" access="public" output="false">
	<cfreturn variables._linkFrom />
</cffunction>

<cffunction name="setLinkTo" returntype="void" access="public" output="false">
	<cfargument name="LinkTo" type="string" required="true" />
	<cfset variables._linkTo = arguments.LinkTo />
</cffunction>
<cffunction name="getLinkTo" returntype="string" access="public" output="false">
	<cfreturn variables._linkTo />
</cffunction>

<cffunction name="setIsLink" returntype="void" access="public" output="false">
	<cfargument name="IsLink" type="string" required="true" />
	<cfset variables._IsLink = arguments.IsLink />
</cffunction>
<cffunction name="getIsLink" returntype="string" access="public" output="false">
	<cfreturn variables._IsLink />
</cffunction>

</cfcomponent>