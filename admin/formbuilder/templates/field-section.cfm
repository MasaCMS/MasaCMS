<cfoutput><span>
		<div class="meld-tb-form" id="formblock-${fieldid}">
			<div class="meld-tb-header">
				<h3>#mmRBF.getKey('field_section')#: <span id="meld-tb-form-label"></span></h3>
				<ul class="right">
					<li><div class="ui-button" id="button-trash" title="#mmRBF.getKey('delete')#"><span class="ui-icon ui-icon-closethick"></span></div></li>
				</ul>
			</div>
			<ul class="template-form">
				<li>
					<label for="field_label">#mmRBF.getKey('field_label')#</label>
					<input class="text medium tb-label" type="text" name="label" value="" data-label="true">
				</li>
				<li>
					<label for="field_name">#mmRBF.getKey('field_name')#</label>
					<input id="tb-name" class="text medium disabled" name="name" type="text" value="" maxlength="50" disabled="true" />
				</li>
			</ul>
		</div>
	</span>
</cfoutput>