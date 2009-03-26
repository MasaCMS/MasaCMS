<circuit access="public">

<prefuseaction>
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="(not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000009','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>
<set name="attributes.startrow" value="1" overwrite="false" />
</prefuseaction>

<fuseaction name="list">
<invoke object="application.mailinglistManager" methodcall="getList(attributes.siteid)" returnVariable="request.rslist" />
<do action="vMailingList.list" contentvariable="fusebox.layout"/>

 </fuseaction>
 
<fuseaction name="edit">
<invoke object="application.mailinglistManager" methodcall="read(attributes.mlid,attributes.siteid)" returnVariable="request.listBean" />
<do action="vMailingList.edit" contentvariable="fusebox.layout"/>

 </fuseaction>
 
<fuseaction name="listmembers">
<invoke object="application.mailinglistManager" methodcall="read(attributes.mlid,attributes.siteid)" returnVariable="request.listBean" />
<invoke object="application.mailinglistManager" methodcall="getListMembers(attributes.mlid,attributes.siteid)" returnVariable="request.rslist" />
<invoke object="application.utility" methodcall="getNextN(request.rslist,30,attributes.startrow)" returnVariable="request.nextn" />
<do action="vMailingList.listmembers" contentvariable="fusebox.layout" />
</fuseaction>
 
<fuseaction name="update">
		<if condition="attributes.action eq 'add'">
		<true>
			<invoke object="application.mailinglistManager" methodcall="create(attributes)" returnVariable="listBean" />
			<set name="attributes.mlid" value="#listBean.getMLID()#" />
		</true>
		</if>
		
		<if condition="attributes.action eq 'update'">
		<true>
			<invoke object="application.mailinglistManager" methodcall="update(attributes)" />
		</true>
		</if>
		<if condition="attributes.action eq 'delete'">
			<true>
				<invoke object="application.mailinglistManager" methodcall="delete(attributes.mlid,attributes.siteid)" />
			</true>
		</if>
		
	<if condition="attributes.action eq 'delete'">
	<true>
	<relocate addtoken="false" url="index.cfm?fuseaction=cMailingList.list&amp;siteid=#attributes.siteid#"/>
	</true>
	<false>
	<relocate addtoken="false" url="index.cfm?fuseaction=cMailingList.listmembers&amp;mlid=#attributes.mlid#&amp;siteid=#attributes.siteid#"/>
	</false>
	</if>
 </fuseaction>
 
<fuseaction name="updatemember">
	<if condition="attributes.action eq 'add'">
		<true>
			<invoke object="application.mailinglistManager" methodcall="createMember(attributes)" />
		</true>
	</if>
		
	<if condition="attributes.action eq 'delete'">
		<true>
			<invoke object="application.mailinglistManager" methodcall="deleteMember(attributes)" />
		</true>
	</if>
	<relocate addtoken="false" url="index.cfm?fuseaction=cMailingList.listmembers&amp;mlid=#attributes.mlid#&amp;siteid=#attributes.siteid#"/>
</fuseaction>

<fuseaction name="download">
<invoke object="application.mailinglistManager" methodcall="read(attributes.mlid,attributes.siteid)" returnVariable="request.listBean" />
<invoke object="application.mailinglistManager" methodcall="getListMembers(attributes.mlid,attributes.siteid)" returnVariable="request.rslist" />
<do action="vMailingList.download" />
</fuseaction>
 
<postfuseaction>
	<if condition="myfusebox.originalfuseaction neq 'download'">
		<true>
			<do action="layout.display"/>
		</true>
	</if>
</postfuseaction>

</circuit>