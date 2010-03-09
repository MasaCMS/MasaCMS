<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfif ( NOT structKeyExists( application, "setupComplete" ) or not application.appInitialized or structKeyExists(url,application.appReloadKey)) and isDefined("onApplicationStart")>
	<cfset onApplicationStart()>
</cfif>
	
<cfif not application.configBean.getDebuggingEnabled()>
	<cferror 
	template="error.html"
	mailto="#application.configBean.getMailserverusername()#"
	type="Exception">
</cfif>
	
<!--- Making sure that session is valid --->
<cfif 
	(not session.mura.isLoggedIn and isValid("UUID",listFirst(getAuthUser(),"^")))
		or
	(session.mura.isLoggedIn and not isValid("UUID",listFirst(getAuthUser(),"^")))	>
	
	<cfset application.loginManager.logout()>	
</cfif>
	
<cfset application.userManager.setUserStructDefaults()>
	
<!---settings.custom.vars.cfm reference is for backwards compatability --->
<cfif fileExists(expandPath("/muraWRM/config/settings.custom.vars.cfm"))>
	<cfinclude template="/muraWRM/config/settings.custom.vars.cfm">
</cfif>
<cfif not StructKeyExists(cookie, 'userid')>
	  <cfcookie name="userid" expires="never" value="">
</cfif>
	
<cfif not StructKeyExists(cookie, 'userHash')>
   <cfcookie name="userHash" expires="never" value="">
</cfif>
	
<cfif not IsDefined("Cookie.CFID") AND IsDefined("Session.CFID")>
	<cfcookie name="CFID" value="#Session.CFID#">
	<cfcookie name="CFTOKEN" value="#Session.CFTOKEN#">
</cfif>
	
<cftry>
	<cfif cookie.userid eq '' and structKeyExists(session,"rememberMe") and session.rememberMe eq 1 and session.mura.isLoggedIn>
	<cfcookie name="userid" value="#session.mura.userID#" expires="never" />
	<cfcookie name="userHash" value="#application.userManager.readUserHash(session.mura.userID).userHash#" expires="never" />
	</cfif>
	
	<cfif cookie.userid neq '' and not session.mura.isLoggedIn>
	<cfset application.loginManager.rememberMe(cookie.userid,cookie.userHash) />
	</cfif>
	
	<cfif cookie.userid neq '' and structKeyExists(session,"rememberMe") and session.rememberMe eq 0 and session.mura.isLoggedIn>
	<cfcookie name="userid" value="" expires="never" />
	<cfcookie name="userHash" value="" expires="never" />
	</cfif>
	
	<cfif not structKeyExists(cookie,"originalURLToken")>
	<cfparam name="session.trackingID" default="#application.utility.getUUID()#">
	<cfcookie name="originalURLToken" value="#session.trackingID#" expires="never" />
	</cfif>
<cfcatch></cfcatch>
</cftry>

	
<cfif structKeyExists(request,"doMuraGlobalSessionStart")>
	<cfset application.pluginManager.executeScripts('onGlobalSessionStart')>
</cfif>
<cfset application.pluginManager.executeScripts('onGlobalRequestStart')>
