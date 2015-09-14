<cfoutput>
<cfif objectParams.addlabel>
	<h2>#esapiEncode('html',objectParams.label)#</h2>
</cfif>
<cfif listFindNoCase('localindex,remotefeed',objectParams.sourcetype)>
	#$.dspObject(object='feed',objectid=objectParams.sourceid,params=objectParams)#
<cfelseif listFindNoCase('localindex,remotefeed',objectParams.sourcetype)>
	#$.dspObject(object='relatedcontent',objectid=objectParams.sourceid,params=objectParams)#
<cfelse>
	<p class="alert">
		This collection has not be defined.
	</p>
</cfif>
</cfoutput>