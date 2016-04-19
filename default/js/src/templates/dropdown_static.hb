	<div class="{{{inputWrapperClass}}}" id="field-{{name}}-container">
		<label for="{{name}}">{{label}}</label>
		<select {{commonInputAttributes}}>
			{{#eachStatic dataset}}
				<option data-isother="{{isother}}" id="field-{{datarecordid}}" value="{{value}}" {{#if isselected}}selected='selected'{{/if}}>{{label}}</option>
			{{/eachStatic}}
		</select>
	</div>
