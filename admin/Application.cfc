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
	
	<cfinclude template="../config/applicationSettings.cfm">
	
	<cffunction name="onRequestStart" returnType="boolean" output="false">
		<cfargument name="thePage" type="string" required="true">
			
		<cfif right(cgi.script_name, Len("index.cfm")) NEQ "index.cfm" and right(cgi.script_name, Len("error.cfm")) NEQ "error.cfm" AND right(cgi.script_name, 3) NEQ "cfc">
			<cflocation url="index.cfm" addtoken="false">
		</cfif>

		<cfinclude template="../config/settings.cfm">

		<cfreturn true>
	</cffunction>
	
	<!--- <cffunction name="onSessionEnd" returnType="void">
	   <cfargument name="SessionScope" required=True/>
	   <cfargument name="ApplicationScope" required=False/>
	  		<cfabort>
	</cffunction> --->

</cfcomponent>