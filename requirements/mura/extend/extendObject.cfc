<cfcomponent extends="mura.cfobject" output="false">

<cfset variable.intsance.error=structNew()>
<cfset variables.instance.Type = "Page" />
<cfset variables.instance.subType = "Default" />
<cfset variables.instance.ID = "" />
<cfset variables.instance.siteID="">
<cfset variables.instance.extendData="">
<cfset variables.instance.extendSetID="">
<cfset variables.manager="">
<cfset variables.configBean="">

<cffunction name="init" output="false">
<cfargument name="type">
<cfargument name="subType">
<cfargument name="siteID">
<cfargument name="manager" default="">
<cfargument name="configBean" default="#application.configBean#">
	<cfset setType(arguments.type)>
	<cfset setSubType(arguments.subType)>
	<cfset setSiteID(arguments.siteID)>
	<cfset setManager(arguments.manager)>
	<cfset setConfigBean(arguments.configBean)>
	<cfreturn this>
</cffunction>

<cffunction name="setID" output="false" access="public">
   <cfargument name="ID" type="string" required="true">
   <cfset variables.instance.ID = trim(arguments.ID) />
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

<cffunction name="getSiteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SiteID />
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

<cffunction name="getType" returnType="string" output="false" access="public">
   <cfreturn variables.instance.Type />
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

 <cffunction name="getSubType" returnType="string" output="false" access="public">
		<cfreturn variables.instance.subType />
 </cffunction>

<cffunction name="validate" access="public" output="false">
		<cfset var extErrors=structNew() />
	
		<cfif len(getSiteID())>
			<cfset extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues())>
		</cfif>
		
		<cfset variables.instance.errors=structnew() />
		
		<cfif not structIsEmpty(extErrors)>
			<cfset structAppend(variables.instance.errors,extErrors)>
		</cfif>
		<cfreturn this>	
</cffunction>

<cffunction name="getErrors" returntype="any" output="false">
	<cfreturn variables.instance.errors>
</cffunction>

<cffunction name="getExtendedData" returntype="any" output="false" access="public">
	<cfif not isObject(variables.instance.extendData)>
	<cfset variables.instance.extendData=variables.configBean.getClassExtensionManager().getExtendedData(baseID:getID(), type:getType(), subType:getSubType(), siteID:getSiteID())/>
	</cfif> 
	<cfreturn variables.instance.extendData />
</cffunction>

<cffunction name="purgeExtendedData" output="false" access="public">
	<cfset variables.instance.extendData=""/>
	<cfreturn this>
</cffunction>

<cffunction name="getExtendedAttribute" returnType="string" output="false" access="public">
 	<cfargument name="key" type="string" required="true">
	<cfargument name="useMuraDefault" type="boolean" required="true" default="false"> 
	
  	<cfreturn getExtendedData().getAttribute(arguments.key,arguments.useMuraDefault) />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="propertyValue" default="" >
	
	<cfset var extData =structNew() />
	<cfset var i = "">	
	
	<cfif structKeyExists(this,"set#property#")>
		<cfset evaluate("set#property#(arguments.propertyValue)") />
	<cfelse>
		<cfset extData=getExtendedData().getExtendSetDataByAttributeName(arguments.property)>
		<cfif not structIsEmpty(extData)>
			<cfset structAppend(variables.instance,extData.data,false)>	
			<cfloop list="#extData.extendSetID#" index="i">
				<cfif not listFind(variables.instance.extendSetID,i)>
					<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
				</cfif>
			</cfloop>
		</cfif>
			
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
		
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	
	<cfif structKeyExists(this,"get#property#")>
		<cfreturn evaluate("get#property#()") />
	<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn getExtendedAttribute(arguments.property) />
	</cfif>

</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfset var i="">
		<cfset var extData=getExtendedData().getAllExtendSetData()>
		
		<cfif not structIsEmpty(extData)>
			<cfset structAppend(variables.instance,extData.data,false)>	
			<cfloop list="#extData.extendSetID#" index="i">
				<cfif not listFind(variables.instance.extendSetID,i)>
					<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
				</cfif>
			</cfloop>
		</cfif>
	
		<cfset purgeExtendedData()>
	
		<cfreturn variables.instance />
</cffunction>

<cffunction name="save" output="false">
	<cfif isObject(getManager())>
		<cfset getManager().save(this)>
	<cfelse>
		<cfset getConfigBean().getClassExtensionManager().saveExtendedData(getID(),getAllValues())/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="delete" output="false">
	<cfif isObject(getManager())>
		<cfset getManager().delete(this)>
	<cfelse>
		<cfset getConfigBean().getClassExtensionManager().deleteExtendedData(getID())/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
<cfset var prop="">
<cfset var prefix=left(arguments.MissingMethodName,3)>
<cfset var bean="">

<cfif len(arguments.MissingMethodName)>
	<cfif listFindNoCase("set,get",prefix) and len(arguments.MissingMethodName) gt 3>
		<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>	
		<cfif prefix eq "get">
			<cfreturn getValue(prop)>
		<cfelseif prefix eq "set" and not structIsEmpty(MissingMethodArguments)>
			<cfset setValue(prop,MissingMethodArguments[1])>	
		</cfif>
	<cfelse>
		<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
	</cfif>
<cfelse>
	<cfreturn "">
</cfif>

</cffunction>

</cfcomponent>