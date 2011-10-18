<cfoutput>
<script>

	function saveFormBuilder(){
		jQuery("##mura-templatebuilder").templatebuilder('save');
	}

	jQuery(document).ready(function() {
		jQuery("##mura-templatebuilder").templatebuilder();
	});
</script>
	<div id="mura-templatebuilder" data-url="#$.globalConfig('context')#/admin/index.cfm">
		<div class="mura-tb-menu">
			<ul>
			<li><div class="ui-button button-field" id="button-section" data-object="section-section" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.section.tooltip')#"><span class="ui-button-text ui-icon-formfield-section">#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.section')#</span></div></li>
			<li class="spacer"></li>
			<li><div class="ui-button button-field" id="button-textfield" data-object="field-textfield" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.textfield.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-textfield"></span></div></li>
			<li><div class="ui-button button-field" id="button-textarea" data-object="field-textarea" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.textarea.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-textarea"></span></div></li>
			<li><div class="ui-button button-field" id="button-hidden" data-object="field-hidden" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.hidden.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-hidden"></span></div></li>
			<li><div class="ui-button button-field" id="button-radio" data-object="field-radio" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.radio.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-radiobox"></span></div></li>
			<li><div class="ui-button button-field" id="button-checkbox" data-object="field-checkbox" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.checkbox.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-checkbox"></span></div></li>
			<li><div class="ui-button button-field" id="button-dropdown" data-object="field-dropdown" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.dropdown.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-select"></span></div></li>
			</ul>
		</div>
		<div id="mura-tb-form" class="clearfix">
			<div id="mura-tb-form-fields">
				<div id="mura-tb-fields-empty" class="notice">#application.rbFactory.getKeyValue(session.rb,'formbuilder.fields.empty')#</div>
				<ul id="mura-tb-fields">
				</ul>
			</div>
			<div id="mura-tb-fields-settings">	
				<div id="mura-tb-field-form" class="mura-tb-data-form">
					<div id="mura-tb-field-empty" class="notice">#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.empty')#</div>
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
	<textarea id="mura-formdata" name="body">#request.contentBean.getBody()#</textarea>
	
</cfoutput>
