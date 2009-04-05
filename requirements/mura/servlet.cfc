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
<cfset msg="">
	
<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="event">
	
	<cfset variables.event=arguments.event>
	<cfset setFactories()>
	<cfset getHandler("standardSetContentRenderer").execute(event)>
	
	<cfreturn this />
</cffunction>

<cffunction name="onRequestStart" access="public" returnType="void" output="false">
</cffunction>

<cffunction name="onRequestEnd" access="public" returnType="void" output="false">
</cffunction>

<cffunction name="doRequest" returntype="any"  access="public" output="false">
		
	<cfset setFactories()>
	
	<cfset getHandler("standardSetContent").execute(event)>
	
	<cfset getValidator("standard404").execute(event)>
	
	<cfset getValidator("standardWrongDomain").execute(event)> 
	
	<cfset getValidator("standardTrackSession").execute(event)>
	
	<cfset getHandler("standardSetPermissions").execute(event)>
	
	<cfset getHandler("standardSetIsOnDisplay").execute(event)>
	
	<cfset getValidator("standardRequireLogin").execute(event)>
	
	<cfset getHandler("standardSetLocale").execute(event)>

	<cfset getHandler("standardDoActions").execute(event)>
	
 	<cfreturn getHandler("standardDoResponse").execute(event)>
	
</cffunction>

<cffunction name="getHandler" returntype="any" access="public">
	<cfargument name="handler">
	<cfreturn event.getValue('HandlerFactory').get(arguments.handler) />	
</cffunction>

<cffunction name="getValidator" returntype="any" access="public">
	<cfargument name="validation">
	<cfreturn event.getValue('ValidatorFactory').get(arguments.validation) />	
</cffunction>

<cffunction name="setFactories" returntype="any" access="public">	
	<cfset event.setValue('ValidatorFactory',application.pluginManager.getEventManager(event.getValue('siteid')).getFactory("Validator"))>
	<cfset event.setValue('HandlerFactory',application.pluginManager.getEventManager(event.getValue('siteid')).getFactory("Handler"))>
	<cfset event.setValue('TranslatorFactory',application.pluginManager.getEventManager(event.getValue('siteid')).getFactory("Translator"))>
</cffunction>

</cfcomponent>
