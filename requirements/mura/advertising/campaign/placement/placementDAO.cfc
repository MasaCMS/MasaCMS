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
	<cfset variables.instance.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="placementBean" type="any" />
	
	<cfif arguments.placementBean.getIsExclusive()>
	<cfset clearExclusives(arguments.placementBean.getAdZoneID())>
	</cfif>
 
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	insert into tadplacements (placementID,campaignID,adZoneID,creativeID,dateCreated, 
	lastupdate,lastupdateBy ,startDate,endDate,
	costPerImp,costPerClick,isExclusive,budget, isActive, notes,billable,hasCategories)
	values (
	'#arguments.placementBean.getPlacementID()#',
	'#arguments.placementBean.getCampaignID()#',
	'#arguments.placementBean.getAdZoneID()#',
	'#arguments.placementBean.getCreativeID()#',
	<cfqueryparam cfsqltype="cf_sql_timestamp" null="#iif(isDate(arguments.placementBean.getDateCreated()),de('no'),de('yes'))#" value="#arguments.placementBean.getDateCreated()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" null="#iif(isDate(arguments.placementBean.getLastUpdate()),de('no'),de('yes'))#" value="#arguments.placementBean.getLastUpdate()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.placementBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.placementBean.getLastUpdateBy()#"> ,
	<cfif isDate(arguments.placementBean.getStartDate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.placementBean.getStartDate()#"><cfelse>null</cfif>,
	<cfif isDate(arguments.placementBean.getEndDate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.placementBean.getEndDate()#"><cfelse>null</cfif>,
	#arguments.placementBean.getCostPerImp()#,
	#arguments.placementBean.getCostPerClick()#,
	#arguments.placementBean.getIsExclusive()#,
	#arguments.placementBean.getBudget()#,
	#arguments.placementBean.getIsActive()#,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.placementBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.placementBean.getNotes()#"> ,
	0,
	#listLen(arguments.placementBean.getCategoryID())#
	)
	</cfquery>
	
	<cfset createPlacementDetails(arguments.placementBean)>
	<cfset createCategoryAssignments(arguments.placementBean)>

</cffunction>

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="placementID" type="string" />

	<cfset var placementBean=getBean("placement") />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getReadOnlyDatasource()#"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
	Select * from tadplacements where 
	placementID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.placementID#" />
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset placementBean.set(rs) />
	<cfset placementBean.setHour(readPlacementDetails(arguments.placementid,'hour')) />
	<cfset placementBean.setWeekday(readPlacementDetails(arguments.placementid,'weekday')) />
	<cfset placementBean.setCategoryID(readCategoryAssignments(arguments.placementid)) />
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
	lastUpdate = <cfif isDate(arguments.placementBean.getLastUpdate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.placementBean.getLastUpdate()#"><cfelse>null</cfif>,
	lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.placementBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.placementBean.getLastUpdateBy()#">,
	startDate = <cfif isDate(arguments.placementBean.getStartDate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.placementBean.getStartDate()#"><cfelse>null</cfif>,
	endDate = <cfif isDate(arguments.placementBean.getEndDate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.placementBean.getEndDate()#"><cfelse>null</cfif>,
	costPerImp = #arguments.placementBean.getCostPerImp()#,
	costPerClick = #arguments.placementBean.getCostPerClick()#,
	isExclusive = #arguments.placementBean.getIsExclusive()#,
	budget = #arguments.placementBean.getBudget()#,
	isActive = #arguments.placementBean.getIsActive()#,
	notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.placementBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.placementBean.getNotes()#">,
	billable=  #getBillable(arguments.placementBean.getPlacementID(),arguments.placementBean.getCostPerImp(),arguments.placementBean.getCostPerClick())#,
	hasCategories=#listLen(arguments.placementBean.getCategoryID())#
	where placementID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.placementBean.getPlacementID()#" />
	</cfquery>
	
	<cfset deletePlacementDetails(arguments.placementBean.getPlacementID())>
	<cfset createPlacementDetails(arguments.placementBean)>
	<cfset deleteCategoryAssignments(arguments.placementBean.getPlacementID())>
	<cfset createCategoryAssignments(arguments.placementBean)>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="placementID" type="String" />
	
	<cfset deletePlacementDetails(arguments.placementid)>
	<cfset deleteCategoryAssignments(arguments.placementid)>
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
	
	<cfquery name="rsBillableImps" datasource="#variables.instance.configBean.getReadOnlyDatasource()#"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
	select sum(counter) as total
	from tadstats
	where placementID='#arguments.placementID#'
	and Type='Impression'
	</cfquery>
	
	<cfif rsBillableImps.recordcount and rsBillableImps.total gt 0>
	<cfset billable=billable + (rsBillableImps.total * arguments.costPerImp) />
	</cfif>
	
	<cfquery name="rsBillableClicks" datasource="#variables.instance.configBean.getReadOnlyDatasource()#"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
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
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getReadOnlyDatasource()#"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
	select PlacementValue from tadplacementdetails
	where placementID = '#arguments.placementID#'
	and placementType='#arguments.placementType#'
	</cfquery>
	
	<cfreturn valuelist(rs.placementValue)/>

</cffunction>


<cffunction name="createCategoryAssignments" returntype="void" access="public" output="false">
	<cfargument name="placementBean"  />

	<cfset var I = ""/>

	 <cfloop list="#arguments.placementBean.getCategoryID()#" index="I">
		<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
		insert into tadplacementcategoryassign (placementID,categoryID)
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.placementBean.getPlacementID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#I#">
		)
		</cfquery>
	</cfloop>

</cffunction> 


<cffunction name="readCategoryAssignments" returntype="string" access="public" output="false">
	<cfargument name="placementID" type="string" required="yes" default="" />
	
	 <cfset var rs =""/>
	 <cfset var ItemList =""/>
	
	<cfquery name="rs" datasource="#variables.instance.configBean.getReadOnlyDatasource()#"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
		select categoryID from tadplacementcategoryassign
		where placementID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.placementID#">
	</cfquery>
	
	<cfset ItemList=valueList(rs.categoryID) />
	
	<cfreturn ItemList />
	
</cffunction> 

<cffunction name="deleteCategoryAssignments" access="public" output="false">
	<cfargument name="placementID" type="string" required="yes" default="" />
	
	 <cfset var rs =""/>
	 <cfset var ItemList =""/>
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
		delete from tadplacementcategoryassign
		where placementID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.placementID#">
	</cfquery>
	
	
</cffunction> 

</cfcomponent>