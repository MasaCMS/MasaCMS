<circuit access="public">

<prefuseaction>
<set name="attributes.return" value="" overwrite="false" />
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.contentHistID" value="#createuuid()#" overwrite="false" />
<set name="attributes.notify" value="" overwrite="false" />
<set name="attributes.preview" value="0" overwrite="false" />
<set name="attributes.size" value="20" overwrite="false" />
<set name="attributes.isNav" value="0" overwrite="false" />
<set name="attributes.isLocked" value="0" overwrite="false" />
<set name="attributes.forceSSL" value="0" overwrite="false" />
<set name="attributes.target" value="_self" overwrite="false" />
<set name="attributes.searchExclude" value="0" overwrite="false" />
<set name="attributes.restricted" value="0" overwrite="false" />
<set name="attributes.relatedcontentid" value="" overwrite="false" />
<set name="attributes.responseChart" value="0" overwrite="false" />
<set name="attributes.displayTitle" value="0" overwrite="false" />
<set name="attributes.closeCompactDisplay" value="" overwrite="false" />
<set name="attributes.compactDisplay" value="" overwrite="false" />
<set name="attributes.doCache" value="1" overwrite="false" />
<set name="attributes.returnURL" value="" overwrite="false" />

<if condition="not len(getAuthUser())">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="not application.permUtility.getModulePerm('00000000000000000000000000000000000',attributes.siteid)">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>
</prefuseaction>

<fuseaction name="multiFileUpload">
	<invoke object="application.contentManager" methodcall="getCrumbList(attributes.parentid,attributes.siteid)" returnVariable="request.crumbdata" />
  	<invoke object="application.contentManager" methodcall="getItemCount(attributes.contentid,attributes.siteid)" returnVariable="request.rsCount" />
  	<invoke object="application.contentManager" methodcall="getPageCount(attributes.siteid)" returnVariable="request.rsPageCount" />
  	<invoke object="application.contentUtility" methodcall="getRestrictGroups(attributes.siteid)" returnVariable="request.rsRestrictGroups" />
	<do action="vArch.ajax" contentvariable="fusebox.ajax"/>
	<do action="vArch.multiFileUpload" contentvariable="fusebox.layout"/>
	<if condition="attributes.compactDisplay eq 'true'">
		<true>
			<do action="layout.compact"/>
		</true>
		<false>
			<do action="layout.display"/>
		</false>
	</if>

</fuseaction>

<fuseaction name="edit">

  <if condition="attributes.contentid eq ''">
		<true>
			<invoke object="application.contentManager" methodcall="getCrumbList(attributes.parentid,attributes.siteid)" returnVariable="request.crumbdata" />
	    </true>
		<false>
			<invoke object="application.contentManager" methodcall="getCrumbList(attributes.contentid,attributes.siteid)" returnVariable="request.crumbdata" />
	    </false>
	</if>

  <invoke object="application.contentManager" methodcall="getcontentVersion(attributes.contenthistid,attributes.siteid)" returnVariable="request.contentBean" />
  
   <if condition="attributes.contentid neq '' and attributes.contenthistid neq '' and request.contentBean.getIsNew() eq 1">
   <true>
	<relocate url="index.cfm?fuseaction=cArch.hist&amp;topid=#attributes.topid#&amp;contentid=#attributes.contentid#&amp;startrow=#attributes.startrow#&amp;siteid=#attributes.siteid#&amp;moduleid=#attributes.moduleid#&amp;parentid=#attributes.parentid#&amp;type=#attributes.type#" addtoken="false"/>
   	</true>
   </if>
   
  <invoke object="application.contentManager" methodcall="getItemCount(attributes.contentid,attributes.siteid)" returnVariable="request.rsCount" />
  <invoke object="application.contentManager" methodcall="getPageCount(attributes.siteid)" returnVariable="request.rsPageCount" />
  <invoke object="application.contentUtility" methodcall="getRestrictGroups(attributes.siteid)" returnVariable="request.rsRestrictGroups" />
  <if condition="attributes.moduleid eq '00000000000000000000000000000000000'">
		<true>
		  <invoke object="application.contentUtility" methodcall="getTemplates(attributes.siteid)" returnVariable="request.rsTemplates" />
		  <invoke object="application.contentManager" methodcall="readRegionObjects(attributes.contenthistid,attributes.siteid)" />
		  <invoke object="application.categoryManager" methodcall="getCategoriesBySiteID(attributes.siteid,'')" returnVariable="request.rsCategories" />
		 <invoke object="application.contentManager" methodcall="getCategoriesByHistID(attributes.contenthistID)" returnVariable="request.rsCategoryAssign" />
		</true>
	</if>
	<invoke object="application.contentManager" methodcall="getRelatedContent(attributes.siteid, attributes.contenthistID)" returnVariable="request.rsRelatedContent" />
	<do action="vArch.ajax" contentvariable="fusebox.ajax"/>
	<do action="vArch.edit" contentvariable="fusebox.layout"/>
	<if condition="attributes.compactDisplay eq 'true'">
		<true>
			<do action="layout.compact"/>
		</true>
		<false>
			<do action="layout.display"/>
		</false>
	</if>
</fuseaction>

  
<fuseaction name="hist">
<invoke object="application.contentManager" methodcall="getHist(attributes.contentid,attributes.siteid)" returnVariable="request.rshist" />
<invoke object="application.contentManager" methodcall="getActiveContent(attributes.contentid,attributes.siteid)" returnVariable="request.contentBean" />
<invoke object="application.contentManager" methodcall="getItemCount(attributes.contentid,attributes.siteid)" returnVariable="request.rsCount" />
<do action="vArch.ajax" contentvariable="fusebox.ajax"/>
<do action="vArch.hist" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="draft">
<invoke object="application.contentManager" methodcall="getDraftList(attributes.siteid)" returnVariable="request.rsList" />
<do action="vArch.ajax" contentvariable="fusebox.ajax"/>
<do action="vArch.draft" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

  
<fuseaction name="update">
	<invoke object="application.contentGateway" methodcall="getCrumblist(attributes.contentID, attributes.siteid)" returnVariable="attributes.crumbData" />  
	
	 <if condition="len(attributes.contentID)">
		 <true>
		 <invoke object="application.contentGateway" methodcall="getCrumblist(attributes.contentID, attributes.siteid)" returnVariable="attributes.crumbData" />
		 <invoke object="application.permUtility" methodcall="getNodePerm(attributes.crumbData)" returnVariable="attributes.perm" />  
		 </true>
	 </if>
	 
	 <if condition="not len(attributes.contentID) and len(attributes.parentID)">
		 <true>
		 <invoke object="application.contentGateway" methodcall="getCrumblist(attributes.parentID, attributes.siteid)" returnVariable="attributes.crumbData" />
		 <invoke object="application.permUtility" methodcall="getNodePerm(attributes.crumbData)" returnVariable="attributes.perm" />  
		 </true>
	 </if>
	 
	<if condition="not listFindNoCase('author,editor',attributes.perm)">
		<true>
			<set name="attributes.allowAction" value="false" overwrite="true" />
		</true>
		<false>
			<set name="attributes.allowAction" value="true" overwrite="true" />
		</false>
	</if>
	 
	 <if condition="attributes.allowAction and attributes.action eq 'deleteall'">
		 <true>
		<invoke object="application.contentManager" methodcall="deleteAll(attributes)" returnVariable="attributes.topid" />  
		 </true>
	 </if>
  
	 <if condition="attributes.allowAction and attributes.action eq 'deletehistall'">
	 <true>
	 	<invoke object="application.contentManager" methodcall="deletehistAll(attributes)" />
     </true>
	 </if>
  
	  <if condition="attributes.allowAction and attributes.action eq 'delete'">
		 <true>
			  <invoke object="application.contentManager" methodcall="delete(attributes)" />
		</true>
	 </if>
  
	 <if condition="attributes.allowAction and attributes.action eq 'add'">
		 <true>
		  <invoke object="application.contentManager" methodcall="add(attributes)" returnVariable="request.contentBean" />
		 </true>
	 </if>
	 
	 <if condition="attributes.allowAction and attributes.action eq 'multiFileUpload'">
		 <true>
		  <invoke object="application.contentManager" methodcall="multiFileUpload(attributes)" />
		 </true>
	 </if>
	 
	  <if condition="attributes.allowAction and attributes.action eq 'add' and attributes.contentID neq '00000000000000000000000000000000001'">
		 <true>
	      <set name="attributes.topid" value="#request.contentBean.getParentID()#" overwrite="true" />	
		</true>
	 </if>
	 
	<if condition="attributes.closeCompactDisplay eq 'true'">
		<true>
			<do action="vArch.closeCompactDisplay" contentvariable="fusebox.layout" />
			<do action="layout.empty" />
		</true>
		<false>
			<if condition="attributes.action eq 'delete' or attributes.action eq 'deletehistall' or (len(attributes.returnURL) and attributes.preview eq 0)">
				<true>
					<relocate url="#attributes.returnURL#" addtoken="false"/>
				</true>
			</if>
			
			<if condition="attributes.action eq 'delete' or attributes.action eq 'deletehistall' or (attributes.return eq 'hist' and attributes.preview eq 0)">
				<true>
					<relocate url="index.cfm?fuseaction=cArch.hist&amp;topid=#attributes.topid#&amp;contentid=#attributes.contentid#&amp;startrow=#attributes.startrow#&amp;siteid=#attributes.siteid#&amp;moduleid=#attributes.moduleid#&amp;parentid=#attributes.parentid#&amp;type=#attributes.type#" addtoken="false"/>
				</true>
			</if>
			
			<if condition="attributes.preview eq 0">
				<true>
					<relocate url="index.cfm?fuseaction=cArch.list&amp;topid=#attributes.topid#&amp;siteid=#attributes.siteid#&amp;startrow=#attributes.startrow#&amp;moduleid=#attributes.moduleid#" addtoken="false"/>
				</true>
				<false>
					<relocate url="index.cfm?fuseaction=cArch.edit&amp;contenthistid=#request.contentBean.getcontentHistID()#&amp;contentid=#request.contentBean.getcontentID()#&amp;type=#request.contentBean.getType()#&amp;parentid=#request.contentBean.getParentID()#&amp;topid=#attributes.topid#&amp;siteid=#attributes.siteid#&amp;moduleid=#attributes.moduleid#&amp;startrow=#attributes.startrow#&amp;preview=1&amp;return=#attributes.return#" addtoken="false"/>
				</false>
			</if>
		</false>	
	</if>
	
	
</fuseaction>

<fuseaction name="list">

	<invoke object="application.contentManager" methodcall="getlist(attributes)" returnVariable="request.rsTop" />
	
	<if condition="attributes.moduleid neq '00000000000000000000000000000000001'">
		<true>
			<invoke object="application.utility" methodcall="getNextN(request.rsTop,30,attributes.startrow)" returnVariable="request.nextn" />
		</true>
	</if>
	<do action="vArch.ajax" contentvariable="fusebox.ajax"/>
	<do action="vArch.list"  contentvariable="fusebox.layout"/>
	<do action="layout.display"/>

</fuseaction>

<fuseaction name="datamanager">
<invoke object="application.contentManager" methodcall="getCrumbList(attributes.contentid,attributes.siteid)" returnVariable="request.crumbdata" />
<invoke object="application.contentManager" methodcall="getActiveContent(attributes.contentid,attributes.siteid)" returnVariable="request.contentBean" />
<do action="vArch.ajax" contentvariable="fusebox.ajax"/>
<do action="vArch.datamanager" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="viewreport">
<invoke object="application.contentManager" methodcall="getCrumbList(attributes.contentid,attributes.siteid)" returnVariable="request.crumbdata" />
<invoke object="application.contentManager" methodcall="getActiveContent(attributes.contentid,attributes.siteid)" returnVariable="request.contentBean" />
<invoke object="application.contentManager" methodcall="getReportData(attributes,request.contentBean)" />
<do action="vArch.ajax" contentvariable="fusebox.ajax"/>
<do action="vArch.viewreport" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="downloaddata">
<invoke object="application.contentManager" methodcall="getActiveContent(attributes.contentid,attributes.siteid)" returnVariable="request.currentBean" />
<invoke object="application.contentManager" methodcall="getDownloadselect(attributes.contentid,attributes.siteid)" returnVariable="request.dataInfo" />
<do action="vArch.downloaddata"/>
</fuseaction>

<fuseaction name="sendReminders">
<invoke object="application.contentManager" methodcall="sendReminders()"  />
</fuseaction>

<fuseaction name="search">
<invoke object="application.contentManager" methodcall="getPrivateSearch('#attributes.siteid#','#attributes.keywords#')" returnVariable="request.rsList" />
<set name="session.keywords" value="#attributes.keywords#"/>
<invoke object="application.utility" methodcall="getNextN(request.rsList,30,attributes.startrow)" returnVariable="request.nextn" />
<do action="vArch.ajax" contentvariable="fusebox.ajax"/>
<do action="vArch.search" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<!-- AJAX -->
<fuseaction name="siteParents">
<do action="vArch.siteParents" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

<fuseaction name="loadClass">
<do action="vArch.loadClass" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

<fuseaction name="loadNotify">
  <if condition="attributes.contentid eq ''">
		<true>
			<invoke object="application.contentManager" methodcall="getCrumbList(attributes.parentid,attributes.siteid)" returnVariable="request.crumbdata" />
	    </true>
		<false>
			<invoke object="application.contentManager" methodcall="getCrumbList(attributes.contentid,attributes.siteid)" returnVariable="request.crumbdata" />
	    </false>
	</if>
<do action="vArch.loadNotify" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

<fuseaction name="exportHtmlSite">
	<invoke object="application.contentManager" methodcall="exportHtmlSite(attributes.siteid)" />
	<do action="vArch.exportHtmlSite" contentvariable="fusebox.layout" />
	<do action="layout.display"/>
</fuseaction>

<fuseaction name="loadRelatedContent">
	<do action="vArch.loadRelatedContent" contentvariable="fusebox.layout"/>
	<do action="layout.empty"/>
</fuseaction>

<fuseaction name="loadExtendedAttributes">
	<do action="vArch.loadExtendedAttributes" contentvariable="fusebox.layout"/>
	<do action="layout.empty"/>
</fuseaction>

<fuseaction name="topRated">
	<invoke object="application.raterManager" methodcall="getTopRated(attributes.siteid,attributes.size)"  returnVariable="request.rsList"/>
	<invoke object="application.utility" methodcall="getNextN(request.rsList,30,attributes.startrow)" returnVariable="request.nextn" />
	<do action="vArch.topRated" contentvariable="fusebox.layout" />
	<do action="layout.display"/>
</fuseaction>

<fuseaction name="copy">
	<invoke object="application.contentManager" methodcall="copy(attributes.siteid,attributes.contentID,attributes.parentID)"  />
</fuseaction>

<fuseaction name="saveCopyInfo">
	<invoke object="application.contentManager" methodcall="saveCopyInfo(attributes.siteid,attributes.contentID)"  />
</fuseaction>

<fuseaction name="loadCategoryFeatureStartStop">
 <do action="vArch.loadCategoryFeatureStartStop" contentvariable="fusebox.layout"/>
 <do action="layout.empty"/>
</fuseaction>
 
</circuit>
