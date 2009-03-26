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
		<cfset variables.instance.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="reminderBean" type="any" />
 
 <cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
insert into tcontenteventreminders (contentid,email,siteid,reminddate,remindHour,remindMinute,isSent,remindInterval)
values (
<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.reminderBean.getcontentID() neq '',de('no'),de('yes'))#" value="#arguments.reminderBean.getcontentID()#">,
<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.reminderBean.getEmail() neq '',de('no'),de('yes'))#" value="#arguments.reminderBean.getEmail()#">,
<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.reminderBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.reminderBean.getSiteID()#">,
<cfqueryparam cfsqltype="cf_sql_timestamp" null="#iif(isdate(arguments.reminderBean.getRemindDate()) ,de('no'),de('yes'))#" value="#createodbcdatetime(dateFormat(arguments.reminderBean.getRemindDate(),'mm/dd/yyyy'))#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reminderBean.getRemindHour()#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reminderBean.getRemindMinute()#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reminderBean.getIsSent()#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reminderBean.getRemindInterval()#">
)
</cfquery>

</cffunction> 

<cffunction name="read" returntype="any" access="public" output="false">
 <cfargument name="contentid" type="string">
 <cfargument name="siteid" type="string">
 <cfargument name="email" type="string">
 
 <cfset var rs=""/>
 <cfset var reminderBean=application.serviceFactory.getBean("reminderBean") />
 
	<cfquery datasource="#variables.instance.configBean.getDatasource()#" name="rs"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select * from tcontenteventreminders 
	where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and email= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#"/>
	</cfquery>

	<cfif rs.recordcount>
		<cfset reminderBean.set(rs) />
		<cfset reminderBean.setIsNew(0) />
	<cfelse>
		<cfset reminderBean.setcontentId(arguments.contentid) />
		<cfset reminderBean.setSiteId(arguments.siteid) />
		<cfset reminderBean.setEmail(arguments.email) />
	</cfif>
	
	<cfreturn reminderBean />

</cffunction> 

<cffunction name="update" returntype="void" access="public" output="false">
<cfargument name="reminderBean" type="any" />
 
 <cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
update tcontenteventreminders set
remindDate=<cfqueryparam cfsqltype="cf_sql_timestamp" null="#iif(isdate(arguments.reminderBean.getRemindDate()) ,de('no'),de('yes'))#" value="#createodbcdatetime(dateFormat(arguments.reminderBean.getRemindDate(),'mm/dd/yyyy'))#">,
remindHour=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reminderBean.getRemindHour()#">,
remindMinute=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reminderBean.getRemindMinute()#">,
remindInterval=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reminderBean.getRemindInterval()#">
where 
contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reminderBean.getcontentID()#"/>
and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reminderBean.getSiteID()#"/>
and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reminderBean.getEmail()#"/>
</cfquery>

</cffunction> 

</cfcomponent>