	<div class="{{{inputWrapperClass}}}" id="field-{{name}}-container">
		<div class="mura-checkbox-group">
			<div class="mura-group-label">{{label}}{{#if isrequired}} <ins>Required</ins>{{/if}}</div>
			{{#eachCheck dataset.options selected}}
				<label class="checkbox">
				<input source="{{../dataset.source}}" type="checkbox" name="{{../name}}" id="field-{{id}}" value="{{id}}" id="{{../name}}-{{id}}" {{#if isselected}}checked='checked'{{/if}}/>
				{{label}}</label>
			{{/eachCheck}}
		</div>
	</div>
