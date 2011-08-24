<cfoutput>
<div id="dataset-row">
	<div id="element-row">
		<li></li>
	</div>
	<div id="element-button-delete">
		<div class="ui-button noframe button-grid-row-delete" title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.delete')#"></div>
	</div>
	<div id="element-labels">
		<label id="label">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.label')#</label>
		<label id="value">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.value')#</label>
	</div>
	<div id="element-cell">
		<span class='meld-tb-cell'></span>
	</div>
	<div id="element-display">
		<div class="meld-tb-grid-display"></div>
	</div>
	<div id="element-input">
		<input type="text" class="meld-tb-grid-input" />
	</div>
	<div id="element-handle">
		<span class="meld-tb-grid-handle"></span> 
	</div>
</div>
</cfoutput>