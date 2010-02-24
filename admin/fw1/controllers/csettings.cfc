<cfcomponent extends="controller" output="false">

<cffunction name="setPluginManager" output="false">
	<cfargument name="pluginManager">
	<cfset variables.pluginManager=arguments.pluginManager>
</cffunction>

<cffunction name="setPublisher" output="false">
	<cfargument name="publisher">
	<cfset variables.publisher=arguments.publisher>
</cffunction>

<cffunction name="setClusterManager" output="false">
	<cfargument name="clusterManager">
	<cfset variables.clusterManager=arguments.clusterManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfif not listFind(session.mura.memberships,'S2')>
		<cfset secure(rc)>
	</cfif>
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">
	<cfparam name="rc.orderID" default="" />
	<cfparam name="rc.orderno" default="" />
	<cfparam name="rc.deploy" default="" />
	<cfparam name="rc.action" default="" />
	<cfparam name="rc.siteid" default="" />
	
	<cfif rc.action eq 'deploy'>
		<cfset variables.settingsManager.publishSite(rc.siteid)  />
	</cfif>
	
	<cfset variables.settingsManager.saveOrder(rc.orderno,rc.orderID)  />
	<cfset variables.settingsManager.saveDeploy(rc.deploy,rc.orderID) />
	<cfset rc.rsSites=variables.settingsManager.getList() />
	<cfset rc.rsPlugins=variables.pluginManager.getAllPlugins() />
</cffunction>

<cffunction name="editSite" output="false">
	<cfargument name="rc">
	<cfset rc.siteBean=variables.settingsManager.read(rc.siteid) />
</cffunction>

<cffunction name="deletePlugin" output="false">
	<cfargument name="rc">
	<cfset variables.pluginManager.deletePlugin(rc.moduleID) />
	<cfset rc.activeTab=1>
	<cfset variables.fw.redirect(action="cSettings.list",append="activeTab",path="")>
</cffunction>

<cffunction name="editPlugin" output="false">
	<cfargument name="rc">
	<cfset rc.pluginXML=variables.pluginManager.getPluginXML(rc.moduleID) />
	<cfset rc.rsSites=variables.settingsManager.getList() />
</cffunction>

<cffunction name="updatePluginVersion" output="false">
	<cfargument name="rc">
	<cfset rc.pluginConfig=variables.pluginManager.getConfig(rc.moduleID) />
</cffunction>

<cffunction name="deployPlugin" output="false">
	<cfargument name="rc">
	<cfparam name="rc.moduleID" default="" />
	<cfset rc.moduleID=variables.pluginManager.deploy(rc.moduleID) />
	<cfset variables.fw.redirect(action="cSettings.editPlugin",append="moduleid",path="")>
</cffunction>

<cffunction name="updatePlugin" output="false">
	<cfargument name="rc">
	<cfset rc.moduleID=variables.pluginManager.updateSettings(rc) />
	<cfset rc.activeTab=1>
	<cfset variables.fw.redirect(action="cSettings.list",append="activeTab",path="")>
</cffunction>

<cffunction name="updateSite" output="false">
	<cfargument name="rc">
	<cfif rc.action eq 'Update'>
			<cfset variables.settingsManager.update(rc)  />
			<cfset variables.clusterManager.reload() />
	</cfif>
	<cfif rc.action eq 'Add'>
			<cfset variables.settingsManager.create(rc)  />
			<cfset variables.settingsManager.setSites()  />
			<cfset variables.clusterManager.reload() />
			<cfset session.userFilesPath = "#application.configBean.getAssetPath()#/#rc.siteid#/assets/">
			<cfset session.siteid=rc.siteid />
	</cfif>
	<cfif rc.action eq 'Delete'>
			<cfset variables.settingsManager.delete(rc.siteid)  />
			<cfset session.siteid="default" />
			<cfset session.userFilesPath = "#application.configBean.getAssetPath()#/default/assets/">
			<cfset rc.siteid="default"/>
	</cfif>
	<cfset variables.fw.redirect(action="cSettings.list",path="")>
</cffunction>

<cffunction name="sitecopyselect" output="false">
	<cfargument name="rc">
	<cfset rc.rsSites=variables.settingsManager.getList()>
</cffunction>

<cffunction name="sitecopy" output="false">
	<cfargument name="rc">
	<cfif rc.fromSiteID neq rc.toSiteID>
		<cfset variables.publisher.copy(fromSiteID=rc.fromSiteID,toSiteID=rc.toSiteID)>
	</cfif>
	<cfset variables.fw.redirect(action="cSettings.sitecopyresult",append="fromSiteID,toSiteID",path="")>
</cffunction>

</cfcomponent>