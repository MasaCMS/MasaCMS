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