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
<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>

<cfset variables.configBean=arguments.configBean />
<cfset variables.settingsManager=arguments.settingsManager />

<cfif variables.configBean.getDbType() eq "MSSQL">
	<cfset variables.tableModifier="with (nolock)">
<cfelse>
	<cfset variables.tableModifier="">
</cfif>

<cfreturn this />
</cffunction>

<cffunction name="getSessionHistory" access="public" returntype="query">
	<cfargument name="urlToken" type="string" default="">
	<cfargument name="siteID" type="string" default="">
	
	<cfset var rs = ""/>
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select  fname,lname,company,tsessiontracking.*, tcontent.menuTitle,tfiles.fileEXT,
	tcontent.Type, tcontent.filename,tcontent.targetParams
	from tsessiontracking #variables.tableModifier#
	inner join tcontent  #variables.tableModifier# on
	(tsessiontracking.contentid=tcontent.contentid and tsessiontracking.siteid=tcontent.siteid)
	left join tusers #variables.tableModifier# on (tsessiontracking.userid = tusers.userid)
	left join tfiles #variables.tableModifier# on (tcontent.fileid=tfiles.fileid)
	where urlToken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.urlToken#">
	and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	and tcontent.active=1
	order by entered desc
	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="getTopContent" access="public" returntype="query">
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="10">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	<cfargument name="excludeHome" type="boolean" required="true" default="false">
	
	<cfset var rs = ""/>
	<cfset var start ="">
	<cfset var stop ="">
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	<cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	select  <cfif dbType eq "mssql" and arguments.limit>Top #arguments.limit#</cfif> count(tsessiontracking.contentid) Hits, tsessiontracking.contentid,
	tcontent.type,tcontent.moduleID,tcontent.ContentHistID,tcontent.siteID,tcontent.filename,
	tcontent.menuTitle,tcontent.LastUpdate, tcontent.parentID,tcontent.targetParams ,tfiles.fileEXT  
    from tsessiontracking #variables.tableModifier#
	inner join tcontent #variables.tableModifier# on (tsessiontracking.contentid=tcontent.contentid and tsessiontracking.siteid=tcontent.siteid)
	left join tfiles #variables.tableModifier# on (tcontent.fileid=tfiles.fileid)
	where tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	and tcontent.active=1
	
	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),0,0,0)#">
		<cfcatch>
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),23,59,0)#">
		<cfcatch>
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif arguments.membersOnly>
	and tsessiontracking.userID is not null
	</cfif>
	
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	
	<cfif arguments.excludeHome>
	and tcontent.ContentID <>'00000000000000000000000000000000001'
	</cfif>
	
	Group By tsessiontracking.contentID,
	tcontent.type,tcontent.moduleID,tcontent.ContentHistID,tcontent.type,tcontent.siteID,tcontent.filename,
	tcontent.menuTitle,tcontent.LastUpdate,tcontent.parentID ,tcontent.targetParams,tfiles.fileEXT  
	order by hits desc
	
	<cfif dbType eq "mysql" and arguments.limit>limit #arguments.limit#</cfif>
	<cfif dbType eq "oracle" and arguments.limit>)  where ROWNUM <=#arguments.limit#</cfif>
	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="isUserOnLine" access="public" returntype="numeric">
	<cfargument name="userID" type="string" required="true" default="">
	
	<cfset var rs = ""/>
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select count(userID) as isOnLine
    from tsessiontracking #variables.tableModifier#
	where 
	entered >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd("n",-15,now())#">
	and userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	</cfquery>
	
	<cfreturn rs.isOnLine />

</cffunction>

<cffunction name="getSiteSessions" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="contentID" type="string" required="yes" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="span" type="numeric" required="true" default="15">
	<cfargument name="spanType" type="string" required="true" default="n">
	
	<cfset var rs = ""/>
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select distinct fname,lname,company,urlToken,max(entered)
	LastRequest,min(entered)
	firstRequest, count(urlToken) as views,
	tsessiontracking.country,tsessiontracking.lang,tsessiontracking.locale,
	tsessiontracking.userid,tsessiontracking.siteid,tsessiontracking.user_agent
	from tsessiontracking #variables.tableModifier#
	left join tusers #variables.tableModifier# on (tsessiontracking.userid = tusers.userid)
	where
	entered >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd(arguments.spanType,-arguments.span,now())#">
	<cfif arguments.siteID neq ''>
	and tsessiontracking.siteID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.membersOnly>
	and tsessiontracking.userID is not null
	</cfif>
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	<cfif arguments.contentID neq ''>
	and tsessiontracking.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	</cfif>
	and (
	tsessiontracking.userid is not null
	or
	
	tsessiontracking.userid is null and 
	urlToken not in (
		select distinct urlToken from tsessiontracking where siteid='#arguments.siteid#' 
		and userid is not null
	)
	
	
	)
	group by fname,lname,company,urlToken,tsessiontracking.country,tsessiontracking.lang,tsessiontracking.locale,
	tsessiontracking.userid,tsessiontracking.siteid,tsessiontracking.user_agent	
	order by LastRequest desc
	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="getSiteSessionCount" access="public" returntype="numeric" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="span" type="numeric" required="true" default="15">
	<cfargument name="spanType" type="string" required="true" default="n">
	
	<cfset var rs = ""/>
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" >
	select count(distinct urlToken) as sessions 
	from tsessiontracking #variables.tableModifier#
	<!---
	left join tcontent on (tsessiontracking.contentid=tcontent.contentID
							and tsessiontracking.siteid=tcontent.siteID
							and tcontent.active=1)
	--->
	where 
	entered >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd(arguments.spanType,-arguments.span,now())#">
	<cfif arguments.siteID neq ''>
	and tsessiontracking.siteID = 
		<!---
			Tried to conditionally use cachedwithin but it throws errors on some compilers when used with cfqueryparam
			<cfif server.coldfusion.productname eq "ColdFusion Server" and listFirst(server.coldfusion.productversion) lt 8>
			'#arguments.siteID#'
		<cfelse>
		--->
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
		<!---</cfif>--->
	</cfif>
	<cfif arguments.membersOnly>
	and tsessiontracking.userID is not null
	</cfif>
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	</cfquery>
	
	
	<cfreturn rs.sessions />


</cffunction>

<cffunction name="getTopKeywords" access="public" returntype="query">
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="10">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs = ""/>
	<cfset var start ="">
	<cfset var stop ="">
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	<cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	select  <cfif dbType eq "mssql" and arguments.limit>Top #arguments.limit#</cfif> count(tsessiontracking.keywords) keywordCount, tsessiontracking.keywords from tsessiontracking #variables.tableModifier#
	where tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	
	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),0,0,0)#">
		<cfcatch>
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),23,59,0)#">
		<cfcatch>
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif arguments.siteID neq ''>
	and tsessiontracking.siteID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.membersOnly>
	and tsessiontracking.userID is not null
	</cfif>
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	and keywords is not null
	Group By tsessiontracking.keywords
	order by keywordCount desc
	
	<cfif dbType eq "mysql" and arguments.limit>limit #arguments.limit#</cfif>
	<cfif dbType eq "oracle" and arguments.limit>) where ROWNUM <=#arguments.limit#</cfif>
	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="getTotalKeywords" access="public" returntype="query">
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs = ""/>
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select count(tsessiontracking.keywords) keywordCount from tsessiontracking #variables.tableModifier#
	where tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	<cfif isdate(arguments.stopDate)>and entered <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and entered >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>

	<cfif arguments.siteID neq ''>
	and tsessiontracking.siteID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.membersOnly>
	and tsessiontracking.userID is not null
	</cfif>
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	and keywords is not null
	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="getTopReferers" access="public" returntype="query">
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="10">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs = ""/>
	<cfset var start ="">
	<cfset var stop ="">
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	<cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	select  <cfif dbType eq "mssql" and arguments.limit>Top #arguments.limit#</cfif> count(tsessiontracking.referer) referals, tsessiontracking.referer from tsessiontracking #variables.tableModifier#
	inner join tcontent on (tsessiontracking.contentid=tcontent.contentid and tsessiontracking.siteid=tcontent.siteid)
	where tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	and tcontent.active=1
	
	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),0,0,0)#">
		<cfcatch>
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),23,59,0)#">
		<cfcatch>
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#">
		</cfcatch>
		</cftry>
	</cfif>

	and tsessiontracking.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	
	and tsessiontracking.referer <>'Internal'
	
	Group By tsessiontracking.referer
	order by referals desc
	
	<cfif dbType eq "mysql" and arguments.limit>limit #arguments.limit#</cfif>
	<cfif dbType eq "oracle" and arguments.limit>) where ROWNUM <=#arguments.limit#</cfif>
	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="getTotalReferers" access="public" returntype="query">
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs = ""/>
	<cfset var start ="">
	<cfset var stop ="">
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select  count(tsessiontracking.referer) referals from tsessiontracking #variables.tableModifier#
	where tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	
	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),0,0,0)#">
		<cfcatch>
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),23,59,0)#">
		<cfcatch>
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#">
		</cfcatch>
		</cftry>
	</cfif>

	and tsessiontracking.siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	
	and tsessiontracking.referer <> 'Internal'
		

	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="getTotalHits" access="public" returntype="query">
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs = ""/>
	<cfset var start ="">
	<cfset var stop ="">
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select count(*) hits from tsessiontracking #variables.tableModifier#
	inner join tcontent on (tsessiontracking.contentID=tcontent.contentID)
	where tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	and tcontent.active=1

	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),0,0,0)#">
		<cfcatch>
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),23,59,0)#">
		<cfcatch>
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif arguments.siteID neq ''>
	and tsessiontracking.siteID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.membersOnly>
	and tsessiontracking.userID is not null
	</cfif>
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	
	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="getTotalSessions" access="public" returntype="query">
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs = ""/>
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select count(distinct urlToken) sessionCount	
	from tsessiontracking  #variables.tableModifier#
	where tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	<cfif isdate(arguments.stopDate)>and entered <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and entered >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>

	<cfif arguments.siteID neq ''>
	and tsessiontracking.siteID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.membersOnly>
	and tsessiontracking.userID is not null
	</cfif>
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	
	</cfquery>
	
	<cfreturn rs />

</cffunction>

<cffunction name="getSessionSearch" access="public" returntype="query">
	<cfargument name="params" type="array" required="true" >
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="String" required="true" default="All">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var i = 1 />
	<cfset var paramLen=arrayLen(arguments.params)  />
	<cfset var param= "" />
	<cfset var paramNum= 0 />
	<cfset var started=false />
	<cfset var searchAddresses=false />
	<cfset var paramArray =arrayNew(1) />
	<cfset var rs1= ""/>
	<cfset var rs2= ""/>
	<cfset var onlyMembers=arguments.membersOnly/>
	<cfset var searchAddress=false />
	<cfset var searchUsers=false/>
	<cfset var searchContent=false/>
	<cfset var start= ""/>
	<cfset var stop= ""/>
	<cfif paramLen>
		<cfloop from="1" to="#paramLen#" index="i">
		 		<cfset param=createObject("component","mura.queryParam").init(
		 					arguments.params[i].Relationship,
		 					listFirst(arguments.params[i].Field,'^'),
		 					listLast(arguments.params[i].Field,'^'),
		 					arguments.params[i].Condition,
		 					arguments.params[i].Criteria
		 					) />
		 	
		 	<cfif param.getIsValid()>
		 		<cfset arrayAppend(paramArray,param)/>	
		 		<cfif listFind("tuseraddresses,tusers",listFirst(param.getField(),"."))>
					<cfset onlyMembers=true/>
					<cfif listFirst(param.getField(),".") eq "tuseraddresses">
						<cfset searchAddress=true />
					</cfif>
				</cfif>
				<!--- <cfif listFirst(param.getField(),'.') eq 'tuseraddresses'>
					<cfset searchAddresses = true />
				<cfelseif listFirst(param.getField(),'.') eq 'tusers'>
					<cfset searchUsers = true />
				<cfelseif listFirst(param.getField(),'.') eq 'tcontent'>
					<cfset searchContent = true />
				</cfif> --->
			</cfif>
		</cfloop>
	</cfif>
	
	<cfquery name="rs1" datasource="#variables.configBean.getReadOnlyDatasource()#" timeout="120" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	<cfif not onlyMembers>
	select '' as fname,'' as lname,'' as company,tsessiontracking.urlToken, max(entered) AS LastRequest,
	 min(entered) AS FirstRequest,
	count(tsessiontracking.urlToken) as views,
	tsessiontracking.country, tsessiontracking.lang,tsessiontracking.locale,
	tsessiontracking.userid, tsessiontracking.siteid,tsessiontracking.user_agent
	From tsessiontracking #variables.tableModifier#
	inner join tcontent #variables.tableModifier# on (tsessiontracking.contentid=tcontent.contentID
							and tsessiontracking.siteid=tcontent.siteID
							and tcontent.active=1)
	
	 
	where 
	tsessiontracking.userID is null
	
	and tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	
	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),0,0,0)#">
		<cfcatch>
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),23,59,0)#">
		<cfcatch>
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	
	<cfif arrayLen(paramArray)>
		<cfloop from="1" to="#arrayLen(paramArray)#" index="i">
				<cfset param=paramArray[i] />
		 		<cfif not started ><cfset started = true />and (<cfelse>#param.getRelationship()#</cfif>			
		 		#param.getField()# #param.getCondition()# <cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#">  	
		</cfloop>
		<cfif started>)</cfif>
	<!--- <cfelse> 
		and 0=1 --->
	</cfif>


	group by tsessiontracking.urlToken, 		
	tsessiontracking.country,tsessiontracking.lang,tsessiontracking.locale,
	tsessiontracking.userid,tsessiontracking.siteid,tsessiontracking.user_agent 
	
	Union
	
	</cfif>
	select fname,lname,company,tsessiontracking.urlToken, max(entered) AS LastRequest,
	 min(entered) AS FirstRequest,
	count(tsessiontracking.urlToken) as views,
	tsessiontracking.country, tsessiontracking.lang,tsessiontracking.locale,
	tsessiontracking.userid, tsessiontracking.siteid,tsessiontracking.user_agent
	From tsessiontracking #variables.tableModifier#
	inner join tusers #variables.tableModifier# on (tsessiontracking.userid=tusers.userID)
	<cfif searchAddress>
	inner join tuseraddresses #variables.tableModifier# on (tsessiontracking.userid=tuseraddresses.userID)
	</cfif>
	
	inner join tcontent #variables.tableModifier# on (tsessiontracking.contentid=tcontent.contentID
							and tsessiontracking.siteid=tcontent.siteID
							and tcontent.active=1)
		 
	where 
	
	tsessiontracking.userID is not null
	
	and tsessiontracking.siteid=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
	
	<cfif lsIsDate(arguments.startDate)>
		<cftry>
		<cfset start=lsParseDateTime(arguments.startDate) />
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(start),month(start),day(start),0,0,0)#">
		<cfcatch>
		and entered >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfif lsIsDate(arguments.stopDate)>
		<cftry>
		<cfset stop=lsParseDateTime(arguments.stopDate) />
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(stop),month(stop),day(stop),23,59,0)#">
		<cfcatch>
		and entered <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdatetime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#">
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfswitch expression="#arguments.visitorStatus#">
	<cfcase value="Return">
	and tsessiontracking.urlToken <> tsessiontracking.originalUrlToken
	</cfcase>
	<cfcase value="New">
	and tsessiontracking.urlToken = tsessiontracking.originalUrlToken
	</cfcase>
	</cfswitch>
	
	<cfset started = false />
	<cfif arrayLen(paramArray)>
		<cfloop from="1" to="#arrayLen(paramArray)#" index="i">
				<cfset param=paramArray[i] />
		 		<cfif not started ><cfset started = true />and (<cfelse>#param.getRelationship()#</cfif>			
		 		#param.getField()# #param.getCondition()# <cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#">  	
		</cfloop>
		<cfif started>)</cfif>
	<!--- <cfelse> 
		and 0=1 --->
	</cfif>
		

	group by fname,lname,company,tsessiontracking.urlToken, 		
	tsessiontracking.country,tsessiontracking.lang,tsessiontracking.locale,
	tsessiontracking.userid,tsessiontracking.siteid,tsessiontracking.user_agent 
	</cfquery>

	<cfquery name="rs2" dbtype="query">
	select fname,lname,company,urlToken, LastRequest,
	FirstRequest,views,
	country, lang, locale,
	userid, siteid,user_agent
	from rs1
	order by LastRequest desc
	</cfquery>

	<cfreturn rs2 />

</cffunction>


</cfcomponent>