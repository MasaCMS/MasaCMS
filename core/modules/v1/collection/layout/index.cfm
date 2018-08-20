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
<cfparam name="objectParams.maxitems" default="4">
<cfparam name="objectParams.source" default="">
<cfparam name="objectParams.layout" default="default">
<cfparam name="objectParams.forcelayout" default="false">
<cfparam name="objectParams.sortby" default="Title">
<cfparam name="objectParams.sortdirection" default="ASC">
<cfparam name="objectParams.object" default="">
<cfparam name="objectParams.displaylist" default="Image,Date,Title,Summary,Credits,Tags">
<cfset feed=rc.$.getBean("feed").loadBy(feedID=objectParams.source)>
<cfset feed.set(objectParams)>
<cfparam name="objectParams.sourcetype" default="local">

</cfsilent>
<cfoutput>
	<cfif objectParams.sourcetype neq "remotefeed">
		<cfif not objectParams.forcelayout>
		<div class="mura-control-group">
			<label class="mura-control-label">
				#application.rbFactory.getKeyValue(session.rb,'collections.layout')#
			</label>
			<cfset layouts=rc.$.siteConfig().getLayouts('collection/layouts')>
			<cfset layout=feed.getLayout()>
			<cfset layout=(len(layout)) ? layout :' default'>
			<select name="layout" class="objectParam">
				<option value="default"<cfif feed.getLayout() eq "default"> selected</cfif>>Default</option>
				<cfloop query="layouts">
					<cfif layouts.name neq 'default'>
					<option value="#layouts.name#"<cfif feed.getLayout() eq layouts.name> selected</cfif>>#reReplace(layouts.name, "\b([a-zA-Z])(\w{2,})\b", "\U\1\E\2", "all")#</option>
					</cfif>
				</cfloop>
			</select>
		</div>
		<cfelse>
			<cfset layout=feed.getLayout()>
			<cfset layout=(len(layout)) ? layout :' default'>
			<input type="hidden" name="layout" class="objectParam" value="#esapiEncode('html_attr',layout)#">
		</cfif>

		<!---- Begin layout based configuration --->
		<cfset configFile=rc.$.siteConfig().lookupDisplayObjectFilePath('collection/layouts/#layout#/configurator.cfm')>
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
			<div class="mura-control-group container-viewalllink">
				<label class="mura-control-label">
					#application.rbFactory.getKeyValue(session.rb,'collections.viewalllink')#
				</label>
				<input name="viewalllink" class="objectParam" type="text" value="#esapiEncode('html_attr',feed.getViewAllLink())#" maxlength="255">
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label container-viewalllabel">
					#application.rbFactory.getKeyValue(session.rb,'collections.viewalllabel')#
				</label>
				<input name="viewalllabel" class="objectParam" type="text" value="#esapiEncode('html_attr',feed.getViewAllLabel())#" maxlength="100">
			</div>
			<div class="mura-control-group">
				<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</label>
				<select name="maxItems" data-displayobjectparam="maxItems" class="objectParam">
					<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
					<option value="#m#" <cfif feed.getMaxItems() eq m>selected</cfif>>#m#</option>
					</cfloop>
					<option value="100000" <cfif feed.getMaxItems() eq 100000>selected</cfif>>All</option>
				</select>
			</div>
			<div class="mura-control-group container-nextn">
			    <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</label>
				<select name="nextN" data-displayobjectparam="nextN" class="objectParam">
					<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
					<option value="#r#" <cfif r eq feed.getNextN()>selected</cfif>>#r#</option>
					</cfloop>
					<option value="100000" <cfif feed.getNextN() eq 100000>selected</cfif>>All</option>
				</select>
			</div>
			<cfif objectparams.sourcetype eq "relatedcontent" and objectparams.source eq 'reverse'>
				<div class="mura-control-group">
					<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.sortby')#</label>
					<select name="sortby" class="objectParam">
					<option value="orderno" <cfif objectparams.sortby eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.manual")#</option>
					<option value="releaseDate" <cfif objectparams.sortby eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.releasedate")#</option>
					<option value="lastUpdate" <cfif objectparams.sortby eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.updatedate")#</option>
					<option value="created" <cfif objectparams.sortby eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.created")#</option>
					<option value="menuTitle" <cfif objectparams.sortby eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.menutitle")#</option>
					<option value="title" <cfif objectparams.sortby eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.longtitle")#</option>
					<option value="rating" <cfif objectparams.sortby eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.rating")#</option>
					<cfif rc.$.getServiceFactory().containsBean('marketingManager')>
						<option value="mxpRelevance" <cfif objectparams.sortby eq 'mxpRelevance'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.mxpRelevance')#</option>
					</cfif>
					<option value="comments" <cfif objectparams.sortby eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.comments")#</option>
					<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(rc.siteid)>
					<cfloop query="rsExtend">
					  <option value="#esapiEncode('html_attr',rsExtend.attribute)#" <cfif objectparams.sortby eq rsExtend.attribute>selected</cfif>>#esapiEncode('html',rsExtend.Type)#/#esapiEncode('html',rsExtend.subType)# - #esapiEncode('html',rsExtend.attribute)#</option>
					</cfloop>
					</select>
				</div>
				<div class="mura-control-group sort-container" style="display:none">
					<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.sortdirection')#</label>
					<select name="sortdirection" class="sort-param">
						<option value="asc" <cfif objectparams.sortDirection eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.ascending")#</option>
						<option value="desc" <cfif objectparams.sortDirection  eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.descending")#</option>
					</select>
				</div>
			</cfif>
		</cfif>
	<cfelse>
		<!--- REMOTE FEEDS --->
		<cfset displaySummaries=yesNoFormat(feed.getValue("displaySummaries"))>
		<div class="mura-control-group">
			<label class="mura-control-label">
				#application.rbFactory.getKeyValue(session.rb,'collections.displaysummaries')#
			</label>
			<label class="radio inline">
				<input name="displaySummaries" type="radio" value="1" class="objectParam radio" onchange="jQuery('##altNameContainer').toggle();"<cfif displaySummaries>checked</cfif>>
				#application.rbFactory.getKeyValue(session.rb,'collections.yes')#
			</label>
			<label class="radio inline">
				<input name="displaySummaries" type="radio" value="0" class="objectParam radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not displaySummaries>checked</cfif>>
				#application.rbFactory.getKeyValue(session.rb,'collections.no')#
			</label>
		</div>
		<div class="mura-control-group">
			<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</label>
			<select name="maxItems" data-displayobjectparam="maxItems" class="objectParam">
				<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
				<option value="#m#" <cfif feed.getMaxItems() eq m>selected</cfif>>#m#</option>
				</cfloop>
				<option value="100000" <cfif feed.getMaxItems() eq 100000>selected</cfif>>All</option>
			</select>
		</div>
		<div class="mura-control-group">
				<label class="mura-control-label">
					#application.rbFactory.getKeyValue(session.rb,'collections.viewalllink')#
				</label>
				<input name="viewalllink" class="objectParam" type="text" value="#esapiEncode('html_attr',feed.getViewAllLink())#" maxlength="255">
			</div>
		</div>
		<div class="mura-control-group">
			<label class="mura-control-label">
				#application.rbFactory.getKeyValue(session.rb,'collections.viewalllabel')#
			</label>
			<input name="viewalllabel" class="objectParam" type="text" value="#esapiEncode('html_attr',feed.getViewAllLabel())#" maxlength="100">
		</div>
</cfif>
</cfoutput>
