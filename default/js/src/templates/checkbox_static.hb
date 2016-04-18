	<div class="mura-control-group" id="field-{{name}}-container">
		<div class="mura-checkbox-group">
			{{displayName}}
			{{#eachStatic dataset}}
				<label class="checkbox">	
				<input type="checkbox" name="{{../name}}" id="field-{{datarecordid}}" value="{{value}}" id="{{../name}}" {{#if isselected}} checked='checked'{{/if}}{{#if selected}} checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachStatic}}
		</div>
	</div>
