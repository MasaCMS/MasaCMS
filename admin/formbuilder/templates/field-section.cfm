<cfoutput><span>
		<div class="meld-tb-form" id="formblock-${fieldid}">
			<div class="meld-tb-header">
				<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.field.section')#: <span id="meld-tb-form-label"></span></h3>
				<ul class="right">
					<li><div class="ui-button" id="button-trash" title="#mmRBF.getKeyValue(session.rb,'formbuilder.delete')#"><span class="ui-icon ui-icon-closethick"></span></div></li>
				</ul>
			</div>
			<ul class="template-form">
				<li>
					<label for="label">#mmRBF.getKeyValue(session.rb,'formbuilder.field.label')#</label>
					<input class="text medium tb-label" type="text" name="label" value="" data-label="true">
				</li>
				<li>
					<label for="name">#mmRBF.getKeyValue(session.rb,'formbuilder.field.name')#</label>
					<input id="tb-name" class="text medium disabled" name="name" type="text" value="" maxlength="50" disabled="true" />
				</li>
			</ul>
		</div>
	</span>
</cfoutput>