<circuit access="public">

<prefuseaction>
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="not application.settingsManager.getSite(attributes.siteid).getHasfeedManager() or (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000011','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.keywords" value="" overwrite="false" />
<set name="attributes.categoryID" value="" overwrite="false" />
<set name="attributes.contentID" value="" overwrite="false" />
<set name="attributes.restricted" value="0" overwrite="false" />
<set name="attributes.closeCompactDisplay" value="" overwrite="false" />
<set name="attributes.compactDisplay" value="" overwrite="false" />
<set name="attributes.homeID" value="" overwrite="false" />
</prefuseaction>

<fuseaction name="list">
<invoke object="application.feedManager" methodcall="getFeeds(attributes.siteID,'Local')" returnVariable="request.rsLocal" />
<invoke object="application.feedManager" methodcall="getFeeds(attributes.siteID,'Remote')" returnVariable="request.rsRemote" />
<do action="vFeed.list" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="edit">
<invoke object="application.contentUtility" methodcall="getRestrictGroups(attributes.siteid)" returnVariable="request.rsRestrictGroups" />
<invoke object="application.feedManager" methodcall="read(attributes.feedID)" returnVariable="request.feedBean" />
<invoke object="application.feedManager" methodcall="getcontentItems(attributes.feedID,request.feedBean.getcontentID())" returnVariable="request.rslist" />
<do action="vFeed.ajax" contentvariable="fusebox.ajax"/>
<do action="vFeed.edit" contentvariable="fusebox.layout"/>

<if condition="attributes.compactDisplay eq 'true'">
	<true>
		<do action="layout.compact"/>
	</true>
	<false>
		<do action="layout.display"/>
	</false>
</if>

</fuseaction>


<fuseaction name="update">
	
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="application.feedManager" methodcall="update(attributes)" returnVariable="request.feedBean" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="application.feedManager" methodcall="delete(attributes.feedID)" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="application.feedManager" methodcall="create(attributes)" returnVariable="request.feedBean" /> 
	  </true>
	  </if> 
	  
	  <if condition="attributes.action eq 'Add' and structIsEmpty(request.feedBean.getErrors())">
	  <true>
	   	<set name="attributes.feedID" value="#request.feedBean.getfeedID()#" />
	  </true>
	   </if>
	 
	  <if condition="attributes.closeCompactDisplay eq 'true'">
		<true>
			<do action="vFeed.closeCompactDisplay" contentvariable="fusebox.layout" />
			<do action="layout.empty" />
		</true>
		<false>
		  <if condition="attributes.action neq  'delete' and not structIsEmpty(request.feedBean.getErrors())">
		  <true>
			<do action="cFeed.edit"/>
		  </true>
		  <false>
			<relocate url="index.cfm?fuseaction=cFeed.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </false>
		  </if>
		 </false>
		</if>
</fuseaction>

<!-- AJAX -->
<fuseaction name="loadSite">
<do action="vFeed.loadSite" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

<!-- AJAX -->
<fuseaction name="siteParents">
<do action="vFeed.siteParents" contentvariable="fusebox.layout"/>
<do action="layout.empty"/>
</fuseaction>

<fuseaction name="import1">
<do action="vFeed.import1" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="import2">
<invoke object="application.feedManager" methodcall="import(attributes)" returnVariable="request.import" />
<do action="vFeed.import2" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

</circuit>
