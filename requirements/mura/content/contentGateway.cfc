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

<cffunction name="init" returntype="any" access="public" output="true">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="contentIntervalManager" type="any" required="yes"/>
<cfargument name="permUtility" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.contentIntervalManager=arguments.contentIntervalManager>
		<cfset variables.permUtility=arguments.permUtility>
		<cfset variables.classExtensionManager=variables.configBean.getClassExtensionManager()>
<cfreturn this >
</cffunction>

<cffunction name="getCrumblist" returntype="any" access="public" output="false">
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
				<cfif arrayLen(crumbdata) lt 50>
					<cfreturn cacheFactory.get( key, crumbdata ) />
				<cfelse>
					<cfreturn crumbdata>
				</cfif>
			<cfelse>
				<cftry>
					<cfset crumbdata=cacheFactory.get( key ) />
					
					<cfif not isArray(crumbdata)>
						<cfset crumbdata=buildCrumblist(arguments.contentID,arguments.siteID,arguments.setInheritance,arguments.path) />
						<cfif arrayLen(crumbdata) lt 50>
							<cfreturn cacheFactory.get( key, crumbdata ) />
						<cfelse>
							<cfreturn crumbdata>
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
					<cfreturn crumbdata />
					<cfcatch>
						<cfset crumbdata=buildCrumblist(arguments.contentID,arguments.siteID,arguments.setInheritance,arguments.path) />
						<cfif arrayLen(crumbdata) lt 50>
							<cfreturn cacheFactory.get( key, crumbdata ) />
						<cfelse>
							<cfreturn crumbdata>
						</cfif>
					</cfcatch>
				</cftry>
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
		<cfset var rsCrumbData = "" />
		<cfset var crumbdata=arraynew(1) />
		<cfset var crumb= ""/>
		<cfset var parentArray=arraynew(1) />
		
		<cfif not len(arguments.path)>
			<cftry>
			
			<cfloop condition="ID neq '00000000000000000000000000000000END'">

			<cfquery name="rsCrumbData" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select tcontent.contenthistid, tcontent.contentid, tcontent.menutitle, tcontent.filename, tcontent.parentid, tcontent.type, 
			tcontent.subtype, tcontent.target, tcontent.targetParams, 
			tcontent.siteid, tcontent.restricted, tcontent.restrictgroups,tcontent.template,tcontent.childTemplate,tcontent.inheritObjects,tcontent.metadesc,tcontent.metakeywords,tcontent.sortBy,
			tcontent.sortDirection,tfiles.fileExt
			from tcontent 
			left join tfiles on(tcontent.fileID=tfiles.fileID)
			where tcontent.active=1 
			and tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ID#"/> 
			and tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
			</cfquery>
			
			<cfset crumb=structNew() />
			<cfset crumb.type=rsCrumbData.type />
			<cfset crumb.subtype=rsCrumbData.subtype />
			<cfset crumb.filename=rsCrumbData.filename />
			<cfset crumb.menutitle=rsCrumbData.menutitle />
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
				
			<cfset I=I+1>
			<cfset arrayAppend(crumbdata,crumb) />
			<cfif arguments.setInheritance and request.inheritedObjects eq "" and rsCrumbData.inheritObjects eq 'cascade'>
			<cfset request.inheritedObjects=rsCrumbData.contenthistid>
			</cfif>
			
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
			
			<cfquery name="rsCrumbData" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select tcontent.contenthistid, tcontent.contentid, tcontent.menutitle, tcontent.filename, tcontent.parentid, tcontent.type, 
			tcontent.subtype, tcontent.target, tcontent.targetParams, 
			tcontent.siteid, tcontent.restricted, tcontent.restrictgroups,tcontent.template,tcontent.childTemplate,tcontent.inheritObjects,tcontent.metadesc,tcontent.metakeywords,tcontent.sortBy,
			tcontent.sortDirection,
			<cfif variables.configBean.getDBType() eq "MSSQL">
			len(Cast(tcontent.path as varchar(1000))) depth
			<cfelseif variables.configBean.getDBType() eq "NUODB">
			char_length(tcontent.path) depth
			<cfelse>
			length(tcontent.path) depth
			</cfif> 
			,tfiles.fileExt
			
			from tcontent  
			left join tfiles on(tcontent.fileID=tfiles.fileID)
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
			<cfset crumb.menutitle=rsCrumbData.menutitle />
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
			
			<cfset arrayAppend(crumbdata,crumb) />
			<cfif arguments.setInheritance and request.inheritedObjects eq "" and rsCrumbData.inheritObjects eq 'cascade'>
				<cfset request.inheritedObjects=rsCrumbData.contenthistid>
			</cfif>
			
			<cfset arrayAppend(parentArray,rsCrumbData.contentid) />
			
			</cfloop>
			
			<cfif arrayLen(crumbdata)>
				<cfset crumbdata[1].parentArray=parentArray />
			</cfif>
			
			</cfif>
			
			<cfreturn crumbdata/>
			
</cffunction>

<cffunction name="getContentIDFromContentHistID" returntype="string" access="public" output="false">
	<cfargument name="contenthistid" required="true" default="">
	<cfset var rsContentIDFromHistID="">
	<cfquery name="rsContentIDFromHistID" datasource="#variables.configBean.getReadOnlyDatasource()#" blockfactor="20"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select contentID from tcontent where contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistid#">
	</cfquery>
	<cfreturn rsContentIDFromHistID.contentID>
</cffunction>

<cffunction name="getContentHistIDFromContentID" returntype="string" access="public" output="false">
	<cfargument name="contentID" required="true" default="">
	<cfargument name="siteID" required="true" default="">
	<cfset var rsHistIDFromContentID="">
	<cfquery name="rsHistIDFromContentID" datasource="#variables.configBean.getReadOnlyDatasource()#" blockfactor="20"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select contentHistID from tcontent where 
		
		<cfif isValid("UUID",arguments.contentID)>
			contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
			and active=1
			and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
		<cfelse>
			active=1
			and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
			and title=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
		</cfif>
	</cfquery>
	<cfreturn rsHistIDFromContentID.contentHistID>
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
			<cfargument name="applyPermFilter" type="boolean" required="yes" default="false" >
			
			<cfset var rs = getKids(arguments.moduleID, arguments.siteid, arguments.parentID, arguments.type, arguments.today, arguments.size, arguments.keywords, arguments.hasFeatures, arguments.sortBy, arguments.sortDirection, arguments.categoryID, arguments.relatedID, arguments.tag, arguments.aggregation,arguments.applyPermFilter)>
			<cfset var it = getBean("contentIterator")>
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
			<cfargument name="applyPermFilter" type="boolean" required="yes" default="false" >
			
			<cfset var rsKids = ""/>
			<cfset var relatedListLen = listLen(arguments.relatedID) />
			<cfset var categoryListLen=listLen(arguments.categoryID)/>
			<cfset var c = ""/>
			<cfset var f = ""/>
			<cfset var doKids =false />
			<cfset var dbType=variables.configBean.getDbType() />
			<cfset var sortOptions="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,rating,comment,credits,type,subtype">
			<cfset var isExtendedSort=(not listFindNoCase(sortOptions,arguments.sortBy))>
			<cfset var nowAdjusted="">
			<cfset var tableModifier="">

			<cfif dbtype eq "MSSQL">
				<cfset tableModifier="with (nolock)">
			</cfif>

			<cfif request.muraChangesetPreview>
				<cfset nowAdjusted=getCurrentUser().getValue("ChangesetPreviewData").publishDate>
			</cfif>
			
			<cfif not isdate(nowAdjusted)>
				<cfset nowAdjusted=createDateTime(year(arguments.today),month(arguments.today),day(arguments.today),hour(arguments.today),int((minute(arguments.today)/5)*5),0)>
			</cfif>
			
			<cfif arguments.aggregation >
				<cfset doKids =true />
			</cfif>

			
				<cfquery name="rsKids" datasource="#variables.configBean.getReadOnlyDatasource()#" blockfactor="20"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				<cfif dbType eq "oracle" and arguments.size>select * from (</cfif>
				SELECT <cfif dbType eq "mssql" and arguments.size>Top #arguments.size#</cfif> 
				title, releasedate, menuTitle, tcontent.lastupdate,summary, tags,tcontent.filename, type,subType, tcontent.siteid,
				tcontent.contentid, tcontent.contentHistID, target, targetParams, 
				restricted, restrictgroups, displaystart, displaystop, orderno,sortBy,sortDirection,
				tcontent.fileid, credits, remoteSource, remoteSourceURL, remoteURL,
				tfiles.fileSize,tfiles.fileExt, audience, keypoints
				,tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes
				,tcontentstats.comments, '' as parentType, <cfif doKids> qKids.kids<cfelse>null as kids</cfif>,tcontent.path, tcontent.created, tcontent.nextn,
				tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontent.expires,
				tfiles.filename as AssocFilename,tcontent.displayInterval,tcontent.display, tcontent.sourceID
				
				FROM tcontent 
				Left Join tfiles #tableModifier# ON (tcontent.fileID=tfiles.fileID)
				left Join tcontentstats #tableModifier# on (tcontent.contentid=tcontentstats.contentid
								    and tcontent.siteid=tcontentstats.siteid) 

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
							    
							   	  <cfif arguments.hasFeatures and not categoryListLen>
					  and  (tcontent.isFeature=1
	 						 or
	 						tcontent.isFeature = 2 
							and tcontent.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> AND  (tcontent.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.FeatureStop is null)
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
							select relatedID from tcontentrelated #tableModifier#
							where contentID in 
							(<cfloop from=1 to="#relatedListLen#" index="f">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.relatedID,f)#"/> 
							<cfif f lt relatedListLen >,</cfif>
							</cfloop>)
							and siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						)
					 </cfif>

					  <cfif categoryListLen>
					  and tcontent.contentHistID in (
							select tcontentcategoryassign.contentHistID from 
							tcontentcategoryassign #tableModifier#
							inner join tcontentcategories #tableModifier#
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
							where (<cfloop from="1" to="#categoryListLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.categoryID,c)#%"/> 
									<cfif c lt categoryListLen> or </cfif>
									</cfloop>) 	
							
							<cfif arguments.hasFeatures>
							and  (tcontentcategoryassign.isFeature=1
		 
									 or
		 
									tcontentcategoryassign.isFeature = 2 
		
								and tcontentcategoryassign.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> AND  					
								(tcontentcategoryassign.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or 
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
				Inner Join tcontenttags #tableModifier# on (tcontent.contentHistID=tcontenttags.contentHistID)
				</cfif>
				WHERE  	
				    tcontent.parentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
					  #renderActiveClause("tcontent",arguments.siteID)# 
					  AND tcontent.isNav = 1 
					  AND tcontent.moduleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#"/>
					  AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					
					 <cfif arguments.hasFeatures and not categoryListLen>
					  and  (tcontent.isFeature=1
	 						 or
	 						tcontent.isFeature = 2 
							and tcontent.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> AND  (tcontent.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.FeatureStop is null)
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
					  and tcontent.contentHistID in (
							select tcontentcategoryassign.contentHistID from 
							tcontentcategoryassign #tableModifier#
							inner join tcontentcategories #tableModifier#
							ON (tcontentcategoryassign.categoryID=tcontentcategories.categoryID)
								and (<cfloop from="1" to="#categoryListLen#" index="c">
									tcontentcategories.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listgetat(arguments.categoryID,c)#%"/> 
									<cfif c lt categoryListLen> or </cfif>
									</cfloop>) 	
							
							<cfif arguments.hasFeatures>
							and  (tcontentcategoryassign.isFeature=1
		 
									 or
		 
									tcontentcategoryassign.isFeature = 2 
		
								and tcontentcategoryassign.FeatureStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> AND  					
								(tcontentcategoryassign.FeatureStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or 
								tcontentcategoryassign.FeatureStop is null)
								)
							</cfif>
					  )
					  </cfif>	
				
				#renderMobileClause()#
						
				order by 
							
				<cfswitch expression="#arguments.sortBy#">
					<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displaystart,displaystop,created,credits,type,subtype">
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
							tcontent.releaseDate desc,tcontent.lastUpdate desc,tcontent.menutitle
						</cfif>
					</cfdefaultcase>
				</cfswitch>
						
				<cfif dbType eq "mysql" and arguments.size>limit #arguments.size#</cfif>
				<cfif dbType eq "nuodb" and arguments.size>fetch #arguments.size#</cfif>
				<cfif dbType eq "oracle" and arguments.size>) where ROWNUM <=#arguments.size# </cfif>

		</cfquery>
		
		<cfif arguments.applyPermFilter>
			<cfset rsKids=variables.permUtility.queryPermFilter(rawQuery=rsKids,siteID=arguments.siteID)>
		</cfif>
		
		<cfreturn variables.contentIntervalManager.applyByMenuTypeAndDate(query=rsKids,menuType=arguments.type,menuDate=nowAdjusted) />
</cffunction>
	
<cffunction name="getKidsCategorySummary" returntype="query" output="false">
			<cfargument name="siteid" type="string">
			<cfargument name="parentid" type="string" >
			<cfargument name="relatedID" type="string" required="yes" default="">
			<cfargument name="today" type="date" required="yes" default="#now()#">
			<cfargument name="menutype" type="string" required="true" default="">
			
			<cfset var rsKidsCategorySummary= "" />
			<cfset var relatedListLen = listLen(arguments.relatedID) />
			<cfset var f=""/>
			<cfset var nowAdjusted=createDateTime(year(arguments.today),month(arguments.today),day(arguments.today),hour(arguments.today),int((minute(arguments.today)/5)*5),0)>
			
				<cfquery name="rsKidsCategorySummary" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				SELECT tcontentcategories.categoryID, tcontentcategories.filename, Count(tcontent.contenthistID) as "Count", tcontentcategories.name from tcontent inner join tcontentcategoryassign
				ON (tcontent.contenthistID=tcontentcategoryassign.contentHistID
					and tcontent.siteID=tcontentcategoryassign.siteID)
					 inner join tcontentcategories ON
						(tcontentcategoryassign.categoryID=tcontentcategories.categoryID
						and tcontentcategoryassign.siteID=tcontentcategories.siteID
						)
				WHERE 
				      tcontent.parentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"/>
					  AND tcontentcategories.isActive=1  
					 #renderActiveClause("tcontent",arguments.siteID)# 
					  AND tcontent.moduleid = '00000000000000000000000000000000000'
					  AND tcontent.isNav = 1 
					  AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					  AND 
					  (
					  	(tcontent.Display = 2 
					  <cfif arguments.menuType neq 'Calendar'>
					  AND (tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#">) 
					  AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#"> or tcontent.DisplayStop is null)
					  	)
					 <cfelse>
					  AND (
					  		(
					  			tcontent.DisplayStart >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#">
					  			AND tcontent.DisplayStart < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('m',1,nowAdjusted)#">
					  		)
					  	OR (
					  			tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nowAdjusted#">
					  			AND tcontent.DisplayStop < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('m',1,nowAdjusted)#">
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
					 
					  group by tcontentcategories.name,tcontentcategories.categoryID,tcontentcategories.filename
					  order by tcontentcategories.name asc

		</cfquery>
	
		 <cfreturn rsKidsCategorySummary>
</cffunction>

<cffunction name="getCommentCount" returntype="numeric" access="remote" output="false">
			<cfargument name="siteid" type="string">
			<cfargument name="contentID" type="string" >
			
			<cfset var rsCommentCount=""/>
	
			<cfquery name="rsCommentCount" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				SELECT count(tcontentcomments.contentid) as CommentCount
				FROM tcontentcomments
				WHERE contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and isApproved=1	 
			</cfquery>
	
		 <cfreturn rsCommentCount.CommentCount>
</cffunction>

<cffunction name="getSystemObjects" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfset var rsSystemObjects = "">
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsSystemObjects"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select object,name, '' as objectid, orderno from tsystemobjects where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	order by name
	</cfquery>
	
	<cfreturn rsSystemObjects />
</cffunction>

<cffunction name="getHasComments" returntype="numeric" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rsHasComments = "">
	
	<cfquery name="rsHasComments" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='comments'
	</cfquery>
	
	<cfreturn rsHasComments.theCount />
</cffunction>

<cffunction name="getHasRatings" returntype="numeric" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rsHasRatings = "">
	
	<cfquery name="rsHasRatings" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='Rater'
	</cfquery>
	
	<cfreturn rsHasRatings.theCount />
</cffunction>

<cffunction name="getHasTagCloud" returntype="numeric" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contenthistid"  type="string" />
	<cfset var rsHasTagCloud = "">
	
	<cfquery name="rsHasTagCloud" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT count(ContentID) as theCount FROM tcontentobjects WHERE
	 (contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> <cfif request.inheritedObjects neq ''>or contenthistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.inheritedObjects#"/></cfif>)
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and object='tag_cloud'
	</cfquery>
	
	<cfreturn rsHasTagCloud.theCount />
</cffunction>
	
<cffunction name="getCount" returntype="numeric" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="contentid"  type="string" />
	<cfset var rsNodeCount = "">
	
	<cfquery name="rsNodeCount" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT count(ContentID) as theCount FROM tcontent WHERE
	 ParentID='#arguments.ContentID#' 
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	 and active=1
	 and approved=1
	 and isNav=1
	 and (display=1
	 	 or 
	 	 (display=2 AND (DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) 
					  AND (DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or tcontent.DisplayStop is null)
		)
		)
				
	</cfquery>
	
	<cfreturn rsNodeCount.theCount />
</cffunction>

<cffunction name="getSections" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="type"  type="string" required="true" default="" />
	<cfset var rsSections = "">
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsSections"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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

<cffunction name="getPageCount" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfset var rsPageCount = "">
	
	<cfquery name="rsPageCount" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT Count(tcontent.ContentID) AS counter
	FROM tcontent
	WHERE Type in ('Page','Folder','File','Calendar','Gallery') and 
	 tcontent.active=1 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
		
	<cfreturn rsPageCount />
</cffunction>

<cffunction name="getDraftList" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="userID"  type="string"  required="true" default="#session.mura.userID#"/>
	<cfargument name="limit" type="numeric" required="true" default="100000000">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	<cfargument name="sortBy" type="string" required="true" default="lastUpdate">
	<cfargument name="sortDirection" type="string" required="true" default="desc">
	<cfset var rsDraftList = "">
	
	<cfquery name="rsDraftList" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT DISTINCT tmodule.Title AS module, active.ModuleID, active.SiteID, active.ParentID, active.Type, active.subtype, active.MenuTitle, active.Filename, active.ContentID,
	 tmodule.SiteID, draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, draft.expires
	FROM tcontent active INNER JOIN tcontent draft ON active.ContentID = draft.ContentID
	INNER JOIN tcontent tmodule ON draft.ModuleID = tmodule.ContentID
	INNER JOIN tcontentassignments ON (active.contentID=tcontentassignments.contentID and tcontentassignments.type='draft')
	LEFT join tfiles on active.fileID=tfiles.fileID
	LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID 
								and draft.siteID=tcontentstats.siteID
								)
	WHERE draft.active=0 
	AND active.active=1 
	AND draft.lastUpdate>active.lastupdate 
	and draft.changesetID is null
	and tcontentassignments.userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	<cfif isdate(arguments.stopDate)>and active.lastUpdate <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and active.lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>
	GROUP BY tmodule.Title, active.ModuleID, active.SiteID, active.ParentID, active.Type, active.subType,
	active.MenuTitle, active.Filename, active.ContentID, draft.IsNav, tmodule.SiteID, 
	draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, draft.expires
	HAVING tmodule.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND draft.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  AND active.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	
	union 
	
	SELECT DISTINCT tmodule.Title AS module, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subtype, draft.MenuTitle, draft.Filename, draft.ContentID,
	 tmodule.SiteID, draft.SiteID, draft.SiteID, draft.targetparams,draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, draft.expires
	FROM  tcontent draft INNER JOIN tcontent tmodule ON draft.ModuleID = tmodule.ContentID
		   INNER JOIN tcontentassignments ON (draft.contentID=tcontentassignments.contentID and tcontentassignments.type='draft')
			LEFT JOIN tcontent active ON draft.ContentID = active.ContentID and active.approved=1
			LEFT join tfiles on draft.fileID=tfiles.fileID
			LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID 
								and draft.siteID=tcontentstats.siteID
								)
	WHERE 
		draft.active=1 
		AND draft.approved=0
		and active.contentid is null
		and draft.changesetID is null
		and tcontentassignments.userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
		<cfif isdate(arguments.stopDate)>and draft.lastUpdate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
		<cfif isdate(arguments.startDate)>and draft.lastUpdate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>
	GROUP BY tmodule.Title, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subType,
	draft.MenuTitle, draft.Filename, draft.ContentID, draft.IsNav, tmodule.SiteID, 
	draft.SiteID, draft.SiteID, draft.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, draft.expires
	HAVING tmodule.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND draft.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	
	
	union
	
	SELECT DISTINCT tmodule.Title AS module, active.ModuleID, active.SiteID, active.ParentID, active.Type, active.subtype, active.MenuTitle, active.Filename, active.ContentID,
	 tmodule.SiteID, draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, draft.expires
	FROM tcontent active INNER JOIN tcontent draft ON active.ContentID = draft.ContentID
	INNER JOIN tcontent tmodule ON draft.ModuleID = tmodule.ContentID
	LEFT join tfiles on active.fileID=tfiles.fileID
	LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID 
								and draft.siteID=tcontentstats.siteID
								)
	WHERE draft.active=0 
	AND active.active=1 
	AND draft.lastUpdate>active.lastupdate 
	and draft.changesetID is null
	and draft.lastUpdateByID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
	<cfif isdate(arguments.stopDate)>and active.lastUpdate <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and active.lastUpdate >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>
	GROUP BY tmodule.Title, active.ModuleID, active.SiteID, active.ParentID, active.Type,active.subType, 
	active.MenuTitle, active.Filename, active.ContentID, draft.IsNav, tmodule.SiteID, 
	draft.SiteID, active.SiteID, active.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, draft.expires
	HAVING tmodule.SiteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  AND draft.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> AND active.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	
	union 
	
	SELECT DISTINCT module.Title AS module, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type, draft.subtype, draft.MenuTitle, draft.Filename, draft.ContentID,
	 module.SiteID, draft.SiteID, draft.SiteID, draft.targetparams,draft.lastUpdate,
	 draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, draft.expires
	FROM  tcontent draft INNER JOIN tcontent module ON draft.ModuleID = module.ContentID
			LEFT JOIN tcontent active ON draft.ContentID = active.ContentID and active.approved=1
			LEFT join tfiles on draft.fileID=tfiles.fileID
			LEFT JOIN tcontentstats on (draft.contentID=tcontentstats.contentID 
								and draft.siteID=tcontentstats.siteID
								)
	WHERE 
		draft.active=1 
		AND draft.approved=0
		and active.contentid is null
		and draft.changesetID is null
		and draft.lastUpdateByID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/>
		<cfif isdate(arguments.stopDate)>and draft.lastUpdate <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
		<cfif isdate(arguments.startDate)>and draft.lastUpdate >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>
	GROUP BY module.Title, draft.ModuleID, draft.SiteID, draft.ParentID, draft.Type,draft.subType, 
	draft.MenuTitle, draft.Filename, draft.ContentID, draft.IsNav, module.SiteID, 
	draft.SiteID, draft.SiteID, draft.targetparams, draft.lastUpdate,
	draft.lastUpdateBy,tfiles.fileExt, draft.changesetID, draft.majorVersion, draft.minorVersion, tcontentstats.lockID, draft.expires
	HAVING module.SiteID='#arguments.siteid#' AND draft.SiteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
	
	<cfquery name="rsDraftList" dbtype="query" maxrows="#arguments.limit#">
	select * from rsDraftList 
	order by #arguments.sortBy# #arguments.sortDirection#
	</cfquery>
	<cfreturn rsDraftList />
</cffunction>

<cffunction name="getNest" returntype="query" access="public" output="false">
		<cfargument name="ParentID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfargument name="sortBy" type="string" required="true" default="orderno">
		<cfargument name="sortDirection" type="string" required="true" default="asc">
		<cfargument name="searchString" type="string" required="true" default="">
		<cfset var rsNest = "">
		<cfset var sortOptions="menutitle,title,lastupdate,releasedate,orderno,displayStart,created,rating,comment,credits,type,subtype">
		<cfset var isExtendedSort=(not listFindNoCase(sortOptions,arguments.sortBy))>
		<cfset var dbType=variables.configBean.getDbType() />
		<cfset var tableModifier="">

		<cfif dbtype eq "MSSQL">
			<cfset tableModifier="with (nolock)">
		</cfif>
		
		<cfquery name="rsNest" datasource="#variables.configBean.getReadOnlyDatasource()#"   username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isfeature,tcontent.inheritObjects,tcontent.target,
		tcontent.targetParams,tcontent.islocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,
		tfiles.fileSize,tfiles.FileExt,tfiles.ContentType,tfiles.ContentSubType, tcontent.siteID, tcontent.featureStart,tcontent.featureStop,tcontent.template,tcontent.childTemplate,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontent.expires,
		tcontentstats.rating,tcontentstats.totalVotes, tcontentstats.comments,
		tfiles.filename as AssocFilename,tcontent.displayInterval, tcontent.sourceID, tcontent.fileid
	
		FROM tcontent LEFT JOIN tcontent tcontent2 #tableModifier# ON tcontent.contentid=tcontent2.parentid
		LEFT JOIN tfiles #tableModifier# On tcontent.FileID=tfiles.FileID and tcontent.siteID=tfiles.siteID
		LEFT JOIN tcontentstats #tableModifier# on (tcontent.contentID=tcontentstats.contentID 
								and tcontent.siteID=tcontentstats.siteID
								)

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
				or tcontent.Type = 'File' 
				or tcontent.Type = 'Folder'
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
		tfiles.fileSize,tfiles.FileExt,tfiles.ContentType,tfiles.ContentSubType, tcontent.created, tcontent.siteID, tcontent.featureStart,tcontent.featureStop,tcontent.template,tcontent.childTemplate,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontent.expires,
		tcontentstats.rating,tcontentstats.totalVotes, tcontentstats.comments,tfiles.filename,tcontent.displayInterval, tcontent.sourceID
		<cfif isExtendedSort>
			,qExtendedSort.extendedSort	
		</cfif>
		,tcontent.fileid
		
		order by
		<cfswitch expression="#arguments.sortBy#">
			<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displaystart,displaystop,created,credits,type,subtype">
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
	
		</cfquery>

		<cfreturn rsNest />
	</cffunction>
	
<cffunction name="getComponents" returntype="query" access="public" output="false">
		<cfargument name="moduleID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rsComponents = "">
		
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsComponents"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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

<cffunction name="getTop" returntype="query" access="public" output="true">
		<cfargument name="topID" type="string" required="true">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rsTop = "">
		
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsTop"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isFeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
		tcontent.isLocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,tfiles.fileEXT, tcontent.featurestart, tcontent.featurestop,tcontent.template,tcontent.childTemplate,
		tfiles.filename AS assocFilename,tfiles.fileid, tcontent.siteid
		FROM tcontent LEFT JOIN tcontent tcontent2 ON (tcontent.contentid=tcontent2.parentid)
		LEFT JOIN tfiles On tcontent.FileID=tfiles.FileID
		WHERE tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and tcontent.Active=1 and tcontent.contentid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.topID#"/>
		group by tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.subtype, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted,tcontent.isfeature,tcontent.inheritObjects,
		tcontent.inheritObjects,tcontent.target,tcontent.targetParams,tcontent.isLocked,tcontent.sortBy,tcontent.sortDirection,tcontent.releaseDate,tfiles.fileEXT, tcontent.featurestart, tcontent.featurestop, tcontent.template,tcontent.childTemplate,
		tcontent.featurestop,tcontent.template,tcontent.childTemplate,
		tfiles.filename ,tfiles.fileid, tcontent.siteid
		</cfquery>
		
		<cfreturn rsTop />
</cffunction>

<cffunction name="getComponentType" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="type" type="string" required="true">
	<cfset var rsComponentType = "">
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsComponentType"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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

	<cfreturn rsComponentType />
</cffunction>

<cffunction name="getHist" returntype="query" access="public" output="false" hint="I get all versions">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsHist = "">
	
	<cfquery name="rsHist" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select menutitle, tcontent.siteid, contentid, contenthistid, fileID, type, tcontent.lastupdateby, active, approved, tcontent.lastupdate, 
	display, displaystart, displaystop, moduleid, isnav, notes,isfeature,featurestart,featurestop,inheritObjects,filename,targetParams,releaseDate,
	tcontent.changesetID, tchangesets.name changesetName, tchangesets.published changsetPublished,tchangesets.publishDate changesetPublishDate , 
	tcontent.majorVersion,tcontent.minorVersion, tcontent.sourceID
	from tcontent 
	left Join tchangesets on (tcontent.changesetID=tchangesets.changesetID)
	where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> order by tcontent.lastupdate desc
	</cfquery>

	<cfreturn rsHist />
</cffunction>

<cffunction name="getDraftHist" returntype="query" access="public" output="false" hint="I get all draft versions">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsDraftList = "">
	
	<cfquery name="rsDraftList" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select menutitle, contentid, contenthistid, fileID, type, lastupdateby, active, approved, lastupdate, 
	display, displaystart, displaystop, moduleid, isnav, notes,isfeature,inheritObjects,filename,targetParams,releaseDate,path
	from tcontent where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	and approved=0 and changesetID is null
	order by lastupdate desc
	</cfquery>

	<cfreturn rsDraftList />
</cffunction>

<cffunction name="getPendingChangesets" returntype="query" access="public" output="false" hint="I get all draft versions">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsPendingChangeSets = "">
	
	<cfquery name="rsPendingChangeSets" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select menutitle, contentid, contenthistid, fileID, type, lastupdateby, active, approved, lastupdate, 
	display, displaystart, displaystop, moduleid, isnav, notes,isfeature,inheritObjects,filename,targetParams,releaseDate,path
	from tcontent where contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	and approved=0 and changesetID is not null
	order by lastupdate desc
	</cfquery>

	<cfreturn rsPendingChangeSets />
</cffunction>

<cffunction name="getArchiveHist" returntype="query" access="public" output="false" hint="I get all archived versions">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsArchiveHist = "">
	
	<cfquery name="rsArchiveHist" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select menutitle, contentid, contenthistid, fileID, type, lastupdateby, active, approved, lastupdate, 
	display, displaystart, displaystop, moduleid, isnav, notes,isfeature,inheritObjects,filename,targetParams,releaseDate
	from tcontent where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> 
	and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	and approved=1 
	and active=0 
	order by lastupdate desc
	</cfquery>

	<cfreturn rsArchiveHist />
</cffunction>

<cffunction name="getItemCount" returntype="query" access="public" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsItemCount = "">
	
	<cfquery name="rsItemCount" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT menuTitle, Title, filename, lastupdate, type  from  tcontent WHERE
	 contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/> and active=1 and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery> 


	<cfreturn rsItemCount />
</cffunction>

<cffunction name="getDownloadSelect" returntype="query" access="public" output="false">
	<cfargument name="contentid" type="string" required="true">
	<cfargument name="siteid" type="string" required="true">
	<cfset var rsDownloadSelect = "">
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsDownloadSelect"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select min(entered) as FirstEntered, max(entered) as LastEntered, Count(*) as CountEntered from tformresponsepackets 
	where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and formid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>
	</cfquery>


	<cfreturn rsDownloadSelect />
</cffunction>

<cffunction name="getPrivateSearch" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="keywords" type="string" required="true">
	<cfargument name="tag" type="string" required="true" default="">
	<cfargument name="sectionID" type="string" required="true" default="">
	<cfargument name="searchType" type="string" required="true" default="default" hint="Can be default or image">
	
	<cfset var rsPrivateSearch = "">
	<cfset var kw = trim(arguments.keywords)>
	
	<cfquery name="rsPrivateSearch" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" maxrows="1000">
	SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID, 
	tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
	tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isfeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
	tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt, 2 AS Priority, tcontent.nextn, tfiles.fileid,
	tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontent.expires,tfiles.filename as assocFilename
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

	<cfif len(arguments.tag)>
		Inner Join tcontenttags on (tcontent.contentHistID=tcontenttags.contentHistID)
	</cfif> 
	
	WHERE
	
	<cfif arguments.searchType eq "image">
	tfiles.fileext in ('png','gif','jpg','jpeg') AND
	</cfif>
	
	<cfif kw neq '' or arguments.tag neq ''>
         			(tcontent.Active = 1 
			  		AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
					
					AND
					
					
					tcontent.type in ('Page','Folder','Calendar','File','Link','Gallery')
						
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
		tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt, tcontent.nextn, tfiles.fileid,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontent.expires,tfiles.filename
		
		
		<cfif kw neq ''>	
		UNION
		
		SELECT tcontent.ContentHistID, tcontent.ContentID, tcontent.Approved, tcontent.filename, tcontent.Active, tcontent.Type, tcontent.OrderNo, tcontent.ParentID, 
		tcontent.Title, tcontent.menuTitle, tcontent.lastUpdate, tcontent.lastUpdateBy, tcontent.lastUpdateByID, tcontent.Display, tcontent.DisplayStart, 
		tcontent.DisplayStop,  tcontent.isnav, tcontent.restricted, count(tcontent2.parentid) AS hasKids,tcontent.isfeature,tcontent.inheritObjects,tcontent.target,tcontent.targetParams,
		tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt, 1 AS Priority, tcontent.nextn, tfiles.fileid,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontent.expires,tfiles.filename as assocFilename
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
		
		
		WHERE		
		
		<cfif arguments.searchType eq "image">
			tfiles.fileext in ('png','gif','jpg','jpeg') AND
		</cfif>
		
		(tcontent.Active = 1 
			  		AND tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
					
					AND
					
					
					tcontent.type in ('Page','Folder','Calendar','File','Link','Gallery')
						
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
		tcontent.target,tcontent.targetParams,tcontent.islocked,tcontent.releaseDate,tfiles.fileSize,tfiles.fileExt,tcontent.nextn, tfiles.fileid,
		tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, tcontent.expires,tfiles.filename 
	</cfif>
	</cfquery> 
	
	<cfquery name="rsPrivateSearch" dbtype="query">
	select * from rsPrivateSearch order by priority, title
	</cfquery>

	<cfreturn rsPrivateSearch />
</cffunction>

<cffunction name="getPublicSearch" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="keywords" type="string" required="true">
	<cfargument name="tag" type="string" required="true" default="">
	<cfargument name="sectionID" type="string" required="true" default="">
	<cfargument name="categoryID" type="string" required="true" default="">
	<cfset var rsPublicSearch = "">
	<cfset var w = "">
	<cfset var c = "">
	<cfset var categoryListLen=listLen(arguments.categoryID)>
	
	<cfquery name="rsPublicSearch" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	<!--- Find direct matches with no releasedate --->
	
	select tcontent.contentid,tcontent.contenthistid,tcontent.siteid,tcontent.title,tcontent.menutitle,tcontent.targetParams,tcontent.filename,tcontent.summary,tcontent.tags,
	tcontent.restricted,tcontent.releaseDate,tcontent.type,tcontent.subType,
	tcontent.restrictgroups,tcontent.target ,tcontent.displaystart,tcontent.displaystop,0 as Comments, 
	tcontent.credits, tcontent.remoteSource, tcontent.remoteSourceURL, 
	tcontent.remoteURL,tfiles.fileSize,tfiles.fileExt,tcontent.fileID,tcontent.audience,tcontent.keyPoints,
	tcontentstats.rating,tcontentstats.totalVotes,tcontentstats.downVotes,tcontentstats.upVotes, 0 as kids, 
	tparent.type parentType,tcontent.nextn,tcontent.path,tcontent.orderno,tcontent.lastupdate,tcontent.created,
	tcontent.created sortdate, 0 sortpriority,tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, 
	tcontent.expires,tfiles.filename as assocFilename
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
								(tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or tcontent.DisplayStop is null)
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
					and tcontenttags.Tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.tag)#"/> 
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
							(tcontent.Title like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
							or tcontent.menuTitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
							or tcontent.metaKeywords like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
							or tcontent.summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"> 
							or tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
							or tcontent.credits like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">)
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
	tparent.type parentType,tcontent.nextn,tcontent.path,tcontent.orderno,tcontent.lastupdate,tcontent.created,
	tcontent.releaseDate sortdate, 0 sortpriority,tcontent.majorVersion, tcontent.minorVersion, tcontentstats.lockID, 
	tcontent.expires,tfiles.filename as assocFilename
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
								(tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or tcontent.DisplayStop is null)
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
					and tcontenttags.Tag= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.tag)#"/> 
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
							(tcontent.Title like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
							or tcontent.menuTitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
							or tcontent.metaKeywords like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
							or tcontent.summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%"> 
							or tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
							or tcontent.credits like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">)
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
	</cfquery>
	
	<cfquery name="rsPublicSearch" dbtype="query">
		select *
		from rsPublicSearch 
		order by sortpriority, sortdate desc
	</cfquery>
	
	<cfreturn rsPublicSearch />
</cffunction>

<cffunction name="getCategoriesByHistID" returntype="query" access="public" output="false">
	<cfargument name="contentHistID" type="string" required="true">
	<cfset var rsCategoriesByHistID = "">
	
	<cfquery name="rsCategoriesByHistID" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select tcontentcategoryassign.*, tcontentcategories.name, tcontentcategories.filename, tcontentcategories.parentid, tcontentcategories.path from tcontentcategories inner join tcontentcategoryassign
		ON (tcontentcategories.categoryID=tcontentcategoryassign.categoryID)
		where tcontentcategoryassign.contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
		Order By tcontentcategories.filename
	</cfquery> 


	<cfreturn rsCategoriesByHistID />
</cffunction>

<cffunction name="getRelatedContent" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String">
	<cfargument name="contentHistID" type="String">
	<cfargument name="liveOnly" type="boolean" required="yes" default="false">
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	<cfargument name="sortBy" type="string" default="created" >
	<cfargument name="sortDirection" type="string" default="desc" >
	<cfset var rs ="" />

	<cfif not len(arguments.sortBy)>
		<cfset arguments.sortBy=created>
	</cfif>

	<cfif not len(arguments.sortDirection)>
		<cfset arguments.sortDirection=desc>
	</cfif>

	<cfquery name="rsRelatedContent" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT tcontent.title, tcontent.releasedate, tcontent.menuTitle, tcontent.lastupdate, tcontent.summary, tcontent.filename, tcontent.type, tcontent.contentid,
	tcontent.target,tcontent.targetParams, tcontent.restricted, tcontent.restrictgroups, tcontent.displaystart, tcontent.displaystop, tcontent.orderno,tcontent.sortBy,tcontent.sortDirection,
	tcontent.fileid, tcontent.credits, tcontent.remoteSource, tcontent.remoteSourceURL, tcontent.remoteURL,
	tfiles.fileSize,tfiles.fileExt,tcontent.path, tcontent.siteid, tcontent.contenthistid
	FROM  tcontent Left Join tfiles ON (tcontent.fileID=tfiles.fileID)

	WHERE
	tcontent.siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and tcontent.active=1 and
	
	tcontent.contentID in (
	select relatedID from tcontentrelated where contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
	)
	
	<cfif arguments.liveOnly>
	  AND (
			  (
			  	tcontent.Display = 2
			  	AND (
				  		(
				  			tcontent.DisplayStart >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.today#">   
							AND tcontent.parentID in (select contentID from tcontent 
															where type='Calendar'
															#renderActiveClause("tcontent",arguments.siteID)#
															and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
														   ) 
						 )	
					   OR 
					   	(
					   		tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.today#"> 
							AND 
							(
								tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.today#"> 
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
	</cfif>
	
	#renderMobileClause()#
	
	order by 
	
	<cfswitch expression="#arguments.sortBy#">
		<cfcase value="menutitle,title,lastupdate,releasedate,orderno,displaystart,displaystop,created,credits,type,subtype">
			<cfif variables.configBean.getDbType() neq "oracle" or  listFindNoCase("orderno,lastUpdate,releaseDate,created,displayStart,displayStop",arguments.sortBy)>
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
			tcontent.created desc
		</cfdefaultcase>
	</cfswitch>
	
	</cfquery>
	
	<cfreturn rsRelatedContent />

</cffunction>

<cffunction name="getUsage" access="public" output="false" returntype="query">
	<cfargument name="objectID" type="String">
	
	<cfset var rsUsage= ''/>
	
	<cfquery name="rsUsage" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select tcontent.menutitle, tcontent.type, tcontent.filename, tcontent.lastupdate, tcontent.contentID, tcontent.siteID,
	tcontent.approved,tcontent.display,tcontent.displayStart,tcontent.displayStop,tcontent.moduleid,tcontent.contenthistID,
	tcontent.parentID
	from tcontent inner join tcontentobjects on (tcontent.contentHistID=tcontentobjects.contentHistID)
	where tcontent.active=1 
	and  
	<cfif len(arguments.objectID)>
		objectID like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.objectID#%"/>
	<cfelse>
		0=1
	</cfif>
	</cfquery>
	
	<cfreturn rsUsage />
</cffunction>

<cffunction name="getTypeCount" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="type" type="String" required="true" default="">
	
	<cfset var rsTypeCount= ''/>
	
	<cfquery name="rsTypeCount" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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

<cffunction name="getRecentUpdates" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rsRecentUpdate= ''/>
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfquery name="rsRecentUpdate" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	<cfif dbType eq "oracle" and arguments.limit>select * from (</cfif>
	select <cfif dbType eq "mssql"  and arguments.limit>Top #arguments.limit#</cfif>
	contentID,contentHistID,approved,menutitle,parentID,moduleID,siteid,lastupdate,lastUpdatebyID,lastUpdateBy,type from tcontent
	where active=1 and type not in ('Module','Plugin')
	<cfif arguments.siteID neq ''>
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfif>

	<cfif isdate(arguments.stopDate)>and lastUpdate <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.stopDate),month(arguments.stopDate),day(arguments.stopDate),23,59,0)#"></cfif>
	<cfif isdate(arguments.startDate)>and lastUpdate >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.startDate),month(arguments.startDate),day(arguments.startDate),0,0,0)#"></cfif>
	
	order by lastupdate desc
	
	<cfif dbType eq "mysql" and arguments.limit>limit #arguments.limit#</cfif>
	<cfif dbType eq "oracle" and arguments.limit>) where ROWNUM <=#arguments.limit# </cfif>
	</cfquery>
	
	<cfreturn rsRecentUpdate />
</cffunction>

<cffunction name="getRecentFormActivity" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">
	
	<cfset var rsFormActivity= ''/>
	<cfset var dbType=variables.configBean.getDbType() />
	
	<cfquery name="rsFormActivity" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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
	
	<cfreturn rsFormActivity />
</cffunction>

<cffunction name="getTagCloud" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfargument name="categoryID" type="string" required="true" default="">
	<cfargument name="rsContent" type="any" required="true" default="">
	<cfargument name="moduleID" type="string" required="true" default="00000000000000000000000000000000000">
	<cfset var rsTagCloud= ''/>
	
	<cfquery name="rsTagCloud" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select tag, count(tag) as tagCount from tcontenttags 
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

	  AND 
		(
			
			tcontent.Display = 1
		OR
			(		
				tcontent.Display = 2
				
				AND
				 (
					(
						tcontent.DisplayStart <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
						AND (tcontent.DisplayStop >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> or tcontent.DisplayStop is null)
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

<cffunction name="getObjects" access="public" returntype="query" output="false">
	<cfargument name="columnID" required="yes" type="numeric" >
	<cfargument name="ContentHistID" required="yes" type="string" >
	<cfargument name="siteID" required="yes" type="string" >
	
	<cfset var rsObjects=""/>
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsObjects"  username="#application.configBean.getReadOnlyDbUsername()#" password="#application.configBean.getReadOnlyDbPassword()#">
	select tcontentobjects.object,tcontentobjects.objectid, tcontentobjects.orderno, tcontentobjects.params, tplugindisplayobjects.configuratorInit from tcontentobjects 
	inner join tcontent On(
	tcontentobjects.contenthistid=tcontent.contenthistid
	and tcontentobjects.siteid=tcontent.siteid) 
	left join tplugindisplayobjects on (tcontentobjects.object='plugin' 
										and tcontentobjects.objectID=tplugindisplayobjects.objectID)
	where tcontent.siteid='#arguments.siteid#' 
	and tcontent.contenthistid ='#arguments.contentHistID#'
	and tcontentobjects.columnid=#arguments.columnID# 
	order by tcontentobjects.orderno
	</cfquery>
		
	<cfreturn rsObjects>

</cffunction>

<cffunction name="getObjectInheritance" access="public" returntype="query" output="false">
	<cfargument name="columnID" required="yes" type="numeric" >
	<cfargument name="inheritedObjects" required="yes" type="string" >
	<cfargument name="siteID" required="yes" type="string" >
	
	<cfset var rsObjectInheritence=""/>
	<cfquery datasource="#application.configBean.getReadOnlyDatasource()#" name="rsObjectInheritence"  username="#application.configBean.getReadOnlyDbUsername()#" password="#application.configBean.getReadOnlyDbPassword()#">
	select tcontentobjects.object, tcontentobjects.objectid, tcontentobjects.orderno, tcontentobjects.params, tplugindisplayobjects.configuratorInit from tcontentobjects
	left join tplugindisplayobjects on (tcontentobjects.object='plugin' 
										and tcontentobjects.objectID=tplugindisplayobjects.objectID)  
	where 
	tcontentobjects.contenthistid ='#arguments.inheritedObjects#' 
	and tcontentobjects.siteid='#arguments.siteid#'
	and tcontentobjects.columnid=#arguments.columnID#
	and tcontentobjects.object <>'goToFirstChild'
	order by orderno
	</cfquery>
	
	<cfreturn rsObjectInheritence>
		
</cffunction>

<cffunction name="getExpiringContent" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="userid" type="string" required="true">
	<cfset var rsExpiringContent = "">
	
	<cfquery name="rsExpiringContent" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" maxrows="1000">
	SELECT contentid 
	FROM tcontent 
	
	WHERE
	lastUpdateByID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/> 
	and
	active=1 
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and expires <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd("m",1,now())#"> 
	and expires > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd("m",-12,now())#"> 
	
	UNION
	
	SELECT tcontent.contentid 
	FROM tcontent inner join tcontentassignments on (tcontent.contentHistID=tcontentassignments.contentHistID
													and tcontentassignments.type='expire')
	
	WHERE 
	tcontent.active=1 
	and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and tcontentassignments.userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"/> 
	and tcontent.expires <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd("m",1,now())#"> 
	and tcontent.expires > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd("m",-12,now())#"> 
	</cfquery> 


	<cfreturn rsExpiringContent />
</cffunction>

<cffunction name="getReleaseCountByMonth" output="false">
<cfargument name="siteid">
<cfargument name="parentID">
<cfset var rsReleaseCountByMonth="">

	<cfquery name="rsReleaseCountByMonth" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select
			parentID,
			<cfif variables.configBean.getDbTYpe() neq 'oracle'>
			month(releaseDate) m,
			year(releaseDate) y,
			<cfelse>
			TO_NUMBER(TO_CHAR(releaseDate, 'mm')) m,
			TO_NUMBER(TO_CHAR(releaseDate, 'yyyy')) y,
			</cfif>
			count(*) items  
		from tcontent 
		where parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"> 
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"> 
        #renderActiveClause("tcontent",arguments.siteID)#
		and releaseDate <> ''
		group by parentID,
		<cfif variables.configBean.getDbTYpe() neq 'oracle'>
			month(releaseDate),
			year(releaseDate)
			<cfelse>
			TO_NUMBER(TO_CHAR(releaseDate, 'mm')),
			TO_NUMBER(TO_CHAR(releaseDate, 'yyyy'))
		</cfif>
		
		union
		
		select
			parentID,
			<cfif variables.configBean.getDbTYpe() neq 'oracle'>
			month(lastUpdate) m,
			year(lastUpdate) y,
			<cfelse>
			TO_NUMBER(TO_CHAR(lastUpdate, 'mm')) m,
			TO_NUMBER(TO_CHAR(lastUpdate, 'yyyy')) y,
			</cfif>
			count(*) items  
		from tcontent 
		where parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#"> 
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"> 
        #renderActiveClause("tcontent",arguments.siteID)#
		and releaseDate is null
		group by parentID,
		<cfif variables.configBean.getDbTYpe() neq 'oracle'>
			month(lastUpdate),
			year(lastUpdate)
			<cfelse>
			TO_NUMBER(TO_CHAR(lastUpdate, 'mm')),
			TO_NUMBER(TO_CHAR(lastUpdate, 'yyyy'))
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
 	<cfoutput>
			<cfif request.muraChangesetPreview>
				<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
				<cfif len(previewData.contentIDList)>
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
					  			OR (tcontent.DisplayStart < #renderDateTimeArg(arguments.menuDateTime)# AND tcontent.DisplayStop >= #renderDateTimeArg(arguments.menuDateTime)#)
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
						  		AND  tcontent.releaseDate >= #renderDateTimeArg(createDate(year(arguments.menuDateTime),month(arguments.menuDateTime),1))#) 
						  		
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
							        tcontent.releaseDate < #renderDateTimeArg(dateadd("D",1,createDate(year(arguments.menuDateTime),12,31)))# AND tcontent.releaseDate >= #renderDateTimeArg(createDate(year(arguments.menuDateTime),1,1))#)
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

<cffunction name="renderDateTimeArg" returntype="string" output="false">
        <cfargument name="date">
       
        <cfif isDate(arguments.date)>
        	<cfif variables.configBean.getCompiler() eq "Adobe" and variables.configBean.getDbType() eq "MSSQL">
                <cfreturn "'" & dateFormat(createODBCDateTime(arguments.date), "yyyy-mm-dd") & 'T' & timeFormat(createODBCDateTime(arguments.date), "HH:mm:ss.l") & "'">
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

</cfcomponent>