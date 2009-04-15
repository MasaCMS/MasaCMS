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
<cfset variables.instance.isPublic=1 />
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
<cfset variables.instance.type="" />
<cfset variables.instance.sortBy="lastUpdate" />
<cfset variables.instance.sortDirection="desc" />
<cfset variables.instance.parentID="" />
<cfset variables.instance.nextN=20 />
<cfset variables.instance.displayName=0 />
<cfset variables.instance.displayRatings=0 />
<cfset variables.instance.displayComments=0 />
<cfset variables.instance.displayKids=0 />
<cfset variables.instance.advancedParams=queryNew("feedID,param,relationship,field,condition,criteria,dataType","varchar,integer,varchar,varchar,varchar,varchar,varchar" )  />
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
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
		
		<cfelseif isStruct(arguments.feed)>
		
			<cfloop collection="#arguments.feed#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.feed[prop])") />
				</cfif>
			</cfloop>
			
			<cfset setAdvancedParams(arguments.feed) />
			
		</cfif>
		
		<cfset validate() />
		
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
</cffunction>

<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset variables.instance.errors=structnew() />
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
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
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
</cffunction>

<cffunction name="getlastUpdateBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdateBy />
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
</cffunction>

<cffunction name="getAltName" returntype="String" access="public" output="false">	
	<cfreturn variables.instance.altName />
</cffunction>

<cffunction name="setAltName" access="public" output="false">
	<cfargument name="altName" type="String" />
	<cfset variables.instance.altName = trim(arguments.altName) />
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="isActive" type="numeric" />
	<cfset variables.instance.isActive = arguments.isActive />
</cffunction>

<cffunction name="getIsPublic" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isPublic />
</cffunction>

<cffunction name="setIsPublic" access="public" output="false">
	<cfargument name="isPublic" type="numeric" />
	<cfset variables.instance.isPublic = arguments.isPublic />
</cffunction>

<cffunction name="getIsDefault" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isDefault />
</cffunction>

<cffunction name="setIsDefault" access="public" output="false">
	<cfargument name="isDefault" type="numeric" />
	<cfset variables.instance.isDefault = arguments.isDefault />
</cffunction>

<cffunction name="getDescription" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Description />
</cffunction>

<cffunction name="setDescription" access="public" output="false">
	<cfargument name="Description" type="String" />
	<cfset variables.instance.Description = trim(arguments.Description) />
</cffunction>

<cffunction name="getLang" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Lang />
</cffunction>

<cffunction name="setLang" access="public" output="false">
	<cfargument name="Lang" type="String" />
	<cfset variables.instance.Lang = trim(arguments.Lang) />
</cffunction>

<cffunction name="getcontentID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.contentID />
</cffunction>

<cffunction name="setcontentID" access="public" output="false">
	<cfargument name="contentID" type="String" />
	<cfset variables.instance.contentID = trim(arguments.contentID) />
</cffunction>

<cffunction name="getCategoryID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.categoryID />
</cffunction>

<cffunction name="setCategoryID" access="public" output="false">
	<cfargument name="categoryID" type="String" />
	<cfset variables.instance.categoryID = trim(arguments.categoryID) />
</cffunction>

<cffunction name="getMaxItems" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.MaxItems />
</cffunction>

<cffunction name="setMaxItems" access="public" output="false">
	<cfargument name="MaxItems" type="numeric" />
	<cfset variables.instance.MaxItems = arguments.MaxItems />
</cffunction>

<cffunction name="getAllowHTML" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.AllowHTML />
</cffunction>

<cffunction name="setAllowHTML" access="public" output="false">
	<cfargument name="AllowHTML" type="numeric" />
	<cfset variables.instance.AllowHTML = arguments.AllowHTML />
</cffunction>

<cffunction name="getIsFeaturesOnly" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.IsFeaturesOnly />
</cffunction>

<cffunction name="setIsFeaturesOnly" access="public" output="false">
	<cfargument name="IsFeaturesOnly" type="numeric" />
	<cfset variables.instance.IsFeaturesOnly = arguments.IsFeaturesOnly />
</cffunction>

<cffunction name="getRestricted" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.Restricted />
</cffunction>

<cffunction name="setRestricted" access="public" output="false">
	<cfargument name="Restricted" type="numeric" />
	<cfset variables.instance.Restricted = arguments.Restricted />
</cffunction>

<cffunction name="setRestrictGroups" access="public" output="false">
	<cfargument name="RestrictGroups" type="string" />
	<cfset variables.instance.RestrictGroups = trim(arguments.RestrictGroups) />
</cffunction>

<cffunction name="getRestrictGroups" returntype="String" access="public" output="false">
	<cfreturn variables.instance.RestrictGroups />
</cffunction>

<cffunction name="setVersion" access="public" output="false">
	<cfargument name="Version" type="String" />
	<cfset variables.instance.Version = trim(arguments.Version) />
</cffunction>

<cffunction name="getVersion" access="public" output="false" returntype="String">
	<cfreturn variables.instance.Version />
</cffunction>

<cffunction name="setChannelLink" access="public" output="false">
	<cfargument name="ChannelLink" type="String" />
	<cfset variables.instance.ChannelLink = trim(arguments.ChannelLink) />
</cffunction>

<cffunction name="getChannelLink" access="public" output="false" returntype="String">
	<cfreturn variables.instance.ChannelLink />
</cffunction>

<cffunction name="setType" access="public" output="false">
	<cfargument name="Type" type="String" />
	<cfset variables.instance.Type = trim(arguments.Type) />
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
</cffunction>

<cffunction name="getSortBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.sortBy />
</cffunction>

<cffunction name="setSortBy" access="public" output="false">
	<cfargument name="sortBy" type="String" />
	<cfset variables.instance.sortBy = trim(arguments.sortBy) />
</cffunction>

<cffunction name="getSortDirection" returntype="String" access="public" output="false">
	<cfreturn variables.instance.sortDirection />
</cffunction>

<cffunction name="setSortDirection" access="public" output="false">
	<cfargument name="sortDirection" type="String" />
	<cfset variables.instance.sortDirection = trim(arguments.sortDirection) />
</cffunction>

<cffunction name="getNextN" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.NextN />
</cffunction>

<cffunction name="setNextN" access="public" output="false">
	<cfargument name="NextN" type="any" />
	<cfif isNumeric(arguments.nextN)>
	<cfset variables.instance.NextN = arguments.NextN />
	</cfif>
</cffunction>

<cffunction name="getDisplayName" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.displayName />
</cffunction>

<cffunction name="setDisplayName" access="public" output="false">
	<cfargument name="DisplayName" type="any" />
	<cfif isNumeric(arguments.DisplayName)>
	<cfset variables.instance.DisplayName = arguments.DisplayName />
	</cfif>
</cffunction>

<cffunction name="getDisplayRatings" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.displayRatings />
</cffunction>

<cffunction name="setDisplayRatings" access="public" output="false">
	<cfargument name="DisplayRatings" type="any" />
	<cfif isNumeric(arguments.DisplayRatings)>
	<cfset variables.instance.DisplayRatings = arguments.DisplayRatings />
	</cfif>
</cffunction>

<cffunction name="getDisplayComments" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.displayComments />
</cffunction>

<cffunction name="setDisplayComments" access="public" output="false">
	<cfargument name="DisplayComments" type="any" />
	<cfif isNumeric(arguments.DisplayComments)>
	<cfset variables.instance.DisplayComments = arguments.DisplayComments />
	</cfif>
</cffunction>

<cffunction name="getDisplayKids" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.displayKids />
</cffunction>

<cffunction name="setDisplayKids" access="public" output="false">
	<cfargument name="DisplayKids" type="any" />
	<cfif isNumeric(arguments.DisplayKids)>
	<cfset variables.instance.displayKids = arguments.DisplayKids />
	</cfif>
</cffunction>

<cffunction name="getAdvancedParams" returntype="query" access="public" output="false">
	<cfreturn variables.instance.advancedParams />
</cffunction>

<cffunction name="setAdvancedParams" returntype="void" access="public" output="false">
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
</cffunction>


<cffunction name="addAdvancedParam" returntype="void" access="public" output="false">
	<cfargument name="field" type="string" required="true">
	<cfargument name="relationship" type="string" default="and" required="true">
	<cfargument name="criteria" type="string" required="true">
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

</cffunction>


<cffunction name="clearAdvancedParams">
	<cfset variables.instance.advancedParams=queryNew("feedID,param,relationship,field,condition,criteria,dataType","varchar,integer,varchar,varchar,varchar,varchar,varchar" )  />
</cffunction>

<cffunction name="renderName" returntype="String" access="public" output="false">	
	<cfif len(variables.instance.altName)>
		<cfreturn variables.instance.altName />
	<cfelse>
		<cfreturn variables.instance.name />
	</cfif>
</cffunction>
</cfcomponent>