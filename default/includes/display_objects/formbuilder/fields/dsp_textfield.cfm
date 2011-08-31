<cfset strField = "" />
<cfinclude template="dsp_label.cfm">
<cfsilent>
<cfsavecontent variable="strField">
	<cfoutput></label><input type="text" name="#field.name#" value="#field.value#"</cfoutput>
</cfsavecontent>
<cfinclude template="dsp_common.cfm" />
<cfinclude template="dsp_single_common.cfm" />
</cfsilent>
<cfoutput>
#strField# />
</cfoutput>