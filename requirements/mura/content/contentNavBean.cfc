<cfcomponent extends="mura.cfobject">

<cfset variables.instance=structNew()>
<cfset variables.instance.content="">
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
		
<cffunction name="set" access="public" returntype="any" output="false">
	<cfargument name="contentStruct">
	<cfargument name="packageBy" required="true" default="active">
	
	<cfset variables.instance.struct=arguments.contentStruct>
	<cfset variables.packageBy=arguments.packageBy>
	
	<cfreturn this>
</cffunction>

<cffunction name="getValue" access="public" returntype="any" output="false">
	<cfargument name="property">
	<cfif len(arguments.property)>	
		<cfif isdefined("variables.instance.struct.#arguments.property#")>
			<cfreturn variables.instance.struct[arguments.property]>
		<cfelse>
			<cfreturn  getContentBean().getValue(arguments.property)>
		</cfif>
	<cfelse>
		<cfreturn "">
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
	
	<cfif isObject("variables.instance.content") >
		<cfreturn variables.instance.content>
	<cfelse>
		<cfif variables.packageBy eq "version" and structKeyExists(variables.instance.struct,"contentHistID")>
			<cfset variables.instance.content=getBean("contentManager").getContentVersion(contentHistID=variables.instance.struct.contentHistID, siteID=variables.instance.struct.siteID)>
		<cfelseif structKeyExists(variables.instance.struct,"contentID")>
			<cfset variables.instance.content=getBean("contentManager").getActiveContent(contentID=variables.instance.struct.contentID,siteID=variables.instance.struct.siteID)>
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
					<cfreturn createObject("component","contentNavBean").init(request.crumbData[i+1], getBean("contentManager"),"active") />
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	
	<cfreturn getContentBean().getParent()>
	
</cffunction>

<cffunction name="getKidsQuery" returnType="query" output="false" access="public">
	<cfargument name="aggregation" required="true" default="false">
	
	<cfif structKeyExists(variables.instance.struct,"kids") and isNumeric(variables.instance.struct.kids) and not variables.instance.struct.kids>
		<!--- There are no kids so no need to query --->
		<cfreturn queryNew("contentid,contenthistid,siteid,type,filename,title,menutitle,summary,kids")>
	<cfelse>
		<cfreturn getBean("contentManager").getKidsQuery(siteID:getValue("siteID"), parentID:getValue("contentID"), sortBy:getValue("sortBy"), sortDirection:getValue("sortDirection"), aggregation=arguments.aggregation) />
	</cfif>
</cffunction>

<cffunction name="getKidsIterator" returnType="any" output="false" access="public">
	<cfargument name="liveOnly" required="true" default="true">
	<cfargument name="aggregation" required="true" default="false">
	<cfset var q=getKidsQuery(arguments.aggregation) />
	<cfset var it=getBean("contentIterator").init(packageBy="active")>
	
	<cfif arguments.liveOnly>
		<cfset q=getKidsQuery(arguments.aggregation) />
	<cfelse>
		<cfset q=getBean("contentManager").getNest( parentID:getValue("parentID"), siteID:getValue("siteID"), sortBy:getValue("sortBy"), sortDirection:getValue("sortDirection")) />
	</cfif>
	<cfset it.setQuery(q,getValue("nextn"))>
	
	<cfreturn it>
</cffunction>

<cffunction name="getCrumbArray" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfargument name="setInheritance" required="true" type="boolean" default="false">
	<cfreturn getBean("contentManager").getCrumbList(contentID=getValue("contentID"), siteID=getValue("siteID"), setInheritance=arguments.setInheritance, path=getValue("path"), sort=arguments.sort)>
</cffunction>

<cffunction name="getCrumbIterator" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfargument name="setInheritance" required="true" type="boolean" default="false">
	<cfset var a=getCrumbArray(setInheritance=arguments.setInheritance,sort=arguments.sort)>
	<cfset var it=getBean("contentIterator").init()>
	<cfset it.setArray(a)>
	<cfreturn it>
</cffunction>

<cffunction name="getURL" output="false">
	<cfargument name="querystring" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="showMeta" type="string" required="true" default="0">
	<cfreturn getBean("contentManager").getURL(this, arguments.queryString, arguments.complete, arguments.showMeta)>
</cffunction>			

<cffunction name="getImageURL" output="false">
	<cfargument name="size" required="true" default="Large">
	<cfargument name="direct" default="true"/>
	<cfargument name="complete" default="false"/>
	<cfargument name="height" default=""/>
	<cfargument name="width" default=""/>
	<cfset arguments.bean=this>
	<cfreturn getBean("contentManager").getImageURL(argumentCollection=arguments)>
</cffunction>

</cfcomponent>