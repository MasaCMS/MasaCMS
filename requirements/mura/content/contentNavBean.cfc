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
		
<cffunction name="init" access="public" returntype="any" output="false">
	<cfargument name="contentStruct">
	<cfargument name="contentManager">
	<cfset variables.instance.struct=arguments.contentStruct>
	<cfset variables.contentManager=arguments.contentManager>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" access="public" returntype="any" output="false">
	<cfargument name="key">	
	<cfif structKeyExists(variables.instance.struct,arguments.key)>
		<cfreturn variables.instance.struct[arguments.key]>
	<cfelseif isObject(variables.instance.bean) >
		<cfreturn variables.instance.bean.getValue(arguments.key)>
	<cfelse>
		<cfreturn  getBean().getValue(arguments.key)>
	</cfif>
</cffunction>

<cffunction name="getBean" access="public" returntype="any" output="false">
	<cfif isObject(variables.instance.bean) >
		<cfreturn variables.instance.bean>
	<cfelse>
		<cfif structKeyExists(variables.instance.struct,"contentHistID")>
			<cfset variables.instance.bean=variables.contentManager.getContentVersion(variables.instance.struct.contentHistID,variables.instance.struct.siteID)>
		<cfelseif structKeyExists(variables.instance.struct,"contentID")>
			<cfset variables.instance.bean=variables.contentManager.getActiveContent(variables.instance.struct.contentID,variables.instance.struct.siteID)>
		<cfelse>
			<cfthrow message="The query you are iterating over does not contain either contentID or contentHistID">
		</cfif>
		<cfreturn variables.instance.bean>
	</cfif>
</cffunction>

</cfcomponent>