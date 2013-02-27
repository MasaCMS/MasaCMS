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
<cfset variables.fbManager = $.getBean('formBuilderManager') />

<cfset variables.frmID		= "frm" & replace(arguments.formID,"-","","ALL") />
<cfset variables.frm			= variables.fbManager.renderFormJSON( arguments.formJSON ) />
<cfset variables.frmForm		= variables.frm.form />
<cfset variables.frmData		= variables.frm.datasets />
<cfset variables.frmFields	= variables.frmForm.fields />
<cfset variables.dataset		= "" />
<cfset variables.isMultipart	= false />

<!--- start with fieldsets closed --->
<cfset request.fieldsetopen = false />

<cfset variables.aFieldOrder = variables.frmForm.fieldorder />
<cfsavecontent variable="frmFieldContents">
<cfoutput>
<cfloop from="1" to="#ArrayLen(aFieldOrder)#" index="variables.iiX">
	<cfif StructKeyExists(variables.frmFields,variables.aFieldOrder[variables.iiX])>
		<cfset variables.field = variables.frmFields[variables.aFieldOrder[variables.iiX]] />
		<!---<cfif iiX eq 1 and field.fieldtype.fieldtype neq "section">
			<ol>
		</cfif>--->
		<cfif variables.field.fieldtype.isdata eq 1 and len(variables.field.datasetid)>
			<cfset variables.dataset = variables.fbManager.processDataset( variables.$,variables.frmData[variables.field.datasetid] ) />
		</cfif>
		<cfif variables.field.fieldtype.fieldtype eq "file">
			<cfset variables.isMultipart = true />
		</cfif>
		<cfif variables.field.fieldtype.fieldtype eq "hidden">
		#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#variables.field.fieldtype.fieldtype#.cfm',
			field=variables.field,
			dataset=variables.dataset
			)#			
		<cfelseif variables.field.fieldtype.fieldtype neq "section">
			<div class="mura-form-#variables.field.fieldtype.fieldtype#<cfif variables.field.isrequired> req</cfif> control-group">
			#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#variables.field.fieldtype.fieldtype#.cfm',
				field=variables.field,
				dataset=variables.dataset
				)#			
			</div>
		<cfelseif variables.field.fieldtype.fieldtype eq "section">
			<!---<cfif iiX neq 1>
				</ol>
			</cfif>--->
			#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#variables.field.fieldtype.fieldtype#.cfm',
				field=variables.field,
				dataset=variables.dataset
				)#
			<!---<ol>--->
		<cfelse>
		#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#variables.field.fieldtype.fieldtype#.cfm',
			field=variables.field,
			dataset=variables.dataset
			)#
		</cfif>		
		<!---#$.dspObject_Include('formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm')#--->
	<cfelse>
		<!---<cfthrow message="ERROR 9000: Field Missing: #aFieldOrder[iiX]#">--->
	</cfif>
</cfloop>
<cfif request.fieldsetopen eq true></fieldset><cfset request.fieldsetopen = false /></cfif>
<!---</ol>--->
</cfoutput>
</cfsavecontent>
<cfoutput>
<form id="#variables.frmID#" class="#variables.$.siteConfig('bsFormLayout')#" method="post"<cfif isMultipart>enctype="multipart/form-data"</cfif>>
	#variables.frmFieldContents#
	<div class="form-actions buttons"><input type="submit" class="btn" value="#$.rbKey('form.submit')#"></div>
	#variables.$.dspObject_Include(thefile='dsp_form_protect.cfm')#
	<!---#$.dspObject_Include(thefile='dsp_captcha.cfm')#--->
</form>
</cfoutput>

