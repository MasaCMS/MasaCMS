<script id="field-dropdown" type="text/x-handlebars-template">
	<div class="form-group" id="field-{{name}}-container">
		<label class="control-label" for="{{name}}">{{displayName}}</label>	
		<div class="form-group-select">
			<select class="form-control" type="text" name="{{name}}" id="field-{{loadkey}}">
				{{#each options}}
					<option data-isother="{{isother}}" id="field-{{id}}" value="{{id}}">{{label}}</option>
				{{/each}}
			</select>
		</div>
	</div>
</script>
