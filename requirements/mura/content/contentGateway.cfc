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

<cffunction name="init" returntype="any" access="public" output="true">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.dsn=variables.configBean.getDatasource() />
		<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
<cfreturn this />
</cffunction>

<cffunction name="getCrumblist" returntype="array" access="public" output="false">
		<cfargument name="contentid" required="true" default="">
		<cfargument name="siteid" required="true" default="">
		<cfargument name="setInheritance" required="true" type="boolean" default="false">
		<cfargument name="path" required="true" default="">
			
		<cfset var I=0>
		<cfset var crumbdata="">
		<cfset var key="crumb" & arguments.contentID & arguments.setInheritance />
		<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
		<cfset var cacheFactory=site.getCacheFactory()>
		
		<cfif arguments.setInheritance>
			<cfset request.inheritedObjects="">
		</cfif>
			
		<cfif site.getCache()>
			<!--- check to see if it is cached. if not then pass in the context --->
			<!--- otherwise grab it from the cache --->
			
			<cfif NOT cacheFactory.has( key )>
				
				<cfset crumbdata=buildCrumblist(arguments.contentID,arguments.siteID,arguments.setInheritance,arguments.path) />
				
				<cfreturn cacheFactory.get( key, crumbdata ) />
			<cfelse>
				<cfset crumbdata=cacheFactory.get( key ) />
				<cfif arguments.setInheritance>
					<cfloop from="1" to="#arrayLen(crumbdata)#" index="I">
						<cfif crumbdata[I].inheritObjects eq 'cascade'>
							<cfset request.inheritedObjects=crumbdata[I].contenthistid>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>	
				<cfreturn crumbdata />
			</cfif>
		<cfelse>
			<cfreturn buildCrumblist(arguments.contentID,arguments.siteID,arguments.setInheritance,arguments.path)/>
		</cfif>

</cffunction>

<cffunction name="buildCrumblist" returntype="array" access="public" output="false">
		<cfargument name="contentid" required="true" default="">
		<cfargument name="siteid" required="true" default="">
		<cfargument name="setInheritance" required="true" type="boolean" default="false">
		<cfargument name="path" required="true" default="">
			
		<cfset var ID=arguments.contentid>
		<cfset var I=0>
		<cfset var rscontent = "" />
		<cfset var crumbdata=arraynew(1) />
		<cfset var crumb= ""/>
		<cfset var parentArray=arraynew(1) />
		
		<cfif not len(arguments.path)>
			<cftry>
			
			<cfloop condition="ID neq '00000000000000000000000000000000END'">

			<cfquery name="rsContent" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select contenthistid, contentid, menutitle, filename, parentid, type, target, targetParams, 
			siteid, restricted, restrictgroups,template,inheritObjects,metadesc,metakeywords,sortBy,
			sortDirection from tcontent where active=1 and contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
			</cfquery>
			
			<cfset crumb=structNew() />
			<cfset crumb.type=rscontent.type />
			<cfset crumb.filename=rscontent.filename />
			<cfset crumb.menutitle=rscontent.menutitle />
			<cfset crumb.target=rscontent.target />
			<cfset crumb.contentid=rscontent.contentid />
			<cfset crumb.parentid=rscontent.parentid />
			<cfset crumb.siteid=rscontent.siteid />
			<cfset crumb.restricted=rscontent.restricted />
			<cfset crumb.restrictGroups=rscontent.restrictgroups />
			<cfset crumb.template=rscontent.template />
			<cfset crumb.contenthistid=rscontent.contenthistid />
			<cfset crumb.targetPrams=rscontent.targetParams />
			<cfset crumb.metadesc=rscontent.metadesc />
			<cfset crumb.metakeywords=rscontent.metakeywords />
			<cfset crumb.sortBy=rscontent.sortBy />
			<cfset crumb.sortDirection=rscontent.sortDirection />
			<cfset crumb.inheritObjects=rscontent.inheritObjects />
				
			<cfset I=I+1>
			<cfset arrayAppend(crumbdata,crumb) />
			<cfif arguments.setInheritance and request.inheritedObjects eq "" and rscontent.inheritObjects eq 'cascade'>
			<cfset request.inheritedObjects=rscontent.contenthistid>
			</cfif>
			
			<cfset arrayAppend(parentArray,rscontent.contentid) />
			
			<cfset ID=rscontent.parentid>
			
			<cfif I gt 50><cfthrow  type="custom" message="Crumdata Loop Error"></cfif>
			</cfloop>
			
			<cfif I>
			<cfset crumbdata[1].parentArray=parentArray />
			</cfif>
			<cfcatch type="custom"></cfcatch>
			</cftry>
			
			<cfelse>
			
			<cfquery name="rsContent" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select contenthistid, contentid, menutitle, filename, parentid, type, target, targetParams, 
			siteid, restricted, restrictgroups,template,inheritObjects,metadesc,metakeywords,sortBy,
			sortDirection,
			<cfif variables.configBean.getDBType() eq "MSSQL">
			len(Cast(path as varchar(1000))) depth
			<cfelse>
			length(path) depth
			</cfif> 
			
			from tcontent where 
			contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.path#">)
			and active=1 
			and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
			order by depth desc
			</cfquery>
		
			<cfloop query="rsContent">
			<cfset crumb=structNew() />
			<cfset crumb.type=rscontent.type />
			<cfset crumb.filename=rscontent.filename />
			<cfset crumb.menutitle=rscontent.menutitle />
			<cfset crumb.target=rscontent.target />
			<cfset crumb.contentid=rscontent.contentid />
			<cfset crumb.parentid=rscontent.parentid />
			<cfset crumb.siteid=rscontent.siteid />
			<cfset crumb.restricted=rscontent.restricted />
			<cfset crumb.restrictGroups=rscontent.restrictgroups />
			<cfset crumb.template=rscontent.template />
			<cfset crumb.contenthistid=rscontent.contenthistid />
			<cfset crumb.targetPrams=rscontent.targetParams />
			<cfset crumb.metadesc=rscontent.metadesc />
			<cfset crumb.metakeywords=rscontent.metakeywords />
			<cfset crumb.sortBy=rscontent.sortBy />
			<cfset crumb.sortDirection=rscontent.sortDirection />
			<cfset crumb.inheritObjects=rscontent.inheritObjects />
			
			<cfset arrayAppend(crumbdata,crumb) />
			<cfif arguments.setInheritance and request.inheritedObjects eq "" and rscontent.inheritObjects eq 'cascade'>
				<cfset request.inheritedObjects=rscontent.contenthistid>
			</cfif>
			
			<cfset arrayAppend(parentArray,rscontent.contentid) />
			
			</cfloop>
			
			<cfif rsContent.recordcount>
				<cfset crumbdata[1].parentArray=parentArray />
			</cfif>
			
			</cfif>
			
			<cfreturn crumbdata/>
			
</cffunction>

<cffunction name="getKidsIterator" returntype="any" output="false">
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
			
			<cfset var rs = getKids(arguments.moduleID, arguments.siteid, arguments.parentID, arguments.type, arguments.today, arguments.size, arguments.keywords, arguments.hasFeatures, arguments.sortBy, arguments.sortDirection, arguments.categoryID, arguments.relatedID, arguments.tag, arguments.aggregation)>
			<cfset var it = getServiceFactory().getBean("contentIterator")>
			<cfset it.setQuery(rs)>
			<cfreturn it/>	
</cffunction>

<cffunction name="getKids" returntype="query" output="false">
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
			
			<cfset var rsKids = ""/>
			<cfset var relatedListLen = listLen(arguments.relatedID) />
			<cfset var categoryListLen=listLen(arguments.categoryID)/>
			<cfset var c = ""/>
			<cfset var f = ""/>
			<cfset var doKids =false />
			<cfset var dbType=variables.configBean.getDbType() />
			<cfset var sortOptions="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,rating,comment,credits,type,subtype">
			<cfset var isExtendedSort=(not listFindNoCase(sortOptions,arguments.sortBy))>
			<cfset var nowAdjusted=createDateTime(year(arguments.today),month(arguments.today),day(arguments.today),hour(arguments.today),int((minute(arguments.today)/5)*5),0)>
			
			<cfif arguments.aggregation >
				<cfset doKids =true />
			</cfif>

			
				<cfquery name="rsKids" datasource="#variables.dsn#" blockfactor="20"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				<cfif dbType eq "oracle" and arguments.size>select * from (</cfif>
				SELECT <cfif dbType eq "mssql" and arguments.size>Top #arguments.size#</cfif> 
				title, releasedate, menuTitle, tcontent.lastupdate,summary, tags,tcontent.filename, type,subType, tcontent.siteid,
				tcontent.contentid, tcontent.contentHistID, target, targetParams, 
				restricted, restrictgroups, displaystart, displaystop, orderno,sortBy,sortDirection,
				tcontent.fileid, credits, remoteSource, remoteSourceURL, remoteURL,
				tfiles.fileSize,tfiles.fileExt, audience, keypoints
				,tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes
				,tcontentstats.comments, '' parentType, <cfif doKids> qKids.kids<cfelse>0 as kids</cfif>,tcontent.path
				
				FROM tcontent Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
				left Join tcontentstats on (tcontent.contentid=tcontentstats.contentid
								    and tcontent.siteid=tcontentstats.siteid) 

<cfif isExtendedSort>
	left Join (select 
			#variables.classExtensionManager.getCastString(arguments.sortBy,arguments.siteID)# extendedSort
			 ,tclassextenddata.baseID 
			from tclassextenddata inner join tclassextendattributes
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
						   from tcontent 
						   left join tcontent TKids
						   on (tcontent.contentID=TKids.parentID
						   		and tcontent.siteID=TKids.siteID)
						   	<cfif len(arguments.tag)>
							Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
							</cfif>
						   where tcontent.siteid='#arguments.siteid#'
						        AND tcontent.parentid =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
						   		AND tcontent.Approved = 1
							    AND tcontent.active = 1 
							    AND tcontent.isNav = 1 
							    AND TKids.Approved = 1
							    AND TKids.active = 1 
							    AND TKids.isNav = 1 
							    AND tcontent.moduleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleid#"/>
							    
							   	  <cfif arguments.hasFeatures and not categoryListLen>
					  and  (tcontent.isFeature=1
	 						 or
	 						tcontent.isFeature = 2 
							and tcontent.FeatureStart <= #createodbcdatetime(nowAdjusted)# AND  (tcontent.FeatureStop >= #createodbcdatetime(nowAdjusted)# or tcontent.FeatureStop is null)
							)
					  </cfif>
					  <cfif arguments.keywords neq ''>
					  AND (tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"/>
					  		OR tcontent.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"/>)
					  </cfif>
 					
					   AND (
					 		#renderMenuTypeClause(arguments.type,nowAdjusted)#
					 		)
					
					<cfif len(arguments.tag)>
					and tcontenttags.tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#"/> 
					</cfif>
					
					<cfif relatedListLen >
					  and tcontent.contentID in (
							select relatedID from tcontentrelated 
							where contentID in 
							(<cfloop from=1 to="#relatedListLen#" index="f">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.relatedID,f)#"/> 
							<cfif f lt relatedListLen >,</cfif>
							</cfloop>)
							and siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						)
					 </cfif>

					  <cfif categoryListLen>
					  and contentHistID in (
							select tcontentcategoryassign.contentHistID from 
							tcontentcategoryassign 
							inner join tcontentcategories 
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
							where (<cfloop from="1" to="#categoryListLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.categoryID,c)#%"/> 
									<cfif c lt categoryListLen> or </cfif>
									</cfloop>) 	
							
							<cfif arguments.hasFeatures>
							and  (tcontentcategoryassign.isFeature=1
		 
									 or
		 
									tcontentcategoryassign.isFeature = 2 
		
								and tcontentcategoryassign.FeatureStart <= #createodbcdatetime(nowAdjusted)# AND  					
								(tcontentcategoryassign.FeatureStop >= #createodbcdatetime(nowAdjusted)# or 
								tcontentcategoryassign.FeatureStop is null)
								)
							</cfif>
					  )
					  </cfif>	

							   
						   group by tcontent.contentID
						   ) qKids 
				on (tcontent.contentID=qKids.contentID)
				</cfif>
<!--- end QKids --->
				<cfif len(arguments.tag)>
				Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
				</cfif>
				WHERE  	
				    tcontent.parentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
					  AND tcontent.Approved = 1
					  AND tcontent.active = 1 
					  AND tcontent.isNav = 1 
					  AND tcontent.moduleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#"/>
					  AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					
					 <cfif arguments.hasFeatures and not categoryListLen>
					  and  (tcontent.isFeature=1
	 						 or
	 						tcontent.isFeature = 2 
							and tcontent.FeatureStart <= #createodbcdatetime(nowAdjusted)# AND  (tcontent.FeatureStop >= #createodbcdatetime(nowAdjusted)# or tcontent.FeatureStop is null)
							)
					  </cfif>
					  
					  <cfif arguments.keywords neq ''>
					  AND 
					  (tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"/>
					  		OR tcontent.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"/>)
					  </cfif>
 					
					   AND (
					   		#renderMenuTypeClause(arguments.type,nowAdjusted)#
		  					)
					
					<cfif len(arguments.tag)>
						and tcontenttags.tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#"/> 
					</cfif>
					
					<cfif relatedListLen >
					  and tcontent.contentID in (
							select relatedID from tcontentrelated 
							where contentID in 
							(<cfloop from=1 to="#relatedListLen#" index="f">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.relatedID,f)#"/>
							<cfif f lt relatedListLen >,</cfif>
							</cfloop>)
							and siteID='#arguments.siteid#'
						)
					 </cfif>

					  <cfif categoryListLen>
					  and contentHistID in (
							select tcontentcategoryassign.contentHistID from 
							tcontentcategoryassign 
							inner join tcontentcategories 
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
								and (<cfloop from="1" to="#categoryListLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.categoryID,c)#%"/> 
									<cfif c lt categoryListLen> or </cfif>
									</cfloop>) 	
							
							<cfif arguments.hasFeatures>
							and  (tcontentcategoryassign.isFeature=1
		 
									 or
		 
									tcontentcategoryassign.isFeature = 2 
		
								and tcontentcategoryassign.FeatureStart <= #createodbcdatetime(nowAdjusted)# AND  					
								(tcontentcategoryassign.FeatureStop >= #createodbcdatetime(nowAdjusted)# or 
								tcontentcategoryassign.FeatureStop is null)
								)
							</cfif>
					  )
					  </cfif>	

				  order by 
					<!--- <cfswitch expression="#arguments.sortBy#">
					<cfcase value="rating">
					tcontentstats.rating #arguments.sortDirection#,tcontentstats.totalVotes #arguments.sortDirection#, tcontent.releaseDate #arguments.sortDirection#
					</cfcase>
					<cfcase value="comments">
					tcontentstats.comments #arguments.sortDirection#
					</cfcase>
					<cfdefaultcase>
					tcontent.#arguments.sortBy# #arguments.sortDirection#
					</cfdefaultcase>
					</cfswitch> --->
					<cfswitch expression="#arguments.sortBy#">
					<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,credits,type,subtype">
					tcontent.#arguments.sortBy# #arguments.sortDirection#
					</cfcase>
					<cfcase value="rating">
					 tcontentstats.rating #arguments.sortBy#, tcontentstats.totalVotes #arguments.sortDirection#
					</cfcase>
					<cfcase value="comments">
					 tcontentstats.comments #arguments.sortDirection#
					</cfcase>
					<cfdefaultcase>
						<cfif isExtendedSort>
							qExtendedSort.extendedSort #arguments.sortDirection#
						<cfelse>
							tcontent.releaseDate desc,tcontent.lastUpdate desc,tcontent.menutitle
						</cfif>
					</cfdefaultcase>
					</cfswitch>
					
					<cfif dbType eq "mysql" and arguments.size>limit #arguments.size#</cfif>
					<cfif dbType eq "oracle" and arguments.size>) where ROWNUM <=#arguments.size# </cfif>

		</cfquery>
	
		 <cfreturn rsKids>
</cffunction>
	
<cffunction name="getKidsCategorySummary" returntype="query" output="false">
			<cfargument name="siteid" type="string">
			<cfargument name="parentid" type="string" >
			<cfargument name="relatedID" type="string" required="yes" default="">
			<cfargument name="today" type="date" required="yes" default="#now()#">
			<cfargument name="menutype" type="string" required="true" default="">
			
			<cfset var rs= "" />
			<cfset var relatedListLen = listLen(arguments.relatedID) />
			<cfset var f=""/>
			<cfset var nowAdjusted=createDateTime(year(arguments.today),month(arguments.today),day(arguments.today),hour(arguments.today),int((minute(arguments.today)/5)*5),0)>
			
				<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				SELECT tcontentcategories.categoryID, Count(tcontent.contenthistID) as "Count", tcontentcategories.name from tcontent inner join tcontentcategoryassign
				ON (tcontent.contenthistID=tcontentcategoryassign.contentHistID
					and tcontent.siteID=tcontentcategoryassign.siteID)
					 inner join tcontentcategories ON
						(tcontentcategoryassign.categoryID=tcontentcategories.categoryID
						and tcontentcategoryassign.siteID=tcontentcategories.siteID
						)
				WHERE 
				      tcontent.parentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
					  AND tcontentcategories.isActive=1  
					  AND tcontent.Active = 1
					  AND tcontent.moduleid = '00000000000000000000000000000000000'
					  AND tcontent.Approved = 1 
					  AND tcontent.isNav = 1 
					  AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					  AND 
					  (
					  	(tcontent.Display = 2 
					  <cfif arguments.menuType neq 'Calendar'>
					  AND (tcontent.DisplayStart <= #createodbcdatetime(nowAdjusted)#) 
					  AND (tcontent.DisplayStop >= #createodbcdatetime(nowAdjusted)# or tcontent.DisplayStop is null)
					  	)
					 <cfelse>
					  AND (
					  		(
					  			tcontent.DisplayStart >= #createodbcdatetime(nowAdjusted)#
					  			AND tcontent.DisplayStart < #createodbcdatetime(dateAdd('m',1,nowAdjusted))#
					  		)
					  	OR (
					  			tcontent.DisplayStop >= #createodbcdatetime(nowAdjusted)#
					  			AND tcontent.DisplayStop < #createodbcdatetime(dateAdd('m',1,nowAdjusted))#
					  		)
					  	   )
					  	  )
					 </cfif>
					 
					  OR 
                   		  tcontent.Display = 1
					  )
					 					  
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
					 
					  group by tcontentcategories.name,tcontentcategories.categoryID
					  order by tcontentcategories.name asc

		</cfquery>
	
		 <cfreturn rs>
</cffunction>

<cffunction name="getCommentCount" returntype="numeric" access="remote" output="false">
			<cfargument name="siteid" type="string">
			<cfargument name="contentID" type="string" >
			
			<cfset var rs=""/>
	
			<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				SELECT count(tcontentcomments.contentid) as CommentCount
				FROM tcontentcomments
				WHERE contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and isApproved=1	 
			</cfquery>
	
		 <cfreturn rs.CommentCount>
</cffunction>

<cffunction name="getSystemObjects" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfset var rs = "">
	
	<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select object,name, '' as objectid, orderno from tsystemobjects where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	order by orderno
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getHasComments" returntype="numeric" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='comments'
	</cfquery>
	
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getHasRatings" returntype="numeric" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='Rater'
	</cfquery>
	
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getHasTagCloud" returntype="numeric" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='tag_cloud'
	</cfquery>
	
	<cfreturn rs.theCount />
</cffunction>
	
<cffunction name="getCount" returntype="numeric" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contentid"  type="string" />
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT count(ContentID) as theCount FROM tcontent WHERE
	 ParentID='#arguments.ContentID#' 
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and active=1
	 and approved=1
	 and isNav=1
	 and (display=1
	 	 or 
	 	 (display=2 AND (DisplayStart <= #createodbcdatetime(now())#) 
					  AND (DisplayStop >= #createodbcdatetime(now())# or tcontent.DisplayStop is null)
		)
		)
				
	</cfquery>
	
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getSections" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="type"  type="string" required="true" default="" />
	<cfset var rs = "">
	
	<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contentid, menutitle, type from tcontent where siteid='#arguments.siteid#' and 
	<cfif arguments.type eq ''>
	(type='Portal' or type='Calendar' or type='Gallery')
	<cfelse>
	type= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>
	</cfif> 			
	and display=1
	and approved=1 and active=1
	</cfquery>
		
	<cfreturn rs />
</cffunction>

<cffunction name="getPageCount" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT Count(tcontent.ContentID) AS counter
	FROM tcontent
	WHERE Type in ('Page','Portal','File','Calendar','Gallery') and 
	 tcontent.active=1 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
		
	<cfreturn rs />
</cffunction>

<cffunction name="getDraftList" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="userID"  type="string"  required="true" default="#session.mura.userID#"/>
	<cfargument name="limit" type="numeric" required="true" default="100000000">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	<cfargument name="sortBy" type="string" required="true" default="lastUpdate">
	<cfargument name="sortDirection" type="string" required="true" default="desc">
	<cfset var rspre = "">
	<cfset var rs = "">
	
	<cfquery name="rspre" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT DISTINCT tmodule.Title AS module, active.ModuleID, active.SiteID, active.ParentID, active.Type, active.subtype, active.MenuTitle, active.Filename, active.ContentID,
	 tmodule.SiteID, draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt
	FROM tcontent active INNER JOIN tcontent draft ON active.ContentID = draft.ContentID
	INNER JOIN tcontent tmodule ON draft.ModuleID = tmodule.ContentID
	INNER JOIN tcontentassignments ON active.contentID=tcontentassignments.contentID
	LEFT join tfiles on active.fileID=tfiles.fileID
	WHERE draft.Active=0 AND active.Active=1 AND draft.lastUpdate>active.lastupdate
	and tcontentassignments.userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	<cfif isdate(arguments.stopDate)>and active.lastUpdate <=  #createODBCDateTime(createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0))#</cfif>
	<cfif isdate(arguments.startDate)>and active.lastUpdate >=  #createODBCDateTime(createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0))#</cfif>
	GROUP BY tmodule.Title, active.ModuleID, active.SiteID, active.ParentID, active.Type, active.subType,
	active.MenuTitle, active.Filename, active.ContentID, draft.IsNav, tmodule.SiteID, 
	draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt
	HAVING tmodule.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND draft.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  AND active.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	
	union 
	
	SELECT DISTINCT tmodule.Title AS module, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subtype, draft.MenuTitle, draft.Filename, draft.ContentID,
	 tmodule.SiteID, draft.SiteID, draft.SiteID, draft.targetparams,draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt
	FROM  tcontent draft INNER JOIN tcontent tmodule ON draft.ModuleID = tmodule.ContentID
		   INNER JOIN tcontentassignments ON draft.contentID=tcontentassignments.contentID
			LEFT JOIN tcontent active ON draft.ContentID = active.ContentID and active.approved=1
			LEFT join tfiles on draft.fileID=tfiles.fileID
	WHERE 
		draft.Active=1 
		AND draft.approved=0
		and active.contentid is null
		and tcontentassignments.userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
		<cfif isdate(arguments.stopDate)>and draft.lastUpdate <=  #createODBCDateTime(createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0))#</cfif>
		<cfif isdate(arguments.startDate)>and draft.lastUpdate >=  #createODBCDateTime(createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0))#</cfif>
	GROUP BY tmodule.Title, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subType,
	draft.MenuTitle, draft.Filename, draft.ContentID, draft.IsNav, tmodule.SiteID, 
	draft.SiteID, draft.SiteID, draft.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt
	HAVING tmodule.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND draft.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	
	
	union
	
	SELECT DISTINCT tmodule.Title AS module, active.ModuleID, active.SiteID, active.ParentID, active.Type, active.subtype, active.MenuTitle, active.Filename, active.ContentID,
	 tmodule.SiteID, draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt
	FROM tcontent active INNER JOIN tcontent draft ON active.ContentID = draft.ContentID
	INNER JOIN tcontent tmodule ON draft.ModuleID = tmodule.ContentID
	LEFT join tfiles on active.fileID=tfiles.fileID
	WHERE draft.Active=0 AND active.Active=1 AND draft.lastUpdate>active.lastupdate
	and draft.lastUpdateByID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	<cfif isdate(arguments.stopDate)>and active.lastUpdate <=  #createODBCDateTime(createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0))#</cfif>
	<cfif isdate(arguments.startDate)>and active.lastUpdate >=  #createODBCDateTime(createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0))#</cfif>
	GROUP BY tmodule.Title, active.ModuleID, active.SiteID, active.ParentID, active.Type,active.subType, 
	active.MenuTitle, active.Filename, active.ContentID, draft.IsNav, tmodule.SiteID, 
	draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt
	HAVING tmodule.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  AND draft.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND active.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	
	union 
	
	SELECT DISTINCT module.Title AS module, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subtype, draft.MenuTitle, draft.Filename, draft.ContentID,
	 module.SiteID, draft.SiteID, draft.SiteID, draft.targetparams,draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt
	FROM  tcontent draft INNER JOIN tcontent module ON draft.ModuleID = module.ContentID
			LEFT JOIN tcontent active ON draft.ContentID = active.ContentID and active.approved=1
			LEFT join tfiles on draft.fileID=tfiles.fileID
	WHERE 
		draft.Active=1 
		AND draft.approved=0
		and active.contentid is null
		and draft.lastUpdateByID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
		<cfif isdate(arguments.stopDate)>and draft.lastUpdate <=  #createODBCDateTime(createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0))#</cfif>
		<cfif isdate(arguments.startDate)>and draft.lastUpdate >=  #createODBCDateTime(createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0))#</cfif>
	GROUP BY module.Title, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type,draft.subType, 
	draft.MenuTitle, draft.Filename, draft.ContentID, draft.IsNav, module.SiteID, 
	draft.SiteID, draft.SiteID, draft.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt
	HAVING module.SiteID='#arguments.siteid#' AND draft.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
	
	<cfquery name="rs" dbtype="query" maxrows="#arguments.limit#">
	select * from rsPre 
	order by #arguments.sortBy# #arguments.sortDirection#
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="getNest" returntype="query" access="public" output="false">
		<cfargument name="ParentID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfargument name="sortBy" type="string" required="true" default="orderno">
		<cfargument name="sortDirection" type="string" required="true" default="asc">
		<cfargument name="searchString" type="string" required="true" default="">
		<cfset var rs = "">
		<cfset var doAg=false/>
		<cfset var sortOptions="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,rating,comment,credits,type,subtype">
		<cfset var isExtendedSort=(not listFindNoCase(sortOptions,arguments.sortBy))>
		
		<cfif arguments.sortBy eq 'rating' 
			or arguments.sortBy eq 'comments'>
			<cfset doAg=true/>
		</cfif>
		
		<cfquery name="rs" datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isfeature,tcontent.inheritObjects,tcontent.target,
		tcontent.targetParams,tcontent.islocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,
		tfiles.fileSize,tfiles.FileExt,tfiles.ContentType,tfiles.ContentSubType, tcontent.siteID
		<cfif doAg>
			,avg(tcontentratings.rate) As Rating,count(tcontentcomments.contentID) as Comments,count(tcontentratings.contentID) as Votes
		<cfelse>
			,0 as Rating, 0 as Comments, 0 as Votes
		</cfif>
	
		FROM tcontent LEFT JOIN tcontent tcontent2 ON tcontent.contentid=tcontent2.parentid
		LEFT JOIN tfiles On tcontent.FileID=tfiles.FileID and tcontent.siteID=tfiles.siteID
		<cfif doAg>
		Left Join tcontentcomments on tcontent.contentID=tcontentcomments.contentID
		Left Join tcontentratings on tcontent.contentID=tcontentratings.contentID
		</cfif>

<cfif isExtendedSort>
	left Join (select 
			#variables.classExtensionManager.getCastString(arguments.sortBy,arguments.siteID)# extendedSort
			 ,tclassextenddata.baseID 
			from tclassextenddata inner join tclassextendattributes
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
				or tcontent.Type = 'File' 
				or tcontent.Type = 'Portal'
				or tcontent.Type = 'Calendar'
				or tcontent.Type = 'Form'
				or tcontent.Type = 'Gallery') 
		
		<cfif arguments.searchString neq "">
			and (tcontent.menuTitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchString#%"/>)
		</cfif>	
	
		group by tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
		tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,
		tfiles.fileSize,tfiles.FileExt,tfiles.ContentType,tfiles.ContentSubType, tcontent.created, tcontent.siteID
		<cfif isExtendedSort>
			,qExtendedSort.extendedSort	
		</cfif>
		<cfif arguments.sortBy neq "">
			ORDER BY
			<cfif not doAg>
				<cfif isExtendedSort>
				qExtendedSort.extendedSort #arguments.sortDirection#	
				<cfelse>
				 tcontent.#arguments.sortBy# #arguments.sortDirection#
				 </cfif> 
			<cfelseif arguments.sortBy eq 'rating'>
				Rating #arguments.sortDirection#, Votes #arguments.sortDirection# 
			<cfelse>
				Comments #arguments.sortDirection# 
			</cfif>
			
		</cfif>
		
		</cfquery>

		<cfreturn rs />
	</cffunction>
	
<cffunction name="getComponents" returntype="query" access="public" output="false">
		<cfargument name="moduleID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rs = "">
		
		<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
		
		<cfreturn rs />
</cffunction>

<cffunction name="getTop" returntype="query" access="public" output="true">
		<cfargument name="topID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rs = "">
		
		<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isFeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
		tcontent.isLocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate
		FROM tcontent LEFT JOIN tcontent tcontent2 ON (tcontent.contentid=tcontent2.parentid)
		WHERE tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and tcontent.Active=1 and tcontent.contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.topID#"/>
		group by tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
		tcontent.inheritObjects,tcontent.target,tcontent.targetParams,tcontent.isLocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate
		</cfquery>
		
		<cfreturn rs />
</cffunction>

<cffunction name="getComponentType" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	<cfset var rs = "">
	
	<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contentid, menutitle, responseChart FROM  tcontent 
	WHERE     	         (tcontent.Active = 1) 
			<!--- 		    AND (tcontent.DisplayStart <= #createodbcdatetime(now())#) 
					  AND (tcontent.DisplayStop >= #createodbcdatetime(now())# or tcontent.DisplayStop is null) --->
					  AND (tcontent.Display = 2) 
					  AND (tcontent.Approved = 1) 
					  AND (tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>) 
					  AND (tcontent.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>)
					 
					  OR
					  (tcontent.Active = 1)
					  AND (tcontent.Display = 1) 
					  AND (tcontent.Approved = 1) 
					  AND (tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>) 
					  AND (tcontent.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>)
								
	Order By title desc					  
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getHist" returntype="query" access="public" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select menutitle, siteid, contentid, contenthistid, fileID, type, lastupdateby, active, approved, lastupdate, 
	display, displaystart, displaystop, moduleid, isnav, notes,isfeature,inheritObjects,filename,targetParams,releaseDate
	from tcontent where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> order by lastupdate desc
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getDraftHist" returntype="query" access="public" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select menutitle, contentid, contenthistid, fileID, type, lastupdateby, active, approved, lastupdate, 
	display, displaystart, displaystop, moduleid, isnav, notes,isfeature,inheritObjects,filename,targetParams,releaseDate,path
	from tcontent where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	and approved=0 
	order by lastupdate desc
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getArchiveHist" returntype="query" access="public" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select menutitle, contentid, contenthistid, fileID, type, lastupdateby, active, approved, lastupdate, 
	display, displaystart, displaystop, moduleid, isnav, notes,isfeature,inheritObjects,filename,targetParams,releaseDate
	from tcontent where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> 
	and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	and approved=1 
	and active=0 
	order by lastupdate desc
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getItemCount" returntype="query" access="public" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT menuTitle, Title, filename, lastupdate, type  from  tcontent WHERE
	 contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and active=1 and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery> 


	<cfreturn rs />
</cffunction>

<cffunction name="getDownloadSelect" returntype="query" access="public" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rs = "">
	
	<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select min(entered) as FirstEntered, max(entered) as LastEntered, Count(*) as CountEntered from tformresponsepackets 
	where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and formid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	</cfquery>


	<cfreturn rs />
</cffunction>

<cffunction name="getPrivateSearch" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="keywords" type="string" required="true">
	<cfargument name="tag" type="string" required="true" default="">
	<cfargument name="sectionID" type="string" required="true" default="">
	
	<cfset var rs = "">
	<cfset var kw = trim(arguments.keywords)>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID, 
	tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
	tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isfeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
	tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt, 2 AS Priority
	FROM tcontent LEFT JOIN tcontent tcontent2 ON (tcontent.contentid=tcontent2.parentid)
	Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
	<cfif len(arguments.tag)>
		Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
	</cfif> 
	WHERE
	
	<cfif kw neq '' or arguments.tag neq ''>
         			(tcontent.Active = 1 
			  		AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
					
					AND
					
					
					tcontent.type in ('Page','Portal','Calendar','File','Link','Gallery')
						
						<cfif len(arguments.sectionID)>
							and tcontent.path like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.sectionID#%">	
						</cfif>
				
						<cfif len(arguments.tag)>
							and tcontenttags.Tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.tag)#"/> 
						<cfelse>
						
						and
						(tcontent.Title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#kw#%"/>
						or tcontent.menuTitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#kw#%"/>
						or tcontent.summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#kw#%"/>
						or tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#kw#%"/>)
						and not (
						tcontent.Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#kw#"/>
						or tcontent.menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#kw#"/>	
						)
						</cfif>
					
		<cfelse>
		0=1
		</cfif>				
		
			
		GROUP BY tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
		tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt
		
		
		<cfif kw neq ''>	
		UNION
		
		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isfeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
		tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt, 1 AS Priority
		FROM tcontent LEFT JOIN tcontent tcontent2 ON (tcontent.contentid=tcontent2.parentid)
		Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
		WHERE		
		
		(tcontent.Active = 1 
			  		AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
					
					AND
					
					
					tcontent.type in ('Page','Portal','Calendar','File','Link','Gallery')
						
						<cfif len(arguments.sectionID)>
							and tcontent.path like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.sectionID#%">	
						</cfif>
			
						and
						(tcontent.Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#kw#"/>
						or tcontent.menuTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#kw#"/>
					
		)				
	GROUP BY tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
		tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt	
	</cfif>
	</cfquery> 
	
	<cfquery name="rs" dbtype="query">
	select * from rs order by priority, title
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getPublicSearch" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="keywords" type="string" required="true">
	<cfargument name="tag" type="string" required="true" default="">
	<cfargument name="sectionID" type="string" required="true" default="">
	<cfset var rs = "">
	<cfset var w = "">
	
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select tcontent.contentid,tcontent.contenthistid,tcontent.siteid,tcontent.title,tcontent.menutitle,tcontent.targetParams,tcontent.filename,tcontent.summary,tcontent.tags,
	tcontent.restricted,tcontent.releaseDate,tcontent.type,tcontent.subType,
	tcontent.restrictgroups,tcontent.target ,tcontent.displaystart,tcontent.displaystop,0 as Comments, 
	tcontent.credits, tcontent.remoteSource, tcontent.remoteSourceURL, 
	tcontent.remoteURL,tfiles.fileSize,tfiles.fileExt,tcontent.fileID,tcontent.audience,tcontent.keyPoints,
	tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes, 0 as kids, 
	tparent.type parentType
	from tcontent Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
	Left Join tcontent tparent on (tcontent.parentid=tparent.contentid
						    			and tcontent.siteid=tparent.siteid
						    			and tparent.active=1) 
	Left Join tcontentstats on (tcontent.contentid=tcontentstats.contentid
					    and tcontent.siteid=tcontentstats.siteid) 
	
	
	
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
								(tcontent.DisplayStart <= #createodbcdate(now())#
								AND (tcontent.DisplayStop >= #createodbcdate(now())# or tcontent.DisplayStop is null)
								)
								OR  tparent.type='Calendar'
							)
							
							OR tcontent.Display = 1
						)
						
						
				AND
				tcontent.type in ('Page','Portal','Calendar','File','Link')
				
				<cfif len(arguments.sectionID)>
				and tcontent.path like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.sectionID#%">	
				</cfif>
				
				<cfif len(arguments.tag)>
					and tcontenttags.Tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.tag)#"/> 
				<cfelse>
					<cfloop list="#trim(arguments.keywords)#" index="w" delimiters=" ">
							and
							(tcontent.Title like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.menuTitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.metaKeywords like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">
							or tcontent.summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%"> 
							or tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#w#%">)
					</cfloop>
				</cfif>
				and tcontent.searchExclude=0
	
						
				order by tcontent.title 
						 
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getCategoriesByHistID" returntype="query" access="public" output="false">
	<cfargument name="contentHistID" type="string" required="true">
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select tcontentcategoryassign.*, tcontentcategories.name  from tcontentcategories inner join tcontentcategoryassign
		ON (tcontentcategories.categoryID=tcontentcategoryassign.categoryID)
		where tcontentcategoryassign.contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
		Order By tcontentcategories.name
	</cfquery> 


	<cfreturn rs />
</cffunction>

<cffunction name="getRelatedContent" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="contentHistID" type="String">
	<cfargument name="liveOnly" type="boolean" required="yes" default="false">
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	
	<cfset var rs ="" />

	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT title, releasedate, menuTitle, lastupdate, summary, tcontent.filename, type, tcontent.contentid,
	target,targetParams, restricted, restrictgroups, displaystart, displaystop, orderno,sortBy,sortDirection,
	tcontent.fileid, credits, remoteSource, remoteSourceURL, remoteURL,
	tfiles.fileSize,tfiles.fileExt,path, tcontent.siteid, tcontent.contenthistid
	FROM  tcontent Left Join tfiles ON (tcontent.fileID=tfiles.fileID)
	WHERE
	tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and active=1 and
	
	tcontent.contentID in (
	select relatedID from tcontentrelated where contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
	)
	
	<cfif arguments.liveOnly>
	  AND (
		  (tcontent.DisplayStart <= #createodbcdatetime(arguments.today)# 
			AND (tcontent.DisplayStop >= #createodbcdatetime(arguments.today)# or tcontent.DisplayStop is null)
			AND tcontent.Display = 2)
			OR  (tcontent.Display = 1)
		)
	</cfif>
	
	</cfquery>
	
	<cfreturn rs />
	
	
</cffunction>

<cffunction name="getUsage" access="public" output="false" returntype="query">
	<cfargument name="objectID" type="String">
	
	<cfset var rs= ''/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select tcontent.menutitle, tcontent.type, tcontent.filename, tcontent.lastupdate, tcontent.contentID, tcontent.siteID,
	tcontent.approved,tcontent.display,tcontent.displayStart,tcontent.displayStop,tcontent.moduleid,tcontent.contenthistID,
	tcontent.parentID
	from tcontent inner join tcontentobjects on (tcontent.contentHistID=tcontentobjects.contentHistID)
	where tcontent.active=1 
	and objectID like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.objectID#%"/>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getTypeCount" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="type" type="String" required="true" default="">
	
	<cfset var rs= ''/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select count(*) as Total from tcontent
	where active=1
	<cfif arguments.siteID neq ''>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>
	<cfif arguments.type neq ''>
		<cfif arguments.type eq 'Page'>
		 and type in ('Page','Calendar','Portal','Gallery')
		<cfelse>
		and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#"/>
		</cfif>
	</cfif>
	
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getRecentUpdates" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs= ''/>
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	<cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	select <cfif dbType eq "mssql"  and arguments.limit>Top #arguments.limit#</cfif>
	contentID,contentHistID,approved,menutitle,parentID,moduleID,siteid,lastupdate,lastUpdatebyID,lastUpdateBy,type from tcontent
	where active=1 and type not in ('Module','Plugin')
	<cfif arguments.siteID neq ''>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>

	<cfif isdate(arguments.stopDate)>and lastUpdate <=  #createODBCDateTime(createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0))#</cfif>
	<cfif isdate(arguments.startDate)>and lastUpdate >=  #createODBCDateTime(createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0))#</cfif>
	
	order by lastupdate desc
	
	<cfif dbType eq "mysql" and arguments.limit>limit #arguments.limit#</cfif>
	<cfif dbType eq "oracle" and arguments.limit>) where ROWNUM <=#arguments.limit# </cfif>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getRecentFormActivity" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">
	
	<cfset var rs= ''/>
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	<cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	select <cfif dbType eq "mssql"  and arguments.limit>Top #arguments.limit#</cfif>
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
	
	<cfif dbType eq "mysql" and arguments.limit>limit #arguments.limit#</cfif>
	<cfif dbType eq "oracle" and arguments.limit>) where ROWNUM <=#arguments.limit# </cfif>
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getTagCloud" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfargument name="categoryID" type="string" required="true" default="">
	<cfargument name="rsContent" type="any" required="true" default="">
	
	<cfset var rs= ''/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select tag, count(tag) as tagCount from tcontenttags 
	inner join tcontent on (tcontenttags.contenthistID=tcontent.contenthistID)
	left Join tcontent tparent on (tcontent.parentid=tparent.contentid
					    			and tcontent.siteid=tparent.siteid
					    			and tparent.active=1) 
	<cfif len(arguments.categoryID)>
		inner join tcontentcategoryassign
		on (tcontent.contentHistID=tcontentcategoryassign.contentHistID)
		inner join tcontentcategories
		on (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
	</cfif>
	where tcontent.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	  AND tcontent.Approved = 1
	  AND tcontent.active = 1 
      AND tcontent.isNav = 1 
	  AND tcontent.moduleid =   '00000000000000000000000000000000000'
	
	<cfif len(arguments.parentID)>
		and tcontent.parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
	</cfif>
	
	<cfif len(arguments.categoryID)>
		and tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.categoryID#%"/>
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
	<cfif isQuery(arguments.rsContent)  and arguments.rsContent.recordcount> and contentID in (#quotedValuelist(arguments.rsContent.contentID)#)</cfif>
	group by tag
	order by tag
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getObjects" access="public" returntype="query" output="false">
	<cfargument name="columnID" required="yes" type="numeric" >
	<cfargument name="ContentHistID" required="yes" type="string" >
	<cfargument name="siteID" required="yes" type="string" >
	
	<cfset var rsObjects=""/>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" name="rsObjects"  username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	select object,objectid, tcontentobjects.orderno from tcontentobjects 
	inner join tcontent On(
	tcontentobjects.contenthistid=tcontent.contenthistid
	and tcontentobjects.siteid=tcontent.siteid) 
	where tcontent.siteid='#arguments.siteid#' and tcontent.contenthistid ='#arguments.contentHistID#'
	and columnid=#arguments.columnID# order by tcontentobjects.orderno
	</cfquery>
		
	<cfreturn rsObjects>

</cffunction>

<cffunction name="getObjectInheritance" access="public" returntype="query" output="false">
	<cfargument name="columnID" required="yes" type="numeric" >
	<cfargument name="inheritedObjects" required="yes" type="string" >
	<cfargument name="siteID" required="yes" type="string" >
	
	<cfset var rsObjects=""/>
	<cfquery datasource="#application.configBean.getDatasource()#" name="rsObjects"  username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	select object,objectid,orderno from tcontentobjects  
	where contenthistid 
	='#arguments.inheritedObjects#' and siteid='#arguments.siteid#'
	and columnid=#arguments.columnID#
	and object !='goToFirstChild'
	order by orderno
	</cfquery>
	
	<cfreturn rsObjects>
		
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
						  	tcontent.DisplayStart < #createodbcdate(dateadd("D",1,arguments.menuDateTime))#
						  	AND 
						  		(
						  			tcontent.DisplayStop >= #createodbcdate(arguments.menuDateTime)# or tcontent.DisplayStop is null
						  		)
						  	)  
					</cfcase>
					<cfcase value="calendar_features">
					  	tcontent.Display = 2 	 
					 	AND
					  		(
					  			tcontent.DisplayStart >= #createodbcdatetime(arguments.menuDateTime)# 
					  			OR (tcontent.DisplayStart < #createodbcdatetime(arguments.menuDateTime)# AND tcontent.DisplayStop >= #createodbcdatetime(arguments.menuDateTime)#)
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
						 	 		tcontent.DisplayStart < #createodbcdate(dateadd("D",1,arguments.menuDateTime))#
							  		AND (
							  				tcontent.DisplayStop >= #createodbcdate(arguments.menuDateTime)# or tcontent.DisplayStop is null
							  			)  
								)
							)
						)
						  
						AND
						
						(
						  	(
						  		tcontent.releaseDate < #createodbcdate(dateadd("D",1,arguments.menuDateTime))#
						  		AND tcontent.releaseDate >= #createodbcdate(arguments.menuDateTime)#) 
						  		
						  	OR 
						  	 (
						  	 	tcontent.releaseDate is Null
						  		AND tcontent.lastUpdate < #createodbcdate(dateadd("D",1,arguments.menuDateTime))#
						  		AND tcontent.lastUpdate >= #createodbcdate(arguments.menuDateTime)#
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
						 	 		tcontent.DisplayStart < #createodbcdate(dateadd("D",1,arguments.menuDateTime))#
							  		AND (
							  				tcontent.DisplayStop >= #createodbcdate(arguments.menuDateTime)# or tcontent.DisplayStop is null
							  			)  
								)
							)
						)
						  
						AND
						(
						  	(
						  		tcontent.releaseDate < #createodbcdate(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
						  		AND  tcontent.releaseDate >= #createodbcdate(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))#) 
						  		
						  	OR 
					  		(
					  			tcontent.releaseDate is Null
					  			AND tcontent.lastUpdate < #createodbcdate(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
					  			AND tcontent.lastUpdate >= #createodbcdate(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))#
					  		)  
					  	)
					   </cfcase>
					  <cfcase value="CalendarMonth">
						tcontent.display=2
						
						AND
						(
						  	(
						  		tcontent.displayStart < #createodbcdate(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
						  		AND  tcontent.displayStart >= #createodbcdate(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))# 
						  	)
						  	
						  	or 
						  	
						  	(
						  		tcontent.displayStop < #createodbcdate(dateadd("D",1,createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),daysInMonth(arguments.menuDateTime))))#
						  		AND  tcontent.displayStop >= #createodbcdate(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))# 
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
					 	 			tcontent.DisplayStart < #createodbcdate(dateadd("D",1,arguments.menuDateTime))#
						  			AND 
						  				(
						  					tcontent.DisplayStop >= #createodbcdate(arguments.menuDateTime)# or tcontent.DisplayStop is null
						  				)  
						  		)
						)
					  
					  </cfdefaultcase>
			</cfswitch>
</cfoutput>
</cffunction>
</cfcomponent>