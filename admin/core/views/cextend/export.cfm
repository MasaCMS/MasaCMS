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
		jQuery(document).ready(function($){

			var $defaultmsg, $thecode, $clipboardContainer, $doc, $focusInput, $infoBox, onKeydown, onKeyup, value;

			$defaultmsg = "#rc.$.rbKey('sitemanager.extension.copymessage.default')#";
			$copiedmsg = "#rc.$.rbKey('sitemanager.extension.copymessage.copied')#";
			$focusInput = $('<input class="absolute-hidden" type="text"/>').appendTo(document.body).focus().remove();
			$doc = $(document);
			$thecode = $('##thecode');
			$infoBox = $('.info-box');
			$clipboardContainer = $("##clipboard-container");
			value = '';

			$infoBox.html($defaultmsg);			

			onKeydown = function(e) {
			  var $target;
			  $target = $(e.target);

			  return setTimeout((function() {
			    $clipboardContainer.empty().show();
			    $("<textarea id='clipboard'></textarea>").val(value).appendTo($clipboardContainer).focus().select();
			    $infoBox.html($copiedmsg);
			    return setTimeout((function() {
			      return true;
			    }), 0);
			  }), 0);
			};

			onKeyup = function(e) {
			  if ($(e.target).is('##clipboard')) {
			    return $('##clipboard-container').empty().hide();
			  }
			};

			$doc.on('keydown', function(e) {
			  if (value && (e.ctrlKey || e.metaKey) && (e.which === 67)) {
			    return onKeydown(e);
			  }
			}).on('keyup', onKeyup);

			$thecode.bind('mouseenter focusin', function(e){
				return value = $(this).val();
			});

			$thecode.bind('mouseleave focusout', function(e){
				$infoBox.html($defaultmsg);
				return value = '';
			});

		});
	</script>

	<div id="clipboard-container" style="position:fixed;left:0px;top:0px;width:0px;height:0px;z-index:100;display:none;opacity:0;"><textarea id="clipboard" style="width:1px;height:1px;padding:0px;margin:0px;"></textarea></div>

	<h1>#rc.$.rbKey('sitemanager.extension.exportclassextensions')#</h1>

	<div id="nav-module-specific" class="btn-group">
		<a class="btn" href="#rc.$.globalConfig('context')#/admin/?muraAction=cExtend.listSubTypes&amp;siteid=#esapiEncode('url',rc.siteid)#">
			<i class="icon-circle-arrow-left"></i> 
			#rc.$.rbKey('sitemanager.extension.backtoclassextensions')#
		</a>
	</div>

	<form class="fieldset-wrap">
		<div class="fieldset">
			<div class="control-group">
				<div id="copymessage" class="controls">
					<div class="info-box alert alert-info"></div>
				</div>
				<div class="controls">
					<textarea id="thecode" class="form-control span12" rows="20" style="height:100% !important;">#esapiEncode('html', rc.exportXML)#</textarea>	
				</div>
			</div>
		</div>
	</form>
</cfoutput>