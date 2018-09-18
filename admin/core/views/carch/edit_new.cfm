<cfoutput>

<!--- TEMP SHIM FOR 7.2 DEV --->
<link href="#application.configBean.getContext()##application.configBean.getAdminDir()#/assets/css/mura72shim.css" rel="stylesheet" type="text/css" />

<!--- new sidebar markup --->
	<div class="mura__edit__controls">
		<div class="mura__edit__controls__scrollable">
			<div class="mura__edit__controls__objects">
				<div id="mura-edit-tabs" class="mura__edit__controls__tabs">

					<div class="mura-panel-group" id="content-panels" role="tablist" aria-multiselectable="true">
						<div class="mura-panel panel">
							<div class="mura-panel-heading" role="tab" id="heading-basic">
								<h4 class="mura-panel-title"><a href="##panel-basic">Basic</a></h4>

									<div id="panel-basic" class="panel-collapse" role="tabpanel" aria-labelledby="heading-basic" aria-expanded="false" style="height: 0px;">
										<div class="mura-panel-body">

											<div class="mura-control-group">
											  <label>Credits</label>
											  <input type="text" id="credits" name="credits" value="" maxlength="255">
											</div>

										</div>
									</div>

							</div>
						</div>
					</div>	

				</div>
			</div>
		</div>
	</div>

</cfoutput>