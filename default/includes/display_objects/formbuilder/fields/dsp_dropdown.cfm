<cfset strField = "" />
<cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	#dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#
	<select name="#field.name#"
	</cfoutput>
</cfsavecontent>
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