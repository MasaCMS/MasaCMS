<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
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
	<cfset variables.instance.sourceIterator = "" />
	<cfreturn this>
</cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
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
	<cfset variables.instance.extendData=variables.configBean.getClassExtensionManager().getExtendedData(baseID:getExtendBaseID(), type:variables.instance.type, subType:variables.instance.subtype, siteID:variables.instance.siteID, dataTable=variables.instance.extendDataTable, sourceIterator=variables.instance.sourceIterator)/>
	</cfif> 
	<cfreturn variables.instance.extendData />
</cffunction>

<cffunction name="purgeExtendedData" output="false" access="public">
	<cfset variables.instance.extendData=""/>
	<cfset variables.instance.extendAutoComplete = true />
	<cfset variables.instance.sourceIterator = "" />
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
		<!---
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
		--->
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
		
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="defaultValue">
	<cfset var tempValue="">	
	<cfif len(arguments.property)>
		<cfif structKeyExists(this,"get#arguments.property#")>
			<cfreturn evaluate("get#arguments.property#()") />
		<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
			<cfreturn variables.instance["#arguments.property#"] />
		<cfelseif structKeyExists(arguments,"defaultValue")>
			<cfset tempValue=getExtendedAttribute(arguments.property,true) />
			<cfif tempValue neq "useMuraDefault">
				<cfset variables.instance["#arguments.property#"]=tempValue />
				<cfreturn tempValue>
			<cfelse>
				<cfset variables.instance["#arguments.property#"]=arguments.defaultValue />
				<cfreturn arguments.defaultValue />
			</cfif>
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