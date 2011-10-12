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
<cfcomponent extends="mura.Factory" output="false">

<cffunction name="init" output="false" returnType="any">
<cfargument name="class">
<cfargument name="siteid">
<cfargument name="standardEventsHandler">
<cfargument name="pluginManager">
	<cfset variables.class=arguments.class>
	<cfset variables.siteid=arguments.siteid>
	<cfset variables.standardEventsHandler=arguments.standardEventsHandler>
	<cfset variables.pluginManager=arguments.pluginManager>
	<cfset super.init() />
	<cfreturn this>
</cffunction>

<cffunction name="get" access="public" returntype="any" output="false">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="localHandler" default="" required="true" />
		<!---<cfargument name="persist" default="true" required="true" />--->
		<cfset var hashKey = getHashKey( arguments.key ) />
		<cfset var checkKey= "__check__" & arguments.key>
		<cfset var localKey=arguments.key & variables.class>
		<cfset var hashCheckKey = getHashKey( checkKey ) />
		<cfset var rs="" />
		<cfset var event="" />
		<cfset var classInstance="" />
		<cfset var wrappedClassInstance="" />
	
		<!---If the local handler has a locally defined method then use it instead --->
		<!---<cfif NOT arguments.persist or NOT has( localKey )>--->
		<cfif NOT has( localKey )>
			<cfif isObject(arguments.localHandler) and structKeyExists(arguments.localHandler, localKey)>
				<cfset classInstance=localHandler>
				<cfset wrappedClassInstance=wrapHandler(classInstance, localKey)>	
				<!---<cfif arguments.persist>--->
					<cfset super.set( localKey, wrappedClassInstance )>
				<!---</cfif>--->
				<cfreturn wrappedClassInstance />
			</cfif>
		
			<!---If there is a non plugin listener then use it instead --->
			<cfset classInstance=variables.pluginManager.getSiteListener(variables.siteID, localKey)>
			<cfif isObject(classInstance)>
				<cfset wrappedClassInstance=wrapHandler(classInstance, localKey)>
				<!---<cfif arguments.persist>--->
					<cfset super.set( localKey, wrappedClassInstance )>			
				<!---</cfif>--->
				<cfreturn wrappedClassInstance />
			</cfif>
		</cfif>
		
		<!--- Check if the prelook for plugins has been made --->
		<!---<cfif NOT arguments.persist or NOT has( checkKey )>--->
		<cfif NOT has( checkKey )>	
			<cfset rs=variables.pluginManager.getScripts(localKey, variables.siteid)>
			<!--- If it has not then get it--->
			<!---<cfif arguments.persist>--->
				<cfset super.set( checkKey, rs.recordcount ) />
			<!---</cfif>--->
			
			<cfif rs.recordcount>
				<cfset classInstance=variables.pluginManager.getComponent("plugins.#rs.directory#.#rs.scriptfile#", rs.pluginID, variables.siteID, rs.docache)>
				<cfset wrappedClassInstance=wrapHandler(classInstance, localKey)>
				<!---<cfif arguments.persist>--->
					<cfset super.set( localKey, wrappedClassInstance )>
				<!---</cfif>--->
				<cfreturn wrappedClassInstance />
			</cfif>
		</cfif>
		
		<cfif has( localKey )>
			<!--- It's already in cache --->
			<cfreturn variables.collection.get( getHashKey(localKey) ).object>
		<cfelse>
			<!--- return cached context --->
			<cfif structKeyExists(variables.standardEventsHandler,localKey)>
				<cfset wrappedClassInstance=wrapHandler(variables.standardEventsHandler,localKey)>
				<cfset super.set( localKey, wrappedClassInstance )>
			<cfelse>
				<cfset wrappedClassInstance=wrapHandler(createObject("component","mura.#variables.class#.#localKey#").init(),localKey)>
			</cfif>
			<!---<cfif arguments.persist>
				<cfset super.set( localKey, wrappedClassInstance )>
			</cfif>--->
				
			<cfreturn wrappedClassInstance />
		</cfif>

</cffunction>

<cffunction name="wrapHandler" access="public"  output="false">
<cfargument name="handler">
<cfargument name="eventName">
<cfreturn createObject("component","mura.plugin.pluginStandardEventWrapper").init(arguments.handler,arguments.eventName)>
</cffunction>

<cffunction name="has" access="public" returntype="boolean" output="false">
	<cfargument name="key" type="string" required="true" />
	<cfreturn structKeyExists( variables.collection , getHashKey( arguments.key ) ) >
</cffunction>

</cfcomponent>