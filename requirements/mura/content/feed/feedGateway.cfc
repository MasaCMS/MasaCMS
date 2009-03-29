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
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfif arguments.aggregation >
		<cfset doKids =true />
	<cfelse>
		<cfif arguments.feedBean.getDisplayKids() 
		or arguments.feedBean.getSortBy() eq 'kids'>
			<cfset doKids=true />
		</cfif>
	</cfif>

	
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" blockfactor="#arguments.feedBean.getNextN()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	<cfif dbType eq "oracle">select * from (</cfif>
	select <cfif dbtype eq "mssql">top #arguments.feedBean.getMaxItems()#</cfif> 
	tcontent.siteid, tcontent.title, tcontent.menutitle, tcontent.restricted, tcontent.restrictgroups, 
	tcontent.type, tcontent.subType, tcontent.filename, tcontent.displaystart, tcontent.displaystop,
	tcontent.remotesource, tcontent.remoteURL,tcontent.remotesourceURL, tcontent.keypoints,
	tcontent.contentID, tcontent.contentHistID,tcontent.target, tcontent.targetParams,
	tcontent.releaseDate, tcontent.lastupdate,tcontent.summary, 
	tfiles.fileSize,tfiles.fileExt,tcontent.fileid,
	tcontent.tags,tcontent.credits,tcontent.audience,
	tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes,
	tcontentstats.comments, tparent.type parentType, <cfif doKids> qKids.kids<cfelse> 0 as kids</cfif>,tcontent.path
	
	from tcontent
	left Join tfiles on (tcontent.fileid=tfiles.fileid)
	left Join tcontentstats on (tcontent.contentid=tcontentstats.contentid
					    		and tcontent.siteid=tcontentstats.siteid)
	Left Join tcontent tparent on (tcontent.parentid=tparent.contentid
					    			and tcontent.siteid=tparent.siteid
					    			and tparent.active=1) 
	
	
	<!---  begin qKids --->
				<cfif doKids>
				Left Join (select
						   tcontent.contentID, 
						   Count(TKids.contentID) as kids					   
						   from tcontent 
						   inner join tcontent TKids
						   on (tcontent.contentID=TKids.parentID
						   		and tcontent.siteID=TKids.siteID)
							
						   	<cfif len(arguments.tag)>
							Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
							</cfif>
						   where tcontent.siteid='#arguments.feedBean.getsiteid()#'
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
							 		<cfif not started ><cfset started = true />and (<cfelse>#param.getRelationship()#</cfif>			
							 		#param.getField()# #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCriteria() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>  	
								</cfif>
							</cfloop>
							<cfif started>)</cfif>
						</cfif>
						<cfset started=false/>
						<cfif len(arguments.tag)>
							and tcontent.Tags= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#"/> 
						</cfif>
										
						<cfif arguments.feedBean.getIsFeaturesOnly()>AND (
						 (
								tcontent.isFeature = 1
							
								OR
								
								(	tcontent.isFeature = 2 
									AND tcontent.FeatureStart <= #createodbcdatetime(now())# 
									AND (tcontent.FeatureStop >= #createodbcdatetime(now())# or tcontent.FeatureStop is null)			 
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
										AND tcontentcategoryassign.FeatureStart <= #createodbcdatetime(now())# 
										AND (tcontentcategoryassign.FeatureStop >= #createodbcdatetime(now())# or tcontentcategoryassign.FeatureStop is null)			 
									)
													
								) 
							and tcontentcategoryassign.siteID='#arguments.feedBean.getSiteID()#')
							
							</cfif>
							)
						
						<cfelseif categoryLen>
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
						
						<cfif contentLen>
						and (
						<cfloop from="1" to="#contentLen#" index="c">
						tcontent.parentid='#listGetAt(arguments.feedBean.getcontentID(),c)#' <cfif c lt contentLen> or </cfif> 
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
										tcontent.DisplayStart <= #createodbcdatetime(now())# 
										AND (tcontent.DisplayStop >= #createodbcdatetime(now())# or tcontent.DisplayStop is null)			 
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
										TKids.DisplayStart <= #createodbcdatetime(now())# 
										AND (TKids.DisplayStop >= #createodbcdatetime(now())# or TKids.DisplayStop is null)			 
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

					
	<cfif len(arguments.tag)>
		Inner Join tcontentTags on (tcontent.contentHistID=tcontentTags.contentHistID)
	</cfif>
	where tcontent.active=1
	AND tcontent.isNav = 1
	AND tcontent.Approved = 1
	AND tcontent.moduleid = '00000000000000000000000000000000000'
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
				<cfif not started ><cfset started = true />and (<cfelse>#param.getRelationship()#</cfif>			
					#param.getField()# #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCriteria() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>  	
			</cfif>
		</cfloop>
		<cfif started>)</cfif>
	</cfif>
	
	<cfif len(arguments.tag)>
		and tcontentTags.tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#"/> 
	</cfif>
					
	<cfif arguments.feedBean.getIsFeaturesOnly()>AND (
	 (
			tcontent.isFeature = 1
		
			OR
			
			(	tcontent.isFeature = 2 
				AND tcontent.FeatureStart <= #createodbcdatetime(now())# 
				AND (tcontent.FeatureStop >= #createodbcdatetime(now())# or tcontent.FeatureStop is null)			 
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
					AND tcontentcategoryassign.FeatureStart <= #createodbcdatetime(now())# 
					AND (tcontentcategoryassign.FeatureStop >= #createodbcdatetime(now())# or tcontentcategoryassign.FeatureStop is null)			 
				)
								
			) 
			and tcontentcategoryassign.siteID= <cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.feedBean.getsiteid()#">
		)
		
		</cfif>
	)
	
	<cfelseif categoryLen>
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
					tcontent.DisplayStart <= #createodbcdatetime(now())# 
					AND (tcontent.DisplayStop >= #createodbcdatetime(now())# or tcontent.DisplayStop is null)
				)
				OR tparent.type='Calendar'
			  )			 
		)		
	
	
	) 
	
									
	order by 
	
	<cfswitch expression="#arguments.feedBean.getSortBy()#">
	<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displayStart">
	tcontent.#arguments.feedBean.getSortBy()# #arguments.feedBean.getSortDirection()#
	</cfcase>
	<cfcase value="rating">
	 tcontentstats.rating #arguments.feedBean.getSortDirection()#, tcontentstats.totalVotes #arguments.feedBean.getSortDirection()#
	</cfcase>
	<cfcase value="comments">
	 tcontentstats.comments #arguments.feedBean.getSortDirection()#
	</cfcase>
	<cfdefaultcase>
	tcontent.releaseDate desc,tcontent.lastUpdate desc,tcontent.menutitle
	</cfdefaultcase>
	</cfswitch>
	<cfif dbType eq "mysql">limit <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.feedBean.getMaxItems()#" /> </cfif>
	<cfif dbType eq "oracle">) where ROWNUM <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.feedBean.getMaxItems()#" /> </cfif>
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