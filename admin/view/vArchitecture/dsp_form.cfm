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
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
<cfset pageLevelList="Page,Portal,Calendar,Gallery"/>
<cfset extendedList="Page,Portal,Calendar,Gallery,Link,File,Component"/>
<cfset nodeLevelList="Page,Portal,Calendar,Gallery,Link,File"/>
<cfset hasChangesets=application.settingsManager.getSite(attributes.siteID).getHasChangesets() and listFindNoCase("Page,Portal,Calendar,Gallery,File,Link",attributes.type)>
<cfset request.perm=application.permUtility.getnodePerm(request.crumbdata)>
<cfif attributes.parentID eq "" and not request.contentBean.getIsNew()>
	<cfset attributes.parentID=request.contentBean.getParentID()>	
 </cfif>
<cfif hasChangesets>
<cfset currentChangeset=application.changesetManager.read(request.contentBean.getChangesetID())>
<cfset pendingChangesets=application.changesetManager.getPendingByContentID(request.contentBean.getContentID(),attributes.siteID)>
</cfif>
<cfset request.deletable=attributes.compactDisplay neq "true" and ((attributes.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all') or (attributes.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(attributes.siteid).getLocking() eq 'none')) and (request.perm eq 'editor' and attributes.contentid neq '00000000000000000000000000000000001') and request.contentBean.getIsLocked() neq 1>
<cfset assignChangesets=request.perm eq 'editor' and hasChangesets>
<cfset $=event.getValue("MuraScope")>
<cfset tabAssignments=$.getBean("user").loadBy(userID=session.mura.userID, siteID=session.mura.siteID).getContentTabAssignments()>
<script>
var draftremovalnotice=<cfif application.configBean.getPurgeDrafts() and event.getValue("suppressDraftNotice") neq "true" and request.contentBean.hasDrafts()><cfoutput>'#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draftremovalnotice"))#'</cfoutput><cfelse>""</cfif>;
</script>
<cfif attributes.compactDisplay neq "true" and application.configBean.getConfirmSaveAsDraft()><script>
var requestedURL="";
var formSubmitted=false;
onload=function(){
	var anchors=document.getElementsByTagName("A");
	
	for(var i=0;i<anchors.length;i++){		
		if (typeof anchors[i].onclick != 'function') {
   			anchors[i].onclick = setRequestedURL;
		}
	}
	
}

onunload=function(){
	if(!formSubmitted && requestedURL != '')
	{
		conditionalExit();
	}
}

function conditionalExit(msg){
	if(form_is_modified(document.contentForm)){
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
					if(ckContent()){
						document.getElementById('contentForm').returnURL.value=requestedURL;
						submitForm(document.contentForm,'add');
						}
						return false;
					},
				'No': function() {
					jQuery(this).dialog('close');
					location.href=requestedURL;
					requestedURL="";
				}
			}
		});
	
		return false;	
		
	} else {
		requestedURL="";
		return true;	
	}

}
<cfoutput>
function setRequestedURL(){
	requestedURL=this.href
	return conditionalExit("#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.saveasdraft"))#");
}</cfoutput>
</script>
<cfelseif attributes.compactDisplay eq "true">
<script type="text/javascript">
jQuery(document).ready(function(){
	if (top.location != self.location) {
		if(jQuery("##ProxyIFrame").length){
			jQuery("##ProxyIFrame").load(
				function(){
					frontEndProxy.postMessage("cmd=setWindowMode&mode=standard");
				}
			);	
		} else {
			frontEndProxy.postMessage("cmd=setWindowMode&mode=standard");
		}
	}
});
</script>
</cfif> 

<cfsilent>
	<cfif request.contentBean.getType() eq 'File'>
	<cfset rsFile=application.serviceFactory.getBean('fileManager').readMeta(request.contentBean.getFileID())>
	<cfset fileExt=rsFile.fileExt>
	<cfelse>
	<cfset fileExt=''/>
	</cfif>
	<cfif listFindNoCase(extendedList,attributes.type)>
		<cfset rsSubTypes=application.classExtensionManager.getSubTypes(siteID=attributes.siteID,activeOnly=true) />
		<cfif attributes.compactDisplay neq "true" and listFindNoCase("#pageLevelList#",attributes.type)>
			<cfquery name="rsSubTypes" dbtype="query">
			select * from rsSubTypes
			where type in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#pageLevelList#"/>)
			</cfquery>
		<cfelse>
			<cfquery name="rsSubTypes" dbtype="query">
			select * from rsSubTypes
			where type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.type#"/>
			</cfquery>
		</cfif>
		<cfif listFindNoCase("Component,File,Link",attributes.type)>
			<cfset baseTypeList=attributes.type>
		<cfelse>
			<cfset baseTypeList=pageLevelList>
		</cfif>
		
		<!--- If the node is new check to see if the parent type has a matching sub type. --->
		<cfif request.contentBean.getIsNew()>
			<cfquery name="rsParentSubType" dbtype="query">
			select * from rsSubTypes
			where 
			type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.type#"/>
			and subtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#$.getBean('content').loadBy(contentID=attributes.parentID, siteID=attributes.siteID).getSubType()#"/>
			</cfquery>
			<cfif rsParentSubType.recordcount>
				<cfset request.contentBean.setSubType(rsParentSubType.subType)>
			</cfif>
		</cfif>
		
		<cfif rsSubTypes.recordCount>
			<cfset isExtended=true/>
		<cfelse>
			<cfset isExtended=false/>
		</cfif>
	</cfif>
	
	<cfif  ListFindNoCase("Page,Portal,Calendar,Link,File,Gallery",attributes.type)>
	<cfset rsPluginScripts1=application.pluginManager.getScripts("onContentEdit",attributes.siteID)>
	<cfset rsPluginScripts2=application.pluginManager.getScripts("on#attributes.type#Edit",attributes.siteID)>
	<cfquery name="rsPluginScripts3" dbtype="query">
	select * from rsPluginScripts1 
	union
	select * from rsPluginScripts2 
	</cfquery>
	<cfquery name="rsPluginScripts" dbtype="query">
	select * from rsPluginScripts3 order by pluginID
	</cfquery>
	<cfelse>
	<cfset rsPluginScripts=application.pluginManager.getScripts("on#attributes.type#Edit",attributes.siteID)>
	</cfif>
</cfsilent>

<!--- check to see if the site has reached it's maximum amount of pages --->
<cfif (request.rsPageCount.counter lt application.settingsManager.getSite(attributes.siteid).getpagelimit() and  attributes.contentid eq '') or attributes.contentid neq ''>
<cfoutput>
	<cfif attributes.type eq "Component">
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editcomponent")#</h2>
	<cfelseif attributes.type eq "Form">
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editform")#</h2>
	<cfelse>
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.editcontent")#</h2>
	</cfif>
	
	<cfif attributes.compactDisplay neq "true">
	<ul class="metadata">
		<cfif attributes.contentid neq ''>
			<cfif listFindNoCase('Page,Portal,Calendar,Gallery,Link,File',attributes.type)>
				<cfset rsRating=application.raterManager.getAvgRating(request.contentBean.getcontentID(),request.contentBean.getSiteID()) />
				<cfif rsRating.recordcount>
				<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.votes")#: <strong><cfif rsRating.recordcount>#rsRating.theCount#<cfelse>0</cfif></strong></li>
				<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.averagerating")#: <img id="ratestars" src="images/rater/star_#application.raterManager.getStarText(rsRating.theAvg)#.gif" alt="#rsRating.theAvg# stars" border="0"></li>
				</cfif>
			</cfif>
		<cfif attributes.type eq "file" and request.contentBean.getMajorVersion()>
				<li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#: <strong>#request.contentBean.getMajorVersion()#.#request.contentBean.getMinorVersion()#</strong></li>
		</cfif>
		</cfif>
		<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.update")#: <strong>#LSDateFormat(parseDateTime(request.contentBean.getlastupdate()),session.dateKeyFormat)# #LSTimeFormat(parseDateTime(request.contentBean.getlastupdate()),"short")#</strong></li>
		<li>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.status")#: <strong><cfif attributes.contentid neq ''><cfif request.contentBean.getactive() gt 0 and request.contentBean.getapproved() gt 0>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.published")#<cfelseif request.contentBean.getapproved() lt 1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#<cfelse>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.archived")#</cfif><cfelse>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.draft")#</cfif></strong></li>
		<cfset started=false>
		<li>
		<!---
		<cfif listFindNoCase(pageLevelList,attributes.type)>
				<cfset started=true>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
				<cfloop list="#baseTypeList#" index="t">
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option>
					</cfloop>
				</cfif>
				</cfloop>
				</select>
			<cfelseif attributes.type eq 'File'>
				<cfset t="File"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<cfset started=true>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#t#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")# / #rsst.subtype#</option>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			<cfelseif attributes.type eq 'Link'>	
				<cfset t="Link"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<cfset started=true>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:v
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<cfif rsst.subtype neq 'Default'><option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option></cfif>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			<cfelseif attributes.type eq 'Component'>	
				<cfset t="Component"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<cfset started=true>
				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<cfif rsst.subtype neq 'Default'><option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option></cfif>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			</cfif>
			
			<cfif not started> --->
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#: <strong>#HTMLEditFormat(attributes.type)#</strong>
			<!---</cfif>--->
		</li>
	</ul>
	</cfif>
	
	<cfif attributes.compactDisplay eq "true" and not ListFindNoCase(nodeLevelList,attributes.type)>
		<p class="notice">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.globallyappliednotice")#</p>
	</cfif>
	
	<cfif not request.contentBean.getIsNew()>
		<cfset draftcheck=application.contentManager.getDraftPromptData(request.contentBean.getContentID(),request.contentBean.getSiteID())>
		
		<cfif yesNoFormat(draftcheck.showdialog) and draftcheck.historyid neq request.contentBean.getContentHistID()>
		<p class="notice">
		#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.inline')#: <strong><a href="./?#replace(cgi.query_string,'#request.contentBean.getContentHistID()#','#draftcheck.historyid#')#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.gotolatest')#</a></strong>
		<p>
		</cfif>
	</cfif>
	
	<cfif hasChangesets and (not currentChangeset.getIsNew() or pendingChangesets.recordcount)>
		<p class="notice">
		<cfif pendingChangesets.recordcount>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnodenotify")#: 
		<cfloop query="pendingChangesets"><a href="?fuseaction=cArch.edit&moduleID=#URLEncodedFormat(attributes.moduleID)#&siteID=#URLEncodedFormat(attributes.siteID)#&topID=#URLEncodedFormat(attributes.topID)#&contentID=#URLEncodedFormat(attributes.contentID)#&return=#URLEncodedFormat(attributes.return)#&contentHistID=#pendingChangesets.contentHistID#&parentID=#URLEncodedFormat(attributes.parentID)#&startrow=#URLEncodedFormat(attributes.startrow)#">"#HTMLEditFormat(pendingChangesets.changesetName)#"</a><cfif pendingChangesets.currentrow lt pendingChangesets.recordcount>, </cfif></cfloop><br/></cfif>
		<cfif not currentChangeset.getIsNew()>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetversionnotify")#: "#HTMLEditFormat(currentChangeset.getName())#"</cfif>
		</p>
	</cfif>
	<form novalidate="novalidate" action="index.cfm" method="post" enctype="multipart/form-data" name="contentForm" onsubmit="return ckContent(draftremovalnotice);" id="contentForm">
	
	<cfif attributes.compactDisplay neq "true" and attributes.moduleid eq '00000000000000000000000000000000000'>
		#application.contentRenderer.dspZoom(request.crumbdata,fileExt)#
	</cfif>
	
	<!-- This is plugin message targeting --->	
	<span id="msg">
	#application.pluginManager.renderEvent("on#request.contentBean.getType()#EditMessageRender", pluginEvent)#
	#application.pluginManager.renderEvent("on#request.contentBean.getType()##request.contentBean.getSubType()#EditMessageRender", pluginEvent)#
	</span>
	
	
	<cfif attributes.compactDisplay neq "true" or not listFindNoCase(nodeLevelList,attributes.type)>	
		<cfif attributes.contentid neq "">
			<ul id="navTask">
			<cfif attributes.compactDisplay neq "true" and (request.contentBean.getfilename() neq '' or attributes.contentid eq '00000000000000000000000000000000001')>
				<cfswitch expression="#attributes.type#">
				<cfcase value="Page,Portal,Calendar,Gallery">
					<cfif attributes.contentID neq ''>
						<cfset currentBean=application.contentManager.getActiveContent(attributes.contentID,attributes.siteid) />
						<li><a  href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,currentBean.getfilename())#','#currentBean.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewactive")#</a></li>
					</cfif>
					<li><a  href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?previewid=#request.contentBean.getcontenthistid()#&contentid=#request.contentBean.getcontentid()#','#request.contentBean.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewversion")#</a></li>
				</cfcase>
				<cfcase value="Link">
					<cfset currentBean=application.contentManager.getActiveContent(attributes.contentID,attributes.siteid) />
					<cfif attributes.contentID neq ''>
						<li><a href="javascript:preview('#currentBean.getfilename()#','#currentBean.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewactive")#</a></li>
					</cfif>
					<li><a href="javascript:preview('#request.contentBean.getfilename()#','#request.contentBean.getTargetParams()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewversion")#</a></li>
				</cfcase>
				<cfcase value="File">	
					<li><a  href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#attributes.contentid#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewactive")#</a></li>
					<li><a  href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/render/file/?fileID=#request.contentBean.getFileID()#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.viewversion")#</a></li>
				</cfcase>
				</cfswitch>
			</cfif>
			<cfswitch expression="#attributes.type#">
			<cfcase value="Form">
				<cfif listFind(session.mura.memberships,'S2IsPrivate')>
				<li><a  href="index.cfm?fuseaction=cArch.datamanager&contentid=#URLEncodedFormat(attributes.contentid)#&siteid=#URLEncodedFormat(attributes.siteid)#&topid=#URLEncodedFormat(attributes.topid)#&moduleid=#attributes.moduleid#&type=Form&parentid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.managedata")#</a></li>
				</cfif>
			</cfcase>
			</cfswitch>
			<li><a href="index.cfm?fuseaction=cArch.hist&contentid=#URLEncodedFormat(attributes.contentid)#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&compactDisplay=#attributes.compactDisplay#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.versionhistory")#</a> </li>
			<cfif attributes.compactDisplay neq 'true' and request.contentBean.getactive()lt 1 and (request.perm neq 'none')><li><a href="index.cfm?fuseaction=cArch.update&contenthistid=#URLEncodedFormat(attributes.contenthistid)#&action=delete&contentid=#URLEncodedFormat(attributes.contentid)#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#&return=#attributes.return#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.deleteversionconfirm"))#',this.href)">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.deleteversion")#</a></li></cfif>
			<cfif request.deletable><li><a href="index.cfm?fuseaction=cArch.update&action=deleteall&contentid=#URLEncodedFormat(attributes.contentid)#&type=#attributes.type#&parentid=#URLEncodedFormat(attributes.parentid)#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#" 
			<cfif listFindNoCase(nodeLevelList,request.contentBean.getType())>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),request.contentBean.getMenutitle()))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.deletecontentconfirm"))#',this.href)"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.deletecontent")#</a></li></cfif>
			<cfif (listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2'))><li><a href="index.cfm?fuseaction=cPerm.main&contentid=#URLEncodedFormat(attributes.contentid)#&type=#request.contentBean.gettype()#&parentid=#request.contentBean.getparentID()#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.permissions")#</a></li></cfif>
			</ul>
		</cfif>
	</cfif>
	
	<cfif attributes.compactDisplay neq "true">
			<div class="selectContentType">
			<cfif listFindNoCase(pageLevelList,attributes.type)>
				<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
				<cfloop list="#baseTypeList#" index="t">
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option>
					</cfloop>
				</cfif>
				</cfloop>
				</select>
			<cfelseif attributes.type eq 'File'>
				<cfset t="File"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#t#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")# / #rsst.subtype#</option>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			<cfelseif attributes.type eq 'Link'>	
				<cfset t="Link"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<cfif rsst.subtype neq 'Default'><option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option></cfif>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			<cfelseif attributes.type eq 'Component'>	
				<cfset t="Component"/>
				<cfsilent><cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery></cfsilent>
				<cfif rsst.recordcount>
				<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
				<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
				<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
				<cfif rsst.recordcount>
					<cfloop query="rsst">
						<cfif rsst.subtype neq 'Default'><option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option></cfif>
					</cfloop>
				</cfif>
				</select>
				</cfif>
			</cfif>
		</div>
	</cfif>
	
	<cfif attributes.compactDisplay eq "true">
		<cfif not listFindNoCase("Component,Form", attributes.type)>
			<cfquery name="rsst" dbtype="query">select * from rsSubTypes where type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#attributes.type#"> and subtype not in ('Default','default')</cfquery>
			<cfif rsst.recordcount>
					<cfset t=attributes.type/>
					<cfsilent></cfsilent>
					<div class="selectContentType">
					<strong>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type")#:</strong>
					<select name="typeSelector" class="dropdown" onchange="resetExtendedAttributes('#request.contentBean.getcontentHistID()#',this.value,'#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');">
					<option value="#t#^Default" <cfif attributes.type eq t and request.contentBean.getSubType() eq "Default">selected</cfif>>#t#</option>
					<cfloop query="rsst">
						<option value="#t#^#rsst.subtype#" <cfif attributes.type eq t and request.contentBean.getSubType() eq rsst.subtype>selected</cfif>>#t#  / #rsst.subtype#</option>
					</cfloop>
					</select>	
					</div>								
			</cfif>
		</cfif>
			
		<input type="hidden" name="closeCompactDisplay" value="true" />
	</cfif>
	
	</cfoutput>
	
	<cfset tabLabelList=""/>
	<cfset tabList="">
	<cfsavecontent variable="tabContent">
	
		<cfif attributes.type neq "Form">
			<cfinclude template="form/dsp_tab_basic.cfm">	
		<cfelse>
			<cfif request.contentBean.getIsNew() and not (isdefined("url.formType") and url.formType eq "editor")>		
				<cfset request.contentBean.setBody( application.serviceFactory.getBean('formBuilderManager').createJSONForm( request.contentBean.getContentID() ) ) />
			</cfif>
			<cfif isJSON(request.contentBean.getBody())>
				<cfinclude template="form/dsp_tab_formbuilder.cfm">
			<cfelse>
				<cfinclude template="form/dsp_tab_basic.cfm">
			</cfif>
		</cfif>
		
		<cfswitch expression="#attributes.type#">
			<cfcase value="Page,Portal,Calendar,Gallery,File,Link">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Meta Data')>
			<cfinclude template="form/dsp_tab_meta.cfm">
			</cfif>
			</cfcase>
		</cfswitch>
			
		<cfswitch expression="#attributes.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Content Objects')>
			<cfif listFind(session.mura.memberships,'S2IsPrivate')>
			<cfinclude template="form/dsp_tab_objects.cfm">
			</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
			<cfif application.categoryManager.getCategoryCount(attributes.siteID)>
			<cfinclude template="form/dsp_tab_categories.cfm">
			</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content')>
			<cfinclude template="form/dsp_tab_related_content.cfm">
			</cfif>
		</cfcase>
		<cfcase value="Link,File">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Categorization')>
			<cfif application.categoryManager.getCategoryCount(attributes.siteid)>
			<cfinclude template="form/dsp_tab_categories.cfm">
			</cfif>
			</cfif>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Related Content')>
			<cfinclude template="form/dsp_tab_related_content.cfm">
			</cfif>
		</cfcase>
		<cfcase value="Component">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report')>
			<cfif attributes.contentID neq ''>
			<cfinclude template="form/dsp_tab_usage.cfm">
			</cfif>
			</cfif>		
		</cfcase>
		<cfcase value="Form">
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Usage Report')>
			<cfif attributes.contentID neq ''>
			<cfinclude template="form/dsp_tab_usage.cfm">
			</cfif>
			</cfif>
		</cfcase>
	</cfswitch>
	
	<cfswitch expression="#attributes.type#">
		<cfcase value="Page,Portal,Calendar,Gallery,Link,File,Component">
		<cfif isExtended>
			<cfif not len(tabAssignments) or listFindNocase(tabAssignments,'Extended Attributes')>
			<cfset extendSets=application.classExtensionManager.getSubTypeByName(attributes.type,request.contentBean.getSubType(),attributes.siteid).getExtendSets(activeOnly=true) />
			<cfinclude template="form/dsp_tab_extended_attributes.cfm">
			</cfif>
			<cfoutput>
			<script type="text/javascript">
			loadExtendedAttributes('#request.contentbean.getcontentHistID()#','#attributes.type#','#request.contentBean.getSubType()#','#attributes.siteID#','#application.configBean.getContext()#','#application.settingsManager.getSite(attributes.siteID).getThemeAssetPath()#');
			</script>
			</cfoutput>
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
				<div id="#tabID#">
				<cfoutput>
				<cfset rsPluginScript=application.pluginManager.getScripts("onContentEdit",attributes.siteID,rsPluginScripts.moduleID)>
				<cfif rsPluginScript.recordcount>
				#application.pluginManager.renderScripts("onContentEdit",attributes.siteid,pluginEvent,rsPluginScript)#
				<cfelse>
				<cfset rsPluginScript=application.pluginManager.getScripts("on#attributes.type#Edit",attributes.siteID,rsPluginScripts.moduleID)>
				#application.pluginManager.renderScripts("on#attributes.type#Edit",attributes.siteid,pluginEvent,rsPluginScript)#
				</cfif>
				</cfoutput>
				</div>
		</cfoutput>
	</cfsavecontent>
	<cfoutput>
	<img class="loadProgress tabPreloader" src="images/progress_bar.gif">
	<div class="tabs initActiveTab" style="display:none">
		<ul>
		<cfloop from="1" to="#listlen(tabList)#" index="t">
		<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
		</cfloop>
		</ul>
		#tabContent#
	</div>
	
	<cfif assignChangesets>
		<cfinclude template="form/dsp_changesets.cfm">
	</cfif>
	
	<div class="clearfix" id="actionButtons">
		<cfif assignChangesets>
		<input type="button" class="submit" onclick="saveToChangeset('#request.contentBean.getChangesetID()#','#HTMLEditFormat(attributes.siteID)#','');return false;" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savetochangeset")#" />	
		</cfif>
		 <input type="button" class="submit" onclick="if(ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.savedraft"))#" />
		<cfif listFindNoCase("Page,Portal,Calendar,Gallery",attributes.type)>
		<input type="button" class="submit" onclick="document.contentForm.preview.value=1;if(ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.preview"))#" />
		</cfif>
		<cfif request.perm eq 'editor'>
		<input type="button" class="submit" onclick="document.contentForm.approved.value=1;if(ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}" value="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.publish"))#" />
		</cfif> 
	</div>
	<div id="actionIndicator" style="display: none;">
		<img src="#application.configBean.getContext()#/admin/images/progress_bar.gif">
	</div>
		<input name="approved" type="hidden" value="0">
		<input id="removePreviousChangeset" name="removePreviousChangeset" type="hidden" value="false">
		<input id="changesetID" name="changesetID" type="hidden" value="">
		<input name="preview" type="hidden" value="0">	
		<cfif attributes.type neq 'Link'>
			<input name="filename" type="hidden" value="#request.contentBean.getfilename()#">
		</cfif>
		<cfif attributes.contentid neq ''>
			<input name="lastupdate" type="hidden" value="#LSDateFormat(request.contentBean.getlastupdate(),session.dateKeyFormat)#">
		</cfif>
		<cfif attributes.contentid eq '00000000000000000000000000000000001'>
			<input name="isNav" type="hidden" value="1">
		</cfif>
		<cfif attributes.type eq 'Form'>
			<input name="responseDisplayFields" type="hidden" value="#request.contentBean.getResponseDisplayFields()#">
		</cfif>
		<input name="action" type="hidden" value="add">
		<input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
		<input type="hidden" name="moduleid" value="#attributes.moduleid#">
		<input type="hidden" name="preserveID" value="#request.contentBean.getPreserveID()#">
		<input type="hidden" name="return" value="#attributes.return#">
		<input type="hidden" name="topid" value="#attributes.topid#">
		<input type="hidden" name="contentid" value="#request.contentBean.getContentID()#">
		<input type="hidden" name="ptype" value="#attributes.ptype#">
		<input type="hidden" name="type"  value="#attributes.type#">
		<input type="hidden" name="subtype" value="#request.contentBean.getSubType()#">
		<input type="hidden" name="fuseaction" value="cArch.update">
		<input type="hidden" name="startrow" value="#attributes.startrow#">
		<input type="hidden" name="returnURL" id="txtReturnURL" value="#attributes.returnURL#">
		<input type="hidden" name="homeID" value="#attributes.homeID#">
		<cfif not  listFind(session.mura.memberships,'S2')>
			<input type="hidden" name="isLocked" value="#request.contentBean.getIsLocked()#">
		</cfif>
		<input name="OrderNo" type="hidden" value="<cfif request.contentBean.getorderno() eq ''>0<cfelse>#request.contentBean.getOrderNo()#</cfif>">
				
	</cfoutput>
	</form>
<cfelse>
	<div>
		<cfinclude template="form/dsp_full.cfm">
	</div>
</cfif>
