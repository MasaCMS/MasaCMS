<cfsilent>
	<cfparam name="objectParams.sourcetype" default="">
	<cfparam name="objectParams.source" default="">
	<cfparam name="objectParams.layout" default="default">
	<cfparam name="objectParams.displaylist" default="Date,Title,Summary,Credits,Tags">
	<cfparam name="objectParams.items" default="">
	<cfparam name="objectParams.maxitems" default="4">
	<cfparam name="objectParams.nextN" default="20">

	<cfif not len(objectparams.layout)>
		<cfset objectParams.layout='default'>
	</cfif>
</cfsilent>
<cfif objectParams.sourcetype neq 'remotefeed'>
	<cfsilent>
		<cfset variables.pagination=''>

		<cfset objectParams.layout=listFirst(listLast(replace(objectParams.layout, "\", "/", "ALL"),'/'),'.')>

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
			<cfcase value="children">
				<cfset iterator=$.content().getKidsIterator()>
			
				<cfset variables.pagination=variables.$.dspObject_include(
					theFile='collection/dsp_pagination.cfm', 
					iterator=iterator, 
					nextN=iterator.getNextN(),
					source=objectParams.source
				)>
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
					theFile='collection/layouts/#objectParams.layout#.cfm', 
					propertyMap=propertyMap, 
					iterator=iterator, 
					objectParams=objectParams
				)#

	</div>
	#variables.pagination#
	</cfoutput>
<cfelse>
	#variables.dspObject(object='feed',objectid=objectParams.source,params=objectParams)#
</cfif>