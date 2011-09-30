<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent output="false" extends="mura.cfobject">

<cfset variables.event=structNew()>

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="data"  type="any" default="#structNew()#">
	
	<cfset variables.event=arguments.data />
	<cfif isdefined("form")><cfset structAppend(variables.event,form,false)/></cfif>
	<cfset structAppend(variables.event,url,false)/>
	
	<cfif len(getValue('siteid')) and application.settingsManager.siteExists(getValue('siteid'))>
		<cfset loadSiteRelatedObjects()/>
	<cfelse>
		<cfset setValue("contentRenderer",application.contentRenderer)>
	</cfif>
	
	<cfset setValue("MuraScope",createObject("component","mura.MuraScope"))>
	<cfset getValue('MuraScope').setEvent(this)>
	
	<cfreturn this />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfset variables.event["#arguments.property#"]=arguments.propertyValue />
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	
	<cfif structKeyExists(variables.event,"#arguments.property#")>
		<cfreturn variables.event["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables.event["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables.event["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="valueExists" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
		<cfreturn structKeyExists(variables.event,arguments.property) />
</cffunction>

<cffunction name="removeValue" access="public" output="false">
	<cfargument name="property" type="string" required="true"/>
		<cfset structDelete(variables.event,arguments.property) />
		<cfreturn this>
</cffunction>

<cffunction name="getValues" returntype="any" access="public" output="false">
		<cfreturn variables.event />
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
		<cfreturn variables.event />
</cffunction>

<cffunction name="getHandler" returntype="any" access="public" output="false">
	<cfargument name="handler">
	<cfargument name="persist" default="true" required="true">
	<cfif isObject(getValue('HandlerFactory'))>
		<cfreturn getValue('HandlerFactory').get(arguments.handler,getValue("localHandler"),arguments.persist) />
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
</cffunction>

<cffunction name="getValidator" returntype="any" access="public" output="false">
	<cfargument name="validation">
	<cfargument name="persist" default="true" required="true">
	<cfif isObject(getValue('ValidatorFactory'))>
		<cfreturn getValue('ValidatorFactory').get(arguments.validation,getValue("localHandler"),arguments.persist) />	
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
	
</cffunction>

<cffunction name="getTranslator" returntype="any" access="public" output="false">
	<cfargument name="translator">
	<cfargument name="persist" default="true" required="true">
	<cfif isObject(getValue('TranslatorFactory'))>
		<cfreturn getValue('TranslatorFactory').get(arguments.translator,getValue("localHandler"),arguments.persist) />	
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
	
</cffunction>

<cffunction name="getContentRenderer" returntype="any" access="public" output="false">
	<cfreturn getValue('contentRenderer') />	
</cffunction>

<cffunction name="getThemeRenderer" returntype="any" access="public" output="false">
	<cfreturn getValue('themeRenderer') />	
</cffunction> 

<cffunction name="getSite" returntype="any" access="public" output="false">
	<cfif len(getValue('siteid'))>
		<cfreturn application.settingsManager.getSite(getValue('siteid')) />
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>	
</cffunction>

<cffunction name="getServiceFactory" returntype="any" access="public" output="false">
	<cfreturn application.serviceFactory />	
</cffunction>

<cffunction name="getMuraScope" returntype="any" access="public" output="false">
	<cfreturn getValue("MuraScope") />	
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false">
	<cfargument name="beanName">
	<cfargument name="siteID" required="false">
	
	<cfif structKeyExists(arguments,"siteid")>
		<cfreturn super.getBean(arguments.beanName,arguments.siteID)>
	<cfelse>
		<cfreturn super.getBean(arguments.beanName,getValue('siteid'))>
	</cfif>
</cffunction>

<cffunction name="throwSiteIDError" returntype="any" access="public" output="false">
	<cfthrow type="custom" message="The 'SITEID' was not defined for this event">
</cffunction>

<cffunction name="loadSiteRelatedObjects" returntype="any" access="public" output="false">
	<cfset var localHandler="">
	<cfif not valueExists("ValidatorFactory")>
		<cfset setValue('ValidatorFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Validator"))>
	</cfif>
	<cfif not valueExists("HandlerFactory")>
		<cfset setValue('HandlerFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Handler"))>
	</cfif>
	<cfif not valueExists("TranslatorFactory")>
		<cfset setValue('TranslatorFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Translator"))>
	</cfif>
	<cfif not valueExists("contentRenderer")>
		<cfset setValue("contentRenderer",createObject("component","#application.settingsManager.getSite(getValue('siteid')).getAssetMap()#.includes.contentRenderer").init(event=this,$=getValue('MuraScope'),mura=getValue('MuraScope')))>
	</cfif>
	<cfif not valueExists("themeRenderer") and fileExists(expandPath(getSite().getThemeIncludePath()) & "/contentRenderer.cfc")>
		<cfset setValue("themeRenderer",createObject("component","#getSite().getThemeAssetMap()#.contentRenderer").init(event=this,$=getValue('MuraScope'),mura=getValue('MuraScope')))>
	</cfif>	
	<cfif not valueExists("localHandler") and fileExists(expandPath("/#application.configBean.getWebRootMap()#") & "/#getValue('siteid')#/includes/eventHandler.cfc")>
		<cfset localHandler=createObject("component","#application.configBean.getWebRootMap()#.#getValue('siteid')#.includes.eventHandler").init()>
		<cfset localHandler._objectName="#application.configBean.getWebRootMap()#.#getValue('siteid')#.includes.eventHandler">
		<cfset setValue("localHandler",localHandler)>
	</cfif>
	
	<cfreturn this>
</cffunction>

</cfcomponent>

