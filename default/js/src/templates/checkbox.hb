	<div class="mura-control-group" id="field-{{name}}-container">
		<div class="mura-checkbox-group">
			{{label}}
			{{#eachCheck dataset.options selected}}
				<label class="checkbox">
				<input source="{{../dataset.source}}" type="checkbox" name="{{../name}}" id="field-{{id}}" value="{{id}}" id="{{../name}}-{{id}}" {{#if isselected}}checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachCheck}}
		</div>
	</div>
