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

</cfcomponent>