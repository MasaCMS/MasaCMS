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
<cfoutput>
	<select name="subClassSelector" 
	        onchange="loadObjectClass('#attributes.siteid#','localFeed',this.value,'#attributes.contentid#','#attributes.parentid#');" 
	        class="dropdown">
		<cfset request.rslist = application.feedManager.getFeeds(attributes.siteid, 'Local')/>
		<!---<option 
		value="feed_table~#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexlistingtable')#~none">
		    #application.rbFactory.getKeyValue(session.rb, 
		                                    'sitemanager.content.fields.localindexlistingtable')#
		</option>--->
		<option 
		value="">
		    #application.rbFactory.getKeyValue(session.rb, 
		                                    'sitemanager.content.fields.selectlocalindex')#
		</option>
		<cfloop query="request.rslist">
			<option value="#request.rslist.feedID#"<cfif request.rslist.feedID eq attributes.subclassid> selected</cfif>>
				#request.rslist.name# 
				- 
				#application.rbFactory.getKeyValue(session.rb, 'sitemanager.content.fields.localindex')#
			</option>
		</cfloop>
	</select>
	
	<cfif attributes.subclassid neq ''>
		<cfset $=application.serviceFactory.getBean("muraScope").init(attributes.siteID)>
		<cfset feed=$.getBean("feed").loadBy(feedID=attributes.subclassid)>
		<!---<cfset rsExtend=$.getBean("configBean").getClassExtensionManager().getExtendedAttributeList(attributes.siteid,"tcontent")>--->
		
		<div id="feedConfigurator">
			<!---
			<select onchange="resetFeedParams(this.value);" class="dropdown">
				<option value="default">#application.rbFactory.getKeyValue(session.rb,'collections.selectdisplayoptions.default')#</option>
				<option value="custom">#application.rbFactory.getKeyValue(session.rb,'collections.selectdisplayoptions.custom')#</option>
			</select>
			--->
			<div id="availableObjectParams"<!--- style="display:none;"--->>
				<h4>#application.rbFactory.getKeyValue(session.rb,'collections.displayoptions')#</h4>
				<dl class="oneColumn">
					<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</dt>
					<dd><select data-displayobjectparam="imageSize" class="dropdown" onchange="if(this.value=='Custom'){jQuery('##feedCustomImageOptions').fadeIn('fast')}else{jQuery('##feedCustomImageOptions').hide()}">
						<cfloop list="Small,Medium,Large,Custom" index="i">
							<option value="#i#"<cfif i eq feed.getImageSize()> selected</cfif>>#I#</option>
						</cfloop>
						</select>
					</dd>
					<dd id="feedCustomImageOptions"<cfif feed.getImageSize() neq "Custom"> style="display:none"</cfif>>
						<dl>
							<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</dt>
							<dd><input data-displayobjectparam="imageHeight" class="text" value="#feed.getImageHeight()#" /></dd>
							<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</dt>
							<dd><input data-displayobjectparam="imageWidth" class="text" value="#feed.getImageWidth()#" /></dd>
						</dl>
					</dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displaysummaries')#</dt>
				<dd>
				<input name="feedDisplaySummaries" data-displayobjectparam="displaySummaries" type="radio" value="1" class="radio" checked>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				<input name="feedDisplaySummaries" data-displayobjectparam="displaySummaries" type="radio" value="0" class="radio">#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displayname')#</dt>
				<dd>
				<input name="feedDisplayName" data-displayobjectparam="displayName" type="radio" value="1" class="radio" onchange="jQuery('##altNameContainer').toggle();"<cfif feed.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				<input name="feedDisplayName" data-displayobjectparam="displayName" type="radio" value="0" class="radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not feed.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</dd>
				<span id="altNameContainer"<cfif NOT feed.getDisplayName()> style="display:none;"</cfif>>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.altname')#</dt>
				<dd><input data-displayobjectparam="altName" class="text" value="#HTMLEditFormat(feed.getAltName())#" maxlength="50"></dd>
				</span>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displaycomments')#</dt>
				<dd>
				<input name="feedDisplayComments" data-displayobjectparam="displayComments" type="radio" value="1" class="radio" <cfif feed.getDisplayComments()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				<input name="feedDisplayComments" data-displayobjectparam="displayComments" type="radio" value="0" class="radio" <cfif not feed.getDisplayComments()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displayrating')#</dt>
				<dd>
				<input name="feedDisplayRatings" data-displayobjectparam="displayRatings" type="radio" value="1" class="radio" <cfif feed.getDisplayRatings()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				<input name="feedDisplayRatings" data-displayobjectparam="displayRatings" type="radio" value="0" class="radio" <cfif not feed.getDisplayRatings()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</dt>
				<dd><select data-displayobjectparam="nextN" class="dropdown">
					<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
					<option value="#r#" <cfif r eq feed.getNextN()>selected</cfif>>#r#</option>
					</cfloop>
					<option value="100000" <cfif feed.getNextN() eq 100000>selected</cfif>>ALL</option>
					</select>
				</dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</dt>
				<dd><select data-displayobjectparam="maxItems" class="dropdown">
				<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
				<option value="#m#" <cfif feed.getMaxItems() eq m>selected</cfif>>#m#</option>
				</cfloop>
				<option value="100000" <cfif feed.getMaxItems() eq 100000>selected</cfif>>ALL</option>
				</select>
				</dd>
				<!---
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.sortby')#</dt>
				<dd><select data-displayobjectparam="sortBy" class="dropdown">
						<option value="lastUpdate" <cfif feed.getsortBy() eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.lastupdate')#</option>
						<option value="releaseDate" <cfif feed.getsortBy() eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.releasedate')#</option>
						<option value="displayStart" <cfif feed.getsortBy() eq 'displayStart'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</option>
						<option value="menuTitle" <cfif feed.getsortBy() eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.menutitle')#</option>
						<option value="title" <cfif feed.getsortBy() eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.longtitle')#</option>
						<option value="rating" <cfif feed.getsortBy() eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.rating')#</option>
						<option value="comments" <cfif feed.getsortBy() eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.comments')#</option>
						<option value="created" <cfif feed.getsortBy() eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.created')#</option>
						<option value="orderno" <cfif feed.getsortBy() eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.orderno')#</option>
						<option value="random" <cfif feed.getsortBy() eq 'random'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.random')#</option>
						<cfloop query="rsExtend"><option value="#HTMLEditFormat(rsExtend.attribute)#" <cfif feed.getsortBy() eq rsExtend.attribute>selected</cfif>>#rsExtend.Type#/#rsExtend.subType# - #rsExtend.attribute#</option>
						</cfloop>
					</select>
					</dd>
					<dt>#application.rbFactory.getKeyValue(session.rb,'collections.sortdirection')#</dt>
					<dd>
					<select data-displayobjectparam="sortDirection" class="dropdown">
						<option value="asc" <cfif feed.getsortDirection() eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.ascending')#</option>
						<option value="desc" <cfif feed.getsortDirection() eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.descending')#</option>
					</select>
				</dd>--->
				</dl>
			</div>
		</div>
		<input type="hidden" name="availableObjects" id="availableObjects" value="{'object':'feed','name':'#JSStringFormat('#feed.getName()# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindex')#')#','objectid':'#feed.getFeedID()#'}"/>
	</cfif>
</cfoutput>