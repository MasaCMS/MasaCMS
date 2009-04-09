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
	<cfset event.getHandler("standardSetContentRenderer").handle(event)>
	
	<cfreturn this />
</cffunction>

<cffunction name="onRequestStart" access="public" returnType="void" output="false">
</cffunction>

<cffunction name="onRequestEnd" access="public" returnType="void" output="false">
</cffunction>

<cffunction name="doRequest" returntype="any"  access="public" output="false">
	
	<cfset event.getHandler("standardSetContent").handle(event)>
	
	<cfset event.getValidator("standard404").validate(event)>
	
	<cfset event.getValidator("standardWrongDomain").validate(event)> 
	
	<cfset event.getValidator("standardTrackSession").validate(event)>
	
	<cfset event.getHandler("standardSetPermissions").handle(event)>
	
	<cfset event.getHandler("standardSetIsOnDisplay").handle(event)>
	
	<cfset event.getHandler("standardDoActions").handle(event)>
	
	<cfset event.getValidator("standardRequireLogin").validate(event)>
	
	<cfset event.getHandler("standardSetLocale").handle(event)>

 	<cfset event.getHandler("standardDoResponse").handle(event)>
	
	<cfreturn event.getValue("__MuraResponse__")>
	
</cffunction>

</cfcomponent>
