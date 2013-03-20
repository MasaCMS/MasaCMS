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
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" access="public" returntype="any" output="false">
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

<cffunction name="getList" access="public" output="false" returntype="query">
	<cfargument name="sortBy" default="orderno">
	<cfargument name="sortDirection" default="asc">
	<cfset var rs = variables.gateway.getList(arguments.sortBy,arguments.sortDirection) />
	
	<cfreturn rs />
	
</cffunction>

<cffunction name="publishSite" access="public" output="false" returntype="void">
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

<cffunction name="pushBundle" access="public" output="no" returntype="any">
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
				
	<cfhttp method="post" url="#serverArgs.serverURL#">
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

<cffunction name="saveOrder" access="public" output="false" returntype="void">
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
	
	<cfobjectcache action="clear"/>
	
</cffunction>

<cffunction name="saveDeploy" access="public" output="false" returntype="void">
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

<cffunction name="read" access="public" output="false" returntype="any">
<cfargument name="siteid" type="string" />
<cfargument name="settingsBean" default=""> />
	<cfreturn variables.DAO.read(arguments.siteid,arguments.settingsBean) />
	
</cffunction>

<cffunction name="update" access="public" output="false" returntype="any">
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
		<cfset variables.DAO.update(bean) />
		<cfset checkForBundle(arguments.data,bean.getErrors())>
		<cfset setSites() />
		<cfset application.appInitialized=false>

		<cfset getBean('pluginManager').announceEvent("onAfterSiteUpdate",pluginEvent)>
		<cfset getBean('pluginManager').announceEvent("onAfterSiteSave",pluginEvent)>
	</cfif>

	<cfreturn bean />

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void">
	<cfargument name="siteid" type="string" />
	
	<cfset var bean=read(arguments.siteid) />
	<cfset var pluginEvent = createObject("component","mura.event") />
	<cfset var data={sited=arguments.siteid,settingsBean=bean}>
	<cfset pluginEvent.init(data)>

	<cfset getBean('pluginManager').announceEvent("onBeforeSiteDelete",pluginEvent)>

	<cfset variables.utility.logEvent("SiteID:#arguments.siteid# Site:#bean.getSite()# was deleted","mura-settings","Information",true) />
	<cfset variables.DAO.delete(arguments.siteid) />
	<cfset setSites() />
	<cftry>
	<cfset variables.utility.deleteDir("#variables.configBean.getWebRoot()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#") />
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
	<cfset variables.utility.deleteDir("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#") />
	<cfcatch></cfcatch>
	</cftry>
	<cftry>
	<cfset variables.utility.deleteDir("#variables.configBean.getAssetDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#") />
	<cfcatch></cfcatch>
	</cftry>

	<cfset getBean('pluginManager').announceEvent("onAfterSiteDelete",pluginEvent)>

</cffunction>

<cffunction name="create" access="public" output="false" returntype="any">
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
			<cfthrow message="The SiteID you entered is already being used.">
			<cfabort>
		</cfif>
		
		<cfif directoryExists(expandPath("/muraWRM/#bean.getSiteID()#"))>
			<cfthrow message="A directory with the same name as the SiteID you entered is already being used.">
		</cfif>
		
		<cfset variables.utility.logEvent("SiteID:#bean.getSiteID()# Site:#bean.getSite()# was created","mura-settings","Information",true) />
		<cfif structKeyExists(arguments.data,"extendSetID") and len(arguments.data.extendSetID)>
			<cfset variables.classExtensionManager.saveExtendedData(bean.getBaseID(),bean.getAllValues())/>
		</cfif>
		<cfset variables.DAO.create(bean) />
		<cfset variables.utility.copyDir("#variables.configBean.getWebRoot()##variables.configBean.getFileDelim()#default#variables.configBean.getFileDelim()#", "#variables.configBean.getWebRoot()##variables.configBean.getFileDelim()##bean.getSiteID()##variables.configBean.getFileDelim()#") />
		<cfif variables.configBean.getCreateRequiredDirectories()>
			<cfset variables.utility.createRequiredSiteDirectories(bean.getSiteID()) />
		</cfif>
		<cfset checkForBundle(arguments.data,bean.getErrors())>
		<cfset setSites() />
		<cfset application.appInitialized=false>

		<cfset getBean('pluginManager').announceEvent("onAfterSiteCreate",pluginEvent)>
		<cfset getBean('pluginManager').announceEvent("onAfterSiteSave",pluginEvent)>
	</cfif>

	<cfreturn bean />
</cffunction>

<cffunction name="setSites" access="public" output="false" returntype="void">
	<cfargument name="missingOnly" default="false">
	<cfset var rs="" />
	<cfset var builtSites=structNew()>
	<cfobjectcache action="clear"/>
	<cfset rs=getList() />

	<cfloop query="rs">
		<cfif arguments.missingOnly and structKeyExists(variables.sites,'#rs.siteid#')>
			<cfset builtSites['#rs.siteid#']=variables.sites['#rs.siteid#'] />
		<cfelse>
			<cfset builtSites['#rs.siteid#']=variables.DAO.read(rs.siteid) />	
		</cfif>
		<cfif variables.configBean.getCreateRequiredDirectories()>
			<cfset variables.utility.createRequiredSiteDirectories(rs.siteid) />
		</cfif>
 	</cfloop>

	<cfset variables.sites=builtSites>
	
</cffunction>

<cffunction name="getSite" access="public" output="false" returntype="any">
	<cfargument name="siteid" type="string" />
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

<cffunction name="siteExists" access="public" output="false" returntype="any">
	<cfargument name="siteid" type="string" />
	
	<cfreturn structKeyExists(variables.sites,arguments.siteid) />

</cffunction>

<cffunction name="getSites" access="public" output="false" returntype="any">
	<cfreturn variables.sites />
</cffunction>

<cffunction name="purgeAllCache" access="public" output="false" returntype="void">
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

<cffunction name="getUserSites" access="public" output="false" returntype="query">
<cfargument name="siteArray" type="array" required="yes" default="#arrayNew(1)#">
<cfargument name="isS2" type="boolean" required="yes" default="false">
	<cfset var rsSites=""/>
	<cfset var counter=1/>
	<cfset var rsAllSites=getList(sortby="site")/>
	<cfset var s=0/>
	
	<cfquery name="rsSites" dbtype="query">
		select * from rsAllSites
		<cfif arrayLen(arguments.siteArray) and not arguments.isS2>
			where siteid in (
			<cfloop from="1" to="#arrayLen(arguments.siteArray)#" index="s">
			'#arguments.siteArray['#s#']#'
			<cfif counter lt arrayLen(arguments.siteArray)>,</cfif>
			<cfset counter=counter+1>
			</cfloop>)
		<cfelseif not arrayLen(arguments.siteArray) and not arguments.isS2>
		where 0=1
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

		<cfset arguments.errors.message="The bundle was not successfully imported:<br/>ERROR: " & cfcatch.message>
		<cfif findNoCase("duplicate",errors.message)>
			<cfset arguments.errors.message=arguments.errors.message & "<br/>HINT: This error is most often caused by 'Maintaining Keys' when the bundle data already exists within another site in the current Mura instance.">
		</cfif>
		<cfif isDefined("cfcatch.sql") and len(cfcatch.sql)>
			<cfset arguments.errors.message=arguments.errors.message & "<br/>SQL: " & cfcatch.sql>
		</cfif>
		<cfif isDefined("cfcatch.detail") and len(cfcatch.detail)>
			<cfset arguments.errors.message=arguments.errors.message & "<br/>DETAIL: " & cfcatch.detail>
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

<cffunction name="createCacheFactory" output="false">
	<cfargument name="capacity" required="true" default="0">
	<cfargument name="freeMemoryThreshold" required="true" default="60">
	
	<cfif not arguments.capacity>
		<cfreturn createObject("component","mura.cache.cacheFactory").init(freeMemoryThreshold=arguments.freeMemoryThreshold)>
	<cfelse>
		<cfreturn createObject("component","mura.cache.cacheFactoryLRU").init(capacity=arguments.capacity, freeMemoryThreshold=arguments.freeMemoryThreshold)>
	</cfif>
	
</cffunction>

<cffunction name="save" access="public" returntype="any" output="false">
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

</cfcomponent>