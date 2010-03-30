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

<cfset variables.instance.feedID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.dateCreated="#now()#"/>
<cfset variables.instance.lastUpdate="#now()#"/>
<cfset variables.instance.lastUpdateBy=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.altName=""/>
<cfset variables.instance.Lang="en-us"/>
<cfset variables.instance.isActive=1 />
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
<cfset variables.instance.displayKids=0 />
<cfset variables.instance.isNew=1 />
<cfset variables.instance.advancedParams=queryNew("feedID,param,relationship,field,condition,criteria,dataType","varchar,integer,varchar,varchar,varchar,varchar,varchar" )  />
<cfset variables.instance.errors=structnew() />
<cfset variables.instance.remoteID = "" />
<cfset variables.instance.remoteSourceURL = "" />
<cfset variables.instance.remotePubDate = "">
<cfset variables.feedManager = "" />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="any" output="false" access="public">
		<cfargument name="feed" type="any" required="true">
		<cfset var prop = "" />
		
		<cfif isquery(arguments.feed)>
		
			<cfset setFeedID(arguments.feed.feedID) />
			<cfset setsiteID(arguments.feed.siteID) />
			<cfset setdateCreated(arguments.feed.dateCreated) />
			<cfset setlastUpdate(arguments.feed.lastUpdate) />
			<cfset setlastUpdateby(arguments.feed.lastUpdateBy) />
			<cfset setname(arguments.feed.name) />
			<cfset setAltName(arguments.feed.altName) />
			<cfset setLang(arguments.feed.Lang) />
			<cfset setisActive(arguments.feed.isActive)/>
			<cfset setisPublic(arguments.feed.isPublic)/>
			<cfset setisDefault(arguments.feed.isDefault)/>
			<cfset setDescription(arguments.feed.description) />
			<cfset setMaxItems(arguments.feed.maxItems) />
			<cfset setAllowHTML(arguments.feed.allowHTML) />
			<cfset setIsFeaturesOnly(arguments.feed.isFeaturesOnly) />
			<cfset setRestricted(arguments.feed.Restricted) />
			<cfset setRestrictGroups(arguments.feed.RestrictGroups) />
			<cfset setVersion(arguments.feed.Version) />
			<cfset setChannelLink(arguments.feed.ChannelLink) />
			<cfset setType(arguments.feed.Type) />
			<cfset setSortBy(arguments.feed.sortBy) />
			<cfset setSortDirection(arguments.feed.sortDirection) />
			<cfset setNextN(arguments.feed.nextN) />
			<cfset setDisplayName(arguments.feed.displayName) />
			<cfset setDisplayRatings(arguments.feed.displayRatings) />
			<cfset setDisplayComments(arguments.feed.displayComments) />
			<cfset setParentID(arguments.feed.parentID) />
			<cfset setRemoteID(arguments.feed.remoteID) />
			<cfset setRemoteSourceURL(arguments.feed.remoteSourceURL) />
			<cfset setRemotePubDate(arguments.feed.remotePubDate) />
		
		<cfelseif isStruct(arguments.feed)>
		
			<cfloop collection="#arguments.feed#" item="prop">
				<cfif structKeyExists(this,"set#prop#")>
				<cfset evaluate("set#prop#(arguments.feed[prop])") />
			</cfif>
			</cfloop>
			
			<cfset setAdvancedParams(arguments.feed) />
			
		</cfif>
		
		<cfset validate() />	
		<cfreturn this />
</cffunction>

<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getFeedID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.feedID />
</cffunction>

<cffunction name="setFeedID" access="public" output="false">
	<cfargument name="feedID" type="String" />
	<cfset variables.instance.feedID = trim(arguments.feedID) />
	<cfreturn this>
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getDateCreated" returntype="String" access="public" output="false">
	<cfreturn variables.instance.dateCreated />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="dateCreated" type="String" />
	<cfif isDate(arguments.dateCreated)>
	<cfset variables.instance.dateCreated = parseDateTime(arguments.dateCreated) />
	<cfelse>
	<cfset variables.instance.dateCreated = ""/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getLastUpdate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdate />
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	<cfelse>
	<cfset variables.instance.lastUpdate = ""/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getlastUpdateBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdateBy />
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
	<cfreturn this>
</cffunction>

<cffunction name="getAltName" returntype="String" access="public" output="false">	
	<cfreturn variables.instance.altName />
</cffunction>

<cffunction name="setAltName" access="public" output="false">
	<cfargument name="altName" type="String" />
	<cfset variables.instance.altName = trim(arguments.altName) />
	<cfreturn this>
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="isActive" type="numeric" />
	<cfset variables.instance.isActive = arguments.isActive />
	<cfreturn this>
</cffunction>

<cffunction name="getIsPublic" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isPublic />
</cffunction>

<cffunction name="setIsPublic" access="public" output="false">
	<cfargument name="isPublic" type="numeric" />
	<cfset variables.instance.isPublic = arguments.isPublic />
	<cfreturn this>
</cffunction>

<cffunction name="getIsDefault" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isDefault />
</cffunction>

<cffunction name="setIsDefault" access="public" output="false">
	<cfargument name="isDefault" type="numeric" />
	<cfset variables.instance.isDefault = arguments.isDefault />
	<cfreturn this>
</cffunction>

<cffunction name="getDescription" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Description />
</cffunction>

<cffunction name="setDescription" access="public" output="false">
	<cfargument name="Description" type="String" />
	<cfset variables.instance.Description = trim(arguments.Description) />
	<cfreturn this>
</cffunction>

<cffunction name="getLang" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Lang />
</cffunction>

<cffunction name="setLang" access="public" output="false">
	<cfargument name="Lang" type="String" />
	<cfset variables.instance.Lang = trim(arguments.Lang) />
	<cfreturn this>
</cffunction>

<cffunction name="getcontentID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.contentID />
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

<cffunction name="getCategoryID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.categoryID />
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

<cffunction name="getMaxItems" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.MaxItems />
</cffunction>

<cffunction name="setMaxItems" access="public" output="false">
	<cfargument name="MaxItems" type="numeric" />
	<cfset variables.instance.MaxItems = arguments.MaxItems />
	<cfreturn this>
</cffunction>

<cffunction name="getAllowHTML" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.AllowHTML />
</cffunction>

<cffunction name="setAllowHTML" access="public" output="false">
	<cfargument name="AllowHTML" type="numeric" />
	<cfset variables.instance.AllowHTML = arguments.AllowHTML />
	<cfreturn this>
</cffunction>

<cffunction name="getIsFeaturesOnly" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.IsFeaturesOnly />
</cffunction>

<cffunction name="setIsFeaturesOnly" access="public" output="false">
	<cfargument name="IsFeaturesOnly" type="numeric" />
	<cfset variables.instance.IsFeaturesOnly = arguments.IsFeaturesOnly />
	<cfreturn this>
</cffunction>

<cffunction name="getRestricted" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.Restricted />
</cffunction>

<cffunction name="setRestricted" access="public" output="false">
	<cfargument name="Restricted" type="numeric" />
	<cfset variables.instance.Restricted = arguments.Restricted />
	<cfreturn this>
</cffunction>

<cffunction name="setRestrictGroups" access="public" output="false">
	<cfargument name="RestrictGroups" type="string" />
	<cfset variables.instance.RestrictGroups = trim(arguments.RestrictGroups) />
	<cfreturn this>
</cffunction>

<cffunction name="getRestrictGroups" returntype="String" access="public" output="false">
	<cfreturn variables.instance.RestrictGroups />
</cffunction>

<cffunction name="setVersion" access="public" output="false">
	<cfargument name="Version" type="String" />
	<cfset variables.instance.Version = trim(arguments.Version) />
	<cfreturn this>
</cffunction>

<cffunction name="getVersion" access="public" output="false" returntype="String">
	<cfreturn variables.instance.Version />
</cffunction>

<cffunction name="setChannelLink" access="public" output="false">
	<cfargument name="ChannelLink" type="String" />
	<cfset variables.instance.ChannelLink = trim(arguments.ChannelLink) />
	<cfreturn this>
</cffunction>

<cffunction name="getChannelLink" access="public" output="false" returntype="String">
	<cfreturn variables.instance.ChannelLink />
</cffunction>

<cffunction name="setType" access="public" output="false">
	<cfargument name="Type" type="String" />
	<cfset variables.instance.Type = trim(arguments.Type) />
	<cfreturn this>
</cffunction>

<cffunction name="getType" access="public" output="false" returntype="String">
	<cfreturn variables.instance.Type />
</cffunction>

<cffunction name="getParentID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ParentID />
</cffunction>

<cffunction name="setParentID" access="public" output="false">
	<cfargument name="ParentID" type="String" />
	<cfset variables.instance.ParentID = trim(arguments.ParentID) />
	<cfreturn this>
</cffunction>

<cffunction name="getSortBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.sortBy />
</cffunction>

<cffunction name="setSortBy" access="public" output="false">
	<cfargument name="sortBy" type="String" />
	<cfset variables.instance.sortBy = trim(arguments.sortBy) />
	<cfreturn this>
</cffunction>

<cffunction name="getSortDirection" returntype="String" access="public" output="false">
	<cfreturn variables.instance.sortDirection />
</cffunction>

<cffunction name="setSortDirection" access="public" output="false">
	<cfargument name="sortDirection" type="String" />
	<cfset variables.instance.sortDirection = trim(arguments.sortDirection) />
	<cfreturn this>
</cffunction>

<cffunction name="getNextN" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.NextN />
</cffunction>

<cffunction name="setNextN" access="public" output="false">
	<cfargument name="NextN" type="any" />
	<cfif isNumeric(arguments.nextN)>
	<cfset variables.instance.NextN = arguments.NextN />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDisplayName" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.displayName />
</cffunction>

<cffunction name="setDisplayName" access="public" output="false">
	<cfargument name="DisplayName" type="any" />
	<cfif isNumeric(arguments.DisplayName)>
	<cfset variables.instance.DisplayName = arguments.DisplayName />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDisplayRatings" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.displayRatings />
</cffunction>

<cffunction name="setDisplayRatings" access="public" output="false">
	<cfargument name="DisplayRatings" type="any" />
	<cfif isNumeric(arguments.DisplayRatings)>
	<cfset variables.instance.DisplayRatings = arguments.DisplayRatings />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDisplayComments" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.displayComments />
</cffunction>

<cffunction name="setDisplayComments" access="public" output="false">
	<cfargument name="DisplayComments" type="any" />
	<cfif isNumeric(arguments.DisplayComments)>
	<cfset variables.instance.DisplayComments = arguments.DisplayComments />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getDisplayKids" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.displayKids />
</cffunction>

<cffunction name="setDisplayKids" access="public" output="false">
	<cfargument name="DisplayKids" type="any" />
	<cfif isNumeric(arguments.DisplayKids)>
	<cfset variables.instance.displayKids = arguments.DisplayKids />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getAdvancedParams" returntype="query" access="public" output="false">
	<cfreturn variables.instance.advancedParams />
</cffunction>

<cffunction name="setAdvancedParams" access="public" output="false">
	<cfargument name="params" type="any" required="true">
		
		<cfset var rows=0/>
		<cfset var I = 0 />
		
		<cfif isquery(arguments.params)>
			
			<cfset variables.instance.advancedParams=arguments.params />
			
		<cfelseif isdefined('arguments.params.param')>
		
			<cfset clearAdvancedParams() />
			<cfloop from="1" to="#listLen(arguments.params.param)#" index="i">
				
				<cfset addAdvancedParam(
						listFirst(evaluate('arguments.params.paramField#i#'),'^'),
						evaluate('arguments.params.paramRelationship#i#'),
						evaluate('arguments.params.paramCriteria#i#'),
						evaluate('arguments.params.paramCondition#i#'),
						listLast(evaluate('arguments.params.paramField#i#'),'^')
						) />
	
			</cfloop>
			
		</cfif>
	<cfreturn this>
</cffunction>


<cffunction name="addAdvancedParam" access="public" output="false">
	<cfargument name="field" type="string" required="true" default="">
	<cfargument name="relationship" type="string" default="and" required="true">
	<cfargument name="criteria" type="string" required="true" default="">
	<cfargument name="condition" type="string" default="EQUALS" required="true">
	<cfargument name="datatype" type="string"  default="varchar" required="true">
		<cfset var rows=1/>
		
		<cfset queryAddRow(variables.instance.advancedParams,1)/>
		<cfset rows = variables.instance.advancedParams.recordcount />
		<cfset querysetcell(variables.instance.advancedParams,"feedid",getFeedID(),rows)/>
		<cfset querysetcell(variables.instance.advancedParams,"param",rows,rows)/>
		<cfset querysetcell(variables.instance.advancedParams,"field",arguments.field,rows)/>
		<cfset querysetcell(variables.instance.advancedParams,"relationship",arguments.relationship,rows)/>
		<cfset querysetcell(variables.instance.advancedParams,"criteria",arguments.criteria,rows)/>
		<cfset querysetcell(variables.instance.advancedParams,"condition",arguments.condition,rows)/>
		<cfset querysetcell(variables.instance.advancedParams,"dataType",arguments.datatype,rows)/>
		<cfreturn this>
</cffunction>

<cffunction name="addParam" access="public" output="false" hint="This is the same as addAdvancedParam.">
	<cfargument name="field" type="string" required="true" default="">
	<cfargument name="relationship" type="string" default="and" required="true">
	<cfargument name="criteria" type="string" required="true" default="">
	<cfargument name="condition" type="string" default="EQUALS" required="true">
	<cfargument name="datatype" type="string"  default="varchar" required="true">
		<cfset addAdvancedParam(argumentcollection=arguments)>
		<cfreturn this>
</cffunction>


<cffunction name="clearAdvancedParams" output="false">
	<cfset variables.instance.advancedParams=queryNew("feedID,param,relationship,field,condition,criteria,dataType","varchar,integer,varchar,varchar,varchar,varchar,varchar" )  />
	<cfreturn this>
</cffunction>

<cffunction name="renderName" returntype="String" access="public" output="false">	
	<cfif len(variables.instance.altName)>
		<cfreturn variables.instance.altName />
	<cfelse>
		<cfreturn variables.instance.name />
	</cfif>
</cffunction>

<cffunction name="setFeedManager" access="public" output="false">
	<cfargument name="feedManager" type="any" />
	<cfset variables.feedManager = arguments.feedManager />
	<cfreturn this>
</cffunction>

<cffunction name="getQuery" returnType="query" output="false" access="public">
	<cfreturn variables.feedManager.getFeed(this) />
</cffunction>

<cffunction name="getIterator" returnType="any" output="false" access="public">
	<cfset var q=getQuery() />
	<cfset var it=getServiceFactory().getBean("contentIterator")>
	<cfset it.setQuery(q,getNextN())>
	<cfreturn it>
</cffunction>

<cffunction name="save" returnType="any" output="false" access="public">
	<cfset setAllValues(variables.feedManager.save(this).getAllValues())>
	<cfreturn this />
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.feedManager.delete(getFeedID()) />
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfreturn this>
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
	<cfreturn variables.instance/>
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >

	<cfset variables.intance["#arguments.property#"]=arguments.propertyValue />
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
	
	<cfif structKeyExists(variables,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=getSiteID()>
	</cfif>
	<cfset setAllValues(variables.feedManager.read(argumentCollection=arguments).getAllValues())>
	<cfreturn this />
</cffunction>

<cffunction name="setIsNew" output="false" access="public">
    <cfargument name="IsNew" type="numeric" required="true">
    <cfset variables.instance.IsNew = arguments.IsNew />
	<cfreturn this>
</cffunction>

<cffunction name="getIsNew" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsNew />
</cffunction>

<cffunction name="setRemoteID" output="false" access="public">
    <cfargument name="RemoteID" type="string" required="true">
    <cfset variables.instance.RemoteID = trim(arguments.RemoteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getRemoteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteID />
</cffunction>
  
<cffunction name="setRemoteSourceURL" output="false" access="public">
    <cfargument name="remoteSourceURL" type="string" required="true">
    <cfset variables.instance.remoteSourceURL = trim(arguments.remoteSourceURL) />
	<cfreturn this>
</cffunction>

<cffunction name="getRemoteSourceURL" returnType="string" output="false" access="public">
    <cfreturn variables.instance.remoteSourceURL />
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

<cffunction name="getRemotePubDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemotePubDate />
</cffunction>
</cfcomponent>