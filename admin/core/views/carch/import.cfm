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
	<cfset hasChangesets = $.getBean('settingsManager').getSite($.event('siteID')).getValue('hasChangesets') />
	<cfset enforceChangesets = $.getBean('settingsManager').getSite($.event('siteID')).getValue('enforceChangesets') />
</cfsilent>
<cfoutput>
	<script>
		jQuery(document).ready(function($) {

			$("##savetochangesetname").hide();
			$("##import_status").change(function() {
				if( $("##import_status").val() == "Changeset" ) {
					$("##savetochangesetname").show();
				} else {
					$("##savetochangesetname").hide();
				}
			});

			$('##frmSubmit').click(function(e) {
				var newFile = $('input[name="newFile"]').val();
				if ( newFile === '' || newFile.split('.').pop() !== 'zip' ) {
					var msg = '#rc.$.rbKey('sitemanager.content.importnofilemessage')#';
					$('##alertDialogMessage').html(msg);

					$('##alertDialog').dialog({
						resizable: false,
						modal: true,
						buttons: {
							'#rc.$.rbKey('sitemanager.extension.ok')#': function() {
								$(this).dialog('close');
							}
						}
					});

				} else {
					submitForm(document.forms.form1,'import')
				}
			});

		});
	</script>

	<h1>
		#rc.$.rbKey('sitemanager.content.importcontent')#
	</h1>

	<div id="nav-module-specific" class="btn-group">
		<a class="btn" href="./?muraAction=cArch.list&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;contentid=#esapiEncode('url',rc.contentid)#&amp;moduleid=#esapiEncode('url',rc.moduleid)#">
			<i class="icon-circle-arrow-left"></i> 
			#rc.$.rbKey('sitemanager.backtositemanager')#
		</a>
	</div>

	<form class="fieldset-wrap" novalidate="novalidate" name="form1" method="post" onsubmit="return validateForm(this);" enctype="multipart/form-data">
		<div class="fieldset">
			<div class="control-group">
				<label class="control-label">
					#rc.$.rbKey('sitemanager.content.importcontent')#
				</label>
				<div class="controls">
					<input type="file" name="newFile">
				</div>
			</div>

			<cfif not enforceChangesets>
				<div class="control-group">
					<label class="control-label">
						#rc.$.rbKey('sitemanager.content.contentstatus')#
					</label>
					<div class="controls">
						<select name="import_status" id="import_status">
							<option value="Approved">#rc.$.rbKey('sitemanager.content.published')#</option>				
							<option value="Draft">#rc.$.rbKey('sitemanager.content.draft')#</option>
							<cfif hasChangesets or enforceChangesets>
							<option value="Changeset">#rc.$.rbKey('sitemanager.content.savetochangeset')#</option>
							</cfif>
						</select>
					</div>
				</div>
			<cfelse>
				<input type="hidden" name="import_status" value="Changeset" />
			</cfif>

			<div id="savetochangesetname">
				<div class="control-group">
					<label class="control-label">
						#rc.$.rbKey('sitemanager.content.changesetname')#
					</label>
					<div class="controls">
						<input type="text" name="changeset_name">
					</div>
				</div>
			</div>
		</div>

		<div class="form-actions">
			<input id="frmSubmit" type="button" class="btn" value="Import" />
		</div>

		<input type="hidden" name="action" value="import">
		<input name="muraAction" value="cArch.importcontent" type="hidden">
		<input name="siteID" value="#esapiEncode('html_attr',session.siteid)#" type="hidden">
		<input name="moduleid" value="#esapiEncode('html_attr',rc.moduleid)#" type="hidden">
		<input name="contentid" value="#esapiEncode('html_attr',rc.contentid)#" type="hidden">
		#rc.$.renderCSRFTokens(context=rc.contentid,format="form")#
	</form>
</cfoutput>