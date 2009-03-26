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

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.dsn=variables.configBean.getDatasource()/>
		<cfreturn this />
</cffunction>

<cffunction name="getListMembers" access="public" output="false" returntype="query">
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	<cfset var rs = ""/>
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rs">
	select * from tmailinglistmembers where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mlid#" /> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" /> order by email
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getList" access="public" output="false" returntype="query">
	<cfargument name="siteid" type="string" />
	<cfset var rs = ""/>
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rs">
	select tmailinglist.siteid, tmailinglist.name, tmailinglist.lastupdate, tmailinglist.mlid, tmailinglist.ispurge, tmailinglist.isPublic, count(tmailinglistmembers.mlid) as "Members" from tmailinglist LEFT JOIN tmailinglistmembers ON(tmailinglist.mlid=tmailinglistmembers.mlid and tmailinglist.siteid=tmailinglistmembers.siteid)
	WHERE tmailinglist.siteid =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> 
	GROUP By tmailinglist.siteid, tmailinglist.name, tmailinglist.mlid, tmailinglist.ispurge, tmailinglist.lastupdate,tmailinglist.isPublic
	ORDER BY tmailinglist.ispurge desc, tmailinglist.name
	</cfquery>
	
	<cfreturn rs />
</cffunction>


</cfcomponent>