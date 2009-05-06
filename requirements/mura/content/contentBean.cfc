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
<cfset variables.instance = structNew() />
<cfset variables.instance.ContentHistID = "" />
<cfset variables.instance.Contentid = "" />
<cfset variables.instance.Active = 0 />
<cfset variables.instance.OrderNo = 1 />
<cfset variables.instance.MetaDesc = "" />
<cfset variables.instance.MetaKeyWords = "" />
<cfset variables.instance.Approved = 0 />
<cfset variables.instance.DisplayStart = "" />
<cfset variables.instance.Displaystop = "">
<cfset variables.instance.Body = "" />
<cfset variables.instance.Title = "" />
<cfset variables.instance.MenuTitle = "" />
<cfset variables.instance.Filename = "" />
<cfset variables.instance.OldFilename = "" />
<cfset variables.instance.LastUpdate = now() />
<cfset variables.instance.Display = 1 />
<cfset variables.instance.ParentID = "" />
<cfset variables.instance.Type = "" />
<cfset variables.instance.subType = "Default" />

<cftry>
	<cfset variables.instance.LastUpdateBy = left(listGetAt(getAuthUser(),"2","^"),50) />
	<cfset variables.instance.LastUpdateByID = listFirst(getAuthUser(),"^") />
	<cfcatch>
		<cfset variables.instance.LastUpdateBy = "" />
		<cfset variables.instance.LastUpdateByID = "" />
	</cfcatch>
</cftry>


<cfset variables.instance.Summary = "" />
<cfset variables.instance.SiteID = "" />
<cfset variables.instance.ModuleID = "00000000000000000000000000000000000" />
<cfset variables.instance.IsNav = 1 />
<cfset variables.instance.Restricted = 0 />
<cfset variables.instance.Target = "_self" />
<cfset variables.instance.RestrictGroups = "RestrictAll" />
<cfset variables.instance.Template = "" />
<cfset variables.instance.ResponseMessage = "" />
<cfset variables.instance.ResponseChart = 0 />
<cfset variables.instance.ResponseSendTo = "" />
<cfset variables.instance.ResponseDisplayFields = "" />
<cfset variables.instance.ModuleAssign = "" />
<cfset variables.instance.notes = "" />
<cfset variables.instance.inheritObjects = "Inherit" />
<cfset variables.instance.isFeature = 0 />
<cfset variables.instance.isNew = 0 />
<cfset variables.instance.releaseDate = "" />
<cfset variables.instance.targetParams = "" />
<cfset variables.instance.IsLocked = 0 />
<cfset variables.instance.nextN = 10 />
<cfset variables.instance.sortBy = "orderno" />
<cfset variables.instance.sortDirection = "asc" />
<cfset variables.instance.FeatureStart = "" />
<cfset variables.instance.FeatureStop = "">
<cfset variables.instance.FileID = "">
<cfset variables.instance.FileSize = 0>
<cfset variables.instance.FileExt = "">
<cfset variables.instance.ContentType = "">
<cfset variables.instance.ContentSubType = "">
<cfset variables.instance.forceSSL = 0>
<cfset variables.instance.remoteURL = "">
<cfset variables.instance.remoteID = "">
<cfset variables.instance.remotePubDate = "">
<cfset variables.instance.remoteSource = "">
<cfset variables.instance.remoteSourceURL = "">
<cfset variables.instance.credits = "">
<cfset variables.instance.audience = "">
<cfset variables.instance.keyPoints = "">
<cfset variables.instance.searchExclude = 0>
<cfset variables.instance.displayTitle = 1>
<cfset variables.instance.Path = "">
<cfset variables.instance.tags = "">
<cfset variables.instance.extendData="" />
<cfset variables.instance.doCache = 1 />
<cfset variables.instance.created = now() />

<cffunction name="init" access="public" returntype="any" output="false">
	<cfargument name="configBean" required="true" default=""/>
	<cfset variables.configBean=arguments.configBean />
	<cfreturn this />
</cffunction>

 <cffunction name="set" returnType="void" output="false" access="public">
    <cfargument name="content" type="any" required="true">
	
	<cfset var starthour = 0 />
	<cfset var stophour = 0 />
	<cfset var pageNum = 2 />
	<cfset var featurestophour="" />
	<cfset var featurestarthour="" />
	<cfset var prop="" />
	
	<cfif isQuery(arguments.content)>
		<cfset setcontentHistID(arguments.Content.ContentHistID) />
		<cfset setcontentid(arguments.Content.Contentid) />
		<cfset setActive(arguments.Content.Active) />
		<cfset setOrderNo(arguments.Content.OrderNo) />
		<cfset setMetaDesc(arguments.Content.MetaDesc) />
		<cfset setMetaKeyWords(arguments.Content.MetaKeyWords) />
		<cfset setApproved(arguments.Content.Approved) />
		<cfset setDisplayStart(arguments.Content.DisplayStart) />
		<cfset setDisplaystop(arguments.Content.Displaystop) />
		<cfset setBody(arguments.Content.Body) />
		<cfset setTitle(arguments.Content.Title) />
		<cfset setMenuTitle(arguments.Content.MenuTitle) />
		<cfset setFilename(arguments.Content.Filename) />
		<cfset setLastUpdate(arguments.Content.LastUpdate) />
		<cfset setDisplay(arguments.Content.Display) />
		<cfset setParentID(arguments.Content.ParentID) />
		<cfset setType(arguments.Content.Type) />
		<cfset setSubType(arguments.Content.subType) />
		<cfset setLastUpdateBy(arguments.Content.LastUpdateBy) />
		<cfset setLastUpdateByID(arguments.Content.LastUpdateByID) />
		<cfset setSummary(arguments.Content.summary) />
		<cfset setSiteID(arguments.Content.SiteID) />
		<cfset setModuleID(arguments.Content.ModuleID) />
		<cfset setIsNav(arguments.Content.IsNav) />
		<cfset setRestricted(arguments.Content.Restricted) />
		<cfset setTarget(arguments.Content.Target) />
		<cfset setTargetParams(arguments.Content.TargetParams) />
		<cfset setRestrictGroups(arguments.Content.RestrictGroups) />
		<cfset setTemplate(arguments.Content.Template) />
		<cfset setResponseMessage(arguments.Content.ResponseMessage) />
		<cfset setResponseChart(arguments.Content.ResponseChart) />
		<cfset setResponseSendTo(arguments.Content.ResponseSendTo) />
		<cfset setResponseDisplayFields(arguments.Content.ResponseDisplayFields) />
		<cfset setModuleAssign(arguments.Content.ModuleAssign) />
		<cfset setnotes(arguments.Content.notes) />
		<cfset setInheritObjects(arguments.Content.inheritObjects) />
		<cfset setIsFeature(arguments.Content.isFeature) />
		<cfset setReleaseDate(arguments.Content.releaseDate) />
		<cfset setTargetParams(arguments.Content.targetParams) />
		<cfset setIsLocked(arguments.Content.IsLocked) />
		<cfset setNextN(arguments.Content.nextN) />
		<cfset setSortBy(arguments.Content.sortBy) />
		<cfset setSortDirection(arguments.Content.sortDirection) />
		<cfset setFeatureStart(arguments.Content.FeatureStart) />
		<cfset setFeatureStop(arguments.Content.FeatureStop) />
		<cfset setFileID(arguments.Content.FileID) />
		<cfset setFileSize(arguments.Content.FileSize) />
		<cfset setFileExt(arguments.Content.FileExt) />
		<cfset setcontentType(arguments.Content.ContentType) />
		<cfset setcontentSubType(arguments.Content.ContentSubType) />
		<cfset setForceSSL(arguments.Content.ForceSSL) />
		<cfset setRemoteID(arguments.Content.remoteID) />
		<cfset setRemoteURL(arguments.Content.remoteURL) />
		<cfset setRemotePubDate(arguments.Content.remotePubDate) />
		<cfset setRemoteSource(arguments.Content.remoteSource) />
		<cfset setRemoteSourceURL(arguments.Content.remoteSourceURL) />
		<cfset setCredits(arguments.Content.credits) />
		<cfset setAudience(arguments.Content.audience) />
		<cfset setKeyPoints(arguments.Content.keyPoints) />
		<cfset setSearchExclude(arguments.Content.searchExclude) />
		<cfset setDisplayTitle(arguments.Content.displayTitle) />
		<cfset setPath(arguments.Content.path) />
		<cfset setTags(arguments.Content.tags) />
		<cfset setdoCache(arguments.Content.doCache) />
		<cfset setCreated(arguments.Content.created) />
		
	<cfelseif isStruct(arguments.content)>
	
		<cfloop collection="#arguments.content#" item="prop">
			<cfif structKeyExists(this,"set#prop#")>
				<cfset evaluate("set#prop#(arguments.content[prop])") />
			</cfif>
		</cfloop>
		
		<cfif getDisplay() eq 2 
			AND isDate(getDisplayStart())>
			
			<cfif isdefined("arguments.content.starthour")
			and isdefined("arguments.content.startMinute")
			and isdefined("arguments.content.startDayPart")>
			
				<cfif arguments.content.startdaypart eq "PM">
					<cfset starthour = arguments.content.starthour + 12>
					
					<cfif starthour eq 24>
						<cfset starthour = 12>
					</cfif>
				<cfelse>
					<cfset starthour = arguments.content.starthour>
					
					<cfif starthour eq 12>
						<cfset starthour = 0>
					</cfif>
				</cfif>
				
				<cfset setDisplayStart(createDateTime(year(getDisplayStart()), month(getDisplayStart()), day(getDisplayStart()),starthour, arguments.content.startMinute, "0"))>
		
			</cfif>
		<cfelseif getDisplay() eq 2 >
			<cfset setDisplay(1) >
			<cfset setDisplayStart("") >
			<cfset setDisplayStop("") >
		</cfif>
		
		<cfif getDisplay() eq 2 
			AND isDate(getDisplayStop())>
			
			<cfif isdefined("arguments.content.Stophour")
			and isdefined("arguments.content.StopMinute")
			and isdefined("arguments.content.StopDayPart")>
			<cfif arguments.content.stopdaypart eq "PM">
				<cfset stophour = arguments.content.stophour + 12>
				
				<cfif stophour eq 24>
					<cfset stophour = 12>
				</cfif>
			<cfelse>
				<cfset stophour = arguments.content.stophour>
				
				<cfif stophour eq 12>
					<cfset stophour = 0>
				</cfif>
			</cfif>
			
			<cfset setDisplayStop(createDateTime(year(getDisplayStop()), month(getDisplayStop()), day(getDisplayStop()),stophour, arguments.content.StopMinute, "0"))>
			
			</cfif>
		</cfif>
		
		<cfif getIsFeature() eq 2 
			AND isDate(getFeatureStart())
			and isdefined("arguments.content.featurestarthour")
			and isdefined("arguments.content.featurestartMinute")
			and isdefined("arguments.content.featureStartDayPart")>
			
			<cfif arguments.content.featureStartdaypart eq "PM">
				<cfset featurestarthour = arguments.content.featurestarthour + 12>
				
				<cfif featurestarthour eq 24>
					<cfset featurestarthour = 12>
				</cfif>
			<cfelse>
				<cfset featurestarthour = arguments.content.featurestarthour>
				
				<cfif featurestarthour eq 12>
					<cfset featurestarthour = 0>
				</cfif>
			</cfif>
			
			<cfset setFeatureStart(createDateTime(year(getFeatureStart()), month(getFeatureStart()), day(getFeatureStart()),Featurestarthour, arguments.content.featurestartMinute, "0"))>
		</cfif>
		
		<cfif getIsFeature() eq 2 
			AND isDate(getFeatureStop())
			and isdefined("arguments.content.featurestophour")
			and isdefined("arguments.content.featurestopMinute")
			and isdefined("arguments.content.featureStopDayPart")>
			
			<cfif arguments.content.featureStopdaypart eq "PM">
				<cfset featurestophour = arguments.content.featurestophour + 12>
				
				<cfif featurestophour eq 24>
					<cfset featurestophour = 12>
				</cfif>
			<cfelse>
				<cfset featurestophour = arguments.content.featurestophour>
				
				<cfif featurestophour eq 12>
					<cfset featurestophour = 0>
				</cfif>
			</cfif>
			
			<cfset setFeatureStop(createDateTime(year(getFeatureStop()), month(getFeatureStop()), day(getFeatureStop()),Featurestophour, arguments.content.featurestopMinute, "0"))>
		</cfif>
		
		<cfif getAuthUser() eq "" >
			<cfset variables.instance.LastUpdateBy = "" />
			<cfset variables.instance.LastUpdateByID = "" />
		<cfelse>
			<cfset variables.instance.LastUpdateBy = "#listGetAt(getAuthUser(),"2","^")#" />
			<cfset variables.instance.LastUpdateByID = "#listFirst(getAuthUser(),"^")#" />
		</cfif>
		
	</cfif>
  </cffunction>

  <cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
  </cffunction>

 <cffunction name="setcontentHistID" returnType="void" output="false" access="public">
    <cfargument name="ContentHistID" type="string" required="true">
    <cfset variables.instance.ContentHistID = arguments.ContentHistID />
  </cffunction>

  <cffunction name="getcontentHistID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.ContentHistID)>
		<cfset variables.instance.ContentHistID = createUUID() />
	</cfif>
	<cfreturn variables.instance.ContentHistID />
  </cffunction>

 <cffunction name="setcontentid" returnType="void" output="false" access="public">
    <cfargument name="contentid" type="string" required="true">
    <cfset variables.instance.contentid = trim(arguments.contentid) />
  </cffunction>

  <cffunction name="getcontentid" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.contentid)>
		<cfset variables.instance.contentid = createUUID() />
	</cfif>
	<cfreturn variables.instance.contentid />
  </cffunction>
  
   <cffunction name="setActive" returnType="void" output="false" access="public">
    <cfargument name="Active" type="numeric" required="true">
    <cfset variables.instance.Active = arguments.Active />
  </cffunction>

  <cffunction name="getActive" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Active />
  </cffunction>
  
     <cffunction name="setOrderNo" returnType="void" output="false" access="public">
    <cfargument name="OrderNo" type="numeric" required="true">
    <cfset variables.instance.OrderNo = arguments.OrderNo />
  </cffunction>

  <cffunction name="getOrderNo" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.OrderNo />
  </cffunction>
  
   <cffunction name="setMetaDesc" returnType="void" output="false" access="public">
    <cfargument name="MetaDesc" type="string" required="true">
    <cfset variables.instance.MetaDesc = trim(arguments.MetaDesc) />
  </cffunction>

  <cffunction name="getMetaDesc" returnType="string" output="false" access="public">
    <cfreturn variables.instance.MetaDesc />
  </cffunction>
  
  <cffunction name="setMetaKeyWords" returnType="void" output="false" access="public">
    <cfargument name="MetaKeyWords" type="string" required="true">
    <cfset variables.instance.MetaKeyWords = trim(arguments.MetaKeyWords) />
  </cffunction>

  <cffunction name="getMetaKeyWords" returnType="string" output="false" access="public">
    <cfreturn variables.instance.MetaKeyWords />
  </cffunction>
  
   <cffunction name="setApproved" returnType="void" output="false" access="public">
    <cfargument name="Approved" type="numeric" required="true">
    <cfset variables.instance.Approved = arguments.Approved />
  </cffunction>

  <cffunction name="getApproved" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Approved />
  </cffunction>
  
  <cffunction name="setDisplayStart" returnType="void" output="false" access="public">
    <cfargument name="DisplayStart" type="string" required="true">
	<cfif lsisDate(arguments.displayStart)>
		<cftry>
		<cfset variables.instance.displayStart = lsparseDateTime(arguments.displayStart) />
		<cfcatch>
			<cfset variables.instance.displayStart = arguments.displayStart />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.displayStart = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getDisplayStart" returnType="string" output="false" access="public">
    <cfreturn variables.instance.DisplayStart />
  </cffunction>
  
  <cffunction name="setDisplaystop" returnType="void" output="false" access="public">
    <cfargument name="Displaystop" type="string" required="true">
	<cfif lsisDate(arguments.displayStop)>
		<cftry>
		<cfset variables.instance.displayStop = lsparseDateTime(arguments.displayStop) />
		<cfcatch>
			<cfset variables.instance.displayStop = arguments.displayStop />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.displayStop = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getDisplaystop" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Displaystop />
  </cffunction>
  
  <cffunction name="setBody" returnType="void" output="false" access="public">
    <cfargument name="Body" type="string" required="true">
    <cfset variables.instance.Body = trim(arguments.Body) />
  </cffunction>

  <cffunction name="getBody" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Body />
  </cffunction>
  
  <cffunction name="setTitle" returnType="void" output="false" access="public">
    <cfargument name="Title" type="string" required="true">
    <cfset variables.instance.Title = trim(arguments.Title) />
  </cffunction>

  <cffunction name="getTitle" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Title />
  </cffunction>

  <cffunction name="setMenuTitle" returnType="void" output="false" access="public">
    <cfargument name="MenuTitle" type="string" required="true">
    <cfset variables.instance.MenuTitle = trim(arguments.MenuTitle) />
  </cffunction>

  <cffunction name="getMenuTitle" returnType="string" output="false" access="public">
    <cfreturn variables.instance.MenuTitle />
  </cffunction>

  <cffunction name="setFilename" returnType="void" output="false" access="public">
    <cfargument name="Filename" type="string" required="true">
    <cfset variables.instance.Filename = trim(arguments.Filename) />
  </cffunction>

  <cffunction name="getFilename" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Filename />
  </cffunction>
  
  <cffunction name="setOldFilename" returnType="void" output="false" access="public">
    <cfargument name="OldFilename" type="string" required="true">
    <cfset variables.instance.OldFilename = trim(arguments.OldFilename) />
  </cffunction>

  <cffunction name="getOldFilename" returnType="string" output="false" access="public">
    <cfreturn variables.instance.OldFilename />
  </cffunction>
  
  <cffunction name="setLastUpdate" returnType="void" output="false" access="public">
    <cfargument name="LastUpdate" type="string" required="true">
	<cfif lsisDate(arguments.LastUpdate)>
		<cftry>
		<cfset variables.instance.LastUpdate = lsparseDateTime(arguments.LastUpdate) />
		<cfcatch>
			<cfset variables.instance.LastUpdate = arguments.LastUpdate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.LastUpdate = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getLastUpdate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdate />
  </cffunction>

   <cffunction name="setDisplay" returnType="void" output="false" access="public">
    <cfargument name="Display" type="numeric" required="true">
    <cfset variables.instance.Display = arguments.Display />
  </cffunction>

  <cffunction name="getDisplay" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Display />
  </cffunction>
  
  <cffunction name="setParentID" returnType="void" output="false" access="public">
    <cfargument name="ParentID" type="string" required="true">
    <cfset variables.instance.ParentID = trim(arguments.ParentID) />
  </cffunction>

  <cffunction name="getParentID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ParentID />
  </cffunction>
  
  <cffunction name="setType" returnType="void" output="false" access="public">
    <cfargument name="Type" type="string" required="true">
    <cfset variables.instance.Type = trim(arguments.Type) />
  </cffunction>

  <cffunction name="getType" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Type />
  </cffunction>

  <cffunction name="setSubType" returnType="void" output="false" access="public">
    <cfargument name="SubType" type="string" required="true">
    <cfif len(trim(arguments.subType))>
    	<cfset variables.instance.subType = trim(arguments.subType) />
    </cfif>
  </cffunction>

  <cffunction name="getSubType" returnType="string" output="false" access="public">
		<cfreturn variables.instance.subType />
  </cffunction>

  <cffunction name="setLastUpdateBy" returnType="void" output="false" access="public">
    <cfargument name="LastUpdateBy" type="string" required="true">
    <cfset variables.instance.LastUpdateBy = left(trim(arguments.LastUpdateBy),50) />
  </cffunction>

  <cffunction name="getLastUpdateBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateBy />
  </cffunction>
  
  <cffunction name="setLastUpdateByID" returnType="void" output="false" access="public">
    <cfargument name="LastUpdateByID" type="string" required="true">
    <cfset variables.instance.LastUpdateByID = trim(arguments.LastUpdateByID) />
  </cffunction>

  <cffunction name="getLastUpdateByID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateByID />
  </cffunction>

  <cffunction name="setSummary" returnType="void" output="false" access="public">
    <cfargument name="Summary" type="string" required="true">
    <cfset variables.instance.Summary = trim(arguments.Summary) />
  </cffunction>

  <cffunction name="getSummary" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Summary />
  </cffunction>

  <cffunction name="setSiteID" returnType="void" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
  </cffunction>

  <cffunction name="getSiteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SiteID />
  </cffunction>
  
  <cffunction name="setModuleID" returnType="void" output="false" access="public">
    <cfargument name="ModuleID" type="string" required="true">
    <cfset variables.instance.ModuleID = arguments.ModuleID />
  </cffunction>

  <cffunction name="getModuleID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ModuleID />
  </cffunction>
  
   <cffunction name="setIsNav" returnType="void" output="false" access="public">
    <cfargument name="IsNav" type="numeric" required="true">
    <cfset variables.instance.IsNav = arguments.IsNav />
  </cffunction>

  <cffunction name="getIsNav" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsNav />
  </cffunction>
  
  <cffunction name="setRestricted" returnType="void" output="false" access="public">
    <cfargument name="Restricted" type="numeric" required="true">
    <cfset variables.instance.Restricted = arguments.Restricted />
  </cffunction>

  <cffunction name="getRestricted" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Restricted />
  </cffunction>
  
  <cffunction name="setTarget" returnType="void" output="false" access="public">
    <cfargument name="Target" type="string" required="true">
    <cfset variables.instance.Target = trim(arguments.Target) />
  </cffunction>

  <cffunction name="getTarget" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Target />
  </cffunction>
  
  <cffunction name="setRestrictGroups" returnType="void" output="false" access="public">
    <cfargument name="RestrictGroups" type="string" required="true">
    <cfset variables.instance.RestrictGroups = trim(arguments.RestrictGroups) />
  </cffunction>

  <cffunction name="getRestrictGroups" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RestrictGroups />
  </cffunction>
  
  <cffunction name="setTemplate" returnType="void" output="false" access="public">
    <cfargument name="Template" type="string" required="true">
    <cfset variables.instance.Template = trim(arguments.Template) />
  </cffunction>

  <cffunction name="getTemplate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Template />
  </cffunction>
  
  <cffunction name="setResponseMessage" returnType="void" output="false" access="public">
    <cfargument name="ResponseMessage" type="string" required="true">
    <cfset variables.instance.ResponseMessage = trim(arguments.ResponseMessage) />
  </cffunction>

  <cffunction name="getResponseMessage" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ResponseMessage />
  </cffunction>
  
  <cffunction name="setResponseChart" returnType="void" output="false" access="public">
    <cfargument name="ResponseChart" type="numeric" required="true">
    <cfset variables.instance.ResponseChart = arguments.ResponseChart />
  </cffunction>

  <cffunction name="getResponseChart" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.ResponseChart />
  </cffunction>
  
  <cffunction name="setResponseSendTo" returnType="void" output="false" access="public">
    <cfargument name="ResponseSendTo" type="string" required="true">
    <cfset variables.instance.ResponseSendTo = trim(arguments.ResponseSendTo) />
  </cffunction>

  <cffunction name="getResponseSendTo" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ResponseSendTo />
  </cffunction>
  
  <cffunction name="setResponseDisplayFields" returnType="void" output="false" access="public">
    <cfargument name="ResponseDisplayFields" type="string" required="true">
    <cfset variables.instance.ResponseDisplayFields = trim(arguments.ResponseDisplayFields) />
  </cffunction>

  <cffunction name="getResponseDisplayFields" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ResponseDisplayFields />
  </cffunction>
  
  <cffunction name="setModuleAssign" returnType="void" output="false" access="public">
    <cfargument name="ModuleAssign" type="string" required="true">
    <cfset variables.instance.ModuleAssign = trim(arguments.ModuleAssign) />
  </cffunction>

  <cffunction name="getModuleAssign" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ModuleAssign />
  </cffunction>
  
  <cffunction name="setNotes" returnType="void" output="false" access="public">
    <cfargument name="Notes" type="string" required="true">
    <cfset variables.instance.Notes = trim(arguments.Notes) />
  </cffunction>

  <cffunction name="getNotes" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Notes />
  </cffunction>

  <cffunction name="setInheritObjects" returnType="void" output="false" access="public">
    <cfargument name="InheritObjects" type="string" required="true">
    <cfset variables.instance.InheritObjects = trim(arguments.InheritObjects) />
  </cffunction>

  <cffunction name="getInheritObjects" returnType="string" output="false" access="public">
    <cfreturn variables.instance.InheritObjects />
  </cffunction>
  
   <cffunction name="setIsFeature" returnType="void" output="false" access="public">
    <cfargument name="IsFeature" type="numeric" required="true">
    <cfset variables.instance.IsFeature = arguments.IsFeature />
  </cffunction>

  <cffunction name="getIsFeature" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsFeature />
  </cffunction>
  
     <cffunction name="setIsNew" returnType="void" output="false" access="public">
    <cfargument name="IsNew" type="numeric" required="true">
    <cfset variables.instance.IsNew = arguments.IsNew />
  </cffunction>

  <cffunction name="getIsNew" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsNew />
  </cffunction>
  
  <cffunction name="setReleaseDate" returnType="void" output="false" access="public">
    <cfargument name="releaseDate" type="string" required="true">
	<cfif lsisDate(arguments.releaseDate)>
		<cftry>
		<cfset variables.instance.releaseDate = lsparseDateTime(arguments.releaseDate) />
		<cfcatch>
			<cfset variables.instance.releaseDate = arguments.releaseDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.releaseDate = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getReleaseDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.releaseDate />
  </cffunction>
  
         <cffunction name="setTargetParams" returnType="void" output="false" access="public">
    <cfargument name="TargetParams" type="string" required="true">
    <cfset variables.instance.TargetParams = trim(arguments.TargetParams) />
  </cffunction>

  <cffunction name="getTargetParams" returnType="string" output="false" access="public">
    <cfreturn variables.instance.TargetParams />
  </cffunction>
  
  <cffunction name="setIsLocked" returnType="void" output="false" access="public">
    <cfargument name="IsLocked" type="numeric" required="true">
    <cfset variables.instance.IsLocked = arguments.IsLocked />
  </cffunction>

  <cffunction name="getIsLocked" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsLocked />
  </cffunction>
  
  <cffunction name="setNextN" returnType="void" output="false" access="public">
    <cfargument name="NextN" type="any" required="true">
	<cfif isNumeric(arguments.NextN)>
   		<cfset variables.instance.NextN = arguments.NextN />
	</cfif>
  </cffunction>

  <cffunction name="getNextN" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.NextN />
  </cffunction>
  
 <cffunction name="setSortBy" returnType="void" output="false" access="public">
    <cfargument name="SortBy" type="string" required="true">
    <cfset variables.instance.SortBy = trim(arguments.SortBy) />
  </cffunction>

  <cffunction name="getSortBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SortBy />
  </cffunction>
  
   <cffunction name="setSortDirection" returnType="void" output="false" access="public">
    <cfargument name="SortDirection" type="string" required="true">
    <cfset variables.instance.SortDirection = trim(arguments.SortDirection) />
  </cffunction>

  <cffunction name="getSortDirection" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SortDirection />
  </cffunction>
  
    <cffunction name="setFeatureStop" returnType="void" output="false" access="public">
    <cfargument name="FeatureStop" type="string" required="true">
    	<cfif lsisDate(arguments.FeatureStop)>
		<cftry>
		<cfset variables.instance.FeatureStop = lsparseDateTime(arguments.FeatureStop) />
		<cfcatch>
			<cfset variables.instance.FeatureStop = arguments.FeatureStop />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.FeatureStop = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getFeatureStop" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FeatureStop />
  </cffunction>
  
  <cffunction name="setFeatureStart" returnType="void" output="false" access="public">
    <cfargument name="FeatureStart" type="string" required="true">
	<cfif lsisDate(arguments.FeatureStart)>
		<cftry>
		<cfset variables.instance.FeatureStart = lsparseDateTime(arguments.FeatureStart) />
		<cfcatch>
			<cfset variables.instance.FeatureStart = arguments.FeatureStart />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.FeatureStart = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getFeatureStart" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FeatureStart />
  </cffunction>
  
  <cffunction name="setFileID" returnType="void" output="false" access="public">
    <cfargument name="FileID" type="string" required="true">
    <cfset variables.instance.FileID = trim(arguments.FileID) />
  </cffunction>

  <cffunction name="getFileID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FileID />
  </cffunction>
  
    <cffunction name="setFileSize" returnType="void" output="false" access="public">
    <cfargument name="FileSize" type="string" required="true">
    <cfset variables.instance.FileSize = trim(arguments.FileSize) />
  </cffunction>

  <cffunction name="getFileSize" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FileSize />
  </cffunction>
  
   <cffunction name="setFileExt" returnType="void" output="false" access="public">
    <cfargument name="FileExt" type="string" required="true">
    <cfset variables.instance.FileExt = trim(arguments.FileExt) />
  </cffunction>

  <cffunction name="getFileExt" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FileExt />
  </cffunction>
  
   <cffunction name="setcontentType" returnType="void" output="false" access="public">
    <cfargument name="ContentType" type="string" required="true">
    <cfset variables.instance.ContentType = trim(arguments.ContentType) />
  </cffunction>

  <cffunction name="getcontentType" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ContentType />
  </cffunction>
  
  <cffunction name="setcontentSubType" returnType="void" output="false" access="public">
    <cfargument name="ContentSubType" type="string" required="true">
    <cfset variables.instance.ContentSubType = trim(arguments.ContentSubType) />
  </cffunction>

  <cffunction name="getcontentSubType" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ContentSubType />
  </cffunction>
  
  <cffunction name="setForceSSL" returnType="void" output="false" access="public">
    <cfargument name="ForceSSL" type="numeric" required="true">
    <cfset variables.instance.ForceSSL = arguments.ForceSSL />
  </cffunction>

  <cffunction name="getForceSSL" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.ForceSSL />
  </cffunction>
  
   <cffunction name="setRemoteID" returnType="void" output="false" access="public">
    <cfargument name="RemoteID" type="string" required="true">
    <cfset variables.instance.RemoteID = trim(arguments.RemoteID) />
  </cffunction>

  <cffunction name="getRemoteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteID />
  </cffunction>
  
   <cffunction name="setRemoteURL" returnType="void" output="false" access="public">
    <cfargument name="RemoteURL" type="string" required="true">
    <cfset variables.instance.RemoteURL = trim(arguments.RemoteURL) />
  </cffunction>

  <cffunction name="getRemoteURL" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteURL />
  </cffunction>
  
  <cffunction name="setRemotePubDate" returnType="void" output="false" access="public">
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
  </cffunction>

  <cffunction name="getRemotePubDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemotePubDate />
  </cffunction>

  <cffunction name="setRemoteSource" returnType="void" output="false" access="public">
    <cfargument name="RemoteSource" type="string" required="true">
    <cfset variables.instance.RemoteSource = trim(arguments.RemoteSource) />
  </cffunction>
  
  <cffunction name="getRemoteSource" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteSource />
  </cffunction>

  <cffunction name="setRemoteSourceURL" returnType="void" output="false" access="public">
    <cfargument name="RemoteSourceURL" type="string" required="true">
    <cfset variables.instance.RemoteSourceURL = trim(arguments.RemoteSourceURL) />
  </cffunction>
  
  <cffunction name="getRemoteSourceURL" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteSourceURL />
  </cffunction>

  <cffunction name="setCredits" returnType="void" output="false" access="public">
    <cfargument name="Credits" type="string" required="true">
    <cfset variables.instance.Credits = trim(arguments.Credits) />
  </cffunction>
  
  <cffunction name="getCredits" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Credits />
  </cffunction>

  <cffunction name="setAudience" returnType="void" output="false" access="public">
    <cfargument name="audience" type="string" required="true">
    <cfset variables.instance.audience = trim(arguments.audience) />
  </cffunction>
  
  <cffunction name="getAudience" returnType="string" output="false" access="public">
    <cfreturn variables.instance.audience />
  </cffunction>

  <cffunction name="setKeyPoints" returnType="void" output="false" access="public">
    <cfargument name="keyPoints" type="string" required="true">
    <cfset variables.instance.keyPoints = trim(arguments.keyPoints) />
  </cffunction>
  
  <cffunction name="getKeyPoints" returnType="string" output="false" access="public">
    <cfreturn variables.instance.keyPoints />
  </cffunction>

  <cffunction name="setSearchExclude" returnType="void" output="false" access="public">
    <cfargument name="searchExclude" type="numeric" required="true">
    <cfset variables.instance.searchExclude = arguments.searchExclude />
  </cffunction>
  
  <cffunction name="getSearchExclude" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.searchExclude />
  </cffunction>

  <cffunction name="setDisplayTitle" returnType="void" output="false" access="public">
    <cfargument name="DisplayTitle" required="true">
	<cfif isNumeric(arguments.DisplayTitle)>
  	  <cfset variables.instance.DisplayTitle = arguments.DisplayTitle />
	</cfif>
  </cffunction>
  
  <cffunction name="getDisplayTitle" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.DisplayTitle />
  </cffunction>
  
  <cffunction name="setPath" returnType="void" output="false" access="public">
    <cfargument name="Path" type="string" required="true">
    <cfset variables.instance.Path = trim(arguments.Path) />
  </cffunction>
  
  <cffunction name="getPath" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Path />
  </cffunction>

  <cffunction name="setTags" returnType="void" output="false" access="public">
    <cfargument name="tags" type="string" required="true">
    <cfset variables.instance.tags = trim(arguments.tags) />
  </cffunction>
  
  <cffunction name="getTags" returnType="string" output="false" access="public">
    <cfreturn variables.instance.tags />
  </cffunction>

  <cffunction name="setDoCache" returnType="void" output="false" access="public">
    <cfargument name="doCache" required="true">
	<cfif isNumeric(arguments.doCache)>
    <cfset variables.instance.doCache = arguments.doCache />
	</cfif>
  </cffunction>

  <cffunction name="getDoCache" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.doCache />
  </cffunction>

  <cffunction name="setCreated" returnType="void" output="false" access="public">
    <cfargument name="Created" type="string" required="true">
	<cfif lsisDate(arguments.created)>
		<cftry>
		<cfset variables.instance.created = lsparseDateTime(arguments.created) />
		<cfcatch>
			<cfset variables.instance.created = arguments.created />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.created = ""/>
	</cfif>
  </cffunction>

  <cffunction name="getCreated" returnType="string" output="false" access="public">
    <cfreturn variables.instance.created />
  </cffunction>

  <cffunction name="getExtendedAttribute" returnType="string" output="false" access="public">
 	<cfargument name="key" type="string" required="true">
	<cfargument name="useMuraDefault" type="boolean" required="true" default="false"> 
	
	<cfif not isObject(variables.instance.extendData)>
	<cfset variables.instance.extendData=variables.configBean.getClassExtensionManager().getExtendedData(getcontentHistID())/>
	</cfif> 
  	<cfreturn variables.instance.extendData.getAttribute(arguments.key,arguments.useMuraDefault) />
  </cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="propertyValue" default="" >
	
	<cfif structKeyExists(this,"set#property#")>
		<cfset evaluate("set#property#(arguments.propertyValue") />
	<cfelse>
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
	</cfif>

</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	
	<cfif structKeyExists(this,"get#property#")>
		<cfreturn evaluate("get#property#(arguments.propertyValue") />
	<cfelseif structKeyExists(request,"#arguments.property#")>
		<cfreturn request["#arguments.property#"] />
	<cfelse>
		<cfreturn getExtendedAttribute(arguments.property) />
	</cfif>

</cffunction>

<cffunction name="setCategory" returntype="any" access="public" output="false">
	<cfargument name="categoryID"  required="true" default=""/>
	<cfargument name="membership"  required="true" default="0"/>
	<cfargument name="featureStart"  required="true" default=""/>	
	<cfargument name="featureStop"  required="true" default=""/>	
	
	<cfset var catTrim=replace(arguments.categoryID,'-','','ALL')>
	
	<cfset variables.instance["categoryAssign#catTrim#"]=arguments.membership />
	
	<cfif arguments.membership eq "2">
		<cfif isdate(arguments.featureStart)>
		<cfset variables.instance['featureStart#catTrim#']=arguments.featureStart />
		<cfset variables.instance['starthour#catTrim#']=hour(arguments.featureStart)+1 />
		<cfset variables.instance['startMinute#catTrim#']=minute(arguments.featureStart) />
		<cfset variables.instance['startDayPart#catTrim#']=dateFormat(arguments.featureStart,"tt") />
		</cfif>
		<cfif isdate(arguments.featureStop)>
		<cfset variables.instance['featureStop#catTrim#']=arguments.featureStop />
		<cfset variables.instance['stophour#catTrim#']=hour(arguments.featureStop)+1 />
		<cfset variables.instance['stopMinute#catTrim#']=minute(arguments.featureStop) />
		<cfset variables.instance['stopDayPart#catTrim#']=dateFormat(arguments.featureStop,"tt") />
		</cfif>
	</cfif>
</cffunction>

<cffunction name="setCategories" returntype="any" access="public" output="false">
	<cfargument name="categoryList"  required="true" default=""/>
	<cfargument name="membership"  required="true" default="0"/>
	<cfargument name="featureStart"  required="true" default=""/>	
	<cfargument name="featureStop"  required="true" default=""/>
	
	<cfset var cat = "" />
	<cfloop list="#arguments.categoryList#" index="cat">
		<cfset setCategory(
			cat,
			arguments.membership,
			arguments.featureStart,
			arguments.featureStop	
		) />
	</cfloop>
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
</cffunction>

</cfcomponent>