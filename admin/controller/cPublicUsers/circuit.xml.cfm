<circuit access="public">

<prefuseaction>

<set name="attributes.siteID" value="default" overwrite="false" />

<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="(not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000008','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>

<set name="request.error" value="#structnew()#" overwrite="false" />
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.userid" value="" overwrite="false" />
<set name="attributes.routeid" value="" overwrite="false" />
<set name="attributes.categoryid" value="" overwrite="false" />
<set name="attributes.search" value="" overwrite="false" />
<set name="attributes.newSearch" value="false" overwrite="false" />

<if condition="attributes.userid eq ''">
<true>
  	<set name="attributes.Action" value="Add" overwrite="false" />
</true>
<false>
  <set name="attributes.Action" value="Update" overwrite="false" />
</false>
</if>

</prefuseaction>

<fuseaction name="list">
<invoke object="application.userManager" methodcall="getUserGroups('#attributes.siteid#',1)" returnVariable="request.rsGroups" />
<do action="vPublicUsers.list" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>
	
<fuseaction name="editgroup">
<if condition="not isdefined('request.userBean')">
	<true>
		<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
	</true>
</if>
<invoke object="application.userManager" methodcall="readGroupMemberships(attributes.userid)" returnVariable="request.rsGroupList" />
<invoke object="application.utility" methodcall="getNextN(request.rsGroupList,15,attributes.startrow)" returnVariable="request.nextn" />
<do action="vPublicUsers.editgroup" contentvariable="fusebox.layout" />
<do action="layout.display"/>
</fuseaction>
	
<fuseaction name="addtogroup">
<invoke object="application.userManager" methodcall="createUserInGroup(attributes.userid,attributes.groupid)" />
<do action="cPublicUsers.route"/>
</fuseaction>

<fuseaction name="removefromgroup">
<invoke object="application.userManager" methodcall="deleteUserFromGroup(attributes.userid,attributes.groupid)" />
<do action="cPublicUsers.route"/>
</fuseaction>
	

<fuseaction name="route">
<if condition="attributes.routeid eq ''">
	<true>
		<relocate url="index.cfm?fuseaction=cPublicUsers.list&amp;siteid=#attributes.siteid#" />
	</true>
</if>
<if condition="attributes.routeid eq 'adManager' and attributes.action neq 'delete'">
	<true>
		<relocate url="index.cfm?fuseaction=cAdvertising.viewAdvertiser&amp;siteid=#attributes.siteid#&amp;userid=#attributes.userid#" />
	</true>
</if>
<if condition="attributes.routeid eq 'adManager' and attributes.action eq 'delete'">
	<true>
		<relocate url="index.cfm?fuseaction=cAdvertising.listAdvertisers&amp;siteid=#attributes.siteid#" />
	</true>
</if>
<if condition="attributes.routeid neq '' and attributes.routeid neq 'adManager'">
	<true>
		<relocate url="index.cfm?fuseaction=cPublicUsers.editgroup&amp;userid=#attributes.routeid#&amp;siteid=#attributes.siteid#" />
	</true>
</if>
</fuseaction>
	
<fuseaction name="search">
<invoke object="application.userManager" methodcall="getSearch(attributes.search,attributes.siteid,1)" returnVariable="request.rslist" />
<if condition="request.rslist.recordcount eq 1">
	<true>
		<relocate url="index.cfm?fuseaction=cPublicUsers.editUser&amp;userid=#request.rslist.userid#&amp;siteid=#attributes.siteid#" />
</true>
</if>
<invoke object="application.utility" methodcall="getNextN(request.rsList,15,attributes.startrow)" returnVariable="request.nextn" />
<do action="vPublicUsers.search" contentvariable="fusebox.layout" />
<do action="layout.display"/>
</fuseaction>

<fuseaction name="advancedSearch">
<invoke object="application.userManager" methodcall="getPublicGroups('#attributes.siteid#',1)" returnVariable="request.rsGroups" />
<do action="vPublicUsers.advancedSearch" contentvariable="fusebox.layout" />
<do action="vPublicUsers.ajax" contentvariable="fusebox.ajax"/>
<do action="layout.display"/>
</fuseaction>
	
<fuseaction name="edituser">
<if condition="not isdefined('request.userBean')">
	<true>
		<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
	</true>
</if>
<invoke object="application.userManager" methodcall="getPublicGroups(attributes.siteid)" returnVariable="request.rsPublicGroups" />
<do action="vPublicUsers.edituser" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="editAddress">
<if condition="not isdefined('request.userBean')">
	<true>
		<invoke object="application.userManager" methodcall="read(attributes.userid)" returnVariable="request.userBean" />
	</true>
</if>
<do action="vPublicUsers.editAddress" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="update">
	
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="application.userManager" methodcall="update(attributes)" returnVariable="request.userBean" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="application.userManager" methodcall="delete(attributes.userid,attributes.type)" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="application.userManager" methodcall="create(attributes)" returnVariable="request.userBean" /> 
	  </true>
	  </if> 
	  
	  <if condition="attributes.action eq 'Add' and structIsEmpty(request.userBean.getErrors())">
	  <true>
	   	<set name="attributes.userid" value="#request.userBean.getUserID()#" />
	  </true>
	   </if>
	 
	   <if condition="(attributes.action neq 'delete' and structIsEmpty(request.userBean.getErrors())) or attributes.action eq 'delete'">
	  <true>
	    <do action="cPublicUsers.route"/>
	  </true>
	   </if>
	 
	  <if condition="attributes.action neq 'delete' and not structIsEmpty(request.userBean.getErrors()) and attributes.type eq 1"> 
	 <true>
	    <do action="cPublicUsers.editgroup"/>
	  </true>
	  </if>
	  
	    <if condition="attributes.action neq 'delete' and not structIsEmpty(request.userBean.getErrors()) and attributes.type eq 2"> 
	 <true>
	    <do action="cPublicUsers.edituser"/>
	  </true>
	  </if>
</fuseaction>
	
<fuseaction name="updateAddress">
	
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="application.userManager" methodcall="updateAddress(attributes)" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="application.userManager" methodcall="deleteAddress(attributes.addressid)" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="application.userManager" methodcall="createAddress(attributes)" /> 
	  </true>
	  </if>
	  
	  <relocate url="index.cfm?fuseaction=cPublicUsers.editUser&amp;siteid=#attributes.siteid#&amp;userID=#attributes.UserID#&amp;routeid=#attributes.routeID#&amp;activeTab=1" />
	
	
</fuseaction>

<fuseaction name="loadExtendedAttributes">
	<do action="vPublicUsers.loadExtendedAttributes" contentvariable="fusebox.layout"/>
	<do action="layout.empty"/>
</fuseaction>
</circuit>