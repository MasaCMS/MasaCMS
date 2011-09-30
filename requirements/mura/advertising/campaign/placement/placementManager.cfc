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
<cfargument name="placementGateway" type="any" required="yes"/>
<cfargument name="placementDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="trashManager" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.gateway=arguments.placementGateway />
	<cfset variables.instance.DAO=arguments.placementDAO />
	<cfset variables.instance.globalUtility=arguments.utility />
	<cfset variables.instance.trashManager=arguments.trashManager />
	
	<cfreturn this />
</cffunction>

<cffunction name="getBean" output="false">
	<cfargument name="beanName" default="placement">
	<cfreturn super.getBean(arguments.beanName)>
</cffunction>

<cffunction name="getPlacementsByCampaign" access="public" output="false" returntype="query">
	<cfargument name="campaignID" type="String">
	<cfargument name="date1" type="string" required="true" default="" />
	<cfargument name="date2" type="string" required="true" default="" />
	
	<cfreturn variables.instance.gateway.getPlacementsByCampaign(arguments.campaignID,arguments.date1,arguments.date2) />
</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var placementBean=getBean("placementBean") />
	<cfset placementBean.set(arguments.data) />
	
	<cfif structIsEmpty(placementBean.getErrors())>
		<cfset placementBean.setLastUpdateBy(left(session.mura.fname & " " & session.mura.lname,50)) />
		<cfif not (structKeyExists(arguments.data,"placementID") and len(arguments.data.placementID))>
			<cfset placementBean.setPlacementID("#createUUID()#") />
		</cfif>
		<cfset variables.instance.globalUtility.logEvent("PlacementID:#placementBean.getPlacementID()# CampaignID:#placementBean.getCampaignID()# was created","mura-advertising","Information",true) />
		<cfset variables.instance.DAO.create(placementBean) />
		<cfset variables.instance.trashManager.takeOut(placementBean)>
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
		<cfset variables.instance.globalUtility.logEvent("PlacementID:#placementBean.getPlacementID()# Name:#placementBean.getCampaignID()# was updated","mura-advertising","Information",true) />
		<cfset placementBean.setLastUpdateBy(left(session.mura.fname & " " & session.mura.lname,50)) />
		<cfset variables.instance.DAO.update(placementBean) />
	</cfif>
	
	<cfreturn placementBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="placementID" type="String" />		
	
	<cfset var placementBean=read(arguments.placementID) />
	<cfset variables.instance.trashManager.throwIn(placementBean)>
	<cfset variables.instance.globalUtility.logEvent("PlacementID:#arguments.placementID# CampaignID:#placementBean.getCampaignID()# was deleted","mura-advertising","Information",true) />
	<cfset variables.instance.DAO.delete(arguments.placementID) />

</cffunction>

<cffunction name="deleteByCampaign" access="public" returntype="void" output="false">
	<cfargument name="campaignID" type="String" />		
	
	<cfset var rs=getPlacementsByCampaign(arguments.campaignID)>
	<cfif rs.recordcount>
		<cfset variables.instance.globalUtility.logEvent("All Placements for CampaignID:#arguments.campaignID# were deleted","mura-advertising","Information",true) />
	
		<cfloop query="rs">
			<cfset delete(rs.placementID)>
		</cfloop>
	</cfif>

</cffunction>

</cfcomponent>