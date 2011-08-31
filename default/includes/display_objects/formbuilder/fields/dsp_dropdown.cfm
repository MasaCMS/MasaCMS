<cfset strField = "" />
<cfinclude template="dsp_label.cfm">
<cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	<select name="#field.name#"
	</cfoutput>
</cfsavecontent>
<cfinclude template="dsp_common.cfm" />
<!---<cfinclude template="dsp_data_common.cfm" />--->
</cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	#strField#>
	<cfloop from="1" to="#ArrayLen(dataset.datarecordorder)#" index="iiy">
		<cfset record = dataset.datarecords[dataset.datarecordorder[iiy]] />
		<option<cfif len(record.value)> value="#record.value#"</cfif><cfif record.datarecordid eq dataset.defaultid> SELECTED</cfif>>#record.label#</option>
	</cfloop>
	</select>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#strField#
</cfoutput>