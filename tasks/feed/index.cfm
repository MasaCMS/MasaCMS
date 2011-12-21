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

<cfsetting enablecfoutputonly="yes">
<cfsilent>
<cfset is404=false>
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
	<cfif feedBean.getIsNew()>
		<cfset is404=true>
	</cfif>
<cfelseif url.siteid neq "">
	<cfset feedBean=application.feedManager.read("") />
	<cfset feedBean.set(url)/>
<cfelse>
	<cfset is404=true>
</cfif>
<cfif isDefined("feedBean") and not is404>
	<cfset rs=application.feedManager.getFeed(feedBean,url.tag) />
</cfif>
</cfsilent>	
<cfif is404>
	<cfheader statuscode="404" statustext="Not Found">
	<cfoutput>
	#application.contentServer.render404()#
	</cfoutput>
	<cfabort>
</cfif>
<cfif isDefined("feedBean")>
	<cfif not application.feedManager.allowFeed(feedBean,url.username,url.password) >
		This feed is restricted
		<cfabort>
	</cfif>
	<cfset feedIt = application.serviceFactory.getBean("contentIterator").setQuery(rs)>
	<cfset renderer = createObject("component","#application.configBean.getWebRootMap()#.#application.settingsManager.getSite(feedBean.getSiteID()).getDisplayPoolID()#.includes.contentRenderer").init() />
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

