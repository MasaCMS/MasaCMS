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
	<fieldset id="set-default" data-role="controlgroup">
<cfloop from="1" to="#ArrayLen(aFieldOrder)#" index="iiX">
	<cfif StructKeyExists(frmFields,aFieldOrder[iiX])>
		<cfset field = frmFields[aFieldOrder[iiX]] />
		<cfif field.fieldtype.isdata eq 1 and len(field.datasetid)>
			<cfset dataset = frmData[field.datasetid] /> 
		</cfif>
		<cfif field.fieldtype.fieldtype neq "section">
		<li id="fld-#field.name#" data-role="controlgroup">
		#$.dspObject_Include(thefile='/formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm',
			field=field,
			dataset=dataset
			)#			
		</li>
		<cfelse>
		#$.dspObject_Include(thefile='/formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm',
			field=field,
			dataset=dataset
			)#
		</cfif>			
		<!---#$.dspObject_Include('formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm')#--->
	<cfelse>
		<!---<cfthrow message="ERROR 9000: Field Missing: #aFieldOrder[iiX]#">--->
	</cfif>
</cfloop>	
	</fieldset>
	<div class="buttons"><input type="submit" class="submit" value="Submit"></div>
</form>
</cfoutput>


<!---jQuery Mobile Example Output--->

<!---Radio Buttons--->
<!---<ul data-role="fieldcontain">
    <li data-role="controlgroup">
    	<legend>Choose a pet:</legend>
         	<input type="radio" name="radio-choice-1" id="radio-choice-1" value="choice-1" checked="checked" />
         	<label for="radio-choice-1">Cat</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-2" value="choice-2"  />
         	<label for="radio-choice-2">Dog</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-3" value="choice-3"  />
         	<label for="radio-choice-3">Hamster</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-4" value="choice-4"  />
         	<label for="radio-choice-4">Lizard</label>
    </li>
</ul>--->

<!---Checkboxes--->
<!---<ul data-role="fieldcontain">
 	<li data-role="controlgroup">
		<legend>Agree to the terms:</legend>
		<input type="checkbox" name="checkbox-1" id="checkbox-1" class="custom" />
		<label for="checkbox-1">I agree</label>
    </li>
</ul>--->