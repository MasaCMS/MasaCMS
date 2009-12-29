<cfsilent>
<!--- set this to the number of months back you would like to display --->	
<cfparam name="request.sortBy" default=""/>
<cfparam name="request.sortDirection" default=""/>
<cfparam name="request.day" default="#day(now())#"/>

<cfset addToHTMLHeadQueue('nav/calendarNav/htmlhead/htmlhead.cfm')>
</cfsilent>
<cf_CacheOMatic key="#arguments.object##event.getValue('siteid')##arguments.objectid##event.getValue('month')##event.getvalue('year')#" nocache="#event.getValue('nocache')#">
<cfsilent>
<cfset navTools=createObject("component","navTools")>
<cfset navID=arguments.objectID>	
<cfquery datasource="#application.configBean.getDatasource()#" 
		username="#application.configBean.getDBUsername()#" 
		password="#application.configBean.getDBPassword()#" 
		name="rsSection">
		select filename,menutitle,type from tcontent where siteid='#request.siteid#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1
</cfquery>

<cfset navPath="#application.configBean.getContext()##getURLStem(request.siteID,rsSection.filename)#">
<cfset navMonth=request.month >
<cfset navYear=request.year >
<cfset navDay=request.day >
<cfif rsSection.type eq "Portal">
	<cfset navType = "releaseMonth">
<cfelse>
	<cfset navType = "CalendarMonth">
</cfif>
</cfsilent>
<div id="svCalendarNav" class="svCalendar">
<cfset navTools.setParams(navMonth,navDay,navYear,navID,navPath,navType) />
<cfoutput>#navTools.dspMonth()#</cfoutput>
</div>
</cf_CacheOMatic>











