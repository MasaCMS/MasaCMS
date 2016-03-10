{{#each this}}
	<div class="alert alert-danger" data-field="{{field}}">{{#if label}}{{label}}: {{/if}}{{message}}</div>
{{/each}}
