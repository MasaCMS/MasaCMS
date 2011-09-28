<cfsilent>
<cfset strField = "" />
</cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	#$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</p>
	<cfloop from="1" to="#ArrayLen(dataset.datarecordorder)#" index="iiy">
		<cfset record = dataset.datarecords[dataset.datarecordorder[iiy]] />
		<label for="#record.datarecordid#"><input name="#field.name#" id="#record.datarecordid#" type="radio"<cfif record.isselected eq 1> CHECKED</cfif> value="#record.value#">#record.label#</label>
	</cfloop>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#strField#
</cfoutput>