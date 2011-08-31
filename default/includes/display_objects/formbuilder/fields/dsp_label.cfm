<cfif len(field.rblabel)>
	<cfoutput><label for="#field.name#">#$.rbKey(field.rblabel)#</cfoutput>
<cfelse>
	<cfoutput><label for="#field.name#">#field.label#</cfoutput>
</cfif>	
