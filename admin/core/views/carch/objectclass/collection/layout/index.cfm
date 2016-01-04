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
<cfsilent>
<cfparam name="objectParams.maxitems" default="4">
<cfparam name="objectParams.displaylist" default="Image,Date,Title,Summary,Credits,Tags">
<cfset feed=rc.$.getBean("feed").loadBy(feedID=objectParams.source)>
<cfset feed.set(objectParams)>
<cfparam name="objectParams.sourcetype" default="local">
</cfsilent>
<cfoutput>
	<cfif objectParams.sourcetype neq "remotefeed">		
		<div class="control-group">
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'collections.layout')#
			</label>
			<div class="controls">
				<cfset layouts=rc.$.siteConfig().getLayouts('collection/layouts')>
				<cfset layout=feed.getLayout()>
				<cfset layout=(len(layout)) ? layout :' default'>
				<select name="layout" class="objectParam span12">
					<option value="default"<cfif feed.getLayout() eq "default"> selected</cfif>>default</option>
					<cfloop query="layouts">
						<cfif layouts.name neq 'default'>
						<option value="#layouts.name#"<cfif feed.getLayout() eq layouts.name> selected</cfif>>#layouts.name#</option>
						</cfif>
					</cfloop>
				</select>
			</div>
		</div>

		<!---- Begin layout based configuration --->
		<cfset configFile=rc.$.siteConfig('themeIncludePath') & "/display_objects/collection/layouts/#layout#/configurator.cfm">
		<cfif fileExists(expandPath(configFile))>
			<cfinclude template="#configFile#">
		<cfelse>
			<cfset configFile=rc.$.siteConfig('includePath') & "/includes/display_objects/custom/collection/layouts/#layout#/configurator.cfm">
			<cfif fileExists(expandPath(configFile))>
				<cfinclude template="#configFile#">
			<cfelse>
				<cfset configFile=rc.$.siteConfig('includePath') & "/includes/display_objects/collection/layouts/#layout#/configurator.cfm">
				<cfif fileExists(expandPath(configFile))>
					<cfinclude template="#configFile#">
				</cfif>
			</cfif>
		</cfif>
		<script>
			$('select[name="layout"]').on('change',setLayoutOptions);
		</script>
		<!---  End layout based configuration --->

		<cfif objectParams.object eq 'collection'>
			<div class="control-group">
				<div class="span12">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'collections.viewalllink')#
					</label>
					<div class="controls">
						<input name="viewalllink" class="objectParam span12" type="text" value="#esapiEncode('html_attr',feed.getViewAllLink())#" maxlength="255">
					</div>
				</div>
			</div>
			<div class="control-group">
				<div class="span12">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'collections.viewalllabel')#
					</label>
					<div class="controls">
						<input name="viewalllabel" class="objectParam span12" type="text" value="#esapiEncode('html_attr',feed.getViewAllLabel())#" maxlength="100">
					</div>
				</div>
			</div>
		</cfif>
		<cfif objectParams.object eq 'collection'>
			<div class="control-group">
				<div class="span6">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</label>
					<div class="controls">
						<select name="maxItems" data-displayobjectparam="maxItems" class="objectParam span12">
						<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
						<option value="#m#" <cfif feed.getMaxItems() eq m>selected</cfif>>#m#</option>
						</cfloop>
						<option value="100000" <cfif feed.getMaxItems() eq 100000>selected</cfif>>All</option>
						</select>
					</div>
				</div>
				<div class="span6">
				      <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</label>
						<div class="controls"><select name="nextN" data-displayobjectparam="nextN" class="objectParam span12">
						<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
						<option value="#r#" <cfif r eq feed.getNextN()>selected</cfif>>#r#</option>
						</cfloop>
						<option value="100000" <cfif feed.getNextN() eq 100000>selected</cfif>>All</option>
						</select>
					  </div>
				</div>
			</div>
		</cfif>
	<cfelse>
		<cfset displaySummaries=yesNoFormat(feed.getValue("displaySummaries"))>
		<div class="control-group">
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'collections.displaysummaries')#
			</label>
			<div class="controls">
				<label class="radio inline">
					<input name="displaySummaries" type="radio" value="1" class="objectParam radio" onchange="jQuery('##altNameContainer').toggle();"<cfif displaySummaries>checked</cfif>>
					#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				</label>
				<label class="radio inline">
					<input name="displaySummaries" type="radio" value="0" class="objectParam radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not displaySummaries>checked</cfif>>
					#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</label>
			</div>
		</div>
		<div class="control-group">
			<div class="span12">
				<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'collections.viewalllink')#
				</label>
				<div class="controls">
					<input name="viewalllink" class="objectParam span12" type="text" value="#esapiEncode('html_attr',feed.getViewAllLink())#" maxlength="255">
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="span12">
				<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'collections.viewalllabel')#
				</label>
				<div class="controls">
					<input name="viewalllabel" class="objectParam span12" type="text" value="#esapiEncode('html_attr',feed.getViewAllLabel())#" maxlength="100">
				</div>
			</div>
		</div>
</cfif>
</cfoutput>
