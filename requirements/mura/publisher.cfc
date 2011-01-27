<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

	<cffunction name="update" returntype="void" output="false">
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
				<cfset newbody=replace(BODY,"#arguments.find#","#arguments.replace#","ALL")>
				<cfquery datasource="#arguments.datasource#">
					update tcontent set body=<cfqueryparam value="#newBody#" cfsqltype="cf_sql_longvarchar" > where contenthistid='#contenthistid#'
				</cfquery>
			</cfloop>
			
			<cfquery datasource="#arguments.datasource#" name="rs">
				select contenthistid, summary from tcontent where summary like '%#arguments.find#%'
			</cfquery>
			
			<cfloop query="rs">
				<cfset newSummary=replace(summary,"#arguments.find#","#arguments.replace#","ALL")>
				<cfquery datasource="#arguments.datasource#">
					update tcontent set summary=<cfqueryparam value="#newSummary#" cfsqltype="cf_sql_longvarchar" > where contenthistid='#contenthistid#'
				</cfquery>
			</cfloop> 	
		</cfif>
	</cffunction>
	
	<cffunction name="getToWork" returntype="any" output="false">
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
		<cfset var rstplugins="">
		<cfset var bundleAssetPath="">
		<cfset var bundleContext="">
		<cfset var rssite="">
		
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
		
		<cfif len(arguments.toSiteID) and arguments.contentMode neq "none">
			<cfset getToWorkSite(argumentCollection=arguments)>
			
			<cfif arguments.contentMode eq "all" and arguments.keyMode eq "publish" and not StructKeyExists(arguments,"Bundle")>
				<cfif not isDate(arguments.lastDeployment)>
					<cfset getToWorkSyncMetaOLD(argumentCollection=arguments)>
				</cfif>
				<cfset getToWorkClassExtensionsOLD(argumentCollection=arguments)>
			</cfif>
			
			<cfif StructKeyExists(arguments,"Bundle")>
				<cfset getToWorkSyncMeta(argumentCollection=arguments)>
				<cfset getToWorkTrash(argumentCollection=arguments)>
				
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
						<cfset application.contentUtility.findAndReplace(rssite.domain,application.settingsManager.getSite(arguments.toSiteID).getDomain() , arguments.toSiteID)>
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
			
		</cfif>
		
		<cfif len(arguments.toSiteID) and arguments.usersMode neq "none">
			<cfset getToWorkUsers(argumentCollection=arguments)>
		</cfif>
		
		<cfif len(arguments.toSiteID) and (arguments.usersMode neq "none" or arguments.contentMode neq "none")>
			<cfset getToWorkFiles(argumentCollection=arguments)>
		</cfif>
		
		<cfif len(arguments.toSiteID) and (arguments.usersMode neq "none" or arguments.contentMode neq "none")
		and not (arguments.keyMode eq "publish" and not StructKeyExists(arguments,"Bundle"))>
			<cfset getToWorkClassExtensions(argumentCollection=arguments)>
		</cfif>
		
		<cfif arguments.pluginMode neq "none">
			<cfset getToWorkPlugins(argumentCollection=arguments)>
		</cfif>
		
		<cfif StructKeyExists(arguments,"Bundle")>
			<cfset arguments.Bundle.unpackFiles( arguments.toSiteID,arguments.keyFactory,arguments.toDSN, arguments.moduleID, arguments.errors , arguments.renderingMode, arguments.contentMode, arguments.pluginMode, arguments.lastDeployment,arguments.keyMode) />
			<cfif arguments.keyMode eq "copy" and arguments.contentMode eq "all">
				<cfset arguments.Bundle.renameFiles( arguments.toSiteID,arguments.keyFactory,arguments.toDSN ) />
			</cfif>
			<cfif arguments.contentMode neq "none">
				<cfset getBean("fileManager").cleanFileCache(arguments.toSiteID)>
			</cfif>

			<cfif listFindNoCase("All,Theme",arguments.renderingMode)>
				<cfset rssite=Bundle.getValue("rssite")>
						
				<cfif rssite.recordcount and directoryExists(expandPath("/muraWRM/#arguments.toSiteID#/includes/themes/#rssite.theme#"))>
					<cfquery datasource="#arguments.toDSN#">
						update tsettings set 
						
						<cfif isdefined("rssite.columnCount")>
						columnCount=<cfqueryparam cfsqltype="cf_sql_integer" value="#rssite.columnCount#">,
						columnNames=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.columnNames#">,
						primaryColumn=<cfqueryparam cfsqltype="cf_sql_integer" value="#rssite.primaryColumn#">,
						</cfif>
						
						theme=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.theme#">,
						displayPoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,
						galleryMainScaleBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.galleryMainScaleBy#">,
						galleryMediumScaleBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.galleryMediumScaleBy#">,
						gallerySmallScaleBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rssite.gallerySmallScaleBy#">,
						galleryMainScale=<cfqueryparam cfsqltype="cf_sql_integer" value="#rssite.galleryMainScale#">,
						galleryMediumScale=<cfqueryparam cfsqltype="cf_sql_integer" value="#rssite.galleryMediumScale#">,
						gallerySmallScale=<cfqueryparam cfsqltype="cf_sql_integer" value="#rssite.gallerySmallScale#">
						where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
					</cfquery>
					<cfset application.settingsManager.setSites()>
				<cfelse>
					<cfset arguments.errors.missingtheme="The submitted bundle did not provide valid theme settings information.">
				</cfif>
			</cfif>
			<cfset arguments.Bundle.cleanUp() />
		</cfif>
		
		<cfreturn arguments.errors>
	</cffunction>
	
	<cffunction name="getToWorkSite" returntype="void" output="false">
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
		
		<cfset var keys=arguments.keyFactory/>
		<cfset var rstContentNew=""/>
		<cfset var rstContent=""/>
		<cfset var rstContentObjects=""/>
		<cfset var rstContentTags=""/>
		<cfset var rstSystemObjects=""/>
		<cfset var rstpermissions=""/>
		<cfset var rstSettings=""/>
		<cfset var rstadcampaigns=""/>
		<cfset var rstadcreatives=""/>
		<cfset var rstadipwhitelist=""/>
		<cfset var rstadzones=""/>
		<cfset var rstadzonesnew=""/>
		<cfset var rstadplacements=""/>
		<cfset var rstadplacementdetails=""/>
		<cfset var rstadplacementcategories=""/>
		<cfset var rstcontentcategoryassign=""/>
		<cfset var rstcontentfeeds=""/>
		<cfset var rstcontentfeedsnew=""/>
		<cfset var rstcontentfeeditems=""/>
		<cfset var rstcontentfeedadvancedparams=""/>
		<cfset var rstcontentrelated=""/>
		<cfset var rstMailinglist=""/>
		<cfset var rstMailinglistnew=""/>
		<cfset var rstFiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcategoriesnew=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstusersinterests=""/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getNewID=""/>
		<cfset var rstpluginscripts=""/>
		<cfset var rstplugindisplayobjects=""/>
		<cfset var rstpluginsettings=""/>
		<cfset var rsCheck="">	
		<cfset var rstchangesets=""/>
		<cfset var rstchangesetsnew=""/>
		<cfset var rssite=""/>
		<cfset var rsttrashfiles=""/>
			<!--- pushed tables --->
		
			<!--- tcontent --->
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstContent">
					select * from tcontent 
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> 
					and (tcontent.active = 1 or (tcontent.changesetID is not null and tcontent.approved=0))
					and type !='Module'
					<cfif isDate(arguments.lastDeployment)>
						and lastUpdate >= #createODBCDateTime(lastDeployment)#
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontent = arguments.Bundle.getValue("rstcontent")>
			</cfif>	
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontent 
				where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				and type !='Module'
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
			
			<cfloop query="rstContent">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontent (Active,Approved,audience,Body,ContentHistID,ContentID,Credits,Display,DisplayStart,DisplayStop,featureStart,featureStop,FileID,Filename,forceSSL,inheritObjects,isFeature,IsLocked,IsNav,keyPoints,lastUpdate,lastUpdateBy,lastUpdateByID,MenuTitle,MetaDesc,MetaKeyWords,moduleAssign,ModuleID,nextN,Notes,OrderNo,ParentID,displayTitle,ReleaseDate,RemoteID,RemotePubDate,RemoteSource,RemoteSourceURL,RemoteURL,responseChart,responseDisplayFields,responseMessage,responseSendTo,Restricted,RestrictGroups,searchExclude,SiteID,sortBy,sortDirection,Summary,Target,TargetParams,Template,Title,Type,subType,Path,tags,doCache,created,urltitle,htmltitle,mobileExclude,changesetID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Active),de(Active),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Approved),de(Approved),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(audience neq '',de('no'),de('yes'))#" value="#audience#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Body neq '',de('no'),de('yes'))#" value="#Body#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Credits neq '',de('no'),de('yes'))#" value="#Credits#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Display),de(Display),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(DisplayStart),de('no'),de('yes'))#" value="#DisplayStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(DisplayStop),de('no'),de('yes'))#" value="#DisplayStop#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStart),de('no'),de('yes'))#" value="#featureStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStop),de('no'),de('yes'))#" value="#featureStop#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(FileID neq '',de('no'),de('yes'))#" value="#keys.get(fileID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Filename neq '',de('no'),de('yes'))#" value="#Filename#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(forceSSL),de(forceSSL),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(inheritObjects neq '',de('no'),de('yes'))#" value="#inheritObjects#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isFeature),de(isFeature),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(IsLocked),de(IsLocked),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(IsNav),de(IsNav),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(keyPoints neq '',de('no'),de('yes'))#" value="#keyPoints#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateByID neq '',de('no'),de('yes'))#" value="#lastUpdateByID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(MenuTitle neq '',de('no'),de('yes'))#" value="#MenuTitle#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(MetaDesc neq '',de('no'),de('yes'))#" value="#MetaDesc#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(MetaKeyWords neq '',de('no'),de('yes'))#" value="#MetaKeyWords#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(moduleAssign neq '',de('no'),de('yes'))#" value="#moduleAssign#">,
					<cfif type eq "plugin">
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontent.ModuleID neq '',de('no'),de('yes'))#" value="#keys.get(rstcontent.ModuleID)#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstcontent.ModuleID neq '',de('no'),de('yes'))#" value="#rstcontent.ModuleID#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(nextN),de(nextN),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Notes neq '',de('no'),de('yes'))#" value="#Notes#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayTitle),de(displayTitle),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(ReleaseDate),de('no'),de('yes'))#" value="#ReleaseDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemoteID neq '',de('no'),de('yes'))#" value="#RemoteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemotePubDate neq '',de('no'),de('yes'))#" value="#RemotePubDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemoteSource neq '',de('no'),de('yes'))#" value="#RemoteSource#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemoteSourceURL neq '',de('no'),de('yes'))#" value="#RemoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemoteURL neq '',de('no'),de('yes'))#" value="#RemoteURL#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(responseChart),de(responseChart),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(responseDisplayFields neq '',de('no'),de('yes'))#" value="#responseDisplayFields#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(responseMessage neq '',de('no'),de('yes'))#" value="#responseMessage#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(responseSendTo neq '',de('no'),de('yes'))#" value="#responseSendTo#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Restricted),de(Restricted),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RestrictGroups neq '',de('no'),de('yes'))#" value="#RestrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(searchExclude),de(searchExclude),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortBy neq '',de('no'),de('yes'))#" value="#sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortDirection neq '',de('no'),de('yes'))#" value="#sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Summary neq '',de('no'),de('yes'))#" value="#Summary#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Target neq '',de('no'),de('yes'))#" value="#Target#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(TargetParams neq '',de('no'),de('yes'))#" value="#TargetParams#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Template neq '',de('no'),de('yes'))#" value="#Template#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Title neq '',de('no'),de('yes'))#" value="#Title#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Type neq '',de('no'),de('yes'))#" value="#Type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(subType neq '',de('no'),de('yes'))#" value="#subType#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Path neq '',de('no'),de('yes'))#" value="#Path#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Tags neq '',de('no'),de('yes'))#" value="#Tags#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(doCache),de(doCache),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(created),de('no'),de('yes'))#" value="#created#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(urlTitle neq '',de('no'),de('yes'))#" value="#urltitle#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(htmltitle neq '',de('no'),de('yes'))#" value="#htmltitle#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(mobileExclude),de(mobileExclude),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(changesetID neq '',de('no'),de('yes'))#" value="#changesetID#">
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
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(ColumnID),de(ColumnID),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Object neq '',de('no'),de('yes'))#" value="#Object#">,
					<cfif arguments.keyMode eq "copy" and arguments.fromDSN eq arguments.toDSN>
						<cfif listFindNoCase("plugin,adzone", object)>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ObjectID neq '',de('no'),de('yes'))#" value="#objectID#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ObjectID neq '',de('no'),de('yes'))#" value="#keys.get(objectID)#">,
						</cfif>
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ObjectID neq '',de('no'),de('yes'))#" value="#keys.get(objectID)#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(params neq '',de('no'),de('yes'))#" value="#params#">
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
					insert into tcontenttags (ContentHistID,ContentID,siteID,tag)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(tag neq '',de('no'),de('yes'))#" value="#tag#">
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
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Object neq '',de('no'),de('yes'))#" value="#Object#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR"  value="#arguments.toSiteID#">
					)
				</cfquery>
			</cfloop>
			</cfif>
		
			<!--- BEGIN ADVERTISING--->
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfif not (arguments.keyMode eq "copy" and arguments.toDSN eq arguments.fromDSN)>
					<!--- tadcampaigns --->
					<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstSettings">
							select advertiserUserPoolID from tsettings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
						</cfquery>
					<cfelse>
						<cfquery datasource="#arguments.toDSN#" name="rstSettings">
							select advertiserUserPoolID from tsettings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
						</cfquery>
					</cfif>
						
					<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstadcampaigns">
							select * from tadcampaigns
							where userID in 
							(select userID from tusers where
							siteid = '#application.settingsManager.getSite(rstSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
							siteid = '#application.settingsManager.getSite(rstSettings.advertiserUserPoolID).getPublicUserPoolID()#')
							<cfif isDate(arguments.lastDeployment)>
								and lastUpdate >= #createODBCDateTime(lastDeployment)#
							</cfif>
						</cfquery>
					<cfelse>
						<cfset rstadcampaigns = arguments.Bundle.getValue("rstadcampaigns")>
					</cfif>
					
						<cfquery datasource="#arguments.toDSN#">
							delete from tadcampaigns
							where userID in 
							(select userID from tusers where
							siteid = '#application.settingsManager.getSite(rstSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
							siteid = '#application.settingsManager.getSite(rstSettings.advertiserUserPoolID).getPublicUserPoolID()#')
							<cfif isDate(arguments.lastDeployment)>
								<cfif rstadcampaigns.recordcount or rsDeleted.recordcount>
									and (
									<cfif rstadcampaigns.recordcount>
										campaignID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadcampaigns.campaignID)#">)
									</cfif>
									<cfif rsDeleted.recordcount>
										<cfif rstadcampaigns.recordcount>or</cfif>
										campaignID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
									</cfif>
									)
								<cfelse>
									and 0=1
								</cfif>
							</cfif>
						</cfquery>
						
						<cfloop query="rstadcampaigns">
							<cfquery name="rsCheck" datasource="#arguments.toDSN#">
								select userID from tusers where userID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(userID)#">
							</cfquery>
							<!--- only add the campaign if the user exists--->
							<cfif rsCheck.recordcount>
							<cfquery datasource="#arguments.toDSN#">
								insert into tadcampaigns (campaignID,dateCreated,endDate,isActive,lastUpdate,lastUpdateBy,name,notes,startDate,userID)
								values
								(
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(campaignID)#">,
								<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
								<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(endDate),de('no'),de('yes'))#" value="#endDate#">,
								<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
								<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
								<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(startDate),de('no'),de('yes'))#" value="#startDate#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#userID#">
								)
							</cfquery>
							</cfif>
						</cfloop>
						<!--- tadcreatives --->
						
					<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstadcreatives">
							select * from tadcreatives
							where userID in 
							(select userID from tusers where
							siteid = '#application.settingsManager.getSite(rstSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
							siteid = '#application.settingsManager.getSite(rstSettings.advertiserUserPoolID).getPublicUserPoolID()#')
							<cfif isDate(arguments.lastDeployment)>
								and lastUpdate >= #createODBCDateTime(lastDeployment)#
							</cfif>
						</cfquery>
					<cfelse>
						<cfset rstadcreatives = arguments.Bundle.getValue("rstadcreatives")>
					</cfif>
					
					<cfquery datasource="#arguments.toDSN#">
						delete from tadcreatives 
						where userID in 
						(select userID from tusers where
						siteid = '#application.settingsManager.getSite(rstSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
						siteid = '#application.settingsManager.getSite(rstSettings.advertiserUserPoolID).getPublicUserPoolID()#')
						<cfif isDate(arguments.lastDeployment)>
							<cfif tadcreatives.recordcount or rsDeleted.recordcount>
								and (
								<cfif rstadcreatives.recordcount>
									creativeID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(tadcreatives.creativeID)#">)
								</cfif>
								<cfif rsDeleted.recordcount>
									<cfif tadcreatives.recordcount>or</cfif>
									creativeID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
								</cfif>
								)
							<cfelse>
								and 0=1
							</cfif>
						</cfif>
					</cfquery>
					
					<cfloop query="rstadcreatives">
						<cfquery name="rsCheck" datasource="#arguments.toDSN#">
							select userID from tusers where userID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(userID)#">
						</cfquery>
						<!--- only add the campaign if the user exists--->
						<cfif rsCheck.recordcount>
						<cfquery datasource="#arguments.toDSN#">
							insert into tadcreatives (altText,creativeID,creativeType,dateCreated,fileID,height,isActive,lastUpdate,lastUpdateBy,mediaType,name,notes,redirectURL,textBody,userID,width,target)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(altText neq '',de('no'),de('yes'))#" value="#altText#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(creativeID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeType neq '',de('no'),de('yes'))#" value="#creativeType#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileID neq '',de('no'),de('yes'))#" value="#keys.get(fileID)#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(height),de(height),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(mediaType neq '',de('no'),de('yes'))#" value="#mediaType#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(redirectURL neq '',de('no'),de('yes'))#" value="#redirectURL#">,
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(textBody neq '',de('no'),de('yes'))#" value="#textBody#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#userID#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(width),de(width),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(target neq '',de('no'),de('yes'))#" value="#target#">
							)				
						</cfquery>
						</cfif>
					</cfloop>
					<!--- tadipwhitelist --->
					<cfquery datasource="#arguments.toDSN#">
						delete from tadipwhitelist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					</cfquery>
				<cfif not StructKeyExists(arguments,"Bundle")>
					<cfquery datasource="#arguments.fromDSN#" name="rstadipwhitelist">
						select * from tadipwhitelist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					</cfquery>
				<cfelse>
					<cfset rstadipwhitelist = arguments.Bundle.getValue("rstadipwhitelist")>
				</cfif>
					<cfloop query="rstadipwhitelist">
						<cfquery datasource="#arguments.toDSN#">
							insert into tadipwhitelist (IP,siteID)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(IP neq '',de('no'),de('yes'))#" value="#IP#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
							)
						</cfquery>
					</cfloop>
					
					<!--- tadzones --->
				<cfif not StructKeyExists(arguments,"Bundle")>
					<cfquery datasource="#arguments.fromDSN#" name="rstadzones">
						select * from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
						<cfif isDate(arguments.lastDeployment)>
							and lastUpdate >= #createODBCDateTime(lastDeployment)#
						</cfif>
					</cfquery>
				<cfelse>
					<cfset rstadzones = arguments.Bundle.getValue("rstadzones")>
				</cfif>
				
				<cfquery datasource="#arguments.toDSN#">
						delete from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
						<cfif isDate(arguments.lastDeployment)>
							<cfif rstadzones.recordcount or rsDeleted.recordcount>
								and (
								<cfif rstadzones.recordcount>
									adzoneID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadzones.adzoneID)#">)
								</cfif>
								<cfif rsDeleted.recordcount>
									<cfif rstadzones.recordcount>or</cfif>
									adzoneID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
								</cfif>
								)
							<cfelse>
								and 0=1
							</cfif>
						</cfif>
					</cfquery>
					
					<cfloop query="rstadzones">
						<cfquery datasource="#arguments.toDSN#">
							insert into tadzones (adZoneID,creativeType,dateCreated,height,isActive,lastUpdate,lastUpdateBy,name,notes,siteID,width)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(adZoneID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeType neq '',de('no'),de('yes'))#" value="#creativeType#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(height),de(height),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeid#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(width),de(width),de(0))#">
							)
						</cfquery>
					</cfloop>
					
					<!--- tadplacements --->
				<cfif not StructKeyExists(arguments,"Bundle")>
					<cfquery datasource="#arguments.fromDSN#" name="rstadplacements">
						select * from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
						<cfif isDate(arguments.lastDeployment)>
							and lastUpdate >= #createODBCDateTime(lastDeployment)#
						</cfif>
					</cfquery>
				<cfelse>
					<cfset rstadplacements = arguments.Bundle.getValue("rstadplacements")>
				</cfif>
				<cfquery datasource="#arguments.toDSN#">
						delete from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
						<cfif isDate(arguments.lastDeployment)>
							<cfif rstadplacements.recordcount or rsDeleted.recordcount>
								and (
								<cfif rstadplacements.recordcount>
									placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacements.placementID)#">)
								</cfif>
								<cfif rsDeleted.recordcount>
									<cfif rstadplacements.recordcount>or</cfif>
									placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
								</cfif>
								)
							<cfelse>
								and 0=1
							</cfif>
						</cfif>
					</cfquery>
					<cfloop query="rstadplacements">
						<cfquery datasource="#arguments.toDSN#">
							insert into tadplacements (adZoneID,billable,budget,campaignID,costPerClick,costPerImp,creativeID,dateCreated,endDate,isActive,isExclusive,lastUpdate,lastUpdateBy,notes,placementID,startDate,hasCategories)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(adZoneID neq '',de('no'),de('yes'))#" value="#keys.get(adZoneID)#">,
							<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(billable),de(billable),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(budget),de(budget),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(campaignID neq '',de('no'),de('yes'))#" value="#keys.get(campaignID)#">,
							<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(costPerClick),de(costPerClick),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(costPerImp),de(costPerImp),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeID neq '',de('no'),de('yes'))#" value="#keys.get(creativeID)#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(endDate),de('no'),de('yes'))#" value="#endDate#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isExclusive),de(isExclusive),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(placementID)#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(startDate),de('no'),de('yes'))#" value="#startDate#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(hasCategories),de(hasCategories),de(0))#">
							)
						</cfquery>
					</cfloop>
					
					<!--- tadplacementdetails --->
					<cfquery datasource="#arguments.toDSN#">
						delete from tadplacementdetails where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>))
						<cfif isDate(arguments.lastDeployment)>
							<cfif rstadplacements.recordcount or rsDeleted.recordcount>
								and (
								<cfif rstadplacements.recordcount>
									placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacements.placementID)#">)
								</cfif>
								<cfif rsDeleted.recordcount>
									<cfif rstadplacements.recordcount>or</cfif>
									placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
								</cfif>
								)
							<cfelse>
								and 0=1
							</cfif>
						</cfif>
					</cfquery>
					<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstadplacementdetails">
							select * from tadplacementdetails where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>))
							<cfif isDate(arguments.lastDeployment)>
								<cfif rstadplacements.recordcount>
									and placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacements.placementID)#">)
								<cfelse>
									and 0=1
								</cfif>
							</cfif>
						</cfquery>
					<cfelse>
						<cfset rstadplacementdetails = arguments.Bundle.getValue("rstadplacementdetails")>
					</cfif>
					<cfloop query="rstadplacementdetails">
						<cfquery datasource="#arguments.toDSN#">
							insert into tadplacementdetails (placementID, placementType, placementValue)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(placementID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(placementType neq '',de('no'),de('yes'))#" value="#placementType#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(placementValue),de(placementValue),de(0))#">
							)
						</cfquery>
					</cfloop>
					
					<!--- rstadplacementcategories --->
					<cfquery datasource="#arguments.toDSN#">
						delete from tadplacementcategoryassign where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>))
						<cfif isDate(arguments.lastDeployment)>
							<cfif rstadplacements.recordcount or rsDeleted.recordcount>
								and (
								<cfif rstadplacements.recordcount>
									placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacements.placementID)#">)
								</cfif>
								<cfif rsDeleted.recordcount>
									<cfif rstadplacements.recordcount>or</cfif>
									placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
								</cfif>
								)
							<cfelse>
								and 0=1
							</cfif>
						</cfif>
					</cfquery>
					<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstadplacementcategories">
							select * from tadplacementcategoryassign where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>))
							<cfif isDate(arguments.lastDeployment)>
								<cfif rstadplacements.recordcount>
									and placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacements.placementID)#">)
								<cfelse>
									and 0=1
								</cfif>
							</cfif>
						</cfquery>
					<cfelse>
						<cfset rstadplacementcategories = arguments.Bundle.getValue("rstadplacementcategories")>
					</cfif>
					<cfloop query="rstadplacementcategories">
						<cfquery datasource="#arguments.toDSN#">
							insert into tadplacementcategoryassign (placementID, categoryID)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(placementID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(categoryID)#">
							)
						</cfquery>
					</cfloop>
				</cfif>
			</cfif>
			<!--- END ADVERTISING--->
			
			
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
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(categoryID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStart),de('no'),de('yes'))#" value="#featureStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStop),de('no'),de('yes'))#" value="#featureStop#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isFeature),de(isFeature),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(orderno),de(orderno),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentfeeds --->
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentfeeds">
					select * from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						and lastUpdate >= #createODBCDateTime(lastDeployment)#
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
					insert into tcontentfeeds (allowHTML,channelLink,dateCreated,description,feedID,isActive,isDefault,isFeaturesOnly,isPublic,lang,lastUpdate,lastUpdateBy,maxItems,name,parentID,restricted,restrictGroups,siteID,Type,version,sortBy,sortDirection,nextN,displayName,displayRatings,displayComments,altname,remoteID,remoteSourceURL,remotePubDate)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(allowHTML),de(allowHTML),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(channelLink neq '',de('no'),de('yes'))#" value="#channelLink#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(description neq '',de('no'),de('yes'))#" value="#description#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isDefault),de(isDefault),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isFeaturesOnly),de(isFeaturesOnly),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isPublic),de(isPublic),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lang neq '',de('no'),de('yes'))#" value="#lang#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(maxItems),de(maxItems),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#keys.get(parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(restricted),de(restricted),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(restrictGroups neq '',de('no'),de('yes'))#" value="#restrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Type neq '',de('no'),de('yes'))#" value="#Type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(version neq '',de('no'),de('yes'))#" value="#version#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortBy neq '',de('no'),de('yes'))#" value="#sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortDirection neq '',de('no'),de('yes'))#" value="#sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(nextN),de(nextN),de(20))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayName),de(displayName),de(1))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayRatings),de(displayRatings),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayComments),de(displayComments),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(altname neq '',de('no'),de('yes'))#" value="#altname#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteid neq '',de('no'),de('yes'))#" value="#remoteid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteSourceURL neq '',de('no'),de('yes'))#" value="#remoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(remotePubDate neq '',de('no'),de('yes'))#" value="#remotePubDate#">
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
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(itemID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">
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
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(paramID)#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(param),de('no'),de('yes'))#" value="#param#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(relationship neq '',de('no'),de('yes'))#" value="#relationship#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(field neq '',de('no'),de('yes'))#" value="#field#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(dataType neq '',de('no'),de('yes'))#" value="#dataType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(condition neq '',de('no'),de('yes'))#" value="#condition#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(criteria neq '',de('no'),de('yes'))#" value="#criteria#">
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
					insert into tcontentrelated (contentHistID,contentID,relatedID,siteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(relatedID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">
					)
				</cfquery>
			</cfloop>
			<!--- tmailinglist --->
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstMailinglist">
					select * from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						 and lastUpdate >= #createODBCDateTime(lastDeployment)#
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
							lastUpdate >= #createODBCDateTime(lastDeployment)#
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
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Description neq '',de('no'),de('yes'))#" value="#Description#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isPublic),de(isPublic),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isPurge),de(isPurge),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(LastUpdate),de('no'),de('yes'))#" value="#LastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(MLID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
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
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(MLID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#Email#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fname neq '',de('no'),de('yes'))#" value="#fname#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lname neq '',de('no'),de('yes'))#" value="#lname#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(company neq '',de('no'),de('yes'))#" value="#company#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isVerified),de(isVerified),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(created),de('no'),de('yes'))#" value="#created#">
					)
				</cfquery>
			</cfloop>
			</cfif>
			
			<!--- tchangesets --->		
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstchangesets">
					select * from tchangesets where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						and lastUpdate >= #createODBCDateTime(lastDeployment)#
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
					remoteID, remotePubDate, remoteSourceURL)
					values (
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(changesetID)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Description neq '',de('no'),de('yes'))#" value="#Description#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(Created),de('no'),de('yes'))#" value="#Created#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(publishDate),de('no'),de('yes'))#" value="#publishDate#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(published),de(published),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(LastUpdate),de('no'),de('yes'))#" value="#LastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(LastUpdateBy neq '',de('no'),de('yes'))#" value="#LastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(LastUpdateByID neq '',de('no'),de('yes'))#" value="#LastUpdateByID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteID neq '',de('no'),de('yes'))#" value="#remoteID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(remotePubDate),de('no'),de('yes'))#" value="#remotePubDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteSourceURL neq '',de('no'),de('yes'))#" value="#remoteSourceURL#">
					)
				</cfquery>
			</cfloop>
			
			
			<!--- tcontentcategories --->
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentcategories">
					select * from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif isDate(arguments.lastDeployment)>
						and lastUpdate >= #createODBCDateTime(lastDeployment)#
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstcontentcategories = arguments.Bundle.getValue("rstcontentcategories")>
			</cfif>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
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
					insert into tcontentcategories (categoryID,dateCreated,isActive,isInterestGroup,isOpen,lastUpdate,lastUpdateBy,name,notes,parentID,restrictGroups,siteID,sortBy,sortDirection,Path,remoteID,remoteSourceURL,remotePubDate,filename,urltitle)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(categoryID)#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isInterestGroup),de(isInterestGroup),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isOpen),de(isOpen),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#keys.get(parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(restrictGroups neq '',de('no'),de('yes'))#" value="#restrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortBy neq '',de('no'),de('yes'))#" value="#sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortDirection neq '',de('no'),de('yes'))#" value="#sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Path neq '',de('no'),de('yes'))#" value="#Path#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteid neq '',de('no'),de('yes'))#" value="#remoteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteSourceURL neq '',de('no'),de('yes'))#" value="#remoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(remotePubDate neq '',de('no'),de('yes'))#" value="#remotePubDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(filename neq '',de('no'),de('yes'))#" value="#filename#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(urltitle neq '',de('no'),de('yes'))#" value="#urltitle#">
					)
				</cfquery>
			</cfloop>
			
			<!--- synced tables--->
			<cfset arguments.rstcontent=rstcontent>
			
	</cffunction>
	
	<cffunction name="getToWorkFiles" returntype="void" output="false">
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
		
		<!---
		<cfloop list="#arguments.moduleID#" index="i">
			<cfset moduleIDSQLlist=listAppend(moduleIDlist,"'#keys.get(i)#'")>
		</cfloop>
		--->
		
		<!--- tfiles --->
			<cfif structKeyExists(arguments,"Bundle")>
				<cfset rsttrashfiles=bundle.getValue("rsttrashfiles")/>
			<cfelse>
				<cfset rsttrashfiles=queryNew("objectID")>
			</cfif>		
				
			<cfif isDate(arguments.lastDeployment) and rsttrashfiles.recordcount>
				<cfif rsttrashfiles.recordcount>
					<cfloop query="rsttrashfiles">
						<cfdirectory name="rsFileCheck" action="list" directory="#application.confiBean.getFileDir()#/#arguments.toSiteID#/cache/file/" filter="#rsttrashfiles.fileID#*">
						<cfif rsFileCheck.recordcount>
							<cfloop query="rsFileCheck">
								<cffile action="delete" file="#application.confiBean.getFileDir()#/#arguments.toSiteID#/cache/file/#rsFileCheck.name#">
							</cfloop>
						</cfif>
					</cfloop>
				</cfif>
				
				<cfquery datasource="#arguments.toDSN#">
				delete from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				and moduleid  in (''<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.usersMode neq "none">,'00000000000000000000000000000000008'</cfif><cfif arguments.contentMode neq "none">,'00000000000000000000000000000000000'</cfif>)
				and fileID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valuesList(rsttrashfiles.fileID)#">)
				</cfquery>
			</cfif>
			
			<cfif not isDate(arguments.lastDeployment)>
				<cfquery datasource="#arguments.toDSN#">
					delete from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and moduleid  in (''<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.usersMode neq "none">,'00000000000000000000000000000000008'</cfif><cfif arguments.contentMode neq "none">,'00000000000000000000000000000000000'</cfif>)
				</cfquery>
			</cfif>
			
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstFiles">
					select * from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and moduleid  in (''<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.usersMode neq "none">,'00000000000000000000000000000000008'</cfif><cfif arguments.contentMode neq "none">,'00000000000000000000000000000000000'</cfif>)
					<cfif isDate(arguments.lastDeployment)>
						created >= #createODBCDateTime(created)#
					</cfif>
				</cfquery>
			<cfelse>
				<cfset rstFiles = arguments.Bundle.getValue("rstfiles")>
				<cfquery name="rstfiles" dbtype="query">
					select * from rstfiles where
					moduleid  in (''<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.usersMode neq "none">,'00000000000000000000000000000000008'</cfif><cfif arguments.contentMode neq "none">,'00000000000000000000000000000000000'</cfif>)
				</cfquery>
			</cfif>
			
			<cfloop query="rstFiles">
				<cfquery datasource="#arguments.toDSN#">
					insert into tfiles (contentID,contentSubType,contentType,fileExt,fileID,filename,fileSize,
					image,imageMedium,imageSmall,moduleID,siteID,created)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentID neq '',de('no'),de('yes'))#" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentSubType neq '',de('no'),de('yes'))#" value="#contentSubType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentType neq '',de('no'),de('yes'))#" value="#contentType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileExt neq '',de('no'),de('yes'))#" value="#fileExt#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileID neq '',de('no'),de('yes'))#" value="#keys.get(fileID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(filename neq '',de('no'),de('yes'))#" value="#filename#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(fileSize),de(fileSize),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(rstFiles.image) eq '',de('yes'),de('no'))#" value="#rstFiles.image#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(rstFiles.imageMedium) eq '',de('yes'),de('no'))#" value="#rstFiles.imageMedium#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(rstFiles.imageSmall) eq '',de('yes'),de('no'))#" value="#rstFiles.imageSmall#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(rstfiles.moduleID neq '',de('no'),de('yes'))#" value="#rstfiles.moduleID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(created),de('no'),de('yes'))#" value="#created#">
					)
				</cfquery>
			</cfloop>
			
	</cffunction>
	
	<cffunction name="getToWorkTrash" returntype="void" output="false">
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
						insert into ttrash (objectID,parentID,siteID,objectClass,objectLabel,objectType,objectSubType,objectString,deletedDate,deletedBy)
							values(	
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(objectID)#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(parentID)#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#objectClass#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#objectLabel#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#objectType#" />,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#objectSubType#" />,
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#allValues#" />,
								#createODBCDateTime(deletedDate)#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#deletedBy#" />
							)			
					</cfquery>
					
					<cfcatch></cfcatch>
					</cftry>
				</cfloop>
			</cfif>
	
	</cffunction>

	<cffunction name="getToWorkSyncMeta" returntype="void" output="false">
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
							insert into tcontentcomments (comments,commentid,contenthistid,contentid,email,entered,ip,isApproved,name,siteid,url,subscribe,parentID,path)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(comments neq '',de('no'),de('yes'))#" value="#comments#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(commentid neq '',de('no'),de('yes'))#" value="#keys.get(commentID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contenthistid neq '',de('no'),de('yes'))#" value="#keys.get(contentHistID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentid neq '',de('no'),de('yes'))#" value="#keys.get(contentID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(email neq '',de('no'),de('yes'))#" value="#email#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(entered),de('no'),de('yes'))#" value="#entered#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ip neq '',de('no'),de('yes'))#" value="#ip#">,
							<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isApproved),de(isApproved),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeid#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(url neq '',de('no'),de('yes'))#" value="#url#">,
							<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(subscribe),de(subscribe),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#keys.get(parentID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(path neq '',de('no'),de('yes'))#" value="#path#">
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
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rate),de(rate),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.fromsiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#keys.get(userID)#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(entered),de('no'),de('yes'))#" value="#entered#">
					)
				</cfquery>
			</cfloop>
			
			<cfset rstcontentstats=Bundle.getValue("rstcontentstats")>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentstats where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
			<cfloop query="rstcontentstats">
				<cfquery datasource="#arguments.fromDSN#">
					insert into tcontentstats (contentID,siteID,views,rating,totalVotes,upVotes,downVotes,comments)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(views),de(views),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rating),de(rating),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(totalVotes),de(totalVotes),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(upVotes),de(upVotes),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(downVotes),de(downVotes),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(comments),de(comments),de(0))#">,
					)
				</cfquery>
			</cfloop>
		</cfif>
	
	</cffunction>

	<cffunction name="getToWorkUsers" returntype="void" output="false">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="Bundle" type="any" required="false">
		<cfargument name="usersMode" type="any" required="false">
		<cfargument name="lastDeployment" type="any" required="false">
		<cfargument name="errors" type="any" required="true" default="#structNew()#">
		
		<cfset var rstusers="">
		<cfset var rstusersmemb="">
		<cfset var rstuserstags="">
		<cfset var rstusersinterests="">
		<cfset var rstusersfavorites="">
		<cfset var rstuseraddresses="">
		<cfset var keys=arguments.keyFactory>
		
		<cfset arguments.rsUserConflicts=queryNew("userID")>
		
		<!--- tpermissions--->
			<cfquery datasource="#arguments.toDSN#">
				delete from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rsTPermissions">
					select * from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
			<cfelse>
				<cfset rsTPermissions = arguments.Bundle.getValue("rsTPermissions")>
			</cfif>
			<cfloop query="rsTPermissions">
				<cfquery datasource="#arguments.toDSN#">
					insert into tpermissions (contentID,groupID,Type,SiteID)
					values
					(
					<cfif type eq "module" or not find("-",contentID)>
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#contentID#">
					<cfelse>
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#groupID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
					)
				</cfquery>
			</cfloop>
			
		<cfif arguments.usersMode neq "none" and structKeyExists(arguments,"Bundle")>
			<cfset rstusers = arguments.Bundle.getValue("rstusers")>
		
			<cfif rstusers.recordcount>
				<cfquery name="arguments.rsUserConflicts" datasource="#arguments.toDSN#">
					select userID,username from tusers where 
					username in (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstusers.username)#" list="true">
								)
					and siteID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">	
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
								select userID from tusers where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">	
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
					<cfquery datasource="#arguments.toDSN#">
						insert into tusersmemb (userID,groupID) values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(userID)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(groupID)#">
						)
					</cfquery>
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
						siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
						
						<cfif arguments.rsUserConflicts.recordcount>
							and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
					   </cfif>		
					</cfquery>
					
					<cfloop query="rstuserstags">
						<cfquery datasource="#arguments.toDSN#">
							insert into tuserstags (userID,siteID,tag) values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(userID)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#tag#">
							)
						</cfquery>
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
									select userID from tusers where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">	
									)
						<cfif arguments.rsUserConflicts.recordcount>
							and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
					   </cfif>
					</cfquery>
					
					<cfloop query="rstusersinterests">
						<cfquery datasource="#arguments.toDSN#">
							insert into tusersinterests (userID,categoryID) values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(userID)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(categoryID)#">
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
					siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
					<cfif arguments.rsUserConflicts.recordcount>
						and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
				   </cfif>	
				</cfquery>
				
				<cfloop query="rstusersfavorites">
					<cfquery datasource="#arguments.toDSN#">
						insert into tusersfavorites (userID,favoriteName,favorite,type,siteID,dateCreated,columnNumber,rowNumber,maxRssItems ) values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(userID)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(favoriteName neq '',de('no'),de('yes'))#" value="#favoriteName#">,
						<cfif isValid("UUID",favorite)>
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(favorite neq '',de('no'),de('yes'))#" value="#keys.get(favorite)#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(favorite neq '',de('no'),de('yes'))#" value="#favorite#">,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,
					    #createODBCDateTime(dateCreated)#,
						<cfqueryparam cfsqltype="cf_sql_integer" null="#iif(isnumeric(columnNumber),de('no'),de('yes'))#" value="#columnNumber#">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="#iif(isnumeric(rowNumber),de('no'),de('yes'))#" value="#rowNumber#">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="#iif(isnumeric(maxRSSItems),de('no'),de('yes'))#" value="#maxRSSItems#">
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
					siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
					<cfif arguments.rsUserConflicts.recordcount>
						and userID not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(arguments.rsUserConflicts.userID)#" list="true">)
				   </cfif>	
				</cfquery>
				
				<cfloop query="rstuseraddresses">
					<cfquery datasource="#arguments.toDSN#">
						INSERT INTO tuseraddresses  (AddressID,UserID,siteID,
							phone,fax,address1, address2, city, state, zip ,
							addressName,country,isPrimary,addressNotes,addressURL,
							longitude,latitude,addressEmail,hours)
					     VALUES(
					        <cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(addressID)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(userID)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Phone neq '',de('no'),de('yes'))#" value="#Phone#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Fax neq '',de('no'),de('yes'))#" value="#Fax#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Address1 neq '',de('no'),de('yes'))#" value="#Address1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Address2 neq '',de('no'),de('yes'))#" value="#Address2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(City neq '',de('no'),de('yes'))#" value="#City#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(State neq '',de('no'),de('yes'))#" value="#State#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Zip neq '',de('no'),de('yes'))#" value="#Zip#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(AddressName neq '',de('no'),de('yes'))#" value="#AddressName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Country neq '',de('no'),de('yes'))#" value="#Country#">,
							#isprimary#,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(AddressNotes neq '',de('no'),de('yes'))#" value="#AddressNotes#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(AddressURL neq '',de('no'),de('yes'))#" value="#AddressURL#">,
							#Longitude#,
							#Latitude#,
							<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(AddressEmail neq '',de('no'),de('yes'))#" value="#AddressEmail#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(Hours neq '',de('no'),de('yes'))#" value="#Hours#">
							  )
					</cfquery>
				</cfloop>
				
				<cfquery datasource="#arguments.toDSN#">
					delete from tusers where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
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
				        <cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(userID)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#remoteID#">,
						 #s2#, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Fname neq '',de('no'),de('yes'))#" value="#fname#">,
						  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Lname neq '',de('no'),de('yes'))#" value="#lname#">, 
				         <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Password neq '',de('no'),de('yes'))#" value="#password#">,
						 <cfif isDate(passwordCreated)>#createODBCDateTime(passwordCreated)#<cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Email neq '',de('no'),de('yes'))#" value="#email#">,
				         <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(GroupName neq '',de('no'),de('yes'))#" value="#groupname#">, 
				         #Type#,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(SubType neq '',de('no'),de('yes'))#" value="#subtype#">, 
				        <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(ContactForm neq '',de('no'),de('yes'))#" value="#contactform#">,
						  <cfif isDate(lastUpdate)>#createodbcdatetime(lastUpdate)#<cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(LastUpdateBy neq '',de('no'),de('yes'))#" value="#lastupdateBy#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(LastUpdateById neq '',de('no'),de('yes'))#" value="#keys.get(lastUpdateByID)#">,
						 #InActive#,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Username neq '',de('no'),de('yes'))#" value="#username#">,
						  #perm#,
						  #ispublic#,
						   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Company neq '',de('no'),de('yes'))#" value="#company#">,
						   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(JobTitle neq '',de('no'),de('yes'))#" value="#jobTitle#">, 
						  #subscribe#,
						   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">,
						  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Website neq '',de('no'),de('yes'))#" value="#website#">,
						 <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(Notes neq '',de('no'),de('yes'))#" value="#notes#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(MobilePhone neq '',de('no'),de('yes'))#" value="#mobilePhone#">,
						  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Description neq '',de('no'),de('yes'))#" value="#description#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(Interests neq '',de('no'),de('yes'))#" value="#translateKeyList(interests,keys)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(photoFileID neq '',de('no'),de('yes'))#" value="#keys.get(photoFileID)#">,
						#KeepPrivate#,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(IMName neq '',de('no'),de('yes'))#" value="#IMName#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(IMService neq '',de('no'),de('yes'))#" value="#IMService#">,
						  <cfif isDate(created)>#createODBCDAteTime(created)#<cfelse>null</cfif>,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(tags neq '',de('no'),de('yes'))#" value="#tags#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(tablist neq '',de('no'),de('yes'))#" value="#tablist#">
						 )
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
		
		
	</cffunction>
	
	<cffunction name="getToWorkSyncMetaOLD" returntype="void" output="false">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="mode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="rstcontent" type="any" required="true">
		<cfargument name="rsDeleted" type="any" required="true">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">		
		
		<cfset var keys=arguments.keyFactory/>
		<cfset var rstContentObjects=""/>
		<cfset var rstContentTags=""/>
		<cfset var rstSystemObjects=""/>
		<cfset var rstpermissions=""/>
		<cfset var rstSettings=""/>
		<cfset var rstadcampaigns=""/>
		<cfset var rstadcreatives=""/>
		<cfset var rstadipwhitelist=""/>
		<cfset var rstadzones=""/>
		<cfset var rstadplacements=""/>
		<cfset var rstadplacementdetails=""/>
		<cfset var rstcontentcategoryassign=""/>
		<cfset var rstcontentfeeds=""/>
		<cfset var rstcontentfeeditems=""/>
		<cfset var rstcontentfeedadvancedparams=""/>
		<cfset var rstcontentrelated=""/>
		<cfset var rstMailinglist=""/>
		<cfset var rstFiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstusersinterests=""/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getNewID=""/>
		<cfset var rstpluginscripts=""/>
		<cfset var rstplugindisplayobjects=""/>
		<cfset var rstpluginsettings=""/>
		<cfset var rsRemoteDefinitions=application.configBean.getClassExtensionManager().buildDefinitionsQuery(arguments.toDSN)>		
		<cfset var rsRemoteAttribute="">
		
		
				<!--- tcontentcomments --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tcontentcomments where commentid not in (select commentid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				</cfquery>
				<cfquery datasource="#arguments.toDSN#" name="rstcontentcomments">
					select * from tcontentcomments where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#">
					delete from tcontentcomments where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
				<cfloop query="rstcontentcomments">
					<cfquery datasource="#arguments.fromDSN#">
						insert into tcontentcomments (comments,commentid,contenthistid,contentid,email,entered,ip,isApproved,name,siteid,url,subscribe,parentID,path)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(comments neq '',de('no'),de('yes'))#" value="#comments#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(commentid neq '',de('no'),de('yes'))#" value="#keys.get(commentID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contenthistid neq '',de('no'),de('yes'))#" value="#keys.get(contentHistID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentid neq '',de('no'),de('yes'))#" value="#keys.get(contentID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(email neq '',de('no'),de('yes'))#" value="#email#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(entered),de('no'),de('yes'))#" value="#entered#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ip neq '',de('no'),de('yes'))#" value="#ip#">,
						<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isApproved),de(isApproved),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.fromsiteid#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(url neq '',de('no'),de('yes'))#" value="#url#">,
						<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(subscribe),de(subscribe),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#keys.get(parentID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(path neq '',de('no'),de('yes'))#" value="#path#">
						)
					</cfquery>
				</cfloop>
				<!--- tcontentratings --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tcontentratings where contentid not in (select contentid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				</cfquery>
				<cfquery datasource="#arguments.toDSN#" name="rstcontentRatings">
					select * from tcontentratings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#">
					delete from tcontentratings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
				<cfloop query="rstcontentRatings">
					<cfquery datasource="#arguments.fromDSN#">
						insert into tcontentratings (contentID,rate,siteID,userID,entered)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(contentID)#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rate),de(rate),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.fromsiteID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#keys.get(userID)#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(entered),de('no'),de('yes'))#" value="#entered#">
						)
					</cfquery>
				</cfloop>
	
				<!--- tusersinterests --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tusersinterests where categoryid not in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				</cfquery>
				<cfquery datasource="#arguments.toDSN#" name="rstusersinterests">
					select * from tusersinterests where categoryid in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#">
					delete from tusersinterests where categoryid in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
				</cfquery>
				<cfloop query="rstusersinterests">
					<cfquery datasource="#arguments.fromDSN#">
						insert into tusersinterests (categoryID,userID)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(categoryID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(userID)#">
						)
					</cfquery>
				</cfloop>
		
	</cffunction>
		
	<cffunction name="getToWorkClassExtensionOLD" returntype="void">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="mode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="contentPushMode" type="any" default="full" required="true">
		<cfargument name="rstcontent" type="any" required="true">
		<cfargument name="rsDeleted" type="any" required="true">
		<cfargument name="errors" type="any" required="true">
		<cfargument name="renderingMode" type="string" default="all" required="true">
		<cfargument name="pluginMode" type="string" default="all" required="true">		
					
				<!--- tclassextenddata --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextenddata 
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and baseID  
						in (select contenthistid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
							<cfif isDate(arguments.lastDeployment)>
								<cfif arguments.rstcontent.recordcount or arguments.rsDeleted.recordcount>
									and (
									<cfif arguments.rstcontent.recordcount>
										contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(arguments.rstcontent.contentID)#">)
									</cfif>
									<cfif arguments.rsDeleted.recordcount>
										<cfif arguments.rstcontent.recordcount>or</cfif>
										contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(arguments.rsDeleted.objectID)#">)
									</cfif>
									)
								<cfelse>
									and 0=1
								</cfif>
							</cfif>
							)
				</cfquery>
				
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextenddata">
					select tclassextenddata.baseID, tclassextenddata.attributeID, tclassextenddata.attributeValue, tclassextenddata.siteID, 
					tclassextenddata.stringvalue, tclassextenddata.numericvalue, tclassextenddata.datetimevalue, tclassextenddata.remoteID,
					tclassextendattributes.name
					from tclassextenddata 
					Inner Join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID)
					where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and tclassextenddata.baseID 
						in (
							select contenthistid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
							<cfif isDate(arguments.lastDeployment)>
								<cfif arguments.rstcontent.recordcount>
									and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(arguments.rstcontent.contentID)#">)
								<cfelse>
									and 0=1
								</cfif>
							</cfif>
							)
				</cfquery>
				
				<cfloop query="rstclassextenddata">
					<cfquery name="rsRemoteAttribute" dbtype="query">
					select attributeID from rsRemoteDefinitions 
					where attributename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstclassextenddata.name#">
					and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
					</cfquery>
					<!--- Only move the data over if the attribute exists --->
					<cfif rsRemoteAttribute.recordcount>
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextenddata (baseID,attributeID,attributeValue,siteID, stringvalue, numericvalue, datetimevalue, remoteID)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(baseID)#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rsRemoteAttribute.attributeID),de(rsRemoteAttribute.attributeID),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(attributeValue neq '',de('no'),de('yes'))#" value="#attributeValue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(stringvalue neq '',de('no'),de('yes'))#" value="#stringvalue#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(numericvalue),de('no'),de('yes'))#" value="#numericvalue#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(datetimevalue),de('no'),de('yes'))#" value="#datetimevalue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteID neq '',de('no'),de('yes'))#" value="#remoteID#">
							)
						</cfquery>
					</cfif>
				</cfloop>
		
	</cffunction>
	
	<cffunction name="getToWorkClassExtensions" returntype="void">
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
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getAttributeID=""/>
		<cfset var existingAttributeList=""/>
		<cfset var fileattributeList=""/>
		<cfset var rsbaseids=""/>
		<cfset var typeList="">
		<cfset var incomingAttributeList="">
		
		<cfparam name="arguments.rsUserConflicts" default="#queryNew('userID')#">
		
		<cfif arguments.usersMode neq "none">
			<cfset typeList="1,2,User,Group,Address">
		</cfif>
		<cfif arguments.contentMode neq "none">
			<cfif arguments.usersMode neq "none">
				<cfset typeList=typeList & ",">
			</cfif>
			<cfset typeList=typeList & "Custom,Page,Portal,Gallery,Calendar,Link,File">
		</cfif>
		
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextend">
					select * from tclassextend where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and type in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#typeList#" list="true">)
				</cfquery>
			<cfelse>
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
				</cfquery>
			
				<cfloop query="rstclassextend">
					<cfquery datasource="#arguments.toDSN#">
						insert into tclassextend (subTypeID,siteID, baseTable, baseKeyField, dataTable, type, subType,
						isActive, notes, lastUpdate, dateCreated, lastUpdateBy)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(subTypeID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(baseTable neq '',de('no'),de('yes'))#" value="#baseTable#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(baseKeyField neq '',de('no'),de('yes'))#" value="#baseKeyField#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(baseTable neq '',de('no'),de('yes'))#" value="#baseTable#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(subType neq '',de('no'),de('yes'))#" value="#subType#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(isActive neq '',de('no'),de('yes'))#" value="#isActive#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
						#createODBCDateTime(now())#,
						#createODBCDateTime(now())#,
						'System'
						)
					</cfquery>
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
				subtypeID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextend.subtypeID)#" list="true">)
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
			
				<cfloop query="rstclassextendsets">
					
					<cfquery datasource="#arguments.toDSN#">
						insert into tclassextendsets (extendsetID, subTypeID, categoryID, siteID, name, orderno, isActive, container)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(extendSetID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(subTypeID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(categoryID neq '',de('no'),de('yes'))#" value="#translateKeyList(categoryID,keys)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(orderno neq '',de('no'),de('yes'))#" value="#orderno#">,
						<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isActive neq '',de('no'),de('yes'))#" value="#isActive#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(container neq '',de('no'),de('yes'))#" value="#container#">
						)
					</cfquery>
					
				</cfloop>
				
			<cfif not StructKeyExists(arguments,"Bundle")>
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextendattributes">
					select * from tclassextendattributes where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and extendsetID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextendsets.extendsetID)#" list="true">)
				</cfquery>
			<cfelse>
				<cfset rstclassextendattributes = arguments.Bundle.getValue("rstclassextendattributes")>
				
				<cfquery name="rstclassextendattributes" dbtype="query">
					select * from rstclassextendattributes where 
					extendsetID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextendsets.extendsetID)#" list="true">)
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
						<cfset keys.get(attributeID, getAttributeID.attributeID)>
						<cfset existingAttributeList=listAppend(existingAttributeList,keys.get(attributeID))>
						<cfquery datasource="#arguments.toDSN#">
							update tclassextendattributes set
							extendSetID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(extendSetID)#">,
							siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
							name=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
							label=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(label neq '',de('no'),de('yes'))#" value="#label#">,
							hint=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(hint neq '',de('no'),de('yes'))#" value="#hint#">,
							type=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
							orderno=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(orderno neq '',de('no'),de('yes'))#" value="#orderno#">,
							isActive=<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(isActive neq '',de('no'),de('yes'))#" value="#isActive#">,
							required=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(required neq '',de('no'),de('yes'))#" value="#required#">,
							validation=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(validation neq '',de('no'),de('yes'))#" value="#validation#">,
							regex=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(regex neq '',de('no'),de('yes'))#" value="#regex#">,
							message=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(message neq '',de('no'),de('yes'))#" value="#message#">,
							defaultValue=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(defaultValue neq '',de('no'),de('yes'))#" value="#defaultValue#">,
							optionlist=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(optionList neq '',de('no'),de('yes'))#" value="#optionList#">,
							optionlabellist=<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(optionLabelList neq '',de('no'),de('yes'))#" value="#optionLabelList#">
							where attributeID=<cfqueryparam cfsqltype="cf_sql_INTEGER" value="#keys.get(attributeID)#">
						</cfquery>
				
						
					<cfelse>
					
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextendattributes (extendSetID, siteID, name, label, hint, 
								type, orderno, isActive, required, validation, regex, message, defaultValue, optionList, optionLabelList)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(extendSetID)#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(label neq '',de('no'),de('yes'))#" value="#label#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(hint neq '',de('no'),de('yes'))#" value="#hint#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(orderno neq '',de('no'),de('yes'))#" value="#orderno#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(isActive neq '',de('no'),de('yes'))#" value="#isActive#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(required neq '',de('no'),de('yes'))#" value="#required#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(validation neq '',de('no'),de('yes'))#" value="#validation#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(regex neq '',de('no'),de('yes'))#" value="#regex#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(message neq '',de('no'),de('yes'))#" value="#message#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(defaultValue neq '',de('no'),de('yes'))#" value="#defaultValue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(optionList neq '',de('no'),de('yes'))#" value="#optionList#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(optionLabelList neq '',de('no'),de('yes'))#" value="#optionLabelList#">
							)
						</cfquery>
						
						<cfquery name="getAttributeID" datasource="#arguments.toDSN#">
						select max(attributeID) as newID from tclassextendattributes
						</cfquery>
						
						<cfset keys.get(attributeID, getAttributeID.newID)>
						
					</cfif>
					
					<!--- Extended attribute values of type file need to go through the key factory--->
					<cfif type eq "File">
						<cfset fileattributelist=listAppend(fileattributelist,keys.get(attributeID))>
					</cfif>
					
					<cfset incomingAttributeList=listAppend(incomingAttributeList,attributeID)>
					
				</cfloop>
			
				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextendattributes
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and extendSetID not in (
							select extendSetID from tclassextendsets
							where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/> 			
							)
				</cfquery>
			
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
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextenddata (baseID,attributeID,attributeValue,stringvalue,siteID,numericvalue,datetimevalue,remoteID
							)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(baseID)#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" value="#keys.get(attributeID)#">,
							
							<!--- Extended attribute values of type file need to go through the key factory--->
							<cfif listFind(fileattributelist,keys.get(attributeID))>
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(attributeValue neq '',de('no'),de('yes'))#" value="#keys.get(attributeValue)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(stringvalue neq '',de('no'),de('yes'))#" value="#keys.get(stringValue)#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(attributeValue neq '',de('no'),de('yes'))#" value="#attributeValue#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(stringvalue neq '',de('no'),de('yes'))#" value="#stringvalue#">,
							</cfif>
							
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(numericvalue),de('no'),de('yes'))#" value="#numericvalue#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(datetimevalue),de('no'),de('yes'))#" value="#datetimevalue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteID neq '',de('no'),de('yes'))#" value="#remoteID#">
							
							)
						</cfquery>
						<cfcatch>
							<cfdump var="#baseID#">
							<cfdump var="#attributeID#">
							<cfdump var="#keys.get(attributeID)#">
							<cfdump var="#cfcatch#">
							<cfabort>
						</cfcatch>
					</cftry>
				</cfloop>
			</cfif>
			
			<cfif arguments.usersMode neq "none" and structKeyExists(arguments,"Bundle")>
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
					<cftry>
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextenddatauseractivity (baseID,attributeID,attributeValue,stringvalue,siteID,numericvalue,datetimevalue,remoteID)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(baseID)#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" value="#keys.get(attributeID)#">,
							
							<!--- Extended attribute values of type file need to go through the key factory--->
							<cfif listFind(fileattributelist,keys.get(attributeID))>
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(attributeValue neq '',de('no'),de('yes'))#" value="#keys.get(attributeValue)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(stringvalue neq '',de('no'),de('yes'))#" value="#keys.get(stringValue)#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(attributeValue neq '',de('no'),de('yes'))#" value="#attributeValue#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(stringvalue neq '',de('no'),de('yes'))#" value="#stringvalue#">,
							</cfif>
							
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(numericvalue),de('no'),de('yes'))#" value="#numericvalue#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(datetimevalue),de('no'),de('yes'))#" value="#datetimevalue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteID neq '',de('no'),de('yes'))#" value="#remoteID#">
							)
						</cfquery>
						<cfcatch>
							<cfdump var="#baseID#">
							<cfdump var="#attributeID#">
							<cfdump var="#attributeValue#">
							<cfdump var="#cfcatch#">
							<cfabort>
						</cfcatch>
					</cftry>
				</cfloop>
			</cfif>
	</cffunction>

	<cffunction name="getToWorkPlugins" returntype="void">
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
								and moduleID!=<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
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
						
						<cfquery datasource="#arguments.toDSN#" name="rsCheck">
							select * from tcontent 
							where moduleID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/> and type='Plugin'
							<!---and siteID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#"/>--->
						</cfquery>
						
						<cfif rscheck.recordcount>
							<cfquery datasource="#arguments.todsn#">
							update tcontent set
							title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstplugins.name#">
							where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#">
							<!---and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeID#">--->
							</cfquery>
						<cfelse>
							<cfquery datasource="#arguments.todsn#">
							insert into tcontent (siteID,moduleID,contentID,contentHistID,parentID,type,subType,title,
							display,approved,isNav,active,forceSSL,searchExclude) values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeID#">,
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
						
						<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstpluginscripts">
							select * from tpluginscripts 
							where moduleID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>
						<cfelse>
							<cfset rstpluginscripts = arguments.Bundle.getValue("rstpluginscripts")>
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
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(scriptID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstplugins.moduleID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(scriptfile neq '',de('no'),de('yes'))#" value="#scriptfile#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(runat neq '',de('no'),de('yes'))#" value="#runat#">,
								<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(docache),de(docache),de(0))#">
								
								)
							</cfquery>
						</cfloop>
						
						<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstplugindisplayobjects">
							select * from tplugindisplayobjects 
							where moduleID  =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>
						<cfelse>
							<cfset rstplugindisplayobjects = arguments.Bundle.getValue("rstplugindisplayobjects")>
						</cfif>	
						<cfquery datasource="#arguments.toDSN#">
							delete from tplugindisplayobjects 
							where moduleID  =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>
						<cfloop query="rstplugindisplayobjects">
							<cfquery datasource="#arguments.toDSN#">
								insert into tplugindisplayobjects (objectID,moduleID,name,location,displayObjectFile,displayMethod,docache)
								values
								(
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(objectID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(rstplugins.moduleID)#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(location neq '',de('no'),de('yes'))#" value="#location#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(displayObjectFile neq '',de('no'),de('yes'))#" value="#displayObjectFile#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(displayMethod neq '',de('no'),de('yes'))#" value="#displayMethod#">,
								<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(docache),de(docache),de(0))#">
								
								)
							</cfquery>
						</cfloop>
						
						<cfif not StructKeyExists(arguments,"Bundle")>
						<cfquery datasource="#arguments.fromDSN#" name="rstpluginsettings">
							select * from tpluginsettings 
							where moduleID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keys.get(rstplugins.moduleID)#"/>
						</cfquery>
						<cfelse>
							<cfset rstpluginsettings = arguments.Bundle.getValue("rstpluginsettings")>
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
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
								<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(settingValue neq '',de('no'),de('yes'))#" value="#settingValue#">
								
								)
							</cfquery>
						</cfloop>
					</cfif>
				</cfloop>
			
	</cffunction>
	
	<cffunction name="publish" returntype="void">
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
		<cfset var fileWriter=application.serviceFactory.getBean("fileWriter")>
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
	
	<cffunction name="copy" returntype="void" output="no">
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
			<cfset application.utility.copyDir("#fromWebRoot##fileDelim##fromsiteid##fileDelim#", "#toWebRoot##fileDelim##tositeid##fileDelim#","cache#fileDelim#file") />
		<!---</cfthread>--->
		
		<cfif arguments.fromWebRoot neq arguments.toWebRoot>
			<cfloop query="rsPlugins">
				<!---<cfthread action="run" name="thread2#rsPlugins.currentRow#">--->
					<cfset application.utility.copyDir("#fromWebRoot##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#", "#toWebRoot##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#") />
				<!---</cfthread>--->
			</cfloop>
		</cfif>
		
		<!---<cfif fromWebRoot neq fromFileDir>--->
			<!---<cfthread action="run" name="thread3">--->
				<cfset copySiteFiles("#fromFileDir##fileDelim##fromsiteid##fileDelim#cache#fileDelim#file#fileDelim#", "#toFileDir##fileDelim##tositeid##fileDelim#cache#fileDelim#file#fileDelim#",keys) />
			<!---</cfthread>--->
		<!---</cfif>--->
		
		<cfif arguments.toWebRoot neq arguments.toAssetDir>
			<!---<cfthread action="run" name="thread4">--->
				<cfset application.utility.copyDir("#fromAssetDir##fileDelim##fromsiteid##fileDelim#assets#fileDelim#", "#toAssetDir##fileDelim##tositeid##fileDelim#assets#fileDelim#") />
			<!---</cfthread>--->
		</cfif>
		<!---
		<cfthread action="join" name="thread0" />
		--->		
		<!---<cfthread action="run" name="thread5">--->
			<cfif fromAssetPath neq toAssetPath>
				<cfset application.contentUtility.findAndReplace("#fromAssetPath#/", "#toAssetPath#/", "#toSiteID#")>
			</cfif>
		<!---</cfthread>--->
		
		<!---<cfthread action="run" name="thread6">--->
			<cfif fromSiteID neq toSiteID>
				<cfset application.contentUtility.findAndReplace("/#fromsiteID#/", "/#toSiteID#/", "#toSiteID#")>
			</cfif>
		<!---</cfthread>--->
		
		<cfset application.serviceFactory.getBean("contentUtility").updateGlobalMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
		<cfset application.serviceFactory.getBean("categoryUtility").updateGlobalMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
		
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
		<cfset var rs = "" />
		<cfset var keys=arguments.keyFactory>
		<cfset var newFile="">
		<cfset var newDir="">
		<cfset var fileDelim=application.configBean.getFileDelim()>
		<cfset var fileWriter=application.serviceFactory.getBean("fileWriter")>
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
					<cfset newDir="#replace('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir)##rs.name##fileDelim#">
					<cfif not directoryExists(newDir)>
						<cfset fileWriter.createDir(directory=newDir)>
					</cfif>
					<cfcatch></cfcatch>
				</cftry>
			<cfelse>
				<!--- <cftry> --->

					<cfset fileWriter.copyFile(source="#rs.directory##fileDelim##rs.name#", destination=replace('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir))>

					<cfset newFile=listFirst(rs.name,".")>
					
					<cfif listLen(newFile,"_") gt 1>
						<cfset newFile=keys.get(listFirst(newFile,"_")) & "_" & listLast(newFile,"_") & "." & listLast(rs.name,".")>
					<cfelse>
						<cfset newFile=keys.get(newFile) & "." & listLast(rs.name,".")>	
					</cfif>
					
					<cfset fileWriter.renameFile(source="#replace('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir)##rs.name#", destination="#replace('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir)##newFile#")>
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
	
</cfcomponent>