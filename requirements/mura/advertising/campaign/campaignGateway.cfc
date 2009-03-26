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

<cfcomponent output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

<cffunction name="getCampaignsByUser" access="public" output="false" returntype="query">
	<cfargument name="userID" type="String">
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select tadcampaigns.* 
	from tadcampaigns
	where tadcampaigns.userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" /> order by tadcampaigns.name
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getCampaignsBySiteID" access="public" output="false" returntype="query">
	<cfargument name="siteid" type="String">
	<cfargument name="keywords"  type="string" required="true" default=""/>
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select tadcampaigns.* , tusers.company
	from tadcampaigns inner join tusers on tadcampaigns.userid=tusers.userid
	where tusers.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	<cfif arguments.keywords neq ''>and tadcampaigns.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%" /></cfif>
	order by tadcampaigns.name
	</cfquery>
	
	<cfreturn rs />
</cffunction>

</cfcomponent>