<cfset request.layout=false>
<cfset tags=$.getBean('changesetManager').getTagCloud(siteid=$.event('siteID')) />
<cfoutput>[<cfloop query="tags">{id: '#JSStringFormat(tags.tag)#', toString: function() { return '#JSStringFormat(tags.tag)#'; } }<cfif tags.currentrow lt tags.recordcount>,</cfif></cfloop>]</cfoutput><cfabort>