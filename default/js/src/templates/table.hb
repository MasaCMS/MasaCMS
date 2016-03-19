	<div class="form-group">
		<div id="filter-results-container">
			<div id="date-filters">
				<div class="control-group">
				  <label class="control-label">From</label>
				  <div class="controls">
				  	<input type="text" class="datepicker span2" id="date1" name="date1" validate="date" value="{{filters.fromdate}}">
				  	<select id="hour1" name="hour1" class="span2">{{#eachHour filters.fromhour}}<option value="{{num}}" {{selected}}>{{label}}</option>{{/eachHour}}</select></select>
					</div>
				</div>
			
				<div class="control-group">
				  <label class="control-label">To</label>
				  <div class="controls">
				  	<input type="text" class="datepicker span2" id="date2" name="date2" validate="date" value="{{filters.todate}}">
				  	<select id="hour2" name="hour2"  class="span2">{{#eachHour filters.tohour}}<option value="{{num}}" {{selected}}>{{label}}</option>{{/eachHour}}</select></select>
				   </select>
					</div>
				</div>
			</div>
					
			<div class="control-group">
				<label class="control-label">Keywords</label>
				<div class="controls">
					<select name="filterBy" class="span2" id="results-filterby">
					{{#eachKey properties filters.filterby}}
					<option value="{{name}}" {{selected}}>{{displayName}}</option>
					{{/eachKey}}
					</select>
					<input type="text" class="span6" name="keywords" id="results-keywords" value="{{filters.filterkey}}">
				</div>
			</div>
			<div class="form-actions">
				<button type="button" class="btn" id="btn-results-search" ><i class="mi-bar-chart"></i> View Data</button>
				<button type="button" class="btn"  id="btn-results-download" ><i class="mi-download"></i> Download</button>
			</div>
		</div>
	<div>

	<ul class="metadata">
		<li>Page:
			<strong>{{rows.pageindex}} of {{rows.totalpages}}</strong>
		</li>
		<li>Total Records:
			<strong>{{rows.totalitems}}</strong>
		</li>
	</ul>

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
				<td>
				{{#eachColButton this}}
				<button type="button" class="{{type}}" data-value="{{id}}" data-pos="{{@index}}">{{label}}</button>
				{{/eachColButton}}
				</td>
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