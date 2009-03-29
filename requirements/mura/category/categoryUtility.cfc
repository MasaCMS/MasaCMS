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

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="categoryGateway" type="any" required="yes"/>
	
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.categoryGateway=arguments.categoryGateway />
		<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfreturn this />
</cffunction>

<cffunction name="updateGlobalMaterializedPath" returntype="any" output="false">
<cfargument name="siteID">
<cfargument name="parentID" required="true" default="">
<cfargument name="path" required="true" default=""/>

<cfset var rs="" />
<cfset var newPath = "" />

<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select categoryID from tcontentcategories 
where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
<cfif arguments.parentID neq ''>
and parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#" />
<cfelse>
and parentID is null
</cfif>
</cfquery>

	<cfloop query="rs">
		<cfset newPath=#listappend(arguments.path,"#rs.categoryID#")# />
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentcategories
		set path=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newPath#" />
		where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.categoryID#" />
		</cfquery>
		<cfset updateGlobalMaterializedPath(arguments.siteID,rs.categoryID,newPath) />
	</cfloop>

</cffunction>

</cfcomponent>