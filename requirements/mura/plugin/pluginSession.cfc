<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.properties=structNew() />

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="data"  type="any" default="#structNew()#">
	
	<cfset variables.properties=arguments.data />
	
	<cfreturn this />
</cffunction>


<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfset variables.properties["#arguments.property#"]=arguments.propertyValue />

</cffunction>


<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
	
	<cfif structKeyExists(variables.properties,"#arguments.property#")>
		<cfreturn variables.properties["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
		<cfreturn variables.properties />
</cffunction>

<cffunction name="valueExists" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
		<cfreturn structKeyExists(variables.properties,arguments.property) />
</cffunction>

<cffunction name="removeValue" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true"/>
		<cfset structDelete(variables.properties,arguments.property) />
</cffunction>

</cfcomponent>

