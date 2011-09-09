<cfset fbManager = $.getBean('formBuilderManager') />

<cfset frmID		= "frm" & replace(arguments.formID,"-","","ALL") />
<cfset frm			= fbManager.renderFormJSON( arguments.formJSON ) />
<cfset frmForm		= frm.form />
<cfset frmData		= frm.datasets />
<cfset frmFields	= frmForm.fields />
<cfset dataset		= "" />

<cfset aFieldOrder = frmForm.fieldorder />
<cfoutput>
<form data-role="fieldcontain" id="#frmID#" method="post">
<input type="hidden" name="siteid" value="#arguments.siteid#">
<input type="hidden" name="formid" value="#arguments.formid#">
<ul>
<cfloop from="1" to="#ArrayLen(aFieldOrder)#" index="iiX">
	<cfif StructKeyExists(frmFields,aFieldOrder[iiX])>
		<cfset field = frmFields[aFieldOrder[iiX]] />
		<cfif field.fieldtype.isdata eq 1 and len(field.datasetid)>
			<cfset dataset = frmData[field.datasetid] /> 
		</cfif>
		<li>
		#dspObject_Include(thefile='/formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm',
			field=field,
			dataset=dataset
			)#			
		</li>
		<!---#$.dspObject_Include('formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm')#--->
	<cfelse>
		<!---<cfthrow message="ERROR 9000: Field Missing: #aFieldOrder[iiX]#">--->
	</cfif>
</cfloop> 
	<li><input type="Submit"></li>
</ul>	
</form>
</cfoutput>
