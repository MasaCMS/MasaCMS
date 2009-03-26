<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfsetting enablecfoutputonly="yes">
<cfsilent>

<cfparam name="url.username" default="" />
<cfparam name="url.password" default="" />
<cfparam name="url.filter" default="" />
<cfparam name="url.feedID" default="" />
<cfparam name="url.contentID" default="" />
<cfparam name="url.categoryID" default="" />
<cfparam name="url.siteid" default=""/>
<cfparam name="url.maxItems" default="20"/>
<cfparam name="url.tag" default=""/>

<cfif url.feedID neq "">
	<cfset feedBean=application.feedManager.read(url.feedID) />
	<cfif feedBean.getRestricted() and application.settingsManager.getSite(feedBean.getSiteID()).getextranetssl() and  cgi.https eq 'Off'>
		<cfif cgi.query_string eq ''>
			<cfset location='#cgi.script_name#'>
		<cfelse>
			<cfset location='#cgi.script_name#?#cgi.QUERY_STRING#'>
		</cfif>
		<cflocation addtoken="no" url="https://#request.rspage.domain##location#">
	</cfif>
<cfelseif url.siteid neq "">
	<cfset feedBean=application.feedManager.read("") />
	<cfset feedBean.set(url)/>
</cfif>

<cfset rs=application.feedManager.getFeed(feedBean,url.tag) />
</cfsilent>	

<cfif isDefined("feedBean")>
	<cfif not application.feedManager.allowFeed(feedBean,url.username,url.password) >
		This feed is restricted
		<cfabort>
	</cfif>
	<cfset renderer = createObject("component","#application.configBean.getWebRootMap()#.#feedBean.getSiteID()#.includes.contentRenderer").init() />
	<cfswitch expression="#feedBean.getVersion()#">
		<cfcase value="RSS 0.920">
			<cfinclude template="rss0920.cfm">
		</cfcase>
		<cfcase value="RSS 2.0">
			<cfinclude template="rss2.cfm">
		</cfcase>
	</cfswitch>
</cfif>
<cfsetting enablecfoutputonly="no">

