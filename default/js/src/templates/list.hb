<form>
	<div class="form-group">
		<label class="control-label" for="beanList">Choose Entity:</label>	
		<div class="form-group-select">
			<select class="form-control" type="text" name="bean" id="select-bean-value">
				{{#each this}}
					<option value="{{name}}">{{name}}</option>
				{{/each}}
			</select>
		</div>
	</div>
	<div class="form-group">
		<button type="button" id="select-bean">Go</button>
	</div>
</form>