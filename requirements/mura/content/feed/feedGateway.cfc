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
	<cfargument name="tag" required="true" default="" />
	<cfargument name="aggregation" required="true" type="boolean" default="false" />
	<cfargument name="applyPermFilter" required="true" type="boolean" default="false" />
	
	<cfset var c ="" />
	<cfset var rsFeed ="" />
	<cfset var contentLen =listLen(arguments.feedBean.getcontentID()) />
	<cfset var categoryLen =listLen(arguments.feedBean.getCategoryID()) />
	<cfset var rsParams=arguments.feedBean.getAdvancedParams() />
	<cfset var started =false />
	<cfset var param ="" />
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

	 <cfif dbtype eq "MSSQL">
	 	<cfset tableModifier="with (nolock)">
	 </cfif>

	<cfif blockFactor gt 100>
		<cfset blockFactor=100>
	</cfif>
	
	<cfif request.muraChangesetPreview>
		<cfset nowAdjusted=getCurrentUser().getValue("ChangesetPreviewData").publishDate>
	</cfif>
			
	<cfif not isdate(nowAdjusted)>
		<cfset nowAdjusted=createDateTime(year(now()),month(now()),day(now()),hour(now()),int((minute(now())/5)*5),0)>
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
	
	<cfquery name="rsFeed" datasource="#variables.configBean.getReadOnlyDatasource()#" blockfactor="#blockFactor#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	<cfif dbType eq "oracle" and arguments.feedBean.getMaxItems()>select * from (</cfif>
	select <cfif dbtype eq "mssql" and arguments.feedBean.getMaxItems()>top #arguments.feedBean.getMaxItems()#</cfif> 
	tcontent.siteid, tcontent.title, tcontent.menutitle, tcontent.restricted, tcontent.restrictgroups, 
	tcontent.type, tcontent.subType, tcontent.filename, tcontent.displaystart, tcontent.displaystop,
	tcontent.remotesource, tcontent.remoteURL,tcontent.remotesourceURL, tcontent.keypoints,
	tcontent.contentID, tcontent.parentID, tcontent.approved, tcontent.isLocked, tcontent.contentHistID,tcontent.target, tcontent.targetParams,
	tcontent.releaseDate, tcontent.lastupdate,tcontent.summary, 
	tfiles.fileSize,tfiles.fileExt,tcontent.fileid,
	tcontent.tags,tcontent.credits,tcontent.audience, tcontent.orderNo,
	tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes,
	tcontentstats.comments, tparent.type parentType, <cfif doKids> qKids.kids<cfelse> null as kids</cfif>,
	tcontent.path, tcontent.created, tcontent.nextn, tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontent.expires,
	tfiles.filename as AssocFilename,tcontent.displayInterval,tcontent.display, tcontent.sourceID

	from tcontent
	
	<cfloop list="#jointables#" index="jointable">
		<cfif listFindNoCase(histtables,jointable)>
		inner join #jointable# #tableModifier# on (tcontent.contenthistid=#jointable#.contenthistid)
		<cfelse>
		inner join #jointable# #tableModifier# on (tcontent.contentid=#jointable#.contentid)
		</cfif>
	</cfloop>
	
	left Join tfiles #tableModifier# on (tcontent.fileid=tfiles.fileid)
	left Join tcontentstats #tableModifier# on (tcontent.contentid=tcontentstats.contentid
					    		and tcontent.siteid=tcontentstats.siteid)
	Left Join tcontent tparent #tableModifier# on (tcontent.parentid=tparent.contentid
					    			and tcontent.siteid=tparent.siteid
					    			and tparent.active=1) 
	
	<cfif isExtendedSort>
	left Join (select 
			
			#variables.classExtensionManager.getCastString(arguments.feedBean.getSortBy(),arguments.feedBean.getSiteID())# extendedSort
			 ,tclassextenddata.baseID 
			from tclassextenddata #tableModifier# inner join tclassextendattributes #tableModifier#
			on (tclassextenddata.attributeID=tclassextendattributes.attributeID)
			where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSiteID()#">
			and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSortBy()#">
	) qExtendedSort
	
	on (tcontent.contenthistid=qExtendedSort.baseID)
	</cfif>
	
	<!---  begin qKids --->
				<cfif doKids>
				Left Join (select
						   tcontent.contentID, 
						   Count(TKids.contentID) as kids					   
						   from tcontent #tableModifier#
						   
						   <cfloop list="#jointables#" index="jointable">
								<cfif listFindNoCase(histtables,jointable)>
								inner join #jointable# #tableModifier# on (tcontent.contenthistid=#jointable#.contenthistid)
								<cfelse>
								inner join #jointable# #tableModifier# on (tcontent.contentid=#jointable#.contentid)
								</cfif>
							</cfloop>
						
						   inner join tcontent TKids #tableModifier#
						   on (tcontent.contentID=TKids.parentID
						   		and tcontent.siteID=TKids.siteID)
							
						   <cfif doTags>
							Inner Join tcontenttags #tableModifier# on (tcontent.contentHistID=tcontenttags.contentHistID)
							</cfif>
						   where tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getsiteid()#"/>
						   		#renderActiveClause("tcontent",arguments.feedBean.getSiteID(),arguments.feedBean.getLiveOnly())#
							    #renderActiveClause("TKids",arguments.feedBean.getSiteID(),arguments.feedBean.getLiveOnly())#
							    <cfif not arguments.feedBean.getShowExcludeSearch()> AND TKids.searchExclude = 0</cfif>
							    <cfif arguments.feedBean.getShowNavOnly() and not listFindNoCase('Form,Component',arguments.feedBean.getType())>AND TKids.isNav = 1</cfif>
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
							<cfloop query="rsParams">
								<cfset param=createObject("component","mura.queryParam").init(rsParams.relationship,
										rsParams.field,
										rsParams.dataType,
										rsParams.condition,
										rsParams.criteria
									) />
													 
								<cfif param.getIsValid()>	
									<cfif not started >
										and (
									</cfif>
									<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
										(
										<cfset openGrouping=true />
									<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
										<cfif started>or</cfif> (
										<cfset openGrouping=true />
									<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
										<cfif started>and</cfif> (
										<cfset openGrouping=true />
									<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
										)
									<cfelse>
										<cfif not openGrouping and started>
											#param.getRelationship()#
										<cfelse>
											<cfset openGrouping=false />
										</cfif>
									</cfif>
									
									<cfset started = true />
									<cfset isListParam=listFindNoCase("IN,NOT IN",param.getCondition())>			
									<cfif  listLen(param.getField(),".") gt 1>
										<cfif listFirst(param.getField(),".") neq "tcontentcategoryassign">
											#param.getField()# #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>  	
										<cfelse>
											tcontent.contenthistid in (select distinct contenthistid from tcontentcategoryassign
												where
												#param.getField()# #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif> 
												)
										</cfif>
									<cfelseif len(param.getField())>
										tcontent.contentHistID IN (
											select tclassextenddata.baseID from tclassextenddata #tableModifier#
											inner join tcontent #tableModifier# on (tcontent.contentHistID=tclassextenddata.baseID and tcontent.active=1)
											<cfif isNumeric(param.getField())>
											where tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
											<cfelse>
											inner join tclassextendattributes on (tclassextenddata.attributeID = tclassextendattributes.attributeID)
											where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSiteID()#">
											and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
											</cfif>
											and <cfif param.getCondition() neq "like">#variables.classExtensionManager.getCastString(param.getField(),arguments.feedBean.getSiteID())#<cfelse>attributeValue</cfif> #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>)
									</cfif>
								</cfif>						
							</cfloop>
							<cfif started>)</cfif>
						</cfif>
						<cfset started=false/>
						
						<cfif categoryLen>
							AND tcontent.contentHistID in (
							select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign #tableModifier#
							inner join tcontentcategories #tableModifier#
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID) 
							where (<cfloop from="1" to="#categoryLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.feedBean.getCategoryID(),c)#%"/> 
									<cfif c lt categoryLen> or </cfif>
									</cfloop>) 
							)
						
						</cfif>
										
						<cfif arguments.feedBean.getIsFeaturesOnly()>AND (
						 (
								tcontent.isFeature = 1
							
								OR
								
								(	tcontent.isFeature = 2 
									AND tcontent.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
									AND (tcontent.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.FeatureStop is null)			 
								)				
							) 
							<cfif categoryLen> OR tcontent.contentHistID in (
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
							and tcontentcategoryassign.siteID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.feedBean.getsiteid()#">)
							
							</cfif>
							)
						</cfif>
						
						<cfif contentLen>
						and (
						<cfloop from="1" to="#contentLen#" index="c">
						tcontent.parentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.feedBean.getcontentID(),c)#" /> <cfif c lt contentLen> or </cfif> 
						</cfloop>)
						</cfif>
						
						<cfif arguments.feedBean.getLiveOnly()>	    
						AND 
						(
							
							tcontent.Display = 1
						OR
							(	
								tcontent.Display = 2	
								AND 
									(
										(
										tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
										AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.DisplayStop is null)			 
										)
										OR
										tcontent.parentID in (select contentID from tcontent 
															where type='Calendar'
															#renderActiveClause("tcontent",arguments.feedBean.getSiteID())#
															and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#feedBean.getSiteID()#">
														   )
									)
							)		
						
						
						) 
						
						AND 
						(
							
							TKids.Display = 1
						OR
							(	
								TKids.Display = 2
								AND 
									(
										(
										TKids.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
										AND (TKids.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or TKids.DisplayStop is null)			 
										)
										OR
										TKids.parentID in (select contentID from tcontent 
															where type='Calendar'
															#renderActiveClause("tcontent",arguments.feedBean.getSiteID())#
															and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#feedBean.getSiteID()#">
														   )
									)
							)	
					
						) 
						</cfif>
												    
											   group by tcontent.contentID
											   ) qKids
				on (tcontent.contentID=qKids.contentID) 
				
				</cfif>
<!--- end qKids --->
	
	where
	tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.feedBean.getsiteid()#">
	#renderActiveClause("tcontent",arguments.feedBean.getSiteID(),arguments.feedBean.getLiveOnly())#
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
	<cfif not arguments.feedBean.getShowExcludeSearch()> AND tcontent.searchExclude = 0</cfif>
	AND tcontent.type <>'Module'

		<cfif rsParams.recordcount>
		<cfset started=false>
		<cfloop query="rsParams">
			<cfset param=createObject("component","mura.queryParam").init(rsParams.relationship,
					rsParams.field,
					rsParams.dataType,
					rsParams.condition,
					rsParams.criteria
				) />
								 
			<cfif param.getIsValid()>	
				<cfif not started >
					and (
				</cfif>
				<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
					(
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
					<cfif started>or</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
					<cfif started>and</cfif> (
					<cfset openGrouping=true />
				<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
					)
				<cfelse>
					<cfif not openGrouping and started>
						#param.getRelationship()#
					<cfelse>
						<cfset openGrouping=false />
					</cfif>
				</cfif>
				
				<cfset started = true />
				<cfset isListParam=listFindNoCase("IN,NOT IN",param.getCondition())>	
				<cfif  listLen(param.getField(),".") gt 1>						
					<cfif listFirst(param.getField(),".") neq "tcontentcategoryassign">
						#param.getField()# #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>  	
					<cfelse>
						tcontent.contenthistid in (select distinct contenthistid from tcontentcategoryassign
							where
							#param.getField()# #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif> 
							)
					</cfif>
				<cfelseif len(param.getField())>
					tcontent.contentHistID IN (
						select tclassextenddata.baseID from tclassextenddata #tableModifier#
						inner join tcontent #tableModifier# on (tcontent.contentHistID=tclassextenddata.baseID and tcontent.active=1)
						<cfif isNumeric(param.getField())>
						where tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#param.getField()#">
						<cfelse>
						inner join tclassextendattributes on (tclassextenddata.attributeID = tclassextendattributes.attributeID)
						where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSiteID()#">
						and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
						</cfif>
						and <cfif param.getCondition() neq "like">#variables.classExtensionManager.getCastString(param.getField(),arguments.feedBean.getSiteID())#<cfelse>attributeValue</cfif> #param.getCondition()# <cfif isListParam>(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(isListParam,de('true'),de('false'))#" null="#iif(param.getCriteria() eq 'null',de('true'),de('false'))#"><cfif isListParam>)</cfif>)
				</cfif>
			</cfif>						
		</cfloop>
		<cfif started>)</cfif>
	</cfif>

	<cfif len(arguments.tag)>
		and tcontenttags.tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#"/> 
	</cfif>
	
	<cfif categoryLen>
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
					
	<cfif arguments.feedBean.getIsFeaturesOnly()>AND (
	 (
			tcontent.isFeature = 1
		
			OR
			
			(	tcontent.isFeature = 2 
				AND tcontent.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
				AND (tcontent.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.FeatureStop is null)			 
			)				
		) 
		<cfif categoryLen> OR tcontent.contenthistID in (
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
			and tcontentcategoryassign.siteID= <cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.feedBean.getsiteid()#">
		)
		
		</cfif>
	)
	</cfif>
	
	<cfif contentLen>
	and tcontent.parentid in (
	<cfloop from="1" to="#contentLen#" index="c">
	<cfqueryparam cfsqltype="cf_sql_varchar"  value="#listGetAt(arguments.feedBean.getcontentID(),c)#">, 
	</cfloop>'')
	</cfif>
	
	<cfif arguments.feedBean.getLiveOnly()>	    
	AND 
	(
		
		tcontent.Display = 1
	OR
		(		
			tcontent.Display = 2
			
			AND
			 (
				(
					tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> 
					AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.DisplayStop is null)
				)
				OR tparent.type='Calendar'
			  )			 
		)		
	
	
	) 

	and (tcontent.mobileExclude is null
		OR 
		<cfif request.muraMobileRequest>
			tcontent.mobileExclude in (0,2)
		<cfelse>
			tcontent.mobileExclude in (0,1)
		</cfif>
	)
	</cfif>
						
	order by
	
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
	<cfif dbType eq "nuodb" and arguments.feedBean.getMaxItems()>fetch <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feedBean.getMaxItems()#" /> </cfif>
	<cfif dbType eq "mysql" and arguments.feedBean.getMaxItems()>limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feedBean.getMaxItems()#" /> </cfif>
	<cfif dbType eq "oracle" and arguments.feedBean.getMaxItems()>) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feedBean.getMaxItems()#" /> </cfif>
	</cfquery>
	
	<cfif arguments.applyPermFilter>
		<cfset rsFeed=variables.permUtility.queryPermFilter(rawQuery=rsFeed,siteID=arguments.feedBean.getSiteID())>
	</cfif>

	<cfreturn variables.contentIntervalManager.applyByMenuTypeAndDate(query=rsFeed,menuType="default",menuDate=nowAdjusted) />
</cffunction>

<cffunction name="getcontentItems" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="ContentID" type="String">
	
	<cfset var rsFeedItems ="" />
	<cfset var theListLen =listLen(arguments.contentID) />
	<cfset var I = 0 />

	<cfquery name="rsFeedItems" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contentID, menutitle, type from tcontent where
	active=1 and
	<cfif theListLen>
	(<cfloop from="1" to="#theListLen#" index="I">
	contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.contentID,I)#" /> 
	<cfif I lt theListLen> or </cfif>
	</cfloop>)
	AND siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
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
	<cfset var previewData="">
	<cfoutput>
			<cfif request.muraChangesetPreview>
				<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
				<cfif len(previewData.contentIDList)>
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
	</cfoutput>
</cffunction>
</cfcomponent>