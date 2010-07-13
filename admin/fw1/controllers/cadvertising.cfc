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
	  	<cfset variables.fw.redirect(action="cAdvertising.viewAdvertiser",append="userid,siteid",path="")>
	  <cfelse>
	  	<cfset variables.fw.redirect(action="cAdvertising.editCampaign",append="userid,siteid,campaignid",path="")>
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
		 <cfset variables.fw.redirect(action="cAdvertising.Listadzones",append="siteid",path="")>
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
		  <cfset variables.fw.redirect(action="cAdvertising.viewAdvertiser",append="userid,siteid",path="")>
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
		  <cfset variables.fw.redirect(action="cAdvertising.editCampaign",append="userid,siteid,campaignid",path="")>
	  </cfif>
</cffunction>

<cffunction name="editIPWhiteList" output="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.advertiserManager.getIPWhiteListBySiteID(arguments.rc.siteid) />
</cffunction>

<cffunction name="updateIPWhiteList" output="false">
	<cfargument name="rc">
	<cfset variables.advertiserManager.updateIPWhiteListBySiteID(arguments.rc.IPWhiteList,arguments.rc.siteid) />
	<cfset variables.fw.redirect(action="cAdvertising.listAdvertisers",append="siteid",path="")>
</cffunction>

</cfcomponent>