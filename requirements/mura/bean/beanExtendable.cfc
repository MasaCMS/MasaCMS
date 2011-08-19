<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="extendData" type="any" default="" required="true" />
<cfproperty name="extendSetID" type="string" default="" required="true" />
<cfproperty name="extendDataTable" type="string" default="tclassextenddata" required="true" />
<cfproperty name="type" type="string" default="Custom" required="true" />
<cfproperty name="subType" type="string" default="Default" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="extendAutoComplete" type="boolean" default="false" required="true" />

<cffunction name="init" output="false">
	<cfset super.init(argumentCollection=arguments)>
	<cfset variables.instance.extendData="" />
	<cfset variables.instance.extendSetID="" />
	<cfset variables.instance.extendDataTable="tclassextenddata" />
	<cfset variables.instance.extendAutoComplete = true />
	<cfset variables.instance.type = "Custom" />
	<cfset variables.instance.subType = "Default" />
	<cfset variables.instance.siteiD = "" />
	
</cffunction>

<!--- This needs to be overriden--->
<cffunction name="getExtendBaseID" output="false">
	<cfreturn "">
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

<cffunction name="setSiteID" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
	<cfif len(arguments.siteID) and trim(arguments.siteID) neq variables.instance.siteID>
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
	<cfset purgeExtendedData()>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getExtendedData" returntype="any" output="false" access="public">
	<cfif not isObject(variables.instance.extendData)>
	<cfset variables.instance.extendData=variables.configBean.getClassExtensionManager().getExtendedData(baseID:getExtendBaseID(), type:variables.instance.type, subType:variables.instance.subtype, siteID:variables.instance.siteID, dataTable=variables.instance.extendDataTable)/>
	</cfif> 
	<cfreturn variables.instance.extendData />
</cffunction>

<cffunction name="purgeExtendedData" output="false" access="public">
	<cfset variables.instance.extendData=""/>
	<cfset variables.instance.extendAutoComplete = true />
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
	
	<cfif isSimpleValue(arguments.propertyValue)>
		<cfset arguments.propertyValue=trim(arguments.propertyValue)>
	</cfif>
	
	<cfif structKeyExists(this,"set#arguments.property#")>
		<cfset evaluate("set#arguments.property#(arguments.propertyValue)") />
	<cfelse>
		<cfif not structKeyExists(variables.instance,arguments.property)>
			<cfset extData=getExtendedData().getExtendSetDataByAttributeName(arguments.property)>
			<cfif not structIsEmpty(extData)>
				<cfset structAppend(variables.instance,extData.data,false)>	
				<cfloop list="#extData.extendSetID#" index="i">
					<cfif not listFind(variables.instance.extendSetID,i)>
						<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
		
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">	
	<cfif len(arguments.property)>
		<cfif isdefined("this.get#property#")>
			<cfreturn evaluate("get#property#()") />
		<cfelseif isdefined("variables.instance.#arguments.property#")>
			<cfreturn variables.instance["#arguments.property#"] />
		<cfelse>
			<cfreturn getExtendedAttribute(arguments.property) />
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfargument name="autocomplete" required="true" default="#variables.instance.extendAutoComplete#">
	<cfset var i="">
	<cfset var extData="">
		
	<cfif arguments.autocomplete>
		<cfset extData=getExtendedData().getAllExtendSetData()>
			
		<cfif not structIsEmpty(extData)>
			<cfset structAppend(variables.instance,extData.data,false)>	
			<cfloop list="#extData.extendSetID#" index="i">
				<cfif not listFind(variables.instance.extendSetID,i)>
					<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
		
	<cfset purgeExtendedData()>
		
	<cfreturn variables.instance />
</cffunction>

</cfcomponent>