<cfoutput>
	<div id="meld-tb-grid" class="meld-tb-form">
		<div id="dataset-sourced" class="meld-tb-header">
			<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.source')#</h3>
			<ul class="right">
				<li><div class="ui-button" id="button-grid-edit" title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.edit')#"><span class="ui-icon ui-icon-pencil"></span></div></li>
			</ul>
		</div>
		<div class="columns">
			<div class="col2">
				<ul class="template-form">
					<li>
						<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.source')#</label>
						<input id="tb-source" class="text medium disabled" name="source" type="text" value="" maxlength="150" disabled="true" />
					</li>
				</ul>
			</div>
		</div>
	</div>
</cfoutput>