<div class="form-group">
	<label class="control-label" for="beanList">Choose Entity:</label>	
	<div>
	<table style="width: 100%" class="table">
		<thead>
		<tr>
		{{#each columns}}
			<th class='data-sort' data-value='{{column}}'>{{displayName}}</th>
		{{/each}}
			<th></th>
		</tr>
		</thead>
		<tbody>
		{{#each rows.items}}
			<tr class="even">
				{{#eachColRow this ../columns}}
					<td>{{this}}</td>
				{{/eachColRow}}
				<!---<td><button type="button" class="data-view" data-value="{{id}}" data-pos="{{@index}}">View</td>--->
			</tr>
		{{/each}}
		</tbody>
		<tfoot>
		<tr>
			<td>
				{{#if rows.links.first}}
				<button class='data-nav' data-value="{{rows.links.first}}">First</button>
				{{/if}}
				{{#if rows.links.previous}}
				<button class='data-nav' data-value="{{rows.links.previous}}">Prev</button>
				{{/if}}
				{{#if rows.links.next}}
				<button class='data-nav' data-value="{{rows.links.next}}">Next</button>
				{{/if}}
				{{#if rows.links.last}}
				<button class='data-nav' data-value="{{rows.links.last}}">Last</button>
				{{/if}}
			</td>
		</tfoot>
	</table>
</div>