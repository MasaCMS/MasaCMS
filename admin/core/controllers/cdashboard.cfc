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
<cfcomponent extends="controller" output="false">

<cffunction name="setDashboardManager" output="false">
	<cfargument name="dashboardManager">
	<cfset variables.dashboardManager=arguments.dashboardManager>
</cffunction>

<cffunction name="setUserManager" output="false">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">

	<cfparam name="arguments.rc.startrow" default="1" />
	<cfparam name="arguments.rc.keywords" default=""/>
	<cfparam name="arguments.rc.limit" default="10"/>
	<cfparam name="arguments.rc.threshold" default="1"/>
	<cfparam name="arguments.rc.siteID" default=""/>
	<cfparam name="session.startDate" default="#now()#"/>
	<cfparam name="session.stopDate" default="#now()#"/>
	<cfparam name="arguments.rc.membersOnly" default="false"/>
	<cfparam name="arguments.rc.visitorStatus" default="All"/>
	<cfparam name="arguments.rc.contentID" default=""/>
	<cfparam name="arguments.rc.direction" default=""/>
	<cfparam name="arguments.rc.orderby" default=""/>
	<cfparam name="arguments.rc.page" default="1"/>
	<cfparam name="arguments.rc.span" default="#session.dashboardSpan#"/>
	<cfparam name="arguments.rc.spanType" default="d"/>
	<cfparam name="arguments.rc.startDate" default="#dateAdd('#rc.spanType#',-rc.span,now())#"/>
	<cfparam name="arguments.rc.stopDate" default="#now()#"/>
	<cfparam name="arguments.rc.newSearch" default="false"/>
	<cfparam name="arguments.rc.startSearch" default="false"/>
	<cfparam name="arguments.rc.returnurl" default=""/>
	<cfparam name="arguments.rc.layout" default=""/>
	<cfparam name="arguments.rc.ajax" default=""/>
	
	<cfif (not listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid)>
		<cfset secure(arguments.rc)>
	</cfif>
	
	<cfif not LSisDate(arguments.rc.startDate) and not LSisDate(session.startDate)>
		<cfset session.startdate=now()>
	</cfif>
	
	<cfif not LSisDate(arguments.rc.stopDate) and not LSisDate(session.stopDate)>
		<cfset session.stopdate=now()>
	</cfif>
	
	<cfif arguments.rc.startSearch and LSisDate(arguments.rc.startDate)>
		<cfset session.startDate=rc.startDate>
	</cfif>
	
	<cfif arguments.rc.startSearch and LSisDate(arguments.rc.stopDate)>
		<cfset session.stopDate=rc.stopDate>
	</cfif>
	
	<cfif arguments.rc.newSearch>
		<cfset session.stopDate=now()>
		<cfset session.startDate=now()>
	</cfif>

</cffunction>

<cffunction name="listSessions" output="false">
<cfargument name="rc">
<cfset arguments.rc.rslist=variables.dashboardManager.getSiteSessions(arguments.rc.siteid,arguments.rc.contentid,arguments.rc.membersOnly,arguments.rc.visitorStatus,arguments.rc.span,arguments.rc.spanType)>
</cffunction>

<cffunction name="sessionSearch" output="false">
<cfargument name="rc">
<cfset arguments.rc.rsGroups=variables.userManager.getPublicGroups(arguments.rc.siteid,1)>
</cffunction>

<cffunction name="viewsession" output="false">
<cfargument name="rc">
<cfset arguments.rc.rslist=application.dashboardManager.getSessionHistory(arguments.rc.urlToken,arguments.rc.siteID)>
</cffunction>

<cffunction name="dismissAlert" output="false">
	<cfargument name="rc">
	<cfset var alerts=session.mura.alerts['#rc.siteid#']>
	<cfif listFindNoCase('defaultpasswordnotice,cachenotice',rc.alertid)>
		<cfset alerts[rc.alertid]=false>
	<cfelse>
		<cfset structDelete(alerts, rc.alertid)>
	</cfif>
	
	<cfabort>
</cffunction>

</cfcomponent>