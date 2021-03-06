<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

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
							#rc.$.rbKey('sitemanager.extension.ok')#: 
							{click: function() {
									jQuery(this).dialog('close');
								}
							, text: '#rc.$.rbKey('sitemanager.extension.ok')#'
							, class: 'mura-primary'
							} // /Yes
						}
					});

				} else {
					submitForm(document.forms.form1,'import')
				}
			});

		});
	</script>

	<div class="mura-header">
		<h1>#rc.$.rbKey('sitemanager.content.importcontent')#</h1>

		<div class="nav-module-specific btn-group">
			<a class="btn" href="./?muraAction=cArch.list&amp;siteid=#esapiEncode('url',rc.siteid)#&amp;contentid=#esapiEncode('url',rc.contentid)#&amp;moduleid=#esapiEncode('url',rc.moduleid)#">
				<i class="mi-arrow-circle-left"></i>
				#rc.$.rbKey('sitemanager.backtositemanager')#
			</a>
		</div>
		
		#rc.$.dspZoom(crumbdata=rc.$.getBean('content').loadBy(contentid=rc.contentid).getCrumbArray(),class="breadcrumb")#
	</div> <!-- /.mura-header -->

	<form novalidate="novalidate" name="form1" method="post" onsubmit="return validateForm(this);" enctype="multipart/form-data">
		<div class="block block-constrain">
			<div class="block-content">
				<div class="mura-control-group">
					<label class="mura-control-label">
						#rc.$.rbKey('sitemanager.content.importcontent')#
					</label>
					<input type="file" name="newFile">
				</div>

				<cfif not enforceChangesets>
					<div class="mura-control-group">
						<label class="mura-control-label">
							#rc.$.rbKey('sitemanager.content.contentstatus')#
						</label>

						<select name="import_status" id="import_status">
							<option value="Approved">#rc.$.rbKey('sitemanager.content.published')#</option>
							<option value="Draft">#rc.$.rbKey('sitemanager.content.draft')#</option>
							<cfif hasChangesets or enforceChangesets>
							<option value="Changeset">#rc.$.rbKey('sitemanager.content.savetochangeset')#</option>
							</cfif>
						</select>

					</div>
				<cfelse>
					<input type="hidden" name="import_status" value="Changeset" />
				</cfif>

				<div id="savetochangesetname">
					<div class="mura-control-group">
						<label class="mura-control-label">
							#rc.$.rbKey('sitemanager.content.changesetname')#
						</label>
						<div class="mura-control">
							<input type="text" name="changeset_name">
						</div>
					</div>
				</div>
			</div>

			<div class="mura-actions">
				<div class="form-actions">
					<button id="frmSubmit" class="btn mura-primary"><i class="mi-sign-in"></i>Import</button>
				</div>
			</div>

			<input type="hidden" name="action" value="import">
			<input name="muraAction" value="cArch.importcontent" type="hidden">
			<input name="siteID" value="#esapiEncode('html_attr',session.siteid)#" type="hidden">
			<input name="moduleid" value="#esapiEncode('html_attr',rc.moduleid)#" type="hidden">
			<input name="contentid" value="#esapiEncode('html_attr',rc.contentid)#" type="hidden">
			#rc.$.renderCSRFTokens(context=rc.contentid,format="form")#
		</div>
	</form>

</cfoutput>
