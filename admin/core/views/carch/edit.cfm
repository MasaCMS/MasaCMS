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
or libraries that are released under the GNU Lesser General Pbuublic License version 2.1.

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
<cfset event=request.event>
<cfinclude template="js.cfm">
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
<cfif rc.contentBean.getType() eq 'Gallery'>
	<cfset pageLevelList="Page,Folder,Calendar,Gallery"/>
	<cfset extendedList="Page,Folder,Calendar,Gallery,Link,File,Component,Form"/>
<cfelse>
	<cfset pageLevelList="Page,Folder,Calendar"/>
	<cfset extendedList="Page,Folder,Calendar,Link,File,Component,Form"/>
</cfif>
<cfset isExtended=false>
<cfset nodeLevelList="Page,Folder,Calendar,Gallery,Link,File"/>
<cfset hasChangesets=application.settingsManager.getSite(rc.siteID).getHasChangesets()>
<cfset stats=rc.contentBean.getStats()>
<cfset rc.perm=application.permUtility.getnodePerm(rc.crumbdata)>

<cfif rc.parentID eq "" and not rc.contentBean.getIsNew()>
	<cfset rc.parentID=rc.contentBean.getParentID()>
</cfif>



<cfif rc.contentBean.getIsNew()>
	<cfif isDefined('rc.title') and len(rc.title)>
		<cfset rc.contentBean.setTitle(rc.title)>
	</cfif>

	<cfif isDefined('rc.remoteid') and len(rc.remoteid)>
		<cfset rc.contentBean.setRemoteID(rc.remoteid)>
	</cfif>

	<cfif isDefined('rc.type') and len(rc.type)>
		<cfset rc.contentBean.setType(rc.type)>
	</cfif>

	<cfif isDefined('rc.subtype') and len(rc.subtype)>
		<cfset rc.contentBean.setSubType(rc.subtype)>
	</cfif>

</cfif>

<cfset rc.parentBean=$.getBean('content').loadBy(contentid=rc.parentID)>
<cfset subtypefilter=rc.parentBean.getClassExtension().getAvailableSubTypes()>
<cfif rc.contentBean.getIsNew()>
	<cfset requiresApproval=rc.parentBean.requiresApproval()>
	<cfset showApprovalStatus=rc.parentBean.requiresApproval(applyExemptions=false)>
<cfelse>
	<cfset requiresApproval=rc.contentBean.requiresApproval()>
	<cfset showApprovalStatus=rc.contentBean.requiresApproval(applyExemptions=false)>
</cfif>

<cfif hasChangesets>
	<cfset currentChangeset=application.changesetManager.read(rc.contentBean.getChangesetID())>
	<cfset pendingChangesets=application.changesetManager.getPendingByContentID(rc.contentBean.getContentID(),rc.siteID)>
</cfif>

<cfset rc.deletable=rc.compactDisplay neq "true" and ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getLocking() eq 'none')) and (rc.perm eq 'editor' and rc.contentid neq '00000000000000000000000000000000001') and rc.contentBean.getIsLocked() neq 1>
<cfset assignChangesets=rc.perm eq 'editor' and hasChangesets>
<cfset $=event.getValue("MuraScope")>
<cfset tabAssignments=$.getBean("user").loadBy(userID=session.mura.userID, siteID=session.mura.siteID).getContentTabAssignments()>
<script>
	var draftremovalnotice=<cfif application.configBean.getPurgeDrafts() and event.getValue("suppressDraftNotice") neq "true" and rc.contentBean.hasDrafts() and not requiresApproval><cfoutput>'#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draftremovalnotice"))#'</cfoutput><cfelse>""</cfif>;
		siteManager.hasNodeLock=<cfif stats.getLockType() eq 'node'>true<cfelse>false</cfif>;
		<cfoutput>siteManager.unlocknodeconfirm="#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlocknodeconfirm'))#";</cfoutput>
</script>

<cfif rc.compactDisplay neq "true" and application.configBean.getConfirmSaveAsDraft()>
	<script>
	siteManager.requestedURL="";
	siteManager.formSubmitted=false;
	siteManager.doConditionalExit=true;
	<cfoutput>
	function setRequestedURL(){
		siteManager.requestedURL=this.href
		return conditionalExit("#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#");
	}

	$(document).ready(function(){
		var anchors=document.getElementsByTagName("A");

		for(var i=0;i<anchors.length;i++){
			try{
				if (typeof(anchors[i].onclick) != 'function'
					&& typeof(anchors[i].getAttribute('href')) == 'string'
					&& anchors[i].getAttribute('href').indexOf('##') == -1
					&& anchors[i].getAttribute('href').indexOf('mailto') == -1) {
		   			anchors[i].onclick = setRequestedURL;
				}
			} catch(err){}
		}

	});
	</cfoutput>

	$(document).on('unload',function(){
		if(!siteManager.formSubmitted && siteManager.requestedURL != '')
		{
			conditionalExit();
		}
	});

	function conditionalExit(msg){

		if(!siteManager.doConditionalExit){
			return true;
		}

		if(siteManager.form_is_modified(document.contentForm)){
		if(msg==null){
			<cfoutput>msg="#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#";</cfoutput>
		}

		document.contentForm.approved.value=0;
		jQuery("#alertDialog").html(msg);
		jQuery("#alertDialog").dialog({
				dialogClass: "dialog-info",
				title:"<cfoutput>#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.savedraft'))#</cfoutput>",
				width: 400,
				resizable: false,
				modal: true,
				position: getDialogPosition(),
				buttons: {
					'No': function() {
						jQuery(this).dialog('close');
						location.href=siteManager.requestedURL;
						siteManager.requestedURL="";
					},
					Yes:
						{click: function() {
							jQuery(this).dialog('close');
							if(siteManager.ckContent()){
								document.getElementById('contentForm').returnURL.value=siteManager.requestedURL;
								submitForm(document.contentForm,'add');
							}
							return false;
							}
						, text: 'Yes'
						, class: 'mura-primary'
						} // /yes
				}

			});

			return false;

		} else {
			siteManager.requestedURL="";
			return true;
		}

	}
	</script>
<cfelseif rc.compactDisplay eq "true">
	<script type="text/javascript">
	jQuery(document).ready(function(){
		if (top.location != self.location) {
			if(jQuery("#ProxyIFrame").length){
				jQuery("#ProxyIFrame").load(
					function(){
						frontEndProxy.post({cmd:'setWidth',width:'standard'});
					}
				);
			} else {
				frontEndProxy.post({cmd:'setWidth',width:'standard'});
			}
		}
	});
	</script>
</cfif>

<script>
	<cfif requiresApproval or showApprovalStatus>
		<cfset approvalRequest=rc.contentBean.getApprovalRequest()>
		<cfif not approvalRequest.getIsNew() and approvalRequest.getStatus() eq 'Pending'>
			var pendingApproval=true;
			var cancelPendingApproval=<cfoutput>'#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,"approvalchains.cancelPendingApproval"))#'</cfoutput>;
		<cfelse>
			var pendingApproval=false;
		</cfif>
	<cfelse>
		var pendingApproval=false;
	</cfif>
</script>

<cfset subtype=application.classExtensionManager.getSubTypeByName(rc.type,rc.contentBean.getSubType(),rc.siteid)>

<cfoutput>
	<script type="text/javascript">
		var hasSummary=#subType.getHasSummary()#;
		var hasBody=#subType.getHasBody()#;
	</script>
</cfoutput>

<cfsilent>
	<cfif rc.contentBean.getType() eq 'File'>
		<cfset rsFile=application.serviceFactory.getBean('fileManager').readMeta(rc.contentBean.getFileID())>
		<cfset fileExt=rsFile.fileExt>
	<cfelse>
		<cfset fileExt=''/>
	</cfif>

	<cfif listFindNoCase(extendedList,rc.type)>
		<cfset rsSubTypes=application.classExtensionManager.getSubTypes(siteID=rc.siteID,activeOnly=true) />

		<cfquery name="rsSubTypes" dbtype="query">
		select * from rsSubTypes
		where
			<cfif not len(subtypefilter) or not listFind(nodeLevelList,rc.type)>
				type in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#extendedList#"/>)
				or type='Base'
			<cfelse>
				1=1 AND
				<cfloop list="#subtypefilter#" index="i">
					<cfif i neq listFirst(subtypefilter)>
						OR
					</cfif>
					(
							type=<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#listFirst(i,'/')#"/>
							and subtype=<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#listLast(i,'/')#"/>
					)
				</cfloop>
			</cfif>
		</cfquery>

		<cfif listFindNoCase("Component,File,Link,Form,Variation",rc.type)>
			<cfset baseTypeList=rc.type>
		<cfelse>
			<cfset baseTypeList=pageLevelList>
		</cfif>

		<!--- If the node is new check to see if the parent type has a matching sub type. --->
		<cfif rc.contentBean.getIsNew() and structKeyExists(rc,"subType") and len(rc.subtype)>
			<cfset rc.contentBean.setSubType(rc.subtype)>

		</cfif>

		<cfif rsSubTypes.recordCount>
			<cfset isExtended=true/>
		<cfelse>
			<cfset isExtended=false/>
		</cfif>
	</cfif>

	<cfif ListFindNoCase(rc.$.getBean('contentManager').TreeLevelList,rc.type)>
		<cfset pluginEventMappings=duplicate($.getBean('pluginManager').getEventMappings(eventName='onContentEdit',siteid=rc.siteid))>
		<cfif arrayLen(pluginEventMappings)>
			<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
				<cfset pluginEventMappings[i].eventName='onContentEdit'>
			</cfloop>
		</cfif>
		<cfset pluginEventMappings2=duplicate($.getBean('pluginManager').getEventMappings(eventName='on#rc.type#Edit',siteid=rc.siteid))>
		<cfif arrayLen(pluginEventMappings2)>
			<cfloop from="1" to="#arrayLen(pluginEventMappings2)#" index="i">
				<cfset pluginEventMappings2[i].eventName='on#rc.type#Edit'>
				<cfset arrayAppend(pluginEventMappings,pluginEventMappings2[i])>
			</cfloop>
		</cfif>
	<cfelse>
		<cfset pluginEventMappings=$.getBean('pluginManager').getEventMappings(eventName='on#rc.type#Edit',siteid=rc.siteid)>
		<cfif arrayLen(pluginEventMappings)>
			<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
				<cfset pluginEventMappings[i].eventName='on#rc.type#Edit'>
			</cfloop>
		</cfif>
	</cfif>

	<!--- on{Type}{Subtype}Edit --->
	<cfif rc.contentBean.getSubType() neq 'Default'>
		<cfset pluginEventMappings3=duplicate($.getBean('pluginManager').getEventMappings(eventName='on#rc.type##rc.contentBean.getSubType()#Edit',siteid=rc.siteid))>
		<cfif arrayLen(pluginEventMappings3)>
			<cfloop from="1" to="#arrayLen(pluginEventMappings3)#" index="i">
				<cfset pluginEventMappings3[i].eventName='on#rc.type##rc.contentBean.getSubType()#Edit'>
				<cfset arrayAppend(pluginEventMappings,pluginEventMappings3[i])>
			</cfloop>
		</cfif>
	</cfif>

	<cfsavecontent variable="actionButtons">
	<cfoutput>
	<div class="mura-actions">
		<div class="form-actions">

			 <button type="button" class="btn" onclick="return saveDraftPrompt();"><i class="mi-edit"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#</button>

			<cfif listFindNoCase("Page,Folder,Calendar,Gallery",rc.type)>
			<button type="button" class="btn" onclick="document.contentForm.approved.value=0;document.contentForm.preview.value=1;if(siteManager.ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}"><i class="mi-eye"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraftandpreview"))#</button>
			</cfif>
			<cfif assignChangesets>

				<button type="button" class="btn<cfif (hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)) or len(rc.contentBean.getChangesetID())> mura-primary</cfif>" onclick="document.contentForm.approved.value=0;saveToChangeset('#rc.contentBean.getChangesetID()#','#esapiEncode('html',rc.siteID)#','');return false;">
					<cfif requiresApproval>
						<i class="mi-list-alt"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangesetandsendforapproval"))#
					<cfelse>
						<i class="mi-list-alt"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset"))#
					</cfif>
				</button>

				<!---
				<cfif not currentChangeset.getIsNew()>
					<button type="button" class="btn" onclick="document.contentForm.approved.value=0;document.contentForm.removePreviousChangeset.value='true';document.contentForm.changesetID.value='#rc.contentBean.getChangesetID()#';if(siteManager.ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}">
					<cfif requiresApproval>
						<i class="mi-list-alt"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetoexistingchangesetandsendforapproval"))#
					<cfelse>
						<i class="mi-list-alt"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetoexistingchangeset"))#
					</cfif>
					</button>
				</cfif>
				--->
			</cfif>
			<cfif rc.perm eq 'editor' and not $.siteConfig('EnforceChangesets')>
				<button type="button" class="btn<cfif not ((hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)) or len(rc.contentBean.getChangesetID()))> mura-primary</cfif>" onclick="document.contentForm.approved.value=1;if(siteManager.ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}">
					<cfif requiresApproval>
						<i class="mi-share-alt"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.sendforapproval"))#
					<cfelse>
						<i class="mi-check"></i> #esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#
					</cfif>
				</button>
			</cfif>
			</div>
		</div>

	</cfoutput>
	</cfsavecontent>
</cfsilent>

<!--- check to see if the site has reached it's maximum amount of pages --->
<cfif (rc.rsPageCount.counter lt application.settingsManager.getSite(rc.siteid).getpagelimit() and  rc.contentBean.getIsNew()) or not rc.contentBean.getIsNew()>
<cfoutput>
	<!--- mura-header --->
	<div class="mura-header">
	<cfif rc.type eq "Component">
		<cfif rc.contentBean.exists()>
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editcomponent")#</h1>
		<cfelse>
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.createcomponent")#</h1>
		</cfif>
	<cfelseif rc.type eq "Form">
		<cfif rc.contentBean.exists()>
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editform")#</h1>
		<cfelse>
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.createform")#</h1>
		</cfif>
	<cfelseif rc.type eq "Variation">
		<cfif rc.contentBean.exists()>
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editvariation")#</h1>
		<cfelse>
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.createvariation")#</h1>
		</cfif>
	<cfelse>
		<cfif rc.contentBean.exists()>
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editcontent")#</h1>
		<cfelse>
			<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.createcontent")#</h1>
		</cfif>
	</cfif>

	<!--- secondary menu --->
	<cfif rc.compactDisplay neq "true" or not listFindNoCase(nodeLevelList,rc.type)>
		<cfinclude template="dsp_secondary_menu.cfm">
	</cfif>

		<!--- metadata labels --->
	<cfif rc.compactDisplay neq "true">
	<div class="mura-item-metadata">
		<div class="label-group">
			<cfif not rc.contentBean.getIsNew()>



				<cfif listFindNoCase(rc.$.getBean('contentManager').TreeLevelList,rc.type)>
					<cfset rsRating=application.raterManager.getAvgRating(rc.contentBean.getcontentID(),rc.contentBean.getSiteID()) />
					<cfif rsRating.recordcount>
						<span class="label">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.votes")#: <strong><cfif rsRating.recordcount>#rsRating.theCount#<cfelse>0</cfif></strong></li>
						<span class="label">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.averagerating")#: <img id="ratestars" src="assets/images/rater/star_#application.raterManager.getStarText(rsRating.theAvg)#.gif" alt="#rsRating.theAvg# stars" border="0"></span>
					</cfif>
				</cfif>
			<cfif rc.type eq "file" and rc.contentBean.getMajorVersion()>
					<span class="label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#: <strong>#rc.contentBean.getMajorVersion()#.#rc.contentBean.getMinorVersion()#</strong></span>
			</cfif>
			</cfif>
			<span class="label">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.update")#: <strong>#LSDateFormat(parseDateTime(rc.contentBean.getlastupdate()),session.dateKeyFormat)# #LSTimeFormat(parseDateTime(rc.contentBean.getlastupdate()),"short")#</strong></span>
			<span class="label">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.status")#:
				<strong>

					<cfif not rc.contentBean.getIsNew()>
						<cfif rc.contentBean.getactive() gt 0 and rc.contentBean.getapproved() gt 0>
							<cfif len(rc.contentBean.getApprovalStatus())>
								<a href="##" onclick="return viewStatusInfo('#esapiEncode('javascript',rc.contentBean.getContentHistID())#','#esapiEncode('javascript',rc.contentBean.getSiteID())#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#</a>
							<cfelse>
								#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#
							</cfif>
						<cfelseif len(rc.contentBean.getApprovalStatus()) and (requiresApproval or showApprovalStatus) >
							<a href="##" onclick="return viewStatusInfo('#esapiEncode('javascript',rc.contentBean.getContentHistID())#','#esapiEncode('javascript',rc.contentBean.getSiteID())#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.#rc.contentBean.getApprovalStatus()#")#</a>
						<cfelseif rc.contentBean.getapproved() lt 1>
							<cfif len(rc.contentBean.getChangesetID())>
								#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.queued")#
							<cfelse>
								#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#
							</cfif>
						<cfelse>
							#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.archived")#
						</cfif>
					<cfelse>
						#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#
					</cfif>
				</strong>
			</span>
			<cfset started=false>
			<span class="label">
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#: <strong>#esapiEncode('html',rc.type)#</strong>
			</span>
		</div><!-- /.label-group -->
	</div><!-- /.mura-item-metadata -->

	</cfif>

	<!--- crumbdata --->
	<cfif rc.compactDisplay neq "true">
			#$.dspZoom(crumbdata=rc.crumbdata,class="breadcrumb")#
	</cfif>

</div> <!-- /.mura-header -->

<cfinclude template="dsp_status.cfm">

	<cfif not rc.contentBean.getIsNew()>


		<cfset draftcheck=application.contentManager.getDraftPromptData(rc.contentBean.getContentID(),rc.contentBean.getSiteID())>

		<cfif yesNoFormat(draftcheck.showdialog) and len(draftcheck.historyid) and draftcheck.historyid neq rc.contentBean.getContentHistID()>
			<div class="alert alert-info">
				<span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.inline')#: <strong><a href="./?#replace(cgi.query_string,'#rc.contentBean.getContentHistID()#','#draftcheck.historyid#')#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.gotolatest')#</a></strong></span>
			</div>
		</cfif>
	</cfif>

	<cfif hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)>
		<div class="alert alert-info">
			<span>
				<cfif pendingChangesets.recordcount>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnodenotify")#:<br>
				<ul class="alert-list">
				<cfloop query="pendingChangesets"><li><a href="?muraAction=cArch.edit&moduleID=#esapiEncode('url',rc.moduleID)#&siteID=#esapiEncode('url',rc.siteID)#&topID=#esapiEncode('url',rc.topID)#&contentID=#esapiEncode('url',rc.contentID)#&return=#esapiEncode('url',rc.return)#&contentHistID=#pendingChangesets.contentHistID#&parentID=#esapiEncode('url',rc.parentID)#&startrow=#esapiEncode('url',rc.startrow)#&type=#esapiEncode('url',rc.type)#&compactDisplay=#esapiEncode('url',rc.compactDisplay)#">#esapiEncode('html',pendingChangesets.changesetName)#</a></li></cfloop>
				</ul>
				</cfif>
				<cfif not currentChangeset.getIsNew()>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetversionnotify")#: <strong>#esapiEncode('html',currentChangeset.getName())#</strong></cfif>
			</span>
		</div>
	</cfif>

	<cfif len(rc.contentBean.getNotes())>
		<div class="alert alert-info">
			<span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.notes")#: #esapiEncode('html',rc.contentBean.getNotes())#</span>
		</div>
	</cfif>

	<!--- This is plugin message targeting --->
	<span id="msg">
	<cfif not listFindNoCase("Component,Form,Variation",rc.type)>#application.pluginManager.renderEvent("onContentEditMessageRender", pluginEvent)#</cfif>
	#application.pluginManager.renderEvent("on#rc.contentBean.getType()#EditMessageRender", pluginEvent)#
	#application.pluginManager.renderEvent("on#rc.contentBean.getType()##rc.contentBean.getSubType()#EditMessageRender", pluginEvent)#
	</span>

	</cfoutput>

	<cfset tabLabelList=""/>
	<cfset tabList="">
	<!--- set up tab content --->
	<cfsavecontent variable="tabContent">

		<cfif rc.type neq "Form">
			<cfinclude template="form/dsp_tab_basic.cfm">
		<cfelse>
			<cfif rc.contentBean.getIsNew() and not (isdefined("url.formType") and url.formType eq "editor")>
				<cfset rc.contentBean.setBody( application.serviceFactory.getBean('formBuilderManager').createJSONForm( rc.contentBean.getContentID() ) ) />
			</cfif>
			<cfif isJSON(rc.contentBean.getBody())>
				<cfinclude template="form/dsp_tab_formbuilder.cfm">
			<cfelse>
				<cfinclude template="form/dsp_tab_basic.cfm">
			</cfif>
		</cfif>

	<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Publishing')>
		<cfinclude template="form/dsp_tab_publishing.cfm">
	<cfelse>
		<input type="hidden" name="ommitPublishingTab" value="true">
		<cfoutput><input type="hidden" name="parentid" value="#esapiEncode('html_attr',rc.parentid)#"></cfoutput>
	</cfif>

		<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not rc.$.getContentRenderer().useLayoutManager() and listFindNoCase('Page,Folder,Gallery,Calender',rc.type) and (not len(tabAssignments) or listFindNocase(tabAssignments,'List Display Options')))>
			<cfinclude template="form/dsp_tab_listdisplayoptions.cfm">
		</cfif>

		<cfswitch expression="#rc.type#">
		<cfcase value="Page,Folder,Calendar,Gallery">
			<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Layout & Objects'))>
				<cfif listFind(session.mura.memberships,'S2IsPrivate')>
					<cfinclude template="form/dsp_tab_layoutobjects.cfm">
				</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
				<cfif application.categoryManager.getCategoryCount(rc.siteID)>
					<cfinclude template="form/dsp_tab_categories.cfm">
				</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
				<cfinclude template="form/dsp_tab_tags.cfm">
			</cfif>
			<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content'))>
				<cfinclude template="form/dsp_tab_related_content.cfm">
			<cfelse>
				<input type="hidden" name="ommitRelatedContentTab" value="true">
			</cfif>
		</cfcase>
		<cfcase value="Link,File">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
				<cfif application.categoryManager.getCategoryCount(rc.siteid)>
					<cfinclude template="form/dsp_tab_categories.cfm">
				</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
				<cfinclude template="form/dsp_tab_tags.cfm">
			</cfif>
			<cfif rc.moduleid eq '00000000000000000000000000000000000' and (not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content'))>
				<cfinclude template="form/dsp_tab_related_content.cfm">
			<cfelse>
				<input type="hidden" name="ommitRelatedContentTab" value="true">
			</cfif>
		</cfcase>
		<cfcase value="Variation">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
				<cfif application.categoryManager.getCategoryCount(rc.siteID)>
					<cfinclude template="form/dsp_tab_categories.cfm">
				</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
				<cfinclude template="form/dsp_tab_tags.cfm">
			</cfif>
		</cfcase>
		<cfcase value="Component">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
				<cfif application.categoryManager.getCategoryCount(rc.siteID)>
					<cfinclude template="form/dsp_tab_categories.cfm">
				</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
				<cfinclude template="form/dsp_tab_tags.cfm">
			</cfif>
			<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and (not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report'))>
				<cfif not rc.contentBean.getIsNew()>
					<cfinclude template="form/dsp_tab_usage.cfm">
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="Form">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
				<cfif application.categoryManager.getCategoryCount(rc.siteID)>
					<cfinclude template="form/dsp_tab_categories.cfm">
				</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Tags')>
				<cfinclude template="form/dsp_tab_tags.cfm">
			</cfif>
			<cfif application.configBean.getValue(property='showUsageTabs',defaultValue=true) and (not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report'))>
				<cfif not rc.contentBean.getIsNew()>
					<cfinclude template="form/dsp_tab_usage.cfm">
				</cfif>
			</cfif>
		</cfcase>
	</cfswitch>

	<cfif listFindNoCase(rc.$.getBean('contentManager').ExtendableList,rc.type)>
		<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Extended Attributes')>
			<cfset extendSets=application.classExtensionManager.getSubTypeByName(rc.type,rc.contentBean.getSubType(),rc.siteid).getExtendSets(activeOnly=true) />
			<cfinclude template="form/dsp_tab_extended_attributes.cfm">
		</cfif>
	</cfif>

	<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Advanced')>
		<cfif listFind(session.mura.memberships,'S2IsPrivate')>
			<cfinclude template="form/dsp_tab_advanced.cfm">
		<cfelse>
			<input type="hidden" name="ommitAdvancedTab" value="true">
		</cfif>
	</cfif>

	<cfif arrayLen(pluginEventMappings)>
		<cfoutput>
			<cfset renderedEvents = '' />
			<cfset eventIdx = 0 />
			<cfloop from="1" to="#arrayLen(pluginEventMappings)#" index="i">
				<cfset eventToRender = pluginEventMappings[i].eventName />

				<cfif ListFindNoCase(renderedEvents, eventToRender)>
					<cfset eventIdx++ />
				<cfelse>
					<cfset renderedEvents = ListAppend(renderedEvents, eventToRender) />
					<cfset eventIdx=1 />
				</cfif>

				<cfset renderedEvent=$.getBean('pluginManager').renderEvent(eventToRender=eventToRender,currentEventObject=$,index=eventIdx)>
				<cfif len(trim(renderedEvent))>
					<cfset tabLabel = Len($.event('tabLabel')) && !ListFindNoCase(tabLabelList, $.event('tabLabel')) ? $.event('tabLabel') : pluginEventMappings[i].pluginName />
					<cfset tabLabelList=listAppend(tabLabelList, tabLabel)/>
					<cfset tabID="tab" & $.createCSSID(tabLabel)>
					<cfif ListFind(tabList,tabID)>
						<cfset tabID = tabID & i />
					</cfif>
					<cfset tabList=listAppend(tabList,tabID)>
					<cfset pluginEvent.setValue("tabList",tabLabelList)>
					<div id="#tabID#" class="tab-pane">
						<div class="block block-bordered">
							<div class="block-header">
						<h3 class="block-title">#tabLabel#</h3>
							</div>
							<!-- /block header -->

						  	<!-- block content -->
						  	<div class="block-content">
								#renderedEvent#
							</div>
						</div>
					</div>
				</cfif>
			</cfloop>
		</cfoutput>
	</cfif>

	</cfsavecontent>
	<!--- /tabcontent --->

	<cfoutput>
		<cfif rc.contentBean.exists() and rc.compactDisplay eq "true" and not ListFindNoCase(nodeLevelList & ",Variation",rc.type)>
			<div class="alert alert-info">
				<span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.globallyappliednotice")#</span>
			</div>
		</cfif>

		<cfif not structIsEmpty(rc.contentBean.getErrors())>
			<div class="alert alert-error"><span>#application.utility.displayErrors(rc.contentBean.getErrors())#</span></div>
		</cfif>
	</cfoutput>

	<form novalidate="novalidate" action="index.cfm" method="post" enctype="multipart/form-data" name="contentForm" onsubmit="return ckContent(draftremovalnotice);" id="contentForm">

	<!--- start output --->
	<cfoutput>



	<div class="block block-constrain">

	<!-- tabs -->
		<ul class="mura-tabs nav-tabs" data-toggle="tabs">
			<cfloop from="1" to="#listlen(tabList)#" index="t">
			<cfset currentTab=listGetAt(tabList,t)>
			<li<cfif listFindNoCase("tabExtendedAttributes,tabListDisplayOptions",currentTab)> class="hide"<cfelseif t eq 1> class="active"</cfif>  id="#currentTab#LI"><a href="###currentTab#"><span>#listGetAt(tabLabelList,t)#</span></a></li>
			</cfloop>
		</ul>

		<!-- tab content -->
		<div class="block-content tab-content">
			#tabContent#

			<div class="load-inline tab-preloader"></div>

			<script>
				$(function(){
					$('.tab-preloader').spin(spinnerArgs2);
					<cfif rc.compactDisplay eq 'true'>
					//This is a hack to prevent ckeditor bug that sets iframe width to zero when goin to extended attributes and back
					$('a[href="##tabBasic"]').on('click',function(){
						$('##tabBasic').find('.cke_wysiwyg_frame').width('100%');
					});
					</cfif>
				});
			</script>

		</div><!-- /block-content tab content -->
		#actionButtons#
	</div><!-- /.block-constrain -->

	<cfif assignChangesets>
		<cfinclude template="form/dsp_changesets.cfm">
	</cfif>


<script type="text/javascript">

<cfif listFindNoCase("Page,Folder,Calendar,Gallery,Link,File,Component,Form",rc.contentBean.getType())>
	siteManager.tablist='#esapiEncode('javascript',lcase(tabList))#';
	siteManager.loadExtendedAttributes('#rc.contentBean.getcontentID()#','#rc.contentbean.getcontentHistID()#','#rc.type#','#rc.contentBean.getSubType()#','#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');
</cfif>

saveDraftPrompt=function(){
	confirmDialog(
		'#esapiEncode('html',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.keepeditingconfirm"))#',
		function(){
			if(siteManager.ckContent(draftremovalnotice,true)){
				document.contentForm.approved.value=0;
				document.contentForm.preview.value=0;
				document.contentForm.murakeepediting.value=true;
				submitForm(document.contentForm,'add');
			}
		},
		function(){
			if(siteManager.ckContent(draftremovalnotice,true)){
				document.contentForm.approved.value=0;
				document.contentForm.preview.value=0;
				document.contentForm.murakeepediting.value=false;
				submitForm(document.contentForm,'add');
			}
		},
		'','','Yes','No'
	);
}

	var shifted=false;
	var lockedbysomeonelse=false;

	checkForSave=function(e) {
  	if (e.keyCode == 83 && (navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey)) {
    	e.preventDefault();
	   	if(!lockedbysomeonelse){
	   		if(e.altKey){
				document.contentForm.approved.value=1;
			} else {
				document.contentForm.approved.value=0;
			}

			if(e.shiftKey){
				document.contentForm.preview.value=1;
			} else {
				document.contentForm.preview.value=0;
			}

			<cfif rc.compactDisplay neq 'true'>
			document.contentForm.murakeepediting.value=true;
			</cfif>

		    if(siteManager.ckContent(draftremovalnotice,true)){
				submitForm(document.contentForm,'add');
			} else {
				document.contentForm.approved.value=0;
				document.contentForm.murakeepediting.value=false;
				document.contentForm.preview.value=0;
				document.contentForm.approved.value=0;
			}

		}
	}
}

//This will throw an error under crossdomain
try{
	window.top.document.addEventListener("keydown", checkForSave , false);
} catch (e){};
</script>
	<input name="approved" type="hidden" value="0">
	<input name="muraPreviouslyApproved" type="hidden" value="#rc.contentBean.getApproved()#">
	<input id="removePreviousChangeset" name="removePreviousChangeset" type="hidden" value="false">
	<input id="changesetID" name="changesetID" type="hidden" value="">
	<input id="changesetname" name="changesetname" type="hidden" value="">
	<input name="preview" type="hidden" value="0">
	<cfif rc.type neq 'Link'>
		<input name="filename" type="hidden" value="#rc.contentBean.getfilename()#">
	</cfif>
	<cfif not rc.contentBean.getIsNew()>
		<input name="lastupdate" type="hidden" value="#LSDateFormat(rc.contentBean.getlastupdate(),session.dateKeyFormat)#">
	</cfif>
	<cfif rc.contentid eq '00000000000000000000000000000000001'>
		<input name="isNav" type="hidden" value="1">
	</cfif>
	<cfif rc.type eq 'Form'>
		<input name="responseDisplayFields" type="hidden" value="#rc.contentBean.getResponseDisplayFields()#">
	</cfif>
	<input name="action" type="hidden" value="add">
	<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
	<input type="hidden" name="moduleid" value="#esapiEncode('html_attr',rc.moduleid)#">
	<input type="hidden" name="contenthistid" value="#rc.contentBean.getContentHistID()#">
	<input type="hidden" name="return" value="#esapiEncode('html_attr',rc.return)#">
	<input type="hidden" name="topid" value="#esapiEncode('html_attr',rc.topid)#">
	<input type="hidden" name="contentid" value="#rc.contentBean.getContentID()#">
	<input type="hidden" name="ptype" value="#esapiEncode('html_attr',rc.ptype)#">
	<input type="hidden" name="type" value="#esapiEncode('html_attr',rc.type)#">
	<input type="hidden" name="subtype" value="#rc.contentBean.getSubType()#">
	<input type="hidden" name="muraAction" value="cArch.update">
	<input type="hidden" name="startrow" value="#esapiEncode('html_attr',rc.startrow)#">
	<input type="hidden" name="returnURL" id="txtReturnURL" value="#rc.returnURL#">
	<input type="hidden" name="homeID" value="#esapiEncode('html_attr',rc.homeID)#">
	<input type="hidden" name="cancelpendingapproval" value="false">
	<input type="hidden" name="murakeepediting" value="false">
	<input type="hidden" name="filemetadataassign" id="filemetadataassign" value=""/>
	<input type="hidden" id="unlocknodewithpublish" name="unlocknodewithpublish" value="false" />
	<cfif not  listFind(session.mura.memberships,'S2')>
		<input type="hidden" name="isLocked" value="#rc.contentBean.getIsLocked()#">
	</cfif>
	<input name="OrderNo" type="hidden" value="<cfif rc.contentBean.getorderno() eq ''>0<cfelse>#rc.contentBean.getOrderNo()#</cfif>">
	<input type="hidden" name="closeCompactDisplay" value="#esapiEncode('html_attr',rc.compactDisplay)#" />
	<input type="hidden" name="compactDisplay" value="#esapiEncode('html_attr',rc.compactDisplay)#" />
	<input type="hidden" name="instanceid" value="#esapiEncode('html_attr',rc.instanceid)#" />
	<input type="hidden" name="parenthistid" value="#esapiEncode('html_attr',rc.parenthistid)#" />

	#rc.$.renderCSRFTokens(context=rc.contentBean.getContentHistID() & "add",format="form")#

	</cfoutput>
	</form>

<cfelse>
	<div>
		<cfinclude template="form/dsp_full.cfm">
	</div>
</cfif>
