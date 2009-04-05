<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance=structNew()/>

<cffunction name="getFactory" output="false" returnType="any">
<cfargument name="class">
	
	<cfif not structKeyExists(variables.instance,arguments.class)>
		<cfset variables.instance[arguments.class]=createObject("component","genericFactory").init(arguments.class)>
	</cfif>
	
	<cfreturn variables.instance[arguments.class]>
</cffunction>

</cfcomponent>