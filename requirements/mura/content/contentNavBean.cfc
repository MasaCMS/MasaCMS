<cfcomponent extends="mura.cfobject">

<cfset variables.instance=structNew()>
<cfset variables.instance.content=""/>
<cfset variables.instance.struct=structNew()>
<cfset variables.packageBy="active"/>

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
<cfset var prop="">
<cfset var prefix=left(arguments.MissingMethodName,3)>
<cfset var theValue="">
<cfset var bean="">

<cfif len(arguments.MissingMethodName)>
	<!--- forward normal getters to the default getValue method --->
	<cfif prefix eq "get" and len(arguments.MissingMethodName)gt 3>
		<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>
		<cfreturn getValue(prop)>
	<!---
	<cfelseif listfindNoCase("get,set",arguments.MissingMethodName) and not structIsEmpty(MissingMethodArguments)>
		<cfif arguments.MissingMethodName eq "get">
			<cfreturn getValue(argumentCollection=MissingMethodArguments)>
		<cfelse>
			<cfreturn setValue(argumentCollection=MissingMethodArguments)>
		</cfif>
	--->
	</cfif>
	
	<!--- otherwise get the bean and if the method exsists forward request --->
	<cfset bean=getContentBean()>
	
	<cfif structKeyExists(bean,arguments.MissingMethodName)>
		<cfif not structIsEmpty(MissingMethodArguments)>
			<cfinvoke component="#bean#" method="#MissingMethodName#" argumentcollection="#MissingMethodArguments#" returnvariable="theValue">
		<cfelse>
			<cfinvoke component="#bean#" method="#MissingMethodName#" returnvariable="theValue">
		</cfif>
		
		<cfif isDefined("theValue")>
			<cfreturn theValue>
		<cfelse>
			<cfreturn "">
		</cfif>
		
	<cfelse>
		<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
	</cfif>

<cfelse>
	<cfreturn "">
</cfif>

</cffunction>
		
<cffunction name="init" access="public" returntype="any" output="false">
	<cfargument name="contentStruct">
	<cfargument name="contentManager">
	<cfargument name="packageBy" required="true" default="active">
	<cfset variables.instance.struct=arguments.contentStruct>
	<cfset variables.contentManager=arguments.contentManager>
	<cfset variables.packageBy=arguments.packageBy>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" access="public" returntype="any" output="false">
	<cfargument name="property">	
	<cfif structKeyExists(variables.instance.struct,arguments.property)>
		<cfreturn variables.instance.struct[arguments.property]>
	<cfelse>
		<cfreturn  getContentBean().getValue(arguments.property)>
	</cfif>
</cffunction>

<cffunction name="setValue" access="public" returntype="any" output="false">
	<cfargument name="property">
	<cfargument name="propertyValue">	
	
		<cfset variables.instance.struct[arguments.property]=arguments.propertyValue>
		<cfset getContentBean().setValue(arguments.property, arguments.propertyValue)>
		<cfreturn this>
</cffunction>

<cffunction name="getContentBean" access="public" returntype="any" output="false">
	<cfif isObject(variables.instance.content) >
		<cfreturn variables.instance.content>
	<cfelse>
		<cfif variables.packageBy eq "version"  and structKeyExists(variables.instance.struct,"contentHistID")>
			<cfset variables.instance.content=variables.contentManager.getContentBeanVersion(variables.instance.struct.contentHistID,variables.instance.struct.siteID)>
		<cfelseif structKeyExists(variables.instance.struct,"contentID")>
			<cfset variables.instance.content=variables.contentManager.getActiveContent(variables.instance.struct.contentID,variables.instance.struct.siteID)>
		<cfelse>
			<cfthrow message="The query you are iterating over does not contain either contentID or contentHistID">
		</cfif>
		<cfreturn variables.instance.content>
	</cfif>
</cffunction>

<cffunction name="getParent" output="false" returntype="any">
	<cfset var i="">
	<cfset var cl=0>
	
	<cfif structKeyExists(request,"crumbdata")>
		<cfset cl=arrayLen(request.crumbdata)-1>
		<cfif cl>
			<cfloop from="1" to="#cl#" index="i">
				<cfif request.crumbdata[i].contentID eq getValue("contentID") >
					<cfreturn createObject("component","contentNavBean").init(request.crumbData[i+1], variables.contentManager,"active") />
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	
	<cfreturn getContentBean().getParent()>
	
</cffunction>

</cfcomponent>