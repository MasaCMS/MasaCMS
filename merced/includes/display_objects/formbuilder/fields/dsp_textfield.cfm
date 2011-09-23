<cfsilent>
<cfset strField = "" />	
<cfsavecontent variable="strField">
	<cfoutput>
	#$.dspObject_Include(thefile='/formbuilder/fields/dsp_label.cfm',field=arguments.field,dataset=arguments.dataset)#
	</label><input type="text" name="#field.name#" value="#field.value#"#$.dspObject_Include(thefile='/formbuilder/fields/dsp_common.cfm',field=arguments.field,dataset=arguments.dataset)#</cfoutput>
</cfsavecontent>
</cfsilent>
<cfoutput>
#strField# />
</cfoutput>