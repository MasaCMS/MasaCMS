<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean" type="any" required="yes" />

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.dsn=variables.configBean.getDatasource() />
	<cfreturn this />
</cffunction>

<cffunction name="getFeeds" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="type" type="String">
	<cfargument name="publicOnly" type="boolean" required="true" default="false">
	<cfargument name="activeOnly" type="boolean" required="true" default="false">

	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
	
	<cfreturn rs />
</cffunction>

<cffunction name="getDefaultFeeds" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tcontentfeeds
	where siteID= <cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.siteID#">
	and isDefault=1
	order by name
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getFeed" access="public" output="false" returntype="query">
	<cfargument name="feedBean" type="any">
	<cfargument name="tag" required="true" default="" />
	<cfargument name="aggregation" required="true" type="boolean" default="false" />
	
	<cfset var c ="" />
	<cfset var rs ="" />
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
	<cfset var isExtendedSort=(not listFindNoCase(sortOptions,feedBean.getSortBy()))>
	<cfset var nowAdjusted=createDateTime(year(now()),month(now()),day(now()),hour(now()),int((minute(now())/5)*5),0)>
	<cfset var blockFactor=arguments.feedBean.getNextN()>
	<cfset var jointables="" />
	<cfset var jointable="">
	<cfset var histtables="tcontenttags,tcontentcategorysassign,tcontentobjects,tcontentrelated">
	
	<cfif blockFactor gt 100>
		<cfset blockFactor=100>
	</cfif>
	
	<cfif arguments.feedBean.getType() eq "Local">
		<cfif arguments.aggregation>
			<cfset doKids =true />
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
			<cfif jointable neq "tcontent" and not listFind(jointables,jointable)>
				<cfset jointables=listAppend(jointables,jointable)>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" blockfactor="#blockFactor#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	<cfif dbType eq "oracle">select * from (</cfif>
	select <cfif dbtype eq "mssql">top #arguments.feedBean.getMaxItems()#</cfif> 
	tcontent.siteid, tcontent.title, tcontent.menutitle, tcontent.restricted, tcontent.restrictgroups, 
	tcontent.type, tcontent.subType, tcontent.filename, tcontent.displaystart, tcontent.displaystop,
	tcontent.remotesource, tcontent.remoteURL,tcontent.remotesourceURL, tcontent.keypoints,
	tcontent.contentID, tcontent.contentHistID,tcontent.target, tcontent.targetParams,
	tcontent.releaseDate, tcontent.lastupdate,tcontent.summary, 
	tfiles.fileSize,tfiles.fileExt,tcontent.fileid,
	tcontent.tags,tcontent.credits,tcontent.audience, tcontent.orderNo,
	tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes,
	tcontentstats.comments, tparent.type parentType, <cfif doKids> qKids.kids<cfelse> 0 as kids</cfif>,tcontent.path, tcontent.created 
	from tcontent
	left Join tfiles on (tcontent.fileid=tfiles.fileid)
	left Join tcontentstats on (tcontent.contentid=tcontentstats.contentid
					    		and tcontent.siteid=tcontentstats.siteid)
	Left Join tcontent tparent on (tcontent.parentid=tparent.contentid
					    			and tcontent.siteid=tparent.siteid
					    			and tparent.active=1) 
	
	<cfif isExtendedSort>
	left Join (select 
			<cfif variables.configBean.getDBType() eq "MSSQL">
				Cast(tclassextenddata.attributeValue as varchar(1000)) extendedSort
			<cfelseif variables.configBean.getDBType() eq "ORACLE">
				to_char(tclassextenddata.attributeValue) extendedSort
			<cfelse>
				tclassextenddata.attributeValue extendedSort
			</cfif>  
			 ,tclassextenddata.baseID 
			from tclassextenddata inner join tclassextendattributes
			on (tclassextenddata.attributeID=tclassextendattributes.attributeID)
			where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSiteID()#">
			and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSortBy()#">
			group by 
			<cfif variables.configBean.getDBType() eq "MSSQL">
			Cast(tclassextenddata.attributeValue as varchar(1000))
			<cfelseif variables.configBean.getDBType() eq "ORACLE">
			to_char(tclassextenddata.attributeValue)
			<cfelse>
			tclassextenddata.attributeValue
			</cfif>
			,baseID
	) qExtendedSort
	on (tcontent.contenthistid=qExtendedSort.baseID)
	</cfif>
	
	<!---  begin qKids --->
				<cfif doKids>
				Left Join (select
						   tcontent.contentID, 
						   Count(TKids.contentID) as kids					   
						   from tcontent 
						   inner join tcontent TKids
						   on (tcontent.contentID=TKids.parentID
						   		and tcontent.siteID=TKids.siteID)
							
						   <cfif doTags>
							Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
							</cfif>
						   where tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getsiteid()#"/>
						   		AND tcontent.Approved = 1
							    AND tcontent.active = 1  
							    AND TKids.Approved = 1
							    AND TKids.active = 1
							    AND TKids.isNav = 1 
							 	AND tcontent.moduleid = '00000000000000000000000000000000000'
							 
							<cfif rsParams.recordcount>
							<cfloop query="rsParams">
								<cfset param=createObject("component","mura.queryParam").init(rsParams.relationship,
										rsParams.field,
										rsParams.dataType,
										rsParams.condition,
										rsParams.criteria
									) />
													 
								<cfif param.getIsValid()>	
									<cfif not started >
										<cfset started = true />and (
									<cfelse>
										<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
											(
											<cfset openGrouping=true />
										<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
											or (
											<cfset openGrouping=true />
										<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
											and (
											<cfset openGrouping=true />
										<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
											)
										<cfelse>
											<cfif not openGrouping>
											#param.getRelationship()#
											<cfelse>
											<cfset openGrouping=false />
											</cfif>
										</cfif>
									</cfif>
									<cfif  listLen(param.getField(),".") gt 1>			
										#param.getField()# #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCondition() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>  	
									<cfelseif len(param.getField())>
										tcontent.contentHistID IN (
																select tclassextenddata.baseID from tclassextenddata
																<cfif isNumeric(param.getField())>
																where tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
																<cfelse>
																inner join tclassextendattributes on (tclassextenddata.attributeID = tclassextendattributes.attributeID)
																where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSiteID()#">
																and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
																</cfif>
																and tclassextenddata.attributeValue #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCondition() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>)
									</cfif>
								</cfif>						
							</cfloop>
							<cfif started>)</cfif>
						</cfif>
						<cfset started=false/>
						
						<cfloop list="#jointables#" index="jointable">
							<cfif listFindNoCase(histtables,jointable)>
							inner join #jointable# on (tcontent.contenthistid=#jointable#.contenthistid)
							<cfelse>
							inner join #jointable# on (tcontent.contentid=#jointable#.contentid)
							</cfif>
						</cfloop>
						
						<cfif categoryLen>
							AND tcontent.contentHistID in (
							select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign
							inner join tcontentcategories 
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
									AND tcontent.FeatureStart <= #createodbcdatetime(nowAdjusted)# 
									AND (tcontent.FeatureStop >= #createodbcdatetime(nowAdjusted)# or tcontent.FeatureStop is null)			 
								)				
							) 
							<cfif categoryLen> OR tcontent.contentHistID in (
							AND tcontent.contentHistID in (
							select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign
							inner join tcontentcategories 
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
										AND tcontentcategoryassign.FeatureStart <= #createodbcdatetime(nowAdjusted)# 
										AND (tcontentcategoryassign.FeatureStop >= #createodbcdatetime(nowAdjusted)# or tcontentcategoryassign.FeatureStop is null)			 
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
							    
						AND 
						(
							
							tcontent.Display = 1
						OR
							(	
								tcontent.Display = 2	
								AND 
									(
										(
										tcontent.DisplayStart <= #createodbcdatetime(nowAdjusted)# 
										AND (tcontent.DisplayStop >= #createodbcdatetime(nowAdjusted)# or tcontent.DisplayStop is null)			 
										)
										OR
										tcontent.parentID in (select contentID from tcontent 
															where type='Calendar'
															and active=1
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
										TKids.DisplayStart <= #createodbcdatetime(nowAdjusted)# 
										AND (TKids.DisplayStop >= #createodbcdatetime(nowAdjusted)# or TKids.DisplayStop is null)			 
										)
										OR
										TKids.parentID in (select contentID from tcontent 
															where type='Calendar'
															and active=1
															and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#feedBean.getSiteID()#">
														   )
									)
							)	
					
						) 
												    
											   group by tcontent.contentID
											   ) qKids
				on (tcontent.contentID=qKids.contentID) 
				
				</cfif>
<!--- end qKids --->

					
	<cfloop list="#jointables#" index="jointable">
		<cfif listFindNoCase(histtables,jointable)>
		inner join #jointable# on (tcontent.contenthistid=#jointable#.contenthistid)
		<cfelse>
		inner join #jointable# on (tcontent.contentid=#jointable#.contentid)
		</cfif>
	</cfloop>
	
	where tcontent.active=1
	<cfif arguments.feedBean.getType() eq "Local">
	AND tcontent.isNav = 1
	</cfif>
	AND tcontent.Approved = 1
	<cfif arguments.feedBean.getType() eq "Remote">
		<cfthrow message="This function is not available for remote feeds.">
	<cfelseif arguments.feedBean.getType() eq "Component">
		AND tcontent.moduleid = '00000000000000000000000000000000003'
	<cfelse>
		AND tcontent.moduleid = '00000000000000000000000000000000000'
	</cfif>
	and tcontent.type !='Module'
	AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.feedBean.getsiteid()#">
	
		<cfif rsParams.recordcount>
		<cfloop query="rsParams">
			<cfset param=createObject("component","mura.queryParam").init(rsParams.relationship,
					rsParams.field,
					rsParams.dataType,
					rsParams.condition,
					rsParams.criteria
				) />
								 
			<cfif param.getIsValid()>	
				<cfif not started >
					<cfset started = true />and (
				<cfelse>
					<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
						(
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
						or (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
						and (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
						)
					<cfelse>
						<cfif not openGrouping>
						#param.getRelationship()#
						<cfelse>
						<cfset openGrouping=false />
						</cfif>
					</cfif>
				</cfif>
				<cfif  listLen(param.getField(),".") gt 1>			
					#param.getField()# #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCondition() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>  	
				<cfelseif len(param.getField())>
					tcontent.contentHistID IN (
											select tclassextenddata.baseID from tclassextenddata
											<cfif isNumeric(param.getField())>
											where tclassextenddata.attributeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
											<cfelse>
											inner join tclassextendattributes on (tclassextenddata.attributeID = tclassextendattributes.attributeID)
											where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSiteID()#">
											and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
											</cfif>
											and tclassextenddata.attributeValue #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCondition() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>)
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
			select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign
			inner join tcontentcategories 
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
				AND tcontent.FeatureStart <= #createodbcdatetime(nowAdjusted)# 
				AND (tcontent.FeatureStop >= #createodbcdatetime(nowAdjusted)# or tcontent.FeatureStop is null)			 
			)				
		) 
		<cfif categoryLen> OR tcontent.contenthistID in (
		select distinct tcontentcategoryassign.contentHistID from tcontentcategoryassign
		inner join tcontentcategories 
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
					AND tcontentcategoryassign.FeatureStart <= #createodbcdatetime(nowAdjusted)# 
					AND (tcontentcategoryassign.FeatureStop >= #createodbcdatetime(nowAdjusted)# or tcontentcategoryassign.FeatureStop is null)			 
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
		    
	AND 
	(
		
		tcontent.Display = 1
	OR
		(		
			tcontent.Display = 2
			
			AND
			 (
				(
					tcontent.DisplayStart <= #createodbcdatetime(nowAdjusted)# 
					AND (tcontent.DisplayStop >= #createodbcdatetime(nowAdjusted)# or tcontent.DisplayStop is null)
				)
				OR tparent.type='Calendar'
			  )			 
		)		
	
	
	) 
	
									
	order by
	
	<cfswitch expression="#arguments.feedBean.getSortBy()#">
	<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,credits,type,subtype">
	tcontent.#arguments.feedBean.getSortBy()# #arguments.feedBean.getSortDirection()#
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
	<cfif dbType eq "mysql">limit <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feedBean.getMaxItems()#" /> </cfif>
	<cfif dbType eq "oracle">) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feedBean.getMaxItems()#" /> </cfif>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getcontentItems" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="ContentID" type="String">
	
	<cfset var rs ="" />
	<cfset var theListLen =listLen(arguments.contentID) />
	<cfset var I = 0 />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contentID, menutitle, type from tcontent where
	active=1 and
	<cfif theListLen>
	(<cfloop from="1" to="#theListLen#" index="I">
	contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.contentID,I)#" /> 
	<cfif I lt theListLen> or </cfif>
	</cfloop>)
	<cfelse>
	0=1
	</cfif>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getFeedsByCategoryID" returntype="query" access="public" output="false">
	<cfargument name="categoryID" type="string" />
	<cfargument name="siteID" type="string" />
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">

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
	
	<cfreturn rs />
</cffunction>

<cffunction name="getTypeCount" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="type" type="String" required="true" default="">
	
	<cfset var rs= ''/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select count(*) as Total from tcontentfeeds
	where isactive=1
	<cfif arguments.siteID neq ''>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.type neq ''>
	and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>
	</cfif>
	
	</cfquery>
	
	<cfreturn rs />
</cffunction>

</cfcomponent>