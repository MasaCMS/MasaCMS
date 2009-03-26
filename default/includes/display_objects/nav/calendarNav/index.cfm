<cfsilent>
<!--- set this to the number of months back you would like to display --->	
<cfparam name="request.sortBy" default=""/>
<cfparam name="request.sortDirection" default=""/>
<cfparam name="request.day" default="#day(now())#"/>
<cfset navTools=createObject("component","navTools")>
<cfset addToHTMLHeadQueue('nav/calendarNav/htmlhead/htmlhead.cfm')>
<cfset navID=arguments.objectID>

<cfquery datasource="#application.configBean.getDatasource()#" 
		username="#application.configBean.getDBUsername()#" 
		password="#application.configBean.getDBPassword()#" 
		name="rsSection">
		select filename,menutitle from tcontent where siteid='#request.siteid#' and contentid='#arguments.objectid#' and approved=1 and active=1 and display=1
</cfquery>

<cfset navPath="#application.configBean.getContext()##getURLStem(request.siteID,rsSection.filename)#">
<cfset navMonth=request.month >
<cfset navYear=request.year >
<cfset navDay=request.day >
</cfsilent>
<div id="svCalendarNav">
<cfset navTools.setParams(navMonth,navDay,navYear,navID,navPath) />
<cfoutput>#navTools.dspMonth()#</cfoutput>
</div>












