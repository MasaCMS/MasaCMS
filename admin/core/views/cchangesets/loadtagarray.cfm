<cfset request.layout=false>
<cfset tags=$.getBean('changesetManager').getTagCloud(siteid=$.event('siteID')) />
<cfoutput>[<cfloop query="tags">{id: '#encodeForJavascript(tags.tag)#', toString: function() { return '#encodeForJavascript(tags.tag)#'; } }<cfif tags.currentrow lt tags.recordcount>,</cfif></cfloop>]</cfoutput><cfabort>