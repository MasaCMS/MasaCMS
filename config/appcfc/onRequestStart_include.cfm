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
<cfparam name="local" default="#structNew()#">
<cfparam name="application.setupComplete" default="false">
<cfparam name="application.appInitialized" default="false">
<cfparam name="application.instanceID" default="#createUUID()#" />
<cfprocessingdirective pageencoding="utf-8"/>
<cfset setEncoding("url", "utf-8")>
<cfset setEncoding("form", "utf-8")>

<cfif left(server.coldfusion.productversion,5) eq "9,0,0" or listFirst(server.coldfusion.productversion) lt 9>
	<cfoutput>Mura CMS requires Adobe Coldfusion 9.0.1 or greater compatibility</cfoutput>
	<cfabort>
</cfif>

<!--- Double check that the application has started properly.
If it has not, set application.appInitialized=false. --->
<cftry>
	<cfif not (
			structKeyExists(application.settingsManager,'validate')
			and application.settingsManager.validate()
			and structKeyExists(application.contentManager,'validate')
			and application.contentManager.validate()
			and application.serviceFactory.containsBean('contentManager')
			and isStruct(application.configBean.getAllValues())
		)>
		<cfset application.appInitialized=false>
		<cfset application.broadcastInit=false/>
	</cfif>
	<cfset application.clusterManager.runCommands()>
	<cfif not application.appInitialized>
		<cfset request.muraAppreloaded=false>
	</cfif>
	<cfcatch>
		<cfset application.appInitialized=false>
		<cfset request.muraAppreloaded=false>
		<cfset application.broadcastInit=false/>
	</cfcatch>
</cftry>

<cfif isDefined("onApplicationStart") >
	<cfif (
			not application.setupComplete
		OR
		(
			not request.muraAppreloaded
			and
				(
					not application.appInitialized
					or structKeyExists(url,application.appReloadKey)
				)
			and not (
				isDefined('url.method') and url.method eq 'processAsyncObject'
			)
		)
	)
	>
		<cflock name="appInitBlock#application.instanceID#" type="exclusive" timeout="200">
			<!--- Since the request may have had to wait twice, this code still needs to run --->
			<cfif (not application.appInitialized or structKeyExists(url,application.appReloadKey))>
				<cfinclude template="onApplicationStart_include.cfm">
				<cfif isdefined("setupApplication")>
					<cfset setupApplication()>
				</cfif>
			</cfif>
		</cflock>
	</cfif>

	<cfif not application.setupComplete>
		<cfset request.renderMuraSetup = true />
		<!--- go to the index.cfm page (setup) --->
		<cfinclude template="/muraWRM/config/setup/index.cfm">
		<cfabort>
	</cfif>
</cfif>

<cfset application.userManager.setUserStructDefaults()>
<cfset sessionData=application.userManager.getSession()>

<cfif isDefined("url.showTrace") and isBoolean(url.showTrace)>
	<cfset sessionData.mura.showTrace=url.showTrace>
<cfelseif not isDefined("sessionData.mura.showTrace")>
	<cfset sessionData.mura.showTrace=false>
</cfif>

<cfset request.muraShowTrace=sessionData.mura.showTrace>

<cfif not isDefined("application.cfstatic")>
	<cfset application.cfstatic=structNew()>
</cfif>

<!--- Making sure that session is valid --->
<cftry>
<cfif yesNoFormat(application.configBean.getValue("useLegacySessions")) and structKeyExists(sessionData,"mura")>
	<cfif
		(not sessionData.mura.isLoggedIn and isValid("UUID",listFirst(getAuthUser(),"^")))
			or
		(sessionData.mura.isLoggedIn and not isValid("UUID",listFirst(getAuthUser(),"^")))	>

		<cfset variables.tempcookieuserID=cookie.userID>
		<cfset application.loginManager.logout()>
	</cfif>
</cfif>
<cfcatch>
	<cfset application.loginManager.logout()>
</cfcatch>
</cftry>

<!---settings.custom.vars.cfm reference is for backwards compatability --->
<cfif fileExists(expandPath("/muraWRM/config/settings.custom.vars.cfm"))>
	<cfinclude template="/muraWRM/config/settings.custom.vars.cfm">
</cfif>

<!---<cfif not IsDefined("Cookie.CFID") AND IsDefined("Session.CFID")>
	<cfcookie name="CFID" value="#Session.CFID#">
	<cfcookie name="CFTOKEN" value="#Session.CFTOKEN#">
</cfif>
--->
<cftry>
	<cfif (not isdefined('cookie.userid') or cookie.userid eq '') and structKeyExists(sessionData,"rememberMe") and session.rememberMe eq 1 and sessionData.mura.isLoggedIn>
		<cfset application.utility.setCookie(name="userid",value=sessionData.mura.userID)/>
		<cfset application.utility.setCookie(name="userHash",value=encrypt(application.userManager.readUserHash(sessionData.mura.userID).userHash,application.userManager.readUserPassword(cookie.userid),'cfmx_compat','hex')) />
	</cfif>
<cfcatch>
	<cfset application.utility.deleteCookie(name="userHash")>
	<cfset application.utility.deleteCookie(name="userid")>
</cfcatch>
</cftry>

<cftry>
	<cfif isDefined('cookie.userid') and cookie.userid neq '' and not sessionData.mura.isLoggedIn>
	<cfset application.loginManager.rememberMe(cookie.userid,decrypt(cookie.userHash,application.userManager.readUserPassword(cookie.userid),"cfmx_compat",'hex')) />
	</cfif>
<cfcatch></cfcatch>
</cftry>

<cftry>
	<cfif isDefined('cookie.userid') and cookie.userid neq '' and structKeyExists(sessionData,"rememberMe") and sessionData.rememberMe eq 0 and sessionData.mura.isLoggedIn>
		<cfset application.utility.deleteCookie(name="userHash")>
		<cfset application.utility.deleteCookie(name="userid")>
	</cfif>
<cfcatch>
	<cfset application.utility.deleteCookie(name="userHash")>
	<cfset application.utility.deleteCookie(name="userid")>
</cfcatch>
</cftry>

<cftry>
	<cfparam name="sessionData.muraSessionID" default="#application.utility.getUUID()#">
	<cfif not structKeyExists(cookie,"MXP_TRACKINGID")>
		<cfif structKeyExists(cookie,"originalURLToken")>
			<cfset application.utility.setCookie(name="MXP_TRACKINGID", value=cookie.originalURLToken) />
			<cfset StructDelete(cookie, 'originalURLToken')>
		<cfelse>
			<cfset application.utility.setCookie(name="MXP_TRACKINGID", value=sessionData.muraSessionID) />
		</cfif>
	</cfif>
	<cfparam name="sessionData.muraTrackingID" default="#cookie.MXP_TRACKINGID#">
<cfcatch></cfcatch>
</cftry>

<!--- look to see is there is a custom remote IP header in the settings.ini.cfm --->
<cfset variables.remoteIPHeader=application.configBean.getValue("remoteIPHeader")>
<cfif len(variables.remoteIPHeader)>
	<cftry>
		<cfif StructKeyExists(GetHttpRequestData().headers, variables.remoteIPHeader)>
	    	<cfset request.remoteAddr = GetHttpRequestData().headers[remoteIPHeader]>
	    <cfelse>
			<cfset request.remoteAddr = CGI.REMOTE_ADDR>
	    </cfif>
		<cfcatch type="any"><cfset request.remoteAddr = CGI.REMOTE_ADDR></cfcatch>
	</cftry>
<cfelse>
	<cfset request.remoteAddr = CGI.REMOTE_ADDR>
</cfif>

<cfif not isdefined('url.muraadminpreview')>
	<cfset request.muraMobileRequest=false>

	<cfif isDefined("form.mobileFormat") and isBoolean(form.mobileFormat)>
		<cfset request.muraMobileRequest=form.mobileFormat>
		<cfset application.utility.setCookie(name="mobileFormat",value=form.mobileFormat)/>
	<cfelseif isDefined("url.mobileFormat") and isBoolean(url.mobileFormat)>
		<cfset request.muraMobileRequest=url.mobileFormat>
		<cfset application.utility.setCookie(name="mobileFormat",value=url.mobileFormat)/>
	</cfif>

	<cfif not isdefined("cookie.mobileFormat")>
		<cfset application.pluginManager.executeScripts('onGlobalMobileDetection')>

		<cfif not isdefined("cookie.mobileFormat")>
			<cfif
				findNoCase("iphone",CGI.HTTP_USER_AGENT)
				or
					(
						findNoCase("mobile",CGI.HTTP_USER_AGENT)
						and not reFindNoCase("tablet|ipad|xoom",CGI.HTTP_USER_AGENT)
					)>
					<cfset application.utility.setCookie(name="mobileFormat",value=true)/>
					<cfset request.muraMobileRequest=true>
			<cfelse>
				<cfset application.utility.setCookie(name="mobileFormat",value=false)/>
				<cfset request.muraMobileRequest=false>
			</cfif>
		</cfif>
	</cfif>

	<cfif not isBoolean(request.muraMobileRequest)>
		<cfset request.muraMobileRequest=false>
		<cfset application.utility.setCookie(name="mobileFormat",value=false)/>
	</cfif>

<cfelse>
	<cfparam name="url.mobileFormat" default="false">
	<cfset request.muraMobileRequest=url.mobileFormat>
</cfif>

<cfif not request.hasCFApplicationCFM and not fileExists("#expandPath('/muraWRM/config')#/cfapplication.cfm")>
	<cfset variables.tracePoint=initTracePoint("Writing config/cfapplication.cfm")>
	<cfset application.serviceFactory.getBean("fileWriter").writeFile(file="#expandPath('/muraWRM/config')#/cfapplication.cfm", output='<!--- Add Custom Application.cfc Vars Here --->')>
	<cfset commitTracePoint(variables.tracePoint)>
</cfif>

<cfparam name="sessionData.mura.requestcount" default="0">
<cfset sessionData.mura.requestcount=sessionData.mura.requestcount+1>

<cfparam name="sessionData.mura.csrfsecretkey" default="#createUUID()#">
<cfparam name="sessionData.mura.csrfusedtokens" default="#structNew()#">

<cfif request.muraSessionManagement and (structKeyExists(request,"doMuraGlobalSessionStart"))>
	<cfset application.utility.setSessionCookies()>
	<cfset application.pluginManager.executeScripts('onGlobalSessionStart')>
</cfif>

<cfset application.pluginManager.executeScripts('onGlobalRequestStart')>
<cfparam name="application.coreversion" default="#application.serviceFactory.getBean('autoUpdater').getCurrentVersion()#">

<cfscript>
// HSTS: https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security
	getPageContext()
		.getResponse()
		.setHeader('Strict-Transport-Security', 'max-age=#application.configBean.getValue(property='HSTSMaxAge',defaultValue=1200)#;includeSubDomains');
</cfscript>

<cfheader name="Generator" value="Mura CMS #application.serviceFactory.getBean('configBean').getVersion()#" />
