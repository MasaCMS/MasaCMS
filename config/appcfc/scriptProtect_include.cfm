<!--- Preventing XSS attacks --->
<cfparam name="local" default="#structNew()#">
<cfif structKeyExists(application,"scriptProtectionFilter") and application.configBean.getScriptProtect()>
	<cfif isDefined("url") and isDefined("form")>
		<cfset application.scriptProtectionFilter.scan(
									object=url,
									objectname="url",
									ipAddress=request.remoteAddr,
									useTagFilter=true)>
		<cfset application.scriptProtectionFilter.scan(
									object=form,
									objectname="form",
									ipAddress=request.remoteAddr,
									useTagFilter=true)>
		<!---cfset application.scriptProtectionFilter.scan(cookie,"cookie",cgi.remote_addr)>--->
		<cfif application.scriptProtectionFilter.isBlocked(request.remoteAddr) eq true>
			<cfset application.eventManager.announceEvent("onGlobalThreatDetect",createObject("component","mura.event"))>
		</cfif> 
	</cfif> 
</cfif>