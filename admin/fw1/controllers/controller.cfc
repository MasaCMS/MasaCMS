<cfcomponent extends="mura.cfobject" output="false">

	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
	</cffunction>

	<cffunction name="secure" output="false">	
		<cfargument name="rc">
		<cfif not session.mura.isLoggedIn>
			<cfset request.context.returnURL='index.cfm?#cgi.query_string#'>
			<cfset variables.fw.redirect(action="cLogin.main",append="returnURL",path="")>
		<cfelse>
			<cfset variables.utility.backUp()>
		</cfif>
	</cffunction>
	
	<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
		<cfset variables.configBean=arguments.configBean>
	</cffunction>
	
	<cffunction name="setSettingsManager" output="false">
	<cfargument name="settingsManager">
		<cfset variables.settingsManager=arguments.settingsManager>
	</cffunction>
	
	<cffunction name="setPermUtility" output="false">
	<cfargument name="permUtility">
		<cfset variables.permUtility=arguments.permUtility>
	</cffunction>
	
	<cffunction name="setUtility" output="false">
	<cfargument name="utility">
		<cfset variables.utility=arguments.utility>
	</cffunction>
</cfcomponent>