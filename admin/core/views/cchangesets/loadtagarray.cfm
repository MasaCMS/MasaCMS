<cfset request.layout=false>
<cfset tags=$.getBean('changesetManager').getTagCloud(siteid=$.event('siteID')) />
<cfoutput>[<cfloop query="tags">{id: '#esapiEncode('javascript',tags.tag)#', toString: function() { return '#esapiEncode('javascript',tags.tag)#'; } }<cfif tags.currentrow lt tags.recordcount>,</cfif></cfloop>]</cfoutput><cfabort>