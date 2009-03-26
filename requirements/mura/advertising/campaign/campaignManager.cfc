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

<cfcomponent output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="campaignGateway" type="any" required="yes"/>
<cfargument name="campaignDAO" type="any" required="yes"/>
<cfargument name="placementManager" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>

	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.gateway=arguments.campaignGateway />
	<cfset variables.instance.DAO=arguments.campaignDAO />
	<cfset variables.instance.placementManager=arguments.placementManager />
	<cfset variables.instance.globalUtility=arguments.utility />
	
	<cfreturn this />
</cffunction>

<cffunction name="getCampaignsByUser" returntype="query" access="public" output="false">
	<cfargument name="userid"  type="string" />

	<cfreturn variables.instance.gateway.getCampaignsByUser(arguments.userid) />
</cffunction>

<cffunction name="getCampaignsBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteid"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>

	<cfreturn variables.instance.gateway.getCampaignsBySiteID(arguments.siteid,arguments.keywords) />
</cffunction>

<cffunction name="getPlacementsByCampaign" returntype="query" access="public" output="false">
	<cfargument name="campaignID"  type="string" />

	<cfreturn variables.instance.placementManager.getPlacementsByCampaign(arguments.campaignID) />
</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var campaignBean=application.serviceFactory.getBean("campaignBean") />
	<cfset campaignBean.set(arguments.data) />
	
	<cfif structIsEmpty(campaignBean.getErrors())>
		<cfset campaignBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset campaignBean.setCampaignID("#createUUID()#") />
		<cfset variables.instance.globalUtility.logEvent("CampaignID:#campaignBean.getCampaignID()# Name:#campaignBean.getName()# was created","mura-advertising","Information",true) />
		<cfset variables.instance.DAO.create(campaignBean) />
	</cfif>
	
	<cfreturn campaignBean />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="campaignID" type="String" />		
	
	<cfreturn variables.instance.DAO.read(arguments.campaignID) />

</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var campaignBean=variables.instance.DAO.read(arguments.data.campaignID) />
	<cfset campaignBean.set(arguments.data) />
	
	<cfif structIsEmpty(campaignBean.getErrors())>
		<cfset variables.instance.globalUtility.logEvent("CampaignID:#campaignBean.getCampaignID()# Name:#campaignBean.getName()# was updated","mura-advertising","Information",true) />
		<cfset campaignBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset variables.instance.DAO.update(campaignBean) />
	</cfif>
	
	<cfreturn campaignBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="campaignID" type="String" />		
	
	<cfset var campaignBean=read(arguments.campaignID) />
	<cfset variables.instance.globalUtility.logEvent("CampaignID:#arguments.campaignID# Name:#campaignBean.getName()# was deleted","mura-advertising","Information",true) />
	<cfset variables.instance.DAO.delete(arguments.campaignID) />
	<cfset variables.instance.placementManager.deleteByCampaign(arguments.campaignID) />
	

</cffunction>

<cffunction name="createPlacement" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.PlacementManager.create(arguments.data) />
</cffunction>

<cffunction name="readPlacement" returntype="any" access="public" output="false">
	<cfargument name="PlacementID"  type="string" />

	<cfreturn variables.instance.PlacementManager.read(arguments.PlacementID) />
</cffunction>

<cffunction name="updatePlacement" returntype="any" access="public" output="false">
	<cfargument name="data"  type="struct" />

	<cfreturn variables.instance.PlacementManager.update(arguments.data) />
</cffunction>

<cffunction name="deletePlacement" returntype="void" access="public" output="false">
	<cfargument name="PlacementID"  type="string" />

	<cfreturn variables.instance.PlacementManager.delete(arguments.PlacementID) />
</cffunction>

</cfcomponent>