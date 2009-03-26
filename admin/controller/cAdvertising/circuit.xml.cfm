<circuit access="public">

<prefuseaction>
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.keywords" value="" overwrite="false" />
<set name="attributes.date1" value="" overwrite="false" />
<set name="attributes.date2" value="" overwrite="false" />

<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>

<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>
<if condition="(not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000006','#attributes.siteid#')">
	<true>
		<relocate url="#cgi.HTTP_REFERER#" addtoken="false"/>
	</true>
</if>
</prefuseaction>


<fuseaction name="listAdvertisers">
<invoke object="application.advertiserManager" methodcall="getAdvertisersBySiteID(attributes.siteid,attributes.keywords)" returnVariable="request.rsList" />
<do action="vAdvertising.listAdvertisers" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="listadzones">
<invoke object="application.advertiserManager" methodcall="getadzonesBySiteID(attributes.siteid,attributes.keywords)" returnVariable="request.rsList" />
<do action="vAdvertising.listadzones" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="listCampaigns">
<invoke object="application.advertiserManager" methodcall="getCampaignsBySiteID(attributes.siteid,attributes.keywords)" returnVariable="request.rsList" />
<do action="vAdvertising.listCampaigns" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="listCreatives">
<invoke object="application.advertiserManager" methodcall="getCreativesBySiteID(attributes.siteid,attributes.keywords)" returnVariable="request.rsList" />
<do action="vAdvertising.listCreatives" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="editAdZone">
<invoke object="application.advertiserManager" methodcall="readAdZone(attributes.adZoneID)" returnVariable="request.adZoneBean" />
<do action="vAdvertising.editAdZone" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="editCreative">
<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
<invoke object="application.advertiserManager" methodcall="readCreative(attributes.creativeid)" returnVariable="request.creativeBean" />
<do action="vAdvertising.editCreative" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="editPlacement">
<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
<invoke object="application.advertiserManager" methodcall="readCampaign(attributes.campaignid)" returnVariable="request.campaignBean" />
<invoke object="application.advertiserManager" methodcall="readPlacement(attributes.placementid)" returnVariable="request.placementBean" />
<invoke object="application.advertiserManager" methodcall="getadzonesBySiteID(attributes.siteid,'')" returnVariable="request.rsAdZones" />
<invoke object="application.advertiserManager" methodcall="getCreativesByUser(attributes.userid,'')" returnVariable="request.rsCreatives" />
<do action="vAdvertising.editPlacement" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="viewAdvertiser">
<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
<invoke object="application.advertiserManager" methodcall="getCampaignsByUser(attributes.userid)" returnVariable="request.rsCampaigns" />
<invoke object="application.advertiserManager" methodcall="getCreativesByUser(attributes.userid)" returnVariable="request.rsCreatives" />
<do action="vAdvertising.viewAdvertiser" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>


<fuseaction name="editCampaign">
<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
<invoke object="application.advertiserManager" methodcall="readCampaign(attributes.campaignID)" returnVariable="request.campaignBean" />
<invoke object="application.advertiserManager" methodcall="getPlacementsByCampaign(attributes.campaignID)" returnVariable="request.rsPlacements" />
<do action="vAdvertising.editCampaign" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="viewReportByPlacement">
<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
<invoke object="application.advertiserManager" methodcall="readCampaign(attributes.campaignID)" returnVariable="request.campaignBean" />
<invoke object="application.advertiserManager" methodcall="readPlacement(attributes.placementid)" returnVariable="request.placementBean" />
<invoke object="application.advertiserManager" methodcall="readCreative(request.placementBean.getCreativeID())" returnVariable="request.creativeBean" />
<invoke object="application.advertiserManager" methodcall="readAdZone(request.placementBean.getAdZoneID())" returnVariable="request.adZoneBean" />
<invoke object="application.advertiserManager" methodcall="getReportDataByPlacement(attributes,request.placementBean)" />
<do action="vAdvertising.viewReportByPlacement" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="viewReportByCampaign">
<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
<invoke object="application.advertiserManager" methodcall="readCampaign(attributes.campaignID)" returnVariable="request.campaignBean" />
<do action="vAdvertising.viewReportByCampaign" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="updateCampaign">
	
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="updateCampaign(attributes)" returnVariable="request.campaignBean" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="deleteCampaign(attributes.campaignid)" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="createCampaign(attributes)" returnVariable="request.campaignBean" /> 
	  </true>
	  </if> 
	  
	  <if condition="attributes.action eq 'Add' and structIsEmpty(request.campaignBean.getErrors())">
	  <true>
	   	<set name="attributes.campaignid" value="#request.campaignBean.getCampaignID()#" />
	  </true>
	   </if>
	 
	  <if condition="attributes.action eq  'add' or attributes.action neq  'delete' and not structIsEmpty(request.campaignBean.getErrors())">
	  <true>
	  	<do action="cAdvertising.editCampaign"/>
	  </true>
	  <false>
	  	<relocate url="index.cfm?fuseaction=cAdvertising.viewAdvertiser&amp;userid=#attributes.userid#&amp;siteid=#attributes.siteid#" addtoken="false"/>
	  </false>
	  </if>
</fuseaction>

<fuseaction name="updateAdZone">
	
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="updateAdZone(attributes)" returnVariable="request.adZoneBean" />
	  	<invoke object="application.utility" methodcall="flushCache('')" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="deleteAdZone(attributes.adZoneid)" />
	 	<invoke object="application.utility" methodcall="flushCache('')" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="createAdZone(attributes)" returnVariable="request.adZoneBean" /> 
	  </true>
	  </if> 
	  
	  <if condition="attributes.action eq 'Add' and structIsEmpty(request.adZoneBean.getErrors())">
	  <true>
	   	<set name="attributes.AdZoneID" value="#request.adZoneBean.getAdZoneID()#" />
	  </true>
	   </if>
	 
	  <if condition="attributes.action neq  'delete' and not structIsEmpty(request.AdZoneBean.getErrors())">
	  <true>
	  	<do action="cAdvertising.editAdZone"/>
	  </true>
	  <false>
	  	<relocate url="index.cfm?fuseaction=cAdvertising.Listadzones&amp;siteid=#attributes.siteid#" addtoken="false"/>
	  </false>
	  </if>
</fuseaction>

<fuseaction name="updateCreative">
	
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="updateCreative(attributes)" returnVariable="request.creativeBean" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="deleteCreative(attributes.creativeid)" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="createCreative(attributes)" returnVariable="request.creativeBean" /> 
	  </true>
	  </if> 
	  
	  <if condition="attributes.action eq 'Add' and structIsEmpty(request.creativeBean.getErrors())">
	  <true>
	   	<set name="attributes.creativeid" value="#request.creativeBean.getcreativeID()#" />
	  </true>
	   </if>
	 
	  <if condition="attributes.action neq  'delete' and not structIsEmpty(request.creativeBean.getErrors())">
	  <true>
	  	<do action="cAdvertising.editCreative"/>
	  </true>
	  <false>
	  	<relocate url="index.cfm?fuseaction=cAdvertising.viewAdvertiser&amp;siteid=#attributes.siteid#&amp;userid=#attributes.userid#" addtoken="false"/>
	  </false>
	  </if>
</fuseaction>

<fuseaction name="updatePlacement">
	
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="updatePlacement(attributes)" returnVariable="request.placementBean" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="deletePlacement(attributes.placementid)" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="application.advertiserManager" methodcall="createPlacement(attributes)" returnVariable="request.placementBean" /> 
	  </true>
	  </if> 
	  
	  <if condition="attributes.action eq 'Add' and structIsEmpty(request.placementBean.getErrors())">
	  <true>
	   	<set name="attributes.placementid" value="#request.placementBean.getplacementID()#" />
	  </true>
	   </if>
	 
	  <if condition="attributes.action neq  'delete' and not structIsEmpty(request.placementBean.getErrors())">
	  <true>
	  	<do action="cAdvertising.editPlacement"/>
	  </true>
	  <false>
	  	<relocate url="index.cfm?fuseaction=cAdvertising.editCampaign&amp;siteid=#attributes.siteid#&amp;userid=#attributes.userid#&amp;campaignid=#attributes.campaignid#" addtoken="false"/>
	  </false>
	  </if>
</fuseaction>

<fuseaction name="editIPWhiteList">
<invoke object="application.advertiserManager" methodcall="getIPWhiteListBySiteID(attributes.siteid)" returnVariable="request.rsList" />
<do action="vAdvertising.editIPWhiteList" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="updateIPWhiteList">
<invoke object="application.advertiserManager" methodcall="updateIPWhiteListBySiteID(attributes.IPWhiteList,attributes.siteid)" />
<relocate url="index.cfm?fuseaction=cAdvertising.listAdvertisers&amp;siteid=#attributes.siteid#" addtoken="false"/>
</fuseaction>

</circuit>
