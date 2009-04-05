<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance=structNew()/>

<cffunction name="init" output="false" returnType="any">
<cfargument name="siteid">
<cfargument name="genericManager">
<cfargument name="pluginManager">	

	<cfset variables.siteid=arguments.siteid>
	<cfset variables.genericManager=arguments.genericManager>
	<cfset variables.pluginManager=arguments.pluginManager>
	
	<cfreturn this>
</cffunction>

<cffunction name="getFactory" output="false" returnType="any">
<cfargument name="class">

	<cfif not structKeyExists(variables.instance,arguments.class)>
		<cfset variables.instance[arguments.class]=createObject("component","pluginEventFactory").init(arguments.class,variables.siteid,variables.genericManager,variables.pluginManager)>
	</cfif>
	
	<cfreturn variables.instance[arguments.class]>
</cffunction>

</cfcomponent>