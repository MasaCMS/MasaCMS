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
<h1>#application.rbFactory.getKeyValue(session.rb,'advertising.editadzone')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

#application.utility.displayErrors(rc.adZoneBean.getErrors())#

<form <cfif rc.adZoneID neq ''>class="fieldset-wrap"</cfif> novalidate="novalidate" name="form1" method="post" action="index.cfm?muraAction=cAdvertising.updateAdZone&siteid=#URLEncodedFormat(rc.siteid)#" onsubmit="return false;">


<cfif rc.adZoneID neq ''>
<div class="tabbable tabs-left">
	<ul class="nav nav-tabs tabs initActiveTab">
		<li><a href="##tabBasic" onclick="return false;"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.basic')#</span></a></li>
		<li><a href="##tabUsagereport" onclick="return false;"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.usagereport')#</span></a></li>
	</ul>
	<div class="tab-content">
		<div id="tabBasic" class="tab-pane fade">
<cfelse>
	<div class="fieldset">
</cfif>
			<div class="control-group">
				<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'advertising.name')#
				</label>
				<div class="controls">
					<input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.namerequired')#" value="#HTMLEditFormat(rc.adZoneBean.getName())#" maxlength="50">
				</div>
			</div>

			<div class="control-group">
			<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'advertising.assettype')#</label>
				<div class="controls">
					<select name="creativeType">
						<cfloop list="#application.advertiserManager.getCreativeTypes()#" index="ct">
						<option value="#ct#" <cfif rc.adZoneBean.getCreativeType() eq ct>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#replace(ct,' ','','all')#')#</option>
						</cfloop>
					</select>
				</div>
			</div>

			<div class="control-group">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</label>
				<div class="controls">
					<input name="height" validate="numeric" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.heightvalidate')#" value="#rc.adZoneBean.getHeight()#">
				</div>
			</div>

			<div class="control-group">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</label>
				<div class="controls">
				<input name="width" validate="numeric" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.widthvalidate')#" value="#rc.adZoneBean.getWidth()#">
				</div>
			</div>

			<div class="control-group">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'advertising.isactive')#</label>
				<div class="controls">
					<label for="isActiveYes" class="radio">
						<input name="isActive" id="isActiveYes" type="radio" value="1" <cfif rc.adZoneBean.getIsActive()>checked</cfif>> 
						#application.rbFactory.getKeyValue(session.rb,'advertising.yes')#
					</label> 
					<label for="isActiveNo" class="radio">
						<input name="isActive" id="isActiveNo" type="radio" value="0" <cfif not rc.adZoneBean.getIsActive()>checked</cfif>> 
						#application.rbFactory.getKeyValue(session.rb,'advertising.no')#
					</label>
				</div>
			</div>

			<div class="control-group">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'advertising.notes')#</label>
				<div class="controls">
				<textarea name="notes" class="textArea">#HTMLEditFormat(rc.adZoneBean.getNotes())#</textarea>
				</div>
			</div>
		

		</div>
		
		<cfif rc.adZoneID neq ''>
		<cfinclude template="dsp_tab_usage.cfm">
		</cfif>

		<div class="form-actions">
			<cfif rc.adZoneid eq ''>
				<input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.add')#" /><input type=hidden name="adZoneID" value="">
			<cfelse>
				<input type="button" class="btn" onclick="submitForm(document.forms.form1,'delete','#jsStringformat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteadzoneconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" />
				<input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.update')#" />
				<input type="hidden" name="adZoneID" value="#rc.adZoneBean.getAdZoneID()#">
			</cfif>
			<input type="hidden" name="action" value="add">
		</div>
<cfif rc.adZoneID neq ''>
	</div>
</div>
</cfif>
</form>
</cfoutput>

