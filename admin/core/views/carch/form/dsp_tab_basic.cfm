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
<div id="tabBasic" class="tab-pane">
	
	<span id="extendset-container-tabbasictop" class="extendset-container"></span>

	<div class="fieldset">
	<cfinclude template="dsp_type_selector.cfm">
	
	<cfswitch expression="#rc.type#">
		<cfcase value="Page,Folder,Calendar,Gallery,File,Link">
			<div class="control-group">
			    <label class="control-label">
			    	<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.pageTitle"))#">
			    		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.title")# <i class="icon-question-sign"></i>
					</a>
			    </label>
			    <div class="controls">
			     	<input type="text" id="title" name="title" value="#HTMLEditFormat(rc.contentBean.gettitle())#"  maxlength="255" class="span12" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.titlerequired')#" <cfif not rc.contentBean.getIsNew() and not listFindNoCase('Link,File',rc.type)>onkeypress="openDisplay('editAdditionalTitles','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');"</cfif>>
			     </div>
		    </div>
		<div class="control-group" id="editAdditionalTitles" style="display:none;">		
			<div class="controls" >
				<p class="alert help-block">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.AdditionalTitlesnote")#</p>
			</div>
		</div>
		</cfcase>
		<cfdefaultcase>
			
			<div class="control-group">
	      		<label class="control-label">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#
	      		</label>
	     		 <div class="controls">
	     		 	<input type="text" id="title" name="title" value="#HTMLEditFormat(rc.contentBean.getTitle())#"  maxlength="255" class="span12" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.titlerequired')#"<cfif rc.contentBean.getIsLocked()> disabled="disabled"</cfif>>
	     		 	<input type="hidden" id="menuTitle" name="menuTitle" value="">
	     		</div>
	     	</div>
		</cfdefaultcase>
	</cfswitch>

	<cfif listFind("Page,Folder,Calendar,Gallery,Link",rc.type)>
		<cfinclude template="dsp_file_selector.cfm">
	</cfif>	

	<cfif rc.type neq 'Form' and  rc.type neq 'Component' >	
		<div class="control-group summaryContainer" style="display:none;">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.contentSummary"))#">
	      			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.summary")#
	      		 <i class="icon-question-sign"></i></a> 
	      		<!---<a href="##" id="editSummaryLink" onclick="javascript: toggleDisplay('editSummary','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#'); editSummary();return false">
	      			[#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.expand")#]
	      		</a>--->
	      	</label>
	      	<div id="editSummary" class="controls summaryContainer" style="display:none;">
				<cfoutput>
					<textarea name="summary" id="summary" cols="96" rows="10"><cfif application.configBean.getValue("htmlEditorType") neq "none" or len(rc.contentBean.getSummary())>#HTMLEditFormat(rc.contentBean.getSummary())#<cfelse><p></p></cfif></textarea>
				</cfoutput>
			</div>
			
		</div>

		<script>
			
			hideSummaryEditor=function(){
				if(typeof CKEDITOR.instances.summary != 'undefined'){
					CKEDITOR.instances.summary.updateElement();
					CKEDITOR.instances.summary.destroy();
				}
				jQuery(".summaryContainer").hide();
				summaryLoaded=true;
			}
			
			showSummaryEditor=function(){
				if(typeof CKEDITOR.instances.summary == 'undefined'){
					jQuery(".summaryContainer").show();
					jQuery('##summary').ckeditor(
		     		{ toolbar:'Summary',
		     			height:'150',
		     		  	customConfig : 'config.js.cfm'},
		     		htmlEditorOnComplete
		     	);
				}
			}
			<cfif not isExtended>
			showSummaryEditor();
			</cfif>
		</script>
	</cfif>

	<cfif rc.type eq 'Page' or rc.type eq 'Folder' or rc.type eq 'Gallery' or rc.type eq 'Calendar' or  rc.type eq 'Component' or  rc.type eq 'Form' >
		<div class="control-group">
	      	<label class="control-label">
	      		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.content")#
	      	</label>
			<cfset rsPluginEditor=application.pluginManager.getScripts("onHTMLEdit",rc.siteID)>
			<div id="bodyContainer" class="body-container controls"<cfif rsPluginEditor.recordcount> style="display:none;"</cfif>>
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
					<script type="text/javascript">
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
					<script type="text/javascript">
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
			</div>
		</div>
		
	<cfelseif rc.type eq 'Link'>
		<div class="control-group">
	      	<label class="control-label">
	      		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.url")#
	      	</label>
	     	<div class="controls">
	     	 	<input type="text" id="url" name="body" value="#HTMLEditFormat(rc.contentBean.getbody())#" class="text span12" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.urlrequired')#">
	     	</div>
	    </div>
	<cfelseif rc.type eq 'File'>
		<cfinclude template="dsp_file_selector.cfm">
	</cfif>

	<cfif rc.type eq 'Component'>
		<div class="control-group">
	      	<label class="control-label">
	      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.componentassign')#
	      	</label>
	      	<div class="controls">
				<label for="m1" class="checkbox inline">
					<input name="moduleAssign" type="CHECKBOX" id="m1" value="00000000000000000000000000000000000" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000000') or rc.contentBean.getIsNew()>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sitemanager')#
				</label>
				
				<label for="m2" class="checkbox inline">
					<input name="moduleAssign" type="CHECKBOX" id="m2" value="00000000000000000000000000000000003" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000003')>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#
				</label>

				<cfif application.settingsManager.getSite(rc.siteid).getdatacollection()>
					<label for="m3" class="checkbox inline">
						<input name="moduleAssign" type="CHECKBOX" id="m3" value="00000000000000000000000000000000004" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000004')>checked </cfif> class="checkbox">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.formsmanager')#
					</label>
				</cfif>

				<cfif application.settingsManager.getSite(rc.siteid).getemailbroadcaster()>
					<label for="m4" class="checkbox inline">
						<input name="moduleAssign" type="CHECKBOX" id="m4"  value="00000000000000000000000000000000005" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000005')>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.emailbroadcaster')#
					</label>
				</cfif>
			</div>
		</div>
	</cfif>

	<cfif rc.type eq 'Form'>
		<div class="control-group">
			<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.formpresentation')#</label>
			<div class="controls">
				<label for="rc" class="checkbox">
	      			<input name="responseChart" id="rc" type="CHECKBOX" value="1" <cfif rc.contentBean.getresponseChart() eq 1>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.ispoll')#
	      		</label>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">
				 #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.confirmationmessage')#
			</label>
			<div class="controls">
				<textarea name="responseMessage" rows="6" class="span12">#HTMLEditFormat(rc.contentBean.getresponseMessage())#</textarea>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.responsesendto')#
			</label>
			<div class="controls">
				<input type="text" name="responseSendTo" value="#HTMLEditFormat(rc.contentBean.getresponseSendTo())#" class="span12">
			</div>
		</div> 
	</cfif>

	<cfif rc.ptype eq 'Calendar' and ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>	
		<cfinclude template="dsp_displaycontent.cfm">
	</cfif>

	</div> <!--- / .fieldset --->
	
	<span id="extendset-container-basic" class="extendset-container"></span>

	<span id="extendset-container-tabbasicbottom" class="extendset-container"></span>

</div>
</cfoutput>