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
<cfcomponent extends="mura.bean.beanFeed" output="false">

<cfproperty name="feedID" type="string" default="" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="dateCreated" type="date" default=""/>
<cfproperty name="lastUpdate" type="date" default=""/>
<cfproperty name="lastUpdateBy" type="string" default=""/>
<cfproperty name="name" type="string" default=""/>
<cfproperty name="altName" type="string" default=""/>
<cfproperty name="lang" type="string" default="en-us" required="true" />
<cfproperty name="isActive" type="numeric" default="1" required="true" />
<cfproperty name="showNavOnly" type="numeric" default="1" required="true" />
<cfproperty name="showExcludeSearch" type="numeric" default="0" required="true" />
<cfproperty name="isPublic" type="numeric" default="0" required="true" />
<cfproperty name="isDefault" type="numeric" default="0" required="true" />
<cfproperty name="description" type="string" default=""/>
<cfproperty name="contentID" type="string" default=""/>
<cfproperty name="categoryID" type="string" default=""/>
<cfproperty name="maxItems" type="numeric" default="20" required="true" />
<cfproperty name="allowHTML" type="numeric" default="1" required="true" />
<cfproperty name="isFeaturesOnly" type="numeric" default="0" required="true" />
<cfproperty name="restricted" type="numeric" default="0" required="true" />
<cfproperty name="restrictGroups" type="string" default=""/>
<cfproperty name="version" type="string" default="RSS 2.0" required="true" />
<cfproperty name="channelLink" type="string" default=""/>
<cfproperty name="type" type="string" default="local" required="true" />
<cfproperty name="sortBy" type="string" default="lastUpdate" required="true" />
<cfproperty name="sortDirection" type="string" default="desc" required="true" />
<cfproperty name="parentID" type="string" default=""/>
<cfproperty name="nextN" type="numeric" default="20" required="true" />
<cfproperty name="displayName" type="numeric" default="0" required="true" />
<cfproperty name="displayRatings" type="numeric" default="0" required="true" />
<cfproperty name="displayComments" type="numeric" default="0" required="true" />
<cfproperty name="displayKids" type="numeric" default="0" required="true" />
<cfproperty name="isNew" type="numeric" default="0" required="true" />
<cfproperty name="params" type="query" default=""/>
<cfproperty name="remoteID" type="string" default=""/>
<cfproperty name="remoteSourceURL" type="string" default=""/>
<cfproperty name="remotePubDAte" type="string" default="" />
<cfproperty name="imageSize" type="string" default="small" required="true" />
<cfproperty name="imageHeight" type="string" default="AUTO" required="true" />
<cfproperty name="imageWidth" type="string" default="AUTO" required="true" />
<cfproperty name="displayList" type="string" default="Title,Date,Image,Summary,Tags,Credits" required="true" />
<cfproperty name="liveOnly" type="numeric" default="1" required="true" />
<cfproperty name="entityName" type="string" default="content" />
<cfproperty name="viewalllabel" type="string" default="" />
<cfproperty name="viewalllink" type="string" default="View All" />
<cfproperty name="autoimport" type="numeric" default="0" required="true" />
<cfproperty name="isLocked" type="numeric" default="0" required="true" />
<cfproperty name="cssClass" type="string" default="" />
<cfproperty name="useCategoryIntersect" type="numeric" default="0" />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.instance.feedID=""/>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.dateCreated="#now()#"/>
	<cfset variables.instance.lastUpdate="#now()#"/>
	<cfset variables.instance.lastUpdateBy=""/>
	<cfset variables.instance.name=""/>
	<cfset variables.instance.altName=""/>
	<cfset variables.instance.Lang="en-us"/>
	<cfset variables.instance.isActive=1 />
	<cfset variables.instance.showNavOnly=1 />
	<cfset variables.instance.showExcludeSearch=0 />
	<cfset variables.instance.isPublic=0 />
	<cfset variables.instance.isDefault=0 />
	<cfset variables.instance.description=""/>
	<cfset variables.instance.contentID=""/>
	<cfset variables.instance.categoryID=""/>
	<cfset variables.instance.MaxItems=20 />
	<cfset variables.instance.allowHTML=1 />
	<cfset variables.instance.isFeaturesOnly=0 />
	<cfset variables.instance.restricted=0 />
	<cfset variables.instance.restrictGroups="" />
	<cfset variables.instance.Version="RSS 2.0" />
	<cfset variables.instance.ChannelLink="" />
	<cfset variables.instance.type="local" />
	<cfset variables.instance.sortBy="lastUpdate" />
	<cfset variables.instance.sortDirection="desc" />
	<cfset variables.instance.parentID="" />
	<cfset variables.instance.nextN=20 />
	<cfset variables.instance.displayName=0 />
	<cfset variables.instance.displayRatings=0 />
	<cfset variables.instance.displayComments=0 />
	<cfset variables.instance.displaySummaries=1 />
	<cfset variables.instance.displayKids=0 />
	<cfset variables.instance.isNew=1 />
	<cfset variables.instance.params=queryNew("feedID,param,relationship,field,condition,criteria,dataType","varchar,integer,varchar,varchar,varchar,varchar,varchar" )  />
	<cfset variables.instance.errors=structnew() />
	<cfset variables.instance.remoteID = "" />
	<cfset variables.instance.remoteSourceURL = "" />
	<cfset variables.instance.remotePubDate = "">
	<cfset variables.instance.imageSize="small" />
	<cfset variables.instance.imageHeight="AUTO" />
	<cfset variables.instance.imageWidth="AUTO" />
	<cfset variables.instance.displayList="Date,Title,Image,Summary,Credits,Tags" />
	<cfset variables.instance.liveOnly=1 />
	<cfset variables.instance.activeOnly=1 />
	<cfset variables.instance.entityName="content" />
	<cfset variables.instance.table="tcontent">
	<cfset variables.instance.viewalllink="" />
	<cfset variables.instance.viewalllabel="" />
	<cfset variables.instance.autoimport=0 />
	<cfset variables.instance.isLocked=0 />
	<cfset variables.instance.cssClass="" />
	<cfset variables.instance.useCategoryIntersect=0 />

	<cfset variables.primaryKey = 'feedid'>
	<cfset variables.entityName = 'feed'>
	
	<cfreturn this />
</cffunction>

<cffunction name="setFeedManager">
	<cfargument name="feedManager">
	<cfset variables.feedManager=arguments.feedManager>
	<cfreturn this>
</cffunction>

<cffunction name="set" returnType="any" output="false" access="public">
	<cfargument name="feed" type="any" required="true">
	<cfset var prop=""/>
		
	<cfif isQuery(arguments.feed) and arguments.feed.recordcount>
		<cfloop list="#arguments.feed.columnlist#" index="prop">
			<cfset setValue(prop,arguments.feed[prop][1]) />
		</cfloop>
		
	<cfelseif isStruct(arguments.feed)>
		<cfloop collection="#arguments.feed#" item="prop">
			<cfset setValue(prop,arguments.feed[prop]) />
		</cfloop>
		
		<cfset setAdvancedParams(arguments.feed) />
	</cfif>
	
	<cfreturn this />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="dateCreated" type="String" />
	<cfset variables.instance.dateCreated = parseDateArg(arguments.dateCreated) />
	<cfreturn this>
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfset variables.instance.lastUpdate = parseDateArg(arguments.lastUpdate) />
	<cfreturn this>
</cffunction>

<cffunction name="setContentID" access="public" output="false">
	<cfargument name="contentID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
	<cfif not arguments.append>
		<cfset variables.instance.contentID = trim(arguments.contentID) />
	<cfelse>
		<cfloop list="#arguments.contentID#" index="i">
		<cfif not listFindNoCase(variables.instance.contentID,trim(i))>
	    	<cfset variables.instance.contentID = listAppend(variables.instance.contentID,trim(i)) />
	    </cfif> 
	    </cfloop>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="removeContentID" access="public" output="false">
	<cfargument name="contentID" type="String" />
	<cfset var i=0>
	<cfset var offset=0>
	
	<cfif len(arguments.contentID)>
		<cfloop from="1" to="#listLen(arguments.contentID)#" index="i">
		<cfif listFindNoCase(variables.instance.contentID,listGetAt(arguments.contentID,i))>
	    	<cfset variables.instance.contentID = listDeleteAt(variables.instance.contentID,i-offset) /> />
	    	<cfset offset=offset+1>
	    </cfif>
	    </cfloop> 
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="setCategoryID" access="public" output="false">
	<cfargument name="categoryID" type="String" />
	<cfargument name="append" type="boolean" default="false" required="true" />
	<cfset var i="">
	
	<cfif not arguments.append>
		<cfset variables.instance.categoryID = trim(arguments.categoryID) />
	<cfelse>
		<cfloop list="#arguments.categoryID#" index="i">
		<cfif not listFindNoCase(variables.instance.categoryID,trim(i))>
	    	<cfset variables.instance.categoryID = listAppend(variables.instance.categoryID,trim(i)) />
	    </cfif> 
	    </cfloop>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="removeCategoryID" access="public" output="false">
	<cfargument name="categoryID" type="String" />
	<cfset var i=0>
	<cfset var offset=0>
	
	<cfif len(arguments.categoryID)>
		<cfloop from="1" to="#listLen(arguments.categoryID)#" index="i">
		<cfif listFindNoCase(variables.instance.categoryID,listGetAt(arguments.categoryID,i))>
	    	<cfset variables.instance.categoryID = listDeleteAt(variables.instance.categoryID,i-offset) /> />
	    	<cfset offset=offset+1>
	    </cfif>
	    </cfloop> 
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="setDisplayName" access="public" output="false">
	<cfargument name="DisplayName" type="any" />
	<cfif isNumeric(arguments.DisplayName)>
	<cfset variables.instance.DisplayName = arguments.DisplayName />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setDisplayRatings" access="public" output="false">
	<cfargument name="DisplayRatings" type="any" />
	<cfif isNumeric(arguments.DisplayRatings)>
	<cfset variables.instance.DisplayRatings = arguments.DisplayRatings />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setDisplayComments" access="public" output="false">
	<cfargument name="DisplayComments" type="any" />
	<cfif isNumeric(arguments.DisplayComments)>
	<cfset variables.instance.DisplayComments = arguments.DisplayComments />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setDisplayKids" access="public" output="false">
	<cfargument name="DisplayKids" type="any" />
	<cfif isNumeric(arguments.DisplayKids)>
	<cfset variables.instance.displayKids = arguments.DisplayKids />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setShowNavOnly" access="public" output="false">
	<cfargument name="showNavOnly" type="any" />
	<cfif isNumeric(arguments.showNavOnly)>
	<cfset variables.instance.showNavOnly = arguments.showNavOnly />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setIsLocked" access="public" output="false">
	<cfargument name="isLocked" type="any" />
	<cfif isNumeric(arguments.isLocked)>
	<cfset variables.instance.isLocked = arguments.isLocked />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setUseCategoryIntersect" access="public" output="false">
	<cfargument name="useCategoryIntersect" type="any" />
	<cfif isNumeric(arguments.useCategoryIntersect)>
	<cfset variables.instance.useCategoryIntersect = arguments.useCategoryIntersect />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setShowExcludeSearch" access="public" output="false">
	<cfargument name="showExcludeSearch" type="any" />
	<cfif isNumeric(arguments.showExcludeSearch)>
	<cfset variables.instance.showExcludeSearch = arguments.showExcludeSearch />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setImageSize" output="false">
	<cfargument name="imageSize">
	<cfif len(arguments.imageSize)>
		<cfset variables.instance.imageSize = arguments.imageSize>
	</cfif>	
	<cfreturn this>
</cffunction>

<cffunction name="getImageSize" output="false" access="public">
	<cfif variables.instance.imageSize eq "Custom"
	and variables.instance.ImageHeight eq "AUTO" 
	and variables.instance.ImageWidth eq "AUTO">
  	  <cfreturn "small" />
	<cfelse>
		<cfreturn variables.instance.imageSize>
	</cfif>
</cffunction>

<cffunction name="setImageHeight" output="false" access="public">
    <cfargument name="ImageHeight" required="true">
	<cfif isNumeric(arguments.ImageHeight)>
  	  <cfset variables.instance.ImageHeight = arguments.ImageHeight />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getImageHeight" output="false" access="public">
	<cfif variables.instance.imageSize eq "Custom">
  	  <cfreturn variables.instance.ImageHeight />
	<cfelse>
		<cfreturn "AUTO">
	</cfif>
</cffunction>

<cffunction name="setImageWidth" output="false" access="public">
    <cfargument name="ImageWidth" required="true">
	<cfif isNumeric(arguments.ImageWidth)>
  	  <cfset variables.instance.ImageWidth = arguments.ImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setAutoImport" output="false" access="public">
    <cfargument name="autoimport" required="true">
	<cfif isNumeric(arguments.autoimport)>
  	  <cfset variables.instance.autoimport = arguments.autoimport />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getImageWidth" output="false" access="public">
	<cfif variables.instance.imageSize eq "Custom">
  	  <cfreturn variables.instance.ImageWidth />
	<cfelse>
		<cfreturn "AUTO">
	</cfif>
</cffunction>

<cffunction name="setParams" access="public" output="false">
	<cfargument name="params" type="any" required="true">
		
	<cfset var rows=0/>
	<cfset var I = 0 />


	<cfif isquery(arguments.params)>
		<cfset variables.instance.params=arguments.params />
			
	<cfelseif isdefined('arguments.params.param')>
	
		<cfset clearParams() />
		<cfloop from="1" to="#listLen(arguments.params.param)#" index="i">

			<cfset addParam(
					listFirst(arguments.params['paramField#i#'],'^'),
					arguments.params['paramRelationship#i#'],
					arguments.params['paramCriteria#i#'],
					arguments.params['paramCondition#i#'],
					listLast(arguments.params['paramField#i#'],'^')
					) />
		</cfloop>
			
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="setAdvancedParams" output="false">
	<cfargument name="params" type="any" required="true">
	<cfreturn setParams(argumentCollection=arguments)>
</cffunction>

<cffunction name="renderName" returntype="String" access="public" output="false">	
	<cfif len(variables.instance.altName)>
		<cfreturn variables.instance.altName />
	<cfelse>
		<cfreturn variables.instance.name />
	</cfif>
</cffunction>

<cffunction name="getQuery" returnType="query" output="false" access="public">
	<cfargument name="aggregation" required="true" default="false">
	<cfargument name="applyPermFilter" required="true" default="false">
	<cfargument name="countOnly" default="false">
	<cfreturn variables.feedManager.getFeed(feedBean=this,tag="",aggregation=arguments.aggregation,applyPermFilter=arguments.applyPermFilter, countOnly=arguments.countOnly) />
</cffunction>

<cffunction name="getIterator" returnType="any" output="false" access="public">
	<cfargument name="aggregation" required="true" default="false">
	<cfargument name="applyPermFilter" required="true" default="false">
	<cfset var q=getQuery(aggregation=arguments.aggregation,applyPermFilter=arguments.applyPermFilter) />
	<cfset var it=getBean("contentIterator")>
	<cfset it.setQuery(q,variables.instance.nextn)>
	<cfreturn it>
</cffunction>

<cffunction name="save" returnType="any" output="false" access="public">
	<cfset setAllValues(variables.feedManager.save(this).getAllValues())>
	<cfreturn this />
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.feedManager.delete(variables.instance.feedID) />
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>
	<cfset arguments.feedBean=this>
	
	<cfreturn variables.feedManager.read(argumentCollection=arguments)>
</cffunction>

<cffunction name="setRemotePubDate" output="false" access="public">
    <cfargument name="RemotePubDate" type="string" required="true">
	<cfif lsisDate(arguments.RemotePubDate)>
		<cftry>
		<cfset variables.instance.RemotePubDate = lsparseDateTime(arguments.RemotePubDate) />
		<cfcatch>
			<cfset variables.instance.RemotePubDate = arguments.RemotePubDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.RemotePubDate = ""/>
	</cfif>
	<cfreturn this>
  </cffunction>

<cffunction name="getEditUrl" access="public" returntype="string" output="false">
	<cfargument name="compactDisplay" type="any" required="true" default="false"/>
	<cfset var returnStr="">
	
	<cfset returnStr= "#variables.configBean.getContext()#/admin/?muraAction=cFeed.edit&feedID=#variables.instance.feedID#&siteid=#variables.instance.siteID#&type=#variables.instance.type#&compactDisplay=#arguments.compactdisplay#" >
	
	<cfreturn returnStr>
</cffunction> 

<cffunction name="getDisplayList" output="false">
	<cfset var hasRating=false>
	<cfset var hasComments=false>
	
	<cfif not len(variables.instance.displayList)>
		<cfset variables.instance.displayList="Date,Title,Image,Summary,Credits" />
		<cfset hasRating=listFindNoCase(variables.instance.displayList,"Rating")>
		<cfset hasComments=listFindNoCase(variables.instance.displayList,"Comments")>
		
		<cfif variables.instance.displayComments and not hasComments>
			<cfset variables.instance.displayList=listAppend(variables.instance.displayList,"Comments")>
		<cfelseif not variables.instance.displayComments and hasComments>
			<cfset variables.instance.displayList=listDeleteAt(variables.instance.displayList,hasComments)>
		</cfif>
		
		<cfset variables.instance.displayList=listAppend(variables.instance.displayList,"Tags")>
		
		<cfif variables.instance.displayRatings and not hasRating>
			<cfset variables.instance.displayList=listAppend(variables.instance.displayList,"Rating")>
		<cfelseif not variables.instance.displayRatings and hasRating>
			<cfset variables.instance.displayList=listDeleteAt(variables.instance.displayList,hasRating)>
		</cfif>		
	</cfif>
		
	<cfreturn variables.instance.displayList>
</cffunction>

<cffunction name="getAvailableDisplayList" output="false">
	<cfset var returnList="Date,Title,Image,Summary,Body,ReadMore,Credits,Comments,Tags,Rating">
	<cfset var i=0>
	<cfset var finder=0>
	<cfset var rsExtend=variables.configBean.getClassExtensionManager().getExtendedAttributeList(variables.instance.siteid,"tcontent")>
	
	<cfif rsExtend.recordcount>
		<cfquery name="rsExtend" dbType="query">
			select attribute from rsExtend 
			group by attribute
			order by attribute
		</cfquery>
		<cfset returnList=returnList & "," & valueList(rsExtend.attribute)>
	</cfif>
	
	<cfloop list="#variables.instance.displayList#" index="i">
		<cfset finder=listFindNoCase(returnList,i)>
		<cfif finder>
			<cfset returnList=listDeleteAt(returnList,finder)>
		</cfif>
	</cfloop>
	<cfreturn returnList>
</cffunction>

<cffunction name="getPrimaryKey" output="false">
	<cfreturn "feedID">
</cffunction>

<cffunction name="getAvailableCount" output="false">
	<cfreturn getQuery(countOnly=true).count>
</cffunction>
	
</cfcomponent>