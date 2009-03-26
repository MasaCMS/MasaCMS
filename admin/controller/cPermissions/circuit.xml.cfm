<circuit access="public">

<prefuseaction>
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>
</prefuseaction>

<fuseaction name="Update">
<invoke object="application.permUtility" methodcall="update(attributes)"  />
<relocate url="index.cfm?fuseaction=cArch.list&amp;siteid=#attributes.siteid#&amp;moduleid=#attributes.moduleid#&amp;startrow=#attributes.startrow#&amp;topid=#attributes.topid#" addtoken="false"/>
</fuseaction>
	 
<fuseaction name="UpdateGroup">
<invoke object="application.permUtility" methodcall="updateGroup(attributes)"  />
<relocate addtoken="false" url="index.cfm?fuseaction=cPrivateUsers.list&amp;siteid=#attributes.siteid#"/>
</fuseaction>

<fuseaction name="main">
<invoke object="application.permUtility" methodcall="getcontent(attributes)" returnVariable="request.rsContent" />
<do action="vPerm.main" contentvariable="fusebox.layout"/>
</fuseaction> 
	
<fuseaction name="module">
<invoke object="application.permUtility" methodcall="getGrouplist(attributes)" returnVariable="request.groups" />
<invoke object="application.permUtility" methodcall="getModule(attributes)" returnVariable="request.rsContent" />
<do action="vPerm.module" contentvariable="fusebox.layout" />
</fuseaction> 
		
<fuseaction name="updatemodule">
<invoke object="application.permUtility" methodcall="updateModule(attributes)" />
	<if condition="attributes.moduleid eq '00000000000000000000000000000000004'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cPrivateUsers.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </true>
	 </if>
	 <if condition="attributes.moduleid eq '00000000000000000000000000000000005'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cEmail.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </true>
	 </if>
	 <if condition="attributes.moduleid eq '00000000000000000000000000000000007'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cForm.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </true>
	 </if>
	 <if condition="attributes.moduleid eq '00000000000000000000000000000000008'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cPublicUsers.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </true>
	 </if>
	 <if condition="attributes.moduleid eq '00000000000000000000000000000000009'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cMailingList.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </true>
	 </if>
	  <if condition="attributes.moduleid eq '00000000000000000000000000000000000'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cArch.list&amp;siteid=#attributes.siteid#&amp;moduleid=00000000000000000000000000000000000&amp;topid=00000000000000000000000000000000001" addtoken="false"/>
		  </true>
	 </if>
	  <if condition="attributes.moduleid eq '00000000000000000000000000000000006'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cAdvertising.listAdvertisers&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </true>
	 </if>
	  <if condition="attributes.moduleid eq '00000000000000000000000000000000010'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cCategory.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </true>
	 </if>
	 <if condition="attributes.moduleid eq '00000000000000000000000000000000011'">
		  <true>
		  <relocate url="index.cfm?fuseaction=cFeed.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
		  </true>
	 </if>
	 <relocate url="index.cfm?fuseaction=cPlugins.list&amp;siteid=#attributes.siteid#" addtoken="false"/>
</fuseaction>

<postfuseaction>
<do action="layout.display"/>
</postfuseaction>

</circuit>