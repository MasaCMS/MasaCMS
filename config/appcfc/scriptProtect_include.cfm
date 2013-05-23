<!--- Preventing XSS attacks --->
<cfparam name="local" default="#structNew()#">
<cfif structKeyExists(application,"scriptProtectionFilter") and application.configBean.getScriptProtect()>
	<cfif isDefined("url")>
		<cfset application.scriptProtectionFilter.scan(
									object=url,
									objectname="url",
									ipAddress=request.remoteAddr,
									useTagFilter=true,
									useWordFilter=true)>
	</cfif>
	<cfif isDefined("form")>
		<cfset application.scriptProtectionFilter.scan(
									object=form,
									objectname="form",
									ipAddress=request.remoteAddr,
									useTagFilter=true)>
	</cfif>
	<cftry>
		<cfif isDefined("cgi")>
			<cfset application.scriptProtectionFilter.scan(
										object=cgi,
										objectname="cgi",
										ipAddress=request.remoteAddr,
										useTagFilter=true,
										useWordFilter=true,
										fixValues=false)>
		</cfif>
		<cfif isDefined("cookie")>
			<cfset application.scriptProtectionFilter.scan(
										object=cookie,
										objectname="cookie",
										ipAddress=request.remoteAddr,
										useTagFilter=true,
										useWordFilter=true,
										fixValues=false)>
		</cfif>
		<cfcatch></cfcatch>
	</cftry>
	<cfif application.scriptProtectionFilter.isBlocked(request.remoteAddr) eq true>
		<cfset application.eventManager.announceEvent("onGlobalThreatDetect",createObject("component","mura.event"))>
	</cfif> 
</cfif>