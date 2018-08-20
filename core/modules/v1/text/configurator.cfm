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
	<cfparam name="objectParams.sourcetype" default="custom">
	<cfparam name="objectParams.source" default="">
	<cfset content=rc.$.getBean('content').loadBy(contentid=rc.objectid)>
	<cfset content.setType('Component')>
	<cfset rc.rsComponents = application.contentManager.getComponentType(rc.siteid, 'Component','00000000000000000000000000000000000')/>
	<cfset hasModulePerm=rc.configuratormode neq 'backend' and listFindNocase('editor,author',rc.$.getBean('permUtility').getPerm('00000000000000000000000000000000003',rc.siteid))>
</cfsilent>
<cfsavecontent variable="data.html">
<cf_objectconfigurator params="#objectparams#">
	<cfoutput>
	<div id="availableObjectParams"
		data-object="collection"
		data-name="#esapiEncode('html_attr','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.text')#')#"
		data-objectid="none">
		<div class="mura-layout-row">
			<div class="mura-control-group">
				<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentsource')#</label>
				<select class="objectParam" name="sourcetype">
					<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectcontentsource')#</option>
					<option <cfif objectParams.sourcetype eq 'custom'>selected </cfif>value="custom">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.custom')#</option>
					<option <cfif objectParams.sourcetype eq 'component'>selected </cfif>value="component">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.component')#</option>
					<option <cfif objectParams.sourcetype eq 'boundattribute'>selected </cfif>value="boundattribute">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.boundattribute')#</option>
				</select>
				<button id="editSource" class="btn"><i class="mi-pencil"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.edit')#</button>
			</div>
			<div id="componentcontainer" class="mura-control-group source-container" style="display:none">
				<label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectcomponent')#</label>
				<cfset rs=rc.$.getBean('contentManager').getList(args={moduleid='00000000000000000000000000000000003',siteid=session.siteid})>
				<select name="source" id="component">
					<option value="{object:'component',objectid:'unconfigured'}">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectcomponent')#
					</option>`
					<cfloop query="rc.rsComponents">
						<cfset title=rc.rsComponents.menutitle>
						<option <cfif rc.objectid eq rc.rsComponents.contentid and rc.object eq 'component'>selected </cfif>title="#esapiEncode('html_attr',title)#" value="#rc.rsComponents.contentid#">
							#esapiEncode('html',title)#
						</option>
					</cfloop>
				</select>

				<cfif hasModulePerm>
					<button class="btn" id="editBtnComponent"><i class="mi-plus-circle"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.createnew')#</button>
				</cfif>
			</div>
			<div id="customcontainer" class="mura-control-group source-container" style="display:none">
				<textarea name="source" id="custom" style="display:none;"><cfif objectParams.sourceType eq 'custom'>#objectParams.source#</cfif></textarea>
				<script>
				$(function(){
					$('##editSource').click(function(){
						frontEndProxy.post({
							cmd:'openModal',
							src:'?muraAction=cArch.edittext&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true'
							}
						);
					});
				});
				</script>

			</div>
			<div id="boundattributecontainer" class="mura-control-group source-container" style="display:none">
				<label class="mura-ontrol-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectboundattribute')#</label>
					<cfsilent>
					<cfset options=arrayNew(2) />
					<cfset options[1][1]="menutitle">
					<cfset options[1][2]=application.rbFactory.getKeyValue(session.rb,'params.menutitle')>
					<cfset options[2][1]="title">
					<cfset options[2][2]=application.rbFactory.getKeyValue(session.rb,'params.title')>
					<cfset options[3][1]="credits">
					<cfset options[3][2]=application.rbFactory.getKeyValue(session.rb,'params.credits')>
					<cfset options[4][1]="summary">
					<cfset options[4][2]=application.rbFactory.getKeyValue(session.rb,'params.summary')>

					<cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(siteID=rc.siteid,baseTable="tcontent",activeOnly=true,type=content.getType(),subtype=content.getSubType())>
					<cfloop query="rsExtend">
					<cfset options[rsExtend.currentRow + 4][1]=rsExtend.attribute>
					<cfset options[rsExtend.currentRow + 4][2]=rsExtend.label/>
					</cfloop>
				</cfsilent>
				<select name="source" id="boundattribute">
					<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectboundattribute')#</option>
					<cfloop from="1" to="#arrayLen(options)#" index="i">
						<option value="#esapiEncode('html_attr',options[i][1])#"<cfif objectParams.source eq options[i][1]> selected</cfif>>#esapiEncode('html',options[i][2])#</option>
					</cfloop>
				</select>
			</div>
		</div>
		</div>

		<!--- Include global config object options --->
		<cfinclude template="#$.siteConfig().lookupDisplayObjectFilePath('object/configurator.cfm')#">

	<cfparam name="objectParams.render" default="server">
	<input type="hidden" class="objectParam" name="render" value="#esapiEncode('html_attr',objectParams.render)#">
	<input type="hidden" class="objectParam" name="async" value="#esapiEncode('html_attr',objectParams.async)#">
	<script>
		$(function(){

			function setContentSourceVisibility(){
				<cfif rc.configuratormode neq 'backend'>

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

				$('select[name="source"], textarea[name="source"]').removeClass('objectParam');
				$('.source-container').hide();
				$('##editSource').hide();

				var val=$('select[name="sourcetype"]').val();

				if(val=='custom'){
					$('##custom').addClass('objectParam');
					$('##editSource').show();
					$('input[name="render"]').val('client');
					$('input[name="async"]').val('false');
				} else if(val=='boundattribute'){
					$('##boundattribute').addClass('objectParam');
					$('##boundattributecontainer').show();
					$('input[name="render"]').val('server');
					$('input[name="async"]').val('true');
				} else if(val=='component'){
					$('##component').addClass('objectParam');
					$('##componentcontainer').show();
					$('input[name="render"]').val('server');
					$('input[name="async"]').val('true');
				}
			}

			$('select[name="sourcetype"]').on('change', function() {
				setContentSourceVisibility();
			});

			setContentSourceVisibility();

		});
	</script>
	</cfoutput>
</cf_objectconfigurator>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>
