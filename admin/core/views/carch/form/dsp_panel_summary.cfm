<!--- 
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the  
same licensing model. It is, therefore, licensed under the Gnu General Public License 
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing 
notice set out below. That exception is also granted by the copyright holders of Masa CMS 
also applies to this file and Masa CMS in general. 

This file has been modified from the original version received from Mura CMS. The 
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright 
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained 
only to ensure software compatibility, and compliance with the terms of the GPLv2 and 
the exception set out below. That use is not intended to suggest any commercial relationship 
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa. 

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com  

Masa CMS is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, Version 2 of the License. 
Masa CMS is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>. 

The original complete licensing notice from the Mura CMS version of this file is as 
follows: 

This file is part of Mura CMS.

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
<cfset tabList=listAppend(tabList,"tabSummary")>
<cfoutput>
<div class="mura-panel panel">
	<div class="mura-panel-heading" role="tab" id="heading-summary">
		<h4 class="mura-panel-title">
			<a class="collapse collapsed" role="button" data-toggle="collapse" data-parent="##content-panels" href="##panel-summary" aria-expanded="true" aria-controls="panel-summary">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.summary")#</a>
		</h4>
	</div>
	<div id="panel-summary" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading-summary" aria-expanded="false" style="height: 0px;">
		<div class="mura-panel-body">

<!--- todo: add new tabs extendset containers to layout UI/Tab selection --->
			<span id="extendset-container-tabsummarytop" class="extendset-container"></span>

			<!--- metadata --->
			<div class="help-block" id="mura-content-metadata">
				<cfif not rc.contentBean.getIsNew()>
					<cfif listFindNoCase(rc.$.getBean('contentManager').TreeLevelList,rc.type)>
						<cfset rsRating=application.raterManager.getAvgRating(rc.contentBean.getcontentID(),rc.contentBean.getSiteID()) />
						<cfif rsRating.recordcount>
							<span class="meta-label">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.votes")#: <span><cfif rsRating.recordcount>#rsRating.theCount#<cfelse>0</cfif></span></span>
							<span class="meta-label">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.averagerating")#: <img id="ratestars" src="assets/images/rater/star_#application.raterManager.getStarText(rsRating.theAvg)#.gif" alt="#rsRating.theAvg# stars" border="0"></span>
						</cfif>
					</cfif>
					<cfif rc.type eq "file" and rc.contentBean.getMajorVersion()>
							<span class="meta-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.file')#: <span>#rc.contentBean.getMajorVersion()#.#rc.contentBean.getMinorVersion()#</span></span>
					</cfif>
					</cfif>
					<span class="meta-label">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.update")#: <span>#LSDateFormat(parseDateTime(rc.contentBean.getlastupdate()),session.dateKeyFormat)# #LSTimeFormat(parseDateTime(rc.contentBean.getlastupdate()),"short")#</span></span>
					<span class="meta-label">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.status")#:
						<span>
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
						</span>
					</span>

					<cfif listFind("Gallery,Link,Folder,Page,Calendar",rc.type)>
						<span class="meta-label">
				      	#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.currentfilename')#: 
						<cfif rc.contentBean.getContentID() eq "00000000000000000000000000000000001">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.emptystring')#<cfelseif len(rc.contentID) and len(rc.contentBean.getcontentID())><span class="clicktocopy">#rc.contentBean.getFilename()#</span><cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif>
						</span>
					</cfif>
					<span class="meta-label meta-label-wide">
				      #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentid')#: 
				      <cfif len(rc.contentID) and len(rc.contentBean.getcontentID())><span class="clicktocopy">#rc.contentBean.getcontentID()#</span><cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif>
				    </span>

					<div class="clearfix"></div>
		  		</div> <!--- /metadata .help-block --->

				<!--- summary --->
				<cfif not ListFindNoCase('Form,Component',rc.type) >
					<div class="mura-control-group summaryContainer" style="display:none;">
				      	<label>
					    	<span data-toggle="popover" title="" data-placement="right"
					    	data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.contentSummary"))#"
					    	data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.summary"))#">
					    		#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.fields.summary")# <i class="mi-question-circle"></i></span>
			      		</label>
				      	<div id="editSummary" class="summaryContainer" style="display:none;">
						<cfoutput>
							<textarea name="summary" id="summary" cols="96" rows="10"><cfif application.configBean.getValue("htmlEditorType") neq "none" or len(rc.contentBean.getSummary())>#esapiEncode('html',rc.contentBean.getSummary())#<cfelse><p></p></cfif></textarea>
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
					     		  	customConfig : 'config.js.cfm'
								},
								function(editorInstance){
									htmlEditorOnComplete(editorInstance);
									if (!hasBody){
										showPreview();
									}
								}
					     	);
							}
						}
						<cfif not isExtended>
						showSummaryEditor();
						</cfif>
					</script>
				</cfif>
				<!--- /summary --->

				<cfif listFindNoCase('Page,Folder,Calendar,Gallery,File,Link',rc.type)>
					<!--- credits --->
					<div class="mura-control-group">
					  <label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.credits')#</label>
					  <input type="text" id="credits" name="credits" value="#esapiEncode('html_attr',rc.contentBean.getCredits())#"  maxlength="255">
					</div>

					<!--- meta description, keywords, canonical URL --->
					<cfif rc.moduleid eq '00000000000000000000000000000000000' and not len(tabAssignments) or listFindNocase(tabAssignments,'SEO')>
						<div class="mura-control-group">
							<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.description')#</label>
							<textarea name="metadesc" id="metadesc">#esapiEncode('html',rc.contentBean.getMETADesc())#</textarea>
						</div>
						<cfif application.configBean.getValue(property='keepMetaKeywords',defaultValue=false)>
							<div class="mura-control-group">
								<label>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.keywords')#</label>
								<textarea name="metakeywords" rows="3" id="metakeywords">#esapiEncode('html',rc.contentBean.getMetaKeywords())#</textarea>
							</div>
						</cfif>
						<div class="mura-control-group">
							<label>Canonical URL</label>
							<input type="text" id="canonicalURL" name="canonicalURL" value="#esapiEncode('html_attr',rc.contentBean.getCanonicalURL())#"  maxlength="255">
						</div>
					</cfif>

				</cfif>

				<!--- notes --->
				<div class="mura-control-group">
					<label>
						<!--- todo: change this rb key to simply 'Notes' --->
						#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addnotes')#
					</label>
					<textarea name="notes" rows="3" id="abstract">#esapiEncode('html',rc.contentBean.getNotes())#</textarea>
				</div> <!--- /end mura-control-group --->


				<div class="mura-control-group extendedattributes-group" id="extendedattributes-container-summary">
					<div class="bigui" id="bigui__summary" data-label="Manage Extended Attributes">
						<div class="bigui__title">Manage Extended Attributes</div>
						<div class="bigui__controls">
							<span id="extendset-container-tabextendedattributestop"></span>
							<span id="extendset-container-summary" class="extendset-container extendedattributes-body" data-controlparent="extendedattributes-container-summary"></span>
							<span id="extendset-container-tabextendedattributesbottom"></span>
						</div>
					</div>
					<!--- /.bigui --->
				</div>
			<span id="extendset-container-tabsummarybottom" class="extendset-container"></span>
		</div>
	</div>
</div> 



</cfoutput>
