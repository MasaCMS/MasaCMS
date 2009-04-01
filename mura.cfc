<cfcomponent output="false" extends="mura.cfobject">

<cffunction name="purgeSiteCache" access="remote" output="false">
<cfargument name="siteid">
<cfargument name="appreloadKey">

<cfif arguments.appreloadkey eq application.appreloadKey>
	<cfif len(arguments.siteid)>
		<cfset application.settingsManager.getSite("site").getCacheFactory().purgeAll()>	
	<cfelse>
		<cfset application.settingsManager.purgeAllCache()>
	</cfif>
</cfif>
</cffunction>
</cfcomponent>