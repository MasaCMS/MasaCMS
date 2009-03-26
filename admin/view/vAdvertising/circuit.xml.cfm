<circuit access="internal">
<prefuseaction>
<set name="attributes.date1" value="" overwrite="false" />
<set name="attributes.date2" value="" overwrite="false" />
<set name="attributes.keywords" value="" overwrite="false" />
</prefuseaction>

  <fuseaction name="listAdvertisers">
  <include template="dsp_listAdvertisers.cfm"/>
  </fuseaction>

  <fuseaction name="listadzones">
  <include template="dsp_listAdZones.cfm"/>
  </fuseaction>
  
  <fuseaction name="listCampaigns">
  <include template="dsp_listCampaigns.cfm"/>
  </fuseaction>
  
  <fuseaction name="listCreatives">
  <include template="dsp_listCreatives.cfm"/>
  </fuseaction>
  
  <fuseaction name="editAdZone">
  <include template="dsp_editAdZone.cfm"/>
  </fuseaction>

  <fuseaction name="editCreative">
  <include template="dsp_editCreative.cfm"/>
  </fuseaction>
  
  <fuseaction name="viewAdvertiser">
  <include template="dsp_viewAdvertiser.cfm"/>
  </fuseaction>

  <fuseaction name="editCampaign">
  <include template="dsp_editCampaign.cfm"/>
  </fuseaction>
  
  <fuseaction name="editPlacement">
  <include template="dsp_editPlacement.cfm"/>
  </fuseaction>
  
  <fuseaction name="viewReportByCampaign">
  <include template="dsp_viewReportByCampaign.cfm"/>
  </fuseaction>
  
  <fuseaction name="viewReportByPlacement">
  <include template="dsp_viewReportByPlacement.cfm"/>
  </fuseaction>
	
  <fuseaction name="editIPWhiteList">
  <include template="dsp_editIPWhiteList.cfm"/>
  </fuseaction>
</circuit>