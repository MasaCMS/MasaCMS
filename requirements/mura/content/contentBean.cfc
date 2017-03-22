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
<cfcomponent extends="mura.bean.beanExtendable" entityName="content" table="tcontent" output="false" hint="This provides content functionality">

<cfproperty name="contentHistID" fieldtype="id" type="string" default="" required="true" comparable="false"/>
<cfproperty name="contentID" type="string" default="" required="true" comparable="false"/>
<cfproperty name="kids" fieldtype="one-to-many" cfc="content" nested=true fkcolumn="contentid" orderby="created asc" cascade="delete"/>
<cfproperty name="parent" fieldtype="many-to-one" cfc="content" fkcolumn="parentid"/>
<cfproperty name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID" />
<cfproperty name="categoryAssignments" fieldtype="one-to-many" cfc="contentCategoryAssign" loadkey="contenthistid"/>
<cfproperty name="changeset" fieldtype="many-to-one" cfc="changeset" fkcolumn="changesetid"/>
<cfproperty name="comments" fieldtype="one-to-many" cfc="comment" fkcolumn="contentid"/>
<cfproperty name="stats" fieldtype="one-to-one" cfc="stats" fkcolumn="contentid" />
<cfproperty name="preserveID" type="string" default="" comparable="false"/>
<cfproperty name="active" type="numeric" default="0" required="true" comparable="false"/>
<cfproperty name="approved" type="numeric" default="0" required="true" comparable="false"/>
<cfproperty name="orderno" type="numeric" default="0" required="true" comparable="false"/>
<cfproperty name="metaDesc" type="string" default=""/>
<cfproperty name="metaKeyWords" type="string" default=""/>
<cfproperty name="displayStart" type="date" default=""/>
<cfproperty name="displayStop" type="date" default=""/>
<cfproperty name="body" type="string" default="" html="true"/>
<cfproperty name="title" type="string" default=""/>
<cfproperty name="menuTitle" type="string" default=""/>
<cfproperty name="URLTitle" type="string" default=""/>
<cfproperty name="HTMLTitle" type="string" default=""/>
<cfproperty name="filename" type="string" default=""/>
<cfproperty name="oldfilename" type="string" default=""/>
<cfproperty name="lastUpdate" type="date" default="" comparable="false"/>
<cfproperty name="display" type="numeric" default=""/>
<cfproperty name="type" type="string" default="Page" required="true" />
<cfproperty name="newfile" type="string" default=""/>
<cfproperty name="lastUpdateBy" type="string" default=""/>
<cfproperty name="lastUpdateByID" type="string" default="" comparable="false"/>
<cfproperty name="summary" type="string" default="" html="true"/>
<cfproperty name="siteID" type="string" default=""/>
<cfproperty name="moduleID" type="string" default="00000000000000000000000000000000000" required="true" />
<cfproperty name="isNav" type="numeric" default="1" required="true" />
<cfproperty name="restricted" type="numeric" default="0" required="true" />
<cfproperty name="target" type="string" default="_self" required="true" />
<cfproperty name="restrictGroups" type="string" default=""/>
<cfproperty name="template" type="string" default=""/>
<cfproperty name="childTemplate" type="string" default=""/>
<cfproperty name="responseMessage" type="string" default="" html="true" />
<cfproperty name="responseChart" type="numeric" default="0" required="true" />
<cfproperty name="responseSendTo" type="string" default=""/>
<cfproperty name="responseDisplayFields" type="string" default=""/>
<cfproperty name="moduleAssign" type="string" default=""/>
<cfproperty name="notes" type="string" default=""/>
<cfproperty name="inheritObjects" type="string" default="Inherit" required="true" />
<cfproperty name="isFeature" type="numeric" default="0" required="true" />
<cfproperty name="isNew" type="numeric" default="1" required="true" />
<cfproperty name="releaseDate" type="date" default=""/>
<cfproperty name="isLocked" type="numeric" default="0" required="true" />
<cfproperty name="nextN" type="numeric" default="10" required="true" />
<cfproperty name="sortBy" type="string" default="orderno" required="true"/>
<cfproperty name="sortDirection" type="string" default="asc" required="true" />
<cfproperty name="featureStart" type="date" default=""/>
<cfproperty name="featureStop" type="date" default=""/>
<cfproperty name="fileID" type="string" default=""/>
<cfproperty name="fileSize" type="any" default="0" />
<cfproperty name="fileExt" type="string" default=""/>
<cfproperty name="contentType" type="string" default=""/>
<cfproperty name="contentSubType" type="string" default=""/>
<cfproperty name="forceSSL" type="numeric" default="0" required="true" />
<cfproperty name="remoteURL" type="string" default=""/>
<cfproperty name="remoteID" type="string" default=""/>
<cfproperty name="remotePubDate" type="string" default=""/>
<cfproperty name="remoteSource" type="string" default=""/>
<cfproperty name="remoteSourceURL" type="string" default=""/>
<cfproperty name="credits" type="string" default=""/>
<cfproperty name="audience" type="string" default=""/>
<cfproperty name="keyPoints" type="string" default=""/>
<cfproperty name="searchExclude" type="numeric" default="0" required="true" />
<cfproperty name="displayTitle" type="numeric" default="1" required="true" />
<cfproperty name="path" type="string" default=""/>
<cfproperty name="tags" type="string" default=""/>
<cfproperty name="doCache" type="numeric" default="1" required="true" />
<cfproperty name="created" type="date" default=""/>
<cfproperty name="mobileExclude" type="numeric" default="0" required="true" />
<cfproperty name="changesetID" type="string" default="" comparable="false"/>
<cfproperty name="imageSize" type="string" default="small" required="true" />
<cfproperty name="imageHeight" type="string" default="AUTO" required="true" />
<cfproperty name="imageWidth" type="string" default="AUTO" required="true" />
<cfproperty name="majorVersion" type="numeric" default="0" required="true" />
<cfproperty name="minorVersion" type="numeric" default="0" required="true" />
<cfproperty name="expires" type="date" default=""/>
<cfproperty name="assocFilename" type="string" default=""/>
<cfproperty name="displayInterval" type="any" default="Daily" />
<cfproperty name="requestID" type="string" default="" comparable="false"/>
<cfproperty name="approvalStatus" type="string" default=""/>
<cfproperty name="approvalGroupID" type="string" default="" comparable="false"/>
<cfproperty name="approvalChainOverride" type="boolean" default="false" required="true" comparable="false"/>
<cfproperty name="relatedContentSetData" type="any"/>

<cfset variables.primaryKey = 'contenthistid'>
<cfset variables.entityName = 'content'>
<cfset variables.instanceName= 'title'>

<cffunction name="init" output="false">

	<cfset super.init(argumentCollection=arguments)>

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
	<cfset variables.instance.URLTitle="" />
	<cfset variables.instance.HTMLTitle="" />
	<cfset variables.instance.Filename = "" />
	<cfset variables.instance.OldFilename = "" />
	<cfset variables.instance.LastUpdate = now() />
	<cfset variables.instance.Display = 1 />
	<cfset variables.instance.ParentID = "" />
	<cfset variables.instance.newFile = "" />
	<cfset variables.instance.type = "Page" />
	<cfset variables.instance.subType = "Default" />

	<cfset var sessionData=getSession()>
	<cfif isDefined("sessionData.mura") and sessionData.mura.isLoggedIn>
		<cfset variables.instance.LastUpdateBy = left(sessionData.mura.fname & " " & sessionData.mura.lname,50) />
		<cfset variables.instance.LastUpdateByID = sessionData.mura.userID />
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
	<cfset variables.instance.childTemplate=""/>
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
	<cfset variables.instance.doCache = 1 />
	<cfset variables.instance.created = now() />
	<cfset variables.instance.mobileExclude = 0 />
	<cfset variables.instance.changesetID = "" />
	<cfset variables.instance.tcontent_id = 0 />
	<cfset variables.instance.imageSize = "small" />
	<cfset variables.instance.imageHeight = "AUTO" />
	<cfset variables.instance.imageWidth = "AUTO" />
	<cfset variables.instance.majorVersion = 0 />
	<cfset variables.instance.minorVersion = 0 />
	<cfset variables.instance.expires = "" />
	<cfset variables.instance.assocFilename = "" />
	<cfset variables.instance.displayInterval = "Daily" />
	<cfset variables.instance.errors=structnew() />
	<cfset variables.instance.categoryID = "" />
	<cfset variables.instance.requestID = "" />
	<cfset variables.instance.approvalStatus = "" />
	<cfset variables.instance.approvalGroupID = "" />
	<cfset variables.instance.approvalChainOverride = false />
	<cfset variables.instance.approvingChainRequest = false />
	<cfset variables.instance.relatedContentSetData = "" />
	<cfset variables.instance.objectParams={}>

	<cfset variables.displayRegions = structNew()>

	<cfreturn this />
</cffunction>

<cffunction name="setContentManager">
	<cfargument name="contentManager">
	<cfset variables.contentManager=arguments.contentManager>
	<cfreturn this>
</cffunction>

<cffunction name="setConfigBean">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="setSettingsManager">
	<cfargument name="settingsManager">
	<cfset variables.settingsManager=arguments.settingsManager>
	<cfreturn settingsManager>
</cffunction>

<cffunction name="set" output="false">
   	<cfargument name="property" required="true">
	<cfargument name="propertyValue">

	<cfif not isDefined('arguments.content')>
		<cfif isSimpleValue(arguments.property)>
			<cfreturn setValue(argumentCollection=arguments)>
		</cfif>

		<cfset arguments.content=arguments.property>
	</cfif>

	<cfset var starthour = 0 />
	<cfset var stophour = 0 />
	<cfset var pageNum = 2 />
	<cfset var featurestophour="" />
	<cfset var featurestarthour="" />
	<cfset var releasehour="" />
	<cfset var expireshour="" />
	<cfset var prop="" />

	<cfif isQuery(arguments.content) and arguments.content.recordcount>
		<cfloop list="#arguments.content.columnlist#" index="prop">
			<cfset setValue(prop,arguments.content[prop][1]) />
		</cfloop>

	<cfelseif isStruct(arguments.content)>
		<cfloop collection="#arguments.content#" item="prop">
			<cfset setValue(prop,arguments.content[prop]) />
		</cfloop>

		<cfif variables.instance.display eq 2
			AND isDate(variables.instance.displayStart)>

			<cfif isdefined("arguments.content.starthour")
			and isdefined("arguments.content.startMinute")>

				<cfparam name="arguments.content.startDayPart" default="">

				<cfif arguments.content.startdaypart eq "PM">
					<cfset starthour = arguments.content.starthour + 12>

					<cfif starthour eq 24>
						<cfset starthour = 12>
					</cfif>
				<cfelseif arguments.content.startdaypart eq "AM">
					<cfset starthour = arguments.content.starthour>

					<cfif starthour eq 12>
						<cfset starthour = 0>
					</cfif>
				<cfelse>
					<cfset starthour = arguments.content.starthour>
				</cfif>

				<cfset setDisplayStart(createDateTime(year(variables.instance.displayStart), month(variables.instance.displayStart), day(variables.instance.displayStart),starthour, arguments.content.startMinute, "0"))>

			</cfif>
		<cfelseif variables.instance.display eq 2 >
			<cfset variables.instance.display=1 >
			<cfset variables.instance.displayStart="" >
			<cfset variables.instance.displayStop="" >
		</cfif>

		<cfif variables.instance.display eq 2
			AND isDate(variables.instance.displayStop)>

			<cfif isdefined("arguments.content.Stophour")
			and isdefined("arguments.content.StopMinute")>

			<cfparam name="arguments.content.stopDayPart" default="">

			<cfif arguments.content.stopdaypart eq "PM">
				<cfset stophour = arguments.content.stophour + 12>

				<cfif stophour eq 24>
					<cfset stophour = 12>
				</cfif>
			<cfelseif arguments.content.stopdaypart eq "AM">
				<cfset stophour = arguments.content.stophour>

				<cfif stophour eq 12>
					<cfset stophour = 0>
				</cfif>
			<cfelse>
				<cfset stophour = arguments.content.stophour>
			</cfif>

			<cfset setDisplayStop(createDateTime(year(variables.instance.displayStop), month(variables.instance.displayStop), day(variables.instance.displayStop),stophour, arguments.content.StopMinute, "0"))>

			</cfif>

		</cfif>

		<cfif variables.instance.isFeature eq 2
			AND isDate(variables.instance.featureStart)
			and isdefined("arguments.content.featurestarthour")
			and isdefined("arguments.content.featurestartMinute")>

			<cfparam name="arguments.content.featureStartDayPart" default="">

			<cfif arguments.content.featureStartdaypart eq "PM">
				<cfset featurestarthour = arguments.content.featurestarthour + 12>

				<cfif featurestarthour eq 24>
					<cfset featurestarthour = 12>
				</cfif>
			<cfelseif arguments.content.featureStartdaypart eq "AM">
				<cfset featurestarthour = arguments.content.featurestarthour>

				<cfif featurestarthour eq 12>
					<cfset featurestarthour = 0>
				</cfif>
			<cfelse>
				<cfset featurestarthour = arguments.content.featurestarthour>
			</cfif>

			<cfset setFeatureStart(createDateTime(year(variables.instance.featureStart), month(variables.instance.featureStart), day(variables.instance.featureStart),Featurestarthour, arguments.content.featurestartMinute, "0"))>
		</cfif>

		<cfif variables.instance.isFeature eq 2
			AND isDate(variables.instance.featureStop)
			and isdefined("arguments.content.featurestophour")
			and isdefined("arguments.content.featurestopMinute")>

			<cfparam name="arguments.content.featureStopDayPart" default="">

			<cfif arguments.content.featureStopdaypart eq "PM">
				<cfset featurestophour = arguments.content.featurestophour + 12>

				<cfif featurestophour eq 24>
					<cfset featurestophour = 12>
				</cfif>
			<cfelseif arguments.content.featureStopdaypart eq "AM">
				<cfset featurestophour = arguments.content.featurestophour>

				<cfif featurestophour eq 12>
					<cfset featurestophour = 0>
				</cfif>
			<cfelse>
				<cfset featurestophour = arguments.content.featurestophour>
			</cfif>

			<cfset setFeatureStop(createDateTime(year(variables.instance.featureStop), month(variables.instance.featureStop), day(variables.instance.featureStop),Featurestophour, arguments.content.featurestopMinute, "0"))>
		</cfif>

		<cfif isDate(variables.instance.releaseDate)>

			<cfif isdefined("arguments.content.releasehour")
			and isdefined("arguments.content.releaseMinute")>

				<cfparam name="arguments.content.releaseDayPart" default="">

				<cfif arguments.content.releasedaypart eq "PM">
					<cfset releasehour = arguments.content.releasehour + 12>

					<cfif releasehour eq 24>
						<cfset releasehour = 12>
					</cfif>
				<cfelseif arguments.content.releasedaypart eq "AM">
					<cfset releasehour = arguments.content.releasehour>

					<cfif releasehour eq 12>
						<cfset releasehour = 0>
					</cfif>
				<cfelse>
					<cfset releasehour = arguments.content.releasehour>
				</cfif>

				<cfset setReleaseDate(createDateTime(year(variables.instance.releaseDate), month(variables.instance.releaseDate), day(variables.instance.releaseDate), releasehour, arguments.content.releaseMinute, "0"))>

			</cfif>
		</cfif>

		<cfif isDate(variables.instance.expires)>

			<cfif isdefined("arguments.content.expireshour")
			and isdefined("arguments.content.expiresMinute")>

				<cfparam name="arguments.content.expiresDayPart" default="">

				<cfif arguments.content.expiresdaypart eq "PM">
					<cfset expireshour = arguments.content.expireshour + 12>

					<cfif expireshour eq 24>
						<cfset expireshour = 12>
					</cfif>
				<cfelseif arguments.content.expiresdaypart eq "AM">
					<cfset expireshour = arguments.content.expireshour>

					<cfif expireshour eq 12>
						<cfset expireshour = 0>
					</cfif>
				<cfelse>
					<cfset expireshour = arguments.content.expireshour>
				</cfif>

				<cfset setExpires(createDateTime(year(variables.instance.expires), month(variables.instance.expires), day(variables.instance.expires), expireshour, arguments.content.expiresMinute, "0"))>

			</cfif>
		</cfif>


		<cfif isDefined("sessionData.mura") and sessionData.mura.isLoggedIn>
			<cfset variables.instance.LastUpdateBy = left(sessionData.mura.fname & " " & sessionData.mura.lname,50) />
			<cfset variables.instance.LastUpdateByID = sessionData.mura.userID />
		<cfelse>
			<cfset variables.instance.LastUpdateBy = "" />
			<cfset variables.instance.LastUpdateByID = "" />
		</cfif>

	</cfif>

	<cfscript>
		variables.instance.statusid = getStatusID();
		variables.instance.status = getStatus();
		variables.instance.ishome = getIsHome();
		variables.instance.depth = getDepth();
	</cfscript>

	<cfreturn this />
</cffunction>

<cffunction name="validate" output="false">
	<cfset var extErrors=structNew() />

	<cfif len(variables.instance.siteID)>
		<cfset extErrors=variables.configBean.getClassExtensionManager().validateExtendedData(getAllValues())>
	</cfif>

	<cfset super.validate()>

	<cfif not structIsEmpty(extErrors)>
		<cfset structAppend(variables.instance.errors,extErrors)>
	</cfif>

	<cfif listFindNoCase('Form,Component',variables.instance.type)
		and variables.contentManager.doesLoadKeyExist(this,'title',variables.instance.title)>
			<cfset variables.instance.errors.titleconflict=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("sitemanager.titlenotunique")>
	</cfif>

	<cfif getValue('display') eq 2 and getDisplayConflicts().hasNext()>
		<cfset variables.instance.errors.displayconflict=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("sitemanager.displayconflict")>
	</cfif>

	<cfif variables.instance.isNew
		and listFindNoCase('File',variables.instance.type)
		and not (len(variables.instance.newfile) or len(variables.instance.fileID))>
			<cfset variables.instance.errors.filemissing=variables.settingsManager.getSite(variables.instance.siteID).getRBFactory().getKey("sitemanager.filemissing")>
	</cfif>

	<cfscript>
		var errorCheck={};
		var checknum=1;
		var checkfound=false;

		if(arrayLen(variables.instance.addObjects)){
			for(var obj in variables.instance.addObjects){
				errorCheck=obj.validate().getErrors();
				if(!structIsEmpty(errorCheck)){
					do{
						if( !structKeyExists(variables.instance.errors,obj.getEntityName() & checknum) ){
							variables.instance.errors[obj.getEntityName()  & checknum ]=errorCheck;
							checkfound=true;
						}
					} while (!checkfound);
				}

			}
		}
	</cfscript>

	<cfreturn this>
</cffunction>

<cffunction name="getAllValues" returntype="struct" output="false">
	<cfargument name="autocomplete" required="true" default="#variables.instance.extendAutoComplete#">
	<cfset var i="">
	<cfset var extData="">

	<cfif arguments.autocomplete>
		<cfset extData=getExtendedData().getAllExtendSetData()>
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
	</cfif>

	<cfset purgeExtendedData()>
	<cfset variables.displayRegions=structNew()>

	<cfreturn variables.instance />
</cffunction>

<cffunction name="getContentHistID" output="false">
    <cfif not len(variables.instance.ContentHistID)>
		<cfset variables.instance.ContentHistID = createUUID() />
	</cfif>
	<cfreturn variables.instance.ContentHistID />
</cffunction>

<cffunction name="getContentID" output="false">
    <cfif not len(variables.instance.contentid)>
		<cfset variables.instance.contentid = createUUID() />
	</cfif>
	<cfreturn variables.instance.contentid />
</cffunction>

<cffunction name="setDisplayStart" output="false">
    <cfargument name="DisplayStart" type="string" required="true">
	<cfset variables.instance.displayStart = parseDateArg(arguments.displayStart) />
	<cfreturn this>
</cffunction>

<cffunction name="setDisplaystop" output="false">
    <cfargument name="Displaystop" type="string" required="true">
	<cfset variables.instance.Displaystop = parseDateArg(arguments.Displaystop) />
	<cfreturn this>
</cffunction>

<cffunction name="setExpires" output="false">
    <cfargument name="expires" type="string" required="true">
	<cfset variables.instance.expires = parseDateArg(arguments.expires) />
	<cfreturn this>
</cffunction>

<cffunction name="setLastUpdate" output="false">
    <cfargument name="LastUpdate" type="string" required="true">
	<cfset variables.instance.LastUpdate = parseDateArg(arguments.LastUpdate) />
	<cfreturn this>
</cffunction>

<cffunction name="setType" output="false">
    <cfargument name="Type" type="string" required="true">

    <cfif arguments.type eq 'Portal'>
		<cfset arguments.type='Folder'>
	</cfif>

    <cfset arguments.Type=trim(arguments.Type)>

	<cfif len(arguments.Type) and variables.instance.Type neq arguments.Type and listFindNoCase('Page,Folder,Calendar,Gallery,File,Link,Form,Component,Variation,Module',arguments.type)>
		<cfset variables.instance.Type = arguments.Type />
		<cfset purgeExtendedData()>
		<cfif variables.instance.Type eq "Form">
			<cfset variables.instance.moduleID="00000000000000000000000000000000004">
			<cfif not isValid('uuid',variables.instance.ParentID)>
				<cfset variables.instance.ParentID="00000000000000000000000000000000004">
			</cfif>
		<cfelseif variables.instance.Type eq "Component">
			<cfset variables.instance.moduleID="00000000000000000000000000000000003">
			<cfif not isValid('uuid',variables.instance.ParentID)>
				<cfset variables.instance.ParentID="00000000000000000000000000000000003">
			</cfif>
		<cfelseif variables.instance.Type eq "Variation">
			<cfset variables.instance.moduleID="00000000000000000000000000000000099">
			<cfif not isValid('uuid',variables.instance.ParentID)>
				<cfset variables.instance.ParentID="00000000000000000000000000000000099">
			</cfif>
		</cfif>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="setTitle" output="false">
    <cfargument name="title" type="string" required="true">
   	<cfset arguments.title=trim(arguments.title)>

   	<cfif len(arguments.title)>
		<cfset variables.instance.title =arguments.title />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setFilename" output="false">
	<cfargument name="filename">
	<cfset variables.instance.filename=left(arguments.filename,255)>
	<cfreturn this>
</cffunction>

<cffunction name="setLastUpdateBy" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

<cffunction name="setReleaseDate" output="false">
    <cfargument name="releaseDate" type="string" required="true">
	<cfset variables.instance.releaseDate = parseDateArg(arguments.releaseDate) />
	<cfreturn this>
</cffunction>

<cffunction name="setNextN" output="false">
    <cfargument name="NextN" type="any" required="true">
	<cfif isNumeric(arguments.NextN)>
   		<cfset variables.instance.NextN = arguments.NextN />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setFeatureStop" output="false">
    <cfargument name="FeatureStop" type="string" required="true">
    <cfset variables.instance.FeatureStop = parseDateArg(arguments.FeatureStop) />
	<cfreturn this>
</cffunction>

<cffunction name="setFeatureStart" output="false">
    <cfargument name="FeatureStart" type="string" required="true">
	<cfset variables.instance.FeatureStart = parseDateArg(arguments.FeatureStart) />
	<cfreturn this>
</cffunction>

<cffunction name="setRemotePubDate" output="false">
    <cfargument name="RemotePubDate" type="string" required="true">
	<cfset variables.instance.RemotePubDate = parseDateArg(arguments.RemotePubDate) />
	<cfreturn this>
</cffunction>

<cffunction name="setDisplayTitle" output="false">
    <cfargument name="DisplayTitle" required="true">
	<cfif isNumeric(arguments.DisplayTitle)>
  	  <cfset variables.instance.DisplayTitle = arguments.DisplayTitle />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMajorVersion" output="false">
    <cfargument name="majorVersion" required="true">
	<cfif isNumeric(arguments.majorVersion)>
  	  <cfset variables.instance.majorVersion = arguments.majorVersion />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMinorVersion" output="false">
    <cfargument name="minorVersion" required="true">
	<cfif isNumeric(arguments.minorVersion)>
  	  <cfset variables.instance.minorVersion = arguments.minorVersion />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setDoCache" output="false">
    <cfargument name="doCache" required="true">
	<cfif isNumeric(arguments.doCache)>
    <cfset variables.instance.doCache = arguments.doCache />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setMobileExclude" output="false">
    <cfargument name="mobileExclude" required="true">
	<cfif isNumeric(arguments.mobileExclude)>
    <cfset variables.instance.mobileExclude = arguments.mobileExclude />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setCreated" output="false">
    <cfargument name="Created" type="string" required="true">
	<cfset variables.instance.Created = parseDateArg(arguments.Created) />
	<cfreturn this>
</cffunction>

<cffunction name="setImageSize" output="false">
	<cfargument name="imageSize">
	<cfif len(arguments.imageSize)>
		<cfset variables.instance.imageSize = arguments.imageSize>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getImageSize" output="false">
	<cfif variables.instance.imageSize eq "Custom"
	and variables.instance.ImageHeight eq "AUTO"
	and variables.instance.ImageWidth eq "AUTO">
  	  <cfreturn "small" />
	<cfelse>
		<cfreturn variables.instance.imageSize>
	</cfif>
</cffunction>

<cffunction name="setImageHeight" output="false">
    <cfargument name="ImageHeight" required="true">
	<cfif isNumeric(arguments.ImageHeight)>
  	  <cfset variables.instance.ImageHeight = arguments.ImageHeight />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getImageHeight" output="false">
	<cfif variables.instance.imageSize eq "Custom">
  	  <cfreturn variables.instance.ImageHeight />
	<cfelse>
		<cfreturn "AUTO">
	</cfif>
</cffunction>

<cffunction name="setImageWidth" output="false">
    <cfargument name="ImageWidth" required="true">
	<cfif isNumeric(arguments.ImageWidth)>
  	  <cfset variables.instance.ImageWidth = arguments.ImageWidth />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getImageWidth" output="false">
	<cfif variables.instance.imageSize eq "Custom">
  	  <cfreturn variables.instance.ImageWidth />
	<cfelse>
		<cfreturn "AUTO">
	</cfif>
</cffunction>

<cffunction name="setTarget" output="false">
    <cfargument name="target" type="string" default="_self">
	<cfif len(arguments.target)>
		<cfset variables.instance.target=arguments.target>
	</cfif>
	<cfreturn this>
</cffunction>

<!--- for variations --->
<cffunction name="getInitJS" output="false">
	<cfreturn variables.instance.responseMessage>
</cffunction>

<cffunction name="setInitJS" output="false">
	<cfargument name="initjs">
	<cfset variables.instance.responseMessage=arguments.initjs>
	<cfreturn this>
</cffunction>
<!--- --->

<cffunction name="getDisplayStart" output="false">
	<cfargument name="timezone" default="">

	<cfif len(arguments.timezone) and isDate(variables.instance.displaystart)>
		<cfreturn convertTimezone(datetime=variables.instance.displaystart,to=arguments.timezone)>
	<cfelse>
		<cfreturn variables.instance.displaystart>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="getDisplayStop" output="false">
	<cfargument name="timezone" default="">

	<cfif len(arguments.timezone) and isDate(variables.instance.displaystop)>
		<cfreturn convertTimezone(datetime=variables.instance.displaystop,to=arguments.timezone)>
	<cfelse>
		<cfreturn variables.instance.displaystop>
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="setDisplayList" output="false">
	<cfargument name="displayList">
	<cfset variables.instance.responseDisplayFields=arguments.displayList>
	<cfreturn this>
</cffunction>

<cffunction name="getDisplayList" output="false">
	<cfif not len(variables.instance.responseDisplayFields)>
		<cfreturn "Image,Date,Title,Summary,Credits">
	<cfelse>
		<cfreturn variables.instance.responseDisplayFields>
	</cfif>
</cffunction>

<cffunction name="setDisplayInterval" output="false">
	<cfargument name="displayInterval">

	<cfif isJSON(arguments.displayInterval)>
		<cfset arguments.displayInterval=deserializeJSON(arguments.displayInterval)>
	</cfif>

	<cfif not isSimpleValue(arguments.displayInterval)>

		<cfif isValid('component',arguments.displayInterval)>
			<cfset arguments.displayInterval=arguments.displayInterval.getAllValues()>
		<cfelseif isdefined('arguments.displayInterval.endon')>
			<cfset arguments.displayInterval.endon=parseDateArg(arguments.displayInterval.endon)>
		</cfif>

		<cfif isDefined('arguments.displayInterval.end')>
			<cfif arguments.displayInterval.end eq 'on'
			and isDefined('arguments.displayInterval.endon')
			and isDate(arguments.displayInterval.endon)>
				<cfif not isDate(getValue('displayStop'))>
					<cfset setValue('displayStop',arguments.displayInterval.endon)>
				<cfelseif dateFormat(getValue('displayStop'),'yyyymmdd') neq dateFormat(arguments.displayInterval.endon,'yyyymmdd')>
					<cfset var current=getValue('displayStop')>
					<cfif isDate(current)>
						<cfset setValue('displayStop',createDateTime(year(arguments.displayInterval.endon), month(arguments.displayInterval.endon), day(arguments.displayInterval.endon), hour(current), minute(current), 0))>
					<cfelse>
						<cfset setValue('displayStop',arguments.displayInterval.endon)>
					</cfif>
				</cfif>
			<cfelseif arguments.displayInterval.end eq 'after'
				and isDefined('arguments.displayInterval.endafter')
				and isNumeric(arguments.displayInterval.endafter)
				or arguments.displayInterval.end eq 'never'>
				<cfset setValue('displayStop',dateAdd('yyyy',100,now()))>
			</cfif>
		</cfif>

		<cfif isDefined('arguments.displayInterval.end') and arguments.displayInterval.end eq 'on'
			and (!isDefined('arguments.displayInterval.endon') or !isDate(arguments.displayInterval.endon))>
			<cfdump var="#getValue('displayStart')#">
			<cfdump var="#arguments#">
			<cfset setValue('displayStop',dateAdd('yyyy',100,now()))>
			<cfset arguments.displayInterval.endon='never'>
		</cfif>

		<cfset arguments.displayInterval=serializeJSON(arguments.displayInterval)>
	</cfif>

	<cfset variables.instance.displayInterval=arguments.displayInterval>
	<cfreturn this>
</cffunction>

<cffunction name="getDisplayIntervalDesc" output="false">
	<cfargument name="showTitle" default="true">
	<cfreturn getBean('settingsManager').getSite(getValue('siteid')).getContentRenderer().renderIntervalDesc(content=this,showTitle=arguments.showTitle)>
</cffunction>

<cffunction name="getDisplayInterval" output="false">
	<cfargument name="serialize" default="false">

	<cfif not arguments.serialize>
		<cfreturn getBean('contentDisplayInterval').set(getBean('contentIntervalManager').deserializeInterval(
			interval=variables.instance.displayInterval,
			displayStart=getValue('displayStart'),
			displayStop=getValue('displayStop')
		)).setContent(this)>
	<cfelse>
		<cfreturn variables.instance.displayInterval>
	</cfif>

</cffunction>

<cffunction name="getDisplayConflicts" output="false">
	<cfreturn getBean('contentIntervalManager').findConflicts(this)>
</cffunction>

<cffunction name="getAvailableDisplayList" output="false">
	<cfset var returnList="">
	<cfset var i=0>
	<cfset var finder=0>
	<cfset var rsExtend=variables.configBean.getClassExtensionManager().getExtendedAttributeList(variables.instance.siteID,"tcontent")>

	<cfif variables.instance.type neq "Gallery">
		<cfset returnList="Date,Title,Image,Summary,Body,ReadMore,Credits,Comments,Tags,Rating">
	<cfelse>
		<cfset returnList="Date,Title,Image,Summary,ReadMore,Credits,Comments,Tags,Rating">
	</cfif>

	<cfif rsExtend.recordcount>
		<cfquery name="rsExtend" dbType="query">
			select attribute from rsExtend
			group by attribute
			order by attribute
		</cfquery>
		<cfset returnList=returnList & "," & valueList(rsExtend.attribute)>
	</cfif>

	<cfloop list="#variables.instance.responseDisplayFields#" index="i">
		<cfset finder=listFindNoCase(returnList,i)>
		<cfif finder>
			<cfset returnList=listDeleteAt(returnList,finder)>
		</cfif>
	</cfloop>
	<cfreturn returnList>
</cffunction>

<cffunction name="removeCategory" output="false">
	<cfargument name="categoryID"  required="true" default="" hint="only use when not using name"/>
	<cfargument name="name"  required="true" default="" hint="only use when not using categoryid"/>
	<cfset setCategory(arguments.categoryid,'')>
	<cfreturn this>
</cffunction>

<cffunction name="setCategory" output="false">
	<cfargument name="categoryID"  required="true" default="" hint="only use when not using name"/>
	<cfargument name="membership"  required="true" default="0"/>
	<cfargument name="featureStart"  required="true" default=""/>
	<cfargument name="featureStop"  required="true" default=""/>
	<cfargument name="name"  required="true" default="" hint="only use when not using categoryid"/>

	<cfif len(arguments.name)>
		<cfset arguments.categoryid=getBean('category').loadBy(name=arguments.name,siteid=getValue('siteid')).getCategoryID()>
	<cfelseif len(arguments.categoryid) and not isValid('uuid',arguments.categoryid)>
		<cfset arguments.categoryid=getBean('category').loadBy(name=arguments.categoryid,siteid=getValue('siteid')).getCategoryID()>
	</cfif>

	<cfif isDefined('arguments.isFeature')>
		<cfset arguments.membership=arguments.isFeature>
	</cfif>

	<cfset var catTrim=replace(arguments.categoryID,'-','','ALL')>

	<cfset variables.instance["categoryAssign#catTrim#"]=arguments.membership />

	<cfif isNumeric(arguments.membership)>
		<cfif not listFind(variables.instance.categoryID,arguments.categoryID)>
			<cfset variables.instance.categoryID=listAppend(variables.instance.categoryID,arguments.categoryID)>
		</cfif>
	<cfelse>
		<cfset var catPOS=listFind(variables.instance.categoryID,arguments.categoryID)>
		<cfif catPOS>
			<cfset variables.instance.categoryID=listDeleteAt(variables.instance.categoryID,catPOS)>
		</cfif>
	</cfif>

	<cfif arguments.membership eq "2">
		<cfif isdate(arguments.featureStart)>
			<cfset variables.instance['featureStart#catTrim#']=arguments.featureStart />
			<cfset variables.instance['startDayPart#catTrim#']=timeFormat(arguments.featureStart,"tt") />
			<cfset variables.instance['starthour#catTrim#']=hour(arguments.featureStart) />
			<cfif variables.instance['startDayPart#catTrim#'] eq 'pm'>
				<cfset variables.instance['starthour#catTrim#']=variables.instance['starthour#catTrim#']-12>
			</cfif>
			<cfset variables.instance['startMinute#catTrim#']=minute(arguments.featureStart) />
		<cfelse>
			<cfset variables.instance["categoryAssign#catTrim#"]=1 />
		</cfif>
		<cfif isdate(arguments.featureStop)>
			<cfset variables.instance['featureStop#catTrim#']=arguments.featureStop />
			<cfset variables.instance['stopDayPart#catTrim#']=timeFormat(arguments.featureStop,"tt") />
			<cfset variables.instance['stophour#catTrim#']=hour(arguments.featureStop) />
			<cfif variables.instance['stopDayPart#catTrim#'] eq 'pm'>
				<cfset variables.instance['stophour#catTrim#']=variables.instance['stophour#catTrim#']-12>
			</cfif>
			<cfset variables.instance['stopMinute#catTrim#']=minute(arguments.featureStop) />
		<cfelse>
			<cfset variables.instance['featureStop#catTrim#']="" />
			<cfset variables.instance['stopDayPart#catTrim#']="" />
			<cfset variables.instance['stophour#catTrim#']="" />
			<cfset variables.instance['stopMinute#catTrim#']="" />
		</cfif>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setCategories" output="false">
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

<cffunction name="setAllValues" output="false">
	<cfargument name="instance">
	<cfset super.setAllValues(argumentCollection=arguments)>
	<cfset variables.displayRegions=structNew()>
	<cfreturn this>
</cffunction>

<cffunction name="getHTMLTitle" output="false">
	<cfif len(variables.instance.HTMLTitle)>
		<cfreturn variables.instance.HTMLTitle />
	<cfelse>
		<cfreturn variables.instance.MenuTitle />
	</cfif>
</cffunction>

<cffunction name="getKidsQuery" output="false">
	<cfargument name="aggregation" required="true" default="false">
	<cfargument name="applyPermFilter" required="true" default="false">
	<cfargument name="size" required="true" default="0">
	<cfargument name="sortBy" required="true" default="#getValue('sortBy')#">
	<cfargument name="sortDirection" required="true" default="#getValue('sortDirection')#">
	<cfargument name="nextN" required="true" default="#getValue('nextN')#">
	<cfset arguments.parentid=getContentID()>
	<cfset arguments.siteid=getValue('siteid')>
	<cfreturn variables.contentManager.getKidsQuery(argumentCollection=arguments) />
</cffunction>

<cffunction name="getKidsIterator" output="false">
	<cfargument name="liveOnly" required="true" default="true">
	<cfargument name="aggregation" required="true" default="false">
	<cfargument name="applyPermFilter" required="true" default="false">
	<cfargument name="size" required="true" default="0">
	<cfargument name="sortBy" required="true" default="#getValue('sortBy')#">
	<cfargument name="sortDirection" required="true" default="#getValue('sortDirection')#">
	<cfargument name="nextN" required="true" default="#getValue('nextN')#">

	<cfset var q="" />
	<cfset var it=getBean("contentIterator")>

	<cfif arguments.liveOnly>
		<cfset q=getKidsQuery(argumentCollection=arguments) />
	<cfelse>
		<cfset arguments.parentid=getContentID()>
		<cfset arguments.siteid=getValue('siteid')>
		<cfset q=variables.contentManager.getNest(argumentCollection=arguments) />
	</cfif>
	<cfset it.setQuery(q,variables.instance.nextn)>

	<cfreturn it>
</cffunction>

<cffunction name="getEventsQuery" output="false">
	<cfif getValue('type') neq 'Calendar'>
		<cfthrow message="The method is only for calendars">
	</cfif>
	<cfset arguments.calendarid=getValue('contentid')>
	<cfset arguments.siteid=getValue('siteid')>
	<cfreturn getBean('$')
		.init(getValue('siteid'))
		.getCalendarUtility()
		.getCalendarItems(argumentCollection=arguments)>
</cffunction>

<cffunction name="getEventsIterator">
	<cfscript>
		var q = getEventsQuery(argumentCollection=arguments);
		var it = getBean('contentIterator').init();
		it.setQuery(q);
		return it;
	</cfscript>
</cffunction>

<cffunction name="getKidsCategoryQuery" output="false">
	<cfargument name="siteid" default="#variables.instance.siteID#">
	<cfargument name="parentid" default="#getContentID()#">
	<cfargument name="categoryid" default="">
	<cfargument name="categorypathid" default="">
	<cfreturn variables.contentManager.getCategoriesByParentID(argumentCollection=arguments) />
</cffunction>

<cffunction name="getKidsCategoryIterator">
	<cfscript>
		var q = getKidsCategoryQuery(argumentCollection=arguments);
		var it = getBean('categoryIterator').init();
		it.setQuery(q);
		return it;
	</cfscript>
</cffunction>

<cffunction name="getVersionHistoryQuery" output="false">
	<cfreturn variables.contentManager.getHist(getContentID(), variables.instance.siteID) />
</cffunction>

<cffunction name="getVersionHistoryIterator" output="false">
	<cfset var q=getVersionHistoryQuery() />
	<cfset var it=getBean("contentIterator")>
	<cfset it.setQuery(q)>
	<cfreturn it>
</cffunction>

<cffunction name="getCategoriesQuery" output="false">
	<cfreturn variables.contentManager.getCategoriesByHistID(getContentHistID()) />
</cffunction>

<cffunction name="getCategoriesIterator" output="false">
	<cfset var q=getCategoriesQuery() />
	<cfset var it=getBean("categoryIterator").init()>
	<cfset it.setQuery(q)>
	<cfreturn it>
</cffunction>

<cffunction name="getRelatedContentQuery" output="false">
	<cfargument name="liveOnly" type="boolean" required="yes" default="true" />
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	<cfargument name="sortBy" type="string" default="orderno">
	<cfargument name="sortDirection" type="string" default="asc">
	<cfargument name="relatedContentSetID" type="string" default="">
	<cfargument name="name" type="string" default="">
	<cfargument name="reverse" type="boolean" default="false">
	<cfargument name="navOnly" type="boolean" required="yes" default="false" />

	<cfreturn variables.contentManager.getRelatedContent(variables.instance.siteID, getContentHistID(), arguments.liveOnly, arguments.today, arguments.sortBy, arguments.sortDirection, arguments.relatedContentSetID, arguments.name, arguments.reverse, getContentID(),arguments.navOnly) />
</cffunction>

<cffunction name="getRelatedContentIterator" output="false">
	<cfargument name="liveOnly" type="boolean" required="yes" default="true" />
	<cfargument name="today" type="date" required="yes" default="#now()#" />
	<cfargument name="sortBy" type="string" default="orderno" >
	<cfargument name="sortDirection" type="string" default="asc">
	<cfargument name="relatedContentSetID" type="string" default="">
	<cfargument name="name" type="string" default="">
	<cfargument name="reverse" type="boolean" default="false">
	<cfargument name="navOnly" type="boolean" required="yes" default="false" />

	<cfset var q=getRelatedContentQuery(argumentCollection=arguments) />
	<cfset var it=getBean("contentIterator")>
	<cfset it.setQuery(q)>
	<cfreturn it>
</cffunction>

<cffunction name="save" output="false">
	<cfset var obj="">
	<cfset var i="">
	<cfset setAllValues(variables.contentManager.save(this).getAllValues())>

	<cfreturn this />
</cffunction>

<cffunction name="addObject" output="false">
	<cfargument name="obj" hint="Instance of a contentBean">
	<cfset arguments.obj.setSiteID(variables.instance.siteID)>
	<cfset arguments.obj.setContentID(getContentID())>
	<cfset arguments.obj.setContentHistID(getContentHistID())>
	<cfset arguments.obj.setModuleID(variables.instance.moduleID)>
	<cfset arrayAppend(variables.instance.addObjects,arguments.obj)>
	<cfreturn this>
</cffunction>

<cffunction name="addChild" output="false">
	<cfargument name="child" hint="Instance of a contentBean">
	<cfset arguments.child.setSiteID(variables.instance.siteID)>
	<cfset arguments.child.setParentID(getContentID())>
	<cfset arguments.child.setModuleID(variables.instance.moduleID)>
	<cfset arrayAppend(variables.instance.addObjects,arguments.child)>
	<cfreturn this>
</cffunction>

<cffunction name="setObjectParams" output="false" hint="This is used when content nodes are configurable as display objects">
	<cfargument name="objectParams">

	<cfif isSimpleValue(arguments.objectParams) and len(arguments.objectParams) and isJSON(arguments.objectParams)>
		<cfset var val=deserializeJSON(arguments.objectParams)>

		<cfif isStruct(val)>
			<cfset variables.instance.objectParams=val>
		</cfif>
	<cfelseif not isSimpleValue(arguments.objectParams)>
		<cfset variables.instance.objectParams=arguments.objectParams>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getObjectParams"  output="false" hint="This is used when content nodes are configurable as display objects">
	<cfargument name="serialize" default="false">
	<cfif arguments.serialize>
		<cfreturn serializeJSON(variables.instance.objectParams)>
	<cfelse>
		<cfreturn variables.instance.objectParams>
	</cfif>
</cffunction>

<cffunction name="getObjectParam"  output="false" hint="This is used when content nodes are configurable as display objects">
	<cfargument name="param">
	<cfargument name="defaultValue">
	<cfset var val=getValue('param')>
	<cfif len(val)>
		<cfreturn val>
	<cfelse>
		<cfset var params=getObjectParams()>

		<cfif structKeyExists(params,arguments.param)>
			<cfreturn params['#arguments.param#']>
		<cfelseif isDefined('arguments.defaultValue')>
			<cfreturn arguments.defaultValue>
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="addDisplayObject" output="false">
	<cfargument name="regionID">
	<cfargument name="object">
	<cfargument name="objectID">
	<cfargument name="name">
	<cfargument name="params" default="">
	<cfargument name="orderno" default="">
	<cfset var rs=getDisplayRegion(arguments.regionID)>
	<cfset var rows=0>

	<cfif isNumeric(arguments.orderno)>
		<cfloop query="rs">
			<cfif rs.objectID eq arguments.objectID
				and rs.object eq arguments.object
				and rs.orderno eq arguments.orderno>
				<cfset querysetcell(rs,"objectid",arguments.objectID,rs.currentrow)/>
				<cfset querysetcell(rs,"object",arguments.object,rs.currentrow)/>
				<cfset querysetcell(rs,"name",arguments.name,rs.currentrow)/>
				<cfset querysetcell(rs,"params",arguments.params,rs.currentrow)/>
				<cfset variables.instance.extendAutoComplete = true />
				<cfreturn this>
			</cfif>
		</cfloop>
	</cfif>

	<cfif not hasDisplayObject(argumentCollection=arguments)>
		<cfset queryAddRow(rs,1)/>
		<cfset rows =rs.recordcount />
		<cfset querysetcell(rs,"objectid",arguments.objectID,rows)/>
		<cfset querysetcell(rs,"object",arguments.object,rows)/>
		<cfset querysetcell(rs,"name",arguments.name,rows)/>
		<cfset querysetcell(rs,"params",arguments.params,rows)/>
		<cfset variables.instance.extendAutoComplete = true />
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
		<cfset variables.instance.extendAutoComplete = true />
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

<cffunction name="getDisplayRegion" output="false">
	<cfargument name="regionID">
	<cfset var rs="">
	<cfif not structKeyExists(variables.displayRegions,"objectlist#arguments.regionID#")>
		<cfset variables.displayRegions["objectlist#arguments.regionID#"]=variables.contentManager.getRegionObjects(getContentHistID(), variables.instance.siteID, arguments.regionID)>
	</cfif>

	<cfreturn variables.displayRegions["objectlist#arguments.regionID#"]>
</cffunction>

<cffunction name="deleteVersion" output="false">
	<cfif not getValue('active')>
		<cfset variables.contentManager.delete(getAllValues()) />
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="deleteVersionHistory" output="false">
	<cfset variables.contentManager.deleteHistAll(getAllValues()) />
</cffunction>

<cffunction name="delete" output="false">
	<cfset variables.contentManager.deleteAll(getAllValues()) />
</cffunction>

<cffunction name="loadBy" output="false">
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>

	<cfset arguments.contentBean=this>

	<cfreturn variables.contentManager.read(argumentCollection=arguments)>
</cffunction>

<cffunction name="getStats" output="false">
	<cfset var statsBean=getBean("stats") />
	<cfset statsBean.setSiteID(variables.instance.siteID)>
	<cfset statsBean.setContentID(getContentID())>
	<cfset statsBean.load()>
	<cfreturn statsBean>
</cffunction>

<cffunction name="getCommentsQuery" output="false">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfreturn variables.contentManager.readComments(getContentID(), variables.instance.siteID, arguments.isEditor, arguments.sortOrder, arguments.parentID) />
</cffunction>

<cffunction name="getCommentsIterator" output="false">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfargument name="parentID" type="string" required="true" default="">
	<cfset var q=getCommentsQuery(arguments.isEditor, arguments.sortOrder, arguments.parentID) />
	<cfset var it=getBean("contentCommentIterator")>
	<cfset it.setQuery(q)>
	<cfreturn it />
</cffunction>

<cffunction name="getParent" output="false">
	<cfif getContentID() neq '00000000000000000000000000000000001'>
		<cfreturn variables.contentManager.read(contentID=variables.instance.parentID,siteID=variables.instance.siteID)>
	<cfelse>
		<cfthrow message="Parent content does not exist.">
	</cfif>
</cffunction>

<cffunction name="getCrumbArray" output="false">
	<cfargument name="sort" required="true" default="asc">
	<cfargument name="setInheritance" required="true" type="boolean" default="false">
	<cfif getValue('isNew') and getValue('contentid') neq '00000000000000000000000000000000001'>
		<cfreturn variables.contentManager.getCrumbList(contentID=variables.instance.parentid, siteID=variables.instance.siteID, setInheritance=arguments.setInheritance, sort=arguments.sort)>
	<cfelse>
		<cfreturn variables.contentManager.getCrumbList(contentID=getContentID(), siteID=variables.instance.siteID, setInheritance=arguments.setInheritance, path=variables.instance.path, sort=arguments.sort)>
	</cfif>
</cffunction>

<cffunction name="getCrumbIterator" output="false">
	<cfargument name="sort" required="true" default="asc">
	<cfargument name="setInheritance" required="true" type="boolean" default="false">
	<cfset var a=getCrumbArray(setInheritance=arguments.setInheritance,sort=arguments.sort)>
	<cfset var it=getBean("contentIterator")>
	<cfset it.setArray(a)>
	<cfreturn it>
</cffunction>

<cffunction name="hasDrafts" output="false">
	<cfreturn variables.contentManager.getHasDrafts(getContentID(),variables.instance.siteID) />
</cffunction>

<cffunction name="getURL" output="false">
	<cfargument name="querystring" required="true" default="">
	<cfargument name="complete" type="boolean" required="true" default="false">
	<cfargument name="showMeta" type="string" required="true" default="0">
	<cfargument name="secure" type="string" required="true" default="0">
	<cfreturn variables.contentManager.getURL(this, arguments.queryString,arguments.complete, arguments.showMeta,arguments.secure)>
</cffunction>

<cffunction name="getAssocURL" output="false">
	<cfif variables.instance.type eq 'Link'>
		<cfreturn variables.instance.body>
	<cfelse>
		 <cfreturn variables.contentManager.getURL(this,'',true)>
	</cfif>
</cffunction>

<cffunction name="setBody" output="false">
	<cfargument name="body">

	<cfif getValue('type') eq 'Variation'>
		<cfif not isSimpleValue(arguments.body)>
			<cfset arguments.body=serializeJSON(arguments.body)>
		</cfif>
		<cfif not isJSON(arguments.body)>
			<cfset arguments.body=urlDecode(arguments.body)>
			<cfif not isJSON(arguments.body)>
				<cfset arguments.body="[]">
			</cfif>
		</cfif>
	</cfif>

	<cfset variables.instance.body=arguments.body>
	<cfreturn this>
</cffunction>

<cffunction name="setAssocURL" output="false">
	<cfargument name="assocURL">
	<cfif variables.instance.type eq 'Link'>
		<cfset variables.instance.body=arguments.assocURL>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEditUrl" output="false">
	<cfargument name="compactDisplay" type="boolean" required="true" default="false"/>
	<cfargument name="tab">
	<cfargument name="complete" required="true" default="false">
	<cfargument name="hash" required="true" default="false">
	<cfset var returnStr="">
	<cfset var topID="00000000000000000000000000000000001">

	<cfif listFindNoCase("Form,Component", variables.instance.type)>
		<cfset topID=getValue('moduleid')>
	</cfif>

	<cfif arguments.compactDisplay>
		<cfset arguments.compactDisplay='true'>
	</cfif>

	<cfset returnStr= "#variables.configBean.getAdminPath(complete=arguments.complete)#/?muraAction=cArch.edit&contenthistid=#getContentHistId()#&contentid=#getContentId()#&type=#getValue('type')#&siteid=#getValue('siteid')#&topid=#topID#&parentid=#getValue('parentid')#&moduleid=#getValue('moduleid')#&compactdisplay=#arguments.compactdisplay#" >

	<cfif structKeyExists(arguments,"tab")>
		<cfset returnStr=returnStr & "##" & arguments.tab>
	</cfif>

	<cfif arguments.hash>
		<cfset var redirectid=getBean('utility').createRedirectId(returnStr)>
		<cfset returnStr=getBean('settingsManager').getSite(getValue('siteid')).getContentRenderer().createHREF(complete=arguments.complete,filename=redirectid)>
	</cfif>

	<cfreturn returnStr>
</cffunction>

<cffunction name="hasParent" output="false">
	<cfreturn listLen(variables.instance.path) gt 1>
</cffunction>

<cffunction name="getIsOnDisplay" output="false">
<cfreturn variables.instance.display eq 1 or
			(
				variables.instance.display eq 2 and variables.instance.displayStart lte now()
				AND (variables.instance.displayStop eq "" or variables.instance.displayStop gte now())
			)
			and (listFind("Page,Folder,Gallery,File,Calendar,Link,Form",variables.instance.type) or listFind(variables.instance.moduleAssign,'00000000000000000000000000000000000'))>
</cffunction>

<cffunction name="getImageURL" output="false">
	<cfargument name="size" required="true" default="undefined">
	<cfargument name="direct" default="true"/>
	<cfargument name="complete" default="false"/>
	<cfargument name="height" default=""/>
	<cfargument name="width" default=""/>
	<cfargument name="default" default=""/>
	<cfargument name="useProtocol" default="true"/>
	<cfargument name="secure" default="false">
	<cfset arguments.bean=this>
	<cfreturn variables.contentManager.getImageURL(argumentCollection=arguments)>
</cffunction>

<cffunction name="clone" output="false">
	<cfreturn getBean("content").setAllValues(structCopy(getAllValues()))>
</cffunction>

<cffunction name="getExtendBaseID" output="false">
	<cfreturn getContentHistID()>
</cffunction>

<cffunction name="requiresApproval" output="false">
	<cfargument name="applyExemptions" default="true">
	<cfset var crumbs=getCrumbIterator()>
	<cfset var crumb="">
	<cfset var chain="">
	<cfset var i="">
	<cfset var permUtility=getBean('permUtility')>
	<cfset var privateUserPool=getBean('settingsManager').getSite(getValue('siteid')).getPrivateUserPoolID()>

	<cfif not arguments.applyExemptions or not ( permUtility.isS2() or permUtility.isUserInGroup('admin',privateUserPool,0) )>
		<cfloop condition="crumbs.hasNext()">
			<cfset crumb=crumbs.next()>
			<cfif len(crumb.getChainID())>
				<cfset chain=getBean('approvalChain').loadBy(chainID=crumb.getChainID())>
				<cfif not chain.getIsNew()>
					<cfif arguments.applyExemptions and len(crumb.getExemptID()) and isdefined('sessionData.mura.membershipids')>
						<cfloop list="#crumb.getExemptID()#" index="i">
							<cfif listFind(sessionData.mura.membershipids,i)>
								<cfreturn false>
							</cfif>
						</cfloop>
					</cfif>
					<cfset setValue('chainID',crumb.getChainID())>
					<cfreturn true>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="getApprovalRequest" output="false">
	<cfreturn getBean('approvalRequest').loadBy(contenthistid=getValue('contenthistid'),chainID=getValue('chainID'),siteID=getValue('siteID'))>
</cffunction>

<cffunction name="getSource" output="false">
	<cfset var map=getBean('contentSourceMap').loadBy(contenthistid=getValue('contenthistID'),siteid=getValue('siteid'))>
	<cfset var source=map.getSource()>

	<cfif source.getIsNew() and not map.getIsNew()>
		<cfloop condition="source.getIsNew() and not map.getIsNew()">
			<cfset map=getBean('contentSourceMap').loadBy(contenthistid=map.getSourceID(),siteid=map.getSiteID())>
			<cfset source=map.getSource()>
		</cfloop>
	</cfif>

	<cfreturn source>

</cffunction>

<cffunction name="getUser" output="false">
	<cfreturn getBean('user').loadBy(userID=getValue('LastUpdateByID'))>
</cffunction>

<cffunction name="getClassExtension" output="false">
	<cfreturn variables.configBean.getClassExtensionManager().getSubTypeByName(getValue('type'),getValue('subtype'),getValue('siteid'))>
</cffunction>

<cffunction name="getFileMetaData" output="false">
	<cfargument name="property" default="fileid">
	<cfreturn getBean('fileMetaData').loadBy(contentid=getValue('contentid'),contentHistID=getValue('contentHistID'),siteID=getValue('siteid'),fileid=getValue(arguments.property))>
</cffunction>

<cffunction name="setRelatedContentID" output="false">
	<cfargument name="contentIDs" required="yes" default="">
	<cfargument name="relatedContentSetID" default="">
	<cfargument name="name" default="">
	<cfset var relatedContentSets = variables.configBean.getClassExtensionManager().getSubTypeByName(variables.instance.type, variables.instance.subtype, variables.instance.siteid).getRelatedContentSets()>
	<cfset var rcs = "">
	<cfset var i = "">
	<cfset var q = "">

	<cfset variables.instance.relatedContentSetData = arrayNew(1)>

	<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="i">
		<cfset rcs = structNew()>
		<cfset rcs.items = arrayNew(1)>
		<cfset rcs.relatedContentSetID = relatedContentSets[i].getRelatedContentSetID()>

		<cfset q = relatedContentSets[i].getRelatedContentQuery(getValue('contentHistID'))>

		<cfloop query="q">
			<cfset arrayAppend(rcs.items, q.contentID)>
		</cfloop>

		<cfset arrayAppend(variables.instance.relatedContentSetData, rcs)>
	</cfloop>

	<cfset rcs = structNew()>
	<cfset rcs.items = arrayNew(1)>
	<cfset rcs.relatedContentSetID = "00000000000000000000000000000000000">

	<cfloop list="#arguments.contentIDs#" index="i">
		<cfset arrayAppend(rcs.items, i)>
	</cfloop>

	<cfif len(arguments.relatedContentSetID)>
		<cfset rcs.relatedContentSetID = arguments.relatedContentSetID>
	<cfelseif len(arguments.name)>
		<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="i">
			<cfif relatedContentSets[i].getName() eq trim(arguments.name)>
				<cfset rcs.relatedContentSetID = relatedContentSets[i].getRelatedContentSetID()>
			</cfif>
		</cfloop>
	</cfif>

	<cfloop from="1" to="#arrayLen(variables.instance.relatedContentSetData)#" index="i">
		<cfif variables.instance.relatedContentSetData[i].relatedContentSetID eq rcs.relatedContentSetID>
			<cfset variables.instance.relatedContentSetData[i] = rcs>
		</cfif>
	</cfloop>

</cffunction>

<cffunction name="hasImage">
	<cfargument name="usePlaceholder" default="true">
	<cfreturn len(getValue('fileID')) and listFindNoCase('jpg,jpeg,png,gif,svg',getValue('fileEXT')) or arguments.usePlaceholder and len(variables.settingsManager.getSite(getValue('siteid')).getPlaceholderImgId())>
</cffunction>

	<cffunction name="getStatusID" output="false">
		<cfset var statusid = '' />
		<cfif variables.instance.active gt 0 and variables.instance.approved gt 0>
			<!--- 2: Published --->
			<cfset statusid = 2>
		<cfelseif len(variables.instance.approvalstatus) and requiresApproval()>
			<!--- 1: Pending Approval --->
			<cfset statusid = 1 />
		<cfelseif variables.instance.approved lt 1>
			<!--- 0: Draft --->
			<cfset statusid = 0 />
		<cfelse>
			<!--- 3: Archived --->
			<cfset statusid = 3 />
		</cfif>
		<cfreturn statusid />
	</cffunction>

	<cffunction name="getStatus" output="false">
		<cfset var status = '' />
		<cfif IsDefined('sessionData.rb')>
			<cfswitch expression="#getStatusID()#">
				<cfcase value="0">
					<cfset status = application.rbFactory.getKeyValue(sessionData.rb,"sitemanager.content.draft") />
				</cfcase>
				<cfcase value="1">
					<cfset status = application.rbFactory.getKeyValue(sessionData.rb,"sitemanager.content.#variables.instance.approvalstatus#") />
				</cfcase>
				<cfcase value="2">
					<cfset status = application.rbFactory.getKeyValue(sessionData.rb,"sitemanager.content.published") />
				</cfcase>
				<cfdefaultcase>
					<cfset status = application.rbFactory.getKeyValue(sessionData.rb,"sitemanager.content.archived") />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
		<cfreturn status />
	</cffunction>

	<cfscript>
		public boolean function getIsHome() {
			return Right(variables.instance.parentid, 3) == 'end';
		}

		public numeric function getDepth() {
			return ListLen(variables.instance.path) - 1;
		}
	</cfscript>

</cfcomponent>
