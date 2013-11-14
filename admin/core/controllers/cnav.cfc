<cfcomponent extends="controller" output="false">

<cffunction name="setSettingsManager" output="false">
	<cfargument name="settingsManager">
	<cfset variables.settingsManager=arguments.settingsManager>
</cffunction>

<cffunction name="searchsitedata" ouput="false">
	<cfargument name="rc">

	<cfset arguments.rc.rsList=variables.settingsManager.getUserSites(
		session.siteArray,
		listFind(session.mura.memberships,'S2'),
		rc.searchString,
		-1 
	) /><!--- // unlimited maxRows because of minLength trigger of autocomplete set to 2 --->
	
</cffunction>

</cfcomponent>