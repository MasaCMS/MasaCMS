<cfset strField = "" />
<cfsilent>
<!---<cfinclude template="dsp_data_common.cfm" />--->
</cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	<cfloop from="1" to="#ArrayLen(dataset.datarecordorder)#" index="iiy">
		<cfset record = dataset.datarecords[dataset.datarecordorder[iiy]] />
		<div><label for="record.datarecordid"><input name="#field.name#" type="checkbox"<cfif record.isselected eq 1> CHECKED</cfif> value="#record.value#">#record.label#</label></div>
	</cfloop>
	</select>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#strField#
</cfoutput>