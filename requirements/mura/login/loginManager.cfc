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
		<cfcookie name="userid" expires="never" value="#listFirst(getAuthUser(),'^')#" />
		<cfreturn true />
	<cfelse>
		<cfcookie name="userid" expires="never" value="" />
		<cfreturn false />
	</cfif>
	
</cffunction>

<cffunction name="login" access="public" output="false" returntype="void">
<cfargument name="data" type="struct" />
<cfargument name="loginObject" type="any"  required="true" default=""/>

<cfset var isloggedin =false />
<cfset var returnUrl ="" />
<cfset var site=""/>

<cfparam name="arguments.data.returnUrl" default="" />
<cfparam name="arguments.data.rememberMe" default="0" />
<cfparam name="arguments.data.contentid" default="" />
<cfparam name="arguments.data.linkServID" default="" />

<cfset session.rememberMe=arguments.data.rememberMe />

<cfif not isdefined('arguments.data.username')>

	<cflocation url="index.cfm?fuseaction=clogin.main&linkServID=#arguments.data.linkServID#" addtoken="no">

<cfelse>
	
	<cfif not isObject(arguments.loginObject)>
		<cfset isloggedin=variables.userUtility.login(arguments.data.username,arguments.data.password,arguments.data.siteid)>
	<cfelse>
		<cfset isloggedin=arguments.loginObject.login(arguments.data.username,arguments.data.password,arguments.data.siteid)>
	</cfif>
	
	<cfif isloggedin>
		
		<cfif isUserInRole('S2IsPrivate')>
		
			<cfset session.siteArray=arrayNew(1) />
				<cfloop collection="#variables.settingsManager.getSites()#" item="site">
				<cfif variables.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
						<cfset arrayAppend(session.siteArray,site) />
				</cfif>
			</cfloop>
		
			<cfif arguments.data.returnUrl eq ''>
						
				<cflocation url="#application.configBean.getindexFile()#?LinkServID=#arguments.data.LinkServID#" addtoken="no">
			<cfelseif arguments.data.returnUrl neq ''>
	
				<cfset returnUrl = replace(arguments.data.returnUrl, 'doaction=logout', '', 'ALL')>
				<cflocation url="#returnUrl#" addtoken="false">
			</cfif>
		<cfelseif arguments.data.returnUrl neq ''>
		
			<cflocation url="#arguments.data.returnUrl#" addtoken="false">
		<cfelse>
		<cflocation url="#application.configBean.getindexFile()#?LinkServID=#arguments.data.linkServID#" addtoken="false">
		</cfif>
	<cfelse>
		<cflocation url="?fuseaction=cLogin.main&display=login&status=failed&rememberMe=#arguments.data.rememberMe#&contentid=#arguments.data.contentid#&LinkServID=#arguments.data.linkServID#&returnURL=#urlEncodedFormat(arguments.data.returnUrl)#" addtoken="no">
	</cfif>
</cfif>

</cffunction>

<cffunction name="loginByUserID" access="public" output="true" returntype="void">
<cfargument name="data" type="struct" />
<cfset var isloggedin =false />
<cfset var returnURL=""/>
<cfset var site=""/>
<cfparam name="arguments.data.redirect" default="" />
<cfparam name="arguments.data.returnUrl" default="" />
<cfparam name="arguments.data.rememberMe" default="0" />
<cfparam name="arguments.data.contentid" default="" />
<cfparam name="arguments.data.linkServID" default="" />

<cfset session.rememberMe=arguments.data.rememberMe />

<cfif not isdefined('arguments.data.userid')>

	<cflocation url="index.cfm?fuseaction=clogin.main&linkServID=#arguments.data.linkServID#" addtoken="no">

<cfelse>
	
	<cfset isloggedin=variables.userUtility.loginByUserID(arguments.data.userID,arguments.data.siteid)>
	
	<cfif isloggedin>
		
		<cfif isUserInRole('S2IsPrivate')>
		
			<cfset session.siteArray=arrayNew(1) />
				<cfloop collection="#variables.settingsManager.getSites()#" item="site">
				<cfif variables.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
						<cfset arrayAppend(session.siteArray,site) />
				</cfif>
			</cfloop>
		

			<cfif arguments.data.redirect eq '' and arguments.data.returnUrl eq ''>
				<cflocation url="#application.configBean.getindexFile()#?LinkServID=#arguments.data.LinkServID#" addtoken="no">
			<cfelseif arguments.data.returnUrl neq ''>
				<cfset returnUrl = replace(arguments.data.returnUrl, 'doaction=logout', '', 'ALL')>
				<cflocation url="#returnUrl#" addtoken="false">
			<cfelse>
				<cflocation url="index.cfm?fuseaction=#arguments.data.redirect#&parentid=#arguments.data.parentid#&topid=#arguments.data.topid#&siteid=#arguments.data.siteid#&contentid=#arguments.data.contentid#&contenthistid=#arguments.data.contenthistid#&type=#arguments.data.type#&moduleid=#arguments.data.moduleid#" addtoken="no">
			</cfif>
		<cfelseif arguments.data.returnUrl neq ''>
			<cflocation url="#arguments.data.returnUrl#" addtoken="false">
		<cfelse>
		<cflocation url="#application.configBean.getindexFile()#?LinkServID=#arguments.data.linkServID#" addtoken="false">
		</cfif>
	<cfelse>
		<cflocation url="?fuseaction=cLogin.main&display=login&status=failed&rememberMe=#arguments.data.rememberMe#&contentid=#arguments.data.contentid#&LinkServID=#arguments.data.linkServID#" addtoken="no">
	</cfif>
</cfif>

</cffunction>

<cffunction name="logout" returntype="void" access="public" output="false">
	<cfset structclear(session) />
	<cflogout>
	<cfcookie name="userid" expires="never" value="" />
	
</cffunction>

</cfcomponent>