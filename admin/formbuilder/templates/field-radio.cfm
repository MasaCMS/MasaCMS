<cfoutput>

<span>
		<div class="meld-tb-form" id="formblock-${fieldid}">
			<div class="meld-tb-header">
				<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.field.radio')#: <span id="meld-tb-form-label"></span></h3>
				<ul class="right">
					<li><div class="ui-button" id="button-trash" title="#mmRBF.getKeyValue(session.rb,'formbuilder.delete')#"><span class="ui-icon ui-icon-closethick"></span></div></li>
				</ul>
			</div>
			
		<div class="ui-tabs">
		
			<ul class="ui-tabs-nav">
				<li class="ui-state-default ui-corner-top"><a href="##meld-tb-form-tab-basic"><span>Basic</span></a></li>
				<li class="ui-state-default ui-corner-top"><a href="##meld-tb-form-tab-advanced"><span>Advanced</span></a></li>
				<li class="ui-state-default ui-corner-top"><a href="##meld-tb-form-tab-validation"><span>Validation</span></a></li>
			</ul>
			
			<div class="ui-tabs-panel" id="meld-tb-form-tab-basic">
					<ul class="template-form">
						<li>
							<label for="label">#mmRBF.getKeyValue(session.rb,'formbuilder.field.label')#</label>
							<input class="text long tb-label" type="text" name="label" value="" maxlength="50" data-required='true' data-label="true" />
						</li>
						<li>
							<label for="name">#mmRBF.getKeyValue(session.rb,'formbuilder.field.name')#</label>
							<input id="tb-name" class="text long disabled" name="name" type="text" value="" maxlength="50" disabled="true" />
						</li>
					</ul>
				</div>
				
				<div class="ui-tabs-panel" id="meld-tb-form-tab-advanced">
					<ul class="template-form">
						<li>
							<label for="size">#mmRBF.getKeyValue(session.rb,'formbuilder.field.size')#</label>
							<input class="text short" type="text" name="size" value="" maxlength="50" data-required='false' />
						</li>
						<li>
							<label for="cssid">#mmRBF.getKeyValue(session.rb,'formbuilder.field.cssid')#</label>
							<input class="text long" type="text" name="cssid" value="" maxlength="50" data-required='false' />
						</li>
						<li>
							<label for="cssclass">#mmRBF.getKeyValue(session.rb,'formbuilder.field.cssclass')#</label>
							<input class="text long" type="text" name="cssclass" value="" maxlength="50" data-required='false' />
						</li>
						<li>
							<label for="tooltip">#mmRBF.getKeyValue(session.rb,'formbuilder.field.tooltip')#</label>
							<textarea name="tooltip" value="" maxlength="250" ></textarea>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</span>
</cfoutput>