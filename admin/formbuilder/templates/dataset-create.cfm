<cfoutput><span>
		<div class="meld-template-form">
			<h3>#mmRBF.getKey('dataset_form')#: <span id="meld-template-form-label"></span></h3>
			<div class="columns">
				<div class="col2 wide bordered">
					<ul class="template-form">
						<li>
							<label for="dataset">#mmRBF.getKey('dataset')#</label>
							<select class="select" name="datasetid">
								<option value="">#mmRBF.getKey('chooseone')#</option>
								<option value="4FA62B2D-3A29-44B1-8603FB892C60014B">Big Long Honking Name Shirt Sizes</option>
								<option value="77917A42-28F4-4BA4-B88732109F9A05C5">Colors</option>
							</select>
							<input type="button" class="button ui-icon ui-icon-check" name="set-dataset" value="#mmRBF.getKey('set')#" />
						</li>
						<li>
							<label for="filter">#mmRBF.getKey('filter')#</label>
							<input class="text medium" type="text" name="filter" id="dataset-filter" value="" maxlength="50" />
							<input type="button" class="button ui-icon ui-icon-check" name="set-filter" value="" />
						</li>
					</ul>
				</div>
				<div class="col3">
					<ul class="template-form">
						<li>
							<!--- <button name="new-datasource">#mmRBF.getKey('createnew')#</button> --->
							<input type="button" class="button" name="new-datasource" value="#mmRBF.getKey('createnew')#" />
						</li>
					</ul>
				</div>
			</div>
		</div>
	</span>
</cfoutput>