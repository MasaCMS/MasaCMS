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
	<cfset content=rc.$.getBean('content').loadBy(contentid=rc.objectid)>
	<cfset content.setType('Form')>
	<cfset rc.rsForms = application.contentManager.getComponentType(rc.siteid, 'Form')/>
	<cfset hasModulePerm=rc.configuratormode neq 'backend' and rc.$.getBean('permUtility').getModulePerm('00000000000000000000000000000000004',rc.siteid)>
</cfsilent>
<cf_objectconfigurator>
<cfoutput>
<div class="fieldset-wrap row-fluid">
	<div class="fieldset">
		<div class="control-group">
			<label class="control-label">Select Form</label>
			<div class="controls">
				<select id="availableObjectSelector" class="span12">
					<option value="{object:'form',name:'#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectform'))#',objectid:'unconfigured'}">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectform')#
					</option>

					<cfloop query="rc.rsForms">

						<cfset title=rc.rsForms.menutitle>

						<option <cfif rc.objectid eq rc.rsForms.contentid and rc.object eq 'form'>selected </cfif>title="#esapiEncode('html_attr',title)#" value="{object:'form',name:'#esapiEncode('html_attr',title)#',objectid:'#rc.rsForms.contentid#'}">
							#esapiEncode('html',title)#
						</option>
				
					</cfloop>
				</select>
				<cfif hasModulePerm>
					<button class="btn" id="editBtn">#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#</button>
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
				frontEndProxy.post({
					cmd:'openModal',
					src:'?muraAction=cArch.editLive&contentId=' + eval('(' + $('##availableObjectSelector').val() + ')').objectid  + '&type=Form&siteId=#esapiEncode("javascript",rc.siteid)#&instanceid=#esapiEncode("javascript",rc.instanceid)#&compactDisplay=true'
					}
				);
		})

	});
</script>
</cfif>
</cfoutput>
</cf_objectconfigurator>
