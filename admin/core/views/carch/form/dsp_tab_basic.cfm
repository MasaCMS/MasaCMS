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
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.basic"))/>
<cfset tabList=listAppend(tabList,"tabBasic")>
<cfset started=false>
<cfoutput>
<div id="tabBasic">
<dl class="oneColumn">
		
<cfswitch expression="#rc.type#">
	<cfcase value="Page,Portal,Calendar,Gallery,File,Link">
		<dt<cfif not started> class="first"</cfif>><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.title")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.pageTitle")#</span></a></dt>
		<dd><input type="text" id="title" name="title" value="#HTMLEditFormat(rc.contentBean.gettitle())#"  maxlength="255" class="textLong" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.titlerequired')#" <cfif not rc.contentBean.getIsNew() and not listFindNoCase('Link,File',rc.type)>onkeypress="openDisplay('editAdditionalTitles','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');"</cfif>></dd>
		
		<!---<cfif not listFind("File,Link",rc.type)>--->
			<dt><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.AdditionalTitles")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.AdditionalTitles")#</span> <a href="##" id="editAdditionalTitlesLink" onclick="javascript: toggleDisplay('editAdditionalTitles','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');return false">[#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.expand")#]</a></dt>
			<dd id="editAdditionalTitles" style="display:none;">
			<p class="notice">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.AdditionalTitlesnote")#</p>
			<p>
				<dl>
				<dt><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.menutitle")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.navigationTitle")#</span></a></dt>
				<dd><input type="text" id="menuTitle" name="menuTitle" value="#HTMLEditFormat(rc.contentBean.getmenuTitle())#"  maxlength="255" class="textLong"></dd>
				<dt class="alt noBorder"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.urltitle")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.urlTitle")#</span></a></dt>
				<dd><input type="text" id="urlTitle" name="urlTitle" value="#HTMLEditFormat(rc.contentBean.getURLTitle())#"  maxlength="255" class="textLong"></dd>
				<dt class="alt"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.htmltitle")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.htmlTitle")#</span></a></dt>
				<dd><input type="text" id="htmlTitle" name="htmlTitle" value="#HTMLEditFormat(rc.contentBean.getHTMLTitle())#"  maxlength="255" class="textLong"></dd>
				</dl>
			</p>
			</dd>
		<!---</cfif>--->
	</cfcase>
	<cfdefaultcase>
		<input type="hidden" id="menuTitle" name="menuTitle" value="">
		<dt<cfif not started> class="first"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#</dt>
		<dd><input type="text" id="title" name="title" value="#HTMLEditFormat(rc.contentBean.getTitle())#"  maxlength="255" class="textLong" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.titlerequired')#"></dd>
	</cfdefaultcase>
</cfswitch>

<cfif listFind("Page,Portal,Calendar,Gallery,Link",rc.type)>
	<cfinclude template="dsp_file_selector.cfm">
</cfif>	

<cfif rc.type neq 'Form' and  rc.type neq 'Component' >
	<dt class="summaryContainer" style="display:none;"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.summary")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.contentSummary")#</span></a> <a href="##" id="editSummaryLink" onclick="javascript: toggleDisplay('editSummary','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#'); editSummary();return false">[#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.expand")#]</a></dt>
	<dd id="editSummary"  class="summaryContainer" style="display:none;">
	<cfoutput><textarea name="summary" id="summary" cols="96" rows="10"><cfif application.configBean.getValue("htmlEditorType") neq "none" or len(rc.contentBean.getSummary())>#HTMLEditFormat(rc.contentBean.getSummary())#<cfelse><p></p></cfif></textarea></cfoutput>
	</dd>
	<script>
		hideSummaryEditor=function(){
			if(typeof CKEDITOR.instances.summary != 'undefined'){
				CKEDITOR.instances.summary.updateElement();
				CKEDITOR.instances.summary.destroy();
			}
			jQuery(".summaryContainer").hide();
			summaryLoaded=false;
		}

		showSummaryEditor=function(){
			if(typeof CKEDITOR.instances.summary == 'undefined'){
				jQuery(".summaryContainer").show();
				jQuery("##editSummary").hide();
			}
		}
		<cfif not isExtended>
		(function($){
			var summary=$('##summary').val();
			if(summary!='' && summary!='<p></p>'){
				toggleDisplay('editSummary','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');
				editSummary();
			}
		}(jQuery));
		</cfif>
	</script>
</cfif>

<cfif rc.type eq 'Page' or rc.type eq 'Portal' or rc.type eq 'Gallery' or rc.type eq 'Calendar' or  rc.type eq 'Component' or  rc.type eq 'Form' >
	<dt class="separate body-container">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.content")#</dt>
	<cfset rsPluginEditor=application.pluginManager.getScripts("onHTMLEdit",rc.siteID)>
	<dd id="bodyContainer" class="body-container"<cfif rsPluginEditor.recordcount> style="display:none;"</cfif>>
	<cfif rsPluginEditor.recordcount>
		#application.pluginManager.renderScripts("onHTMLEdit",rc.siteid,pluginEvent,rsPluginEditor)#
	<cfelse>
		<cfif application.configBean.getValue("htmlEditorType") eq "fckeditor">
			<cfscript>
				fckEditor = createObject("component", "mura.fckeditor");
				fckEditor.instanceName	= "body";
				fckEditor.value			= '#rc.contentBean.getBody()#';
				fckEditor.basePath		= "#application.configBean.getContext()#/wysiwyg/";
				fckEditor.config.EditorAreaCSS	= '#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/css/editor.css';
				fckEditor.config.StylesXmlPath = '#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/css/fckstyles.xml';
				fckEditor.width			= "98%";
				fckEditor.height		= 550;
				fckEditor.config.DefaultLanguage=lcase(session.rb);
				fckEditor.config.AutoDetectLanguage=false;
				if (rc.moduleID eq "00000000000000000000000000000000000"){
				fckEditor.config.BodyId		="primary";
				}
				if (len(application.settingsManager.getSite(rc.siteID).getGoogleAPIKey())){
				fckEditor.config.GoogleMaps_Key =application.settingsManager.getSite(rc.siteID).getGoogleAPIKey();
				} else {
				fckEditor.config.GoogleMaps_Key ='none';
				}
				fckEditor.toolbarset 	= '#iif(rc.type eq "Form",de("Form"),de("Default"))#';
				
				if(fileExists("#expandPath(application.settingsManager.getSite(rc.siteid).getThemeIncludePath())#/js/fckconfig.js.cfm"))
				{
				fckEditor.config["CustomConfigurationsPath"]=urlencodedformat('#application.settingsManager.getSite(rc.siteid).getThemeAssetPath()#/js/fckconfig.js.cfm?EditorType=#rc.type#');
				}
				
				fckEditor.create(); // create the editor.
			</cfscript>
			<script type="text/javascript" language="Javascript">
			var loadEditorCount = 0;
			
			function FCKeditor_OnComplete( editorInstance ) { 	
				<cfif rc.preview eq 1>
			   	preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,'')#?previewid=#rc.contentBean.getcontenthistid()#','#rc.contentBean.getTargetParams()#');
				</cfif> 
				htmlEditorOnComplete(editorInstance); 
			}

			<cfif rc.contentBean.getSummary() neq '' and rc.contentBean.getSummary() neq "<p></p>">
			toggleDisplay('editSummary','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');
			editSummary();
			</cfif>
			</script>
		<cfelseif application.configBean.getValue("htmlEditorType") eq "none">
			<textarea name="body" id="body">#HTMLEditFormat(rc.contentBean.getBody())#</textarea>
		<cfelse>	
			<textarea name="body" id="body"><cfif len(rc.contentBean.getBody())>#HTMLEditFormat(rc.contentBean.getBody())#<cfelse><p></p></cfif></textarea>
			<script type="text/javascript" language="Javascript">
			var loadEditorCount = 0;
			<cfif rc.preview eq 1>var previewLaunched= false;</cfif>

			hideBodyEditor=function(){
				if(typeof CKEDITOR.instances.body != 'undefined'){
					CKEDITOR.instances.body.updateElement();
					CKEDITOR.instances.body.destroy();
				}
				jQuery(".body-container").hide();
			}

			showBodyEditor=function(){
				if(typeof CKEDITOR.instances.body == 'undefined'){
					jQuery(".body-container").show();

					jQuery('##body').ckeditor(
					{ toolbar:<cfif rc.type eq "Form">'Form'<cfelse>'Default'</cfif>,
					height:'550',
					customConfig : 'config.js.cfm' 
					},
						function(editorInstance){
							htmlEditorOnComplete(editorInstance);
							<cfif rc.preview eq 1>
								if(!previewLaunched){
							<cfif listFindNoCase("File",rc.type)>
								preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,'')#?previewid=#rc.contentBean.getcontenthistid()#&siteid=#rc.contentBean.getsiteid()#');
							<cfelse>
								openPreviewDialog('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,'')#?previewid=#rc.contentBean.getcontenthistid()#&siteid=#rc.contentBean.getsiteid()#');
							</cfif>
									previewLaunched=true;
								}
							</cfif>
							
						}
					);
				}
			}

			<cfif not isExtended>
				showBodyEditor();	
			</cfif>
			</script>
		</cfif>
	</cfif>
	</dd>
	
<cfelseif rc.type eq 'Link'>
	<dt class="separate">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.url")#</dt>
	<dd><input type="text" id="url" name="filename" value="#HTMLEditFormat(rc.contentBean.getfilename())#" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.urlrequired')#"></dd>
<cfelseif rc.type eq 'File'>
	<cfinclude template="dsp_file_selector.cfm">
</cfif>

<cfif rc.type eq 'Component'>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.componentassign')#</dt>
	<dd>
	<input name="moduleAssign" type="CHECKBOX" id="m1" value="00000000000000000000000000000000000" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000000') or rc.contentBean.getIsNew()>checked </cfif> class="checkbox"> <label for="m1">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sitemanager')#</label>&nbsp;
	<input name="moduleAssign" type="CHECKBOX" id="m2" value="00000000000000000000000000000000003" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000003')>checked </cfif> class="checkbox"> <label for="m2">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#</label>&nbsp;
	<cfif application.settingsManager.getSite(rc.siteid).getdatacollection()><input name="moduleAssign" type="CHECKBOX" id="m3" value="00000000000000000000000000000000004" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000004')>checked </cfif> class="checkbox"> <label for="m3">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.formsmanager')#</label>&nbsp;</cfif>
	<cfif application.settingsManager.getSite(rc.siteid).getemailbroadcaster()><input name="moduleAssign" type="CHECKBOX" id="m4"  value="00000000000000000000000000000000005" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000005')>checked </cfif> class="checkbox"> <label for="m4">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.emailbroadcaster')#</label>&nbsp;</cfif>
	</dd>
</cfif>

<span id="extendSetsBasic"></span>

<cfif rc.type eq 'Form'>
	<dt class="separate"><input name="responseChart" id="rc" type="CHECKBOX" value="1" <cfif rc.contentBean.getresponseChart() eq 1>checked </cfif> class="checkbox"> <label for="rc">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.ispoll')#</label></dt> 
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.confirmationmessage')#</dt>
	<dd><textarea name="responseMessage">#HTMLEditFormat(rc.contentBean.getresponseMessage())#</textarea></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.responsesendto')#</dt>
	<dd><input name="responseSendTo" value="#HTMLEditFormat(rc.contentBean.getresponseSendTo())#" class="text"></dd> 
</cfif>

<cfif rc.type neq 'Component' and rc.type neq 'Form'>
	<dt class="separate"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.releasedate')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.contentReleaseDate")#</span></a></dt>
	<dd>
		<input type="text" class="datepicker textAlt" name="releaseDate" value="#LSDateFormat(rc.contentBean.getreleasedate(),session.dateKeyFormat)#"  maxlength="12" ><!---<img class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=releaseDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
		<select name="releasehour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getReleaseDate())  and h eq 12 or (LSisDate(rc.contentBean.getReleaseDate()) and (hour(rc.contentBean.getReleaseDate()) eq h or (hour(rc.contentBean.getReleaseDate()) - 12) eq h or hour(rc.contentBean.getReleaseDate()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
		<select name="releaseMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getReleaseDate()) and minute(rc.contentBean.getReleaseDate()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
		<select name="releaseDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getReleaseDate()) and hour(rc.contentBean.getReleaseDate()) gte 12>selected</cfif>>PM</option></select>
	
	</dd>
</cfif>	

<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>
	<cfset bydate=iif(rc.contentBean.getdisplay() EQ 2 or (rc.ptype eq 'Calendar' and rc.contentBean.getIsNew()),de('true'),de('false'))>
	<dt><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.displayContent")#</span></a></dt>
	<dd><select name="display" class="dropdown" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editDates',true):toggleDisplay2('editDates',false);">
					<option value="1"  <cfif  rc.contentBean.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
					<option value="0"  <cfif  rc.contentBean.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
					<option value="2"  <cfif  bydate> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
					</select>
	<dd>
		  <dl id="editDates" <cfif  not bydate>style="display: none;"</cfif>>
			<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</dt>
			<dd><input type="text" name="displayStart" value="#LSDateFormat(rc.contentBean.getdisplaystart(),session.dateKeyFormat)#" class="textAlt datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=displayStart&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
			<select name="starthour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getdisplaystart())  and h eq 12 or (LSisDate(rc.contentBean.getdisplaystart()) and (hour(rc.contentBean.getdisplaystart()) eq h or (hour(rc.contentBean.getdisplaystart()) - 12) eq h or hour(rc.contentBean.getdisplaystart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
			<select name="startMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getdisplaystart()) and minute(rc.contentBean.getdisplaystart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
			<select name="startDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getdisplaystart()) and hour(rc.contentBean.getdisplaystart()) gte 12>selected</cfif>>PM</option></select>
			</dd>
			<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#</dt>
			<dd><input type="text" name="displayStop" value="#LSDateFormat(rc.contentBean.getdisplaystop(),session.dateKeyFormat)#" class="textAlt datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=displayStop&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
		<select name="stophour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getdisplaystop())  and h eq 11 or (LSisDate(rc.contentBean.getdisplaystop()) and (hour(rc.contentBean.getdisplaystop()) eq h or (hour(rc.contentBean.getdisplaystop()) - 12) eq h or hour(rc.contentBean.getdisplaystop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
			<select name="stopMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rc.contentBean.getdisplaystop()) and m eq 59) or (LSisDate(rc.contentBean.getdisplaystop()) and minute(rc.contentBean.getdisplaystop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
			<select name="stopDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rc.contentBean.getdisplaystop()) and (hour(rc.contentBean.getdisplaystop()) gte 12)) or not LSisDate(rc.contentBean.getdisplaystop())>selected</cfif>>PM</option></select>
			</dd>
			</dl>
	</dd>
	
	<cfif rc.type neq 'Component' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all' and rc.type neq 'Form'>
	
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#:<span id="move" class="text"> <cfif rc.contentBean.getIsNew()>"#rc.crumbData[1].menutitle#"<cfelse>"#rc.crumbData[2].menutitle#"</cfif>
				&nbsp;&nbsp;<a href="javascript:##;" onclick="javascript: loadSiteParents('#rc.siteid#','#rc.contentid#','#rc.parentid#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent')#]</a>
				<input type="hidden" name="parentid" value="#rc.parentid#">
		<!---<cfif rc.contentBean.getIsNew() and  rc.crumbdata[1].sortBy eq 'orderno'>
				at <select name="topOrBottom" class="dropdown">
				<option value="top">Top</option>
				<option value="bottom">Bottom</option>
		</select></cfif>---></span>
	</dt>
	<cfelse>
	<dd style="display:none;">
		  <input type="hidden" name="parentid" value="#rc.parentid#">
	</dd>
	</cfif>
<cfelse>
	<dd style="display:none;">
		<cfif rc.type neq 'Component' and rc.type neq 'Form'>
		
		<input type="hidden" name="display" value="#rc.contentBean.getdisplay()#">
			<cfif rc.contentid eq '00000000000000000000000000000000001' or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'top') or application.settingsManager.getSite(rc.siteid).getlocking() eq 'all'>
				<input type="hidden" name="parentid" value="#rc.parentid#">
			</cfif>
		<input type="hidden" name="displayStart" value="">
		<input type="hidden" name="displayStop" value="">
		<cfelse>
		<input type="hidden" name="display" value="1">
		<input type="hidden" name="parentid" value="#rc.parentid#">
		</cfif>
	</dd>
</cfif>
<cfif listFind("Page,Portal,Calendar,Gallery,Link,File,Link",rc.type)>
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires')#</dt>
<dd class="clearfix"><div id="expires-date-selector">
	<input type="text" name="expires" value="#LSDateFormat(rc.contentBean.getExpires(),session.dateKeyFormat)#" class="textAlt datepicker">
	<select name="expireshour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getExpires())  and h eq 12 or (LSisDate(rc.contentBean.getExpires()) and (hour(rc.contentBean.getExpires()) eq h or (hour(rc.contentBean.getExpires()) - 12) eq h or hour(rc.contentBean.getExpires()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
	<select name="expiresMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getExpires()) and minute(rc.contentBean.getExpires()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
	<select name="expiresDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getExpires()) and hour(rc.contentBean.getExpires()) gte 12>selected</cfif>>PM</option></select>
	</div>
	<div id="expires-notify">
		<label for="dspexpiresnotify"><input type="checkbox" name="dspExpiresNotify"  id="dspexpiresnotify" onclick="loadExpiresNotify('#rc.siteid#','#rc.contenthistid#','#rc.parentid#');"  class="checkbox"><!---<a href="##" class="tooltip">--->#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expiresnotify')#<!---<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.notifyReview")#</span></a>---></label>
		<div id="selectExpiresNotify" style="display: none;"></div>
	</div>
</dd>
</cfif>
<cfif rc.type neq 'Component' and rc.type neq 'Form' and  rc.contentid neq '00000000000000000000000000000000001'>
<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isfeature')#</dt>

	<dd><select name="isFeature" class="dropdown" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editFeatureDates',true):toggleDisplay2('editFeatureDates',false);">
	<option value="0"  <cfif  rc.contentBean.getisfeature() EQ 0> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
	<option value="1"  <cfif  rc.contentBean.getisfeature() EQ 1> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
	<option value="2"  <cfif rc.contentBean.getisfeature() EQ 2> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
	</select>
	<dd>
	<dl id="editFeatureDates" <cfif rc.contentBean.getisfeature() NEQ 2>style="display: none;"</cfif>>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#</dt>
	<dd><input type="text" name="featureStart" value="#LSDateFormat(rc.contentBean.getFeatureStart(),session.dateKeyFormat)#" class="textAlt datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=featureStart&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
	<select name="featureStartHour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getFeatureStart())  and h eq 12 or (LSisDate(rc.contentBean.getFeatureStart()) and (hour(rc.contentBean.getFeatureStart()) eq h or (hour(rc.contentBean.getFeatureStart()) - 12) eq h or hour(rc.contentBean.getFeatureStart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
	<select name="featureStartMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getFeatureStart()) and minute(rc.contentBean.getFeatureStart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
	<select name="featureStartDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getFeatureStart()) and hour(rc.contentBean.getFeatureStart()) gte 12>selected</cfif>>PM</option></select>
	</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#</dt>
	<dd><input type="text" name="featureStop" value="#LSDateFormat(rc.contentBean.getFeatureStop(),session.dateKeyFormat)#" class="textAlt datepicker"><!---<img class="calendar" type="image" src="images/icons/cal_24.png" width="14" height="14" hidefocus onclick="window.open('date_picker/index.cfm?form=contentForm&field=featureStop&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">--->
	<select name="featureStophour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getFeatureStop())  and h eq 11 or (LSisDate(rc.contentBean.getFeatureStop()) and (hour(rc.contentBean.getFeatureStop()) eq h or (hour(rc.contentBean.getFeatureStop()) - 12) eq h or hour(rc.contentBean.getFeatureStop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
	<select name="featureStopMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rc.contentBean.getFeatureStop()) and m eq 59) or (LSisDate(rc.contentBean.getFeatureStop()) and minute(rc.contentBean.getFeatureStop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
		<select name="featureStopDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rc.contentBean.getFeatureStop()) and (hour(rc.contentBean.getFeatureStop()) gte 12)) or not LSisDate(rc.contentBean.getFeatureStop())>selected</cfif>>PM</option></select>
	</dd>
	</dl>
	</dd>
	<dt><input name="isnav" id="isNav" type="CHECKBOX" value="1" <cfif rc.contentBean.getisnav() eq 1 or rc.contentBean.getisNew() eq 1>checked</cfif> class="checkbox"> <label for="isNav"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isnav')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.includeSiteNav")#</span></a></label></dt>
	<dt><input  name="target" id="Target" type="CHECKBOX" value="_blank" <cfif rc.contentBean.gettarget() eq "_blank">checked</cfif> class="checkbox" onclick="javascript: this.checked?toggleDisplay2('editTargetParams',true):toggleDisplay2('editTargetParams',false);"> <label for="Target"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newwindow')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.openNewWindow")#</span></a></label></dt>  
	<dd id="editTargetParams" <cfif  rc.contentBean.gettarget() neq "_blank">style="display: none;"</cfif> class="clearfix">
	<cfinclude template="dsp_buildtargetparams.cfm"> <input name="targetParams" value="#rc.contentBean.getTargetParams()#" type="hidden">
	</dd>
</cfif>

<dt><input type="checkbox" name="dspNotify"  id="dspnotify" onclick="loadNotify('#rc.siteid#','#rc.contentid#','#rc.parentid#');"  class="checkbox"> <label for="dspnotify"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notifyforreview')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.notifyReview")#</span></a></label></dt>
<dd id="selectNotify" style="display: none;"></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addnotes')# <a href="" id="editNoteLink" onclick="toggleDisplay('editNote','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#]</a></dt>
<dd id="editNote" style="display: none;">
<textarea name="notes" rows="8" class="alt" id="abstract"></textarea>	
</dd>
</dl>
</div>
</cfoutput>