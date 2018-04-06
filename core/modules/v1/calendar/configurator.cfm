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
		<cfset content=rc.$.getBean('content').loadBy(contenthistid=rc.contenthistid)>
		<cfset content.set(objectParams)>

		<cfparam name="objectParams.items" default="#arrayNew(1)#">
		<cfparam name="objectParams.viewoptions" default="">
		<cfparam name="objectParams.format" default="calendar">
		<cfparam name="objectParams.forcelayout" default="false">

		<cfif not len(objectParams.viewoptions)>
			<cfset objectParams.viewoptions='agendaDay,agendaWeek,month'>
		</cfif>

		<cfparam name="objectParams.viewdefault" default="">

		<cfif not len(objectParams.viewdefault)>
			<cfset objectParams.viewdefault='month'>
		</cfif>

		<cfset objectParams.source=content.getContentID()>
		<cfset objectParams.sourcetype='calendar'>

	</cfsilent>
	<cfsavecontent variable="data.html">
	<cf_objectconfigurator params="#objectparams#">
		<cfoutput>
		<div id="availableObjectParams"
			data-object="calendar"
			data-name="Calendar"
			data-objectid="#esapiEncode('html_attr',rc.contentid)#"
			data-forcelayout="#esapiEncode('html_attr',objectParams.forcelayout)#">

			<cfif rc.$.getBean('configBean').getClassExtensionManager().getSubTypeByName(content.get('type'),content.get('subtype'),content.get('siteid')).getHasConfigurator()>
			<div class="mura-layout-row">
				<div class="mura-control-group">
					<label>
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.format')#
					</label>
					<select id="formatselector" name="format" class="objectParam">
						<cfloop list="Calendar,List" index="i">
							<option name="#i#"<cfif objectparams.format eq i> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.#i#')#</option>
						</cfloop>
					</select>
				</div>
				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'calendar.additionalcalendars')#</label>
					<button class="btn" id="editBtnRelatedContent"><i class="mi-pencil"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#</button>
					<cfif arrayLen(objectParams.items)>
					<ul class="configurator-options">
					<cfloop array="#objectParams.items#" index="i">
						<cfif i neq content.getContentID()>
						 	<cfset item=rc.$.getBean('content').loadBy(contentid=i)>
						 	<li><a href="#item.getURL()#" target="_top">#esapiEncode('html',item.getMenuTitle())#</a></li>
						</cfif>
					</cfloop>
					</ul>
					<cfelse>
					<div class="help-block-empty">#application.rbFactory.getKeyValue(session.rb,'calendar.noadditional')#</div>
					</cfif>
				</div>

				<div id="calendarformatoptions" style="display:none">
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'calendar.availableviews')#
						</label>
						<ul class="configurator-options">
						<cfloop list="month,basicWeek,basicDay,agendaWeek,agendaDay" index="i">
						<li><label class="checkbox">
							<input type="checkbox" class="objectParam" name="viewoptions" value="#i#" <cfif listFindNoCase(objectParams.viewoptions,i)> checked</cfif>/> #application.rbFactory.getKeyValue(session.rb,'calendar.#i#')#</label></li>
						</cfloop>
						</ul>
					</div>
					<div class="mura-control-group">
						<label>
							#application.rbFactory.getKeyValue(session.rb,'calendar.defaultview')#
						</label>
						<select name="viewdefault" class="objectParam">
						<cfloop list="month,basicWeek,basicDay,agendaWeek,agendaDay" index="i">
							<option value="#i#" <cfif objectParams.viewdefault eq i> selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'calendar.#i#')#</option>
						</cfloop>
						</select>
					</div>

				<input type="hidden" class="objectParam" name="items" id="items" value="#esapiEncode('html_attr',serializeJSON(objectParams.items))#">
			</div>

			<div id="listformatoptions" style="display:none">
					<div id="layoutcontainer"></div>
					<div class="mura-control-group">
				      	<label>#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</label>
						<select name="nextn" data-displayobjectparam="nextn" class="objectParam">
						<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
							<option value="#r#" <cfif r eq content.getNextN()>selected</cfif>>#r#</option>
							</cfloop>
							<option value="100000" <cfif content.getNextN() eq 100000>selected</cfif>>All</option>
						</select>
					</div>
				</div>
			</div>
		</div>
		<script>
			$(function(){

				function setOptionDisplay(){
					if($('##formatselector').val().toLowerCase()=='list'){
						$('##listformatoptions').show();
						$('##calendarformatoptions').hide();
					} else {
						$('##listformatoptions').hide();
						$('##calendarformatoptions').show();
					}
				}

				$('##formatselector').change(setOptionDisplay);

				$('##editBtnRelatedContent').click(function(){
					frontEndProxy.post({
						cmd:'openModal',
						src:'?muraAction=cArch.relatedcontent&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true&relatedcontentsetid=calendar&items=#esapiEncode("url",serializeJSON(objectparams.items))#'
						}
					);

				});

				setColorPickers(".colorpicker");
				setOptionDisplay();

				setLayoutOptions=function(){

					siteManager.updateAvailableObject();

					siteManager.availableObject.params.source = siteManager.availableObject.params.source || '';

					var params=siteManager.availableObject.params;

					$.ajax(
					 {
					 	type: 'post',
					 	dataType: 'text',
						url: './?muraAction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + configOptions.siteid + '&instanceid=#esapiEncode("url",rc.instanceid)#&classid=calendar&contentid=' + contentid + '&parentid=' + configOptions.parentid + '&contenthistid=' + configOptions.contenthistid + '&regionid=' + configOptions.regionid + '&objectid=' + configOptions.objectid + '&contenttype=' + configOptions.contenttype + '&contentsubtype=' + configOptions.contentsubtype + '&container=layout&cacheid=' + Math.random(),

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
	<cfsilent>
		<cfset feed=rc.$.getBean("content").loadBy(contenthistid=rc.contenthistid)>
		<cfset feed.set(objectParams)>
	</cfsilent>
	<cfsavecontent variable="data.html">
	<cfoutput>
	<div id="availableObjectParams"
		data-object="calendar"
		data-name="Calendar"
		data-objectid="#rc.contentid#">

		<h2>Edit Calendar Listing</h2>

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

				<span id="feedCustomImageOptions" <cfif feed.getImageSize() neq "custom"> style="display:none"</cfif>>
					<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</label>
						<input class="objectParam half" name="imageWidth" data-displayobjectparam="imageWidth" type="text" value="#feed.getImageWidth()#" />
					</div>
					<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
	      		<input class="objectParam half" name="imageHeight" data-displayobjectparam="imageHeight" type="text" value="#feed.getImageHeight()#" />
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
