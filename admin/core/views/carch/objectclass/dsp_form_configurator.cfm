
<cfset content=rc.$.getBean('content').loadBy(contentid=rc.objectid)>
<cfset content.setType('Form')>
<cfset rc.rsForms = application.contentManager.getComponentType(rc.siteid, 'Form')/>
<cfset hasModulePerm=rc.configuratormode neq 'backend' and rc.$.getBean('permUtility').getModulePerm('00000000000000000000000000000000004',rc.siteid)>
<cf_objectconfigurator>
<cfoutput>
<div class="fieldset-wrap row-fluid">
	<div class="fieldset">
		<div class="control-group">
			<label class="control-label">Select Form</label>
			<div class="controls">
				<select id="availableObjectSelector">
					<option value="{object:'form',name:'#esapiEncode('html_attr','Select Form')#',objectid:''}">
					--
					</option>

					<cfloop query="rc.rsForms">

						<cfset title=rc.rsForms.menutitle>

						<option <cfif rc.objectid eq rc.rsForms.contentid and rc.object eq 'form'>selected </cfif>title="#esapiEncode('html_attr',title)#" value="{object:'form',name:'#esapiEncode('html_attr',title)#',objectid:'#rc.rsForms.contentid#'}">
							#esapiEncode('html',title)#
						</option>
						<!---
						<cfif rc.rsForms.responseChart neq 1>

							<cfset title=application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.dataresponses')
								& ' - ' 
								& rc.rsForms.menutitle>
								
							<option <cfif rc.objectid eq rc.rsForms.contentid and rc.object eq 'form_responses'>selected </cfif>title="#esapiEncode('html_attr',title)#" value="{'object':'form_responses','name':'#esapiEncode('html_attr',title)#','objectid':'#rc.rsForms.contentid#'}">
								#esapiEncode('html',title)#
							</option>
						</cfif>
						--->
					</cfloop>
				</select>
				<cfif hasModulePerm>
					<button class="btn" id="editBtn">Edit</button>
				</cfif>
			</div>
		</div>
	</div>
</div>
<cfif hasModulePerm>
<script>
	$(function(){
		function setEditOption(){
			var selector=$('##availableObjectSelector');
		 	if(eval('(' + selector.val() + ')').objectid){
		 		$('##editBtn').html('Edit');
		 	} else {
		 		$('##editBtn').html('Create New');
		 	}
		}
		
		$('##availableObjectSelector').change(setEditOption);

		setEditOption();
		 
		$('##editBtn').click(function(){
				document.location='./?muraAction=cArch.editLive&contentId=' + eval('(' + $('##availableObjectSelector').val() + ')').objectid  + '&type=Form&siteId=#esapiEncode("javascript",rc.siteid)#&instanceid=#esapiEncode("javascript",rc.instanceid)#&compactDisplay=true';
		})

	});
</script>
</cfif>
</cfoutput>
</cf_objectconfigurator>
