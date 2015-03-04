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
<cfoutput>
<script>
	isFormBuilder = true;
	
	jQuery(document).ready(function() {
		jQuery("##mura-templatebuilder").templatebuilder();
	});
</script>
<style>
.tb-fieldIsEmpty {
	border: 1px solid ##ff0000 !important;
}	
</style>

	<div id="mura-templatebuilder" data-url="#$.globalConfig('context')#/admin/">
		<div class="mura-tb-menu">
			<ul class="mura-tb-form-menu">
			<li><div class="ui-button button-field" id="button-form" data-object="section-form" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.form.tooltip')#"><span class="ui-button-text">#application.rbFactory.getKeyValue(session.rb,'formbuilder.form')#</span></div></li>
			<li class="spacer"></li>
			</ul>
			<ul class="mura-tb-field-menu">
			<li><div class="ui-button button-field" id="button-section" data-object="section-section" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.section.tooltip')#"><span class="ui-button-text ui-icon-formfield-section">#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.section')#</span></div></li>
			<li class="spacer"></li>
			<li><div class="ui-button button-field" id="button-textfield" data-object="field-textfield" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.textfield.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-textfield"></span></div></li>
			<li><div class="ui-button button-field" id="button-textarea" data-object="field-textarea" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.textarea.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-textarea"></span></div></li>
			<li><div class="ui-button button-field" id="button-hidden" data-object="field-hidden" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.hidden.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-hidden"></span></div></li>
			<li><div class="ui-button button-field" id="button-radio" data-object="field-radio" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.radio.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-radiobox"></span></div></li>
			<li><div class="ui-button button-field" id="button-checkbox" data-object="field-checkbox" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.checkbox.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-checkbox"></span></div></li>
			<li><div class="ui-button button-field" id="button-dropdown" data-object="field-dropdown" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.dropdown.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-select"></span></div></li>
			<li><div class="ui-button button-field" id="button-file" data-object="field-file" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.file.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-file"></span></div></li>
			<li><div class="ui-button button-field" id="button-textblock" data-object="field-textblock" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.textblock.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-textblock"></span></div></li>
			<li><div class="ui-button button-field" id="button-nested" data-object="field-nested" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.nested.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-nested"></span></div></li>
			</ul>
		</div>
		<div id="mura-tb-form" class="clearfix">
			<div id="mura-tb-form-fields">
				<div id="mura-tb-fields-empty" class="alert">#application.rbFactory.getKeyValue(session.rb,'formbuilder.fields.empty')#</div>
				<ul id="mura-tb-fields">
				</ul>
			</div>
			<div id="mura-tb-fields-settings">	
				<div id="mura-tb-field-form" class="mura-tb-data-form">
					<div id="mura-tb-field-empty" class="alert">#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.empty')#</div>
					<div id="mura-tb-field">
					</div>
				</div>
				<div id="mura-tb-dataset-form" class="mura-tb-data-form">
				</div>
				<div id="mura-tb-grid">
				</div>
			</div>
		</div>

	</div>	
	<textarea id="mura-formdata" name="body">#replace(rc.contentBean.getBody(),"&quot;","\""","all")#</textarea>
	
</cfoutput>
