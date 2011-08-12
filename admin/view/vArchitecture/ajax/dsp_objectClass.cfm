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
<cfparam name="attributes.contentid" default="">
<cfparam name="attributes.parentid" default="">
<cfswitch expression="#attributes.classid#">
<cfcase value="component">
<cfoutput>
<cfset request.rsUserDefinedTemplates=application.contentManager.getComponents("00000000000000000000000000000000000",attributes.siteid) />
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsUserDefinedTemplates">
	<option value="Component~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.component')# - #request.rsUserDefinedTemplates.menutitle#~#request.rsUserDefinedTemplates.contentid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.component')# - #request.rsUserDefinedTemplates.menutitle#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="mailingList">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rsmailinglists=application.contentUtility.getMailingLists(attributes.siteid) />
<option value="mailing_list_master~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mastermailinglistsignupform')#~none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mastermailinglistsignupform')#</option>
<cfloop query="request.rsmailinglists">
	<option value="mailing_list~Mailing List - #request.rsmailinglists.name#~#request.rsmailinglists.mlid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mailinglist')# - #request.rsmailinglists.name#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="system">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rsObjects=application.contentManager.getSystemObjects(attributes.siteid) />
<cfloop query="request.rsObjects">
	<!---<option value="#request.rsobjects.object#~#request.rsObjects.name#~none">#request.rsObjects.name#</option>--->
	<option value='{"object":"#JSStringFormat(request.rsobjects.object)#","name":"#JSStringFormat(request.rsObjects.name)#","objectid":"none"}'>#request.rsObjects.name#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="form">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rsForms=application.contentManager.getComponentType(attributes.siteid,'Form') />
<cfloop query="request.rsForms">
	<option value="form~#iif(request.rsForms.responseChart eq 1,de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.poll')#'),de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.datacollector')#'))# - #request.rsForms.menutitle#~#request.rsForms.contentid#">#iif(request.rsForms.responseChart eq 1,de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.poll')#'),de('#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.datacollector')#'))# - #request.rsForms.menutitle#</option>
	<cfif request.rsForms.responseChart neq 1><option value="form_responses~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.dataresponses')# - #request.rsForms.menutitle#~#request.rsForms.contentid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.dataresponses')# - #request.rsForms.menutitle#</option></cfif>
</cfloop>
</select>
</cfoutput>
</cfcase>
<cfcase value="adzone">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rsAdZones=application.advertiserManager.getadzonesBySiteID(attributes.siteid,'') />
<cfloop query="request.rsAdZones">
	<option value="adZone~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adzone')# - #request.rsAdZones.name#~#request.rsAdZones.adZoneID#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adzone')# - #request.rsAdZones.name#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>
<!--- <cfcase value="category">
<cfset request.rsSections=application.contentManager.getSections(attributes.siteid) />
<cfset request.rsCategories=application.categoryManager.getCategoriesBySiteID(attributes.siteid,'') />
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','category',this.value);" class="dropdown">
<option value="" <cfif attributes.subclassid eq ''>selected</cfif>>Across All Site Sections</option> 
<cfloop query="request.rsSections">
	<cfif attributes.subclassid eq request.rsSections.contentID>
	<cfset selected ='selected'>
	<cfset currentSection = request.rsSections.currentRow />
	<cfelse>
	<cfset selected =''>
	</cfif>
	<option value="#request.rsSections.contentid#" #selected#>#HTMLEditFormat(request.rsSections.menutitle)# - #request.rsSections.type#</option> 
	
	</cfloop>
</select><br/>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsCategories">
	<cfif attributes.subclassid eq ''>
	<option value="category_features~Featured #request.rsCategories.name# Category Content [Summaries]~#request.rsCategories.categoryid#">Featured #request.rsCategories.name# Category Content [Summaries]</option>
	<option value="category_features_no_summary~Featured #request.rsCategories.name# Category Content~#request.rsCategories.categoryid#">Featured #request.rsCategories.name# Category Content </option>
	<cfelse>
	<option value="category_portal_features~#request.rsCategories.name# - #HTMLEditFormat(request.rsSections.menutitle)[currentSection]# #request.rsSections.type[currentSection]# [Summaries]~#request.rsCategories.categoryid#,#request.rsSections.contentid[currentSection]#">#request.rsCategories.name# - #HTMLEditFormat(request.rsSections.menutitle)[currentSection]# #request.rsSections.type[currentSection]# [Summaries]</option>
	<option value="category_portal_features_no_summary~#request.rsCategories.name# - #HTMLEditFormat(request.rsSections.menutitle)[currentSection]# #request.rsSections.type[currentSection]# Portal~#request.rsCategories.categoryid#,#request.rsSections.contentid[currentSection]#">#request.rsCategories.name# - #HTMLEditFormat(request.rsSections.menutitle)[currentSection]# #request.rsSections.type[currentSection]#</option>			
	</cfif>
</cfloop>
</select>
</cfcase> --->
<cfcase value="portal">
<cfset request.rsSections=application.contentManager.getSections(attributes.siteid,'Portal') />
<cfoutput>
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','portal',this.value,'#attributes.contentid#','#attributes.parentid#');" class="dropdown">
<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectportal')#</option>
<cfloop query="request.rsSections">
<option value="#request.rsSections.contentID#" <cfif request.rsSections.contentID eq attributes.subclassid>selected</cfif>>#HTMLEditFormat(request.rsSections.menutitle)#</option>
</cfloop>
</select><br/>

<cfif attributes.subclassid neq ''>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsSections">
	<cfif request.rsSections.contentID eq attributes.subclassid>
	<!--- <option value="features~Featured #HTMLEditFormat(request.rsSections.menutitle)# Content [Summaries]~#request.rsSections.contentid#">Featured #HTMLEditFormat(request.rsSections.menutitle)# Content [Summaries]</option>
	<option value="features_no_summary~Featured #HTMLEditFormat(request.rsSections.menutitle)# Content~#request.rsSections.contentid#">Featured #HTMLEditFormat(request.rsSections.menutitle)# Content</option> --->
	<option value="category_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#</option>
	<option value="category_summary_rss~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')# [RSS]~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#</option>
	<option value="related_section_content~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#</option>
	<option value="related_section_content_no_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#</option>
	<option value="calendar_nav~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#</option>
	<option value="archive_nav~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.archivenavigation')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.archivenavigation')#</option>
	</cfif>
</cfloop>
</select>
</cfif>
</cfoutput>
</cfcase>
<cfcase value="calendar">

<cfset request.rsSections=application.contentManager.getSections(attributes.siteid,'Calendar') />
<cfoutput>
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','calendar',this.value,'#attributes.contentid#','#attributes.parentid#');" class="dropdown">
<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectcalendar')#</option>
<cfloop query="request.rsSections">
<option value="#request.rsSections.contentID#" <cfif request.rsSections.contentID eq attributes.subclassid>selected</cfif>>#HTMLEditFormat(request.rsSections.menutitle)#</option>
</cfloop>
</select><br/>

<cfif attributes.subclassid neq ''>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsSections">
	<cfif request.rsSections.contentID eq attributes.subclassid>
	<option value="features~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.featuredcontentsummaries')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.featuredcontentsummaries')#</option>
	<option value="features_no_summary~#HTMLEditFormat(request.rsSections.menutitle)# #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.featuredcontent')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.featuredcontent')#</option>
	<option value="category_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#</option>
	<option value="category_summary_rss~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#</option>
	<option value="related_section_content~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#</option>
	<option value="related_section_content_no_summary~#HTMLEditFormat(request.rsSections.menutitle)# #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#</option>
	<option value="calendar_nav~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#</option>
	</cfif>
</cfloop>
</select>
</cfif>

</cfoutput>
</cfcase>
<cfcase value="gallery">

<cfset request.rsSections=application.contentManager.getSections(attributes.siteid,'Gallery') />
<cfoutput>
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','gallery',this.value,'#attributes.contentid#','#attributes.parentid#');" class="dropdown">
<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectgallery')#</option>
<cfloop query="request.rsSections">
<option value="#request.rsSections.contentID#" <cfif request.rsSections.contentID eq attributes.subclassid>selected</cfif>>#HTMLEditFormat(request.rsSections.menutitle)#</option>
</cfloop>
</select><br/>

<cfif attributes.subclassid neq ''>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfloop query="request.rsSections">
	<cfif request.rsSections.contentID eq attributes.subclassid>
	<!--- <option value="features~Featured #HTMLEditFormat(request.rsSections.menutitle)# Content [Summaries]~#request.rsSections.contentid#">Featured #HTMLEditFormat(request.rsSections.menutitle)# Content [Summaries]</option>
	<option value="features_no_summary~Featured #HTMLEditFormat(request.rsSections.menutitle)# Content~#request.rsSections.contentid#">Featured #HTMLEditFormat(request.rsSections.menutitle)# Content</option> --->
	<option value="category_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')# Summary~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummary')#</option>
	<option value="category_summary_rss~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.categorysummaryrss')#</option>
	<option value="related_section_content~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontentsummaries')#</option>
	<option value="related_section_content_no_summary~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#</option>
	<option value="calendar_nav~#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#~#request.rsSections.contentid#">#HTMLEditFormat(request.rsSections.menutitle)# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendarnavigation')#</option>
	</cfif>
</cfloop>
</select>
</cfif>
</cfoutput>
</cfcase>

<cfcase value="localFeed">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rslist=application.feedManager.getFeeds(attributes.siteid,'Local') />
<option value="feed_table~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexlistingtable')#~none">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexlistingtable')#</option>
<cfloop query="request.rslist">
	<option value="feed~#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexsummaries')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexsummaries')#</option>
	<option value="feed_no_summary~#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindex')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindex')#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>

<cfcase value="slideshow">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rslist=application.feedManager.getFeeds(attributes.siteid,'Local') />
<cfloop query="request.rslist">
	<option value="feed_slideshow~#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshowsummaries')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshowsummaries')#</option>
	<option value="feed_slideshow_no_summary~#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshow')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshow')#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>

<cfcase value="remoteFeed">
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
<cfset request.rslist=application.feedManager.getFeeds(attributes.siteid,'Remote') />
<cfloop query="request.rslist">
	<option value="feed~#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeedsummaries')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeedsummaries')#</option>
	<option value="feed_no_summary~#request.rslist.name# #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeed')#~#request.rslist.feedID#">#request.rslist.name# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeed')#</option>
</cfloop>
</select>
</cfoutput>
</cfcase>

<cfcase value="plugins">
<cfif listLen(attributes.subclassid) gt 1>
	<cfset attributes.objectid=listLast(attributes.subclassid)>
	<cfset attributes.subclassid=listFirst(attributes.subclassid)>
</cfif>
<cfset request.rsPlugins=application.pluginManager.getDisplayObjectBySiteID(siteID=attributes.siteid,modulesOnly=true) />
<cfoutput>
<select name="subClassSelector" onchange="loadObjectClass('#attributes.siteid#','plugins',this.value,'#attributes.contentid#','#attributes.parentid#');" class="dropdown">
<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectplugin')#</option>
<cfloop query="request.rsPlugins">
<cfif application.permUtility.getModulePerm(request.rsPlugins.moduleID,attributes.siteid)>
<option value="#request.rsPlugins.moduleID#" <cfif request.rsPlugins.moduleID eq attributes.subclassid>selected</cfif>>#HTMLEditFormat(request.rsPlugins.title)#</option>
</cfif>
</cfloop>
</select><br/>
</cfoutput>

<cfif len(attributes.subclassid)>

<cfset prelist=application.pluginManager.getDisplayObjectBySiteID(siteID=attributes.siteid,moduleID=attributes.subclassid) />
<cfset customOutputList="">
<cfset customOutput="">
<cfset customOutput1="">
<cfset customOutput2="">
<cfloop query="prelist">
<cfif listLast(prelist.displayObjectFile,".") neq "cfm">
	<cfset displayObject=application.pluginManager.getComponent("plugins.#prelist.directory#.#prelist.displayobjectfile#", prelist.pluginID, attributes.siteID, prelist.docache)>
	<cfif structKeyExists(displayObject,"#prelist.displayMethod#OptionsRender")>
		<cfset customOutputList=listAppend(customOutputList,prelist.objectID)>
		<cfif attributes.objectID eq prelist.objectID>
			<cfset event=createObject("component","mura.event").init(attributes)>
			<cfset muraScope=event.getValue("muraScope")>
			<cfsavecontent variable="customOutput1">
			<cfinvoke component="#displayObject#" method="#prelist.displaymethod#OptionsRender" returnvariable="customOutput2">
				<cfinvokeargument name="event" value="#event#">
				<cfinvokeargument name="$" value="#muraScope#">
				<cfinvokeargument name="mura" value="#muraScope#">
			</cfinvoke>
			</cfsavecontent>
			<cfif isdefined("customOutput2")>
				<cfset customOutput=trim(customOutput2)>
			<cfelse>
				<cfset customOutput=trim(customOutput1)>
			</cfif>		
			<!---<cfset customOutput=evaluate("displayObject.#prelist.displayMethod#OptionsRender(event)")>--->
		</cfif>
	</cfif>
</cfif>
</cfloop>

<cfif len(customOutputList)>
<cfquery name="rs" dbType="query">
select * from prelist where
objectID in (''
	<cfloop list="#customOutputList#" index="i">
	,'#i#'
	</cfloop>
	)
</cfquery>
<cfoutput>
<select name="customObjectSelector" onchange="loadObjectClass('#attributes.siteid#','plugins',this.value,'#attributes.contentid#','#attributes.parentid#');" class="dropdown">
<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectplugindisplayobjectclass')#</option>
<cfloop query="rs">
<cfif application.permUtility.getModulePerm(request.rsPlugins.moduleID,attributes.siteid)>
<option value="#rs.moduleID#,#rs.objectID#" <cfif rs.objectID eq attributes.objectID>selected</cfif>>#HTMLEditFormat(rs.name)#</option>
</cfif>
</cfloop>
</select><br/>
</cfoutput>
</cfif>
<cfif not len(customOutput)>
<cfquery name="rs" dbType="query">
select * from prelist where
objectID not in (''
	<cfloop list="#customOutputList#" index="i">
	,'#i#'
	</cfloop>
	)
</cfquery>
<cfif rs.recordcount>
<cfoutput>
<select name="availableObjects" id="availableObjects" class="multiSelect" size="#evaluate((application.settingsManager.getSite(attributes.siteid).getcolumnCount() * 6)-4)#" style="width:310px;">
</cfoutput>
<cfoutput query="rs">
	<option value="plugin~#rs.title# - #rs.name#~#rs.objectID#">#rs.name#</option>
</cfoutput>
<cfoutput></select></cfoutput>
</cfif>
<cfelse>
<cfoutput>#customOutput#</cfoutput>
</cfif>
</cfif>
</cfcase>

</cfswitch>

<cfif fileExists("#application.configBean.getWebRoot()##application.configBean.getFileDelim()##attributes.siteid##application.configBean.getFileDelim()#includes#application.configBean.getFileDelim()#display_objects#application.configBean.getFileDelim()#custom#application.configBean.getFileDelim()#admin#application.configBean.getFileDelim()#dsp_objectClass.cfm")> 
	<cfinclude template="/#application.configBean.getWebRootMap()#/#attributes.siteID#/includes/display_objects/custom/admin/dsp_objectClass.cfm" >
</cfif>