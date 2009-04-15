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

<cfset variables.instance.placementID=""/>
<cfset variables.instance.campaignID=""/>
<cfset variables.instance.adZoneID=""/>
<cfset variables.instance.creativeID=""/>
<cfset variables.instance.dateCreated="#now()#"/>
<cfset variables.instance.lastUpdate="#now()#"/>
<cfset variables.instance.lastUpdateBy=""/>
<cfset variables.instance.startDate=""/>
<cfset variables.instance.endDate=""/>
<cfset variables.instance.weekday="1,2,3,4,5,6,7" />
<cfset variables.instance.hour="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23" />
<cfset variables.instance.CostPerImp=0 />
<cfset variables.instance.CostPerM=0 />
<cfset variables.instance.CostPerClick=0 />
<cfset variables.instance.isExclusive=0 />
<cfset variables.instance.billable=0 />
<cfset variables.instance.budget=0 />
<cfset variables.instance.isActive=1 />
<cfset variables.instance.notes="" />
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="placement" type="any" required="true">

		<cfset var prop="" />
		
		<cfif isquery(arguments.placement)>
		
			<cfset setplacementID(arguments.placement.placementID) />
			<cfset setcampaignID(arguments.placement.campaignID) />
			<cfset setadZoneID(arguments.placement.adZoneID) />
			<cfset setcreativeID(arguments.placement.creativeID) />
			<cfset setdateCreated(arguments.placement.dateCreated) />
			<cfset setlastUpdate(arguments.placement.lastUpdate) />
			<cfset setlastUpdateBy(arguments.placement.lastUpdateBy) />
			<cfset setstartDate(arguments.placement.startDate) />
			<cfset setendDate(arguments.placement.endDate) />
			<cfset setcostPerImp(arguments.placement.costPerImp) />
			<cfset setCostPerM(arguments.placement.costPerImp*1000) />
			<cfset setcostPerClick(arguments.placement.costPerClick) />
			<cfset setisExclusive(arguments.placement.isExclusive) />
			<cfset setbillable(arguments.placement.billable) />
			<cfset setisActive(arguments.placement.isActive) />
			<cfset setnotes(arguments.placement.notes) />
			<cfset setbudget(arguments.placement.budget) />		
			
		<cfelseif isStruct(arguments.placement)>
		
			<cfloop collection="#arguments.placement#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.placement[prop])") />
				</cfif>
			</cfloop>
			
			<cfif isdefined("arguments.placement.costPerM") and arguments.placement.costPerM gt 0 >
				<cfset variables.instance.costPerImp= (arguments.placement.costPerM/1000) />
			<cfelse>
				<cfset variables.instance.costPerImp= 0 />
			</cfif>
			
			<cfif not isdefined("arguments.placement.hour")>
				<cfset variables.instance.hour= "" />
			</cfif>
			
			<cfif not isdefined("arguments.placement.weekday")>
				<cfset variables.instance.weekday= "" />
			</cfif>
			
			
			
		</cfif>
		
		<cfset validate() />
		
  </cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfreturn variables.instance />
</cffunction>
 
<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset variables.instance.errors=structnew() />
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
	<cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getPlacementID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.placementID />
</cffunction>

<cffunction name="setPlacementID" access="public" output="false">
	<cfargument name="placementID" type="String" />
	<cfset variables.instance.placementID = trim(arguments.placementID) />
</cffunction>

<cffunction name="getCampaignID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.campaignID />
</cffunction>

<cffunction name="setCampaignID" access="public" output="false">
	<cfargument name="campaignID" type="String" />
	<cfset variables.instance.campaignID = trim(arguments.campaignID) />
</cffunction>

<cffunction name="getCreativeID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.creativeID />
</cffunction>

<cffunction name="setCreativeID" access="public" output="false">
	<cfargument name="creativeID" type="String" />
	<cfset variables.instance.creativeID = trim(arguments.creativeID) />
</cffunction>

<cffunction name="getAdZoneID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.adZoneID />
</cffunction>

<cffunction name="setAdZoneID" access="public" output="false">
	<cfargument name="adZoneID" type="String" />
	<cfset variables.instance.adZoneID = trim(arguments.adZoneID) />
</cffunction>

<cffunction name="getDateCreated" returntype="String" access="public" output="false">
	<cfreturn variables.instance.dateCreated />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="dateCreated" type="String" />
	<cfif isDate(arguments.dateCreated)>
	<cfset variables.instance.dateCreated = parseDateTime(arguments.dateCreated) />
	<cfelse>
	<cfset variables.instance.dateCreated = ""/>
	</cfif>
</cffunction>

<cffunction name="getlastUpdate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdate />
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	<cfelse>
	<cfset variables.instance.lastUpdate = ""/>
	</cfif>
</cffunction>

<cffunction name="getlastUpdateBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdateBy />
</cffunction>

<cffunction name="setLastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
</cffunction>

<cffunction name="getStartDate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.startDate />
</cffunction>

<cffunction name="setStartDate" access="public" output="false">
	<cfargument name="startDate" type="String" />
	<cfif lsisDate(arguments.startDate)>
		<cftry>
		<cfset variables.instance.startDate = lsparseDateTime(arguments.startDate) />
		<cfcatch>
			<cfset variables.instance.startDate = arguments.startDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.startDate = ""/>
	</cfif>
</cffunction>

<cffunction name="getEndDate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.endDate />
</cffunction>

<cffunction name="setEndDate" access="public" output="false">
	<cfargument name="endDate" type="String" />
	<cfif lsisDate(arguments.endDate)>
		<cftry>
		<cfset variables.instance.endDate = lsparseDateTime(arguments.endDate) />
		<cfcatch>
			<cfset variables.instance.endDate = arguments.endDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.endDate = ""/>
	</cfif>
</cffunction>


<cffunction name="getWeekday" returntype="String" access="public" output="false">
	<cfreturn variables.instance.weekday />
</cffunction>

<cffunction name="setWeekday" access="public" output="false">
	<cfargument name="weekday" type="String" />
	<cfset variables.instance.weekday = arguments.weekday />
</cffunction>

<cffunction name="getHour" returntype="String" access="public" output="false">
	<cfreturn variables.instance.hour />
</cffunction>

<cffunction name="setHour" access="public" output="false">
	<cfargument name="hour" type="String" />
	<cfset variables.instance.hour = arguments.hour />
</cffunction>

<cffunction name="getCostPerImp" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.costPerImp />
</cffunction>

<cffunction name="setCostPerImp" access="public" output="false">
	<cfargument name="costPerImp" type="numeric" />
	<cfset variables.instance.costPerImp = arguments.costPerImp />
</cffunction>

<cffunction name="getcostPerM" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.costPerM />
</cffunction>

<cffunction name="setCostPerM" access="public" output="false">
	<cfargument name="costPerM" type="numeric" />
	<cfset variables.instance.costPerM = arguments.costPerM />
</cffunction>

<cffunction name="getCostPerClick" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.costPerClick />
</cffunction>

<cffunction name="setCostPerClick" access="public" output="false">
	<cfargument name="costPerClick" type="numeric" />
	<cfset variables.instance.costPerClick = arguments.costPerClick />
</cffunction>

<cffunction name="getIsExclusive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isExclusive />
</cffunction>

<cffunction name="setIsExclusive" access="public" output="false">
	<cfargument name="isExclusive" type="numeric" />
	<cfset variables.instance.isExclusive = arguments.isExclusive />
</cffunction>


<cffunction name="getBillable" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.billable />
</cffunction>

<cffunction name="setBillable" access="public" output="false">
	<cfargument name="Billable" type="numeric" />
	<cfset variables.instance.Billable = arguments.Billable />
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="isActive" type="numeric" />
	<cfset variables.instance.isActive = arguments.isActive />
</cffunction>

<cffunction name="getNotes" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Notes />
</cffunction>

<cffunction name="setNotes" access="public" output="false">
	<cfargument name="Notes" type="String" />
	<cfset variables.instance.Notes = trim(arguments.Notes) />
</cffunction>

<cffunction name="getBudget" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.budget />
</cffunction>

<cffunction name="setBudget" access="public" output="false">
	<cfargument name="budget" type="numeric" />
	<cfset variables.instance.budget = arguments.budget />
</cffunction>

</cfcomponent>