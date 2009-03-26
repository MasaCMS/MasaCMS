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

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","mura.mailinglist.mailinglistBean").init()>
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="listBean" type="any" />
 
<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
insert into tmailinglist (mlid,name,lastupdate,siteid,isPublic,description,ispurge)
values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getMLID()#">,<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.listBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getName()#">,
#createodbcdatetime(now())#,<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.listBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getsiteID()#">,#arguments.listBean.getisPublic()#,
<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.listBean.getDescription() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getDescription()#">,0)
</cfquery>

</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="MLID" type="string" />
	<cfargument name="siteID" type="string" />
	<cfset var listBean=getBean() />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Select * from tmailinglist where 
	mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MLID#">
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset listBean.set(rs) />
	</cfif>
	
	<cfreturn listBean />
</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="listBean" type="any" />
	

	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tmailinglist set name=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.listBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getName()#">,
	lastupdate=#createodbcdatetime(now())#, 
	isPublic=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.listBean.getIsPublic()#">,
	description=<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.listBean.getDescription() neq '',de('no'),de('yes'))#" value="#arguments.listBean.getDescription()#">
	where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getMLID()#"> and
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listBean.getSiteID()#">
	</cfquery>

   

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />
	
	<cftransaction>
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tmailinglist where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mlid#"> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
	</cfquery>
	
	<cfset deleteMembers(arguments.mlid,arguments.siteid)/>
	
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentobjects where objectid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mlid#"> and object='mailing_list' and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
	</cfquery>
	</cftransaction>

</cffunction>

<cffunction name="deleteMembers" access="public" output="false" returntype="void" >
	<cfargument name="mlid" type="string" />
	<cfargument name="siteid" type="string" />

	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tmailinglistmembers where mlid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mlid#"> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
	</cfquery>

</cffunction>
</cfcomponent>
