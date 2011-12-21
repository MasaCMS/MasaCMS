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

<cfif not isNumeric($.event('month'))>
	<cfset $.event('year',month(now()))>
</cfif>

<cfif not isNumeric($.event('year'))>
	<cfset $.event('year',year(now()))>
</cfif>

<cfif isNumeric($.event('day')) and $.event('day')
	and menuType eq "CalendarDate">
	<cfset menuDate=createDate($.event('year'),$.event('month'),$.event('day'))>
<cfelseif menuType eq "CalendarMonth">
	<cfset menuDate=createDate($.event('year'),$.event('month'),1)>
</cfif>

<cfset rsPreSection=$.getBean('contentGateway').getKids('00000000000000000000000000000000000',$.event('siteID'),$.content('contentID'),menuType,menuDate,100,$.event('keywords'),0,"displayStart","asc",$.event('categoryID'),$.event('relatedID'),$.event('tag'))>
<cfif $.siteConfig('extranet') eq 1 and $.event('r').restrict eq 1>
	<cfset rssection=$.queryPermFilter(rsPreSection)/>
<cfelse>
	<cfset rssection=rsPreSection/>
</cfif>
</cfsilent>				
<cfoutput>
<cfinclude template="myglobals.cfm">
<cfif $.event("filterBy") eq "">
<!---<a href="index.cfm?month=#htmlEditFormat($.event('month'))#&year=#htmlEditFormat($.event('year'))#&categoryID=#htmlEditFormat($.event('categoryID'))#&relatedID=#htmlEditFormat($.event('relatedID'))#&filterBy=releaseMonth">View in List Format</a>--->
<cfinclude template="dsp_dp_showmonth.cfm">
<cfelse>
<!---<a href="index.cfm?month=#htmlEditFormat($.event('month'))#&year=#htmlEditFormat($.event('year'))#&categoryID=#htmlEditFormat($.event('categoryID'))#&relatedID=#htmlEditFormat($.event('relatedID'))#">View in Calendar Format</a>--->
<cfinclude template="dsp_list.cfm">
</cfif>
</cfoutput>










