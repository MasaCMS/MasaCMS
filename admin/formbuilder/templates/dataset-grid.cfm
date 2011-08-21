<cfoutput>
<span>
	<div id="dataset-grid" class="meld-tb-form">
		<div class="meld-tb-header">
			<ul class="right">
				<li><div class="ui-button" id="button-grid-dump" title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.dump')#"><span class="ui-icon ui-icon-comment"></span></div></li>
				<li><div class="ui-button" id="button-grid-reload" title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.reload')#"><span class="ui-icon ui-icon-arrowrefresh-1-e"></span></div></li>
				<li><div class="ui-button" id="button-grid-edit" title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.edit')#"><span class="ui-icon ui-icon-pencil"></span></div></li>
				<li><div class="ui-button" id="button-grid-add" title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.add')#"><span class="ui-icon ui-icon-plusthick"></span></div></li>
			</ul>
			<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.grid')#: <span id="meld-tb-form-label"></span></h3>
		</div>
		<div id="meld-tb-grid-message" style="display: none">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.mastermode')#</div>
		<div id="meld-tb-grid">
			<div id="meld-tb-grid-padding">
			<ul id="meld-tb-grid-table-header">
			</ul>
			<ul id="meld-tb-grid-table">
			</ul>
			</div>
		</div>
	</div>
</span>
</cfoutput>