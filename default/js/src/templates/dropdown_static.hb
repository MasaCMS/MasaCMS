	<div class="mura-control-group" id="field-{{name}}-container">
		<label for="{{name}}">{{label}}</label>	
		<select type="text" name="{{name}}" id="field-{{name}}">
			{{#eachStatic dataset}}
				<option data-isother="{{isother}}" id="field-{{datarecordid}}" value="{{value}}" {{#if isselected}}selected='selected'{{/if}}>{{label}}</option>
			{{/eachStatic}}
		</select>
	</div>

