<cfoutput>
<cfif listFindNoCase('localindex,remotefeed',objectParams.sourcetype)>
	#$.dspObject_include(thefile='dsp_feed.cfm',objectid=objectParams.source,params=objectParams)#
<cfelseif listFindNoCase('relatedcontent',objectParams.sourcetype)>
	#$.dspObject_Include(thefile='dsp_related_content.cfm',objectid=objectParams.source,params=objectParams)#
<cfelse>
	<p class="alert">
		This collection has not be defined.
	</p>
</cfif>
</cfoutput>