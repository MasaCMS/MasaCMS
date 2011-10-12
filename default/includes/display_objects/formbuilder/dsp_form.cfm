<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
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
<!---<input type="hidden" name="siteid" value="#arguments.siteid#">
<input type="hidden" name="formid" value="#arguments.formid#">--->
<fieldset id="set-default">
<ol>
<cfloop from="1" to="#ArrayLen(aFieldOrder)#" index="iiX">
	<cfif StructKeyExists(frmFields,aFieldOrder[iiX])>
		<cfset field = frmFields[aFieldOrder[iiX]] />
		<cfif field.fieldtype.isdata eq 1 and len(field.datasetid)>
			<cfset dataset = fbManager.processDataset( $,frmData[field.datasetid] ) />  
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