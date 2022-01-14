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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides content CRUD functionality">

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
tcontent.imageSize,tcontent.imageHeight,tcontent.imageWidth,tcontent.childTemplate,tcontent.majorVersion,tcontent.minorVersion,tcontent.expires,tcontent.displayInterval,tcontent.objectParams
</cfoutput></cfsavecontent>

<cffunction name="init" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.utility=arguments.utility>
<cfreturn this />
</cffunction>

<cffunction name="readVersion" output="false">
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
				<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPage')#">
					select #variables.fieldlist#, tfiles.fileSize,
					tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename,
					tapprovalrequests.status as approvalStatus, tapprovalrequests.requestID,tapprovalrequests.groupid as approvalGroupID
					 from tcontent
					left join tfiles on (tcontent.fileid=tfiles.fileid)
					left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
					where
					tcontent.contenthistid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.sourceIterator.getPageIDList()#">)
				</cfquery>

				<cfset arguments.sourceIterator.setPageQuery("page#arguments.sourceIterator.getPageIndex()#",rsPage)>

			</cfif>

			<cfset rsPage=arguments.sourceIterator.getPageQuery("page#arguments.sourceIterator.getPageIndex()#")>

			<cfquery name="rsContent" dbtype="query">
				select * from rsPage where contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistid#" />
			</cfquery>

		<cfelse>
			<cfif len(arguments.contentHistID)>
				<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContent')#">
					select #variables.fieldlist#, tfiles.fileSize,
					tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename,
					tapprovalrequests.status as approvalStatus, tapprovalrequests.requestID,tapprovalrequests.groupid as approvalGroupID
					from tcontent
					left join tfiles on (tcontent.fileid=tfiles.fileid)
					left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
					where tcontent.contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#" />
				</cfquery>
			</cfif>
		</cfif>

		<cfif rsContent.recordCount>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset setCustomTagGroups(bean)>
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

<cffunction name="readActive" output="false">
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
				<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPage')#">
					select #variables.fieldlist#, tfiles.fileSize,
					tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename,
					tapprovalrequests.status as approvalStatus, tapprovalrequests.requestID,tapprovalrequests.groupid as approvalGroupID
					from tcontent
					left join tfiles on (tcontent.fileid=tfiles.fileid)
					left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
					where
					tcontent.#arguments.sourceIterator.getRecordIdField()# in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.sourceIterator.getPageIDList()#">)
					#renderActiveClause("tcontent",arguments.siteID)#
					and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form','Variation','Module')
				</cfquery>

				<cfset arguments.sourceIterator.setPageQuery("page#arguments.sourceIterator.getPageIndex()#",rsPage)>

			</cfif>

			<cfset rsPage=arguments.sourceIterator.getPageQuery("page#arguments.sourceIterator.getPageIndex()#")>

			<cfquery name="rsContent" dbtype="query">
				select * from rsPage where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#" />
			</cfquery>

		<cfelse>

			<cfif len(arguments.contentID)>
				<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContent')#">
					select #variables.fieldlist#, tfiles.fileSize,
					tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename,
				tapprovalrequests.status as approvalStatus, tapprovalrequests.requestID,tapprovalrequests.groupid as approvalGroupID
					from tcontent
					left join tfiles on (tcontent.fileid=tfiles.fileid)
					left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
					where tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
					#renderActiveClause("tcontent",arguments.siteID)#
					and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form','Variation','Module')
				</cfquery>
			</cfif>
		</cfif>

		<cfif rsContent.recordCount>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset setCustomTagGroups(bean)>
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

<cffunction name="readActiveByRemoteID" output="false">
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
			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContent')#">
				select #variables.fieldlist#, tfiles.fileSize,
				tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename,
				tapprovalrequests.status as approvalStatus, tapprovalrequests.requestID,tapprovalrequests.groupid as approvalGroupID
				from tcontent
				left join tfiles on (tcontent.fileid=tfiles.fileid)
				left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
				where tcontent.remoteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remoteID#" />
				#renderActiveClause("tcontent",arguments.siteID)#
				and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
				<cfif len(arguments.type)>
					and tcontent.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />
				<cfelse>
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form','Variation','Module')
				</cfif>
			</cfquery>
		</cfif>

		<cfif rsContent.recordcount gt 1>
				<cfloop query="rscontent">
				<cfset bean=getBean("content").set(variables.utility.queryRowToStruct(rsContent,rsContent.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset bean.setPreserveID(rsContent.contentHistID)>
				<cfset setCustomTagGroups(bean)>
				<cfset arrayAppend(beanArray,bean)>
				</cfloop>
		<cfelseif rsContent.recordCount eq 1>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset setCustomTagGroups(bean)>
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

<cffunction name="readActiveByTitle" output="false">
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
			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContent')#">
				select #variables.fieldlist#, tfiles.fileSize,
				tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename,
				tapprovalrequests.status as approvalStatus, tapprovalrequests.requestID,tapprovalrequests.groupid as approvalGroupID
				from tcontent
				left join tfiles on (tcontent.fileid=tfiles.fileid)
				left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
				where tcontent.title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" />
				#renderActiveClause("tcontent",arguments.siteID)#
				and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
				<cfif len(arguments.type)>
					and tcontent.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />
				<cfelse>
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form','Variation','Module')
				</cfif>
			</cfquery>
		</cfif>

		<cfif rsContent.recordcount gt 1>
				<cfloop query="rscontent">
				<cfset bean=getBean("content").set(variables.utility.queryRowToStruct(rsContent,rsContent.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset bean.setPreserveID(rsContent.contentHistID)>
				<cfset setCustomTagGroups(bean)>
				<cfset arrayAppend(beanArray,bean)>
				</cfloop>
		<cfelseif rsContent.recordCount eq 1>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset bean.setPreserveID(rsContent.contentHistID) />
			<cfset setCustomTagGroups(bean)>
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

<cffunction name="readActiveByURLTitle" output="false">
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
			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContent')#">
				select #variables.fieldlist#, tfiles.fileSize,
				tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename,
				tapprovalrequests.status as approvalStatus, tapprovalrequests.requestID,tapprovalrequests.groupid as approvalGroupID
				from tcontent
				left join tfiles on (tcontent.fileid=tfiles.fileid)
				left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
				where tcontent.urltitle=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.urltitle#" />
				#renderActiveClause("tcontent",arguments.siteID)#
				and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
				<cfif len(arguments.type)>
					and tcontent.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />
				<cfelse>
					and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form','Variation','Module')
				</cfif>
			</cfquery>
		</cfif>

		<cfif rsContent.recordcount gt 1>
				<cfloop query="rscontent">
				<cfset bean=getBean("content").set(variables.utility.queryRowToStruct(rsContent,rsContent.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset bean.setPreserveID(rsContent.contentHistID)>
				<cfset setCustomTagGroups(bean)>
				<cfset arrayAppend(beanArray,bean)>
				</cfloop>
		<cfelseif rsContent.recordCount eq 1>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset setCustomTagGroups(bean)>
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

<cffunction name="readActiveByFilename" output="true">
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

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContent')#">
			select #variables.fieldlist#, tfiles.fileSize,
			tfiles.contentType, tfiles.contentSubType, tfiles.fileExt,tfiles.filename as assocFilename,
			tapprovalrequests.status as approvalStatus, tapprovalrequests.requestID,tapprovalrequests.groupid as approvalGroupID
			from tcontent
			left join tfiles on (tcontent.fileid=tfiles.fileid)
			left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
			where
			<cfif arguments.filename neq ''>
			 tcontent.filename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.filename)#" />
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
				and type in ('Page','Folder','File','Calendar','Link','Gallery','Component','Form','Variation')
			</cfif>
		</cfquery>

		<cfif rsContent.recordcount gt 1>
				<cfloop query="rscontent">
				<cfset bean=getBean("content").set(variables.utility.queryRowToStruct(rsContent,rsContent.currentrow))>
				<cfset bean.setIsNew(0)>
				<cfset bean.setPreserveID(rsContent.contentHistID)>
				<cfset setCustomTagGroups(bean)>
				<cfset arrayAppend(beanArray,bean)>
				</cfloop>
		<cfelseif rsContent.recordCount eq 1>
			<cfset bean.set(rsContent) />
			<cfset bean.setIsNew(0) />
			<cfset setCustomTagGroups(bean)>
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

<cffunction name="create" output="false">
		<cfargument name="contentBean" type="any" required="yes" />

		 <cfquery >
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
	  displayInterval
	  ,objectParams)
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
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getMetaKeyWords(conditional=false) neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getMetaKeywords(conditional=false)#">,
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
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getDisplayInterval(serialize=true) neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getDisplayInterval(serialize=true)#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getObjectParams(serialize=true) neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getObjectParams(serialize=true)#">

		)
 </CFQUERY>

</cffunction>

<cffunction name="deleteHistAll" output="false" hint="I delete all archived and draft versions">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />
	<cfset var rsdate= "">
	<cfset var rslist= "">
	<cfset var ap= "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDate')#">
	select tcontent.lastupdate from tcontent
	where tcontent.active = 1
	and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and tcontent.contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	</cfquery>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsList')#">
	select tcontent.contenthistid,tcontent.active,tapprovalrequests.status from tcontent
	left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and tcontent.contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	<!---and lastupdate < #createodbcdatetime(rsdate.lastupdate)#--->
	and tcontent.active=0
	and (
		 		(tcontent.approved=0 and tcontent.changesetID is null)
				 or
				(tcontent.approved=1 and tcontent.active=0)
			)

	and (tapprovalrequests.status !='Pending' or tapprovalrequests.status is null)
	</cfquery>

	<cfif rslist.recordcount>
		<cfquery>
		 Delete from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		 and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

		<cfquery>
		delete from tcontentobjects where
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

		<cfloop query="rslist">
			<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>

			<cfset ap=getBean('approvalRequest').loadBy(contenthistid=rslist.contenthistid)>
			<cfif not ap.getIsNew()>
				<cfset ap.delete()>
			</cfif>
			<cfset deleteVersionedObjects(rslist.contenthistid)>
		</cfloop>

		<cfquery>
		delete from tcontentcategoryassign where
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

		<cfquery>
		delete from tcontentrelated where
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

		<cfquery>
		delete from tcontenttags where
		siteid='#arguments.siteid#'
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

	</cfif>

	<cfset deleteOldSourceMaps(argumentCollection=arguments)>
</cffunction>

<cffunction name="deleteDraftHistAll" output="false" hint="I delete all draft versions">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />
	<cfset var rslist= "">
	<cfset var rsFiles= "">
	<cfset var ap= "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rslist')#">
	select tcontent.contenthistid from tcontent
	left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and tcontent.contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	and tcontent.active=0
	and tcontent.approved=0 and tcontent.changesetID is null
	and (tapprovalrequests.status !='Pending' or tapprovalrequests.status is null)
	</cfquery>

	<cfif rslist.recordcount>
		<cfquery>
		delete from tcontentobjects where
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

		<cfloop query="rslist">
			<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>
			<cfset deleteVersionedObjects(rslist.contenthistid)>
		</cfloop>

		<cfquery>
		delete from tcontentcategoryassign where
		siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

		<cfquery>
		delete from tcontentrelated where
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

		<cfquery>
		delete from tcontenttags where
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>

		<!---
		<cfset ap=getBean('approvalRequest').loadBy(contenthistid=rslist.contenthistid)>
		<cfif not ap.getIsNew()>
			<cfset ap.delete()>
		</cfif>
		--->
		<cfquery>
		delete from tcontent where
		siteid='#arguments.siteid#'
		and contenthistid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valuelist(rslist.contentHistID)#" />)
		</cfquery>
	</cfif>

	<cfset deleteOldSourceMaps(argumentCollection=arguments)>

</cffunction>

<cffunction name="archiveActive" output="false">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />

	<cfquery>
		update tcontent set active=0 where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
		and active=1
		and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

</cffunction>

<cffunction name="createObjects" output="false">
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
			<cfset objectList =arguments.data["objectlist#r#"] />
			<cfif isJSON(objectList)>	
				<cfset objectList=deserializeJSON(objectList)>

				<cfloop array="#objectlist#" item="i">
					<cfset objectOrder=objectOrder+1>
					<cfif arrayLen(i) gt 3 and not isJSON(i[4])>
						<cfset i[4]=serializeJSON(i[4])>
					</cfif>
					<cfquery>
					insert into tcontentobjects (contentid,contenthistid,object,name,objectid,orderno,siteid,columnid,params)
					values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#i[1]#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#i[2]#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#i[3]#" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#objectOrder#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#r#" />,
						<cfif arrayLen(i) gt 3 ><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#i[4]#" /><cfelse>null</cfif>
						)
					</cfquery>
				</cfloop>

			<cfelse>

				<cfloop list="#objectlist#" index="i" delimiters="^">
					<cfset objectOrder=objectOrder+1>
					<cfquery>
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
			</cfif>

		<cfelseif arguments.oldContentHistID neq ''>
			<cfset rsOld=readRegionObjects(arguments.oldContentHistID,arguments.contentBean.getsiteid(),r)/>

			<cfloop query="rsOld">
				<cfset objectOrder=objectOrder+1>
				<cfquery>
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

	<cfquery>
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

	<cfquery name="rs">
		select * from tcontentobjects
		where contentHistID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#" />
		and columnid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.regionID#" />
		and orderno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.orderno#" />
	</cfquery>

	<cfreturn rs>
</cffunction>

<cffunction name="setCustomTagGroups" output="false">
	<cfargument name="contentBean">
	<cfset var tagGroupList=variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getCustomTagGroups()>
	<cfset var g="">
	<cfset var rs="">
	<cfset var rsgroup="">

	<cfif not arguments.contentBean.getIsNew() and len(tagGroupList)>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
			select tag,taggroup from tcontenttags where
			contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />
			and taggroup is not null
		</cfquery>

		<cfloop list="#tagGroupList#" index="g" delimiters="^,">
			<cfset g=trim(g)>
			<cfquery name="rsgroup" dbtype="query">
				select tag from rs where
				taggroup=<cfqueryparam cfsqltype="cf_sql_varchar" value="#g#" />
			</cfquery>

			<cfset arguments.contentBean.setValue('#g#tags',valueList(rsgroup.tag))>
		</cfloop>
	</cfif>

</cffunction>

<cffunction name="createTags" output="false">
	<cfargument name="contentBean" type="any" />
	<cfset var taglist  = "" />
	<cfset var t = "" />
	<cfset var tagGroupList=variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getCustomTagGroups()>
	<cfset var g="">

	<cfif len(arguments.contentBean.getTags())>
		<cfset taglist = arguments.contentBean.getTags() />
		<cfloop list="#taglist#" index="t">
			<cfif len(trim(t))>
				<cfquery>
				insert into tcontenttags (contentid,contenthistid,siteid,tag,taggroup)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(t)#"/>,
					null
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>

	<cfif len(tagGroupList)>
		<cfloop list="#tagGroupList#" index="g" delimiters="^,">
			<cfset g=trim(g)>
			<cfif len(arguments.contentBean.getValue('#g#tags'))>
				<cfset taglist = arguments.contentBean.getValue('#g#tags') />

				<cfloop list="#taglist#" index="t">
					<cfif len(trim(t))>
						<cfquery>
						insert into tcontenttags (contentid,contenthistid,siteid,tag,taggroup)
						values(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(t)#"/>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#g#" />
							)
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="readRegionObjects" output="false">
	<cfargument name="contenthistid"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfargument name="regionID"  type="numeric" />
	<cfset var rs = "">

	<cfset var qAtts={}>


	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select contenthistid, contentid, objectid, siteid, object, name, columnid, orderno, params
	from tcontentobjects
	where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
	and columnid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.regionID#"/>
	order by orderno
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="deleteObjects" output="false">
	<cfargument name="contentID"  type="string" />
	<cfargument name="siteID"  type="string" />

	<cfquery>
	delete from tcontentobjects where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
</cffunction>

<cffunction name="deleteTags" output="false">
	<cfargument name="contentID"  type="string" />
	<cfargument name="siteID"  type="string" />

	<cfquery>
	delete from tcontenttags where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
</cffunction>

<cffunction name="deleteObjectsHist" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery>
	delete from tcontentobjects where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
</cffunction>

<cffunction name="deleteTagHist" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery>
	delete from tcontenttags where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
</cffunction>

<cffunction name="deleteHist" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />

	<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(arguments.contentHistID)/>

	<cfquery>
	DELETE FROM tcontent where  siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  and ContentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/>
	</cfquery>
</cffunction>

<cffunction name="deleteExtendDataHist" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(arguments.contentHistID)/>
</cffunction>

<cffunction name="deleteCategoryHist" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery>
	DELETE FROM tcontentcategoryassign where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and
	contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
	</cfquery>
</cffunction>

<cffunction name="delete" output="false">
	<cfargument name="contentBean"  type="any" />
	<cfset var rsList="">
	<cfset var ap="">
	<cfif arguments.contentBean.getContentID() neq '00000000000000000000000000000000001'>

	<cfquery>
	update tcontent set parentID='#arguments.contentBean.getParentID()#' where
	siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and parentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentID()#"/>
	</cfquery>


	<!--- get Versions and delete extended data --->
	<cfquery name="rslist">
	select contentHistID,active FROM tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and
	ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
	</cfquery>

	<cfloop query="rslist">
		<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>
		<cfset ap=getBean('approvalRequest').loadBy(contenthistid=rslist.contenthistid)>
		<cfif not ap.getIsNew()>
			<cfset ap.delete()>
		</cfif>

		<!--- only delete if not active so that the data is available if restored from trash --->
		<cfif not rslist.active>
			<cfset deleteVersionedObjects(rslist.contenthistid)>
		</cfif>
	</cfloop>
	<!--- --->

	<cfquery>
	DELETE FROM tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and
	ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#"/>
	</cfquery>

	<cfquery>
		DELETE FROM tcontentassignments where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
	</cfquery>

	<cfif arguments.contentBean.gettype() neq 'Form'  and arguments.contentBean.gettype() neq 'Component'>

		<cfquery>
			DELETE FROM tcontentremotepointer where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
			AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>

		<cfquery>
		DELETE FROM tcontentobjects where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>

		<cfquery>
		DELETE FROM tcontenttags where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>

		<cfquery>
		DELETE FROM tcontentcategoryassign where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>

		<cfquery>
		DELETE FROM tcontentrelated where (contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/> or relatedID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>)
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>

	<cfelse>

		<cfquery>
		DELETE FROM tcontentobjects where objectID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>

	</cfif>

	</cfif>
</cffunction>

<cffunction name="createRelatedItems" output="false">
	<cfargument name="contentID" type="string" required="yes" default="" />
	<cfargument name="contentHistID" type="string" required="yes" default="" />
	<cfargument name="data" type="struct" required="yes" default="#structNew()#" />
	<cfargument name="siteID" type="string" required="yes" default="" />
	<cfargument name="oldContentHistID" type="string" required="yes" default="" />
	<cfargument name="bean" />
	<cfset var i = "">
	<cfset var s = "">
	<cfset var j = "">
	<cfset var rcs = "">
	<cfset var item = "">
	<cfset var rcsData = "">
	<cfset var rsRelatedContent = "">
	<cfset var relatedID="">
	<cfset var rsCheck="">
	<cfset var relatedBean="">
	<cfset var relatedIDList=structNew()>
	<cfset var relatedContentSets=variables.configBean
			.getClassExtensionManager()
			.getSubTypeByName(arguments.bean.getValue('type'), arguments.bean.getValue('subtype'), arguments.bean.getValue('siteid'))
			.getRelatedContentSets(includeInheritedSets=true)>

	<cfif isDefined('arguments.data.relatedContentSetData') and ((isArray(arguments.data.relatedContentSetData) and arrayLen(arguments.data.relatedContentSetData) gte 1) or isJSON(arguments.data.relatedContentSetData))>
		<cfif isJSON(arguments.data.relatedContentSetData)>
			<cfset rcsData = deserializeJSON(arguments.data.relatedContentSetData)>
		<cfelseif isArray(arguments.data.relatedContentSetData)>
			<cfset rcsData = arguments.data.relatedContentSetData>
		</cfif>
	<cfelse>
		<cfset rcsData=[]>
	</cfif>

	<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="i">
		<cfset rcs=''>
		<cfloop from="1" to="#arrayLen(rcsData)#" index="s">
			<cfif relatedContentSets[i].getRelatedContentSetId() eq rcsData[s].relatedContentSetID>
				<cfset rcs = rcsData[s]>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif isStruct(rcs)>
			<cfset relatedIDList['setid-#rcs.relatedContentSetID#'] = "">
			<cfloop from="1" to="#arrayLen(rcs.items)#" index="j">
				<cfif isStruct(rcs.items[j])>
					<cfif not isdefined('local.parentBean')>
						<cfset local.parentBean=getBean('content').loadBy(filename=arguments.bean.getFilename() & "/related-content",siteid=bean.getSiteID())>

						<cfif local.parentBean.getIsNew()>
							<cfset local.parentBean.setTitle('Related Content')
								.setSiteID(arguments.bean.getSiteID())
								.setParentID(arguments.bean.getContentID())
								.setType('Folder')
								.setIsNav(0)
								.setSearchExclude(1)
								.setApproved(1)
								.save()>
						</cfif>
					</cfif>

					<cfset relatedBean=getBean('content')>

					<cfquery name="rsCheck">
						select contenthistid,siteid from tcontent
						where
						parentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.parentBean.getContentID()#">
						and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.parentBean.getSiteID()#">
						and active=1
						and type= 'Link'
						and body like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rcs.items[j].url#">
					</cfquery>

					<cfif rsCheck.recordcount>
						<cfset relatedBean.loadBy(contenthistid=rsCheck.contenthistid,siteid=rsCheck.siteid)>
					</cfif>

					<cfset relatedID = relatedBean
						.setBody(rcs.items[j].url)
						.setTitle(rcs.items[j].title)
						.setType('Link')
						.setIsNav(0)
						.setParentID(local.parentBean.getContentID())
						.setSearchExclude(1)
						.setSiteID(arguments.bean.getSiteID())
						.setApproved(1)
						.save()
						.getContentID()>

				<cfelse>
					<cfset relatedID = rcs.items[j]>
				</cfif>

				<cfif not listFindNoCase(relatedIDList['setid-#rcs.relatedContentSetID#'],relatedID)>
					<cftry>
						<cfquery>
							insert into tcontentrelated (contentID,contentHistID,relatedID,siteid,relatedContentSetID,orderNo)
							values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedID#"/>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rcs.relatedContentSetID#"/>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#j#"/>
							)
						</cfquery>
						<cfcatch></cfcatch>
					</cftry>
					<cfset relatedIDList['setid-#rcs.relatedContentSetID#']=listAppend(relatedIDList['setid-#rcs.relatedContentSetID#'],relatedID)>
				</cfif>
			</cfloop>
		<cfelseif arguments.oldContentHistID neq ''>
			<cfset rsRelatedContent = readRelatedItems(contenthistid=arguments.oldContentHistID, siteid=arguments.siteID, relatedContentSetID=relatedContentSets[i].getRelatedContentSetId())>
			<cfloop query="rsRelatedContent">
				<cftry>
					<cfquery>
						insert into tcontentrelated (contentID,contentHistID,relatedID,siteid,relatedContentSetID,orderNo)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRelatedContent.relatedID#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRelatedContent.relatedContentSetID#"/>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRelatedContent.orderNo#"/>
						)
					</cfquery>
					<cfcatch></cfcatch>
				</cftry>
			</cfloop>
		</cfif>
	</cfloop>

</cffunction>

<cffunction name="deleteRelatedItems" output="false" >
	<cfargument name="contentHistID" type="String" />

	<cfquery>
	delete from tcontentrelated
	where contentHIstID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
	</cfquery>

</cffunction>

<cffunction name="readRelatedItems" output="false">
	<cfargument name="contentHistID" type="string" required="yes" default="" />
	<cfargument name="siteid" type="string" required="yes" default="" />
	<cfargument name="relatedcontentsetid" type="string" required="yes" default="" />

	 <cfset var rsRelatedItems =""/>

	<cfquery name="rsRelatedItems">
		select relatedID, relatedContentSetID, orderNo from tcontentrelated
		where contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/>
		and siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		<cfif len(arguments.relatedcontentsetid)>
			and relatedcontentsetid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relatedcontentsetid#"/>
		</cfif>
	</cfquery>

	<cfreturn rsRelatedItems />

</cffunction>

<cffunction name="deleteContentAssignments" output="false" >
	<cfargument name="id" type="String" />
	<cfargument name="siteID" type="String" />
	<cfargument name="type" type="String" default="draft"/>

	<cfquery>
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

<cffunction name="createContentAssignment" output="false" >
	<cfargument name="contentBean" type="any" />
	<cfargument name="userID" type="String" />
	<cfargument name="type" type="String" default="draft"/>

	<cfquery>
			insert into tcontentassignments (contentID,contentHistID,siteID,UserID,type) values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentHistID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSiteID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" >
			)
	</cfquery>

</cffunction>

<cffunction name="readComments" output="false">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfargument name="filterByParentID" type="boolean" required="true" default="true">
	<cfargument name="includeSpam" type="boolean" required="true" default="false">
	<cfargument name="includeDeleted" type="boolean" required="true" default="false">
	<cfargument name="includeKids" type="boolean" required="true" default="false">
	<cfset var rsComments= ''/>

	<cfquery name="rsComments">
	select c.contentid, c.commentid, c.parentid, c.name, c.email, c.url, c.comments, c.entered, c.siteid, c.isApproved, c.subscribe, c.userID, c.path,
	f.fileid, f.fileExt, <cfif arguments.includeKids>k.kids <cfelse> 0 kids</cfif>
	from tcontentcomments c
	left join tusers u on c.userid=u.userid
	left join tfiles f on u.photofileid=f.fileid

	<cfif arguments.includeKids>
	left join (select count(*) kids, parentID from tcontentcomments
				where parentID in (select commentID from tcontentcomments
									where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/>
									and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
								  	<cfif not arguments.isEditor>
									and isApproved=1
									</cfif>
									<cfif not arguments.includeSpam>
									and isSpam=0
									</cfif>
									<cfif not arguments.includeDeleted>
									and isDeleted=0
									</cfif>
								  )
				group by parentID

				)  k on c.commentID=k.parentID
	</cfif>
	where c.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/>
	and c.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	<cfif arguments.filterByParentID>
	and c.parentID <cfif len(arguments.parentID)>=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/><cfelse>is null</cfif>
	</cfif>
	<cfif not arguments.isEditor>
	and c.isApproved=1
	</cfif>
	<cfif not arguments.includeSpam>
	and  c.isSpam=0
	</cfif>
	<cfif not arguments.includeDeleted>
	and c.isDeleted=0
	</cfif>
	order by c.entered #arguments.sortOrder#
	</cfquery>

	<cfreturn rsComments />
</cffunction>

<cffunction name="readRecentComments" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="size" type="numeric" required="true" default="5">
	<cfargument name="approvedOnly" type="boolean" required="true" default="true">
	<cfargument name="includeSpam" type="boolean" required="true" default="false">
	<cfargument name="includeDeleted" type="boolean" required="true" default="false">

	<cfset var rsRecentComments= ''/>
	<cfset var dbType=variables.configBean.getDbType() />

	<cfquery name="rsRecentComments">
	<cfif dbType eq "oracle" and arguments.size>select * from (</cfif>
	select
	<cfif dbType eq "mssql" and arguments.size>Top #val(arguments.size)#</cfif>
	c.contentid, c.commentid, c.parentid, c.name, c.email, c.url, c.comments, c.entered, c.siteid, c.isApproved, c.subscribe, c.userID, c.path,
	f.fileid, f.fileExt
	from tcontentcomments c
	left join tusers u on c.userid=u.userid
	left join tfiles f on u.photofileid=f.fileid
	where c.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	<cfif arguments.approvedOnly>
	and approved=1
	</cfif>
	<cfif not arguments.includeSpam>
	and isSpam=0
	</cfif>
	<cfif not arguments.includeDeleted>
	and isDeleted=0
	</cfif>
	order by entered desc
	<cfif dbType eq "nuodb" and arguments.size>fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.size#" /></cfif>
	<cfif listFindNoCase("mysql,postgresql", dbType) and arguments.size>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.size#" /></cfif>
	<cfif dbType eq "oracle" and arguments.size>) where ROWNUM <=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.size#" /> </cfif>
	</cfquery>

	<cfreturn rsRecentComments />
</cffunction>

<cffunction name="getCommentCount" output="false">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="includeSpam" type="boolean" required="true" default="false">
	<cfargument name="includeDeleted" type="boolean" required="true" default="false">
	<cfset var rs= ''/>

	<cfquery name="rs">
		select count(*) TotalComments from tcontentcomments where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		<cfif not arguments.isEditor>
			and isApproved=1
		</cfif>
		<cfif not arguments.includeSpam>
			and isSpam = 0
		</cfif>
		<cfif not arguments.includeDeleted>
			and isDeleted = 0
		</cfif>
	</cfquery>

	<cfreturn rs.TotalComments />
</cffunction>

<cffunction name="getCommentSubscribers" output="false">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfset var rsCommentSubscribers= ''/>

	<cfquery name="rsCommentSubscribers">
	select distinct email from tcontentcomments
	where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and email is not null
	and isApproved=1
	and subscribe=1
	and isSpam=0
	and isDeleted=0
	</cfquery>

	<cfreturn rsCommentSubscribers />
</cffunction>

<cffunction name="renderActiveClause" output="true">
<cfargument name="table" default="tcontent">
<cfargument name="siteID">
	<cfset var previewData="">
	<cfset var sessionData=getSession()>
	<cfoutput>
		<cfif isDefined('sessionData.mura')>
			<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
		</cfif>
		<cfif isStruct(previewData) and previewData.siteID eq arguments.siteid and isDefined('previewData.contentIDList') and len(previewData.contentIDList)>
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
	</cfoutput>
</cffunction>

<cffunction name="getExpireAssignments" output="false">
<cfargument name="contenthistid">
<cfset var rs="">
<cfquery name="rs">
    select userID from tcontentassignments
	where contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#">
	and type='expire'
</cfquery>
<cfreturn rs>
</cffunction>


<cffunction name="deleteOldSourceMaps" output="false">
	<cfargument name="contentid">
	<cfargument name="siteid">

	<cfquery>
    delete from tcontentsourcemaps
	where
	contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#">
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
	and (
			created < (select min(lastupdate) from tcontent
					where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#">
					and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
				)
			or contentid not in (select distinct contentid from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">)
		)

	</cfquery>

</cffunction>

<cffunction name="deleteVersionedObjects" output="false">
	<cfargument name="contenthistid">
	<cfargument name="contentid">
	<cfargument name="siteid">

	<cfset var it="">
	<cfset var i="">
	<cfset var bean="">

	<cfif len(application.objectMappings.versionedBeans)>
		<cfloop list="#application.objectMappings.versionedBeans#" index="i">
			<cfif structKeyExists(arguments, "contentid")>
				<cfset it=getBean(i).loadBy(contentid=arguments.contentid,siteid=arguments.siteid,returnformat='iterator')>
			<cfelse>
				<cfset it=getBean(i).loadBy(contenthistid=arguments.contenthistid,returnformat='iterator')>
			</cfif>

			<cfloop condition="it.hasNext()">
				<cfset bean=it.next()>
				<cfif not bean.getIsNew()>
					<cfset bean.delete()>
				</cfif>
			</cfloop>

		</cfloop>
	</cfif>

</cffunction>


<cffunction name="persistVersionedObjects" output="false">
	<cfargument name="version1">
	<cfargument name="version2">
	<cfargument name="removeObjects">
	<cfargument name="addObjects">
	<cfargument name="$">

	<cfset var it="">
	<cfset var i="">
	<cfset var bean="">
	<cfset var remove=false>
	<cfset var ro="">

	<cfif len(application.objectMappings.versionedBeans)>
		<cfloop list="#application.objectMappings.versionedBeans#" index="i">

			<cfset it=getBean(i).loadBy(contenthistid=arguments.version1.getContentHistID(),returnformat='iterator')>

			<cfloop condition="it.hasNext()">
				<cfset bean=it.next()>

				<!--- Do not persist objects that have been removed. --->
				<cfset remove=false>

				<cfif arrayLen(arguments.removeObjects)>
					<cfloop array="#arguments.removeObjects#" index="ro">
						<cfif ro.getValue(ro.getPrimaryKey()) eq bean.getValue(bean.getPrimaryKey())>
							<cfset remove=true>
						</cfif>
					</cfloop>
				</cfif>

				<cfif not remove and arrayLen(arguments.addObjects)>
					<cfloop array="#arguments.addObjects#" index="ro">
						<cfif ro.getValue(ro.getPrimaryKey()) eq bean.getValue(bean.getPrimaryKey())>
							<cfset remove=true>
						</cfif>
					</cfloop>
				</cfif>

				<cfif not remove and not bean.getIsNew()>
					<cfif bean.persistToVersion(previousBean=arguments.version1,newBean=arguments.version2,version1=arguments.version1,version2=arguments.version2,$=arguments.$)>
						<cfset bean.setContentHistID(arguments.version2.getContentHistID())>
						<cfset bean.setValue(bean.getPrimaryKey(),createUUID())>
						<cfset bean.save()>
					</cfif>
				</cfif>
			</cfloop>

		</cfloop>
	</cfif>

</cffunction>

</cfcomponent>
