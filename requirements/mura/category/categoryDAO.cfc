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

<cfset variables.fieldlist="categoryID,siteID,dateCreated,lastUpdate,lastUpdateBy,name,isInterestGroup,parentID,isActive,isOpen,notes,sortBy,sortDirection,restrictGroups,path,remoteID,remoteSourceURL,remotePubDate,urlTitle,filename,isFeatureable">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
	<cfreturn this />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
	<cfargument name="categoryBean" type="any" />
	 
	<cfquery>
	insert into tcontentcategories (categoryID,siteid,parentID,dateCreated,lastupdate,lastupdateBy,
	name,notes,isInterestGroup,isActive,isOpen,sortBy,sortDirection,restrictgroups,path,remoteID,remoteSourceURL,remotePubDate,urltitle,filename,isFeatureable)
	values (
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryBean.getCategoryID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getsiteID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getParentID() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getParentID()#">,
	<cfif isDate(arguments.categoryBean.getDateCreated()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.categoryBean.getDateCreated()#"><cfelse>null</cfif>,
	<cfif isDate(arguments.categoryBean.getLastUpdate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.categoryBean.getLastUpdate()#"><cfelse>null</cfif>,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getLastUpdateBy()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getName()#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.categoryBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getNotes()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" null="no" value="#iif(isNumeric(arguments.categoryBean.getIsInterestGroup()),de(arguments.categoryBean.getIsInterestGroup()),de(0))#">,
	<cfqueryparam cfsqltype="cf_sql_integer" null="no" value="#iif(isNumeric(arguments.categoryBean.getIsActive()),de(arguments.categoryBean.getIsActive()),de(0))#">,
	<cfqueryparam cfsqltype="cf_sql_integer" null="no" value="#iif(isNumeric(arguments.categoryBean.getIsOpen()),de(arguments.categoryBean.getIsOpen()),de(0))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSortBy() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getSortBy()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSortDirection() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getSortDirection()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getRestrictGroups() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRestrictGroups()#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.categoryBean.getPath() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getPath()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getRemoteID() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRemoteID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getRemoteSourceURL() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRemoteSourceURL()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" null="#iif(arguments.categoryBean.getRemotePubDate() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRemotePubDate()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getURLTitle() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getURLTitle()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getFilename() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getFilename()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" null="no" value="#iif(isNumeric(arguments.categoryBean.getIsFeatureable()),de(arguments.categoryBean.getIsFeatureable()),de(0))#">)
	</cfquery>

</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="categoryID" type="string" />
	<cfargument name="categoryBean" required="true" default=""/>
	<cfset var rsCategory ="" />
	<cfset var bean=arguments.categoryBean />
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("category")>
	</cfif>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCategory')#">
	Select 
	#variables.fieldlist#
	from tcontentcategories where 
	categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	</cfquery>
	
	<cfif rsCategory.recordcount>
	<cfset bean.set(rsCategory) />
	<cfset bean.setIsNew(0)>
	</cfif>
	
	<cfreturn bean />
</cffunction>

<cffunction name="readByName" access="public" output="false" returntype="any" >
	<cfargument name="name" type="string" />
	<cfargument name="siteID" type="string" />
	<cfargument name="categoryBean" required="true" default=""/>
	<cfset var rsCategory ="" />
	<cfset var beanArray=arrayNew(1)>
	<cfset var utility="">
	<cfset var bean=arguments.categoryBean />
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("category")>
	</cfif>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCategory')#">
	Select
	#variables.fieldlist#
	from tcontentcategories where 
	name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" />
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteID).getCategoryPoolID()#" />
	</cfquery>
	
	<cfif rsCategory.recordcount gt 1>
		<cfset utility=getBean("utility")>
		<cfloop query="rsCategory">
			<cfset bean=getBean("category").set(utility.queryRowToStruct(rsCategory,rsCategory.currentrow))>
			<cfset bean.setIsNew(0)>
			<cfset arrayAppend(beanArray,bean)>		
		</cfloop>
		<cfreturn beanArray>
	<cfelseif rsCategory.recordcount>
		<cfset bean.set(rsCategory) />
		<cfset bean.setIsNew(0)>
	<cfelse>
		<cfset bean.setSiteID(arguments.siteID)>
	</cfif>
	
	<cfreturn bean />
</cffunction>

<cffunction name="readByURLTitle" access="public" output="false" returntype="any" >
	<cfargument name="urlTitle" type="string" />
	<cfargument name="siteID" type="string" />
	<cfargument name="categoryBean" required="true" default=""/>
	<cfset var rsCategory ="" />
	<cfset var beanArray=arrayNew(1)>
	<cfset var utility="">
	<cfset var bean=arguments.categoryBean />
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("category")>
	</cfif>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCategory')#">
	Select
	#variables.fieldlist#
	from tcontentcategories where 
	urlTitle=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.urlTitle#" />
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteID).getCategoryPoolID()#" />
	</cfquery>
	
	<cfif rsCategory.recordcount gt 1>
		<cfset utility=getBean("utility")>
		<cfloop query="rsCategory">
			<cfset bean=getBean("category").set(utility.queryRowToStruct(rsCategory,rsCategory.currentrow))>
			<cfset bean.setIsNew(0)>
			<cfset arrayAppend(beanArray,bean)>		
		</cfloop>
		<cfreturn beanArray>
	<cfelseif rsCategory.recordcount>
		<cfset bean.set(rsCategory) />
		<cfset bean.setIsNew(0)>
	<cfelse>
		<cfset bean.setSiteID(arguments.siteID)>
	</cfif>
	
	<cfreturn bean />
</cffunction>

<cffunction name="readByFilename" access="public" output="false" returntype="any" >
	<cfargument name="filename" type="string" />
	<cfargument name="siteID" type="string" />
	<cfargument name="categoryBean" required="true" default=""/>
	<cfset var rsCategory ="" />
	<cfset var beanArray=arrayNew(1)>
	<cfset var utility="">
	<cfset var bean=arguments.categoryBean />
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("category")>
	</cfif>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCategory')#">
	Select
	#variables.fieldlist#
	from tcontentcategories where 
	filename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#" />
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteID).getCategoryPoolID()#" />
	</cfquery>
	
	<cfif rsCategory.recordcount gt 1>
		<cfset utility=getBean("utility")>
		<cfloop query="rsCategory">
			<cfset bean=getBean("category").set(utility.queryRowToStruct(rsCategory,rsCategory.currentrow))>
			<cfset bean.setIsNew(0)>
			<cfset arrayAppend(beanArray,bean)>		
		</cfloop>
		<cfreturn beanArray>
	<cfelseif rsCategory.recordcount>
		<cfset bean.set(rsCategory) />
		<cfset bean.setIsNew(0)>
	<cfelse>
		<cfset bean.setSiteID(arguments.siteID)>
	</cfif>
	
	<cfreturn bean />
</cffunction>

<cffunction name="readByRemoteID" access="public" output="false" returntype="any" >
	<cfargument name="remoteID" type="string" />
	<cfargument name="siteID" type="string" />
	<cfargument name="categoryBean" required="true" default=""/>
	<cfset var rsCategory ="" />
	<cfset var beanArray=arrayNew(1)>
	<cfset var utility="">
	<cfset var bean=arguments.categoryBean />
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("category")>
	</cfif>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCategory')#">
	Select
	#variables.fieldlist#
	from tcontentcategories where 
	remoteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remoteID#" />
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteID).getCategoryPoolID()#" />
	</cfquery>
	
	<cfif rsCategory.recordcount gt 1>
		<cfset utility=getBean("utility")>
		<cfloop query="rsCategory">
			<cfset bean=getBean("category").set(utility.queryRowToStruct(rsCategory,rsCategory.currentrow))>
			<cfset bean.setIsNew(0)>
			<cfset arrayAppend(beanArray,bean)>		
		</cfloop>
		<cfreturn beanArray>
	<cfelseif rsCategory.recordcount>
		<cfset bean.set(rsCategory) />
		<cfset bean.setIsNew(0)>
	<cfelse>
		<cfset bean.setSiteID(arguments.siteID)>
	</cfif>
	
	<cfreturn bean />
</cffunction>

<cffunction name="keepCategories" returntype="void" access="public" output="false">
	<cfargument name="contentHistID" type="string" default=""/>
	<cfargument name="rsKeepers" type="query"/>
			
	<cfloop query="arguments.rsKeepers">
		
		<cfset saveAssignment(arguments.contentHistID, rsKeepers.contentID, rsKeepers.categoryID, rsKeepers.siteID,
				rsKeepers.orderno, rsKeepers.isFeature, rsKeepers.featureStart, rsKeepers.featureStop)>
	</cfloop>

</cffunction>

<cffunction name="saveAssignment" returntype="void" access="public" output="false">
	<cfargument name="contentHistID" type="string" default=""/>
	<cfargument name="contentID" />
	<cfargument name="categoryID" />
	<cfargument name="siteID" />
	<cfargument name="orderNo" required="true" default="0"/>
	<cfargument name="isFeature"  required="true" default="0"/>	
	<cfargument name="featureStart"  required="true" default=""/>	
	<cfargument name="featureStop"  required="true" default=""/>		
	
		<cfquery>
		insert Into tcontentcategoryassign (categoryID,contentID,contentHistID,isFeature,orderno,siteid,
		featureStart,featureStop)
		values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#" />,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isFeature#" />,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.orderno#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />,
		<cfif arguments.isFeature eq 2 and isdate(arguments.featureStart)> <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.featurestart#"><cfelse>null</cfif>,
		<cfif arguments.isFeature eq 2 and isdate(arguments.featureStop)> <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.featureStop#"><cfelse>null</cfif>)
		</cfquery>
	

</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="categoryBean" type="any" />
	
	<cfquery>
	update tcontentcategories set
	lastUpdate = <cfif isDate(arguments.categoryBean.getLastUpdate()) ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.categoryBean.getLastUpdate()#"><cfelse>null</cfif>,
	lastupdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getLastUpdateBy()#">,
	name = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getName()#">,
	isActive = <cfqueryparam cfsqltype="cf_sql_integer" null="no" value="#iif(isNumeric(arguments.categoryBean.getIsActive()),de(arguments.categoryBean.getIsActive()),de(0))#">,
	isOpen = <cfqueryparam cfsqltype="cf_sql_integer" null="no" value="#iif(isNumeric(arguments.categoryBean.getIsOpen()),de(arguments.categoryBean.getIsOpen()),de(0))#">,
	parentID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getParentID() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getParentID()#">,
	isInterestGroup = <cfqueryparam cfsqltype="cf_sql_integer" null="no" value="#iif(isNumeric(arguments.categoryBean.getIsInterestGroup()),de(arguments.categoryBean.getIsInterestGroup()),de(0))#">,
	notes= <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.categoryBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getNotes()#">,
	sortBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSortBy() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getSortBy()#">,
	sortDirection = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSortDirection() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getSortDirection()#">,
	restrictGroups = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getRestrictGroups() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRestrictGroups()#">,
	path= <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.categoryBean.getPath() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getPath()#">,
	remoteID= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getRemoteID() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRemoteID()#">,
	remoteSourceURL= <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getRemoteSourceURL() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRemoteSourceURL()#">,
	remotePubDate=<cfqueryparam cfsqltype="cf_sql_timestamp" null="#iif(arguments.categoryBean.getRemotePubDate() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRemotePubDate()#">,
	urlTitle=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getURLTitle() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getURLTitle()#">,
	filename=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getFilename() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getFilename()#">,
	isFeatureable=<cfqueryparam cfsqltype="cf_sql_integer" null="no" value="#iif(isNumeric(arguments.categoryBean.getIsFeatureable()),de(arguments.categoryBean.getIsFeatureable()),de(0))#">
	where categoryID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryBean.getCategoryID()#" />
	</cfquery>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="categoryID" type="String" />
	
	<cfset var categoryBean=read(arguments.categoryID) />
	
	<cfquery>
	update tcontentcategories set 
	parentID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(categoryBean.getParentID() neq '',de('no'),de('yes'))#" value="#categoryBean.getParentID()#">
	where parentID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	</cfquery>
	
	<cfquery>
	delete from tcontentcategories 
	where categoryID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	</cfquery>
	
</cffunction>

<cffunction name="setListOrder" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="orderid" type="string" default=""/>
	<cfargument name="orderno" type="string" default=""/>
	<cfargument name="siteid" type="string" default=""/>
	
	<cfset var i=0 />

	<cfloop from="1" to="#listlen(arguments.orderid)#" index="i">
	<cfquery>
	update tcontentcategoryassign set 
	orderno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#listgetat(arguments.orderno,i)#" />
	where contentID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.orderid,i)#" />
	and categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	and siteid IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getContentPoolID()#" list="true">)
	</cfquery>
	</cfloop>

</cffunction>

<cffunction name="getCurrentOrderNo" returntype="numeric" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="contentID" type="string" default=""/>
	<cfargument name="siteID" type="string" default=""/>
	
	<cfset var rsCategoryCurrentOrderNo = ""/>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCategoryCurrentOrderNo')#">
	select distinct tcontentcategoryassign.orderno from tcontentcategoryassign  inner join tcontent
	ON (tcontentcategoryassign.contentid=tcontent.contentid
		and tcontentcategoryassign.siteid=tcontent.siteid)
	where tcontent.contentID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" /> and 		
	categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" /> 
	and tcontent.siteID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getContentPoolID()#" list="true">)
	and tcontent.active=1
	</cfquery>

	<cfif rsCategoryCurrentOrderNo.recordcount>
		<cfreturn rsCategoryCurrentOrderNo.orderno/>
	<cfelse>
		<cfreturn 0/>
	</cfif>
</cffunction>

<cffunction name="setAssignment" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="contentID" type="string" default=""/>
	<cfargument name="contentHistID" type="string" default=""/>
	<cfargument name="isFeature" type="numeric" default="0"/>
	<cfargument name="orderno" type="numeric" default="0"/>
	<cfargument name="siteID" type="string" default=""/>
	<cfargument name="schedule" type="struct" default="#structNew()#"/>
	
	<cfset var feature = arguments.isFeature />
	<cfset var sched = arguments.schedule />
	
	<cfif feature eq 2 AND isDate(sched.featureStart)>

		<cfif sched.startdaypart eq "PM">
			<cfset sched.starthour = sched.starthour + 12>
			
			<cfif sched.starthour eq 24>
				<cfset sched.starthour = 12>
			</cfif>
		<cfelseif sched.startdaypart eq "AM">
			<cfif sched.starthour eq 12>
				<cfset sched.starthour = 0>
			</cfif>
		</cfif>
		
		<cfset sched.featureStart = createDateTime(year(sched.featureStart), month(sched.featureStart), day(sched.featureStart),sched.starthour, sched.startMinute, "0")>
	<cfelseif feature eq 2>
		<cfset feature = 1 />
	</cfif>
	
	<cfif feature eq 2 AND isDate(sched.featurestop)>
		
		<cfif sched.stopdaypart eq "PM">
			<cfset sched.stophour = sched.stophour + 12>
			
			<cfif sched.stophour eq 24>
				<cfset sched.stophour = 12>
			</cfif>
		<cfelseif sched.stopdaypart eq "AM">
			<cfif sched.stophour eq 12>
				<cfset sched.stophour = 0>
			</cfif>
		</cfif>
		
		<cfset sched.featurestop = createDateTime(year(sched.featurestop), month(sched.featurestop), day(sched.featurestop),sched.stophour, sched.stopMinute, "0")>
	</cfif>

	<cfset saveAssignment(arguments.contentHistID, arguments.contentID, arguments.categoryID, arguments.siteID,
				arguments.orderno, feature, sched.featureStart, sched.featureStop)>

</cffunction>

<cffunction name="pushCategory" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="siteID" type="string" default=""/>
	
	<cfquery>
		update tcontentcategoryassign set orderno=OrderNo+1 where 
		categoryid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" /> 
		and siteid IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.settingsManager.getSite(arguments.siteid).getContentPoolID()#" list="true">)
	</cfquery>

</cffunction>

</cfcomponent>
