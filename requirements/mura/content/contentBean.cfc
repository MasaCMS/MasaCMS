<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">
<cfset variables.instance = structNew() />
<cfset variables.instance.ContentHistID = "" />
<cfset variables.instance.Contentid = "" />
<cfset variables.instance.preserveID = "" />
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
<cfset variables.instance.URLTitle="" />
<cfset variables.instance.HTMLTitle="" />
<cfset variables.instance.Filename = "" />
<cfset variables.instance.OldFilename = "" />
<cfset variables.instance.LastUpdate = now() />
<cfset variables.instance.Display = 1 />
<cfset variables.instance.ParentID = "" />
<cfset variables.instance.Type = "Page" />
<cfset variables.instance.newFile = "" />
<cfset variables.instance.subType = "Default" />

<cfif isDefined("session.mura") and session.mura.isLoggedIn>
	<cfset variables.instance.LastUpdateBy = left(session.mura.fname & " " & session.mura.lname,50) />
	<cfset variables.instance.LastUpdateByID = session.mura.userID />
<cfelse>
	<cfset variables.instance.LastUpdateBy = "" />
	<cfset variables.instance.LastUpdateByID = "" />
</cfif>

<cfset variables.instance.Summary = "" />
<cfset variables.instance.SiteID = "" />
<cfset variables.instance.ModuleID = "00000000000000000000000000000000000" />
<cfset variables.instance.IsNav = 1 />
<cfset variables.instance.Restricted = 0 />
<cfset variables.instance.Target = "_self" />
<cfset variables.instance.RestrictGroups = "" />
<cfset variables.instance.Template = "" />
<cfset variables.instance.ResponseMessage = "" />
<cfset variables.instance.ResponseChart = 0 />
<cfset variables.instance.ResponseSendTo = "" />
<cfset variables.instance.ResponseDisplayFields = "" />
<cfset variables.instance.ModuleAssign = "" />
<cfset variables.instance.notes = "" />
<cfset variables.instance.inheritObjects = "Inherit" />
<cfset variables.instance.isFeature = 0 />
<cfset variables.instance.isNew = 1 />
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
<cfset variables.instance.extendSetID="" />
<cfset variables.instance.doCache = 1 />
<cfset variables.instance.created = now() />
<cfset variables.instance.mobileExclude = 0 />
<cfset variables.instance.changesetID = "" />
<cfset variables.instance.errors=structnew() />
<cfset variables.kids = arrayNew(1) />
<cfset variables.displayRegions = structNew()>

<cffunction name="init" access="public" returntype="any" output="false">
	<cfargument name="configBean" required="true" default=""/>
	<cfargument name="contentManager" required="true" default=""/>
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.contentManager=arguments.contentManager />
	<cfreturn this />
</cffunction>

 <cffunction name="set" returnType="any" output="false" access="public">
    <cfargument name="content" type="any" required="true">
	
	<cfset var starthour = 0 />
	<cfset var stophour = 0 />
	<cfset var pageNum = 2 />
	<cfset var featurestophour="" />
	<cfset var featurestarthour="" />
	<cfset var releasehour="" />
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
		<cfset setURLTitle(arguments.Content.urltitle) />
		<cfset setHTMLTitle(arguments.Content.htmltitle) />
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
		<cfset setMobileExclude(arguments.Content.mobileExclude) />
		<cfset setCreated(arguments.Content.created) />
		<cfset setChangesetID(arguments.Content.changesetID) />
		
	<cfelseif isStruct(arguments.content)>
	
		<cfloop collection="#arguments.content#" item="prop">
				<cfset setValue(prop,arguments.content[prop]) />
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
		
		<cfif isDate(getReleaseDate())>
			
			<cfif isdefined("arguments.content.releasehour")
			and isdefined("arguments.content.releaseMinute")
			and isdefined("arguments.content.releaseDayPart")>
			
				<cfif arguments.content.releasedaypart eq "PM">
					<cfset releasehour = arguments.content.releasehour + 12>
					
					<cfif releasehour eq 24>
						<cfset releasehour = 12>
					</cfif>
				<cfelse>
					<cfset releasehour = arguments.content.releasehour>
					
					<cfif releasehour eq 12>
						<cfset releasehour = 0>
					</cfif>
				</cfif>
				
				<cfset setReleaseDate(createDateTime(year(getReleaseDate()), month(getReleaseDate()), day(getReleaseDate()), releasehour, arguments.content.releaseMinute, "0"))>
		
			</cfif>
		</cfif>
		
		<cfif not session.mura.isLoggedIn >
			<cfset variables.instance.LastUpdateBy = "" />
			<cfset variables.instance.LastUpdateByID = "" />
		<cfelse>
			<cfset variables.instance.LastUpdateBy = left(session.mura.fname & " " & session.mura.lname,50) />
			<cfset variables.instance.LastUpdateByID = session.mura.userID />
		</cfif>
		
	</cfif>
	
	<cfset validate()/>
	<cfreturn this />
  </cffunction>

  <cffunction name="validate" access="public" output="false">
		<cfset var extErrors=structNew() />
	
		<cfif len(getSiteID())>
			<cfset extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues())>
		</cfif>
		
		<cfset variables.instance.errors=structnew() />
		
		<cfif not structIsEmpty(extErrors)>
			<cfset structAppend(variables.instance.errors,extErrors)>
		</cfif>
		<cfreturn this>	
  </cffunction>

  <cffunction name="getErrors" returntype="any" output="false">
	<cfreturn variables.instance.errors>
  </cffunction>
 
  <cffunction name="getAllValues" access="public" returntype="struct" output="false">
		<cfset var i="">
		<cfset var extData=getExtendedData().getAllExtendSetData()>
		
		<cfif not structIsEmpty(extData)>
			<cfset structAppend(variables.instance,extData.data,false)>	
			<cfloop list="#extData.extendSetID#" index="i">
				<cfif not listFind(variables.instance.extendSetID,i)>
					<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif not structIsEmpty(variables.displayRegions)>
			<cfloop collection="#variables.displayRegions#" item="i">
				<cfset variables.instance[i]=variables.contentManager.formatRegionObjectsString(variables.displayRegions[i])>
			</cfloop>
		</cfif>
		
		<cfset purgeExtendedData()>
		<cfset variables.displayRegions=structNew()>
		
		<cfreturn variables.instance />
  </cffunction>

 <cffunction name="setcontentHistID" output="false" access="public">
    <cfargument name="ContentHistID" type="string" required="true">
    <cfset variables.instance.ContentHistID = arguments.ContentHistID />
	<cfreturn this>
  </cffunction>

 <cffunction name="getcontentHistID" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.ContentHistID)>
		<cfset variables.instance.ContentHistID = createUUID() />
	</cfif>
	<cfreturn variables.instance.ContentHistID />
  </cffunction>

 <cffunction name="setPreserveID" output="false" access="public">
    <cfargument name="preserveID" type="string" required="true">
    <cfset variables.instance.preserveID = arguments.preserveID />
	<cfreturn this>
  </cffunction>

  <cffunction name="getPreserveID" returnType="string" output="false" access="public">
	<cfreturn variables.instance.preserveID />
  </cffunction>

 <cffunction name="setcontentid" output="false" access="public">
    <cfargument name="contentid" type="string" required="true">
    <cfset variables.instance.contentid = trim(arguments.contentid) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getcontentid" returnType="string" output="false" access="public">
    <cfif not len(variables.instance.contentid)>
		<cfset variables.instance.contentid = createUUID() />
	</cfif>
	<cfreturn variables.instance.contentid />
  </cffunction>
  
   <cffunction name="setActive" output="false" access="public">
    <cfargument name="Active" type="numeric" required="true">
    <cfset variables.instance.Active = arguments.Active />
	<cfreturn this>
  </cffunction>

  <cffunction name="getActive" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Active />
  </cffunction>
  
     <cffunction name="setOrderNo" output="false" access="public">
    <cfargument name="OrderNo" type="numeric" required="true">
    <cfset variables.instance.OrderNo = arguments.OrderNo />
	<cfreturn this>
  </cffunction>

  <cffunction name="getOrderNo" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.OrderNo />
  </cffunction>
  
   <cffunction name="setMetaDesc" output="false" access="public">
    <cfargument name="MetaDesc" type="string" required="true">
    <cfset variables.instance.MetaDesc = trim(arguments.MetaDesc) />
  </cffunction>

  <cffunction name="getMetaDesc" returnType="string" output="false" access="public">
    <cfreturn variables.instance.MetaDesc />
  </cffunction>
  
  <cffunction name="setMetaKeyWords" output="false" access="public">
    <cfargument name="MetaKeyWords" type="string" required="true">
    <cfset variables.instance.MetaKeyWords = trim(arguments.MetaKeyWords) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getMetaKeyWords" returnType="string" output="false" access="public">
    <cfreturn variables.instance.MetaKeyWords />
  </cffunction>
  
   <cffunction name="setApproved" output="false" access="public">
    <cfargument name="Approved" type="numeric" required="true">
    <cfset variables.instance.Approved = arguments.Approved />
	<cfreturn this>
  </cffunction>

  <cffunction name="getApproved" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Approved />
  </cffunction>
  
  <cffunction name="setDisplayStart" output="false" access="public">
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
	<cfreturn this>
  </cffunction>

  <cffunction name="getDisplayStart" returnType="string" output="false" access="public">
    <cfreturn variables.instance.DisplayStart />
  </cffunction>
  
  <cffunction name="setDisplaystop" output="false" access="public">
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
	<cfreturn this>
  </cffunction>

  <cffunction name="getDisplaystop" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Displaystop />
  </cffunction>
  
  <cffunction name="setBody" output="false" access="public">
    <cfargument name="Body" type="string" required="true">
    <cfset variables.instance.Body = trim(arguments.Body) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getBody" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Body />
  </cffunction>
  
  <cffunction name="setTitle" output="false" access="public">
    <cfargument name="Title" type="string" required="true">
    <cfset variables.instance.Title = trim(arguments.Title) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getTitle" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Title />
  </cffunction>

  <cffunction name="setMenuTitle" output="false" access="public">
    <cfargument name="MenuTitle" type="string" required="true">
    <cfset variables.instance.MenuTitle = trim(arguments.MenuTitle) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getMenuTitle" returnType="string" output="false" access="public">
    <cfreturn variables.instance.MenuTitle />
  </cffunction>

  <cffunction name="setFilename" output="false" access="public">
    <cfargument name="Filename" type="string" required="true">
    <cfset variables.instance.Filename = trim(arguments.Filename) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getFilename" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Filename />
  </cffunction>
  
  <cffunction name="setOldFilename" output="false" access="public">
    <cfargument name="OldFilename" type="string" required="true">
    <cfset variables.instance.OldFilename = trim(arguments.OldFilename) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getOldFilename" returnType="string" output="false" access="public">
    <cfreturn variables.instance.OldFilename />
  </cffunction>
  
  <cffunction name="setLastUpdate" output="false" access="public">
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
	<cfreturn this>
  </cffunction>

  <cffunction name="getLastUpdate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdate />
  </cffunction>

   <cffunction name="setDisplay" output="false" access="public">
    <cfargument name="Display" type="numeric" required="true">
    <cfset variables.instance.Display = arguments.Display />
	<cfreturn this>
  </cffunction>

  <cffunction name="getDisplay" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Display />
  </cffunction>
  
  <cffunction name="setParentID" output="false" access="public">
    <cfargument name="ParentID" type="string" required="true">
    <cfset variables.instance.ParentID = trim(arguments.ParentID) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getParentID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ParentID />
  </cffunction>
  
  <cffunction name="setType" output="false" access="public">
    <cfargument name="Type" type="string" required="true">
    <cfset arguments.Type=trim(arguments.Type)>
	
	<cfif len(arguments.Type) and variables.instance.Type neq arguments.Type>
		<cfset variables.instance.Type = arguments.Type />
		<cfset purgeExtendedData()>
		<cfif variables.instance.Type eq "Form">
			<cfset setModuleID("00000000000000000000000000000000004")>
			<cfset setParentID("00000000000000000000000000000000004")>
		<cfelseif variables.instance.Type eq "Component">
			<cfset setModuleID("00000000000000000000000000000000003")>
			<cfset setParentID("00000000000000000000000000000000003")>
		</cfif>
	</cfif>
	
	<cfreturn this>
  </cffunction>

  <cffunction name="getType" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Type />
  </cffunction>


  <cffunction name="setSubType" output="false" access="public">
    <cfargument name="SubType" type="string" required="true">
	<cfset arguments.subType=trim(arguments.subType)>
	<cfif len(arguments.subType) and variables.instance.SubType neq arguments.SubType>
    	<cfset variables.instance.SubType = arguments.SubType />
		<cfset purgeExtendedData()>
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getSubType" returnType="string" output="false" access="public">
		<cfreturn variables.instance.subType />
  </cffunction>

  <cffunction name="setLastUpdateBy" output="false" access="public">
    <cfargument name="LastUpdateBy" type="string" required="true">
    <cfset variables.instance.LastUpdateBy = left(trim(arguments.LastUpdateBy),50) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getLastUpdateBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateBy />
  </cffunction>
  
  <cffunction name="setLastUpdateByID" output="false" access="public">
    <cfargument name="LastUpdateByID" type="string" required="true">
    <cfset variables.instance.LastUpdateByID = trim(arguments.LastUpdateByID) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getLastUpdateByID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.LastUpdateByID />
  </cffunction>

  <cffunction name="setSummary" output="false" access="public">
    <cfargument name="Summary" type="string" required="true">
    <cfset variables.instance.Summary = trim(arguments.Summary) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getSummary" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Summary />
  </cffunction>

  <cffunction name="setSiteID" output="false" access="public">
    <cfargument name="SiteID" type="string" required="true">
	<cfif len(arguments.siteID) and trim(arguments.siteID) neq variables.instance.siteID>
    <cfset variables.instance.SiteID = trim(arguments.SiteID) />
	<cfset purgeExtendedData()>
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getSiteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SiteID />
  </cffunction>
  
  <cffunction name="setModuleID" output="false" access="public">
    <cfargument name="ModuleID" type="string" required="true">
    <cfset variables.instance.ModuleID = arguments.ModuleID />
	<cfreturn this>
  </cffunction>

  <cffunction name="getModuleID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ModuleID />
  </cffunction>
  
   <cffunction name="setIsNav" output="false" access="public">
    <cfargument name="IsNav" type="numeric" required="true">
    <cfset variables.instance.IsNav = arguments.IsNav />
	<cfreturn this>
  </cffunction>

  <cffunction name="getIsNav" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsNav />
  </cffunction>
  
  <cffunction name="setRestricted" output="false" access="public">
    <cfargument name="Restricted" type="numeric" required="true">
    <cfset variables.instance.Restricted = arguments.Restricted />
	<cfreturn this>
  </cffunction>

  <cffunction name="getRestricted" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.Restricted />
  </cffunction>
  
  <cffunction name="setTarget" output="false" access="public">
    <cfargument name="Target" type="string" required="true">
    <cfset variables.instance.Target = trim(arguments.Target) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getTarget" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Target />
  </cffunction>
  
  <cffunction name="setRestrictGroups" output="false" access="public">
    <cfargument name="RestrictGroups" type="string" required="true">
    <cfset variables.instance.RestrictGroups = trim(arguments.RestrictGroups) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getRestrictGroups" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RestrictGroups />
  </cffunction>
  
  <cffunction name="setTemplate" output="false" access="public">
    <cfargument name="Template" type="string" required="true">
    <cfset variables.instance.Template = trim(arguments.Template) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getTemplate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Template />
  </cffunction>
  
  <cffunction name="setResponseMessage" output="false" access="public">
    <cfargument name="ResponseMessage" type="string" required="true">
    <cfset variables.instance.ResponseMessage = trim(arguments.ResponseMessage) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getResponseMessage" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ResponseMessage />
  </cffunction>
  
  <cffunction name="setResponseChart" output="false" access="public">
    <cfargument name="ResponseChart" type="numeric" required="true">
    <cfset variables.instance.ResponseChart = arguments.ResponseChart />
	<cfreturn this>
  </cffunction>

  <cffunction name="getResponseChart" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.ResponseChart />
  </cffunction>
  
  <cffunction name="setResponseSendTo" output="false" access="public">
    <cfargument name="ResponseSendTo" type="string" required="true">
    <cfset variables.instance.ResponseSendTo = trim(arguments.ResponseSendTo) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getResponseSendTo" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ResponseSendTo />
  </cffunction>
  
  <cffunction name="setResponseDisplayFields" output="false" access="public">
    <cfargument name="ResponseDisplayFields" type="string" required="true">
    <cfset variables.instance.ResponseDisplayFields = trim(arguments.ResponseDisplayFields) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getResponseDisplayFields" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ResponseDisplayFields />
  </cffunction>
  
  <cffunction name="setModuleAssign" output="false" access="public">
    <cfargument name="ModuleAssign" type="string" required="true">
    <cfset variables.instance.ModuleAssign = trim(arguments.ModuleAssign) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getModuleAssign" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ModuleAssign />
  </cffunction>
  
  <cffunction name="setNotes" output="false" access="public">
    <cfargument name="Notes" type="string" required="true">
    <cfset variables.instance.Notes = trim(arguments.Notes) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getNotes" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Notes />
  </cffunction>

  <cffunction name="setInheritObjects" output="false" access="public">
    <cfargument name="InheritObjects" type="string" required="true">
    <cfset variables.instance.InheritObjects = trim(arguments.InheritObjects) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getInheritObjects" returnType="string" output="false" access="public">
    <cfreturn variables.instance.InheritObjects />
  </cffunction>
  
   <cffunction name="setIsFeature" output="false" access="public">
    <cfargument name="IsFeature" type="numeric" required="true">
    <cfset variables.instance.IsFeature = arguments.IsFeature />
	<cfreturn this>
  </cffunction>

  <cffunction name="getIsFeature" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsFeature />
  </cffunction>
  
     <cffunction name="setIsNew" output="false" access="public">
    <cfargument name="IsNew" type="numeric" required="true">
    <cfset variables.instance.IsNew = arguments.IsNew />
	<cfreturn this>
  </cffunction>

  <cffunction name="getIsNew" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsNew />
  </cffunction>
  
  <cffunction name="setReleaseDate" output="false" access="public">
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
	<cfreturn this>
  </cffunction>

  <cffunction name="getReleaseDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.releaseDate />
  </cffunction>
  
  <cffunction name="setTargetParams" output="false" access="public">
    <cfargument name="TargetParams" type="string" required="true">
    <cfset variables.instance.TargetParams = trim(arguments.TargetParams) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getTargetParams" returnType="string" output="false" access="public">
    <cfreturn variables.instance.TargetParams />
  </cffunction>
  
  <cffunction name="setIsLocked" output="false" access="public">
    <cfargument name="IsLocked" type="numeric" required="true">
    <cfset variables.instance.IsLocked = arguments.IsLocked />
	<cfreturn this>
  </cffunction>

  <cffunction name="getIsLocked" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.IsLocked />
  </cffunction>
  
  <cffunction name="setNextN" output="false" access="public">
    <cfargument name="NextN" type="any" required="true">
	<cfif isNumeric(arguments.NextN)>
   		<cfset variables.instance.NextN = arguments.NextN />
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getNextN" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.NextN />
  </cffunction>
  
 <cffunction name="setSortBy" output="false" access="public">
    <cfargument name="SortBy" type="string" required="true">
    <cfset variables.instance.SortBy = trim(arguments.SortBy) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getSortBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SortBy />
  </cffunction>
  
   <cffunction name="setSortDirection" output="false" access="public">
    <cfargument name="SortDirection" type="string" required="true">
    <cfset variables.instance.SortDirection = trim(arguments.SortDirection) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getSortDirection" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SortDirection />
  </cffunction>
  
    <cffunction name="setFeatureStop" output="false" access="public">
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
	<cfreturn this>
  </cffunction>

  <cffunction name="getFeatureStop" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FeatureStop />
  </cffunction>
  
  <cffunction name="setFeatureStart" output="false" access="public">
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
	<cfreturn this>
  </cffunction>

  <cffunction name="getFeatureStart" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FeatureStart />
  </cffunction>
  
  <cffunction name="setFileID" output="false" access="public">
    <cfargument name="FileID" type="string" required="true">
    <cfset variables.instance.FileID = trim(arguments.FileID) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getFileID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FileID />
  </cffunction>
  
    <cffunction name="setFileSize" output="false" access="public">
    <cfargument name="FileSize" type="string" required="true">
    <cfset variables.instance.FileSize = trim(arguments.FileSize) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getFileSize" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FileSize />
  </cffunction>
  
   <cffunction name="setFileExt" output="false" access="public">
    <cfargument name="FileExt" type="string" required="true">
    <cfset variables.instance.FileExt = trim(arguments.FileExt) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getFileExt" returnType="string" output="false" access="public">
    <cfreturn variables.instance.FileExt />
  </cffunction>
  
   <cffunction name="setcontentType" output="false" access="public">
    <cfargument name="ContentType" type="string" required="true">
    <cfset variables.instance.ContentType = trim(arguments.ContentType) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getcontentType" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ContentType />
  </cffunction>
  
  <cffunction name="setcontentSubType" output="false" access="public">
    <cfargument name="ContentSubType" type="string" required="true">
    <cfset variables.instance.ContentSubType = trim(arguments.ContentSubType) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getcontentSubType" returnType="string" output="false" access="public">
    <cfreturn variables.instance.ContentSubType />
  </cffunction>
  
  <cffunction name="setForceSSL" output="false" access="public">
    <cfargument name="ForceSSL" type="numeric" required="true">
    <cfset variables.instance.ForceSSL = arguments.ForceSSL />
	<cfreturn this>
  </cffunction>

  <cffunction name="getForceSSL" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.ForceSSL />
  </cffunction>
  
   <cffunction name="setRemoteID" output="false" access="public">
    <cfargument name="RemoteID" type="string" required="true">
    <cfset variables.instance.RemoteID = trim(arguments.RemoteID) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getRemoteID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteID />
  </cffunction>
  
   <cffunction name="setRemoteURL" output="false" access="public">
    <cfargument name="RemoteURL" type="string" required="true">
    <cfset variables.instance.RemoteURL = trim(arguments.RemoteURL) />
	<cfreturn this>
  </cffunction>

  <cffunction name="getRemoteURL" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteURL />
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
		<cfset variables.instance.RemotePubDate = arguments.RemotePubDate/>
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getRemotePubDate" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemotePubDate />
  </cffunction>

  <cffunction name="setRemoteSource" output="false" access="public">
    <cfargument name="RemoteSource" type="string" required="true">
    <cfset variables.instance.RemoteSource = trim(arguments.RemoteSource) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getRemoteSource" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteSource />
  </cffunction>

  <cffunction name="setRemoteSourceURL" output="false" access="public">
    <cfargument name="RemoteSourceURL" type="string" required="true">
    <cfset variables.instance.RemoteSourceURL = trim(arguments.RemoteSourceURL) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getRemoteSourceURL" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RemoteSourceURL />
  </cffunction>

  <cffunction name="setCredits" output="false" access="public">
    <cfargument name="Credits" type="string" required="true">
    <cfset variables.instance.Credits = trim(arguments.Credits) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getCredits" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Credits />
  </cffunction>

  <cffunction name="setAudience" output="false" access="public">
    <cfargument name="audience" type="string" required="true">
    <cfset variables.instance.audience = trim(arguments.audience) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getAudience" returnType="string" output="false" access="public">
    <cfreturn variables.instance.audience />
  </cffunction>

  <cffunction name="setKeyPoints" output="false" access="public">
    <cfargument name="keyPoints" type="string" required="true">
    <cfset variables.instance.keyPoints = trim(arguments.keyPoints) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getKeyPoints" returnType="string" output="false" access="public">
    <cfreturn variables.instance.keyPoints />
  </cffunction>

  <cffunction name="setSearchExclude" output="false" access="public">
    <cfargument name="searchExclude" type="numeric" required="true">
    <cfset variables.instance.searchExclude = arguments.searchExclude />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getSearchExclude" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.searchExclude />
  </cffunction>

  <cffunction name="setDisplayTitle" output="false" access="public">
    <cfargument name="DisplayTitle" required="true">
	<cfif isNumeric(arguments.DisplayTitle)>
  	  <cfset variables.instance.DisplayTitle = arguments.DisplayTitle />
	</cfif>
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getDisplayTitle" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.DisplayTitle />
  </cffunction>
  
  <cffunction name="setPath" output="false" access="public">
    <cfargument name="Path" type="string" required="true">
    <cfset variables.instance.Path = trim(arguments.Path) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getPath" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Path />
  </cffunction>

  <cffunction name="setTags" output="false" access="public">
    <cfargument name="tags" type="string" required="true">
    <cfset variables.instance.tags = trim(arguments.tags) />
	<cfreturn this>
  </cffunction>
  
  <cffunction name="getTags" returnType="string" output="false" access="public">
    <cfreturn variables.instance.tags />
  </cffunction>

  <cffunction name="setDoCache" output="false" access="public">
    <cfargument name="doCache" required="true">
	<cfif isNumeric(arguments.doCache)>
    <cfset variables.instance.doCache = arguments.doCache />
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getDoCache" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.doCache />
  </cffunction>

  <cffunction name="setMobileExclude" output="false" access="public">
    <cfargument name="mobileExclude" required="true">
	<cfif isNumeric(arguments.mobileExclude)>
    <cfset variables.instance.mobileExclude = arguments.mobileExclude />
	</cfif>
	<cfreturn this>
  </cffunction>

  <cffunction name="getMobileExclude" returnType="numeric" output="false" access="public">
    <cfreturn variables.instance.mobileExclude />
  </cffunction>

  <cffunction name="setCreated" output="false" access="public">
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
	<cfreturn this>
  </cffunction>

  <cffunction name="getCreated" returnType="string" output="false" access="public">
    <cfreturn variables.instance.created />
  </cffunction>

 <cffunction name="getExtendedData" returntype="any" output="false" access="public">
	<cfif not isObject(variables.instance.extendData)>
	<cfset variables.instance.extendData=variables.configBean.getClassExtensionManager().getExtendedData(baseID:getcontentHistID(), type:getType(), subType:getSubType(), siteID:getSiteID())/>
	</cfif> 
	<cfreturn variables.instance.extendData />
 </cffunction>

 <cffunction name="purgeExtendedData" output="false" access="public">
	<cfset variables.instance.extendData=""/>
	<cfreturn this>
 </cffunction>
 
 <cffunction name="getExtendedAttribute" returnType="string" output="false" access="public">
 	<cfargument name="key" type="string" required="true">
	<cfargument name="useMuraDefault" type="boolean" required="true" default="false"> 
	
  	<cfreturn getExtendedData().getAttribute(arguments.key,arguments.useMuraDefault) />
  </cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
	<cfargument name="property"  type="string" required="true">
	<cfargument name="propertyValue" default="" >
	
	<cfset var extData =structNew() />
	<cfset var i = "">	
	
	<cfif structKeyExists(this,"set#property#")>
		<cfset evaluate("set#property#(arguments.propertyValue)") />
	<cfelse>
		<cfset extData=getExtendedData().getExtendSetDataByAttributeName(arguments.property)>
		<cfif not structIsEmpty(extData)>
			<cfset structAppend(variables.instance,extData.data,false)>	
			<cfloop list="#extData.extendSetID#" index="i">
				<cfif not listFind(variables.instance.extendSetID,i)>
					<cfset variables.instance.extendSetID=listAppend(variables.instance.extendSetID,i)>
				</cfif>
			</cfloop>
		</cfif>
			
		<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
		
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	
	<cfif structKeyExists(this,"get#property#")>
		<cfreturn evaluate("get#property#()") />
	<cfelseif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
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
	<cfreturn this>
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
	<cfreturn this>
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfset variables.displayRegions=structNew()>
	<cfreturn this>
</cffunction>

<cffunction name="setURLTitle" output="false" access="public">
    <cfargument name="URLTitle" required="true">
	<cfset variables.instance.URLTitle = trim(arguments.URLTitle) />
	<cfreturn this>
</cffunction>
  
<cffunction name="getURLTitle" returnType="string" output="false" access="public">
	<cfreturn variables.instance.URLTitle />
</cffunction>

<cffunction name="setHTMLTitle" output="false" access="public">
    <cfargument name="HTMLTitle" required="true">
  	<cfset variables.instance.HTMLTitle = trim(arguments.HTMLTitle) />
	<cfreturn this>
</cffunction>
  
<cffunction name="getHTMLTitle" returnType="string" output="false" access="public">
	<cfif len(variables.instance.HTMLTitle)>
		<cfreturn variables.instance.HTMLTitle />
	<cfelse>
		<cfreturn variables.instance.MenuTitle />
	</cfif>
</cffunction>

<cffunction name="setNewFile" output="false" access="public">
    <cfargument name="newFile" required="true">
	<cfset variables.instance.newFile = arguments.newFile />
	<cfreturn this>
</cffunction>
  
<cffunction name="getNewFile" returnType="any" output="false" access="public">
	<cfreturn variables.instance.newFile />
</cffunction>

<cffunction name="getKidsQuery" returnType="query" output="false" access="public">
	<cfargument name="aggregation" required="true" default="false">
	<cfreturn variables.contentManager.getKidsQuery(siteID:getSiteID(), parentID:getContentID(), sortBy:getSortBy(), sortDirection:getSortDirection(), aggregation=arguments.aggregation) />
</cffunction>

<cffunction name="getKidsIterator" returnType="any" output="false" access="public">
	<cfargument name="liveOnly" required="true" default="true">
	<cfargument name="aggregation" required="true" default="false">
	<cfset var q="" />
	<cfset var it=getServiceFactory().getBean("contentIterator").init(packageBy="active")>
	
	<cfif arguments.liveOnly>
		<cfset q=getKidsQuery(aggregation=arguments.aggregation) />
	<cfelse>
		<cfset q=variables.contentManager.getNest( parentID:getContentID(), siteID:getSiteID(), sortBy:getSortBy(), sortDirection:getSortDirection()) />
	</cfif>
	<cfset it.setQuery(q,getNextN())>
	
	<cfreturn it>
</cffunction>

<cffunction name="getVersionHistoryQuery" returnType="query" output="false" access="public">
	<cfreturn variables.contentManager.getHist(getContentID(), getSiteID()) />
</cffunction>

<cffunction name="getVersionHistoryIterator" returnType="any" output="false" access="public">
	<cfset var q=getVersionHistoryQuery() />
	<cfset var it=getServiceFactory().getBean("contentIterator").init(packageBy="version")>
	<cfset it.setQuery(q)>
	<cfreturn it>
</cffunction>

<cffunction name="getCategoriesQuery" returnType="query" output="false" access="public">
	<cfreturn variables.contentManager.getCategoriesByHistID(getContentHistID()) />
</cffunction>

<cffunction name="getCategoriesIterator" returnType="any" output="false" access="public">
	<cfset var q=getCategoriesQuery() />
	<cfset var it=getServiceFactory().getBean("categoryIterator").init()>
	<cfset it.setQuery(q)>
	<cfreturn it>
</cffunction>

<cffunction name="getRelatedContentQuery" returnType="query" output="false" access="public">
	<cfargument name="liveOnly" type="boolean" required="yes" default="false" />
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	
	<cfreturn variables.contentManager.getRelatedContent(getSiteID(), getContentHistID(), arguments.liveOnly, arguments.today) />
</cffunction>

<cffunction name="getRelatedContentIterator" returnType="any" output="false" access="public">
	<cfargument name="liveOnly" type="boolean" required="yes" default="false" />
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	
	<cfset var q=getRelatedContentQuery(arguments.liveOnly, arguments.today) />
	<cfset var it=getServiceFactory().getBean("contentIterator").init(packageBy="active")>
	<cfset it.setQuery(q)>
	<cfreturn it>
</cffunction>

<cffunction name="save" returnType="any" output="false" access="public">
	<cfset var kid="">
	<cfset var i="">
	<cfset setAllValues(variables.contentManager.save(this).getAllValues())>
	
	<cfif arrayLen(variables.kids)>
		<cfloop from="1" to="#arrayLen(variables.kids)#" index="i">
			<cfset kid=variables.kids[i]>
			<cfset kid.save()>
		</cfloop>
	</cfif>
	
	<cfset variables.kids=arrayNew(1)>
	
	<cfreturn this />
</cffunction>

<cffunction name="addChild" output="false">
	<cfargument name="child" hint="Instance of a contentBean">
	<cfset arguments.child.setSiteID(getSiteID())>
	<cfset arguments.child.setParentID(getContentID())>
	<cfset arguments.child.setModuleID(getModuleID())>
	<cfset arrayAppend(variables.kids,arguments.child)>	
	<cfreturn this>
</cffunction>

<cffunction name="addDisplayObject" output="false">
	<cfargument name="regionID">
	<cfargument name="object">
	<cfargument name="objectID">
	<cfargument name="name">
	<cfargument name="params">
	<cfset var rs=getDisplayRegion(arguments.regionID)>
	<cfset var rows=0>
	
	<cfif not hasDisplayObject(argumentCollection=arguments)>
		<cfset queryAddRow(rs,1)/>
		<cfset rows =rs.recordcount />
		<cfset querysetcell(rs,"objectid",arguments.objectID,rows)/>
		<cfset querysetcell(rs,"object",arguments.object,rows)/>
		<cfset querysetcell(rs,"name",arguments.name,rows)/>
		<cfset querysetcell(rs,"params",arguments.params,rows)/>	
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="removeDisplayObject" output="false">
	<cfargument name="regionID">
	<cfargument name="object">
	<cfargument name="objectID">
	<cfset var rs=getDisplayRegion(arguments.regionID)>
	<cfset var rows=0>
	
	<cfif hasDisplayObject(argumentCollection=arguments)>
		<cfquery name="variables.displayRegions.objectlist#arguments.regionID#" dbtype="query">
		select * from rs where
		not (objectID='#arguments.objectID#'
		and object='#arguments.object#')
		</cfquery>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="hasDisplayObject" output="false" returntype="boolean">
	<cfargument name="regionID">
	<cfargument name="object">
	<cfargument name="objectID">
	<cfset var rs=getDisplayRegion(arguments.regionID)>
	
	<cfquery name="rs" dbtype="query">
		select * from rs where
		objectID='#arguments.objectID#'
		and object='#arguments.object#'
	</cfquery>
	
	<cfreturn rs.recordcount>
</cffunction>
	
<cffunction name="getDisplayRegion" output="false" access="public" returntype="any">
	<cfargument name="regionID">
	<cfset var rs="">
	<cfif not structKeyExists(variables.displayRegions,"objectlist#arguments.regionID#")>
		<cfset variables.displayRegions["objectlist#arguments.regionID#"]=variables.contentManager.getRegionObjects(getContentHistID(), getSiteID(), arguments.regionID)>
	</cfif>
	
	<cfreturn variables.displayRegions["objectlist#arguments.regionID#"]>	
</cffunction>

<cffunction name="deleteVersion" returnType="any" output="false" access="public">
	<cfif not getActive()>
		<cfset variables.contentManager.delete(getAllValues()) />
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="deleteVersionHistory" output="false" access="public">
	<cfset variables.contentManager.deleteHistAll(getAllValues()) />
</cffunction>

<cffunction name="delete" output="false" access="public">
	<cfset variables.contentManager.deleteAll(getAllValues()) />
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfset var response="">
	
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=getSiteID()>
	</cfif>
	
	<cfset response=variables.contentManager.read(argumentCollection=arguments)>

	<cfif isArray(response)>
		<cfset setAllValues(response[1].getAllValues())>
		<cfreturn response>
	<cfelse>
		<cfset setAllValues(response.getAllValues())>
		<cfreturn this>
	</cfif>
</cffunction>

<cffunction name="getStats" returnType="any" output="false" access="public">
	<cfset var statsBean=variables.contentManager.getStatsBean() />
	<cfset statsBean.setSiteID(getSiteID())>
	<cfset statsBean.setContentID(getContentID())>
	<cfset statsBean.load()>
	<cfreturn statsBean>
</cffunction>

<cffunction name="getCommentsQuery" returnType="query" output="false" access="public">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfreturn variables.contentManager.readComments(getContentID(), getSiteID(), arguments.isEditor, arguments.sortOrder, arguments.parentID) />
</cffunction>

<cffunction name="getCommentsIterator" returnType="any" output="false" access="public">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfset var q=getCommentsQuery(arguments.isEditor, arguments.sortOrder, arguments.parentID) />
	<cfset var it=getBean("contentCommentIterator").init()>
	<cfset it.setQuery(q)>
	<cfreturn it />
</cffunction>

<cffunction name="getParent" output="false" returntype="any">
	<cfif getContentID() neq '00000000000000000000000000000000001'>
		<cfreturn variables.contentManager.read(contentID=getParentID(),siteID=getSiteID())>
	<cfelse>
		<cfthrow message="Parent content does not exist.">
	</cfif>
</cffunction>

<cffunction name="getCrumbArray" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfargument name="setInheritance" required="true" type="boolean" default="false">
	<cfreturn variables.contentManager.getCrumbList(contentID=getContentID(), siteID=getSiteID(), setInheritance=arguments.setInheritance, path=getPath(), sort=arguments.sort)>
</cffunction>

<cffunction name="getCrumbIterator" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfargument name="setInheritance" required="true" type="boolean" default="false">
	<cfset var a=getCrumbArray(setInheritance=arguments.setInheritance,sort=arguments.sort)>
	<cfset var it=getBean("contentIterator").init()>
	<cfset it.setArray(a)>
	<cfreturn it>
</cffunction>

<cffunction name="hasDrafts" returntype="any" access="public" output="false">
	<cfreturn variables.contentManager.getHasDrafts(getContentID(),getSiteID()) />
</cffunction>

<cffunction name="getURL" output="false">
	<cfargument name="querystring" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="showMeta" type="string" required="true" default="0">
	 <cfreturn variables.contentManager.getURL(this, arguments.queryString,arguments.complete, arguments.showMeta)>
</cffunction>		

<cffunction name="getEditUrl" access="public" returntype="string" output="false">
	<cfargument name="compactDisplay" type="any" required="true" default="false"/>
	<cfset var returnStr="">
	<cfset var topID="00000000000000000000000000000000001">
	
	<cfif listFindNoCase("Form,Component", getType())>
		<cfset topID=getModuleID()>
	</cfif>
	
	<cfset returnStr= "#variables.configBean.getContext()#/admin/?fuseaction=cArch.edit&contentHistId=#getContentHistId()#&contentId=#getContentId()#&Type=#getType()#&siteId=#getSiteId()#&topId=#topID#&parentId=#arguments.contentBean.getParentId()#&moduleId=#getModuleId()#&compactDisplay=#arguments.compactdisplay#" >
	
	<cfreturn returnStr>
</cffunction> 

<cffunction name="hasParent" output="false">
	<cfreturn listLen(getPath()) gt 1>
</cffunction>

<cffunction name="getIsOnDisplay" output="false">
<cfreturn getDisplay() eq 1 or 
			(
				getDisplay() eq 2 and getDisplayStart() lte now()
				AND (getDisplayStop() gte now() or getDisplayStop() eq "")
			)
			and (listFind("Page,Portal,Gallery,File,Calendar,Link,Form",getType()) or listFind(getModuleAssign(),'00000000000000000000000000000000000'))>
</cffunction>

<cffunction name="setChangesetID" output="false" access="public">
    <cfargument name="changesetID" type="string" required="true">
    <cfset variables.instance.changesetID = trim(arguments.changesetID) />
	<cfreturn this>
</cffunction>

<cffunction name="getChangesetID" returnType="string" output="false" access="public">
    <cfreturn variables.instance.changesetID />
</cffunction>

<cffunction name="getImageURL" output="false">
	<cfargument name="size" required="true" default="Large">
	<cfargument name="direct" default="true"/>
	<cfargument name="complete" default="false"/>
	<cfargument name="height" default=""/>
	<cfargument name="width" default=""/>
	<cfset arguments.bean=this>
	<cfreturn variables.contentManager.getImageURL(argumentCollection=arguments)>
</cffunction>

</cfcomponent>