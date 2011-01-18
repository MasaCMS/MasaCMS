<cfcomponent output="false" extends="mura.cfobject">

<cffunction name="init" output="false" returntype="any">
	<cfset super.init()>
	<cfreturn this>
</cffunction>

<cffunction name="call">
	<cfargument name="event">
	
	<cfset proceed(event)>
	
</cffunction>

<cffunction name="proceed">
	<cfargument name="event">
	
	<cfinvoke component="#this#" method="#event.getValue('methodName')#">
		<cfinvokeargument name="event" value="#event#" />
	</cfinvoke>
	
</cffunction>

<cffunction name="format" returntype="any">
	<cfargument name="data">
	<cfargument name="format">
	
	<cfreturn arguments.data>
</cffunction>

</cfcomponent>