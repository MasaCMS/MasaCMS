<cfset strField = "" />
<cfsilent>
</cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	#$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</p>
	<cfloop from="1" to="#ArrayLen(dataset.datarecordorder)#" index="iiy">
		<cfset record = dataset.datarecords[dataset.datarecordorder[iiy]] />
		<input name="#field.name#" id="#record.datarecordid#" type="radio"<cfif record.isselected eq 1> CHECKED</cfif> value="#record.value#"><label for="#record.datarecordid#">#record.label#</label>
	</cfloop>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#strField#
</cfoutput>