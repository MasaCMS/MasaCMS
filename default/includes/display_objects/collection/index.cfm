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
<cfsilent>
	<cfparam name="objectParams.sourcetype" default="">
	<cfparam name="objectParams.source" default="">
	<cfparam name="objectParams.layout" default="default">
	<cfparam name="objectParams.displaylist" default="Image,Date,Title,Summary,Credits,Tags">
	<cfparam name="objectParams.items" default="">
	<cfparam name="objectParams.maxitems" default="4">
	<cfparam name="objectParams.nextN" default="20">
	<cfparam name="objectParams.sortBy" default="">
	<cfparam name="objectParams.sortDirection" default="">
	<cfparam name="objectParams.viewalllink" default="">
	<cfparam name="objectParams.viewalllabel" default="">

	<cfif not len(objectparams.layout)>
		<cfset objectParams.layout='default'>
	</cfif>

	<cfset objectParams.layout=listLast(replace(objectParams.layout, "\", "/", "ALL"),"/")>

	<cfset objectParams.layout=objectParams.layout>
	
</cfsilent>
<cfif objectParams.sourcetype neq 'remotefeed'>
	<cfsilent>
		<cfset variables.pagination=''>

		<cfswitch expression="#objectParams.sourceType#">
			<cfcase value="relatedcontent">
				<cfif objectParams.source eq 'custom'>
					<cfif isJson(objectParams.items)>
						<cfset objectParams.items=deserializeJSON(objectParams.items)>
					</cfif>
					<cfif isArray(objectParams.items)>
						<cfset objectparams.items=arrayToList(objectparams.items)>
					</cfif>
					<cfset objectParams.contentids=objectParams.items>
					<cfset objectParams.siteid=$.event('siteid')>
					<cfset iterator=$.getBean('contentManager')
						.findMany(
							argumentCollection=objectParams
						)>
	
				<cfelse>
					<cfset iterator=$.content().getRelatedContentIterator(relatedcontentsetid=objectParams.source)>
				</cfif>

			</cfcase>
			<cfcase value="calendar">
				<cfset calendarUtility=variables.$.getCalendarUtility()>

				<cfif not isNumeric(variables.$.event('year'))>
					<cfset variables.$.event('year',year(now()))>
				</cfif>

				<cfif isNumeric(variables.$.event('day')) and variables.$.event('day')
					and variables.$.event('filterBy') eq "releaseDate">
					<cfset variables.menuType="releaseDate">
					<cfset variables.menuDate=createDate(variables.$.event('year'),variables.$.event('month'),variables.$.event('day'))>
					<cfset iterator=calendarUtility.getCalendarItems(
						calendarid=arrayToList(objectParams.items),
						tag=variables.$.event('tag'),
						categoryid=variables.$.event('categoryid'),
						start=variables.menuDate,
						end=variables.menuDate,
						returnFormat='iterator'
					)>
				<cfelseif variables.$.event('filterBy') eq "releaseMonth">
					<cfset variables.menuType="releaseMonth">
					<cfset variables.menuDate=createDate(variables.$.event('year'),variables.$.event('month'),1)>
					<cfset iterator=calendarUtility.getCalendarItems(
						calendarid=arrayToList(objectParams.items),
						tag=variables.$.event('tag'),
						categoryid=variables.$.event('categoryid'),
						start=createDate(year(variables.menudate),month(variables.menudate),1),
						end=createDate(year(variables.menudate),month(variables.menudate),daysInMonth(variables.menudate)),
						returnFormat='iterator'
					)>
				<cfelseif variables.$.event('filterBy') eq "releaseYear">
					<cfset variables.menuType="releaseYear">
					<cfset variables.menuDate=createDate(variables.$.event('year'),1,1)>
					<cfset iterator=calendarUtility.getCalendarItems(
						calendarid=arrayToList(objectParams.items),
						tag=variables.$.event('tag'),
						categoryid=variables.$.event('categoryid'),
						start=createDate(year(variables.menudate),1,1),
						end=createDate(year(variables.menudate),12,31),
						returnFormat='iterator'
					)>
				<cfelse>
					<cfset variables.menuDate=now()>
					<cfset variables.menuType="default">
					<cfset iterator=calendarUtility.getCalendarItems(
						calendarid=arrayToList(objectParams.items),
						tag=variables.$.event('tag'),
						categoryid=variables.$.event('categoryid'),
						start=createDate(year(variables.menudate),month(variables.menudate),1),
						end=createDate(year(variables.menudate),month(variables.menudate),daysInMonth(variables.menudate)),
						returnFormat='iterator'
					)>
				</cfif>

				<cfset iterator.setNextN(variables.$.event('nextn'))>
				<cfset iterator.setStartRow(variables.$.event('startrow'))>
			</cfcase>
			<cfcase value="children">
				<cfif not isNumeric(variables.$.event('year'))>
					<cfset variables.$.event('year',year(now()))>
				</cfif>

				<cfif isNumeric(variables.$.event('day')) and variables.$.event('day')
					and variables.$.event('filterBy') eq "releaseDate">
					<cfset objectParams.type="releaseDate">
					<cfset objectParams.today=createDate(variables.$.event('year'),variables.$.event('month'),variables.$.event('day'))>
				<cfelseif variables.$.event('filterBy') eq "releaseMonth">
					<cfset objectParams.type="releaseMonth">
					<cfset objectParams.today=createDate(variables.$.event('year'),variables.$.event('month'),1)>
				<cfelseif variables.$.event('filterBy') eq "releaseYear">
					<cfset objectParams.type="releaseYear">
					<cfset objectParams.today=createDate(variables.$.event('year'),1,1)>
				<cfelse>
					<cfset objectParams.today=now()>
					<cfset objectParams.type="default">
				</cfif>

				<cfset variables.maxPortalItems=variables.$.globalConfig("maxPortalItems")>
				<cfif not isNumeric(variables.maxPortalItems)>
					<cfset variables.maxPortalItems=100>
				</cfif>

				<cfif variables.$.siteConfig('extranet') eq 1 and variables.$.event('r').restrict eq 1>
					<cfset objectParams.applyPermFilter=true/>
				<cfelse>
					<cfset objectParams.applyPermFilter=false/>
				</cfif>
				
				<cfif not len(objectParams.sortBy)>
					<cfset objectParams.sortBy=$.content('sortBy')>
				</cfif>

				<cfif not len(objectParams.sortDirection)>
					<cfset objectParams.sortDirection=$.content('sortDirection')>
				</cfif>

				<cfset iterator=$.content().set(objectParams).getKidsIterator(argumentCollection=objectParams)>
				
			</cfcase>
			<cfdefaultcase>
				<cfif not len(objectParams.sortBy)>
					<cfset structDelete(objectParams,'sortby')>
				</cfif>

				<cfif not len(objectParams.sortDirection)>
					<cfset structDelete(objectParams,'sortDirection')>
				</cfif>

				<cfset iterator=$.getBean('feed')
					.loadBy(feedid=objectParams.source)
					.set(objectParams)
					.getIterator()>

			</cfdefaultcase>
		</cfswitch>


		<cfset propertyMap={
			itemEl={tag="div",class="mura-item-meta"},
			labelEl={tag="span"},
			title={tag="div"},
			date={tag="div"},
			credits={tag="div",showLabel=true,labelDelim=":",rbkey="list.by"},
			tags={tag="div",showLabel=true,labelDelim=":",rbkey="tagcloud.tags"},
			rating={tag="div",showLabel=true,labelDelim=":",rbkey="list.rating"},
			'default'={tag="div"}
		}>
	</cfsilent>
	<cfoutput>
		#variables.$.dspObject_include(
					theFile='collection/layouts/#objectParams.layout#/index.cfm', 
					propertyMap=propertyMap, 
					iterator=iterator, 
					objectParams=objectParams
				)#
	</cfoutput>
<cfelse>
	<cfoutput>#variables.dspObject(object='feed',objectid=objectParams.source,params=objectParams)#</cfoutput>
</cfif>