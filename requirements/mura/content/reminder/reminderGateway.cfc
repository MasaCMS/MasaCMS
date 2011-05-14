<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
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
and tcontenteventreminders.remindDate<=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(theTime,'mm/dd/yyyy')#">
and tcontenteventreminders.remindHour<=#hour(theTime)#
and tcontenteventreminders.remindMinute<=#minute(theTime)#
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