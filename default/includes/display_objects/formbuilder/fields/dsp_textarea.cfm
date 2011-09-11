<cfset strField = "" />
<cfsilent>
<cfsavecontent variable="strField">
	<cfoutput>
	#$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#</label>
	<textarea name="#field.name#"
	#$.dspObject_Include(thefile='/formbuilder/fields/dsp_common.cfm',field=arguments.field,dataset=arguments.dataset)#
	#strField#>#field.value#</textarea>
	</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>#strField#</cfoutput>