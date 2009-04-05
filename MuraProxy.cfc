<cfcomponent output="false" extends="mura.cfobject">

<cffunction name="purgeSiteCache" access="remote" output="false">
<cfargument name="siteid" required="true" default="">
	<cfset super.purgeSiteCache(arguments.siteid)>
</cffunction>

<cffunction name="reload" access="remote" output="false">
	<cfset super.reload()>
</cffunction>

</cfcomponent>