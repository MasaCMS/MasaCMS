<circuit access="public">

<prefuseaction>
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="(not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not ( application.permUtility.getModulePerm('00000000000000000000000000000000005','#attributes.siteid#') and application.permUtility.getModulePerm('00000000000000000000000000000000000','#attributes.siteid#'))">
	<true>
		<invoke object="application.utility" methodcall="backUp()" />
	</true>
</if>

<set name="Session.moduleid" value="00000000000000000000000000000000005"/>
</prefuseaction>


<fuseaction name="list"> 
<invoke object="application.emailManager" methodcall="getList(attributes)" returnVariable="request.rsList" />
<invoke object="application.emailManager" methodcall="getPrivateGroups(attributes.siteid)" returnVariable="request.rsPrivateGroups" />
<invoke object="application.emailManager" methodcall="getPublicGroups(attributes.siteid)" returnVariable="request.rsPublicGroups" />
<invoke object="application.emailManager" methodcall="getMailingLists(attributes.siteid)" returnVariable="request.rsMailingLists" />
<do action="vEmail.ajax" contentvariable="fusebox.ajax"/>
<do action="vEmail.list" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>
	
<fuseaction name="Edit">
<invoke object="application.emailManager" methodcall="read(attributes.emailid)" returnVariable="request.emailBean" />
<invoke object="application.emailManager" methodcall="getPrivateGroups(attributes.siteid)" returnVariable="request.rsPrivateGroups" />
<invoke object="application.emailManager" methodcall="getPublicGroups(attributes.siteid)" returnVariable="request.rsPublicGroups" />
<invoke object="application.emailManager" methodcall="getMailingLists(attributes.siteid)" returnVariable="request.rsMailingLists" />
<do action="vEmail.ajax" contentvariable="fusebox.ajax"/>
<do action="vEmail.edit" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>
	
<fuseaction name="update">
<invoke object="application.emailManager" methodcall="update(attributes)" />
<relocate addtoken="false" url="index.cfm?fuseaction=cEmail.list&amp;siteid=#attributes.siteid#"/>
</fuseaction>

<fuseaction name="sendEmails">
<invoke object="application.emailManager" methodcall="send()"  />
</fuseaction>

<fuseaction name="showBounces"> 
<invoke object="application.emailManager" methodcall="getBounces(attributes.emailid)" returnVariable="request.rsBounces" />
<do action="vEmail.showBounces" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="showReturns"> 
<invoke object="application.emailManager" methodcall="getReturns(attributes.emailid)" returnVariable="request.rsReturns" />
<invoke object="application.emailManager" methodcall="getReturnsByUser(attributes.emailid)" returnVariable="request.rsReturnsByUser" />
<do action="vEmail.ajax" contentvariable="fusebox.ajax"/>
<do action="vEmail.showReturns" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="showAllBounces"> 
<invoke object="application.emailManager" methodcall="getAllBounces(attributes)" returnVariable="request.rsBounces" />
<do action="vEmail.ajax" contentvariable="fusebox.ajax"/>
<do action="vEmail.showBounces" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="deleteBounces"> 
<invoke object="application.emailManager" methodcall="deleteBounces(attributes)" />
<relocate addtoken="false" url="index.cfm?fuseaction=cEmail.list&amp;siteid=#attributes.siteid#"/>
</fuseaction>

<fuseaction name="download"> 
<do action="vEmail.download"/>
</fuseaction>
   
</circuit>
