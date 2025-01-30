<!---
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the
same licensing model. It is, therefore, licensed under the Gnu General Public License
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing
notice set out below. That exception is also granted by the copyright holders of Masa CMS
also applies to this file and Masa CMS in general.

This file has been modified from the original version received from Mura CMS. The
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained
only to ensure software compatibility, and compliance with the terms of the GPLv2 and
the exception set out below. That use is not intended to suggest any commercial relationship
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa.

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com

Masa CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.
Masa CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>.

The original complete licensing notice from the Mura CMS version of this file is as
follows:

This file is part of Mura CMS.

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

<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfset feed=$.getBean("feed").loadBy(name=createUUID())>
<cfset rc.contentBean = $.getBean('content').loadBy(contentID=rc.contentID, siteID=rc.siteID)>
<cfset subtype = application.classExtensionManager.getSubTypeByName(rc.contentBean.getType(), rc.contentBean.getSubType(), rc.contentBean.getSiteID())>
<cfset relatedContentSets = subtype.getRelatedContentSets()>
<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>

<cfif isDefined("form.params") and isJSON(form.params)>
	<cfset feed.set(deserializeJSON(form.params))>
<cfelse>
	<cfset feed.setDisplayList("Title")>
</cfif>

<cfoutput>
	<cfif rc.classid eq "related_content">
		<div id="availableObjectParams"
		data-object="#rc.classid#"
		data-name="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent'))#"
		data-objectid="#createUUID()#">
	<cfelse>
		<cfset menutitle=$.getBean("content").loadBy(contentID=rc.contentID).getMenuTitle()>
		<div id="availableObjectParams"
		data-object="#rc.classid#"
		data-name="#esapiEncode('html_attr','#menutitle# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#')#"
		data-objectid="#hash('related_content','CFMX_COMPAT')#">
	</cfif>

<!---<cfif rc.classid eq "related_content">
<h2>#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent'))#</h2>
	<cfelse>
		<h2>#esapiEncode('html','#menutitle# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#')#</h2>
	</cfif>
--->
	<div class="mura-layout-row">
		<cfif rc.classid eq "related_content">
			<div class="mura-control-group">
				<label>
					Related Content Set
				</label>
					<select name="relatedContentSetName" class="objectParam">
						<option value=""<cfif feed.getRelatedContentSetName() eq ""> selected</cfif>>All</option>
						<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="s">
							<cfset rcsBean = relatedContentSets[s]/>
							<option value="#rcsBean.getName()#"<cfif feed.getRelatedContentSetName() eq rcsBean.getName()> selected</cfif>>#rcsBean.getName()#</option>
						</cfloop>
					</select>
			</div>
		</cfif>

		<div class="mura-control-group">
    	<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
			<select name="imageSize" data-displayobjectparam="imageSize" class="objectParam" onchange="if(this.value=='custom'){jQuery('##feedCustomImageOptions').fadeIn('fast')}else{jQuery('##feedCustomImageOptions').hide();jQuery('##feedCustomImageOptions').find(':input').val('AUTO');}">
				<cfloop list="Small,Medium,Large" index="i">
					<option value="#lcase(i)#"<cfif i eq feed.getImageSize()> selected</cfif>>#I#</option>
				</cfloop>
				<cfloop condition="imageSizes.hasNext()">
					<cfset image=imageSizes.next()>
					<option value="#lcase(image.getName())#"<cfif image.getName() eq feed.getImageSize()> selected</cfif>>#esapiEncode('html',image.getName())#</option>
				</cfloop>
					<option value="custom"<cfif "custom" eq feed.getImageSize()> selected</cfif>>Custom</option>
			</select>
		</div>

		<div id="feedCustomImageOptions"<cfif feed.getImageSize() neq "custom"> style="display:none"</cfif>>
			<div class="mura-control-group half">
				<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#
			      </label>
				<input class="objectParam" name="imageWidth" data-displayobjectparam="imageWidth" type="text" value="#feed.getImageWidth()#" />
			</div>
			<div class="mura-control-group half">
			    <label>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
			    <input class="objectParam" name="imageHeight" data-displayobjectparam="imageHeight" type="text" value="#feed.getImageHeight()#" />
			</div>
		</div>

		<cfif rc.classid neq "related_content">
			<div class="mura-control-group">
				<label>
					#application.rbFactory.getKeyValue(session.rb,'collections.sortby')#
				</label>
				<select name="sortBy" class="objectParam">
					<option value="lastUpdate" <cfif feed.getsortBy() eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.lastupdate')#</option>
					<option value="releaseDate" <cfif feed.getsortBy() eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.releasedate')#</option>
					<option value="displayStart" <cfif feed.getsortBy() eq 'displayStart'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</option>
					<option value="menuTitle" <cfif feed.getsortBy() eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.menutitle')#</option>
					<option value="title" <cfif feed.getsortBy() eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.longtitle')#</option>
					<!---
					<option value="rating" <cfif feed.getsortBy() eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.rating')#</option>
					<option value="comments" <cfif feed.getsortBy() eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.comments')#</option>
					--->
					<option value="created" <cfif feed.getsortBy() eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.created')#</option>
					<option value="orderno" <cfif feed.getsortBy() eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.orderno')#</option>
					<!---
					<option value="random" <cfif feed.getsortBy() eq 'random'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.random')#</option>

					<cfloop query="rsExtend"><option value="#esapiEncode('html_attr',rsExtend.attribute)#" <cfif feed.getsortBy() eq rsExtend.attribute>selected</cfif>>#rsExtend.Type#/#rsExtend.subType# - #rsExtend.attribute#</option>
					</cfloop>
				--->
				</select>
			</div>

			<div class="mura-control-group">
				<label>
					#application.rbFactory.getKeyValue(session.rb,'collections.sortdirection')#
				</label>
				<select name="sortDirection" class="objectParam">
					<option value="asc" <cfif feed.getsortDirection() eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.ascending')#</option>
					<option value="desc" <cfif feed.getsortDirection() eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.descending')#</option>
				</select>
			</div>
		</cfif>

		<div class="mura-control-group" id="availableFields">
			<label>
				<span class="half">Available Fields</span> <span class="half">Selected Fields</span>
			</label>
			<div class="sortableFields">
				<p class="dragMsg">
					<span class="dragFrom half">Drag Fields from Here&hellip;</span><span class="half">&hellip;and Drop Them Here.</span>
				</p>

				<cfset displayList=feed.getDisplayList()>
				<cfset availableList=feed.getAvailableDisplayList()>

						<ul id="availableListSort" class="displayListSortOptions">
							<cfloop list="#availableList#" index="i">
								<li class="ui-state-default">#trim(i)#</li>
							</cfloop>
						</ul>
						<ul id="displayListSort" class="displayListSortOptions">
							<cfloop list="#displayList#" index="i">
								<li class="ui-state-highlight">#trim(i)#</li>
							</cfloop>
						</ul>

				<input type="hidden" id="displayList" class="objectParam " value="#displayList#" name="displayList"/>
			</div>
		</div>

	</div> <!-- /.mura-layout-row -->
</div> <!-- /availableObjectParams -->
</cfoutput>
