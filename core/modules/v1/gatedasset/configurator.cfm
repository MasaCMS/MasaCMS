 <!--- license goes here --->
<cfsilent>
	<cfset rc.rsForms = application.contentManager.getComponentType(rc.siteid, 'Form')/>
	<cfparam name="objectParams.formid" default="">
	<cfparam name="objectParams.pretext" default="">
	<cfparam name="objectParams.posttext" default="">
	<cfparam name="objectParams.buttonlabel" default="">
	<cfparam name="objectParams.modalbuttonlabel" default="">
	<cfparam name="objectParams.displaytype" default="">
	<cfparam name="objectParams.url" default="">
</cfsilent>
<cf_objectconfigurator params="#objectParams#">
<cfoutput>
	<div>
		<div class="mura-layout-row">
			<div class="mura-control-group">
				<label class="mura-control-label">Select Form</label>
				<select class="objectparam" name="formid">
					<option
						data-value='unconfigured'
						value="">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectform')#
					</option>
					<cfloop query="rc.rsForms">
						<cfset title=rc.rsForms.menutitle>
						<option
							<cfif objectParams.formid eq rc.rsForms.contentid>selected</cfif>
							title="#esapiEncode('html_attr',title)#"
							value="#rc.rsForms.contentid#">
							#esapiEncode('html',title)#
						</option>
					</cfloop>
				</select>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Download Button Label</label>
				<input type="text" placeholder="Download Button Label" id="buttonlabel" name="buttonlabel" class="objectParam" value="#esapiEncode('html_attr',objectparams.buttonlabel)#"/>
			</div>
				<!---<input type="hidden" class="objectParam" name="displaytype" id="displaytype" value="inline">--->
			<div class="mura-control-group">
				<label>Display</label>
				<select class="objectparam" name="displaytype" id="displaytype-select">
					<cfloop list="modal,inline" item="i">
						<option <cfif objectparams.displaytype eq i>selected </cfif>value="#i#">#rereplace(i,"(.)(.*)","\u\1\2")#</option>
					</cfloop>
				</select>
			</div>
			<div class="mura-control-group" id="displaytype-modal-label">
				<label class="mura-control-label">Modal Button Label</label>
				<input type="text" placeholder="Modal Button Label" name="modalbuttonlabel" class="objectParam" value="#esapiEncode('html_attr',objectparams.modalbuttonlabel)#"/>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Pre Gated Message</label>
				<div class="htmlEditorbox">
				<textarea id="pretext" name="pretext" class="objectParam" style="height:150px">#esapiEncode('html',objectParams.pretext)#</textarea>
				</div>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Post Gated Message</label>
				<div class="htmlEditorbox">
				<textarea id="posttext" name="posttext" class="objectParam htmlEditor" style="height:150px">#esapiEncode('html',objectParams.posttext)#</textarea>
				</div>
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">Asset URL</label>
				<input type="text" placeholder="URL" id="url" name="url" class="objectParam" value="#esapiEncode('html_attr',objectparams.url)#"/>
			</div>
		</div>
		<input type="hidden" class="objectParam" name="async" value="true">
	</div>
	<!--- Include global config object options --->
	<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">
	<cfset CKEDITOR_BASEPATH = '#$.siteConfig().getCorePath(complete=1)#/vendor/ckeditor/'>
	<script>
		$(document).ready(function() {
			function showHideModalLabel() {
				if($("##displaytype-select").val() == 'inline') {
					$("##displaytype-modal-label").hide();
				}
				else {
					$("##displaytype-modal-label").show();
				}				
			}

			$("##displaytype-select").on('change',showHideModalLabel);

			$('textarea##pretext').ckeditor(
				{ 
					toolbar: 'Basic'
					, customConfig: '#CKEDITOR_BASEPATH#/config.js.cfm'
				}
				, customHtmlEditorOnComplete
			);
			$('textarea##posttext').ckeditor(
				{ 
					toolbar: 'Basic'
					, customConfig: '#CKEDITOR_BASEPATH#/config.js.cfm'
				}
				, customHtmlEditorOnComplete
			);
			showHideModalLabel();
		});



		function customHtmlEditorOnComplete(editorInstance) {
			instance = $(editorInstance).ckeditorGet();
			instance.resetDirty();
			instance.on('blur', function() {
				$('textarea##posttext').trigger('change');
			});
		}
	</script>
	<link rel="stylesheet" href="/core/modules/v1/gatedasset/assets/css/module.css">
</cfoutput>
</cf_objectconfigurator>
