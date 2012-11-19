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

<cfsavecontent variable="variables.fieldlist"><cfoutput>tcontent.Active,tcontent.Approved,tcontent.audience,tcontent.Body,tcontent.ContentHistID,
tcontent.ContentID,tcontent.Credits,tcontent.Display,tcontent.DisplayStart,tcontent.DisplayStop,tcontent.featureStart,
tcontent.featureStop,tcontent.FileID,tcontent.Filename,tcontent.forceSSL,tcontent.inheritObjects,tcontent.isFeature,
tcontent.IsLocked,tcontent.IsNav,tcontent.keyPoints,tcontent.lastUpdate,tcontent.lastUpdateBy,tcontent.lastUpdateByID,
tcontent.MenuTitle,tcontent.MetaDesc,tcontent.MetaKeyWords,tcontent.moduleAssign,tcontent.ModuleID,tcontent.nextN,
tcontent.Notes,tcontent.OrderNo,tcontent.ParentID,tcontent.displayTitle,tcontent.ReleaseDate,tcontent.RemoteID,
tcontent.RemotePubDate,tcontent.RemoteSource,tcontent.RemoteSourceURL,tcontent.RemoteURL,tcontent.responseChart,
tcontent.responseDisplayFields,tcontent.responseMessage,tcontent.responseSendTo,tcontent.Restricted,tcontent.RestrictGroups,
tcontent.searchExclude,tcontent.SiteID,tcontent.sortBy,tcontent.sortDirection,tcontent.Summary,tcontent.Target,
tcontent.TargetParams,tcontent.Template,tcontent.Title,tcontent.Type,tcontent.subType,tcontent.Path,tcontent.tags,
tcontent.doCache,tcontent.created,tcontent.urltitle,tcontent.htmltitle,tcontent.mobileExclude,tcontent.changesetID,
tcontent.imageSize,tcontent.imageHeight,tcontent.imageWidth,tcontent.childTemplate,tcontent.majorVersion,tcontent.minorVersion,tcontent.expires,tcontent.displayInterval,tcontent.sourceID
</cfoutput></cfsavecontent>

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.utility=arguments.utility>
<cfreturn this />
</cffunction>

<cffunction name="readVersion" access="public" returntype="any" output="false">
		<cfargument name="contentHistID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfargument name="contentBean" required="true" default="">
		<cfargument name="sourceIterator" required="true" default="">
		<cfset var rsContent = queryNew('empty') />
		<cfset var bean=arguments.contentBean />
		<cfset var rsPage="">
		<cfif not isObject(bean)>
			<cfset bean=getBean("content")>
		</cfif>

		<cfif isObject(arguments.sourceIterator) and (
					arguments.sourceIterator.getNextN() lte 2000 
					or (
						not arguments.sourceIterator.getNextN()
						and arguments.sourceIterator.getRecordCount() lte 2000
						)
				)>
			<cfif not isQuery(arguments.sourceIterator.getPageQuery("page#arguments.sourceIterator.getPageIndex()#"))>
				<cfquery name="rsPage" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
					select #variables.fieldlist#, tfiles.fileSize, 
					tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename
					 from tcontent 
					left join tfiles on (tcontent.fileid=tfiles.fileid)
					where 
					tcontent.contenthistid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.sourceIterator.getPageIDList()#">)
					and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
				</cfquery>

				<cfset arguments.sourceIterator.setPageQuery("page#arguments.sourceIterator.getPageIndex()#",rsPage)>

			</cfif>

			<cfset rsPage=arguments.sourceIterator.getPageQuery("page#arguments.sourceIterator.getPageIndex()#")>

			<cfquery name="rsContent" dbtype="query">
				select * from rsPage where contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistid#" />
			</cfquery>

		<cfelse>
			<cfif len(arguments.contentHistID)>	
				<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsContent"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
					select #variables.fieldlist#, tfiles.fileSize, 
					tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename
					from tcontent 
					left join tfiles on (tcontent.fileid=tfiles.fileid)
					where tcontent.contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#" /> 
					and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
				</cfquery>
			</cfif>
		</cfif>
		
		<cfif rsContent.recordCount>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset bean.setPreserveID(rsContent.contentHistID) />
		<cfelseif arguments.use404>
			<cfset bean.setType("Page") />
			<cfset bean.setSubType("Default") />
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setBody('The requested version of this content could not be found.')/>
			<cfset bean.setTitle('404')/>
			<cfset bean.setMenuTitle('404')/>
			<cfset bean.setFilename('404') />
			<cfset bean.setParentID('00000000000000000000000000000000END') />
			<cfset bean.setcontentID('00000000000000000000000000000000001') />
			<cfset bean.setPath('00000000000000000000000000000000001') />
			<cfset bean.setSiteID(arguments.siteID) />
			<cfset bean.setDisplay(1) />
			<cfset bean.setApproved(1) />
		<cfelse>
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setSiteID(arguments.siteid) />
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="readActive" access="public" returntype="any" output="false">
		<cfargument name="contentID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfargument name="contentBean" required="true" default="">
		<cfargument name="sourceIterator" required="true" default="">
		<cfset var rsContent = queryNew('empty') />
		<cfset var bean=arguments.contentBean />
		<cfset var rsPage="">
		
		<cfif not isObject(bean)>
			<cfset bean=getBean("content")>
		</cfif>
		
		<cfif isObject(arguments.sourceIterator) and (
					arguments.sourceIterator.getNextN() lte 2000 
					or (
						not arguments.sourceIterator.getNextN()
						and arguments.sourceIterator.getRecordCount() lte 2000
						)
				)>
			<cfif not isQuery(arguments.sourceIterator.getPageQuery("page#arguments.sourceIterator.getPageIndex()#"))>
				<cfquery name="rsPage" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
					select #variables.fieldlist#, tfiles.fileSize,
					tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename
					from tcontent 
					left join tfiles on (tcontent.fileid=tfiles.fileid)
					where 
					tcontent.#arguments.sourceIterator.getRecordIdField()# in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.sourceIterator.getPageIDList()#">)
					#renderActiveClause("tcontent",arguments.siteID)#
					and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form')
				</cfquery>

				<cfset arguments.sourceIterator.setPageQuery("page#arguments.sourceIterator.getPageIndex()#",rsPage)>

			</cfif>

			<cfset rsPage=arguments.sourceIterator.getPageQuery("page#arguments.sourceIterator.getPageIndex()#")>

			<cfquery name="rsContent" dbtype="query">
				select * from rsPage where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#" />
			</cfquery>

		<cfelse>
			<cfif len(arguments.contentID)>
				<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsContent"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
					select #variables.fieldlist#, tfiles.fileSize,
					tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename
					from tcontent 
					left join tfiles on (tcontent.fileid=tfiles.fileid)
					where tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" /> 
					#renderActiveClause("tcontent",arguments.siteID)#
					and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form')
				</cfquery>
			</cfif>
		</cfif>
		
		<cfif rsContent.recordCount>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset bean.setPreserveID(rsContent.contentHistID) />
		<cfelseif arguments.use404>
			<cfset bean.setType("Page") />
			<cfset bean.setSubType("Default") />
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setBody('The requested page could not be found.')/>
			<cfset bean.setTitle('404')/>
			<cfset bean.setMenuTitle('404')/>
			<cfset bean.setFilename('404') />
			<cfset bean.setParentID('00000000000000000000000000000000END') />
			<cfset bean.setcontentID('00000000000000000000000000000000001') />
			<cfset bean.setPath('00000000000000000000000000000000001') />
			<cfset bean.setSiteID(arguments.siteID) />
			<cfset bean.setDisplay(1) />
			<cfset bean.setApproved(1) />
		<cfelse>
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setSiteID(arguments.siteid) />
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="readActiveByRemoteID" access="public" returntype="any" output="false">
		<cfargument name="remoteID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfargument name="contentBean" required="true" default="">
		<cfargument name="type" required="true" default="">
		<cfset var rsContent = queryNew('empty') />
		<cfset var beanArray=arrayNew(1)>
		<cfset var bean=arguments.contentBean />
		
		<cfif not isObject(bean)>
			<cfset bean=getBean("content")>
		</cfif>
		
		<cfif len(arguments.remoteID)>		
			<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsContent"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				select #variables.fieldlist#, tfiles.fileSize,
				tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename
				from tcontent 
				left join tfiles on (tcontent.fileid=tfiles.fileid)
				where tcontent.remoteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remoteID#" /> 
				#renderActiveClause("tcontent",arguments.siteID)#
				and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
				<cfif len(arguments.type)>
					and tcontent.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />
				<cfelse>
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form')
				</cfif>	
			</cfquery>
		</cfif>
		
		<cfif rsContent.recordcount gt 1>
				<cfloop query="rscontent">
				<cfset bean=getBean("content").set(variables.utility.queryRowToStruct(rsContent,rsContent.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset bean.setPreserveID(rsContent.contentHistID)>
				<cfset arrayAppend(beanArray,bean)>				
				</cfloop>
				<cfreturn beanArray>
		<cfelseif rsContent.recordCount>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset bean.setPreserveID(rsContent.contentHistID) />
		<cfelse>
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setSiteID(arguments.siteid) />
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="readActiveByTitle" access="public" returntype="any" output="false">
		<cfargument name="title" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfargument name="contentBean" required="true" default="">
		<cfargument name="type" required="true" default="">
		<cfset var rsContent = queryNew('empty') />
		<cfset var beanArray=arrayNew(1)>
		<cfset var bean=arguments.contentBean />
		
		<cfif not isObject(bean)>
			<cfset bean=getBean("content")>
		</cfif>
		
		<cfif len(arguments.title)>		
			<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsContent"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				select #variables.fieldlist#, tfiles.fileSize,
				tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename
				from tcontent 
				left join tfiles on (tcontent.fileid=tfiles.fileid)
				where tcontent.title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" /> 
				#renderActiveClause("tcontent",arguments.siteID)#
				and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
				<cfif len(arguments.type)>
					and tcontent.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />
				<cfelse>
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form')
				</cfif>	
			</cfquery>
		</cfif>
		
		<cfif rsContent.recordcount gt 1>
				<cfloop query="rscontent">
				<cfset bean=getBean("content").set(variables.utility.queryRowToStruct(rsContent,rsContent.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset bean.setPreserveID(rsContent.contentHistID)>
				<cfset arrayAppend(beanArray,bean)>				
				</cfloop>
				<cfreturn beanArray>
		<cfelseif rsContent.recordCount>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset bean.setPreserveID(rsContent.contentHistID) />
		<cfelse>
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setSiteID(arguments.siteid) />
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="readActiveByURLTitle" access="public" returntype="any" output="false">
		<cfargument name="urltitle" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfargument name="contentBean" required="true" default="">
		<cfargument name="type" required="true" default="">
		<cfset var rsContent = queryNew('empty') />
		<cfset var beanArray=arrayNew(1)>
		<cfset var bean=arguments.contentBean />
		
		<cfif not isObject(bean)>
			<cfset bean=getBean("content")>
		</cfif>
		
		<cfif len(arguments.urltitle)>		
			<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsContent"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				select #variables.fieldlist#, tfiles.fileSize,
				tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename
				from tcontent 
				left join tfiles on (tcontent.fileid=tfiles.fileid)
				where tcontent.urltitle=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.urltitle#" /> 
				#renderActiveClause("tcontent",arguments.siteID)#
				and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
				<cfif len(arguments.type)>
					and tcontent.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />
				<cfelse>
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form')
				</cfif>	
			</cfquery>
		</cfif>
		
		<cfif rsContent.recordcount gt 1>
				<cfloop query="rscontent">
				<cfset bean=getBean("content").set(variables.utility.queryRowToStruct(rsContent,rsContent.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset bean.setPreserveID(rsContent.contentHistID)>
				<cfset arrayAppend(beanArray,bean)>				
				</cfloop>
				<cfreturn beanArray>
		<cfelseif rsContent.recordCount>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset bean.setPreserveID(rsContent.contentHistID) />
		<cfelse>
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setSiteID(arguments.siteid) />
		</cfif>
		
		<cfreturn bean />
</cffunction>

<cffunction name="readActiveByFilename" access="public" returntype="any" output="true">
		<cfargument name="filename" type="string" required="yes" default="" />
		<cfargument name="siteID" type="string" required="yes" default="" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfargument name="contentBean" required="true" default="">
		<cfargument name="type" required="true" default="">
		<cfset var rsContent = queryNew('empty') />
		<cfset var beanArray=arrayNew(1)>
		<cfset var bean=arguments.contentBean />
		
		<cfif not isObject(bean)>
			<cfset bean=getBean("content")>
		</cfif>
		
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsContent"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select #variables.fieldlist#, tfiles.fileSize,
			tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename
			from tcontent 
			left join tfiles on (tcontent.fileid=tfiles.fileid)
			where 
			<cfif arguments.filename neq ''>
			 tcontent.filename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#" />
			#renderActiveClause("tcontent",arguments.siteID)#
			and tcontent.type in('Page','Folder','Calendar','Gallery','File','Link') 
			<cfelse>
			 tcontent.filename is null
			#renderActiveClause("tcontent",arguments.siteID)#
			 and tcontent.type in('Page','Folder','Calendar','Gallery','File','Link') 
			</cfif>
			and  tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
			<cfif len(arguments.type)>
				and tcontent.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />
			<cfelse>
				and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form')
			</cfif>	
		</cfquery>

		<cfif rsContent.recordcount gt 1>
				<cfloop query="rscontent">
				<cfset bean=getBean("content").set(variables.utility.queryRowToStruct(rsContent,rsContent.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset bean.setPreserveID(rsContent.contentHistID)>
				<cfset arrayAppend(beanArray,bean)>				
				</cfloop>
		<cfelseif rsContent.recordCount eq 1>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset bean.setPreserveID(rsContent.contentHistID) />
		<cfelseif arguments.use404>
			<cfset bean.setType("Page") />
			<cfset bean.setSubType("Default") />
			<cfset bean.setBody('The requested page could not be found.')/>
			<cfset bean.setTitle('404')/>
			<cfset bean.setMenuTitle('404')/>
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setFilename('404') />
			<cfset bean.setParentID('00000000000000000000000000000000END') />
			<cfset bean.setcontentID('00000000000000000000000000000000001') />
			<cfset bean.setPath('00000000000000000000000000000000001') />
			<cfset bean.setSiteID(arguments.siteID) />
			<cfset bean.setDisplay(1) />
			<cfset bean.setApproved(1) />
		<cfelse>
			<cfset bean.setIsNew(1) />
			<cfset bean.setActive(1) />
			<cfset bean.setSiteID(arguments.siteid) />
		</cfif>
		<cfreturn bean />
</cffunction>

<cffunction name="create" access="public" returntype="void" output="false">
		<cfargument name="contentBean" type="any" required="yes" />
		
		 <cfquery  DATASOURCE="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      INSERT INTO tcontent (ContentHistID, ContentID, Active, OrderNo,  approved, DisplayStart,
	   displaystop,
	   <!--- clob fields --->
	   MetaDesc,
	   MetaKeyWords,
	   Body,
	   Summary, 
	   path,
	   tags,
	   responseMessage,
	   responseDisplayFields,
	   <!--- --->
	   Title, menuTitle, filename, LastUpdate, Display, ParentID, Type, subType,LastUpdateBy, 
	   LastUpdateByID, siteid, moduleid, isnav, restricted, target, restrictgroups,template,
	   responseChart,responseSendTo,moduleAssign,notes,inheritObjects,isFeature,
	   releaseDate,targetParams,isLocked,nextN,sortBy,sortDirection,featureStart,featureStop,fileID,forceSSL,
	   remoteID,remoteURL,remotePubDate,remoteSource,RemoteSourceURL,Credits,
	   audience, keyPoints, searchExclude, displayTitle, doCache, created,
	   urltitle,
	   htmltitle,
	   mobileExclude,
	  changesetID,
	  imageSize,
	  imageHeight,
	  imageWidth,
	  childTemplate,
	  majorVersion,
	  minorVersion,
	  expires,
	  displayInterval,
	  sourceID)
      VALUES (
	  	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentHistID()#">, 
         <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#">,
		 #arguments.contentBean.getActive()#,
		 #arguments.contentBean.getOrderNo()#,
		#arguments.contentBean.getApproved()#,
		<cfif arguments.contentBean.getDisplay() eq 2 and isdate(arguments.contentBean.getDisplayStart())> 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.contentBean.getDisplayStart()),
									month(arguments.contentBean.getDisplayStart()),
									day(arguments.contentBean.getDisplayStart()),
									hour(arguments.contentBean.getDisplayStart()),
									minute(arguments.contentBean.getDisplayStart()),0)#">
		<cfelse>
			null
		</cfif>,
		<cfif arguments.contentBean.getDisplay() eq 2 and isdate(arguments.contentBean.getDisplayStop())> 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.contentBean.getDisplayStop()),
									month(arguments.contentBean.getDisplayStop()),
									day(arguments.contentBean.getDisplayStop()),
									hour(arguments.contentBean.getDisplayStop()),
									minute(arguments.contentBean.getDisplayStop()),0)#">
		<cfelse>
			null
		</cfif>,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getMetaDesc() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getMetaDesc()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getMetaKeyWords() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getMetaKeywords()#">,  
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getBody() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getBody()#"> , 
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getSummary() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getSummary()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getPath() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getPath()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getTags() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getTags()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getResponseMessage() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getResponseMessage()#">,
	    <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getResponseDisplayFields() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getResponseDisplayFields()#">,    
	    <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getTitle() neq '',de('no'),de('yes'))#" value="#trim(arguments.contentBean.getTitle())#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getMenutitle() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getMenutitle()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getFilename() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getFilename()#"> ,  
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
         #arguments.contentBean.getDisplay()#, 
       <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getParentID() neq '',de('no'),de('yes'))#" value="#trim(arguments.contentBean.getParentID())#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getType()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSubType()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#trim(arguments.contentBean.getLastUpdateBy())#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getLastUpdateByID() neq '',de('no'),de('yes'))#" value="#trim(arguments.contentBean.getLastUpdateByID())#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getModuleID()#">,
		#arguments.contentBean.getisnav()#,
		#arguments.contentBean.getrestricted()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getTarget() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getTarget()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRestrictGroups() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRestrictGroups()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getTemplate() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getTemplate()#">,
		#arguments.contentBean.getresponseChart()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getResponseSendTo() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getResponseSendTo()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getModuleAssign() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getModuleAssign()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getNotes()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getInheritObjects() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getInheritObjects()#">,
		#arguments.contentBean.getisfeature()#,
		<cfif isdate(arguments.contentBean.getReleaseDate())>
			 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.contentBean.getReleaseDate()), 
			 				month(arguments.contentBean.getReleaseDate()),
							day(arguments.contentBean.getReleaseDate()), 
							hour(arguments.contentBean.getReleaseDate()), 
							minute(arguments.contentBean.getReleaseDate()), 
							second(arguments.contentBean.getReleaseDate()))#">
		<cfelse>
			null
		</cfif>,
		<CFIF arguments.contentBean.getTarget() EQ "_blank" and arguments.contentBean.getTargetParams() NEQ ""> <cfqueryparam cfsqltype="cf_sql_varchar" null="no" value="#arguments.contentBean.getTargetParams()#"><CFELSE> Null </CFIF>,
		#arguments.contentBean.getIsLocked()#,
		<cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.contentBean.getNextN()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getSortBy() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getSortBy()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getSortDirection() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getSortDirection()#">,
		<cfif arguments.contentBean.getIsFeature() eq 2 and isdate(arguments.contentBean.getFeatureStart())> 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.contentBean.getFeatureStart()),
											month(arguments.contentBean.getFeatureStart()),
											day(arguments.contentBean.getFeatureStart()),
											hour(arguments.contentBean.getFeatureStart()),
											minute(arguments.contentBean.getFeatureStart()),0)#">
		<cfelse>
			null
		</cfif>,
		<cfif arguments.contentBean.getIsFeature() eq 2 and isdate(arguments.contentBean.getFeatureStop())>
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.contentBean.getFeatureStop()),
											month(arguments.contentBean.getFeatureStop()),
											day(arguments.contentBean.getFeatureStop()),
											hour(arguments.contentBean.getFeatureStop()),
											minute(arguments.contentBean.getFeatureStop()),0)#">
		<cfelse>
			null
		</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getFileID() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getFileID()#">,
		<cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.contentBean.getForceSSL()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemoteID() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemoteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemoteURL() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemoteURL()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemotePubDate() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemotePubDate()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemoteSource() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemoteSource()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemoteSourceURL() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemoteSourceURL()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getCredits() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getCredits()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getAudience() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getAudience()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getKeyPoints() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getKeyPoints()#">,
		#arguments.contentBean.getSearchExclude()#,
		#arguments.contentBean.getDisplayTitle()#,
		#arguments.contentBean.getDoCache()#,
		<cfif isdate(arguments.contentBean.getCreated())>
			 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.contentBean.getCreated()), 
			 				month(arguments.contentBean.getCreated()),
							day(arguments.contentBean.getCreated()), 
							hour(arguments.contentBean.getCreated()), 
							minute(arguments.contentBean.getCreated()), 
							second(arguments.contentBean.getCreated()))#">
		<cfelse>
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getURLTitle() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getURLTitle()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getHTMLTitle() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getHTMLTitle()#">,
		#arguments.contentBean.getMobileExclude()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getChangesetID() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getChangesetID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getImageSize() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getImageSize()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getImageHeight() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getImageHeight()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getImageWidth() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getImageWidth()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getChildTemplate() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getchildTemplate()#">,
		#arguments.contentBean.getMajorVersion()#,
		#arguments.contentBean.getMinorVersion()#,
		<cfif isdate(arguments.contentBean.getExpires())>
			 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.contentBean.getExpires()), 
			 				month(arguments.contentBean.getExpires()),
							day(arguments.contentBean.getExpires()), 
							hour(arguments.contentBean.getExpires()), 
							minute(arguments.contentBean.getExpires()), 
							second(arguments.contentBean.getExpires()))#">
		<cfelse>
			null
		</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getDisplayInterval() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getDisplayInterval()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSourceID()#">
		)
 </CFQUERY>

</cffunction>

<cffunction name="deleteHistAll" access="public" returntype="void" output="false" hint="I delete all archived and draft versions">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />
	<cfset var rsdate= "">
	<cfset var rslist= "">
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsdate"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select lastupdate from tcontent where active = 1 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rslist"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select contenthistid from tcontent 
	where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> 
	and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	<!---and lastupdate < #createodbcdatetime(rsdate.lastupdate)#--->
	and (
		 		(approved=0 and changesetID is null)
				 or 
				(approved=1 and active=0)
			)
	</cfquery>
	
	<cfif rslist.recordcount>
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		 Delete from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
		 <!---and lastupdate < #createodbcdatetime(rsdate.lastupdate)#--->
		 and (
		 		(approved=0 and changesetID is null)
				 or 
				(approved=1 and active=0)
			)
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentobjects where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /><cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfloop query="rslist">
			<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>
		</cfloop>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentcategoryassign where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /><cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentrelated where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /> <cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontenttags where 
		siteid='#arguments.siteid#'
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /> <cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="deleteDraftHistAll" access="public" returntype="void" output="false" hint="I delete all draft versions">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />
	<cfset var rslist= "">
	<cfset var rsFiles= "">
		
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rslist"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select contenthistid from tcontent 
	where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	and approved=0 and changesetID is null
	</cfquery>
	
	<cfif rslist.recordcount>	
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentobjects where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /><cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfloop query="rslist">
			<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>
		</cfloop>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentcategoryassign where 
		siteid='#arguments.siteid#'
		and contenthistid in (<cfloop query="rslist">'#rslist.contenthistid#'<cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentrelated where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist">'#rslist.contenthistid#'<cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontenttags where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /> <cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
	</cfif>
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Delete from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	and approved=0 and changesetID is null
	</cfquery>
	
</cffunction>

<cffunction name="archiveActive" access="public" returntype="void" output="false">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontent set active=0 where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
		and active=1 
		and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
</cffunction>

<cffunction name="createObjects" access="public" returntype="void" output="false">
	<cfargument name="data" type="struct" />
	<cfargument name="contentBean" type="any" />
	<cfargument name="oldContentHistID" type="string" default="" required="yes"/>

	<cfset var objectOrder = 0>
	<cfset var objectList = "">
	<cfset var rsOld = "">
	<cfset var r=0 />
	<cfset var i=0 />
	
	<cfloop from="1" to="#variables.settingsManager.getSite(arguments.contentBean.getsiteid()).getcolumnCount()#" index="r">
		<cfset objectOrder = 0>
		<cfif isdefined("arguments.data.objectlist#r#")>
			<cfset objectList =#evaluate("arguments.data.objectlist#r#")# />
			<cfloop list="#objectlist#" index="i" delimiters="^">
				<cfset objectOrder=objectOrder+1>
				<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				insert into tcontentobjects (contentid,contenthistid,object,name,objectid,orderno,siteid,columnid,params)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(i,1,"~")#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(i,2,"~")#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(i,3,"~")#" />,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#objectOrder#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#r#" />,
					<cfif listLen(i,"~") gt 3 ><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#listgetat(i,4,"~")#" /><cfelse>null</cfif>
					)
				</cfquery>
			</cfloop>
			
		<cfelseif arguments.oldContentHistID neq ''>
			<cfset rsOld=readRegionObjects(arguments.oldContentHistID,arguments.contentBean.getsiteid(),r)/>
			
			<cfloop query="rsOld">
				<cfset objectOrder=objectOrder+1>
				<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				insert into tcontentobjects (contentid,contenthistid,object,name,objectid,orderno,siteid,columnid,params)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOld.object#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOld.name#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOld.objectID#" />,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOld.currentRow#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOld.columnid#" />,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(rsOld.params neq '',de('no'),de('yes'))#" value="#rsOld.params#" />
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cfloop>
	
</cffunction>

<cffunction name="updateContentObjectParams" output="false">
	<cfargument name="contenthistID">
	<cfargument name="regionID">
	<cfargument name="orderno">
	<cfargument name="params">
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentobjects set
		params= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.params#" />
		where
		contentHistID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#" />
		and columnid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.regionID#" />
		and orderno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.orderno#" />		
	</cfquery>
</cffunction>

<cffunction name="readContentObject" output="false">
	<cfargument name="contenthistID">
	<cfargument name="regionID">
	<cfargument name="orderno">
	<cfset var rs="">
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select * from tcontentobjects
		where contentHistID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#" />
		and columnid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.regionID#" />
		and orderno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.orderno#" />		
	</cfquery>
	
	<cfreturn rs>
</cffunction>

<cffunction name="createTags" access="public" returntype="void" output="false">
	<cfargument name="contentBean" type="any" />
	<cfset var taglist  = "" />
	<cfset var t = "" />
		<cfif len(arguments.contentBean.getTags())>
			<cfset taglist = arguments.contentBean.getTags() />
			<cfloop list="#taglist#" index="t">
				<cfif len(trim(t))>
					<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					insert into tcontenttags (contentid,contenthistid,siteid,tag)
					values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(t)#"/>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
</cffunction>

<cffunction name="readRegionObjects" access="public" returntype="query" output="false">
	<cfargument name="contenthistid"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfargument name="regionID"  type="numeric" />
	<cfset var rs = "">
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rs"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select contenthistid, contentid, objectid, siteid, object, name, columnid, orderno, params
	from tcontentobjects 
	where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
	and columnid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.regionID#"/> 
	order by orderno
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="deleteObjects" access="public" returntype="void" output="false">
	<cfargument name="contentID"  type="string" />
	<cfargument name="siteID"  type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentobjects where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteTags" access="public" returntype="void" output="false">
	<cfargument name="contentID"  type="string" />
	<cfargument name="siteID"  type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontenttags where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteObjectsHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentobjects where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteTagHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontenttags where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />

	<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(arguments.contentHistID)/>
	
	<cfquery datasource="#variables.configBean.getDatasource()#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	DELETE FROM tcontent where  siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  and ContentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteExtendDataHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(arguments.contentHistID)/>
</cffunction>

<cffunction name="deleteCategoryHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery datasource="#variables.configBean.getDatasource()#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	DELETE FROM tcontentcategoryassign where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and
	contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> 
	</cfquery>
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="contentBean"  type="any" />
	<cfset var rsList=""/>
	<cfif arguments.contentBean.getContentID() neq '00000000000000000000000000000000001'>
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontent set parentID='#arguments.contentBean.getParentID()#' where 
	siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and parentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentID()#"/>
	</cfquery>
	
	
	<!--- get Versions and delete extended data --->
	<cfquery name="rslist" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select contentHistID FROM tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and 
	ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
	</cfquery>
	
	<cfloop query="rslist">
		<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>
	</cfloop>
	<!--- --->
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	DELETE FROM tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and 
	ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#"/>
	</cfquery>
	
	<cfquery datasource="#variables.configBean.getDatasource()#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentassignments where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
	</cfquery>
		
	<cfif arguments.contentBean.gettype() neq 'Form'  and arguments.contentBean.gettype() neq 'Component'>
	
		<cfquery datasource="#variables.configBean.getDatasource()#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentobjects where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontenttags where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentcategoryassign where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getDatasource()#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentrelated where (contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/> or relatedID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>)
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
	
	<cfelse>
	
		<cfquery datasource="#variables.configBean.getDatasource()#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentobjects where objectID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
	</cfif>
	
	</cfif>
</cffunction>

<cffunction name="createRelatedItems" returntype="void" access="public" output="false">
	<cfargument name="contentID" type="string" required="yes" default="" />
	<cfargument name="contentHistID" type="string" required="yes" default="" />
	<cfargument name="data" type="struct" required="yes" default="#structNew()#" />
	<cfargument name="siteID" type="string" required="yes" default="" />
	<cfargument name="oldContentHistID" type="string" required="yes" default="" />
	
	<cfset var I='' />
	 
	 <cfif isDefined('arguments.data.relatedContentID')>
	 <cfloop list="#arguments.data.relatedContentID#" index="I">
		<cftry>
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentrelated (contentID,contentHistID,relatedID,siteid)
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		)
		</cfquery>
		<cfcatch></cfcatch>
		</cftry>
	</cfloop>
	
	<cfelseif arguments.oldContentHistID neq ''>

	 <cfloop list="#readRelatedItems(arguments.oldContentHistID,arguments.siteID)#" index="I">
		<cftry>
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentrelated (contentID,contentHistID,relatedID,siteid)
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		)
		</cfquery>
		<cfcatch></cfcatch>
		</cftry>
	</cfloop>
	
	</cfif>

</cffunction> 

<cffunction name="deleteRelatedItems" access="public" output="false" returntype="void" >
	<cfargument name="contentHistID" type="String" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentrelated
	where contentHIstID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
	</cfquery>

</cffunction>

<cffunction name="readRelatedItems" returntype="string" access="public" output="false">
	<cfargument name="contentHistID" type="string" required="yes" default="" />
	<cfargument name="siteid" type="string" required="yes" default="" />
	
	 <cfset var rsRelatedItems =""/>
	 <cfset var ItemList =""/>
	
	<cfquery name="rsRelatedItems" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select relatedID from tcontentrelated
		where contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/> and siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
	
	<cfset ItemList=valueList(rsRelatedItems.relatedID) />
	
	<cfreturn ItemList />
	
</cffunction> 

<cffunction name="deleteContentAssignments" access="public" output="false" returntype="void" >
	<cfargument name="id" type="String" />
	<cfargument name="siteID" type="String" />
	<cfargument name="type" type="String" default="draft"/>
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentassignments
	where 
	<cfif arguments.type eq "expire">
	contentHistID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#"/>
	<cfelse>
	contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#"/>
	and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	and type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>
	</cfquery>

</cffunction>

<cffunction name="createContentAssignment" access="public" output="false" returntype="void" >
	<cfargument name="contentBean" type="any" />
	<cfargument name="userID" type="String" />
	<cfargument name="type" type="String" default="draft"/>
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into tcontentassignments (contentID,contentHistID,siteID,UserID,type) values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentHistID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSiteID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" >
			)
	</cfquery>
	
</cffunction>

<cffunction name="readComments" access="public" output="false" returntype="query">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfargument name="filterByParentID" type="boolean" required="true" default="true">
	<cfset var rsComments= ''/>
	
	<cfquery name="rsComments" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select c.contentid, c.commentid, c.parentid, c.name, c.email, c.url, c.comments, c.entered, c.siteid, c.isApproved, c.subscribe, c.userID, c.path,
	f.fileid, f.fileExt, k.kids
	from tcontentcomments c 
	left join tusers u on c.userid=u.userid
	left join tfiles f on u.photofileid=f.fileid
	left join (select count(*) kids, parentID from tcontentcomments
				where parentID in (select commentID from tcontentcomments
									where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/> 
									and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
								  	<cfif not arguments.isEditor>
									and isApproved=1
									</cfif>
								  )
				group by parentID
				
				)  k on c.commentID=k.parentID
	where c.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/> 
	and c.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	<cfif arguments.filterByParentID>
	and c.parentID <cfif len(arguments.parentID)>=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/><cfelse>is null</cfif>
	</cfif>
	<cfif not arguments.isEditor>
	and c.isApproved=1
	</cfif>
	order by c.entered #arguments.sortOrder#
	</cfquery>

	<cfreturn rsComments />
</cffunction>

<cffunction name="readRecentComments" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="size" type="numeric" required="true" default="5">
	<cfargument name="approvedOnly" type="boolean" required="true" default="true">
	
	<cfset var rsRecentComments= ''/>
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfquery name="rsRecentComments" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	<cfif dbType eq "oracle" and arguments.size>select * from (</cfif>
	select 
	<cfif dbType eq "mssql" and arguments.size>Top #arguments.size#</cfif> 
	c.contentid, c.commentid, c.parentid, c.name, c.email, c.url, c.comments, c.entered, c.siteid, c.isApproved, c.subscribe, c.userID, c.path,
	f.fileid, f.fileExt
	from tcontentcomments c 
	left join tusers u on c.userid=u.userid
	left join tfiles f on u.photofileid=f.fileid
	where c.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	<cfif arguments.approvedOnly>
	and approved=1
	</cfif>
	order by entered desc
	<cfif dbType eq "nuodb" and arguments.size>fetch #arguments.size#</cfif>
	<cfif dbType eq "mysql" and arguments.size>limit #arguments.size#</cfif>
	<cfif dbType eq "oracle" and arguments.size>) where ROWNUM <=#arguments.size# </cfif>
	</cfquery>
	
	<cfreturn rsRecentComments />
</cffunction>

<cffunction name="getCommentCount" access="public" output="false" returntype="numeric">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfset var rs= ''/>
	
	<cfquery name="rsCommentCount" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select count(*) TotalComments from tcontentcomments where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	<cfif not arguments.isEditor >
	and isApproved=1
	</cfif>
	</cfquery>
	
	<cfreturn rsCommentCount.TotalComments />
</cffunction>

<cffunction name="getCommentSubscribers" access="public" output="false" returntype="query">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfset var rsCommentSubscribers= ''/>
	
	<cfquery name="rsCommentSubscribers" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select distinct email from tcontentcomments 
	where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/> 
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and email is not null
	and isApproved=1
	and subscribe=1
	</cfquery>
	
	<cfreturn rsCommentSubscribers />
</cffunction>

<cffunction name="renderActiveClause" output="true">
<cfargument name="table" default="tcontent">
<cfargument name="siteID">
	<cfset var previewData="">
	<cfoutput>
			<cfif request.muraChangesetPreview>
				<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
				<cfif len(previewData.contentIDList)>
					and (
							(#arguments.table#.active = 1			
							and #arguments.table#.contentID not in (#previewData.contentIDList#)	
							)
							
							or 
							
							(
							#arguments.table#.contentHistID in (#previewData.contentHistIDList#)
							)		
						)	
				<cfelse>
					and #arguments.table#.active = 1	
				</cfif>
			<cfelse>
				and #arguments.table#.active = 1
				
			</cfif>	
	</cfoutput>
</cffunction>

<cffunction name="getExpireAssignments" output="false">
<cfargument name="contenthistid">
<cfset var rs="">
<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
    select userID from tcontentassignments 
	where contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#">
	and type='expire'
</cfquery>
<cfreturn rs>
</cffunction>
</cfcomponent>