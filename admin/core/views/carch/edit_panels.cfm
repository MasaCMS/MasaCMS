<cfoutput>

<!--- accordion effect for side panels --->
<script type="text/javascript">
$(document).ready(function(){
	$('##content-panels .mura-panel-title a').not('.collapsed').on('click',function(){
	   $(this).parents('.mura-panel').siblings('.mura-panel').find('.panel-collapse.in').removeClass('in');
	});
});
</script>

<!--- new sidebar markup --->
	<div class="mura__edit__controls">
		<div class="mura__edit__controls__scrollable">
			<div class="mura__edit__controls__objects">
				<div id="mura-edit-tabs" class="mura__edit__controls__tabs">

					<div class="mura-panel-group" id="content-panels" role="tablist" aria-multiselectable="true">

						<!--- basic --->
						<div class="mura-panel panel">
							<div class="mura-panel-heading" role="tab" id="heading-basic">
								<h4 class="mura-panel-title">
									<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-basic" aria-expanded="true" aria-controls="panel-basic">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.basic")#</a>
								</h4>
									<div id="panel-basic" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-basic" aria-expanded="false" style="height: 0px;">
										<div class="mura-panel-body">

											<cfinclude template="form/dsp_panel_basic.cfm">

										</div>
									</div>

							</div>
						</div> 
						<!--- /basic --->

						<!--- publishing --->
						<div class="mura-panel panel">
							<div class="mura-panel-heading" role="tab" id="heading-publishing">
								<h4 class="mura-panel-title">
									<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-publishing" aria-expanded="false" aria-controls="panel-publishing">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.publishing")#</a>
								</h4>
									<div id="panel-publishing" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-publishing" aria-expanded="false" style="height: 0px;">
										<div class="mura-panel-body">

											<cfinclude template="form/dsp_panel_publishing.cfm">

										</div>
									</div>

							</div>
						</div> 
						<!--- /publishing --->

						<!--- layout --->
						<div class="mura-panel panel">
							<div class="mura-panel-heading" role="tab" id="heading-layout">
								<h4 class="mura-panel-title">
									<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-layout" aria-expanded="false" aria-controls="panel-layout">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.layoutobjects")#</a>
								</h4>
									<div id="panel-layout" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-layout" aria-expanded="false" style="height: 0px;">
										<div class="mura-panel-body">

											<cfinclude template="form/dsp_panel_layout.cfm">

										</div>
									</div>

							</div>
						</div> 
						<!--- /layout --->


						<!--- tags --->
						<div class="mura-panel panel">
							<div class="mura-panel-heading" role="tab" id="heading-tags">
								<h4 class="mura-panel-title">
									<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-tags" aria-expanded="false" aria-controls="panel-tags">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.tags")#</a>
								</h4>
									<div id="panel-tags" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-tags" aria-expanded="false" style="height: 0px;">
										<div class="mura-panel-body">

											<cfinclude template="form/dsp_panel_tags.cfm">

										</div>
									</div>

							</div>
						</div> 
						<!--- /tags --->

						<!--- related content --->
						<div class="mura-panel panel">
							<div class="mura-panel-heading" role="tab" id="heading-relatedcontent">
								<h4 class="mura-panel-title">
									<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-relatedcontent" aria-expanded="false" aria-controls="panel-relatedcontent">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.relatedcontent")#</a>
								</h4>
									<div id="panel-relatedcontent" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-relatedcontent" aria-expanded="false" style="height: 0px;">
										<div class="mura-panel-body">

											<cfinclude template="form/dsp_panel_related_content.cfm">

										</div>
									</div>

							</div>
						</div> 
						<!--- /related content --->

						<!--- advanced --->
						<div class="mura-panel panel">
							<div class="mura-panel-heading" role="tab" id="heading-advanced">
								<h4 class="mura-panel-title">
									<a class="collapse" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-advanced" aria-expanded="false" aria-controls="panel-advanced">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.advanced")#</a>
								</h4>
									<div id="panel-advanced" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-advanced" aria-expanded="false" style="height: 0px;">
										<div class="mura-panel-body">

											<cfinclude template="form/dsp_panel_advanced.cfm">

										</div>
									</div>

							</div>
						</div> 
						<!--- /advanced --->


					</div>	

				</div>
			</div>
		</div>
	</div>

</cfoutput>