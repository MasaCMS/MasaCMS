<cfoutput>
		<div id="meld-tb-dataset" class="meld-tb-form">
			<div id="dataset-form" class="meld-tb-header">
			<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.form')#: <span id="meld-template-form-label"></span></h3>	
			</div>
					<ul class="template-form">
						<li>
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype')#</label>
							<select class="select" name="sourcetype" id="meld-tb-dataset-sourcetype">
								<option value="entered">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype.entered')#</option>
								<option value="dsp">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype.dsp')#</option>
								<option value="object">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype.object')#</option>
								<option value="remote">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sourcetype.remote')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-entered" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.issorted')#</label>
							<select class="select" name="issorted" id="meld-tb-dataset-issorted">
								<option value="0">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.issorted.manual')#</option>
								<option value="1">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.issorted.sorted')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sorttype')#</label>
							<select class="select" name="sorttype" id="meld-tb-dataset-sorttype">
								<option value="string">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sorttype.string')#</option>
								<option value="numeric">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sorttype.numeric')#</option>
								<option value="date">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sorttype.date')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortcolumn')#</label>
							<select class="select" name="sortcolumn" id="meld-tb-dataset-sortcolumn">
								<option value="label">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortcolumn.label')#</option>
								<option value="value">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortcolumn.value')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-sorted" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortdirection')#</label>
							<select class="select" name="sortdirection" id="meld-tb-dataset-sortdirection">
								<option value="asc">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortdirection.asc')#</option>
								<option value="desc">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.sortdirection.desc')#</option>
							</select>
						</li>
						<li class="meld-tb-dsi meld-tb-grp-source" style="display: none">
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.source')#</label>
							<input class="text tb-source" id="meld-tb-dataset-source" type="text" name="source" value="" maxlength="250" />
						</li>
					</ul>
							<div class="btn-wrap">
								<input type="button" class="button" name="save-dataset" id="meld-tb-save-dataset" value="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.update')#" />
							</div>
		</div>
</cfoutput>
