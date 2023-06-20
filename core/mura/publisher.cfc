<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides a utility to import bundles">

	<cffunction name="update" output="false">
		<cfargument name="find" type="string" default="" required="true">
		<cfargument name="replace" type="string"  default="" required="true">
		<cfargument name="datasource" type="string"  default="#application.configBean.getDatasource()#" required="true">

		<cfset var newBody=""/>
		<cfset var newSummary=""/>
		<cfset var rs="">
		<cfif len(arguments.find)>
			<cfquery datasource="#arguments.datasource#" name="rs">
				select contenthistid, body from tcontent where body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.find#%"/>
			</cfquery>

			<cfloop query="rs">
				<cfset newbody=replaceNoCase(BODY,"#arguments.find#","#arguments.replace#","ALL")>
				<cfquery datasource="#arguments.datasource#">
					update tcontent set body=<cfqueryparam value="#newBody#" cfsqltype="cf_sql_longvarchar" > where contenthistid='#contenthistid#'
				</cfquery>
			</cfloop>

			<cfquery datasource="#arguments.datasource#" name="rs">
				select contenthistid, summary from tcontent where summary like '%#arguments.find#%'
			</cfquery>

			<cfloop query="rs">
				<cfset newSummary=replaceNoCase(summary,"#arguments.find#","#arguments.replace#","ALL")>
				<cfquery datasource="#arguments.datasource#">
					update tcontent set summary=<cfqueryparam value="#newSummary#" cfsqltype="cf_sql_longvarchar" > where contenthistid='#contenthistid#'
				</cfquery>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="getToWork" output="false">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="any" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="all" required="true">
		<cfargument name="keyFactory" type="any">
		<cfargument name="lastDeployment" default="" required="true">
		<cfargument name="rsDeleted" required="true" default="#queryNew('objectID')#">
		<cfargument name="moduleID" type="any" required="false" default="">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="errors" type="any" required="true" default="#structNew()#">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">
		<cfargument name="mailingListMembersMode" type="string" default="none" required="true">
		<cfargument name="usersMode" type="string" default="none" required="true">
		<cfargument name="keyMode" type="string" default="copy" required="true">
		<cfargument name="formDataMode" type="string" default="none" required="true">
		<cfset var rstplugins="">
		<cfset var bundleAssetPath="">
		<cfset var bundleContext="">
		<cfset var rssite="">
		<cfset var themeDir="">
		<cfset var doFindAndReplace=false>

		<cfset var hasStructuredAssets = not isdefined('arguments.Bundle.getValue') or arguments.Bundle.getValue("hasstructuredassets",true) />

		<cfif isBoolean(hasStructuredAssets) and NOT hasStructuredAssets>			
			<cfset arguments.keyMode = "publish">
		</cfif>
		
		<cfsetting requestTimeout = "7200">

		<cfif structKeyExists(arguments,"Bundle")>
			<cfset arguments.lastDeployment=arguments.bundle.getValue("sincedate","")>
		</cfif>

		<cfif isDate(arguments.lastDeployment)>
			<cfset arguments.keyMode="publish">
			<cfset arguments.usersMode="none">
			<cfset arguments.mailingListMembersMode="none">
			<cfif structKeyExists(arguments,"Bundle")>
				<cfset arguments.rsDeleted=arguments.Bundle.getValue("rsttrash")>
				<cfset arguments.keyFactory.setMode("publish")>
			</cfif>
		</cfif>

		<cfif not structKeyExists(arguments,"keyFactory")>
			<cfset arguments.keyFactory=createObject("component" ,"mura.publisherKeys").init(arguments.keyMode,application.utility)>
		</cfif>

		<cfif structKeyExists(arguments,"Bundle") and arguments.pluginMode eq "all">
			<cfset rstplugins=arguments.Bundle.getValue("rstplugins")>

			<cfloop query="rstplugins">
				<cfset arguments.moduleID=listAppend(arguments.moduleID,rstplugins.moduleID)>
			</cfloop>
		</cfif>

		<!--- BEGIN BUNDLEABLE CUSTOM OBJECTS --->
		<cfif structKeyExists(arguments, "bundle")>
			<cfset var bundleablebeans=arguments.Bundle.getValue("bundleablebeans",'')>
			<cfif len(bundleablebeans)>
				<cfset var bb="">
				<cfset var bbList="">
				<cfloop list="#bundleablebeans#" index="bb">
					<cfif getServiceFactory().containsBean(bb) and not listFindNoCase(bbList,bb)>
						<cfset local.beanClass=getBean(beanName=bb)>
						<cfif arguments.contentMode eq 'All' and local.beanClass.hasProperty('siteid')>
							<cfquery>
								delete from #local.beanClass.getTable()#
								where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeID#" />
							</cfquery>
						</cfif>
						<cfset local.beanClass.fromBundle(bundle=arguments.bundle,keyFactory=arguments.keyFactory,siteid=arguments.toSiteID)>
						<cfset bbList=listAppend(bbList,bb)>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>

		<!--- END BUNDLEABLE CUSTOM OBJECTS --->

		<cfif len(arguments.toSiteID) and arguments.contentMode neq "none">
			<cfset getToWorkSite(argumentCollection=arguments)>

			<cfif arguments.keyMode eq "copy">
				<cfset getBean("contentUtility").updateGlobalMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
				<cfset getBean("contentUtility").updateGlobalCommentsMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
				<cfset getBean("categoryUtility").updateGlobalMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
		 	</cfif>

		 	<!---
			<cfif arguments.contentMode eq "all" and arguments.keyMode eq "publish" and not StructKeyExists(arguments,"Bundle")>
				<cfif not isDate(arguments.lastDeployment)>
					<cfset getToWorkSyncMetaOLD(argumentCollection=arguments)>
				</cfif>
				<cfset getToWorkClassExtensionsOLD(argumentCollection=arguments)>
			</cfif>
			--->

			<cfif StructKeyExists(arguments,"Bundle")>
				<cfset getToWorkSyncMeta(argumentCollection=arguments)>
				<cfset getToWorkTrash(argumentCollection=arguments)>

				<cfset doFindAndReplace=true>

			</cfif>

		</cfif>

		<cfif len(arguments.toSiteID) and arguments.usersMode neq "none">
			<cfset getToWorkUsers(argumentCollection=arguments)>
		</cfif>

		<cfif len(arguments.toSiteID) and (arguments.usersMode neq "none" or arguments.contentMode neq "none")>
			<cfset getToWorkFiles(argumentCollection=arguments)>
			<cfset getToWorkClassExtensions(argumentCollection=arguments)>
		</cfif>

		<cfif doFindAndReplace>
			<cfset rssite=arguments.Bundle.getValue("rssite")>
			<cfif rssite.recordcount and isDefined("rssite.siteID")>
				<cfset bundleAssetPath=arguments.Bundle.getValue("assetPath")>

				<cfif isSimpleValue(bundleAssetPath)>
					<cfif bundleAssetPath neq application.configBean.getAssetPath()>
						<cfset application.contentUtility.findAndReplace("#bundleAssetPath#/#rssite.siteID#/cache/", "#application.configBean.getAssetPath()#/#arguments.toSiteID#/cache/", arguments.toSiteID)>
						<cfset application.contentUtility.findAndReplace("#bundleAssetPath#/#rssite.siteID#/assets/", "#application.configBean.getAssetPath()#/#arguments.toSiteID#/assets/", arguments.toSiteID)>
					</cfif>
				</cfif>

				<cfif isDefined("rssite.domain")
					and len(rssite.domain)
					and rssite.domain neq application.settingsManager.getSite(arguments.toSiteID).getDomain()>
					<cfset application.contentUtility.findAndReplace("//#rssite.domain#","//#application.settingsManager.getSite(arguments.toSiteID).getDomain()#" , arguments.toSiteID)>
				</cfif>

				<cfif rssite.siteID neq arguments.toSiteID>
					<cfset application.contentUtility.findAndReplace("/#rssite.siteID#/", "/#arguments.toSiteID#/", arguments.toSiteID)>
				</cfif>

				<cfset bundleContext=arguments.Bundle.getValue("context")>
				<cfif isSimpleValue(bundleContext) and len(bundleContext) >
					<cfif bundleContext neq application.configBean.getContext()>
						<cfset application.contentUtility.findAndReplace("#bundleContext#/", "#application.configBean.getContext()#/", "#arguments.toSiteID#")>
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<!---<cfif len(arguments.toSiteID) and (arguments.usersMode neq "none" or arguments.contentMode neq "none")
		and not (arguments.keyMode eq "publish" and not StructKeyExists(arguments,"Bundle"))>
			<cfset getToWorkClassExtensions(argumentCollection=arguments)>
		</cfif>--->

		<cfif StructKeyExists(arguments,"Bundle")>
			<cfset rssite=Bundle.getValue("rssite")>
			<cfif isDefined("rssite.theme")>
				<cfset themeDir=rssite.theme>
			</cfif>
			<cfset arguments.Bundle.unpackFiles( 
				arguments.toSiteID,
				arguments.keyFactory,
				arguments.toDSN, 
				arguments.moduleID, 
				arguments.errors , 
				arguments.renderingMode, 
				arguments.contentMode, 
				arguments.pluginMode,
				arguments.lastDeployment,
				arguments.keyMode,
				hasStructuredAssets,
				themeDir) />

			<cfif arguments.pluginMode neq "none">
				<cfset getToWorkPlugins(argumentCollection=arguments)>
			</cfif>

			<cfif arguments.keyMode eq "copy" and arguments.contentMode eq "all">
				<cfset arguments.Bundle.renameFiles( arguments.toSiteID,arguments.keyFactory,arguments.toDSN ) />
			</cfif>
			<cfif arguments.contentMode neq "none">
				<cfset getBean("fileManager").cleanFileCache(arguments.toSiteID)>
			</cfif>
			<cfif arguments.contentMode neq 'none'>
				<cfset rssite=Bundle.getValue("rssite")>
				<cfif rssite.recordcount and isDefined('rssite.customtaggroups') and len(rssite.customtaggroups)>
					<cfquery datasource="#arguments.toDSN#">
						update tsettings set customtaggroups=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.customtaggroups#">
						where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
					</cfquery>
				</cfif>
			</cfif>
			<cfif listFindNoCase("All,Theme",arguments.renderingMode)>
				<cfset rssite=Bundle.getValue("rssite")>
				<cfif rssite.recordcount
					and (
						directoryExists("#getBean('configBean').getSiteDir()#/#arguments.toSiteID#/includes/themes/#rssite.theme#")
						or directoryExists("#getBean('configBean').getSiteDir()#/#arguments.toSiteID#/themes/#rssite.theme#")
						or directoryExists("#expandPath('/muraWRM')#/themes/#rssite.theme#")
					)>
					<cfquery datasource="#arguments.toDSN#">
						update tsettings set

						<cfif isdefined("rssite.columnCount")>
						columnCount=<cfqueryparam cfsqltype="cf_sql_integer" value="#rssite.columnCount#">,
						columnNames=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.columnNames#">,
						primaryColumn=<cfqueryparam cfsqltype="cf_sql_integer" value="#rssite.primaryColumn#">,
						</cfif>

						<cfif isdefined("rssite.placeholderImgID")>
						placeholderImgID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyFactory.get(rssite.placeholderImgID)#">,
						</cfif>

						theme=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.theme#">,
						displayPoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,

						<cfif not isDefined('rssite.largeImageWidth')>
							<cfif rssite.galleryMainScaleBy eq 'x'>
								largeImageHeight='Auto',
								largeImageWidth=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.galleryMainScale#">,
							<cfelse>
								largeImageHeight=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.galleryMainScale#">,
								largeImageWidth='Auto',
							</cfif>
						<cfelse>
							largeImageHeight=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.largeImageHeight#">,
							largeImageWidth=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.largeImageWidth#">,
						</cfif>

						<cfif not isDefined('rssite.smallImageWidth')>
							<cfif rssite.gallerySmallScaleBy eq 's'>
								smallImageHeight=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.gallerySmallScale#">,
								smallImageWidth=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.gallerySmallScale#">,
							<cfelseif rssite.gallerySmallScaleBy eq 'x'>
								smallImageHeight='Auto',
								smallImageWidth=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.gallerySmallScale#">,
							<cfelse>
								smallImageHeight=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.gallerySmallScale#">,
								smallImageWidth='Auto',
							</cfif>
						<cfelse>
							smallImageHeight=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.smallImageHeight#">,
							smallImageWidth=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.smallImageWidth#">,
						</cfif>

						<cfif not isDefined('rssite.mediumImageWidth')>
							<cfif rssite.galleryMediumScaleBy eq 's'>
								mediumImageHeight=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.galleryMediumScale#">,
								mediumImageWidth=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.galleryMediumScale#">
							<cfelseif rssite.galleryMediumScaleBy eq 'x'>
								mediumImageHeight='Auto',
								mediumImageWidth=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.galleryMediumScale#">
							<cfelse>
								mediumImageHeight=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.galleryMediumScale#">,
								mediumImageWidth='Auto'
							</cfif>
						<cfelse>
							mediumImageHeight=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.mediumImageHeight#">,
							mediumImageWidth=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.mediumImageWidth#">
						</cfif>

						where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
					</cfquery>
					<cfset application.settingsManager.setSites()>
				<cfelse>
					<cfset arguments.errors.missingtheme="The submitted bundle did not provide valid theme settings information.">
				</cfif>
			</cfif>
			<cfset arguments.Bundle.cleanUp() />
		<cfelse>
			<cfif arguments.pluginMode neq "none">
				<cfset getToWorkPlugins(argumentCollection=arguments)>
			</cfif>
		</cfif>

		<cfreturn arguments.errors>
	</cffunction>

	<cffunction name="getToWorkPartial" output="false">
		<cfargument name="siteID" type="string" default="" required="true">
		<cfargument name="parentID" type="string" default="">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="errors" type="any" required="true" default="#structNew()#">
		<cfargument name="isApproved" type="numeric" required="false" default="0">
		<cfargument name="changesetBean" type="any" required="false">
		<cfargument name="keyFactory" required="true">

		<cfset var bundleAssetPath="">
		<cfset var extendManager	= getBean("extendManager") />

		<cfset var keys = {}>

		<cfset var rsCheckPath=""/>

		<cfset var rstContent=""/>
		<cfset var rsContent=""/>
		<cfset var rstContentObjects=""/>
		<cfset var rsContentObjects=""/>
		<cfset var rsObjects=""/>

		<cfset var rsContentObjectsUpdate=""/>
		<cfset var rsthierarchy=""/>
		<cfset var rstfiles=""/>
		<cfset var rsthasmetadata=""/>
		<cfset var importExtensions=""/>

		<cfset var rstClassExtendData=""/>
		<cfset var rsExtendData=""/>

		<cfset var rstContentTags=""/>
		<cfset var rsContentTags=""/>

		<cfset var rsfile="">
		<cfset var newFileID="">

		<cfset var contentBean=""/>
		<cfset var contentData={}/>
		<cfset var utility = getBean("utility") />
		<cfset var changesetID = "" />

		<cfset var assetPathFields="" />
		<cfset var i="" />

		<cfif isObject( arguments.changesetBean )>
			<cfset changesetID = arguments.changesetBean.getChangesetID() />
		</cfif>

		<cfsetting requestTimeout = "7200">

		<cfif structKeyExists(arguments,"Bundle")>
			<cfset arguments.lastDeployment=arguments.bundle.getValue("sincedate","")>
		</cfif>

		<cfif fileExists("#Bundle.getBundle()#extensions.txt")>
			<cffile action="read" file="#Bundle.getBundle()#extensions.txt" variable="importExtensions" >
			<cfif len( importExtensions ) gt 30>
				<cfset extendManager.loadConfigXML(parseXML(importExtensions),arguments.siteid) />
			</cfif>
		</cfif>

		<cfset rstcontent = arguments.Bundle.getValue("rstcontent")>
		<cfset rstcontentobjects = arguments.Bundle.getValue("rstcontentobjects")>
		<cfset rsthierarchy = arguments.Bundle.getValue("rsthierarchy")>
		<cfset rstfiles = arguments.Bundle.getValue("rstfiles")>
		<cfset rstClassExtendData = arguments.Bundle.getValue("rstClassExtendData")>
		<cfset rsthasmetadata = arguments.Bundle.getValue("rsthasmetadata")>
		<cfset rstContentTags = arguments.Bundle.getValue("rstContentTags")>

		<cfquery name="rsObjects">
			select object from tsystemobjects
			where
			siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
		</cfquery>

		<cfloop query="rsthierarchy">
			<cfquery name="rsCheckPath">
				select contentid from tcontent
				where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
				and remoteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsthierarchy.contentID#"/>
				and active = 1
				and path LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%"/>
			</cfquery>

			<cfif rsCheckPath.recordCount>
				<cfset contentBean = getBean('content').loadBy(contentid=rsCheckPath.contentID,siteid=arguments.siteid) />
			<cfelse>
				<cfset contentBean = getBean('content').loadBy(siteid=arguments.siteid) />
			</cfif>

			<cfquery name="rsContent" dbtype="query">
				select * from rstcontent
				where
				contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsthierarchy.contentid#"/>
			</cfquery>

			<cfset contentData = utility.queryRowToStruct(rsContent) />
			<!--- asset paths --->
			<cfset contentData.body = replaceNoCase( contentData.body,"^^siteid^^",arguments.siteid,"all" ) />
			<cfset contentData.summary = replaceNoCase( contentData.summary,"^^siteid^^",arguments.siteid,"all" ) />

			<cfquery name="rsExtendData" dbtype="query">
				select * from rstClassExtendData
				where
				contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsContent.contentid#"/>
			</cfquery>

			<cfif rsExtendData.recordCount>
				<cfloop query="rsExtendData">
					<cfset rsExtendData.attributeValue = replaceNoCase( rsExtendData.attributeValue,"^^siteid^^",arguments.siteid,"all" ) />
					<cfset contentData[rsExtendData.name] = rsExtendData.attributeValue />
				</cfloop>
			</cfif>

			<cfquery name="rsContentObjects" dbtype="query">
				select * from rstContentObjects
				where
				contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsContent.contentid#"/>
				and
				object in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(rsObjects.object)#" list="true"/>)
				and
				object not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="plugin,component,form" list="true"/>)
			</cfquery>

			<cfquery name="rsContentTags" dbtype="query">
				select tag from rstContentTags
				where
				contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsContent.contentid#"/>
			</cfquery>

			<cfif rsContentTags.recordCount>
				<cfset contentData.tags = valuelist(rsContentTags.tag) />
			</cfif>

			<cfset contentData.remoteID = contentData.contentID />

			<cfif contentBean.getIsNew()>
				<cfset contentBean.setContentID( arguments.keyFactory.get(contentBean.getContentID()) ) />
				<cfset contentBean.setDisplay( 1 ) />
				<cfset contentBean.set('topOrBottom','bottom')>

				<cfset contentData.remoteID = contentData.contentID />
				<cfif StructKeyExists(keys,contentData.parentid)>
					<cfset contentData.parentID = keys[contentData.parentid] />
				<cfelse>
					<cfset contentData.parentID = arguments.parentid />
				</cfif>
			<!--- existing content --->
			<cfelseif StructKeyExists(contentData,"parentid")>
				<cfset contentBean.setContentID( arguments.keyFactory.get(contentBean.getContentID()), contentBean.getContentID() ) />
				<cfset structDelete(contentData,"parentid") />
			</cfif>

			<cfset keys[rsContent.contentID] = contentBean.getContentID() />

			<cfset structDelete(contentData,"siteID") />
			<cfset structDelete(contentData,"lastUpdate") />
			<cfset structDelete(contentData,"lastUpdateBy") />
			<cfset structDelete(contentData,"lastUpdateByID") />
			<cfset structDelete(contentData,"contentID") />
			<cfset structDelete(contentData,"contentHistID") />
			<cfset structDelete(contentData,"path") />
			<cfset structDelete(contentData,"filename") />

			<!--- asset paths --->

			<cfset contentBean.set( contentData ) />

			<cfset contentBean.setChangesetID( changesetID ) />
			<cfset contentBean.setApproved( arguments.isApproved ) />

			<cfif len(contentdata.fileid)>
				<cfquery name="rsfile" dbtype="query">
					Select * from rstfiles
					where fileid = <cfqueryparam value="#contentdata.fileid#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif rsFile.recordcount>
					<cfset newFileID = arguments.bundle.unpackPartialFile( arguments.siteid,contentdata.fileid,contentBean.getContentID(),rsfile,arguments.toDSN, arguments.errors ) />
					<cfset contentBean.setFileID(newFileID) />
				</cfif>
			</cfif>

			<cfset contentBean.save() />

			<cfloop query="rsContentObjects">
				<cftry>
				<cfquery datasource="#arguments.toDSN#" name="rsContentObjectsUpdate">
					insert into tcontentobjects(ColumnID,ContentHistID,ContentID,Name,Object,ObjectID,OrderNo,SiteID,params)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rsContentObjects.ColumnID),de(rsContentObjects.ColumnID),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#contentBean.getContentHistID()#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#contentBean.getContentID()#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rsContentObjects.Name neq '',de('no'),de('yes'))#" value="#rsContentObjects.Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rsContentObjects.Object neq '',de('no'),de('yes'))#" value="#rsContentObjects.Object#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rsContentObjects.ObjectID neq '',de('no'),de('yes'))#" value="#arguments.keyFactory(rsContentObjects.ObjectID)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rsContentObjects.OrderNo),de(rsContentObjects.OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.SiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rsContentObjects.params neq '',de('no'),de('yes'))#" value="#translateObjectParams(rsContentObjects.params,arguments.keyFactory)#">
					)
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>
			</cfloop>

			<!--- BEGIN BUNDLEABLE CUSTOM OBJECTS --->
			<cfif structKeyExists(arguments, "bundle")>
				<cfset var bundleablebeans=arguments.Bundle.getValue("bundleablebeans",'')>
				<cfif len(bundleablebeans)>
					<cfset var bb="">
					<cfset var bbList="">
					<cfloop list="#bundleablebeans#" index="bb">
						<cfif getServiceFactory().containsBean(bb) and not listFindNoCase(bbList,bb)>
							<cfset getBean(bb).fromBundle(bundle=arguments.bundle,keyFactory=arguments.keyFactory,siteid=arguments.siteid)>
							<cfset bbList=listAppend(bbList,bb)>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>

		<cfset arguments.Bundle.unpackPartialAssets( arguments.siteid ) />

		<cfreturn arguments.errors>
	</cffunction>

	<cffunction name="getToWorkSite" output="false">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="any" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="all" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="lastDeployment" default="" required="true">
		<cfargument name="rsDeleted" required="true" default="#queryNew('objectID')#">
		<cfargument name="moduleID" type="any" required="false" default="">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">
		<cfargument name="keyMode" type="string" default="copy" required="true">
		<cfargument name="mailingListMembersMode" type="string" default="none" required="true">
		<cfargument name="formDataMode" type="string" default="none" required="true">

		<cfset var keys=arguments.keyFactory/>
		<cfset var rstContentNew=""/>
		<cfset var rstContent=""/>
		<cfset var rstContentObjects=""/>
		<cfset var rstContentTags=""/>
		<cfset var rstSystemObjects=""/>
		<cfset var rstpermissions=""/>
		<cfset var rstSettings=""/>
		<cfset var rstcontentcategoryassign=""/>
		<cfset var rstcontentrelated=""/>
		<cfset var rstMailinglist=""/>
		<cfset var rstMailinglistnew=""/>
		<cfset var rstMailinglistmembers="">
		<cfset var rstFiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcategoriesnew=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var getNewID=""/>
		<cfset var rssite=""/>
		<cfset var rsttrashfiles=""/>
		<cfset var rstformresponsepackets="">
		<cfset var rstformresponsequestions="">
		<cfset var rstimagesizes="">

			<!--- pushed tables --->

			<!--- tcontent --->
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstContent">
					select * from tcontent
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and (tcontent.active = 1 or (tcontent.changesetID is not null and tcontent.approved=0))
					<cfif arguments.pluginMode neq 'none'>
						and type <>'Module'
					<cfelse>
						and type not in ('Module','Plugin')
					</cfif>
					<cfif isDate(arguments.lastDeployment)>
						and lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.lastDeployment#">
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontent = arguments.Bundle.getValue("rstcontent")>
			</cfif>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontent
				where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pluginMode neq 'none'>
					and type <>'Module'
				<cfelse>
					and type not in ('Module','Plugin')
				</cfif>

				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontent.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontent.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontent.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>

			<cfquery datasource="#arguments.toDSN#">
				update tcontent set menutitle=title
				where menutitle is null
				and type='Module'
				and siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>

			<cfloop query="rstContent">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontent (Active,Approved,audience,Body,ContentHistID,ContentID,Credits,Display,DisplayStart,DisplayStop,featureStart,featureStop,FileID,Filename,forceSSL,inheritObjects,isFeature,IsLocked,IsNav,keyPoints,
					lastUpdate,lastUpdateBy,lastUpdateByID,MenuTitle,MetaDesc,MetaKeyWords,moduleAssign,ModuleID,nextN,Notes,OrderNo,ParentID,displayTitle,ReleaseDate,RemoteID,RemotePubDate,RemoteSource,RemoteSourceURL,RemoteURL,responseChart,
					responseDisplayFields,responseMessage,responseSendTo,Restricted,RestrictGroups,searchExclude,SiteID,sortBy,sortDirection,Summary,Target,TargetParams,Template,Title,Type,subType,Path,tags,doCache,created,urltitle,htmltitle,mobileExclude,changesetID
					<!--- Check for new fields added in 5.5 --->
					<cfif isdefined("rstContent.imageSize")>
					,imageSize,imageHeight,imageWidth,childTemplate
					</cfif>
					<!--- Check for new fields added in 5.6 --->
					<cfif isdefined("rstContent.majorVersion")>
					,majorVersion,minorVersion, expires
					</cfif>
					<cfif isdefined("rstContent.displayInterval")>
					,displayInterval
					</cfif>
					<cfif isdefined("rstContent.objectParams")>
					,objectParams
					</cfif>
					)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.Active),de(rstContent.Active),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.Approved),de(rstContent.Approved),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.audience neq '',de('no'),de('yes'))#" value="#rstContent.audience#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.Body neq '',de('no'),de('yes'))#" value="#rstContent.Body#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstContent.contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstContent.contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.Credits neq '',de('no'),de('yes'))#" value="#rstContent.Credits#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.Display),de(rstContent.Display),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstContent.DisplayStart),de('no'),de('yes'))#" value="#rstContent.DisplayStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstContent.DisplayStop),de('no'),de('yes'))#" value="#rstContent.DisplayStop#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstContent.featureStart),de('no'),de('yes'))#" value="#rstContent.featureStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstContent.featureStop),de('no'),de('yes'))#" value="#rstContent.featureStop#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.FileID neq '',de('no'),de('yes'))#" value="#keys.get(rstContent.fileID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.Filename neq '',de('no'),de('yes'))#" value="#left(rstContent.Filename,255)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.forceSSL),de(rstContent.forceSSL),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.inheritObjects neq '',de('no'),de('yes'))#" value="#rstContent.inheritObjects#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.isFeature),de(rstContent.isFeature),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.IsLocked),de(rstContent.IsLocked),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.IsNav),de(rstContent.IsNav),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.keyPoints neq '',de('no'),de('yes'))#" value="#rstContent.keyPoints#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstContent.lastUpdate),de('no'),de('yes'))#" value="#rstContent.lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.lastUpdateBy neq '',de('no'),de('yes'))#" value="#rstContent.lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.lastUpdateByID neq '',de('no'),de('yes'))#" value="#rstContent.lastUpdateByID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.MenuTitle neq '',de('no'),de('yes'))#" value="#rstContent.MenuTitle#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.MetaDesc neq '',de('no'),de('yes'))#" value="#rstContent.MetaDesc#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.MetaKeyWords neq '',de('no'),de('yes'))#" value="#rstContent.MetaKeyWords#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.moduleAssign neq '',de('no'),de('yes'))#" value="#rstContent.moduleAssign#">,
					<cfif rstContent.type eq "plugin">
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontent.ModuleID neq '',de('no'),de('yes'))#" value="#keys.get(rstcontent.ModuleID)#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontent.ModuleID neq '',de('no'),de('yes'))#" value="#rstcontent.ModuleID#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.nextN),de(rstContent.nextN),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.Notes neq '',de('no'),de('yes'))#" value="#rstContent.Notes#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.OrderNo),de(rstContent.OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstContent.parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.displayTitle),de(rstContent.displayTitle),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstContent.ReleaseDate),de('no'),de('yes'))#" value="#rstContent.ReleaseDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.RemoteID neq '',de('no'),de('yes'))#" value="#rstContent.RemoteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.RemotePubDate neq '',de('no'),de('yes'))#" value="#rstContent.RemotePubDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.RemoteSource neq '',de('no'),de('yes'))#" value="#rstContent.RemoteSource#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.RemoteSourceURL neq '',de('no'),de('yes'))#" value="#rstContent.RemoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.RemoteURL neq '',de('no'),de('yes'))#" value="#rstContent.RemoteURL#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.responseChart),de(rstContent.responseChart),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.responseDisplayFields neq '',de('no'),de('yes'))#" value="#rstContent.responseDisplayFields#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.responseMessage neq '',de('no'),de('yes'))#" value="#rstContent.responseMessage#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.responseSendTo neq '',de('no'),de('yes'))#" value="#rstContent.responseSendTo#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.Restricted),de(rstContent.Restricted),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.RestrictGroups neq '',de('no'),de('yes'))#" value="#rstContent.RestrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.searchExclude),de(rstContent.searchExclude),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.sortBy neq '',de('no'),de('yes'))#" value="#rstContent.sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.sortDirection neq '',de('no'),de('yes'))#" value="#rstContent.sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.Summary neq '',de('no'),de('yes'))#" value="#rstContent.Summary#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.Target neq '',de('no'),de('yes'))#" value="#rstContent.Target#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.TargetParams neq '',de('no'),de('yes'))#" value="#rstContent.TargetParams#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.Template neq '',de('no'),de('yes'))#" value="#rstContent.Template#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.Title neq '',de('no'),de('yes'))#" value="#rstContent.Title#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.Type neq '',de('no'),de('yes'))#" value="#rstContent.Type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.subType neq '',de('no'),de('yes'))#" value="#rstContent.subType#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.Path neq '',de('no'),de('yes'))#" value="#rstContent.Path#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.Tags neq '',de('no'),de('yes'))#" value="#rstContent.Tags#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.doCache),de(rstContent.doCache),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstContent.created),de('no'),de('yes'))#" value="#rstContent.created#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.urlTitle neq '',de('no'),de('yes'))#" value="#left(rstContent.urltitle,255)#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstContent.htmltitle neq '',de('no'),de('yes'))#" value="#rstContent.htmltitle#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.mobileExclude),de(rstContent.mobileExclude),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.changesetID neq '',de('no'),de('yes'))#" value="#keys.get(rstContent.changesetID)#">
					<!--- Check for new fields added in 5.5 --->
					<cfif isdefined("rstContent.imageSize")>
						,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.imageSize neq '',de('no'),de('yes'))#" value="#rstContent.imageSize#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.imageHeight neq '',de('no'),de('yes'))#" value="#rstContent.imageHeight#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.imageWidth neq '',de('no'),de('yes'))#" value="#rstContent.imageWidth#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.childTemplate neq '',de('no'),de('yes'))#" value="#rstContent.childTemplate#">
					</cfif>
					<!--- Check for new fields added in 5.6 --->
					<cfif isdefined("rstContent.majorVersion")>
						,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.majorVersion),de(rstContent.majorVersion),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContent.minorVersion),de(rstContent.minorVersion),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstContent.expires),de('no'),de('yes'))#" value="#rstContent.expires#">
					</cfif>
					<cfif isdefined("rstContent.displayInterval")>
						,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.displayInterval neq '',de('no'),de('yes'))#" value="#rstContent.displayInterval#">
					</cfif>
					<cfif isdefined("rstContent.objectParams")>
						,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContent.objectParams neq '',de('no'),de('yes'))#" value="#translateObjectParams(rstContent.objectParams,keys)#">
					</cfif>
					)
				</cfquery>
			</cfloop>

			<!--- tcontentobjects --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontent.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontent.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontent.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstContentObjects">
					select * from tcontentobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						<cfif rstcontent.recordcount>
							and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstContentObjects = arguments.Bundle.getValue("rstContentObjects")>
			</cfif>

			<cfloop query="rstContentObjects">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentobjects (ColumnID,ContentHistID,ContentID,Name,Object,ObjectID,OrderNo,SiteID,params)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContentObjects.ColumnID),de(rstContentObjects.ColumnID),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstContentObjects.contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstContentObjects.contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContentObjects.Name neq '',de('no'),de('yes'))#" value="#rstContentObjects.Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContentObjects.Object neq '',de('no'),de('yes'))#" value="#rstContentObjects.Object#">,
					<cfif arguments.keyMode eq "copy" and arguments.fromDSN eq arguments.toDSN>
						<cfif listFindNoCase("plugin", rstContentObjects.object)>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContentObjects.ObjectID neq '',de('no'),de('yes'))#" value="#rstContentObjects.objectID#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContentObjects.ObjectID neq '',de('no'),de('yes'))#" value="#keys.get(rstContentObjects.objectID)#">,
						</cfif>
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContentObjects.ObjectID neq '',de('no'),de('yes'))#" value="#keys.get(rstContentObjects.objectID)#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstContentObjects.OrderNo),de(rstContentObjects.OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContentObjects.params neq '',de('no'),de('yes'))#" value="#translateObjectParams(rstContentObjects.params,keys)#">
					)
				</cfquery>
			</cfloop>

			<!--- tcontenttags --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontenttags where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontent.recordcount or rsDeleted.recordcount>
					and (
						<cfif rstcontent.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontent.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstContentTags">
					select * from tcontenttags where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						<cfif rstcontent.recordcount>
							and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstContentTags = arguments.Bundle.getValue("rstContentTags")>
			</cfif>
			<cfloop query="rstContentTags">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontenttags (ContentHistID,ContentID,siteID,tag
					<cfif isdefined('rstContentTags.taggroup')>
						,taggroup
					</cfif>
					)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstContentTags.contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstContentTags.contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContentTags.tag neq '',de('no'),de('yes'))#" value="#rstContentTags.tag#">
					<cfif isdefined('rstContentTags.taggroup')>
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstContentTags.taggroup neq '',de('no'),de('yes'))#" value="#rstContentTags.taggroup#">
					</cfif>
					)
				</cfquery>
			</cfloop>

			<!--- tsystemobjects--->
			<cfif not isDate(arguments.lastDeployment)>
			<cfquery datasource="#arguments.toDSN#">
				delete from tsystemobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstSystemObjects">
					select * from tsystemobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
			<cfelse>
				<cfset rstSystemObjects = arguments.Bundle.getValue("rstSystemObjects")>
			</cfif>
			<cfloop query="rstSystemObjects">
				<cfquery datasource="#arguments.toDSN#">
					insert into tsystemobjects (Name,Object,OrderNo,SiteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstSystemObjects.Name neq '',de('no'),de('yes'))#" value="#rstSystemObjects.Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstSystemObjects.Object neq '',de('no'),de('yes'))#" value="#rstSystemObjects.Object#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstSystemObjects.OrderNo),de(rstSystemObjects.OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR"  value="#arguments.toSiteID#">
					)
				</cfquery>
			</cfloop>
			</cfif>

			<!--- tcontentcategoryassign --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcategoryassign where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontent.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontent.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontent.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>		

			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentcategoryassign">
					select * from tcontentcategoryassign where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						<cfif rstcontent.recordcount>
							and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontentcategoryassign = arguments.Bundle.getValue("rstcontentcategoryassign")>
			</cfif>
			<cfloop query="rstcontentcategoryassign">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentcategoryassign (categoryID,contentHistID,contentID,featureStart,featureStop,isFeature,orderno,siteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentcategoryassign.categoryID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentcategoryassign.contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentcategoryassign.contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstcontentcategoryassign.featureStart),de('no'),de('yes'))#" value="#rstcontentcategoryassign.featureStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstcontentcategoryassign.featureStop),de('no'),de('yes'))#" value="#rstcontentcategoryassign.featureStop#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentcategoryassign.isFeature),de(rstcontentcategoryassign.isFeature),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentcategoryassign.orderno),de(rstcontentcategoryassign.orderno),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">
					)
				</cfquery>
			</cfloop>

			<!--- tcontentrelated --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentrelated where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontent.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontent.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeeds.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentrelated">
					select * from tcontentrelated where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						<cfif rstcontent.recordcount>
							and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontentrelated = arguments.Bundle.getValue("rstcontentrelated")>
			</cfif>


			<cfloop query="rstcontentrelated">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentrelated (contentHistID,contentID,relatedID,siteID,relatedContentSetID,orderNo)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentrelated.contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentrelated.contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentrelated.relatedID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">
					<cfif isdefined('rstcontentrelated.relatedContentSetID')>
						,<cfif rstcontentrelated.relatedContentSetID eq '00000000000000000000000000000000000'>
							'00000000000000000000000000000000000'
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentrelated.relatedContentSetID)#">
						</cfif>
						,<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentrelated.orderno),de(rstcontentrelated.orderno),de(0))#">
					<cfelse>
						,'00000000000000000000000000000000000'
						,1
					</cfif>
					)
				</cfquery>
			</cfloop>

			<cfset getToWorkChangeSets(argumentCollection=arguments)>
			<cfset getToWorkContentCategories(argumentCollection=arguments)>
			<cfset getToWorkImageSizes(argumentCollection=arguments)>

			<!--- synced tables--->
			<cfset arguments.rstcontent=rstcontent>

			<cfset getToWorkFeeds(argumentCollection=arguments)>
			<cfset getToWorkFormData(argumentCollection=arguments)>
			<cfset getToWorkMailingLists(argumentCollection=arguments)>

	</cffunction>

	<cffunction name="getToWorkChangeSets" output="false">
		<cfset var keys=arguments.keyFactory/>
		<cfset var rstchangesets="">

		<cfif not StructKeyExists(arguments,"Bundle")>
			<cfquery datasource="#arguments.fromDSN#" name="rstchangesets">
				select * from tchangesets where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				<cfif isDate(arguments.lastDeployment)>
					and lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.lastDeployment#">
				</cfif>
			</cfquery>
		<cfelse>
			<cfset rstchangesets = arguments.Bundle.getValue("rstchangesets")>
		</cfif>
		<cfquery datasource="#arguments.toDSN#">
			delete from tchangesets where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			<cfif isDate(arguments.lastDeployment)>
				<cfif rstchangesets.recordcount or rsDeleted.recordcount>
					and (
					<cfif rstchangesets.recordcount>
						changesetID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstchangesets.changesetID)#">)
					</cfif>
					<cfif rsDeleted.recordcount>
						<cfif rstchangesets.recordcount>or</cfif>
						changesetID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
					</cfif>
					)
				<cfelse>
					and 0=1
				</cfif>
			</cfif>
		</cfquery>
		<cfloop query="rstchangesets">
			<cfquery datasource="#arguments.toDSN#">
				insert into tchangesets (changesetID, siteID, name, description, created, publishDate,
				published, lastupdate, lastUpdateBy, lastUpdateByID,
				remoteID, remotePubDate, remoteSourceURL,closedate)
				values (
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstchangesets.changesetID)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstchangesets.Name neq '',de('no'),de('yes'))#" value="#rstchangesets.Name#">,
				<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstchangesets.Description neq '',de('no'),de('yes'))#" value="#rstchangesets.Description#">,
				<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstchangesets.Created),de('no'),de('yes'))#" value="#rstchangesets.Created#">,
				<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstchangesets.publishDate),de('no'),de('yes'))#" value="#rstchangesets.publishDate#">,
				<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstchangesets.published),de(rstchangesets.published),de(0))#">,
				<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstchangesets.LastUpdate),de('no'),de('yes'))#" value="#rstchangesets.LastUpdate#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstchangesets.LastUpdateBy neq '',de('no'),de('yes'))#" value="#rstchangesets.LastUpdateBy#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstchangesets.LastUpdateByID neq '',de('no'),de('yes'))#" value="#rstchangesets.LastUpdateByID#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstchangesets.remoteID neq '',de('no'),de('yes'))#" value="#rstchangesets.remoteID#">,
				<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstchangesets.remotePubDate),de('no'),de('yes'))#" value="#rstchangesets.remotePubDate#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstchangesets.remoteSourceURL neq '',de('no'),de('yes'))#" value="#rstchangesets.remoteSourceURL#">,
				<cfif structKeyExists(rstchangesets, "closedate")>
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstchangesets.closedate),de('no'),de('yes'))#" value="#rstchangesets.closedate#">
				<cfelse>
					null
				</cfif>
				)
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="getToWorkImageSizes" output="false">
		<cfset var keys=arguments.keyFactory/>
		<cfset var rstimagesizes="">

		<cfif not StructKeyExists(arguments,"Bundle")>
			<cfquery datasource="#arguments.fromDSN#" name="rstimagesizes">
				select * from timagesizes where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
			</cfquery>
		<cfelse>
			<cfset rstimagesizes = arguments.Bundle.getValue("rstimagesizes")>
		</cfif>

		<cfif rstimagesizes.recordcount>
			<cfquery datasource="#arguments.toDSN#">
				delete from timagesizes where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
		</cfif>
		<cfloop query="rstimagesizes">
			<cfquery datasource="#arguments.toDSN#">
				insert into timagesizes (sizeID,siteID,name,height,width)
				values
				(
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstimagesizes.sizeID)#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstimagesizes.name neq '',de('no'),de('yes'))#" value="#rstimagesizes.name#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstimagesizes.height neq '',de('no'),de('yes'))#" value="#rstimagesizes.height#">,
				<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstimagesizes.width neq '',de('no'),de('yes'))#" value="#rstimagesizes.width#">
				)
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="getToWorkContentCategories" output="false">
		<cfset var keys=arguments.keyFactory/>
		<cfset var rstcontentcategories=""/>

		<cfif application.settingsManager.getSite(arguments.tositeid).getCategoryPoolID() eq arguments.tositeid>
			<!--- tcontentcategories --->
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentcategories">
					select * from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						and lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.lastDeployment#">
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontentcategories = arguments.Bundle.getValue("rstcontentcategories")>
			</cfif>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#application.settingsManager.getSite(arguments.tositeid).getCategoryPoolID()#"/>
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontentcategories.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontentcategories.recordcount>
							categoryID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentcategories.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentcategories.recordcount>or</cfif>
							categoryID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstcontentcategories">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentcategories (categoryID,dateCreated,isActive,isInterestGroup,isOpen,lastUpdate,lastUpdateBy,name,notes,parentID,restrictGroups,siteID,sortBy,sortDirection,Path,remoteID,remoteSourceURL,remotePubDate,filename,urltitle
					<cfif structKeyExists(rstcontentcategories,'isfeatureable')>
					, isfeatureable
					</cfif>
					)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentcategories.categoryID)#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstcontentcategories.dateCreated),de('no'),de('yes'))#" value="#rstcontentcategories.dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentcategories.isActive),de(rstcontentcategories.isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentcategories.isInterestGroup),de(rstcontentcategories.isInterestGroup),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentcategories.isOpen),de(rstcontentcategories.isOpen),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstcontentcategories.lastUpdate),de('no'),de('yes'))#" value="#rstcontentcategories.lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.lastUpdateBy neq '',de('no'),de('yes'))#" value="#rstcontentcategories.lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.name neq '',de('no'),de('yes'))#" value="#rstcontentcategories.name#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstcontentcategories.notes neq '',de('no'),de('yes'))#" value="#rstcontentcategories.notes#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.parentID neq '',de('no'),de('yes'))#" value="#keys.get(rstcontentcategories.parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.restrictGroups neq '',de('no'),de('yes'))#" value="#rstcontentcategories.restrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.sortBy neq '',de('no'),de('yes'))#" value="#rstcontentcategories.sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.sortDirection neq '',de('no'),de('yes'))#" value="#rstcontentcategories.sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstcontentcategories.Path neq '',de('no'),de('yes'))#" value="#rstcontentcategories.Path#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.remoteid neq '',de('no'),de('yes'))#" value="#rstcontentcategories.remoteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.remoteSourceURL neq '',de('no'),de('yes'))#" value="#rstcontentcategories.remoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(rstcontentcategories.remotePubDate neq '',de('no'),de('yes'))#" value="#rstcontentcategories.remotePubDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.filename neq '',de('no'),de('yes'))#" value="#rstcontentcategories.filename#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcategories.urltitle neq '',de('no'),de('yes'))#" value="#rstcontentcategories.urltitle#">
					<cfif structKeyExists(rstcontentcategories,'isfeatureable')>
					, <cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentcategories.isfeatureable),de(rstcontentcategories.isfeatureable),de(1))#">
					</cfif>

					)
				</cfquery>
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="getToWorkFeeds" output="false">
		<cfset var keys=arguments.keyFactory/>
		<cfset var rstcontentfeeds=""/>
		<cfset var rstcontentfeedsnew=""/>
		<cfset var rstcontentfeeditems=""/>
		<cfset var rstcontentfeedadvancedparams=""/>

		<!--- tcontentfeeds --->
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentfeeds">
					select * from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						and lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.lastDeployment#">
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontentfeeds = arguments.Bundle.getValue("rstcontentfeeds")>
			</cfif>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontentfeeds.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontentfeeds.recordcount>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeeds.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeeds.recordcount>or</cfif>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstcontentfeeds">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeeds (allowHTML,channelLink,dateCreated,description,feedID,isActive,isDefault,isFeaturesOnly,isPublic,lang,lastUpdate,lastUpdateBy,maxItems,name,parentID,
					restricted,restrictGroups,siteID,Type,version,sortBy,sortDirection,nextN,displayName,displayRatings,displayComments,altname,remoteID,remoteSourceURL,remotePubDate
					<!--- Check for new fields added in 5.5 --->
					<cfif isdefined("rstcontentfeeds.imageSize")>
					,imageSize,imageHeight,imageWidth,showExcludeSearch,showNavOnly,displaylist
					</cfif>
					<cfif isdefined("rstcontentfeeds.viewalllink")>
					,viewalllink,viewalllabel
					</cfif>
					<cfif isdefined("rstcontentfeeds.autoimport")>
					,autoimport
					</cfif>
					<cfif isdefined("rstcontentfeeds.isLocked")>
					,isLocked
					</cfif>
					<cfif isdefined("rstcontentfeeds.cssclass")>
					,cssclass
					</cfif>
					<cfif isdefined("rstcontentfeeds.contentpoolid")>
					,contentpoolid
					</cfif>
					<cfif isdefined("rstcontentfeeds.authtype")>
					,authtype
					</cfif>
					)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.allowHTML),de(rstcontentfeeds.allowHTML),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstcontentfeeds.channelLink neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.channelLink#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstcontentfeeds.dateCreated),de('no'),de('yes'))#" value="#rstcontentfeeds.dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstcontentfeeds.description neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.description#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentfeeds.feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.isActive),de(rstcontentfeeds.isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.isDefault),de(rstcontentfeeds.isDefault),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.isFeaturesOnly),de(rstcontentfeeds.isFeaturesOnly),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.isPublic),de(rstcontentfeeds.isPublic),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.lang neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.lang#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstcontentfeeds.lastUpdate),de('no'),de('yes'))#" value="#rstcontentfeeds.lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.lastUpdateBy neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.maxItems),de(rstcontentfeeds.maxItems),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.name neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.parentID neq '',de('no'),de('yes'))#" value="#keys.get(rstcontentfeeds.parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.restricted),de(rstcontentfeeds.restricted),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstcontentfeeds.restrictGroups neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.restrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#application.settingsManager.getSite(arguments.toSiteID).getCategoryPoolID()#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.Type neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.Type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.version neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.version#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.sortBy neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.sortDirection neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.nextN),de(rstcontentfeeds.nextN),de(20))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.displayName),de(rstcontentfeeds.displayName),de(1))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.displayRatings),de(rstcontentfeeds.displayRatings),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.displayComments),de(rstcontentfeeds.displayComments),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.altname neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.altname#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.remoteid neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.remoteid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.remoteSourceURL neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.remoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(rstcontentfeeds.remotePubDate neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.remotePubDate#">
					<!--- Check for new fields added in 5.5 --->
					<cfif isdefined("rstcontentfeeds.imageSize")>
					,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.imageSize neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.imageSize#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.imageHeight neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.imageHeight#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.imageWidth neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.imageWidth#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.showExcludeSearch),de(rstcontentfeeds.showExcludeSearch),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.showNavOnly),de(rstcontentfeeds.showNavOnly),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.displaylist neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.displaylist#">
					</cfif>
					<cfif isdefined("rstcontentfeeds.viewalllink")>
					,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.viewalllink neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.viewalllink#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.viewalllabel neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.viewalllabel#">
					</cfif>
					<cfif isdefined("rstcontentfeeds.autoimport")>
					,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.autoimport),de(rstcontentfeeds.autoimport),de(0))#">
					</cfif>
					<cfif isdefined("rstcontentfeeds.isLocked")>
					,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentfeeds.isLocked),de(rstcontentfeeds.isLocked),de(0))#">
					</cfif>
					<cfif isdefined("rstcontentfeeds.cssclass")>
					,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.cssclass neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.cssclass#">
					</cfif>
					<cfif isdefined("rstcontentfeeds.contentpoolid")>
					,
					<!---<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstcontentfeeds.contentpoolid neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.contentpoolid#">--->
					null
					</cfif>
					<cfif isdefined("rstcontentfeeds.authtype")>
					,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentfeeds.authtype neq '',de('no'),de('yes'))#" value="#rstcontentfeeds.authtype#">
					</cfif>
					)
				</cfquery>
			</cfloop>

			<!--- tcontentfeeditems --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeeditems where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontentfeeds.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontentfeeds.recordcount>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeeds.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeeds.recordcount>or</cfif>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentFeedItems">
					select * from tcontentfeeditems where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
					<cfif isDate(arguments.lastDeployment)>
						<cfif rstcontentfeeds.recordcount>
							and feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeeds.feedID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontentFeedItems = arguments.Bundle.getValue("rstcontentfeeditems")>
			</cfif>
			<cfloop query="rstcontentFeedItems">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeeditems (feedID,itemID,type)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentFeedItems.feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentFeedItems.itemID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentFeedItems.type neq '',de('no'),de('yes'))#" value="#rstcontentFeedItems.type#">
					)
				</cfquery>
			</cfloop>

			<!--- tcontentfeedadvancedparams --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeedadvancedparams where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstcontentfeeds.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontentfeeds.recordcount>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeeds.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeeds.recordcount>or</cfif>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentFeedAdvancedParams">
					select * from tcontentfeedadvancedparams where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
					<cfif isDate(arguments.lastDeployment)>
						<cfif rstcontentfeeds.recordcount>
							and feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeeds.feedID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontentFeedAdvancedParams = arguments.Bundle.getValue("rstcontentFeedAdvancedParams")>
			</cfif>
			<cfloop query="rstcontentFeedAdvancedParams">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeedadvancedparams (paramID,feedID,param,relationship,field,dataType,<cfif application.configBean.getDbType() eq "mysql">`condition`<cfelse>condition</cfif>,criteria)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentFeedAdvancedParams.paramID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentFeedAdvancedParams.feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(rstcontentFeedAdvancedParams.param),de('no'),de('yes'))#" value="#rstcontentFeedAdvancedParams.param#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentFeedAdvancedParams.relationship neq '',de('no'),de('yes'))#" value="#rstcontentFeedAdvancedParams.relationship#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentFeedAdvancedParams.field neq '',de('no'),de('yes'))#" value="#rstcontentFeedAdvancedParams.field#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentFeedAdvancedParams.dataType neq '',de('no'),de('yes'))#" value="#rstcontentFeedAdvancedParams.dataType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentFeedAdvancedParams.condition neq '',de('no'),de('yes'))#" value="#rstcontentFeedAdvancedParams.condition#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentFeedAdvancedParams.criteria neq '',de('no'),de('yes'))#" value="#rstcontentFeedAdvancedParams.criteria#">
					)
				</cfquery>
			</cfloop>
	</cffunction>

	<cffunction name="getToWorkFiles" output="false">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="any" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="all" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="lastDeployment" default="" required="true">
		<cfargument name="rsDeleted" required="true" default="#queryNew('objectID')#">
		<cfargument name="moduleID" type="any" required="false" default="">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">
		<cfargument name="keyMode" type="string" default="copy" required="true">
		<cfargument name="mailingListMembersMode" type="string" default="none" required="true">

		<cfset var rsttrashfiles="">
		<cfset var rstfiles="">
		<cfset var keys=arguments.keyfactory>
		<cfset var rstplugins="">
		<!---<cfset var moduleIDSqlList="">--->
		<cfset var i="">
		<cfset var rsFileCheck="">
		<cfset var cfBlobType="cf_sql_BLOB">
		<cfset var toFilePoolID=getBean('settingsManager').getSite(arguments.toSiteID).getFilePoolID()>

		<cfif len(arguments.fromSiteID)>
			<cfset var fromFilePoolID=getBean('settingsManager').getSite(arguments.fromSiteID).getFilePoolID()>
		</cfif>

		<cfif application.configBean.getDbType() eq "postgresql">
			<cfset cfBlobType="cf_sql_LONGVARBINARY">
		</cfif>
		<!---
		<cfloop list="#arguments.moduleID#" index="i">
			<cfset moduleIDSQLlist=listAppend(moduleIDlist,"'#keys.get(i)#'")>
		</cfloop>
		--->

		<cfif not structKeyExists(arguments,"Bundle")
			and arguments.toSiteID eq arguments.fromSiteID>
			<cfreturn true>
		</cfif>

		<!--- tfiles --->
			<cfif structKeyExists(arguments,"Bundle")>
				<cfset rsttrashfiles=bundle.getValue("rsttrashfiles")/>
			<cfelse>
				<cfset rsttrashfiles=queryNew("objectID")>
			</cfif>

			<cfif isDate(arguments.lastDeployment) and rsttrashfiles.recordcount>
				<cfif rsttrashfiles.recordcount>
					<cfloop query="rsttrashfiles">
						<cfdirectory name="rsFileCheck" action="list" directory="#application.confiBean.getFileDir()#/#toFilePoolID#/cache/file/" filter="#rsttrashfiles.fileID#*">
						<cfif rsFileCheck.recordcount>
							<cfloop query="rsFileCheck">
								<cffile action="delete" file="#application.confiBean.getFileDir()#/#toFilePoolID#/cache/file/#rsFileCheck.name#">
							</cfloop>
						</cfif>
					</cfloop>
				</cfif>

				<cfquery datasource="#arguments.toDSN#">
				delete from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#toFilePoolID#"/>
				and moduleid  in (''<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.usersMode neq "none">,'00000000000000000000000000000000008'</cfif><cfif arguments.contentMode neq "none">,'00000000000000000000000000000000000','00000000000000000000000000000000003'</cfif><cfif arguments.formDataMode neq "none">,'00000000000000000000000000000000004'</cfif>)
				<cfif rsttrashfiles.recordcount>
					and fileID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valuesList(rsttrashfiles.fileID)#">)
				<cfelse>
					and 0=1
				</cfif>
				</cfquery>
			</cfif>

			<cfif not isDate(arguments.lastDeployment) and not getBean('settingsManager').getSite(arguments.tositeid).getHasSharedFilePool()>
				<cfquery datasource="#arguments.toDSN#">
					delete from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#toFilePoolID#"/>
					and moduleid  in (''<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.usersMode neq "none">,'00000000000000000000000000000000008'</cfif><cfif arguments.contentMode neq "none">,'00000000000000000000000000000000000','00000000000000000000000000000000003'</cfif><cfif arguments.formDataMode neq "none">,'00000000000000000000000000000000004'</cfif>)
				</cfquery>
			</cfif>

			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstFiles">
					select * from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fromFilePoolID#"/>
					and moduleid  in (''<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.usersMode neq "none">,'00000000000000000000000000000000008'</cfif><cfif arguments.contentMode neq "none">,'00000000000000000000000000000000000','00000000000000000000000000000000003'</cfif><cfif arguments.formDataMode neq "none">,'00000000000000000000000000000000004'</cfif>)
					<cfif isDate(arguments.lastDeployment)>
						created >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.lastDeployment#">
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstFiles = arguments.Bundle.getValue("rstfiles")>
				<cfquery name="rstfiles" dbtype="query">
					select * from rstfiles where
					moduleid  in (''<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.usersMode neq "none">,'00000000000000000000000000000000008'</cfif><cfif arguments.contentMode neq "none">,'00000000000000000000000000000000000','00000000000000000000000000000000003'</cfif><cfif arguments.formDataMode neq "none">,'00000000000000000000000000000000004'</cfif>)
				</cfquery>
			</cfif>

			<cfloop query="rstFiles">
				<cfquery datasource="#arguments.toDSN#">
					insert into tfiles (contentID,contentSubType,contentType,fileExt,fileID,filename,fileSize,
					<!---
					<cfif not StructKeyExists(arguments,"Bundle")>
					image,imageMedium,imageSmall,
					</cfif>
					--->
					moduleID,siteID,created
					<cfif structKeyExists(rstfiles, "caption")>
						,caption
						,credits
						,alttext
						,remoteid
						,RemoteURL
						,remotePubDate
						,RemoteSource
						,remoteSourceURL
					</cfif>
					<cfif structKeyExists(rstfiles, "exif")>
						,exif
					</cfif>
					)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.contentID neq '',de('no'),de('yes'))#" value="#keys.get(rstFiles.contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.contentSubType neq '',de('no'),de('yes'))#" value="#rstFiles.contentSubType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.contentType neq '',de('no'),de('yes'))#" value="#rstFiles.contentType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.fileExt neq '',de('no'),de('yes'))#" value="#rstFiles.fileExt#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.fileID neq '',de('no'),de('yes'))#" value="#keys.get(rstFiles.fileID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.filename neq '',de('no'),de('yes'))#" value="#rstFiles.filename#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstFiles.fileSize),de(rstFiles.fileSize),de(0))#">,
					<!---
					<cfif not StructKeyExists(arguments,"Bundle")>
						<cfqueryparam cfsqltype="#cfBlobType#" null="#iif(toBase64(rstFiles.image) eq '',de('yes'),de('no'))#" value="#rstFiles.image#">,
						<cfqueryparam cfsqltype="#cfBlobType#" null="#iif(toBase64(rstFiles.imageMedium) eq '',de('yes'),de('no'))#" value="#rstFiles.imageMedium#">,
						<cfqueryparam cfsqltype="#cfBlobType#" null="#iif(toBase64(rstFiles.imageSmall) eq '',de('yes'),de('no'))#" value="#rstFiles.imageSmall#">,
					</cfif>
					--->
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstfiles.moduleID neq '',de('no'),de('yes'))#" value="#rstfiles.moduleID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#toFilePoolID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstFiles.created),de('no'),de('yes'))#" value="#rstFiles.created#">
					<cfif structKeyExists(rstfiles, "caption")>
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.caption neq '',de('no'),de('yes'))#" value="#rstFiles.caption#">
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.credits neq '',de('no'),de('yes'))#" value="#rstFiles.credits#">
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.alttext neq '',de('no'),de('yes'))#" value="#rstFiles.alttext#">
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.remoteid neq '',de('no'),de('yes'))#" value="#rstFiles.remoteid#">
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.remoteurl neq '',de('no'),de('yes'))#" value="#rstFiles.remoteurl#">
						,<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstFiles.remotePubDate),de('no'),de('yes'))#" value="#rstFiles.remotePubDate#">
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.remotesource neq '',de('no'),de('yes'))#" value="#rstFiles.remotesource#">
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.remotesourceurl neq '',de('no'),de('yes'))#" value="#rstFiles.remotesourceurl#">
					</cfif>
					<cfif structKeyExists(rstfiles, "exif")>
						,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstFiles.exif neq '',de('no'),de('yes'))#" value="#rstFiles.exif#">
					</cfif>
					)
				</cfquery>
			</cfloop>

	</cffunction>

	<cffunction name="getToWorkTrash" output="false">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="all" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="keyMode" type="string" default="copy" required="true">
		<cfargument name="usersMode" type="string" default="none" required="true">

		<cfset var keys=arguments.keyFactory/>
		<cfset var rsttrash=""/>
		<cfset var rsttrashfiles=""/>
		<cfset var allValues="">
		<cfset var rsFileCheck=""/>

			<cfset rsttrash=Bundle.getValue("rsttrash")>
			<cfquery datasource="#arguments.toDSN#">
				delete from ttrash where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif isDate(arguments.lastDeployment)>
					<cfif rsttrash.recordcount>
						and fileID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsttrash.objectID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>

			<cfif not isDate(arguments.lastDeployment)>
				<cfloop query="rsttrash">
					<cftry>
					<!--- convert the objects data to the new siteID --->
					<cfif arguments.toSiteID neq rsttrash.siteID or arguments.keyFactory.getMode() neq "publish">
						<cfwddx action = "wddx2cfml" input = "#rsttrash.objectstring#" output = "allValues">
						<cfset allValues.siteid=arguments.tositeID>

						<cfif structKeyExists(allValues,"contentID")>
							<cfset allValues.contentID=arguments.keyFactory.get(allValues.contentID)>
						</cfif>
						<cfif structKeyExists(allValues,"contentHistID")>
							<cfset allValues.contentHistID=arguments.keyFactory.get(allValues.contentHistID)>
						</cfif>
						<cfif structKeyExists(allValues,"categoryID")>
							<cfset allValues.categoryID=arguments.keyFactory.get(allValues.categoryID)>
						</cfif>
						<cfif structKeyExists(allValues,"feedID")>
							<cfset allValues.feedID=arguments.keyFactory.get(allValues.feedID)>
						</cfif>
						<cfif structKeyExists(allValues,"parentID")>
							<cfset allValues.parentID=arguments.keyFactory.get(allValues.parentID)>
						</cfif>
						<cfif structKeyExists(allValues,"commentID")>
							<cfset allValues.parentID=arguments.keyFactory.get(allValues.commentID)>
						</cfif>
						<cfif structKeyExists(allValues,"userID")>
							<cfset allValues.parentID=arguments.keyFactory.get(allValues.userID)>
						</cfif>
						<cfif structKeyExists(allValues,"mlid")>
							<cfset allValues.mlid=arguments.keyFactory.get(allValues.mlid)>
						</cfif>
						<cfif structKeyExists(allValues,"changesetID")>
							<cfset allValues.changesetID=arguments.keyFactory.get(allValues.changesetID)>
						</cfif>

						<cfwddx action="cfml2wddx" input="#allValues#" output="allValues">
					</cfif>

					<cfquery datasource="#arguments.toDSN#">
						insert into ttrash (objectID,parentID,siteID,objectClass,
							objectLabel,objectType,objectSubType,objectString,deletedDate,deletedBy
							<cfif isDefined("rsttrash.deleteid")>
								,deleteID
								,orderno
							</cfif>)
							values(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rsttrash.objectID)#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rsttrash.parentID)#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsttrash.objectClass#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsttrash.objectLabel#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsttrash.objectType#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsttrash.objectSubType#" />,
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#allValues#" />,
								#createODBCDateTime(deletedDate)#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsttrash.deletedBy#" />
								<cfif isDefined("rsttrash.deleteid")>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsttrash.deleteid#" />
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsttrash.orderno#" />
								</cfif>
							)
					</cfquery>

					<cfcatch></cfcatch>
					</cftry>
				</cfloop>
			</cfif>

	</cffunction>

	<cffunction name="getToWorkSyncMeta" output="false">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">

		<cfset var keys=arguments.keyFactory/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstcontentstats=""/>
		<cfset var allValues="">
		<cfset var rsFileCheck=""/>

		<cfif not isDate(arguments.lastDeployment) and arguments.Bundle.getValue("hasmetadata","true")>
			<cfset rstcontentcomments=arguments.Bundle.getValue("rstcontentcomments")>

			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcomments where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>

			<cfloop query="rstcontentcomments">
					<cfquery datasource="#arguments.toDSN#">
							insert into tcontentcomments (
							comments,commentid,contenthistid,contentid,email,entered,ip,isApproved,name,siteid,url,subscribe,parentID,path
							<!--- added in 5.6 --->
							<cfif isdefined("rstcontentcomments.remoteid")>
								,remoteID
							</cfif>
							)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstcontentcomments.comments neq '',de('no'),de('yes'))#" value="#rstcontentcomments.comments#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.commentid neq '',de('no'),de('yes'))#" value="#keys.get(rstcontentcomments.commentID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.contenthistid neq '',de('no'),de('yes'))#" value="#keys.get(rstcontentcomments.contentHistID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.contentid neq '',de('no'),de('yes'))#" value="#keys.get(rstcontentcomments.contentID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.email neq '',de('no'),de('yes'))#" value="#rstcontentcomments.email#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstcontentcomments.entered),de('no'),de('yes'))#" value="#rstcontentcomments.entered#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.ip neq '',de('no'),de('yes'))#" value="#rstcontentcomments.ip#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentcomments.isApproved),de(rstcontentcomments.isApproved),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.name neq '',de('no'),de('yes'))#" value="#rstcontentcomments.name#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeid#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.url neq '',de('no'),de('yes'))#" value="#rstcontentcomments.url#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentcomments.subscribe),de(rstcontentcomments.subscribe),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.parentID neq '',de('no'),de('yes'))#" value="#keys.get(rstcontentcomments.parentID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.path neq '',de('no'),de('yes'))#" value="#rstcontentcomments.path#">
							<cfif isdefined("rstcontentcomments.remoteid")>
								,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentcomments.remoteid neq '',de('no'),de('yes'))#" value="#rstcontentcomments.remoteid#">
							</cfif>
							)
					</cfquery>
			</cfloop>

			<cfset rstcontentratings=Bundle.getValue("rstcontentratings")>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentratings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
			<cfloop query="rstcontentratings">
				<cfquery datasource="#arguments.fromDSN#">
					insert into tcontentratings (contentID,rate,siteID,userID,entered)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentratings.contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentratings.rate),de(rstcontentratings.rate),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.fromsiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentratings.userID neq '',de('no'),de('yes'))#" value="#keys.get(rstcontentratings.userID)#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstcontentratings.entered),de('no'),de('yes'))#" value="#rstcontentratings.entered#">
					)
				</cfquery>
			</cfloop>

			<cfset rstcontentstats=Bundle.getValue("rstcontentstats")>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentstats where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
			<cfloop query="rstcontentstats">
				<cfquery datasource="#arguments.fromDSN#">
					insert into tcontentstats (contentID,siteID,views,rating,totalVotes,upVotes,downVotes,comments
					<cfif isdefined("rstcontentstats.majorVersion")>
					,majorVersion,minorVersion, lockID
					</cfif>
					<cfif isdefined("rstcontentstats.lockType")>
					,lockType
					</cfif>
					<cfif isdefined("rstcontentstats.disableComments")>
					,disableComments
					</cfif>
					)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstcontentstats.contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.views),de(rstcontentstats.views),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.rating),de(rstcontentstats.rating),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.totalVotes),de(rstcontentstats.totalVotes),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.upVotes),de(rstcontentstats.upVotes),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.downVotes),de(rstcontentstats.downVotes),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.comments),de(rstcontentstats.comments),de(0))#">
					<!--- Check for new fields added in 5.6 --->
					<cfif isdefined("rstcontentstats.majorVersion")>
					,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.majorVersion),de(rstcontentstats.majorVersion),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.minorVersion),de(rstcontentstats.minorVersion),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentstats.lockID neq '',de('no'),de('yes'))#" value="#rstcontentstats.lockID#">
					</cfif>
					<cfif isdefined("rstcontentstats.lockType")>
					,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontentstats.lockType neq '',de('no'),de('yes'))#" value="#rstcontentstats.lockType#">
					</cfif>
					<cfif isdefined("rstcontentstats.disableComments")>
					,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstcontentstats.disableComments),de(rstcontentstats.disableComments),de(0))#">
					</cfif>
					)
				</cfquery>
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="getToWorkFormData" output="false">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="any" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="all" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="lastDeployment" default="" required="true">
		<cfargument name="rsDeleted" required="true" default="#queryNew('objectID')#">
		<cfargument name="moduleID" type="any" required="false" default="">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">
		<cfargument name="keyMode" type="string" default="copy" required="true">
		<cfargument name="mailingListMembersMode" type="string" default="none" required="true">
		<cfargument name="formDataMode" type="string" default="none" required="true">

		<cfset var keys=arguments.keyFactory/>
		<cfset var rstformresponsepackets="">
		<cfset var rstformresponsequestions="">

		<cfif arguments.formDataMode neq "none" and structKeyExists(arguments,"Bundle")>
				<cfset rstformresponsepackets = arguments.Bundle.getValue("rstformresponsepackets")>

				<cfquery datasource="#arguments.toDSN#">
					delete from tformresponsepackets where siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
				</cfquery>

				<cfloop query="rstformresponsepackets">
					<cfquery datasource="#arguments.toDSN#">
						insert into tformresponsepackets (responseid,formid,siteid,fieldlist,data,entered)
						values (
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstformresponsepackets.responseID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstformresponsepackets.formID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstformresponsepackets.fieldlist neq '',de('no'),de('yes'))#" value="#rstformresponsepackets.fieldlist#">,
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstformresponsepackets.data neq '',de('no'),de('yes'))#" value="#rstformresponsepackets.data#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstformresponsepackets.entered),de('no'),de('yes'))#" value="#rstformresponsepackets.entered#">
						)
					</cfquery>
				</cfloop>

				<cfset rstformresponsequestions = arguments.Bundle.getValue("rstformresponsequestions")>

				<cfquery datasource="#arguments.toDSN#">
					delete from tformresponsequestions
					where formID in (
									select contentID from tcontent where
									type='Form'
									and active=1
									and siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
									)
				</cfquery>

				<cfloop query="rstformresponsequestions">
					<cftry>
					<cfquery datasource="#arguments.toDSN#">
						insert into tformresponsequestions (responseid,formid,formField,formValue,pollValue)
						values (
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstformresponsequestions.responseID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstformresponsequestions.formID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstformresponsequestions.formField neq '',de('no'),de('yes'))#" value="#rstformresponsequestions.formField#">,
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstformresponsequestions.formValue neq '',de('no'),de('yes'))#" value="#rstformresponsequestions.formValue#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstformresponsequestions.pollValue neq '',de('no'),de('yes'))#" value="#rstformresponsequestions.pollValue#">
						)
					</cfquery>
					<cfcatch>
						<cfset local.error={
							responseID=rstformresponsequestions.responseID,
							formID=rstformresponsequestions.formID,
							formField=rstformresponsequestions.formField,
							formValue=rstformresponsequestions.formValue,
							pollValue=rstformresponsequestions.pollValue
						}>
						<cflog log="application" text="bundle error - rstformresponsequestions: #serializeJSON(local.error)#">
					</cfcatch>
					</cftry>
				</cfloop>
			</cfif>

	</cffunction>

	<cffunction name="getToWorkMailingLists" output="false">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="any" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="all" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="lastDeployment" default="" required="true">
		<cfargument name="rsDeleted" required="true" default="#queryNew('objectID')#">
		<cfargument name="moduleID" type="any" required="false" default="">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">
		<cfargument name="keyMode" type="string" default="copy" required="true">
		<cfargument name="mailingListMembersMode" type="string" default="none" required="true">
		<cfargument name="formDataMode" type="string" default="none" required="true">

		<cfset var keys=arguments.keyFactory/>
		<cfset var rstMailinglist=""/>
		<cfset var rstMailinglistnew=""/>
		<cfset var rstMailinglistmembers="">

		<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstMailinglist">
					select * from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						 and lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.lastDeployment#">
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstMailinglist = arguments.Bundle.getValue("rstMailinglist")>
			</cfif>
			<cfquery datasource="#arguments.toDSN#">
				delete from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif isDate(arguments.lastDeployment)>
					<cfif rstMailinglist.recordcount or rsDeleted.recordcount>
						and (
							lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.lastDeployment#">
						<cfif rsDeleted.recordcount>
							or
							mlid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstMailinglist">
				<cfquery datasource="#arguments.toDSN#">
					insert into tmailinglist (Description,isPublic,isPurge,LastUpdate,MLID,Name,SiteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstMailinglist.Description neq '',de('no'),de('yes'))#" value="#rstMailinglist.Description#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstMailinglist.isPublic),de(rstMailinglist.isPublic),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstMailinglist.isPurge),de(rstMailinglist.isPurge),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstMailinglist.LastUpdate),de('no'),de('yes'))#" value="#rstMailinglist.LastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstMailinglist.MLID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstMailinglist.Name neq '',de('no'),de('yes'))#" value="#rstMailinglist.Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
					)
				</cfquery>
			</cfloop>

			<cfif arguments.mailingListMembersMode neq "none" and structKeyExists(arguments,"Bundle")>

			<cfset rstMailinglistmembers = arguments.Bundle.getValue("rstMailinglistmembers")>

			<cfquery datasource="#arguments.toDSN#">
				delete from tmailinglistmembers where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>

			<cfloop query="rstMailinglistmembers">
				<cfquery datasource="#arguments.toDSN#">
					insert into tmailinglistmembers (MLID,Email,SiteID,fname,lname,company,isVerified,created)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstMailinglistmembers.MLID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#rstMailinglistmembers.Email#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstMailinglistmembers.fname neq '',de('no'),de('yes'))#" value="#rstMailinglistmembers.fname#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstMailinglistmembers.lname neq '',de('no'),de('yes'))#" value="#rstMailinglistmembers.lname#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstMailinglistmembers.company neq '',de('no'),de('yes'))#" value="#rstMailinglistmembers.company#">,
					<cfif isNumeric(rstMailinglistmembers.isVerified)>
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#rstMailinglistmembers.isVerified#">,
					<cfelse>
						0,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstMailinglistmembers.created),de('no'),de('yes'))#" value="#rstMailinglistmembers.created#">
					)
				</cfquery>
			</cfloop>
			</cfif>

	</cffunction>

	<cffunction name="getToWorkUsers" output="false">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="usersMode" type="any" required="false">
		<cfargument name="lastDeployment" type="any" required="false">
		<cfargument name="errors" type="any" required="true" default="#structNew()#">

		<cfset var rstusers="">
		<cfset var rstusersonly=queryNew("empty")>
		<cfset var rstusersmemb="">
		<cfset var rstuserstags="">
		<cfset var rstusersinterests="">
		<cfset var rstusersfavorites="">
		<cfset var rstuseraddresses="">
		<cfset var keys=arguments.keyFactory>
		<cfset var rstpermissions="">
		<cfset var publicUserPoolID=application.settingsManager.getSite(arguments.toSiteID).getPublicUserPoolID()>
		<cfset var privateUserPoolID=application.settingsManager.getSite(arguments.toSiteID).getPrivateUserPoolID()>
		<cfset var rsUserCheck="">
		<cfset arguments.rsUserConflicts=queryNew("userID")>

		<!--- tpermissions--->
			<cfquery datasource="#arguments.toDSN#">
				delete from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstpermissions">
					select * from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
			<cfelse>
				<cfset rsTPermissions = arguments.Bundle.getValue("rstpermissions")>
			</cfif>
			<cfloop query="rstpermissions">
				<cfquery datasource="#arguments.toDSN#">
					insert into tpermissions (contentID,groupID,Type,SiteID)
					values
					(
					<cfif rstpermissions.type eq "module" or not find("-",rstpermissions.contentID)>
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#rstpermissions.contentID#">
					<cfelse>
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstpermissions.contentID)#">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstpermissions.groupID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstpermissions.type neq '',de('no'),de('yes'))#" value="#rstpermissions.type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
					)
				</cfquery>
			</cfloop>

		<cfif arguments.usersMode neq "none" and structKeyExists(arguments,"Bundle")>
			<cfset rstusers = arguments.Bundle.getValue("rstusers")>

			<cfif rstusers.recordcount>
				<cfquery name="rstusersonly" dbtype="query">
					select * from rstusers
					where type=2
				</cfquery>
			</cfif>

			<cfif rstusersonly.recordcount>
				<cfquery name="arguments.rsUserConflicts" datasource="#arguments.toDSN#">
					select userID,username from tusers where
					username in (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstusers.username)#" list="true">
								)
					and not
						(
							(
								siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
								and isPublic=0
							)

							or

							(
								siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
								and isPublic=1
							)
						)
				</cfquery>

				<cfif arguments.rsUserConflicts.recordcount>
					<cfset arguments.errors["existingusers"]="#arguments.rsUserConflicts.recordcount# users were not imported because username conflicts.">
				</cfif>

				<cfif arguments.rsUserConflicts.recordcount>
					<cfquery name="rstusers" dbtype="query">
						select * from rstusers
						where username not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.username)#" list="true">)
					</cfquery>
				</cfif>
			</cfif>

			<cfif not rstusers.recordcount>
				<cfset arguments.errors["nousers"]="No users were found to be imported.">
			</cfif>

			<cfif rstusers.recordcount>

				<!--- TUSERSMEMB--->
				<cfset rstusersmemb = arguments.Bundle.getValue("rstusersmemb")>

				<cfquery datasource="#arguments.toDSN#">
					delete from tusersmemb where
					userID in (
								select userID from tusers where
								(
									(
										siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
										and isPublic=0
									)

									or

									(
										siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
										and isPublic=1
									)
								)
							)
				   <cfif arguments.rsUserConflicts.recordcount>
						and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
				   </cfif>
				</cfquery>

				<cfif arguments.rsUserConflicts.recordcount>
					<cfquery name="rstusersmemb" dbtype="query">
						select * from rstusersmemb
						where userID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(rstusers.userID)#" list="true">)
					</cfquery>
				</cfif>

				<cfloop query="rstusersmemb">
					<cftry>
					<cfquery datasource="#arguments.toDSN#">
						insert into tusersmemb (userID,groupID) values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstusersmemb.userID)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstusersmemb.groupID)#">
						)
					</cfquery>
					<cfcatch></cfcatch>
					</cftry>
				</cfloop>

				<!--- TUSERSTAGS--->
				<cfset rstuserstags = arguments.Bundle.getValue("rstuserstags")>

				<cfif rstuserstags.recordcount>
					<cfif arguments.rsUserConflicts.recordcount>
						<cfquery name="rstuserstags" dbtype="query">
							select * from rstuserstags
							where userID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(rstusers.userID)#" list="true">)
						</cfquery>
					</cfif>

					<cfquery datasource="#arguments.toDSN#">
						delete from tuserstags where
						userID in (
									select userID from tusers where
									(
										(
											siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
											and isPublic=0
										)

										or

										(
											siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
											and isPublic=1
										)
									)
								)

						<cfif arguments.rsUserConflicts.recordcount>
							and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
					   </cfif>
					</cfquery>

					<cfloop query="rstuserstags">
						<cfquery name="rsUserCheck" dbtype="query">
							select isPublic from rstusers
							where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstuserstags.userid#">
						</cfquery>
						<cfif rsUserCheck.recordcount>
							<cfquery datasource="#arguments.toDSN#">
								insert into tuserstags (userID,siteID,tag) values (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstuserstags.userID)#">,
								<cfif rsUserCheck.isPublic>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#">
								</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstuserstags.tag#">
								)
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>

				<!--- TUSERSINTERESTS--->
				<cfset rstusersinterests = arguments.Bundle.getValue("rstusersinterests")>

				<cfif rstusersinterests.recordcount>
					<cfif arguments.rsUserConflicts.recordcount>
						<cfquery name="rstusersinterests" dbtype="query">
							select * from rstusersinterests
							where userID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(rstusers.userID)#" list="true">)
						</cfquery>
					</cfif>

					<cfquery datasource="#arguments.toDSN#">
						delete from tusersinterests where
						userID in (
									select userID from tusers where
									(
										(
											siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
											and isPublic=0
										)

										or

										(
											siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
											and isPublic=1
										)
									)
								)
						<cfif arguments.rsUserConflicts.recordcount>
							and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
					   </cfif>
					</cfquery>

					<cfloop query="rstusersinterests">
						<cfquery datasource="#arguments.toDSN#">
							insert into tusersinterests (userID,categoryID) values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstusersinterests.userID)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstusersinterests.categoryID)#">
							)
						</cfquery>
					</cfloop>
				</cfif>
				<!--- TUSERSFAVORITES--->
				<cfset rstusersfavorites = arguments.Bundle.getValue("rstusersfavorites")>

				<cfif arguments.rsUserConflicts.recordcount>
					<cfquery name="rstusersfavorites" dbtype="query">
						select * from rstusersfavorites
						where userID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(rstusers.userID)#" list="true">)
					</cfquery>
				</cfif>

				<cfquery datasource="#arguments.toDSN#">
					delete from tusersfavorites where
					siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#"/>
					<cfif arguments.rsUserConflicts.recordcount>
						and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
				   </cfif>
				</cfquery>

				<cfloop query="rstusersfavorites">
					<cfquery datasource="#arguments.toDSN#">
						insert into tusersfavorites (favoriteID,userID,favoriteName,favorite,type,siteID,dateCreated,columnNumber,rowNumber,maxRssItems ) values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstusersfavorites.favoriteID)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstusersfavorites.userID)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusersfavorites.favoriteName neq '',de('no'),de('yes'))#" value="#rstusersfavorites.favoriteName#">,
						<cfif isValid("UUID",favorite)>
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusersfavorites.favorite neq '',de('no'),de('yes'))#" value="#keys.get(rstusersfavorites.favorite)#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusersfavorites.favorite neq '',de('no'),de('yes'))#" value="#rstusersfavorites.favorite#">,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusersfavorites.type neq '',de('no'),de('yes'))#" value="#rstusersfavorites.type#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,
					    #createODBCDateTime(dateCreated)#,
						<cfqueryparam cfsqltype="cf_sql_integer" null="#iif(isnumeric(rstusersfavorites.columnNumber),de('no'),de('yes'))#" value="#rstusersfavorites.columnNumber#">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="#iif(isnumeric(rstusersfavorites.rowNumber),de('no'),de('yes'))#" value="#rstusersfavorites.rowNumber#">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="#iif(isnumeric(rstusersfavorites.maxRSSItems),de('no'),de('yes'))#" value="#rstusersfavorites.maxRSSItems#">
						)
					</cfquery>
				</cfloop>

				<!--- TUSERADDRESSES --->
				<cfset rstuseraddresses = arguments.Bundle.getValue("rstuseraddresses")>

				<cfif arguments.rsUserConflicts.recordcount>
					<cfquery name="rstuseraddresses" dbtype="query">
						select * from rstuseraddresses
						where userID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(rstusers.userID)#" list="true">)
					</cfquery>
				</cfif>

				<cfquery datasource="#arguments.toDSN#">
					delete from tuseraddresses where
					userID in (
									select userID from tusers where
									(
										(
											siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
											and isPublic=0
										)

										or

										(
											siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
											and isPublic=1
										)
									)
								)
					<cfif arguments.rsUserConflicts.recordcount>
						and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
				   </cfif>
				</cfquery>

				<cfloop query="rstuseraddresses">
					<cfquery name="rsUserCheck" dbtype="query">
						select isPublic from rstusers
						where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstuseraddresses.userid#">
					</cfquery>
					<cfif rsUserCheck.recordcount>
						<cfquery datasource="#arguments.toDSN#">
							INSERT INTO tuseraddresses  (AddressID,UserID,siteID,
								phone,fax,address1, address2, city, state, zip ,
								addressName,country,isPrimary,addressNotes,addressURL,
								longitude,latitude,addressEmail,hours)
						     VALUES(
						        <cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstuseraddresses.addressID)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstuseraddresses.userID)#">,
								<cfif rsUserCheck.isPublic>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#">
								</cfif>,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.Phone neq '',de('no'),de('yes'))#" value="#rstuseraddresses.Phone#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.Fax neq '',de('no'),de('yes'))#" value="#rstuseraddresses.Fax#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.Address1 neq '',de('no'),de('yes'))#" value="#rstuseraddresses.Address1#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.Address2 neq '',de('no'),de('yes'))#" value="#rstuseraddresses.Address2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.City neq '',de('no'),de('yes'))#" value="#rstuseraddresses.City#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.State neq '',de('no'),de('yes'))#" value="#rstuseraddresses.State#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.Zip neq '',de('no'),de('yes'))#" value="#rstuseraddresses.Zip#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.AddressName neq '',de('no'),de('yes'))#" value="#rstuseraddresses.AddressName#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.Country neq '',de('no'),de('yes'))#" value="#rstuseraddresses.Country#">,
								#rstuseraddresses.isprimary#,
								<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(rstuseraddresses.AddressNotes neq '',de('no'),de('yes'))#" value="#rstuseraddresses.AddressNotes#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.AddressURL neq '',de('no'),de('yes'))#" value="#rstuseraddresses.AddressURL#">,
								#rstuseraddresses.Longitude#,
								#rstuseraddresses.Latitude#,
								<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstuseraddresses.AddressEmail neq '',de('no'),de('yes'))#" value="#rstuseraddresses.AddressEmail#">,
								<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(rstuseraddresses.Hours neq '',de('no'),de('yes'))#" value="#rstuseraddresses.Hours#">
								  )
						</cfquery>
					</cfif>
				</cfloop>

				<cfquery datasource="#arguments.toDSN#">
					delete from tusers where
						(
							(
								siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
								and isPublic=0
							)

							or

							(
								siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
								and isPublic=1
							)
						)
					 <cfif arguments.rsUserConflicts.recordcount>
						and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
				   </cfif>
				</cfquery>

				<cfloop query="rstusers">
					<cfquery datasource="#arguments.toDSN#">
						INSERT INTO tusers  (UserID, RemoteID, s2, Fname, Lname, Password, PasswordCreated,
						Email, GroupName, Type, subType, ContactForm, LastUpdate, lastupdateby, lastupdatebyid,InActive, username,  perm, isPublic,
						company,jobtitle,subscribe,siteid,website,notes,mobilePhone,
						description,interests,photoFileID,keepPrivate,IMName,IMService,created,tags, tablist)
				     VALUES(
				        <cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstusers.userID)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rstusers.remoteID#">,
						 #rstusers.s2#,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Fname neq '',de('no'),de('yes'))#" value="#rstusers.fname#">,
						  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Lname neq '',de('no'),de('yes'))#" value="#rstusers.lname#">,
				         <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Password neq '',de('no'),de('yes'))#" value="#rstusers.password#">,
						 <cfif isDate(rstusers.passwordCreated)>#createODBCDateTime(rstusers.passwordCreated)#<cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Email neq '',de('no'),de('yes'))#" value="#rstusers.email#">,
				         <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.GroupName neq '',de('no'),de('yes'))#" value="#rstusers.groupname#">,
				         #rstusers.Type#,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.SubType neq '',de('no'),de('yes'))#" value="#rstusers.subtype#">,
				        <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(rstusers.ContactForm neq '',de('no'),de('yes'))#" value="#rstusers.contactform#">,
						  <cfif isDate(rstusers.lastUpdate)>#createodbcdatetime(rstusers.lastUpdate)#<cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.LastUpdateBy neq '',de('no'),de('yes'))#" value="#rstusers.lastupdateBy#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.LastUpdateById neq '',de('no'),de('yes'))#" value="#keys.get(rstusers.lastUpdateByID)#">,
						 #rstusers.InActive#,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Username neq '',de('no'),de('yes'))#" value="#rstusers.username#">,
						  #rstusers.perm#,
						  #rstusers.ispublic#,
						   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Company neq '',de('no'),de('yes'))#" value="#rstusers.company#">,
						   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.JobTitle neq '',de('no'),de('yes'))#" value="#rstusers.jobTitle#">,
						  #rstusers.subscribe#,
						  <cfif rstusers.isPublic>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#">
						  </cfif>,
						  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Website neq '',de('no'),de('yes'))#" value="#rstusers.website#">,
						 <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(rstusers.Notes neq '',de('no'),de('yes'))#" value="#rstusers.notes#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.MobilePhone neq '',de('no'),de('yes'))#" value="#rstusers.mobilePhone#">,
						  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Description neq '',de('no'),de('yes'))#" value="#rstusers.description#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.Interests neq '',de('no'),de('yes'))#" value="#translateKeyList(rstusers.interests,keys)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.photoFileID neq '',de('no'),de('yes'))#" value="#keys.get(rstusers.photoFileID)#">,
						#rstusers.KeepPrivate#,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.IMName neq '',de('no'),de('yes'))#" value="#rstusers.IMName#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.IMService neq '',de('no'),de('yes'))#" value="#rstusers.IMService#">,
						  <cfif isDate(rstusers.created)>#createODBCDAteTime(rstusers.created)#<cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.tags neq '',de('no'),de('yes'))#" value="#rstusers.tags#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(rstusers.tablist neq '',de('no'),de('yes'))#" value="#rstusers.tablist#">
						 )
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="getToWorkClassExtensions">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="lastDeployment" type="string" default="" required="true">
		<cfargument name="rsDeleted" required="true" default="#queryNew('objectID')#">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">
		<cfargument name="usersMode" type="string" default="all" required="true">
		<cfargument name="keyMode" type="string" default="copy" required="true">

		<cfset var keys=arguments.keyFactory/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendrcsets="">
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getAttributeID=""/>
		<cfset var existingAttributeList=""/>
		<cfset arguments.fileattributeList=""/>
		<cfset var rsbaseids=""/>
		<cfset var typeList="">
		<cfset var incomingAttributeList="">
		<cfset var rsCheck="">
		<cfset var rstclassextenddatauseractivity="">
		<cfset var rsFeedParams="">
		<cfset var rssite="">
		<cfset var tclassextendrcsets="">

		<cfparam name="arguments.rsUserConflicts" default="#queryNew('userID')#">

		<cfif arguments.usersMode neq "none">
			<cfset typeList="1,2,User,Group,Address">
		</cfif>
		<cfif arguments.contentMode neq "none">
			<cfif arguments.usersMode neq "none">
				<cfset typeList=typeList & ",">
			</cfif>
			<cfset typeList=typeList & "Custom,Page,Folder,Portal,Gallery,Calendar,Link,File,Component,Site,Base">
		</cfif>

			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextend">
					select * from tclassextend where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
			<cfelse>
				<cfif listFindNoCase(typeList,"Site")>
					<cfset rssite=arguments.bundle.getValue("rssite")>
					<cfif isDefined("rssite.baseID")>
						<cfquery datasource="#arguments.toDSN#">
							update tsettings set
								baseID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rssite.baseID)#">
							where
								siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
						</cfquery>
					</cfif>
				</cfif>

				<cfset rstclassextend = arguments.Bundle.getValue("rstclassextend")>
			</cfif>

				<cfquery name="rstclassextend" dbtype="query">
				select * from rstclassextend where
				type in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#typeList#" list="true">)
				</cfquery>

				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextend
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and type in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#typeList#" list="true">)
					<cfif keys.getMode() eq "publish">
						and subtypeID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextend.subTypeID)#" list="true">)
					</cfif>
				</cfquery>

				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextendsets
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and subTypeID not in (
								select subTypeID
								from tclassextend
								where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
								)
				</cfquery>
				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextendattributes
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and extendSetID not in (
							select extendSetID from tclassextendsets
							where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
							)
				</cfquery>

		<cfif rstclassextend.recordcount>
				<cfloop query="rstclassextend">
					<cfquery name="rsCheck" datasource="#arguments.toDSN#">
						select * from tclassextend
						where subTypeID = <cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextend.subTypeID)#">
					</cfquery>
					<cfif rsCheck.recordcount>
						<cfquery datasource="#arguments.toDSN#">
							update tclassextend set
							siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
							baseTable=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.baseTable neq '',de('no'),de('yes'))#" value="#rstclassextend.baseTable#">,
							baseKeyField=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.baseKeyField neq '',de('no'),de('yes'))#" value="#rstclassextend.baseKeyField#">,
							dataTable=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.dataTable neq '',de('no'),de('yes'))#" value="#rstclassextend.dataTable#">,
							type=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.type neq '',de('no'),de('yes'))#" value="#rstclassextend.type#">,
							subtype=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.subType neq '',de('no'),de('yes'))#" value="#rstclassextend.subType#">,
							isActive=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.isActive neq '',de('no'),de('yes'))#" value="#rstclassextend.isActive#">,
							notes=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.notes neq '',de('no'),de('yes'))#" value="#rstclassextend.notes#">,
							lastUpdate=#createODBCDateTime(now())#,
							<cfif isDefined("rstclassextend.hasSummary")>
							hasSummary=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.hasSummary neq '',de('no'),de('yes'))#" value="#rstclassextend.hasSummary#">,
							hasBody=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.hasBody neq '',de('no'),de('yes'))#" value="#rstclassextend.hasBody#">,
							</cfif>
							<cfif isDefined("rstclassextend.hasAssocFile")>
							hasAssocFile=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.hasAssocFile neq '',de('no'),de('yes'))#" value="#rstclassextend.hasAssocFile#">,
							</cfif>
							<cfif isDefined("rstclassextend.description")>
							description=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.description neq '',de('no'),de('yes'))#" value="#rstclassextend.description#">,
							</cfif>
							<cfif isDefined("rstclassextend.availableSubTypes")>
							availableSubTypes=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.availableSubTypes neq '',de('no'),de('yes'))#" value="#rstclassextend.availableSubTypes#">,
							</cfif>
							<cfif isDefined("rstclassextend.iconclass")>
							iconclass=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.iconclass neq '',de('no'),de('yes'))#" value="#rstclassextend.iconclass#">,
							</cfif>
							<cfif isDefined("rstclassextend.hasConfigurator")>
							hasConfigurator=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.hasConfigurator neq '',de('no'),de('yes'))#" value="#rstclassextend.hasConfigurator#">,
							</cfif>
							<cfif isDefined("rstclassextend.adminonly")>
							adminonly=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.hasConfigurator neq '',de('no'),de('yes'))#" value="#rstclassextend.hasConfigurator#">,
							</cfif>
							lastUpdateBy='System'
							where subTypeID = <cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextend.subTypeID)#">
						</cfquery>
					<cfelse>
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextend (subTypeID,siteID, baseTable, baseKeyField, dataTable, type, subType,
							isActive, notes, lastUpdate, dateCreated,
							<cfif isDefined("rstclassextend.hasSummary")>
							hasSummary,hasBody,
							</cfif>
							<cfif isDefined("rstclassextend.hasAssocFile")>
							hasAssocFile,
							</cfif>
							<cfif isDefined("rstclassextend.description")>
							description,
							</cfif>
							<cfif isDefined("rstclassextend.availableSubTypes")>
							availableSubTypes,
							</cfif>
							<cfif isDefined("rstclassextend.iconclass")>
							iconclass,
							</cfif>
							<cfif isDefined("rstclassextend.adminonly")>
							adminonly,
							</cfif>
							lastUpdateBy)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextend.subTypeID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.baseTable neq '',de('no'),de('yes'))#" value="#rstclassextend.baseTable#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.baseKeyField neq '',de('no'),de('yes'))#" value="#rstclassextend.baseKeyField#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.dataTable neq '',de('no'),de('yes'))#" value="#rstclassextend.dataTable#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.type neq '',de('no'),de('yes'))#" value="#rstclassextend.type#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.subType neq '',de('no'),de('yes'))#" value="#rstclassextend.subType#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.isActive neq '',de('no'),de('yes'))#" value="#rstclassextend.isActive#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.notes neq '',de('no'),de('yes'))#" value="#rstclassextend.notes#">,
							#createODBCDateTime(now())#,
							#createODBCDateTime(now())#,
							<cfif isDefined("rstclassextend.hasSummary")>
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.hasSummary neq '',de('no'),de('yes'))#" value="#rstclassextend.hasSummary#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.hasBody neq '',de('no'),de('yes'))#" value="#rstclassextend.hasBody#">,
							</cfif>
							<cfif isDefined("rstclassextend.hasAssocFile")>
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.hasAssocFile neq '',de('no'),de('yes'))#" value="#rstclassextend.hasAssocFile#">,
							</cfif>
							<cfif isDefined("rstclassextend.description")>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.description neq '',de('no'),de('yes'))#" value="#rstclassextend.description#">,
							</cfif>
							<cfif isDefined("rstclassextend.availableSubTypes")>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.availableSubTypes neq '',de('no'),de('yes'))#" value="#rstclassextend.availableSubTypes#">,
							</cfif>
							<cfif isDefined("rstclassextend.iconclass")>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextend.iconclass neq '',de('no'),de('yes'))#" value="#rstclassextend.iconclass#">,
							</cfif>
							<cfif isDefined("rstclassextend.adminonly")>
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextend.adminonly neq '',de('no'),de('yes'))#" value="#rstclassextend.adminonly#">,
							</cfif>
							'System'
							)
						</cfquery>
					</cfif>
				</cfloop>

			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextendsets">
					select * from tclassextendsets
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and subTypeID in (
								select subTypeID
								from tclassextend
								where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
								and type in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#typeList#" list="true">)
								)
				</cfquery>
			<cfelse>
				<cfset rstclassextendsets = arguments.Bundle.getValue("rstclassextendsets")>
			</cfif>

				<cfquery name="rstclassextendsets" dbtype="query">
				select * from rstclassextendsets where
				<cfif rstclassextend.recordcount>
					subtypeID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextend.subtypeID)#" list="true">)
				<cfelse>
					0=1
				</cfif>
				</cfquery>

				<cfloop query="rstclassextendsets">
					<cfquery name="rsCheck" datasource="#arguments.toDSN#">
					select * from tclassextendsets
					where extendsetID = <cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextendsets.extendSetID)#">
					</cfquery>

					<cfif not rsCheck.recordcount>
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextendsets (extendsetID, subTypeID, categoryID, siteID, name, orderno, isActive, container)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextendsets.extendSetID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextendsets.subTypeID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendsets.categoryID neq '',de('no'),de('yes'))#" value="#translateKeyList(rstclassextendsets.categoryID,keys)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendsets.name neq '',de('no'),de('yes'))#" value="#rstclassextendsets.name#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(rstclassextendsets.orderno neq '',de('no'),de('yes'))#" value="#rstclassextendsets.orderno#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(rstclassextendsets.isActive neq '',de('no'),de('yes'))#" value="#rstclassextendsets.isActive#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendsets.container neq '',de('no'),de('yes'))#" value="#rstclassextendsets.container#">
							)
						</cfquery>
					<cfelse>
						<cfquery datasource="#arguments.toDSN#">
							update tclassextendsets set
							subtypeID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextendsets.subTypeID)#">,
							categoryID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendsets.categoryID neq '',de('no'),de('yes'))#" value="#translateKeyList(rstclassextendsets.categoryID,keys)#">,
							siteiD=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
							name=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendsets.name neq '',de('no'),de('yes'))#" value="#rstclassextendsets.name#">,
							orderno=<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(rstclassextendsets.orderno neq '',de('no'),de('yes'))#" value="#rstclassextendsets.orderno#">,
							isactive=<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(rstclassextendsets.isActive neq '',de('no'),de('yes'))#" value="#rstclassextendsets.isActive#">,
							container=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendsets.container neq '',de('no'),de('yes'))#" value="#rstclassextendsets.container#">
							where extendsetID = <cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextendsets.extendSetID)#">
						</cfquery>
					</cfif>

				</cfloop>

			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="tclassextendrcsets">
					select * from tclassextendrcsets
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and subTypeID in (
								select subTypeID
								from tclassextend
								where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
								and type in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#typeList#" list="true">)
								)
				</cfquery>
			<cfelse>
				<cfset tclassextendrcsets = arguments.Bundle.getValue("tclassextendrcsets")>
			</cfif>

			<cfif tclassextendrcsets.recordcount>
				<cfquery name="tclassextendrcsets" dbtype="query">
				select * from tclassextendrcsets where
				<cfif rstclassextend.recordcount>
					subtypeID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextend.subtypeID)#" list="true">)
				<cfelse>
					0=1
				</cfif>
				</cfquery>

				<cfset local.it=getBean('relatedContentSet').getIterator()>
				<cfset local.it.setQuery(tclassextendrcsets)>
				<cfloop condition="local.it.hasNext()">
					<cfset local.item=local.it.next()>
					<cfset local.item.setSiteID(arguments.toSiteID)>
					<cfset local.item.setRelatedContentSetID(keys.get(local.item.getRelatedContentSetID()))>
					<cfset local.item.setSubTypeID(keys.get(local.item.getSubTypeID()))>
					<cfset local.item.save()>
				</cfloop>
			</cfif>

			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextendattributes">
					select * from tclassextendattributes where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif rstclassextendsets.recordcount>
						and extendsetID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextendsets.extendsetID)#" list="true">)
					<cfelse>
						and 0=1
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstclassextendattributes = arguments.Bundle.getValue("rstclassextendattributes")>

				<cfquery name="rstclassextendattributes" dbtype="query">
					select * from rstclassextendattributes where
					<cfif rstclassextendsets.recordcount>
						extendsetID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextendsets.extendsetID)#" list="true">)
					<cfelse>
						0=1
					</cfif>
				</cfquery>
			</cfif>

				<cfloop query="rstclassextendattributes">

					<cfquery name="getAttributeID" datasource="#arguments.toDSN#">
						select attributeID from tclassextendattributes
						where
						siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
						and extendsetID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextendattributes.extendSetID)#">
						and name=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#rstclassextendattributes.name#">
					</cfquery>

					<cfif getAttributeID.recordcount>
						<cfset keys.get(rstclassextendattributes.attributeID, getAttributeID.attributeID)>
						<cfset existingAttributeList=listAppend(existingAttributeList,keys.get(attributeID))>
						<cfquery datasource="#arguments.toDSN#">
							update tclassextendattributes set
							extendSetID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextendattributes.extendSetID)#">,
							siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
							name=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.name neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.name#">,
							label=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.label neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.label#">,
							hint=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.hint neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.hint#">,
							type=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.type neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.type#">,
							orderno=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextendattributes.orderno neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.orderno#">,
							isActive=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextendattributes.isActive neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.isActive#">,
							required=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.required neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.required#">,
							validation=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.validation neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.validation#">,
							regex=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.regex neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.regex#">,
							message=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.message neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.message#">,
							defaultValue=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.defaultValue neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.defaultValue#">,
							optionlist=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.optionList neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.optionList#">,
							optionlabellist=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.optionLabelList neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.optionLabelList#">

							<cfif isDefined("rstclassextendattributes.adminonly")>
							,adminonly=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextendattributes.adminonly neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.adminonly#">
							</cfif>

							where attributeID=<cfqueryparam cfsqltype="cf_sql_INTEGER" value="#keys.get(rstclassextendattributes.attributeID)#">
						</cfquery>

					<cfelse>

						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextendattributes (extendSetID, siteID, name, label, hint,
								type, orderno, isActive, required, validation, regex, message, defaultValue, optionList, optionLabelList
								<cfif isDefined('rstclassextendattributes.adminonly')>
								,adminonly
								</cfif>
								)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextendattributes.extendSetID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.name neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.name#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.label neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.label#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.hint neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.hint#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.type neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.type#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextendattributes.orderno neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.orderno#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextendattributes.isActive neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.isActive#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.required neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.required#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.validation neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.validation#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.regex neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.regex#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.message neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.message#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.defaultValue neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.defaultValue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.optionList neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.optionList#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextendattributes.optionLabelList neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.optionLabelList#">
							<cfif isDefined('rstclassextendattributes.adminonly')>
								,<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(rstclassextendattributes.adminonly neq '',de('no'),de('yes'))#" value="#rstclassextendattributes.adminonly#">
							</cfif>
							)
						</cfquery>

						<cfquery name="getAttributeID" datasource="#arguments.toDSN#">
						select max(attributeID) as newID from tclassextendattributes
						</cfquery>

						<cfset keys.get(rstclassextendattributes.attributeID, getAttributeID.newID)>

					</cfif>

					<!--- Extended attribute values of type file need to go through the key factory--->
					<cfif rstclassextendattributes.type eq "File">
						<cfset arguments.fileattributelist=listAppend(arguments.fileattributelist,rstclassextendattributes.attributeID)>
					</cfif>

					<cfset incomingAttributeList=listAppend(incomingAttributeList,rstclassextendattributes.attributeID)>

				</cfloop>

			<cfif arguments.contentMode neq "none">
				<cfif not StructKeyExists(arguments,"Bundle")>
					<cfquery datasource="#arguments.fromDSN#" name="rstclassextenddata">
						select tclassextenddata.baseID, tclassextenddata.attributeID, tclassextenddata.attributeValue,
						tclassextenddata.siteID, tclassextenddata.stringvalue, tclassextenddata.numericvalue, tclassextenddata.datetimevalue, tclassextenddata.remoteID from tclassextenddata
						inner join tcontent on (tclassextenddata.baseid=tcontent.contenthistid)
						where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
						and (tcontent.active = 1 or (tcontent.changesetID is not null and tcontent.approved=0))
					</cfquery>
				<cfelse>
					<cfset rstclassextenddata = arguments.Bundle.getValue("rstclassextenddata")>
				</cfif>

				<cfif len(incomingAttributeList)>
					<cfquery name="rstclassextenddata" dbtype="query">
						select * from rstclassextenddata
						where attributeID in (<cfqueryparam cfsqltype="cf_sql_integer" value="#incomingAttributeList#" list="true">)
					</cfquery>
				</cfif>

				<cfif isDate(arguments.lastDeployment)>
					<cfquery name="rsbaseids" dbtype="query">
						select distinct baseID from rstclassextenddata
					</cfquery>

					<cfif arguments.rstcontent.recordcount or rsbaseids.recordcount or rsDeleted.recordcount>
						<cfquery datasource="#arguments.toDSN#">
							delete from tclassextenddata where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>

								and
								(
									<cfif arguments.rstcontent.recordcount>
									baseID in (
										select contentHistID from tcontent where contentHistID in
										(<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(arguments.rstcontent.contentID)#">)
									)
									</cfif>

									<cfif rsbaseids.recordcount>
									<cfif arguments.rstcontent.recordcount>or</cfif>
									or baseID in (
									select contentHistID from tcontent where contentHistID in
										(<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsbaseids.baseID)#">)
									)
									</cfif>

									<cfif rsDeleted.recordcount>
									<cfif arguments.rstcontent.recordcount or rsbaseids.recordcount>or</cfif>
										baseID in (
										select contentHistID from tcontent where contentHistID in
										(<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
									)
									</cfif>
									)
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery datasource="#arguments.toDSN#">
						delete from tclassextenddata where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					</cfquery>
				</cfif>

				<cfloop query="rstclassextenddata">
					<cftry>
						<!--- Attributes that have not been imported will return as a uuid.
						This most likely is the result of orphaned data.
						--->
						<cfif isNumeric(keys.get(rstclassextenddata.attributeID))>
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextenddata (baseID,attributeID,attributeValue,stringvalue,siteID,numericvalue,datetimevalue,remoteID
							)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextenddata.baseID)#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" value="#keys.get(rstclassextenddata.attributeID)#">,

							<!--- Extended attribute values of type file need to go through the key factory--->
							<cfif listFind(arguments.fileattributelist,rstclassextenddata.attributeID)>
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstclassextenddata.attributeValue neq '',de('no'),de('yes'))#" value="#keys.get(rstclassextenddata.attributeValue)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextenddata.stringvalue neq '',de('no'),de('yes'))#" value="#keys.get(rstclassextenddata.stringValue)#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstclassextenddata.attributeValue neq '',de('no'),de('yes'))#" value="#rstclassextenddata.attributeValue#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextenddata.stringvalue neq '',de('no'),de('yes'))#" value="#rstclassextenddata.stringvalue#">,
							</cfif>

							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(rstclassextenddata.numericvalue),de('no'),de('yes'))#" value="#rstclassextenddata.numericvalue#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstclassextenddata.datetimevalue),de('no'),de('yes'))#" value="#rstclassextenddata.datetimevalue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextenddata.remoteID neq '',de('no'),de('yes'))#" value="#rstclassextenddata.remoteID#">

							)
						</cfquery>
						</cfif>
						<cfcatch>
							<cfdump var="#rstclassextenddata.baseID#">
							<cfdump var="#rstclassextenddata.attributeID#">
							<cfdump var="#cfcatch#">
							<cfabort>
						</cfcatch>
					</cftry>
				</cfloop>

				<cfif keys.getMode() eq "Copy">
					<cfquery name="rsFeedParams" datasource="#arguments.toDSN#">
						select field
						from tcontentfeedadvancedparams
						where feedID in (select feedID
										 from tcontentfeeds
										 where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeID#">
										 )
						group by field
					</cfquery>
					<cfloop query="rsFeedParams">
						<cfif isNumeric(rsFeedParams.field)>
							<cfquery datasource="#arguments.toDSN#">
								update tcontentfeedadvancedparams
								set field=<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rsFeedParams.field)#">
								where field=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFeedParams.field#">
								and feedID in (select feedID
										 from tcontentfeeds
										 where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeID#">
										 )
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>

			<cfif arguments.usersMode neq "none" and structKeyExists(arguments,"Bundle")>
				<cfset getToWorkClassExtensionsUsers(argumentCollection=arguments)>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="getToWorkClassExtensionsUsers">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="lastDeployment" type="string" default="" required="true">
		<cfargument name="rsDeleted" required="true" default="#queryNew('objectID')#">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">
		<cfargument name="usersMode" type="string" default="all" required="true">
		<cfargument name="keyMode" type="string" default="copy" required="true">
		<cfargument name="fileattributelist" type="string" default="" required="true">

		<cfset var keys=arguments.keyFactory/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendrcsets="">
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getAttributeID=""/>
		<cfset var existingAttributeList=""/>
		<cfset var rsbaseids=""/>
		<cfset var typeList="">
		<cfset var incomingAttributeList="">
		<cfset var rsCheck="">
		<cfset var rstclassextenddatauseractivity="">
		<cfset var rsFeedParams="">
		<cfset var rssite="">
		<cfset var tclassextendrcsets="">


				<cfset rstclassextenddatauseractivity = arguments.Bundle.getValue("rstclassextenddatauseractivity")>

				<cfif arguments.rsUserConflicts.recordcount>
					<cfquery dbtype="query">
					select * from rstclassextenddatauseractivity
					where baseID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(arguments.rsUserConfilicts.userID)#">)
					</cfquery>
				</cfif>

				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextenddatauseractivity where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				</cfquery>

					<cfloop query="rstclassextenddatauseractivity">
					<!--- Attributes that have not been imported will return as a uuid.
					This most likely is the result of orphaned data.
					--->
					<cfif isNumeric(keys.get(rstclassextenddatauseractivity.attributeID))>
					<cftry>
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextenddatauseractivity (baseID,attributeID,attributeValue,stringvalue,siteID,numericvalue,datetimevalue,remoteID)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstclassextenddatauseractivity.baseID)#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" value="#keys.get(rstclassextenddatauseractivity.attributeID)#">,

							<!--- Extended attribute values of type file need to go through the key factory--->
							<cfif listFind(arguments.fileattributelist,rstclassextenddatauseractivity.attributeID)>
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstclassextenddatauseractivity.attributeValue neq '',de('no'),de('yes'))#" value="#keys.get(rstclassextenddatauseractivity.attributeValue)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextenddatauseractivity.stringvalue neq '',de('no'),de('yes'))#" value="#keys.get(rstclassextenddatauseractivity.stringValue)#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(rstclassextenddatauseractivity.attributeValue neq '',de('no'),de('yes'))#" value="#rstclassextenddatauseractivity.attributeValue#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextenddatauseractivity.stringvalue neq '',de('no'),de('yes'))#" value="#rstclassextenddatauseractivity.stringvalue#">,
							</cfif>

							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(rstclassextenddatauseractivity.numericvalue),de('no'),de('yes'))#" value="#rstclassextenddatauseractivity.numericvalue#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(rstclassextenddatauseractivity.datetimevalue),de('no'),de('yes'))#" value="#rstclassextenddatauseractivity.datetimevalue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstclassextenddatauseractivity.remoteID neq '',de('no'),de('yes'))#" value="#rstclassextenddatauseractivity.remoteID#">
							)
						</cfquery>
						<cfcatch>
							<cfdump var="#rstclassextenddatauseractivity.baseID#">
							<cfdump var="#rstclassextenddatauseractivity.attributeID#">
							<cfdump var="#keys.get(rstclassextenddatauseractivity.attributeID)#">
							<cfdump var="#rstclassextenddatauseractivity.attributeValue#">
							<cfdump var="#cfcatch#">
							<cfabort>
						</cfcatch>
					</cftry>
					</cfif>
				</cfloop>

	</cffunction>

	<cffunction name="getToWorkPlugins">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="contentMode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="moduleID" type="any" required="false">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">

		<cfset var keys=arguments.keyFactory/>
		<cfset var getNewID=""/>
		<cfset var rsCheck=""/>
		<cfset var proceed=false/>
		<cfset var rstplugins=""/>
		<cfset var rstpluginsto=""/>
		<cfset var rstpluginscripts=""/>
		<cfset var rstplugindisplayobjects=""/>
		<cfset var rstpluginsettings=""/>
		<cfset var newdirectory="">
		<cfset var rsTemp="">
		<cfset var s="">
		<cfset var pluginDir="">
		<cfset var pluginCFC="">
		<cfset var pluginConfig="">

			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstplugins">
					select * from tplugins
					where moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and type='Plugin')
				</cfquery>
			<cfelse>
				<cfset rstplugins = arguments.Bundle.getValue("rstplugins")>
				<cfif len(arguments.moduleID)>
				<cfquery name="rstplugins" dbtype="query">
					select * from rstplugins
					where moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true">)
				</cfquery>
				</cfif>
			</cfif>

				<cfloop query="rstplugins">
						<cfset proceed=false>

						<cfquery datasource="#arguments.toDSN#" name="rsCheck">
							select * from tplugins
							where moduleID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>

						<cfif rscheck.recordcount>
							<cfset proceed=true/>
							<cfquery datasource="#arguments.todsn#">
								update tplugins set
								name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.name#">,
								provider=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.provider#">,
								providerURL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.providerURL#">,
								version=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.version#">,
								deployed=1,
								category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.category#">,
								created=#createODBCDateTime(rstplugins.created)#,
								loadPriority=<cfqueryparam cfsqltype="cf_sql_integer" value="#rstplugins.loadPriority#">,
								package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.package#">

								where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">
							</cfquery>
						<cfelse>

							<cfquery datasource="#arguments.toDSN#" name="rsCheck">
								select moduleID from tplugins
								where package=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.package#"/>
								and moduleID<><cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
							</cfquery>

							<cfif rsCheck.recordcount>
								<cfset proceed=false/>
								<cfset arguments.errors["#rstplugins.moduleID#"]="The plugin named '#rstplugins.package#' has a package value of '#rstplugins.package#' which is already taken.">
							<cfelse>
								<cfset proceed=true/>
								<cfquery datasource="#arguments.todsn#">
									insert into tplugins (moduleID,name,provider,providerURL,version,deployed,
									category,created,loadPriority,package) values (
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.name#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.provider#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.providerURL#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.version#">,
									1,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.category#">,
									#createODBCDateTime(rstplugins.created)#,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rstplugins.loadPriority#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.package#">
									)
								</cfquery>
								</cfif>
						</cfif>

						<cfif proceed>
						<cfquery datasource="#arguments.toDSN#" name="rsCheck">
							select * from tplugins
							where moduleID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>

						<cfif isNumeric(rstplugins.directory)>
							<cfset newdirectory=rsCheck.pluginID>
						<cfelseif isNumeric(listLast(rstplugins.directory,"_"))>
							<cfset newdirectory=rsCheck.package & "_" & rsCheck.pluginID>
						<cfelse>
							<cfset newdirectory=rsCheck.package>
						</cfif>

						<cfquery datasource="#arguments.toDSN#">
							update tplugins set
							directory=<cfqueryparam cfsqltype="cf_sql_varchar" value="#newdirectory#">
							where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">
						</cfquery>

						<cfif len(arguments.toSiteID)>
							<cfloop list="#arguments.toSiteID#" index="s">
								<cfquery datasource="#arguments.toDSN#" name="rsCheck">
									select * from tcontent
									where moduleID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/> and type='Plugin'
									and siteID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#s#"/>
								</cfquery>

								<cfif rscheck.recordcount>
									<cfquery datasource="#arguments.todsn#">
									update tcontent set
									title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.name#">
									where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">
									and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#s#">
									</cfquery>
								<cfelse>

									<cfquery datasource="#arguments.todsn#">
									insert into tcontent (siteID,moduleID,contentID,contentHistID,parentID,type,subType,title,
									display,approved,isNav,active,forceSSL,searchExclude) values (
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#s#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">,
									'Plugin',
									'Default',
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.name#">,
									1,
									1,
									1,
									1,
									1,
									1
									)
									</cfquery>
								</cfif>
							</cfloop>
						</cfif>

						<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstpluginscripts">
							select * from tpluginscripts
							where moduleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.moduleID#"/>
						</cfquery>
						<cfelse>
							<cfset rstpluginscripts = arguments.Bundle.getValue("rstpluginscripts")>
							<cfquery name="rsTemp" dbtype="query">
								select * from rstpluginscripts
								where moduleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.moduleID#"/>
							</cfquery>
							<cfset rstpluginscripts = rsTemp>
						</cfif>
						<cfquery datasource="#arguments.toDSN#">
							delete from tpluginscripts
							where moduleID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>


						<cfloop query="rstpluginscripts">
							<cfquery datasource="#arguments.toDSN#">
								insert into tpluginscripts (scriptID,moduleID,scriptfile,runat,docache)
								values
								(
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstpluginscripts.scriptID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstplugins.moduleID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstpluginscripts.scriptfile neq '',de('no'),de('yes'))#" value="#rstpluginscripts.scriptfile#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstpluginscripts.runat neq '',de('no'),de('yes'))#" value="#rstpluginscripts.runat#">,
								<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstpluginscripts.docache),de(rstpluginscripts.docache),de(0))#">

								)
							</cfquery>
						</cfloop>

						<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstplugindisplayobjects">
							select * from tplugindisplayobjects
							where moduleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.moduleID#"/>
						</cfquery>
						<cfelse>
							<cfset rstplugindisplayobjects = arguments.Bundle.getValue("rstplugindisplayobjects")>
							<cfquery name="rsTemp" dbtype="query">
								select * from rstplugindisplayobjects
								where moduleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.moduleID#"/>
							</cfquery>
							<cfset rstplugindisplayobjects = rsTemp>
						</cfif>
						<cfquery datasource="#arguments.toDSN#">
							delete from tplugindisplayobjects
							where moduleID  =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>
						<cfloop query="rstplugindisplayobjects">
							<cfquery datasource="#arguments.toDSN#">
								insert into tplugindisplayobjects (objectID,moduleID,name,location,displayObjectFile,displayMethod,docache,configuratorInit,configuratorJS)
								values
								(
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstplugindisplayobjects.objectID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstplugins.moduleID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstplugindisplayobjects.name neq '',de('no'),de('yes'))#" value="#rstplugindisplayobjects.name#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstplugindisplayobjects.location neq '',de('no'),de('yes'))#" value="#rstplugindisplayobjects.location#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstplugindisplayobjects.displayObjectFile neq '',de('no'),de('yes'))#" value="#rstplugindisplayobjects.displayObjectFile#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstplugindisplayobjects.displayMethod neq '',de('no'),de('yes'))#" value="#rstplugindisplayobjects.displayMethod#">,
								<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rstplugindisplayobjects.docache),de(rstplugindisplayobjects.docache),de(0))#">
								<cfif isdefined("rstplugindisplayobjects.configuratorInit") and len(rstplugindisplayobjects.configuratorInit)>
									,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="no" value="#rstplugindisplayobjects.configuratorInit#">
								<cfelse>
									,null
								</cfif>
								<cfif isdefined("rstplugindisplayobjects.configuratorJS") and len(rstplugindisplayobjects.configuratorJS)>
									,<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="no" value="#rstplugindisplayobjects.configuratorJS#">
								<cfelse>
									,null
								</cfif>
								)
							</cfquery>
						</cfloop>

						<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstpluginsettings">
							select * from tpluginsettings
							where moduleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.moduleID#"/>
						</cfquery>
						<cfelse>
							<cfset rstpluginsettings = arguments.Bundle.getValue("rstpluginsettings")>
							<cfquery name="rsTemp" dbtype="query">
								select * from rstpluginsettings
								where moduleID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.moduleID#"/>
							</cfquery>
							<cfset rstpluginsettings = rsTemp>
						</cfif>
						<cfquery datasource="#arguments.toDSN#">
							delete from tpluginsettings
							where moduleID  =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>
						<cfloop query="rstpluginsettings">
							<cfquery datasource="#arguments.toDSN#">
								insert into tpluginsettings (moduleID,name,settingValue)
								values
								(
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstplugins.moduleID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstpluginsettings.name neq '',de('no'),de('yes'))#" value="#rstpluginsettings.name#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstpluginsettings.settingValue neq '',de('no'),de('yes'))#" value="#rstpluginsettings.settingValue#">

								)
							</cfquery>
						</cfloop>


						<cfif StructKeyExists(arguments,"Bundle")>
							<cfset pluginDir=application.configBean.getPluginDir() & application.configBean.getFileDelim() & rstplugins.directory>

							<cfif fileExists("#pluginDir#/plugin/plugin.cfc")>
								<cfset pluginConfig=getPlugin(ID=keyFactory.get(rstplugins.moduleID), siteID="", cache=false)>
								<cfset pluginCFC= createObject("component","plugins.#rstplugins.directory#.plugin.plugin") />

								<!--- only call the methods if they have been defined --->

								<cfif structKeyExists(pluginCFC,"init")>
									<cfset pluginCFC.init(pluginConfig)>
									<cfif structKeyExists(pluginCFC,"fromBundle")>
										<cfset pluginCFC.fromBundle(pluginConfig=pluginConfig,Bundle=arguments.bundle,keyFactory=arguments.keyFactory, siteID=arguments.toSiteID, errors=arguments.errors)>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
					</cfif>

				</cfloop>

	</cffunction>

	<cffunction name="publish">
		<cfargument name="siteid" required="yes" default="">
		<cfargument name="pushMode" required="yes" default="">

		<cfset var i=""/>
		<cfset var j=""/>
		<cfset var k=""/>
		<cfset var p=""/>
		<cfset var fileDelim=application.configBean.getFileDelim() />
		<cfset var rsPlugins=application.pluginManager.getSitePlugins(arguments.siteid)>
		<cfset var pluginEvent = createObject("component","mura.event").init(arguments) />
		<cfset var keys=createObject("component","mura.publisherKeys").init('publish',application.utility)>
		<cfset var fileWriter=getBean("fileWriter")>
		<cfset var errors=arrayNew(1)>
		<cfset var itemErrors=arrayNew(1)>
		<cfset var publishercontentPushMode="Full">
		<cfset var lastDeployment=application.settingsManager.getSite(arguments.siteID).getLastDeployment()>
		<cfset var rsDeleted=queryNew("objectID")>

		<cfif arguments.pushMode neq "changesOnly">
			<cfset lastDeployment="">
		</cfif>

		<cfif isDate(lastDeployment)>
			<cfset rsDeleted=getBean("trashManager").getQuery(siteID=arguments.fromSiteID,sinceDate=lastDeployment)>
		<cfelse>
			<cfset rsDeleted=queryNew("objectID")>
		</cfif>

		<cfset application.pluginManager.announceEvent("onSiteDeploy",pluginEvent)>
		<cfset application.pluginManager.announceEvent("onBeforeSiteDeploy",pluginEvent)>

		<cfloop list="#application.configBean.getProductionDatasource()#" index="i">
			<cfset getToWork(arguments.siteid, arguments.siteid, '#application.configBean.getDatasource()#', '#i#','publish',keys,lastDeployment,rsDeleted)>
			<cfif len(application.configBean.getAssetPath())>
				<cfset update("#application.configBean.getAssetPath()#","#application.configBean.getProductionAssetPath()#",i)>
			</cfif>
		</cfloop>

		<cfif not isDate(lastDeployment)>
			<cfloop list="#application.configBean.getProductionWebroot()#" index="j">
				<cfset itemErrors=application.utility.copyDir("#application.configBean.getWebRoot()##fileDelim##arguments.siteid##fileDelim#", "#j##fileDelim##arguments.siteid##fileDelim#") />
				<cfset errors=application.utility.joinArrays(errors,itemErrors)>
			</cfloop>
		</cfif>

		<cfloop list="#application.configBean.getProductionWebroot()#" index="p">
			<cfloop query="rsPlugins">
				<cfset itemErrors=application.utility.copyDir("#application.configBean.getWebRoot()##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#", "#p##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#","",lastDeployment) />
				<cfset errors=application.utility.joinArrays(errors,itemErrors)>
			</cfloop>
			<!--- delete mappings file so that it will be recreated but prod instance --->
			<cfif fileExists("#p##fileDelim#plugins#fileDelim#mappings.cfm")>
				<cffile action="delete" file="#p##fileDelim#plugins#fileDelim#mappings.cfm">
			</cfif>
		</cfloop>

		<cfloop list="#application.configBean.getProductionFiledir()#" index="k">
				<cfset itemErrors=application.utility.copyDir("#application.configBean.getFiledir()##fileDelim##arguments.siteid##fileDelim#", "#k##fileDelim##arguments.siteid##fileDelim#","",lastDeployment) />
				<cfset errors=application.utility.joinArrays(errors,itemErrors)>
		</cfloop>

		<cfloop list="#application.configBean.getProductionAssetdir()#" index="k">
			<cfif not listFindNoCase(application.configBean.getProductionFiledir(),k)>
				<cfset itemErrors=application.utility.copyDir("#application.configBean.getAssetdir()##fileDelim##arguments.siteid##fileDelim#", "#k##fileDelim##arguments.siteid##fileDelim#","",lastDeployment) />
				<cfset errors=application.utility.joinArrays(errors,itemErrors)>
			</cfif>
		</cfloop>

		<!---
		<cfif len(application.configBean.getAssetPath())>
			<cfset update("#application.configBean.getAssetPath()#","#application.configBean.getProductionAssetPath()#")>
		</cfif>
		--->

		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			update tsettings set lastDeployment = #createODBCDateTime(now())#
			where siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.siteID#">
		</cfquery>

		<cfloop list="#application.configBean.getProductionDatasource()#" index="i">
			<cfquery datasource="#i#">
				update tsettings set lastDeployment = #createODBCDateTime(now())#
				where siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.siteID#">
			</cfquery>
			<cfquery datasource="#i#">
				update tglobals set appreload = #createODBCDateTime(now())#
			</cfquery>
		</cfloop>

		<cfset pluginEvent.setValue("errors",errors)>
		<cfset application.pluginManager.announceEvent("onAfterSiteDeploy",pluginEvent)>
	</cffunction>

	<cffunction name="copy" output="no">
		<cfargument name="fromsiteid" required="yes" default="">
		<cfargument name="tositeid" required="yes" default="">
		<cfargument name="fromDSN" required="yes" default="#application.configBean.getDatasource()#">
		<cfargument name="toDSN" required="yes" default="#application.configBean.getDatasource()#">
		<cfargument name="fromWebRoot" required="yes" default="#application.configBean.getWebRoot()#">
		<cfargument name="toWebRoot" required="yes" default="#application.configBean.getWebRoot()#">
		<cfargument name="fromFileDir" required="yes" default="#application.configBean.getFileDir()#">
		<cfargument name="toFileDir" required="yes" default="#application.configBean.getFileDir()#">
		<cfargument name="fromAssetDir" required="yes" default="#application.configBean.getAssetDir()#">
		<cfargument name="toAssetDir" required="yes" default="#application.configBean.getAssetDir()#">
		<cfargument name="fromAssetPath" required="yes" default="#application.configBean.getAssetPath()#">
		<cfargument name="toAssetPath" required="yes" default="#application.configBean.getAssetPath()#">
		<cfargument name="fromSiteDir" required="yes" default="#application.configBean.getSiteDir()#">
		<cfargument name="toSiteDir" required="yes" default="#application.configBean.getSiteDir()#">

		<cfset var i=""/>
		<cfset var j=""/>
		<cfset var k=""/>
		<cfset var p=""/>
		<cfset var pluginEvent = createObject("component","mura.event") />
		<cfset var fileDelim="/"/>
		<cfset var rsplugins=""/>
		<cfset var keys=""/>

		<cfloop collection="#arguments#" item="i">
			<cfset variables[i] = arguments[i]>
		</cfloop>

		<cfif arguments.fromSiteID eq arguments.toSiteID>
			<cfreturn >
		</cfif>

		<cfset variables.siteID=arguments.fromSiteID>
		<cfset pluginEvent.init(variables)>
		<cfset application.pluginManager.announceEvent("onSiteCopy",pluginEvent)>

		<cfset fileDelim=application.configBean.getFileDelim() />
		<cfset rsPlugins=application.pluginManager.getSitePlugins(arguments.fromsiteid)>
		<cfset keys=createObject("component","mura.publisherKeys").init('copy',application.utility)>

		<!---<cfthread action="run" name="thread0">--->
			<cfset getToWork(fromSiteID=fromsiteid, toSiteID=tositeid, fromDSN=fromDSN, toDSN=toDSN, contentMode='all', keyFactory=keys, keyMode="copy")>
		<!---</cfthread>--->

		<!---<cfthread action="run" name="thread1">--->
			<cfset application.utility.copyDir("#arguments.fromSiteDir##fileDelim##arguments.fromsiteid##fileDelim#", "#arguments.toSiteDir##fileDelim##arguments.tositeid##fileDelim#","cache#fileDelim#file") />
		<!---</cfthread>--->

		<cfif arguments.fromWebRoot neq arguments.toWebRoot>
			<cfloop query="rsPlugins">
				<!---<cfthread action="run" name="thread2#rsPlugins.currentRow#">--->
					<cfset application.utility.copyDir("#arguments.fromWebRoot##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#", "#arguments.toWebRoot##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#") />
				<!---</cfthread>--->
			</cfloop>
		</cfif>

		<!---<cfif fromWebRoot neq fromFileDir>--->
			<!---<cfthread action="run" name="thread3">--->
				<cfset copySiteFiles("#arguments.fromFileDir##fileDelim##arguments.fromsiteid##fileDelim#cache#fileDelim#file#fileDelim#", "#arguments.toFileDir##fileDelim##arguments.tositeid##fileDelim#cache#fileDelim#file#fileDelim#",keys, "", arguments.fromsiteid, arguments.tositeid) />
			<!---</cfthread>--->
		<!---</cfif>--->

		<!---<cfif arguments.toWebRoot neq arguments.toAssetDir>--->
			<!---<cfthread action="run" name="thread4">--->

			<cfset application.utility.copyDir("#arguments.fromAssetDir##fileDelim##arguments.fromsiteid##fileDelim#assets#fileDelim#", "#arguments.toAssetDir##fileDelim##arguments.tositeid##fileDelim#assets#fileDelim#") />

			<!---</cfthread>--->
		<!---</cfif>--->

		<!---
		<cfthread action="join" name="thread0" />
		--->
		<!---<cfthread action="run" name="thread5">--->
			<cfif fromAssetPath neq toAssetPath>
				<cfset application.contentUtility.findAndReplace("#arguments.fromAssetPath#/", "#arguments.toAssetPath#/", "#arguments.toSiteID#")>
			</cfif>
		<!---</cfthread>--->

		<!---<cfthread action="run" name="thread6">--->
			<!---<cfif fromSiteID neq toSiteID>--->
				<cfset application.contentUtility.findAndReplace("/#arguments.fromsiteID#/", "/#arguments.toSiteID#/", "#arguments.toSiteID#")>
			<!---</cfif>--->
		<!---</cfthread>--->

		<cfset getBean("contentUtility").updateGlobalMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
		<cfset getBean("contentUtility").updateGlobalCommentsMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
		<cfset getBean("categoryUtility").updateGlobalMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />

	</cffunction>

	<cffunction name="start" returntype="boolean">
		<cfargument name="siteid" required="yes" default="">
		<cfset var rsSites=""/>
		<cfif siteid neq "">
			<!--- publish just one --->
			<cfset publish(arguments.siteid)>
		<cfelse>
			<!--- publish all sites --->
			<cfquery name="rsSites"datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				select siteid, deploy from tsettings
			</cfquery>
			<cfloop query="rsSites">
				<cfif deploy>
					<cfset publish(rsSites.siteid)>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn true />
	</cffunction>

	<cffunction name="copySiteFiles">
		<cfargument name="baseDir" default="" required="true" />
		<cfargument name="destDir" default="" required="true" />
		<cfargument name="keyFactory" required="true" />
		<cfargument name="sinceDate" default="" />
		<cfargument name="fromsiteid" default="" />
		<cfargument name="tositeid" default="" />
		<cfset var rs = "" />
		<cfset var keys=arguments.keyFactory>
		<cfset var newFile="">
		<cfset var newDir="">
		<cfset var fileDelim=application.configBean.getFileDelim()>
		<cfset var fileWriter=getBean("fileWriter")>
		<cfdirectory directory="#arguments.baseDir#" name="rs" action="list" recurse="true" />
		<!--- filter out Subversion hidden folders --->
		<cfquery name="rs" dbtype="query">
		SELECT * FROM rs
		WHERE directory NOT LIKE '%#application.configBean.getFileDelim()#.svn%'
		AND name <> '.svn'

		<cfif isDate(arguments.sinceDate)>
		and dateLastModified >= #createODBCDateTime(arguments.sinceDate)#
		</cfif>
		</cfquery>

		<cfif not isDate(arguments.sinceDate) and directoryExists(arguments.destDir)>
			<cfset fileWriter.deleteDir(directory="#arguments.destDir#")>
		</cfif>

		<cfif not directoryExists(arguments.destDir)>
			<cfset fileWriter.createDir(directory="#arguments.destDir#")>
		</cfif>

		<cfloop query="rs">
			<cfif rs.type eq "dir">
				<cftry>
					<cfset newDir="#replaceNoCase('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir)##rs.name##fileDelim#">
					<cfif not directoryExists(newDir)>
						<cfset fileWriter.createDir(directory=newDir)>
					</cfif>
					<cfcatch></cfcatch>
				</cftry>
			<cfelse>
				<!--- <cftry> --->
					<cfset fileWriter.copyFile(source="#rs.directory##fileDelim##rs.name#", destination=replaceNoCase('#rs.directory##fileDelim#',expandPath(arguments.baseDir),expandPath(arguments.destDir)))>

					<cfset newFile=listFirst(rs.name,".")>

					<cfif listLen(newFile,"_") gt 1>
						<cfset newFile=keys.get(listFirst(newFile,"_")) & "_" & listLast(newFile,"_") & "." & listLast(rs.name,".")>
					<cfelse>
						<cfset newFile=keys.get(newFile) & "." & listLast(rs.name,".")>
					</cfif>

					<cfset fileWriter.renameFile(source="#replaceNoCase('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir)##rs.name#", destination="#replaceNoCase('#rs.directory##fileDelim#',expandPath(arguments.baseDir),expandPath(arguments.destDir))##newFile#")>
				<!--- 	<cfcatch></cfcatch>
				</cftry> --->
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="translateKeyList" returntypew="string" output="false">
	<cfargument name="list">
	<cfargument name="keyFactory">
	<cfset var i="">
	<cfset var newList="">

	<cfloop list="#arguments.list#" index="i">
		<cfset newList=listAppend(newList,arguments.keyFactory.get(i))>
	</cfloop>
	</cffunction>

	<cffunction name="translateObjectParams" output="false">
		<cfargument name="params">
		<cfargument name="keyFactory">

		<cfif isJson(arguments.params)>
			<cfset arguments.params=deserializeJSON(arguments.params)>

			<cfloop collection="#arguments.params#" item="local.key">
				<cfif isSimpleValue(arguments.params['#local.key#']) and isValid('uuid',arguments.params['#local.key#'])>
					<cfset arguments.params['#local.key#']=arguments.keyFactory.get(arguments.params['#local.key#'])>
				</cfif>
			</cfloop>

			<cfset arguments.params=serializeJSON(arguments.params)>
		</cfif>

		<cfreturn arguments.params>
	</cffunction>

</cfcomponent>
