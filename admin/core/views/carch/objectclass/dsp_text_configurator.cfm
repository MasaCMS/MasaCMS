<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfsilent>
	<cfif isDefined("form.params") and isJSON(form.params)>
		<cfset objectParams=deserializeJSON(form.params)>
	<cfelse>
		<cfset objectParams={}>
	</cfif>
	<cfparam name="objectParams.sourcetype" default="">
	<cfparam name="objectParams.source" default="">
	<cfset data=structNew()>
	<cfset hasModuleAccess=rc.configuratormode neq 'backend' and rc.$.getBean('permUtility').getModulePerm('00000000000000000000000000000000003',rc.siteid)>
	<cfset content=rc.$.getBean('content').loadBy(contenthistid=rc.contenthistid)>
</cfsilent>
<cfsavecontent variable="data.html">
<cf_objectconfigurator params="#objectparams#">
	<cfoutput>
	<div id="availableObjectParams"
		data-object="collection" 
		data-name="#esapiEncode('html_attr','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.text')#')#" 
		data-objectid="none">
		<div class="fieldset-wrap row-fluid">
			<div class="fieldset">
				<div class="control-group">
					<label class="control-label">Content Source</label>
					<div class="controls">
						<select class="objectParam span12" name="sourcetype">
							<option value="">Select Content Source</option> 	
							<option <cfif objectParams.sourcetype eq 'freetext'>selected </cfif>value="freetext">Free Text</option>	
							<option <cfif objectParams.sourcetype eq 'boundattribute'>selected </cfif>value="boundattribute">Bound Attribute</option>
							<option <cfif objectParams.sourcetype eq 'component'>selected </cfif>value="component">Component</option>
						</select>
					</div>
				</div>
				<div id="componentcontainer" class="control-group source-container" style="display:none">
					<label class="control-label">Select Component</label>
					<div class="controls">
						<cfset rs=rc.$.getBean('contentManager').getList(args={moduleid='00000000000000000000000000000000003',siteid=session.siteid})>
						<select name="source" id="component" class="span12">
							<option value="">Select Component</option> 	
							<cfloop query="rs">
								<option value="#rs.contentid#"<cfif rs.contentid eq objectParams.source> selected</cfif>>#esapiEncode('html',rs.title)#</option>
							</cfloop>
						</select>

						<cfif hasModuleAccess>
							<button class="btn" id="editBtnComponent">Create New</button>
						</cfif>

					</div>
				</div>
				<div id="freetextcontainer" class="control-group source-container" style="display:none">
					<label class="control-label">Set Free Text</label>
					<div class="controls">
						<textarea name="source" id="freetext" class="htmlEditor"><cfif objectParams.sourceType eq 'freetext'>#objectParams.source#</cfif></textarea>
					</div>
				</div>
				<div id="boundattributecontainer" class="control-group source-container" style="display:none">
					<label class="control-label">Select Bound Attribute</label>
					<div class="controls">
						<cfsilent>
						<cfset options=arrayNew(2) />
						<cfset options[1][1]="menutitle">
						<cfset options[1][2]=application.rbFactory.getKeyValue(session.rb,'params.menutitle')>
						<cfset options[2][1]="title">
						<cfset options[2][2]=application.rbFactory.getKeyValue(session.rb,'params.title')>
						<cfset options[3][1]="credits">
						<cfset options[3][2]=application.rbFactory.getKeyValue(session.rb,'params.credits')>
						<cfset options[4][1]="summary">
						<cfset options[4][2]=application.rbFactory.getKeyValue(session.rb,'params.summary')>
				
						<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(siteID=rc.siteid,baseTable="tcontent",activeOnly=true,type=content.getType(),subtype=content.getSubType())>
						<cfloop query="rsExtend">
						<cfset options[rsExtend.currentRow + 4][1]=rsExtend.attribute>
						<cfset options[rsExtend.currentRow + 4][2]=rsExtend.attribute/>
						</cfloop>
					</cfsilent>
						<select name="source" id="boundattribute" class="span12">
							<option value="">Select Bound Attribute</option> 
							<cfloop from="1" to="#arrayLen(options)#" index="i">
								<option value="#esapiEncode('html_attr',options[i][1])#"<cfif objectParams.source eq options[i][1]> selected</cfif>>#esapiEncode('html',options[i][2])#</option> 
							</cfloop>
						</select>
					</div>
				</div>
			</div>			
		</div>
	</div>	
	<cfparam name="objectParams.render" default="server">
	<input type="hidden" class="objectParam" name="render" value="#esapiEncode('html_attr',objectParams.render)#">
	<input type="hidden" class="objectParam" name="async" value="#esapiEncode('html_attr',objectParams.async)#">
	<script>
		$(function(){

			function setComponentEditOption(){
				var selector=$('##component');
			 	if(selector.val()){
			 		$('##editBtnComponent').html('Edit');
			 	} else {
			 		$('##editBtnComponent').html('Create New');
			 	}
			}

			function setContentSourceVisibility(){
				<cfif rc.configuratormode neq 'backend'>

				function getType(){
					var type=$('input[name="type"]');

					if(type.length){
						return type.val();
					} else {
						return '#esapiEncode("javascript",content.getType())#';
					}
				}

				function getSubType(){
					var subtype=$('input[name="subtype"]');

					if(subtype.length){
						return subtype.val();
					} else {
						return '#esapiEncode("javascript",content.getSubType())#';
					}
				}

				function getContentID(){
					return '#esapiEncode("javascript",content.getContentID())#';
				}

				function getContentHistID(){
					return '#esapiEncode("javascript",content.getContentHistID())#';
				}

				function getSiteID(){
					return '#esapiEncode("javascript",rc.siteid)#';
				}
				</cfif>

				$('select[name="source"], textarea[name="source"]').removeClass('objectParam');
				$('.source-container').hide();

				var val=$('select[name="sourcetype"]').val();

				if(val=='freetext'){
					$('##freetext').addClass('objectParam');
					$('##freetextcontainer').show();
					$('input[name="render"]').val('client');
					$('input[name="async"]').val('false');
				} else if(val=='boundattribute'){
					$('##boundattribute').addClass('objectParam');
					$('##boundattributecontainer').show();
					$('input[name="render"]').val('server');
					$('input[name="async"]').val('true');
				} else if(val=='component'){
					$('##component').addClass('objectParam');
					$('##componentcontainer').show();
					$('input[name="render"]').val('server');	
					$('input[name="async"]').val('true');
				}
			}

			$('select[name="sourcetype"]').on('change', function() {
				setContentSourceVisibility();
			});

			$('##component').change(setComponentEditOption);
			
			$('##editBtnComponent').click(function(){
				frontEndProxy.post({
					cmd:'openModal',
					src:'?muraAction=cArch.editLive&contentId=' +  $('##component').val() + '&type=Component&siteId=#esapiEncode("javascript",rc.siteid)#&instanceid=#esapiEncode("javascript",rc.instanceid)#&compactDisplay=true'
					}
				);
			
			});

			$('textarea.htmlEditor').each(function(){
				var textarea=$(this);

				var instance = CKEDITOR.instances[textarea.attr('id')];

				if(typeof(instance) != 'undefined' && instance != null) {
					CKEDITOR.remove(instance);
				}

				if(!textarea.val()){
					textarea.val('<p></p>');
				}
				textarea.ckeditor({
					toolbar: 'htmlEditor',
					customConfig: 'config.js.cfm'
				});
			})
			setContentSourceVisibility();
			setComponentEditOption();

		});
	</script>
	</cfoutput>
</cf_objectconfigurator>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>
