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

<cfif isDefined("url.args") OR isDefined("form.args")>
	<cfset injectMethod("callWithStructArgs",call)>
	<cfset injectMethod("call",callWithStringArgs)>
</cfif>


<cffunction name="login" returntype="any" output="false" access="remote">
	<cfargument name="username">
	<cfargument name="password">
	<cfargument name="siteID">
	<cfset var authToken=hash(createUUID())>
	<cfset var rsSession="">
	<cfset var sessionData="">
	<cfset var loginSuccess = application.loginManager.remoteLogin(arguments)>

	<cfif loginSuccess>
		<cfwddx action="cfml2wddx" output="sessionData" input="#session.mura#">

		<cfquery name="rsSession" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			select * from tuserremotesessions
			where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.mura.userID#">
		</cfquery>
		
		<cfif rsSession.recordcount>
			
			<cfif rsSession.lastAccessed gte dateAdd("h",-3,now()) and application.configBean.getSharableRemoteSessions()>
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
					update tuserremotesessions set
					data=<cfqueryparam cfsqltype="cf_sql_varchar" value="#sessionData#">,
					lastAccessed=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.mura.userID#">
				</cfquery>
				
				<cfset authToken=rsSession.AuthToken>
				
			<cfelse>
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
					update tuserremotesessions set
					authToken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#authToken#">,
					data=<cfqueryparam cfsqltype="cf_sql_varchar" value="#sessionData#">,
					created=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					lastAccessed=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.mura.userID#">
				</cfquery>
				
			</cfif>
		<cfelse>
			<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				INSERT Into tuserremotesessions (userID,authToken,data,created,lastAccessed)
				values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.mura.userID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#authToken#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#sessionData#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			</cfquery>
	
		</cfif>
		
		
		<cfreturn authToken>
	<cfelse>
		<cfif isDate(session.blockLoginUntil) and session.blockLoginUntil gt now()>
			<cfset application.loginManager.logout()>
			<cfreturn "blocked">
		<cfelse>
			<cfset application.loginManager.logout()>
			<cfreturn "false">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="logout" returntype="any" output="false" access="remote">
	<cfargument name="authToken">
	
	<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		update tuserremotesessions set
		lastAccessed=#createODBCDateTime(dateAdd("h",-3,now()))#
		where authToken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.authToken#">
	</cfquery>
	
	<cfset application.loginManager.logout()>

</cffunction>

<cffunction name="getService" returntype="any" output="false">
<cfargument name="serviceName">
	
	<cfif not structKeyExists(application,"proxyServices")>
		<cfset application.proxyServices=structNew()>
	</cfif>
	
	<cfif not structKeyExists(application.proxyServices, arguments.serviceName)>
		<cfset application.proxyServices[arguments.serviceName]=createObject("component","mura.client.api.soap.v1.#arguments.serviceName#").init()>
	</cfif>
	
	<cfreturn application.proxyServices[arguments.serviceName]>
</cffunction>

<cffunction name="isValidSession" returntype="any" output="false" access="remote">
<cfargument name="authToken">
	<cfset var rsSession="">
	
	<cfif not len(arguments.authToken)>
		<cfreturn false>
	<cfelse>
		<cfquery name="rsSession" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			select authToken from tuserremotesessions
			where authtoken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.authToken#">
			and lastAccessed > #createODBCDateTime(dateAdd("h",-3,now()))#
		</cfquery>
		
		<cfreturn rsSession.recordcount>
	</cfif>
</cffunction>

<cffunction name="getSession" returntype="any" output="false">
<cfargument name="authToken">
	<cfset var rsSession="">
	<cfset var sessionData=structNew()>
	
	<cfquery name="rsSession" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		select * from tuserremotesessions
		where authtoken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.authToken#">
	</cfquery>
	
	<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		update tuserremotesessions
		set lastAccessed=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		where authToken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.authToken#">
	</cfquery>
	
	<cfwddx action="wddx2cfml" input="#rsSession.data#" output="sessionData">
	
	<cfreturn sessionData>
</cffunction>

<cffunction name="call" returntype="any" access="remote">
<cfargument name="serviceName" type="string">
<cfargument name="methodName" type="string">
<cfargument name="authToken" type="string" default="">
<cfargument name="args" default="#structNew()#" type="struct">

<cfset var event="">
<cfset var service="">	

<cfif (isDefined("session.mura.isLoggedIn") and session.mura.isLoggedIn)
		or (len(arguments.authToken) and isValidSession(arguments.authToken))>
	
	<cfif len(arguments.authToken)>
		<cfset session.mura=getSession(arguments.authToken)>
		<cfset session.siteID=session.mura.siteID>
		<cfset application.rbFactory.resetSessionLocale()>
	</cfif>
	
	<cfif not isObject(arguments.args)>
		<cfset event=createObject("component","mura.event")>
		<cfset event.init(args)>
		<cfset event.setValue("proxy",this)>
	<cfelse>
		<cfset event=args>
	</cfif>

	<cfset event.setValue("isProxyCall",true)>
	<cfset event.setValue("serviceName",arguments.serviceName)>
	<cfset event.setValue("methodName",arguments.methodName)>
	<cfset service=getService(event.getValue('serviceName'))>
	
	<cfinvoke component="#service#" method="call">
		<cfinvokeargument name="event" value="#event#" />
	</cfinvoke>
	
	<cfif len(arguments.authToken)>
		<cfset application.loginManager.logout()>
	</cfif>
	
	<cfreturn event.getValue("__response__")>

<cfelse>
	<cfreturn "invalid session">
</cfif>
</cffunction>

<cffunction name="callWithStringArgs" returntype="any" access="remote">
	<cfargument name="serviceName" type="string">
	<cfargument name="methodName" type="string">
	<cfargument name="authToken" type="string" default="">
	<cfargument name="args" default="" type="string">

	<cfif isJSON(arguments.args)>
		<cfset arguments.args=deserializeJSON(arguments.args)>
	<cfelseif isWddx(arguments.args)>
		<cfwddx action="wddx2cfml" input="#arguments.args#" output="arguments.args">
	<cfelseif not isStruct(arguments.args)>
		<cfset arguments.args=structNew()>
	</cfif>
	<cfreturn callWithStructArgs(argumentCollection=arguments)>
</cffunction>

</cfcomponent>