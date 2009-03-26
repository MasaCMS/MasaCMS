<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="mura.cfobject" output="false">
	<cffunction name="update" returntype="void">
		<cfargument name="find" type="string" default="" required="true">
		<cfargument name="replace" type="string"  default="" required="true">
		
		<cfset var newBody=""/>
		<cfset var newSummary=""/>
	
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rs">
			select contenthistid, body from tcontent where body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.find#%"/>
		</cfquery>
	
		<cfloop query="rs">
			<cfset newbody=replace(BODY,"#arguments.find#","#arguments.replace#","ALL")>
			<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rs">
				update tcontent set body=<cfqueryparam value="#newBody#" cfsqltype="cf_sql_longvarchar" > where contenthistid='#contenthistid#'
			</cfquery>
		</cfloop>
		
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rs">
			select contenthistid, summary from tcontent where summary like '%#arguments.find#%'
		</cfquery>
		
		<cfloop query="rs">
			<cfset newSummary=replace(summary,"#arguments.find#","#arguments.replace#","ALL")>
			<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rs">
				update tcontent set summary=<cfqueryparam value="#newSummary#" cfsqltype="cf_sql_longvarchar" > where contenthistid='#contenthistid#'
			</cfquery>
		</cfloop> 
	</cffunction>
	
	<cffunction name="getToWork" returntype="void">
		<cfargument name="siteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
	
		<cfset var rsContent=""/>
		<cfset var rsContentObjects=""/>
		<cfset var rsContentTags=""/>
		<cfset var rsSystemObjects=""/>
		<cfset var rstpermissions=""/>
		<cfset var rsSettings=""/>
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
		<cfset var rsMailinglist=""/>
		<cfset var rsFiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstusersinterests=""/>
		<cfset var rstclassextenddata=""/>		
			<!--- pushed tables --->
			
			<!--- tcontent --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsContent">
				select * from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/> and active = 1
			</cfquery>
			<cfloop query="rsContent">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontent (Active,Approved,audience,Body,ContentHistID,ContentID,Credits,Display,DisplayStart,DisplayStop,featureStart,featureStop,FileID,Filename,forceSSL,inheritObjects,isFeature,IsLocked,IsNav,keyPoints,lastUpdate,lastUpdateBy,lastUpdateByID,MenuTitle,MetaDesc,MetaKeyWords,moduleAssign,ModuleID,nextN,Notes,OrderNo,ParentID,displayTitle,ReleaseDate,RemoteID,RemotePubDate,RemoteSource,RemoteSourceURL,RemoteURL,responseChart,responseDisplayFields,responseMessage,responseSendTo,Restricted,RestrictGroups,searchExclude,SiteID,sortBy,sortDirection,Summary,Target,TargetParams,Template,Title,Type,subType,Path,tags,doCache)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Active),de(Active),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Approved),de(Approved),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(audience neq '',de('no'),de('yes'))#" value="#audience#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Body neq '',de('no'),de('yes'))#" value="#Body#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ContentHistID neq '',de('no'),de('yes'))#" value="#ContentHistID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ContentID neq '',de('no'),de('yes'))#" value="#ContentID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Credits neq '',de('no'),de('yes'))#" value="#Credits#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Display),de(Display),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(DisplayStart),de('no'),de('yes'))#" value="#DisplayStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(DisplayStop),de('no'),de('yes'))#" value="#DisplayStop#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStart),de('no'),de('yes'))#" value="#featureStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStop),de('no'),de('yes'))#" value="#featureStop#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(FileID neq '',de('no'),de('yes'))#" value="#FileID#">,
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
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ModuleID neq '',de('no'),de('yes'))#" value="#ModuleID#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(nextN),de(nextN),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Notes neq '',de('no'),de('yes'))#" value="#Notes#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ParentID neq '',de('no'),de('yes'))#" value="#ParentID#">,
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
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(SiteID neq '',de('no'),de('yes'))#" value="#SiteID#">,
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
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(doCache),de(doCache),de(0))#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentobjects --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsContentObjects">
				select * from tcontentobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rsContentObjects">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentobjects (ColumnID,ContentHistID,ContentID,Name,Object,ObjectID,OrderNo,SiteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(ColumnID),de(ColumnID),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ContentHistID neq '',de('no'),de('yes'))#" value="#ContentHistID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ContentID neq '',de('no'),de('yes'))#" value="#ContentID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Object neq '',de('no'),de('yes'))#" value="#Object#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ObjectID neq '',de('no'),de('yes'))#" value="#ObjectID#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(SiteID neq '',de('no'),de('yes'))#" value="#SiteID#">
					)
				</cfquery>
			</cfloop>
			
			<!--- tcontenttags --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontenttags where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsContentTags">
				select * from tcontenttags where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rsContentTags">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontenttags (ContentHistID,ContentID,siteID,tag)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ContentHistID neq '',de('no'),de('yes'))#" value="#ContentHistID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ContentID neq '',de('no'),de('yes'))#" value="#ContentID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(tag neq '',de('no'),de('yes'))#" value="#tag#">
					)
				</cfquery>
			</cfloop>
			
			<!--- tsystemobjects--->
			<cfquery datasource="#arguments.toDSN#">
				delete from tsystemobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsSystemObjects">
				select * from tsystemobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rsSystemObjects">
				<cfquery datasource="#arguments.toDSN#">
					insert into tsystemobjects (Name,Object,OrderNo,SiteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Object neq '',de('no'),de('yes'))#" value="#Object#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(SiteID neq '',de('no'),de('yes'))#" value="#SiteID#">
					)
				</cfquery>
			</cfloop>
			
			<!--- tpermissions--->
			<cfquery datasource="#arguments.toDSN#">
				delete from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsTPermissions">
				select * from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rsTPermissions">
				<cfquery datasource="#arguments.toDSN#">
					insert into tpermissions (contentID,groupID,Type,SiteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentID neq '',de('no'),de('yes'))#" value="#contentID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(groupID neq '',de('no'),de('yes'))#" value="#groupID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(SiteID neq '',de('no'),de('yes'))#" value="#SiteID#">
					)
				</cfquery>
			</cfloop>
			
			<!--- tadcampaigns --->
			<cfquery datasource="#arguments.fromDSN#" name="rsSettings">
				select advertiserUserPoolID from tsettings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.toDSN#">
				delete from tadcampaigns
				where userID in 
				(select userID from tusers where
				siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
				siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstadcampaigns">
				select * from tadcampaigns
				where userID in 
				(select userID from tusers where
				siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
				siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
			</cfquery>
			<cfloop query="rstadcampaigns">
				<cfquery datasource="#arguments.toDSN#">
					insert into tadcampaigns (campaignID,dateCreated,endDate,isActive,lastUpdate,lastUpdateBy,name,notes,startDate,userID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(campaignID neq '',de('no'),de('yes'))#" value="#campaignID#">,
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
			</cfloop>
			<!--- tadcreatives --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tadcreatives 
				where userID in 
				(select userID from tusers where
				siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
				siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstadcreatives">
				select * from tadcreatives
				where userID in 
				(select userID from tusers where
				siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
				siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
			</cfquery>
			<cfloop query="rstadcreatives">
				<cfquery datasource="#arguments.toDSN#">
					insert into tadcreatives (altText,creativeID,creativeType,dateCreated,fileID,height,isActive,lastUpdate,lastUpdateBy,mediaType,name,notes,redirectURL,textBody,userID,width,target)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(altText neq '',de('no'),de('yes'))#" value="#altText#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeID neq '',de('no'),de('yes'))#" value="#creativeID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeType neq '',de('no'),de('yes'))#" value="#creativeType#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileID neq '',de('no'),de('yes'))#" value="#fileID#">,
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
			</cfloop>
			<!--- tadipwhitelist --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tadipwhitelist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstadipwhitelist">
				select * from tadipwhitelist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rstadipwhitelist">
				<cfquery datasource="#arguments.toDSN#">
					insert into tadipwhitelist (IP,siteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(IP neq '',de('no'),de('yes'))#" value="#IP#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">
					)
				</cfquery>
			</cfloop>
			<!--- tadzones --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstadzones">
				select * from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rstadzones">
				<cfquery datasource="#arguments.toDSN#">
					insert into tadzones (adZoneID,creativeType,dateCreated,height,isActive,lastUpdate,lastUpdateBy,name,notes,siteID,width)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(adZoneID neq '',de('no'),de('yes'))#" value="#adZoneID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeType neq '',de('no'),de('yes'))#" value="#creativeType#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(height),de(height),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(width),de(width),de(0))#">
					)
				</cfquery>
			</cfloop>
			<!--- tadplacements --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstadplacements">
				select * from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfloop query="rstadplacements">
				<cfquery datasource="#arguments.toDSN#">
					insert into tadplacements (adZoneID,billable,budget,campaignID,costPerClick,costPerImp,creativeID,dateCreated,endDate,isActive,isExclusive,lastUpdate,lastUpdateBy,notes,placementID,startDate)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(adZoneID neq '',de('no'),de('yes'))#" value="#adZoneID#">,
					<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(billable),de(billable),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(budget),de(budget),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(campaignID neq '',de('no'),de('yes'))#" value="#campaignID#">,
					<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(costPerClick),de(costPerClick),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(costPerImp),de(costPerImp),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeID neq '',de('no'),de('yes'))#" value="#creativeID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(endDate),de('no'),de('yes'))#" value="#endDate#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isExclusive),de(isExclusive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(placementID neq '',de('no'),de('yes'))#" value="#placementID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(startDate),de('no'),de('yes'))#" value="#startDate#">
					)
				</cfquery>
			</cfloop>
			<!--- tadplacementdetails --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tadplacementdetails where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>))
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstadplacementdetails">
				select * from tadplacementdetails where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>))
			</cfquery>
			<cfloop query="rstadplacementdetails">
				<cfquery datasource="#arguments.toDSN#">
					insert into tadplacementdetails (placementID, placementType, placementValue)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(placementID neq '',de('no'),de('yes'))#" value="#placementID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(placementType neq '',de('no'),de('yes'))#" value="#placementType#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(placementValue),de(placementValue),de(0))#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentcategoryassign --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcategoryassign where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentcategoryassign">
				select * from tcontentcategoryassign where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rstcontentcategoryassign">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentcategoryassign (categoryID,contentHistID,contentID,featureStart,featureStop,isFeature,orderno,siteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(categoryID neq '',de('no'),de('yes'))#" value="#categoryID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentHistID neq '',de('no'),de('yes'))#" value="#contentHistID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentID neq '',de('no'),de('yes'))#" value="#contentID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStart),de('no'),de('yes'))#" value="#featureStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStop),de('no'),de('yes'))#" value="#featureStop#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isFeature),de(isFeature),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(orderno),de(orderno),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentfeeds --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentfeeds">
				select * from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rstcontentfeeds">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeeds (allowHTML,channelLink,dateCreated,description,feedID,isActive,isDefault,isFeaturesOnly,isPublic,lang,lastUpdate,lastUpdateBy,maxItems,name,parentID,restricted,restrictGroups,siteID,Type,version,sortBy,sortDirection,nextN,displayName,displayRatings,displayComments,altname)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(allowHTML),de(allowHTML),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(channelLink neq '',de('no'),de('yes'))#" value="#channelLink#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(description neq '',de('no'),de('yes'))#" value="#description#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(feedID neq '',de('no'),de('yes'))#" value="#feedID#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isDefault),de(isDefault),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isFeaturesOnly),de(isFeaturesOnly),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isPublic),de(isPublic),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lang neq '',de('no'),de('yes'))#" value="#lang#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(maxItems),de(maxItems),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#parentID#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(restricted),de(restricted),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(restrictGroups neq '',de('no'),de('yes'))#" value="#restrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Type neq '',de('no'),de('yes'))#" value="#Type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(version neq '',de('no'),de('yes'))#" value="#version#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortBy neq '',de('no'),de('yes'))#" value="#sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortDirection neq '',de('no'),de('yes'))#" value="#sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(nextN),de(nextN),de(20))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayName),de(displayName),de(1))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayRatings),de(displayRatings),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayComments),de(displayComments),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(altname neq '',de('no'),de('yes'))#" value="#altname#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentfeeditems --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeeditems where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentFeedItems">
				select * from tcontentfeeditems where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfloop query="rstcontentFeedItems">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeeditems (feedID,itemID,type)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(feedID neq '',de('no'),de('yes'))#" value="#feedID#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(itemID neq '',de('no'),de('yes'))#" value="#itemID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">
					)
				</cfquery>
			</cfloop>

			<!--- tcontentfeedadvancedparams --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeedadvancedparams where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentFeedAdvancedParams">
				select * from tcontentfeedadvancedparams where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfloop query="rstcontentFeedAdvancedParams">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeedadvancedparams (paramID,feedID,param,relationship,field,dataType,<cfif application.configBean.getDbType() eq "mysql">`condition`<cfelse>condition</cfif>,criteria)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(paramID neq '',de('no'),de('yes'))#" value="#paramID#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(feedID neq '',de('no'),de('yes'))#" value="#feedID#">,
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
				delete from tcontentrelated where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentrelated">
				select * from tcontentrelated where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rstcontentrelated">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentrelated (contentHistID,contentID,relatedID,siteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentHistID neq '',de('no'),de('yes'))#" value="#contentHistID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentID neq '',de('no'),de('yes'))#" value="#contentID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(relatedID neq '',de('no'),de('yes'))#" value="#relatedID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">
					)
				</cfquery>
			</cfloop>
			<!--- tmailinglist --->
			<cfquery datasource="#arguments.toDSN#" name="rsMailingList">
				delete from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsMailingList">
				select * from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rsMailingList">
				<cfquery datasource="#arguments.toDSN#">
					insert into tmailinglist (Description,isPublic,isPurge,LastUpdate,MLID,Name,SiteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Description neq '',de('no'),de('yes'))#" value="#Description#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isPublic),de(isPublic),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isPurge),de(isPurge),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(LastUpdate),de('no'),de('yes'))#" value="#LastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(MLID neq '',de('no'),de('yes'))#" value="#MLID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(SiteID neq '',de('no'),de('yes'))#" value="#SiteID#">
					)
				</cfquery>
			</cfloop>
			<!--- tfiles --->
			<cfquery datasource="#arguments.toDSN#" name="rsFiles">
				delete from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsFiles">
				select * from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rsFiles">
				<cfquery datasource="#arguments.toDSN#">
					insert into tfiles (contentID,contentSubType,contentType,fileExt,fileID,filename,fileSize,image,imageMedium,imageSmall,moduleID,siteID,created)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentID neq '',de('no'),de('yes'))#" value="#contentID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentSubType neq '',de('no'),de('yes'))#" value="#contentSubType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentType neq '',de('no'),de('yes'))#" value="#contentType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileExt neq '',de('no'),de('yes'))#" value="#fileExt#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileID neq '',de('no'),de('yes'))#" value="#fileID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(filename neq '',de('no'),de('yes'))#" value="#filename#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(fileSize),de(fileSize),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(image) eq '',de('yes'),de('no'))#" value="#image#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(imageMedium) eq '',de('yes'),de('no'))#" value="#imageMedium#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(imageSmall) eq '',de('yes'),de('no'))#" value="#imageSmall#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(moduleID neq '',de('no'),de('yes'))#" value="#moduleID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(created),de('no'),de('yes'))#" value="#created#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentcategories --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentcategories">
				select * from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rstcontentcategories">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentcategories (categoryID,dateCreated,isActive,isInterestGroup,isOpen,lastUpdate,lastUpdateBy,name,notes,parentID,restrictGroups,siteID,sortBy,sortDirection,Path)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(categoryID neq '',de('no'),de('yes'))#" value="#categoryID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isInterestGroup),de(isInterestGroup),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isOpen),de(isOpen),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#parentID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(restrictGroups neq '',de('no'),de('yes'))#" value="#restrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortBy neq '',de('no'),de('yes'))#" value="#sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortDirection neq '',de('no'),de('yes'))#" value="#sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Path neq '',de('no'),de('yes'))#" value="#Path#">
					)
				</cfquery>
			</cfloop>
			
			<!--- synced tables--->
			
			<!--- tcontentcomments --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcomments where commentid not in (select commentid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfquery datasource="#arguments.toDSN#" name="rstcontentcomments">
				select * from tcontentcomments where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#">
				delete from tcontentcomments where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rstcontentcomments">
				<cfquery datasource="#arguments.fromDSN#">
					insert into tcontentcomments (comments,commentid,contenthistid,contentid,email,entered,ip,isApproved,name,siteid,url,subscribe)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(comments neq '',de('no'),de('yes'))#" value="#comments#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(commentid neq '',de('no'),de('yes'))#" value="#commentid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contenthistid neq '',de('no'),de('yes'))#" value="#contenthistid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentid neq '',de('no'),de('yes'))#" value="#contentid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(email neq '',de('no'),de('yes'))#" value="#email#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(entered),de('no'),de('yes'))#" value="#entered#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ip neq '',de('no'),de('yes'))#" value="#ip#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isApproved),de(isApproved),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteid neq '',de('no'),de('yes'))#" value="#siteid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(url neq '',de('no'),de('yes'))#" value="#url#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(subscribe),de(subscribe),de(0))#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentratings --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentratings where contentid not in (select contentid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfquery datasource="#arguments.toDSN#" name="rstcontentRatings">
				select * from tcontentratings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#">
				delete from tcontentratings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			</cfquery>
			<cfloop query="rstcontentRatings">
				<cfquery datasource="#arguments.fromDSN#">
					insert into tcontentratings (contentID,rate,siteID,userID,entered)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(contentID neq '',de('no'),de('yes'))#" value="#contentID#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rate),de(rate),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#userID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(entered),de('no'),de('yes'))#" value="#entered#">
					)
				</cfquery>
			</cfloop>

			<!--- tusersinterests --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tusersinterests where categoryid not in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfquery datasource="#arguments.toDSN#" name="rstusersinterests">
				select * from tusersinterests where categoryid in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#">
				delete from tusersinterests where categoryid in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfloop query="rstusersinterests">
				<cfquery datasource="#arguments.fromDSN#">
					insert into tusersinterests (categoryID,userID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(categoryID neq '',de('no'),de('yes'))#" value="#categoryID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#userID#">
					)
				</cfquery>
			</cfloop>
			
				<!--- tclassextenddata --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tclassextenddata 
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstclassextenddata">
				select * from tclassextenddata where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
				and baseID  in (select contenthistid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>)
			</cfquery>
			<cfloop query="rstclassextenddata">
				<cfquery datasource="#arguments.toDSN#">
					insert into tclassextenddata (baseID,attributeID,attributeValue,siteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(baseID neq '',de('no'),de('yes'))#" value="#baseID#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(attributeID),de(attributeID),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(attributeValue neq '',de('no'),de('yes'))#" value="#attributeValue#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(siteID neq '',de('no'),de('yes'))#" value="#siteID#">
					)
				</cfquery>
			</cfloop>
		
	</cffunction>
	
	<cffunction name="publish" returntype="void">
		<cfargument name="siteid" required="yes" default="">

		<cfset var i=""/>
		<cfset var j=""/>
		<cfset var k=""/>
		<cfset var fileDelim=application.configBean.getFileDelim() />

		<cfloop list="#application.configBean.getProductionDatasource()#" index="i">
			<cfset getToWork(arguments.siteid, '#application.configBean.getDatasource()#', '#i#')>
		</cfloop>
		
		<cfloop list="#application.configBean.getProductionWebroot()#" index="j">
			<cfset application.utility.copyDir("#application.configBean.getWebRoot()##fileDelim##arguments.siteid##fileDelim#", "#j##fileDelim##arguments.siteid##fileDelim#") />
		</cfloop>
		
		<cfloop list="#application.configBean.getProductionFiledir()#" index="k">
			<cfset application.utility.copyDir("#application.configBean.getFiledir()##fileDelim##arguments.siteid##fileDelim#", "#k##fileDelim##arguments.siteid##fileDelim#") />
		</cfloop>
		
		<cfset update("#application.configBean.getAssetPath()#","#application.configBean.getProductionAssetPath()#") >
		
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			update tsettings set lastDeployment = #now()#
		</cfquery>
		
		<cfloop list="#application.configBean.getProductionDatasource()#" index="i">
			<cfquery datasource="#i#">
				update tsettings set lastDeployment = #now()#
			</cfquery>
			<cfquery datasource="#i#">
				update tglobals set appreload = #now()#
			</cfquery>
		</cfloop>

	</cffunction>
	
	<cffunction name="init" returntype="any">
		<cfreturn this />
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

</cfcomponent>