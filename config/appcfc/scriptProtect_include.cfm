<!--- Preventing XSS attacks --->
<cfparam name="local" default="#structNew()#">
<cfif structKeyExists(application,"scriptProtectionFilter") and application.configBean.getScriptProtect()>
	<cfif isDefined("url")>
		<cfset application.scriptProtectionFilter.scan(
									object=url,
									objectname="url",
									ipAddress=request.remoteAddr,
									useTagFilter=true)>
	</cfif>
	<cfif isDefined("form")>
		<cfset application.scriptProtectionFilter.scan(
									object=form,
									objectname="form",
									ipAddress=request.remoteAddr,
									useTagFilter=true)>
	</cfif>
	<cfif isDefined("cookie")>
		<cfset application.scriptProtectionFilter.scan(
									object=cookie,
									objectname="cookie",
									ipAddress=request.remoteAddr,
									useTagFilter=true)>
	</cfif>
	<cfif application.scriptProtectionFilter.isBlocked(request.remoteAddr) eq true>
		<cfset application.eventManager.announceEvent("onGlobalThreatDetect",createObject("component","mura.event"))>
	</cfif> 
</cfif>