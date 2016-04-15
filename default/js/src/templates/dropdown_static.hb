	<div class="form-group" id="field-{{name}}-container">
		<label class="control-label" for="{{name}}">{{label}}</label>	
		<div class="form-group-select">
			<select class="form-control" type="text" name="{{name}}" id="field-{{name}}">
				{{#eachStatic dataset}}
					<option data-isother="{{isother}}" id="field-{{datarecordid}}" value="{{value}}" {{#if isselected}}selected='selected'{{/if}}>{{label}}</option>
				{{/eachStatic}}
			</select>
		</div>
	</div>

