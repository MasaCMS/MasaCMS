<cfset strField = "" />
<cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	</ol>
</fieldset>
<fieldset id="set-#field.name#">
	<legend>#field.label#</legend>
	<ol>
	</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>
#strField#
</cfoutput>