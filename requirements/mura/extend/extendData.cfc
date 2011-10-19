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

<cfset variables.instance.data="">
<cfset variables.instance.baseID="">
<cfset variables.instance.dataTable="tclassextenddata">
<cfset variables.instance.type="">
<cfset variables.instance.subType="">
<cfset variables.instance.siteID="">
<cfset variables.instance.definitionsQuery="">


<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	<cfargument name="baseID"/>
	<cfargument name="dataTable" required="true" default="tclassextenddata"/>
	<cfargument name="type"/>
	<cfargument name="subType"/>
	<cfargument name="siteID"/>
	
	<cfset variables.configBean=arguments.configBean />
	<cfset setBaseID(arguments.baseID)/>
	<cfset setDataTable(arguments.dataTable)/>
	<cfset setDefinitions(arguments.configBean.getClassExtensionManager().getDefinitionsQuery())>
	
	<cfif structKeyExists(arguments,"type")>
		<cfset setType(arguments.type)/>
	</cfif>
	<cfif structKeyExists(arguments,"subType")>
		<cfset setSubType(arguments.subType)/>
	</cfif>
	<cfif structKeyExists(arguments,"siteID")>
		<cfset setSiteID(arguments.siteID)/>
	</cfif>
	
	<cfset loadData()/>
	
	<cfreturn this />
</cffunction>

<cffunction name="getBaseID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.BaseID />
</cffunction>

<cffunction name="setBaseID" returntype="void" access="public" output="false">
	<cfargument name="BaseID" type="String" />
	<cfset variables.instance.BaseID = trim(arguments.BaseID) />
</cffunction>

<cffunction name="getDefinitionsQuery" access="public" output="false">
	<cfreturn variables.instance.definitions />
</cffunction>

<cffunction name="setDefinitions" returntype="void" access="public" output="false">
	<cfargument name="definitions" />
	<cfset variables.instance.definitions= arguments.definitions />
</cffunction>


<cffunction name="getDataTable" returntype="String" access="public" output="false">
	<cfreturn variables.instance.dataTable />
</cffunction>

<cffunction name="setDataTable" returntype="void" access="public" output="false">
	<cfargument name="dataTable" type="String" />
	<cfset variables.instance.dataTable = trim(arguments.dataTable) />
</cffunction>

<cffunction name="getType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.type />
</cffunction>

<cffunction name="setType" returntype="void" access="public" output="false">
	<cfargument name="type" type="String" />
	<cfset variables.instance.type = trim(arguments.type) />
</cffunction>

<cffunction name="getSubType" returntype="String" access="public" output="false">
	<cfreturn variables.instance.subType />
</cffunction>

<cffunction name="setSubType" returntype="void" access="public" output="false">
	<cfargument name="subType" type="String" />
	<cfset variables.instance.subType = trim(arguments.subType) />
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" returntype="void" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
</cffunction>

<cffunction name="getAttribute" access="public" returntype="any" output="false">
<cfargument name="key">
<cfargument name="useMuraDefault" type="boolean" required="true" default="false">
<cfset var rs="" />
<cfset var tempDate="">
	<cfquery name="rs" dbType="query">
		 select baseID,attributeValue,defaultValue,validation from variables.instance.data
		 where lower(name)=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#lcase(key)#">
		 <cfif isNumeric(arguments.key)>
			 or attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#key#">
		 </cfif>
	</cfquery>

	<cfif rs.recordcount>
		<cfif len(rs.baseID)>
			<cfif rs.validation eq "Date">
				<cfset tempDate=rs.attributeValue>
				<cftry>
					<cfreturn parseDateTime(tempDate) />	
					<cfcatch><cfreturn rs.attributeValue /></cfcatch>
				</cftry>	
			<cfelse>
				<cfreturn rs.attributeValue />
			</cfif>
		<cfelse>
			<cfreturn application.contentRenderer.setDynamicContent(rs.defaultValue) />
		</cfif>
	<cfelseif arguments.useMuraDefault>
		<cfreturn "useMuraDefault" />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="loadData" access="public" returntype="void" output="false">
<cfset var rs=""/>
<cfset var dataTable=getDataTable() />
<cfset var rsDefinitions=getDefinitionsQuery()>

		<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select #dataTable#.baseid, tclassextendattributes.name, tclassextendattributes.validation, 
		<cfif variables.configBean.getDBType() eq "oracle">
			to_char(tclassextendattributes.label) as label
		<cfelse>
			tclassextendattributes.label
		</cfif>, 
		tclassextendattributes.attributeID,tclassextendattributes.defaultValue,tclassextendattributes.extendSetID,
		
		#dataTable#.attributeValue
		
		from #dataTable# inner join
		tclassextendattributes On (#dataTable#.attributeID=tclassextendattributes.attributeID)
		where #dataTable#.baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getBaseID()#">
		
		<cfif variables.configBean.getDBType() eq "oracle" and len(getType()) and len(getSubType()) and len(getSiteID())>
			Union All
			
			select 
			#dataTable#.baseID, tclassextendattributes.name, tclassextendattributes.validation,
			<cfif variables.configBean.getDBType() eq "oracle">
				to_char(tclassextendattributes.label) as label
			<cfelse>
				tclassextendattributes.label
			</cfif>,
			tclassextendattributes.attributeID,tclassextendattributes.defaultValue,tclassextendattributes.extendSetID,
			
			#dataTable#.attributeValue
			 
			from tclassextend 
			inner join tclassextendsets On (tclassextend.subtypeid=tclassextendsets.subtypeid)
			inner join tclassextendattributes On (tclassextendsets.extendsetid=tclassextendattributes.extendsetid)
			left join #dataTable# on (
												(
													tclassextendattributes.attributeID=#dataTable#.attributeID
													and  #dataTable#.baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getBaseID()#">
												)
											)
			where tclassextend.siteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
			and tclassextend.type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getType()#">
			and (
				<cfif getSubType() neq "Default">
				tclassextend.subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSubType()#">
				or
				</cfif>
				tclassextend.subtype='Default'
				)
				
			and #dataTable#.baseID is null
			
		</cfif>
		</cfquery>
		
		<cfif variables.configBean.getDBType() neq "oracle" and len(getType()) and len(getSubType()) and len(getSiteID())>
		
			<cfquery name="rs" dbtype="query">
				select baseID, name, validation, label, attributeID, defaultValue, extendSetID, attributeValue
				from rs
				
				union all
				
				select '' baseID, attributename, validation, label, attributeID, defaultValue, extendSetID, '' attributeValue
				from rsDefinitions
				where siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSiteID()#">
				and type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getType()#">
	          	and (
	                 <cfif getSubType() neq "Default">
	                  subtype=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getSubType()#">
	                 
					  or
	                  </cfif>
	                 subtype='Default'
	                  )
				<cfif rs.recordcount>
				and attributeID not in (#valuelist(rs.attributeid)#)
				</cfif>
			
			</cfquery>
		</cfif>
		
		<cfset variables.instance.data=rs />
		
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
</cffunction>

<cffunction name="getAllExtendSetData" access="public" returntype="struct" output="false">
	<cfset var extData=structNew() />	
	<cfreturn convertDataToStruct(variables.instance.data)/>
	<cfreturn extData/>	
</cffunction>

<cffunction name="getExtendSetDataByAttributeName" access="public" returntype="struct" output="false">
	<cfargument name="key">
	
	<cfset var rs="" />
	<cfset var extData=structNew() />
	
	<cfquery name="rs" dbType="query">
		 select baseID, extendSetID, name, defaultValue, attributeValue, validation from variables.instance.data
		 where lower(name)=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#lcase(key)#">
		 <cfif isNumeric(arguments.key)>
			 or attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#key#">
		 </cfif>
	</cfquery>
		
	<cfreturn convertDataToStruct(rs)/>
	
</cffunction>

<cffunction name="convertDataToStruct" output="false" returntype="any">
<cfargument name="rs">

	<cfset var extData=structNew() />
	<cfset var tempDate="" />
	<cfif rs.recordcount>
		<cfset extData.extendSetID=valueList(rs.extendSetID)>
		<cfset extData.data=structNew()>
		
		<cfloop query="rs">
			<cfif len(rs.baseID)>
				<cfif rs.validation eq "Date">
					<cfset tempDate=rs.attributeValue>
					<cftry>
						<cfset extData.data['#rs.name#']=parseDateTime(tempDate)>
						<cfcatch><cfset extData.data['#rs.name#']=tempDate></cfcatch>
					</cftry>
				<cfelse>
					<cfset extData.data['#rs.name#']=rs.attributeValue>
				</cfif>
			<cfelse>
				<cfset extData.data['#rs.name#']=application.contentRenderer.setDynamicContent(rs.defaultValue)>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn extData>
</cffunction>

</cfcomponent>