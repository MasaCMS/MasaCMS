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
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="categoryGateway" type="any" required="yes"/>
<cfargument name="categoryDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="categoryUtility" type="any" required="yes"/>

	<cfset variables.configBean=arguments.configBean />
	<cfset variables.gateway=arguments.categoryGateway />
	<cfset variables.DAO=arguments.categoryDAO />
	<cfset variables.utility=arguments.utility />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.categoryUtility=arguments.categoryUtility />
	
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
<cfset var path = "'#categoryBean.getCategoryID()#'" />
<cfset var reversePath = "" />
<cfset var i =0 />
	
	<cfif ID neq ''>
		
		<cfloop condition="ID neq ''">
				<cfset path =  listAppend(path,"'#ID#'")>
				<cfquery name="rsCat" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var categoryBean=application.serviceFactory.getBean("categoryBean") />
	<cfset categoryBean.set(arguments.data) />

	<cfif structIsEmpty(categoryBean.getErrors())>

		<cfset categoryBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset categoryBean.setCategoryID("#createUUID()#") />
		<cfset setMaterializedPath(categoryBean) />
		<cfset variables.utility.logEvent("CategoryID:#categoryBean.getCategoryID()# Name:#categoryBean.getName()# was created","sava-content","Information",true) />
		<cfset variables.DAO.create(categoryBean) />
	</cfif>
	
	<cfreturn categoryBean />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="categoryID" type="String" />		
	
	<cfreturn variables.DAO.read(arguments.categoryID) />

</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var categoryBean=variables.DAO.read(arguments.data.categoryID) />
	<cfset var currentParentID= "" />
	<cfset var currentPath= "" />
	
	<cfset currentParentID=categoryBean.getParentID() />
	<cfset categoryBean.set(arguments.data) />
	<cfset currentPath=categoryBean.getPath() />
	
	<cfif structIsEmpty(categoryBean.getErrors())>
	
		<cfif currentParentID neq categoryBean.getParentID()>
			<cfset setMaterializedPath(categoryBean) />
			<cfset updateMaterializedPath(categoryBean.getPath(),currentPath,categoryBean.getSiteID())>
		</cfif>
	
		<cfset categoryBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset variables.DAO.update(categoryBean) />
		<cfif isdefined('arguments.data.OrderID')>
			<cfset setListOrder(categoryBean.getCategoryID(),arguments.data.OrderID,arguments.data.Orderno,arguments.data.siteID) />
		</cfif>
	</cfif>
	
	<cfset variables.utility.logEvent("CategoryID:#categoryBean.getCategoryID()# Name:#categoryBean.getName()# was updated","sava-content","Information",true) />
	
	<cfreturn categoryBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="categoryID" type="String" />		
	
	<cfset var categoryBean=read(arguments.categoryID) />
	<cfset var currentPath=categoryBean.getPath() />
	<cfset var newPath=""/>
	
	<cfif currentPath neq "">
		<cfset newPath=listDeleteAt(categoryBean.getPath(),listLen(categoryBean.getPath())) /> 
		<cfset updateMaterializedPath(newPath,currentPath,categoryBean.getSiteID())>
	</cfif>
	<cfset variables.utility.logEvent("CategoryID:#categoryBean.getCategoryID()# Name:#categoryBean.getName()# was deleted","sava-content","Information",true) />
	<cfset variables.DAO.delete(arguments.categoryID) />

</cffunction>

<cffunction name="setListOrder" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="orderID" type="string" default=""/>
	<cfargument name="orderno" type="string" default=""/>
	<cfargument name="siteid" type="string" default=""/>
	
	<cfset variables.DAO.setListOrder(arguments.categoryID,arguments.orderID,arguments.orderno,arguments.siteid) />
	<cfset variables.utility.flushCache(arguments.siteid) />

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
 

</cfcomponent>