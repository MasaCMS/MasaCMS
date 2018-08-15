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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides content feed gateway queries">

<cffunction name="init" output="false">
	<cfargument name="configBean" type="any" required="yes" />
	<cfargument name="contentIntervalManager" type="any" required="yes" />
	<cfargument name="permUtility" type="any" required="yes" />
	<cfargument name="utility" type="any" required="yes" />

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
	<cfset variables.contentIntervalManager=arguments.contentIntervalManager>
	<cfset variables.permUtility=arguments.permUtility>
	<cfset variables.utility=arguments.utility>
	<cfreturn this />
</cffunction>

<cffunction name="getFeeds" output="false">
	<cfargument name="siteID" type="String">
	<cfargument name="type" type="String">
	<cfargument name="publicOnly" type="boolean" required="true" default="false">
	<cfargument name="activeOnly" type="boolean" required="true" default="false">

	<cfset var rsFeeds ="" />

	<cfquery name="rsFeeds" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select * from tcontentfeeds
	where siteID= <cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.siteID#">
	and Type= <cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
	<cfif arguments.publicOnly>
	and isPublic=1
	</cfif>

	<cfif arguments.activeOnly>
	and isactive=1
	</cfif>
	order by name
	</cfquery>

	<cfreturn rsFeeds />
</cffunction>

<cffunction name="getDefaultFeeds" output="false">
	<cfargument name="siteID" type="String">

	<cfset var rsDefaultFeeds ="" />

	<cfquery name="rsDefaultFeeds" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select * from tcontentfeeds
	where siteID= <cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.siteID#">
	and isDefault=1
	order by name
	</cfquery>

	<cfreturn rsDefaultFeeds />
</cffunction>

<cffunction name="getFeed" output="false">
	<cfargument name="feedBean" type="any">
	<cfargument name="tag" required="true" default="">
	<cfargument name="aggregation" required="true" type="boolean" default="false">
	<cfargument name="applyPermFilter" required="true" type="boolean" default="false">
	<cfargument name="countOnly" required="true" type="boolean" default="false">
	<cfargument name="menuType" default="default">
	<cfargument name="from" required="true" default="">
	<cfargument name="to" required="true" default="">
	<cfargument name="applyIntervals" required="true" type="boolean" default="true">

	<cfset var c ="" />
	<cfset var rsFeed ="" />
	<cfset var contentLen =listLen(arguments.feedBean.getcontentID()) />
	<cfset var categoryLen =listLen(arguments.feedBean.getCategoryID()) />
	<cfset var categoryList=arguments.feedBean.getCategoryID()>
	<cfset var rsParams=arguments.feedBean.getAdvancedParams() />
	<cfset var started =false />
	<cfset var isNullVal=false>
	<cfset var param =createObject("component","mura.queryParam")/>
	<cfset var doTags =false />
	<cfset var openGrouping =false />
	<cfset var dbType=variables.configBean.getDbType() />
	<cfset var sortOptions="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,expires,rating,comment,credits,type,subtype">
	<cfset var isExtendedSort=(not listFindNoCase(sortOptions,arguments.feedBean.getSortBy()))>
	<cfset var nowAdjusted="">
	<cfset var blockFactor=arguments.feedBean.getNextN()>
	<cfset var jointables="" />
	<cfset var jointable="">
	<cfset var histtables="tcontenttags,tcontentcategoryassign,tcontentobjects,tcontentrelated,tcontentassignments">
	<cfset var rsAttribute="">
	<cfset var isListParam=false>
	<cfset var tableModifier="">
	<cfset var alpha="a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1,l1,m1,n1,o1,p1,q1,r1,s1,t1,u1,v1,w1,x1,y1,z1">
	<cfset var altTable=arguments.feedBean.getAltTable()>
	<cfset var castfield="attributeValue">
	<cfset var palias="">
	<cfset var talias="">
	<cfset var paramCatLen=0>
	<cfset var paramCatList="">
	<cfset var paramCatItem="">

	<cfif not len(altTable) and len(variables.configBean.getContentGatewayTable())>
		<cfset altTable=variables.configBean.getContentGatewayTable()>
	</cfif>

	<cfif altTable eq 'tcontent'>
		<cfset altTable=''>
	</cfif>

	<cfif dbtype eq "MSSQL">
		<cfset tableModifier="with (nolock)">
	</cfif>

	<cfif blockFactor gt 100>
		<cfset blockFactor=100>
	</cfif>

	<cfif request.muraChangesetPreview and isStruct(getCurrentUser().getValue("ChangesetPreviewData"))>
		<cfset nowAdjusted=getCurrentUser().getValue("ChangesetPreviewData").publishDate>
	</cfif>

	<cfif isDate(request.muraPointInTime)>
		<cfset nowAdjusted=request.muraPointInTime>
	</cfif>

	<cfif not isdate(nowAdjusted)>
			<cfset nowAdjusted=now()>
	</cfif>

	<cfset nowAdjusted=variables.utility.datetimeToTimespanInterval(nowAdjusted,arguments.feedBean.getCachedWithin())>

	<cfif not(isDate(arguments.from) and isDate(arguments.to))>
		<cfset arguments.from=nowAdjusted>
		<cfset arguments.to=dateAdd('m',12,nowAdjusted)>
	</cfif>

	<cfif len(arguments.tag)>
		<cfset jointables="tcontenttags">
	</cfif>

	<cfloop query="rsParams">
		<cfif listLen(rsParams.field,".") eq 2>
			<cfset jointable=REReplace(listFirst(rsParams.field,"."),"[^0-9A-Za-z_,\- ]","","all") >
			<cfif not listFindNoCase("tcontent,tcontentstats,tfiles,tparent,tcontentcategoryassign,tcontenttags,tcontentcategories",jointable) and not listFind(jointables,jointable)>
				<cfset jointables=listAppend(jointables,jointable)>
			</cfif>
		</cfif>
	</cfloop>

	<cfif (arguments.feedBean.getSortBy() eq 'mxpRelevance' or listFirst(arguments.feedBean.getOrderBy(),' ') eq 'mxpRelevance' ) and not (arguments.countOnly)>
		<cfif not isdefined('session.mura.mxp')>
			<cfset session.mura.mxp=getBean('marketingManager').getDefaults()>
		</cfif>
		<cfparam name="session.mura.mxp.trackingProperties.personaid" default=''>
		<cfparam name="session.mura.mxp.trackingProperties.stageid" default=''>
		<cfset var mxpRelevanceSort=true>
	<cfelse>
		<cfset var mxpRelevanceSort=false>
	</cfif>

	<cfprocessingdirective suppressWhitespace="true">
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsFeed',blockFactor=blockFactor,cachedWithin=arguments.feedBean.getCachedWithin())#">
			<cfif not arguments.countOnly and dbType eq "oracle" and arguments.feedBean.getMaxItems()>SELECT * FROM (</cfif>
			SELECT
				<cfif arguments.feedBean.getDistinct()>distinct</cfif>
				<cfif not arguments.countOnly and dbtype eq "mssql" and arguments.feedBean.getMaxItems()>top #arguments.feedBean.getMaxItems()#</cfif>

				<cfif not arguments.countOnly>
					<cfif len(arguments.feedBean.getFields())>
						#REReplace(arguments.feedBean.transformFields(arguments.feedBean.getFields()),"[^0-9A-Za-z\._,\- ]","","all")#
						<cfelseif arguments.feedBean.isAggregateQuery()>
							<cfset started=false>
							<cfif arrayLen(arguments.feedBean.getGroupByArray())>
								<cfloop array="#arguments.feedBean.getGroupByArray()#" index="local.i">
									<cfif started>, <cfelse><cfset started=true></cfif>
									#sanitizedValue(local.i)#
								</cfloop>
							</cfif>
							<cfif arrayLen(arguments.feedBean.getSumValArray())>
								<cfloop array="#arguments.feedBean.getSumValArray()#" index="local.i">
									<cfif started>, <cfelse><cfset started=true></cfif>
									sum(#sanitizedValue(local.i)#) as sum_#sanitizedValue(listLast(local.i,'.'))#
								</cfloop>
							</cfif>
							<cfif arrayLen(arguments.feedBean.getCountValArray())>
								<cfloop array="#arguments.feedBean.getCountValArray()#" index="local.i">
									<cfif started>, <cfelse><cfset started=true></cfif>
									<cfif listLast(local.i,'.') eq '*'>count(*) as count<cfelse>count(#sanitizedValue(local.i,'.')#) as count_#sanitizedValue(listLast(local.i,'.'))#</cfif>
								</cfloop>
							</cfif>
							<cfif arrayLen(arguments.feedBean.getAvgValArray())>
								<cfloop array="#arguments.feedBean.getAvgValArray()#" index="local.i">
									<cfif started>, <cfelse><cfset started=true></cfif>
									avg(#sanitizedValue(local.i)#) as avg_#sanitizedValue(listLast(local.i,'.'))#
								</cfloop>
							</cfif>
							<cfif arrayLen(arguments.feedBean.getMinValArray())>
								<cfloop array="#arguments.feedBean.getMinValArray()#" index="local.i">
									<cfif started>, <cfelse><cfset started=true></cfif>
									min(#sanitizedValue(local.i)#) as min_#sanitizedValue(listLast(local.i,'.'))#
								</cfloop>
							</cfif>
							<cfif arrayLen(arguments.feedBean.getMaxValArray())>
								<cfloop array="#arguments.feedBean.getMaxValArray()#" index="local.i">
									<cfif started>, <cfelse><cfset started=true></cfif>
									max(#sanitizedValue(local.i)#) as max_#sanitizedValue(listLast(local.i,'.'))#
								</cfloop>
							</cfif>
							<cfset started=false>

					<cfelseif len(altTable)>
						tcontent.*
					<cfelse>
						tcontent.siteid, tcontent.title, tcontent.menutitle, tcontent.restricted, tcontent.restrictgroups,
						tcontent.type, tcontent.subType, tcontent.filename, tcontent.displaystart, tcontent.displaystop,
						tcontent.remotesource, tcontent.remoteURL,tcontent.remotesourceURL, tcontent.keypoints,
						tcontent.contentID, tcontent.parentID, tcontent.approved, tcontent.isLocked, tcontent.contentHistID,tcontent.target, tcontent.targetParams,
						tcontent.releaseDate, tcontent.lastupdate,tcontent.summary,
						tfiles.fileSize,tfiles.fileExt,tcontent.fileid,
						tcontent.tags,tcontent.credits,tcontent.audience, tcontent.orderNo,
						tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes,
						tcontentstats.comments, tparent.type parentType,
						tcontent.path, tcontent.created, tcontent.nextn, tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,
						tfiles.filename as AssocFilename,tcontent.displayInterval,tcontent.display,tcontentfilemetadata.altText as fileAltText,tcontent.changesetid
					</cfif>

					<cfif mxpRelevanceSort>
					,tracktotal.track_total_score as total_score, (stagetotal.stage_points + personatotal.persona_points) as total_points
					</cfif>
				<cfelse>
					count(*) as count
				</cfif>

			FROM
				<cfif len(altTable)>#arguments.feedBean.getAltTable()#</cfif> tcontent #tableModifier#

				<cfset local.specifiedjoins=arguments.feedBean.getJoins()>

				<!--- Join to implied tables based on field prefix --->
				<cfloop list="#jointables#" index="jointable">
					<cfset started=false>

					<cfif arrayLen(arguments.feedBean.getJoins())>
						<cfloop from="1" to="#arrayLen(local.specifiedjoins)#" index="local.i">
							<cfif local.specifiedjoins[local.i].table eq jointable>
								<cfset started=true>
								<!--- has explicit join clause--->
								<cfbreak>
							</cfif>
						</cfloop>
					</cfif>
					<cfif not started>
						<cfif listFindNoCase(histtables,jointable)>
							inner join #jointable# #tableModifier# on (tcontent.contenthistid=#jointable#.contenthistid)
						<cfelse>
							inner join #jointable# #tableModifier# on (tcontent.contentid=#jointable#.contentid)
						</cfif>
					</cfif>
				</cfloop>

				<!--- Join to explicit tables based on join clauses --->
				<cfloop from="1" to="#arrayLen(local.specifiedjoins)#" index="local.i">
					<cfif len(local.specifiedjoins[local.i].clause)>
						#local.specifiedjoins[local.i].jointype# join #local.specifiedjoins[local.i].table# #tableModifier# on (#local.specifiedjoins[local.i].clause#)
					</cfif>
				</cfloop>

				<cfif not len(arguments.feedBean.getAltTable())>
					left Join tfiles #tableModifier# on (tcontent.fileid=tfiles.fileid)
					left Join tcontentstats #tableModifier# on (tcontent.contentid=tcontentstats.contentid
						and tcontent.siteid=tcontentstats.siteid)
					Left Join tcontent tparent #tableModifier# on (tcontent.parentid=tparent.contentid
						and tcontent.siteid=tparent.siteid
						and tparent.active=1)
					Left Join tcontentfilemetadata #tableModifier# on (tcontent.fileid=tcontentfilemetadata.fileid
						and tcontent.contenthistid=tcontentfilemetadata.contenthistid
						and tcontent.siteid=tcontentfilemetadata.siteid)
				</cfif>

				<cfif mxpRelevanceSort>
					left join (
						select sum(persona.points) persona_points, persona.contenthistid
						from mxp_personapoints persona
						where persona.personaid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.mura.mxp.trackingProperties.personaid#">
						group by persona.contenthistid
					) personatotal on (tcontent.contenthistid = personatotal.contenthistid)

					left join (
						select sum(stage.points) stage_points, stage.contenthistid
						from mxp_stagepoints stage
						where stage.stageid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.mura.mxp.trackingProperties.stageid#">
						group by stage.contenthistid
					) stagetotal on (tcontent.contenthistid = stagetotal.contenthistid)

					left join (
						select sum(track.points) track_total_score, track.contentid
						from mxp_conversiontrack track
						where track.created >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#dateAdd('m',-1,nowAdjusted)#">
						and track.points > 0
						group by track.contentid
					) tracktotal on (tcontent.contentid=tracktotal.contentid)
				</cfif>

				<cfif not arguments.countOnly and isExtendedSort>
					LEFT JOIN (
						SELECT
							#variables.classExtensionManager.getCastString(arguments.feedBean.getSortBy(),arguments.feedBean.getSiteID())# extendedSort,
							tclassextenddata.baseID
						FROM tclassextenddata #tableModifier#
							inner join tclassextendattributes #tableModifier#
								on (tclassextenddata.attributeID=tclassextendattributes.attributeID)
						WHERE tclassextendattributes.siteid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
							AND tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSortBy()#">
					) qExtendedSort
						ON (tcontent.contenthistid=qExtendedSort.baseID)
				</cfif>

			WHERE
				tcontent.siteid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
				#renderActiveClause("tcontent",arguments.feedBean.getSiteID(),arguments.feedBean.getLiveOnly(),arguments.feedBean.getActiveOnly())#
				<cfif arguments.feedBean.getShowNavOnly() and not listFindNoCase('Form,Component',arguments.feedBean.getType())>
					AND tcontent.isNav = 1
				</cfif>

				<cfif arguments.feedBean.getType() eq "Remote">
					<cfthrow message="This function is not available for remote feeds.">
				<cfelseif arguments.feedBean.getType() eq "Component">
					AND tcontent.moduleid = '00000000000000000000000000000000003'
				<cfelseif arguments.feedBean.getType() eq "Form">
					AND tcontent.moduleid = '00000000000000000000000000000000004'
				<cfelseif arguments.feedBean.getType() eq "Variation">
					AND tcontent.moduleid = '00000000000000000000000000000000099'
				<cfelseif arguments.feedBean.getType() eq "*">
					AND tcontent.moduleid in ('00000000000000000000000000000000003','00000000000000000000000000000000004','00000000000000000000000000000000099','00000000000000000000000000000000000')
				<cfelse>
					AND tcontent.moduleid = '00000000000000000000000000000000000'
				</cfif>

				<cfif not arguments.feedBean.getShowExcludeSearch()>
					AND tcontent.searchExclude = 0
				</cfif>

				<cfif not arguments.feedBean.getIncludeHomePage()>
					AND tcontent.contentid <> '00000000000000000000000000000000001'
				</cfif>

				AND tcontent.type <>'Module'

				<!--- rsParams --->
				<cfif rsParams.recordcount>
					<cfset started=false>
					<cfset openGrouping=false />

					<cfloop query="rsParams">
						<cfset param=createObject("component","mura.queryParam").init(
							relationship=rsParams.relationship,
							field=rsParams.field,
							datatype=rsParams.datatype,
							condition=rsParams.condition,
							criteria=rsParams.criteria
						) />

						<cfif param.getIsValid()>
							<cfset isNullVal = param.getCriteria() eq 'null' ? true : false />

							<cfif not started>
								<cfset openGrouping=true />
								and (
							</cfif>

							<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
								<cfif not openGrouping>and</cfif> (
								<cfset openGrouping=true />
							<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
								<cfif not openGrouping>or</cfif> (
								<cfset openGrouping=true />
							<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
								<cfif not openGrouping>and</cfif> (
								<cfset openGrouping=true />
							<cfelseif listFindNoCase("and not (",param.getRelationship())>
								<cfif not openGrouping>and</cfif> not (
								<cfset openGrouping=true />
							<cfelseif listFindNoCase("or not (",param.getRelationship())>
								<cfif not openGrouping>or</cfif> not (
								<cfset openGrouping=true />
							<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
								)
								<cfset openGrouping=false />
							<cfelseif not openGrouping>
								#param.getRelationship()#
							</cfif>

							<cfset isListParam=param.isListParam()>
							<cfset started=true>

							<cfif listLen(param.getField(),".") gt 1>
								<cfset jointable=listFirst(param.getField(),".")>
								<cfif listFind('tcontentcategoryassign,tcontentcategories',jointable)>
									tcontent.contenthistid <cfif param.getCondition() eq 'not in'>NOT IN <cfelse>IN</cfif> (
										SELECT DISTINCT contenthistid
										FROM tcontentcategoryassign #tableModifier#
										<cfif jointable eq 'tcontentcategories'>
											inner join tcontentcategories #tableModifier#
											ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
										</cfif>
										WHERE
											#param.getFieldStatement()#
											<cfif param.getCondition() eq 'not in'> IN <cfelse>#param.getCondition()#</cfif>
											<cfif param.getCriteria() eq 'null'>
 												NULL
											<cfelse>
												<cfif isListParam>(</cfif>
												<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
												<cfif isListParam>)</cfif>

												<cfif  listFindNoCase('tcontentcategoryassign.categoryid,tcontentcategories.path',param.getField())>
													<cfloop list="#param.getCriteria()#" index="paramCatItem">
														<cfset paramCatList=listAppend(paramCatList,paramCatItem)>
													</cfloop>
												</cfif>
											</cfif>
									)
								<cfelseif jointable eq "tcontenttags">
									tcontent.contenthistid <cfif param.getCondition() eq 'not in'>NOT IN <cfelse>IN</cfif> (
										SELECT DISTINCT contenthistid
										FROM tcontenttags #tableModifier#
										WHERE
											#param.getFieldStatement()#
											<cfif param.getCondition() eq 'not in'> IN <cfelse>#param.getCondition()#</cfif>
											<cfif param.getCriteria() eq 'null'>
												NULL
											<cfelse>
												<cfif isListParam>(</cfif>
												<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
												<cfif isListParam>)</cfif>
											</cfif>
									)
								<cfelse>
										#param.getFieldStatement()#
										#param.getCondition()#
										<cfif param.getCriteria() eq 'null'>
											 NULL
										<cfelse>
											<cfif isListParam>(</cfif>
											<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#">
											<cfif isListParam>)</cfif>
										</cfif>
								</cfif>
								<cfset started=true>
								<cfset openGrouping=false />
							<cfelseif len(param.getField())>
								<cfif not ((param.getCriteria() eq 'null' or param.getCriteria() eq '') and param.getCondition() eq 'is')>
									<cfset castfield="attributeValue">
									tcontent.contentHistID IN (
										SELECT tclassextenddata.baseID
										FROM tclassextenddata #tableModifier#

										<cfif isNumeric(param.getField())>
											WHERE
												tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
										<cfelse>
											INNER JOIN tclassextendattributes #tableModifier#
												ON (tclassextenddata.attributeID = tclassextendattributes.attributeID)
											WHERE
												tclassextendattributes.siteid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
												AND tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
										</cfif>

											AND

												<cfif param.getCriteria() neq 'null'>
													<cfif param.getCondition() neq "like">
														<cfif isDate(param.getCriteria()) or isNumeric(param.getCriteria())>
															<cfset castfield=variables.configBean.getClassExtensionManager().getCastString(param.getField(),arguments.feedBean.getsiteid())>
															<cfif castfield eq 'datetimevalue'>
																<cfset param.setDatatype('datetime')>
															<cfelseif castfield eq 'numericvalue'>
																<cfset param.setDatatype('Numeric')>
															</cfif>
														<cfelse>
															<cfset castfield=variables.configBean.getClassExtensionManager().getCastString(param.getField(),arguments.feedBean.getsiteid(),param.getDatatype())>
														</cfif>
													</cfif>

													<cfif param.getCondition() eq 'like' and variables.configBean.getDbCaseSensitive()>
														upper(#castfield#)
													<cfelse>
														#castfield#
													</cfif>
												<cfelse>
													#castfield#
												</cfif>

												#param.getCondition()#

												<cfif param.getCriteria() eq 'null'>
													NULL
												<cfelse>
													<cfif isListParam>(</cfif>
													<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
													<cfif isListParam>)</cfif>
												</cfif>
									)
									<cfset openGrouping=false />
								<cfelse>
									<cfset castfield="attributeValue">
									(tcontent.contentHistID NOT IN (
										SELECT tclassextenddata.baseID
										FROM tclassextenddata #tableModifier#

										<cfif isNumeric(param.getField())>
											WHERE
												tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
										<cfelse>
											INNER JOIN tclassextendattributes #tableModifier#
												ON (tclassextenddata.attributeID = tclassextendattributes.attributeID)
											WHERE
												tclassextendattributes.siteid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
												AND tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
										</cfif>
										)

										or

										tcontent.contentHistID IN (
											SELECT tclassextenddata.baseID
											FROM tclassextenddata #tableModifier#

											<cfif isNumeric(param.getField())>
												WHERE
													tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
											<cfelse>
												INNER JOIN tclassextendattributes #tableModifier#
													ON (tclassextenddata.attributeID = tclassextendattributes.attributeID)
												WHERE
													tclassextendattributes.siteid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
													AND tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
											</cfif>

											AND tclassextenddata.attributeValue is null
											)
										)
									<cfset openGrouping=false />
								</cfif>
							</cfif>
						</cfif>
					</cfloop>

					<cfif started>)</cfif>
				</cfif><!--- /if rsParams.recordcount --->

				<cfif len(arguments.tag)>
					and tcontenttags.tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#"/>
				</cfif>

				<cfif contentLen>
					and tcontent.parentid in (
					<cfloop from="1" to="#contentLen#" index="c">
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#listGetAt(arguments.feedBean.getcontentID(),c)#">,
					</cfloop>'')
				</cfif>

				<cfif categoryLen>
					<cfif arguments.feedBean.getUseCategoryIntersect()>
						AND tcontent.contentHistID in (
							select a.contentHistID from tcontentcategoryassign a #tableModifier#
							<cfif categoryLen gt 1>
								<cfloop from="2" to="#categoryLen#" index="c">
									<cfset palias = listGetAt(alpha,c-1)>
									<cfset talias = listGetAt(alpha,c)>
									inner join tcontentcategoryassign #talias# #tableModifier# on 	#palias#.contentHistID = #talias#.contentHistID and #talias#.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.feedBean.getCategoryID(),c)#">
								</cfloop>
							</cfif>
							where a.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.feedBean.getCategoryID(),1)#"/>
						)
					<cfelse>
						AND tcontent.contenthistID in (
							select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign #tableModifier#
							inner join tcontentcategories #tableModifier#
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
							where
							<cfif categoryLen>
								(
									<cfloop from="1" to="#categoryLen#" index="c">
										tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.feedBean.getCategoryID(),c)#%"/>
										<cfif c lt categoryLen> or </cfif>
									</cfloop>
								)
							<cfelse>
								tcontentcategories.categoryid=''
							</cfif>
						)
					</cfif>
				</cfif>

				<cfif arguments.feedBean.getIsFeaturesOnly()>
					AND
					(
						<cfif listFindNoCase('either,architecture',arguments.feedBean.getFeatureType())>
						(
							tcontent.isFeature = 1

							OR

							(	tcontent.isFeature = 2
								AND tcontent.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
								AND (tcontent.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or tcontent.FeatureStop is null)
							)
						)
						</cfif>

						<!--- Join any params that used categoryid --->
						<cfset categoryLen=categoryLen + listLen(paramCatList)>
						<cfloop list="#paramCatList#" index="paramCatItem">
							<cfset categoryList=listAppend(categoryList,paramCatItem)>
						</cfloop>

						<cfif listFindNoCase('either,category',arguments.feedBean.getFeatureType()) and categoryLen>
							<cfif arguments.feedBean.getFeatureType() eq 'either'>
								OR
							</cfif>
							<cfif arguments.feedBean.getUseCategoryIntersect()>
							tcontent.contentHistID in (
								select a.contentHistID from tcontentcategoryassign a
								<cfif categoryLen gt 1>
									<cfloop from="2" to="#categoryLen#" index="c">
										<cfset palias = listGetAt(alpha,c-1)>
										<cfset talias = listGetAt(alpha,c)>
										inner join tcontentcategoryassign #talias# #tableModifier# on
											(
												#palias#.contentHistID = #talias#.contentHistID
												and #talias#.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(categoryList,c)#"/>
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
								where a.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(categoryList,1)#"/>


								AND
									(
										a.isFeature = 1
									OR

										(	a.isFeature = 2
											AND a.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
											AND (a.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or a.FeatureStop is null)
										)

									)
							)
						<cfelse>
							tcontent.contenthistID in (
								select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign #tableModifier#
								inner join tcontentcategories #tableModifier#
								ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
								where
									<cfif categoryLen>
										(
											<cfloop from="1" to="#categoryLen#" index="c">
												tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(categoryList,c)#%"/>
												<cfif c lt categoryLen> or </cfif>
											</cfloop>
										)
									<cfelse>
										tcontentcategories.category=''
									</cfif>
								AND
									(
										tcontentcategoryassign.isFeature = 1
									OR

										(	tcontentcategoryassign.isFeature = 2
											AND tcontentcategoryassign.FeatureStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
											AND (tcontentcategoryassign.FeatureStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or tcontentcategoryassign.FeatureStop is null)
										)

									)
							)
						</cfif>
					</cfif>
					)
				</cfif>

				<cfif arguments.feedBean.getLiveOnly()>
					AND (
						tcontent.Display = 1
						OR
							(
								tcontent.Display = 2


								AND
								(

									(   <cfif len(altTable)>
											tcontent.parentType!='Calendar'
										<cfelse>
											tparent.type!='Calendar'
										</cfif>

										and tcontent.DisplayStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#">
										and (tcontent.DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#nowAdjusted#"> or tcontent.DisplayStop is null)
									) OR (
										<cfif len(altTable)>
											tcontent.parentType='Calendar'
										<cfelse>
											tparent.type='Calendar'
										</cfif>

										and tcontent.DisplayStart <= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#arguments.to#">
										and (tcontent.DisplayStop >= <cfqueryparam cfsqltype="#renderDateTimeParamType()#" value="#arguments.from#"> or tcontent.DisplayStop is null)
									)
								)
							)

					)

					AND (
						tcontent.mobileExclude is null
						OR
						<cfif request.muraMobileRequest>
							tcontent.mobileExclude in (0,2)
						<cfelse>
							tcontent.mobileExclude in (0,1)
						</cfif>
					)
				</cfif>

				<cfset started=false>
				<cfif arrayLen(arguments.feedBean.getGroupByArray())>
					group by
					<cfloop array="#arguments.feedBean.getGroupByArray()#" index="local.i">
						<cfif started>, <cfelse><cfset started=true></cfif>
						#sanitizedValue(local.i)#
					</cfloop>
				</cfif>
				<cfset started=false>

				<cfif not arguments.countOnly>
					<cfif arguments.feedBean.getSortBy() neq '' or arguments.feedBean.getOrderBy() neq ''>
						order by

						<cfif len(arguments.feedBean.getOrderBy())>
							<cfif mxpRelevanceSort>
								<cfif listLast(arguments.feedBean.getOrderBy(),' ') eq 'asc'>
									total_points asc, total_score asc
								<cfelse>
									total_points desc, total_score desc
								</cfif>
								,tcontent.releaseDate desc, tcontent.lastUpdate desc <!--- tie-breaker sort options for articles with the same MXP points/scores. Show the most recent one first. --->
							<cfelseif arguments.feedBean.getOrderBy() eq 'random'>
								<cfif dbType eq "mysql">
									rand()
								<cfelseif dbType eq "postgresql">
									random()
								<cfelseif dbType eq "mssql">
									newID()
								<cfelseif dbType eq "oracle">
									dbms_random.value
								</cfif>
							<cfelse>
									#REReplace(arguments.feedBean.getOrderBy(),"[^0-9A-Za-z\._,\-%//""'' ]","","all")#
							</cfif>
						<cfelse>
							<cfswitch expression="#arguments.feedBean.getSortBy()#">
								<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displaystart,displaystop,created,expires,credits,type,subtype">
									<cfif dbType neq "oracle" or listFindNoCase("orderno,releaseDate,lastUpdate,created,displayStart,displayStop",arguments.feedBean.getSortBy())>
										tcontent.#arguments.feedBean.getSortBy()# #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#
									<cfelse>
										lower(tcontent.#arguments.feedBean.getSortBy()#) #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#
									</cfif>
								</cfcase>
								<cfcase value="rating">
									tcontentstats.rating #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#, tcontentstats.totalVotes #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#
								</cfcase>
								<cfcase value="comments">
									tcontentstats.comments #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#
								</cfcase>
								<cfcase value="random">
									<cfif dbType eq "mysql">
										rand()
									<cfelseif dbType eq "postgresql">
										random()
						    	<cfelseif dbType eq "mssql">
						    		newID()
						    	<cfelseif dbType eq "oracle">
						    		dbms_random.value
						    	</cfif>
								</cfcase>
								<cfdefaultcase>
									<cfif mxpRelevanceSort>
										total_points #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")# , total_score #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#, tcontent.releaseDate #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#, tcontent.lastUpdate #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#
									<cfelseif isExtendedSort>
										qExtendedSort.extendedSort #REReplace(arguments.feedBean.getSortDirection(),"[^A-Za-z]","","all")#
									<cfelse>
										tcontent.releaseDate desc,tcontent.lastUpdate desc,tcontent.menutitle
									</cfif>
								</cfdefaultcase>
							</cfswitch>

							<cfif listFindNoCase("oracle,postgresql", dbType)>
								<cfif arguments.feedBean.getSortDirection() eq "asc">
									NULLS FIRST
								<cfelse>
									NULLS LAST
								</cfif>
							</cfif>
						</cfif>
					</cfif>
					<cfif dbType eq "nuodb" and arguments.feedBean.getMaxItems()>
						fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feedBean.getMaxItems()#" />
					</cfif>
					<cfif listFindNoCase("mysql,postgresql", dbType) and arguments.feedBean.getMaxItems()>
						limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feedBean.getMaxItems()#" />
					</cfif>
					<cfif dbType eq "oracle" and arguments.feedBean.getMaxItems()>
						) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feedBean.getMaxItems()#" />
					</cfif>
				</cfif>
		</cfquery>
	</cfprocessingdirective>

	<cfif not arguments.feedBean.isAggregateQuery()>
		<cfif not arguments.countOnly and arguments.applyPermFilter>
			<cfset rsFeed=variables.permUtility.queryPermFilter(rawQuery=rsFeed,siteID=arguments.feedBean.getSiteID())>
		</cfif>

		<cfif not arguments.countOnly and arguments.feedBean.getLiveOnly() and arguments.applyIntervals>
			<cfset rsfeed=variables.contentIntervalManager.apply(query=rsFeed,current=nowAdjusted,from=arguments.from,to=arguments.to) />
		</cfif>
	<cfelseif
		arguments.feedBean.isAggregateQuery()
		and getBean('settingsManager').getSite(arguments.feedBean.getSiteID()).getValue('extranet')
		and not variables.configBean.getValue(property="AggregateContentQueries", defaultValue=false)
		and not (getCurrentUser().isLoggedIn() and (getCurrentUser().isAdminUser() or getCurrentUser().isSuperUser()))>
		<cfthrow type="authorization">
	</cfif>

	<cfif arguments.feedBean.getMaxItems() and rsFeed.recordcount gt arguments.feedBean.getMaxItems()>
		<cfquery name="rsfeed" dbtype="query" maxrows="#arguments.feedBean.getMaxItems()#">
			select * from rsfeed
		</cfquery>
	</cfif>

	<cfreturn arguments.feedBean.getSortBy() eq 'displayStart' ? getBean('contentCalendarUtilityBean').filterCalendarItems(data=rsFeed,maxitems=0,sortDirection=arguments.feedBean.getSortDirection()) : rsFeed />
</cffunction>

<cffunction name="getcontentItems" output="false">
	<cfargument name="feedBean">

	<cfset var rsFeedItems ="" />
	<cfset var theListLen =listLen(arguments.feedBean.getContentID()) />
	<cfset var I = 0 />

	<cfquery name="rsFeedItems" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contentID, menutitle, type, siteid from tcontent where
	active=1 and
	<cfif theListLen>
	(<cfloop from="1" to="#theListLen#" index="I">
	contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.feedBean.getContentID(),I)#" />
	<cfif I lt theListLen> or </cfif>
	</cfloop>)
	AND siteID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#" />)
	<cfelse>
	tcontent.contentid=''
	</cfif>
	</cfquery>

	<cfreturn rsFeedItems />
</cffunction>

<cffunction name="getFeedsByCategoryID" output="false">
	<cfargument name="categoryID" type="string" />
	<cfargument name="siteID" type="string" />

	<cfset var rsFeedByCategory ="" />

	<cfquery name="rsFeedByCategory" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">

	SELECT name, channelLink, type
	FROM tcontentfeeds
	where feedID in
	(select feedID from tcontentfeeditems where itemID
	<cfif arguments.categoryID eq "all">
	in (select categoryID from tcontentcategories where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />)
	<cfelse>
	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	 </cfif>
	 and type = 'categoryID')
	 and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />

	</cfquery>

	<cfreturn rsFeedByCategory />
</cffunction>

<cffunction name="getTypeCount" output="false">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="type" type="String" required="true" default="">

	<cfset var rsFeedTypeCount= ''/>

	<cfquery name="rsFeedTypeCount" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select count(*) as Total from tcontentfeeds
	where isactive=1
	<cfif arguments.siteID neq ''>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.type neq ''>
	and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>
	</cfif>

	</cfquery>

	<cfreturn rsFeedTypeCount />
</cffunction>

<cffunction name="renderActiveClause" output="true">
<cfargument name="table" default="tcontent">
<cfargument name="siteID">
<cfargument name="liveOnly" default="1">
<cfargument name="activeOnly" default="1">
	<cfset var previewData="">
	<cfset var sessionData=getSession()>
	<cfoutput>
		<cfif arguments.activeOnly>
			<cfif isDefined('sessionData.mura')>
				<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
			</cfif>
			<cfif isStruct(previewData) and previewData.siteID eq arguments.siteid and isDefined('previewData.contentIDList') and len(previewData.contentIDList)>
			and (
					(#arguments.table#.active = 1
					<cfif arguments.liveOnly>and #arguments.table#.Approved = 1</cfif>
					and #arguments.table#.contentID not in (#previewData.contentIDList#)
					)

					or

					(
					#arguments.table#.contentHistID in (#previewData.contentHistIDList#)
					)
				)
			<cfelse>
				and #arguments.table#.active = 1
				<cfif arguments.liveOnly>and #arguments.table#.Approved = 1</cfif>
			</cfif>
		</cfif>
	</cfoutput>
</cffunction>

<cffunction name="renderDateTimeParamType">
	<cfif variables.configBean.getDBType() eq 'Oracle'>
		<!--- This was cf_sql_date,but it was loosing precision.  Looking for better solution--->
		<cfreturn "cf_sql_timestamp">
	<cfelse>
		<cfreturn "cf_sql_timestamp">
	</cfif>
</cffunction>


<cffunction name="sanitizedValue" output="false">
	<cfargument name="value">
	<cfreturn REReplace(arguments.value,"[^0-9A-Za-z\._,\- ]\*","","all")>
</cffunction>

</cfcomponent>
