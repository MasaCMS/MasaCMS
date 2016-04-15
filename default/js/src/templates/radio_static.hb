	<div class="form-group" id="field-{{name}}-container">
		<div class="form-group-radio">
			<label class="control-label">
			{{displayName}}
			{{#eachStatic dataset}}
				<label class="control-label" for="{{label}}">	
				<input class="form-control" type="radio" name="{{../name}}" id="field-{{datarecordid}}" value="{{value}}"  {{#if isselected}}checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachStatic}}
			</label>
		</div>
	</div>