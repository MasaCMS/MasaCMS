<cfoutput>
<cfif rc.compactDisplay eq 'true'>
#layout('compact', body)#
<cfelse>
#layout('template', body)#
</cfif>
</cfoutput>