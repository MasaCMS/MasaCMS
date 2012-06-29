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

	<cfinclude template="dsp_type_selector.cfm">
	
	<cfswitch expression="#rc.type#">
		<cfcase value="Page,Portal,Calendar,Gallery,File,Link">
			<div class="control-group">
			    <label class="control-label">
			    	<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.pageTitle"))#">
			    		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.title")#
					</a>
			    </label>
			    <div class="controls">
			     	<input type="text" id="title" name="title" value="#HTMLEditFormat(rc.contentBean.gettitle())#"  maxlength="255" class="textLong" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.titlerequired')#" <cfif not rc.contentBean.getIsNew() and not listFindNoCase('Link,File',rc.type)>onkeypress="openDisplay('editAdditionalTitles','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');"</cfif>>
			     </div>
		    </div>
				
			<div class="control-group">
		      	<label class="control-label">
		      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.AdditionalTitles"))#">
		      			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.AdditionalTitles")#
		      		</a>
		      		<a href="##" id="editAdditionalTitlesLink" onclick="javascript: toggleDisplay('editAdditionalTitles','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');return false">
		      			[#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.expand")#]
		      		</a>
		      	</label>
				<div class="controls" id="editAdditionalTitles" style="display:none;">
					<p class="notice help-block">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.AdditionalTitlesnote")#</p>
					<div class="control-group">
			      		<label class="control-label">
			      			<a href="##" rel="tooltip" title="#application.rbFactory.getKeyValue(session.rb,"tooltip.navigationTitle")#">
			      				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.menutitle")#
			      			</a>
			      		</label>
						<div class="controls">
							<input type="text" id="menuTitle" name="menuTitle" value="#HTMLEditFormat(rc.contentBean.getmenuTitle())#"  maxlength="255" class="textLong">
						</div>
					</div>
							
					<div class="control-group">
			      		<label class="control-label">
			      			<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.urlTitle"))#">
			      				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.urltitle")#
			      			</a>
			      		</label>
						<div class="controls">
							<input type="text" id="urlTitle" name="urlTitle" value="#HTMLEditFormat(rc.contentBean.getURLTitle())#"  maxlength="255" class="textLong">
						</div>
					</div>
						
					<div class="control-group">
			      		<label class="control-label">
			      			<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.htmlTitle"))#">
			      				#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.htmltitle")#
			      			</a>
			      		</label>
						<div class="controls">
							<input type="text" id="htmlTitle" name="htmlTitle" value="#HTMLEditFormat(rc.contentBean.getHTMLTitle())#"  maxlength="255" class="textLong">
						</div>
					</div>
				</div>
			</div>

		</cfcase>
		<cfdefaultcase>
			<input type="hidden" id="menuTitle" name="menuTitle" value="">
			<div class="control-group">
	      		<label class="control-label">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#
	      		</label>
	     		 <div class="controls">
	     		 	<input type="text" id="title" name="title" value="#HTMLEditFormat(rc.contentBean.getTitle())#"  maxlength="255" class="textLong" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.titlerequired')#">
	     		</div>
	     	</div>
		</cfdefaultcase>
	</cfswitch>

	<cfif listFind("Page,Portal,Calendar,Gallery,Link",rc.type)>
		<cfinclude template="dsp_file_selector.cfm">
	</cfif>	

	<cfif rc.type neq 'Form' and  rc.type neq 'Component' >	
		<div class="control-group summaryContainer" style="display:none;">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.contentSummary"))#">
	      			#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.summary")#
	      		</a> 
	      		<a href="##" id="editSummaryLink" onclick="javascript: toggleDisplay('editSummary','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#'); editSummary();return false">
	      			[#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.expand")#]
	      		</a>
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
		<div class="control-group body-container">
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
			</div>
		</div>
		
	<cfelseif rc.type eq 'Link'>
		<div class="control-group">
	      	<label class="control-label">
	      		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.url")#
	      	</label>
	     	<div class="controls">
	     	 	<input type="text" id="url" name="filename" value="#HTMLEditFormat(rc.contentBean.getfilename())#" class="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.urlrequired')#">
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
				<label for="m1" class="checkbox">
					<input name="moduleAssign" type="CHECKBOX" id="m1" value="00000000000000000000000000000000000" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000000') or rc.contentBean.getIsNew()>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.sitemanager')#
				</label>
				
				<label for="m2" class="checkbox">
					<input name="moduleAssign" type="CHECKBOX" id="m2" value="00000000000000000000000000000000003" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000003')>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#
				</label>

				<cfif application.settingsManager.getSite(rc.siteid).getdatacollection()>
					<label for="m3" class="checkbox">
						<input name="moduleAssign" type="CHECKBOX" id="m3" value="00000000000000000000000000000000004" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000004')>checked </cfif> class="checkbox">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.formsmanager')#
					</label>
				</cfif>

				<cfif application.settingsManager.getSite(rc.siteid).getemailbroadcaster()>
					<label for="m4" class="checkbox">
						<input name="moduleAssign" type="CHECKBOX" id="m4"  value="00000000000000000000000000000000005" <cfif listFind(rc.contentBean.getmoduleAssign(),'00000000000000000000000000000000005')>checked </cfif> class="checkbox"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.emailbroadcaster')#
					</label>
				</cfif>
			</div>
		</div>
	</cfif>

	<span id="extendSetsBasic"></span>

	<cfif rc.type eq 'Form'>
		<div class="control-group">
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
				<textarea name="responseMessage">#HTMLEditFormat(rc.contentBean.getresponseMessage())#</textarea>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">
				#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.responsesendto')#
			</label>
			<div class="controls">
				<input name="responseSendTo" value="#HTMLEditFormat(rc.contentBean.getresponseSendTo())#" class="text">
			</div>
		</div> 
	</cfif>

	<cfif rc.type neq 'Component' and rc.type neq 'Form'>
		<div class="control-group">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.contentReleaseDate"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.releasedate')#
	      		</a>
	      	</label>
	      	<div class="controls">
				<input type="text" class="datepicker textAlt" name="releaseDate" value="#LSDateFormat(rc.contentBean.getreleasedate(),session.dateKeyFormat)#"  maxlength="12" >
				<select name="releasehour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getReleaseDate())  and h eq 12 or (LSisDate(rc.contentBean.getReleaseDate()) and (hour(rc.contentBean.getReleaseDate()) eq h or (hour(rc.contentBean.getReleaseDate()) - 12) eq h or hour(rc.contentBean.getReleaseDate()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
				<select name="releaseMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getReleaseDate()) and minute(rc.contentBean.getReleaseDate()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
				<select name="releaseDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getReleaseDate()) and hour(rc.contentBean.getReleaseDate()) gte 12>selected</cfif>>PM</option></select>
			</div>
		</div>
	</cfif>	
		
	<cfif ((rc.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all') or (rc.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none')) and rc.contentid neq '00000000000000000000000000000000001'>
		<cfset bydate=iif(rc.contentBean.getdisplay() EQ 2 or (rc.ptype eq 'Calendar' and rc.contentBean.getIsNew()),de('true'),de('false'))>
		
		<div class="control-group">
	      	<label class="control-label">
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.displayContent"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#
	      		</a>
	      	</label>
	      	<div class="controls">
	      		<select name="display" class="dropdown" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editDates',true):toggleDisplay2('editDates',false);">
					<option value="1"  <cfif  rc.contentBean.getdisplay() EQ 1> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
					<option value="0"  <cfif  rc.contentBean.getdisplay() EQ 0> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
					<option value="2"  <cfif  bydate> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
				</select>
			</div>
			<div class="controls" id="editDates" <cfif  not bydate>style="display: none;"</cfif>>
				<div class="control-group">
					<label class="control-label">
					#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="displayStart" value="#LSDateFormat(rc.contentBean.getdisplaystart(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="starthour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getdisplaystart())  and h eq 12 or (LSisDate(rc.contentBean.getdisplaystart()) and (hour(rc.contentBean.getdisplaystart()) eq h or (hour(rc.contentBean.getdisplaystart()) - 12) eq h or hour(rc.contentBean.getdisplaystart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="startMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getdisplaystart()) and minute(rc.contentBean.getdisplaystart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="startDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getdisplaystart()) and hour(rc.contentBean.getdisplaystart()) gte 12>selected</cfif>>PM</option></select>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="displayStop" value="#LSDateFormat(rc.contentBean.getdisplaystop(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="stophour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getdisplaystop())  and h eq 11 or (LSisDate(rc.contentBean.getdisplaystop()) and (hour(rc.contentBean.getdisplaystop()) eq h or (hour(rc.contentBean.getdisplaystop()) - 12) eq h or hour(rc.contentBean.getdisplaystop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="stopMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rc.contentBean.getdisplaystop()) and m eq 59) or (LSisDate(rc.contentBean.getdisplaystop()) and minute(rc.contentBean.getdisplaystop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="stopDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rc.contentBean.getdisplaystop()) and (hour(rc.contentBean.getdisplaystop()) gte 12)) or not LSisDate(rc.contentBean.getdisplaystop())>selected</cfif>>PM</option></select>
					</div>
				</div>
			</div>
		</div>
		
		<cfif rc.type neq 'Component' and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all' and rc.type neq 'Form'>
			<div class="control-group">
	      		<label class="control-label">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentparent')#:
	      			<span id="move" class="text"> 
	      				<cfif rc.contentBean.getIsNew()>
	      					"#rc.crumbData[1].menutitle#"<cfelse>"#rc.crumbData[2].menutitle#"
	      				</cfif>
						&nbsp;&nbsp;<a href="javascript:##;" onclick="javascript: loadSiteParents('#rc.siteid#','#rc.contentid#','#rc.parentid#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectnewparent')#]</a>
						<input type="hidden" name="parentid" value="#rc.parentid#">
					</span>
				</label>
			</div>
		<cfelse>
		 	<input type="hidden" name="parentid" value="#rc.parentid#">
		</cfif>
	<cfelse>
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
		
	</cfif>

	<cfif listFind("Page,Portal,Calendar,Gallery,Link,File,Link",rc.type)>
		<div class="control-group">
	      	<label class="control-label">
	      		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expires')#
	      	</label>
	     	<div class="controls" id="expires-date-selector">
					<input type="text" name="expires" value="#LSDateFormat(rc.contentBean.getExpires(),session.dateKeyFormat)#" class="textAlt datepicker">
					<select name="expireshour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getExpires())  and h eq 12 or (LSisDate(rc.contentBean.getExpires()) and (hour(rc.contentBean.getExpires()) eq h or (hour(rc.contentBean.getExpires()) - 12) eq h or hour(rc.contentBean.getExpires()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
					<select name="expiresMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getExpires()) and minute(rc.contentBean.getExpires()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
					<select name="expiresDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getExpires()) and hour(rc.contentBean.getExpires()) gte 12>selected</cfif>>PM</option></select>
			</div>
			<div class="controls" id="expires-notify">
				<label for="dspexpiresnotify" class="checkbox">
						<input type="checkbox" name="dspExpiresNotify" id="dspexpiresnotify" onclick="loadExpiresNotify('#rc.siteid#','#rc.contenthistid#','#rc.parentid#');"  class="checkbox">
				</label>
			</div>
			<div class="controls" id="selectExpiresNotify" style="display: none;"></div>
		</div>
	</cfif>

	<cfif rc.type neq 'Component' and rc.type neq 'Form' and  rc.contentid neq '00000000000000000000000000000000001'>
		<div class="control-group">
		    <label class="control-label">
		     	#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isfeature')#
		    </label>
		    <div class="controls">
		    	<select name="isFeature" class="dropdown" onchange="javascript: this.selectedIndex==2?toggleDisplay2('editFeatureDates',true):toggleDisplay2('editFeatureDates',false);">
					<option value="0"  <cfif  rc.contentBean.getisfeature() EQ 0> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</option>
					<option value="1"  <cfif  rc.contentBean.getisfeature() EQ 1> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</option>
					<option value="2"  <cfif rc.contentBean.getisfeature() EQ 2> selected</CFIF>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.perstopstart')#</option>
				</select>
			</div>
			<div class="controls" id="editFeatureDates" <cfif rc.contentBean.getisfeature() NEQ 2>style="display: none;"</cfif>>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.startdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="featureStart" value="#LSDateFormat(rc.contentBean.getFeatureStart(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="featureStartHour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getFeatureStart())  and h eq 12 or (LSisDate(rc.contentBean.getFeatureStart()) and (hour(rc.contentBean.getFeatureStart()) eq h or (hour(rc.contentBean.getFeatureStart()) - 12) eq h or hour(rc.contentBean.getFeatureStart()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="featureStartMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif LSisDate(rc.contentBean.getFeatureStart()) and minute(rc.contentBean.getFeatureStart()) eq m>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="featureStartDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif LSisDate(rc.contentBean.getFeatureStart()) and hour(rc.contentBean.getFeatureStart()) gte 12>selected</cfif>>PM</option></select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.stopdatetime')#
					</label>
					<div class="controls">
						<input type="text" name="featureStop" value="#LSDateFormat(rc.contentBean.getFeatureStop(),session.dateKeyFormat)#" class="textAlt datepicker">
						<select name="featureStophour" class="dropdown"><cfloop from="1" to="12" index="h"><option value="#h#" <cfif not LSisDate(rc.contentBean.getFeatureStop())  and h eq 11 or (LSisDate(rc.contentBean.getFeatureStop()) and (hour(rc.contentBean.getFeatureStop()) eq h or (hour(rc.contentBean.getFeatureStop()) - 12) eq h or hour(rc.contentBean.getFeatureStop()) eq 0 and h eq 12))>selected</cfif>>#h#</option></cfloop></select>
						<select name="featureStopMinute" class="dropdown"><cfloop from="0" to="59" index="m"><option value="#m#" <cfif (not LSisDate(rc.contentBean.getFeatureStop()) and m eq 59) or (LSisDate(rc.contentBean.getFeatureStop()) and minute(rc.contentBean.getFeatureStop()) eq m)>selected</cfif>>#iif(len(m) eq 1,de('0#m#'),de('#m#'))#</option></cfloop></select>
						<select name="featureStopDayPart" class="dropdown"><option value="AM">AM</option><option value="PM" <cfif (LSisDate(rc.contentBean.getFeatureStop()) and (hour(rc.contentBean.getFeatureStop()) gte 12)) or not LSisDate(rc.contentBean.getFeatureStop())>selected</cfif>>PM</option></select>
					</div>
				</div>
			</div>
		</div>

		<div class="control-group">
		     <div class="controls">
		      	<label for="isNav" class="checkbox">
		      		<input name="isnav" id="isNav" type="CHECKBOX" value="1" <cfif rc.contentBean.getisnav() eq 1 or rc.contentBean.getisNew() eq 1>checked</cfif> class="checkbox"> 
		      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.includeSiteNav"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.isnav')#
		      		</a>
		      	</label>
		    </div>
		</div>

		<div class="control-group">
		    <div class="controls">
		     	<label for="Target" class="checkbox">
		     	<input  name="target" id="Target" type="CHECKBOX" value="_blank" <cfif rc.contentBean.gettarget() eq "_blank">checked</cfif> class="checkbox" onclick="javascript: this.checked?toggleDisplay2('editTargetParams',true):toggleDisplay2('editTargetParams',false);"> 
		     		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.openNewWindow"))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newwindow')#
		     		</a>
		     	</label>
		     </div>  
			<div class="controls" id="editTargetParams" <cfif  rc.contentBean.gettarget() neq "_blank">style="display: none;"</cfif>>
				<cfinclude template="dsp_buildtargetparams.cfm"> <input name="targetParams" value="#rc.contentBean.getTargetParams()#" type="hidden">
			</div>
		</div>
	</cfif>

	<div class="control-group">
		<div class="controls">
	   		<label for="dspnotify" class="checkbox">
	      		<input type="checkbox" name="dspNotify"  id="dspnotify" onclick="loadNotify('#rc.siteid#','#rc.contentid#','#rc.parentid#');"  class="checkbox"> 
	      		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"tooltip.notifyReview"))#">
	      			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notifyforreview')#
	      		</a>
	      	</label>
	  	</div>
	     <div class="controls" id="selectNotify" style="display: none;"></div>
	</div>

	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addnotes')# <a href="" id="editNoteLink" onclick="toggleDisplay('editNote','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.close')#');return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.expand')#]</a>
		</label>
		<div class="controls" id="editNote" style="display: none;">
			<textarea name="notes" rows="8" class="alt" id="abstract"></textarea>	
		</div>
	</div>
</div>
</cfoutput>