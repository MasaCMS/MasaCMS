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

<cfset $=application.serviceFactory.getBean("muraScope").init(attributes.siteID)>
<cfset feed=$.getBean("feed").loadBy(feedID=attributes.feedID)>

<cfif isDefined("form.params") and isJSON(form.params)>
	<cfset feed.set(deserializeJSON(form.params))>
</cfif>

<cfset data=structNew()>
<cfsavecontent variable="data.html">
<cfoutput>
	
	<cfif feed.getType() eq "local">
	<div id="availableObjectParams"
	data-object="feed" 
	data-name="#HTMLEditFormat('#feed.getName()# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindex')#')#" 
	data-objectid="#feed.getFeedID()#">
	<cfelse>
	<div id="availableObjectParams"
	data-object="feed" 
	data-name="#HTMLEditFormat('#feed.getName()# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeed')#')#" 
	data-objectid="#feed.getFeedID()#">	
	</cfif>
	
			<h4>#HTMLEditFormat(feed.getName())#</h4>
			<cfif attributes.configuratorMode eq "frontEnd"
				and application.permUtility.getDisplayObjectPerm(feed.getSiteID(),"feed",feed.getFeedD()) eq "editor">
			<cfsilent>
				<cfset editlink = "?fuseaction=cFeed.edit">
				<cfset editlink = editlink & "&amp;siteid=" & feed.getSiteID()>
				<cfset editlink = editlink & "&amp;feedid=" & feed.getFeedID()>
				<cfset editlink = editlink & "&amp;type=" & feed.getType()>
				<cfset editlink = editlink & "&amp;homeID=" & attributes.homeID>
				<cfset editlink = editlink & "&amp;compactDisplay=true">
			</cfsilent>
			<ul id="navTask">
				<li><a href="#editlink#">#application.rbFactory.getKeyValue(session.rb,'collections.editdefaultsettings')#</a></li>
			</ul>
			</cfif>
			<cfif feed.getType() eq "local">		
				<dl class="oneColumn" id="configurator">
					<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</dt>
					<dd><select name="imageSize" class="objectParam  dropdown" onchange="if(this.value=='custom'){jQuery('##feedCustomImageOptions').fadeIn('fast')}else{jQuery('##feedCustomImageOptions').hide();jQuery('##feedCustomImageOptions').find(':input').val('AUTO');}">
						<cfloop list="Small,Medium,Large,Custom" index="i">
							<option value="#lcase(i)#"<cfif i eq feed.getImageSize()> selected</cfif>>#I#</option>
						</cfloop>
						</select>
					</dd>
					<dd id="feedCustomImageOptions"<cfif feed.getImageSize() neq "custom"> style="display:none"</cfif>>
						<dl>
							<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</dt>
							<dd><input name="imageWidth" class="objectParam  text" value="#feed.getImageWidth()#" /></dd>
							<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</dt>
							<dd><input name="imageHeight" class="objectParam  text" value="#feed.getImageHeight()#" /></dd>
						</dl>
					</dd>
				
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displayname')#</dt>
				<dd>
				<input name="displayName" type="radio" value="1" class="objectParam  radio" onchange="jQuery('##altNameContainer').toggle();"<cfif feed.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				<input name="displayName" type="radio" value="0" class="objectParam  radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not feed.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</dd>
				<span id="altNameContainer"<cfif NOT feed.getDisplayName()> style="display:none;"</cfif>>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.altname')#</dt>
				<dd><input name="altName" class="objectParam  text" value="#HTMLEditFormat(feed.getAltName())#" maxlength="50"></dd>
				</span>
				
				
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</dt>
				<dd><select name="maxItems" class="objectParam  dropdown">
				<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
				<option value="#m#" <cfif feed.getMaxItems() eq m>selected</cfif>>#m#</option>
				</cfloop>
				<option value="100000" <cfif feed.getMaxItems() eq 100000>selected</cfif>>ALL</option>
				</select>
				</dd>

				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</dt>
				<dd><select name="nextN" class="objectParam  dropdown">
					<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
					<option value="#r#" <cfif r eq feed.getNextN()>selected</cfif>>#r#</option>
					</cfloop>
					<option value="100000" <cfif feed.getNextN() eq 100000>selected</cfif>>ALL</option>
					</select>
				</dd>
				<dt id="availableFields"><span>Available Fields</span> <span>Selected Fields</span></dt>
				<dd>
					<div class="sortableFields">
					<p class="dragMsg"><span class="dragFrom">Drag Fields from Here&hellip;</span><span>&hellip;and Drop Them Here.</span></p>
					<cfset displayList=feed.getDisplayList()>
					<cfset availableList=feed.getAvailableDisplayList()>
					
					<ul id="availableListSort" class="displayListSortOptions">
						<cfloop list="#availableList#" index="i">
						<li class="ui-state-default">#i#</li>
						</cfloop>
					</ul>
					
					<ul id="displayListSort" class="displayListSortOptions">
						<cfloop list="#displayList#" index="i">
						<li class="ui-state-highlight">#i#</li>
						</cfloop>
					</ul>
					<input type="hidden" id="displayList" class="objectParam " value="#displayList#" name="displayList"/>
					</div>	
				</dd>
				</dl>
			</div>
				
			<cfelse>
				<cfset displaySummaries=yesNoFormat(feed.getValue("displaySummaries"))>
				<dl class="oneColumn">
		
				<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.displaysummaries')#</dt>
				<dd>
				<input name="displaySummaries" type="radio" value="1" class="objectParam  radio" onchange="jQuery('##altNameContainer').toggle();"<cfif displaySummaries>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				<input name="displaySummaries" type="radio" value="0" class="objectParam  radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not displaySummaries>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</dd>
				</dl>
			</div>
			</cfif>
</cfoutput>
</cfsavecontent>
<cfset data.type=feed.getType()>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>
