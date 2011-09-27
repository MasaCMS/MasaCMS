<cfif len(arguments.field.rblabel)>
	<cfoutput><label for="#arguments.field.name#">#$.rbKey(arguments.field.rblabel)#</cfoutput>
<cfelse>
	<cfoutput>
	<cfif field.fieldtype.fieldtype eq "radio">
		<p>#arguments.field.label#
	<cfelseif field.fieldtype.fieldtype eq "checkbox">
		<p>#arguments.field.label#
	<cfelse>
		<label for="#arguments.field.name#">#arguments.field.label#
	</cfif>
	</cfoutput>
</cfif>	
