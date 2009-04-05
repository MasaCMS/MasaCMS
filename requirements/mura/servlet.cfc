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
	<cfset getHandler("standardSetContentRenderer").handle(event)>
	
	<cfreturn this />
</cffunction>

<cffunction name="onRequestStart" access="public" returnType="void" output="false">
</cffunction>

<cffunction name="onRequestEnd" access="public" returnType="void" output="false">
</cffunction>

<cffunction name="doRequest" returntype="any"  access="public" output="false">
		
	<cfset setFactories()>
	
	<cfset getHandler("standardSetContent").handle(event)>
	
	<cfset getValidator("standard404").validate(event)>
	
	<cfset getValidator("standardWrongDomain").validate(event)> 
	
	<cfset getValidator("standardTrackSession").validate(event)>
	
	<cfset getHandler("standardSetPermissions").handle(event)>
	
	<cfset getHandler("standardSetIsOnDisplay").handle(event)>
	
	<cfset getValidator("standardRequireLogin").validate(event)>
	
	<cfset getHandler("standardSetLocale").handle(event)>

	<cfset getHandler("standardDoActions").handle(event)>
	
 	<cfreturn getHandler("standardDoResponse").handle(event)>
	
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
