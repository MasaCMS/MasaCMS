<circuit access="public">

<prefuseaction>
<set name="attributes.siteid" value="#session.siteid#"/>

<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')">
	<true>
		<relocate url="index.cfm" addtoken="false"/>
	</true>
</if>
</prefuseaction>

<fuseaction name="default">
<do action="cFilemanager.render" contentvariable="fusebox.layout"/>
<do action="layout.display"/>
</fuseaction>

<fuseaction name="render">
<include template="render.cfm"/>
</fuseaction>

</circuit>
