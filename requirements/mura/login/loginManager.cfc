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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="userUtility" type="any" required="yes"/>
<cfargument name="userDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="permUtility" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.userUtility=arguments.userUtility />
		<cfset variables.userDAO=arguments.userDAO />
		<cfset variables.globalUtility=arguments.utility />
		<cfset variables.permUtility=arguments.permUtility />
		<cfset variables.settingsManager=arguments.settingsManager />
		
<cfreturn this />
</cffunction>

<cffunction name="rememberMe" access="public" returntype="boolean" output="false">
	<cfargument name="userid" required="yes" type="string" default="" />
	<cfargument name="userHash" required="yes" type="string" default="" />
	
	<cfset var rsUser=variables.userDAO.readUserHash(arguments.userid)/>
	<cfset var isLoggedin=0/>
	
	<cfif not len(arguments.userHash) or arguments.userHash eq rsUser.userHash>
		<cfset isloggedin=variables.userUtility.loginByUserID(rsUser.userID,rsUser.siteID)>
	</cfif>
	
	<cfif isloggedin>
		<cfset session.rememberMe=1>
		<cfreturn true />
	<cfelse>
		<cfset structDelete(cookie,"userid")>
		<cfset structDelete(cookie,"userhash")>
		<cfset session.rememberMe=0>
		<cfreturn false />
	</cfif>
	
</cffunction>

<cffunction name="login" access="public" output="false" returntype="void">
<cfargument name="data" type="struct" />
<cfargument name="loginObject" type="any"  required="true" default=""/>

<cfset var isloggedin =false />
<cfset var returnUrl ="" />
<cfset var site=""/>
<cfset var returnDomain="">
<cfset var indexFile="./">
<cfset var loginURL="" />

<cfparam name="arguments.data.returnUrl" default="" />
<cfparam name="arguments.data.rememberMe" default="0" />
<cfparam name="arguments.data.contentid" default="" />
<cfparam name="arguments.data.linkServID" default="" />
<cfparam name="arguments.data.isAdminLogin" default="false" />
<cfparam name="arguments.data.compactDisplay" default="false" />

<cfif arguments.data.isAdminLogin>
	<cfset indexFile="./">
</cfif>

<cfset session.rememberMe=arguments.data.rememberMe />

<!--- Make sure that the domain of the returnURL is the same as the current domain--->
<cfif len(arguments.data.returnURL) and listFindNoCase("http,https",listFirst(arguments.data.returnURL,":"))>
	<cfset returnDomain = reReplace( arguments.data.returnURL, "^\w+://([^\/:]+)[\w\W]*$", "\1", "one") />
	
	<cfif len(returnDomain)>
		<cfif len(cgi.http_host)>	
			<cfset arguments.data.returnURL=replace(arguments.data.returnURL,returnDomain,listFirst(cgi.http_host,":"))>
		<cfelse>
			<cfset arguments.data.returnURL=replace(arguments.data.returnURL,returnDomain,cgi.server_name)>
		</cfif>
	</cfif>
</cfif>

<cfif not isdefined('arguments.data.username')>

	<cflocation url="#indexFile#?muraAction=clogin.main&linkServID=#arguments.data.linkServID#" addtoken="false">

<cfelse>
	
	<cfif not isObject(arguments.loginObject)>
		<cfset isloggedin=variables.userUtility.login(arguments.data.username,arguments.data.password,arguments.data.siteid)>
	<cfelse>
		<cfset isloggedin=arguments.loginObject.login(arguments.data.username,arguments.data.password,arguments.data.siteid)>
	</cfif>
	
	<cfif isloggedin>
		
		<cfif listFind(session.mura.memberships,'S2IsPrivate')>
		
			<cfset session.siteArray=arrayNew(1) />
				<cfloop collection="#variables.settingsManager.getSites()#" item="site">
				<cfif variables.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
						<cfset arrayAppend(session.siteArray,site) />
				</cfif>
			</cfloop>
		
			<cfif arguments.data.returnUrl eq ''>				
				<cfif len(arguments.data.linkServID)>
					<cflocation url="#indexFile#?LinkServID=#arguments.data.linkServID#" addtoken="false">
				<cfelse>
					<cflocation url="#indexFile#" addtoken="false">
				</cfif>	
			<cfelse>
				<cfset returnUrl = replace(arguments.data.returnUrl, 'doaction=logout', '', 'ALL')>
				<cflocation url="#returnUrl#" addtoken="false">
			</cfif>
		<cfelseif arguments.data.returnUrl neq ''>
			<cfset returnUrl = replace(arguments.data.returnUrl, 'doaction=logout', '', 'ALL')>
			<cflocation url="#returnUrl#" addtoken="false">
		<cfelse>
			<cfif len(arguments.data.linkServID)>
				<cflocation url="#indexFile#?LinkServID=#arguments.data.linkServID#" addtoken="false">
			<cfelse>
				<cflocation url="#indexFile#" addtoken="false">
			</cfif>
		</cfif>
	<cfelse>
		<cfif arguments.data.isAdminLogin>
			<cflocation url="./?muraAction=cLogin.main&display=login&status=failed&rememberMe=#arguments.data.rememberMe#&contentid=#arguments.data.contentid#&LinkServID=#arguments.data.linkServID#&returnURL=#urlEncodedFormat(arguments.data.returnUrl)#&compactDisplay=#urlEncodedFormat(arguments.data.compactDisplay)#" addtoken="false">
		<cfelse>
			<cfset loginURL = application.settingsManager.getSite(request.siteid).getLoginURL() />
			<cfif find('?', loginURL)>
				<cfset loginURL &= "&status=failed&rememberMe=#arguments.data.rememberMe#&contentid=#arguments.data.contentid#&LinkServID=#arguments.data.linkServID#&returnURL=#urlEncodedFormat(arguments.data.returnUrl)#" />
			<cfelse>
				<cfset loginURL &= "?status=failed&rememberMe=#arguments.data.rememberMe#&contentid=#arguments.data.contentid#&LinkServID=#arguments.data.linkServID#&returnURL=#urlEncodedFormat(arguments.data.returnUrl)#" />
			</cfif>
			<cflocation url="#loginURL#" addtoken="false">
		</cfif>
	</cfif>
</cfif>

</cffunction>

<cffunction name="remoteLogin" access="public" output="false" returntype="any">
<cfargument name="data" type="struct" />
<cfargument name="loginObject" type="any"  required="true" default=""/>

<cfset var isloggedin =false />
<cfset var returnUrl ="" />
<cfset var site=""/>

<cfif not isdefined('arguments.data.username')
	or not isdefined('arguments.data.password')
	or not isdefined('arguments.data.siteid')>

	<cfreturn false>

<cfelse>
	
	<cfif not isObject(arguments.loginObject)>
		<cfset isloggedin=variables.userUtility.login(arguments.data.username,arguments.data.password,arguments.data.siteid)>
	<cfelse>
		<cfset isloggedin=arguments.loginObject.login(arguments.data.username,arguments.data.password,arguments.data.siteid)>
	</cfif>
	
	<cfif isloggedin>
		
		<cfif listFind(session.mura.memberships,'S2IsPrivate')>
			<cfset session.siteArray=arrayNew(1) />
				<cfloop collection="#variables.settingsManager.getSites()#" item="site">
				<cfif variables.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
						<cfset arrayAppend(session.siteArray,site) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cfif>

</cffunction>

<cffunction name="loginByUserID" access="public" output="true" returntype="void">
<cfargument name="data" type="struct" />
<cfset var isloggedin =false />
<cfset var returnURL=""/>
<cfset var site=""/>
<cfset var returnDomain=""/> 

<cfparam name="arguments.data.redirect" default="" />
<cfparam name="arguments.data.returnUrl" default="" />
<cfparam name="arguments.data.rememberMe" default="0" />
<cfparam name="arguments.data.contentid" default="" />
<cfparam name="arguments.data.linkServID" default="" />

<cfset session.rememberMe=arguments.data.rememberMe />

<!--- Make sure that the domain of the returnURL is the same as the current domain--->
<cfif len(arguments.data.returnURL) and listFindNoCase("http,https",listFirst(arguments.data.returnURL,":"))>
	<cfset returnDomain = reReplace( arguments.data.returnURL, "^\w+://([^\/:]+)[\w\W]*$", "\1", "one") />
	
	<cfif len(returnDomain)>
		<cfif len(cgi.http_host)>	
			<cfset arguments.data.returnURL=replace(arguments.data.returnURL,returnDomain,listFirst(cgi.http_host,":"))>
		<cfelse>
			<cfset arguments.data.returnURL=replace(arguments.data.returnURL,returnDomain,cgi.server_name)>
		</cfif>
	</cfif>
</cfif>

<cfif not isdefined('arguments.data.userid')>

	<cflocation url="./?muraAction=clogin.main&linkServID=#arguments.data.linkServID#" addtoken="false">

<cfelse>
	
	<cfset isloggedin=variables.userUtility.loginByUserID(arguments.data.userID,arguments.data.siteid)>
	
	<cfif isloggedin>
		
		<cfif listFind(session.mura.memberships,'S2IsPrivate')>
		
			<cfset session.siteArray=arrayNew(1) />
				<cfloop collection="#variables.settingsManager.getSites()#" item="site">
				<cfif variables.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
						<cfset arrayAppend(session.siteArray,site) />
				</cfif>
			</cfloop>

			<cfif arguments.data.redirect eq '' and arguments.data.returnUrl eq ''>
				<cfif len(arguments.data.linkServID)>
					<cflocation url="./index.cfm?LinkServID=#arguments.data.linkServID#" addtoken="false">
				<cfelse>
					<cflocation url="./" addtoken="false">
				</cfif>
			<cfelseif arguments.data.returnUrl neq ''>
				<cfset returnUrl = replace(arguments.data.returnUrl, 'doaction=logout', '', 'ALL')>
				<cflocation url="#returnUrl#" addtoken="false">
			<cfelse>
				<cflocation url="./?muraAction=#arguments.data.redirect#&parentid=#arguments.data.parentid#&topid=#arguments.data.topid#&siteid=#arguments.data.siteid#&contentid=#arguments.data.contentid#&contenthistid=#arguments.data.contenthistid#&type=#arguments.data.type#&moduleid=#arguments.data.moduleid#" addtoken="false">
			</cfif>
		<cfelseif arguments.data.returnUrl neq ''>
			<cfset returnUrl = replace(arguments.data.returnUrl, 'doaction=logout', '', 'ALL')>
			<cflocation url="#returnUrl#" addtoken="false">
		<cfelse>
			<cfif len(arguments.data.linkServID)>
				<cflocation url="./index.cfm?LinkServID=#arguments.data.linkServID#" addtoken="false">
			<cfelse>
				<cflocation url="./" addtoken="false">
			</cfif>
		</cfif>
	<cfelse>
		<cflocation url="./?muraAction=cLogin.main&display=login&status=failed&rememberMe=#arguments.data.rememberMe#&contentid=#arguments.data.contentid#&LinkServID=#arguments.data.linkServID#" addtoken="false">
	</cfif>
</cfif>

</cffunction>


<cffunction name="logout" returntype="void" access="public" output="false">
	<cfset var pluginEvent="">

	<cfif structKeyExists(request,"servletEvent")>
		<cfset pluginEvent=request.servletEvent>
	<cfelseif structKeyExists(request,"event")>
		<cfset pluginEvent=request.event>
	<cfelse>
		<cfset pluginEvent = new mura.event() />
	</cfif>

	<cfif len(pluginEvent.getValue("siteID"))>
		<cfset getPluginManager().announceEvent('onSiteLogout',pluginEvent)/>
		<cfset getPluginManager().announceEvent('onBeforeSiteLogout',pluginEvent)/>
	<cfelse>
		<cfset getPluginManager().announceEvent('onGlobalLogout',pluginEvent)/>
		<cfset getPluginManager().announceEvent('onBeforeGlobalLogout',pluginEvent)/>
	</cfif>

	<cflogout>

	<cfif getBean('configBean').getValue(property='rotateSessions',defaultValue='false')>
		<cfset sessionInvalidate()>
	</cfif>

	<cfset structclear(session) />
	<cfset structDelete(cookie,"userid")>
	<cfset structDelete(cookie,"userhash")>
	<cfset variables.userUtility.setUserStruct()/>
	<cfset getBean('changesetManager').removeSessionPreviewData()>

	<cfif len(pluginEvent.getValue("siteID"))>
		<cfset getPluginManager().announceEvent('onAfterSiteLogout',pluginEvent)/>
	<cfelse>
		<cfset getPluginManager().announceEvent('onAfterGlobalLogout',pluginEvent)/>
	</cfif>
</cffunction>

</cfcomponent>