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
	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.settingsManager=arguments.settingsManager />
	<cfreturn this />
</cffunction>

<cffunction name="getadzonesBySiteID" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="keywords"  type="string" required="true" default=""/>
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select * from tadzones where siteid='#variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID()#'
	<cfif arguments.keywords neq ''>and tadzones.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%" /></cfif> 
	order by name
	</cfquery>
	
	<cfreturn rs />
</cffunction>

</cfcomponent>