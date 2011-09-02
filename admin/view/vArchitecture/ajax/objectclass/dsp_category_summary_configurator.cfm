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

<cfset $=application.serviceFactory.getBean("muraScope").init(attributes.siteID)>
<cfset content=$.getBean("content").loadBy(contentID=attributes.objectid)>

<cfif isDefined("form.params") and isJSON(form.params)>
	<cfset params=deserializeJSON(form.params)>
	<cfset displayRSS=isDefined("params.displayRSS") and yesNoFormat(params.displayRSS)>	
	
<cfelse>
	<cfset displayRSS=false>	
</cfif>

<cfoutput>

	<div id="availableObjectParams"<!--- style="display:none;"--->>
		<dl class="oneColumn">
			<dt class="first">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displayrss')#</dt>
			<dd>
			<input name="displayRSS" data-displayobjectparam="displayRSS" type="radio" value="1" class="radio" <cfif displayRSS>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
			<input name="displayRSS" data-displayobjectparam="displayRSS" type="radio" value="0" class="radio" <cfif not displayRSS>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
			</dd>
		</dl>
	</div>
	<input type="hidden" name="displayObjectTemplate" id="displayObjectTemplate" value="{'object':'category_summary','name':'#JSStringFormat('#content.getMenuTitle()# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#')#','objectid':'#content.getContentID()#'}"/>
</cfoutput>

