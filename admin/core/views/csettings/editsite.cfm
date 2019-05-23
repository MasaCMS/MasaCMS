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
/core/mura/
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

<cfoutput>
	<!--- mura-header --->
	<div class="mura-header">
		<h1><cfif isDefined('url.addsite')>Add Site<cfelse>Site Settings</cfif></h1>
	<cfif len(rc.siteid)>
			<div class="nav-module-specific btn-group">
			<cfif rc.action eq "updateFiles">
				<a class="btn" href="./?muraAction=cSettings.editSite&siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-pencil"></i> Edit Site</a>
			</cfif>
			<cfif application.configBean.getJavaEnabled()>
				<a  class="btn" href="?muraAction=cSettings.selectBundleOptions&siteID=#esapiEncode('url',rc.siteBean.getSiteID())#"><i class="mi-gift"></i> Create Site Bundle</a>
			</cfif>
			<cfif len(rc.siteBean.getExportLocation()) and directoryExists(rc.siteBean.getExportLocation())>
				<a  class="btn" href="##" onclick="confirmDialog('Export static HTML files to #esapiEncode("javascript","'#rc.siteBean.getExportLocation()#'")#.',function(){actionModal('./?muraAction=csettings.exportHTML&siteID=#rc.siteBean.getSiteID()#')});return false;"><i class="mi-share"></i> Export Static HTML (BETA)</a>
			</cfif>
			<a class="btn" href="./?muraAction=cExtend.listSubTypes&siteid=#esapiEncode('url',rc.siteid)#"><i class="mi-list-alt"></i> Class Extensions</a>  <cfif listFind(session.mura.memberships,'S2')> <a  class="btn" href="./?muraAction=cTrash.list&siteID=#esapiEncode('url',rc.siteid)#"><i class="mi-trash"></i> Trash Bin</a></cfif>
		</div>
	</cfif>
	</div><!--- /.mura-header --->
</cfoutput>
<cfoutput>
		<form novalidate method ="post"  enctype="multipart/form-data" action="./?muraAction=cSettings.updateSite" name="form1"  onsubmit="return validate(this);">
		<!---
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/ajax.js"></script>'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/tab-view.js"></script>'>
 --->
		<cfsavecontent variable="actionButtons">
		<cfoutput>
			<div class="mura-actions">
				<div class="form-actions">
				<cfif rc.siteBean.getsiteid() eq ''>
					<button type="button" class="btn mura-primary" onclick="submitForm(document.forms.form1,'add');"><i class="mi-plus-circle"></i> Add</button>
					<cfelse>
					<cfif rc.siteBean.getsiteid() neq 'default' and listFind(session.mura.memberships,'S2')>
						<button type="button" class="btn" onclick="return confirmDialog('#esapiEncode("javascript","WARNING: A deleted site and all of its files cannot be recovered. Are you sure that you want to continue?")#',function(){actionModal('./?muraAction=cSettings.updateSite&action=delete&siteid=#rc.siteBean.getSiteID()##rc.$.renderCSRFTokens(context=rc.siteID,format="url")#')});"><i class="mi-trash"></i> Delete</button>
					</cfif>
					<button type="button" class="btn mura-primary" onclick="submitForm(document.forms.form1,'update');"><i class="mi-check-circle"></i> Save Settings</button>
				</cfif>
				</div> <!-- /.form-actions -->
			</div> <!-- /.mura-actions -->
		</cfoutput>
		</cfsavecontent>
		<cfif arrayLen(extendSets)>
			<cfset tabLabelList='Basic,Contact Info,Shared Resources,Admin Modules,Email,Images,Extranet,Display Regions,Extended Attributes,Deploy Bundle,'>
			<cfset tabList='tabBasic,tabContactinfo,tabSharedresources,tabModules,tabEmail,tabImages,tabExtranet,tabDisplayregions,tabExtendedAttributes,tabBundles'>
		<cfelse>
			<cfset tabLabelList='Basic,Contact Info,Shared Resources,Modules,Email,Images,Extranet,Display Regions,Deploy Bundle'>
			<cfset tabList='tabBasic,tabContactinfo,tabSharedresources,tabModules,tabEmail,tabImages,tabExtranet,tabDisplayregions,tabBundles'>
		</cfif>

		<cfif rc.$.globalConfig().getValue(property='razuna',defaultValue=false)>
			<cfset tabLabelList=listAppend(tabLabelList,'Razuna')>
			<cfset tabList=listAppend(tabList,'tabRazuna')>
		</cfif>

	</cfoutput> <cfoutput query="rsPluginScripts" group="pluginid"> <cfoutput>
			<cfset tabLabelList=listAppend(tabLabelList,rsPluginScripts.name)/>
			<cfset tabList=listAppend(tabList,"tab" & $.createCSSID(rsPluginScripts.name))>
		</cfoutput> </cfoutput> <cfoutput>
		<div class="block block-constrain">
		<ul class="mura-tabs nav-tabs" data-toggle="tabs">
				<cfloop from="1" to="#listlen(tabList)#" index="t">
				<li<cfif t eq 1> class="active"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
			</cfloop>
			</ul>
		<div class="block-content tab-content">
		<!--- Basic --->
		<div id="tabBasic" class="tab-pane active">
				<div class="block block-bordered">
						<!-- block header -->
					  <div class="block-header">
							<h3 class="block-title">Basic Settings</h3>
					  </div>
					  <!-- /block header -->
					  <div class="block-content">
							<div class="mura-control-group">
								<label>Site ID</label>
								<cfif rc.siteid eq ''>
								<p class="help-block">Warning: No spaces, punctuation, dots or file delimiters allowed.</p>
										<input name="siteid" type="text" value="#rc.siteBean.getsiteid()#" size="25" maxlength="25" required="true" onchange="removePunctuation(this);">
								<cfelse>
										<input  id="disabledInput" type="text" placeholder="#rc.siteBean.getsiteid()#" disabled>
								<input name="siteid" type="hidden" value="#rc.siteBean.getsiteid()#">
							</cfif>
							</div>
							<div class="mura-control-group">
								<label>Site Name</label>
								<input name="site" type="text" value="#esapiEncode('html_attr',rc.siteBean.getsite())#" size="50" maxlength="50">
					</div>

				<!--- Tagline --->
						<div class="mura-control-group">
							<label>
								<span data-toggle="popover" title="" data-placement="right"
							  	data-content="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.sitesettings.tagline.tooltip'))#"
							  	data-original-title="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.sitesettings.tagline'))#">
							#rc.$.rbKey('siteconfig.sitesettings.tagline')#
									<i class="mi-question-circle"></i>
								</span>
					</label>
								<input name="tagline" type="text" value="#esapiEncode('html_attr',rc.siteBean.getTagline())#" size="50" maxlength="255">
				</div>

				<!--- Domain --->
						<div class="mura-control-group">
							<label>
								<span data-toggle="popover" title="" data-placement="right"
							  	data-content="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.sitesettings.primarydomain.tooltip'))#"
							  	data-original-title="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.sitesettings.primarydomain'))#">			#rc.$.rbKey('siteconfig.sitesettings.primarydomain')#
									<i class="mi-question-circle"></i>
								</span>
							</label>
							<input name="domain" type="text" value="#esapiEncode('html_attr',rc.siteBean.getdomain('production'))#" size="50" maxlength="255">
					</div>

						<div class="mura-control-group">
							<label>Domain Alias List <span>(Line Delimited)</span></label>
							<textarea name="domainAlias" rows="6">#esapiEncode('html',rc.siteBean.getDomainAlias())#</textarea>
				</div>

					<!--- Enforce Primary --->
							<div class="mura-control-group">
								<label>Enforce Primary Domain</label>
							<label class="radio inline">
										<input type="radio" name="enforcePrimaryDomain" value="0"<cfif rc.siteBean.getEnforcePrimaryDomain() neq 1> checked</cfif>>
								Off
							</label>
							<label class="radio inline">
										<input type="radio" name="enforcePrimaryDomain" value="1"<cfif rc.siteBean.getEnforcePrimaryDomain() eq 1> checked</cfif>>
								On
							</label>
						</div>

					<!--- Use SSL (Sitewide) --->
							<div class="mura-control-group">
								<label>
								<span data-toggle="popover" title="" data-placement="right"
							  	data-content="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.sitesettings.usessl.tooltip'))#"
							  	data-original-title="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.sitesettings.usessl'))#">
									#rc.$.rbKey('siteconfig.sitesettings.usessl')# <i class="mi-question-circle"></i></span>
								</label>
							<label class="radio inline">
									<input type="radio" name="useSSL" value="0"<cfif rc.siteBean.getUseSSL() neq 1> checked</cfif>>
								#rc.$.rbKey('sitemanager.no')#
							</label>
							<label class="radio inline">
									<input type="radio" name="useSSL" value="1"<cfif rc.siteBean.getUseSSL() eq 1> checked</cfif>>
								#rc.$.rbKey('sitemanager.yes')#
							</label>
						</div>

							<div class="mura-control-group">
								<label>Locale</label>
								<select name="siteLocale">
								<option value="">Default</option>
								<cfloop list="#listSort(server.coldfusion.supportedLocales,'textnocase','ASC')#" index="l">
										<option value="#l#"<cfif rc.siteBean.getSiteLocale() eq l> selected</cfif>>#l#</option>
									</cfloop>
							</select>
							</div>

							<div class="mura-control-group">
								<label>Theme</label>
								<select name="theme">
								<cfif rc.siteBean.hasNonThemeTemplates()>
										<option value="">None</option>
									</cfif>
								<cfloop query="rsThemes">
										<option value="#rsThemes.name#"<cfif rsThemes.name eq rc.siteBean.getTheme() or (not len(rc.siteBean.getSiteID()) and rsThemes.currentRow eq 1)> selected</cfif>>#rsThemes.name#</option>
									</cfloop>
							</select>
							</div>
							<div class="mura-control-group">
								<label>Page Limit</label>
										<input name="pagelimit" type="text" value="#esapiEncode('html_attr',rc.siteBean.getpagelimit())#" size="5" maxlength="6">
							</div>
							<div class="mura-control-group">
								<label>Default  Rows <span>(in Content Tree View)</span></label>
										<input name="nextN" type="text" value="#esapiEncode('html_attr',rc.siteBean.getnextN())#" size="5" maxlength="5">
					</div>
							<div class="mura-control-group">
								<label>Site Caching</label>
								<label class="radio inline">
										<input type="radio" name="cache" value="0"<cfif rc.siteBean.getcache() neq 1> checked</cfif>>
								Off</label>
								<label class="radio inline">
										<input type="radio" name="cache" value="1"<cfif rc.siteBean.getcache() eq 1> checked</cfif>>
								On</label>
							</div>
						<!---
						<div>
								<label>Cache Capacity <span class="help-inline">(0=Unlimited)</span></label>
						<div class="mura-control justify">
								<input name="cacheCapacity" type="text" value="#esapiEncode('html_attr',rc.siteBean.getCacheCapacity())#" size="15" maxlength="15">
							</div>
					</div>--->
							<div class="mura-control-group">
								<label>Cache Free Memory Threshold <span class="help-inline">(Defaults to 60%)</span></label>
								<input name="cacheFreeMemoryThreshold" type="text" value="#esapiEncode('html_attr',rc.siteBean.getCacheFreeMemoryThreshold())#" size="3" maxlength="3">
										%
					</div>
							<div class="mura-control-group">
								<label>Lock Site Architecture</label>
								<p class="help-block">Restricts Addition or Deletion of Site Content</p>
								<label class="radio inline">
										<input type="radio" name="locking" value="none" <cfif rc.siteBean.getlocking() eq 'none' or rc.siteBean.getlocking() eq ''> checked</cfif>>
								None</label>
								<label class="radio inline">
										<input type="radio" name="locking" value="all" <cfif rc.siteBean.getlocking() eq 'all'> checked</cfif>>
								All</label>
								<label class="radio inline">
										<input type="radio" name="locking" value="top" <cfif rc.siteBean.getlocking() eq 'top'> checked</cfif>>
								Top</label>
							</div>
							<div class="mura-control-group">
								<label>Allow Comments to be Posted Without Site Admin Approval</label>
								<label class="radio inline">
										<input type="radio" name="CommentApprovalDefault" value="1" <cfif rc.siteBean.getCommentApprovalDefault()  eq 1> checked</cfif>>
								Yes</label>
								<label class="radio inline">
										<input type="radio" name="CommentApprovalDefault" value="0" <cfif rc.siteBean.getCommentApprovalDefault() neq 1> checked</cfif>>
								No</label>
						</div>

							<div class="mura-control-group">
								<label>Static HTML Export Location (BETA)</label>
						<cfif len(rc.siteBean.getExportLocation()) and not directoryExists(rc.siteBean.getExportLocation())>
								<p class="help-block">The current value is not a valid directory</p>
							</cfif>
								<input name="exportLocation" type="text" value="#esapiEncode('html_attr',rc.siteBean.getExportLocation())#" maxlength="100"/>
					</div>
							 <div class="mura-control-group">
								<label>Custom Tag Groups <span class="help-inline">("^" Delimiter. List elements must use valid variable names.)</span></label>
									<input name="customTagGroups" type="text" value="#esapiEncode('html_attr',rc.siteBean.getCustomTagGroups())#" maxlength="255"/>
				</div>
							<div class="mura-control-group">
								<label>Site Mode</label>
							<select name="enableLockdown">
									<option value=""<cfif rc.siteBean.getEnableLockdown() eq ""> selected</cfif>>Live</option>
									<option value="development"<cfif rc.siteBean.getEnableLockdown() eq "development"> selected</cfif>>Development</option>
									<option value="maintenance"<cfif rc.siteBean.getEnableLockdown() eq "maintenance"> selected</cfif>>Maintenance</option>
								</select>
						</div>

				<!--- Lockable nodes --->
				<cfif application.configBean.getLockableNodes()>
							<div class="mura-control-group">
									<label>Allow Content Locking</label>
									<p class="help-block">Grants content editors the right to exlusively lock a content node and all of it's versions when editing.</p>
									<label class="radio inline">
											<input type="radio" name="hasLockableNodes" value="1" <cfif rc.siteBean.gethasLockableNodes()  eq 1> checked</cfif>>
									Yes</label>
									<label class="radio inline">
											<input type="radio" name="hasLockableNodes" value="0" <cfif rc.siteBean.gethasLockableNodes() neq 1> checked</cfif>>
									No</label>
					</div>
				</cfif>
				<!--- /Lockable nodes --->

				<!--- Custom Context + Port --->
						<div class="mura-control-group">
								<label>Is this a Remote Site? (WARNING: When set to true all content MUST be rendered via the JSON/REST APIs)</label>
								<label class="radio inline">
										<input type="radio" name="IsRemote" value="0"<cfif rc.siteBean.getIsRemote() neq 1> checked</cfif>>
								No</label>
								<label class="radio inline">
										<input type="radio" name="IsRemote" value="1"<cfif rc.siteBean.getIsRemote() eq 1> checked</cfif>>
								Yes</label>
						</div>
						<div class="mura-control-group">
								<label>Remote Context</label>
									<input name="remotecontext" type="text" value="#esapiEncode('html_attr',rc.siteBean.getRemoteContext())#" maxlength="100">
						</div>
						<div class="mura-control-group">
								<label>Remote Port</label>
									<input name="remoteport" type="text" value="#esapiEncode('html_attr',rc.siteBean.getRemotePort())#"maxlength="4">
				</div>

						<div class="mura-control-group">
									<label>
									<span data-toggle="popover" title="" data-placement="right"
							  		data-content="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.sitesettings.resourcedomain.tooltip'))#"
							  		data-original-title="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.sitesettings.resourcedomain'))#">
									#rc.$.rbKey('siteconfig.sitesettings.resourcedomain')#
											<i class="mi-question-circle"></i>
										</span>
							</label>
										<input name="resourcedomain" type="text" value="#esapiEncode('html_attr',rc.siteBean.getresourcedomain('production'))#" size="50" maxlength="255">
						</div>
						<div class="mura-control-group">
								<label>#rc.$.rbKey('siteconfig.sitesettings.resourcessl')# </label>
							<label class="radio inline">
										<input type="radio" name="resourceSSL" value="0"<cfif rc.siteBean.getResourceSSL() neq 1> checked</cfif>>
								#rc.$.rbKey('sitemanager.no')#
							</label>
							<label class="radio inline">
										<input type="radio" name="resourceSSL" value="1"<cfif rc.siteBean.getResourceSSL() eq 1> checked</cfif>>
								#rc.$.rbKey('sitemanager.yes')#
							</label>
						</div>
				<!--- /Custom Context + Port --->

				<!--- Google reCAPTCHA API Keys --->
				<cfif not Len(rc.siteBean.getReCAPTCHASiteKey()) or not Len(rc.siteBean.getReCAPTCHASecret())>
					<div class="help-block-inline">
						#rc.$.rbKey('siteconfig.recaptcha.message')#
					</div>
				</cfif>

					<div class="mura-control-group">
						<!--- reCAPTCHA Site Key --->
						<label>
						<span data-toggle="popover" title="" data-placement="right"
					  	data-content="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.recaptcha.getapikeys'))#"
					  	data-original-title="#esapiEncode('html_attr',rc.$.rbKey('siteconfig.recaptcha.sitekey'))#">
								#$.rbKey('siteconfig.recaptcha.sitekey')# <i class="mi-question-circle"></i></span>
						</label>
							<input name="reCAPTCHASiteKey" class="mura-constrain" type="text" value="#esapiEncode('html_attr',rc.siteBean.getReCAPTCHASiteKey())#" maxlength="50">
							<cfif not Len(rc.siteBean.getReCAPTCHASiteKey()) or not Len(rc.siteBean.getReCAPTCHASecret())>
								<div class="mura-control justify">
									<a class="btn" href="http://www.google.com/recaptcha/admin" target="_blank">
									<i class="mi-key"></i> #rc.$.rbKey('siteconfig.recaptcha.getgooglekeys')#
									</a>
								</div>
							</cfif>
					</div>
					<!--- reCAPTCHA Secret --->
						<div class="mura-control-group">
								<label>
								<span data-toggle="popover" title="" data-placement="right"
							  	data-content="#esapiEncode('html_attr',$.rbKey('siteconfig.recaptcha.getapikeys'))#"
							  	data-original-title="#esapiEncode('html_attr',$.rbKey('siteconfig.recaptcha.secret'))#">
								#esapiEncode('html_attr',$.rbKey('siteconfig.recaptcha.secret'))# <i class="mi-question-circle"></i></a>
								</label>
								<input name="reCAPTCHASecret" class="mura-constrain" type="text" value="#esapiEncode('html_attr',rc.siteBean.getReCAPTCHASecret())#" maxlength="50">
					</div>
					<!--- reCAPTCHA Language --->
						<div class="mura-control-group">
								<label>
								<span data-toggle="popover" title="" data-placement="right"
							  	data-content="#esapiEncode('html_attr',$.rbKey('siteconfig.recaptcha.languageoptions'))#"
							  	data-original-title="#esapiEncode('html_attr',$.rbKey('siteconfig.recaptcha.language'))#">
									#$.rbKey('siteconfig.recaptcha.language')# <i class="mi-question-circle"></i></span>
								</label>
							<cfset rc.langs = application.serviceFactory.getBean('utility').getReCAPTCHALanguages() />
							<cfset rc.sortedLangs = StructSort(rc.langs, 'textnocase', 'asc') />
							<select class="mura-constrain" name="reCAPTCHALanguage">
								<option value=""<cfif Not Len(rc.siteBean.getReCAPTACHALanguage())>
									selected</cfif>>- #$.rbKey('siteconfig.recaptcha.selectlanguage')# -</option>
								<cfloop array="#rc.sortedLangs#" index="lang">
									<option value="#rc.langs[lang]#"<cfif rc.siteBean.getReCAPTCHALanguage() eq rc.langs[lang]> selected</cfif>>#lang#</option>
								</cfloop>
							</select>
						</div>

				<!--- /Google reCAPTCHA API Keys --->

			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->

		<!--- Default Contact Info --->
		<div id="tabContactinfo" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Contact Info</h3>
				</div>
			  <!-- /block header -->
			  <div class="block-content">
					<div class="mura-control-group">
								<label>Contact Name </label>
									<input name="contactName" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcontactName())#" size="50" maxlength="50" maxlength="100">
						</div>

					<div class="mura-control-group">
								<label>Contact Address </label>
									<input name="contactAddress" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcontactAddress())#" size="50" maxlength="50" maxlength="100">
					</div>

					<div class="mura-control-group">
								<label>Contact City </label>
									<input name="contactCity" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcontactCity())#" size="50" maxlength="50" maxlength="100">
								</div>
					<div class="mura-control-group">
								<label>Contact State </label>
									<input name="contactState" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcontactState())#" size="50" maxlength="50" maxlength="100">
							</div>
					<div class="mura-control-group">
								<label>Contact Zip </label>
									<input name="contactZip" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcontactZip())#" size="50" maxlength="50" maxlength="100">
								</div>
					<div class="mura-control-group">
								<label>Contact Phone </label>
								<input name="contactPhone" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcontactPhone())#" size="50" maxlength="50" maxlength="100">
							</div>

					<div class="mura-control-group">
							<label>Contact Email </label>
							<input name="contactEmail" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcontactEmail())#" size="50" maxlength="50" maxlength="100">
						</div>

			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->

		<!--- Shared Resources --->
		<div id="tabSharedresources" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Shared Resources</h3>
				</div>
			  <!-- /block header -->
			  <div class="block-content">
				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.memberuserpool')#</label>
							<select  id="publicUserPoolID" name="publicUserPoolID" onchange="if(this.value!='' || jQuery('##privateUserPoolID').val()!=''){jQuery('##bundleImportUsersModeLI').hide();jQuery('##bundleImportUsersMode').attr('checked',false);}else{jQuery('##bundleImportUsersModeLI').show();}">
							<option value="">This site</option>
							<cfloop query="rsSites">
									<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
									<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getPublicUserPoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
								</cfif>
								</cfloop>
						</select>
						</div>

				<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.systemuserpool')#</label>
						<select  id="privateUserPoolID" name="privateUserPoolID" onchange="if(this.value!='' || jQuery('##publicUserPoolID').val()!=''){jQuery('##bundleImportUsersModeLI').hide();jQuery('##bundleImportUsersMode').attr('checked',false);}else{jQuery('##bundleImportUsersModeLI').show();}">
						<option value="">This site</option>
						<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
								<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getPrivateUserPoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
							</cfif>
							</cfloop>
					</select>
					</div>

				<!--- The ad manager is now gone, but can exist in limited legacy situations --->
				<cfif application.configBean.getAdManager() or rc.siteBean.getadManager()>
					<div class="mura-control-group">
						<label>#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.advertiseruserpool')#</label>
						<select  name="advertiserUserPoolID">
							<option value="">This site</option>
							<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
									<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getAdvertiserUserPoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
								</cfif>
							</cfloop>
						</select>
					</div>
				</cfif>

				<div class="mura-control-group">
				<label>#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.displayobjectpool')#</label>
						<select  name="displayPoolID">
						<option value="">This site</option>
						<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
								<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getDisplayPoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
							</cfif>
							</cfloop>
					</select>
					</div>

				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.filepool')#</label>
					<select  name="filePoolID">
						<option value="">This site</option>
						<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
								<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getFilePoolID()>selected</cfif>>#esapiEncode('html',rsSites.site)#</option>
							</cfif>
							</cfloop>
					</select>
					</div>

				<div class="mura-control-group">
					<label>#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.categorypool')#</label>
					<select id="categoryPoolID" name="categoryPoolID">
							<option value="">This site</option>
							<cfloop query="rsSites">
								<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
									<option value="#rsSites.siteid#" <cfif rsSites.siteid eq rc.siteBean.getCategoryPoolID()>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
								</cfif>
							</cfloop>
						</select>
					</div>

				<div class="mura-control-group">
					 <label>#application.rbFactory.getKeyValue(session.rb,'siteconfig.sharedresources.contentpool')#</label>
						<select id="contentPoolID" name="contentPoolID" multiple>
								<option value="#$.event('siteid')#" <cfif listFind(rc.siteBean.getContentPoolID(), $.event('siteid'))>selected</cfif>>This site</option>
								<cfloop query="rsSites">
									<cfif rsSites.siteid neq rc.siteBean.getSiteID()>
										<option value="#rsSites.siteid#" <cfif listFind(rc.siteBean.getContentPoolID(), rsSites.siteid)>selected</cfif>>#HTMLEditFormat(rsSites.site)#</option>
									</cfif>
								</cfloop>
							</select>
					 </div>

			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->

		<!--- Modules --->
		<div id="tabModules" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Modules</h3>
				</div>
			  <!-- /block header -->
			  <div class="block-content">
					<div class="mura-control-group">
							<label>Extranet <span class="help-inline">(Password Protection)</span></label>
									<label class="radio inline"><input type="radio" name="extranet" value="0" <cfif rc.siteBean.getextranet() neq 1> checked</cfif>>Off</label>
									<label class="radio inline"><input type="radio" name="extranet" value="1" <cfif rc.siteBean.getextranet()  eq 1> checked</cfif>>On</label>
					</div>
					<div class="mura-control-group">
							<label>Collections Manager</label>
									<label class="radio inline"><input type="radio" name="hasFeedManager" value="0" <cfif rc.siteBean.getHasFeedManager() neq 1> checked</cfif>>Off</label>
									<label class="radio inline"><input type="radio" name="hasFeedManager" value="1" <cfif rc.siteBean.getHasFeedManager()  eq 1> checked</cfif>>On</label>
						</div>
						<cfif application.configBean.getDataCollection()>
					<div class="mura-control-group">
							<label>Forms Manager</label>
									<label class="radio inline">
									<input type="radio" name="dataCollection" value="0" <cfif rc.siteBean.getdataCollection() neq 1> checked</cfif>>Off</label>
									<label class="radio inline"><input type="radio" name="dataCollection" value="1" <cfif rc.siteBean.getdataCollection() eq 1> checked</cfif>>On</label>
						</div>
						 </cfif>

						<!--- The ad manager is now gone, but can exist in limited legacy situations --->
					<cfif application.configBean.getAdManager() or rc.siteBean.getadManager()>
						<div class="mura-control-group">
							<label>Advertisement Manager</label>
									<label class="radio inline"><input type="radio" name="adManager" value="0" <cfif rc.siteBean.getadManager() neq 1> checked</cfif>>Off</label>
									<label class="radio inline"><input type="radio" name="adManager" value="1" <cfif rc.siteBean.getadManager() eq 1> checked</cfif>>On</label>

						</div>
					</cfif>
					<div class="mura-control-group">
							<label>Comments Manager</label>
							<label class="radio inline"><input type="radio" name="hasComments" value="0" <cfif rc.siteBean.getHasComments() neq 1> checked</cfif>>Off</label>
							<label class="radio inline"><input type="radio" name="hasComments" value="1" <cfif rc.siteBean.getHasComments() eq 1> checked</cfif>>On</label>
					</div>

					<cfif not rc.siteBean.getContentRenderer().useLayoutManager()>
						<div class="mura-control-group">
								<label>JSON API</label>
										<label class="radio inline"><input type="radio" name="JSONAPI" value="0" <cfif rc.siteBean.getJSONAPI() neq 1> checked</cfif>>Off</label>
										<label class="radio inline"><input type="radio" name="JSONAPI" value="1" <cfif rc.siteBean.getJSONAPI() eq 1> checked</cfif>>On</label>
						</div>
					</cfif>

					<cfif application.configBean.getEmailBroadcaster()>
						<div class="mura-control-group">
							<label>Email Broadcaster</label>
							<label class="radio inline"><input type="radio" name="EmailBroadcaster" value="0" <cfif rc.siteBean.getemailbroadcaster() neq 1> checked</cfif>>Off</label>
							<label class="radio inline"><input type="radio" name="EmailBroadcaster" value="1" <cfif rc.siteBean.getemailbroadcaster()  eq 1> checked</cfif>>On</label>
						</div>
						<div class="mura-control-group">
							<label>Email Broadcaster Limit</label>
							<input name="EmailBroadcasterLimit" type="text" class="mura-constrain mura-numeric" value="#esapiEncode('html_attr',rc.siteBean.getEmailBroadcasterLimit())#" size="50" maxlength="50">
						</div>
					</cfif>


				<div class="mura-control-group">
					<label>Content Staging Manager</label>
					<label class="radio inline">
					<input type="radio" name="hasChangesets" value="0" <cfif rc.siteBean.getHasChangesets() neq 1> checked</cfif>>
					Off </label>
					<label class="radio inline">
					<input type="radio" name="hasChangesets" value="1" <cfif rc.siteBean.getHasChangesets() eq 1> checked</cfif>>
					On </label>
				</div>

				<div class="mura-control-group">
					<label>Publish via Change Sets Only</label>
					<label class="radio inline">
					<input type="radio" name="enforceChangesets" value="0" <cfif rc.siteBean.getEnforceChangesets() neq 1> checked</cfif>>
					Off </label>
					<label class="radio inline">
					<input type="radio" name="enforceChangesets" value="1" <cfif rc.siteBean.getEnforceChangesets() eq 1> checked</cfif>>
					On </label>
				</div>

				<div class="mura-control-group">
					<label>Dashboard</label>
					<label class="radio inline">
					<input type="radio" name="showDashboard" value="0" <cfif rc.siteBean.getShowDashboard() neq 1> checked</cfif>>
					Off </label>
					<label class="radio inline">
					<input type="radio" name="showDashboard" value="1" <cfif rc.siteBean.getShowDashboard() eq 1> checked</cfif>>
					On </label>
				</div>

				<div class="mura-control-group">
					<label>Mura ORM Scaffolding (ALPHA)</label>
					<label class="radio inline">
					<input type="radio" name="scaffolding" value="0" <cfif rc.siteBean.getScaffolding() neq 1> checked</cfif>>
					Off </label>
					<label class="radio inline">
					<input type="radio" name="scaffolding" value="1" <cfif rc.siteBean.getScaffolding() eq 1> checked</cfif>>
					On </label>
				</div>
			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->

		<!--- Email --->
		<div id="tabEmail" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Email</h3>
			  </div>
			  <!-- /block header -->
			  <div class="block-content">
				<div class="mura-control-group">
				<label>Default "From" Email Address</label>
						<input name="contact" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcontact())#" size="50" maxlength="50">
					</div>
				<div class="mura-control-group">
				<label>Mail Server IP/Host Name</label>
						<input name="MailServerIP" type="text" class="text" value="#esapiEncode('html_attr',rc.siteBean.getMailServerIP())#" size="50" maxlength="50">
					</div>
				<div class="mura-control-group">
				<label>Mail Server SMTP Port</label>
						<input name="MailServerSMTPPort" type="text" class="text" value="#esapiEncode('html_attr',rc.siteBean.getMailServerSMTPPort())#" size="5" maxlength="5">
					</div>
				<div class="mura-control-group">
				<label>Mail Server POP Port</label>
						<input name="MailServerPOPPort" type="text" class="text" value="#esapiEncode('html_attr',rc.siteBean.getMailServerPOPPort())#" size="5" maxlength="5">
					</div>

				<div class="mura-control-group">
				<label>Mail Server Username
					<span data-toggle="popover" title="" data-placement="right"
				  	data-content="Do Not Use a Personal Account. Email will be removed from server for tracking purposes."
				  	data-original-title="WARNING:">
				  	<i class="mi-warning"></i></span></label>
						<input name="MailServerUserName" type="text" value="#esapiEncode('html_attr',rc.siteBean.getMailServerUserName())#" size="50" maxlength="50">
				</div>
				<div class="mura-control-group">
				<label>Mail Server Password</label>
						<input name="MailServerPassword" type="text" value="#esapiEncode('html_attr',rc.siteBean.getMailServerPassword())#" size="50" maxlength="50">
				</div>

			<div class="mura-control-group">
				<label>Use TLS</label>
						<label class="radio inline">
						<input type="radio" name="mailServerTLS" value="true" <cfif rc.siteBean.getmailServerTLS()  eq "true"> checked</cfif>>
						Yes </label>
						<label class="radio inline">
						<input type="radio" name="mailServerTLS" value="false" <cfif rc.siteBean.getmailServerTLS() eq "false"> checked</cfif>>
						No </label>
					</div>
			<div class="mura-control-group">
				<label>Use SSL</label>
						<label class="radio inline">
						<input type="radio" name="mailServerSSL" value="true" <cfif rc.siteBean.getmailServerSSL()  eq "true"> checked</cfif>>
						Yes </label>
						<label class="radio inline">
						<input type="radio" name="mailServerSSL" value="false" <cfif rc.siteBean.getmailServerSSL() eq "false"> checked</cfif>>
						No </label>
					</div>
			<div class="mura-control-group">
				<label>Use Default SMTP Server</label>
						<label class="radio inline">
						<input type="radio" name="useDefaultSMTPServer" value="1" <cfif rc.siteBean.getUseDefaultSMTPServer()  eq 1> checked</cfif>>
						Yes </label>
						<label class="radio inline">
						<input type="radio" name="useDefaultSMTPServer" value="0" <cfif rc.siteBean.getUseDefaultSMTPServer() neq 1> checked</cfif>>
						No </label>
					</div>

				<div class="mura-control-group">
   				<label>Content Pending Script</label>
   						<p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##contentType##</p>
   						<textarea rows="6" name="contentPendingScript">#esapiEncode('html',rc.siteBean.getContentPendingScript())#</textarea>
	   			</div>

			 <div class="mura-control-group">
				<label>Content Approval Script</label>
						<p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##contentType##</p>
						<textarea rows="6" name="contentApprovalScript">#esapiEncode('html',rc.siteBean.getContentApprovalScript())#</textarea>
			</div>

			 <div class="mura-control-group">
				<label>Content Rejection Script</label>
						<p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##contentType##</p>
						<textarea rows="6" name="contentRejectionScript">#esapiEncode('html',rc.siteBean.getContentRejectionScript())#</textarea>
			</div>

			<div class="mura-control-group">
			   <label>Content Canceled Script</label>
					   <p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##contentType##</p>
					   <textarea rows="6" name="contentCanceledScript">#esapiEncode('html',rc.siteBean.getContentCanceledScript())#</textarea>
		   </div>

			<div class="mura-control-group">
				<label>User Login Authorization Code Challenge Script</label>
					<p class="help-block">Available Dynamic Content: ##firstName## ##lastName## ##username## ##email## ##authcode## ##contactEmail## ##contactName##</p>
					<textarea rows="6" name="sendAuthCodeScript">#esapiEncode('html',rc.siteBean.getSendAuthCodeScript())#</textarea>
			</div>

			<div class="mura-control-group">
				<label>User Login Info Request Script</label>
					<p class="help-block">Available Dynamic Content: ##firstName## ##lastName## ##username## ##password## ##contactEmail## ##contactName## ##returnURL##</p>
					<textarea rows="6" name="sendLoginScript">#esapiEncode('html',rc.siteBean.getSendLoginScript())#</textarea>
			</div>

			<div class="mura-control-group">
				<label>Mailing List Confirmation Script</label>
					<p class="help-block">Available Dynamic Content: ##listName## ##contactName## ##contactEmail## ##returnURL##</p>
					<textarea rows="6" name="mailingListConfirmScript">#esapiEncode('html',rc.siteBean.getMailingListConfirmScript())#</textarea>
			</div>
				<div class="mura-control-group">
				<label>Account Activation Script</label>
						<p class="help-block">Available Dynamic Content: ##firstName## ##lastName## ##username## ##contactEmail## ##contactName##</p>
						<textarea rows="6" name="accountActivationScript">#esapiEncode('html',rc.siteBean.getAccountActivationScript())#</textarea>
			</div>
			<!---
				<div class="mura-control-group">
				<label>Public Submission Approval Script</label>
						<p class="help-block">Available Dynamic Content: ##returnURL## ##contentName## ##parentName## ##contentType##</p>
						<textarea rows="6" name="publicSubmissionApprovalScript">#esapiEncode('html',rc.siteBean.getPublicSubmissionApprovalScript())#</textarea>
			</div>
			--->
				<div class="mura-control-group">
				<label>Event Reminder Script</label>
						<p class="help-block">Available Dynamic Content: ##returnURL## ##eventTitle## ##startDate## ##startTime## ##siteName## ##eventContactName## ##eventContactAddress## ##eventContactCity## ##eventContactState## ##eventContactZip## ##eventContactPhone##</p>
						<textarea rows="6" name="reminderScript">#esapiEncode('html',rc.siteBean.getReminderScript())#</textarea>
			</div>

			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->

		<!--- Galleries --->
		<div id="tabImages" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Image Galleries</h3>
				</div>
			  <!-- /block header -->

		  <div class="block-content">
			<div class="mura-control-group">
				<label>Small (Thumbnail) Image</label>
				<div class="mura-control-inline">
					<label>Height</label>
					<input name="smallImageHeight" type="text" value="#esapiEncode('html_attr',rc.siteBean.getSmallImageHeight())#" />
					<label>Width</label>
					<input name="smallImageWidth" type="text" value="#esapiEncode('html_attr',rc.siteBean.getSmallImageWidth())#" />
				</div>
			</div>

			<div class="mura-control-group">
				<label>Medium Image</label>
				<div class="mura-control-inline">
					<label>Height</label>
					<input name="mediumImageHeight" type="text" value="#esapiEncode('html_attr',rc.siteBean.getMediumImageHeight())#" />
					<label>Width</label>
					<input name="mediumImageWidth" type="text" value="#esapiEncode('html_attr',rc.siteBean.getMediumImageWidth())#" />
				</div>
			</div>

			<div class="mura-control-group">
				<label>Large Image</label>
				<div class="mura-control-inline">
					<label>Height</label>
					<input name="largeImageHeight" type="text" value="#esapiEncode('html_attr',rc.siteBean.getLargeImageHeight())#" />
					<label>Width</label>
					<input name="largeImageWidth" type="text" value="#esapiEncode('html_attr',rc.siteBean.getLargeImageWidth())#" />
				</div>
			</div>

				<cfif len(rc.siteBean.getSiteID())>
				<script>
			function openCustomImageSize(sizeid,siteid){

					jQuery("##custom-image-dialog").remove();
					jQuery("body").append('<div id="custom-image-dialog" rel="tooltip" title="Loading..." style="display:none"><div id="newContentMenu"><div class="load-inline"></div></div></div>');

					var editTitle = "Add Custom Image Size";

					var dialogoptions= {};

						dialogoptions.Cancel=function() {
						 jQuery( this ).dialog( "close" );
						};

						if(sizeid != ''){
							dialogoptions.Delete=function(){
								deleteCustomImageSize();
								jQuery( this ).dialog( "close" );
							};
							var editTitle = "Edit Custom Image Size";
						}

						dialogoptions.Save={click: function() {
								saveCustomImageSize();
								jQuery(this).dialog('close');
							}
							, text: 'Save'
							, class: 'mura-primary'
						} // /Save

					jQuery("##custom-image-dialog").dialog({
						resizable: false,
						modal: true,
						width: 400,
						position: getDialogPosition(),
						buttons:
						dialogoptions,
						open: function(){
							jQuery("##custom-image-dialog").html('<div class="ui-dialog-content ui-widget-content"><div class="load-inline"></div></div>');
							var url = 'index.cfm';
							var pars = 'muraAction=cSettings.loadcustomimage&siteid=' + siteid +'&sizeid=' + sizeid  +'&cacheid=' + Math.random();
							jQuery.get(url + "?" + pars,
									function(data) {
									jQuery("##custom-image-dialog").closest(".ui-dialog").find(".ui-dialog-title").html(editTitle);
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
			<div class="mura-control-group">
				<label>Custom Images</label>
				<div class="mura-control justify">
					<a href="##" onclick="return openCustomImageSize('','#esapiEncode('javascript',rc.siteBean.getSiteID())#')" class="btn"><i class="mi-plus-circle"></i> Add Custom Image Size</a>
				</div>
				<div class="mura-control justify">
					<div id="custom-images-container"></div>
				</div>
			</div>
			</cfif>
			<div class="mura-control-group">
				<label>Placeholder Image</label>
				<div class="mura-control justify">
					<cf_fileselector b name="newPlaceholderImg" property="placeholderImgID" bean="#rc.siteBean#" deleteKey="deletePlaceholderImg" compactDisplay="#rc.compactDisplay#" locked="0" examplefileext="" >
				</div>
			</div>

			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->

		<!--- Extranet --->
		<div id="tabExtranet" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Extranet Settings</h3>
			  </div>
			  <!-- /block header -->
			  <div class="block-content">
				<div class="mura-control-group">
				<label>Allow Public Site Registration</label>
						<label class="radio inline">
						<input type="radio" name="extranetpublicreg" value="0" <cfif rc.siteBean.getextranetpublicreg() neq 1> checked</cfif>>
						No </label>
						<label class="radio inline">
						<input type="radio" name="extranetpublicreg" value="1" <cfif rc.siteBean.getextranetpublicreg()  eq 1> checked</cfif>>
						Yes </label>
					</div>
			<!--- This is removed in favor of a useSSL
				<div class="mura-control-group">
				<label>Require HTTPS Encryption for Extranet</label>
						<label class="radio inline">
						<input type="radio" name="extranetssl" value="0" <cfif rc.siteBean.getextranetssl() neq 1> checked</cfif>>
						No </label>
						<label class="radio inline">
						<input type="radio" name="extranetssl" value="1" <cfif rc.siteBean.getextranetssl()  eq 1> checked</cfif>>
						Yes </label>
					</div>
			--->

				<div class="mura-control-group">
				<label>Custom Login URL</label>
						<input name="loginURL" type="text" value="#esapiEncode('html_attr',rc.siteBean.getLoginURL(parseMuraTag=false))#" maxlength="255">
				</div>
				<div class="mura-control-group">
				<label>Custom Profile URL</label>
						<input name="editProfileURL" type="text" value="#esapiEncode('html_attr',rc.siteBean.getEditProfileURL(parseMuraTag=false))#" maxlength="255">
				</div>
				<!---  <dt>Allow Public Submission In To Folders</dt>
			<dd>
				<input type="radio" name="publicSubmission" value="0" <cfif rc.siteBean.getpublicSubmission() neq 1> checked</cfif>>
				No&nbsp;&nbsp;
				<input type="radio" name="publicSubmission" value="1" <cfif rc.siteBean.getpublicSubmission() eq 1> checked</cfif>>
				Yes</dd>
			<dd> --->

				<div class="mura-control-group">
				<label>Email Site Registration Notifications to:</label>
						<input name="ExtranetPublicRegNotify" type="text" value="#rc.siteBean.getExtranetPublicRegNotify()#" size="255" maxlength="255">
			</div>

			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->

		<!--- Display Regions --->
		<div id="tabDisplayregions" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Display Regions</h3>
			  </div>
			  <!-- /block header -->
			  <div class="block-content">
				<div class="mura-control-group">
					<label>Number of Display Regions</label>
						<select name="columnCount">
						<option value="1" <cfif rc.siteBean.getcolumnCount() eq 1 or rc.siteBean.getcolumnCount() eq 0> selected</cfif>> 1</option>
						<cfloop from="2" to="20" index="i">
								<option value="#i#" <cfif rc.siteBean.getcolumnCount() eq i> selected</cfif>>#i#</option>
							</cfloop>
					</select>
					</div>

				 <div class="mura-control-group">
				<label>Primary Display Region</label>
				<span class="help-block">Dynamic System Content such as Login Forms and Search Results get displayed here</span>
						<select name="primaryColumn">
						<cfloop from="1" to="20" index="i">
								<option value="#i#" <cfif rc.siteBean.getPrimaryColumn() eq i> selected</cfif>>#i#</option>
							</cfloop>
					</select>
						</div>

				<div class="mura-control-group">
				<label>Display Region Names <span class="help-inline">"^" Delimiter</span></label>
						<input name="columnNames" type="text" value="#esapiEncode('html_attr',rc.siteBean.getcolumnNames())#">
					</div>

			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->

		<!--- Extended Attributes --->
		<cfif arrayLen(extendSets)>
				<div id="tabExtendedAttributes" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Extended Attributes</h3>
			  </div>
			  <!-- /block header -->
			  <div class="block-content">					<cfset started=false />
				<cfloop from="1" to="#arrayLen(extendSets)#" index="s">
						<cfset extendSetBean=extendSets[s]/>
						<cfset style=extendSetBean.getStyle()/>
						<cfif not len(style)>
						<cfset started=true/>
					</cfif>
						<span class="extendset" extendsetid="#extendSetBean.getExtendSetID()#" categoryid="#extendSetBean.getCategoryID()#" #style#>
					<input name="extendSetID" type="hidden" value="#extendSetBean.getExtendSetID()#"/>
					<div class="block block-bordered">
							<h2>#extendSetBean.getName()#</h2>
							<cfsilent>
						<cfset attributesArray=extendSetBean.getAttributes() />
						</cfsilent>
							<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">
							<cfset attributeBean=attributesArray[a]/>
							<cfset attributeValue=rc.siteBean.getvalue(attributeBean.getName(),'useMuraDefault') />
							<div class="mura-control-group">
									<label>
									<cfif len(attributeBean.getHint())>
										<span data-toggle="popover" title="" data-placement="right"
									  	data-content="#esapiEncode('html_attr',attributeBean.gethint())#"
									  	data-original-title="#esapiEncode('html_attr',attributeBean.getLabel())#">
									  	#attributeBean.getLabel()# <i class="mi-question-circle"></i></span>
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
									#attributeBean.renderAttribute(attributeValue)#
								</div>
						</cfloop>
						</div>
					</span>
					</cfloop>
			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->
		</cfif>

		<!--- Site Bundles --->
		<div id="tabBundles" class="tab-pane">
			<cfif application.configBean.getJavaEnabled()>
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Deploy Site Bundle</h3>
			  </div>
			  <!-- /block header -->
			  <div class="block-content">
				<cfif listFind(session.mura.memberships,'S2')>


				<div class="mura-control-group">
					<label> Are you restoring a site from a backup bundle? </label>
						<label class="radio inline"><input type="radio" name="bundleImportKeyMode" value="copy" checked="checked">No - <em>Assign New Keys to Imported Items</em></label>
						<label class="radio inline" for=""><input type="radio" name="bundleImportKeyMode" value="publish">Yes - <em>Maintain All Keys from Imported Items</em></label>
					</div>

				<div class="mura-control-group">
				<label>Include:</label>
				<div class="mura-control">
								<label class="checkbox" for="bundleImportContentMode">
								<input id="bundleImportContentMode" name="bundleImportContentMode" value="all" type="checkbox" onchange="if(this.checked){jQuery('##contentRemovalNotice').show();}else{jQuery('##contentRemovalNotice').hide();}">
								Site Architecture &amp; Content</label>
						<span id="bundleImportUsersModeLI"<cfif not (rc.siteBean.getPublicUserPoolID() eq rc.siteBean.getSiteID() and rc.siteBean.getPrivateUserPoolID() eq rc.siteBean.getSiteID())> style="display:none;"</cfif>>
								<label class="checkbox" for="bundleImportUsersMode">
								<input id="bundleImportUsersMode" name="bundleImportUsersMode" value="all" type="checkbox"  onchange="if(this.checked){jQuery('##userNotice').show();}else{jQuery('##userNotice').hide();}">
								Site Members &amp; Administrative Users</label>
							</span>

							<cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster()>
								<label class="checkbox" for="bundleImportMailingListMembersMode">
								<input id="bundleImportMailingListMembersMode" name="bundleImportMailingListMembersMode" value="all" type="checkbox">
								Mailing Lists Members</label>
							</cfif>
								<label class="checkbox" for="bundleImportFormDataMode">
								<input id="bundleImportFormDataMode" name="bundleImportFormDataMode" value="all" type="checkbox">
								Form Response Data</label>
								<label class="checkbox" for="bundleImportPluginMode">
								<input id="bundleImportPluginMode" name="bundleImportPluginMode" value="all" type="checkbox">
								All Plugins</label>
					</div>
						<p class="help-block" style="display:none" id="contentRemovalNotice"><strong>Important:</strong> When importing content from a Mura bundle ALL of the existing content will be deleted.</p>
						<p class="help-block" style="display:none" id="userNotice"><strong>Important:</strong> Importing users will remove all existing user data which may include the account that you are currently logged in as.</p>
					</div>
				 </cfif>
				<div class="mura-control-group">
					<label> Which rendering files would you like to import? </label>
							<cfif listFind(session.mura.memberships,'S2')>
								 <label class="radio inline">
									<input type="radio" name="bundleImportRenderingMode" value="all" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">All</label>
							</cfif>
							<label class="radio inline">
							<input type="radio" name="bundleImportRenderingMode" value="theme" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}"<cfif not listFind(session.mura.memberships,'S2')> checked="true"</cfif>>Theme Only</label>

							<label class="radio inline">
							<input type="radio" name="bundleImportRenderingMode" value="none" checked="checked" onchange="if(this.value!='none'){jQuery('##themeNotice').show();}else{jQuery('##themeNotice').hide();}">None</label>

							<p class="help-block"<cfif listFind(session.mura.memberships,'S2')> style="display:none"</cfif> id="themeNotice"><strong>Important:</strong> Your site theme assignment and gallery image settings will be updated.</p>
					</div>

				<div class="mura-control-group">
					<label>
						<span
							data-toggle="popover"
							title=""
							data-placement="right"
							data-content="Enter the complete server path to the Site Bundle here. For example: C://path/to/bundle/file.zip"
							data-original-title="INFO">
							Select Bundle File From Server
							<cfif application.configBean.getPostBundles()>
								<strong>(Preferred)</strong>
							</cfif>
							<i class="mi-question-circle"></i>
						</span>
					</label>
					<div class="mura-control justify">
						<input class="text" type="text" name="serverBundlePath" id="serverBundlePath" value="">
						<input type="button" value="Browse Server" class="mura-ckfinder" data-completepath="true" data-resourcetype="root" data-target="serverBundlePath"/>
					</div>
					<cfif application.configBean.getPostBundles()>
						<p class="help-block">
							Selecting a bundle file from the server eliminates the need to upload the file via your web browser, avoiding potential timeout issues and server upload restrictions.
						</p>
					</cfif>
				</div>

				<cfif application.configBean.getPostBundles()>
					<div class="mura-control-group">
						<label>
							<span data-toggle="popover" title="" data-placement="right"
							data-content="Uploading large files via the web browser can result in potential timeout issues and trigger server upload restrictions."
							data-original-title="WARNING">Upload Bundle File <i class="mi-question-circle"></i></span>
						</label>
						<input type="file" name="bundleFile" accept=".zip"/>
					</div>
				<cfelse>
					<input type="hidden" name="bundleFile" value=""/>
				</cfif>

			</div> <!--- /.block-content --->
			<cfelse>
			<div class="block block-bordered">
				<div class="mura-control-group">
					<div class="help-block-empty">
						Java is disabled. This feature is unavailable.
					</div>
				</div>
			</div>
			</cfif>
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->
	<cfif rc.$.globalConfig().getValue(property='razuna',defaultValue=false)>
		<cfset rc.razunaSettings=rc.siteBean.getRazunaSettings()>
		<div id="tabRazuna" class="tab-pane">
			<div class="block block-bordered">
				<!-- block header -->
			  <div class="block-header">
					<h3 class="block-title">Razuna Settings</h3>
			  </div>
			  <!-- /block header -->
			  <div class="block-content">
			<!---
			<div class="mura-control-group">
				<label for="razuna_servertype">Server Type</label>
				<div class="mura-control justify">
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
			<div class="mura-control-group">
				<label for="razuna_hostname">Hostname <span class="help-block">Example: yourcompany.razuna.com or localhost:8080/razuna</span></label>
					<input type="text" value="#esapiEncode('html_attr',rc.razunaSettings.getHostName())#" id="razuna_hostname" name="hostname">

				</div>

			<div class="mura-control-group">
				<label for="hostid">Host ID <span class="help-block">Example: 496</span></label>
					<input type="text" value="#esapiEncode('html_attr',rc.razunaSettings.getHostID())#" id="razuna_hostid" name="hostid">
			</div>

			<div class="mura-control-group">
				<label for="dampath">DAM Path <span class="help-block">Example: /demo/dam</span></label>
					<input type="text" value="#esapiEncode('html_attr',rc.razunaSettings.getDAMPath())#" id="razuna_dampath" name="damPath">
			</div>

			<div class="mura-control-group">
				<label for="razuna_api_key">API Key</label>
					<input type="text" value="#esapiEncode('html_attr',rc.razunaSettings.getApiKey())#" id="razuna_api_key" name="apikey">
			</div>

			</div> <!--- /.block-content --->
		</div> <!--- /.block --->
	</div> <!--- /.tab-pane --->
	</cfif>

	</cfoutput>
	<cfoutput query="rsPluginScripts" group="pluginID">
		<!---<cfset tabLabelList=tabLabelList & ",'#esapiEncode('javascript',rsPluginScripts.name)#'"/>--->
		<cfset tabID="tab" & $.createCSSID(rsPluginScripts.name)>
		<div id="#tabID#" class="tab-pane">
			<cfoutput>
				<div class="block block-bordered">
					<!-- block header -->
				  <div class="block-header">
						<h3 class="block-title">#rsPluginScripts.name#</h3>
				  </div><!-- /block header -->
				  <div class="block-content">
						<cfset rsPluginScript=application.pluginManager.getScripts("onSiteEdit",rc.siteID,rsPluginScripts.moduleID)>
						<cfif rsPluginScript.recordcount>
							#application.pluginManager.renderScripts("onSiteEdit",rc.siteid,pluginEvent,rsPluginScript)#
						</cfif>
					</div> <!--- /.block-content --->
				</div> <!--- /.block --->
			</cfoutput>
		</div> <!--- /.tab-pane --->
	</cfoutput> <!--- /rsPluginScripts --->


		<div class="load-inline tab-preloader"></div>
		<script>$('.tab-preloader').spin(spinnerArgs2);</script>
		<cfoutput>
			#actionButtons#
			<input type="hidden" name="action" value="update">
			#rc.$.renderCSRFTokens(context=rc.siteID,format="form")#
		</cfoutput>

		</div>	<!--- /.block-content.tab-content --->
	</div>	<!--- /.block-constrain --->

</form>
