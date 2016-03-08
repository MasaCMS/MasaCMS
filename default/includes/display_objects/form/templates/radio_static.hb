	<div class="form-group" id="field-{{name}}-container">
		<div class="form-group-radio">
			<label class="control-label">
			{{displayName}}
			</label>
			{{#eachStatic dataset}}
				<label class="control-label" for="{{label}}">	
				<input class="form-control" type="radio" name="{{../name}}" id="field-{{id}}" value="{{value}}"  {{#if isselected}}checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachStatic}}
		</div>
	</div>