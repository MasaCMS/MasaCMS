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
<cfsilent>
	<cfset rc.rsObjects = application.contentManager.getSystemObjects(rc.siteid)/>
	<cfquery name="rc.rsObjects" dbtype="query">
		select * from rc.rsObjects where object like '%nav%'
	</cfquery>
	<cfset content=rc.$.getBean("content").loadBy(contentID=rc.objectid)>
	<cfparam name="objectParams.taggroup" default="">
</cfsilent>
<cf_objectconfigurator>
<cfoutput>
	<div class="mura-layout-row">
		<div class="mura-control-group">
			<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.selectnavigation')#</label>
			<select id="objectselector" name="object" class="objectParam">
				<option value="">
					#application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.selectnavigation')#
				</option>
				<cfloop query="rc.rsObjects">
					<option <cfif rc.object eq rc.rsobjects.object>selected </cfif>title="#esapiEncode('html_attr',rc.rsObjects.name)#" value="#esapiEncode('javascript',rc.rsobjects.object)#">
						#esapiEncode('html',rc.rsObjects.name)#
					</option>
				</cfloop>
				<option <cfif rc.object eq 'archive_nav'>selected </cfif>title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.archivenavigation'))#" value="archive_nav">
					#esapiEncode('html',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.archivenavigation'))#
				</option>
				<option <cfif rc.object eq 'category_summary'>selected </cfif>title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.categorysummary'))#" value="category_summary">
					#esapiEncode('html',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.categorysummary'))#
				</option>
				<option <cfif rc.object eq 'calendar_nav'>selected </cfif>title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.calendarnavigation'))#" value="calendar_nav">
					#esapiEncode('html',application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.calendarnavigation'))#
				</option>
				<option <cfif rc.object eq 'tag_cloud'>selected </cfif>title="Tag Cloud" value="tag_cloud">
					#application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.tagcloud')#
				</option>
			</select>
		</div>
	</div>
	<div class="mura-layout-row" id="taggroupcontainer" style="display:none">
		<div class="mura-control-group">
			<label class="mura-control-label">
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selecttaggroup')#
			</label>
			<select name="taggroup" class="objectParam">
				<option value="">Default</option>
				<cfif len(rc.$.siteConfig('customTagGroups'))>
					<cfloop list="#rc.$.siteConfig('customTagGroups')#" index="g" delimiters="^,">
						<option value="#g#" <cfif g eq objectParams.taggroup>selected</cfif>>#g#</option>
					</cfloop>
				</cfif>
			</select>
		</div>
	</div>
	<input name="objectid" type="hidden" class="objectParam" value="#esapiEncode('html_attr',rc.contentid)#">
	<script>
		$(function(){
			function toggleTagGroups(){
				if($('##objectselector').val() == 'tag_cloud'){
					$('##taggroupcontainer').show();
				} else {
					$('##taggroupcontainer').hide();
				}
			}

			toggleTagGroups();
			$('##objectselector').change(toggleTagGroups);

		});
	</script>
</cfoutput>
</cf_objectconfigurator>
