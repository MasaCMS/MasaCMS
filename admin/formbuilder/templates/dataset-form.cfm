<cfoutput><span>
		<div class="meld-template-form">
			<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.form')#: <span id="meld-template-form-label"></span></h3>
			<div class="columns">
				<div class="col2 wide bordered">
					<ul class="template-form">
						<li>
							<label for="filter">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.name')#</label>
							<input class="text long" type="text" name="filter" id="dataset-name" value="" maxlength="50" />
							<!---<input type="button" class="button ui-icon ui-icon-check" name="set-filter" value="" />--->
							<input type="hidden" name="datasetID" id="dataset-id" value="" />
						</li>
					</ul>
				</div>
				<div class="col3">
					<ul class="template-form">
						<li>
							<!--- <button name="new-datasource">#mmRBF.getKeyValue(session.rb,'formbuilder.createnew')#</button> --->
							<input type="button" class="button" name="new-datasource" value="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.createnew')#" />
						</li>
					</ul>
				</div>
			</div>
		</div>
	</span>
</cfoutput>