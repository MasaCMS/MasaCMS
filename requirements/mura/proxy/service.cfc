<cfcomponent output="false" extends="mura.cfobject">

<cffunction name="init" output="false" returntype="any">
	<cfset super.init()>
	<cfset variables.anythingToXML=createObject("component","AnythingToXML.AnythingToXML").init()>
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
	
	<cfset var formattedData="">
	
	<cfswitch expression="#arguments.format#">
		<cfcase value="wddx">
			<cfwddx action="cfml2wddx" input="#arguments.data#" output="formattedData" />
		</cfcase>
		<cfcase value="json">
			<cfset formattedData=serializeJSON(arguments.data)>
		</cfcase>
		<cfcase value="xml">
			<cfset formattedData=variables.anythingToXML.toXML(arguments.data)>
		</cfcase>
		<cfdefaultcase>
			<cfset formattedData=arguments.data>
		</cfdefaultcase>
	</cfswitch>
	
	<cfreturn formattedData>
</cffunction>

</cfcomponent>