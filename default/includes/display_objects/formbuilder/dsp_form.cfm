<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfset local = {} />
<cfset variables.fbManager = $.getBean('formBuilderManager') />

<cfparam name="arguments.isNested" default="false">

<cfset local.frmID		= "frm" & replace(arguments.formID,"-","","ALL") />
<cfset local.frmID		= "frm" & replace(arguments.formID,"-","","ALL") />

<cfset local.prefix		= "" />

<cfif arguments.isNested>
	<cfset local.nestedForm		= $.getBean('content').loadBy( contentID=arguments.formid,siteid=session.siteid ) />
	<cfset arguments.formJSON	= local.nestedForm.getBody() /> 
	<cfset local.frm			= variables.fbManager.renderFormJSON( arguments.formJSON ) />
	<cfset local.prefix			= arguments.prefix />
<cfelse>
	<cfset local.frm			= variables.fbManager.renderFormJSON( arguments.formJSON ) />
</cfif>

<cfif len(local.prefix)>
	<cfset local.prefix = local.prefix & "_">
</cfif>

<cfset local.frmForm		= local.frm.form />
<cfset local.frmData		= local.frm.datasets />
<cfif not structKeyExists(local.frm.form,"formattributes")>
	<cfset local.frm.form.formattributes = structNew() />
</cfif>
<cfif not structKeyExists(local.frm.form.formattributes,"class")>
	<cfset local.frm.form.formattributes.class = "" />
</cfif>
<cfset local.attributes		= local.frm.form.formattributes />
<cfset local.frmFields		= local.frmForm.fields />
<cfset local.dataset		= "" />
<cfset local.isMultipart	= false />


<!--- start with fieldsets closed --->
<cfset request.fieldsetopen = false />

<cfset local.aFieldOrder = local.frmForm.fieldorder />
<cfset local.frmFieldContents = "" />

<cfsavecontent variable="frmFieldContents">
<cfoutput>
<cfloop from="1" to="#ArrayLen(local.aFieldOrder)#" index="iix">
	<cfif StructKeyExists(local.frmFields,local.aFieldOrder[iix])>
		<cfset local.field = local.frmFields[local.aFieldOrder[iix]] />
		<!---<cfif iiX eq 1 and field.fieldtype.fieldtype neq "section">
			<ol>
		</cfif>--->
		<cfif local.field.fieldtype.isdata eq 1 and len(local.field.datasetid)>
			<cfset local.dataset = variables.fbManager.processDataset( variables.$,local.frmData[local.field.datasetid] ) />
		</cfif>
		<cfif local.field.fieldtype.fieldtype eq "file">
			<cfset local.isMultipart = true />
		</cfif>
		<cfif local.field.fieldtype.fieldtype eq "hidden">
		#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#local.field.fieldtype.fieldtype#.cfm',
			field=local.field,
			dataset=local.dataset,
			prefix=local.prefix
			)#			
		<cfelseif local.field.fieldtype.fieldtype neq "section">
			<div class="mura-form-#local.field.fieldtype.fieldtype#<cfif local.field.isrequired> req</cfif> #this.formBuilderFieldWrapperClass#<cfif structKeyExists(local.field,'wrappercssclass')> #local.field.wrappercssclass#</cfif>">
			#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#local.field.fieldtype.fieldtype#.cfm',
				field=local.field,
				dataset=local.dataset,
				prefix=local.prefix
				)#			
			</div>
		<cfelseif local.field.fieldtype.fieldtype eq "section">
			<!---<cfif iiX neq 1>
				</ol>
			</cfif>--->
			#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#local.field.fieldtype.fieldtype#.cfm',
				field=local.field,
				dataset=local.dataset,
				prefix=local.prefix
				)#
			<!---<ol>--->
		<cfelse>
		#variables.$.dspObject_Include(thefile='/formbuilder/fields/dsp_#local.field.fieldtype.fieldtype#.cfm',
			field=local.field,
			dataset=local.dataset,
			prefix=local.prefix
			)#
		</cfif>		
		<!---#$.dspObject_Include('formbuilder/fields/dsp_#field.fieldtype.fieldtype#.cfm')#--->
	<cfelse>
		<!---<cfthrow data-message="ERROR 9000: Field Missing: #aFieldOrder[iiX]#">--->
	</cfif>
</cfloop>

<cfif request.fieldsetopen eq true></fieldset><cfset request.fieldsetopen = false /></cfif>
<!---</ol>--->
</cfoutput>
</cfsavecontent>
<cfset local.frmFieldContents = frmFieldContents />
<cfoutput>
<cfif not arguments.isNested>
<form id="#local.frmID#" class="<cfif structKeyExists(local.attributes,"class") and len(local.attributes.class)>#local.attributes.class# </cfif>mura-form-builder" method="post"<cfif local.isMultipart>enctype="multipart/form-data"</cfif>>
</cfif>
	#local.frmFieldContents#
<cfif not arguments.isNested>
	#variables.$.dspObject_Include(thefile='dsp_form_protect.cfm')#
	<div class="#this.formBuilderButtonWrapperClass#"><br><input type="submit" class="#this.formBuilderSubmitClass#" value="#$.rbKey('form.submit')#"></div>
</form>
</cfif>
</cfoutput>

