<cfcomponent extends="mura.bean.beanExtendable" output="false">

<cfproperty name="type" type="string" default="" required="true" />
<cfproperty name="subType" type="string" default="" required="true" />
<cfproperty name="id" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="remoteID" type="string" default="" required="true" />

<cfset variables.manager="">
<cfset variables.configBean="">

<cffunction name="init" output="false">
<cfargument name="type" default="Custom">
<cfargument name="subType" default="">
<cfargument name="siteID" default="">
<cfargument name="manager" default="">
<cfargument name="configBean" default="#application.configBean#">
<cfargument name="ID" default="">
<cfargument name="remoteID" default="">
<cfargument name="sourceIterator" default="">

	<cfset super.init(argumentCollection=arguments)>

	<cfset variables.instance.ID = "">
	
	<cfset setType(arguments.type)>
	<cfset setSubType(arguments.subType)>
	<cfset setSiteID(arguments.siteID)>
	<cfset setManager(arguments.manager)>
	<cfset setConfigBean(arguments.configBean)>
	<cfset setID(arguments.ID)>
	<cfset variables.instance.remoteID=arguments.remoteID>
	<cfset variables.instance.sourceIterator=arguments.sourceIterator>
	
	<cfreturn this>
</cffunction>

<cffunction name="setID" output="false" access="public">
   <cfargument name="ID" type="string" required="true">
	<cfset arguments.ID=trim(arguments.ID)>
	<cfif len(arguments.ID)>
   	<cfset variables.instance.ID = trim(arguments.ID) />
	</cfif>
	<cfreturn this>
 </cffunction>

<cffunction name="getID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.ID)>
		<cfset variables.instance.ID = createUUID() />
	</cfif>
	<cfreturn variables.instance.ID />
</cffunction>

<cffunction name="setManager" output="false" access="public">
   <cfargument name="manager">
   <cfset variables.manager =arguments.manager />
	<cfreturn this>
 </cffunction>

<cffunction name="getManager" output="false" access="public">
	<cfreturn variables.manager />
</cffunction>

<cffunction name="setConfigBean" output="false" access="public">
   <cfargument name="ConfigBean">
   <cfset variables.configBean=arguments.configBean />
	<cfreturn this>
 </cffunction>

<cffunction name="getConfigBean" output="false" access="public">
	<cfreturn variables.configBean />
</cffunction>

<cffunction name="setSiteID" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
	<cfif len(arguments.siteID) and trim(arguments.siteID) neq variables.instance.siteID>
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
	<cfset purgeExtendedData()>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setType" output="false" access="public">
   <cfargument name="Type" type="string" required="true">
   <cfset arguments.Type=trim(arguments.Type)>
	
	<cfif len(arguments.Type) and variables.instance.Type neq arguments.Type>
		<cfset variables.instance.Type = arguments.Type />
		<cfset purgeExtendedData()>
	</cfif>
	
	<cfreturn this>
</cffunction>

 <cffunction name="setSubType" output="false" access="public">
   <cfargument name="SubType" type="string" required="true">
	<cfset arguments.subType=trim(arguments.subType)>
	<cfif len(arguments.subType) and variables.instance.SubType neq arguments.SubType>
   		<cfset variables.instance.SubType = arguments.SubType />
		<cfset purgeExtendedData()>
	</cfif>
	<cfreturn this>
 </cffunction>

<cffunction name="validate" access="public" output="false">
		<cfset var extErrors=structNew() />
	
		<cfif len(variables.instance.siteID)>
			<cfset extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues())>
		</cfif>
		
		<cfset variables.instance.errors=structnew() />
		
		<cfif not structIsEmpty(extErrors)>
			<cfset structAppend(variables.instance.errors,extErrors)>
		</cfif>
		<cfreturn this>	
</cffunction>

<cffunction name="getExtendBaseID" output="false">
	<cfreturn getID()>
</cffunction>

<cffunction name="save" output="false">
	<cfif isObject(getManager())>
		<cfset getManager().save(this)>
	<cfelse>
		<cfset getConfigBean().getClassExtensionManager().saveExtendedData(getID(),getAllValues(), variables.instance.extendDataTable)/>
	</cfif>
	<cfset getBean("trashManager").takeOut(this)>
	<cfreturn this>
</cffunction>

<cffunction name="delete" output="false">
	<cfset getBean("trashManager").throwIn(this)>
	<cfif isObject(getManager())>
		<cfset getManager().delete(this)>
	<cfelse>
		<cfset getConfigBean().getClassExtensionManager().deleteExtendedData(getID(), variables.instance.extendDataTable)/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="loadBy" output="false">
	<cfset var feed="">
	<cfset var it="">
	<cfset var response="">
	<cfif structKeyExists(arguments,"siteID")>
		<cfset setSiteID(arguments.siteID)>
	</cfif>
	<cfif structKeyExists(arguments,"type")>
		<cfset setType(arguments.type)>
	</cfif>
	<cfif structKeyExists(arguments,"subType")>
		<cfset setSubType(arguments.subType)>
	</cfif>
	<cfif structKeyExists(arguments,"ID")>
		<cfset setID(arguments.ID)>
		<cfreturn this>
	</cfif>
	<cfif structKeyExists(arguments,"remoteID")>
		<cfset variables.instance.remoteID=arguments.remoteID>
		<cfset feed=getBean("extendObjectFeedBean")>
		<cfset feed.setSiteID(variables.instance.siteID)>
		<cfset feed.setType(variables.instance.type)>
		<cfset feed.setSubType(variables.instance.subtype)>
		<cfset feed.addAdvancedParam(field="#variables.instance.extendDataTable#.remoteID",criteria=arguments.remoteID)>
		<cfset it=feed.getIterator()>
		<cfif it.hasNext()>
			<cfset setAllValues(it.next().getAllVAlues())>
			<cfif it.getRecordCount() gt 1>
				<cfset response=arrayNew(1)>
				<cfset it.reset()>
				<cfloop condition="it.hasNext()">
					<cfset arrayAppend(response,it.next())>
				</cfloop>
				<cfreturn response>
			<cfelse>
				<cfreturn this>
			</cfif>
		</cfif>
	</cfif>
	
	<cfreturn this>
</cffunction>

</cfcomponent>