	<div class="form-group" id="field-{{name}}-container">
		<div class="form-group-checkbox">
			<label>
			{{displayName}}
			{{#eachStatic dataset}}
				<label class="control-label">	
				<input class="form-control" type="checkbox" name="{{../name}}" id="field-{{id}}" value="{{value}}" id="{{../name}}" {{#if isselected}} checked='checked'{{/if}}{{#if selected}} checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachStatic}}
			</label>
		</div>
	</div>
