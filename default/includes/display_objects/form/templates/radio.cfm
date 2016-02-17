<script id="field-radio" type="text/x-handlebars-template">
	<div class="form-group" id="field-{{name}}-container">
		<div class="form-group-radio">
			<label class="control-label">
			{{displayName}}
			</label>
			{{#each options}}
				<label class="control-label" for="{{label}}">	
				<input class="form-control" type="radio" name="{{../name}}" id="field-{{id}}" value="{{id}}" />
				{{label}}</label>
			{{/each}}
		</div>
	</div>
</script>