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
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.editadzone')#</h2>
#application.utility.displayErrors(request.adZoneBean.getErrors())#

<form novalidate="novalidate" name="form1" method="post" action="index.cfm?fuseaction=cAdvertising.updateAdZone&siteid=#URLEncodedFormat(attributes.siteid)#" onsubmit="return false;">
<dl class="oneColumn separate">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'advertising.name')#</dt>
<dd><input name="name" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.namerequired')#" value="#HTMLEditFormat(request.adZoneBean.getName())#" maxlength="50"><dd>
<cfif attributes.adZoneID neq ''>
</dl>
<div class="divide"></div>
<div class="tabs initActiveTab" style="display:none">
<ul>

<li><a href="##tabBasic" onclick="return false;"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.basic')#</span></a></li>
<li><a href="##tabUsagereport" onclick="return false;"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.usagereport')#</span></a></li>
</ul>

<div id="tabBasic">
<dl class="oneColumn">
<dt class="first">
<cfelse>
<dt>
</cfif>
#application.rbFactory.getKeyValue(session.rb,'advertising.assettype')#</dt>
<dd><select name="creativeType">
<cfloop list="#application.advertiserManager.getCreativeTypes()#" index="ct">
<option value="#ct#" <cfif request.adZoneBean.getCreativeType() eq ct>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'advertising.creativetype.#ct#')#</option>
</cfloop>
</select></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.height')#</dt>
<dd><input name="height" validate="numeric" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.heightvalidate')#" value="#request.adZoneBean.getHeight()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.width')#</dt>
<dd><input name="width" validate="numeric" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'advertising.widthvalidate')#" value="#request.adZoneBean.getWidth()#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.isactive')#</dt>
<dd>
<input name="isActive" id="isActiveYes" type="radio" value="1" <cfif request.adZoneBean.getIsActive()>checked</cfif>> <label for="isActiveYes">#application.rbFactory.getKeyValue(session.rb,'advertising.yes')#</label> 
<input name="isActive" id="isActiveNo" type="radio" value="0" <cfif not request.adZoneBean.getIsActive()>checked</cfif>> <label for="isActiveNo">#application.rbFactory.getKeyValue(session.rb,'advertising.no')#</label>
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'advertising.notes')#</dt>
<dd><textarea name="notes" class="textArea">#HTMLEditFormat(request.adZoneBean.getNotes())#</textarea></dd>
</dl>
<div id="actionButtons">
<cfif attributes.adZoneid eq ''>
<input type="button" class="submit" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.add')#" /><input type=hidden name="adZoneID" value="">
<cfelse><input type="button" class="submit" onclick="submitForm(document.forms.form1,'delete','#jsStringformat(application.rbFactory.getKeyValue(session.rb,'advertising.deleteadzoneconfirm'))#');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.delete')#" />
<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'advertising.update')#" />
</div>
<input type=hidden name="adZoneID" value="#request.adZoneBean.getAdZoneID()#"></cfif><input type="hidden" name="action" value="add"></form>
</cfoutput>
<cfif attributes.adZoneID neq ''>
</div>
<cfinclude template="dsp_tab_usage.cfm">
</div>
</cfif>