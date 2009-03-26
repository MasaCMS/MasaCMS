<circuit access="internal">

<prefuseaction>
<set name="attributes.datasource" value="#application.configBean.getDatasource()#" overwrite="false" />
<set name="attributes.parentid" value="" overwrite="false" />
<set name="attributes.menuTitle" value="" overwrite="false" />
<set name="attributes.title" value="" overwrite="false" />
<set name="attributes.action" value="" overwrite="false" />
<set name="attributes.ptype" value="Page" overwrite="false" />
<set name="attributes.contentid" value="" overwrite="false" />
<set name="attributes.contenthistid" value="" overwrite="false" />
<set name="attributes.type" value="Page" overwrite="false" />
<set name="attributes.body" value="" overwrite="false" />
<set name="attributes.oldbody" value="" overwrite="false" />
<set name="attributes.oldfilename" value="" overwrite="false" />
<set name="attributes.url" value="" overwrite="false" />
<set name="attributes.filename" value="" overwrite="false" />
<set name="attributes.metadesc" value="" overwrite="false" />
<set name="attributes.metakeywords" value="" overwrite="false" />
<set name="attributes.orderno" value="0" overwrite="false" />
<set name="attributes.display" value="0" overwrite="false" />
<set name="attributes.displaystart" value="" overwrite="false" />
<set name="attributes.displaystop" value="" overwrite="false" />
<set name="attributes.abstract" value="" overwrite="false" />
<set name="attributes.frameid" value="0" overwrite="false" />
<set name="attributes.abstract" value="" overwrite="false" />
<set name="attributes.editor" value="0" overwrite="false" />
<set name="attributes.author" value="0" overwrite="false" />
<set name="variables.editor" value="0" overwrite="false" />
<set name="variables.author" value="0" overwrite="false" />
<set name="attributes.moduleid" value="00000000000000000000000000000000000" overwrite="false" />
<set name="attributes.objectid" value="" overwrite="false" />
<set name="attributes.lastupdate" value="" overwrite="false" />
<set name="attributes.siteid" value="" overwrite="false" />
<set name="attributes.title" value="" overwrite="false" />
<set name="attributes.topid" value="00000000000000000000000000000000001" overwrite="false"/>
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.lastupdate" value="#now()#" overwrite="false" />
<set name="session.viewDepth" value="#application.settingsManager.getSite(attributes.siteid).getviewdepth()#" overwrite="false" />
<set name="session.nextN" value="#application.settingsManager.getSite(attributes.siteid).getnextN()#" overwrite="false" />
<set name="session.keywords" value="" overwrite="false" />
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.date1" value="" overwrite="false" />
<set name="attributes.date2" value="" overwrite="false" />
<set name="attributes.return" value="" overwrite="false" />
<set name="attributes.forceSSL" value="0" overwrite="false" />
<set name="attributes.closeCompactDisplay" value="" overwrite="false" />
<set name="attributes.returnURL" value="" overwrite="false" />

<if condition="attributes.orderno eq ''">
<true>
<set name="attributes.orderno" value="0" />
</true>
</if>


<if condition="isdefined('attributes.approved')">
<true>
<set name="attributes.active" value="1" />
</true>
<false>
<set name="attributes.active" value="0" />
</false>
</if>

<if condition="isdefined('attributes.approved')">
<true>
<set name="attributes.approved" value="1" />
</true>
<false>
<set name="attributes.approved" value="0" />
</false>
</if>

<set name="attributes.locking" value="none" overwrite="false" />

</prefuseaction>

<fuseaction name="Edit">

  <include template="dsp_form.cfm"/>
  </fuseaction>
 
<fuseaction name="multiFileUpload">
  <include template="dsp_multi_upload_form.cfm"/>
 </fuseaction>

 <fuseaction name="hist">

  <include template="dsp_hist.cfm"/>
  </fuseaction>

  <fuseaction name="draft">
 
 <include template="dsp_draftlist.cfm"/>
  </fuseaction>
  
  <fuseaction name="list">
		<if condition="attributes.moduleid eq '00000000000000000000000000000000003'">
			<true>
			<set name="variables.section" value="Component Manager"/>
			<include template="dsp_flatlist.cfm"/>
		</true>
		</if>
		<if condition="attributes.moduleid eq '00000000000000000000000000000000004'">
			<true>
			<set name="variables.section" value="Forms Manager"/>
			<include template="dsp_flatlist.cfm"/>
		</true>
		</if>
		<if condition="attributes.moduleid eq '00000000000000000000000000000000000'">
			<true>
			<include template="dsp_list.cfm"/>
		</true>
		</if>
	
 
  </fuseaction>
  
 <fuseaction name="datamanager">
	<include template="dsp_data_manager.cfm"/>
 </fuseaction>
 
 <fuseaction name="downloaddata">
	<include template="act_downloaddata.cfm"/>
 </fuseaction>
 
  <fuseaction name="viewreport">
	<include template="dsp_viewreport.cfm"/>
 </fuseaction>
 
   <fuseaction name="search">
	<include template="dsp_search.cfm"/>
 </fuseaction>
 
 <!-- AJAX -->

<fuseaction name="ajax">
	<include template="ajax/dsp_javascript.cfm"/>
</fuseaction>

<fuseaction name="siteParents">
	<include template="ajax/dsp_siteParentsRender.cfm"/>
</fuseaction>

<fuseaction name="loadClass">
	<include template="ajax/dsp_objectClass.cfm"/>
</fuseaction>

<fuseaction name="loadNotify">
	<include template="ajax/dsp_notify.cfm"/>
</fuseaction>

<fuseaction name="exportHtmlSite">
	<include template="dsp_export_html_site.cfm"/>
</fuseaction>

<fuseaction name="topRated">
	<include template="dsp_topRated.cfm"/>
</fuseaction>

<fuseaction name="loadRelatedContent">
	<include template="ajax/dsp_loadRelatedContent.cfm"/>
</fuseaction>

<fuseaction name="loadExtendedAttributes">
	<include template="ajax/dsp_extended_attributes.cfm"/>
</fuseaction>

<fuseaction name="closeCompactDisplay">
	<include template="dsp_close_compact_display.cfm"/>
</fuseaction>

<fuseaction name="loadCategoryFeatureStartStop">
 <include template="ajax/dsp_loadCategoryFeatureStartStop.cfm"/>
</fuseaction>

</circuit>