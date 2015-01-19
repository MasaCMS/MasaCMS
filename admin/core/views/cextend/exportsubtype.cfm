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
<cfoutput>
	<script>
		jQuery(function ($) {
			$("##checkall").click(function(){
				$('input:checkbox').not(this).prop('checked', this.checked);
			});

			// make sure at least one class extension has been selected
			$('##btnSubmit').on('click', function(e){
				var n = $('.checkbox:checkbox:checked').map(function(){
					return $(this).val();
				}).get();

				if ( n.length === 0 ) {
					jQuery('##alertDialogMessage').html("#rc.$.rbKey('sitemanager.extension.selectatleastone')#");
					jQuery('##alertDialog').dialog({
						resizable: false,
						modal: true,
						buttons: {
							"#rc.$.rbKey('sitemanager.extension.ok')#": function() {
								jQuery(this).dialog('close');
							}
						}
					});
					return false;
				} else {
					submitForm(document.forms.form1, 'add');
				}
			});

		});
	</script>

	<h1>#rc.$.rbKey('sitemanager.extension.exportclassextensions')#</h1>

	<div id="nav-module-specific" class="btn-group">
		<a class="btn" href="#rc.$.globalConfig('context')#/admin/?muraAction=cExtend.listSubTypes&amp;siteid=#esapiEncode('url',rc.siteid)#">
			<i class="icon-circle-arrow-left"></i> 
			#rc.$.rbKey('sitemanager.extension.backtoclassextensions')#
		</a>
	</div>

	<form class="fieldset-wrap" novalidate="novalidate" name="form1" method="post" onsubit="return validateForm(this);">
		<div class="fieldset">
			<div class="control-group">
				<div class="controls">
					<label class="checkbox">
						<input type="checkbox" name="checkall" id="checkall" /> 
						<strong>#rc.$.rbKey('sitemanager.extension.selectall')#</strong>
					</label>
				</div>
			</div>

			<div class="control-group">
				<div class="controls">
					<cfloop query="rc.subtypes">
						<label class="checkbox">
							<input name="exportClassExtensionID" type="checkbox" class="checkbox" value="#subtypeid#">
							#esapiEncode('html', type)# / #esapiEncode('html', subtype)#
						</label>
					</cfloop>
				</div>
			</div>
		</div>
		
		<div class="form-actions">
			<input id="btnSubmit" type="button" class="btn" value="#rc.$.rbKey('sitemanager.extension.export')#" />
		</div>

		<input type="hidden" name="action" value="export">
		<input name="muraAction" value="cExtend.export" type="hidden">
		<input name="siteID" value="#esapiEncode('html_attr',rc.siteid)#" type="hidden">
		#rc.$.renderCSRFTokens(context=rc.extendSetID,format="form")#
	</form>
</cfoutput>