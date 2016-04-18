	<div class="mura-control-group" id="field-{{name}}-container">
		<div class="mura-radio-group">
			{{displayName}}
			{{#eachStatic dataset}}
				<label for="{{label}}" class="radio">	
				<input type="radio" name="{{../name}}" id="field-{{datarecordid}}" value="{{value}}"  {{#if isselected}}checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachStatic}}
		</div>
	</div>