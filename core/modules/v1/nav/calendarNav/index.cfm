<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes
	the preparation of a derivative work based on Mura CMS. Thus, the terms
	and conditions of the GNU General Public License version 2 ("GPL") cover
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant
	you permission to combine Mura CMS with programs or libraries that are
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS
	grant you permission to combine Mura CMS with independent software modules
	(plugins, themes and bundles), and to distribute these plugins, themes and
	bundles without Mura CMS under the license of your choice, provided that
	you follow these specific guidelines:

	Your custom code

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/core/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that
	meets the above guidelines as a combined work under the terms of GPL for
	Mura CMS, provided that you include the source code of that other code when
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not
	obligated to grant this special exception for your modified version; it is
	your choice whether to do so, or to make such modified version available
	under the GNU General Public License version 2 without this exception.  You
	may, if you choose, apply this exception to your own modified versions of
	Mura CMS.
--->
<cfsilent>
<!--- set this to the number of months back you would like to display --->
<cfparam name="request.sortBy" default=""/>
<cfparam name="request.sortDirection" default=""/>
<cfparam name="request.day" default="#day(now())#"/>
<cfset targetFormat='list'>
<cfset $.addToHTMLHeadQueue('nav/calendarNav/htmlhead/htmlhead.cfm')>
<cfif not isValid('uuid',arguments.objectid)>
	<cfset variables.crumbIterator=variables.$.content().getCrumbIterator()>
	<cfloop condition="variables.crumbIterator.hasNext()">
		<cfset variables.crumb=variables.crumbIterator.next()>
		<cfif listFindNoCase('Folder,Calendar',variables.crumb.getType())>
			<cfset arguments.objectid=variables.crumb.getContentID()>
			<cfif variables.crumb.getType() eq 'Calendar'>
				<cfset targetFormat=variables.$.content().getObjectParam('format')>
				<cfif not len(targetFormat)>
					<cfset targetFormat='Calendar'>
				</cfif>
			</cfif>
			<cfbreak>
		</cfif>
	</cfloop>
<cfelseif variables.$.content('contentid') neq arguments.objectid>
	<cfset targetContent=variables.$.getBean('content').loadBy(contentid=arguments.objectid)>
	<cfif targetContent.getType() eq 'Calendar'>
		<cfset targetFormat=targetContent.getObjectParam('format')>
		<cfif not len(targetFormat)>
			<cfset targetFormat='Calendar'>
		</cfif>
	</cfif>
<cfelseif variables.$.content('type') eq 'Calendar'>
	<cfset targetFormat=variables.$.content().getObjectParam('format')>
	<cfif not len(targetFormat)>
		<cfset targetFormat='Calendar'>
	</cfif>
</cfif>
</cfsilent>
<cfif targetFormat neq 'Calendar'>
<cf_CacheOMatic key="#arguments.object##$.event('siteid')##arguments.objectid##$.event('month')##$.event('year')#" nocache="#$.event('nocache')#">
<cfsilent>
<cfset navTools=createObject("component","navTools").init($)>
<cfset navID=arguments.objectID>
<cfquery datasource="#application.configBean.getDatasource()#"
		username="#application.configBean.getDBUsername()#"
		password="#application.configBean.getDBPassword()#"
		name="rsSection">
		select filename,menutitle,type from tcontent where siteid=<cfqueryparam value="#$.event('siteID')#" cfsqltype="varchar"> and contentid=<cfqueryparam value="#arguments.objectid#" cfsqltype="varchar"> and approved=1 and active=1 and display=1
</cfquery>

<cfset navPath="#$.siteConfig('context')##getURLStem($.event('siteID'),rsSection.filename)#">
<cfset navMonth=request.month >
<cfset navYear=request.year >
<cfset navDay=request.day >
<cfif rsSection.type eq "Folder">
	<cfset navType = "releaseMonth">
<cfelse>
	<cfset navType = "CalendarMonth">
</cfif>
</cfsilent>
<cfoutput>
<nav id="svCalendarNav" class="mura-calendar mura-calendar-nav #this.navCalendarWrapperClass# ">
<cfset navTools.setParams(navMonth,navDay,navYear,navID,navPath,navType) />
#navTools.dspMonth()#
</nav>
</cfoutput>
</cf_CacheOMatic>
</cfif>
