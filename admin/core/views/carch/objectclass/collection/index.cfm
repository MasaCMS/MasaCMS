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

<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfif isDefined("form.params") and isJSON(form.params)>
	<cfset objectParams=deserializeJSON(form.params)>
<cfelse>
	<cfset objectParams={}>
</cfif>

<cfparam name="objectParams.class" default="mura-left mura-twelve">
<cfparam name="objectParams.addlabel" default="false">
<cfparam name="objectParams.label" default="">
<cfparam name="objectParams.sourcetype" default="">
<cfparam name="objectParams.sourceid" default="">
<cfset data=structNew()>
<cfsavecontent variable="data.html">
<cfoutput>
<div id="availableObjectParams"
	data-object="collection" 
	data-name="#esapiEncode('html_attr','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.collection')#')#" 
	data-objectid="none">

	<div class="tabs">
		<ul id="steps" class="nav nav-tabs" role="tablist">
		    <li role="presentation" class="active"><a href="##placement" aria-controls="home" role="tab" data-toggle="tab">Placement</a></li>
		    <li role="presentation"><a href="##label" aria-controls="messages" role="tab" data-toggle="tab">Label</a></li>
			<li role="presentation"><a href="##content" aria-controls="settings" role="tab" data-toggle="tab">Content</a></li>
			<li role="presentation"><a href="##layout" aria-controls="settings" role="tab" data-toggle="tab">Layout</a></li>
			<li role="presentation"><a href="##preview" aria-controls="settings" role="tab" data-toggle="tab">Preview</a></li>
		 </ul>

	 	<!-- Tab panes -->
	  	<div class="tab-content">
			<div role="tabpanel" class="tab-pane active" id="placement">
				<div class="fieldset-wrap row-fluid">
					<div class="fieldset">
						<div class="control-group">
					      	<label class="control-label">Alignment</label>
							<div class="controls">
								 <select name="alignment">
									<option value="mura-left"<cfif listFind(objectParams.class,'mura-left',' ')> selected</cfif>>Left</option>
									<option value="mura-center"<cfif listFind(objectParams.class,'mura-center',' ')> selected</cfif>>Center</option>
									<option value="mura-right"<cfif listFind(objectParams.class,'mura-right',' ')> selected</cfif>>Right</option>
								</select>
							</div>
						</div>
						<div id="offsetcontainer" class="control-group" style="display:none">
					      	<label class="control-label">Offset</label>
							<div class="controls">
								<select name="offset">
									<option value="">None</option>
									<option value="mura-offset-by-one"<cfif listFind(objectParams.class,'mura-offset-by-one',' ')> selected</cfif>>One Twelfth</option>
									<option value="mura-offset-by-two"<cfif listFind(objectParams.class,'mura-offset-by-two',' ')> selected</cfif>>One Sixth</option>
									<option value="mura-offset-by-three"<cfif listFind(objectParams.class,'mura-offset-by-three',' ')> selected</cfif>>One Fourth</option>
									<option value="mura-offset-by-four"<cfif listFind(objectParams.class,'mura-offset-by-four',' ')> selected</cfif>>One Third</option>
									<option value="mura-offset-by-five"<cfif listFind(objectParams.class,'mura-offset-by-five',' ')> selected</cfif>>Five Twelfths</option>
									<option value="mura-offset-by-six"<cfif listFind(objectParams.class,'mura-offset-by-six',' ')> selected</cfif>>One Half</option>
									<option value="mura-offset-by-seven"<cfif listFind(objectParams.class,'mura-offset-by-seven',' ')> selected</cfif>>Seven Twelfths</option>
									<option value="mura-offset-by-eight"<cfif listFind(objectParams.class,'mura-offset-by-eight',' ')> selected</cfif>>Two Thirds</option>
									<option value="mura-offset-by-nine"<cfif listFind(objectParams.class,'mura-offset-by-nine',' ')> selected</cfif>>Three Fourths</option>
									<option value="mura-offset-by-ten"<cfif listFind(objectParams.class,'mura-offset-by-ten',' ')> selected</cfif>>Five Sixths</option>
									<option value="mura-offset-by-eleven"<cfif listFind(objectParams.class,'mura-offset-by-eleven',' ')> selected</cfif>>Eleven Twelfths</option>
								</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Width</label>
							<div class="controls">
								<select name="width">
									<option value="mura-one"<cfif listFind(objectParams.class,'mura-one',' ')> selected</cfif>>One Twelfth</option>
									<option value="mura-two"<cfif listFind(objectParams.class,'mura-two',' ')> selected</cfif>>One Sixth</option>
									<option value="mura-three"<cfif listFind(objectParams.class,'mura-three',' ')> selected</cfif>>One Fourth</option>
									<option value="mura-four"<cfif listFind(objectParams.class,'mura-four',' ')> selected</cfif>>One Third</option>
									<option value="mura-five"<cfif listFind(objectParams.class,'mura-five',' ')> selected</cfif>>Five Twelfths</option>
									<option value="mura-six"<cfif listFind(objectParams.class,'mura-six',' ')> selected</cfif>>One Half</option>
									<option value="mura-seven"<cfif listFind(objectParams.class,'mura-seven',' ')> selected</cfif>>Seven Twelfths</option>
									<option value="mura-eight"<cfif listFind(objectParams.class,'mura-eight',' ')> selected</cfif>>Two Thirds</option>
									<option value="mura-nine"<cfif listFind(objectParams.class,'mura-nine',' ')> selected</cfif>>Three Fourths</option>
									<option value="mura-ten"<cfif listFind(objectParams.class,'mura-ten',' ')> selected</cfif>>Five Sixths</option>
									<option value="mura-eleven"<cfif listFind(objectParams.class,'mura-eleven',' ')> selected</cfif>>Eleven Twelfths</option>
									<option value="mura-twelve"<cfif listFind(objectParams.class,'mura-twelve',' ')> selected</cfif>>Full</option>
								</select>
							</div>
						</div>
						
						<div class="form-actions">
							<button class="btn" onclick="$('##steps li:eq(1) a').tab('show')">Next Step &raquo;</button>
						</div>
					</div>

				
				</div>	
			</div>
		    <div role="tabpanel" class="tab-pane" id="label">
				<div class="fieldset-wrap row-fluid">
					<div class="fieldset">
						<div class="control-group">
							<label class="control-label">Add Label?</label>
							<div class="controls">
								<select name="addlabel" class="objectParam">
									<option value="true"<cfif objectParams.addlabel eq 'true'> selected</cfif>>Yes</option>
									<option value="false"<cfif objectParams.addlabel eq 'false'> selected</cfif>>No</option>
								</select>
							</div>
						</div>
						<div id="labelContainer"class="control-group">
							<label class="control-label">Label</label>
							<div class="controls">
								<input name="label" type="text" class="text objectParam" value="#esapiEncode('html_attr',objectParams.label)#"/>
							</div>
						</div>
						<div class="form-actions">
							<button class="btn" onclick="$('##steps li:eq(0) a').tab('show')">&laquo; Previous Step</button>
							<button class="btn" onclick="$('##steps li:eq(2) a').tab('show')">Next Step &raquo;</button>
						</div>
					</div>
				</div>
			</div>
		    <div role="tabpanel" class="tab-pane" id="content">
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
						</div>
						<div class="form-actions">
							<button class="btn" onclick="$('##steps li:eq(1) a').tab('show')">&laquo; Previous Step</button>
							<button class="btn" onclick="$('##steps li:eq(3) a').tab('show')">Next Step &raquo;</button>
						</div>
					</div>
				</div>
			</div>
			<div role="tabpanel" class="tab-pane" id="layout">
				<div class="fieldset-wrap row-fluid">
					<div class="fieldset">
						
						<div id="layoutcontainer" class="controls"></div>
						
						<div class="form-actions">
							<button class="btn" onclick="$('##steps li:eq(2) a').tab('show')">&laquo; Previous Step</button>
							<button class="btn" onclick="$('##steps li:eq(4) a').tab('show')"> Next Step &raquo;</button>
						</div>
					</div>
				</div>
			</div>
			<div role="tabpanel" class="tab-pane" id="preview">
				<div class="fieldset-wrap row-fluid">
					<div class="fieldset">
						<div>
							<iframe id="configuratorPreview" width="500px" height="700px" frameBorder="0"></iframe>
						</div>
						<div class="form-actions">
							<button class="btn" onclick="$('##steps li:eq(3) a').tab('show')">&laquo; Previous Step</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<input name="class" type="hidden" class="objectParam" value="#esapiEncode('html_attr',objectParams.class)#"/>
</div>
<script>
	$(function(){

		$('select[name="alignment"],select[name="width"],select[name="offset"]').on('change', function() {
			setPlacementVisibility();
		});

		$('select[name="sourcetype"]').on('change', function() {
			setContentSourceVisibility();
		});

		$('select[name="sourceid"]').on('change', function() {
			setLayoutOptions();
		});

		function setPlacementVisibility(){
			var classInput=$('input[name="class"]');

			classInput.val('');

  			var alignment=$('select[name="alignment"]');

  			classInput.val(alignment.val());

  			if(alignment.val()=='mura-left'){
  				$('##offsetcontainer').show();
  			} else {
  				$('##offsetcontainer').hide();
  			}

  			var width=$('select[name="width"]');
  			
  			if(width.val()){
  				if(classInput.val() ){
  					classInput.val(classInput.val() + ' ' + width.val());
  				} else {
  					classInput.val(width.val());
  				}
  			}

  			if(alignment.val()=='mura-left'){
	  			var offset=$('select[name="offset"]');
	  				
	  			if(offset.val()){
	  				if(classInput.val() ){
	  					classInput.val(classInput.val() + ' ' + offset.val());
	  				} else {
	  					classInput.val(offset.val());
	  				}
	  			}
	  		}
		}

		function setContentSourceVisibility(){
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
				$('##relatedcontentcontainer').show();
				$('##relatedcontent').addClass('objectParam');
			}
		}

		function setLabelVisibility(){

			if($('select[name="addlabel"]').val() == 'true'){
				$('##labelContainer').show();
			} else {
				$('##labelContainer').hide();
			}
		}

		function setLayoutOptions(){
			siteManager.updateAvailableObject();

			siteManager.availableObject.params.sourceid = siteManager.availableObject.params.sourceid || '';

			var params=$.extend(configParams,siteManager.availableObject.params);

			//console.log(params);
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

		$('select[name="addlabel"]').on('change', function() {
			setLabelVisibility();
		});

		setLabelVisibility();
		setPlacementVisibility();
		setContentSourceVisibility();
		setLayoutOptions();

	});
</script>
</cfoutput>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>
