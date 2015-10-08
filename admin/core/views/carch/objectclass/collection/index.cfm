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
<cfif isDefined("form.params") and isJSON(form.params)>
	<cfset objectParams=deserializeJSON(form.params)>
<cfelse>
	<cfset objectParams={}>
</cfif>
<cfset data=structNew()>

<cfsavecontent variable="data.html">
<cf_objectconfigurator params="#objectparams#">
	<cfoutput>
	<div id="availableObjectParams"
		data-object="collection" 
		data-name="#esapiEncode('html_attr','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.collection')#')#" 
		data-objectid="none">

		<div class="tabs">
			<ul id="steps" class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="##content" aria-controls="settings" role="tab" data-toggle="tab">Content</a></li>
				<li role="presentation"><a href="##layout" aria-controls="settings" role="tab" data-toggle="tab">Layout</a></li>
				<li role="presentation"><a href="##preview" aria-controls="settings" role="tab" data-toggle="tab">Preview</a></li>
			 </ul>

		 	<!-- Tab panes -->
		  	<div class="tab-content">
			    <div role="tabpanel" class="tab-pane active" id="content">
					<div class="fieldset-wrap row-fluid">
						<div class="fieldset">
							<div class="control-group">
								<label class="control-label">Content Source</label>
								<div class="controls">
									<select class="objectParam" name="sourcetype">
										<option value="">Select Content Source</option> 	
										<option <cfif objectParams.sourcetype eq 'localindex'>selected </cfif>value="localindex">Local Index</option>	
										<option <cfif objectParams.sourcetype eq 'remotefeed'>selected </cfif>value="remotefeed">Remote Feed</option>
										<option <cfif objectParams.sourcetype eq 'relatedcontent'>selected </cfif>value="relatedcontent">Related Content</option>
									</select>
								</div>
							</div>
							<div id="localindexcontainer" class="control-group sourceid-container" style="display:none">
								<label class="control-label">Select Local Index</label>
								<div class="controls">
									<cfset rs=rc.$.getBean('feedManager').getFeeds(type='local',siteid=rc.$.event('siteid'),activeOnlt=true)>
									<select name="sourceid" id="localindex">
										<option value="">Select Local Index</option> 	
										<cfloop query="rs">
											<option value="#rs.feedid#"<cfif rs.feedid eq objectParams.sourceid> selected</cfif>>#esapiEncode('html',rs.name)#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div id="remotefeedcontainer" class="control-group sourceid-container" style="display:none">
								<label class="control-label">Select Remote Feed</label>
								<div class="controls">
									<cfset rs=rc.$.getBean('feedManager').getFeeds(type='remote',siteid=rc.$.event('siteid'),activeOnlt=true)>
									<select name="sourceid" id="remotefeed">
										<option value="">Select Remote Feed</option> 	
										<cfloop query="rs">
											<option value="#rs.feedid#"<cfif rs.feedid eq objectParams.sourceid> selected</cfif>>#esapiEncode('html',rs.name)#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div id="relatedcontentcontainer" class="control-group sourceid-container" style="display:none">
								<label class="control-label">Select Related Content Set</label>
								<div class="controls">
									<cfset subtype = application.classExtensionManager.getSubTypeByName(rc.contenttype, rc.contentsubtype,rc.siteid)>
									<cfset relatedContentSets = subtype.getRelatedContentSets()>
									<select name="sourceid" id="relatedcontent">
										<option value="">Select Related Content</option> 	
										<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="s">
											<cfset rcsBean = relatedContentSets[s]/>
											<option value="#rcsBean.getName()#"<cfif objectParams.sourceid eq rcsBean.getName()> selected</cfif>>#rcsBean.getName()#</option>
										</cfloop>
									</select>
								</div>
								<cfif rc.configuratormode neq 'backend'>
								<div id="relatedContentContainer">
									<div id="selectRelatedContent"></div>
									<div id="selectedRelatedContent" class="control-group"></div>
								</div>
								<input id="relatedContentSetData" type="hidden" name="relatedContentSetData" value="" />	
								</cfif>
							</div>

						</div>
					</div>
				</div>
				<div role="tabpanel" class="tab-pane" id="layout">
					<div class="fieldset-wrap row-fluid">
						<div class="fieldset">
							
							<div id="layoutcontainer" class="controls"></div>
		
						</div>
					</div>
				</div>
				<div role="tabpanel" class="tab-pane" id="preview">
					<div class="fieldset-wrap row-fluid">
						<div class="fieldset">
							<div>
								<iframe id="configuratorPreview" width="500px" height="700px" frameBorder="0"></iframe>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>	

	<script>
		$(function(){

			$('select[name="sourcetype"]').on('change', function() {
				setContentSourceVisibility();
			});

			$('select[name="sourceid"]').on('change', function() {
				setLayoutOptions();

				if($('select[name="sourcetype"]').val()=='relatedcontent'){
					setContentSourceVisibility();
				}
			});

			function setContentSourceVisibility(){
				<cfif rc.configuratormode neq 'backend'>
				<cfset content=rc.$.getBean('content').loadBy(contenthistid=rc.contenthistid)>

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

				$('select[name="sourceid"]').removeClass('objectParam');
				$('.sourceid-container').hide();

				var val=$('select[name="sourcetype"]').val();

				if(val=='localindex'){
					$('##localindex').addClass('objectParam');
					$('##localindexcontainer').show();
				} else if(val=='remotefeed'){
					$('##remotefeed').addClass('objectParam');
					$('##remotefeedcontainer').show();
				} else if(val=='relatedcontent'){
					$('##relatedContentSetData').val('');
					$('##selectRelatedContent').html('');
					$('##selectedRelatedContent').html('');
					$('##relatedcontentcontainer').show();
					$('##relatedcontent').addClass('objectParam');
					<cfif rc.configuratormode neq 'backend'>

					var sourceid=$('##relatedcontent').val();

					if(sourceid){
						$('##relatedContentContainer').show();
						siteManager
							.loadRelatedContentSets(
								getContentID(),
								getContentHistID(),
								getType(),
								getSubType(),
								getSiteID(),
								sourceid
							);
					} else {
						$('##relatedContentContainer').hide();
					}	
					
					</cfif>
				}
			}

			function setLayoutOptions(){
				
				siteManager.updateAvailableObject();

				siteManager.availableObject.params.sourceid = siteManager.availableObject.params.sourceid || '';

				var params=siteManager.availableObject.params;
				
				$.ajax(
				 {
				 	type: 'post',
				 	dataType: 'text',
					url: './?muraAction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + configOptions.siteid + '&classid=' + configOptions.object + '&contentid=' + contentid + '&parentid=' + configOptions.parentid + '&contenthistid=' + configOptions.contenthistid + '&regionid=' + configOptions.regionid + '&objectid=' + configOptions.objectid + '&contenttype=' + configOptions.contenttype + '&contentsubtype=' + configOptions.contentsubtype + '&container=layout&cacheid=' + Math.random(),

					data:{params:JSON.stringify(params)},
					success:function(response){
						$('##layoutcontainer').html(response);

						$("##availableListSort, ##displayListSort").sortable({
							connectWith: ".displayListSortOptions",
							update: function(event) {
								event.stopPropagation();
								$("##displayList").val("");
								$("##displayListSort > li").each(function() {
									var current = $("##displayList").val();

									if(current != '') {
										$("##displayList").val(current + "," + $(this).html());
									} else {
										$("##displayList").val($(this).html());
									}

								});

								siteManager.updateObjectPreview();
								
							}
						}).disableSelection();
					}
				})
			}
		
			setContentSourceVisibility();
			setLayoutOptions();

		});
	</script>
	</cfoutput>
</cf_objectconfigurator>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>
