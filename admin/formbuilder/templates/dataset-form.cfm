<cfoutput>
		<div id="meld-tb-dataset" class="meld-tb-form">
			<div class="meld-tb-header">
			<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.form')#: <span id="meld-template-form-label"></span></h3>
				<!---
				<ul class="right">
					<li><div class="ui-button" id="button-trash" title="#mmRBF.getKeyValue(session.rb,'formbuilder.delete')#"><span class="ui-icon ui-icon-closethick"></span></div></li>
				</ul>
				--->
			</div>
			<div class="columns">
				<div class="col2 wide bordered">
					<ul class="template-form">
						<li>
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.sourcetype')#</label>
							<select class="select" name="sourcetype" id="meld-tb-dataset-sourcetype">
								<option value="entered">#mmRBF.getKeyValue(session.rb,'formbuilder.sourcetype.entered')#</option>
								<option value="dsp">#mmRBF.getKeyValue(session.rb,'formbuilder.sourcetype.dsp')#</option>
								<option value="object">#mmRBF.getKeyValue(session.rb,'formbuilder.sourcetype.object')#</option>
								<option value="remote">#mmRBF.getKeyValue(session.rb,'formbuilder.sourcetype.remote')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-entered" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.issorted')#</label>
							<select class="select" name="issorted" id="meld-tb-dataset-issorted">
								<option value="0">#mmRBF.getKeyValue(session.rb,'formbuilder.sorttype.manual')#</option>
								<option value="1">#mmRBF.getKeyValue(session.rb,'formbuilder.sourcetype.sorted')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.sorttype')#</label>
							<select class="select" name="sorttype" id="meld-tb-dataset-sorttype">
								<option value="string">#mmRBF.getKeyValue(session.rb,'formbuilder.sorttype.string')#</option>
								<option value="numeric">#mmRBF.getKeyValue(session.rb,'formbuilder.sorttype.numeric')#</option>
								<option value="date">#mmRBF.getKeyValue(session.rb,'formbuilder.sorttype.date')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.sortcolumn')#</label>
							<select class="select" name="sortcolumn" id="meld-tb-dataset-sortcolumn">
								<option value="label">#mmRBF.getKeyValue(session.rb,'formbuilder.sortcolumn.label')#</option>
								<option value="value">#mmRBF.getKeyValue(session.rb,'formbuilder.sortcolumn.value')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.sortdirection')#</label>
							<select class="select" name="sortdirection" id="meld-tb-dataset-sortdirection">
								<option value="asc">#mmRBF.getKeyValue(session.rb,'formbuilder.sortdirection.asc')#</option>
								<option value="desc">#mmRBF.getKeyValue(session.rb,'formbuilder.sortdirection.desc')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-source" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.source')#</label>
							<input class="text tb-source" id="meld-tb-dataset-source" type="text" name="source" value="" maxlength="250" data-required='true' />
						</li>
					</ul>
				</div>
				<div class="col3">
					<ul class="template-form">
						<li>
							<input type="button" class="button" name="save-dataset" id="meld-tb-save-dataset" value="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.update')#" />
						</li>
					</ul>
				</div>
			</div>
		</div>
</cfoutput>
