<!--- Preventing XSS attacks --->

<cfif structKeyExists(application,"scriptProtectionFilter") and application.configBean.getScriptProtect()>
	<cfif isDefined("url") and isDefined("form") and isDefined("cookie")>
		<cfset application.scriptProtectionFilter.scan(url,"url",cgi.remote_addr)>
		<cfset application.scriptProtectionFilter.scan(form,"form",cgi.remote_addr)>
		<cfset application.scriptProtectionFilter.scan(cookie,"cookie",cgi.remote_addr)>
		<cfif application.scriptProtectionFilter.isBlocked(cgi.remote_addr) eq true>
			<cfset application.eventManager.announceEvent("onGlobalThreatDetect",createObject("component","mura.event"))>
		</cfif> 
	</cfif> 
</cfif>