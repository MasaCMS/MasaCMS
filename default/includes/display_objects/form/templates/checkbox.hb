	<div class="form-group" id="field-{{name}}-container">
		<div class="form-group-checkbox">
			<label>
			{{displayName}}
			{{#eachCheck dataset.options selected}}
				<label class="control-label">	
				<input class="form-control" source="{{../dataset.source}}" type="checkbox" name="{{../name}}" id="field-{{id}}" value="{{id}}" id="{{../name}}-{{id}}" {{#if isselected}}checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachCheck}}
			</label>
		</div>
	</div>
