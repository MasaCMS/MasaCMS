<cfcomponent extends="mura.cfobject">

<cfset variables.instance=structNew()>
<cfset variables.instance.bean=""/>
<cfset variables.instance.struct=structNew()>

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
<cfset var prop="">
<cfif len(arguments.MissingMethodName) gt 3>
	<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>
	<cfreturn getValue(prop)>
<cfelse>
	<cfreturn "The method '#arguments.MissingMethodName#' is not defined">
</cfif>
</cffunction>
	
	
<cffunction name="init" access="public" returntype="any">
	<cfargument name="contentStruct">
	<cfargument name="contentManager">
	<cfset variables.instance.struct=arguments.contentStruct>
	<cfset variables.contentManager=arguments.contentManager>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" access="public" returntype="any">
	<cfargument name="key">
	
	<cfif isObject(variables.instance.bean) >
		<cfreturn variables.instance.bean.getValue(key)>
	<cfelse>
		<cfif structKeyExists(variables.instance.struct,key)>
			<cfreturn variables.instance.struct[key]>
		<cfelse>
			<cfset variables.instance.bean=variables.contentManager.getActiveContent(variables.instance.struct.contentID,variables.instance.struct.siteID)>
			<cfreturn variables.instance.bean.getValue(key)>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfif isObject(variables.instance.bean) >
		<cfreturn variables.instance.bean>
	<cfelse>
		<cfset variables.instance.bean=variables.contentManager.getActiveContent(variables.instance.struct.contentID,variables.instance.struct.siteID)>
		<cfreturn variables.instance.bean>
	</cfif>
</cffunction>

</cfcomponent>