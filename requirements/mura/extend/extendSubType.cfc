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
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.subTypeID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.type=""/>
<cfset variables.instance.subtype="Default"/>
<cfset variables.instance.baseTable=""/>
<cfset variables.instance.baseKeyField=""/>
<cfset variables.instance.dataTable="tclassextenddata"/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.hasSummary=1/>
<cfset variables.instance.hasBody=1/>
<cfset variables.instance.description=""/>
<cfset variables.instance.availableSubTypes=""/>
<cfset variables.instance.isActive=1/>
<cfset variables.instance.sets=""/>
<cfset variables.instance.isNew=1/>
<cfset variables.instance.errors=structnew() />
<cfset variables.contentRenderer="" />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
	<cfreturn this />
</cffunction>

<cffunction name="getExtendSetBean" returnType="any">
<cfset var extendSetBean=createObject("component","mura.extend.extendSet").init(variables.configBean,getContentRenderer()) />
<cfset extendSetBean.setSubTypeID(getSubTypeID()) />
<cfset extendSetBean.setSiteID(getSiteID()) />
<cfreturn extendSetBean />
</cffunction>

<cffunction name="load">
	<cfset var rs=""/>
		<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select subtypeid,siteID,baseTable,baseKeyField,dataTable,type,subtype,
		isActive,notes,lastUpdate,dateCreated,lastUpdateBy,hasSummary,hasBody,description,availableSubTypes 
		from tclassextend 
		where subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtypeID()#">
		or (
			siteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
			and type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#gettype()#">
			and subType=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtype()#">
			)
		order by type,subType
		</cfquery>
	
	<cfif rs.recordcount>
		<cfset set(rs) />
		<cfset setIsNew(0)>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="set" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isquery(arguments.data)>
		
			<cfset setSubTypeID(arguments.data.subTypeID) />
			<cfset setSiteID(arguments.data.siteID) />
			<cfset setType(arguments.data.type) />
			<cfset setSubType(arguments.data.subType) />
			<cfset setBaseTable(arguments.data.BaseTable) />
			<cfset setDataTable(arguments.data.DataTable) />
			<cfset setbaseKeyField(arguments.data.baseKeyField) />
			<cfset setIsActive(arguments.data.isActive) />
			<cfset setHasSummary(arguments.data.hasSummary) />
			<cfset setHasBody(arguments.data.hasBody) />
			<cfset setDescription(arguments.data.description)/>
			<cfset setAvailableSubTypes(arguments.data.availableSubTypes)/>
			
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.data[prop])") />
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfset validate() />
		<cfreturn this>
</cffunction>
  
<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getSubTypeID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.SubTypeID)>
		<cfset variables.instance.SubTypeID = createUUID() />
	</cfif>
	<cfreturn variables.instance.SubTypeID />
</cffunction>

<cffunction name="setSubTypeID" access="public" output="false">
	<cfargument name="SubTypeID" type="String" />
	<cfset variables.instance.SubTypeID = trim(arguments.SubTypeID) />
	<cfreturn this>
</cffunction>

<cffunction name="getType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="setType" access="public" output="false">
	<cfargument name="Type" type="String" />
	<cfif arguments.type eq 'Portal'>
		<cfset arguments.type='Folder'>
	</cfif>
	<cfset variables.instance.Type = trim(arguments.Type) />
	<cfreturn this>
</cffunction>

<cffunction name="getSubType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SubType />
</cffunction>

<cffunction name="setSubType" access="public" output="false">
	<cfargument name="SubType" type="String" />
	<cfset variables.instance.SubType = trim(arguments.SubType) />
	<cfreturn this>
</cffunction>

<cffunction name="getDataTable" returntype="String" access="public" output="false">
	<cfreturn variables.instance.DataTable />
</cffunction>

<cffunction name="setDataTable" access="public" output="false">
	<cfargument name="DataTable" type="String" />
	<cfif len(trim(arguments.dataTable))>
		<cfset variables.instance.DataTable = trim(arguments.DataTable) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getBaseTable" returntype="String" access="public" output="false">
	<cfreturn variables.instance.BaseTable />
</cffunction>

<cffunction name="setBaseTable" access="public" output="false">
	<cfargument name="BaseTable" type="String" />
	<cfset variables.instance.BaseTable = trim(arguments.BaseTable) />
	<cfreturn this>
</cffunction>

<cffunction name="getbaseKeyField" returntype="String" access="public" output="false">
	<cfreturn variables.instance.baseKeyField />
</cffunction>

<cffunction name="setbaseKeyField" access="public" output="false">
	<cfargument name="baseKeyField" type="String" />
	<cfset variables.instance.baseKeyField = trim(arguments.baseKeyField) />
	<cfreturn this>
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.IsActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="IsActive"/>
	<cfif isNumeric(arguments.isActive)>
		<cfset variables.instance.IsActive = arguments.IsActive />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getHasSummary" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.hasSummary />
</cffunction>

<cffunction name="setHasSummary" access="public" output="false">
	<cfargument name="hasSummary"/>
	<cfif isNumeric(arguments.hasSummary)>
		<cfset variables.instance.hasSummary = arguments.hasSummary />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getHasBody" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.hasBody />
</cffunction>

<cffunction name="setHasBody" access="public" output="false">
	<cfargument name="hasBody"/>
	<cfif isNumeric(arguments.hasBody)>
		<cfset variables.instance.hasBody = arguments.hasBody />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDescription" returntype="String" access="public" output="false">
	<cfreturn variables.instance.description />
</cffunction>

<cffunction name="setDescription" access="public" output="false">
	<cfargument name="description" type="String" />
	<cfset variables.instance.description = trim(arguments.description) />
	<cfreturn this>
</cffunction>

<cffunction name="getAvailableSubTypes" returntype="String" access="public" output="false">
	<cfreturn variables.instance.availableSubTypes />
</cffunction>

<cffunction name="setAvailableSubTypes" access="public" output="false">
	<cfargument name="availableSubTypes" type="String" />
	<cfset variables.instance.availableSubTypes = trim(arguments.availableSubTypes) />
	<cfreturn this>
</cffunction>

<cffunction name="getIsNew" output="false">
	<cfreturn variables.instance.isNew>
</cffunction>

<cffunction name="setIsNew" output="false">
	<cfargument name="isNew">
	<cfset variables.instance.isNew=arguments.isNew>
	<cfreturn this>
</cffunction>

<cffunction name="getExtendSets" access="public" returntype="array">
<cfargument name="Inherit" required="true" default="false"/>
<cfargument name="doFilter" required="true" default="false"/>
<cfargument name="filter" required="true" default=""/>
<cfargument name="container" required="true" default=""/>
<cfargument name="activeOnly" required="true" default="false"/>
<cfset var rs=""/>
<cfset var tempArray=""/>
<cfset var extendSet=""/>
<cfset var extendArray=arrayNew(1) />
<cfset var rsSets=""/>
<cfset var extendSetBean=""/>
<cfset var s=0/>

	<cfset rsSets=getSetsQuery(arguments.inherit,arguments.doFilter,arguments.filter,arguments.container,arguments.activeOnly)/>
	
	<cfif rsSets.recordcount>
		<cfset tempArray=createObject("component","mura.queryTool").init(rsSets).toArray() />
		
		<cfloop from="1" to="#rsSets.recordcount#" index="s">
			
			<cfset extendSetBean=getExtendSetBean() />
			<cfset extendSetBean.set(tempArray[s]) />
			<cfset arrayAppend(extendArray,extendSetBean)/>
		</cfloop>
		
	</cfif>
	
	<cfreturn extendArray />
</cffunction>

<cffunction name="save"  access="public" output="false">
<cfset var rs=""/>
<cfset var extendSetBean=""/>

	<cfif not len(getBaseTable())>
		<cfswitch expression="#getType()#">
			<cfcase value="Page,Folder,Component,File,Link,Calendar,Gallery">
				<cfset setBaseTable("tcontent")>
			</cfcase>
			<cfcase value="1,2,User,Group,Address">
				<cfset setBaseTable("tusers")>
			</cfcase>
		</cfswitch>
	</cfif>
	
	<cfif not len(getBaseKeyField())>
		<cfswitch expression="#getType()#">
			<cfcase value="Page,Folder,Component,File,Link,Calendar,Gallery">
				<cfset setBaseKeyField("contentHistID")>
			</cfcase>
			<cfcase value="1,2,User,Group,Address">
				<cfset setBaseKeyField("userID")>
			</cfcase>
		</cfswitch>
	</cfif>
	
	<cfif not len(getDataTable())>
		<cfswitch expression="#getType()#">
			<cfcase value="Page,Folder,Component,File,Link,Calendar,Gallery">
				<cfset setDataTable("tclassextenddata")>
			</cfcase>
			<cfcase value="1,2,User,Group,Address">
				<cfset setDataTable("tclassextenddatauseractivity")>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select subTypeID,type,subtype,siteid from tclassextend where subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSubTypeID()#">
	</cfquery>
	
	<cfif rs.recordcount>
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tclassextend set
		siteID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		type = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
		subType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubType() neq '',de('no'),de('yes'))#" value="#getSubType()#" maxlength="25">,
		baseTable = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getBaseTable() neq '',de('no'),de('yes'))#" value="#getBaseTable()#">,
		baseKeyField = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getbaseKeyField() neq '',de('no'),de('yes'))#" value="#getbaseKeyField()#">,
		dataTable=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDataTable() neq '',de('no'),de('yes'))#" value="#getDataTable()#">,
		isActive = #getIsActive()#,
		hasSummary = #getHasSummary()#,
		hasBody = #getHasBody()#,
		description=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDescription() neq '',de('no'),de('yes'))#" value="#getDescription()#">,
		availableSubTypes=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getAvailableSubTypes() neq '',de('no'),de('yes'))#" value="#getAvailableSubTypes()#">
		where subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSubTypeID()#">
		</cfquery>
		
		<cfif not (rs.subtype eq 'Address' or getType() eq 'Address') and rs.type neq 'Default' and (rs.type neq getType() or rs.subtype neq getSubType() and getBaseTable() neq "Custom")>
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				update #getBaseTable()# set
				type = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
				subType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubType() neq '',de('no'),de('yes'))#" value="#getSubType()#" maxlength="25">
				where 
				subType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.subtype#" maxlength="25">
				and type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.type#">
				and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.siteID#">
			</cfquery>	
		</cfif>
		
	<cfelse>
	
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		Insert into tclassextend (subTypeID,siteID,type,subType,baseTable,baseKeyField,dataTable,isActive,hasSummary,hasBody,description,availableSubTypes) 
		values(
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubTypeID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSiteID() neq '',de('no'),de('yes'))#" value="#getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getType() neq '',de('no'),de('yes'))#" value="#getType()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getSubType() neq '',de('no'),de('yes'))#" value="#getSubType()#" maxlength="25">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getBaseTable() neq '',de('no'),de('yes'))#" value="#getBaseTable()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getbaseKeyField() neq '',de('no'),de('yes'))#" value="#getbaseKeyField()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDataTable() neq '',de('no'),de('yes'))#" value="#getDataTable()#">,
		#getIsActive()#,
		#getHasSummary()#,
		#getHasBody()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getDescription() neq '',de('no'),de('yes'))#" value="#getDescription()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(getAvailableSubTypes() neq '',de('no'),de('yes'))#" value="#getAvailableSubTypes()#">
		)
		</cfquery>
		<!---
		<cfset extendSetBean=getExtendSetBean() />
		<cfset extendSetBean.setName('Default') />
		<cfset extendSetBean.setSiteID(getSiteID()) />
		<cfset extendSetBean.save() />
		--->
	</cfif>
	
	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>
	
	<cfreturn this>
</cffunction>

<cffunction name="getExtendSetByName" access="public" output="false" returntype="any">
<cfargument name="name">
<cfset var extendSets=getExtendSets()/>
<cfset var i=0/>
<cfset var extendSet=""/>
	<cfif arrayLen(extendSets)>
	<cfloop from="1" to="#arrayLen(extendSets)#" index="i">
		<cfif extendSets[i].getName() eq arguments.name>
			<cfreturn extendSets[i]/>
		</cfif>
	</cfloop>
	</cfif>
	
	<cfset extendSet=getExtendSetBean()>
	<cfset extendSet.setName(arguments.name)>
	<cfreturn extendSet/>
</cffunction>

<cffunction name="delete" access="public">
<cfset var rs=""/>
<cfset var rsSets=""/>


	<cfset rsSets=getSetsQuery()/>
	
	<cfif rsSets.recordcount>	
		<cfloop query="rsSets">
			<cfset deleteSet(rsSets.ExtendSetID)/>
		</cfloop>
	</cfif>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tclassextend 
	where 
	subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtypeID()#">
	</cfquery>
	
	<cfif not listFindNoCase("Custom,Site,Base",getType())>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update #getBaseTable()#
		set subType='Default'
		where 
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
		and subType=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtype()#">
		</cfquery>
	</cfif>
	<cfset variables.classExtensionManager.purgeDefinitionsQuery()>
	
</cffunction>

<cffunction name="loadSet" access="public" returntype="any">
<cfargument name="ExtendSetID">
<cfset var extendSetBean=getExtendSetBean() />
	
	<cfset extendSetBean.setExtendSetID(arguments.ExtendSetID)/>
	<cfset extendSetBean.load()/>
	<cfreturn extendSetBean/>

</cffunction>

<cffunction name="addExtendSet" access="public" output="false">
<cfargument name="rawdata">
<cfset var extendSet=""/>
<cfset var data=arguments.rawdata />

	<cfif not isObject(data)>
		<cfset extendSet=getExtendSetBean() />
		<cfset extendSet.set(data)/>
	<cfelse>
		<cfset extendSet=data />
	</cfif>
	
	<cfset extendSet.setSubTypeID(getSubTypeID())/>
	<cfset extendSet.setSiteID(getSiteID())/>
	<cfset extendSet.save()/>
	<cfset arrayAppend(getExtendSets(),extendSet)/>
	<cfreturn this>
</cffunction>

<cffunction name="deleteSet" access="public">
<cfargument name="ExtendSetID">
<cfset var extendSetBean=getExtendSetBean() />
			
			<cfset extendSetBean.setExtendSetID(ExtendSetID) />
			<cfset extendSetBean.delete() />
</cffunction>

<cffunction name="getSetsQuery" access="public" returntype="query">
<cfargument name="Inherit" required="true" default="false"/>
<cfargument name="doFilter" required="true" default="false"/>
<cfargument name="filter" required="true" default=""/>
<cfargument name="container" required="true" default=""/>
<cfargument name="activeOnly" required="true" default="false"/>
<cfset var rs=""/>
<cfset var rsFinal=""/>
<cfset var f=""/>
<cfset var rsDefault=""/>
<cfset var fLen=listLen(arguments.filter)/>

		<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select tclassextendsets.ExtendSetID,tclassextendsets.subTypeID,tclassextendsets.name,tclassextendsets.orderno,tclassextendsets.isActive,tclassextendsets.siteID,tclassextendsets.categoryID,tclassextendsets.orderno,0 as setlevel 
		from tclassextendsets
		inner join tclassextend on (tclassextendsets.subtypeid=tclassextend.subtypeID) 
		where tclassextendsets.subTypeID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getsubtypeID()#">
		and tclassextendsets.siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
		<cfif arguments.activeOnly>
			and tclassextend.isActive=1
		</cfif>
		<cfif arguments.doFilter and fLen>
		and (
		<cfloop from="1" to="#fLen#" index="f">
		tclassextendsets.categoryID like '%#listGetAt(arguments.filter,f)#%' <cfif f lt fLen>or</cfif> 
		</cfloop>
		)
		<cfelseif arguments.doFilter>
		and tclassextendsets.categoryID is null
		</cfif>
		
		<cfif len(arguments.container)>
		and tclassextendsets.container=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.container#">
		</cfif>
		
		<cfif arguments.inherit>
			<cfif getSubType() neq "Default">
				Union All

				select tclassextendsets.ExtendSetID,tclassextendsets.subTypeID,tclassextendsets.name,tclassextendsets.orderno,tclassextendsets.isActive,tclassextendsets.siteID,tclassextendsets.categoryID,tclassextendsets.orderno,1 as setlevel from tclassextendsets 
			    Inner Join tclassextend
			    On (tclassextendsets.subTypeID=tclassextend.subTypeID)
				where
				tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getType()#">
				and tclassextend.subType=<cfqueryparam cfsqltype="cf_sql_varchar"  value="Default">
				and tclassextend.siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
				<cfif arguments.doFilter and fLen>
				and (
				<cfloop from="1" to="#fLen#" index="f">
				tclassextendsets.categoryID like '%#listGetAt(arguments.filter,f)#%' <cfif f lt fLen>or</cfif> 
				</cfloop>
				)
				<cfelseif arguments.doFilter>
				and tclassextendsets.categoryID is null
				</cfif>
				<cfif len(arguments.container)>
				and tclassextendsets.container=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.container#">
				</cfif>
			</cfif>
			
			<cfif not listFindNoCase("1,2,User,Group,Address,Site,Component,Form",getType())>
				Union All

				select tclassextendsets.ExtendSetID,tclassextendsets.subTypeID,tclassextendsets.name,tclassextendsets.orderno,tclassextendsets.isActive,tclassextendsets.siteID,tclassextendsets.categoryID,tclassextendsets.orderno,2 as setlevel from tclassextendsets 
				Inner Join tclassextend
				On (tclassextendsets.subTypeID=tclassextend.subTypeID)
				where
				tclassextend.type='Base'
				and (
					tclassextend.subType=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSubType()#">
					<cfif getType() neq "Default">
						or tclassextend.subType='Default'
					</cfif>
				)
				and tclassextend.siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
				<cfif arguments.doFilter and fLen>
				and (
				<cfloop from="1" to="#fLen#" index="f">
				tclassextendsets.categoryID like '%#listGetAt(arguments.filter,f)#%' <cfif f lt fLen>or</cfif> 
				</cfloop>
					)
				<cfelseif arguments.doFilter>
				and tclassextendsets.categoryID is null
				</cfif>
				<cfif len(arguments.container)>
				and tclassextendsets.container=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.container#">
				</cfif>
			</cfif>
		</cfif>
		</cfquery>

		<cfquery name="rsFinal" dbtype="query">
		select * from rs order by setlevel desc, orderno
		</cfquery>
		
	<cfreturn rsFinal />
</cffunction>

<cffunction name="getTypeAsString" returntype="string">

<cfif isNumeric(getType())>
	<cfif arguments.type eq 1>
	<cfreturn "User Group">
	<cfelse>
	<cfreturn "User">
	</cfif>
<cfelse>
	<cfreturn getType() />
</cfif>
</cffunction>

<cffunction name="getContentRenderer" output="false">
	<cfif not isObject(variables.contentRenderer)>
		<cfif structKeyExists(request,"servletEvent")>
			<cfset variables.contentRenderer=request.servletEvent.getContentRenderer()>
		<cfelseif structKeyExists(request,"event")>
			<cfset variables.contentRenderer=request.event.getContentRenderer()>
		<cfelseif len(getSiteID())>
			<cfset variables.contentRenderer=getBean("$").init(getSiteID()).getContentRenderer()>
		<cfelse>
			<cfset variables.contentRenderer=getBean("contentRenderer")>
		</cfif>
	</cfif>

	<cfreturn variables.contentRenderer>
</cffunction>

</cfcomponent>