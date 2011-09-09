<cfset strField = "" />
<cfsilent>
</cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	#dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</label>
	<cfloop from="1" to="#ArrayLen(dataset.datarecordorder)#" index="iiy">
		<cfset record = dataset.datarecords[dataset.datarecordorder[iiy]] />
		<div><input name="#field.name#" type="radio"<cfif record.isselected eq 1> CHECKED</cfif> value="#record.value#">#record.label#</div>
	</cfloop>
	</select>
	</cfoutput>
</cfsavecontent>
<cfoutput>
#strField#
</cfoutput>