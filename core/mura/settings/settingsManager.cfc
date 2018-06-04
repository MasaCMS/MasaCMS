<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
Mura CMS under the license of your choice, provided that you follow these specific guidelines:

Your custom code

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

	/admin/
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provides site service level logic functionality">

<cffunction name="init" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="settingsGateway" type="any" required="yes"/>
<cfargument name="settingsDAO" type="any" required="yes"/>
<cfargument name="clusterManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.utility=arguments.utility />
		<cfset variables.Gateway=arguments.settingsGateway />
		<cfset variables.DAO=arguments.settingsDAO />
		<cfset variables.clusterManager=arguments.clusterManager />
		<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
		<cfset setSites() />
<cfreturn this />
</cffunction>

<cffunction name="validate" output="false">
	<cfreturn isObject(variables.configBean)
	and isObject(variables.utility)
	and isObject(variables.Gateway)
	and isObject(variables.DAO)
	and isObject(variables.clusterManager)
	and isObject(variables.classExtensionManager)
	and isDefined('variables.sites')
	and not structIsEmpty(variables.sites)>
</cffunction>

<cffunction name="getBean" output="false">
	<cfargument name="beanName" default="site">
	<cfreturn super.getBean(arguments.beanName)>
</cffunction>

<cffunction name="getList" output="false">
	<cfargument name="sortBy" default="orderno">
	<cfargument name="sortDirection" default="asc">
	<cfargument name="cached" default="true" />

	<cfset var rs = variables.gateway.getList(arguments.sortBy,arguments.sortDirection,arguments.cached) />

	<cfreturn rs />

</cffunction>

<cffunction name="publishSite" output="false">
	<cfargument name="siteID" required="yes" default="">
	<cfset var bundleFileName = "">
	<cfset var authToken = "">
	<cfset var i = "">
	<cfset var serverArgs = structNew()>
	<cfset var rsPlugins = getBean("pluginManager").getSitePlugins(arguments.siteID)>
	<cfset var result="">
	<cfif variables.configBean.getValue('deployMode') eq "bundle">
		<cfset bundleFileName = getBean("Bundle").Bundle(
			siteID=arguments.siteID,
			moduleID=ValueList(rsPlugins.moduleID),
			BundleName='deployBundle',
			includeVersionHistory=false,
			includeTrash=false,
			includeMetaData=true,
			includeMailingListMembers=false,
			includeUsers=false,
			includeFormData=false,
			saveFile=true) />

		<cfloop list="#variables.configBean.getServerList()#" index="i" delimiters="^">
			<cfset serverArgs = deserializeJSON(i)>
			<cfset result = pushBundle(siteID, bundleFileName, serverArgs)>
		</cfloop>

		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			update tsettings set lastDeployment = #createODBCDateTime(now())#
			where siteID = <cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.siteID#">
		</cfquery>

		<cfset fileDelete(bundleFileName)>
	<cfelse>
		<cfset getBean("publisher").start(arguments.siteid) />
	</cfif>
	<cfset variables.clusterManager.reload() />

</cffunction>

<cffunction name="pushBundle" output="no">
	<cfargument name="siteID" required="yes" default="">
	<cfargument name="bundleFileName" required="yes">
	<cfargument name="serverArgs" required="yes">
	<cfset var bundleArgs = structNew()>
	<cfset var result = "">
	<cfset var authToken="">
	<cfinvoke webservice="#serverArgs.serverURL#?wsdl"
		method="login"
		returnVariable="authToken">
		<cfinvokeargument name="username" value="#serverArgs.username#">
		<cfinvokeargument name="password" value="#serverArgs.password#">
		<cfinvokeargument name="siteID" value="#serverArgs.siteID#">
	</cfinvoke>

	<cfset bundleArgs.siteID = arguments.siteID />
	<cfset bundleArgs.bundleImportKeyMode = "publish">

	<cfif serverArgs.deployMode eq "files">
		<!--- push just files --->
		<cfset bundleArgs.bundleImportContentMode = "none">
	<cfelse>
		<!--- files and content --->
		<cfset bundleArgs.bundleImportContentMode = "all">
	</cfif>

	<cfset bundleArgs.bundleImportRenderingMode = "all">
	<cfset bundleArgs.bundleImportPluginMode = "all">
	<cfset bundleArgs.bundleImportMailingListMembersMode = "none">
	<cfset bundleArgs.bundleImportUsersMode = "none">
	<cfset bundleArgs.bundleImportLastDeployment = "">
	<cfset bundleArgs.bundleImportModuleID = "">
	<cfset bundleArgs.bundleImportFormDataMode = "none">

	<cfhttp attributeCollection='#getHTTPAttrs(method="post",url="#serverArgs.serverURL#")#'>
		<cfhttpparam name="method" type="url" value="call">
		<cfhttpparam name="serviceName" type="url" value="bundle">
		<cfhttpparam name="methodName" type="url" value="deploy">
		<cfhttpparam name="authToken" type="url" value="#authToken#">
		<cfhttpparam name="args" type="url" value="#serializeJSON(bundleArgs)#">
		<cfhttpparam name="bundleFile" type="file" file="#bundleFileName#">
	</cfhttp>

	<cfif cfhttp.FileContent contains "success">
		<cfset result = "Deployment Successful">
	<cfelse>
		<cfset result = cfhttp.FileContent>
	</cfif>

	<cfreturn result>
</cffunction>

<cffunction name="saveOrder" output="false">
<cfargument name="orderno" required="yes" default="">
<cfargument name="orderID" required="yes" default="">

<cfset var i=0/>

	<cfif arguments.orderID neq ''>
		<cfloop from="1" to="#listlen(arguments.orderid)#" index="i">
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tsettings set orderno= #listgetat(arguments.orderno,i)# where siteid ='#listgetat(arguments.orderid,i)#'
		</cfquery>
		</cfloop>
	</cfif>

	<cfset variables.gateway.getList(cached=false)>

</cffunction>

<cffunction name="saveDeploy" output="false">
<cfargument name="deploy" required="yes" default="">
<cfargument name="orderID" required="yes" default="">
 <cfset var i=0/>
	<cfif arguments.deploy neq '' and arguments.orderID neq ''>
		<cfloop from="1" to="#listlen(arguments.orderid)#" index="i">
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tsettings set deploy= #listgetat(arguments.deploy,i)# where siteid ='#listgetat(arguments.orderid,i)#'
		</cfquery>
		</cfloop>
	</cfif>

</cffunction>

<cffunction name="read" output="false">
<cfargument name="siteid" type="string" />
<cfargument name="settingsBean" default=""> />
	<cfreturn variables.DAO.read(arguments.siteid,arguments.settingsBean) />

</cffunction>

<cffunction name="update" output="false">
	<cfargument name="data" type="struct" />
	<cfset var bean=variables.DAO.read(arguments.data.SiteID) />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />

	<cfset bean.set(arguments.data) />
	<cfset pluginEvent.setValue('settingsBean',bean)>

	<cfset bean.setModuleID("00000000000000000000000000000000000")>
	<cfset bean.validate()>

	<cfset getBean('pluginManager').announceEvent("onBeforeSiteUpdate",pluginEvent)>
	<cfset getBean('pluginManager').announceEvent("onBeforeSiteSave",pluginEvent)>

	<cfif structIsEmpty(bean.getErrors())>
		<cfset variables.utility.logEvent("SiteID:#bean.getSiteID()# Site:#bean.getSite()# was updated","mura-settings","Information",true) />
		<cfif structKeyExists(arguments.data,"extendSetID") and len(arguments.data.extendSetID)>
			<cfset variables.classExtensionManager.saveExtendedData(bean.getBaseID(),bean.getAllValues())/>
		</cfif>

		<cfset bean.getRazunaSettings().set(arguments.data).save()>

		<cfif len(bean.getNewPlaceholderImg())>
			<cfif len(bean.getPlaceholderImgId())>
				<cfset getBean('fileManager').deleteIfNotUsed(bean.getPlaceholderImgId(),'')>
			</cfif>

			<cfset local.fileBean=getBean('file')>
			<cfset local.fileBean.setSiteID(bean.getSiteID())>
			<cfset local.fileBean.setModuleID('')>
			<cfset local.fileBean.setFileField('newPlaceholderImg')>
			<cfset local.fileBean.setNewFile(bean.getNewPlaceholderImg())>
			<cfset local.fileBean.save()>
			<cfset bean.setPlaceholderImgID(local.fileBean.getFileID()) />
			<cfset bean.setPlaceholderImgExt(local.fileBean.getFileExt()) />
		<cfelseif len(bean.getDeletePlaceholderImg())>
			<cfset getBean('fileManager').deleteIfNotUsed(bean.getPlaceholderImgId(),'')>
			<cfset bean.setPlaceholderImgID('') />
			<cfset bean.setPlaceholderImgExt('') />
		</cfif>

		<cfset variables.DAO.update(bean) />
		<cfset validateDisplayPool(bean) />
		<cfset checkForBundle(arguments.data,bean.getErrors())>
		<cfset setSites() />
		<cfset application.appInitialized=false>

		<cfset getBean('pluginManager').announceEvent("onAfterSiteUpdate",pluginEvent)>
		<cfset getBean('pluginManager').announceEvent("onAfterSiteSave",pluginEvent)>
	</cfif>

	<cfreturn bean />

</cffunction>

<cffunction name="delete" output="false">
	<cfargument name="siteid" type="string" />

	<cfset var bean=read(arguments.siteid) />
	<cfset var pluginEvent = createObject("component","mura.event") />
	<cfset var data={sited=arguments.siteid,settingsBean=bean}>
	<cfset pluginEvent.init(data)>

	<cfset getBean('pluginManager').announceEvent("onBeforeSiteDelete",pluginEvent)>

	<cfset bean.getRazunaSettings().delete()>

	<cfset variables.utility.logEvent("SiteID:#arguments.siteid# Site:#bean.getSite()# was deleted","mura-settings","Information",true) />
	<cfset variables.DAO.delete(arguments.siteid) />
	<cfset setSites() />
	<cfset application.appInitialized=false>
	<cftry>
	<cfset variables.utility.deleteDir("#variables.configBean.getSiteDir()#/#arguments.siteid#/") />
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
	<cfset variables.utility.deleteDir("#variables.configBean.getFileDir()#/#arguments.siteid#/") />
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
	<cfset variables.utility.deleteDir("#variables.configBean.getAssetDir()#/#arguments.siteid#/") />
	<cfcatch></cfcatch>
	</cftry>

	<cfset getBean('pluginManager').announceEvent("onAfterSiteDelete",pluginEvent)>

</cffunction>

<cffunction name="create" output="false">
	<cfargument name="data" type="struct" />
	<cfset var rs=""/>
	<cfset var bean=getBean("settingsBean") />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />

	<cfset bean.set(arguments.data) />
	<cfset pluginEvent.setValue('settingsBean',bean)>
	<cfset bean.setModuleID("00000000000000000000000000000000000")>
	<cfset bean.validate()>

	<cfset getBean('pluginManager').announceEvent("onBeforeSiteCreate",pluginEvent)>
	<cfset getBean('pluginManager').announceEvent("onBeforeSiteSave",pluginEvent)>

	<cfif structIsEmpty(bean.getErrors()) and  bean.getSiteID() neq ''>

		<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select siteid from tsettings where siteid='#bean.getSiteID()#'
		</cfquery>

		<cfif rs.recordcount>
			<cfparam name="arguments.data.autocreated" default="false">
			<cfif isBoolean(arguments.data.autocreated) and arguments.data.autocreated>
				<cfreturn>
			<cfelse>
				<cfthrow message="The SiteID you entered is already being used.">
				<cfabort>
			</cfif>
		</cfif>

		<cfif directoryExists("#variables.configBean.getSiteDir()#/#bean.getSiteID()#")>
			<cfthrow message="A directory with the same name as the SiteID you entered is already being used.">
		</cfif>

		<cfset variables.utility.logEvent("SiteID:#bean.getSiteID()# Site:#bean.getSite()# was created","mura-settings","Information",true) />
		<cfif structKeyExists(arguments.data,"extendSetID") and len(arguments.data.extendSetID)>
			<cfset variables.classExtensionManager.saveExtendedData(bean.getBaseID(),bean.getAllValues())/>
		</cfif>
		<cfset bean.getRazunaSettings().set(arguments.data).save()>

			<cfif len(bean.getNewPlaceholderImg())>
				<cfset local.fileBean=getBean('file')>
				<cfset local.fileBean.setSiteID(bean.getSiteID())>
				<cfset local.fileBean.setModuleID('')>
				<cfset local.fileBean.setFileField('newPlaceholderImg')>
				<cfset local.fileBean.setNewFile(bean.getNewPlaceholderImg())>
				<cfset local.fileBean.save()>
				<cfset bean.setPlaceholderImgID(local.fileBean.getFileID()) />
				<cfset bean.setPlaceholderImgExt(local.fileBean.getFileExt()) />
			</cfif>

		<cfset variables.DAO.create(bean) />

		<cfset var fileDelim=variables.configBean.getFileDelim()>

		<cfset validateDisplayPool(bean) />

		<cfif variables.configBean.getCreateRequiredDirectories()>
			<cfset variables.utility.createRequiredSiteDirectories(bean.getSiteID(),bean.getDisplayPoolID()) />
		</cfif>

		<cfset checkForBundle(arguments.data,bean.getErrors())>
		<cfset setSites() />
		<cfset application.appInitialized=false>

		<cfset getBean('pluginManager').announceEvent("onAfterSiteCreate",pluginEvent)>
		<cfset getBean('pluginManager').announceEvent("onAfterSiteSave",pluginEvent)>
	</cfif>

	<cfreturn bean />
</cffunction>

<cffunction name="validateDisplayPool" output="false">
	<cfargument name="bean" required="true" >

	<cfset var fileDelim=variables.configBean.getFileDelim()>

	<cfif bean.getSiteID() eq bean.getDisplayPoolID() and !directoryExists('#variables.configBean.getSiteDir()##fileDelim##bean.getSiteID()##fileDelim#')>

		<cfset variables.utility.copyDir(
				baseDir="#variables.configBean.getSiteDir()##fileDelim#default#fileDelim#",
				destDir="#variables.configBean.getSiteDir()##fileDelim##bean.getSiteID()##fileDelim#",
				excludeList="#variables.configBean.getSiteDir()##fileDelim#default#fileDelim#cache,#variables.configBean.getSiteDir()##fileDelim#default#fileDelim#assets"
			)>
	</cfif>
</cffunction>

<cffunction name="setSites" output="false">
	<cfargument name="missingOnly" default="false">
	<cfset var rs="" />
	<cfset var builtSites=structNew()>
	<cfset var foundSites=structNew()>
	<cfset var siteTemplate=getBean('site')>
	<cfset var i="">
	<cfset var tracepoint1=''>
	<cfset var tracepoint2=''>

	<cfif arguments.missingOnly>
		<cfset rs=getList() />
	<cfelse>
		<cfset rs=getList(clearCache=true) />
	</cfif>

	<cfset request.muraDeferredModuleAssets=[]>
	<cfset tracepoint1=initTracepoint("Loading global modules")>
	<cfset siteTemplate.discoverGlobalModules().discoverGlobalContentTypes()>
	<cfset request.muraBaseRBFactory=siteTemplate.getRBFactory()>
	<cfset commitTracepoint(tracepoint1)>

	<cfparam name="variables.sites" default="#structNew()#">

	<cfset tracepoint1=initTracepoint("Checking required directories")>
	<cfloop query="rs">
		<cfif arguments.missingOnly and structKeyExists(variables.sites,'#rs.siteid#')>
			<cfset builtSites['#rs.siteid#']=variables.sites['#rs.siteid#'] />
		<cfelse>
			<cfset builtSites['#rs.siteid#']=variables.DAO.read(rs.siteid) />
			<cfset foundSites['#rs.siteid#']=true>
		</cfif>
		<cfif variables.configBean.getCreateRequiredDirectories()>
			<cfset variables.utility.createRequiredSiteDirectories(rs.siteid,builtSites['#rs.siteid#'].getDisplayPoolID()) />
		</cfif>
 	</cfloop>
	<cfset commitTracepoint(tracepoint1)>

	<cfset variables.sites=builtSites>

	<cfset tracepoint1=initTracepoint("Loading deferred global assets")>
	<cfif arrayLen(request.muraDeferredModuleAssets)>
		<cfloop from="1" to="#arrayLen(request.muraDeferredModuleAssets)#" index="i">
				<cfif structKeyExists(request.muraDeferredModuleAssets[i],'modelDir') and len(request.muraDeferredModuleAssets[i].modelDir)>
						<cfset variables.configBean.registerBeanDir(dir=request.muraDeferredModuleAssets[i].modelDir,siteid=rs.siteid,package=request.muraDeferredModuleAssets[i].package,siteid=valuelist(rs.siteid),applyGlobal=true)>
				</cfif>
		</cfloop>
	</cfif>
	<cfset commitTracepoint(tracepoint1)>

	<cfset tracepoint1=initTracepoint("Loading site modules")>
	<cfloop query="rs">

		<cfif structKeyExists(foundSites,'#rs.siteid#')>
			<cfset builtSites['#rs.siteid#'].getRBFactory()>
			<cfset tracepoint2=initTracepoint("Loading site: #rs.siteid#")>
			<cfif arrayLen(request.muraDeferredModuleAssets)>
				<cfloop from="1" to="#arrayLen(request.muraDeferredModuleAssets)#" index="i">
						<cfif structKeyExists(request.muraDeferredModuleAssets[i],'config')>
							<cfset variables.configBean.getClassExtensionManager().loadConfigXML(request.muraDeferredModuleAssets[i].config,rs.siteid)>
						</cfif>
				</cfloop>
			</cfif>

			<cfset builtSites['#rs.siteid#']
				.set('displayObjectLookup',duplicate(siteTemplate.get('displayObjectLookup')))
				.set('displayObjectLookUpArray',duplicate(siteTemplate.get('displayObjectLookUpArray')))
				.discoverModules()>

			<cfset builtSites['#rs.siteid#']
				.set('contentTypeLookUpArray',duplicate(siteTemplate.get('contentTypeLookUpArray')))
				.discoverContentTypes()>

			<cfset builtSites['#rs.siteid#'].discoverBeans()>
			<cfset commitTracepoint(tracepoint2)>
		</cfif>
 	</cfloop>
	<cfset commitTracepoint(tracepoint1)>

</cffunction>

<cffunction name="getSite" output="false">
	<cfargument name="siteid" type="string" />
	<cfif not len(arguments.siteid)>
		<cfset arguments.siteid='default'>
	</cfif>

	<cfparam name="variables.sites" default="#structNew()#">

	<cfif not structKeyExists(variables,'sites')>
		<cfset setSites(missingOnly=true)>
	</cfif>

	<cftry>
	<cfreturn variables.sites['#arguments.siteid#'] />
	<cfcatch>
			<cflock name="buildSites#application.instanceID#" timeout="200">
				<cfif structKeyExists(variables.sites,'#arguments.siteid#')>
					<cfreturn variables.sites['#arguments.siteid#'] />
				<cfelse>
					<cfset setSites(missingOnly=true) />
				</cfif>
			</cflock>
			<cfif structKeyExists(variables.sites,'#arguments.siteid#')>
				<cfreturn variables.sites['#arguments.siteid#'] />
			<cfelse>
				<cfreturn variables.sites['default'] />
			</cfif>
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="siteExists" output="false">
	<cfargument name="siteid" type="string" />
	<cfparam name="variables.sites" default="#structNew()#">
	<cfreturn structKeyExists(variables.sites,arguments.siteid) />
</cffunction>

<cffunction name="getSites" output="false">
	<cfparam name="variables.sites" default="#structNew()#">
	<cfreturn variables.sites />
</cffunction>

<cffunction name="purgeAllCache" output="false">
	<cfargument name="broadcast" default="true">
	<cfset var rs=getList()>

	<cfloop query="rs">
		<cfset getSite(rs.siteid).getCacheFactory(name="data").purgeAll()/>
		<cfset getSite(rs.siteid).getCacheFactory(name="output").purgeAll()/>
	</cfloop>

	<cfif arguments.broadcast>
		<cfset variables.clusterManager.purgeCache(name="all")>
	</cfif>
</cffunction>

<cffunction name="getUserSites" output="false">
<cfargument name="siteArray" type="array" required="yes" default="#arrayNew(1)#">
<cfargument name="isS2" type="boolean" required="yes" default="false">
<cfargument name="searchString" type="string" required="no" default="">
<cfargument name="searchMaxRows" type="numeric" required="no" default="-1">

	<cfset var rsSites=""/>
	<cfset var counter=1/>
	<cfset var rsAllSites=getList(sortby="site")/>
	<cfset var s=0/>
	<cfset var where=false/>

	<cfquery name="rsSites" dbtype="query" maxrows="#arguments.searchMaxRows#">
		select * from rsAllSites
		<cfif arrayLen(arguments.siteArray) and not arguments.isS2>
			<cfset where=true/>
			where siteid in (
			<cfloop from="1" to="#arrayLen(arguments.siteArray)#" index="s">
			'#arguments.siteArray['#s#']#'
			<cfif counter lt arrayLen(arguments.siteArray)>,</cfif>
			<cfset counter=counter+1>
			</cfloop>)
		<cfelseif not arrayLen(arguments.siteArray) and not arguments.isS2>
		<cfset where=true/>
		where 0=1
		</cfif>
		<cfif arguments.searchString neq "">
		<cfif where>
		and
		<cfelse>
		where
		</cfif>
		(
			siteid like <cfqueryparam value="%#arguments.searchString#%">
		or	Site like <cfqueryparam value="%#arguments.searchString#%">
		)
		</cfif>

	</cfquery>

	<cfreturn rsSites />
</cffunction>

<cffunction name="checkForBundle" output="false">
<cfargument name="data">
<cfargument name="errors">
	<cfset var fileManager=getBean("fileManager")>
	<cfset var tempfile="">
	<cfset var deletetempfile=true>

	<cfif isDefined("arguments.data.serverBundlePath") and len(arguments.data.serverBundlePath) and fileExists(arguments.data.serverBundlePath)>
		<cfset arguments.data.bundleFile=arguments.data.serverBundlePath>
	</cfif>

	<cfif structKeyExists(arguments.data,"bundleFile") and len(arguments.data.bundleFile)>
		<cfif fileManager.isPostedFile(arguments.data.bundleFile)>
			<cffile action="upload" result="tempFile" filefield="bundleFile" nameconflict="makeunique" destination="#variables.configBean.getTempDir()#">
		<cfelse>
			<cfset tempFile=fileManager.emulateUpload(arguments.data.bundleFile)>
			<cfset deletetempfile=false>
		</cfif>
		<cfparam name="arguments.data.bundleImportKeyMode" default="copy">
		<cfparam name="arguments.data.bundleImportContentMode" default="none">
		<cfparam name="arguments.data.bundleImportRenderingMode" default="none">
		<cfparam name="arguments.data.bundleImportPluginMode" default="none">
		<cfparam name="arguments.data.bundleImportMailingListMembersMode" default="none">
		<cfparam name="arguments.data.bundleImportUsersMode" default="none">
		<cfparam name="arguments.data.bundleImportFormDataMode" default="none">
		<cfset restoreBundle(
			"#tempfile.serverDirectory#/#tempfile.serverFilename#.#tempfile.serverFileExt#" ,
			arguments.data.siteID,
			arguments.errors,
			arguments.data.bundleImportKeyMode,
			arguments.data.bundleImportContentMode,
			arguments.data.bundleImportRenderingMode,
			arguments.data.bundleImportMailingListMembersMode,
			arguments.data.bundleImportUsersMode,
			arguments.data.bundleImportPluginMode,
			'',
			'',
			arguments.data.bundleImportFormDataMode
			)>
		<cfif deletetempfile>
			<cffile action="delete" file="#tempfile.serverDirectory#/#tempfile.serverFilename#.#tempfile.serverFileExt#">
		</cfif>
	</cfif>

</cffunction>

<cffunction name="restoreBundle" output="false">
<cfargument name="bundleFile">
<cfargument name="siteID" default="">
<cfargument name="errors" default="#structNew()#">
<cfargument name="keyMode" default="copy">
<cfargument name="contentMode" default="none">
<cfargument name="renderingMode" default="none">
<cfargument name="mailingListMembersMode" default="none">
<cfargument name="usersMode" default="none">
<cfargument name="pluginMode" default="none">
<cfargument name="lastDeployment" default="">
<cfargument name="moduleID" default="">
<cfargument name="formDataMode" default="none">

    <cfset var sArgs			= structNew()>
	<cfset var config 			= application.configBean />
	<cfset var Bundle			= getBean("bundle") />
	<cfset var publisher 		= getBean("publisher") />
	<cfset var keyFactory		= createObject("component","mura.publisherKeys").init(arguments.keyMode,application.utility)>
	<cfsetting requestTimeout = "7200">

	<cfset Bundle.restore( arguments.BundleFile)>

	<cfset sArgs.fromDSN		= config.getDatasource() />
	<cfset sArgs.toDSN			= config.getDatasource() />
	<cfset sArgs.fromSiteID		= "" />
	<cfset sArgs.toSiteID		= arguments.siteID />
	<cfset sArgs.contentMode			= arguments.contentMode />
	<cfset sArgs.keyMode			= arguments.keyMode />
	<cfset sArgs.renderingMode			= arguments.renderingMode />
	<cfset sArgs.mailingListMembersMode			= arguments.mailingListMembersMode />
	<cfset sArgs.usersMode			= arguments.usersMode />
	<cfset sArgs.formDataMode			= arguments.formDataMode />
	<cfset sArgs.keyFactory		= keyFactory />
	<cfset sArgs.pluginMode		= arguments.pluginMode  />
	<cfset sArgs.Bundle		= Bundle />
	<cfset sArgs.moduleID		= arguments.moduleID />
	<cfset sArgs.errors			= arguments.errors />
	<cfset sArgs.lastDeployment = arguments.lastDeployment />

	<cftry>
		<cfset publisher.getToWork( argumentCollection=sArgs )>

		<cfif len(arguments.siteID)>
			<!-- Legacy data updates --->
			<cfquery>
				update tclassextend set type='Folder' where type in ('Portal','LocalRepo')
			</cfquery>
			<cfquery>
				update tcontent set type='Folder' where type in ('Portal','LocalRepo')
			</cfquery>
			<cfquery>
				update tsystemobjects set
					object='folder_nav',
					name='Folder Navigation'
				where object='portal_nav'
			</cfquery>
			<!--- --->

			<cfset getSite(arguments.siteID).getCacheFactory(name="output").purgeAll()>
			<cfif sArgs.contentMode neq "none">
				<cfset getSite(arguments.siteID).getCacheFactory(name="data").purgeAll()>
				<cfset getBean("contentUtility").updateGlobalMaterializedPath(siteID=arguments.siteID)>
			</cfif>
			<cfif sArgs.pluginMode neq "none">
				<cfset getBean("pluginManager").loadPlugins()>
			</cfif>
		</cfif>

		<cfset application.appInitialized=false>

	<cfcatch>
		<cflog type="Error"
	    file="exception"
	    text="#serializeJSON(cfcatch)#">

		<cfset arguments.errors.message="The bundle was not successfully imported:<br/>ERROR (Full Details Available in 'exception' Log)<br/>: " & cfcatch.message>
		<cfif findNoCase("duplicate",errors.message)>
			<cfset arguments.errors.message=arguments.errors.message & "<br/>HINT: This error is most often caused by 'Maintaining Keys' when the bundle data already exists within another site in the current Mura instance.">
		</cfif>
		<cfif isDefined("cfcatch.sql") and len(cfcatch.sql)>
			<cfset arguments.errors.message=arguments.errors.message & "<br/>SQL: " & cfcatch.sql>
		</cfif>
		<cfif isDefined("cfcatch.detail") and len(cfcatch.detail)>
			<cfset arguments.errors.message=arguments.errors.message & "<br/>DETAIL: " & cfcatch.detail>
		</cfif>
		<cfif isDefined("cfcatch.cause.stacktrace") and len(cfcatch.cause.stacktrace)>
			<cfset arguments.errors.message=arguments.errors.message & "<br/>EXTENDED INFO: " & cfcatch.cause.stacktrace>
		</cfif>
	</cfcatch>
	</cftry>
	<cfreturn arguments.errors>
</cffunction>

<cffunction name="isBundle" output="false">
	<cfargument name="BundleFile">
	<cfset var rs=createObject("component","mura.Zip").List(zipFilePath="#arguments.BundleFile#")>

	<cfquery name="rs" dbType="query">
		select entry from rs where entry in ('sitefiles.zip','pluginfiles.zip','filefiles.zip','pluginfiles.zip')
	</cfquery>
	<cfreturn rs.recordcount>
</cffunction>

<cffunction name="isPartialBundle" output="false">
	<cfargument name="BundleFile">
	<cfset var rs=createObject("component","mura.Zip").List(zipFilePath="#arguments.BundleFile#")>

	<cfquery name="rs" dbType="query">
		select entry from rs where entry in ('assetfiles.zip')
	</cfquery>
	<cfreturn rs.recordcount>
</cffunction>

<cffunction name="createCacheFactory" output="false">
	<cfargument name="freeMemoryThreshold" required="true" default="60">
	<cfargument name="name" required="true" default="output">
	<cfargument name="siteid" required="true">
	<cfif variables.configBean.getValue(property='advancedCaching',defaultValue=false)>
		<cfreturn createObject("component","mura.cache.cacheAdvanced").init(name=arguments.name,siteid=arguments.siteid)>
	<cfelse>
		<cfreturn createObject("component","mura.cache.cacheSimple").init(freeMemoryThreshold=arguments.freeMemoryThreshold)>
	</cfif>
</cffunction>

<cffunction name="save" output="false">
	<cfargument name="data" type="any" default="#structnew()#"/>

	<cfset var siteID="">
	<cfset var rs="">

	<cfif isObject(arguments.data)>
		<cfif listLast(getMetaData(arguments.data).name,".") eq "settingsBean">
			<cfset arguments.data=arguments.data.getAllValues()>
		<cfelse>
			<cfthrow type="custom" message="The attribute 'DATA' is not of type 'mura.settings.settingsBean'">
		</cfif>
	</cfif>

	<cfif not structKeyExists(arguments.data,"siteID")>
		<cfthrow type="custom" message="The attribute 'SITEID' is required when saving a site settingsBean.">
	</cfif>

	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" name="rs">
	select siteID from tsettings where siteID=<cfqueryparam value="#arguments.data.siteID#">
	</cfquery>

	<cfif rs.recordcount>
		<cfreturn update(arguments.data)>
	<cfelse>
		<cfreturn create(arguments.data)>
	</cfif>

</cffunction>

<cffunction name="remoteReload" output="false">
		<cfset application.appInitialized=false>
		<cfset application.broadcastInit=false>
</cffunction>

<cffunction name="getAccessControlOriginDomainList" output="false">
	<cfscript>
		if(!isDefined("variables.AccessControlOriginDomainList")){
			lock name="origindomainlist#application.instanceid#" type="exclusive" timeout="10"{
				if(!isDefined("variables.AccessControlOriginDomainList")){
					variables.AccessControlOriginDomainList='';

					var admindomain=variables.configBean.getAdminDomain();

					if(len(admindomain)){
						variables.AccessControlOriginList=listAppend(variables.AccessControlOriginDomainList,admindomain);
					}

					var sites=getSites();
					var originArray=[];
					var origin='';

					for(var site in sites){
						originArray=listToArray(sites[site].getAccessControlOriginDomainList());
						if(arrayLen(originArray)){
							for(origin in originArray){
								if(!listFind(variables.AccessControlOriginDomainList,origin)){
									variables.AccessControlOriginDomainList=listAppend(variables.AccessControlOriginDomainList,origin);
								}
							}
						}

					}
				}
			}
		}

		return variables.AccessControlOriginDomainList;

	</cfscript>
</cffunction>

<cffunction name="getAccessControlOriginDomainArray" output="false">
	<cfscript>
		if(!isDefined("variables.AccessControlOriginDomainArray")){
			variables.AccessControlOriginDomainArray=listToArray(getAccessControlOriginDomainList());
		}

		return variables.AccessControlOriginDomainArray;

	</cfscript>
</cffunction>

<cffunction name="getAccessControlOriginList">
	<cfscript>
		if(!isDefined("variables.AccessControlOriginList")){
			lock name="originlist#application.instanceid#" type="exclusive" timeout="10"{
				if(!isDefined("variables.AccessControlOriginList")){
					variables.AccessControlOriginList='';

					var admindomain=variables.configBean.getAdminDomain();

					if(len(admindomain)){
						variables.AccessControlOriginList=listAppend(variables.AccessControlOriginList,"http://#admindomain#");
						variables.AccessControlOriginList=listAppend(variables.AccessControlOriginList,"https://#admindomain#");
					}

					var sites=getSites();
					var originArray=[];
					var origin='';

					for(var site in sites){
						originArray=listToArray(sites[site].getAccessControlOriginList());
						if(arrayLen(originArray)){
							for(origin in originArray){
								if(!listFind(variables.AccessControlOriginList,origin)){
									variables.AccessControlOriginList=listAppend(variables.AccessControlOriginList,origin);
								}
							}
						}

					}
				}
			}
		}

		return variables.AccessControlOriginList;

	</cfscript>
</cffunction>

</cfcomponent>
