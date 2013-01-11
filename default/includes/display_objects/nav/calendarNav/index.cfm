<cfsilent>
<!--- set this to the number of months back you would like to display --->
<cfparam name="request.sortBy" default=""/>
<cfparam name="request.sortDirection" default=""/>
<cfparam name="request.day" default="#day(now())#"/>

<cfset $.addToHTMLHeadQueue('nav/calendarNav/htmlhead/htmlhead.cfm')>
</cfsilent>
<cf_CacheOMatic key="#arguments.object##$.event('siteid')##arguments.objectid##$.event('month')##$.event('year')#" nocache="#$.event('nocache')#">
<cfsilent>
<cfset navTools=createObject("component","navTools").init($)>
<cfset navID=arguments.objectID>
<cfquery datasource="#application.configBean.getDatasource()#"
		username="#application.configBean.getDBUsername()#"
		password="#application.configBean.getDBPassword()#"
		name="rsSection">
		select filename,menutitle,type from tcontent where siteid='#$.event('siteID')#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1
</cfquery>

<cfset navPath="#$.globalConfig('context')##getURLStem($.event('siteID'),rsSection.filename)#">
<cfset navMonth=request.month >
<cfset navYear=request.year >
<cfset navDay=request.day >
<cfif rsSection.type eq "Folder">
	<cfset navType = "releaseMonth">
<cfelse>
	<cfset navType = "CalendarMonth">
</cfif>
</cfsilent>
<nav id="svCalendarNav" class="svCalendar">
<cfset navTools.setParams(navMonth,navDay,navYear,navID,navPath,navType) />
<cfoutput>#navTools.dspMonth()#</cfoutput>
</nav>
</cf_CacheOMatic>











