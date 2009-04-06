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
		
	<cfscript>
	if (NOT IsDefined("request"))
	    request=structNew();
	StructAppend(request, url, "no");
	StructAppend(request, form, "no");
	</cfscript>
	
	<cfparam name="request.doaction" default=""/>
	<cfparam name="request.month" default="#month(now())#"/>
	<cfparam name="request.year" default="#year(now())#"/>
	<cfparam name="request.display" default=""/>
	<cfparam name="request.startrow" default="1"/>
	<cfparam name="request.keywords" default=""/>
	<cfparam name="request.tag" default=""/>
	<cfparam name="request.mlid" default=""/>
	<cfparam name="request.noCache" default="0"/>
	<cfparam name="request.categoryID" default=""/>
	<cfparam name="request.relatedID" default=""/>
	<cfparam name="request.linkServID" default=""/>
	<cfparam name="request.track" default="1"/>
	<cfparam name="request.exportHTMLSite" default="0"/>
	<cfparam name="request.returnURL" default=""/>
	<cfparam name="request.showMeta" default="0"/>
		
	<cfset setValue('ValidatorFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Validator"))>
	<cfset setValue('HandlerFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Handler"))>
	<cfset setValue('TranslatorFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Translator"))>

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

<cffunction name="getHandler" returntype="any" access="public">
	<cfargument name="handler">
	<cfreturn getValue('HandlerFactory').get(arguments.handler) />	
</cffunction>

<cffunction name="getValidator" returntype="any" access="public">
	<cfargument name="validation">
	<cfreturn getValue('ValidatorFactory').get(arguments.validation) />	
</cffunction>

<cffunction name="getTranslator" returntype="any" access="public">
	<cfargument name="translator">
	<cfreturn getValue('TranslatorFactory').get(arguments.translator) />	
</cffunction>

</cfcomponent>

