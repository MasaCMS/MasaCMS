<cfoutput>
<cfif objectParams.addlabel>
	<h2>#esapiEncode('html',objectParams.label)#</h2>
</cfif>
<cfif listFindNoCase('localindex,remotefeed',objectParams.sourcetype)>
	#$.dspObject_include(thefile='dsp_feed.cfm',objectid=objectParams.sourceid,params=objectParams,nested=true)#
<cfelseif listFindNoCase('relatedcontent',objectParams.sourcetype)>
	#$.dspObject_Include(thefile='dsp_related_content.cfm',objectid=objectParams.sourceid,params=objectParams,nested=true)#
<cfelse>
	<p class="alert">
		This collection has not be defined.
	</p>
</cfif>
</cfoutput>