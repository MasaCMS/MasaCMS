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
<cfparam name="rc.action" default="">
<cfparam name="rc.siteSortBy" default="site">
<cfparam name="rc.siteUpdateSelect" default="false">
<cfparam name="rc.siteAutoDeploySelect" default="false">
<h1>Global Settings</h1>
<div id="nav-module-specific" class="btn-toolbar">
	<cfif rc.action neq 'updateCore'>
		<cfif application.configBean.getAllowAutoUpdates()>
			<div class="btn-group">
				<cfoutput>
				<a class="btn" href="##" onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf your are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('./?muraAction=cSettings.list&action=updateCore#rc.$.renderCSRFTokens(context='updatecore',format='url')#')});return false;"><i class="icon-bolt"></i> Update Core Files to Latest Version</a>
				</cfoutput>
				<cfif rc.siteUpdateSelect neq "true">
					<a class="btn" href="./?muraAction=cSettings.list&siteUpdateSelect=true"><i class="icon-bolt"></i> Multi-Site Version Update</a>
				</cfif>
			</div>
		</cfif>
		<div class="btn-group">
			<cfif rc.siteUpdateSelect eq "true" or rc.siteSortBy eq "orderno">
				<a class="btn" href="./?muraAction=cSettings.list&siteSortBy=site"><i class="icon-list"></i> View Site List by Site Name</a>
			</cfif>
			<cfif rc.siteSortBy neq "orderno">
				<a class="btn" href="./?muraAction=cSettings.list&siteSortBy=orderno"><i class="icon-list"></i> View Site List by Bind Order</a>
			</cfif>
			<cfelse>
			<a class="btn" href="./?muraAction=cSettings.list"><i class="icon-list"></i> View Site List</a>
			</cfif>
		</div>
</div>
 
<!--- site updates messaging --->
<cfif StructKeyExists(rc, 'sitesUpdated') and IsSimpleValue(rc.sitesUpdated) and len(trim(rc.sitesUpdated))>
	<cfoutput>#rc.sitesUpdated#</cfoutput>
</cfif>

<cfif rc.action neq 'updateCore'>
	<cfif rc.action eq "deploy">
		<cfoutput>#application.pluginManager.announceEvent("onAfterSiteDeployRender",event)#</cfoutput>
	</cfif>
	<cfset errors=application.userManager.getCurrentUser().getValue("errors")>
	<cfif isStruct(errors) and not structIsEmpty(errors)>
		<cfoutput>
		<div class="alert alert-error">#application.utility.displayErrors(errors)#</div>
		</cfoutput>
	</cfif>
	<cfset application.userManager.getCurrentUser().setValue("errors","")>
	
	<div class="tabbable">
		<ul class="nav nav-tabs tabs initActiveTab">
			<li><a href="#tabCurrentsites" onclick="return false;"><span>Current Sites</span></a></li>
			<li><a href="#tabPlugins" onclick="return false;"><span>Plugins</span></a></li>
		</ul>
	<div class="tab-content">
		<div id="tabCurrentsites" class="tab-pane fade"> 
			<script type="text/javascript">
				jQuery(function ($) {
					$('#checkall').click(function () {
						$(':checkbox.checkall').attr('checked', this.checked);
					});
					$('#btnUpdateSites').click(function() {
						confirmDialog(
						'WARNING: DO NOT continue unless you have backed up all selected site files.',
						function(){
							actionModal(
								function(){
									$('.form-actions').hide();
									$('#actionIndicator').show();
									document.form1.submit();
								}
							);
						}
						)

					});
				});
			</script>
			<form novalidate="novalidate" name="form1" id="form1" action="./?muraAction=csettings.list" method="post">
				<table class="mura-table-grid">
					<tr>
						<cfif rc.siteUpdateSelect eq "true">
							<th>
								<input type="checkbox" name="checkall" id="checkall" />
								<input type="hidden" name="siteUpdateSelect" value="true">
							</th>
						</cfif>
						<cfif rc.siteSortBy eq "orderno">
							<th>Bind Order</th>
						</cfif>
						<th class="var-width">Site</th>
						<th>Domain</th>
						<th>Version</th>
						<cfif application.configBean.getMode() eq 'staging'
						and rc.siteSortBy neq "orderno"
						and rc.siteUpdateSelect neq "true">
							<th>Batch&nbsp;Deploy</th>
							<th>Last&nbsp;Deployment</th>
						</cfif>
						<!---<th>Site Version</th>--->
						<th class="actions">&nbsp;</th>
					</tr>
					<cfoutput query="rc.rsSites">
					<tr>
						<cfif rc.siteUpdateSelect eq "true">
							<td>
								<input type="checkbox" name="ckUpdate" class="checkall" value="#rc.rsSites.siteid#" />
							</td>
						</cfif>
						<cfif rc.siteSortBy eq "orderno">
							<td><select name="orderno" class="dropdown">
									<cfloop from="1" to="#rc.rsSites.recordcount#" index="I">
									<option value="#I#" <cfif I eq rc.rsSites.currentrow>selected</cfif>>#I#</option>
									</cfloop>
								</select>
								<input type="hidden" value="#rc.rsSites.siteid#" name="orderid" />
							</td>
						</cfif>
						<td class="var-width"><a title="Edit" href="./?muraAction=cSettings.editSite&siteid=#rc.rsSites.siteid#">#rc.rsSites.site#</a></td>
						<td>
							<cfif len(rc.rsSites.domain)>
								#esapiEncode('html',rc.rsSites.domain)#
								<cfelse>
								-
							</cfif>
						</td>
						<td> #application.autoUpdater.getCurrentCompleteVersion(rc.rsSites.siteid)#</td>
						<cfif application.configBean.getMode() eq 'staging'
						and rc.siteSortBy neq "orderno"
						and rc.siteUpdateSelect neq "true">
							<td><select name="deploy" class="dropdown">
									<option value="1" <cfif rc.rsSites.deploy eq 1>selected</cfif>>Yes</option>
									<option value="0" <cfif rc.rsSites.deploy neq 1>selected</cfif>>No</option>
								</select></td>
							<td><cfif LSisDate(rc.rsSites.lastDeployment)>
									#LSDateFormat(rc.rsSites.lastDeployment,session.dateKeyFormat)#
									<cfelse>
									Never
								</cfif></td>
						</cfif>
						<!---<td>#application.autoUpdater.getCurrentCompleteVersion(rc.rsSites.siteid)#</td>--->
						<td class="actions"><ul <cfif application.configBean.getMode() eq 'Staging'>class="three"<cfelse>class="two"</cfif>>
								<li class="edit"><a title="Edit" href="./?muraAction=cSettings.editSite&siteid=#rc.rsSites.siteid#"><i class="icon-pencil"></i></a></li>
								<cfif application.configBean.getMode() eq 'Staging'>
									<cfif application.configBean.getValue('deployMode') eq "bundle">
										<li class="deploy"><a href="?muraAction=cSettings.deploybundle&siteid=#rc.rsSites.siteid#" onclick="return confirmDialog('Deploy #esapiEncode('javascript',rc.rsSites.site)# to production?',this.href);" title="Deploy">Deploy</a></li>
									<cfelse>
										<li class="deploy"><a href="?muraAction=cSettings.list&action=deploy&siteid=#rc.rsSites.siteid#" onclick="return confirmDialog('Deploy #esapiEncode('javascript',rc.rsSites.site)# to production?',this.href);" title="Deploy">Deploy</a></li>
									</cfif>
								</cfif>
								<cfif rc.rsSites.siteid neq 'default'>
									<li class="delete"><a title="Delete" href="##" onclick="confirmDialog('#esapiEncode("javascript","WARNING: A deleted site and all of its files cannot be recovered. Are you sure that you want to delete the site named '#Ucase(rc.rsSites.site)#'?")#',function(){actionModal('./?muraAction=cSettings.updateSite&action=delete&siteid=#rc.rsSites.siteid##rc.$.renderCSRFTokens(context=rc.rssites.siteid,format='url')#')});return false;"><i class="icon-remove-sign"></i></a></li>
									<cfelse>
									<li class="delete disabled"><i class="icon-remove-sign"></i></li>
								</cfif>
								<!---<li class="export"><a title="Export" href="./?muraAction=cArch.exportHtmlSite&siteid=#rc.rsSites.siteid#" onclick="return confirm('Export the #esapiEncode("javascript","'#rc.rsSites.site#'")# Site?')">Export</a></li>--->
							</ul></td>
					</tr>
					</cfoutput>
				</table>
				<cfif rc.siteSortBy eq "orderno">
					<button type="button" class="btn" onclick="document.form1.submit();"><i class="icon-check"></i> Update Bind Order</button>
				</cfif>
				<cfif  rc.siteUpdateSelect eq "true">
					<div class="form-actions">
					<button type="button" class="btn" id="btnUpdateSites"><i class="icon-bolt"></i> Update Selected Sites to Latest Version</button>
					</div>
					<div class="load-inline" style="display: none;"></div>
				</cfif>
				<cfif application.configBean.getMode() eq 'staging'
						and rc.siteSortBy neq "orderno"
						and rc.siteUpdateSelect neq "true">
					<button type="button" class="btn" onclick="document.form1.submit();"><i class="icon-check"></i>Update Auto Deploy Settings</button>
				</cfif>
				<cfoutput>
					<input type="hidden" name="siteSortBy" value="#esapiEncode('html_attr',rc.siteSortBy)#" />
					#rc.$.renderCSRFTokens(context='updatesites',format='form')#
				</cfoutput>
			</form>
		</div>
		<div id="tabPlugins" class="tab-pane fade">
		<h2>Install Plugin</h2>
		<cfif application.configBean.getJavaEnabled()>
		<div class="mura-file-selector">
			<div class="btn-group" data-toggle="buttons-radio">
			  <button type="button" class="btn active" data-toggle="button" name="installType" value="Upload" id="apptypefile"><i class="icon-upload-alt"></i> Via Upload</button>
			  <button type="button" class="btn" name="installType" value="URL" id="apptypeurl"><i class="icon-download-alt"></i> Via URL</button>
			</div>
	
			<div id="appzip" class="fileTypeOption">
				<form novalidate="novalidate" name="frmNewPlugin" action="./?muraAction=cSettings.deployPlugin" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);">
					<div class="control-group">
						<label class="control-label">Select File to Upload</label>
						<div class="controls"><input name="newPlugin" type="file" data-required="true" message="Please select a plugin file."></div>
					</div>
					<button type="submit" value="Deploy" class="btn" /><i class="icon-bolt"></i> Deploy</button>
					<cfoutput>#rc.$.renderCSRFTokens(context='newplugin',format='form')#</cfoutput>
				</form>
			</div>
			<div id="appurl" class="fileTypeOption" style="display:none;">
				<form name="frmNewPluginFROMURL" action="./?muraAction=cSettings.deployPlugin" method="post" onsubmit="return validateForm(this);">
					<div class="control-group">
						<label class="control-label">Enter URL</label>
						<div class="controls">	
							<input type="text" name="newPlugin"  class="input-xxlarge" type="url" data-required="true" placeholder="http://www.domain.com/plugin.zip"
					message="Please enter the url for your plugin file"
					value=""></div>
					</div>
					<button type="submit" class="btn" /><i class="icon-bolt"></i> Deploy</button>
					<cfoutput>#rc.$.renderCSRFTokens(context='newplugin',format='form')#</cfoutput>
				</form>
				</div>
		</div>
		<script>
			$(function(){
				$("#apptypefile").click(
					function(){
							$("#appurl").hide()
							$("#appzip").show()
					}
				);
				$("#apptypeurl").click(
					function(){
							$("#appurl").show()
							$("#appzip").hide()
					}
				);
			})
		</script>
		

	   <cfelse>
	      
	          <div class="alert">
	            Java is currently disabled. So the ability to install plugins is not currently available.
	          </div>
	    
      </cfif>
		<h2>Current Plugins</h2>
			<table class="mura-table-grid">
				<tr>
					<th class="var-width">Name</th>
					<th>Directory</th>
					<th>Category</th>
					<th>Version</th>
					<th>Provider</th>
					<!--- <th>Provider URL</th> --->
					<th>Plugin ID</th>
					<th class="actions">&nbsp;</th>
				</tr>
				<cfif rc.rsPlugins.recordcount>
					<cfoutput query="rc.rsPlugins">
					<tr>
						<td class="var-width"><a class="alt" title="view" href="#application.configBean.getContext()#/plugins/#rc.rsPlugins.directory#/">#esapiEncode('html',rc.rsPlugins.name)#</a></td>
						<td>#esapiEncode('html',rc.rsPlugins.directory)#</td>
						<td>#esapiEncode('html',rc.rsPlugins.category)#</td>
						<td>#esapiEncode('html',rc.rsPlugins.version)#</td>
						<td><a class="alt" href="#esapiEncode('url',rc.rsPlugins.providerurl)#" target="_blank">#esapiEncode('html',rc.rsPlugins.provider)#</a></td>
						<!--- <td><a href="#rc.rsPlugins.providerurl#" target="_blank">View</a></td> --->
						<td>#rc.rsPlugins.pluginID#</td>
						<td class="actions"><ul>
								<li class="edit"><a title="Edit" href="./?muraAction=cSettings.editPlugin&moduleID=#rc.rsPlugins.moduleID#"><i class="icon-pencil"></i></a></li>
								<li class="delete"><a title="Delete" href="##" onclick="confirmDialog('Delete #esapiEncode("javascript","'#Ucase(rc.rsPlugins.name)#'")#?',function(){actionModal('./?muraAction=cSettings.deletePlugin&moduleID=#rc.rsPlugins.moduleID##rc.$.renderCSRFTokens(context=rc.rsplugins.moduleid,format='url')#')});return false;"><i class="icon-remove-sign"></i></a></li>
							</ul></td>
					</tr>
					</cfoutput>
					<cfelse>
					<tr>
						<td class="noResults" colspan="7">There are currently no installed plugins.</td>
					</tr>
				</cfif>
			</table>
		</div>
		<div class="load-inline tab-preloader"></div>
		<script>$('.tab-preloader').spin(spinnerArgs2);</script>
	</div>
	</div>
	<!---
<cfparam name="rc.activeTab" default="0">
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="assets/js/tab-view.js"></script>'>
<cfoutput><script type="text/javascript">
initTabs(Array("Current Sites","Plugins"),#rc.activeTab#,0,0);
</script></cfoutput>--->
<cfelse>
	<cftry>
		<cfif rc.$.validateCSRFTokens(context='updatecore')>
			<cfset updated=application.autoUpdater.update()>
			<cfset files=updated.files>
		<cfelse>
			<cfset files=[]>
		</cfif>
		
		<p>Your core files have been updated to version
			<cfoutput>#application.autoUpdater.getCurrentCompleteVersion()#</cfoutput>.</p>
		<p> <strong>Updated Files
			<cfoutput>(#arrayLen(files)#)</cfoutput>
			</strong><br/>
			<cfif arrayLen(files)>
				<cfoutput>
				<cfloop from="1" to="#arrayLen(files)#" index="i"> #files[i]#<br/>
				</cfloop>
				</cfoutput>
			</cfif>
		</p>
		<cfcatch>
			<h2>An Error has occurred.</h2>
			<cfdump var="#cfcatch.message#">
			<br/>
			<br/>
			<cfdump var="#cfcatch.TagContext#">
		</cfcatch>
	</cftry>
</cfif>