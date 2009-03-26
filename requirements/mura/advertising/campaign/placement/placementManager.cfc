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
<cfargument name="placementGateway" type="any" required="yes"/>
<cfargument name="placementDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.gateway=arguments.placementGateway />
	<cfset variables.instance.DAO=arguments.placementDAO />
	<cfset variables.instance.globalUtility=arguments.utility />
	
	<cfreturn this />
</cffunction>

<cffunction name="getPlacementsByCampaign" access="public" output="false" returntype="query">
	<cfargument name="campaignID" type="String">
	<cfargument name="date1" type="string" required="true" default="" />
	<cfargument name="date2" type="string" required="true" default="" />
	
	<cfreturn variables.instance.gateway.getPlacementsByCampaign(arguments.campaignID,arguments.date1,arguments.date2) />
</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var placementBean=application.serviceFactory.getBean("placementBean") />
	<cfset placementBean.set(arguments.data) />
	
	<cfif structIsEmpty(placementBean.getErrors())>
		<cfset placementBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset placementBean.setPlacementID("#createUUID()#") />
		<cfset variables.instance.globalUtility.logEvent("PlacementID:#placementBean.getPlacementID()# CampaignID:#placementBean.getCampaignID()# was created","sava-advertising","Information",true) />
		<cfset variables.instance.DAO.create(placementBean) />
	</cfif>
	
	<cfreturn placementBean />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="placementID" type="String" />		
	
	<cfreturn variables.instance.DAO.read(arguments.placementID) />

</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var placementBean=variables.instance.DAO.read(arguments.data.placementID) />
	<cfset placementBean.set(arguments.data) />
	
	<cfif structIsEmpty(placementBean.getErrors())>
		<cfset variables.instance.globalUtility.logEvent("PlacementID:#placementBean.getPlacementID()# Name:#placementBean.getCampaignID()# was updated","sava-advertising","Information",true) />
		<cfset placementBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset variables.instance.DAO.update(placementBean) />
	</cfif>
	
	<cfreturn placementBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="placementID" type="String" />		
	
	<cfset var placementBean=read(arguments.placementID) />
	<cfset variables.instance.globalUtility.logEvent("PlacementID:#arguments.placementID# CampaignID:#placementBean.getCampaignID()# was deleted","sava-advertising","Information",true) />
	<cfset variables.instance.DAO.delete(arguments.placementID) />

</cffunction>

<cffunction name="deleteByCampaign" access="public" returntype="void" output="false">
	<cfargument name="campaignID" type="String" />		
	
	<cfset variables.instance.globalUtility.logEvent("All Placements for CampaignID:#arguments.campaignID# were deleted","sava-advertising","Information",true) />
	<cfset variables.instance.DAO.deleteByCampaign(arguments.campaignID) />

</cffunction>

</cfcomponent>