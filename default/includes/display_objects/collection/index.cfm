<cfsilent>
	<cfparam name="objectParams.sourcetype" default="">
	<cfparam name="objectParams.source" default="">
	<cfparam name="objectParams.layout" default="default">
	<cfparam name="objectParams.displaylist" default="">
	<cfparam name="objectParams.items" default="">
	<cfparam name="objectParams.maxitems" default="5">
	
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
		</cfcase>
		<cfdefaultcase>
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
<div class="mura-object-meta">#$.dspObject_Include(thefile='meta/index.cfm',params=objectParams)#</div>
<div class="mura-object-content">
	#variables.$.dspObject_include(
				theFile='collection/layouts/#objectParams.layout#.cfm', 
				propertyMap=propertyMap, 
				iterator=iterator, 
				objectParams=objectParams
			)#

</div>
</cfoutput>