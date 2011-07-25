<cfoutput><span>
		<div class="meld-template-form">
			<h3>#mmRBF.getKey('dataset_form')#: <span id="meld-template-form-label"></span></h3>
			<div class="columns">
				<div class="col2 wide bordered">
					<ul class="template-form">
						<li>
							<label for="filter">#mmRBF.getKey('name')#</label>
							<input class="text long" type="text" name="filter" id="dataset-name" value="" maxlength="50" />
							<!---<input type="button" class="button ui-icon ui-icon-check" name="set-filter" value="" />--->
							<input type="hidden" name="datasetID" id="dataset-id" value="" />
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