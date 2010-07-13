<cfcomponent extends="controller" output="false">

<cffunction name="setLoginManager" output="false">
	<cfargument name="loginManager">
	<cfset variables.loginManager=arguments.loginManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	<cfparam name="arguments.rc.returnurl" default=""/>
	<cfparam name="arguments.rc.status" default=""/>
	<cfparam name="arguments.rc.contentid" default=""/>
	<cfparam name="arguments.rc.contenthistid" default=""/>
	<cfparam name="arguments.rc.topid" default=""/>
	<cfparam name="arguments.rc.type" default=""/>
	<cfparam name="arguments.rc.moduleid" default=""/>
	<cfparam name="arguments.rc.redirect" default=""/>
	<cfparam name="arguments.rc.parentid" default=""/>
	<cfparam name="arguments.rc.siteid" default=""/>
	<cfparam name="arguments.rc.status" default=""/>
</cffunction>

<cffunction name="main" output="false">
<cfargument name="rc">
	<cfif listFind(session.mura.memberships,'S2IsPrivate')>
		<cfset variables.fw.redirect(action="home.redirect",path="")>
	</cfif>
	
</cffunction>

<cffunction name="login" output="false">
	<cfargument name="rc">
	<cfset application.loginManager.login(arguments.rc)>	
</cffunction>

<cffunction name="logout" output="false">
	<cfargument name="rc">
	<cfset variables.loginManager.logout()>	
	<cfset variables.fw.redirect(action="home.redirect",path="")>
</cffunction>

</cfcomponent>