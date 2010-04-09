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

	<cfparam name="rc.startrow" default="1" />
	<cfparam name="rc.keywords" default=""/>
	<cfparam name="rc.limit" default="10"/>
	<cfparam name="rc.threshold" default="1"/>
	<cfparam name="rc.siteID" default=""/>
	<cfparam name="session.startDate" default="#now()#"/>
	<cfparam name="session.stopDate" default="#now()#"/>
	<cfparam name="rc.membersOnly" default="false"/>
	<cfparam name="rc.visitorStatus" default="All"/>
	<cfparam name="rc.contentID" default=""/>
	<cfparam name="rc.direction" default=""/>
	<cfparam name="rc.orderby" default=""/>
	<cfparam name="rc.page" default="1"/>
	<cfparam name="rc.span" default="#session.dashboardSpan#"/>
	<cfparam name="rc.spanType" default="d"/>
	<cfparam name="rc.startDate" default="#dateAdd('#rc.spanType#',-rc.span,now())#"/>
	<cfparam name="rc.stopDate" default="#now()#"/>
	<cfparam name="rc.newSearch" default="false"/>
	<cfparam name="rc.startSearch" default="false"/>
	<cfparam name="rc.returnurl" default=""/>
	<cfparam name="rc.layout" default=""/>
	<cfparam name="rc.ajax" default=""/>
	
	<cfif (not listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000000',rc.siteid)>
		<cfset secure(rc)>
	</cfif>
	
	<cfif not LSisDate(rc.startDate) and not LSisDate(session.startDate)>
		<cfset session.startdate=now()>
	</cfif>
	
	<cfif not LSisDate(rc.stopDate) and not LSisDate(session.stopDate)>
		<cfset session.stopdate=now()>
	</cfif>
	
	<cfif rc.startSearch and LSisDate(rc.startDate)>
		<cfset session.startDate=rc.startDate>
	</cfif>
	
	<cfif rc.startSearch and LSisDate(rc.stopDate)>
		<cfset session.stopDate=rc.stopDate>
	</cfif>
	
	<cfif rc.newSearch>
		<cfset session.stopDate=now()>
		<cfset session.startDate=now()>
	</cfif>

</cffunction>

<cffunction name="listSessions" output="false">
<cfargument name="rc">
<cfset rc.rslist=variables.dashboardManager.getSiteSessions(rc.siteid,rc.contentid,rc.membersOnly,rc.visitorStatus,rc.span,rc.spanType)>
</cffunction>

<cffunction name="sessionSearch" output="false">
<cfargument name="rc">
<cfset rc.rsGroups=variables.userManager.getPublicGroups(rc.siteid,1)>
</cffunction>

<cffunction name="viewsession" output="false">
<cfargument name="rc">
<cfset rc.rslist=application.dashboardManager.getSessionHistory(rc.urlToken,rc.siteID)>
</cffunction>

</cfcomponent>