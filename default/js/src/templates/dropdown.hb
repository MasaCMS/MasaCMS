	<div class="mura-control-group" id="field-{{name}}-container">
		<label for="{{name}}">{{label}}</label>	
			<select type="text" name="{{name}}id" id="field-{{name}}">
				{{#each dataset.options}}
					<option data-isother="{{isother}}" id="field-{{id}}" value="{{id}}" {{#if isselected}}selected='selected'{{/if}}>{{label}}</option>
				{{/each}}
			</select>
	</div>

