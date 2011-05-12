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

<cffunction name="getPlacementsByCampaign" access="public" output="false" returntype="query">
	<cfargument name="campaignID" type="String">
	<cfargument name="date1" type="string" required="true" default="" />
	<cfargument name="date2" type="string" required="true" default="" />
	
	<cfset var rs ="" />
	<cfset var start ="" />
	<cfset var stop ="" />
		
	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select tadplacements.startdate,tadplacements.enddate,tadplacements.costPerImp,
	tadplacements.costPerClick,tadplacements.isExclusive,tadplacements.isActive,
	tadplacements.placementid,tadplacements.creativeid,tadplacements.adZoneID, tadplacements.budget,
	tadzones.name as AdZone, tadcreatives.name as Creative
	from tadplacements
	Inner Join tadzones on (tadplacements.adZoneID=tadzones.AdZoneID)
	Inner Join tadcreatives on (tadplacements.creativeID=tadcreatives.creativeID)
	where campaignID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignID#" />
	<cfif lsisdate(arguments.date1)>
		<cfset start=lsParseDateTime(arguments.date1)>
		and tadplacements.startdate >= #createodbcdatetime(createdatetime(year(start),month(start),day(start),0,0,0))#</cfif>
	<cfif isdate(arguments.date2)>
		<cfset stop=lsParseDateTime(arguments.date2)>
		and tadplacements.endDate <= #createodbcdatetime(createdatetime(year(stop),month(stop),day(stop),23,59,9))#</cfif> 
	GROUP BY tadplacements.startdate,tadplacements.enddate,tadplacements.costPerImp,
	tadplacements.costPerClick,tadplacements.budget,tadplacements.isExclusive,tadplacements.isActive,tadplacements.placementid,tadplacements.creativeid,tadplacements.adZoneID, 
	tadzones.name, tadcreatives.name
	order by tadzones.name
	</cfquery>
	
	<cfreturn rs />
</cffunction>

</cfcomponent>