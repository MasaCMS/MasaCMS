<cfsilent>
	<cfparam name="objectParams.sourcetype" default="">
	<cfparam name="objectParams.source" default="">
	<cfparam name="objectParams.layout" default="default">
	<cfparam name="objectParams.displaylist" default="Date,Title,Summary,Credits,Tags">
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

				<cfset variables.pagination=variables.$.dspObject_include(
					theFile='collection/dsp_pagination.cfm', 
					iterator=iterator, 
					nextN=iterator.getNextN(),
					source=objectParams.source
				)>

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
				<cfset variables.pagination=variables.$.dspObject_include(
					theFile='collection/dsp_pagination.cfm', 
					iterator=iterator, 
					nextN=iterator.getNextN(),
					source=objectParams.source
				)>
			</cfcase>
			<cfcase value="children">
				<cfif not isNumeric(variables.$.event('year'))>
					<cfset variables.$.event('year',year(now()))>
				</cfif>

				<cfif isNumeric(variables.$.event('day')) and variables.$.event('day')
					and variables.$.event('filterBy') eq "releaseDate">
					<cfset variables.menuType="releaseDate">
					<cfset variables.menuDate=createDate(variables.$.event('year'),variables.$.event('month'),variables.$.event('day'))>
				<cfelseif variables.$.event('filterBy') eq "releaseMonth">
					<cfset variables.menuType="releaseMonth">
					<cfset variables.menuDate=createDate(variables.$.event('year'),variables.$.event('month'),1)>
				<cfelseif variables.$.event('filterBy') eq "releaseYear">
					<cfset variables.menuType="releaseYear">
					<cfset variables.menuDate=createDate(variables.$.event('year'),1,1)>
				<cfelse>
					<cfset variables.menuDate=now()>
					<cfset variables.menuType="default">
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
				<cfset iterator=$.getBean('feed')
					.loadBy(feedid=objectParams.source)
					.set(objectParams)
					.getIterator()>

				<cfset variables.pagination=variables.$.dspObject_include(
					theFile='collection/dsp_pagination.cfm', 
					iterator=iterator, 
					nextN=iterator.getNextN(),
					source=objectParams.source
				)>

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
	<div class="mura-object-meta">#$.dspObject_Include(thefile='meta/index.cfm',params=objectParams)#</div>
	<div class="mura-object-content">
		#variables.$.dspObject_include(
					theFile='collection/layouts/#objectParams.layout#/index.cfm', 
					propertyMap=propertyMap, 
					iterator=iterator, 
					objectParams=objectParams
				)#
	</div>
	</cfoutput>
<cfelse>
	<cfoutput>#variables.dspObject(object='feed',objectid=objectParams.source,params=objectParams)#</cfoutput>
</cfif>