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

<cfif rc.layoutmanager>
	<cfsilent>
		<cfparam name="objectParams.sortBy" default="">
		<cfparam name="objectParams.sortDirection" default="">
		<cfparam name="objectParams.standardOptions" default="true">
		<cfset content=rc.$.getBean('content').loadBy(contenthistid=rc.contenthistid)>

		<cfif not len(objectParams.sortBy)>
			<cfset objectParams.sortBy=content.getValue('sortBy')>
		</cfif>

		<cfif not len(objectParams.sortDirection)>
			<cfset objectParams.sortDirection=content.getValue('sortDirection')>
		</cfif>

		<cfset content.set(objectParams)>

		<cfparam name="objectParams.layout" default="default">
		<cfparam name="objectParams.forcelayout" default="false">

		<cfset objectParams.source=content.getContentID()>
		<cfset objectParams.sourcetype='children'>

	</cfsilent>
	<cfsavecontent variable="data.html">
	<cf_objectconfigurator params="#objectparams#">
		<cfoutput>
		<div id="availableObjectParams"
			data-object="folder"
			data-objectname="Folder"
			data-objectid="#esapiEncode('html_attr',rc.contentid)#"
			data-forcelayout="#esapiEncode('html_attr',objectParams.forcelayout)#">
			<cfif rc.$.getBean('configBean').getClassExtensionManager().getSubTypeByName(content.get('type'),content.get('subtype'),content.get('siteid')).getHasConfigurator()>
			<div class="mura-layout-row">
				<div id="layoutcontainer"></div>
				<cfif objectParams.standardOptions>
					<div class="mura-control-group">
				      	<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</label>
						<select name="nextn" data-displayobjectparam="nextn" class="objectParam">
						<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
							<option value="#r#" <cfif r eq content.getNextN()>selected</cfif>>#r#</option>
							</cfloop>
							<option value="100000" <cfif content.getNextN() eq 100000>selected</cfif>>All</option>
						</select>
					</div>
					<div class="mura-control-group">
						<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.sortby')#</label>
						<select name="sortby"class="objectParam">
              <option value="orderno" <cfif content.getSortBy() eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.manual")#</option>
              <option value="releaseDate" <cfif content.getSortBy() eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.releasedate")#</option>
              <option value="lastUpdate" <cfif content.getSortBy() eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.updatedate")#</option>
              <option value="created" <cfif content.getSortBy() eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.created")#</option>
              <option value="menuTitle" <cfif content.getSortBy() eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.menutitle")#</option>
              <option value="title" <cfif content.getSortBy() eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.longtitle")#</option>
              <option value="rating" <cfif content.getSortBy() eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.rating")#</option>
							<cfif rc.$.getServiceFactory().containsBean('marketingManager')>
								<option value="mxpRelevance" <cfif content.getSortBy() eq 'mxpRelevance'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'params.mxpRelevance')#</option>
							</cfif>
							<cfif isBoolean(application.settingsManager.getSite(session.siteid).getHasComments()) and application.settingsManager.getSite(session.siteid).getHasComments()>
								<option value="comments" <cfif content.getSortBy() eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.comments")#</option>
							</cfif>
							<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(rc.siteid)>
	              <cfloop query="rsExtend">
	                <option value="#esapiEncode('html_attr',rsExtend.attribute)#" <cfif content.getSortBy() eq rsExtend.attribute>selected</cfif>>#esapiEncode('html',rsExtend.Type)#/#esapiEncode('html',rsExtend.subType)# - #esapiEncode('html',rsExtend.attribute)#</option>
	              </cfloop>
             	</select>
	          </div>
	        	<div class="mura-control-group">
							<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.sortdirection')#</label>
		          <select name="sortdirection" class="objectParam">
		              <option value="asc" <cfif content.getSortDirection() eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.ascending")#</option>
		              <option value="desc" <cfif content.getSortDirection() eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.descending")#</option>
		          </select>
						</div>
				</cfif>
			</div>
		</div>
		<script>
			$(function(){
				setLayoutOptions=function(){

					siteManager.updateAvailableObject();

					siteManager.availableObject.params.source = siteManager.availableObject.params.source || '';

					var params=siteManager.availableObject.params;

					$.ajax(
					 {
					 	type: 'post',
					 	dataType: 'text',
						url: './?muraAction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + configOptions.siteid + '&instanceid=#esapiEncode("url",rc.instanceid)#&classid=folder&contentid=' + contentid + '&parentid=' + configOptions.parentid + '&contenthistid=' + configOptions.contenthistid + '&regionid=' + configOptions.regionid + '&objectid=' + configOptions.objectid + '&contenttype=' + configOptions.contenttype + '&contentsubtype=' + configOptions.contentsubtype + '&container=layout&cacheid=' + Math.random(),

						data:{params:encodeURIComponent(JSON.stringify(params))},
						success:function(response){
							$('##layoutcontainer').html(response);
						  $('.mura ##configurator select').niceSelect();
						}
					})
				}

				setLayoutOptions();
			});
		</script>
		<cfelse>
		</div>
		</cfif>
		</cfoutput>
	</cf_objectconfigurator>
	</cfsavecontent>
	<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
	<cfabort>
<cfelse>
	<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
	<cfset feed=$.getBean("content").loadBy(contenthistid=rc.contenthistid)>

	<cfif isDefined("form.params") and isJSON(form.params)>
		<cfset feed.set(deserializeJSON(form.params))>
	</cfif>

	<cfset data=structNew()>
	<cfsavecontent variable="data.html">
	<cfoutput>
	<div id="availableObjectParams"
		data-object="folder"
		data-name="Folder"
		data-objectid="#rc.contentid#">

		<h2>Edit Folder Listing</h2>

		<div class="mura-layout-row">
			<div class="mura-control-group">
      	<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
				<select name="imageSize" data-displayobjectparam="imageSize" class="objectParam" onchange="if(this.value=='custom'){jQuery('##feedCustomImageOptions').fadeIn('fast')}else{jQuery('##feedCustomImageOptions').hide();jQuery('##feedCustomImageOptions').find(':input').val('AUTO');}">
					<cfloop list="Small,Medium,Large" index="i">
						<option value="#lcase(i)#"<cfif i eq feed.getImageSize()> selected</cfif>>#I#</option>
					</cfloop>

					<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>

					<cfloop condition="imageSizes.hasNext()">
						<cfset image=imageSizes.next()>
						<option value="#lcase(image.getName())#"<cfif image.getName() eq feed.getImageSize()> selected</cfif>>#esapiEncode('html',image.getName())#</option>
					</cfloop>
						<option value="custom"<cfif "custom" eq feed.getImageSize()> selected</cfif>>Custom</option>
				</select>
			</div>
			<span id="feedCustomImageOptions" class=""<cfif feed.getImageSize() neq "custom"> style="display:none"</cfif>>
				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</label>
					<input class="objectParam" name="imageWidth" data-displayobjectparam="imageWidth" type="text" value="#feed.getImageWidth()#" />
				</div>

				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
      		<input class="objectParam" name="imageHeight" data-displayobjectparam="imageHeight" type="text" value="#feed.getImageHeight()#" />
	      </div>
     </span>

			<div class="mura-control-group" id="availableFields">
				<label>
					<span class="half">Available Fields</span> <span class="half">Selected Fields</span>
				</label>
				<div id="sortableFields">
					<p class="dragMsg">
						<span class="dragFrom half">Drag Fields from Here&hellip;</span><span class="half">&hellip;and Drop Them Here.</span>
					</p>

					<cfset displaylist=feed.getdisplaylist()>
					<cfset availableList=feed.getAvailabledisplaylist()>

					<ul id="availableListSort" class="displayListSortOptions">
						<cfloop list="#availableList#" index="i">
							<li class="ui-state-default">#trim(i)#</li>
						</cfloop>
					</ul>

					<ul id="displayListSort" class="displayListSortOptions">
						<cfloop list="#displaylist#" index="i">
							<li class="ui-state-highlight">#trim(i)#</li>
						</cfloop>
					</ul>
					<input type="hidden" id="displaylist" class="objectParam" value="#displaylist#" name="displaylist"  data-displayobjectparam="displaylist"/>
				</div>
			</div>
		</div>
	</div>
	</cfoutput>
	</cfsavecontent>
	<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
	<cfabort>
</cfif>
