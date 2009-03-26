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
<cfcomponent output="false">

<cffunction name="init" returntype="any" access="public" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
<cfargument name="scope" default="request" required="true">
	
	<cfset var theScope=getScope(arguments.scope) />

	<cfset theScope["#arguments.property#"]=arguments.propertyValue />

</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="scope" default="request" required="true">
	
	<cfset var theScope=getScope(arguments.scope) />
	
	<cfif structKeyExists(theScope,"#arguments.property#")>
		<cfreturn theScope["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
<cfargument name="scope" default="request" required="true">
		<cfreturn getScope(arguments.scope)  />
</cffunction>

<cffunction name="getScope" returntype="struct" access="public" output="false">
<cfargument name="scope" default="request" required="true">
		
		<cfswitch expression="#arguments.scope#">
		<cfcase value="request">
			<cfreturn request />
		</cfcase>
		<cfcase value="form">
			<cfreturn form />
		</cfcase>
		<cfcase value="url">
			<cfreturn url />
		</cfcase>
		<cfcase value="session">
			<cfreturn session />
		</cfcase>
		<cfcase value="server">
			<cfreturn server />
		</cfcase>
		<cfcase value="application">
			<cfreturn application />
		</cfcase>
		<cfcase value="attributes">
			<cfreturn attributes />
		</cfcase>
		<cfcase value="cluster">
			<cfreturn cluster />
		</cfcase>
		</cfswitch>
		
</cffunction>

<cffunction name="valueExists" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="scope" default="request" required="true">
		<cfset var theScope=getScope(arguments.scope) />
		<cfreturn structKeyExists(theScope,arguments.property) />
</cffunction>

<cffunction name="removeValue" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true"/>
	<cfargument name="scope" default="request" required="true">
		<cfset var theScope=getScope(arguments.scope) />
		<cfset structDelete(theScope,arguments.property) />
</cffunction>

</cfcomponent>

