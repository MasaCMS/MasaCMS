<cfcomponent extends="controller" output="false">

<cffunction name="setLoginManager" output="false">
	<cfargument name="loginManager">
	<cfset variables.loginManager=arguments.loginManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	<cfparam name="rc.returnurl" default=""/>
	<cfparam name="rc.status" default=""/>
	<cfparam name="rc.contentid" default=""/>
	<cfparam name="rc.contenthistid" default=""/>
	<cfparam name="rc.topid" default=""/>
	<cfparam name="rc.type" default=""/>
	<cfparam name="rc.moduleid" default=""/>
	<cfparam name="rc.redirect" default=""/>
	<cfparam name="rc.parentid" default=""/>
	<cfparam name="rc.siteid" default=""/>
	<cfparam name="rc.status" default=""/>
</cffunction>

<cffunction name="main" output="false">
<cfargument name="rc">
	<cfif listFind(session.mura.memberships,'S2IsPrivate')>
		<cfset variables.fw.redirect(action="home.redirect",path="")>
	</cfif>
	
</cffunction>

<cffunction name="login" output="false">
	<cfargument name="rc">
	<cfset application.loginManager.login(rc)>	
</cffunction>

<cffunction name="logout" output="false">
	<cfargument name="rc">
	<cfset variables.loginManager.logout()>	
	<cfset variables.fw.redirect(action="home.redirect",path="")>
</cffunction>

</cfcomponent>