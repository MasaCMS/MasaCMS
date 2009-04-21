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

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.dsn=variables.configBean.getDatasource() />
<cfreturn this />
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","#variables.configBean.getMapDir()#.content.contentBean").init(variables.configBean)>
</cffunction>

<cffunction name="readVersion" access="public" returntype="any" output="false">
		<cfargument name="contentHistID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfset var rsContent = 0 />
		<cfset var contentBean=getbean() />
			
		<cfquery datasource="#variables.dsn#" name="rsContent"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select tcontent.*, tfiles.fileSize, tfiles.contentType, tfiles.contentSubType, tfiles.fileExt from tcontent 
			left join tfiles on (tcontent.fileid=tfiles.fileid)
			where tcontent.contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#" /> and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		</cfquery>
		
		<cfif rsContent.recordCount>
			<cfset contentBean.set(rsContent) />
		<cfelseif arguments.use404>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setBody('The requested version this content could not be found.')/>
			<cfset contentBean.setTitle('404')/>
			<cfset contentBean.setMenuTitle('404')/>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setFilename('404') />
			<cfset contentBean.setParentID('00000000000000000000000000000000END') />
			<cfset contentBean.setcontentID('00000000000000000000000000000000001') />
			<cfset contentBean.setPath('00000000000000000000000000000000001') />
			<cfset contentBean.setSiteID(arguments.siteID) />
			<cfset contentBean.setDisplay(1) />
			<cfset contentBean.setApproved(1) />
		<cfelse>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setSiteID(arguments.siteid) />
		</cfif>
		
		<cfreturn contentBean />
</cffunction>

<cffunction name="readActive" access="public" returntype="any" output="false">
		<cfargument name="contentID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfset var rsContent = 0 />
		<cfset var contentBean=getbean()  />
			
		<cfquery datasource="#variables.dsn#" name="rsContent"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select tcontent.*, tfiles.fileSize, tfiles.contentType, tfiles.contentSubType, tfiles.fileExt from tcontent 
			left join tfiles on (tcontent.fileid=tfiles.fileid)
			where tcontent.contentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" /> and tcontent.active=1 and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
			and type in ('Page','Portal','File','Calendar','Link','Gallery','Component','Form')
		</cfquery>
		
		<cfif rsContent.recordCount>
			<cfset contentBean.set(rsContent) />
		<cfelseif arguments.use404>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setBody('The requested page could not be found.')/>
			<cfset contentBean.setTitle('404')/>
			<cfset contentBean.setMenuTitle('404')/>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setFilename('404') />
			<cfset contentBean.setParentID('00000000000000000000000000000000END') />
			<cfset contentBean.setcontentID('00000000000000000000000000000000001') />
			<cfset contentBean.setPath('00000000000000000000000000000000001') />
			<cfset contentBean.setSiteID(arguments.siteID) />
			<cfset contentBean.setDisplay(1) />
			<cfset contentBean.setApproved(1) />
		<cfelse>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setSiteID(arguments.siteid) />
		</cfif>
		
		<cfreturn contentBean />
</cffunction>

<cffunction name="readActiveByRemoteID" access="public" returntype="any" output="false">
		<cfargument name="remoteID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfset var rsContent = 0 />
		<cfset var contentBean=getbean()  />
			
		<cfquery datasource="#variables.dsn#" name="rsContent"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select tcontent.*, tfiles.fileSize, tfiles.contentType, tfiles.contentSubType, tfiles.fileExt from tcontent 
			left join tfiles on (tcontent.fileid=tfiles.fileid)
			where tcontent.remoteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remoteID#" /> and tcontent.active=1 and tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#" />
			and type in ('Page','Portal','File','Calendar','Link','Gallery','Component','Form')
		</cfquery>
		
		<cfif rsContent.recordCount>
			<cfset contentBean.set(rsContent) />
		<cfelse>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setSiteID(arguments.siteid) />
		</cfif>
		
		<cfreturn contentBean />
</cffunction>

<cffunction name="readActiveByFilename" access="public" returntype="any" output="true">
		<cfargument name="filename" type="string" required="yes" default="" />
		<cfargument name="siteID" type="string" required="yes" default="" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		<cfset var rsContent = 0 />
		<cfset var contentBean=getbean()  />
			
		<cfquery datasource="#variables.dsn#" name="rsContent"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select tcontent.*, tfiles.fileSize, tfiles.contentType, tfiles.contentSubType, tfiles.fileExt from tcontent 
			left join tfiles on (tcontent.fileid=tfiles.fileid)
			where 
			<cfif arguments.filename neq ''>
			 tcontent.filename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#" />
			<cfelse>
			 tcontent.filename is null
			</cfif>
			and  tcontent.active=1 and 
			 tcontent.type in('Page','Portal','Calendar','Gallery') 
			and  tcontent.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		</cfquery>
		
		<cfif rsContent.recordCount eq 1>

			<cfset contentBean.set(rsContent) />
		<cfelseif arguments.use404>
			<cfset contentBean.setBody('The requested page could not be found.')/>
			<cfset contentBean.setTitle('404')/>
			<cfset contentBean.setMenuTitle('404')/>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setFilename('404') />
			<cfset contentBean.setParentID('00000000000000000000000000000000END') />
			<cfset contentBean.setcontentID('00000000000000000000000000000000001') />
			<cfset contentBean.setPath('00000000000000000000000000000000001') />
			<cfset contentBean.setSiteID(arguments.siteID) />
			<cfset contentBean.setDisplay(1) />
			<cfset contentBean.setApproved(1) />
		<cfelse>
			<cfset contentBean.setIsNew(1) />
			<cfset contentBean.setActive(1) />
			<cfset contentBean.setSiteID(arguments.siteid) />
		</cfif>
		<cfreturn contentBean />
</cffunction>

<cffunction name="create" access="public" returntype="void" output="false">
		<cfargument name="contentBean" type="any" required="yes" />
		
		 <cfquery  DATASOURCE="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      INSERT INTO tcontent (ContentHistID, ContentID, Active, OrderNo,  approved, DisplayStart,
	   displaystop,
	   <!--- clob fields --->
	   MetaDesc,
	   MetaKeyWords,
	   Body,
	   Summary, 
	   path,
	   tags,
	   responseMessage,
	   responseDisplayFields,
	   <!--- --->
	   Title, menuTitle, filename, LastUpdate, Display, ParentID, Type, subType,LastUpdateBy, 
	   LastUpdateByID, siteid, moduleid, isnav, restricted, target, restrictgroups,template,
	   responseChart,responseSendTo,moduleAssign,notes,inheritObjects,isFeature,
	   releaseDate,targetParams,isLocked,nextN,sortBy,sortDirection,featureStart,featureStop,fileID,forceSSL,
	   remoteID,remoteURL,remotePubDate,remoteSource,RemoteSourceURL,Credits,
	   audience, keyPoints, searchExclude, displayTitle, doCache, created)
      VALUES (
	  	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentHistID()#">, 
         <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#">,
		 #arguments.contentBean.getActive()#,
		 #arguments.contentBean.getOrderNo()#,
		#arguments.contentBean.getApproved()#,
		<cfif arguments.contentBean.getDisplay() eq 2 and isdate(arguments.contentBean.getDisplayStart())> #createodbcdatetime(createDateTime(year(arguments.contentBean.getDisplayStart()),month(arguments.contentBean.getDisplayStart()),day(arguments.contentBean.getDisplayStart()),hour(arguments.contentBean.getDisplayStart()),minute(arguments.contentBean.getDisplayStart()),0))#<cfelse>null</cfif>,
		<cfif arguments.contentBean.getDisplay() eq 2 and isdate(arguments.contentBean.getDisplayStop())> #createodbcdatetime(createDateTime(year(arguments.contentBean.getDisplayStop()),month(arguments.contentBean.getDisplayStop()),day(arguments.contentBean.getDisplayStop()),hour(arguments.contentBean.getDisplayStop()),minute(arguments.contentBean.getDisplayStop()),0))#<cfelse>null</cfif>,
	    
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getMetaDesc() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getMetaDesc()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getMetaKeyWords() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getMetaKeywords()#">,  
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getBody() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getBody()#"> , 
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getSummary() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getSummary()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getPath() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getPath()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getTags() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getTags()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getResponseMessage() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getResponseMessage()#">,
	    <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.contentBean.getResponseDisplayFields() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getResponseDisplayFields()#">,
	    
	    <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getTitle() neq '',de('no'),de('yes'))#" value="#trim(arguments.contentBean.getTitle())#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getMenutitle() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getMenutitle()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getFilename() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getFilename()#"> ,  
        #createodbcdatetime(now())#, 
         #arguments.contentBean.getDisplay()#, 
       <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getParentID() neq '',de('no'),de('yes'))#" value="#trim(arguments.contentBean.getParentID())#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getType()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSubType()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#trim(arguments.contentBean.getLastUpdateBy())#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getLastUpdateByID() neq '',de('no'),de('yes'))#" value="#trim(arguments.contentBean.getLastUpdateByID())#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getModuleID()#">,
		#arguments.contentBean.getisnav()#,
		#arguments.contentBean.getrestricted()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getTarget() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getTarget()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRestrictGroups() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRestrictGroups()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getTemplate() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getTemplate()#">,
		#arguments.contentBean.getresponseChart()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getResponseSendTo() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getResponseSendTo()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getModuleAssign() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getModuleAssign()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getNotes()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getInheritObjects() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getInheritObjects()#">,
		#arguments.contentBean.getisfeature()#,
		<cfif isdate(arguments.contentBean.getReleaseDate())> #createodbcdatetime(LSDateFormat(arguments.contentBean.getReleaseDate(),'mm/dd/yyyy'))#<cfelse>null</cfif>,
		<CFIF arguments.contentBean.getTarget() EQ "_blank" and arguments.contentBean.getTargetParams() NEQ ""> <cfqueryparam cfsqltype="cf_sql_varchar" null="no" value="#arguments.contentBean.getTargetParams()#"><CFELSE> Null </CFIF>,
		#arguments.contentBean.getIsLocked()#,
		<cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.contentBean.getNextN()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getSortBy() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getSortBy()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getSortDirection() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getSortDirection()#">,
		<cfif arguments.contentBean.getIsFeature() eq 2 and isdate(arguments.contentBean.getFeatureStart())> #createodbcdatetime(createDateTime(year(arguments.contentBean.getFeatureStart()),month(arguments.contentBean.getFeatureStart()),day(arguments.contentBean.getFeatureStart()),hour(arguments.contentBean.getFeatureStart()),minute(arguments.contentBean.getFeatureStart()),0))#<cfelse>null</cfif>,
		<cfif arguments.contentBean.getIsFeature() eq 2 and isdate(arguments.contentBean.getFeatureStop())> #createodbcdatetime(createDateTime(year(arguments.contentBean.getFeatureStop()),month(arguments.contentBean.getFeatureStop()),day(arguments.contentBean.getFeatureStop()),hour(arguments.contentBean.getFeatureStop()),minute(arguments.contentBean.getFeatureStop()),0))#<cfelse>null</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getFileID() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getFileID()#">,
		<cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.contentBean.getForceSSL()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemoteID() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemoteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemoteURL() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemoteURL()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemotePubDate() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemotePubDate()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemoteSource() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemoteSource()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getRemoteSourceURL() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getRemoteSourceURL()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getCredits() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getCredits()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getAudience() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getAudience()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.contentBean.getKeyPoints() neq '',de('no'),de('yes'))#" value="#arguments.contentBean.getKeyPoints()#">,
		#arguments.contentBean.getSearchExclude()#,
		#arguments.contentBean.getDisplayTitle()#,
		#arguments.contentBean.getDoCache()#,
		<cfif isdate(arguments.contentBean.getCreated())> #createodbcdatetime(LSDateFormat(arguments.contentBean.getCreated(),'mm/dd/yyyy'))#<cfelse>null</cfif>
			)
 </CFQUERY>

</cffunction>

<cffunction name="deleteHistAll" access="public" returntype="void" output="false">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />
	<cfset var rsdate= "">
	<cfset var rslist= "">
	
	<cfquery datasource="#variables.dsn#" name="rsdate"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select lastupdate from tcontent where active = 1 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	</cfquery>
	
	<cfquery datasource="#variables.dsn#" name="rslist"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contenthistid from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	and lastupdate < #createodbcdatetime(rsdate.lastupdate)#
	</cfquery>
	
	<cfif rslist.recordcount>
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		 Delete from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" /> and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
		 and lastupdate < #createodbcdatetime(rsdate.lastupdate)#
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentobjects where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /><cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfloop query="rslist">
			<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>
		</cfloop>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentcategoryassign where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /><cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentrelated where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /> <cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontenttags where 
		siteid='#arguments.siteid#'
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /> <cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="deleteDraftHistAll" access="public" returntype="void" output="false">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />
	<cfset var rslist= "">
	<cfset var rsFiles= "">
		
	<cfquery datasource="#variables.dsn#" name="rslist"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contenthistid from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	and approved=0
	</cfquery>
	
	<cfif rslist.recordcount>	
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentobjects where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /><cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfloop query="rslist">
			<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>
		</cfloop>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentcategoryassign where 
		siteid='#arguments.siteid#'
		and contenthistid in (<cfloop query="rslist">'#rslist.contenthistid#'<cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontentrelated where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist">'#rslist.contenthistid#'<cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from tcontenttags where 
		siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contenthistid in (<cfloop query="rslist"><cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contentHistID#" /> <cfif rslist.currentrow lt rslist.recordcount>,</cfif></cfloop>)
		</cfquery>
	</cfif>
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Delete from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
	and approved=0
	</cfquery>
	
</cffunction>

<cffunction name="archiveActive" access="public" returntype="void" output="false">
<cfargument name="contentID" type="string" required="yes" />
<cfargument name="siteID" type="string" required="yes" />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontent set active=0 where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />
		and active=1 
		and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	
</cffunction>

<cffunction name="createObjects" access="public" returntype="void" output="false">
	<cfargument name="data" type="struct" />
	<cfargument name="contentBean" type="any" />
	<cfargument name="oldContentHistID" type="string" default="" required="yes"/>

	<cfset var objectOrder = 0>
	<cfset var objectList = "">
	<cfset var rsOld = "">
	<cfset var r=0 />
	<cfset var i=0 />
	
	<cfloop from="1" to="#variables.settingsManager.getSite(arguments.contentBean.getsiteid()).getcolumnCount()#" index="r">
		<cfset objectOrder = 0>
		<cfif isdefined("arguments.data.objectlist#r#")>
			<cfset objectList =#evaluate("arguments.data.objectlist#r#")# />
			<cfloop list="#objectlist#" index="i" delimiters="^">
				<cfset objectOrder=objectOrder+1>
				<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				insert into tcontentobjects (contentid,contenthistid,object,name,objectid,orderno,siteid,columnid)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(i,1,"~")#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(i,2,"~")#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(i,3,"~")#" />,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#objectOrder#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#r#" />
					)
				</cfquery>
			</cfloop>
			
		<cfelseif arguments.oldContentHistID neq ''>
			<cfset rsOld=readRegionObjects(arguments.oldContentHistID,arguments.contentBean.getsiteid(),r)/>
			
			<cfloop query="rsOld">
				<cfset objectOrder=objectOrder+1>
				<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				insert into tcontentobjects (contentid,contenthistid,object,name,objectid,orderno,siteid,columnid)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOld.object#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOld.name#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOld.objectID#" />,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOld.currentRow#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOld.columnid#" />
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cfloop>
	
</cffunction>

<cffunction name="createTags" access="public" returntype="void" output="false">
	<cfargument name="contentBean" type="any" />
	<cfset var taglist  = "" />
	<cfset var t = "" />
		<cfif len(arguments.contentBean.getTags())>
			<cfset taglist = arguments.contentBean.getTags() />
			<cfloop list="#taglist#" index="t">
				<cfif len(trim(t))>
					<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					insert into tcontenttags (contentid,contenthistid,siteid,tag)
					values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontenthistid()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(t)#"/>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
</cffunction>

<cffunction name="readRegionObjects" access="public" returntype="query" output="false">
	<cfargument name="contenthistid"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfargument name="regionID"  type="numeric" />
	<cfset var rs = "">
	
	<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tcontentobjects where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> and 
	columnid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.regionID#"/> order by orderno
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="deleteObjects" access="public" returntype="void" output="false">
	<cfargument name="contentID"  type="string" />
	<cfargument name="siteID"  type="string" />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentobjects where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteTags" access="public" returntype="void" output="false">
	<cfargument name="contentID"  type="string" />
	<cfargument name="siteID"  type="string" />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontenttags where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteObjectsHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentobjects where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/> and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteTagHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontenttags where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>  and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />

	<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(arguments.contentHistID)/>
	
	<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	DELETE FROM tcontent where  siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>  and ContentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/> 
	</cfquery>
</cffunction>

<cffunction name="deleteExtendDataHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(arguments.contentHistID)/>
</cffunction>

<cffunction name="deleteCategoryHist" access="public" returntype="void" output="false">
	<cfargument name="contentHistID"  type="string" />
	<cfargument name="siteID"  type="string" />
	<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	DELETE FROM tcontentcategoryassign where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and
	contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/> 
	</cfquery>
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="contentBean"  type="any" />
	<cfset var rsList=""/>
	<cfif arguments.contentBean.getContentID() neq '00000000000000000000000000000000001'>
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontent set parentID='#arguments.contentBean.getParentID()#' where 
	siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and parentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentID()#"/>
	</cfquery>
	
	
	<!--- get Versions and delete extended data --->
	<cfquery name="rslist" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contentHistID FROM tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and 
	ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
	</cfquery>
	
	<cfloop query="rslist">
		<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(rslist.contentHistID)/>
	</cfloop>
	<!--- --->
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	DELETE FROM tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and 
	ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#"/>
	</cfquery>
	
	<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	DELETE FROM tpermissions where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/> and 
	ContentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
	</cfquery>

	<cfif arguments.contentBean.gettype() neq 'Form'  and arguments.contentBean.gettype() neq 'Component'>
	
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentobjects where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontenttags where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontenteventreminders where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>	
		
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentcategoryassign where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentratings where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentrelated where (contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/> or relatedID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>)
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tusersfavorites where favorite= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tsessiontracking where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
	
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentcomments where contentID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
		<!--- sometimes apps allow content to have an address --->
	<!--- 	<cfquery datasource="#variables.dsn#">
		delete from tcontentratings where contentid
		in (select addressID from tuseraddresses where userid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>)
		</cfquery>
		
		<cfquery datasource="#variables.dsn#">
		delete from tuseraddresses where userid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		</cfquery> --->
	
	<cfelse>
	
		<cfquery datasource="#variables.dsn#"   username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tcontentobjects where objectID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		AND siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteid()#"/>
		</cfquery>
		
	</cfif>
	
	
	<cfif arguments.contentBean.gettype() eq 'Form'>
	
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tformresponsequestions where formID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		</cfquery>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tformresponsepackets where formID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentid()#"/>
		</cfquery>
	
	</cfif>
	</cfif>
</cffunction>

<cffunction name="createRelatedItems" returntype="void" access="public" output="false">
	<cfargument name="contentID" type="string" required="yes" default="" />
	<cfargument name="contentHistID" type="string" required="yes" default="" />
	<cfargument name="data" type="struct" required="yes" default="#structNew()#" />
	<cfargument name="siteID" type="string" required="yes" default="" />
	<cfargument name="oldContentHistID" type="string" required="yes" default="" />
	
	<cfset var I='' />
	 
	 <cfif isDefined('arguments.data.relatedContentID')>
	 <cfloop list="#arguments.data.relatedContentID#" index="I">
		<cftry>
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentrelated (contentID,contentHistID,relatedID,siteid)
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		)
		</cfquery>
		<cfcatch></cfcatch>
		</cftry>
	</cfloop>
	
	<cfelseif arguments.oldContentHistID neq ''>

	 <cfloop list="#readRelatedItems(arguments.oldContentHistID,arguments.siteID)#" index="I">
		<cftry>
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentrelated (contentID,contentHistID,relatedID,siteid)
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#"/>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		)
		</cfquery>
		<cfcatch></cfcatch>
		</cftry>
	</cfloop>
	
	</cfif>

</cffunction> 

<cffunction name="deleteRelatedItems" access="public" output="false" returntype="void" >
	<cfargument name="contentHistID" type="String" />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentrelated
	where contentHIstID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#"/>
	</cfquery>

</cffunction>

<cffunction name="readRelatedItems" returntype="string" access="public" output="false">
	<cfargument name="contentHistID" type="string" required="yes" default="" />
	<cfargument name="siteid" type="string" required="yes" default="" />
	
	 <cfset var rs =""/>
	 <cfset var ItemList =""/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select relatedID from tcontentrelated
		where contentHistID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#"/> and siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
	
	<cfset ItemList=valueList(rs.relatedID) />
	
	<cfreturn ItemList />
	
</cffunction> 

<cffunction name="deleteContentAssignments" access="public" output="false" returntype="void" >
	<cfargument name="contentID" type="String" />
	<cfargument name="siteID" type="String" />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentassignments
	where contentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/>
	and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>

</cffunction>

<cffunction name="createContentAssignment" access="public" output="false" returntype="void" >
	<cfargument name="contentBean" type="any" />
	<cfargument name="userID" type="String" />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into tcontentassignments (contentID,contentHistID,siteID,UserID) values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentHistID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSiteID()#" >,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" >
			)
	</cfquery>
	
</cffunction>

<cffunction name="readComments" access="public" output="false" returntype="query">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	
	<cfset var rs= ''/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tcontentcomments where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	<cfif not arguments.isEditor >
	and isApproved=1
	</cfif>
	order by entered #arguments.sortOrder#
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getCommentCount" access="public" output="false" returntype="numeric">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfset var rs= ''/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select count(*) TotalComments from tcontentcomments where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	<cfif not arguments.isEditor >
	and isApproved=1
	</cfif>
	</cfquery>
	
	<cfreturn rs.TotalComments />
</cffunction>

<cffunction name="getCommentSubscribers" access="public" output="false" returntype="query">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfset var rs= ''/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select distinct email from tcontentcomments 
	where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/> 
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and email is not null
	and isApproved=1
	and subscribe=1
	</cfquery>
	
	<cfreturn rs />
</cffunction>

</cfcomponent>