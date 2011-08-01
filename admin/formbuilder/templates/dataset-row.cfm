<cfoutput>
<div>
	<div id="element-row">
		<li></li>
	</div>
	<div id="element-button-delete">
		<div class="ui-button noframe button-grid-row-delete" title="#mmRBF.key('formbuilder.dataset.delete')#"><span class="ui-icon ui-icon-trash"></span></div>
	</div>
	<div id="element-labels">
		<label id="label">#mmRBF.key('formbuilder.dataset.label')#</label>
		<label id="rblabel">#mmRBF.key('formbuilder.dataset.rblabel')#</label>
		<label id="price">#mmRBF.key('formbuilder.dataset.price')#</label>
		<label id="weight">#mmRBF.key('formbuilder.dataset.weight')#</label>
		<label id="customid">#mmRBF.key('formbuilder.dataset.customid')#</label>
		<label id="value">#mmRBF.key('formbuilder.dataset.value')#</label>
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
	<div id="element-checkbox">
		<input type="checkbox" class="meld-tb-grid-checkbox" value="1" /></span>
	</div>
	<div id="element-handle">
		<span class="meld-tb-grid-handle"></span> 
	</div>
</div>
</cfoutput>