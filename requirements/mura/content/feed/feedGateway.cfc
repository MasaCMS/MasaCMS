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
 
<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean" type="any" required="yes" />
	<cfargument name="contentIntervalManager" type="any" required="yes" />
	<cfargument name="permUtility" type="any" required="yes" />

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
	<cfset variables.contentIntervalManager=arguments.contentIntervalManager>
	<cfset variables.permUtility=arguments.permUtility>
	<cfreturn this />
</cffunction>

<cffunction name="getFeeds" access="public" output="false" returntype="query">
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

<cffunction name="getDefaultFeeds" access="public" output="false" returntype="query">
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

<cffunction name="getFeed" access="public" output="false" returntype="query">
	<cfargument name="feedBean" type="any">
	<cfargument name="tag" required="true" default="">
	<cfargument name="aggregation" required="true" type="boolean" default="false">
	<cfargument name="applyPermFilter" required="true" type="boolean" default="false">
	<cfargument name="countOnly" required="true" type="boolean" default="false">
	<cfargument name="menuType" default="default">
	<cfargument name="from" required="true" default="">
	<cfargument name="to" required="true" default="">

	<cfset var c ="" />
	<cfset var rsFeed ="" />
	<cfset var contentLen =listLen(arguments.feedBean.getcontentID()) />
	<cfset var categoryLen =listLen(arguments.feedBean.getCategoryID()) />
	<cfset var rsParams=arguments.feedBean.getAdvancedParams() />
	<cfset var started =false />
	<cfset var isNullVal=false>
	<cfset var param =createObject("component","mura.queryParam")/>
	<cfset var doKids =false />
	<cfset var doTags =false />
	<cfset var openGrouping =false />
	<cfset var dbType=variables.configBean.getDbType() />
	<cfset var sortOptions="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,rating,comment,credits,type,subtype">
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

	<cfif not isdate(nowAdjusted)>
		<cfset nowAdjusted=createDateTime(year(now()),month(now()),day(now()),hour(now()),int((minute(now())/5)*5),0)>
	</cfif>

	<cfif not(isDate(arguments.from) and isDate(arguments.to))>
		<cfset arguments.from=nowAdjusted>
		<cfset arguments.to=dateAdd('m',12,nowAdjusted)>
	</cfif>
	
	<cfif arguments.feedBean.getType() eq "Local">
		<cfif arguments.aggregation>
			<cfset doKids=true />
		<cfelse>
			<cfif arguments.feedBean.getDisplayKids() 
			or arguments.feedBean.getSortBy() eq 'kids'>
				<cfset doKids=true />
			</cfif>
		</cfif>
	</cfif>
	
	<cfif len(arguments.tag)>
		<cfset jointables="tcontenttags">
	</cfif>

	<cfloop query="rsParams">
		<cfif listLen(rsParams.field,".") eq 2>
			<cfset jointable=listFirst(rsParams.field,".") >
			<cfif not listFindNoCase("tcontent,tcontentstats,tfiles,tparent,tcontentcategoryassign",jointable) and not listFind(jointables,jointable)>
				<cfset jointables=listAppend(jointables,jointable)>
			</cfif>
		</cfif>
	</cfloop>

	<cfprocessingdirective suppressWhitespace="true">
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsFeed',blockFactor=blockFactor)#">
			<cfif not arguments.countOnly and dbType eq "oracle" and arguments.feedBean.getMaxItems()>SELECT * FROM (</cfif>
			SELECT 
				<cfif not arguments.countOnly and dbtype eq "mssql" and arguments.feedBean.getMaxItems()>top #arguments.feedBean.getMaxItems()#</cfif> 

				<cfif not arguments.countOnly>
					<cfif len(altTable)>
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
						tcontentstats.comments, tparent.type parentType, <cfif doKids> qKids.kids<cfelse> null as kids</cfif>,
						tcontent.path, tcontent.created, tcontent.nextn, tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontentstats.lockType, tcontent.expires,
						tfiles.filename as AssocFilename,tcontent.displayInterval,tcontent.display,tcontentfilemetadata.altText as fileAltText
					</cfif>
				<cfelse>
					count(*) as count
				</cfif>

			FROM 
				<cfif len(altTable)>#arguments.feedBean.getAltTable()#</cfif> tcontent #tableModifier#
		
				<cfloop list="#jointables#" index="jointable">
					<cfset started=false>

					<cfif arrayLen(arguments.feedBean.getJoins())>
						<cfset local.specifiedjoins=arguments.feedBean.getJoins()>
						<cfloop from="1" to="#arrayLen(local.specifiedjoins)#" index="local.i">
							<cfif local.specifiedjoins[local.i].table eq jointable>
								<cfset started=true>
								#local.specifiedjoins[local.i].jointype# join #jointable# #tableModifier# on (#local.specifiedjoins[local.i].clause#)
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
				
				<cfif not len(arguments.feedBean.getAltTable())>
					left Join tfiles #tableModifier# on (tcontent.fileid=tfiles.fileid)
					left Join tcontentstats #tableModifier# on (tcontent.contentid=tcontentstats.contentid
						and tcontent.siteid=tcontentstats.siteid)
					Left Join tcontent tparent #tableModifier# on (tcontent.parentid=tparent.contentid
						and tcontent.siteid=tparent.siteid
						and tparent.active=1) 
					Left Join tcontentfilemetadata #tableModifier# on (tcontent.fileid=tcontentfilemetadata.fileid 
						and tcontent.contenthistid=tcontentfilemetadata.contenthistid)
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
		
				<!---  begin qKids --->
					<cfif not arguments.countOnly and doKids>
						LEFT JOIN (
							SELECT
								tcontent.contentID, 
								Count(TKids.contentID) AS kids

							FROM tcontent #tableModifier#

								<cfloop list="#jointables#" index="jointable">
									<cfif listFindNoCase(histtables,jointable)>
										inner join #jointable# #tableModifier# on (tcontent.contenthistid=#jointable#.contenthistid)
									<cfelse>
										inner join #jointable# #tableModifier# on (tcontent.contentid=#jointable#.contentid)
									</cfif>
								</cfloop>
									
								inner join tcontent TKids #tableModifier# 
									on (
										tcontent.contentID=TKids.parentID
									   	and tcontent.siteID=TKids.siteID
									)
										
									<cfif doTags>
										Inner Join tcontenttags #tableModifier# on (tcontent.contentHistID=tcontenttags.contentHistID)
									</cfif>
								
							WHERE 
								tcontent.siteid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
								#renderActiveClause("tcontent",arguments.feedBean.getSiteID(),arguments.feedBean.getLiveOnly())#
								#renderActiveClause("TKids",arguments.feedBean.getSiteID(),arguments.feedBean.getLiveOnly())#
								
								<cfif not arguments.feedBean.getShowExcludeSearch()> 
									AND TKids.searchExclude = 0
								</cfif>

								<cfif arguments.feedBean.getShowNavOnly() and not listFindNoCase('Form,Component',arguments.feedBean.getType())>
									AND TKids.isNav = 1
								</cfif>

								<cfif arguments.feedBean.getType() eq "Remote">
									<cfthrow message="This function is not available for remote feeds.">
								<cfelseif arguments.feedBean.getType() eq "Component">
									AND tcontent.moduleid = '00000000000000000000000000000000003'
								<cfelseif arguments.feedBean.getType() eq "Form">
									AND tcontent.moduleid = '00000000000000000000000000000000004'
								<cfelse>
									AND tcontent.moduleid = '00000000000000000000000000000000000'
								</cfif>
									
								<cfif rsParams.recordcount>
									<cfset started=false>
									<cfset openGrouping=false />
									<cfloop query="rsParams">
										<cfset param=createObject("component","mura.queryParam").init(
											relationship=rsParams.relationship,
											field=rsParams.field,
											dataType=rsParams.dataType,
											condition=rsParams.condition,
											criteria=rsParams.criteria
										) />
																 
										<cfif param.getIsValid() and (param.isGroupingParam() or listLen(param.getField(),".") gt 1)>
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
											<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
												)
												<cfset openGrouping=false />
											<cfelseif not openGrouping>
												#param.getRelationship()#
											</cfif>
												
											<cfset started=true>
											<cfset isListParam=param.isListParam()>

											<cfif  listLen(param.getField(),".") gt 1>						
												<cfif listFirst(param.getField(),".") neq "tcontentcategoryassign">
													#param.getFieldStatement()# 

													<cfif param.getCriteria() eq 'null'>
														IS NULL
													<cfelse>
														#param.getCondition()# 
														<cfif isListParam> (</cfif>
														<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
														<cfif isListParam>)</cfif>
													</cfif>
												<cfelse>
													tcontent.contenthistid in (
														select distinct contenthistid 
														from tcontentcategoryassign #tableModifier#
														where
															#param.getFieldStatement()# 

															<cfif param.getCriteria() eq 'null'>
																IS NULL
															<cfelse>
																#param.getCondition()# 
																<cfif isListParam>(</cfif>
																<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
																<cfif isListParam>)</cfif>
															</cfif>
													)
												</cfif>
												<cfset openGrouping=false />
											<cfelseif len(param.getField())>
												<cfset castfield="attributeValue">
												tcontent.contentHistID IN (
													select tclassextenddata.baseID 
													from tclassextenddata #tableModifier#
														<cfif isNumeric(param.getField())>
															where tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
														<cfelse>
															inner join tclassextendattributes #tableModifier#
																on (tclassextenddata.attributeID = tclassextendattributes.attributeID)
															where tclassextendattributes.siteid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
																and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
														</cfif>

														AND 

														<cfif param.getCondition() neq "like">
															<cfset castfield=variables.configBean.getClassExtensionManager().getCastString(param.getField(),arguments.feedBean.getsiteid(),param.getDatatype())>
														</cfif> 
														<cfif param.getCondition() eq "like" and variables.configBean.getDbCaseSensitive()>
															upper(#castfield#)
														<cfelse>
															#castfield#
														</cfif>
														
														<cfif param.getCriteria() eq 'null'>
															IS NULL
														<cfelse>
															#param.getCondition()# 
															<cfif isListParam> (</cfif>
																<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
															<cfif isListParam>)</cfif>
														</cfif>
												) <cfset openGrouping=false />
											</cfif>
										</cfif>						
									</cfloop>
									<cfif started>)</cfif>
								</cfif><!--- /rsParams.recordcount --->

								<cfset started=false>

								<cfif contentLen>
									and (
									<cfloop from="1" to="#contentLen#" index="c">
									tcontent.parentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.feedBean.getcontentID(),c)#" /> <cfif c lt contentLen> or </cfif> 
									</cfloop>)
								</cfif><!--- /contentLen --->

								<cfif categoryLen>
									<cfif arguments.feedBean.getUseCategoryIntersect()>
										AND tcontent.contentHistID in (
											select a.contentHistID from tcontentcategoryassign a #tableModifier#
											<cfif categoryLen gt 1>
												<cfloop from="2" to="#categoryLen#" index="c">
													<cfset palias = listGetAt(alpha,c-1)>
													<cfset talias = listGetAt(alpha,c)>
													inner join tcontentcategoryassign #talias# #tableModifier# 
														on #palias#.contentHistID = #talias#.contentHistID 
															and #talias#.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.feedBean.getCategoryID(),c)#">	
												</cfloop>
											</cfif>
											where a.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.feedBean.getCategoryID(),1)#"/>
										)
									<cfelse>
										AND tcontent.contenthistID in (
											select distinct tcontentcategoryassign.contentHistID 
											from tcontentcategoryassign #tableModifier#
												inner join tcontentcategories #tableModifier#
													ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID) 
											where (
												<cfloop from="1" to="#categoryLen#" index="c">
													tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.feedBean.getCategoryID(),c)#%"/> 
													<cfif c lt categoryLen> or </cfif>
												</cfloop>
											)
										)
									</cfif>
								</cfif><!--- /categoryLen --->

								<cfif arguments.feedBean.getIsFeaturesOnly()>
									AND (
										<cfif listFindNoCase('either,architecture',arguments.feedBean.getFeatureType())>
											(
												tcontent.isFeature = 1
												OR
												(	
													tcontent.isFeature = 2 
													AND tcontent.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
													AND (
														tcontent.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
														OR tcontent.FeatureStop is null
													)
												)
											) 
										</cfif>

										<cfif listFindNoCase('either,category',arguments.feedBean.getFeatureType()) and categoryLen>
											<cfif arguments.feedBean.getFeatureType() eq 'either'>
												OR
											</cfif>
											<cfif arguments.feedBean.getUseCategoryIntersect()>
												tcontent.contentHistID in (
													select a.contentHistID 
													from tcontentcategoryassign a #tableModifier#
														<cfif categoryLen gt 1>
															<cfloop from="2" to="#categoryLen#" index="c">
																<cfset palias = listGetAt(alpha,c-1)>
																<cfset talias = listGetAt(alpha,c)>
																inner join tcontentcategoryassign #talias# #tableModifier# on 
																	(
																		#palias#.contentHistID = #talias#.contentHistID 
																		and #talias#.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.feedBean.getCategoryID(),c)#"/>
																		<cfif arguments.hasFeatures>
																			AND (
																				#talias#.isFeature = 1
																				OR (	
																					#talias#.isFeature = 2 
																					AND #talias#.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
																					AND (
																						#talias#.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
																						OR #talias#.FeatureStop is null
																					)			 
																				)
																			)
																		</cfif> 
																	)
															</cfloop>
														</cfif>
													where 
														a.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.feedBean.getCategoryID(),1)#"/>
														AND (
															a.isFeature = 1
															OR (	
																a.isFeature = 2 
																AND a.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
																AND (
																	a.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
																	or a.FeatureStop is null
																)			 
															)
														)
												)
											<cfelse>
												tcontent.contenthistID IN (
													SELECT DISTINCT tcontentcategoryassign.contentHistID 
													FROM tcontentcategoryassign #tableModifier#
													INNER JOIN tcontentcategories #tableModifier#
														ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID) 
													WHERE (
														<cfloop from="1" to="#categoryLen#" index="c">
															tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.feedBean.getCategoryID(),c)#%"/> 
															<cfif c lt categoryLen> or </cfif>
														</cfloop>
													) AND (
														tcontentcategoryassign.isFeature = 1
														OR (
															tcontentcategoryassign.isFeature = 2 
															AND tcontentcategoryassign.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
															AND (
																tcontentcategoryassign.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
																or tcontentcategoryassign.FeatureStop is null
															)			 
														)
													)
												)
											</cfif> 
										</cfif>
									)
								</cfif><!--- /getIsFeaturesOnly() --->
								
								<cfif arguments.feedBean.getLiveOnly()>	    
									AND (
										tcontent.Display = 1
										OR (	
											tcontent.Display = 2	
											AND (
												(
													tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
													AND (
														tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
														OR tcontent.DisplayStop is null
													)			 
												) 
												OR
													tcontent.parentID IN (
														SELECT contentID 
														FROM tcontent 
														WHERE 
															type='Calendar'
															#renderActiveClause("tcontent",arguments.feedBean.getSiteID())#
															AND siteid  in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
													)
											)
										)
									) AND (
										TKids.Display = 1
										OR (	
											TKids.Display = 2
											AND (
												(
													TKids.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
													AND (
														TKids.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
														OR TKids.DisplayStop is null
													)			 
												) OR
													TKids.parentID IN (
														SELECT contentID 
														FROM tcontent 
														WHERE type='Calendar'
															#renderActiveClause("tcontent",arguments.feedBean.getSiteID())#
															AND in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.feedBean.getContentPoolID()#">)
													)
											)
										)
									)
								</cfif><!--- /getLiveOnly() --->
														    
								GROUP BY tcontent.contentID
						) qKids
						ON (tcontent.contentID=qKids.contentID)
					</cfif>
				<!--- end qKids --->

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
				<cfelse>
					AND tcontent.moduleid = '00000000000000000000000000000000000'
				</cfif>

				<cfif not arguments.feedBean.getShowExcludeSearch()> 
					AND tcontent.searchExclude = 0
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
							<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
								)
								<cfset openGrouping=false />
							<cfelseif not openGrouping>
								#param.getRelationship()#
							</cfif>

							<cfset isListParam=param.isListParam()>
							<cfset started=true>

							<cfif listLen(param.getField(),".") gt 1>
								<cfif listFirst(param.getField(),".") neq "tcontentcategoryassign">
									#param.getFieldStatement()# 

									<cfif param.getCriteria() eq 'null'>
										IS NULL
									<cfelse>
										#param.getCondition()# 
										<cfif isListParam>(</cfif>
										<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#">
										<cfif isListParam>)</cfif>
									</cfif>	
								<cfelse>
									tcontent.contenthistid IN (
										SELECT DISTINCT contenthistid 
										FROM tcontentcategoryassign #tableModifier#
										WHERE 
											#param.getFieldStatement()# 
											
											<cfif param.getCriteria() eq 'null'>
												IS NULL
											<cfelse>
												#param.getCondition()# 
												<cfif isListParam>(</cfif>
												<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
												<cfif isListParam>)</cfif>
											</cfif>
									)
								</cfif>
								<cfset started=true>
								<cfset openGrouping=false />
							<cfelseif len(param.getField())>
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
													<cfset castfield=variables.configBean.getClassExtensionManager().getCastString(param.getField(),arguments.feedBean.getsiteid(),param.getDatatype())>
												</cfif> 
											
												<cfif param.getCondition() eq 'like' and variables.configBean.getDbCaseSensitive()>
													upper(#castfield#)
												<cfelse>
													#castfield#
												</cfif>
											<cfelse>
												#param.getFieldStatement()#
											</cfif>

											<cfif param.getCriteria() eq 'null'>
												IS NULL
											<cfelse>
												#param.getCondition()#
												<cfif isListParam>(</cfif>
												<cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#">
												<cfif isListParam>)</cfif>
											</cfif>
								)
								<cfset openGrouping=false />
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
							where (<cfloop from="1" to="#categoryLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.feedBean.getCategoryID(),c)#%"/> 
									<cfif c lt categoryLen> or </cfif>
									</cfloop>)
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
								AND tcontent.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
								AND (tcontent.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.FeatureStop is null)			 
							)				
						) 
						</cfif>
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
												and #talias#.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.feedBean.getCategoryID(),c)#"/>
												<cfif arguments.hasFeatures>
												AND 
													(
														#talias#.isFeature = 1
													OR
														
														(	#talias#.isFeature = 2 
															AND #talias#.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
															AND (#talias#.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or #talias#.FeatureStop is null)			 
														)
																		
													)
												</cfif> 
											)
									</cfloop>
								</cfif>
								where a.categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.feedBean.getCategoryID(),1)#"/>
								
								
								AND 
									(
										a.isFeature = 1
									OR
										
										(	a.isFeature = 2 
											AND a.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
											AND (a.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or a.FeatureStop is null)			 
										)
														
									)
							)
						<cfelse>
							tcontent.contenthistID in (
								select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign #tableModifier#
								inner join tcontentcategories #tableModifier#
								ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID) 
								where (<cfloop from="1" to="#categoryLen#" index="c">
										tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.feedBean.getCategoryID(),c)#%"/> 
										<cfif c lt categoryLen> or </cfif>
										</cfloop>)
								AND 
									(
										tcontentcategoryassign.isFeature = 1
									OR
										
										(	tcontentcategoryassign.isFeature = 2 
											AND tcontentcategoryassign.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
											AND (tcontentcategoryassign.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontentcategoryassign.FeatureStop is null)			 
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

										and tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
										and (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.DisplayStop is null)
									) OR (
										<cfif len(altTable)>
											tcontent.parentType='Calendar'
										<cfelse>
											tparent.type='Calendar'
										</cfif>
										
										and tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.to#"> 
										and (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.from#"> or tcontent.DisplayStop is null)
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

				<cfif not arguments.countOnly>	
					<cfif arguments.feedBean.getSortBy() neq '' or arguments.feedBean.getOrderBy() neq ''>		
						order by
						
						<cfif len(arguments.feedBean.getOrderBy())>
							#REReplace(arguments.feedBean.getOrderBy(),"[^0-9A-Za-z\._,\- ]","","all")# 
						<cfelse>	
							<cfswitch expression="#arguments.feedBean.getSortBy()#">
								<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displaystart,displaystop,created,credits,type,subtype">
									<cfif dbType neq "oracle" or listFindNoCase("orderno,releaseDate,lastUpdate,created,displayStart,displayStop",arguments.feedBean.getSortBy())>
										tcontent.#arguments.feedBean.getSortBy()# #arguments.feedBean.getSortDirection()#
									<cfelse>
										lower(tcontent.#arguments.feedBean.getSortBy()#) #arguments.feedBean.getSortDirection()#
									</cfif>
								</cfcase>
								<cfcase value="rating">
									tcontentstats.rating #arguments.feedBean.getSortDirection()#, tcontentstats.totalVotes #arguments.feedBean.getSortDirection()#
								</cfcase>
								<cfcase value="comments">
									tcontentstats.comments #arguments.feedBean.getSortDirection()#
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
									<cfif isExtendedSort>
										qExtendedSort.extendedSort #arguments.feedBean.getSortDirection()#
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

	<cfif not arguments.countOnly and arguments.applyPermFilter>
		<cfset rsFeed=variables.permUtility.queryPermFilter(rawQuery=rsFeed,siteID=arguments.feedBean.getSiteID())>
	</cfif>

	<cfif not arguments.countOnly and arguments.feedBean.getLiveOnly()>
		<cfset rsfeed=variables.contentIntervalManager.apply(query=rsFeed,current=nowAdjusted,from=arguments.from,to=arguments.to) />
	</cfif>

	<cfif arguments.feedBean.getMaxItems() and rsFeed.recordcount gt arguments.feedBean.getMaxItems()>
		<cfquery name="rsfeed" dbtype="query" maxrows="#arguments.feedBean.getMaxItems()#">
			select * from rsfeed 
		</cfquery>
	</cfif>

	<cfreturn rsFeed>
	
</cffunction>

<cffunction name="getcontentItems" access="public" output="false" returntype="query">
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
	0=1
	</cfif>
	</cfquery>
	
	<cfreturn rsFeedItems />
</cffunction>

<cffunction name="getFeedsByCategoryID" returntype="query" access="public" output="false">
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

<cffunction name="getTypeCount" access="public" output="false" returntype="query">
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
	<cfoutput>
		<cfif arguments.activeOnly>
			<cfif request.muraChangesetPreview>
				<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
				<cfif isDefined('previewData.contentIDList') and len(previewData.contentIDList)>
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
			<cfelse>
				and #arguments.table#.active = 1
				<cfif arguments.liveOnly>and #arguments.table#.Approved = 1</cfif>
			</cfif>	
		</cfif>
	</cfoutput>
</cffunction>
</cfcomponent>
