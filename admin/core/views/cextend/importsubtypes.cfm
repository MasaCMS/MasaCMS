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
<cfoutput>
	<script>
		// for environments that don't support indexOf()
		if (!Array.prototype.indexOf) {
			Array.prototype.indexOf = function (searchElement /*, fromIndex */ ) {
				"use strict";

				if (this === void 0 || this === null) throw new TypeError();

				var t = Object(this);
				var len = t.length >>> 0;
				if (len === 0) return -1;

				var n = 0;
				if (arguments.length > 0) {
						n = Number(arguments[1]);
						if (n !== n) // shortcut for verifying if it's NaN
						n = 0;
				else if (n !== 0 && n !== (1 / 0) && n !== -(1 / 0)) n = (n > 0 || -1) * Math.floor(Math.abs(n));
				}

				if (n >= len) return -1;
				var k = n >= 0 ? n : Math.max(len - Math.abs(n), 0);
				for (; k < len; k++) {
					if (k in t && t[k] === searchElement) return k;
				}
				return -1;
			};
		}

		jQuery(document).ready(function($) {

			$('##frmSubmit').click(function(e) {
				var newFile = $('input[name="newFile"]').val();
				var validExtensions = ['xml','XML','cfm','CFM'];
				var ext = newFile.split('.').pop();
				var extIdx = validExtensions.indexOf(ext);

				if ( newFile === '' || extIdx == -1 ) {
					var msg = '#rc.$.rbKey('sitemanager.content.importnofilemessage')#';
					$('##alertDialogMessage').html(msg);

					$('##alertDialog').dialog({
						resizable: false,
						modal: true,
						buttons: {
							#rc.$.rbKey('sitemanager.extension.ok')#:
								{click: function() {
										$(this).dialog('close');
									}
								, text: 'OK'
								, class: 'mura-primary'
								} // /ok
							}


					});

				} else {
					submitForm(document.forms.form1,'import')
				}
			});

		});
	</script>
<div class="mura-header">
	<h1>#rc.$.rbKey('sitemanager.extension.importclassextensions')#</h1>

	<div class="nav-module-specific btn-group">
		<a class="btn" href="#rc.$.globalConfig('context')##rc.$.globalConfig('adminDir')#/?muraAction=cExtend.listSubTypes&amp;siteid=#esapiEncode('url',rc.siteid)#">
					<i class="mi-arrow-circle-left"></i>
			#rc.$.rbKey('sitemanager.extension.backtoclassextensions')#
		</a>
	</div>

</div> <!-- /.mura-header -->

<div class="block block-constrain">
		<div class="block block-bordered">
		  <div class="block-content">

					<form novalidate="novalidate" name="form1" method="post" onsubmit="return validateForm(this);"  enctype="multipart/form-data">
						<div class="mura-control-group">
							<label>
					#rc.$.rbKey('sitemanager.extension.uploadfile')#
				</label>
					<input type="file" name="newFile">
				</div>

		<div class="mura-actions">
			<div class="form-actions">
				<button id="frmSubmit" class="btn mura-primary"><i class="mi-sign-in"></i>#rc.$.rbKey('sitemanager.extension.import')#</button>
			</div>
		</div>

		<input type="hidden" name="action" value="import">
		<input name="muraAction" value="cExtend.importsubtypes" type="hidden">
		<input name="siteID" value="#esapiEncode('html_attr',rc.siteid)#" type="hidden">
		#rc.$.renderCSRFTokens(context='import',format="form")#
	</form>

				</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
	</div> <!-- /.block-constrain -->
</cfoutput>
