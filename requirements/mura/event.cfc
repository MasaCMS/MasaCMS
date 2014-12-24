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
	<cfargument name="$">

	<cfif isStruct(arguments.data)>
		<cfset variables.event=arguments.data />
	</cfif>
	
	<cfif isdefined("form")>
		<cfset structAppend(variables.event,form,false)/>
	</cfif>
	
	<cfset structAppend(variables.event,url,false)/>
	
	<cfif structKeyExists(arguments,"$")>
		<cfset setValue("MuraScope",arguments.$)>
	<cfelse>
		<cfset setValue("MuraScope",createObject("component","mura.MuraScope"))>
	</cfif>
	
	<cfset getValue('MuraScope').setEvent(this)>
	
	<cfif len(getValue('siteid')) and application.settingsManager.siteExists(getValue('siteid'))>
		<cfset loadSiteRelatedObjects()/>
	<cfelse>
		<cfset setValue("contentRenderer",getBean('contentRenderer'))>
	</cfif>
	
	<cfreturn this />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfset variables.event["#arguments.property#"]=arguments.propertyValue />
	<cfreturn this>
</cffunction>

<cffunction name="set" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="defaultValue">
	<cfreturn setValue(argumentCollection=arguments)>
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

<cffunction name="get" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="defaultValue">
	<cfreturn getValue(argumentCollection=arguments)>
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
	<cfif isObject(getValue('HandlerFactory'))>
		<cfreturn getValue('HandlerFactory').get(arguments.handler & "Handler",getValue("localHandler")) />
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
</cffunction>

<cffunction name="getValidator" returntype="any" access="public" output="false">
	<cfargument name="validation">
	<cfif isObject(getValue('ValidatorFactory'))>
		<cfreturn getValue('ValidatorFactory').get(arguments.validation & "Validator",getValue("localHandler")) />	
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
	
</cffunction>

<cffunction name="getTranslator" returntype="any" access="public" output="false">
	<cfargument name="translator">
	<cfif isObject(getValue('TranslatorFactory'))>
		<cfreturn getValue('TranslatorFactory').get(arguments.translator & "Translator",getValue("localHandler")) />	
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>	
</cffunction>

<cffunction name="getContentRenderer" returntype="any" access="public" output="false">
	<cfreturn getValue('contentRenderer') />	
</cffunction>

<cffunction name="getThemeRenderer" returntype="any" access="public" output="false" hint="deprecated: use getContentRenderer()">
	<cfreturn getContentRenderer() />	
</cffunction> 

<cffunction name="getSite" returntype="any" access="public" output="false">
	<cfif len(getValue('siteid'))>
		<cfreturn application.settingsManager.getSite(getValue('siteid')) />
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>	
</cffunction>

<cffunction name="getServiceFactory" returntype="any" access="public" output="false">
	<cfif isDefined('application') and structKeyExists(application,'serviceFactory')>
		<cfreturn application.serviceFactory />
	<cfelseif structKeyExists(variables,'applicationScope')><!--- in case this is called in the onRequestEnd() --->
		<cfreturn variables.applicationScope />
	</cfif>
	
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
	<cfif not valueExists("HandlerFactory")>
		<cfset setValue('HandlerFactory',application.pluginManager.getStandardEventFactory(getValue('siteid')))>
	</cfif>
	<cfif not valueExists("contentRenderer")>
		<cfset getBean('settingsManager').getSite(getValue('siteID')).getContentRenderer(getValue('MuraScope'))>
	</cfif>
	<cfset setValue('localHandler',application.settingsManager.getSite(getValue('siteID')).getLocalHandler())>
	
	<cfreturn this>
</cffunction>

</cfcomponent>

