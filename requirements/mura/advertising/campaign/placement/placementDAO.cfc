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

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","#variables.instance.configBean.getMapDir()#.advertising.campaign.placement.placementBean").init()>
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="placementBean" type="any" />
	
	<cfif arguments.placementBean.getIsExclusive()>
	<cfset clearExclusives(arguments.placementBean.getAdZoneID())>
	</cfif>
 
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	insert into tadplacements (placementID,campaignID,adZoneID,creativeID,dateCreated, 
	lastupdate,lastupdateBy ,startDate,endDate,
	costPerImp,costPerClick,isExclusive,budget, isActive, notes,billable)
	values (
	'#arguments.placementBean.getPlacementID()#',
	'#arguments.placementBean.getCampaignID()#',
	'#arguments.placementBean.getAdZoneID()#',
	'#arguments.placementBean.getCreativeID()#',
	<cfif isDate(arguments.placementBean.getDateCreated()) >#createODBCDateTime(arguments.placementBean.getDateCreated())#<cfelse>null</cfif>,
	<cfif isDate(arguments.placementBean.getLastUpdate()) >#createODBCDateTime(arguments.placementBean.getLastUpdate())#<cfelse>null</cfif>,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.placementBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.placementBean.getLastUpdateBy()#"> ,
	<cfif isDate(arguments.placementBean.getStartDate()) >#createODBCDateTime(LSDateFormat(arguments.placementBean.getStartDate(),'mm/dd/yyyy'))#<cfelse>null</cfif>,
	<cfif isDate(arguments.placementBean.getEndDate()) >#createODBCDateTime(LSDateFormat(arguments.placementBean.getEndDate(),'mm/dd/yyyy'))#<cfelse>null</cfif>,
	#arguments.placementBean.getCostPerImp()#,
	#arguments.placementBean.getCostPerClick()#,
	#arguments.placementBean.getIsExclusive()#,
	#arguments.placementBean.getBudget()#,
	#arguments.placementBean.getIsActive()#,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.placementBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.placementBean.getNotes()#"> ,
	0)
	</cfquery>
	
	<cfset createPlacementDetails(arguments.placementBean)>

</cffunction>

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="placementID" type="string" />

	<cfset var placementBean=getBean() />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	Select * from tadplacements where 
	placementID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.placementID#" />
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset placementBean.set(rs) />
	<cfset placementBean.setHour(readPlacementDetails(arguments.placementid,'hour')) />
	<cfset placementBean.setWeekday(readPlacementDetails(arguments.placementid,'weekday')) />
	</cfif>
	
	<cfreturn placementBean />
</cffunction> 

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="placementBean" type="any" />
	
	<cfif arguments.placementBean.getIsExclusive()>
	<cfset clearExclusives(arguments.placementBean.getAdZoneID())>
	</cfif>
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	update tadplacements set
	campaignID = '#arguments.placementBean.getCampaignID()#',
	adZoneID = '#arguments.placementBean.getAdZoneID()#',
	creativeID = '#arguments.placementBean.getCreativeID()#',
	lastUpdate = <cfif isDate(arguments.placementBean.getLastUpdate()) >#createODBCDateTime(arguments.placementBean.getLastUpdate())#<cfelse>null</cfif>,
	lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.placementBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.placementBean.getLastUpdateBy()#">,
	startDate = <cfif isDate(arguments.placementBean.getStartDate()) >#createODBCDateTime(LSDateFormat(arguments.placementBean.getStartDate(),'mm/dd/yyyy'))#<cfelse>null</cfif>,
	endDate = <cfif isDate(arguments.placementBean.getEndDate()) >#createODBCDateTime(LSDateFormat(arguments.placementBean.getEndDate(),'mm/dd/yyyy'))#<cfelse>null</cfif>,
	costPerImp = #arguments.placementBean.getCostPerImp()#,
	costPerClick = #arguments.placementBean.getCostPerClick()#,
	isExclusive = #arguments.placementBean.getIsExclusive()#,
	budget = #arguments.placementBean.getBudget()#,
	isActive = #arguments.placementBean.getIsActive()#,
	notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.placementBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.placementBean.getNotes()#">,
	billable=  #getBillable(arguments.placementBean.getPlacementID(),arguments.placementBean.getCostPerImp(),arguments.placementBean.getCostPerClick())#
	where placementID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.placementBean.getPlacementID()#" />
	</cfquery>
	
	<cfset deletePlacementDetails(arguments.placementBean.getPlacementID())>
	<cfset createPlacementDetails(arguments.placementBean)>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="placementID" type="String" />
	
	<cfset deletePlacementDetails(arguments.placementid)>
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadplacements
	where placementID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.placementID#" />
	</cfquery>

</cffunction>

<cffunction name="deleteByCampaign" access="public" output="false" returntype="void" >
	<cfargument name="campaignID" type="String" />
	
	<cfquery datasource="#application.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadplacements
	where campaignID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignID#" />
	</cfquery>

</cffunction>

<cffunction name="deletePlacementDetails" access="public" output="false" returntype="void" >
	<cfargument name="placementID" type="string" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	delete from tadplacementdetails
	where placementID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.placementID#" />
	</cfquery>

</cffunction>

<cffunction name="clearExclusives" access="public" output="false" returntype="void" >
	<cfargument name="adZoneID" type="string" />
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	update tadplacements set isExclusive=0
	where adzoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adzoneID#" />
	</cfquery>

</cffunction>


<cffunction name="getBillable" access="public" output="false" returntype="numeric" >
	<cfargument name="placementID" type="string" />
	<cfargument name="costPerImp" type="numeric" />
	<cfargument name="costPerClick" type="numeric" />
	<cfset var rsBillableImps=""/>
	<cfset var rsBillableClicks=""/>
	<cfset var billable=0/>
	
	<cfquery name="rsBillableImps" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select sum(counter) as total
	from tadstats
	where placementID='#arguments.placementID#'
	and Type='Impression'
	</cfquery>
	
	<cfif rsBillableImps.recordcount and rsBillableImps.total gt 0>
	<cfset billable=billable + (rsBillableImps.total * arguments.costPerImp) />
	</cfif>
	
	<cfquery name="rsBillableClicks" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select sum(counter) as Total
	from tadstats
	where placementID='#arguments.placementID#'
	and Type='Click'
	</cfquery>
	
	<cfif rsBillableClicks.recordcount and rsBillableClicks.total gt 0>
	<cfset billable=billable + (rsBillableClicks.total * arguments.costPerClick) />
	</cfif>
	
	<cfreturn billable />

</cffunction>

<cffunction name="createPlacementDetails" access="public" output="false" returntype="void" >
	<cfargument name="placementBean" type="any" />
	
	<cfset var h=0 />
	<cfset var wd=0 />
	<cfloop list="#arguments.placementBean.gethour()#" index="h">
		<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
		insert into tadplacementdetails (placementid,placementType,placementValue)
		values(
		 '#arguments.placementBean.getPlacementID()#',
		 'hour',
		 #h#
		 )
		</cfquery>
	</cfloop>
	
	<cfloop list="#arguments.placementBean.getWeekday()#" index="wd">
		<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
		insert into tadplacementdetails (placementid,placementType,placementValue)
		values(
		 '#arguments.placementBean.getPlacementID()#',
		 'weekday',
		 #wd#
		 )
		</cfquery>
	</cfloop>

</cffunction>

<cffunction name="readPlacementDetails" access="public" output="false" returntype="string" >
	<cfargument name="placementID" type="string" />
	<cfargument name="placementType" type="string" />
	
	<cfset var rs=""/>
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select PlacementValue from tadplacementdetails
	where placementID = '#arguments.placementID#'
	and placementType='#arguments.placementType#'
	</cfquery>
	
	<cfreturn valuelist(rs.placementValue)/>

</cffunction>

</cfcomponent>