<cfoutput><span>
		<div class="meld-tb-form" id="formblock-${fieldid}">
			<div class="meld-tb-header">
				<h3>#mmRBF.getKey('field_radio')#: <span id="meld-tb-form-label"></span></h3>
				<ul class="right">
					<li><div class="ui-button" id="button-trash" title="#mmRBF.getKey('delete')#"><span class="ui-icon ui-icon-closethick"></span></div></li>
				</ul>
			</div>
			<div class="columns clearfix">
				<div class="col2 wide bordered">
					<ul class="template-form">
						<li>
							<label for="field_label">#mmRBF.getKey('field_label')#</label>
							<input class="text medium tb-label" type="text" name="label" value="" maxlength="50" data-required='true' data-label="true" />
						</li>
					</ul>
				</div>
				<div class="col3 right">
					<ul class="template-form">
						<li>
							<label for="field_cssstyle">#mmRBF.getKey('field_cssstyle')#</label>
							<select class="select" name="cssstyle">
								<option value="small">Small</option>
								<option value="medium">Medium</option>
								<option value="large">Large</option>
							</select>
						</li>
					</ul>
				</div>
			</div>
			<div class="columns clearfix topbordered">
				<div class="col2 wide bordered">
					<ul>
						<li><br /></li>
						<li><br /></li>
					</ul>
				</div>
				<div class="col3 right">
					<ul class="template-form">
						<li>
							<label for="field_name">#mmRBF.getKey('field_name')#</label>
							<input id="tb-name" class="text medium disabled" name="name" type="text" value="" maxlength="50" disabled="true" />
						</li>
						<li>
							<label for="field_texttip">#mmRBF.getKey('field_texttip')#</label>
							<input class="text long" type="text" name="texttip" value="" maxlength="250" />
						</li>
					</ul>
				</div>
			</div>
		</div>
	</span>
</cfoutput>