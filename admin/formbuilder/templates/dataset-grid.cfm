<cfoutput>
<span>
<div class="ui-tabs">
			<ul class="ui-tabs-nav">
				<li id="button-grid-edit" title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.edit')#" class="ui-state-default ui-corner-top"><a href="javascript:void(null);"><span>Source</span></a></li>
				<li class="ui-state-default ui-state-active ui-corner-top ui-tabs-selected"><a href="javascript:void(null);"><span>List</span></a></li>
			</ul>
			
			<div class="ui-tabs-panel" id="meld-tb-form-tab-list">
	<div id="dataset-grid" class="meld-tb-form template-form">		
		
				<div id="meld-tb-grid-message" style="display: none">#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.mastermode')#</div>
				<div id="meld-tb-grid">
					<div id="meld-tb-grid-padding">
					<ul id="meld-tb-grid-table-header">
					</ul>
					<ul id="meld-tb-grid-table">
					</ul>
					</div>
				</div>
				||<div id="button-grid-add" title="#mmRBF.getKeyValue(session.rb,'formbuilder.dataset.add')#"></div>||
		</div>
		</div>
	</div>
</span>
</cfoutput>