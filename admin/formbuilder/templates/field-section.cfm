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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfoutput><span>
		<div class="meld-tb-form" id="formblock-${fieldid}">
			<div class="meld-tb-header">
				<h3>#mmRBF.getKeyValue(session.rb,'formbuilder.field.section')#: <span id="meld-tb-form-label"></span></h3>
				<ul class="right">
					<li><div class="ui-button" id="button-trash" title="#mmRBF.getKeyValue(session.rb,'formbuilder.delete')#"><span class="ui-icon ui-icon-closethick"></span></div></li>
				</ul>
			</div>
			<ul class="template-form">
				<li>
					<label for="label">#mmRBF.getKeyValue(session.rb,'formbuilder.field.label')#</label>
					<input class="text medium tb-label" type="text" name="label" value="" data-label="true">
				</li>
				<li>
					<label for="name">#mmRBF.getKeyValue(session.rb,'formbuilder.field.name')#</label>
					<input id="tb-name" class="text medium disabled" name="name" type="text" value="" maxlength="50" disabled="true" />
				</li>
			</ul>
		</div>
	</span>
</cfoutput>