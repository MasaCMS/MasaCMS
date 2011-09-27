<cfset fbManager = $.getBean('formBuilderManager') />

<cfset frmID		= "frm" & replace(arguments.formID,"-","","ALL") />
<cfset frm			= fbManager.renderFormJSON( arguments.formJSON ) />
<cfset frmForm		= frm.form />
<cfset frmData		= frm.datasets />
<cfset frmFields	= frmForm.fields />
<cfset dataset		= "" />

<cfset aFieldOrder = frmForm.fieldorder />
<cfoutput>
<form id="#frmID#" method="post">
<input type="hidden" name="siteid" value="#arguments.siteid#">
<input type="hidden" name="formid" value="#arguments.formid#">
<fieldset id="set-default">
<ol>
<cfloop from="1" to="#ArrayLen(aFieldOrder)#" index="iiX">
	<cfif StructKeyExists(frmFields,aFieldOrder[iiX])>
		<cfset field = frmFields[aFieldOrder[iiX]] />
		<cfif field.fieldtype.isdata eq 1 and len(field.datasetid)>
			<cfset dataset = frmData[field.datasetid] /> 
		</cfif>
		<cfif field.fieldtype.fieldtype neq "section">
		<li<cfif field.fieldtype.fieldtype eq "radio"> class="mura-form-radio"
		<cfelseif field.fieldtype.fieldtype eq "checkbox"> class="mura-form-checkbox"
		</cfif>>
		#$.dspObject_Include(thefile='/formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm',
			field=field,
			dataset=dataset
			)#			
		</li>
		<cfelse>
		<li>
		#$.dspObject_Include(thefile='/formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm',
			field=field,
			dataset=dataset
			)#
		</li>
		</cfif>		
		<!---#$.dspObject_Include('formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm')#--->
	<cfelse>
		<!---<cfthrow message="ERROR 9000: Field Missing: #aFieldOrder[iiX]#">--->
	</cfif>
</cfloop>
</ol>	
	</fieldset>
	<div class="buttons"><input type="submit" class="submit" value="Submit"></div>
</form>
</cfoutput>


<!---jQuery Mobile Example Output--->

<!---Radio Buttons--->
<!---<ol >
    <li data-role="controlgroup">
    	<p>Choose a pet:</p>
         	<input type="radio" name="radio-choice-1" id="radio-choice-1" value="choice-1" checked="checked" />
         	<label for="radio-choice-1">Cat</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-2" value="choice-2"  />
         	<label for="radio-choice-2">Dog</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-3" value="choice-3"  />
         	<label for="radio-choice-3">Hamster</label>

         	<input type="radio" name="radio-choice-1" id="radio-choice-4" value="choice-4"  />
         	<label for="radio-choice-4">Lizard</label>
    </li>
</ol>--->

<!---Checkboxes--->
<!---<ul >
 	<li data-role="controlgroup">
		<p>Agree to the terms:</p>
		<input type="checkbox" name="checkbox-1" id="checkbox-1" class="custom" />
		<label for="checkbox-1">I agree</label>
    </li>
</ul>--->