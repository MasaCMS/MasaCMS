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
<cfcomponent extends="controller" output="false">

<cffunction name="setAdvertiserManager" output="false">
	<cfargument name="advertiserManager">
	<cfset variables.advertiserManager=arguments.advertiserManager>
</cffunction>

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not variables.permUtility.getModulePerm('00000000000000000000000000000000006','#rc.siteid#')>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.keywords" default="" />
	<cfparam name="arguments.rc.date1" default="" />
	<cfparam name="arguments.rc.date2" default=""/>
</cffunction>

<cffunction name="listAdvertisers" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.advertiserManager.getAdvertisersBySiteID(arguments.rc.siteid,arguments.rc.keywords) />
</cffunction>

<cffunction name="listadzones" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.advertiserManager.getadzonesBySiteID(arguments.rc.siteid,arguments.rc.keywords) />
</cffunction>

<cffunction name="listCampaigns" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.advertiserManager.getCampaignsBySiteID(arguments.rc.siteid,arguments.rc.keywords) />
</cffunction>

<cffunction name="listCreatives" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.advertiserManager.getCreativesBySiteID(arguments.rc.siteid,arguments.rc.keywords) />
</cffunction>

<cffunction name="editAdZone" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.adZoneBean=variables.advertiserManager.readAdZone(arguments.rc.adZoneID) />
</cffunction>

<cffunction name="editCreative" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	<cfset arguments.rc.creativeBean=variables.advertiserManager.readCreative(arguments.rc.creativeid) />
</cffunction>

<cffunction name="editPlacement" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	<cfset arguments.rc.campaignBean=variables.advertiserManager.readCampaign(arguments.rc.campaignid) />
	<cfset arguments.rc.placementBean=variables.advertiserManager.readPlacement(arguments.rc.placementid) />
	<cfset arguments.rc.rsAdZones=variables.advertiserManager.getadzonesBySiteID(arguments.rc.siteid,'') />
	<cfset arguments.rc.rsCreatives=advertiserManager.getCreativesByUser(arguments.rc.userid,'') />
</cffunction>

<cffunction name="viewAdvertiser" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	<cfset arguments.rc.rsCampaigns=variables.advertiserManager.getCampaignsByUser(arguments.rc.userid) />
	<cfset arguments.rc.rsCreatives=variables.advertiserManager.getCreativesByUser(arguments.rc.userid) />
</cffunction>

<cffunction name="editCampaign" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	<cfset arguments.rc.campaignBean=variables.advertiserManager.readCampaign(arguments.rc.campaignid) />
	<cfset arguments.rc.rsPlacements=variables.advertiserManager.getPlacementsByCampaign(arguments.rc.campaignID) />
</cffunction>

<cffunction name="viewReportByPlacement" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	<cfset arguments.rc.campaignBean=variables.advertiserManager.readCampaign(arguments.rc.campaignid) />
	<cfset arguments.rc.placementBean=variables.advertiserManager.readPlacement(arguments.rc.placementid) />
	<cfset arguments.rc.creativeBean=variables.advertiserManager.readCreative(arguments.rc.placementBean.getCreativeID()) />
	<cfset arguments.rc.adZoneBean=variables.advertiserManager.readAdZone(arguments.rc.placementBean.getAdZoneID()) />
	<cfset variables.advertiserManager.getReportDataByPlacement(arguments.rc,arguments.rc.placementBean) />
</cffunction>

<cffunction name="viewReportByCampaign" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.userBean=variables.userManager.read(arguments.rc.userid) />
	<cfset arguments.rc.campaignBean=variables.advertiserManager.readCampaign(arguments.rc.campaignID) />
</cffunction>

<cffunction name="updateCampaign" output="false">
	<cfargument name="rc">
	
	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.campaignBean=variables.advertiserManager.updateCampaign(arguments.rc) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset variables.advertiserManager.deleteCampaign(arguments.rc.campaignid) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.campaignBean=variables.advertiserManager.createCampaign(arguments.rc) /> 
	  </cfif> 
	  
	  <cfif arguments.rc.action eq 'Add' and structIsEmpty(arguments.rc.campaignBean.getErrors())>
	   	<cfset arguments.rc.campaignid=rc.campaignBean.getCampaignID() />
	   </cfif>
	 
	  <cfif not (arguments.rc.action eq  'add' or arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.campaignBean.getErrors()))>
	  	<cfset variables.fw.redirect(action="cAdvertising.viewAdvertiser",append="userid,siteid")>
	  <cfelse>
	  	<cfset variables.fw.redirect(action="cAdvertising.editCampaign",append="userid,siteid,campaignid")>
	  </cfif>
</cffunction>

<cffunction name="updateAdZone" output="false">
	<cfargument name="rc">
	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.adZoneBean=variables.advertiserManager.updateAdZone(arguments.rc) />
	  	<cfset variables.settingsManager.purgeAllCache() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset variables.advertiserManager.deleteAdZone(arguments.rc.adZoneid) />
	 	<cfset variables.settingsManager.purgeAllCache() />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.adZoneBean=variables.advertiserManager.createAdZone(arguments.rc) /> 
	  </cfif> 
	  
	  <cfif arguments.rc.action eq 'Add' and structIsEmpty(arguments.rc.adZoneBean.getErrors())>
	   	<cfset arguments.rc.AdZoneID=rc.adZoneBean.getAdZoneID() />
	   </cfif>
	 
	  <cfif not (arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.AdZoneBean.getErrors()))>
		 <cfset variables.fw.redirect(action="cAdvertising.Listadzones",append="siteid")>
	  </cfif>
</cffunction>

<cffunction name="updateCreative" output="false">
	<cfargument name="rc">
	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.creativeBean=variables.advertiserManager.updateCreative(arguments.rc) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset variables.advertiserManager.deleteCreative(arguments.rc.creativeid) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.creativeBean=variables.advertiserManager.createCreative(arguments.rc)/> 
	  </cfif> 
	  
	  <cfif arguments.rc.action eq 'Add' and structIsEmpty(arguments.rc.creativeBean.getErrors())>
	   	<cfset arguments.rc.creativeid=rc.creativeBean.getcreativeID() />
	   </cfif>
	 
	  <cfif not (arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.creativeBean.getErrors()))>
		  <cfset variables.fw.redirect(action="cAdvertising.viewAdvertiser",append="userid,siteid")>
	  </cfif>
</cffunction>

<cffunction name="updatePlacement" output="false">
	<cfargument name="rc">
	  <cfif arguments.rc.action eq 'Update'>
	  	<cfset arguments.rc.placementBean=variables.advertiserManager.updatePlacement(arguments.rc) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Delete'>
	  	<cfset variables.advertiserManager.deletePlacement(arguments.rc.placementid) />
	  </cfif>
  
	  <cfif arguments.rc.action eq 'Add'>
	  	<cfset arguments.rc.placementBean=variables.advertiserManager.createPlacement(arguments.rc) /> 
	  </cfif> 
	  
	  <cfif arguments.rc.action eq 'Add' and structIsEmpty(arguments.rc.placementBean.getErrors())>
	   	<cfset arguments.rc.placementid=rc.placementBean.getplacementID() />
	  </cfif>
	 
	  <cfif not (arguments.rc.action neq  'delete' and not structIsEmpty(arguments.rc.placementBean.getErrors()))>
		  <cfset variables.fw.redirect(action="cAdvertising.editCampaign",append="userid,siteid,campaignid")>
	  </cfif>
</cffunction>

<cffunction name="editIPWhiteList" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.advertiserManager.getIPWhiteListBySiteID(arguments.rc.siteid) />
</cffunction>

<cffunction name="updateIPWhiteList" output="false">
	<cfargument name="rc">
	<cfset variables.advertiserManager.updateIPWhiteListBySiteID(arguments.rc.IPWhiteList,arguments.rc.siteid) />
	<cfset variables.fw.redirect(action="cAdvertising.listAdvertisers",append="siteid")>
</cffunction>

</cfcomponent>