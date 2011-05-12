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
	
	<cfreturn removeObjects(arguments.data)>
</cffunction>

<cffunction name="removeObjects" returntype="any">
	<cfargument name="data">
	
	<cfif isstruct(arguments.data)>
		<cfloop collection="#arguments.data#" item="local.dataitem">
			<cfif isobject(arguments.data[local.dataitem])>
				<cfset structdelete(arguments.data,local.dataitem,false)>
			<cfelseif isstruct(arguments.data[local.dataitem])>
				<cfset removeObjects(arguments.data[local.dataitem])>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn arguments.data>
</cffunction>

</cfcomponent>