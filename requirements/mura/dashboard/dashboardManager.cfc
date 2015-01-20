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

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="userGateway" type="any" required="yes"/>
<cfargument name="contentGateway" type="any" required="yes"/>
<cfargument name="sessionTrackingGateway" type="any" required="yes"/>
<cfargument name="emailGateway" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
<cfargument name="raterManager" type="any" required="yes"/>
<cfargument name="feedGateway" type="any" required="yes"/>

		<cfset variables.configBean=arguments.configBean />
		<cfset variables.userGateway=arguments.userGateway />
		<cfset variables.contentGateway=arguments.contentGateway />
		<cfset variables.sessionTrackingGateway=arguments.sessionTrackingGateway />
		<cfset variables.emailGateway=arguments.emailGateway />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.raterManager=arguments.raterManager />
		<cfset variables.feedGateway=arguments.feedGateway />
		
<cfreturn this />
</cffunction>

<cffunction name="getSiteSessionCount" access="public" returntype="numeric" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="span" type="numeric" required="true" default="15">
	<cfargument name="spanType" type="string" required="true" default="n">
	
	<cfreturn variables.sessionTrackingGateway.getSiteSessionCount(arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.span,arguments.spanType) />
</cffunction>

<cffunction name="getCreatedMembers" access="public" returntype="numeric" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.userGateway.getCreatedMembers(arguments.siteID,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getTotalMembers" access="public" returntype="numeric" output="false">
	<cfargument name="siteID" type="string" required="true" default="">

	
	<cfreturn variables.userGateway.getTotalMembers(arguments.siteID) />
</cffunction>

<cffunction name="getTotalAdministrators" access="public" returntype="numeric" output="false">
	<cfargument name="siteID" type="string" required="true" default="">

	
	<cfreturn variables.userGateway.getTotalAdministrators(arguments.siteID) />
</cffunction>

<cffunction name="getTopContent" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="10">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	<cfargument name="excludeHome" type="boolean" required="true" default="false">
	
	<cfreturn variables.sessionTrackingGateway.getTopContent(arguments.siteID,arguments.limit,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate,arguments.excludeHome) />
</cffunction>

<cffunction name="getSiteSessions" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="span" type="numeric" required="true" default="15">
	<cfargument name="spanType" type="string" required="true" default="n">
	
	<cfreturn variables.sessionTrackingGateway.getSiteSessions(arguments.siteID,arguments.contentID,arguments.membersOnly,arguments.visitorStatus,arguments.span,arguments.spanType) />
</cffunction>

<cffunction name="getSessionHistory" access="public" returntype="query">
	<cfargument name="urlToken" type="string" default="">
	<cfargument name="siteID" type="string" default="">

	<cfreturn variables.sessionTrackingGateway.getSessionHistory(arguments.urlToken,arguments.siteID) />

</cffunction>

<cffunction name="getTopKeywords" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="10">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.sessionTrackingGateway.getTopKeywords(arguments.siteID,arguments.limit,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getTotalKeywords" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.sessionTrackingGateway.getTotalKeywords(arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getTotalHits" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.sessionTrackingGateway.getTotalHits(arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getTotalSessions" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.sessionTrackingGateway.getTotalSessions(arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getTopReferers" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="10">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.sessionTrackingGateway.getTopReferers(arguments.siteID,arguments.limit,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getTotalReferers" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.sessionTrackingGateway.getTotalReferers(arguments.siteID,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getcontentTypeCount" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="type" type="string" required="true" default="">
	
	<cfreturn variables.contentGateway.getTypeCount(arguments.siteID,arguments.type) />
</cffunction>

<cffunction name="getRecentUpdates" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.contentGateway.getRecentUpdates(arguments.siteID,arguments.limit,arguments.startdate,arguments.stopdate) />
</cffunction>

<cffunction name="getRecentFormActivity" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">
	
	<cfreturn variables.contentGateway.getRecentFormActivity(arguments.siteID,arguments.limit) />
</cffunction>

<cffunction name="getDraftList" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="userID"  type="string"  required="true" default="#listFirst(session.mura.isLoggedIn,'^')#"/>
	<cfargument name="limit" type="numeric" required="true" default="100000000">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	<cfargument name="sortBy" type="string" required="true" default="lastUpdate">
	<cfargument name="sortDirection" type="string" required="true" default="desc">
	
	<cfreturn variables.contentGateway.getDraftList(arguments.siteID,arguments.userID,arguments.limit,arguments.startDate,arguments.stopDate,arguments.sortBy,arguments.sortDirection) />
</cffunction>

<cffunction name="getTopRated" access="public" output="true" returntype="query">
	<cfargument name="siteID" type="string" default="" required="yes"/>
	<cfargument name="threshold" type="numeric" default="1" required="yes"/>
	<cfargument name="limit" type="numeric" default="0" required="yes"/>
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.raterManager.getTopRated(arguments.siteID,arguments.threshold,arguments.limit,arguments.startDate,arguments.stopDate)>
</cffunction>

<cffunction name="getFeedTypeCount" access="public" returntype="query" output="false">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="type" type="string" required="true" default="">
	
	<cfreturn variables.feedGateway.getTypeCount(arguments.siteID,arguments.type) />
</cffunction>

<cffunction name="getSessionSearch" access="public" returntype="query" output="false">
	<cfargument name="params" type="array" required="true" >
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="membersOnly" type="boolean" required="true" default="false">
	<cfargument name="visitorStatus" type="string" required="true" default="false">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.sessionTrackingGateway.getSessionSearch(arguments.params,arguments.siteID,arguments.membersOnly,arguments.visitorStatus,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getEmailActivity" access="public" returntype="query" output="false">
	<cfargument name="siteid" type="string" required="true" default="">
	<cfargument name="limit" type="numeric" required="true" default="5">
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfreturn variables.emailGateway.getSessionSearch(arguments.siteID,arguments.limit,arguments.startDate,arguments.stopDate) />
</cffunction>

<cffunction name="getTimeSpan" access="public" returntype="String" output="false">
	<cfargument name="firstRequest">
	<cfargument name="lastRequest">
	<cfargument name="format" required="true" default="#session.dateKeyFormat#">
	
	<cfset var theStart=arguments.firstRequest />
	<cfset var days = 0 />
	<cfset var hours = 0 />
	<cfset var minutes = 0 />
	<cfset var seconds = 0 />
	<cfset var returnStr = "" />
	
	<cfif arguments.format eq session.dateKeyFormat>
		<cfset hours = dateDiff("h",theStart,arguments.lastRequest) />
		<cfset theStart = dateAdd("h",hours,theStart) />
		<cfset minutes = dateDiff("n",theStart,arguments.lastRequest) />
		<cfset theStart = dateAdd("n",minutes,theStart) />
		<cfset seconds = dateDiff("s",theStart,arguments.lastRequest) />
		
		<cfif hours lt 10>
		<cfset hours="0#hours#"/>
		</cfif>
		<cfif minutes lt 10>
		<cfset minutes="0#minutes#"/>
		</cfif>
		<cfif seconds lt 10>
		<cfset seconds="0#seconds#"/>
		</cfif>
		
		<cfreturn "#hours#:#minutes#:#seconds#" />
	
	<cfelse>
		<cfset days = dateDiff("d",theStart,arguments.lastRequest) />
		<cfset theStart = dateAdd("d",days,theStart) />
		<cfset hours = dateDiff("h",theStart,arguments.lastRequest) />
		<cfset theStart = dateAdd("h",hours,theStart) />
		<cfset minutes = dateDiff("n",theStart,arguments.lastRequest) />
	
		<cfif days>
			<cfset returnStr = days & " days" />
		</cfif>
		<cfif hours>
			<cfif returnStr neq "">
				<cfset returnStr = returnStr & ", " />
			</cfif>
			<cfset returnStr = returnStr & hours & " hours" />
		</cfif>
		<cfif minutes>
			<cfif returnStr neq "">
				<cfset returnStr = returnStr & ", " />
			</cfif>
			<cfset returnStr = returnStr & minutes & " minutes" />
		</cfif>
		
		
		<cfreturn returnStr /> 
	
	
	</cfif>

</cffunction>

<cffunction name="getLastSessionDate" access="public" returntype="String">
	<cfargument name="urlToken"/>
	<cfargument name="originalUrlToken"/>
	<cfargument name="beforeDate"/>
	
	<cfset var rs = "" />
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select max(entered) as lastRequest
	from tsessiontracking 
	where originalUrlToken=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.originalUrlToken#"/>
	and urlToken <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#urlToken#"/>
	and entered < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(arguments.beforeDate,'mm/dd/yyyy')#">
	</cfquery>
	
	<cfif isDate(rs.lastRequest)>
		<cfreturn rs.lastRequest />
	<cfelse>
		<cfreturn "Not Available" />
	</cfif>
</cffunction>

<cffunction name="getUserFromSessionQuery" access="public" returntype="String">
	<cfargument name="rsSession"/>
	
	<cfset var rs = "" />
	
	<cfquery name="rs" dbType="query">
	select fname,lname from arguments.rsSession where userID > ''
	</cfquery>
	
	<cfif rs.recordcount>
		<cfreturn rs.fname & " " & rs.lname />
	<cfelse>
		<cfreturn "Anonymous" />
	</cfif>
</cffunction>

<cffunction name="getUserAgentFromSessionQuery" access="public" returntype="String">
	<cfargument name="rsSession"/>
	
	<cfset var rs = "" />
	
	<cfquery name="rs" dbType="query">
	select user_agent from arguments.rsSession where user_agent > ''
	</cfquery>
	
	<cfif rs.recordcount>
		<cfreturn rs.user_agent />
	<cfelse>
		<cfreturn "unknown" />
	</cfif>
</cffunction>


</cfcomponent>