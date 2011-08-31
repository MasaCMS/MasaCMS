<cfset strField = "" />
<cfinclude template="dsp_label.cfm">
<cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	<textarea name="#field.name#"
	</cfoutput>
</cfsavecontent>
<cfinclude template="dsp_common.cfm" />
<!---<cfinclude template="dsp_data_common.cfm" />--->
</cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	#strField#>#field.value#</textarea>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#strField#
</cfoutput>