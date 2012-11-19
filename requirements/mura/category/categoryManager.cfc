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
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="categoryGateway" type="any" required="yes"/>
<cfargument name="categoryDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="categoryUtility" type="any" required="yes"/>
<cfargument name="pluginManager" type="any" required="yes"/>
<cfargument name="trashManager" type="any" required="yes"/>
<cfargument name="clusterManager" type="any" required="yes"/>

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.gateway=arguments.categoryGateway />
	<cfset variables.DAO=arguments.categoryDAO />
	<cfset variables.utility=arguments.utility />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.categoryUtility=arguments.categoryUtility />
	<cfset variables.pluginManager=arguments.pluginManager />
	<cfset variables.trashManager=arguments.trashManager />
	<cfset variables.clusterManager=arguments.clusterManager />
	
	<cfreturn this />
</cffunction>

<cffunction name="getPrivateInterestGroups" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="parentID"  type="string" />

	<cfreturn variables.gateway.getPrivateInterestGroups(arguments.siteid,arguments.parentID) />
</cffunction>

<cffunction name="getPublicInterestGroups" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="parentID"  type="string" />

	<cfreturn variables.gateway.getPublicInterestGroups(arguments.siteid,arguments.parentID) />
</cffunction>

<cffunction name="getInterestGroupCount" access="public" output="false" returntype="numeric">
	<cfargument name="siteID" type="String">
	<cfargument name="activeOnly" type="boolean" required="true" default="false">

	<cfreturn variables.gateway.getInterestGroupCount(arguments.siteid,arguments.activeOnly) />
</cffunction>

<cffunction name="getCategoryCount" access="public" output="false" returntype="numeric">
	<cfargument name="siteID" type="String">
	<cfargument name="activeOnly" type="boolean" required="true" default="false">

	<cfreturn variables.gateway.getCategoryCount(arguments.siteid,arguments.activeOnly) />
</cffunction>

<cffunction name="getCategories" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="parentID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>
	<cfargument name="activeOnly" type="boolean" required="true" default="false">
	<cfargument name="InterestsOnly" type="boolean" required="true" default="false">

	<cfreturn variables.gateway.getCategories(arguments.siteid,arguments.parentID,arguments.keywords,arguments.activeOnly,arguments.InterestsOnly) />
</cffunction>

<cffunction name="getIterator" returntype="any" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="parentID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>
	<cfargument name="activeOnly" type="boolean" required="true" default="true">
	<cfargument name="InterestsOnly" type="boolean" required="true" default="false">
	
	<cfset var it=getBean("categoryIterator").init()>
	<cfset it.setQuery(getCategories(arguments.siteid,arguments.parentID,arguments.keywords,arguments.activeOnly,arguments.InterestsOnly))>
	<cfreturn it />
</cffunction>

<cffunction name="getCategoriesBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>

	<cfreturn variables.gateway.getCategoriesBySiteID(arguments.siteid,arguments.keywords) />
</cffunction>

<cffunction name="getInterestGroupsBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>

	<cfreturn variables.gateway.getInterestGroupsBySiteID(arguments.siteid,arguments.keywords) />
</cffunction>

<cffunction name="getCategoryfeatures" returntype="query" access="public" output="false">
	<cfargument name="categoryID"  type="string" />
	
	<cfset var categoryBean=read(arguments.categoryID) />
	<cfreturn variables.gateway.getCategoryFeatures(categoryBean) />
</cffunction>

<cffunction name="getLiveCategoryFeatures" returntype="query" access="public" output="false">
	<cfargument name="categoryID"  type="string" />
	
	<cfset var categoryBean=read(arguments.categoryID) />
	<cfreturn variables.gateway.getLiveCategoryFeatures(categoryBean) />
</cffunction>

<cffunction name="setMaterializedPath" returntype="void" output="false">
<cfargument name="categoryBean" type="any">

<cfset var rsCat= ""/>		
<cfset var ID = arguments.categoryBean.getParentID() />	
<cfset var path = "#categoryBean.getCategoryID()#" />
<cfset var reversePath = "" />
<cfset var i =0 />
	
	<cfif ID neq ''>
		
		<cfloop condition="ID neq ''">
				<cfset path =  listAppend(path,"'#ID#'")>
				<cfquery name="rsCat" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				select parentid from tcontentcategories where categoryid='#ID#' and siteid='#arguments.categoryBean.getSiteID()#'
				</cfquery>
				<cfset ID = rsCat.parentID />
		</cfloop>
		
		<cfloop from="#ListLen(path)#" to="1" index="i" step="-1">
			<cfset reversePath=listAppend(reversePath,"#listGetAt(path,i)#")>
		</cfloop>
	
		<cfset path=reversePath />
	</cfif>
	
	<cfset arguments.categoryBean.setPath(path)>

</cffunction>

<cffunction name="updateMaterializedPath" returntype="void" output="false">
<cfargument name="newPath" type="any">
<cfargument name="currentPath" type="any">
<cfargument name="siteID" type="any">

	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentcategories 
		set path=replace(rtrim(ltrim(cast(path AS char(1000)))),<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.currentPath#">,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.newPath#">) 
		where path like	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.currentPath#%">
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfquery>
		

</cffunction>

<cffunction name="save" access="public" returntype="any" output="false">
	<cfargument name="data" type="any" default="#structnew()#"/>	
	
	<cfset var categoryID="">
	<cfset var rs="">
	
	<cfif isObject(arguments.data)>
		<cfif listLast(getMetaData(arguments.data).name,".") eq "categoryBean">
			<cfset arguments.data=arguments.data.getAllValues()>
		<cfelse>
			<cfthrow type="custom" message="The attribute 'DATA' is not of type 'mura.category.categoryBean'">
		</cfif>
	</cfif>
	
	<cfif not structKeyExists(arguments.data,"categoryID")>
		<cfthrow type="custom" message="The attribute 'CATEGORYID' is required when saving a category.">
	</cfif>
	
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#" name="rs">
	select categoryID from tcontentcategories where categoryID=<cfqueryparam value="#arguments.data.categoryID#">
	</cfquery>
	
	<cfif rs.recordcount>
		<cfreturn update(arguments.data)>	
	<cfelse>
		<cfreturn create(arguments.data)>
	</cfif>

</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var categoryBean=getBean("categoryBean") />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
	<cfset var parentBean="">
	<cfset categoryBean.set(arguments.data) />
	<cfset categoryBean.validate()>

	<cfset pluginEvent.setValue("categoryBean",categoryBean)>
	<cfset pluginEvent.setValue("siteID", categoryBean.getSiteID())>
	<cfset variables.pluginManager.announceEvent("onBeforeCategorySave",pluginEvent)>
	<cfset variables.pluginManager.announceEvent("onBeforeCategoryCreate",pluginEvent)>
	
	<cfif structIsEmpty(categoryBean.getErrors())>
		<cfset categoryBean.setLastUpdateBy(left(session.mura.fname & " " & session.mura.lname,50)) />
		<cfif not (structKeyExists(arguments.data,"categoryID") and len(arguments.data.categoryID))>
			<cfset categoryBean.setCategoryID("#createUUID()#") />
		</cfif>
		
		<cfset setMaterializedPath(categoryBean) />
		
		<cfif not len(categoryBean.getURLTitle())>
			<cfset categoryBean.setURLTitle(categoryBean.getName())>
		</cfif>

		<cfset parentBean=read(categoryBean.getParentID())>
		<cfif not parentBean.getIsNew()>
			<cfif not len(parentBean.getFilename())>
				<cfset parentBean.save()>
				<cfset parentBean=read(categoryBean.getParentID())>
			</cfif>
			<cfset categoryBean.setFilename(parentBean.getFilename() & "/" & categoryBean.getURLTitle())>
		<cfelse>
			<cfset categoryBean.setFilename(categoryBean.getURLTitle())>
		</cfif>
		
		<cfset makeFilenameUnique(categoryBean)>
		
		<cfset variables.utility.logEvent("CategoryID:#categoryBean.getCategoryID()# Name:#categoryBean.getName()# was created","mura-content","Information",true) />
		<cfset variables.DAO.create(categoryBean) />
		
		<cfset variables.trashManager.takeOut(categoryBean)>
		<cfset categoryBean.setIsNew(0)>
		<cfset purgeCategoryCache(categoryBean=categoryBean)>
		
		<cfset variables.pluginManager.announceEvent("onCategorySave",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onCategoryCreate",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterCategorySave",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterCategoryCreate",pluginEvent)>
	</cfif>
	
	<cfreturn categoryBean />
</cffunction>

<cffunction name="makeFilenameUnique" output="false">
<cfargument name="categoryBean">
	<cfset var count=0>
	<cfset var isUnique=false>
	<cfset var rsCheck="">
	<cfset var tempFilename=arguments.categoryBean.getFilename()>
	<cfloop condition="not isUnique">
		<cfquery name="rsCheck" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select categoryID from tcontentcategories 
			where categoryID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryBean.getCategoryID()#">
			and filename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#tempFilename#">
		</cfquery>
		<cfif rsCheck.recordcount>
			<cfset count=count+1>
			<cfset tempFilename=arguments.categoryBean.getFilename() & count>
		<cfelse>
			<cfset isUnique=true>
		</cfif>
	</cfloop>
	
	<cfif count>
		<cfset arguments.categoryBean.setFilename(tempFilename)>
		<cfset arguments.categoryBean.setURLTitle(listLast(tempFilename,"/"))>
	</cfif>
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="categoryID" required="true" default=""/>
	<cfargument name="name" required="true" default=""/>
	<cfargument name="remoteID" required="true" default=""/>
	<cfargument name="filename" required="true" default=""/>
	<cfargument name="siteID" required="true" default=""/>
	<cfargument name="categoryBean" required="true" default=""/>		
	<cfset var key= "" />
	<cfset var site=""/>
	<cfset var cacheFactory="">
	<cfset var bean=arguments.categoryBean>	
	
	<cfif not len(arguments.siteID) and isdefined("session.siteID")>
		<cfset arguments.siteID=session.siteID>
	</cfif>
	
	<cfif not len(arguments.categoryID) and len(arguments.siteID)>
		<cfif len(arguments.name)>
			<cfreturn readByName(arguments.name, arguments.siteID, bean) />
		<cfelseif len(arguments.remoteID)>
			<cfreturn readByRemoteID(arguments.remoteID, arguments.siteID, bean) />
		<cfelseif len(arguments.filename)>
			<cfreturn readByFilename(arguments.filename, arguments.siteID, bean) />
		</cfif>
	</cfif>

	<cfset key= "category" & arguments.siteid & arguments.categoryID />
	<cfset site=variables.settingsManager.getSite(arguments.siteid)/>
	<cfset cacheFactory=site.getCacheFactory(name="data")>			
	
	<cfif site.getCache()>
		<!--- check to see if it is cached. if not then pass in the context --->
		<!--- otherwise grab it from the cache --->
		<cfif NOT cacheFactory.has( key )>
			<cfset bean=variables.DAO.read(arguments.categoryID,bean)>
			<cfif not bean.getIsNew()>
				<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
			</cfif>
			<cfreturn bean/>
		<cfelse>
			<cftry>
				<cfif not isObject(bean)>
					<cfset bean=variables.DAO.getBean("category")/>
				</cfif>
				<cfset bean.setAllValues( structCopy(cacheFactory.get( key )) )>
				<cfreturn bean />
				<cfcatch>
					<cfset bean=variables.DAO.read(arguments.categoryID,bean)>
					<cfif not bean.getIsNew()>
						<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
					</cfif>
					<cfreturn bean/>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfreturn variables.DAO.read(arguments.categoryID,bean) />
	</cfif>		
	
</cffunction>

<cffunction name="readByName" access="public" returntype="any" output="false">
	<cfargument name="name" type="String" />		
	<cfargument name="siteid" type="string" />
	<cfargument name="categoryBean" required="true" default=""/>
	<cfset var key= "category" & arguments.siteid & arguments.name />
	<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
	<cfset var cacheFactory=site.getCacheFactory(name="data")>
	<cfset var bean=arguments.categoryBean>	
	
	<cfif site.getCache()>
		<!--- check to see if it is cached. if not then pass in the context --->
		<!--- otherwise grab it from the cache --->
		<cfif NOT cacheFactory.has( key )>
			<cfset bean=variables.DAO.readByName(arguments.name,arguments.siteID,bean) >
			<cfif not isArray(bean) and not bean.getIsNew()>
				<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
			</cfif>
			<cfreturn bean/>
		<cfelse>
			<cftry>
				<cfif not isObject(bean)>
					<cfset bean=variables.DAO.getBean("category")/>
				</cfif>
				<cfset bean.setAllValues( structCopy(cacheFactory.get( key )) )>
				<cfreturn bean />
				<cfcatch>
					<cfset bean=variables.DAO.readByName(arguments.name,arguments.siteID,bean) >
					<cfif not isArray(bean) and not bean.getIsNew()>
						<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
					</cfif>
					<cfreturn bean/>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfreturn variables.DAO.readByName(arguments.name,arguments.siteID,bean) />
	</cfif>	

</cffunction>

<cffunction name="readByFilename" access="public" returntype="any" output="false">
	<cfargument name="filename" type="String" />		
	<cfargument name="siteid" type="string" />
	<cfargument name="categoryBean" required="true" default=""/>
	<cfset var key= "" />
	<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
	<cfset var cacheFactory=site.getCacheFactory(name="data")>
	<cfset var bean=arguments.categoryBean>
	
	<cfif arguments.filename eq "/">
		<cfset arguments.filename="">
	<cfelse>
		<cfif left(arguments.filename,1) eq "/">
			<cfif len(arguments.filename) gt 1>
				<cfset arguments.filename=right(arguments.filename,len(arguments.filename)-1)>
			<cfelse>
				<cfset arguments.filename="">
			</cfif>
		</cfif>
			
		<cfif right(arguments.filename,1) eq "/">
			<cfif len(arguments.filename) gt 1>
				<cfset arguments.filename=left(arguments.filename,len(arguments.filename)-1)>
			<cfelse>
				<cfset arguments.filename="">
			</cfif>
		</cfif>
	</cfif>
	
	<cfset key= "category" & arguments.siteid & arguments.filename />
	
	<cfif site.getCache()>
		<!--- check to see if it is cached. if not then pass in the context --->
		<!--- otherwise grab it from the cache --->
		<cfif NOT cacheFactory.has( key )>
			<cfset bean=variables.DAO.readByFilename(arguments.filename,arguments.siteID,bean) >
			<cfif not isArray(bean) and not bean.getIsNew()>
				<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
			</cfif>
			<cfreturn bean/>
		<cfelse>
			<cftry>
				<cfif not isObject(bean)>
					<cfset bean=variables.DAO.getBean("category")/>
				</cfif>
				<cfset bean.setAllValues( structCopy(cacheFactory.get( key )) )>
				<cfreturn bean />
				<cfcatch>
					<cfset bean=variables.DAO.readByFilename(arguments.filename,arguments.siteID,bean) >
					<cfif not isArray(bean) and not bean.getIsNew()>
						<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
					</cfif>
					<cfreturn bean/>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfreturn variables.DAO.readByFilename(arguments.filename,arguments.siteID,bean) />
	</cfif>	

</cffunction>

<cffunction name="readByRemoteID" access="public" returntype="any" output="false">
	<cfargument name="remoteID" type="String" />
	<cfargument name="siteID" type="String" />
	<cfargument name="categoryBean" required="true" default=""/>		
	<cfset var key= "category" & arguments.siteid & arguments.remoteID />
	<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
	<cfset var cacheFactory=site.getCacheFactory(name="data")>
	<cfset var bean=arguments.categoryBean>	
	
	<cfif site.getCache()>
		<!--- check to see if it is cached. if not then pass in the context --->
		<!--- otherwise grab it from the cache --->
		<cfif NOT cacheFactory.has( key )>
			<cfset bean=variables.DAO.readByRemoteID(arguments.remoteID,arguments.siteID,bean) >
			<cfif not isArray(bean) and not bean.getIsNew()>
				<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
			</cfif>
			<cfreturn bean/>
		<cfelse>
			<cftry>
				<cfif not isObject(bean)>
					<cfset bean=variables.DAO.getBean("category")/>
				</cfif>
				<cfset bean.setAllValues( structCopy(cacheFactory.get( key )) )>
				<cfreturn bean />
				<cfcatch>
					<cfset bean=variables.DAO.readByRemoteID(arguments.remoteID,arguments.siteID,bean) >
					<cfif not isArray(bean) and not bean.getIsNew()>
						<cfset cacheFactory.get( key, structCopy(bean.getAllValues()) ) />
					</cfif>
					<cfreturn bean/>
				</cfcatch>
			</cftry>
		</cfif>
	<cfelse>
		<cfreturn variables.DAO.readByRemoteID(arguments.remoteID,arguments.siteID,bean) />
	</cfif>	

</cffunction>

<cffunction name="purgeCategoryCache" output="false">
	<cfargument name="categoryID">
	<cfargument name="categoryBean">
	<cfargument name="broadcast" default="true">
	<cfset var cache="">
	
	<cfif NOT isDefined("arguments.categoryBean")>
		<cfset arguments.categoryBean=read(categoryID=arguments.categoryID)>
	</cfif>
	
	<cfif NOT arguments.categoryBean.getIsNew()>
		<cfset cache=variables.settingsManager.getSite(arguments.categoryBean.getSiteID()).getCacheFactory(name="data")>
		
		<cfset cache.purge("category" & arguments.categoryBean.getSiteID() & arguments.categoryBean.getCategoryID())>
		<cfif len(arguments.categoryBean.getRemoteID())>
			<cfset cache.purge("category" & arguments.categoryBean.getSiteID() & arguments.categoryBean.getRemoteID())>
		</cfif>
		<cfif len(arguments.categoryBean.getName())>
			<cfset cache.purge("category" & arguments.categoryBean.getSiteID() & arguments.categoryBean.getName())>
		</cfif>
		<cfif len(arguments.categoryBean.getFilename())>
			<cfset cache.purge("category" & arguments.categoryBean.getSiteID() & arguments.categoryBean.getFilename())>
		</cfif>
		
		<cfif arguments.broadcast>
			<cfset variables.clusterManager.purgeCategoryCache(categoryID=arguments.categoryBean.getcategoryID())>
		</cfif>
	</cfif>
</cffunction>
	
<cffunction name="purgeCategoryDescendentsCache" output="false">
	<cfargument name="categoryID">
	<cfargument name="categoryBean">
	<cfargument name="broadcast" default="true">
	<cfset var it="">
	<cfset var rs="">
	
	<cfif not isDefined("arguments.categoryBean")>
		<cfset arguments.categoryBean=read(categoryID=arguments.categoryID)>
	</cfif>
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select categoryID,siteID,dateCreated,lastUpdate,lastUpdateBy,
	name,isInterestGroup,parentID,isActive,isOpen,notes,sortBy,
	sortDirection,restrictGroups,path,remoteID,remoteSourceURL,
	remotePubDate,urlTitle,filename
	from tcontentcategories where 
	path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.categoryBean.getCategoryID()#%">
	</cfquery>
	
	<cfset it=getBean("categoryIterator").setQuery(rs)>

	<cfloop condition="it.hasNext()">
		<cfset purgeCategoryCache(categoryBean=it.next(),broadcast=false)>
	</cfloop>
	
	<cfif arguments.broadcast>
		<cfset variables.clusterManager.purgeCategoryDescendentsCache(categoryID=arguments.categoryBean.getcategoryID())>
	</cfif>
</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var categoryBean=variables.DAO.read(arguments.data.categoryID) />
	<cfset var currentParentID= "" />
	<cfset var currentURLTitle= "" />
	<cfset var currentPath= "" />
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
	<cfset var currentFilename="">
	<cfset var parentBean="">
	<cfset currentParentID=categoryBean.getParentID() />
	<cfset currentURLTitle=categoryBean.getURLTitle() />
	<cfset currentFilename=categoryBean.getFilename() />
	<cfset categoryBean.set(arguments.data) />
	<cfset categoryBean.validate()>
	<cfset currentPath=categoryBean.getPath() />
	
	<cfset pluginEvent.setValue("categoryBean",categoryBean)>
	<cfset pluginEvent.setValue("siteID", categoryBean.getSiteID())>
	<cfset variables.pluginManager.announceEvent("onBeforeCategorySave",pluginEvent)>
	<cfset variables.pluginManager.announceEvent("onBeforeCategoryUpdate",pluginEvent)>
		
	<cfif structIsEmpty(categoryBean.getErrors())>	
		<cfif not len(categoryBean.getURLTitle())>
			<cfset categoryBean.setURLTitle(categoryBean.getName())>
		</cfif>
	
		<cfif currentURLTitle neq categoryBean.getURLTitle()
			or currentParentID neq categoryBean.getParentID()>		
			
			<cfif currentParentID neq categoryBean.getParentID()>
				<cfset setMaterializedPath(categoryBean) />
				<cfset updateMaterializedPath(categoryBean.getPath(),currentPath,categoryBean.getSiteID())>
			</cfif>
		
			<cfset parentBean=read(categoryBean.getParentID())>
			
			<cfif not parentBean.getIsNew()>
				<cfif not len(parentBean.getFilename())>
					<cfset parentBean.save()>
					<cfset parentBean=read(categoryBean.getParentID())>
				</cfif>
				<cfset categoryBean.setFilename(parentBean.getFilename() & "/" & categoryBean.getURLTitle())>
			<cfelse>
				<cfset categoryBean.setFilename(categoryBean.getURLTitle())>
			</cfif>
		
			<cfset makeFilenameUnique(categoryBean)>
			
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			update tcontentcategories set filename=replace(filename,<cfqueryparam cfsqltype="cf_sql_varchar" value="#currentFilename#/"/>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryBean.getFilename()#/"/>) where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryBean.getSiteID()#"/>
			and filename like <cfqueryparam cfsqltype="cf_sql_varchar" value="#currentFilename#/%"/>
			</cfquery>
			
			<cfset purgeCategoryDescendentsCache(categoryBean=categoryBean)>
		</cfif>
		
		<cfset categoryBean.setLastUpdateBy(left(session.mura.fname & " " & session.mura.lname,50)) />
		<cfset variables.DAO.update(categoryBean) />
		<cfif isdefined('arguments.data.OrderID')>
			<cfset setListOrder(categoryBean.getCategoryID(),arguments.data.OrderID,arguments.data.Orderno,arguments.data.siteID) />
		</cfif>
		<cfset purgeCategoryCache(categoryBean=categoryBean)>
		<cfset variables.pluginManager.announceEvent("onCategorySave",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onCategoryUpdate",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterCategorySave",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterCategoryUpdate",pluginEvent)>
	</cfif>
	
	<cfset variables.utility.logEvent("CategoryID:#categoryBean.getCategoryID()# Name:#categoryBean.getName()# was updated","mura-content","Information",true) />
	
	<cfreturn categoryBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="categoryID" type="String" />		
	
	<cfset var categoryBean=read(arguments.categoryID) />
	<cfset var currentPath=categoryBean.getPath() />
	<cfset var newPath=""/>
	<cfset var pluginEvent = "" />
	<cfset var pluginStruct=structNew()>
	
	<cfset pluginStruct.categoryBean=categoryBean>
	<cfset pluginStruct.siteID=categoryBean.getSiteID()>
	<cfset pluginStruct.categoryID=arguments.categoryID>
	
	<cfset pluginEvent=createObject("component","mura.event").init(pluginStruct)>
	
	<cfset variables.pluginManager.announceEvent("onBeforeCategoryDelete",pluginEvent)>
	
	<cfif currentPath neq "">
		<cfset newPath=listDeleteAt(categoryBean.getPath(),listLen(categoryBean.getPath())) /> 
		<cfset updateMaterializedPath(newPath,currentPath,categoryBean.getSiteID())>
	</cfif>
	
	<cfset variables.trashManager.throwIn(categoryBean)>
	<cfset variables.utility.logEvent("CategoryID:#categoryBean.getCategoryID()# Name:#categoryBean.getName()# was deleted","mura-content","Information",true) />
	<cfset variables.DAO.delete(arguments.categoryID) />
	<cfset purgeCategoryCache(categoryBean=categoryBean)>
	<cfset purgeCategoryDescendentsCache(categoryBean=categoryBean)>
	<cfset variables.pluginManager.announceEvent("onCategoryDelete",pluginEvent)>
	<cfset variables.pluginManager.announceEvent("onAfterCategoryDelete",pluginEvent)>

</cffunction>

<cffunction name="setListOrder" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="orderID" type="string" default=""/>
	<cfargument name="orderno" type="string" default=""/>
	<cfargument name="siteid" type="string" default=""/>
	
	<cfset variables.DAO.setListOrder(arguments.categoryID,arguments.orderID,arguments.orderno,arguments.siteid) />
	<cfset variables.settingsManager.getSite(arguments.siteid).purgeCache() />

</cffunction>

<cffunction name="setCategories" returntype="void" access="public" output="false">
	<cfargument name="data" type="struct" default="#structNew()#"/>
	<cfargument name="contentID" type="string" default=""/>
	<cfargument name="contentHistID" type="string" default=""/>
	<cfargument name="siteID" type="string" default=""/>
	<cfargument name="rsCurrent" type="query"/>
	
	<cfset var orderno=0/>
	<cfset var isFeature=0/>
	<cfset var rsCategories=variables.gateway.getCategoriesBySiteID(arguments.siteid,'') />
	<cfset var catTrim=""/>
	<cfset var rsKeeper=""/>
	<cfset var schedule= structNew()/>
	
	<cfloop query="rsCategories">
		<cfif isdefined('arguments.data.categoryAssign#replace(rsCategories.categoryID,'-','','ALL')#')
		and listFind(arguments.data.categoryid,rsCategories.categoryID)
		and arguments.data['categoryAssign#replace(rsCategories.categoryID,'-','','ALL')#'] neq ''>
		
		<cfset catTrim=replace(rsCategories.categoryID,'-','','ALL') />
		
			<cfset isFeature=arguments.data['categoryAssign#catTrim#'] />
			
			
			<cfif isFeature>
			
				<cfset orderno = variables.DAO.getCurrentOrderNO(rsCategories.categoryID,arguments.contentid,arguments.siteid) />
				<cfif not orderno>
					<cfset variables.DAO.pushCategory(rsCategories.categoryID,arguments.siteID) />
					<cfset orderno=1/>
				</cfif>
				
			</cfif>
			
			<cfif isFeature eq 2>
				<cfset schedule.featureStart=arguments.data['featureStart#catTrim#'] />
				<cfset schedule.starthour=arguments.data['starthour#catTrim#'] />
				<cfset schedule.startMinute=arguments.data['startMinute#catTrim#'] />
				<cfset schedule.startDayPart=arguments.data['startDayPart#catTrim#'] />
				<cfset schedule.featureStop=arguments.data['featureStop#catTrim#'] />
				<cfset schedule.stopHour=arguments.data['stopHour#catTrim#'] />
				<cfset schedule.stopMinute=arguments.data['stopMinute#catTrim#'] />
				<cfset schedule.stopDayPart=arguments.data['stopDayPart#catTrim#'] />
			<cfelse>
				<cfset schedule.featureStart="" />
				<cfset schedule.starthour="" />
				<cfset schedule.startMinute="" />
				<cfset schedule.startDayPart="" />
				<cfset schedule.featureStop="" />
				<cfset schedule.stopHour="" />
				<cfset schedule.stopMinute="" />
				<cfset schedule.stopDayPart="" />
			</cfif>
			
			<cfset variables.DAO.setAssignment(rsCategories.categoryID,arguments.contentID,arguments.contentHistID,isFeature,orderno,arguments.siteID,schedule) />
		<cfelseif not isdefined('arguments.data.categoryAssign#replace(rsCategories.categoryID,'-','','ALL')#')>
			<cfquery name="rsKeeper" dbType="query">
				select * from arguments.rsCurrent where categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCategories.categoryID#" />
			</cfquery>
				
			<cfif rsKeeper.recordcount>
				<cfset variables.DAO.saveAssignment(arguments.contentHistID, rsKeeper.contentID, rsKeeper.categoryID, rsKeeper.siteID,
				rsKeeper.orderno, rsKeeper.isFeature, rsKeeper.featureStart, rsKeeper.featureStop)>
			</cfif>
		</cfif>
	</cfloop>	

</cffunction>

<cffunction name="keepCategories" returntype="void" access="public" output="false">
	<cfargument name="contentHistID" type="string" default=""/>
	<cfargument name="rsKeepers" type="query"/>
		
		<cfset variables.DAO.keepCategories(arguments.contentHistID,arguments.rsKeepers) />

</cffunction>

<cffunction name="getCrumbQuery" output="false" returntype="any">
	<cfargument name="path" required="true">
	<cfargument name="siteID" required="true">
	<cfargument name="sort" required="true" default="asc">

	<cfreturn variables.gateway.getCrumbQuery(arguments.path, arguments.siteid, arguments.sort)>
</cffunction>
	
</cfcomponent>