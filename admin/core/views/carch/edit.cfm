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
<cfset event=request.event>
<cfinclude template="js.cfm">
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
<cfset pageLevelList="Page,Folder,Calendar,Gallery"/>
<cfset extendedList="Page,Folder,Calendar,Gallery,Link,File,Component"/>
<cfset isExtended=false>
<cfset nodeLevelList="Page,Folder,Calendar,Gallery,Link,File"/>
<cfset hasChangesets=application.settingsManager.getSite(rc.siteID).getHasChangesets()>
<cfset rc.perm=application.permUtility.getnodePerm(rc.crumbdata)>
<cfif rc.parentID eq "" and not rc.contentBean.getIsNew()>
	<cfset rc.parentID=rc.contentBean.getParentID()>	
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
var draftremovalnotice=<cfif application.configBean.getPurgeDrafts() and event.getValue("suppressDraftNotice") neq "true" and rc.contentBean.hasDrafts()><cfoutput>'#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draftremovalnotice"))#'</cfoutput><cfelse>""</cfif>;
</script>
<cfif rc.compactDisplay neq "true" and application.configBean.getConfirmSaveAsDraft()><script>
siteManager.requestedURL="";
siteManager.formSubmitted=false;
<cfoutput>
function setRequestedURL(){
	siteManager.requestedURL=this.href
	return conditionalExit("#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#");
}</cfoutput>

$(document).ready(function(){
	var anchors=document.getElementsByTagName("A");
	
	for(var i=0;i<anchors.length;i++){	
		if (typeof(anchors[i].onclick) != 'function' 
			&& typeof(anchors[i].getAttribute('href')) == 'string' 
			&& anchors[i].getAttribute('href').indexOf('#') == -1) {
   			anchors[i].onclick = setRequestedURL;
		}
	}
	
});

$(document).unload(function(){
	if(!siteManager.formSubmitted && siteManager.requestedURL != '')
	{
		conditionalExit();
	}
});

function conditionalExit(msg){
	if(siteManager.form_is_modified(document.contentForm)){
	if(msg==null){
		<cfoutput>msg="#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#";</cfoutput>
	}
	jQuery("#alertDialog").html(msg);
	jQuery("#alertDialog").dialog({
			resizable: false,
			modal: true,
			position: getDialogPosition(),
			buttons: {
				'Yes': function() {
					jQuery(this).dialog('close');
					if(siteManager.ckContent()){
						document.getElementById('contentForm').returnURL.value=siteManager.requestedURL;
						submitForm(document.contentForm,'add');
						}
						return false;
					},
				'No': function() {
					jQuery(this).dialog('close');
					location.href=siteManager.requestedURL;
					siteManager.requestedURL="";
				}
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
		<!---
		<cfif rc.compactDisplay neq "true" and listFindNoCase("#pageLevelList#",rc.type)>
		--->	
			<cfquery name="rsSubTypes" dbtype="query">
			select * from rsSubTypes
			where 
				type in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#extendedList#"/>)
				or type='Base'
			</cfquery>
		<!---
		<cfelse>
			<cfquery name="rsSubTypes" dbtype="query">
			select * from rsSubTypes
			where 
				type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.type#"/>
				<!---<cfif listFindNocase("Link,File",rc.type)>--->
					or type='Base'
				<!---</cfif>--->
			</cfquery>
		</cfif>
		--->
		<cfif listFindNoCase("Component,File,Link",rc.type)>
			<cfset baseTypeList=rc.type>
		<cfelse>
			<cfset baseTypeList=pageLevelList>
		</cfif>
		
		<!--- If the node is new check to see if the parent type has a matching sub type. --->
		<cfif rc.contentBean.getIsNew() and structKeyExists(rc,"subType") and len(rc.subtype)>
			<cfset rc.contentBean.setSubType(rc.subtype)>
		<!---
		<cfelseif rc.contentBean.getIsNew()>
			<cfquery name="rsParentSubType" dbtype="query">
			select * from rsSubTypes
			where 
			type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.type#"/>
			and subtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#$.getBean('content').loadBy(contentID=rc.parentID, siteID=rc.siteID).getSubType()#"/>
			</cfquery>
			<cfif rsParentSubType.recordcount>
				<cfset rc.contentBean.setSubType(rsParentSubType.subType)>
			</cfif>
		--->
		</cfif>
		
		<cfif rsSubTypes.recordCount>
			<cfset isExtended=true/>
		<cfelse>
			<cfset isExtended=false/>
		</cfif>
	</cfif>
	
	<cfif  ListFindNoCase("Page,Folder,Calendar,Link,File,Gallery",rc.type)>
	<cfset rsPluginScripts1=application.pluginManager.getScripts("onContentEdit",rc.siteID)>
	<cfset rsPluginScripts2=application.pluginManager.getScripts("on#rc.type#Edit",rc.siteID)>
	<cfquery name="rsPluginScripts3" dbtype="query">
	select * from rsPluginScripts1 
	union
	select * from rsPluginScripts2 
	</cfquery>
	<cfquery name="rsPluginScripts" dbtype="query">
	select * from rsPluginScripts3 order by pluginID
	</cfquery>
	<cfelse>
	<cfset rsPluginScripts=application.pluginManager.getScripts("on#rc.type#Edit",rc.siteID)>
	</cfif>

	<cfsavecontent variable="actionButtons">
	<cfoutput>
	<div class="form-actions">
	
		 <button type="button" class="btn" onclick="if(siteManager.ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}"><i class="icon-check"></i> #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#</button>
		<cfif listFindNoCase("Page,Folder,Calendar,Gallery",rc.type)>
		<button type="button" class="btn" onclick="document.contentForm.preview.value=1;if(siteManager.ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}"><i class="icon-eye-open"></i> #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraftandpreview"))#</button>
		</cfif>
		<cfif assignChangesets>
		<button type="button" class="btn" onclick="saveToChangeset('#rc.contentBean.getChangesetID()#','#HTMLEditFormat(rc.siteID)#','');return false;"><i class="icon-check"></i> #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset"))#</button>	
		</cfif>
		<cfif rc.perm eq 'editor' and not $.siteConfig('EnforceChangesets')>
		<button type="button" class="btn" onclick="document.contentForm.approved.value=1;if(siteManager.ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}"><i class="icon-check"></i> #HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#</button>
		</cfif> 
	</div>
	</cfoutput>
	</cfsavecontent>
</cfsilent>

<!--- check to see if the site has reached it's maximum amount of pages --->
<cfif (rc.rsPageCount.counter lt application.settingsManager.getSite(rc.siteid).getpagelimit() and  rc.contentBean.getIsNew()) or not rc.contentBean.getIsNew()>
<cfoutput>
	<cfif rc.type eq "Component">
		<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editcomponent")#</h1>
	<cfelseif rc.type eq "Form">
		<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editform")#</h1>
	<cfelse>
		<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editcontent")#</h1>
	</cfif>
	
	<cfif rc.compactDisplay neq "true">
		<ul class="metadata-horizontal">
			<cfif not rc.contentBean.getIsNew()>
				<cfif listFindNoCase('Page,Folder,Calendar,Gallery,Link,File',rc.type)>
					<cfset rsRating=application.raterManager.getAvgRating(rc.contentBean.getcontentID(),rc.contentBean.getSiteID()) />
					<cfif rsRating.recordcount>
					<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.votes")#: <strong><cfif rsRating.recordcount>#rsRating.theCount#<cfelse>0</cfif></strong></li>
					<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.averagerating")#: <img id="ratestars" src="assets/images/rater/star_#application.raterManager.getStarText(rsRating.theAvg)#.gif" alt="#rsRating.theAvg# stars" border="0"></li>
					</cfif>
				</cfif>
			<cfif rc.type eq "file" and rc.contentBean.getMajorVersion()>
					<li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#: <strong>#rc.contentBean.getMajorVersion()#.#rc.contentBean.getMinorVersion()#</strong></li>
			</cfif>
			</cfif>
			<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.update")#: <strong>#LSDateFormat(parseDateTime(rc.contentBean.getlastupdate()),session.dateKeyFormat)# #LSTimeFormat(parseDateTime(rc.contentBean.getlastupdate()),"short")#</strong></li>
			<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.status")#: <strong><cfif not rc.contentBean.getIsNew()><cfif rc.contentBean.getactive() gt 0 and rc.contentBean.getapproved() gt 0>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#<cfelseif rc.contentBean.getapproved() lt 1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#<cfelse>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.archived")#</cfif><cfelse>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#</cfif></strong></li>
			<cfset started=false>
			<li>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#: <strong>#HTMLEditFormat(rc.type)#</strong>
			</li>
		</ul>
	</cfif>
	
	<cfif rc.compactDisplay neq "true" or not listFindNoCase(nodeLevelList,rc.type)>	
		<cfinclude template="dsp_secondary_menu.cfm">
	</cfif>
	
	<cfif rc.compactDisplay eq "true" and not ListFindNoCase(nodeLevelList,rc.type)>
		<p class="alert">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.globallyappliednotice")#</p>
	</cfif>
	
	<cfif not rc.contentBean.getIsNew()>
		<cfset draftcheck=application.contentManager.getDraftPromptData(rc.contentBean.getContentID(),rc.contentBean.getSiteID())>
		
		<cfif yesNoFormat(draftcheck.showdialog) and draftcheck.historyid neq rc.contentBean.getContentHistID()>
			<p class="alert">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.inline')#: <strong><a href="./?#replace(cgi.query_string,'#rc.contentBean.getContentHistID()#','#draftcheck.historyid#')#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.gotolatest')#</a></strong>
			<p>
		</cfif>
	</cfif>
	
	<cfif hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)>
		<p class="alert">
		<cfif pendingChangesets.recordcount>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnodenotify")#: 
		<cfloop query="pendingChangesets"><a href="?muraAction=cArch.edit&moduleID=#URLEncodedFormat(rc.moduleID)#&siteID=#URLEncodedFormat(rc.siteID)#&topID=#URLEncodedFormat(rc.topID)#&contentID=#URLEncodedFormat(rc.contentID)#&return=#URLEncodedFormat(rc.return)#&contentHistID=#pendingChangesets.contentHistID#&parentID=#URLEncodedFormat(rc.parentID)#&startrow=#URLEncodedFormat(rc.startrow)#&type=#URLEncodedFormat(rc.type)#&compactDisplay=#URLEncodedFormat(rc.compactDisplay)#"><strong>#HTMLEditFormat(pendingChangesets.changesetName)#</strong></a><cfif pendingChangesets.currentrow lt pendingChangesets.recordcount>, </cfif></cfloop><br/></cfif>
		<cfif not currentChangeset.getIsNew()>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetversionnotify")#: <strong>#HTMLEditFormat(currentChangeset.getName())#</strong></cfif>
		</p>
	</cfif>

	<cfif len(rc.contentBean.getNotes())>
		<p class="alert">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.notes")#: #HTMLEditFormat(rc.contentBean.getNotes())#</p>
	</cfif>

	<cfif not structIsEmpty(rc.contentBean.getErrors())>
		<div class="alert alert-error">#application.utility.displayErrors(rc.contentBean.getErrors())#</div>
	</cfif>

	<form novalidate="novalidate" action="index.cfm" method="post" enctype="multipart/form-data" name="contentForm" onsubmit="return ckContent(draftremovalnotice);" id="contentForm">
	
	<!--- This is plugin message targeting --->	
	<span id="msg">
	<cfif not listFindNoCase("Component,Form",rc.type)>#application.pluginManager.renderEvent("onContentEditMessageRender", pluginEvent)#</cfif>
	#application.pluginManager.renderEvent("on#rc.contentBean.getType()#EditMessageRender", pluginEvent)#
	#application.pluginManager.renderEvent("on#rc.contentBean.getType()##rc.contentBean.getSubType()#EditMessageRender", pluginEvent)#
	</span>

	<cfif rc.compactDisplay neq "true" and rc.moduleid eq '00000000000000000000000000000000000'>
		#application.contentRenderer.dspZoom(crumbdata=rc.crumbdata,class="navZoom alt")#
	</cfif>
	
	</cfoutput>
	
	<cfset tabLabelList=""/>
	<cfset tabList="">
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
		
		<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'SEO')>
			<cfinclude template="form/dsp_tab_seo.cfm">
			</cfif>	
			<cfif  not len(tabAssignments) or listFindNocase(tabAssignments,'Mobile')>
				<cfinclude template="form/dsp_tab_mobile.cfm">
			</cfif>	
		</cfif>

		<cfif listFindNoCase('Folder,Gallery,Calender',rc.type) and (not len(tabAssignments) or listFindNocase(tabAssignments,'List Display Options'))>
				<cfinclude template="form/dsp_tab_listdisplayoptions.cfm">
		</cfif>	
		
		<cfswitch expression="#rc.type#">
		<cfcase value="Page,Folder,Calendar,Gallery">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Layout & Objects')>
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
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content')>
			<cfinclude template="form/dsp_tab_related_content.cfm">
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
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content')>
			<cfinclude template="form/dsp_tab_related_content.cfm">
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
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report')>
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
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report')>
			<cfif not rc.contentBean.getIsNew()>
			<cfinclude template="form/dsp_tab_usage.cfm">
			</cfif>
			</cfif>
		</cfcase>
	</cfswitch>
	
	<cfswitch expression="#rc.type#">
		<cfcase value="Page,Folder,Calendar,Gallery,Link,File,Component">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Extended Attributes')>
			<cfset extendSets=application.classExtensionManager.getSubTypeByName(rc.type,rc.contentBean.getSubType(),rc.siteid).getExtendSets(activeOnly=true) />
			<cfinclude template="form/dsp_tab_extended_attributes.cfm">
			</cfif>
		</cfcase>
	</cfswitch>
		
	<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Advanced')>
		<cfif listFind(session.mura.memberships,'S2IsPrivate')>
		<cfinclude template="form/dsp_tab_advanced.cfm">
		</cfif> 
	</cfif>

		<cfoutput query="rsPluginScripts" group="pluginID">
			<!---<cfset tabLabelList=tabLabelList & ",'#jsStringFormat(rsPluginScripts.name)#'"/>--->
			<cfset tabLabelList=listAppend(tabLabelList,rsPluginScripts.name)/>
			<cfset tabID="tab" & application.contentRenderer.createCSSID(rsPluginScripts.name)>
			<cfset tabList=listAppend(tabList,tabID)>
			<cfset pluginEvent.setValue("tabList",tabLabelList)>
				<div id="#tabID#" class="tab-pane fade">
				<cfoutput>
				<cfset rsPluginScript=application.pluginManager.getScripts("onContentEdit",rc.siteID,rsPluginScripts.moduleID)>
				<cfif rsPluginScript.recordcount>
				#application.pluginManager.renderScripts("onContentEdit",rc.siteid,pluginEvent,rsPluginScript)#
				<cfelse>
				<cfset rsPluginScript=application.pluginManager.getScripts("on#rc.type#Edit",rc.siteID,rsPluginScripts.moduleID)>
				#application.pluginManager.renderScripts("on#rc.type#Edit",rc.siteid,pluginEvent,rsPluginScript)#
				</cfif>
				</cfoutput>
				</div>
		</cfoutput>



	<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Publishing')>
		<cfinclude template="form/dsp_tab_publishing.cfm">
	</cfif>
	</cfsavecontent>
	<cfoutput>
	
	<div class="tabbable tabs-left">
		<ul class="nav nav-tabs tabs initActiveTab">
			<cfloop from="1" to="#listlen(tabList)#" index="t">
			<cfset currentTab=listGetAt(tabList,t)>
			<li<cfif currentTab eq "tabExtendedAttributes"> class="hide" id="tabExtendedAttributesLI"</cfif>><a href="###currentTab#" data-toggle="tab"><span>#listGetAt(tabLabelList,t)#</span></a></li>
			</cfloop>
		</ul>
		<div class="tab-content row-fluid">		
			#tabContent#
			<div class="load-inline tab-preloader"></div>
			#actionButtons#
		</div>
	</div>


	<cfif assignChangesets>
		<cfinclude template="form/dsp_changesets.cfm">
	</cfif>
	
	<cfif listFindNoCase("Page,Folder,Calendar,Gallery,Link,File,Component",rc.contentBean.getType())>
		<script type="text/javascript">
		siteManager.tablist='#JSStringFormat(lcase(tabList))#';
		siteManager.loadExtendedAttributes('#rc.contentbean.getcontentHistID()#','#rc.type#','#rc.contentBean.getSubType()#','#rc.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#');
		</script>
	</cfif>

	<input name="approved" type="hidden" value="0">
	<input name="muraPreviouslyApproved" type="hidden" value="#rc.contentBean.getApproved()#">
	<input id="removePreviousChangeset" name="removePreviousChangeset" type="hidden" value="false">
	<input id="changesetID" name="changesetID" type="hidden" value="">
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
	<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
	<input type="hidden" name="moduleid" value="#rc.moduleid#">
	<input type="hidden" name="contenthistid" value="#rc.contentBean.getContentHistID()#">
	<input type="hidden" name="return" value="#rc.return#">
	<input type="hidden" name="topid" value="#rc.topid#">
	<input type="hidden" name="contentid" value="#rc.contentBean.getContentID()#">
	<input type="hidden" name="ptype" value="#rc.ptype#">
	<input type="hidden" name="type" value="#rc.type#">
	<input type="hidden" name="subtype" value="#rc.contentBean.getSubType()#">
	<input type="hidden" name="muraAction" value="cArch.update">
	<input type="hidden" name="startrow" value="#rc.startrow#">
	<input type="hidden" name="returnURL" id="txtReturnURL" value="#rc.returnURL#">
	<input type="hidden" name="homeID" value="#rc.homeID#">
	<cfif not  listFind(session.mura.memberships,'S2')>
		<input type="hidden" name="isLocked" value="#rc.contentBean.getIsLocked()#">
	</cfif>
	<input name="OrderNo" type="hidden" value="<cfif rc.contentBean.getorderno() eq ''>0<cfelse>#rc.contentBean.getOrderNo()#</cfif>">
	<input type="hidden" name="closeCompactDisplay" value="#HTMLEditFormat(rc.compactDisplay)#" />
	<input type="hidden" name="compactDisplay" value="#HTMLEditFormat(rc.compactDisplay)#" />	
	</cfoutput>
	</form>
<cfelse>
	<div>
		<cfinclude template="form/dsp_full.cfm">
	</div>
</cfif>