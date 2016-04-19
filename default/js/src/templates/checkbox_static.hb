	<div class="{{{inputWrapperClass}}}" id="field-{{name}}-container">
		<div class="mura-checkbox-group">
			{{label}}{{#if isrequired}} <ins>Required</ins>{{/if}}
			{{#eachStatic dataset}}
				<label class="checkbox">
				<input type="checkbox" name="{{../name}}" id="field-{{datarecordid}}" value="{{value}}" id="{{../name}}" {{#if isselected}} checked='checked'{{/if}}{{#if selected}} checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachStatic}}
		</div>
	</div>
