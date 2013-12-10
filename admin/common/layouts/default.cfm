<cfcontent reset="true"><cfprocessingdirective suppressWhitespace="true"><cfoutput>
<cfif rc.compactDisplay eq 'true'>
<cfinclude template="compact.cfm">
<cfelse>
<cfinclude template="template.cfm">
</cfif>
</cfoutput></cfprocessingdirective>