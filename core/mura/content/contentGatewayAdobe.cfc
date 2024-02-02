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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides content gateway queries">

<cffunction name="init" output="true">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="contentIntervalManager" type="any" required="yes"/>
<cfargument name="permUtility" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.contentIntervalManager=arguments.contentIntervalManager>
		<cfset variables.permUtility=arguments.permUtility>
		<cfset variables.utility=arguments.utility>
		<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
<cfreturn this >
</cffunction>

<cffunction name="getCrumblist" output="false">
		<cfargument name="contentid" required="true" default="">
		<cfargument name="siteid" required="true" default="">
		<cfargument name="setInheritance" required="true" type="boolean" default="false">
		<cfargument name="path" required="true" default="">
		<cfargument name="useCache" required="true" default="true">

		<cfset var I=0>
		<cfset var crumbdata="">
		<cfset var key="crumb" & arguments.siteid & arguments.contentID />
		<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
		<cfset var cacheFactory=site.getCacheFactory()>

		<cfif arguments.setInheritance>
			<cfset request.inheritedObjects="">
		</cfif>

		<cfif site.getCache()>
			<!--- check to see if it is cached. if not then pass in the context --->
			<!--- otherwise grab it from the cache --->

			<cfif NOT arguments.useCache or NOT cacheFactory.has( key )>
				<cfset crumbdata=buildCrumblist(contentid=arguments.contentID,siteid=arguments.siteID,path=arguments.path) />
				<cfif arrayLen(crumbdata) and arrayLen(crumbdata) lt 50>
					<cfset crumbdata=cacheFactory.get( key, crumbdata ) />
				</cfif>
			<cfelse>
				<cftry>
					<cfset crumbdata=cacheFactory.get( key ) />

					<cfif not isArray(crumbdata)>
						<cfset crumbdata=buildCrumblist(contentid=arguments.contentID,siteid=arguments.siteID,path=arguments.path) />
						<cfif arrayLen(crumbdata) and arrayLen(crumbdata) lt 50>
							<cfset crumbdata=cacheFactory.get( key, crumbdata ) />
						</cfif>
					</cfif>

					<cfcatch>
						<cfset crumbdata=buildCrumblist(contentid=arguments.contentID,siteid=arguments.siteID,path=arguments.path) />
						<cfif arrayLen(crumbdata) and arrayLen(crumbdata) lt 50>
							<cfset crumbdata=cacheFactory.get( key, crumbdata ) />
						</cfif>
					</cfcatch>
				</cftry>
			</cfif>
		</cfif>

		<cfif not isDefined('crumbdata') or isSimpleValue(crumbdata) >
			<cfset crumbdata=buildCrumblist(contentid=arguments.contentID,siteid=arguments.siteID,path=arguments.path)/>
			<cfif site.getCache() and arrayLen(crumbdata) and arrayLen(crumbdata) lt 50>
				<cfset cacheFactory.get( key, crumbdata ) />
			</cfif>
		</cfif>

		<cfif arguments.setInheritance>
			<cfloop from="1" to="#arrayLen(crumbdata)#" index="I">
				<cfif crumbdata[I].inheritObjects eq 'cascade'>
					<cfset request.inheritedObjects=crumbdata[I].contenthistid>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn crumbdata>
</cffunction>

<cffunction name="buildCrumblist" returntype="array" output="false">
		<cfargument name="contentid" required="true" default="">
		<cfargument name="siteid" required="true" default="">
		<cfargument name="path" required="true" default="">

		<cfset var ID=arguments.contentid>
		<cfset var I=0>
		<cfset var rsCrumbData = "" />
		<cfset var crumbdata=arraynew(1) />
		<cfset var crumb= ""/>
		<cfset var parentArray=arraynew(1) />

		<cfif not len(arguments.path)>
			<cftry>

			<cfloop condition="ID neq '00000000000000000000000000000000END'">

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCrumbData')#">
			select tcontent.contenthistid, tcontent.contentid,tcontent.title, tcontent.menutitle,tcontent.urltitle, tcontent.filename, tcontent.parentid, tcontent.type,
			tcontent.subtype, tcontent.target, tcontent.targetParams,
			tcontent.siteid, tcontent.restricted, tcontent.restrictgroups,tcontent.template,tcontent.childTemplate,tcontent.inheritObjects,tcontent.metadesc,tcontent.metakeywords,tcontent.sortBy,
			tcontent.sortDirection,tfiles.fileExt,tapprovalassignments.chainID,tapprovalassignments.exemptID,tcontent.moduleid
			from tcontent
			left join tfiles on(tcontent.fileID=tfiles.fileID)
			left join tapprovalassignments on (tcontent.contentid=tapprovalassignments.contentid
											and tcontent.siteID=tapprovalassignments.siteID)
			where tcontent.active=1
			and tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ID#"/>
			and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
			</cfquery>


			<cfif not rsCrumbData.recordcount>
				<cfbreak>
			</cfif>

			<cfset crumb=structNew() />
			<cfset crumb.type=rsCrumbData.type />
			<cfset crumb.subtype=rsCrumbData.subtype />
			<cfset crumb.filename=rsCrumbData.filename />
			<cfset crumb.title=rsCrumbData.title />
			<cfif len(rsCrumbData.menutitle)>
				<cfset crumb.menutitle=rsCrumbData.menutitle />
			<cfelse>
				<cfset crumb.menutitle=rsCrumbData.title />
			</cfif>
			<cfset crumb.urltitle=rsCrumbData.urltitle />
			<cfset crumb.target=rsCrumbData.target />
			<cfset crumb.contentid=rsCrumbData.contentid />
			<cfset crumb.parentid=rsCrumbData.parentid />
			<cfset crumb.siteid=rsCrumbData.siteid />
			<cfset crumb.restricted=rsCrumbData.restricted />
			<cfset crumb.restrictGroups=rsCrumbData.restrictgroups />
			<cfif len(rsCrumbData.childTemplate)>
				<cfset crumb.template=rsCrumbData.childTemplate />
			<cfelse>
				<cfset crumb.template=rsCrumbData.template />
			</cfif>
			<cfset crumb.contenthistid=rsCrumbData.contenthistid />
			<cfset crumb.targetPrams=rsCrumbData.targetParams />
			<cfset crumb.metadesc=rsCrumbData.metadesc />
			<cfset crumb.metakeywords=rsCrumbData.metakeywords />
			<cfset crumb.sortBy=rsCrumbData.sortBy />
			<cfset crumb.sortDirection=rsCrumbData.sortDirection />
			<cfset crumb.inheritObjects=rsCrumbData.inheritObjects />
			<cfset crumb.fileExt=rsCrumbData.fileExt />
			<cfset crumb.chainID=rsCrumbData.chainID />
			<cfset crumb.exemptID=rsCrumbData.exemptID />
			<cfset crumb.moduleid=rsCrumbData.moduleid />

			<cfset I=I+1>
			<cfset arrayAppend(crumbdata,crumb) />
			<cfset arrayAppend(parentArray,rsCrumbData.contentid) />

			<cfset ID=rsCrumbData.parentid>

			<cfif I gt 50><cfthrow  type="custom" message="Crumdata Loop Error"></cfif>
			</cfloop>

			<cfif arrayLen(crumbdata)>
				<cfset crumbdata[1].parentArray=parentArray />
			</cfif>

			<cfcatch type="custom"></cfcatch>
			</cftry>

			<cfelse>

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCrumbData')#">
			select tcontent.contenthistid, tcontent.contentid,tcontent.title, tcontent.menutitle,tcontent.urltitle, tcontent.filename, tcontent.parentid, tcontent.type,
			tcontent.subtype, tcontent.target, tcontent.targetParams,
			tcontent.siteid, tcontent.restricted, tcontent.restrictgroups,tcontent.template,tcontent.childTemplate,tcontent.inheritObjects,tcontent.metadesc,tcontent.metakeywords,tcontent.sortBy,
			tcontent.sortDirection,tapprovalassignments.chainID,
			<cfif variables.configBean.getDBType() eq "MSSQL">
			len(Cast(tcontent.path as varchar(1000))) depth
			<cfelseif variables.configBean.getDBType() eq "NUODB">
			char_length(tcontent.path) depth
			<cfelse>
			length(tcontent.path) depth
			</cfif>
			,tfiles.fileExt,tapprovalassignments.exemptID,tcontent.moduleid

			from tcontent
			left join tfiles on(tcontent.fileID=tfiles.fileID)
			left join tapprovalassignments on (tcontent.contentid=tapprovalassignments.contentid
											and tcontent.siteID=tapprovalassignments.siteID)
			where
			tcontent.contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.path#">)
			and tcontent.active=1
			and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
			order by depth desc
			</cfquery>

			<cfloop query="rsCrumbData">
			<cfset crumb=structNew() />
			<cfset crumb.type=rsCrumbData.type />
			<cfset crumb.subtype=rsCrumbData.subtype />
			<cfset crumb.filename=rsCrumbData.filename />
			<cfset crumb.title=rsCrumbData.title />
			<cfset crumb.menutitle=rsCrumbData.menutitle />
			<cfset crumb.urltitle=rsCrumbData.urltitle />
			<cfset crumb.target=rsCrumbData.target />
			<cfset crumb.contentid=rsCrumbData.contentid />
			<cfset crumb.parentid=rsCrumbData.parentid />
			<cfset crumb.siteid=rsCrumbData.siteid />
			<cfset crumb.restricted=rsCrumbData.restricted />
			<cfset crumb.restrictGroups=rsCrumbData.restrictgroups />
			<cfif len(rsCrumbData.childtemplate)>
				<cfset crumb.template=rsCrumbData.childtemplate />
			<cfelse>
				<cfset crumb.template=rsCrumbData.template />
			</cfif>
			<cfset crumb.contenthistid=rsCrumbData.contenthistid />
			<cfset crumb.targetPrams=rsCrumbData.targetParams />
			<cfset crumb.metadesc=rsCrumbData.metadesc />
			<cfset crumb.metakeywords=rsCrumbData.metakeywords />
			<cfset crumb.sortBy=rsCrumbData.sortBy />
			<cfset crumb.sortDirection=rsCrumbData.sortDirection />
			<cfset crumb.inheritObjects=rsCrumbData.inheritObjects />
			<cfset crumb.fileExt=rsCrumbData.fileExt />
			<cfset crumb.chainID=rsCrumbData.chainID />
			<cfset crumb.exemptID=rsCrumbData.exemptID />
			<cfset crumb.moduleid=rsCrumbData.moduleid />

			<cfset arrayAppend(crumbdata,crumb) />
			<cfset arrayAppend(parentArray,rsCrumbData.contentid) />

			</cfloop>

			<cfif arrayLen(crumbdata)>
				<cfset crumbdata[1].parentArray=parentArray />
			</cfif>

			</cfif>

			<cfreturn crumbdata/>

</cffunction>

<cffunction name="getContentIDFromContentHistID" output="false">
	<cfargument name="contenthistid" required="true" default="">
	<cfset var rsContentIDFromHistID="">
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContentIDFromHistID')#">
		select contentID from tcontent where contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistid#">
	</cfquery>
	<cfreturn rsContentIDFromHistID.contentID>
</cffunction>

<cffunction name="getContentHistIDFromContentID" output="false">
	<cfargument name="contentID" required="true" default="">
	<cfargument name="siteID" required="true" default="">
	<cfset var rsHistIDFromContentID="">
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsHistIDFromContentID')#">
		select contentHistID from tcontent where

		<cfif isValid("UUID",arguments.contentID)>
			contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
			#getBean('contentDAO').renderActiveClause("tcontent",arguments.siteID)#
			and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
		<cfelse>
			siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
			and title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
			#renderActiveClause("tcontent",arguments.siteID)#
		</cfif>
	</cfquery>
	<cfreturn rsHistIDFromContentID.contentHistID>
</cffunction>

<cffunction name="getKidsIterator" output="false">
			<cfargument name="moduleid" type="string" required="true" default="00000000000000000000000000000000000">
			<cfargument name="siteid" type="string">
			<cfargument name="parentid" type="string" >
			<cfargument name="type" type="string"  default="default">
			<cfargument name="today" type="date"  default="#now()#">
			<cfargument name="size" type="numeric" default=100>
			<cfargument name="keywords" type="string"  default="">
			<cfargument name="hasFeatures" type="numeric"  default=0>
			<cfargument name="sortBy" type="string" default="orderno" >
			<cfargument name="sortDirection" type="string" default="asc" >
			<cfargument name="categoryID" type="string" required="yes" default="" >
			<cfargument name="relatedID" type="string" required="yes" default="" >
			<cfargument name="tag" type="string" required="yes" default="" >
			<cfargument name="aggregation" type="boolean" required="yes" default="false" >
			<cfargument name="applyPermFilter" type="boolean" required="yes" default="false" >
			<cfargument name="taggroup" type="string" required="yes" default="" >
			<cfargument name="useCategoryIntersect" default="false">

			<cfset var rs = getKids(arguments.moduleID, arguments.siteid, arguments.parentID, arguments.type, arguments.today, arguments.size, arguments.keywords, arguments.hasFeatures, arguments.sortBy, arguments.sortDirection, arguments.categoryID, arguments.relatedID, arguments.tag, arguments.aggregation,arguments.applyPermFilter,arguments.taggroup,arguments.useCategoryIntersect)>
			<cfset var it = getBean("contentIterator")>
			<cfset it.setQuery(rs)>
			<cfreturn it/>
</cffunction>

<cffunction name="getKids" output="false">
			<cfargument name="moduleid" type="string" required="true" default="00000000000000000000000000000000000">
			<cfargument name="siteid" type="string">
			<cfargument name="parentid" type="string" >
			<cfargument name="type" type="string"  default="default">
			<cfargument name="today" type="date"  default="#now()#">
			<cfargument name="size" type="numeric" default=100>
			<cfargument name="keywords" type="string"  default="">
			<cfargument name="hasFeatures" type="numeric"  default=0>
			<cfargument name="sortBy" type="string" default="orderno" >
			<cfargument name="sortDirection" type="string" default="asc" >
			<cfargument name="categoryID" type="string" required="yes" default="" >
			<cfargument name="relatedID" type="string" required="yes" default="" >
			<cfargument name="tag" type="string" required="yes" default="" >
			<cfargument name="aggregation" type="boolean" required="yes" default="false" >
			<cfargument name="applyPermFilter" type="boolean" required="yes" default="false" >
			<cfargument name="tagGroup" type="string" required="yes" default="" >
			<cfargument name="useCategoryIntersect" default="false">
			<cfset var rsKids = ""/>
			<cfset var relatedListLen = listLen(arguments.relatedID) />
			<cfset var categoryListLen=listLen(arguments.categoryID)/>
			<cfset var c = ""/>
			<cfset var f = ""/>
			<cfset var doKids =false />
			<cfset var dbType=variables.configBean.getDbType() />
			<cfset var alpha="a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1,l1,m1,n1,o1,p1,q1,r1,s1,t1,u1,v1,w1,x1,y1,z1">
			<cfset var sortOptions="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,rating,comment,credits,type,subtype">
			<cfset var isExtendedSort=(not listFindNoCase(sortOptions,arguments.sortBy))>
			<cfset var nowAdjusted="">
			<cfset var tableModifier="">
			<cfset var altTable=variables.configBean.getContentGatewayTable()>
			<cfset var castfield="attributeValue">
			<cfset var palias="">
			<cfset var talias="">

			<cfif altTable eq 'tcontent'>
				<cfset altTable=''>
			</cfif>

			<cfif not listFindNoCase('asc,desc',arguments.sortDirection)>
				<cfset arguments.sortDirection='asc'>
			</cfif>

			<cfif dbtype eq "MSSQL">
				<cfset tableModifier="with (nolock)">
			</cfif>

			<cfif request.muraChangesetPreview and isStruct(getCurrentUser().getValue("ChangesetPreviewData"))>
				<cfset nowAdjusted=getCurrentUser().getValue("ChangesetPreviewData").publishDate>
			</cfif>

			<cfif isDate(request.muraPointInTime)>
				<cfset nowAdjusted=request.muraPointInTime>
			</cfif>

			<cfif not isdate(nowAdjusted)>
				<cfset nowAdjusted=arguments.today>
			</cfif>

			<cfif arguments.type eq 'default'>
				<cfset nowAdjusted=variables.utility.datetimeToTimespanInterval(nowAdjusted,createTimespan(0,0,5,0))>
			</cfif>

			<cfif arguments.aggregation >
				<cfset doKids =true />
			</cfif>

			<cfif arguments.sortby eq 'mxpRelevance' and not doKids>
				<cfif not isDefined('session.mura.mxp')>
					<cfset session.mura.mxp=getBean('marketingManager').getDefaults()>
				</cfif>
				<cfparam name="session.mura.mxp.trackingProperties.personaid" default=''>
				<cfparam name="session.mura.mxp.trackingProperties.stageid" default=''>

				<cfset var personaid=session.mura.mxp.trackingProperties.personaid>
				<cfset var stageid=session.mura.mxp.trackingProperties.stageid>

				<cfif isDefined('url.personaid')>
					<cfset personaid=url.personaid>
					<cfset stageid=''>
				</cfif>

				<cfif isDefined('form.personaid')>
					<cfset personaid=form.personaid>
					<cfset stageid=''>
				</cfif>

				<cfset var mxpRelevanceSort=true>
			<cfelse>
				<cfset var personaid="">
				<cfset var stageid="">
				<cfset var mxpRelevanceSort=false>
			</cfif>

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsKids')#">
				<cfif dbType eq "oracle" and arguments.size>select * from (</cfif>
				SELECT <cfif dbType eq "mssql" and arguments.size>Top #val(arguments.size)#</cfif>

				<cfif len(altTable)>
				tcontent.*
				<cfelse>
				tcontent.title, tcontent.releasedate, tcontent.menuTitle, tcontent.lastupdate,tcontent.summary, tcontent.tags,tcontent.filename, tcontent.type,tcontent.subType, tcontent.siteid,
				tcontent.contentid, tcontent.contentHistID, tcontent.target, tcontent.targetParams,
				tcontent.restricted, tcontent.restrictgroups, tcontent.displaystart, tcontent.displaystop, tcontent.orderno,tcontent.sortBy,tcontent.sortDirection,
				tcontent.fileid, tcontent.credits, tcontent.remoteSource, tcontent.remoteSourceURL, tcontent.remoteURL,
				tfiles.fileSize,tfiles.fileExt, tcontent.audience, tcontent.keypoints
				,tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes
				,tcontentstats.comments, '' as parentType, <cfif doKids> qKids.kids<cfelse>null as kids</cfif>,tcontent.path, tcontent.created, tcontent.nextn,
				tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,
				tfiles.filename as AssocFilename,tcontent.displayInterval,tcontent.display,tcontentfilemetadata.altText as fileAltText,tcontent.changesetid
				</cfif>

				<cfif mxpRelevanceSort>
				,tracktotal.track_total_score as total_score, (<cfif len(stageid)>stagetotal.stage_points + </cfif>personatotal.persona_points) as total_points
				</cfif>
				FROM <cfif len(altTable)>#alttable#</cfif> tcontent #tableModifier#

				<cfif not len(altTable)>
					Left Join tfiles #tableModifier# ON (tcontent.fileID=tfiles.fileID)
					left Join tcontentstats #tableModifier# on (tcontent.contentid=tcontentstats.contentid
						and tcontent.siteid=tcontentstats.siteid)
					Left Join tcontentfilemetadata #tableModifier# on (tcontent.fileid=tcontentfilemetadata.fileid
						and tcontent.contenthistid=tcontentfilemetadata.contenthistid
						and tcontent.siteid=tcontentfilemetadata.siteid)
				</cfif>

				<cfif mxpRelevanceSort>
					left join (
						select sum(persona.points) persona_points, persona.contenthistid
						from mxp_personapoints persona
						where persona.personaid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#personaid#">
						group by persona.contenthistid
					) personatotal on (tcontent.contenthistid = personatotal.contenthistid)

					<cfif len(stageid)>
						left join (
							select sum(stage.points) stage_points, stage.contenthistid
							from mxp_stagepoints stage
							where stage.stageid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stageid#">
							group by stage.contenthistid
						) stagetotal on (tcontent.contenthistid = stagetotal.contenthistid)
					</cfif>

					left join (
						select sum(track.points) track_total_score, track.contentid
						from mxp_conversiontrack track
						where track.created >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#dateAdd('m',-1,nowAdjusted)#">
						and track.points > 0
						group by track.contentid
					) tracktotal on (tcontent.contentid=tracktotal.contentid)
				</cfif>

				<cfif isExtendedSort>
					left Join (select
							#variables.classExtensionManager.getCastString(arguments.sortBy,arguments.siteID)# extendedSort
							 ,tclassextenddata.baseID
							from tclassextenddata #tableModifier# inner join tclassextendattributes #tableModifier#
							on (tclassextenddata.attributeID=tclassextendattributes.attributeID)
							where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
							and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sortBy#">
					) qExtendedSort
					on (tcontent.contenthistid=qExtendedSort.baseID)
				</cfif>

				<!--- begin qKids --->
				<cfif doKids>
					Left Join (select
							   tcontent.contentID,
							   Count(TKids.contentID) as kids
							   from tcontent #tableModifier#
							   left join tcontent TKids #tableModifier#
							   on (tcontent.contentID=TKids.parentID
							   		and tcontent.siteID=TKids.siteID)

							   	<cfif len(arguments.tag)>
								Inner Join tcontenttags #tableModifier# on (tcontent.contentHistID=tcontenttags.contentHistID)
								</cfif>

							   where tcontent.siteid='#arguments.siteid#'
							   		AND tcontent.parentid =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
							      	#renderActiveClause("tcontent",arguments.siteID)#
								    AND tcontent.isNav = 1
								    #renderActiveClause("TKids",arguments.siteID)#
								    AND TKids.isNav = 1
								    AND tcontent.moduleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleid#"/>

									<cfif arguments.keywords neq ''>
									  	AND (UPPER(tcontent.body) like UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"/>)
									  		OR UPPER(tcontent.title) like UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"/>))
									</cfif>

									AND (
									 	#renderMenuTypeClause(arguments.type,nowAdjusted)#
									 	)

									<cfif len(arguments.tag)>
										and tcontenttags.tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#"/>
									</cfif>

									<cfif relatedListLen >
									  and tcontent.contentID in (
											select relatedID from tcontentrelated #tableModifier#
											where contentID in
											(<cfloop from=1 to="#relatedListLen#" index="f">
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.relatedID,f)#"/>
											<cfif f lt relatedListLen >,</cfif>
											</cfloop>)
											and siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
										)
									 </cfif>

									<cfif arguments.hasFeatures and not categoryListLen>
										AND
											(
												tcontent.isFeature = 1

												OR

												(	tcontent.isFeature = 2
													AND tcontent.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
													AND (tcontent.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or tcontent.FeatureStop is null)
												)
											)
									</cfif>

									<cfif categoryListLen>
										<cfif arguments.useCategoryIntersect>
										AND tcontent.contentHistID in (
											select a.contentHistID from tcontentcategoryassign a
											<cfif categoryListLen gt 1>
												<cfloop from="2" to="#categoryListLen#" index="c">
													<cfset palias = listGetAt(alpha,c-1)>
													<cfset talias = listGetAt(alpha,c)>
													inner join tcontentcategoryassign #talias# #tableModifier# on
														(
															#palias#.contentHistID = #talias#.contentHistID
															and #talias#.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.categoryID,c)#"/>
															<cfif arguments.hasFeatures>
															AND
																(
																	#talias#.isFeature = 1
																OR

																	(	#talias#.isFeature = 2
																		AND #talias#.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
																		AND (#talias#.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or #talias#.FeatureStop is null)
																	)

																)
															</cfif>
														)
												</cfloop>
											</cfif>
											where a.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.categoryID,1)#"/>

											<cfif arguments.hasFeatures>
											AND
												(
													a.isFeature = 1
												OR

													(	a.isFeature = 2
														AND a.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
														AND (a.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or a.FeatureStop is null)
													)

												)
											</cfif>
										)
									<cfelse>
										AND tcontent.contenthistID in (
											select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign #tableModifier#
											inner join tcontentcategories #tableModifier#
											ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
											where (<cfloop from="1" to="#categoryListLen#" index="c">
													tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.categoryID,c)#%"/>
													<cfif c lt categoryListLen> or </cfif>
													</cfloop>)
											<cfif arguments.hasFeatures>
											AND
												(
													tcontentcategoryassign.isFeature = 1
												OR

													(	tcontentcategoryassign.isFeature = 2
														AND tcontentcategoryassign.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
														AND (tcontentcategoryassign.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or tcontentcategoryassign.FeatureStop is null)
													)

												)
											</cfif>
										)
									</cfif>
								</cfif>

								group by tcontent.contentID

							   ) qKids

					on (tcontent.contentID=qKids.contentID)
				</cfif>
				<!--- end QKids --->

				<cfif len(arguments.tag)>
					Inner Join tcontenttags #tableModifier# on (tcontent.contentHistID=tcontenttags.contentHistID)
				</cfif>

				WHERE
				    tcontent.parentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
					#renderActiveClause("tcontent",arguments.siteID)#
					AND tcontent.isNav = 1
					AND tcontent.moduleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#"/>
					AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>

					<cfif arguments.keywords neq ''>
					  	AND
					  	(UPPER(tcontent.body) like UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"/>)
					  		OR UPPER(tcontent.title) like UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"/>))
					</cfif>

					AND (
					   	#renderMenuTypeClause(arguments.type,nowAdjusted)#
		  				)

					<cfif len(arguments.tag)>
						and (
								tcontenttags.tag in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.tag#"/> )
								<cfif len(arguments.tagGroup) and arguments.tagGroup neq 'default'>
									and tcontenttags.taggroup=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.taggroup#"/>
								</cfif>
							)
					</cfif>

					<cfif relatedListLen >
					  	and tcontent.contentID in (
							select relatedID from tcontentrelated #tableModifier#
							where contentID in
							(<cfloop from=1 to="#relatedListLen#" index="f">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.relatedID,f)#"/>
							<cfif f lt relatedListLen >,</cfif>
							</cfloop>)
							and siteID='#arguments.siteid#'
						)
					 </cfif>


					<cfif arguments.hasFeatures and not categoryListLen>
						AND
							(
								tcontent.isFeature = 1

								OR

								(	tcontent.isFeature = 2
									AND tcontent.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
									AND (tcontent.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or tcontent.FeatureStop is null)
								)
							)
					</cfif>

					<cfif categoryListLen>
						<cfif arguments.useCategoryIntersect>
						AND tcontent.contentHistID in (
							select a.contentHistID from tcontentcategoryassign a #tableModifier#
							<cfif categoryListLen gt 1>
								<cfloop from="2" to="#categoryListLen#" index="c">
									<cfset palias = listGetAt(alpha,c-1)>
									<cfset talias = listGetAt(alpha,c)>
									inner join tcontentcategoryassign #talias# #tableModifier# on
										(
											#palias#.contentHistID = #talias#.contentHistID
											and #talias#.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.categoryID,c)#"/>
											<cfif arguments.hasFeatures>
											AND
												(
													#talias#.isFeature = 1
												OR

													(	#talias#.isFeature = 2
														AND #talias#.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
														AND (#talias#.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or #talias#.FeatureStop is null)
													)

												)
											</cfif>
										)
								</cfloop>
							</cfif>
							where a.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.categoryID,1)#"/>

							<cfif arguments.hasFeatures>
							AND
								(
									a.isFeature = 1
								OR

									(	a.isFeature = 2
										AND a.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
										AND (a.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or a.FeatureStop is null)
									)

								)
							</cfif>
						)
					<cfelse>
						AND tcontent.contenthistID in (
							select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign #tableModifier#
							inner join tcontentcategories #tableModifier#
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
							where (<cfloop from="1" to="#categoryListLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.categoryID,c)#%"/>
									<cfif c lt categoryListLen> or </cfif>
									</cfloop>)
							<cfif arguments.hasFeatures>
							AND
								(
									tcontentcategoryassign.isFeature = 1
								OR

									(	tcontentcategoryassign.isFeature = 2
										AND tcontentcategoryassign.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
										AND (tcontentcategoryassign.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or tcontentcategoryassign.FeatureStop is null)
									)

								)
							</cfif>
						)
					</cfif>
				</cfif>


				#renderMobileClause()#

				order by

				<cfswitch expression="#arguments.sortBy#">
					<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displaystart,displaystop,created,tcontent.credits,type,subtype">
						<cfif dbType neq "oracle" or  listFindNoCase("orderno,lastUpdate,releaseDate,created,displayStart,displayStop",arguments.sortBy)>
						tcontent.#arguments.sortBy# #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#
						<cfelse>
						lower(tcontent.#arguments.sortBy#) #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#
						</cfif>
					</cfcase>
					<cfcase value="rating">
						tcontentstats.rating #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#, tcontentstats.totalVotes  #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#
					</cfcase>
					<cfcase value="comments">
						tcontentstats.comments #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#
					</cfcase>
					<cfdefaultcase>
						<cfif mxpRelevanceSort>
							total_points #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")# , total_score #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#, tcontent.releaseDate #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#,tcontent.lastUpdate #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#
						<cfelseif isExtendedSort>
							qExtendedSort.extendedSort #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#
						<cfelse>
							tcontent.releaseDate desc,tcontent.lastUpdate desc,tcontent.menutitle
						</cfif>
					</cfdefaultcase>
				</cfswitch>

				<cfif listFindNoCase("oracle,postgresql", dbType)>
					<cfif arguments.sortDirection eq "asc">
						NULLS FIRST
					<cfelse>
						NULLS LAST
					</cfif>
				</cfif>

				<cfif listFindNoCase("mysql,postgresql", dbType) and arguments.size>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.size#" /></cfif>
				<cfif dbType eq "nuodb" and arguments.size>fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.size#" /></cfif>
				<cfif dbType eq "oracle" and arguments.size>) where ROWNUM <=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.size#" /> </cfif>

		</cfquery>

		<cfif arguments.applyPermFilter>
			<cfset rsKids=variables.permUtility.queryPermFilter(rawQuery=rsKids,siteID=arguments.siteID)>
		</cfif>

		<cfreturn variables.contentIntervalManager.applyByMenuTypeAndDate(query=rsKids,menuType=arguments.type,menuDate=nowAdjusted) />
</cffunction>

<cffunction name="getKidsCategorySummary" output="false">
		<cfargument name="siteid" type="string">
		<cfargument name="parentid" type="string" >
		<cfargument name="relatedID" type="string" required="yes" default="">
		<cfargument name="today" type="date" required="yes" default="#now()#">
		<cfargument name="menutype" type="string" required="true" default="">
		<cfargument name="categoryid" type="string" required="yes" default="">
		<cfargument name="categorypathid" type="string" required="yes" default="">

		<cfreturn getCategorySummary(argumentCollection=arguments)>
</cffunction>

<cffunction name="getCategorySummary" output="false">
	<cfargument name="siteid" type="string">
	<cfargument name="parentid" type="string" default="">
	<cfargument name="relatedid" type="string" required="yes" default="">
	<cfargument name="today" type="date" required="yes" default="#now()#">
	<cfargument name="menutype" type="string" required="true" default="">
	<cfargument name="categoryid" type="string" required="yes" default="">
	<cfargument name="categorypathid" type="string" required="yes" default="">

	<cfset var rs= "" />
	<cfset var relatedListLen = listLen(arguments.relatedID) />
	<cfset var f=""/>
	<cfset var c=""/>
	<cfset var nowAdjusted="">

	<cfif request.muraChangesetPreview and isStruct(getCurrentUser().getValue("ChangesetPreviewData"))>
		<cfset nowAdjusted=getCurrentUser().getValue("ChangesetPreviewData").publishDate>
	</cfif>

	<cfif isDate(request.muraPointInTime)>
		<cfset nowAdjusted=request.muraPointInTime>
	</cfif>

	<cfif not isdate(nowAdjusted)>
			<cfset nowAdjusted=arguments.today>
	</cfif>

	<cfset nowAdjusted=variables.utility.datetimeToTimespanInterval(nowAdjusted,createTimespan(0,0,5,0))>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT categoryparent.name parentname, tcontentcategories.parentID, tcontentcategories.categoryID, tcontentcategories.filename, Count(tcontent.contenthistID) as "Count", tcontentcategories.name
			from tcontent
			inner join tcontentcategoryassign
				ON (tcontent.contenthistID=tcontentcategoryassign.contentHistID)
			inner join tcontentcategories
				ON	(tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
			left join tcontentcategories categoryparent
				ON	(tcontentcategories.parentid=categoryparent.categoryID)
			WHERE 1=1
			<cfif len(arguments.parentID)>
				AND tcontent.parentid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.parentid#"/>)
			</cfif>

			#renderActiveClause("tcontent",arguments.siteID)#

			<cfif len(arguments.categorypathid)>
				<cfif len(arguments.categoryid)>
					AND tcontent.contenthistid in (
						select contenthistid from tcontentcategoryassign
						where categoryid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.categoryid#"/>)

					)

				</cfif>
				<cfset var started=false>
			    AND (
						<cfloop list="#arguments.categorypathid#" index="c">
						<cfif started>or</cfif>
						tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#c#%"/>
						<cfset started=true>
						</cfloop>
					)
			<cfelseif len(arguments.categoryid)>
				AND  tcontentcategoryassign.categoryid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.categoryid#"/>
			</cfif>

			  AND tcontent.moduleid = '00000000000000000000000000000000000'
			  AND tcontent.isNav = 1
			  AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
			  AND
			  (
			  	(tcontent.Display = 2
			  <cfif arguments.menuType neq 'Calendar'>
			  AND (tcontent.DisplayStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">)
			  AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or tcontent.DisplayStop is null)
			  	)
			 <cfelse>
			  AND (
			  		(
			  			tcontent.DisplayStart >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
			  			AND tcontent.DisplayStart < <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#dateAdd('m',1,nowAdjusted)#">
			  		)
			  	OR (
			  			tcontent.DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
			  			AND tcontent.DisplayStop < <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#dateAdd('m',1,nowAdjusted)#">
			  		)
			  	   )
			  	  )
			 </cfif>

			  OR
	       		  tcontent.Display = 1
			  )

			#renderMobileClause()#

			 <cfif relatedListLen >
			  and tcontent.contentID in (
					select tcontentrelated.contentID from tcontentrelated
					where
					(<cfloop from=1 to="#relatedListLen#" index="f">
					tcontentrelated.relatedID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.relatedID,f)#"/>
					<cfif f lt relatedListLen > or </cfif>
					</cfloop>)
					and tcontentrelated.siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				)
			 </cfif>

			  group by categoryparent.name, tcontentcategories.parentID, tcontentcategories.name,tcontentcategories.categoryID,tcontentcategories.filename
			  order by <cfif len(arguments.categorypathid)>categoryparent.name asc, tcontentcategories.name asc<cfelse>tcontentcategories.name asc</cfif>
		</cfquery>

		<cfreturn rs>
</cffunction>

<cffunction name="getCommentCount" access="remote" output="false">
			<cfargument name="siteid" type="string">
			<cfargument name="contentID" type="string" >
			<cfargument name="isSpam" type="boolean" default="0">
			<cfargument name="isDeleted" type="boolean" default="0">
			<cfset var rsCommentCount=""/>

			<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCommentCount')#">
				SELECT count(tcontentcomments.contentid) as CommentCount
				FROM tcontentcomments
				WHERE contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
					and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
					and isApproved=1 and isSpam = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isSpam#">
					AND isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.isDeleted#">
			</cfquery>

		 <cfreturn rsCommentCount.CommentCount>
</cffunction>

<cffunction name="getSystemObjects" output="false">
	<cfargument name="siteID"  type="string" />
	<cfset var rsSystemObjects = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsSystemObjects')#">
	select object,name, '' as objectid, orderno from tsystemobjects where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and name !=<cfqueryparam cfsqltype="cf_sql_varchar" value="Dragable Feeds"/>
	order by name
	</cfquery>

	<cfreturn rsSystemObjects />
</cffunction>

<cffunction name="getHasComments" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rsHasComments = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsHasComments')#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='comments'
	</cfquery>

	<cfreturn rsHasComments.theCount />
</cffunction>

<cffunction name="getHasRatings" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rsHasRatings = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsHasRatings')#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='Rater'
	</cfquery>

	<cfreturn rsHasRatings.theCount />
</cffunction>

<cffunction name="getHasTagCloud" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rsHasTagCloud = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsHasTagCloud')#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='tag_cloud'
	</cfquery>

	<cfreturn rsHasTagCloud.theCount />
</cffunction>

<cffunction name="getCount" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contentid"  type="string" />
	<cfset var rsNodeCount = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsNodeCount')#">
	SELECT count(ContentID) as theCount FROM tcontent WHERE
	 ParentID='#arguments.ContentID#'
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and active=1
	 and approved=1
	 and isNav=1
	 and (display=1
	 	 or
	 	 (display=2 AND (DisplayStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#now()#">)
					  AND (DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#now()#"> or tcontent.DisplayStop is null)
		)
		)

	</cfquery>

	<cfreturn rsNodeCount.theCount />
</cffunction>

<cffunction name="getSections" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="type"  type="string" required="true" default="" />
	<cfset var rsSections = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsSections')#">
	select contentid, menutitle, type, siteid, path from tcontent where siteid='#arguments.siteid#' and
	<cfif arguments.type eq ''>
	(type='Folder' or type='Calendar' or type='Gallery')
	<cfelse>
	type= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>
	</cfif>
	and approved=1 and active=1
	</cfquery>

	<cfreturn rsSections />
</cffunction>

<cffunction name="getPageCount" output="false">
	<cfargument name="siteID"  type="string" />
	<cfset var rsPageCount = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPageCount')#">
	SELECT Count(tcontent.ContentID) AS counter
	FROM tcontent
	WHERE Type in ('Page','Folder','File','Calendar','Gallery') and
	 tcontent.active=1 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>

	<cfreturn rsPageCount />
</cffunction>

<cffunction name="getDraftList" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="userID"  type="string"  required="true" default="#getSession().mura.userID#"/>
	<cfargument name="limit" type="numeric" required="true" default="100000000">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	<cfargument name="sortBy" type="string" required="true" default="lastUpdate">
	<cfargument name="sortDirection" type="string" required="true" default="desc">
	<cfset var rsDraftList = "">
	<cfset var rsDraftList1 = "">
	<cfset var rsDraftList2 = "">
	<cfset var rsDraftList3 = "">
	<cfset var rsDraftList4 = "">

	<cfif not listFindNoCase('asc,desc',arguments.sortDirection)>
		<cfset arguments.sortDirection='desc'>
	</cfif>

	<!--- Versions that have been assigned to you by someone else and there is another active version --->
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDraftList1')#">
	SELECT DISTINCT draft.contenthistid, module.Title AS module, active.ModuleID, active.SiteID, active.ParentID, active.Type, active.subtype, active.MenuTitle, active.Filename, active.ContentID,
	 module.SiteID, draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, tcontentstats.lockType, draft.expires
	FROM tcontent active INNER JOIN tcontent draft ON active.ContentID = draft.ContentID
	INNER JOIN tcontent module ON (draft.ModuleID = module.ContentID and draft.siteid = module.siteid)
	INNER JOIN tcontentassignments ON (active.contentID=tcontentassignments.contentID and tcontentassignments.type='draft')
	LEFT join tfiles on active.fileID=tfiles.fileID
	LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID
								and draft.siteID=tcontentstats.siteID
								)
	WHERE
	draft.active=0
	AND draft.approved=0
	AND draft.contenthistid not in ( select contenthistid from tapprovalrequests where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
	AND active.active=1
	AND draft.lastUpdate>active.lastupdate
	and draft.changesetID is null
	and tcontentassignments.userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	<cfif isdate(arguments.stopDate)>and draft.lastUpdate <=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and draft.lastUpdate >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>

	and module.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND draft.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  AND active.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>

	<!--- Versions that have been assigned to you by someone else and the assigned version is the active version --->
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDraftList2')#">
	SELECT DISTINCT draft.contenthistid,module.Title AS module, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subtype, draft.MenuTitle, draft.Filename, draft.ContentID,
	 module.SiteID, draft.SiteID, active.SiteID, draft.targetparams,draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, tcontentstats.lockType, draft.expires
	FROM  tcontent draft INNER JOIN tcontent module ON (draft.ModuleID = module.ContentID and draft.siteid = module.siteid)
		   INNER JOIN tcontentassignments ON (draft.contentID=tcontentassignments.contentID and tcontentassignments.type='draft')
			LEFT JOIN tcontent active ON draft.ContentID = active.ContentID and active.approved=1
			LEFT join tfiles on draft.fileID=tfiles.fileID
			LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID
								and draft.siteID=tcontentstats.siteID
								)
	WHERE
		draft.active=1
		AND draft.approved=0
		AND draft.contenthistid not in ( select contenthistid from tapprovalrequests where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
		and active.contentid is null
		and draft.changesetID is null
		and tcontentassignments.userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
		<cfif isdate(arguments.stopDate)>and draft.lastUpdate <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
		<cfif isdate(arguments.startDate)>and draft.lastUpdate >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>

	and module.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND draft.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>

	<!--- Versions that have been created by you --->
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDraftList3')#">
	SELECT DISTINCT draft.contenthistid, module.Title AS module, active.ModuleID, active.SiteID, active.ParentID, active.Type, active.subtype, active.MenuTitle, active.Filename, active.ContentID,
	 module.SiteID, draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, tcontentstats.lockType, draft.expires
	FROM tcontent active INNER JOIN tcontent draft ON active.ContentID = draft.ContentID
	INNER JOIN tcontent module ON (draft.ModuleID = module.ContentID and draft.siteid = module.siteid)
	LEFT join tfiles on active.fileID=tfiles.fileID
	LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID
								and draft.siteID=tcontentstats.siteID
								)
	WHERE
	draft.active=0
	AND draft.approved=0
	AND draft.contenthistid not in ( select contenthistid from tapprovalrequests where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
	AND active.active=1
	AND draft.lastUpdate>active.lastupdate
	AND draft.changesetID is null
	AND draft.lastUpdateByID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	<cfif isdate(arguments.stopDate)>AND draft.lastUpdate <=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>AND draft.lastUpdate >=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>

	and  module.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  AND draft.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND active.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>

	<!--- Versions that have been created by you and it's the active version --->
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDraftList4')#">
	SELECT DISTINCT draft.contenthistid, module.Title AS module, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subtype, draft.MenuTitle, draft.Filename, draft.ContentID,
	 module.SiteID, draft.SiteID, draft.SiteID, draft.targetparams,draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, tcontentstats.lockType, draft.expires
	FROM  tcontent draft INNER JOIN tcontent module ON (draft.ModuleID = module.ContentID and draft.siteid = module.siteid)
			LEFT JOIN tcontent active ON draft.ContentID = active.ContentID and active.approved=1
			LEFT join tfiles on draft.fileID=tfiles.fileID
			LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID
								and draft.siteID=tcontentstats.siteID
								)
	WHERE
		draft.active=1
		AND draft.approved=0
		AND draft.contenthistid not in ( select contenthistid from tapprovalrequests where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
		AND active.contentid is null
		AND draft.changesetID is null
		AND draft.lastUpdateByID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
		<cfif isdate(arguments.stopDate)>AND draft.lastUpdate <=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
		<cfif isdate(arguments.startDate)>AND draft.lastUpdate >=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>

	and module.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND draft.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>

	<cfquery name="rsDraftList" dbtype="query" maxrows="#arguments.limit#">
	select * from rsDraftList1
	union
		select * from rsDraftList2
	union
		select * from rsDraftList3
	union
		select * from rsDraftList4
	order by #arguments.sortBy# #arguments.sortDirection#
	</cfquery>

	<cfreturn rsDraftList />
</cffunction>

<cffunction name="getApprovals" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="membershipids"  type="string"  required="true" default="#getSession().mura.membershipids#"/>
	<cfargument name="limit" type="numeric" required="true" default="100000000">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	<cfargument name="sortBy" type="string" required="true" default="lastUpdate">
	<cfargument name="sortDirection" type="string" required="true" default="desc">
	<cfset var rs="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	SELECT DISTINCT draft.contentHistID,module.Title AS module, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subtype, draft.MenuTitle, draft.Filename, draft.ContentID,
	 module.SiteID, draft.SiteID, draft.SiteID, draft.targetparams,draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, tcontentstats.lockType, draft.expires,
	 tapprovalrequests.status AS approvalStatus, draft.displayStart, tchangesets.publishDate
	FROM  tcontent draft INNER JOIN tcontent module ON (
														draft.ModuleID = module.ContentID
														and draft.siteid=module.siteID
														)
		LEFT JOIN tcontent active ON (
										draft.ContentID = active.ContentID
										and active.approved=1
										and draft.siteid=active.siteID
									)
		LEFT join tfiles on draft.fileID=tfiles.fileID
		LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID
								and draft.siteID=tcontentstats.siteID
								)
		LEFT JOIN tchangesets on (draft.changesetid=tchangesets.changesetid)
		INNER JOIN tapprovalrequests on (tapprovalrequests.contenthistid=draft.contenthistid)
	WHERE
	draft.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
	and (draft.active=0 or draft.active=1 and draft.approved=0 )
	and tapprovalrequests.status = 'Pending'
	<cfif not getCurrentUser().isAdminUser() and not getCurrentUser().isSuperUser()>
		and tapprovalrequests.groupid in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.membershipids#">)
	</cfif>
	<cfif isdate(arguments.stopDate)>and active.lastUpdate <=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and active.lastUpdate >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>
	GROUP BY draft.contentHistID, module.Title, draft.ModuleID, draft.ParentID, draft.Type, draft.subType,
	draft.MenuTitle, draft.Filename, draft.ContentID, draft.IsNav, module.SiteID,
	draft.SiteID, draft.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, tcontentstats.lockType, draft.expires,
	tapprovalrequests.status, draft.displayStart, tchangesets.publishDate
	</cfquery>

	<cfquery name="rs" dbtype="query" maxrows="#arguments.limit#">
	select * from rs
	order by #arguments.sortBy# #arguments.sortDirection#
	</cfquery>

	<cfreturn rs>

</cffunction>

<cffunction name="getSubmissions" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="userID"  type="string"  required="true" default="#getSession().mura.userID#"/>
	<cfargument name="limit" type="numeric" required="true" default="100000000">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	<cfargument name="sortBy" type="string" required="true" default="lastUpdate">
	<cfargument name="sortDirection" type="string" required="true" default="desc">
	<cfset var rs="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	SELECT DISTINCT draft.contentHistID,module.Title AS module, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subtype, draft.MenuTitle, draft.Filename, draft.ContentID,
	 module.SiteID, draft.SiteID, draft.SiteID, draft.targetparams,draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, tcontentstats.lockType, draft.expires,
	 tapprovalrequests.status AS approvalStatus, draft.displayStart, tchangesets.publishDate
	FROM  tcontent draft INNER JOIN tcontent module ON (
														draft.ModuleID = module.ContentID
														and draft.siteid=module.siteID
														)
		LEFT JOIN tcontent active ON (
										draft.ContentID = active.ContentID
										and active.approved=1
										and draft.siteid=active.siteID
									)
		LEFT join tfiles on draft.fileID=tfiles.fileID
		LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID
								and draft.siteID=tcontentstats.siteID
								)
		LEFT JOIN tchangesets on (draft.changesetid=tchangesets.changesetid)
		INNER JOIN tapprovalrequests on (tapprovalrequests.contenthistid=draft.contenthistid)
	WHERE
	draft.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
	and (draft.active=0 or draft.active=1 and draft.approved=0 )
	and tapprovalrequests.status = 'Pending'
	and tapprovalrequests.userid = <cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#arguments.userid#">

	<cfif isdate(arguments.stopDate)>and active.lastUpdate <=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and active.lastUpdate >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>
	GROUP BY draft.contentHistID,module.Title, draft.ModuleID, draft.ParentID, draft.Type, draft.subType,
	draft.MenuTitle, draft.Filename, draft.ContentID, draft.IsNav, module.SiteID,
	draft.SiteID, draft.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, tcontentstats.lockType, draft.expires,
	tapprovalrequests.status, draft.displayStart, tchangesets.publishDate
	</cfquery>

	<cfquery name="rs" dbtype="query" maxrows="#arguments.limit#">
	select * from rs
	order by #arguments.sortBy# #arguments.sortDirection#
	</cfquery>

	<cfreturn rs>

</cffunction>

<cffunction name="getNest" output="false">
		<cfargument name="ParentID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfargument name="sortBy" type="string" required="true" default="orderno">
		<cfargument name="sortDirection" type="string" required="true" default="asc">
		<cfargument name="searchString" type="string" required="true" default="">
		<cfargument name="aggregation" type="string" required="true" default="true">
		<cfset var rsNest = "">
		<cfset var sortOptions="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,rating,comment,tcontent.credits,type,subtype">
		<cfset var isExtendedSort=(not listFindNoCase(sortOptions,arguments.sortBy))>
		<cfset var dbType=variables.configBean.getDbType() />
		<cfset var tableModifier="">

		<cfif dbtype eq "MSSQL">
			<cfset tableModifier="with (nolock)">
		</cfif>

		<cfif not listFindNoCase('asc,desc',arguments.sortDirection)>
			<cfset arguments.sortDirection='asc'>
		</cfif>

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsNest')#">
		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.moduleid, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID,
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart,
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,
		<cfif arguments.aggregation>
			count(tcontent2.parentid) as hasKids,
		</cfif>tcontent.isfeature,tcontent.inheritObjects,tcontent.target,
		tcontent.targetParams,tcontent.islocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,
		tfiles.fileSize,tfiles.FileExt,tfiles.ContentType,tfiles.ContentSubType, tcontent.siteID, tcontent.featureStart,tcontent.featureStop,tcontent.template,tcontent.childTemplate,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,
		tcontentstats.rating,tcontentstats.totalVotes, tcontentstats.comments,
		tfiles.filename as AssocFilename,tcontent.displayInterval, tcontent.fileid, tcontentfilemetadata.altText as fileAltText,tcontent.remoteurl

		FROM tcontent

		<cfif arguments.aggregation>
		LEFT JOIN tcontent tcontent2 #tableModifier# ON tcontent.contentid=tcontent2.parentid
		</cfif>

		LEFT JOIN tfiles #tableModifier# On tcontent.FileID=tfiles.FileID and tcontent.siteID=tfiles.siteID
		LEFT JOIN tcontentstats #tableModifier# on (tcontent.contentID=tcontentstats.contentID
								and tcontent.siteID=tcontentstats.siteID
								)
		Left Join tcontentfilemetadata #tableModifier# on (tcontent.fileid=tcontentfilemetadata.fileid
													and tcontent.contenthistid=tcontentfilemetadata.contenthistid)

		<cfif isExtendedSort>
			left Join (select
					#variables.classExtensionManager.getCastString(arguments.sortBy,arguments.siteID)# extendedSort
					 ,tclassextenddata.baseID
					from tclassextenddata #tableModifier# inner join tclassextendattributes #tableModifier#
					on (tclassextenddata.attributeID=tclassextendattributes.attributeID)
					where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
					and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sortBy#">
			) qExtendedSort
			on (tcontent.contenthistid=qExtendedSort.baseID)
		</cfif>

		WHERE
		tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		AND tcontent.ParentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
		and   tcontent.Active=1
		and   (tcontent.Type ='Page'
				or tcontent.Type = 'Component'
				or tcontent.Type = 'Link'
				or tcontent.Type = 'Variation'
				or tcontent.Type = 'File'
				or tcontent.Type = 'Folder'
				or tcontent.Type = 'Calendar'
				or tcontent.Type = 'Form'
				or tcontent.Type = 'Gallery'
				or tcontent.Type = 'Module')

		<cfif arguments.searchString neq "">
			and (UPPER(tcontent.menuTitle) like UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%"/>))
		</cfif>

		<cfif arguments.aggregation>
			group by tcontent.ContentHistID, tcontent.ContentID, tcontent.moduleid, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID,
			tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart,
			tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
			tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,
			tfiles.fileSize,tfiles.FileExt,tfiles.ContentType,tfiles.ContentSubType, tcontent.created, tcontent.siteID, tcontent.featureStart,tcontent.featureStop,tcontent.template,tcontent.childTemplate,
			tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,
			tcontentstats.rating,tcontentstats.totalVotes, tcontentstats.comments,tfiles.filename,tcontent.displayInterval
			<cfif isExtendedSort>
				,qExtendedSort.extendedSort
			</cfif>
			,tcontent.fileid, tcontentfilemetadata.altText,tcontent.remoteurl
		</cfif>
		order by
		<cfswitch expression="#arguments.sortBy#">
			<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displaystart,displaystop,created,tcontent.credits,type,subtype">
				<cfif dbType neq "oracle" or  listFindNoCase("orderno,lastUpdate,releaseDate,created,displayStart,displayStop",arguments.sortBy)>
				tcontent.#arguments.sortBy# #arguments.sortDirection#
				<cfelse>
				lower(tcontent.#arguments.sortBy#) #arguments.sortDirection#
				</cfif>
			</cfcase>
			<cfcase value="rating">
				tcontentstats.rating #arguments.sortDirection#, tcontentstats.totalVotes  #arguments.sortDirection#
			</cfcase>
			<cfcase value="comments">
				tcontentstats.comments #arguments.sortDirection#
			</cfcase>
			<cfdefaultcase>
				<cfif isExtendedSort>
					qExtendedSort.extendedSort #arguments.sortDirection#
				<cfelse>
					tcontent.orderno
				</cfif>
			</cfdefaultcase>
		</cfswitch>

		<cfif listFindNoCase("oracle,postgresql", dbType)>
			<cfif arguments.sortDirection eq "asc">
				NULLS FIRST
			<cfelse>
				NULLS LAST
			</cfif>
		</cfif>

		</cfquery>

		<cfreturn rsNest />
	</cffunction>

<cffunction name="getKidsCount" output="false">
		<cfargument name="parentID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfargument name="liveOnly" default="true" required="true">
		<cfargument name="menutype" default="default" required="true">
		<cfset var rs= "">
		<cfset var today=now()>

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		SELECT count(tcontent.parentid) as kids
		FROM tcontent

		WHERE
		tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		AND tcontent.ParentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>

		<cfif arguments.liveOnly>
			#renderActiveClause("tcontent",arguments.siteID)#
		 	and isNav=1
		 	and #renderMenuTypeClause(arguments.menutype,createDateTime(year(today),month(today),day(today),hour(today),int((minute(today)/5)*5),0))#

		 	#renderMobileClause()#
		 <cfelse>
		 	and tcontent.Active=1
		</cfif>
		</cfquery>

		<cfreturn rs.kids />
	</cffunction>

<cffunction name="getComponents" output="false">
		<cfargument name="moduleID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rsComponents = "">

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsComponents')#">
		SELECT contentid, menutitle, body, title, filename
		FROM  tcontent
		WHERE     	         (tcontent.Active = 1)
							  <!---   AND (tcontent.DisplayStart <= #createodbcdatetime(now())#)
					  AND (tcontent.DisplayStop >= #createodbcdatetime(now())# or tcontent.DisplayStop is null) --->
							  AND (tcontent.Display = 2)
							  AND (tcontent.Approved = 1)
							  AND (tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
							  AND (tcontent.type = 'Component')
							  AND tcontent.moduleAssign like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.moduleid#%"/>
							  OR
							  (tcontent.Active = 1)
							  AND (tcontent.Display = 1)
							  AND (tcontent.Approved = 1)
							  AND (tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
							  AND (tcontent.type = 'Component')
							  AND tcontent.moduleAssign like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.moduleid#%"/>

		Order By title
		</cfquery>

		<cfreturn rsComponents />
</cffunction>

<cffunction name="getTop" output="true">
		<cfargument name="topID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rsTop = "">

		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsTop')#">
		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.moduleid, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID,
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart,
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isFeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
		tcontent.isLocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,tfiles.fileEXT, tcontent.featurestart, tcontent.featurestop,tcontent.template,tcontent.childTemplate,
		tfiles.filename AS assocFilename,tfiles.fileid, tcontent.siteid,tcontentstats.lockid,tcontentstats.locktype,tcontent.remoteurl
		FROM tcontent
		LEFT JOIN tcontentstats on (tcontent.contentID=tcontentstats.contentID
								and tcontent.siteID=tcontentstats.siteID
								)
		LEFT JOIN tfiles On tcontent.FileID=tfiles.FileID
		WHERE tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and tcontent.Active=1 and tcontent.contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.topID#"/>
		</cfquery>

		<cfreturn rsTop />
</cffunction>

<cffunction name="getComponentType" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	<cfargument name="moduleid" type="string" default="" required="true">
	<cfset var rsComponentType = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsComponentType')#">
		select contentid, menutitle, responseChart FROM  tcontent
		WHERE
		(tcontent.Active = 1)
		AND (tcontent.Display = 1 or tcontent.Display = 2)
		AND (tcontent.Approved = 1)
		AND (tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
		AND (tcontent.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>)
		<cfif len(arguments.moduleid)>
			AND (tcontent.moduleAssign like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.moduleid#%"/>)
		</cfif>
		Order By title asc
	</cfquery>

	<cfreturn rsComponentType />
</cffunction>

<cffunction name="getHist" output="false" hint="I get all versions">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsHist = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsHist')#">
	select tcontent.menutitle, tcontent.siteid, tcontent.contentid, tcontent.contenthistid, tcontent.fileID, tcontent.type, tcontent.lastupdateby, tcontent.lastupdatebyid, tcontent.active, tcontent.approved, tcontent.lastupdate,
	tcontent.display, tcontent.displaystart, tcontent.displaystop, tcontent.moduleid, tcontent.isnav, tcontent.notes,tcontent.isfeature,tcontent.featurestart,tcontent.featurestop,tcontent.inheritObjects,tcontent.filename,tcontent.targetParams,tcontent.releaseDate,
	tcontent.changesetID, tchangesets.name changesetName, tchangesets.published changsetPublished,tchangesets.publishDate changesetPublishDate ,
	tcontent.majorVersion,tcontent.minorVersion, tapprovalrequests.status approvalStatus,tapprovalrequests.requestID, tapprovalrequests.groupid approvalGroupID
	from tcontent
	left Join tchangesets on (tcontent.changesetID=tchangesets.changesetID)
	left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> order by tcontent.lastupdate desc
	</cfquery>

	<cfreturn rsHist />
</cffunction>

<cffunction name="getDraftHist" output="false" hint="I get all draft versions">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsDraftList = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDraftList')#">
	select tcontent.menutitle, tcontent.contentid, tcontent.contenthistid, tcontent.fileID, tcontent.type, tcontent.lastupdateby, tcontent.lastupdatebyid, tcontent.active, tcontent.approved, tcontent.lastupdate,
	tcontent.display, tcontent.displaystart, tcontent.displaystop, tcontent.moduleid, tcontent.isnav, tcontent.notes,tcontent.isfeature,tcontent.inheritObjects,tcontent.filename,
	tcontent.targetParams,tcontent.releaseDate,tcontent.path, tapprovalrequests.status approvalStatus,tapprovalrequests.requestID,tapprovalrequests.groupid approvalGroupID
	from tcontent
	left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and tcontent.approved=0 and tcontent.changesetID is null
	order by tcontent.lastupdate desc
	</cfquery>

	<cfreturn rsDraftList />
</cffunction>

<cffunction name="getPendingChangesets" output="false" hint="I get all draft versions">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsPendingChangeSets = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPendingChangeSets')#">
	select tcontent.menutitle, tcontent.contentid, tcontent.contenthistid, tcontent.fileID, tcontent.type, tcontent.lastupdateby, tcontent.lastupdatebyid, tcontent.active, tcontent.approved, tcontent.lastupdate,
	tcontent.display, tcontent.displaystart, tcontent.displaystop, tcontent.moduleid, tcontent.isnav, tcontent.notes,tcontent.isfeature,tcontent.inheritObjects,tcontent.filename,
	tcontent.targetParams,tcontent.releaseDate,tcontent.path, tapprovalrequests.status approvalStatus,tapprovalrequests.requestID,tapprovalrequests.groupid approvalGroupID,
	tchangesets.publishDate changesetPublishDate,tchangesets.name as changesetName,tchangesets.changesetID
	from tcontent
	inner join tchangesets on (tcontent.changesetid=tchangesets.changesetid)
	left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and tcontent.approved=0 and tcontent.changesetID is not null
	order by tcontent.lastupdate desc
	</cfquery>

	<cfreturn rsPendingChangeSets />
</cffunction>

<cffunction name="getArchiveHist" output="false" hint="I get all archived versions">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsArchiveHist = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsArchiveHist')#">
	select tcontent.menutitle, tcontent.contentid, tcontent.contenthistid, tcontent.fileID, tcontent.type, tcontent.lastupdateby, tcontent.lastupdatebyid, tcontent.active, tcontent.approved, tcontent.lastupdate,
	tcontent.display, tcontent.displaystart, tcontent.displaystop, tcontent.moduleid, tcontent.isnav, tcontent.notes,tcontent.isfeature,tcontent.inheritObjects,tcontent.filename,
	tcontent.targetParams,tcontent.releaseDate,tcontent.path, tapprovalrequests.status approvalStatus,tapprovalrequests.requestID, tapprovalrequests.groupid approvalGroupID
	from tcontent
	left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and tcontent.approved=1
	and tcontent.active=0
	order by tcontent.lastupdate desc
	</cfquery>

	<cfreturn rsArchiveHist />
</cffunction>

<cffunction name="getItemCount" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsItemCount = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsItemCount')#">
	SELECT menuTitle, Title, filename, lastupdate, type  from  tcontent WHERE
	 contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and active=1 and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>


	<cfreturn rsItemCount />
</cffunction>

<cffunction name="getDownloadSelect" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsDownloadSelect = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDownloadSelect')#">
	select min(entered) as FirstEntered, max(entered) as LastEntered, Count(*) as CountEntered from tformresponsepackets
	where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and formid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	</cfquery>


	<cfreturn rsDownloadSelect />
</cffunction>

<cffunction name="getPrivateSearch" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="keywords" type="string" required="true">
	<cfargument name="tag" type="string" required="true" default="">
	<cfargument name="sectionID" type="string" required="true" default="">
	<cfargument name="searchType" type="string" required="true" default="default" hint="Can be default or image">
	<cfargument name="moduleid" type="string" required="true" default="00000000000000000000000000000000000,00000000000000000000000000000000003,00000000000000000000000000000000004">

	<cfset var rsPrivateSearch = "">
	<cfset var kw = trim(arguments.keywords)>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPrivateSearch',maxrows=1000)#">
	SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID,
	tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, tcontent.subtype,
	tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isfeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
	tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt, 2 AS Priority, tcontent.nextn, tfiles.fileid,
	tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,tfiles.filename as assocFilename, tcontentfilemetadata.altText as fileAltText,
	CASE WHEN tcontent.title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#">
		or tcontent.menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#"> THEN 0 ELSE 1 END AS superSort
	FROM tcontent
	LEFT JOIN tcontent tcontent2 ON (tcontent.contentid=tcontent2.parentid)
	LEFT JOIN tcontentstats on (tcontent.contentID=tcontentstats.contentID
								and tcontent.siteID=tcontentstats.siteID
								)
	<cfif listFindNoCase("image,file",arguments.searchType)>
		Inner Join tfiles ON (tcontent.fileID=tfiles.fileID)
	<cfelse>
		Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
	</cfif>

	<cfif len(arguments.tag)>
		Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
	</cfif>

	Left Join tcontentfilemetadata on (tcontent.fileid=tcontentfilemetadata.fileid
													and tcontent.contenthistid=tcontentfilemetadata.contenthistid)

	WHERE

	<cfif arguments.searchType eq "image">
	tfiles.fileext in ('png','gif','jpg','jpeg') AND
	</cfif>

	<cfif kw neq '' or arguments.tag neq ''>
         	tcontent.Active = 1
			  	<cfif listFindNoCase("image,file",arguments.searchType)>
					AND tcontent.siteID in (
							select siteid
							from tsettings
							where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
							or filePoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						)
			  	<cfelse>
			  		AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				</cfif>

					AND


					tcontent.type in ('Page','Folder','Calendar','File','Link','Gallery','Form','Component','Variation')

						<cfif len(arguments.sectionID)>
							and tcontent.path like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.sectionID#%">
						</cfif>

						<cfif len(arguments.tag)>
							and #renderTextParamColumn('tcontenttags.Tag')# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(trim(arguments.tag))#"/>
						<cfelse>

						and
						(
							#renderTextParamColumn('tcontent.Title')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
							or #renderTextParamColumn('tcontent.menuTitle')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
							or #renderTextParamColumn('tcontent.summary')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>

							<cfif listFindNoCase("image,file",arguments.searchType)>
								or #renderTextParamColumn('tfiles.caption')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
								or #renderTextParamColumn('tfiles.credits')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
								or #renderTextParamColumn('tfiles.alttext')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
								or #renderTextParamColumn('tfiles.filename')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
								or #renderTextParamColumn('tcontentfilemetadata.caption')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
								or #renderTextParamColumn('tcontentfilemetadata.credits')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
								or #renderTextParamColumn('tcontentfilemetadata.alttext')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%"/>
							</cfif>

							or
								(
									tcontent.type not in ('Link','File')
									and #renderTextParamColumn('tcontent.body')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
								)
							or tcontent.contenthistid in (
								select distinct tcontent.contenthistid from tclassextenddata
								inner join tcontent on (tclassextenddata.baseid=tcontent.contenthistid)
								where tcontent.active=1
								and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
								and #renderTextParamColumn('tclassextenddata.attributeValue')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(kw)#%">
							)
						)

						and not (
							#renderTextParamColumn('tcontent.Title')# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(kw)#"/>
							or #renderTextParamColumn('tcontent.menuTitle')# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(kw)#"/>
						)
					</cfif>

				and tcontent.moduleid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.moduleid#">)
		<cfelse>
		0=1
		</cfif>


		GROUP BY tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID,
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, tcontent.subtype,
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
		tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt, tcontent.nextn, tfiles.fileid,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,tfiles.filename,tcontentfilemetadata.altText,
		CASE WHEN tcontent.title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#">
			or tcontent.menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#"> THEN 0 ELSE 1 END


		<cfif kw neq ''>
		UNION

		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID,
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, tcontent.subtype,
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isfeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
		tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt, 1 AS Priority, tcontent.nextn, tfiles.fileid,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,tfiles.filename as assocFilename, tcontentfilemetadata.altText as fileAltText,
		CASE WHEN tcontent.title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#">
			or tcontent.menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#"> THEN 0 ELSE 1 END AS superSort
		FROM tcontent
		LEFT JOIN tcontent tcontent2 ON (tcontent.contentid=tcontent2.parentid)
		LEFT JOIN tcontentstats on (tcontent.contentID=tcontentstats.contentID
								and tcontent.siteID=tcontentstats.siteID
								)
		<cfif arguments.searchType eq "image">
		Inner Join tfiles ON (tcontent.fileID=tfiles.fileID)
		<cfelse>
		Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
		</cfif>

		Left Join tcontentfilemetadata on (tcontent.fileid=tcontentfilemetadata.fileid
													and tcontent.contenthistid=tcontentfilemetadata.contenthistid)

		WHERE

		<cfif arguments.searchType eq "image">
			tfiles.fileext in ('png','gif','jpg','jpeg') AND
		</cfif>

		tcontent.Active = 1

		and tcontent.moduleid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.moduleid#">)

				<cfif listFindNoCase("image,file",arguments.searchType)>
					AND tcontent.siteID in (
							select siteid
							from tsettings
							where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
							or filePoolID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						)
			  	<cfelse>
			  		AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				</cfif>

					AND


					tcontent.type in ('Page','Folder','Calendar','File','Link','Gallery','Form','Component','Variation')

						<cfif len(arguments.sectionID)>
							and tcontent.path like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.sectionID#%">
						</cfif>

						and
						(#renderTextParamColumn('tcontent.Title')# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(kw)#"/>
						or #renderTextParamColumn('tcontent.menuTitle')# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(kw)#"/>

						)
	GROUP BY tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID,
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, tcontent.subtype,
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
		tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt,tcontent.nextn, tfiles.fileid,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,tfiles.filename, tcontentfilemetadata.altText,
		CASE WHEN tcontent.title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#">
			or tcontent.menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#"> THEN 0 ELSE 1 END
	</cfif>
	ORDER BY supersort, priority, title
	</cfquery>

	<cfreturn rsPrivateSearch />
</cffunction>

<cffunction name="getPublicSearch" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="keywords" type="string" required="true">
	<cfargument name="tag" type="string" required="true" default="">
	<cfargument name="sectionID" type="string" required="true" default="">
	<cfargument name="categoryID" type="string" required="true" default="">
	<cfargument name="tagGroup" type="string" required="true" default="">

	<cfset var rsPublicSearch = "">
	<cfset var w = "">
	<cfset var c = "">
	<cfset var categoryListLen=listLen(arguments.categoryID)>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPublicSearch',maxrows=1000)#">
	<!--- Find direct matches with no releasedate --->

	select tcontent.contentid,tcontent.contenthistid,tcontent.siteid,tcontent.title,tcontent.menutitle,tcontent.targetParams,tcontent.filename,tcontent.summary,tcontent.tags,
	tcontent.restricted,tcontent.releaseDate,tcontent.type,tcontent.subType,
	tcontent.restrictgroups,tcontent.target ,tcontent.displaystart,tcontent.displaystop,0 as Comments,
	tcontent.credits, tcontent.remoteSource, tcontent.remoteSourceURL,
	tcontent.remoteURL,tfiles.fileSize,tfiles.fileExt,tcontent.fileID,tcontent.audience,tcontent.keyPoints,
	tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes, 0 as kids,
	tparent.type parentType,tcontent.nextn,tcontent.path,tcontent.orderno,tcontent.lastupdate, tcontent.created,
	tcontent.created sortdate, 0 priority,tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType,
	tcontent.expires,tfiles.filename as assocFilename, tcontentfilemetadata.altText as fileAltText,
	CASE WHEN tcontent.title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#">
		or tcontent.menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#"> THEN 0 ELSE 1 END AS superSort
	from tcontent Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
	Left Join tcontent tparent on (tcontent.parentid=tparent.contentid
						    			and tcontent.siteid=tparent.siteid
						    			and tparent.active=1)
	Left Join tcontentstats on (tcontent.contentid=tcontentstats.contentid
					    and tcontent.siteid=tcontentstats.siteid)
	Left Join tcontentfilemetadata on (tcontent.fileid=tcontentfilemetadata.fileid
													and tcontent.contenthistid=tcontentfilemetadata.contenthistid)


	<cfif len(arguments.tag)>
		Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
	</cfif>
		where

	         			(tcontent.Active = 1
						AND tcontent.Approved = 1
				  		AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> )

						AND

						(
						  tcontent.Display = 2
							AND
							(
								(tcontent.DisplayStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#now()#">
								AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#now()#"> or tcontent.DisplayStop is null)
								)
								OR  tparent.type='Calendar'
							)

							OR tcontent.Display = 1
						)


				AND
				tcontent.type in ('Page','Folder','Calendar','File','Link','Gallery')

				AND tcontent.releaseDate is null

				<cfif len(arguments.sectionID)>
				and tcontent.path like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.sectionID#%">
				</cfif>

				<cfif len(arguments.tag)>
					and (
							#renderTextParamColumn('tcontenttags.tag')# in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.tag)#"/> )
							<cfif len(arguments.tagGroup) and arguments.tagGroup neq 'default'>
								and #renderTextParamColumn('tcontenttags.taggroup')#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.taggroup)#"/>
							</cfif>
						)
				<cfelse>
					<!---
					<cfloop list="#trim(arguments.keywords)#" index="w" delimiters=" ">
							and
							(tcontent.Title like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.menuTitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.metaKeywords like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">)
					</cfloop>
					--->
					and
							(#renderTextParamColumn('tcontent.Title')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							or #renderTextParamColumn('tcontent.menuTitle')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							or #renderTextParamColumn('tcontent.metaKeywords')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							or #renderTextParamColumn('tcontent.summary')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							or (
									tcontent.type not in ('Link','File')
									and #renderTextParamColumn('tcontent.body')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
								)
							or #renderTextParamColumn('tcontent.credits')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">

							or tcontent.contenthistid in (
								select distinct tcontent.contenthistid from tclassextenddata
								inner join tcontent on (tclassextenddata.baseid=tcontent.contenthistid)
								where tcontent.active=1
								and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
								and #renderTextParamColumn('tclassextenddata.attributeValue')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							))
				</cfif>

				and tcontent.searchExclude=0

				<cfif categoryListLen>
					  and tcontent.contentHistID in (
							select tcontentcategoryassign.contentHistID from
							tcontentcategoryassign
							inner join tcontentcategories
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
							where (<cfloop from="1" to="#categoryListLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.categoryID,c)#%"/>
									<cfif c lt categoryListLen> or </cfif>
									</cfloop>)
					  )
				</cfif>

				#renderMobileClause()#


	union all

	<!--- Find direct matches with releasedate --->

	select tcontent.contentid,tcontent.contenthistid,tcontent.siteid,tcontent.title,tcontent.menutitle,tcontent.targetParams,tcontent.filename,tcontent.summary,tcontent.tags,
	tcontent.restricted,tcontent.releaseDate,tcontent.type,tcontent.subType,
	tcontent.restrictgroups,tcontent.target ,tcontent.displaystart,tcontent.displaystop,0 as Comments,
	tcontent.credits, tcontent.remoteSource, tcontent.remoteSourceURL,
	tcontent.remoteURL,tfiles.fileSize,tfiles.fileExt,tcontent.fileID,tcontent.audience,tcontent.keyPoints,
	tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes, 0 as kids,
	tparent.type parentType,tcontent.nextn,tcontent.path,tcontent.orderno,tcontent.lastupdate, tcontent.created,
	tcontent.releaseDate sortdate, 0 priority,tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType,
	tcontent.expires,tfiles.filename as assocFilename, tcontentfilemetadata.altText as fileAltText,
	CASE WHEN tcontent.title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#">
		or tcontent.menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.keywords)#"> THEN 0 ELSE 1 END AS superSort
	from tcontent Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
	Left Join tcontent tparent on (tcontent.parentid=tparent.contentid
						    			and tcontent.siteid=tparent.siteid
						    			and tparent.active=1)
	Left Join tcontentstats on (tcontent.contentid=tcontentstats.contentid
					    and tcontent.siteid=tcontentstats.siteid)
	Left Join tcontentfilemetadata on (tcontent.fileid=tcontentfilemetadata.fileid
													and tcontent.contenthistid=tcontentfilemetadata.contenthistid)


	<cfif len(arguments.tag)>
		Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
	</cfif>
		where

	         			(tcontent.Active = 1
						AND tcontent.Approved = 1
				  		AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> )

						AND

						(
						  tcontent.Display = 2
							AND
							(
								(tcontent.DisplayStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#now()#">
								AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#now()#"> or tcontent.DisplayStop is null)
								)
								OR  tparent.type='Calendar'
							)

							OR tcontent.Display = 1
						)


				AND
				tcontent.type in ('Page','Folder','Calendar','File','Link','Gallery')

				AND tcontent.releaseDate is not null

				<cfif len(arguments.sectionID)>
				and tcontent.path like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.sectionID#%">
				</cfif>

				<cfif len(arguments.tag)>
					and (
							#renderTextParamColumn('tcontenttags.tag')# in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.tag)#"/> )
							<cfif len(arguments.tagGroup) and arguments.tagGroup neq 'default'>
								and #renderTextParamColumn('tcontenttags.taggroup')#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#renderTextParamValue(arguments.taggroup)#"/>
							</cfif>
						)
				<cfelse>
					<!---
					<cfloop list="#trim(arguments.keywords)#" index="w" delimiters=" ">
							and
							(tcontent.Title like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.menuTitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.metaKeywords like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">)
					</cfloop>
					--->
					and
							(#renderTextParamColumn('tcontent.Title')# like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">

							or #renderTextParamColumn('tcontent.menuTitle')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							or #renderTextParamColumn('tcontent.metaKeywords')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							or #renderTextParamColumn('tcontent.summary')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							or
								(
									tcontent.type not in ('Link','File')
									and #renderTextParamColumn('tcontent.body')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
								)
							or #renderTextParamColumn('tcontent.credits')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">

							or tcontent.contenthistid in (
								select distinct tcontent.contenthistid from tclassextenddata
								inner join tcontent on (tclassextenddata.baseid=tcontent.contenthistid)
								where tcontent.active=1
								and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
								and #renderTextParamColumn('tclassextenddata.attributeValue')# like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#renderTextParamValue(arguments.keywords)#%">
							))
				</cfif>

				and tcontent.searchExclude=0

				<cfif categoryListLen>
					  and tcontent.contentHistID in (
							select tcontentcategoryassign.contentHistID from
							tcontentcategoryassign
							inner join tcontentcategories
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
							where (<cfloop from="1" to="#categoryListLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.categoryID,c)#%"/>
									<cfif c lt categoryListLen> or </cfif>
									</cfloop>)
					  )
				</cfif>

				#renderMobileClause()#

	ORDER BY supersort, priority, <cfif variables.configBean.getDBType() neq 'nuodb'>sortdate<cfelse>releasedate</cfif> desc, title
	</cfquery>

	<cfreturn rsPublicSearch />
</cffunction>

<cffunction name="getCategoriesByHistID" output="false">
	<cfargument name="contentHistID" type="string" required="true">
	<cfset var rsCategoriesByHistID = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCategoriesByHistID')#">
		select tcontentcategoryassign.*, tcontentcategories.name, tcontentcategories.filename, tcontentcategories.parentid, tcontentcategories.path from tcontentcategories inner join tcontentcategoryassign
		ON (tcontentcategories.categoryID=tcontentcategoryassign.categoryID)
		where tcontentcategoryassign.contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
		Order By tcontentcategories.filename
	</cfquery>


	<cfreturn rsCategoriesByHistID />
</cffunction>

<cffunction name="getRelatedContent" output="false">
	<cfargument name="siteID" type="String">
	<cfargument name="contentHistID" type="String">
	<cfargument name="liveOnly" type="boolean" required="yes" default="true">
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	<cfargument name="sortBy" type="string" default="orderno" >
	<cfargument name="sortDirection" type="string" default="asc" >
	<cfargument name="relatedContentSetID" type="string" default="">
	<cfargument name="name" type="string" default="">
	<cfargument name="reverse" type="boolean" default="false">
	<cfargument name="reverseContentID"  type="string" />
	<cfargument name="navOnly" type="boolean" required="yes" default="false" />
	<cfargument name="cachedWithin" type="any" required="yes" default="#createTimeSpan(0,0,0,0)#" />

	<cfset var rsRelatedContent ="" />
	<cfset var dbType=variables.configBean.getDbType() />
	<cfset var tableModifier="">
	<cfset var nowAdjusted="">

	<cfif request.muraChangesetPreview and isStruct(getCurrentUser().getValue("ChangesetPreviewData"))>
		<cfset nowAdjusted=getCurrentUser().getValue("ChangesetPreviewData").publishDate>
	</cfif>

	<cfif isDate(request.muraPointInTime)>
		<cfset nowAdjusted=request.muraPointInTime>
	</cfif>

	<cfif not isdate(nowAdjusted)>
		<cfset nowAdjusted=arguments.today>
	</cfif>

	<cfset nowAdjusted=variables.utility.datetimeToTimespanInterval(nowAdjusted,arguments.cachedWithin)>

	<cfif dbtype eq "MSSQL">
		<cfset tableModifier="with (nolock)">
	</cfif>

	<cfif not listFindNoCase('menutitle,title,lastupdate,releasedate,orderno,displaystart,displaystop,created,credits,type,subtype,comments,rating,orderno',arguments.sortby)>
		<cfset arguments.sortBy='orderno'>
	</cfif>

	<cfif arguments.reverse and arguments.sortby eq 'orderno'>
		<cfset arguments.sortby="menutitle">
		<cfset arguments.sortDirection="asc">
	</cfif>

	<cfif not listFindNoCase('asc,desc',arguments.sortDirection)>
		<cfset arguments.sortDirection='asc'>
	</cfif>

	<cfif arguments.relatedContentSetID eq '0'>
		<cfset arguments.relatedContentSetID='00000000000000000000000000000000000'>
	</cfif>

	<cfif arguments.sortby eq 'mxpRelevance' >
		<cfif not isDefined('session.mura.mxp')>
			<cfset session.mura.mxp=getBean('marketingManager').getDefaults()>
		</cfif>
		<cfparam name="session.mura.mxp.trackingProperties.personaid" default=''>
		<cfparam name="session.mura.mxp.trackingProperties.stageid" default=''>

		<cfset var personaid=session.mura.mxp.trackingProperties.personaid>
		<cfset var stageid=session.mura.mxp.trackingProperties.stageid>

		<cfif isDefined('url.personaid')>
			<cfset personaid=url.personaid>
			<cfset stageid=''>
		</cfif>

		<cfif isDefined('form.personaid')>
			<cfset personaid=form.personaid>
			<cfset stageid=''>
		</cfif>

		<cfset var mxpRelevanceSort=true>
	<cfelse>
		<cfset var personaid="">
		<cfset var stageid="">
		<cfset var mxpRelevanceSort=false>
	</cfif>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsRelatedContent',cachedWithin=arguments.cachedWithin)#">
	SELECT tcontent.title, tcontent.releasedate, tcontent.menuTitle, tcontent.lastupdate, tcontent.lastupdatebyid, tcontent.summary, tcontent.filename, tcontent.type, tcontent.contentid,
	tcontent.target,tcontent.targetParams, tcontent.restricted, tcontent.restrictgroups, tcontent.displaystart, tcontent.displaystop, tcontent.orderno,tcontent.sortBy,tcontent.sortDirection,
	tcontent.fileid, tcontent.credits, tcontent.remoteSource, tcontent.remoteSourceURL, tcontent.remoteURL, tcontent.subtype,
	tfiles.fileSize,tfiles.fileExt,tcontent.path, tcontent.siteid, tcontent.contenthistid, tcr.contentid as relatedFromContentID,
	tcr.relatedContentSetID, tcr.orderNo, tcontent.displayInterval, tcontent.display
	<cfif mxpRelevanceSort>
	,tracktotal.track_total_score as total_score, (<cfif len(stageid)>stagetotal.stage_points + </cfif>personatotal.persona_points) as total_points
	</cfif>
	FROM  tcontent Left Join tfiles ON (tcontent.fileID=tfiles.fileID)

	<cfif mxpRelevanceSort>
		left join (
			select sum(persona.points) persona_points, persona.contenthistid
			from mxp_personapoints persona
			where persona.personaid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#personaid#">
			group by persona.contenthistid
		) personatotal on (tcontent.contenthistid = personatotal.contenthistid)

		<cfif len(stageid)>
			left join (
				select sum(stage.points) stage_points, stage.contenthistid
				from mxp_stagepoints stage
				where stage.stageid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stageid#">
				group by stage.contenthistid
			) stagetotal on (tcontent.contenthistid = stagetotal.contenthistid)
		</cfif>

		left join (
			select sum(track.points) track_total_score, track.contentid
			from mxp_conversiontrack track
			where track.created >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('m',-1,nowAdjusted)#">
			and track.points > 0
			group by track.contentid
		) tracktotal on (tcontent.contentid=tracktotal.contentid)
	</cfif>

	<cfif arguments.reverse>
		inner join tcontentrelated tcr #tableModifier# on (tcontent.contentHistID = tcr.contentHistID)

		<cfif len(arguments.name)>
			left join tclassextendrcsets tcrs #tableModifier# on (tcr.relatedContentSetID=tcrs.relatedContentSetID)
		</cfif>

		where tcr.relatedID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reverseContentID#" list="true"/>)

		<cfif len(arguments.name)>
			and (tcrs.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#"/>
				<cfif arguments.name eq 'Default'>
					or tcrs.name is null
				</cfif>
				)
		<cfelseif len(arguments.relatedContentSetID)>
			and (
				tcr.relatedContentSetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relatedContentSetID#"/>
				<cfif arguments.relatedContentSetID eq "00000000000000000000000000000000000">
					or tcr.relatedContentSetID is null
				</cfif>
				)
		</cfif>

	<cfelse>
		inner join tcontentrelated tcr #tableModifier# on (tcontent.contentID = tcr.relatedID)

		<cfif len(arguments.name)>
			left join tclassextendrcsets tcrs #tableModifier# on (tcr.relatedContentSetID=tcrs.relatedContentSetID)
		</cfif>

		where tcr.contenthistid in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistid#" list="true"/>)

		<cfif len(arguments.name)>
			and (tcrs.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#"/>
				<cfif arguments.name eq 'Default'>
					or tcrs.name is null
				</cfif>
				)
		<cfelseif len(arguments.relatedContentSetID)>
			and (
				tcr.relatedContentSetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relatedContentSetID#"/>
				<cfif arguments.relatedContentSetID eq "00000000000000000000000000000000000">
					or tcr.relatedContentSetID is null
				</cfif>
				)
		</cfif>
	</cfif>

	<!--- and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> --->
	and tcontent.siteid IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getContentPoolID()#" list="true">)
	<cfif arguments.navOnly>
		and tcontent.isnav=1
	</cfif>

	<cfif arguments.liveOnly>
		#renderActiveClause("tcontent",arguments.siteID)#

	 	AND (
			(
			  	tcontent.Display = 2
			  	AND (
				  		(
				  			tcontent.DisplayStart >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#arguments.today#">
							AND tcontent.parentID in (select contentID from tcontent
															where type='Calendar'
															#renderActiveClause("tcontent",arguments.siteID)#
															and siteid IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getContentPoolID()#" list="true">)
														   )
						 )
					   OR
					   	(
					   		tcontent.DisplayStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
							AND
							(
								tcontent.DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
								or tcontent.DisplayStop is null
							)
					   )
				)
		  	)
		   	OR
		   	(
		   		tcontent.Display = 1
		   	)
		)
	<cfelse>
			and tcontent.active=1
	</cfif>

	#renderMobileClause()#

	order by

	<cfswitch expression="#arguments.sortBy#">
		<cfcase value="menutitle,title,lastupdate,releasedate,displaystart,displaystop,created,tcontent.credits,type,subtype">
			<cfif variables.configBean.getDbType() neq "oracle" or listFindNoCase("lastUpdate,releaseDate,created,displayStart,displayStop,orderno", arguments.sortBy)>
				tcontent.#arguments.sortBy# #arguments.sortDirection#
			<cfelse>
				lower(tcontent.#arguments.sortBy#) #arguments.sortDirection#
			</cfif>
		</cfcase>
		<cfcase value="orderno">
			<cfif len(arguments.relatedContentSetID) or len(arguments.name)>
				tcr.orderNo #arguments.sortDirection#
			<cfelse>
				tcontent.orderno #arguments.sortDirection#
			</cfif>
		</cfcase>
		<cfcase value="rating">
			tcontentstats.rating #arguments.sortDirection#, tcontentstats.totalVotes  #arguments.sortDirection#
		</cfcase>
		<cfcase value="comments">
			tcontentstats.comments #arguments.sortDirection#
		</cfcase>
		<cfdefaultcase>
			<cfif mxpRelevanceSort>
				total_points #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")# , total_score #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#, tcontent.releaseDate #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#,tcontent.lastUpdate #REReplace(arguments.sortDirection,"[^0-9A-Za-z\._,\- ]","","all")#
			<cfelse>
				tcontent.orderno asc
			</cfif>
		</cfdefaultcase>
	</cfswitch>

	</cfquery>

	<cfif arguments.liveOnly>
		<cfreturn variables.contentIntervalManager.applyByMenuTypeAndDate(query=rsRelatedContent,menuType="default",menuDate=nowAdjusted)>
	<cfelse>
		<cfreturn rsRelatedContent />
	</cfif>

</cffunction>

<cffunction name="getUsage" output="false">
	<cfargument name="objectID" type="String">
	<cfargument name="siteid" type="String">

	<cfset var rsUsage= ''/>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsUsage')#">
	select tcontent.menutitle, tcontent.type, tcontent.filename, tcontent.lastupdate, tcontent.contentID, tcontent.siteID,
	tcontent.approved,tcontent.display,tcontent.displayStart,tcontent.displayStop,tcontent.moduleid,tcontent.contenthistID,
	tcontent.parentID
	from tcontent
	where tcontent.active=1
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
	and
	<cfif len(arguments.objectID)>
		(
			tcontent.contentid in (
			select contentid from tcontentobjects
			where
			siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
			and objectid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.objectID#%"/>
			)
			<cfif variables.configBean.getDbType() neq 'Oracle'>
			or
			tcontent.contentid in (
				select contentid from tcontent
				where
				siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
				and active=1
				and body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.objectID#%"/>

			)
			</cfif>
		)
	<cfelse>
		0=1
	</cfif>
	</cfquery>

	<cfreturn rsUsage />
</cffunction>

<cffunction name="getTypeCount" output="false">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="type" type="String" required="true" default="">

	<cfset var rsTypeCount= ''/>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsTypeCount')#">
	select count(*) as Total from tcontent
	where active=1
	<cfif arguments.siteID neq ''>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.type neq ''>
		<cfif arguments.type eq 'Page'>
		 and type in ('Page','Calendar','Folder','Gallery')
		<cfelse>
		and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>
		</cfif>
	</cfif>

	</cfquery>

	<cfreturn rsTypeCount />
</cffunction>

<cffunction name="getRecentUpdates" output="false">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">

	<cfset var rsRecentUpdate= ''/>
	<cfset var dbType=variables.configBean.getDbType() />

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsRecentUpdate')#">
	<cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	select <cfif dbType eq "mssql"  and arguments.limit>Top #val(arguments.limit)#</cfif>
	contentID,contentHistID,approved,menutitle,parentID,moduleID,siteid,lastupdate,lastUpdatebyID,lastUpdateBy,type from tcontent
	where active=1 and type not in ('Module','Plugin')
	<cfif arguments.siteID neq ''>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>

	<cfif isdate(arguments.stopDate)>and lastUpdate <=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and lastUpdate >=  <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>

	order by lastupdate desc

	<cfif listFindNoCase("mysql,postgresql", dbType) and arguments.limit>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#" /></cfif>
	<cfif dbType eq "nuodb" and arguments.limit>fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#" /></cfif>
	<cfif dbType eq "oracle" and arguments.limit>) where ROWNUM <=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#" /> </cfif>
	</cfquery>

	<cfreturn rsRecentUpdate />
</cffunction>

<cffunction name="getRecentFormActivity" output="false">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">

	<cfset var rsFormActivity= ''/>
	<cfset var dbType=variables.configBean.getDbType() />

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsFormActivity')#">
	<cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	select <cfif dbType eq "mssql"  and arguments.limit>Top #val(arguments.limit)#</cfif>
	contentID,contentHistID,approved,menutitle,parentID,moduleID,tcontent.siteid,
	lastupdate,lastUpdatebyID,lastUpdateBy,type, count(formID) as Submissions,max(entered) as lastEntered
	from tcontent
	inner join tformresponsepackets on (tcontent.contentID=tformresponsepackets.formID)
	where active=1 and type ='Form'
	<cfif arguments.siteID neq ''>
	and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>

	group by

	contentID,contentHistID,approved,menutitle,parentID,moduleID,tcontent.siteid,
	lastupdate,lastUpdatebyID,lastUpdateBy,type

	order by lastEntered desc

	<cfif listFindNoCase("mysql,postgresql", dbType) and arguments.limit>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#" /></cfif>
	<cfif dbType eq "nuodb" and arguments.limit>fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#" /></cfif>
	<cfif dbType eq "oracle" and arguments.limit>) where ROWNUM <=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limit#" /> </cfif>
	</cfquery>

	<cfreturn rsFormActivity />
</cffunction>

<cffunction name="getTagCloud" output="false">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfargument name="categoryID" type="string" required="true" default="">
	<cfargument name="rsContent" type="any" required="true" default="">
	<cfargument name="moduleID" type="string" required="true" default="00000000000000000000000000000000000">
	<cfargument name="taggroup" default="">

	<cfset var rsTagCloud= ''/>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsTagCloud')#">
	select tag, count(tag) as tagCount
	from tcontenttags
	inner join tcontent on (tcontenttags.contenthistID=tcontent.contenthistID)
	<cfif arguments.moduleID eq '00000000000000000000000000000000000'>
	left Join tcontent tparent on (tcontent.parentid=tparent.contentid
					    			and tcontent.siteid=tparent.siteid
					    			and tparent.active=1)
	</cfif>
	<cfif len(arguments.categoryID)>
		inner join tcontentcategoryassign
		on (tcontent.contentHistID=tcontentcategoryassign.contentHistID)
		inner join tcontentcategories
		on (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
	</cfif>
	where tcontent.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	  AND tcontent.Approved = 1
	  AND tcontent.active = 1
      <cfif arguments.moduleID eq '00000000000000000000000000000000000'>AND tcontent.isNav = 1</cfif>
	  AND tcontent.moduleid =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#"/>

	<cfif len(arguments.parentID)>
		and tcontent.parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
	</cfif>

	<cfif len(arguments.categoryID)>
		and tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.categoryID#%"/>
	</cfif>

	<cfif len(arguments.taggroup) and arguments.taggroup neq 'default'>
		and tcontenttags.taggroup=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.taggroup#"/>
	<cfelse>
		and tcontenttags.taggroup is null
	</cfif>

	  AND
		(

			tcontent.Display = 1
		OR
			(
				tcontent.Display = 2

				AND
				 (
					(
						tcontent.DisplayStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#now()#">
						AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#now()#"> or tcontent.DisplayStop is null)
					)
					<cfif arguments.moduleID eq '00000000000000000000000000000000000'>OR tparent.type='Calendar'</cfif>
				  )
			)


		)

	#renderMobileClause()#

	<cfif isQuery(arguments.rsContent)  and arguments.rsContent.recordcount> and contentID in (#quotedValuelist(arguments.rsContent.contentID)#)</cfif>
	group by tag
	order by tag
	</cfquery>

	<cfreturn rsTagCloud />
</cffunction>

<cffunction name="getObjects" output="false">
	<cfargument name="columnID" required="yes" type="numeric" >
	<cfargument name="ContentHistID" required="yes" type="string" >
	<cfargument name="siteID" required="yes" type="string" >

	<cfset var rsObjects=""/>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsObjects')#">
	select tcontentobjects.object,tcontentobjects.name,tcontentobjects.objectid, tcontentobjects.orderno, tcontentobjects.params, tplugindisplayobjects.configuratorInit from tcontentobjects
	inner join tcontent On(
	tcontentobjects.contenthistid=tcontent.contenthistid
	and tcontentobjects.siteid=tcontent.siteid)
	left join tplugindisplayobjects on (tcontentobjects.object='plugin'
										and tcontentobjects.objectID=tplugindisplayobjects.objectID)
	where tcontent.siteid=<cfqueryparam value="#arguments.siteid#" cfsqltype="cf_sql_varchar">
	and tcontent.contenthistid =<cfqueryparam value="#arguments.ContentHistID#" cfsqltype="cf_sql_varchar">
	and tcontentobjects.columnid=<cfqueryparam value="#arguments.columnID#" cfsqltype="cf_sql_integer">
	order by tcontentobjects.orderno
	</cfquery>

	<cfreturn rsObjects>

</cffunction>

<cffunction name="getObjectInheritance" output="false">
	<cfargument name="columnID" required="yes" type="numeric" >
	<cfargument name="inheritedObjects" required="yes" type="string" >
	<cfargument name="siteID" required="yes" type="string" >

	<cfset var rsObjectInheritence=""/>
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsObjectInheritence')#">
	select tcontentobjects.object, tcontentobjects.name, tcontentobjects.objectid, tcontentobjects.orderno, tcontentobjects.params, tplugindisplayobjects.configuratorInit from tcontentobjects
	left join tplugindisplayobjects on (tcontentobjects.object='plugin'
										and tcontentobjects.objectID=tplugindisplayobjects.objectID)
	where
	tcontentobjects.contenthistid =<cfqueryparam value="#arguments.inheritedObjects#" cfsqltype="cf_sql_varchar">
	and tcontentobjects.siteid=<cfqueryparam value="#arguments.siteID#" cfsqltype="cf_sql_varchar">
	and tcontentobjects.columnid=<cfqueryparam value="#arguments.columnID#" cfsqltype="cf_sql_integer">
	and tcontentobjects.object <>'goToFirstChild'
	order by orderno
	</cfquery>

	<cfreturn rsObjectInheritence>

</cffunction>

<cffunction name="getExpiringContent" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="userid" type="string" required="true">
	<cfset var rsExpiringContent = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsExpiringContent',maxrows=1000)#">
	SELECT contentid
	FROM tcontent

	WHERE
	lastUpdateByID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	and
	active=1
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and expires <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#dateAdd("m",1,now())#">
	and expires > <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#dateAdd("m",-12,now())#">

	UNION

	SELECT tcontent.contentid
	FROM tcontent inner join tcontentassignments on (tcontent.contentHistID=tcontentassignments.contentHistID
													and tcontentassignments.type='expire')

	WHERE
	tcontent.active=1
	and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and tcontentassignments.userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	and tcontent.expires <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#dateAdd("m",1,now())#">
	and tcontent.expires > <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#dateAdd("m",-12,now())#">
	</cfquery>


	<cfreturn rsExpiringContent />
</cffunction>

<cffunction name="getLockedContentCount" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="userid" type="string" required="true">
	<cfset var rs = "">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs',maxrows=1000)#">
	SELECT count(*) as theCount
	FROM tcontentstats
	WHERE
	tcontentstats.lockid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>

	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getReleaseCountByMonth" output="false">
<cfargument name="siteid">
<cfargument name="parentID">
<cfset var rsReleaseCountByMonth="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsReleaseCountByMonth')#">
		select
			parentID,
			<cfif variables.configBean.getDbType() eq 'oracle'>
			TO_NUMBER(TO_CHAR(releaseDate, 'mm')) m,
			TO_NUMBER(TO_CHAR(releaseDate, 'yyyy')) y,
			<cfelseif variables.configBean.getDbType() eq 'postgresql'>
			date_part('month', releaseDate) m,
			date_part('year', releaseDate) y,
			<cfelse>
			month(releaseDate) m,
			year(releaseDate) y,
			</cfif>
			count(*) items
		from tcontent
		where parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#">
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
        #renderActiveClause("tcontent",arguments.siteID)#
		and releaseDate is not null
		and display != 0
		and isNav = 1
		group by parentID,
		<cfif variables.configBean.getDbType() eq 'oracle'>
			TO_NUMBER(TO_CHAR(releaseDate, 'mm')),
			TO_NUMBER(TO_CHAR(releaseDate, 'yyyy'))
		<cfelseif variables.configBean.getDbType() eq 'postgresql'>
			date_part('month', releaseDate),
			date_part('year', releaseDate)
		<cfelse>
			month(releaseDate),
			year(releaseDate)
		</cfif>

		union

		select
			parentID,
			<cfif variables.configBean.getDbType() eq 'oracle'>
			TO_NUMBER(TO_CHAR(lastUpdate, 'mm')) m,
			TO_NUMBER(TO_CHAR(lastUpdate, 'yyyy')) y,
			<cfelseif variables.configBean.getDbType() eq 'postgresql'>
			date_part('month', lastUpdate) m,
			date_part('year', lastUpdate) y,
			<cfelse>
			month(lastUpdate) m,
			year(lastUpdate) y,
			</cfif>
			count(*) items
		from tcontent
		where parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#">
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
        #renderActiveClause("tcontent",arguments.siteID)#
		and releaseDate is null
		and display != 0
		and isNav = 1
		group by parentID,
		<cfif variables.configBean.getDbType() eq 'oracle'>
			TO_NUMBER(TO_CHAR(lastUpdate, 'mm')),
			TO_NUMBER(TO_CHAR(lastUpdate, 'yyyy'))
		<cfelseif variables.configBean.getDbType() eq 'postgresql'>
			date_part('month', lastUpdate),
			date_part('year', lastUpdate)
		<cfelse>
			month(lastUpdate),
			year(lastUpdate)
		</cfif>
	</cfquery>

	<cfquery name="rsReleaseCountByMonth"dbtype="query">
		select rsReleaseCountByMonth.m,rsReleaseCountByMonth.y, sum(rsReleaseCountByMonth.items) items
		from rsReleaseCountByMonth
		group by rsReleaseCountByMonth.y,rsReleaseCountByMonth.m
		order by rsReleaseCountByMonth.y,rsReleaseCountByMonth.m desc
 	</cfquery>

	<cfquery name="rsReleaseCountByMonth"dbtype="query">
		select m as [month] ,y as [year], items from rsReleaseCountByMonth
		order by [year] desc, [month] desc
 	</cfquery>

	<cfreturn rsReleaseCountByMonth>
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
				and #arguments.table#.Approved = 1
				and #arguments.table#.contentID not in (#previewData.contentIDList#)
				)

				or

				(
				#arguments.table#.contentHistID in (#previewData.contentHistIDList#)
				)
			)
		<cfelse>
			and #arguments.table#.active = 1
			and #arguments.table#.Approved = 1
		</cfif>
	</cfoutput>
</cffunction>


<cffunction name="renderMenuTypeClause" output="true">
<cfargument name="menuType">
<cfargument name="menuDateTime">
<cfoutput>
			<cfswitch expression="#arguments.menuType#">
					<cfcase value="Calendar,CalendarDate">
						tcontent.Display = 2
					 	AND
						  (
						  	tcontent.DisplayStart < #renderDateTimeArg(dateadd("D",1,arguments.menuDateTime))#
						  	AND
						  		(
						  			tcontent.DisplayStop >= #renderDateTimeArg(arguments.menuDateTime)# or tcontent.DisplayStop is null
						  		)
						  	)
					</cfcase>
					<cfcase value="calendar_features">
					  	tcontent.Display = 2
					 	AND
					  		(
					  			tcontent.DisplayStart >= #renderDateTimeArg(arguments.menuDateTime)#
					  			OR (
									tcontent.DisplayStart < #renderDateTimeArg(arguments.menuDateTime)# AND tcontent.DisplayStop >= #renderDateTimeArg(arguments.menuDateTime)#
								)
					  		)
					 </cfcase>
					 <cfcase value="ReleaseDate">
					 	(
						 	tcontent.Display = 1

						 OR
						 	(
						   	tcontent.Display = 2
						 	 	AND
						 	 	(
						 	 		tcontent.DisplayStart < #renderDateTimeArg(dateadd("D",1,arguments.menuDateTime))#
							  		AND (
							  				tcontent.DisplayStop >= #renderDateTimeArg(arguments.menuDateTime)# or tcontent.DisplayStop is null
							  			)
								)
							)
						)

						AND

						(
						  	(
						  		tcontent.releaseDate < #renderDateTimeArg(dateadd("D",1,arguments.menuDateTime))#
						  		AND tcontent.releaseDate >= #renderDateTimeArg(arguments.menuDateTime)#
						  	)

						  	OR
						  	 (
						  	 	tcontent.releaseDate is Null
						  		AND tcontent.lastUpdate < #renderDateTimeArg(dateadd("D",1,arguments.menuDateTime))#
						  		AND tcontent.lastUpdate >= #renderDateTimeArg(arguments.menuDateTime)#
						  	)
					  	)

					  </cfcase>
					  <cfcase value="ReleaseMonth">
					   (
						 	tcontent.Display = 1

						 	OR

						 	(
						   		tcontent.Display = 2

								AND
								(
									tcontent.DisplayStart <= #renderDateTimeArg(now())#
									AND tcontent.DisplayStart < #renderDateTimeArg(dateadd("M",1,arguments.menuDateTime))#
									AND (
										tcontent.DisplayStop >= #renderDateTimeArg(now())#
										or tcontent.DisplayStop is null
									)

								)
							)
						)

						AND
						(
						  	(
						  		tcontent.releaseDate < #renderDateTimeArg(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
						  		AND  tcontent.releaseDate >= #renderDateTimeArg(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))#
							)

						  	OR
					  		(
					  			tcontent.releaseDate is Null
					  			AND tcontent.lastUpdate < #renderDateTimeArg(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
					  			AND tcontent.lastUpdate >= #renderDateTimeArg(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))#
					  		)
					  	)
					   </cfcase>
					  <cfcase value="CalendarMonth">
						tcontent.display=2

						AND
							(
								(
									tcontent.displayStart < #renderDateTimeArg(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
									AND  tcontent.displayStart >= #renderDateTimeArg(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))#
								)

								or

								(
									tcontent.displayStop < #renderDateTimeArg(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
									AND
										(
											tcontent.displayStop >= #renderDateTimeArg(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))#
											or
											tcontent.displayStop is null
										)
								)

								or

								(
									tcontent.displayStart < #renderDateTimeArg(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))#
									and
										(
											tcontent.displayStop >= #renderDateTimeArg(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
											or
											tcontent.displayStop is null
										)

								)
							)
					  </cfcase>
					  <cfcase value="ReleaseYear">
						  (

							    tcontent.Display = 1

							    OR
							        (
							            tcontent.Display = 2
							                AND (
							                    tcontent.DisplayStart < #renderDateTimeArg(dateadd("D",1,arguments.menuDateTime))# AND (
							                        tcontent.DisplayStop >= #renderDateTimeArg(arguments.menuDateTime)# or tcontent.DisplayStop is null
							                    )
							            )
							    )

							) AND (

							    	(
							        	tcontent.releaseDate < #renderDateTimeArg(dateadd("D",1,createDate(year(arguments.menuDateTime),12,31)))# AND tcontent.releaseDate >= #renderDateTimeArg(createDate(year(arguments.menuDateTime),1,1))#
									)
							    OR
							        (
							            tcontent.releaseDate is Null AND tcontent.lastUpdate < #renderDateTimeArg(dateadd("D",1,createDate(year(arguments.menuDateTime),12,31)))# AND tcontent.lastUpdate >= #renderDateTimeArg(createDate(year(arguments.menuDateTime),1,1))#
							        )
							    )
					  </cfcase>
					  <cfcase value="fixed">

					  	tcontent.Display = 1

					   </cfcase>
					  <cfdefaultcase>

					 	tcontent.Display = 1
					  	OR
					  	(
					  		tcontent.Display = 2
					 		AND
					 	 		(
					 	 			tcontent.DisplayStart < #renderDateTimeArg(arguments.menuDateTime)#
						  			AND
						  				(
						  					tcontent.DisplayStop >= #renderDateTimeArg(arguments.menuDateTime)# or tcontent.DisplayStop is null
						  				)
						  		)
						)

					  </cfdefaultcase>
			</cfswitch>
</cfoutput>
</cffunction>

<cffunction name="renderDateTimeArg" output="false">
        <cfargument name="date">

        <cfif isDate(arguments.date)>
        	<cfif variables.configBean.getCompiler() eq "Adobe" and variables.configBean.getDbType() eq "MSSQL">
                <cfreturn "'" & dateFormat(createODBCDateTime(arguments.date), "yyyy-mm-dd") & 'T' & timeFormat(createODBCDateTime(arguments.date), "HH:mm:ss.l") & "'">
        	<cfelseif variables.configBean.getDbType() eq "Oracle">
				<cfreturn "to_date('#dateFormat(arguments.date,"yyyy-mm-dd")# #timeFormat(arguments.date,"HH:mm:ss")#','YYYY-MM-DD HH24:MI:SS')">
			<cfelse>
        		<cfreturn createODBCDateTime(arguments.date)>
        	</cfif>
        <cfelse>
            <cfreturn "null">
        </cfif>
</cffunction>

<cffunction name="renderMobileClause" output="true">
	<cfoutput>
	and (tcontent.mobileExclude is null
		OR
		<cfif request.muraMobileRequest>
			tcontent.mobileExclude in (0,2)
		<cfelse>
			tcontent.mobileExclude in (0,1)
		</cfif>
	)
	</cfoutput>
</cffunction>

<cffunction name="renderTextParamColumn">
	<cfargument name="column">

	<cfif variables.configBean.getDBCaseSensitive()>
		<cfreturn "UPPER(#arguments.column#)">
	<cfelse>
		<cfreturn arguments.column>
	</cfif>
</cffunction>

<cffunction name="renderTextParamValue">
	<cfargument name="value">

	<cfif variables.configBean.getDBCaseSensitive()>
		<cfreturn ucase(arguments.value)>
	<cfelse>
		<cfreturn arguments.value>
	</cfif>
</cffunction>

<cffunction name="renderDateTimeParamType">
	<cfif variables.configBean.getDBType() eq 'Oracle'>
		<!--- This was cf_sql_date,but it was loosing precision.  Looking for better solution--->
		<cfreturn "cf_sql_timestamp">
	<cfelse>
		<cfreturn "cf_sql_timestamp">
	</cfif>
</cffunction>

</cfcomponent>
