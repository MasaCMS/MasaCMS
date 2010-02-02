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
	
	<cfif (not listFind(session.mura.memberships,'Admin;#variables.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not variables.permUtility.getModulePerm('00000000000000000000000000000000006','#rc.siteid#')>
		<cfset secure(rc)>
	</cfif>
	
	<cfparam name="rc.startrow" default="1" />
	<cfparam name="rc.keywords" default="" />
	<cfparam name="rc.date1" default="" />
	<cfparam name="rc.date2" default=""/>
</cffunction>

<cffunction name="listAdvertisers" output="false">
	<cfargument name="rc">
	<cfset rc.rslist=variables.advertiserManager.getAdvertisersBySiteID(rc.siteid,rc.keywords) />
</cffunction>

<cffunction name="listadzones" output="false">
	<cfargument name="rc">
	<cfset rc.rslist=variables.advertiserManager.getadzonesBySiteID(rc.siteid,rc.keywords) />
</cffunction>

<cffunction name="listCampaigns" output="false">
	<cfargument name="rc">
	<cfset rc.rslist=variables.advertiserManager.getCampaignsBySiteID(rc.siteid,rc.keywords) />
</cffunction>

<cffunction name="listCreatives" output="false">
	<cfargument name="rc">
	<cfset rc.rslist=variables.advertiserManager.getCreativesBySiteID(rc.siteid,rc.keywords) />
</cffunction>

<cffunction name="editAdZone" output="false">
	<cfargument name="rc">
	<cfset rc.adZoneBean=variables.advertiserManager.readAdZone(rc.adZoneID) />
</cffunction>

<cffunction name="editCreative" output="false">
	<cfargument name="rc">
	<cfset rc.userBean=variables.userManager.read(rc.userid) />
	<cfset rc.creativeBean=variables.advertiserManager.readCreative(rc.creativeid) />
</cffunction>

<cffunction name="editPlacement" output="false">
	<cfargument name="rc">
	<cfset rc.userBean=variables.userManager.read(rc.userid) />
	<cfset rc.campaignBean=variables.advertiserManager.readCampaign(rc.campaignid) />
	<cfset rc.placementBean=variables.advertiserManager.readPlacement(rc.placementid) />
	<cfset rc.rsAdZones=variables.advertiserManager.getadzonesBySiteID(rc.siteid,'') />
	<cfset rc.rsCreatives=advertiserManager.getCreativesByUser(rc.userid,'') />
</cffunction>

<cffunction name="viewAdvertiser" output="false">
	<cfargument name="rc">
	<cfset rc.userBean=variables.userManager.read(rc.userid) />
	<cfset rc.rsCampaigns=variables.advertiserManager.getCampaignsByUser(rc.userid) />
	<cfset rc.rsCreatives=variables.advertiserManager.getCreativesByUser(rc.userid) />
</cffunction>

<cffunction name="editCampaign" output="false">
	<cfargument name="rc">
	<cfset rc.userBean=variables.userManager.read(rc.userid) />
	<cfset rc.campaignBean=variables.advertiserManager.readCampaign(rc.campaignid) />
	<cfset rc.rsPlacements=variables.advertiserManager.getPlacementsByCampaign(rc.campaignID) />
</cffunction>

<cffunction name="viewReportByPlacement" output="false">
	<cfargument name="rc">
	<cfset rc.userBean=variables.userManager.read(rc.userid) />
	<cfset rc.campaignBean=variables.advertiserManager.readCampaign(rc.campaignid) />
	<cfset rc.placementBean=variables.advertiserManager.readPlacement(rc.placementid) />
	<cfset rc.creativeBean=variables.advertiserManage.readCreative(rc.placementBean.getCreativeID()) />
	<cfset rc.adZoneBean=variables.advertiserManager.readAdZone(rc.placementBean.getAdZoneID()) />
	<cfset variables.advertiserManager.getReportDataByPlacement(rc,rc.placementBean) />
</cffunction>

<cffunction name="viewReportByCampaign" output="false">
	<cfargument name="rc">
	<cfset rc.userBean=variables.userManager.read(rc.userid) />
	<cfset rc.campaignBean=variables.advertiserManager.readCampaign(rc.campaignID) />
</cffunction>

<cffunction name="updateCampaign" output="false">
	<cfargument name="rc">
	
	  <cfif rc.action eq 'Update'>
	  	<cfset rc.campaignBean=variables.advertiserManager.updateCampaign(rc) />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  	<cfset variables.advertiserManager.deleteCampaign(rc.campaignid) />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  	<cfset rc.campaignBean=variables.advertiserManager.createCampaign(rc) /> 
	  </cfif> 
	  
	  <cfif rc.action eq 'Add' and structIsEmpty(rc.campaignBean.getErrors())>
	   	<cfset rc.campaignid=rc.campaignBean.getCampaignID() />
	   </cfif>
	 
	  <cfif not (rc.action eq  'add' or rc.action neq  'delete' and not structIsEmpty(rc.campaignBean.getErrors()))>
	  	<cfset variables.fw.redirect(action="cAdvertising.viewAdvertiser",append="userid,siteid",path="")>
	  </cfif>
</cffunction>

<cffunction name="updateAdZone" output="false">
	<cfargument name="rc">
	  <cfif rc.action eq 'Update'>
	  	<cfset rc.adZoneBean=variables.advertiserManager.updateAdZone(rc) />
	  	<cfset variables.settingsManager.purgeAllCache() />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  	<cfset variables.advertiserManager.deleteAdZone(rc.adZoneid) />
	 	<cfset variables.settingsManager.purgeAllCache() />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  	<cfset rc.adZoneBean=variables.advertiserManager.createAdZone(rc) /> 
	  </cfif> 
	  
	  <cfif rc.action eq 'Add' and structIsEmpty(rc.adZoneBean.getErrors())>
	   	<cfset rc.AdZoneID=rc.adZoneBean.getAdZoneID() />
	   </cfif>
	 
	  <cfif not (rc.action neq  'delete' and not structIsEmpty(rc.AdZoneBean.getErrors()))>
		 <cfset variables.fw.redirect(action="cAdvertising.Listadzones",append="siteid",path="")>
	  </cfif>
</cffunction>

<cffunction name="updateCreative" output="false">
	<cfargument name="rc">
	  <cfif rc.action eq 'Update'>
	  	<cfset rc.creativeBean=variables.advertiserManager.updateCreative(rc) />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  	<cfset variables.advertiserManager.deleteCreative(rc.creativeid) />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  	<cfset rc.creativeBean=variables.advertiserManager.createCreative(rc)/> 
	  </cfif> 
	  
	  <cfif rc.action eq 'Add' and structIsEmpty(rc.creativeBean.getErrors())>
	   	<cfset rc.creativeid=rc.creativeBean.getcreativeID() />
	   </cfif>
	 
	  <cfif not (rc.action neq  'delete' and not structIsEmpty(rc.creativeBean.getErrors()))>
		  <cfset variables.fw.redirect(action="cAdvertising.viewAdvertiser",append="userid,siteid",path="")>
	  </cfif>
</cffunction>

<cffunction name="updatePlacement" output="false">
	<cfargument name="rc">
	  <cfif rc.action eq 'Update'>
	  	<cfset rc.placementBean=variables.advertiserManager.updatePlacement(rc) />
	  </cfif>
  
	  <cfif rc.action eq 'Delete'>
	  	<cfset variables.advertiserManager.deletePlacement(rc.placementid) />
	  </cfif>
  
	  <cfif rc.action eq 'Add'>
	  	<cfset rc.placementBean=variables.advertiserManager.createPlacement(rc) /> 
	  </cfif> 
	  
	  <cfif rc.action eq 'Add' and structIsEmpty(rc.placementBean.getErrors())>
	   	<cfset rc.placementid=rc.placementBean.getplacementID() />
	  </cfif>
	 
	  <cfif not (rc.action neq  'delete' and not structIsEmpty(rc.placementBean.getErrors()))>
		  <cfset variables.fw.redirect(action="cAdvertising.editCampaign",append="userid,siteid,campaignid",path="")>
	  </cfif>
</cffunction>

<cffunction name="editIPWhiteList" output="false">
	<cfargument name="rc">
	<cfset rc.rslist=variables.advertiserManager.getIPWhiteListBySiteID(rc.siteid) />
</cffunction>

<cffunction name="updateIPWhiteList" output="false">
	<cfargument name="rc">
	<cfset variables.advertiserManager.updateIPWhiteListBySiteID(rc.IPWhiteList,rc.siteid) />
	<cfset variables.fw.redirect(action="cAdvertising.listAdvertisers",append="siteid",path="")>
</cffunction>

</cfcomponent>