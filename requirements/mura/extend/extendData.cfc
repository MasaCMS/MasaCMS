<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.data="">
<cfset variables.instance.baseID="">
<cfset variables.instance.dataTable="tclassextenddata">


<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	<cfargument name="baseID"/>
	<cfargument name="dataTable" required="true" default="tclassextenddata"/>

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfset setBaseID(arguments.baseID)/>
	<cfset setDataTable(arguments.dataTable)/>
	<cfset loadData() />
	
	<cfreturn this />
</cffunction>

<cffunction name="getBaseID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.BaseID />
</cffunction>

<cffunction name="setBaseID" returntype="void" access="public" output="false">
	<cfargument name="BaseID" type="String" />
	<cfset variables.instance.BaseID = trim(arguments.BaseID) />
</cffunction>

<cffunction name="getDataTable" returntype="String" access="public" output="false">
	<cfreturn variables.instance.dataTable />
</cffunction>

<cffunction name="setDataTable" returntype="void" access="public" output="false">
	<cfargument name="dataTable" type="String" />
	<cfset variables.instance.dataTable = trim(arguments.dataTable) />
</cffunction>

<cffunction name="getAttribute" access="public" returntype="any">
<cfargument name="key">
<cfargument name="useMuraDefault" type="boolean" required="true" default="false"> 
<cfset var rs="" />

	<cfquery name="rs" dbType="query">
		 select attributeValue from variables.instance.data
		 where name=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#key#">
		 <cfif isNumeric(arguments.key)>
			 or attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#key#">
		 </cfif>
	</cfquery>

	<cfif rs.recordcount>
		<cfreturn rs.attributeValue />
	<cfelseif arguments.useMuraDefault>
		<cfreturn "useMuraDefault" />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="loadData" access="public" returntype="void">
<cfset var rs=""/>
<cfset var dataTable=getDataTable() />

		<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select tclassextendattributes.name,tclassextendattributes.attributeID,tclassextendattributes.defaultValue,#dataTable#.attributeValue from #dataTable# inner join
		tclassextendattributes On (#dataTable#.attributeID=tclassextendattributes.attributeID)
		where #dataTable#.baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getBaseID()#">
		</cfquery>
		
		<!--- <cfdump var="#rs#"><cfdump var="#getBaseID()#">		<cfabort> --->
		<cfset variables.instance.data=rs />
		
</cffunction>


</cfcomponent>