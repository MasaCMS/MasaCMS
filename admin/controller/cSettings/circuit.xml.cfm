<circuit access="public">

<prefuseaction>
<if condition="not isUserInRole('S2IsPrivate')">
	<true>
		<relocate url="index.cfm?fuseaction=cLogin.main&amp;returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false"/>
	</true>
</if>
<if condition="not isUserInRole('S2')">
	<true>
		<relocate url="index.cfm" addtoken="false"/>
	</true>
</if>
</prefuseaction>


<fuseaction name="list">
<set name="attributes.orderID" value="" overwrite="false" />
<set name="attributes.orderno" value="" overwrite="false" />
<set name="attributes.deploy" value="" overwrite="false" />
<set name="attributes.action" value="" overwrite="false" />
<set name="attributes.siteid" value="" overwrite="false" />

<if condition="attributes.action eq 'deploy'">
	<true>
	<invoke object="application.settingsManager" methodcall="publishSite(attributes.siteid)"  />
	</true>
</if>

<invoke object="application.settingsManager" methodcall="saveOrder(attributes.orderno,attributes.orderID)"  />
<invoke object="application.settingsManager" methodcall="saveDeploy(attributes.deploy,attributes.orderID)" />
<invoke object="application.settingsManager" methodcall="getList()" returnVariable="request.rsSites" />
<invoke object="application.pluginManager" methodcall="getAllPlugins()" returnVariable="request.rsPlugins" />
<do action="vSettings.list" contentvariable="fusebox.layout"/>
</fuseaction>

<fuseaction name="editSite">
<invoke object="application.settingsManager" methodcall="read(attributes.siteid)" returnVariable="request.siteBean" />
<do action="vSettings.editSite" contentvariable="fusebox.layout"/>
</fuseaction>

<fuseaction name="deletePlugin">
<invoke object="application.pluginManager" methodcall="deletePlugin(attributes.moduleID)" />
<relocate url="index.cfm?fuseaction=cSettings.list&amp;activeTab=1" addtoken="false"/>
</fuseaction>

<fuseaction name="editPlugin">
<invoke object="application.pluginManager" methodcall="getPluginXML(attributes.moduleID)" returnVariable="request.pluginXML" />
<invoke object="application.settingsManager" methodcall="getList()" returnVariable="request.rsSites" />
<do action="vSettings.editPlugin" contentvariable="fusebox.layout"/>
</fuseaction>

<fuseaction name="updatePluginVersion">
<invoke object="application.pluginManager" methodcall="getConfig(attributes.moduleID)" returnVariable="request.pluginConfig" />
<do action="vSettings.updatePluginVersion" contentvariable="fusebox.layout"/>
</fuseaction>

<fuseaction name="deployPlugin">
<set name="attributes.moduleID" value="" overwrite="false" />
<invoke object="application.pluginManager" methodcall="deploy(attributes.moduleID)" returnVariable="request.moduleID" />
<relocate url="index.cfm?fuseaction=cSettings.editPlugin&amp;moduleID=#request.moduleID#" addtoken="false"/>
</fuseaction>

<fuseaction name="updatePlugin">
<invoke object="application.pluginManager" methodcall="updateSettings(attributes)" returnVariable="request.moduleID" />
<relocate url="index.cfm?fuseaction=cSettings.list&amp;activeTab=1" addtoken="false"/>
</fuseaction>


<fuseaction name="updateSite">
	<if condition="attributes.action eq 'Update'">
		<true>
			<invoke object="application.settingsManager" methodcall="update(attributes)"  />
			<invoke object="application.clusterManager" methodcall="reload()" />
		</true>
	</if>
	<if condition="attributes.action eq 'Add'">
		<true>
			<invoke object="application.settingsManager" methodcall="create(attributes)"  />
			<invoke object="application.settingsManager" methodcall="setSites()"  />
			<invoke object="application.clusterManager" methodcall="reload()" />
		</true>
	</if>
	<if condition="attributes.action eq 'Delete'">
		<true>
			<invoke object="application.settingsManager" methodcall="delete(attributes.siteid)"  />
			<set name="session.siteid" value="default" overwrite="true" />
			<set name="attributes.siteid" value="default" overwrite="true" />
		</true>
	</if>
<relocate url="index.cfm?fuseaction=cSettings.list" addtoken="false"/>
</fuseaction>
	
<postfuseaction>
<do action="layout.display"/>
</postfuseaction>

</circuit>
