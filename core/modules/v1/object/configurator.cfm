<cfparam name="objectParams.label" default="">
<cfparam name="objectParams.isbodyobject" default="false">
<cfparam name="objectParams.metacssstyles.textalign" default="">
<cfparam name="request.hasbasicoptions" default="true">
<cfset request.hasmetaoptions=true>
<cfif not (IsBoolean(objectParams.isbodyobject) and objectParams.isbodyobject)>
	<cfoutput>
		<cfif isDefined('request.muraconfiguratortag')>
			<cfif request.hasbasicoptions>
					</div> <!--- /end  mura-panel-collapse --->
				</div> <!--- /end  mura-panel-body --->
			</div> <!--- /end panel --->
			</cfif>
			<div class="mura-panel panel">
				<div class="mura-panel-heading" role="tab" id="heading-labeling">
					<h4 class="mura-panel-title">
						<a class="collapsed" role="button" data-toggle="collapse" data-parent="##configurator-panels" href="##panel-labeling" aria-expanded="false" aria-controls="panel-labeling">
							Label
						</a>
					</h4>
				</div>
				<div id="panel-labeling" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-labeling">
					<div class="mura-panel-body">
		</cfif>
				<div id="labelContainer">
					<div class="mura-control-group">
						<cfif isDefined('request.muraconfiguratortag')>
						<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.text')#</label>
						<cfelse>
						<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.label')#</label>
						</cfif>
						<input name="label" type="text" class="objectParam" maxlength="50" value="#esapiEncode('html_attr',objectParams.label)#"/>
					</div>
					<cfif isDefined('request.muraconfiguratortag')>
						<div class="mura-control-group">
							<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.alignment')#</label>
							<select name="textAlign" class="metaStyle">
								<option value="">--</option>
								<option value="left"<cfif objectparams.metacssstyles.textalign eq 'left'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.left')#</option>
								<option value="right"<cfif objectparams.metacssstyles.textalign eq 'right'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.right')#</option>
								<option value="center"<cfif objectparams.metacssstyles.textalign eq 'center'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.center')#</option>
								<option value="justify"<cfif objectparams.metacssstyles.textalign eq 'justify'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.justify')#</option>
							</select>
						</div>
					</cfif>
				</div>
	</cfoutput>
</cfif>
