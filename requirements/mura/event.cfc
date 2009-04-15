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

<cfset variables.event=structNew() />

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="data"  type="any" default="#structNew()#">
	
	<cfset variables.event=arguments.data />
	
	<cfif len(getValue('siteid'))>
		<cfset loadSiteRelatedObjects()/>
	<cfelse>
		<cfset setValue("contentRenderer",application.contentRenderer)>
	</cfif>
	
	<cfreturn this />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfset variables.event["#arguments.property#"]=arguments.propertyValue />

</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
	
	<cfif structKeyExists(variables.event,"#arguments.property#")>
		<cfreturn variables.event["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="getValues" returntype="any" access="public" output="false">
		<cfreturn variables.event />
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
		<cfreturn variables.event />
</cffunction>

<cffunction name="getHandler" returntype="any" access="public">
	<cfargument name="handler">
	<cfif isObject(getValue('HandlerFactory'))>
		<cfreturn getValue('HandlerFactory').get(arguments.handler) />
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
</cffunction>

<cffunction name="getValidator" returntype="any" access="public">
	<cfargument name="validation">
	
	<cfif isObject(getValue('ValidatorFactory'))>
		<cfreturn getValue('ValidatorFactory').get(arguments.validation) />	
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
	
</cffunction>

<cffunction name="getTranslator" returntype="any" access="public">
	<cfargument name="translator">
	
	<cfif isObject(getValue('TranslatorFactory'))>
		<cfreturn getValue('TranslatorFactory').get(arguments.translator) />	
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
	
</cffunction>

<cffunction name="getContentRenderer" returntype="any" access="public">
	<cfreturn getValue('contentRenderer') />	
</cffunction>

<cffunction name="getConfigBean" returntype="any" access="public">
	<cfreturn application.configBean />	
</cffunction>

<cffunction name="getSite" returntype="any" access="public">
	<cfif len(getValue('siteid'))>
		<cfreturn application.settingsManager.getSite(getValue('siteid')) />
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>	
</cffunction>

<cffunction name="getServiceFactory" returntype="any" access="public">
	<cfreturn application.serviceFactory />	
</cffunction>

<cffunction name="throwSiteIDError" returntype="any" access="public">
	<cfthrow type="custom" message="The 'SITEID' was not defined for this event">
</cffunction>

<cffunction name="loadSiteRelatedObjects" returntype="any" access="public">
	<cfset setValue('ValidatorFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Validator"))>
	<cfset setValue('HandlerFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Handler"))>
	<cfset setValue('TranslatorFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Translator"))>
	<cfset setValue("contentRenderer",createObject("component","#getConfigBean().getWebRootMap()#.#getValue('siteid')#.includes.contentRenderer").init(this))>
</cffunction>

</cfcomponent>

