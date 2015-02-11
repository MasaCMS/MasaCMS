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

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/admin/
/tasks/
/config/
/requirements/mura/
You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
<cfset rsThemes=rc.siteBean.getThemes() />
<cfset variables.pluginEvent=createObject("component","mura.event").init(request.event.getAllValues())/>
<cfset rsSites=application.settingsManager.getList() />
<cfset extendSets=application.classExtensionManager.getSubTypeByName("Site","Default",rc.siteid).getExtendSets(inherit=true,container="Default",activeOnly=true) />
<cfparam name="rc.action" default="">
<cfset rsPluginScripts=application.pluginManager.getScripts("onSiteEdit",rc.siteID)>
</cfsilent>

<h1>Site Settings</h1>
<cfoutput>
	<cfif len(rc.siteid)>
		<div id="nav-module-specific" class="btn-group"> <a class="btn" href="./?muraAction=cExtend.listSubTypes&siteid=#esapiEncode('url',rc.siteid)#"><i class="icon-list-alt"></i> Class Extension Manager</a> <a  class="btn" href="./?muraAction=cTrash.list&siteID=#esapiEncode('url',rc.siteid)#"><i class="icon-trash"></i> Trash Bin</a>
			<cfif rc.action eq "updateFiles">
				<a href="./?muraAction=cSettings.editSite&siteid=#esapiEncode('url',rc.siteid)#"><i class="icon-pencil"></i> Edit Site</a>
				<cfelseif application.configBean.getAllowAutoUpdates() and  listFind(session.mura.memberships,'S2')>
				<a  class="btn" href="##" onclick="confirmDialog('WARNING: Do not update your site files unless you have backed up your current siteID directory.',function(){actionModal('./?muraAction=cSettings.editSite&siteid=#esapiEncode('url',rc.siteid)#&action=updateFiles#rc.$.renderCSRFTokens(context=rc.siteid & 'updatesite',format='url')#')});return false;"><i class="icon-bolt"></i> Update Site Files to Latest Version</a> 
			</cfif>
			<cfif application.configBean.getJavaEnabled()>
			<a  class="btn" href="?muraAction=cSettings.selectBundleOptions&siteID=#esapiEncode('url',rc.siteBean.getSiteID())#"><i class="icon-gift"></i> Create Site Bundle</a>
			</cfif>
			<cfif len(rc.siteBean.getExportLocation()) and directoryExists(rc.siteBean.getExportLocation())>
				<a  class="btn" href="##"  onclick="confirmDialog('Export static HTML files to #esapiEncode("javascript","'#rc.siteBean.getExportLocation()#'")#.',function(){actionModal('./?muraAction=csettings.exportHTML&siteID=#rc.siteBean.getSiteID()#')});return false;"><i class="icon-share"></i> Export Static HTML (BETA)</a>
			</cfif>
		</div>
	</cfif>
</cfoutput>
<cfif rc.action neq "updateFiles">
	<cfoutput>
		<form novalidate method ="post"  enctype="multipart/form-data" action="./?muraAction=cSettings.updateSite" name="form1"  onsubmit="return validate(this);">
		<!---
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/ajax.js"></script>'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/tab-view.js"></script>'>
 --->
		<cfsavecontent variable="actionButtons">
		<cfoutput>
			<div class="form-actions">
				<cfif rc.siteBean.getsiteid() eq ''>
					<button type="button" class="btn" onclick="submitForm(document.forms.form1,'add');"><i class="icon-plus-sign"></i> Add</button>
					<cfelse>
					<cfif rc.siteBean.getsiteid() neq 'default' and listFind(session.mura.memberships,'S2')>
						<button type="button" class="btn" onclick="return confirmDialog('#esapiEncode("javascript","WARNING: A deleted site and all of its files cannot be recovered. Are you sure that you want to continue?")#',function(){actionModal('./?muraAction=cSettings.updateSite&action=delete&siteid=#rc.siteBean.getSiteID()#')});"><i class="icon-remove-sign"></i> Delete</button>
					</cfif>
					<button type="button" class="btn" onclick="submitForm(document.forms.form1,'update');"><i class="icon-ok-sign"></i> Update</button>
				</cfif>
			</div>
		</cfoutput>
		</cfsavecontent>
		<cfif arrayLen(extendSets)>
			<cfset tabLabelList='Basic,Contact Info,Shared Resources,Modules,Email,Images,Extranet,Display Regions,Extended Attributes,Deploy Bundle,Razuna'>
			<cfset tabList='tabBasic,tabContactinfo,tabSharedresources,tabModules,tabEmail,tabImages,tabExtranet,tabDisplayregions,tabExtendedAttributes,tabBundles,tabRazuna'>
			<cfelse>
			<cfset tabLabelList='Basic,Contact Info,Shared Resources,Modules,Email,Images,Extranet,Display Regions,Deploy Bundle,Razuna'>
			<cfset tabList='tabBasic,tabContactinfo,tabSharedresources,tabModules,tabEmail,tabImages,tabExtranet,tabDisplayregions,tabBundles,tabRazuna'>
		</cfif>
	</cfoutput> <cfoutput query="rsPluginScripts" group="pluginid"> <cfoutput>
			<cfset tabLabelList=listAppend(tabLabelList,rsPluginScripts.name)/>
			<cfset tabList=listAppend(tabList,"tab" & $.createCSSID(rsPluginScripts.name))>
		</cfoutput> </cfoutput> <cfoutput>
		<div class="tabbable tabs-left mura-ui">
		<ul class="nav nav-tabs tabs initActiveTab">
				<cfloop from="1" to="#listlen(tabList)#" index="t">
				<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
			</cfloop>
			</ul>
		<div class="tab-content">
		<!--- Basic --->
		<div id="tabBasic" class="tab-pane fade">
				<div class="fieldset">
				<div class="control-group">
						<div class="span6">
						<label class="control-label">Site ID</label>
						<div class="controls">
								<cfif rc.siteid eq ''>
								<input name="siteid" type="text" class="span12" value="#rc.siteBean.getsiteid()#" size="25" maxlength="25" required="true" onchange="removePunctuation(this);">
								<p class="help-block alert">Warning: No spaces, punctuation, dots or file delimiters allowed.</p>
								<cfelse>
								<input class="span12"  id="disabledInput" type="text" placeholder="#rc.siteBean.getsiteid()#" disabled>
								<input name="siteid" type="hidden" value="#rc.siteBean.getsiteid()#">
							</cfif>
							</div>
					</div>
						<div class="span6">
						<label class="control-label">Site Name</label>
						<div class="controls">
								<input name="site" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getsite())#" size="50" maxlength="50">
							</div>
					</div>
					</div>

				<!--- Tagline --->
				<div class="control-group">
					<label class="control-label">
						<a href="##" rel="tooltip" title="#rc.$.rbKey('siteconfig.sitesettings.tagline.tooltip')#">
							#rc.$.rbKey('siteconfig.sitesettings.tagline')# 
							<i class="icon-question-sign"></i>
						</a>
					</label>
					<div class="controls">
						<input name="tagline" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getTagline())#" size="50" maxlength="255">
					</div>
				</div>

				<!--- Domain --->
				<div class="control-group">
					<div class="span6">
						<div>
							<label class="control-label">
								<a href="##" rel="tooltip" title="#rc.$.rbKey('siteconfig.sitesettings.primarydomain.tooltip')#">
									#rc.$.rbKey('siteconfig.sitesettings.primarydomain')#
									<i class="icon-question-sign"></i>
								</a>
							</label>
							<div class="controls">
								<input name="domain" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getdomain('production'))#" size="50" maxlength="255">
							</div>
						</div>
					</div>

					<div class="span6">
						<label class="control-label">Domain Alias List <span>(Line Delimited)</span></label>
						<div class="controls">
							<textarea rows="6" class="span12" name="domainAlias" rows="6" class="span12" >#esapiEncode('html',rc.siteBean.getDomainAlias())#</textarea>
						</div>
					</div>
				</div>

				<div class="control-group">          
					<!--- Enforce Primary --->
					<div class="span6">
						<label class="control-label">Enforce Primary Domain</label>
						<div class="controls">
							<label class="radio inline">
								<input type="radio" name="enforcePrimaryDomain" value="0"<cfif rc.siteBean.getEnforcePrimaryDomain() neq 1> CHECKED</CFIF>>
								Off
							</label>
							<label class="radio inline">
								<input type="radio" name="enforcePrimaryDomain" value="1"<cfif rc.siteBean.getEnforcePrimaryDomain() eq 1> CHECKED</CFIF>>
								On
							</label>
						</div>
					</div>

					<!--- Use SSL (Sitewide) --->
					<div class="span6">
						<label class="control-label"><a href="##" rel="tooltip" title="#rc.$.rbKey('siteconfig.sitesettings.usessl.tooltip')#">#rc.$.rbKey('siteconfig.sitesettings.usessl')# <i class="icon-question-sign"></i></a></label>
						<div class="controls">
							<label class="radio inline">
								<input type="radio" name="useSSL" value="0"<cfif rc.siteBean.getUseSSL() neq 1> CHECKED</CFIF>>
								#rc.$.rbKey('sitemanager.no')#
							</label>
							<label class="radio inline">
								<input type="radio" name="useSSL" value="1"<cfif rc.siteBean.getUseSSL() eq 1> CHECKED</CFIF>>
								#rc.$.rbKey('sitemanager.yes')#
							</label>
						</div>
					</div>
				</div>

				<div class="control-group">
						<div class="span6">
						<label class="control-label">Locale</label>
						<div class="controls">
								<select name="siteLocale">
								<option value="">Default</option>
								<cfloop list="#listSort(server.coldfusion.supportedLocales,'textnocase','ASC')#" index="l">
										<option value="#l#"<cfif rc.siteBean.getSiteLocale() eq l> selected</cfif>>#l#</option>
									</cfloop>
							</select>
							</div>
					</div>
						<div class="span6">
						<label class="control-label">Theme</label>
						<div class="controls">
								<select name="theme">
								<cfif rc.siteBean.hasNonThemeTemplates()>
										<option value="">None</option>
									</cfif>
								<cfloop query="rsThemes">
										<option value="#rsThemes.name#"<cfif rsThemes.name eq rc.siteBean.getTheme() or (not len(rc.siteBean.getSiteID()) and rsThemes.currentRow eq 1)> selected</cfif>>#rsThemes.name#</option>
									</cfloop>
							</select>
							</div>
					</div>
					</div>
				<div class="control-group">
						<div class="span6">
						<label class="control-label">Page Limit</label>
						<div class="controls">
								<input name="pagelimit" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getpagelimit())#" size="5" maxlength="6">
							</div>
					</div>
						<div class="span6">
						<label class="control-label">Default  Rows <span>(in Site Manager)</span></label>
						<div class="controls">
								<input name="nextN" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getnextN())#" size="5" maxlength="5">
							</div>
					</div>
				</div>
				<div class="control-group">
						<div class="span6">
						<label class="control-label">Site Caching</label>
						<div class="controls">
								<label class="radio inline">
								<input type="radio" name="cache" value="0"<cfif rc.siteBean.getcache() neq 1> CHECKED</CFIF>>
								Off</label>
								<label class="radio inline">
								<input type="radio" name="cache" value="1"<cfif rc.siteBean.getcache() eq 1> CHECKED</CFIF>>
								On</label>
							</div>
					</div>
						<!---
						<div class="span4">
						<label class="control-label">Cache Capacity <span class="help-inline">(0=Unlimited)</span></label>
						<div class="controls">
								<input name="cacheCapacity" type="text" class="span3" value="#esapiEncode('html_attr',rc.siteBean.getCacheCapacity())#" size="15" maxlength="15">
							</div>
					</div>--->
						<div class="span6">
						<label class="control-label">Cache Free Memory Threshold <span class="help-inline">(Defaults to 60%)</span></label>
						<div class="controls">
								<input name="cacheFreeMemoryThreshold" type="text" class="span2" value="#esapiEncode('html_attr',rc.siteBean.getCacheFreeMemoryThreshold())#" size="3" maxlength="3">
								% </div>
					</div>
					</div>
				<div class="control-group">
						<div class="span6">
						<label class="control-label">Lock Site Architecture</label>
						<div class="controls">
								<p class="help-block">Restricts Addition or Deletion of Site Content</p>
								<label class="radio inline">
								<input type="radio" name="locking" value="none" <cfif rc.siteBean.getlocking() eq 'none' or rc.siteBean.getlocking() eq ''> CHECKED</CFIF>>
								None</label>
								<label class="radio inline">
								<input type="radio" name="locking" value="all" <cfif rc.siteBean.getlocking() eq 'all'> CHECKED</CFIF>>
								All</label>
								<label class="radio inline">
								<input type="radio" name="locking" value="top" <cfif rc.siteBean.getlocking() eq 'top'> CHECKED</CFIF>>
								Top</label>
							</div>
					</div>
						<div class="span6">
						<label class="control-label">Allow Comments to be Posted Without Site Admin Approval</label>
						<div class="controls">
								<label class="radio inline">
								<input type="radio" name="CommentApprovalDefault" value="1" <cfif rc.siteBean.getCommentApprovalDefault()  eq 1> CHECKED</CFIF>>
								Yes</label>
								<label class="radio inline">
								<input type="radio" name="CommentApprovalDefault" value="0" <cfif rc.siteBean.getCommentApprovalDefault() neq 1> CHECKED</CFIF>>
								No</label>
						</div>
					</div>
				</div>
			 
				<div class="control-group">
						<label class="control-label">Static HTML Export Location (BETA)</label>
						<div class="controls">
						<cfif len(rc.siteBean.getExportLocation()) and not directoryExists(rc.siteBean.getExportLocation())>
								<p class="alert alert-error help-block">The current value is not a valid directory</p>
							</cfif>
						<input name="exportLocation" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getExportLocation())#" maxlength="100"/>
					</div>
				</div>
				 <div class="control-group">
						<label class="control-label">Custom Tag Groups <span class="help-inline">("^" Delimiter. List elements must use valid variable names.)</span></label>
						<div class="controls">
							<input name="customTagGroups" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getCustomTagGroups())#" maxlength="255"/>
						</div>
				</div>
				<div class="control-group">
						<label class="control-label">Site Mode</label>
						<div class="controls">
							<select name="enableLockdown">
									<option value=""<cfif rc.siteBean.getEnableLockdown() eq ""> selected</cfif>>Live</option>
									<option value="development"<cfif rc.siteBean.getEnableLockdown() eq "development"> selected</cfif>>Development</option>
									<option value="maintenance"<cfif rc.siteBean.getEnableLockdown() eq "maintenance"> selected</cfif>>Maintenance</option>
								</select>
						</div>
				</div>

				<!--- Lockable nodes --->
				<cfif application.configBean.getLockableNodes()>
					<div class="control-group">      
							<label class="control-label">Allow Content Locking</label>
							<div class="controls">
									<p class="help-block">Grants content editors the right to exlusively lock a content node and all of it's versions when editing.</p>
									<label class="radio inline">
									<input type="radio" name="hasLockableNodes" value="1" <cfif rc.siteBean.gethasLockableNodes()  eq 1> CHECKED</CFIF>>
									Yes</label>
									<label class="radio inline">
									<input type="radio" name="hasLockableNodes" value="0" <cfif rc.siteBean.gethasLockableNodes() neq 1> CHECKED</CFIF>>
									No</label>
								
								</div>      
					</div>
				</cfif> 
				<!--- /Lockable nodes --->

				<!--- Custom Context + Port --->
				<div class="control-group">
					<div class="span4">
						<label class="control-label">Is this a Remote Site?</label>
						<div class="controls">
								<label class="radio inline">
								<input type="radio" name="IsRemote" value="0"<cfif rc.siteBean.getIsRemote() neq 1> CHECKED</CFIF>>
								No</label>
								<label class="radio inline">
								<input type="radio" name="IsRemote" value="1"<cfif rc.siteBean.getIsRemote() eq 1> CHECKED</CFIF>>
								Yes</label>
						</div>
					</div>
					<div class="span4">
						<label class="control-label">Remote Context</label>
						<div class="controls">
							<input name="remotecontext" type="text" value="#esapiEncode('html_attr',rc.siteBean.getRemoteContext())#" class="span12" maxlength="100">
						</div>
					</div>
					<div class="span4">
						<label class="control-label">Remote Port</label>
						<div class="controls">
							<input name="remoteport" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getRemotePort())#"maxlength="4">
						</div>
					</div>
				</div>

				<div class="control-group">          
					<div class="span6">
						<div>
							<label class="control-label">
								<a href="##" rel="tooltip" title="#rc.$.rbKey('siteconfig.sitesettings.resourcedomain.tooltip')#">
									#rc.$.rbKey('siteconfig.sitesettings.resourcedomain')#
									<i class="icon-question-sign"></i>
								</a>
							</label>
							<div class="controls">
								<input name="resourcedomain" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getresourcedomain('production'))#" size="50" maxlength="255">
							</div>
						</div>
					</div>
					<div class="span6">
						<label class="control-label">#rc.$.rbKey('siteconfig.sitesettings.resourcessl')# </label>
						<div class="controls">
							<label class="radio inline">
								<input type="radio" name="resourceSSL" value="0"<cfif rc.siteBean.getResourceSSL() neq 1> CHECKED</CFIF>>
								#rc.$.rbKey('sitemanager.no')#
							</label>
							<label class="radio inline">
								<input type="radio" name="resourceSSL" value="1"<cfif rc.siteBean.getResourceSSL() eq 1> CHECKED</CFIF>>
								#rc.$.rbKey('sitemanager.yes')#
							</label>
						</div>
					</div>
				</div>
				<!--- /Custom Context + Port --->

				<!--- Google reCAPTCHA API Keys --->
				<div class="control-group">
					<!--- reCAPTCHA Site Key --->
					<div class="span4">
						<label class="control-label"><a href="" rel="tooltip" data-original-title="#$.rbKey('siteconfig.recaptcha.getapikeys')#">#$.rbKey('siteconfig.recaptcha.sitekey')# <i class="icon-question-sign"></i></a></label>
						<div class="controls">
								<input name="reCAPTCHASiteKey" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getReCAPTCHASiteKey())#" maxlength="50">
							</div>
					</div>
					<!--- reCAPTCHA Secret --->
					<div class="span4">
						<label class="control-label"><a href="" rel="tooltip" data-original-title="#$.rbKey('siteconfig.recaptcha.getapikeys')#">#$.rbKey('siteconfig.recaptcha.secret')# <i class="icon-question-sign"></i></a></label>
						<div class="controls">
								<input name="reCAPTCHASecret" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getReCAPTCHASecret())#" maxlength="50">
							</div>
					</div>
					<!--- reCAPTCHA Language --->
					<div class="span4">
						<label class="control-label"><a href="" rel="tooltip" data-original-title="#$.rbKey('siteconfig.recaptcha.languageoptions')#">#$.rbKey('siteconfig.recaptcha.language')# <i class="icon-question-sign"></i></a></label>
						<div class="controls">
							<cfset rc.langs = application.serviceFactory.getBean('utility').getReCAPTCHALanguages() />
							<cfset rc.sortedLangs = StructSort(rc.langs, 'textnocase', 'asc') />
							<select name="reCAPTCHALanguage" class="span12">
								<option value=""<cfif Not Len(rc.siteBean.getReCAPTACHALanguage())>
									selected</cfif>>- #$.rbKey('siteconfig.recaptcha.selectlanguage')# -</option>
								<cfloop array="#rc.sortedLangs#" index="lang">
									<option value="#rc.langs[lang]#"<cfif rc.siteBean.getReCAPTCHALanguage() eq rc.langs[lang]> selected</cfif>>#lang#</option>
								</cfloop>
							</select>
						</div>
					</div>
				</div>

				<cfif not Len(rc.siteBean.getReCAPTCHASiteKey()) or not Len(rc.siteBean.getReCAPTCHASecret())>
					<div class="control-group">
						<div class="alert alert-warning">
							#rc.$.rbKey('siteconfig.recaptcha.message')#
						</div>
						<div class="form-actions span12">
							<div class="controls">
								<a class="btn" href="http://www.google.com/recaptcha/admin" target="_blank">
									<i class="icon-key"></i> #rc.$.rbKey('siteconfig.recaptcha.getgooglekeys')#
								</a>
							</div>
						</div>
					</div>
				</cfif>
				<!--- /Google reCAPTCHA API Keys --->

			</div>
		</div>
				
		<!--- Default Contact Info --->
		<div id="tabContactinfo" class="tab-pane fade">
			<div class="fieldset">
					<div class="control-group">
						<div class="span6">
								<label class="control-label">Contact Name </label>
								<div class="controls">
									<input name="contactName" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getcontactName())#" size="50" maxlength="50" maxlength="100">
								</div>
						</div>
						
						<div class="span6">
								<label class="control-label">Contact Address </label>
								<div class="controls">
									<input name="contactAddress" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getcontactAddress())#" size="50" maxlength="50" maxlength="100">
								</div>
						</div>          
					</div>
					
					<div class="control-group">
						<div class="span6">
								<label class="control-label">Contact City </label>
								<div class="controls">
									<input name="contactCity" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getcontactCity())#" size="50" maxlength="50" maxlength="100">
								</div>
							</div>

						<div class="span2">
								<label class="control-label">Contact State </label>
								<div class="controls">
									<input name="contactState" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getcontactState())#" size="50" maxlength="50" maxlength="100">
								</div>
							</div>
						
						<div class="span4">
								<label class="control-label">Contact Zip </label>
								<div class="controls">
									<input name="contactZip" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getcontactZip())#" size="50" maxlength="50" maxlength="100">
								</div>
							</div>
						</div>
					
					<div class="control-group">
						<div class="span6">
								<label class="control-label">Contact Phone </label>
								<div class="controls">
								<input name="contactPhone" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getcontactPhone())#" size="50" maxlength="50" maxlength="100">
								</div>
						</div>
						
					<div class="span6">
							<label class="control-label">Contact Email </label>
							<div class="controls">
							<input name="contactEmail" type="text" class="span12"  value="#esapiEncode('html_attr',rc.siteBean.getcontactEmail())#" size="50" maxlength="50" maxlength="100">
							</div>
					</div>
						
					</div>
		 </div>
		</div>
		
		<!--- Shared Resources --->
		<div id="tabSharedresources" class="tab-pane fade">
				<div class="fieldset">
				<div class="control-group">
				<div class="span3">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.memberuserpool')#</label>
					<div class="controls">
							<select class="span12"  id="publicUserPoolID" name="publicUserPoolID" onchange="if(this.value!='' || jQuery('##privateUserPoolID').val()!=''){jQuery('##bundleImportUsersModeLI').hide();jQuery('##bundleImportUsersMode').attr('checked',false);}else{jQuery('##bundleImportUsersModeLI').show();}">
							<option value="">This site</option>
							<cfloop query="rsSites">
									<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
									<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getPublicUserPoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
								</cfif>
								</cfloop>
						</select>
						</div>
				</div>
				
				<div class="span3">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.systemuserpool')#</label>
				<div class="controls">
						<select class="span12"  id="privateUserPoolID" name="privateUserPoolID" onchange="if(this.value!='' || jQuery('##publicUserPoolID').val()!=''){jQuery('##bundleImportUsersModeLI').hide();jQuery('##bundleImportUsersMode').attr('checked',false);}else{jQuery('##bundleImportUsersModeLI').show();}">
						<option value="">This site</option>
						<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
								<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getPrivateUserPoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
							</cfif>
							</cfloop>
					</select>
					</div>
			</div>
			
				<div class="span3">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.advertiseruserpool')#</label>
				<div class="controls">
						<select class="span12"  name="advertiserUserPoolID">
						<option value="">This site</option>
						<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
								<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getAdvertiserUserPoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
							</cfif>
							</cfloop>
					</select>
					</div>
			</div>
				<div class="span3">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.displayobjectpool')#</label>
				<div class="controls">
						<select class="span12"  name="displayPoolID">
						<option value="">This site</option>
						<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
								<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getDisplayPoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
							</cfif>
							</cfloop>
					</select>
					</div>
					</div>
			</div>
	 
				<div class="control-group">
				 <div class="span3">
				<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.filepool')#</label>
				<div class="controls">
						<select class="span12"  name="filePoolID">
						<option value="">This site</option>
						<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
								<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getFilePoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
							</cfif>
							</cfloop>
					</select>
					</div>
				</div>
			 
				<div class="span3">
					<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.categorypool')#</label>
					<div class="controls">
						<select class="span12" id="categoryPoolID" name="categoryPoolID">
							<option value="">This site</option>
							<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
									<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getCategoryPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
								</cfif>
							</cfloop>
						</select>
					</div>
				</div>
		
				<div class="span3">
					 <label class="control-label">#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.contentpool')#</label>
					 <div class="controls">
							<select class="span12" id="contentPoolID" name="contentPoolID" multiple>
								<option value="#$.event('siteid')#" <cfif listFind(rc.siteBean.getContentPoolID(), $.event('siteid'))>selected</cfif>>This site</option>
								<cfloop query="rsSites">
									<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
										<option value="#rsSites.siteid#" <cfif listFind(rc.siteBean.getContentPoolID(), rsSites.siteid)>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
									</cfif>
								</cfloop>
							</select>
					 </div>
				</div>
			 
			</div>
		</div>
	</div>
		
		<!--- Modules --->
		<div id="tabModules" class="tab-pane fade">
			<div class="fieldset">
			
					<div class="control-group">
					
						<div class="span3">
							<label class="control-label">Extranet <span class="help-inline">(Password Protection)</span></label>
							<div class="controls">
									<label class="radio inline"><input type="radio" name="extranet" value="0" <cfif rc.siteBean.getextranet() neq 1> CHECKED</CFIF>>Off</label>
									<label class="radio inline"><input type="radio" name="extranet" value="1" <cfif rc.siteBean.getextranet()  eq 1> CHECKED</CFIF>>On</label>
							</div>
					</div>
					
						<div class="span3">
							<label class="control-label">Content Collections</label>
							<div class="controls">
									<label class="radio inline"><input type="radio" name="hasFeedManager" value="0" <cfif rc.siteBean.getHasFeedManager() neq 1> CHECKED</CFIF>>Off</label>
									<label class="radio inline"><input type="radio" name="hasFeedManager" value="1" <cfif rc.siteBean.getHasFeedManager()  eq 1> CHECKED</CFIF>>On</label>
							</div>
						</div>
						<cfif application.configBean.getDataCollection()>
						<div class="span3">
							<label class="control-label">Forms Manager</label>
							<div class="controls">
									<label class="radio inline">
									<input type="radio" name="dataCollection" value="0" <cfif rc.siteBean.getdataCollection() neq 1> CHECKED</CFIF>>Off</label>
									<label class="radio inline"><input type="radio" name="dataCollection" value="1" <cfif rc.siteBean.getdataCollection() eq 1> CHECKED</CFIF>>On</label>
							</div>
						</div>
						 </cfif>
					</div>

					<div class="control-group">
						<!--- The ad manager is now gone, but can exist in limited legacy situations --->
						<cfif application.configBean.getAdManager() or rc.siteBean.getadManager()>
						<div class="span3">
							<label class="control-label">Advertisement Manager</label>
							<div class="controls"> 
									<!--- <p class="alert">NOTE: The Advertisement Manager is not supported within Mura Bundles and Staging to Production configurations.</p> --->
									<label class="radio inline"><input type="radio" name="adManager" value="0" <cfif rc.siteBean.getadManager() neq 1> CHECKED</CFIF>>Off</label>
									<label class="radio inline"><input type="radio" name="adManager" value="1" <cfif rc.siteBean.getadManager() eq 1> CHECKED</CFIF>>On</label>
								</div>
						</div>
						</cfif>
						<div class="span3">
							<label class="control-label">Comments Manager</label>
							<div class="controls"> 
									<label class="radio inline"><input type="radio" name="hasComments" value="0" <cfif rc.siteBean.getHasComments() neq 1> CHECKED</CFIF>>Off</label>
									<label class="radio inline"><input type="radio" name="hasComments" value="1" <cfif rc.siteBean.getHasComments() eq 1> CHECKED</CFIF>>On</label>
								</div>
						</div>
						 <div class="span3">
							<label class="control-label">JSON API (ALPHA)</label>
							<div class="controls"> 
									<label class="radio inline"><input type="radio" name="JSONAPI" value="0" <cfif rc.siteBean.getJSONAPI() neq 1> CHECKED</CFIF>>Off</label>
									<label class="radio inline"><input type="radio" name="JSONAPI" value="1" <cfif rc.siteBean.getJSONAPI() eq 1> CHECKED</CFIF>>On</label>
								</div>
						</div>

					</div>
			
					<cfif application.configBean.getEmailBroadcaster()>
					<div class="control-group">
					
						<div class="span3">
							<label class="control-label">Email Broadcaster</label>
							<div class="controls"> 
									<!--- <p class="alert">NOTE: The Email Broadcaster is not supported within Mura Bundles.</p> --->
									<label class="radio inline"><input type="radio" name="EmailBroadcaster" value="0" <cfif rc.siteBean.getemailbroadcaster() neq 1> CHECKED</CFIF>>Off</label>
									<label class="radio inline"><input type="radio" name="EmailBroadcaster" value="1" <cfif rc.siteBean.getemailbroadcaster()  eq 1> CHECKED</CFIF>>On</label>
							</div>
					</div>
						
						<div class="span3">
							<label class="control-label">Email Broadcaster Limit</label>
							<div class="controls">
									<input name="EmailBroadcasterLimit" type="text" class="span4" value="#esapiEncode('html_attr',rc.siteBean.getEmailBroadcasterLimit())#" size="50" maxlength="50">
							</div>
						</div>
					
					</div>
					</cfif>
			
			
					<div class="control-group">
					
			
					<div class="span3">
				<label class="control-label">Content Staging Manager</label>
				<div class="controls">
						<label class="radio inline">
						<input type="radio" name="hasChangesets" value="0" <cfif rc.siteBean.getHasChangesets() neq 1> CHECKED</CFIF>>
						Off </label>
						<label class="radio inline">
						<input type="radio" name="hasChangesets" value="1" <cfif rc.siteBean.getHasChangesets() eq 1> CHECKED</CFIF>>
						On </label>
					</div>
			</div>
					
					<div class="span6">
				<label class="control-label">Publish via Change Sets Only</label>
				<div class="controls">
						<label class="radio inline">
						<input type="radio" name="enforceChangesets" value="0" <cfif rc.siteBean.getEnforceChangesets() neq 1> CHECKED</CFIF>>
						Off </label>
						<label class="radio inline">
						<input type="radio" name="enforceChangesets" value="1" <cfif rc.siteBean.getEnforceChangesets() eq 1> CHECKED</CFIF>>
						On </label>
					</div>
			</div>
			</div>
			</div>
		</div>
		
		<!--- Email --->
		<div id="tabEmail" class="tab-pane fade">
			<div class="fieldset">
			
				<div class="control-group">
				<label class="control-label">Default "From" Email Address</label>
				<div class="controls">
						<input name="contact" type="text" class="span8" value="#esapiEncode('html_attr',rc.siteBean.getcontact())#" size="50" maxlength="50">
					</div>
			</div>
				<div class="control-group">
				<div class="span4">
				<label class="control-label">Mail Server IP/Host Name</label>
				<div class="controls">
						<input name="MailServerIP" type="text" class="text" value="#esapiEncode('html_attr',rc.siteBean.getMailServerIP())#" size="50" maxlength="50">
					</div>
			</div>
				<div class="span4">
				<label class="control-label">Mail Server SMTP Port</label>
				<div class="controls">
						<input name="MailServerSMTPPort" type="text" class="text" value="#esapiEncode('html_attr',rc.siteBean.getMailServerSMTPPort())#" size="5" maxlength="5">
					</div>
			</div>
				<div class="span4">
				<label class="control-label">Mail Server POP Port</label>
				<div class="controls">
						<input name="MailServerPOPPort" type="text" class="text" value="#esapiEncode('html_attr',rc.siteBean.getMailServerPOPPort())#" size="5" maxlength="5">
					</div>
			</div>
				</div>
				
				<div class="control-group">
				<div class="span6">
				<label class="control-label">Mail Server Username <a href="" rel="tooltip" data-original-title="WARNING: Do Not Use a Personal Account. Email will be removed from server for tracking purposes."><i class="icon-warning-sign"></i></a></label>
				<div class="controls">
						<input name="MailServerUserName" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getMailServerUserName())#" size="50" maxlength="50">
					</div>
			</div>
				<div class="span6">
				<label class="control-label">Mail Server Password</label>
				<div class="controls">
						<input name="MailServerPassword" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getMailServerPassword())#" size="50" maxlength="50">
					</div>
			</div>
				</div>
			
			<div class="control-group">
				<div class="span3">
				<label class="control-label">Use TLS</label>
				<div class="controls">
						<label class="radio inline">
						<input type="radio" name="mailServerTLS" value="true" <cfif rc.siteBean.getmailServerTLS()  eq "true"> CHECKED</CFIF>>
						Yes </label>
						<label class="radio inline">
						<input type="radio" name="mailServerTLS" value="false" <cfif rc.siteBean.getmailServerTLS() eq "false"> CHECKED</CFIF>>
						No </label>
					</div>
				</div>
				<div class="span3">
				<label class="control-label">Use SSL</label>
				<div class="controls">
						<label class="radio inline">
						<input type="radio" name="mailServerSSL" value="true" <cfif rc.siteBean.getmailServerSSL()  eq "true"> CHECKED</CFIF>>
						Yes </label>
						<label class="radio inline">
						<input type="radio" name="mailServerSSL" value="false" <cfif rc.siteBean.getmailServerSSL() eq "false"> CHECKED</CFIF>>
						No </label>
					</div>
			</div>
				<div class="span3">
				<label class="control-label">Use Default SMTP Server</label>
				<div class="controls">
						<label class="radio inline">
						<input type="radio" name="useDefaultSMTPServer" value="1" <cfif rc.siteBean.getUseDefaultSMTPServer()  eq 1> CHECKED</CFIF>>
						Yes </label>
						<label class="radio inline">
						<input type="radio" name="useDefaultSMTPServer" value="0" <cfif rc.siteBean.getUseDefaultSMTPServer() neq 1> CHECKED</CFIF>>
						No </label>
					</div>
			</div>
			</div>
			
			 <div class="control-group">
				<label class="control-label">Content Approval Script</label>
				<div class="controls">
						<p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##parentName## ##contentType##</p>
						<textarea rows="6" class="span12" name="contentApprovalScript">#esapiEncode('html',rc.siteBean.getContentApprovalScript())#</textarea>
					</div>
			</div>


			 <div class="control-group">
				<label class="control-label">Content Rejection Script</label>
				<div class="controls">
						<p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##parentName## ##contentType##</p>
						<textarea rows="6" class="span12" name="contentRejectionScript">#esapiEncode('html',rc.siteBean.getContentRejectionScript())#</textarea>
					</div>
			</div>

				<div class="control-group">
				<label class="control-label">User Login Info Request Script</label>
				<div class="controls">
						<p class="help-block">Available Dynamic Content: ##firstName## ##lastName## ##username## ##password## ##contactEmail## ##contactName## ##returnURL##</p>
						<textarea rows="6" class="span12" name="sendLoginScript">#esapiEncode('html',rc.siteBean.getSendLoginScript())#</textarea>
					</div>
			</div>
				<div class="control-group">
				<label class="control-label">Mailing List Confirmation Script</label>
				<div class="controls">
						<p class="help-block">Available Dynamic Content: ##listName## ##contactName## ##contactEmail## ##returnURL##</p>
						<textarea rows="6" class="span12" name="mailingListConfirmScript">#esapiEncode('html',rc.siteBean.getMailingListConfirmScript())#</textarea>
					</div>
			</div>
				<div class="control-group">
				<label class="control-label">Account Activation Script</label>
				<div class="controls">
						<p class="help-block">Available Dynamic Content: ##firstName## ##lastName## ##username## ##contactEmail## ##contactName##</p>
						<textarea rows="6" class="span12" name="accountActivationScript">#esapiEncode('html',rc.siteBean.getAccountActivationScript())#</textarea>
					</div>
			</div>
			<!---
				<div class="control-group">
				<label class="control-label">Public Submission Approval Script</label>
				<div class="controls">
						<p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##parentName## ##contentType##</p>
						<textarea rows="6" class="span12" name="publicSubmissionApprovalScript">#esapiEncode('html',rc.siteBean.getPublicSubmissionApprovalScript())#</textarea>
					</div>
			</div>
			--->
				<div class="control-group">
				<label class="control-label">Event Reminder Script</label>
				<div class="controls">
						<p class="help-block">Available Dynamic Content: ##returnURL## ##eventTitle## ##startDate## ##startTime## ##siteName## ##eventContactName## ##eventContactAddress## ##eventContactCity## ##eventContactState## ##eventContactZip## ##eventContactPhone##</p>
						<textarea rows="6" class="span12" name="reminderScript">#esapiEncode('html',rc.siteBean.getReminderScript())#</textarea>
					</div>
			</div>
			
			</div>
		</div>
		<!--- Galleries --->
		<div id="tabImages" class="tab-pane fade">
			<div class="fieldset">
				
				<div class="control-group">
					
					<div class="span6">
					<label class="control-label">Small (Thumbnail) Image</label>
							<label>Height</label>
							<div class="controls"><input name="smallImageHeight" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getSmallImageHeight())#" /></div>
					</div>
					
					<div class="span6"> 
					<br />  
							<label>Width</label>
							<div class="controls"><input name="smallImageWidth" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getSmallImageWidth())#" /></div>
					</div>
					
			</div>
			
				<div class="control-group">
				<div class="span6">
					<label class="control-label">Medium Image</label>
							<label>Height</label>
							<div class="controls"><input name="mediumImageHeight" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getMediumImageHeight())#" /></div>
					</div>
					
					<div class="span6"> 
					<br />  
							<label>Width</label>
							<div class="controls"><input name="mediumImageWidth" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getMediumImageWidth())#" /></div>
					</div>
			</div>
			
				<div class="control-group">
				<div class="span6">
					<label class="control-label">Large Image</label>
							<label>Height</label>
							<div class="controls"><input name="largeImageHeight" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getLargeImageHeight())#" /></div>
					</div>
					
					<div class="span6"> 
					<br />  
							<label>Width</label>
							<div class="controls"><input name="largeImageWidth" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getLargeImageWidth())#" /></div>
					</div>
			</div>
			
				<cfif len(rc.siteBean.getSiteID())>
				<script>
			function openCustomImageSize(sizeid,siteid){
		
					jQuery("##custom-image-dialog").remove();
					jQuery("body").append('<div id="custom-image-dialog" rel="tooltip" title="Loading..." style="display:none"><div id="newContentMenu"><div class="load-inline"></div></div></div>');

					var dialogoptions= {
							Save: function() {
								saveCustomImageSize();
								jQuery( this ).dialog( "close" );
							},
							Cancel: function() {
								 jQuery( this ).dialog( "close" );
							}
						};

						if(sizeid != ''){
							dialogoptions.Delete=function(){
								deleteCustomImageSize();
								jQuery( this ).dialog( "close" );
							};
						}

					jQuery("##custom-image-dialog").dialog({
						resizable: true,
						modal: true,
						width: 400,
						position: getDialogPosition(),
						buttons: dialogoptions,
						open: function(){
						 
							jQuery("##custom-image-dialog").html('<div class="ui-dialog-content ui-widget-content"><div class="load-inline"></div></div>');
							var url = 'index.cfm';
							var pars = 'muraAction=cSettings.loadcustomimage&siteid=' + siteid +'&sizeid=' + sizeid  +'&cacheid=' + Math.random();
							jQuery.get(url + "?" + pars, 
									function(data) {
									jQuery("##custom-image-dialog").closest(".ui-dialog").find(".ui-dialog-title").html('Edit Custom Image Size');
									jQuery('##custom-image-dialog').html(data);
									$("##custom-image-dialog").dialog("option", "position", "center");
									}
								);    
							
						},
						close: function(){
							jQuery(this).dialog("destroy");
							jQuery("##custom-image-dialog").remove();
						} 
				});

				return false;
		 }

		function saveCustomImageSize(){
			loadCustomImages(
				{
					sizeid:$('##custom-image-form').attr('data-sizeid'),
					siteid:siteid,
					name:$('##custom-image-name').val(),
					height:$('##custom-image-height').val(),
					width:$('##custom-image-width').val(),
					imageaction:'save'
				}
			);
		 }

		function deleteCustomImageSize(){
			if(confirm('Delete custom image size?')){
				loadCustomImages(
					{
						sizeid:$('##custom-image-form').attr('data-sizeid'),
						siteid:siteid,
						name:'',
						height:'',
						width:'',
						imageaction:'delete'
					}
				);
			}
		 }

		 function loadCustomImages(imageoptions){
				var merged=$.extend(
						{
							sizeid:'',
							siteid:'',
							name:'',
							height:'',
							width:'',
							imageaction:''
						},
						imageoptions
					);
				var url = 'index.cfm';
				var pars = 'muraAction=cSettings.loadcustomimages&siteid=' + merged.siteid + '&cacheid=' + Math.random();;
		
				jQuery.post(url + "?" + pars,
					merged, 
					function(data) {
						jQuery('##custom-images-container').html(data);
						}
				);    
		 }

		 $(document).ready(function(){loadCustomImages({siteid:'#esapiEncode('javascript',rc.siteBean.getSiteID())#'})});

			</script>
			<div class="control-group">
				<label class="control-label">Custom Images</label>
				<ul class="nav nav-pills"><li><a href="##" onclick="return openCustomImageSize('','#esapiEncode('javascript',rc.siteBean.getSiteID())#')"><i class="icon-plus-sign"></i> Add Custom Image Size</a></li></ul>
				<div id="custom-images-container"></div>
			</div>
			</cfif>
			
			</div>
		</div>
		
		<!--- Extranet --->
		<div id="tabExtranet" class="tab-pane fade">
			<div class="fieldset">
				
				<div class="control-group">
				<div class="span6">
				<label class="control-label">Allow Public Site Registration</label>
				<div class="controls">
						<label class="radio inline">
						<input type="radio" name="extranetpublicreg" value="0" <cfif rc.siteBean.getextranetpublicreg() neq 1> CHECKED</CFIF>>
						No </label>
						<label class="radio inline">
						<input type="radio" name="extranetpublicreg" value="1" <cfif rc.siteBean.getextranetpublicreg()  eq 1> CHECKED</CFIF>>
						Yes </label>
					</div>
			</div>
			<!--- This is removed in favor of a useSSL 
			<div class="span6">
				<label class="control-label">Require HTTPS Encryption for Extranet</label>
				<div class="controls">
						<label class="radio inline">
						<input type="radio" name="extranetssl" value="0" <cfif rc.siteBean.getextranetssl() neq 1> CHECKED</CFIF>>
						No </label>
						<label class="radio inline">
						<input type="radio" name="extranetssl" value="1" <cfif rc.siteBean.getextranetssl()  eq 1> CHECKED</CFIF>>
						Yes </label>
					</div>
			</div>
			--->
	</div>
				
				<div class="control-group">
				<div class="span6">
				<label class="control-label">Custom Login URL</label>
				<div class="controls">
						<input name="loginURL" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getLoginURL(parseMuraTag=false))#" maxlength="255">
					</div>
			</div>
				<div class="span6">
				<label class="control-label">Custom Profile URL</label>
				<div class="controls">
						<input name="editProfileURL" type="text" class="span12" value="#esapiEncode('html_attr',rc.siteBean.getEditProfileURL(parseMuraTag=false))#" maxlength="255">
					</div>
			</div>
				</div>
				<!---  <dt>Allow Public Submission In To Folders</dt>
			<dd>
				<input type="radio" name="publicSubmission" value="0" <cfif rc.siteBean.getpublicSubmission() neq 1> CHECKED</CFIF>>
				No&nbsp;&nbsp;
				<input type="radio" name="publicSubmission" value="1" <cfif rc.siteBean.getpublicSubmission() eq 1> CHECKED</CFIF>>
				Yes</dd>
			<dd> --->
			 
				<div class="control-group">
				<label class="control-label">Email Site Registration Notifications to:</label>
				<div class="controls">
						<input name="ExtranetPublicRegNotify" type="text" class="span12" value="#rc.siteBean.getExtranetPublicRegNotify()#" size="255" maxlength="255">
					</div>
			</div>
			
			</div>
		</div>
		
		<!--- Display Regions --->
		<div id="tabDisplayregions" class="tab-pane fade">
			<div class="fieldset">
			
				<div class="control-group">
				<div class="span6">
				<label class="control-label">Number of Display Regions</label>
				<div class="controls">
						<select class="span2" name="columnCount">
						<option value="1" <cfif rc.siteBean.getcolumnCount() eq 1 or rc.siteBean.getcolumnCount() eq 0> selected</cfif>> 1</option>
						<cfloop from="2" to="20" index="i">
								<option value="#i#" <cfif rc.siteBean.getcolumnCount() eq i> selected</cfif>>#i#</option>
							</cfloop>
					</select>
					</div>
					</div>
					</div>
					
				 <div class="control-group">
				 <div class="span6">
				<label class="control-label">Primary Display Region <span class="help-block">Dynamic System Content such as Login Forms<br />and Search Results get displayed here</span></label>
				<div class="controls">
						<select class="span2" name="primaryColumn">
						<cfloop from="1" to="20" index="i">
								<option value="#i#" <cfif rc.siteBean.getPrimaryColumn() eq i> selected</cfif>>#i#</option>
							</cfloop>
					</select>
						</div>
					</div>
			</div>
			
				<div class="control-group">
				<label class="control-label">Display Region Names <span class="help-inline">"^" Delimiter</span></label>
				<div class="controls">
						<input name="columnNames" type="text" class="span6" value="#esapiEncode('html_attr',rc.siteBean.getcolumnNames())#">
					</div>
			</div>
			
			</div>
		</div>
		
		<!--- Extended Attributes --->
		<cfif arrayLen(extendSets)>
				<div id="tabExtendedAttributes" class="tab-pane fade">
				 <div class="fieldset">
				<cfset started=false />
				<cfloop from="1" to="#arrayLen(extendSets)#" index="s">
						<cfset extendSetBean=extendSets[s]/>
						<cfset style=extendSetBean.getStyle()/>
						<cfif not len(style)>
						<cfset started=true/>
					</cfif>
						<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
					<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
					<div class="fieldset">
							<h2>#extendSetBean.getName()#</h2>
							<cfsilent>
						<cfset attributesArray=extendSetBean.getAttributes() />
						</cfsilent>
							<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">
							<cfset attributeBean=attributesArray[a]/>
							<cfset attributeValue=rc.siteBean.getvalue(attributeBean.getName(),'useMuraDefault') />
							<div class="control-group">
									<label class="control-label">
									<cfif len(attributeBean.getHint())>
											<a rel="tooltip" href="##" title="#esapiEncode('html_attr',attributeBean.gethint())#">#attributeBean.getLabel()# <i class="icon-question-sign"></i></a>
											<cfelse>
#attributeBean.getLabel()#
										</cfif>
									<cfif attributeBean.getType() eq "File" and len(attributeValue) and attributeValue neq 'useMuraDefault'>
											<cfif listFindNoCase("png,jpg,jpeg",application.serviceFactory.getBean("fileManager").readMeta(attributeValue).fileExt)>
											<a href="./index.cfm?muraAction=cArch.imagedetails&siteid=#rc.siteBean.getSiteID()#&fileid=#esapiEncode('url',attributeValue)#"><img id="assocImage" src="#application.configBean.getContext()#/index.cfm/_api/render/small/?fileid=#esapiEncode('url',attributeValue)#&cacheID=#createUUID()#" /></a>
										</cfif>
											<a href="#application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#esapiEncode('url',attributeValue)#" target="_blank">[Download]</a>
											<input type="checkbox" value="true" name="extDelete#attributeBean.getAttributeID()#"/>
											Delete
										</cfif>
								</label>
									<!--- if it's an hidden type attribute then flip it to be a textbox so it can be editable through the admin --->
									<cfif attributeBean.getType() IS "Hidden">
									<cfset attributeBean.setType( "TextBox" ) />
								</cfif>
									<div class="controls"> #attributeBean.renderAttribute(attributeValue)# </div>
								</div>
						</cfloop>
						</div>
					</span>
					</cfloop>
					</div>
				</div>
		</cfif>
		
		<!--- Site Bundles --->
		<div id="tabBundles" class="tab-pane fade">
			<cfif application.configBean.getJavaEnabled()>
			<div class="fieldset">
				<cfif listFind(session.mura.memberships,'S2')>
					
			 
				<div class="control-group">
					<label class="control-label"> Are you restoring a site from a backup bundle? </label>
					<div class="controls">
						<label class="radio inline"><input type="radio" name="bundleImportKeyMode" value="copy" checked="checked">No - <em>Assign New Keys to Imported Items</em></label>
						<label class="radio inline" for=""><input type="radio" name="bundleImportKeyMode" value="publish">Yes - <em>Maintain All Keys from Imported Items</em></label>
					</div>
			</div>
				
				<div class="control-group">
				<label class="control-label">Include:</label>
				<div class="controls">
						<ul>
						<li>
								<label class="checkbox" for="bundleImportContentMode">
								<input id="bundleImportContentMode" name="bundleImportContentMode" value="all" type="checkbox" onchange="if(this.checked){jQuery('##contentRemovalNotice').show();}else{jQuery('##contentRemovalNotice').hide();}">
								Site Architecture &amp; Content</label>
							</li>
						<li id="bundleImportUsersModeLI"<cfif not (rc.siteBean.getPublicUserPoolID() eq rc.siteBean.getSiteID() and rc.siteBean.getPrivateUserPoolID() eq rc.siteBean.getSiteID())> style="display:none;"</cfif>>
								<label class="checkbox" for="bundleImportUsersMode">
								<input id="bundleImportUsersMode" name="bundleImportUsersMode" value="all" type="checkbox"  onchange="if(this.checked){jQuery('##userNotice').show();}else{jQuery('##userNotice').hide();}">
								Site Members &amp; Administrative Users</label>
							</li>
						<li>
								<label class="checkbox" for="bundleImportMailingListMembersMode">
								<input id="bundleImportMailingListMembersMode" name="bundleImportMailingListMembersMode" value="all" type="checkbox">
								Mailing Lists Members</label>
							</li>
						<li>
								<label class="checkbox" for="bundleImportFormDataMode">
								<input id="bundleImportFormDataMode" name="bundleImportFormDataMode" value="all" type="checkbox">
								Form Response Data</label>
							</li>
						<li>
								<label class="checkbox" for="bundleImportPluginMode">
								<input id="bundleImportPluginMode" name="bundleImportPluginMode" value="all" type="checkbox">
								All Plugins</label>
							</li>
					</ul>
						<p class="alert help-block" style="display:none" id="contentRemovalNotice"><strong>Important:</strong> When importing content from a Mura bundle ALL of the existing content will be deleted.</p>
						<p class="alert help-block" style="display:none" id="userNotice"><strong>Important:</strong> Importing users will remove all existing user data which may include the account that you are currently logged in as.</p>
					</div>
			</div>
				 </cfif>
				<div class="control-group">
					<label class="control-label"> Which rendering files would you like to import? </label>
					<div class="controls">
							<cfif listFind(session.mura.memberships,'S2')>
								 <label class="radio inline">
									<input type="radio" name="bundleImportRenderingMode" value="all" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">All</label>
							</cfif>
							<label class="radio inline">
							<input type="radio" name="bundleImportRenderingMode" value="theme" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}"<cfif not listFind(session.mura.memberships,'S2')> checked="true"</cfif>>Theme Only</label>
						 <cfif listFind(session.mura.memberships,'S2')>
								<label class="radio inline">
							 <input type="radio" name="bundleImportRenderingMode" value="none" checked="checked" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">None</label>
							</cfif>
							<p class="alert help-block"<cfif listFind(session.mura.memberships,'S2')> style="display:none"</cfif> id="themeNotice"><strong>Important:</strong> Your site's theme assignment and gallery image settings will be updated.</p>
					</div>
				</div>
				
				<div class="control-group">
				<label class="control-label">Select Bundle File From Server
						<cfif application.configBean.getPostBundles()>
						(Preferred)
					</cfif>
					</label>
				<div class="controls">
						<p class="help-block alert">You can deploy a bundle that exists on the server by entering the complete server path to the Site Bundle here. This eliminates the need to upload the file via your web browser, avoiding some potential timeout issues.</p>
						<input class="text" type="text" name="serverBundlePath" id="serverBundlePath" value="">
						<input type="button" value="Browse Server" class="mura-ckfinder" data-completepath="true" data-resourcetype="root" data-target="serverBundlePath"/>
					</div>
			</div>
				<cfif application.configBean.getPostBundles()>
				<div class="control-group">
						<label class="control-label"><a rel="tooltip" data-container="body" title="Uploading large files via a web browser can produce inconsistent results.">Upload Bundle File</a></label>
						<div class="controls">
						<input type="file" name="bundleFile" accept=".zip"/>
					</div>
					</div>
				<cfelse>
				<input type="hidden" name="bundleFile" value=""/>
			</cfif>
			
			</div>
			<cfelse>
			<div class="fieldset">
				<div class="control-group">
					<div class="alert">
						Java is currently disabled. So this feature is not currently available.
					</div>
				</div>
			</div>
			</cfif>
		</div>

		<cfset rc.razunaSettings=rc.siteBean.getRazunaSettings()>
		<div id="tabRazuna" class="tab-pane fade">
			<div class="fieldset">
			<!---
			<div class="control-group">
				<label class="control-label" for="razuna_servertype">Server Type</label>
				<div class="controls">
					<label for="razuna_servertype_hosted" class="radio inline">
						<input type="radio" name="servertype" value="cloud" id="razuna_servertype_cloud" <cfif rc.razunaSettings.getServerType() eq "cloud">checked="checked"</cfif>> Hosted (razuna.com)
					</label>
					<label for="razuna_servertype_self" class="radio inline">
						<input type="radio" name="servertype" value="local" id="razuna_servertype_local" <cfif rc.razunaSettings.getServerType() eq "local">checked="checked"</cfif>> Self hosted
					</label>
				</div>
			</div>
			--->
			<input type="hidden" name="servertype" value="local">
			<div class="control-group">
				<label class="control-label" for="razuna_hostname">Hostname</label>
				<div class="controls">
					<input type="text" class="span6" value="#esapiEncode('html_attr',rc.razunaSettings.getHostName())#" id="razuna_hostname" name="hostname"> 
					<span class="help-block">Example: yourcompany.razuna.com or localhost:8080/razuna</span>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="hostid">Host ID</label>
				<div class="controls">
					<input type="text" class="span6" value="#esapiEncode('html_attr',rc.razunaSettings.getHostID())#" id="razuna_hostid" name="hostid"> 
					<span class="help-block">Example: 496</span>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="dampath">DAM Path</label>
				<div class="controls">
					<input type="text" class="span6" value="#esapiEncode('html_attr',rc.razunaSettings.getDAMPath())#" id="razuna_dampath" name="damPath"> 
					<span class="help-block">Example: /demo/dam</span>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label" for="razuna_api_key">API Key</label>
				<div class="controls">
					<input type="text" class="span6" value="#esapiEncode('html_attr',rc.razunaSettings.getApiKey())#" id="razuna_api_key" name="apikey">
				</div>
			</div>
		</div>
 </div>
				
	</cfoutput>
	
	<cfoutput query="rsPluginScripts" group="pluginID"> 
		<!---<cfset tabLabelList=tabLabelList & ",'#esapiEncode('javascript',rsPluginScripts.name)#'"/>--->
		<cfset tabID="tab" & $.createCSSID(rsPluginScripts.name)>
		<div id="#tabID#" class="tab-pane fade"> <cfoutput>
				<cfset rsPluginScript=application.pluginManager.getScripts("onSiteEdit",rc.siteID,rsPluginScripts.moduleID)>
				<cfif rsPluginScript.recordcount>
#application.pluginManager.renderScripts("onSiteEdit",rc.siteid,pluginEvent,rsPluginScript)#
				</cfif>
			</cfoutput> </div>
	</cfoutput> <cfoutput> 
		<div class="load-inline tab-preloader"></div>
		<script>$('.tab-preloader').spin(spinnerArgs2);</script>
		 #actionButtons#
		<input type="hidden" name="action" value="update">
		#rc.$.renderCSRFTokens(context=rc.siteID,format="form")#
		</form>
	</cfoutput>
<cfelseif rc.$.validateCSRFTokens(context=rc.siteid & 'updatesite')>
	<cftry>
		<cfset updated=application.autoUpdater.update(rc.siteid)>
		<cfset files=updated.files>
		<p class="alert alert-success">Your site's files have been updated to version <cfoutput>#application.autoUpdater.getCurrentCompleteVersion(rc.siteid)#</cfoutput>.</p>
		<p> <strong>Updated Files <cfoutput>(#arrayLen(files)#)</cfoutput></strong><br/>
			<cfif arrayLen(files)>
				<cfoutput>
					<cfloop from="1" to="#arrayLen(files)#" index="i">
#files[i]#             <br />
					</cfloop>
				</cfoutput>
			</cfif>
		</p>
		<cfcatch>
			<h2>An Error has occurred.</h2>
			<cfdump var="#cfcatch.message#">
			<cfdump var="#cfcatch.TagContext#">
		</cfcatch>
	</cftry>
</cfif>
