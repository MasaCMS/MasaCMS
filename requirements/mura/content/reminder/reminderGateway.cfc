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

<cffunction name="getReminders" returntype="query" output="false" access="public">
<cfargument name="theTime" default="#now()#" required="yes">
<cfset var rs=""/>

<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
select tsettings.site,tsettings.contact,tsettings.mailserverIP,tsettings.mailserverUsername,
tsettings.domain ,tsettings.contactName,
tsettings.contactAddress,tsettings.contactCity,tsettings.contactState,tsettings.contactZip,
tsettings.contactEmail,tsettings.contactPhone,tsettings.mailserverPassword,
tcontenteventreminders.email,tcontenteventreminders.remindDate,tcontenteventreminders.remindHour,
tcontenteventreminders.remindMinute,tcontenteventreminders.remindInterval,tcontenteventreminders.contentID,tcontenteventreminders.isSent,
tcontent.siteid,tcontent.title,tcontent.filename,tcontent.summary,tcontent.type,tcontent.parentid,
tcontent.displaystart,tcontent.displaystop 
from tcontenteventreminders inner join tcontent 
On (tcontenteventreminders.contentid=tcontent.contentid and tcontenteventreminders.siteid=tcontent.siteid)
inner join tsettings on (tcontent.siteid=tsettings.siteid)
where
tcontent.display=2
and tcontent.active=1
and tcontenteventreminders.remindDate= #createodbcdate(LSDateFormat(theTime,'mm/dd/yyyy'))#
and tcontenteventreminders.remindHour=#hour(theTime)#
and tcontenteventreminders.remindMinute=#minute(theTime)#
and isSent=0
</cfquery>


<cfreturn rs />
</cffunction>

<cffunction name="getRemindersByContentID" returntype="query" output="false" access="public">
<cfargument name="contentid" type="string"/>
<cfargument name="siteid" type="string"/>
<cfset var rs=""/>

<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
select * from tcontenteventreminders where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
</cfquery>

<cfreturn rs />
</cffunction>




</cfcomponent>