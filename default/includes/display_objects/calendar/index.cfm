<!---
|| BEGIN FUSEDOC ||
	
|| Properties ||
Name: 
Author: John Crocker (john@netadvances.co.uk
Template Created: 18-07-2002
Last Updated: 

|| Responsibilities ||
Lazarus contentServer Sitemap
|| URL ||


|| END FUSEDOC ||--->

<!----------------------------
|| BEGIN FUSEBOX APPLICATION ||
------------------------------>

<!--- Global parameters --->
<!---<cfoutput>#URLList#</cfoutput>  --->

<!--- Default Action --->
<cfsilent>
<cfparam name="request.filterBy" default="">
<cfparam name="request.day" default="0">


<cfif request.filterBy eq "releaseDate">
	<cfset menuType="CalendarDate">
<cfelse>
	<cfset menuType="CalendarMonth">
</cfif>

<cfif not isNumeric(request.month)>
	<cfset request.month=month(now())>
</cfif>

<cfif not isNumeric(request.year)>
	<cfset request.year=year(now())>
</cfif>

<cfif isNumeric(request.day) and request.day
	and menuType eq "CalendarDate">
	<cfset menuDate=createDate(request.year,request.month,request.day)>
<cfelseif menuType eq "CalendarMonth">
	<cfset menuDate=createDate(request.year,request.month,1)>
</cfif>

<cfset rsPreSection=application.contentGateway.getKids('00000000000000000000000000000000000',request.siteid,$.content('contentID'),menuType,menuDate,100,request.keywords,0,"displayStart","asc",request.categoryID,request.relatedID,request.tag)>
<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
	<cfset rssection=queryPermFilter(rsPreSection)/>
<cfelse>
	<cfset rssection=rsPreSection/>
</cfif>
<cfset rbFactory=getSite().getRBFactory() />	
</cfsilent>				

<cfoutput>
<cfinclude template="myglobals.cfm">
<cfif request.filterBy eq "">
<!---<a href="index.cfm?month=#htmlEditFormat(request.month)#&year=#htmlEditFormat(request.year)#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#&filterBy=releaseMonth">View in List Format</a>--->
<cfinclude template="dsp_dp_showmonth.cfm">
<cfelse>
<!---<a href="index.cfm?month=#htmlEditFormat(request.month)#&year=#htmlEditFormat(request.year)#&categoryID=#htmlEditFormat(request.categoryID)#&relatedID=#htmlEditFormat(request.relatedID)#">View in Calendar Format</a>--->
<cfinclude template="dsp_list.cfm">
</cfif>
</cfoutput>










