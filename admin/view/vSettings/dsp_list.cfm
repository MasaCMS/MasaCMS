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
<cfparam name="attributes.action" default="">
<cfparam name="attributes.siteSortBy" default="site">
<cfparam name="attributes.siteUpdateSelect" default="false">
<cfparam name="attributes.siteAutoDeploySelect" default="false">
<h2>Site Settings</h2>
<ul id="navTask">
	<cfif attributes.action neq 'updateCore'>
		<li><a href="index.cfm?fuseaction=cSettings.list&action=updateCore" onclick="return confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.\n\nIf your are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.',this.href);">Update Core Files to Latest Version</a></li>
		<cfif attributes.siteUpdateSelect eq "true" or attributes.siteSortBy eq "orderno">
			<li><a href="index.cfm?fuseaction=cSettings.list&siteSortBy=site">View Site List by Site Name</a></li>
		</cfif>
		<cfif attributes.siteSortBy neq "orderno">
			<li><a href="index.cfm?fuseaction=cSettings.list&siteSortBy=orderno">View Site List by Bind Order</a></li>
		</cfif>
		<cfif attributes.siteUpdateSelect neq "true">
			<li><a href="index.cfm?fuseaction=cSettings.list&siteUpdateSelect=true">Multi-Site Version Update</a></li>
		</cfif>
		<cfelse>
		<li><a href="index.cfm?fuseaction=cSettings.list">View Site List</a></li>
	</cfif>
</ul>
 
<!--- site updates messaging --->
<cfif StructKeyExists(rc, 'sitesUpdated') and IsSimpleValue(rc.sitesUpdated) and len(trim(rc.sitesUpdated))>
	<cfoutput>#rc.sitesUpdated#</cfoutput>
</cfif>

<cfif attributes.action neq 'updateCore'>
	<cfif attributes.action eq "deploy">
		<cfoutput>#application.pluginManager.announceEvent("onAfterSiteDeployRender",event)#</cfoutput>
	</cfif>
	<cfset errors=application.userManager.getCurrentUser().getValue("errors")>
	<cfif isStruct(errors) and not structIsEmpty(errors)>
		<cfoutput>
		<p class="error">#application.utility.displayErrors(errors)#</p>
		</cfoutput>
	</cfif>
	<cfset application.userManager.getCurrentUser().setValue("errors","")>
	<img class="loadProgress tabPreloader" src="images/progress_bar.gif">
	<div class="tabs initActiveTab" style="display:none">
		<ul>
			<li><a href="#tabCurrentsites" onclick="return false;"><span>Current Sites</span></a></li>
			<li><a href="#tabPlugins" onclick="return false;"><span>Plugins</span></a></li>
		</ul>
		<div id="tabCurrentsites"> <br/>
			<script type="text/javascript" language="javascript">
				jQuery(function ($) {
					$('#checkall').click(function () {
						$(':checkbox.checkall').attr('checked', this.checked);
					});
					$('#btnUpdateSites').click(function() {
						confirmDialog(
						'WARNING: DO NOT continue unless you have backed up all selected site files.',
						function(){
									$('#actionButtons').hide();
									$('#actionIndicator').show();
									document.form1.submit();
								}
						)

					});
				});
			</script>
			<form novalidate="novalidate" name="form1" id="form1" action="index.cfm?fuseaction=csettings.list" method="post">
				<table class="mura-table-grid stripe">
					<tr>
						<cfif attributes.siteUpdateSelect eq "true">
							<th>
								<input type="checkbox" name="checkall" id="checkall" />
								<input type="hidden" name="siteUpdateSelect" value="true">
							</th>
						</cfif>
						<cfif attributes.siteSortBy eq "orderno">
							<th>Bind Order</th>
						</cfif>
						<th class="varWidth">Site</th>
						<th>Domain</th>
						<th>Version</th>
						<cfif application.configBean.getMode() eq 'staging'
						and attributes.siteSortBy neq "orderno"
						and attributes.siteUpdateSelect neq "true">
							<th>Batch&nbsp;Deploy</th>
							<th>Last&nbsp;Deployment</th>
						</cfif>
						<!---<th>Site Version</th>--->
						<th class="administration">&nbsp;</th>
					</tr>
					<cfoutput query="request.rsSites">
					<tr>
						<cfif attributes.siteUpdateSelect eq "true">
							<td>
								<input type="checkbox" name="ckUpdate" class="checkall" value="#request.rsSites.siteid#" />
							</td>
						</cfif>
						<cfif attributes.siteSortBy eq "orderno">
							<td><select name="orderno" class="dropdown">
									<cfloop from="1" to="#request.rsSites.recordcount#" index="I">
									<option value="#I#" <cfif I eq request.rsSites.currentrow>selected</cfif>>#I#</option>
									</cfloop>
								</select>
								<input type="hidden" value="#request.rsSites.siteid#" name="orderid" />
							</td>
						</cfif>
						<td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cSettings.editSite&siteid=#request.rsSites.siteid#">#request.rsSites.site#</a></td>
						<td>
							<cfif len(request.rsSites.domain)>
								#HTMLEditFormat(request.rsSites.domain)#
								<cfelse>
								-
							</cfif>
						</td>
						<td> #application.autoUpdater.getCurrentCompleteVersion(request.rsSites.siteid)#</td>
						<cfif application.configBean.getMode() eq 'staging'
						and attributes.siteSortBy neq "orderno"
						and attributes.siteUpdateSelect neq "true">
							<td><select name="deploy" class="dropdown">
									<option value="1" <cfif request.rsSites.deploy eq 1>selected</cfif>>Yes</option>
									<option value="0" <cfif request.rsSites.deploy neq 1>selected</cfif>>No</option>
								</select></td>
							<td><cfif LSisDate(request.rsSites.lastDeployment)>
									#LSDateFormat(request.rsSites.lastDeployment,session.dateKeyFormat)#
									<cfelse>
									Never
								</cfif></td>
						</cfif>
						<!---<td>#application.autoUpdater.getCurrentCompleteVersion(request.rsSites.siteid)#</td>--->
						<td class="administration"><ul <cfif application.configBean.getMode() eq 'Staging'>class="three"<cfelse>class="two"</cfif>>
								<li class="edit"><a title="Edit" href="index.cfm?fuseaction=cSettings.editSite&siteid=#request.rsSites.siteid#">Edit</a></li>
								<cfif application.configBean.getMode() eq 'Staging'>
									<cfif application.configBean.getValue('deployMode') eq "bundle">
										<li class="deploy"><a href="?fuseaction=cSettings.deploybundle&siteid=#request.rsSites.siteid#" onclick="return confirmDialog('Deploy #JSStringFormat(request.rsSites.site)# to production?',this.href);" title="Deploy">Deploy</a></li>
									<cfelse>
										<li class="deploy"><a href="?fuseaction=cSettings.list&action=deploy&siteid=#request.rsSites.siteid#" onclick="return confirmDialog('Deploy #JSStringFormat(request.rsSites.site)# to production?',this.href);" title="Deploy">Deploy</a></li>
									</cfif>
								</cfif>
								<cfif request.rsSites.siteid neq 'default'>
									<li class="delete"><a title="Delete" href="index.cfm?fuseaction=cSettings.updateSite&action=delete&siteid=#request.rsSites.siteid#" onclick="return confirmDialog('#JSStringFormat("WARNING: A deleted site and all of it''s files cannot be recovered. Are you sure that you want to delete the site named '#Ucase(request.rsSites.site)#'?")#',this.href);">Delete</a></li>
									<cfelse>
									<li class="deleteOff">&nbsp;</li>
								</cfif>
								<!---<li class="export"><a title="Export" href="index.cfm?fuseaction=cArch.exportHtmlSite&siteid=#request.rsSites.siteid#" onclick="return confirm('Export the #jsStringFormat("'#request.rsSites.site#'")# Site?')">Export</a></li>--->
							</ul></td>
					</tr>
					</cfoutput>
				</table>
				<cfif attributes.siteSortBy eq "orderno">
					<input type="button" class="submit" onclick="document.form1.submit();" value="Update Bind Order" />
				</cfif>
				<cfif  attributes.siteUpdateSelect eq "true">
					<div class="clearfix" id="actionButtons">
					<input type="button" class="submit" id="btnUpdateSites" value="Update Selected Sites to Latest Version" />
					</div>
					<div id="actionIndicator" style="display: none;">
						<cfoutput><img class="loadProgress" src="#application.configBean.getContext()#/admin/images/progress_bar.gif"></cfoutput>
					</div>
				</cfif>
				<cfif application.configBean.getMode() eq 'staging'
						and attributes.siteSortBy neq "orderno"
						and attributes.siteUpdateSelect neq "true">
					<input type="button" class="submit" onclick="document.form1.submit();" value="Update Auto Deploy Settings" />	
				</cfif>
				<cfoutput>
					<input type="hidden" name="siteSortBy" value="#htmlEditFormat(attributes.siteSortBy)#" />
				</cfoutput>
			</form>
		</div>
		<div id="tabPlugins"> <br/>
			<form novalidate="novalidate" name="frmNewPlugin" action="index.cfm?fuseaction=cSettings.deployPlugin" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);">
				Upload New Plugin<br/>
				<input name="newPlugin" type="file" required="true" message="Please select a plugin file.">
				<input type="submit" value="Deploy"/>
			</form>
			<table class="mura-table-grid stripe">
				<tr>
					<th class="varWidth">Name</th>
					<th>Directory</th>
					<th>Category</th>
					<th>Version</th>
					<th>Provider</th>
					<!--- <th>Provider URL</th> --->
					<th>Plugin ID</th>
					<th class="administration">&nbsp;</th>
				</tr>
				<cfif request.rsPlugins.recordcount>
					<cfoutput query="request.rsPlugins">
					<tr>
						<td class="varWidth"><a class="alt" title="view" href="#application.configBean.getContext()#/plugins/#request.rsPlugins.directory#/">#htmlEditFormat(request.rsPlugins.name)#</a></td>
						<td>#htmlEditFormat(request.rsPlugins.directory)#</td>
						<td>#htmlEditFormat(request.rsPlugins.category)#</td>
						<td>#htmlEditFormat(request.rsPlugins.version)#</td>
						<td><a class="alt" href="#request.rsPlugins.providerurl#" target="_blank">#htmlEditFormat(request.rsPlugins.provider)#</a></td>
						<!--- <td><a href="#request.rsPlugins.providerurl#" target="_blank">View</a></td> --->
						<td>#request.rsPlugins.pluginID#</td>
						<td class="administration"><ul class="two">
								<li class="edit"><a title="Edit" href="index.cfm?fuseaction=cSettings.editPlugin&moduleID=#request.rsPlugins.moduleID#">Edit</a></li>
								<li class="delete"><a title="Delete" href="index.cfm?fuseaction=cSettings.deletePlugin&moduleID=#request.rsPlugins.moduleID#" onclick="return confirmDialog('Delete #jsStringFormat("'#Ucase(request.rsPlugins.name)#'")#?',this.href);">Delete</a></li>
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
	</div>
	<!---
<cfparam name="attributes.activeTab" default="0">
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfoutput><script type="text/javascript">
initTabs(Array("Current Sites","Plugins"),#attributes.activeTab#,0,0);
</script></cfoutput>--->
	<cfelse>
	<cftry>
		<cfset updated=application.autoUpdater.update()>
		<cfset files=updated.files>
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
			<h3>An Error has occured.</h3>
			<cfdump var="#cfcatch.message#">
			<br/>
			<br/>
			<cfdump var="#cfcatch.TagContext#">
		</cfcatch>
	</cftry>
</cfif>