<cfif len(arguments.field.rblabel)>
	<cfoutput><label for="#arguments.field.name#">#$.rbKey(arguments.field.rblabel)#</cfoutput>
<cfelse>
	<cfoutput><label for="#arguments.field.name#">#arguments.field.label#</cfoutput>
</cfif>	
