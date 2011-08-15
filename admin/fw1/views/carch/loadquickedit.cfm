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
<cfset request.layout=false>
<cfset $=application.serviceFactory.getBean("MuraScope").init(session.siteID)>
<cfset content=$.getBean("content").loadBy(contentID=rc.contentID)>
<cfif not content.hasDrafts()>
<cfoutput>
<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.quickedit.edit#rc.attribute#')# <span onclick="jQuery('.mura-quickEdit').remove();">[Cancel]</span></a></h1>

<cfif rc.attribute eq "isnav">
<select id="mura-quickEdit-isnav">
	 <option value="1"<cfif content.getIsNav()> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.true')#</option>
	 <option value="0"<cfif not content.getIsNav()> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.false')#</option>
</select>
<cfelseif rc.attribute eq "inheritObjects">
<select id="mura-quickEdit-inheritobjects">
	<option value="Inherit"<cfif content.getInheritObjects() eq "Inherit"> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritcascade')#</option>
	<option value="Cascade"<cfif content.getInheritObjects() eq "Cascade"> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startnewcascade')#</option>
	<option value="Reject"<cfif content.getInheritObjects() eq "Reject"> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.donotinheritcascade')#</option>
</select>
<cfelseif rc.attribute eq "template">
<cfset rsTemplates=application.contentUtility.getTemplates(rc.siteid,content.getType()) />
<select id="mura-quickEdit-template">
	<cfif rc.contentid neq '00000000000000000000000000000000001'>
		<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritfromparent')#</option>
	</cfif>
	<cfloop query="rsTemplates">
	<cfif right(rsTemplates.name,4) eq ".cfm">
		<cfoutput>
		<option value="#rsTemplates.name#" <cfif content.gettemplate() eq rsTemplates.name>selected</cfif>>#rsTemplates.name#</option>
		</cfoutput>
	</cfif>
	</cfloop>
</select>
</cfif>
<input type="button" name="submit" value="Submit" class="submit" onclick="saveQuickEdit(this);" />
</cfoutput>
<cfelse>
<h1><span onclick="jQuery('.mura-quickEdit').remove();">[Cancel]</span></a></h1>
	<p></p>
</div>
</cfif>

