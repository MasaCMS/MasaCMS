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
	<cfparam name="objectParams.sourcetype" default="">
	<cfparam name="objectParams.source" default="">
	<cfparam name="objectParams.items" default="#arrayNew(1)#">
	<cfparam name="objectParams.layout" default="default">
	<cfparam name="objectParams.forcelayout" default="false">
	<cfparam name="objectParams.sortby" default="Title">
	<cfparam name="objectParams.sortdirection" default="ASC">
	<cfparam name="objectParams.render" default="server">
	<cfparam name="objectParams.async" default="false">
	<cfset hasFeedManagerAccess=rc.configuratormode neq 'backend' and rc.$.getBean('permUtility').getModulePerm('00000000000000000000000000000000011',rc.siteid)>
</cfsilent>
<cfsavecontent variable="data.html">
<cf_objectconfigurator params="#objectparams#">
	<cfoutput>

	<div id="availableObjectParams"
		data-object="collection"
		data-name="#esapiEncode('html_attr','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.collection')#')#"
		data-objectid="none"
		data-forcelayout="#esapiEncode('html_attr',objectParams.forcelayout)#">

		<div class="mura-layout-row">
			<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentsource')#</label>
				<select class="objectParam" name="sourcetype">
					<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentsource')#</option>
					<option <cfif objectParams.sourcetype eq 'localindex'>selected </cfif>value="localindex">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindex')#</option>
					<option <cfif objectParams.sourcetype eq 'remotefeed'>selected </cfif>value="remotefeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeed')#</option>
					<option <cfif objectParams.sourcetype eq 'relatedcontent'>selected </cfif>value="relatedcontent">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#</option>
					<option <cfif objectParams.sourcetype eq 'children'>selected </cfif>value="children">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.children')#</option>
				</select>
			</div>
			<div id="localindexcontainer" class="mura-control-group source-container" style="display:none">
				<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectlocalindex')#</label>
				<cfset rs=rc.$.getBean('feedManager').getFeeds(type='Local',siteid=rc.$.event('siteid'),activeOnly=true)>
				<select name="source" id="localindex">
					<option value="">Select Local Index</option>
					<cfloop query="rs">
						<option value="#rs.feedid#"<cfif rs.feedid eq objectParams.source> selected</cfif>>#esapiEncode('html',rs.name)#</option>
					</cfloop>
				</select>

				<cfif hasFeedManagerAccess>
					<button class="btn" id="editBtnLocalIndex"><i class="mi-plus-circle"></i> Create New</button>
				</cfif>
			</div>
			<div id="remotefeedcontainer" class="mura-control-group source-container" style="display:none">
				<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectremotefeed')#</label>
				<cfset rs=rc.$.getBean('feedManager').getFeeds(type='Remote',siteid=rc.$.event('siteid'),activeOnly=true)>
				<select name="source" id="remotefeed">
					<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectremotefeed')#</option>
					<cfloop query="rs">
						<option value="#rs.feedid#"<cfif rs.feedid eq objectParams.source> selected</cfif>>#esapiEncode('html',rs.name)#</option>
					</cfloop>
				</select>

				<cfif hasFeedManagerAccess>
					<button class="btn" id="editBtnRemoteFeed"><i class="mi-plus-circle"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.createnew')#</button>
				</cfif>
			</div>
			<div id="relatedcontentcontainer" class="mura-control-group source-container" style="display:none">
				<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectrelatedcontentset')#</label>
				<cfset subtype = application.classExtensionManager.getSubTypeByName(rc.contenttype, rc.contentsubtype,rc.siteid)>
				<cfset relatedContentSets = subtype.getRelatedContentSets()>
				<select name="source" id="relatedcontent">
					<cfloop from="1" to="#arrayLen(relatedContentSets)#" index="s">
						<cfset rcsBean = relatedContentSets[s]/>
						<option value="#rcsBean.getRelatedContentSetId()#"<cfif objectParams.source eq rcsBean.getRelatedContentSetId()> selected</cfif>>#rcsBean.getName()#</option>
					</cfloop>
					<option value="custom"<cfif objectParams.source eq 'custom'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.custom')#</option>
					<option value="reverse"<cfif objectParams.source eq 'reverse'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.reverse')#</option>
				</select>
				<input type="hidden" name="items" id="items" value="#esapiEncode('html_attr',serializeJSON(objectParams.items))#">
				<button class="btn" id="editBtnRelatedContent"><i class="mi-pencil"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.edit')#</button>
			</div>
		</div>
		<div class="mura-layout-row" id="layoutcontainer">
		</div>

		</div>
		<!--- Include global config object options --->
		<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">


	<script>
		$(function(){

			function setRemoteFeedEditOption(){
				var selector=$('##remotefeed');
			 	if(selector.val()){
			 		$('##editBtnRemoteFeed').html('<i class="mi-pencil"></i> Edit');
			 	} else {
			 		$('##editBtnRemoteFeed').html('<i class="mi-plus-circle"></i> Create New');
			 	}
			}

			function setLocalIndexEditOption(){
				var selector=$('##localindex');
			 	if(selector.val()){
			 		$('##editBtnLocalIndex').html('<i class="mi-pencil"></i> Edit');
			 	} else {
			 		$('##editBtnLocalIndex').html('<i class="mi-plus-circle"></i> Create New');
			 	}
			}

			function setRelatedContentEditOption(){
				var selector=$('##relatedcontent');
			 	if(selector.val()=='custom'){
			 		$('##editBtnRelatedContent').show();
			 		$('##editBtnRelatedContent').html('<i class="mi-pencil"></i> Edit');
			 		$('##items').addClass('objectParam');

			 	} else {
			 		$('##editBtnRelatedContent').hide();
			 		$('##items').removeClass('objectParam');
			 	}
			}

			function setContentSourceVisibility(){
				<cfif rc.configuratormode neq 'backend'>
				<cfset content=rc.$.getBean('content').loadBy(contenthistid=rc.contenthistid)>

				function getType(){
					var type=$('input[name="type"]');

					if(type.length){
						return type.val();
					} else {
						return '#esapiEncode("javascript",content.getType())#';
					}
				}

				function getSubType(){
					var subtype=$('input[name="subtype"]');

					if(subtype.length){
						return subtype.val();
					} else {
						return '#esapiEncode("javascript",content.getSubType())#';
					}
				}

				function getContentID(){
					return '#esapiEncode("javascript",content.getContentID())#';
				}

				function getContentHistID(){
					return '#esapiEncode("javascript",content.getContentHistID())#';
				}

				function getSiteID(){
					return '#esapiEncode("javascript",rc.siteid)#';
				}
				</cfif>

				$('select[name="source"], ##items').removeClass('objectParam');
				$('.source-container').hide();
				$('.sort-container').hide();

				var val=$('select[name="sourcetype"]').val();

				if(val=='localindex'){
					$('##localindex').addClass('objectParam');
					$('##localindexcontainer').show();
				} else if(val=='remotefeed'){
					$('##remotefeed').addClass('objectParam');
					$('##remotefeedcontainer').show();
				} else if(val=='relatedcontent'){
					$('##relatedContentSetData').val('');
					$('##selectRelatedContent').html('');
					$('##selectedRelatedContent').html('');
					$('##relatedcontentcontainer').show();
					$('##relatedcontent').addClass('objectParam');
				}
			}

			setLayoutOptions=function(){
				$('input[name="layout"]').val($('##layoutSel').val());
				siteManager.updateAvailableObject();
				siteManager.availableObject.params.source = siteManager.availableObject.params.source || '';

				var params=siteManager.availableObject.params;

			  params.layout=params.layout || 'default';

				//console.log(params)

				$.ajax(
				 {
				 	type: 'post',
				 	dataType: 'text',
					url: './?muraAction=cArch.loadclassconfigurator&compactDisplay=true&siteid=' + configOptions.siteid + '&instanceid=#esapiEncode("url",rc.instanceid)#&classid=' + configOptions.object + '&contentid=' + contentid + '&parentid=' + configOptions.parentid + '&contenthistid=' + configOptions.contenthistid + '&regionid=' + configOptions.regionid + '&objectid=' + configOptions.objectid + '&contenttype=' + configOptions.contenttype + '&contentsubtype=' + configOptions.contentsubtype + '&container=layout&cacheid=' + Math.random(),

					data:{params:encodeURIComponent(JSON.stringify(params))},
					success:function(response){
						$('##layoutcontainer').html(response);
						$('.mura ##configurator select').niceSelect();
						$('##layoutcontainer .mura-file-selector').fileselector();
					}
				})
			}

			$('select[name="sourcetype"]').on('change', function() {
				setContentSourceVisibility();
				setLayoutOptions();
			});

			$('select[name="source"]').on('change', function() {
				setLayoutOptions();


				if($('select[name="sourcetype"]').val()=='relatedcontent'){
					setContentSourceVisibility();
				}
			});

			$('##localindex').change(setLocalIndexEditOption);
			$('##remotefeed').change(setRemoteFeedEditOption);
			$('##relatedcontent').change(setRelatedContentEditOption);


			$('##editBtnLocalIndex').click(function(){
				frontEndProxy.post({
					cmd:'openModal',
					src:'?muraAction=cFeed.edit&feedid=' +$('##localindex').val() + '&type=Local&siteId=#esapiEncode("url",rc.siteid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true'
					}
				);
			});

			$('##editBtnRemoteFeed').click(function(){
				frontEndProxy.post({
					cmd:'openModal',
					src:'?muraAction=cFeed.edit&feedid=' +$('##remotefeed').val() + '&type=Remote&siteId=#esapiEncode("url",rc.siteid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true'
					}
				);
			});

			$('##editBtnRelatedContent').click(function(){
				frontEndProxy.post({
					cmd:'openModal',
					src:'?muraAction=cArch.relatedcontent&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true&relatedcontentsetid=' + $('##relatedcontent').val() + '&items=#esapiEncode("url",serializeJSON(objectparams.items))#'
					}
				);

			});

			setContentSourceVisibility();
			setLayoutOptions();
			setLocalIndexEditOption()
			setRemoteFeedEditOption()
			setRelatedContentEditOption()

		});
	</script>
	</cfoutput>
</cf_objectconfigurator>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>
