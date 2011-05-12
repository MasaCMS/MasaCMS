<!--- Preventing XSS attacks --->
<cfparam name="local" default="#structNew()#">
<cfif structKeyExists(application,"scriptProtectionFilter") and application.configBean.getScriptProtect()>
	<cfif isDefined("url") and isDefined("form")>
		<cfset application.scriptProtectionFilter.scan(url,"url",request.remoteAddr)>
		<cfset application.scriptProtectionFilter.scan(form,"form",request.remoteAddr)>
		<!---cfset application.scriptProtectionFilter.scan(cookie,"cookie",cgi.remote_addr)>--->
		<cfif application.scriptProtectionFilter.isBlocked(request.remoteAddr) eq true>
			<cfset application.eventManager.announceEvent("onGlobalThreatDetect",createObject("component","mura.event"))>
		</cfif> 
	</cfif> 
</cfif>