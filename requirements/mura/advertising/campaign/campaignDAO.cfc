<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See thefdbTyt
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
	<cfargument name="campaignBean" type="any" />
 
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	insert into tadcampaigns (campaignID,userid,dateCreated, lastupdate,lastupdateBy,name,startDate,endDate,isactive,notes)
	values (
	'#arguments.campaignBean.getcampaignID()#',
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.campaignBean.getUserID() neq '',de('no'),de('yes'))#" value="#arguments.campaignBean.getUserID()#">,
	<cfif isDate(arguments.campaignBean.getDateCreated()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.campaignBean.getDateCreated()#"><cfelse>null</cfif>,
	<cfif isDate(arguments.campaignBean.getLastUpdate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.campaignBean.getLastUpdate()#"><cfelse>null</cfif>,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.campaignBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.campaignBean.getLastUpdateBy()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.campaignBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.campaignBean.getName()#">,
	<cfif isDate(arguments.campaignBean.getStartDate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.campaignBean.getStartDate()#"><cfelse>null</cfif>,
	<cfif isDate(arguments.campaignBean.getEndDate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.campaignBean.getEndDate()#"><cfelse>null</cfif>,
	#arguments.campaignBean.getIsActive()#,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.campaignBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.campaignBean.getNotes()#">
	)
	</cfquery>

</cffunction>

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="campaignID" type="string" />

	<cfset var campaignBean=getBean("campaign") />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#application.configBean.getReadOnlyDatasource()#"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
	Select * from tadcampaigns where 
	campaignID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignID#" />
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset campaignBean.set(rs) />
	</cfif>
	
	<cfreturn campaignBean />
</cffunction> 

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="campaignBean" type="any" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	update tadcampaigns set
	lastUpdate = <cfif isDate(arguments.campaignBean.getLastUpdate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.campaignBean.getLastUpdate()#"><cfelse>null</cfif>,
	lastupdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.campaignBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.campaignBean.getLastUpdateBy()#">,
	name = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.campaignBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.campaignBean.getName()#">,
	startDate = <cfif isDate(arguments.campaignBean.getStartDate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.campaignBean.getStartDate()#"><cfelse>null</cfif>,
	endDate = <cfif isDate(arguments.campaignBean.getEndDate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.campaignBean.getEndDate()#"><cfelse>null</cfif>,
	isActive = #arguments.campaignBean.getIsActive()#,
	notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.campaignBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.campaignBean.getNotes()#">
	where campaignID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignBean.getCampaignID()#" />
	</cfquery>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="campaignID" type="String" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadcampaigns
	where campaignID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignID#" />
	</cfquery>

</cffunction>

</cfcomponent>