<cfoutput><span>
		<div class="meld-template-form">
			<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.form')#: <span id="meld-template-form-label"></span></h3>
			<div class="columns">
				<div class="col2 wide bordered">
					<ul class="template-form">
						<li>
							<label for="dataset">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset')#</label>
							<select class="select" name="datasetid">
								<option value="">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.chooseone')#</option>
								<option value="4FA62B2D-3A29-44B1-8603FB892C60014B">Big Long Honking Name Shirt Sizes</option>
								<option value="77917A42-28F4-4BA4-B88732109F9A05C5">Colors</option>
							</select>
							<input type="button" class="button ui-icon ui-icon-check" name="set-dataset" value="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.set')#" />
						</li>
						<li>
							<label for="filter">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.filter')#</label>
							<input class="text medium" type="text" name="filter" id="dataset-filter" value="" maxlength="50" />
							<input type="button" class="button ui-icon ui-icon-check" name="set-filter" value="" />
						</li>
					</ul>
				</div>
				<div class="col3">
					<ul class="template-form">
						<li>
							<!--- <button name="new-datasource">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.createnew')#</button> --->
							<input type="button" class="button" name="new-datasource" value="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.createnew')#" />
						</li>
					</ul>
				</div>
			</div>
		</div>
	</span>
</cfoutput>