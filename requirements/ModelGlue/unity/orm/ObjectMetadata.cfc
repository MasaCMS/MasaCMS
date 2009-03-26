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


<cfcomponent displayname="ObjectMetadata" output="false">

<cffunction name="init" returntype="ModelGlue.unity.orm.ObjectMetadata" access="public" output="false">
	<cfset variables._properties = arrayNew(1) />
	<cfset variables._propertyMap = structNew() />
	<cfset variables._linkProperties = arrayNew(1) />
	<cfset variables._childProperties = arrayNew(1) />
	<cfset variables._name = "" />
	<cfset variables._signature = "" />
	<cfset variables._cached = false />
	<cfset variables._label = "" />
	<cfset variables._keys = arrayNew(1) />
	<cfreturn this />
</cffunction>

<cffunction name="setName" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true" />
	<cfset variables._name = arguments.name />
</cffunction>
<cffunction name="getName" returntype="string" access="public" output="false">
	<cfreturn variables._name />
</cffunction>

<cffunction name="setSignature" returntype="void" access="public" output="false">
	<cfargument name="Signature" type="string" required="true" />
	<cfset variables._Signature = arguments.Signature />
</cffunction>
<cffunction name="getSignature" returntype="string" access="public" output="false">
	<cfreturn variables._Signature />
</cffunction>

<cffunction name="setCached" returntype="void" access="public" output="false">
	<cfargument name="Cached" type="string" required="true" />
	<cfset variables._Cached = arguments.Cached />
</cffunction>
<cffunction name="getCached" returntype="string" access="public" output="false">
	<cfreturn variables._Cached />
</cffunction>

<cffunction name="setLabel" returntype="void" access="public" output="false">
	<cfargument name="Label" type="string" required="true" />
	<cfset variables._Label = arguments.Label />
</cffunction>
<cffunction name="getLabel" returntype="string" access="public" output="false">
	<cfreturn variables._Label />
</cffunction>

<cffunction name="addProperty" returntype="void" access="public" output="false">
	<cfargument name="property" type="ModelGlue.unity.orm.PropertyMetadata" required="true" />
	<cfset arrayAppend(variables._properties, arguments.property) />
	<cfset variables._propertyMap[arguments.property.getName()] = variables._properties[arrayLen(variables._properties)] />
	<cfif arguments.property.getKey()>
		<cfset arrayAppend(variables._keys, arguments.property) />
	</cfif>
	<cfif len(arguments.property.getLinkTable())>
		<cfset arrayAppend(variables._linkProperties, arguments.property) />
	</cfif>
	<cfif len(arguments.property.getSourceColumn()) and not len(arguments.property.getLinkTable()) and arguments.property.getPlural()>
		<cfset arrayAppend(variables._childProperties, arguments.property) />
	</cfif>
</cffunction>

<cffunction name="getProperty" returntype="ModelGlue.unity.orm.PropertyMetadata" access="public" output="false">
	<cfargument name="name" type="string" required="true" />
	<cfreturn variables._propertyMap[arguments.name] />
</cffunction>

<cffunction name="getProperties" returntype="array" access="public" output="false">
	<cfreturn variables._properties />
</cffunction>

<cffunction name="getPropertyList" returntype="string" access="public" output="false">
	<cfreturn structKeyList(variables._propertyMap) />
</cffunction>

<cffunction name="getLinkProperties" returntype="array" access="public" output="false">
	<cfreturn variables._linkProperties />
</cffunction>

<cffunction name="getChildProperties" returntype="array" access="public" output="false">
	<cfreturn variables._childProperties />
</cffunction>

<cffunction name="getPluralRelations" returntype="array" access="public" output="false">
	<cfset var result = arrayNew(1) />
	<cfset var i = "" />
	<cfloop from="1" to="#arrayLen(variables._properties)#" index="i">
		<cfif variables._properties[i].getPlural() and variables._properties[i].getRelation()>
			<cfset arrayAppend(result, variables._properties[i]) />
		</cfif>
	</cfloop>
	<cfreturn result />
</cffunction>

<cffunction name="getKeys" returntype="array" access="public" output="false">
	<cfreturn variables._keys />
</cffunction>

<cffunction name="toXml" returntype="any" access="public" output="false">
	<cfset var xml = "" />
	<cfset var props = getProperties() />
	<cfset var i = "" />
	
	<cfoutput>
	<cfxml variable="xml">
	<object>
		<name>#getName()#</name>
		<label>#getLabel()#</label>
		<properties>
			<cfloop from="1" to="#arrayLen(props)#" index="i">
				<property name="#props[i].getName()#">
					<physicalname><![CDATA[#props[i].getPhysicalName()#]]></physicalname>
					<label><![CDATA[#props[i].getLabel()#]]></label>
					<description><![CDATA[#props[i].getDescription()#]]></description>
					<maxlength>#props[i].getMaxLength()#</maxlength>
					<required>#props[i].getrequired()#</required>
					<default>#props[i].getdefault()#</default>
					<key>#props[i].getkey()#</key>
					<relation>#props[i].getrelation()#</relation>
					<source>#props[i].getsource()#</source>
					<sourcecolumn>#props[i].getsourcecolumn()#</sourcecolumn>
					<sourcecolumnlabel>#props[i].getsourcecolumnlabel()#</sourcecolumnlabel>
					<sourcekey>#props[i].getsourcekey()#</sourcekey>
					<plural>#props[i].getplural()#</plural>
					<virtual>#props[i].getVirtual()#</virtual>
					<islink>#props[i].getislink()#</islink>
					<linktable>#props[i].getLinktable()#</linktable>
					<linkfrom>#props[i].getlinkfrom()#</linkfrom>
					<linkto>#props[i].getlinkto()#</linkto>
				</property>
			</cfloop>
		</properties>
	</object>
	</cfxml>
	</cfoutput>
	<cfreturn xml />
</cffunction>


</cfcomponent>