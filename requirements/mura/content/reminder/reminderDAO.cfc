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

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="reminderBean" type="any" />
 
 <cfquery>
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
 <cfset var reminderBean=getBean("reminderBean") />
 
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
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
 
 <cfquery>
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