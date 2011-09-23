<cfset strField = "" />
<cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	</ul>
</fieldset>
<fieldset id="set-#field.name#">
	<legend>#field.label#</legend>
	<ul>
	</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>
#strField#
</cfoutput>