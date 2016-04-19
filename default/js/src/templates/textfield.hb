<div class="{{{inputWrapperClass}}}" id="field-{{name}}-container">
	<label for="{{name}}">{{label}}{{#if isrequired}} <ins>Required</ins>{{/if}}</label>
	<input type="text" {{{commonInputAttributes}}} value="{{value}}"{{#if placeholder}} placeholder="{{placeholder}}"{{/if}}/>
</div>
