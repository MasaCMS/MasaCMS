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

<cfsilent><cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsTemplate">
select contentid, menutitle, title, body, doCache
from tcontent 
where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"> and 
				    (
					(tcontent.Active = 1
					  
					  AND tcontent.DisplayStart <= #createodbcdatetime(now())#
					  AND (tcontent.DisplayStop >= #createodbcdatetime(now())# or tcontent.DisplayStop is null)
					  AND tcontent.Display = 2
					  AND tcontent.Approved = 1
					  AND tcontent.contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#">
					  AND tcontent.moduleAssign like '%00000000000000000000000000000000000%')
					  or
					  
                      (tcontent.Active = 1
					  
					  AND tcontent.Display = 1
					  AND tcontent.Approved = 1
					  AND tcontent.contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#">
					  AND tcontent.moduleAssign like '%00000000000000000000000000000000000%')
					  
					 ) 
</cfquery>
<cfset request.cacheItem=rsTemplate.doCache/>
</cfsilent>
<cfif rsTemplate.recordcount>
<cfoutput>#setDynamicContent(rsTemplate.body)#</cfoutput>
</cfif>