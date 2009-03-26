<circuit access="public">

<prefuseaction>
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="(not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000010','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>
<set name="attributes.startrow" value="1" overwrite="false" />
<set name="attributes.keywords" value="" overwrite="false" />
</prefuseaction>

<fuseaction name="list">
<do action="vCategory.ajax" contentvariable="fusebox.ajax"/>
<do action="vCategory.list" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="edit">
<invoke object="application.contentUtility" methodcall="getRestrictGroups(attributes.siteid)" returnVariable="request.rsRestrictGroups" />
<invoke object="application.categoryManager" methodcall="read(attributes.categoryID)" returnVariable="request.categoryBean" />
<!--<invoke object="application.categoryManager" methodcall="getCategoryFeatures(attributes.categoryID)" returnVariable="request.rslist" />-->
<do action="vCategory.ajax" contentvariable="fusebox.ajax"/>
<do action="vCategory.edit" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>


<fuseaction name="update">
	
	  <if condition="attributes.action eq 'Update'">
	  <true>
	  	<invoke object="application.categoryManager" methodcall="update(attributes)" returnVariable="request.categoryBean" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Delete'">
	  <true>
	  	<invoke object="application.categoryManager" methodcall="delete(attributes.categoryid)" />
	  </true>
	  </if>
  
	  <if condition="attributes.action eq 'Add'">
	  <true>
	  	<invoke object="application.categoryManager" methodcall="create(attributes)" returnVariable="request.categoryBean" /> 
	  </true>
	  </if> 
	  
	  <if condition="attributes.action eq 'Add' and structIsEmpty(request.categoryBean.getErrors())">
	  <true>
	   	<set name="attributes.categoryid" value="#request.categoryBean.getCategoryID()#" />
	  </true>
	   </if>
	 
	  <if condition="attributes.action neq  'delete' and not structIsEmpty(request.categoryBean.getErrors())">
	  <true>
	  	<do action="cCategory.edit"/>
	  </true>
	  <false>
	  	<relocate url="index.cfm?fuseaction=cCategory.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
	  </false>
	  </if>
</fuseaction>

</circuit>
