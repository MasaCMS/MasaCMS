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
<cfparam name="rc.action" default="">
<cfparam name="rc.siteSortBy" default="site">
<cfparam name="rc.siteAutoDeploySelect" default="false">
<div class="mura-header">
	<h1>Global Settings</h1>

	<div class="nav-module-specific btn-toolbar">
		<cfif rc.action neq 'updateCore'>
			<cfif application.configBean.getAllowAutoUpdates()>
				<div class="btn-group">
					<cfoutput>
								<a class="btn" href="##" onclick="confirmDialog('WARNING: Do not update your core files unless you have backed up your current Mura install.<cfif application.configBean.getDbType() eq "mssql">\n\nIf your are using MSSQL you must uncheck Maintain Connections in your CF administrator datasource settings before proceeding. You may turn it back on after the update is complete.</cfif>',function(){actionModal('./?muraAction=cSettings.list&action=updateCore#rc.$.renderCSRFTokens(context='updatecore',format='url')#')});return false;"><i class="mi-cloud-download"></i> Update Core Files</a>
					</cfoutput>
				</div>
			</cfif>
			<div class="btn-group">
				<cfif rc.siteSortBy eq "orderno">
								<a class="btn" href="./?muraAction=cSettings.list&siteSortBy=site"><i class="mi-list-alt"></i> List Sites by Site Name</a>
				</cfif>
				<cfif rc.siteSortBy neq "orderno">
								<a class="btn" href="./?muraAction=cSettings.list&siteSortBy=orderno"><i class="mi-list-alt"></i> List Sites by Bind Order</a>
				</cfif>
				<cfelse>
							<a class="btn" href="./?muraAction=cSettings.list"><i class="mi-list-alt"></i> List Sites</a>
				</cfif>
			</div>
		</div>

</div> <!-- /.mura-header -->
<!--- site updates messaging --->
<cfif StructKeyExists(rc, 'sitesUpdated') and IsSimpleValue(rc.sitesUpdated) and len(trim(rc.sitesUpdated))>
	<cfoutput>#rc.sitesUpdated#</cfoutput>
</cfif>

<cfif rc.action neq 'updateCore'>
	<cfif rc.action eq "deploy">
		<cfoutput>#application.pluginManager.renderEvent("onAfterSiteDeployRender",event)#</cfoutput>
	</cfif>
	<cfset errors=application.userManager.getCurrentUser().getValue("errors")>
	<cfif isStruct(errors) and not structIsEmpty(errors)>
		<cfoutput>
		<div class="alert alert-error"><span>#application.utility.displayErrors(errors)#</span></div>
		</cfoutput>
	</cfif>
	<cfset application.userManager.getCurrentUser().setValue("errors","")>

	<div class="block block-constrain">
		<ul class="mura-tabs nav-tabs" data-toggle="tabs">
			<li class="active"><a href="#tabCurrentsites" onclick="return false;"><span>Current Sites</span></a></li>
			<li><a href="#tabPlugins" onclick="return false;"><span>Plugins</span></a></li>
		</ul>
	<div class="tab-content block-content">
		<div id="tabCurrentsites" class="tab-pane active">

					<!-- start tab -->
						<div class="block block-bordered">
							<!-- block header -->
							<div class="block-header">
								<h3 class="block-title">Current Sites</h3>
							</div> <!-- /.block header -->
							<div class="block-content">

			<form novalidate="novalidate" name="form1" id="form1" action="./?muraAction=csettings.list" method="post">
				<table class="mura-table-grid">
					<tr>
						<th class="actions"></th>
						<cfif rc.siteSortBy eq "orderno">
							<th>Bind Order</th>
						</cfif>
						<th class="var-width">Site</th>
						<th>Domain</th>
						<cfif application.configBean.getMode() eq 'staging'
						and rc.siteSortBy neq "orderno">
							<th>Batch&nbsp;Deploy</th>
							<th>Last&nbsp;Deployment</th>
						</cfif>
						<!---<th>Site Version</th>--->
					</tr>
					<cfoutput query="rc.rsSites">
					<tr>
						<td class="actions">
							<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
							<div class="actions-menu hide">
								<ul class="actions-list">
									<li class="edit"><a href="./?muraAction=cSettings.editSite&siteid=#rc.rsSites.siteid#"><i class="mi-pencil"></i>Edit</a></li>
									<cfif application.configBean.getMode() eq 'Staging'>
										<cfif application.configBean.getValue('deployMode') eq "bundle">
											<li class="deploy"><a href="?muraAction=cSettings.deploybundle&siteid=#rc.rsSites.siteid#" onclick="return confirmDialog('Deploy #esapiEncode('javascript',rc.rsSites.site)# to production?',this.href);"><i class="mi-download"></i>Deploy</a></li>
										<cfelse>
											<li class="deploy"><a href="?muraAction=cSettings.list&action=deploy&siteid=#rc.rsSites.siteid#" onclick="return confirmDialog('Deploy #esapiEncode('javascript',rc.rsSites.site)# to production?',this.href);"><i class="mi-download"></i>Deploy</a></li>
										</cfif>
									</cfif>
									<cfif rc.rsSites.siteid neq 'default'>
										<li class="delete"><a href="##" onclick="confirmDialog('#esapiEncode("javascript","WARNING: A deleted site and all of its files cannot be recovered. Are you sure that you want to delete the site named '#Ucase(rc.rsSites.site)#'?")#',function(){actionModal('./?muraAction=cSettings.updateSite&action=delete&siteid=#rc.rsSites.siteid##rc.$.renderCSRFTokens(context=rc.rssites.siteid,format='url')#')});return false;"><i class="mi-trash"></i>Delete</a></li>
	<!--- 									<cfelse>
										<li class="delete disabled"><i class="mi-trash"></i></li> --->
									</cfif>
									<!---<li class="export"><a title="Export" href="./?muraAction=cArch.exportHtmlSite&siteid=#rc.rsSites.siteid#" onclick="return confirm('Export the #esapiEncode("javascript","'#rc.rsSites.site#'")# Site?')">Export</a></li>--->
							</ul>
						</div>
						</td>
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
						<cfif application.configBean.getMode() eq 'staging'
						and rc.siteSortBy neq "orderno">
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
					</tr>
					</cfoutput>
				</table>

				<cfif rc.siteSortBy eq "orderno"
					or (application.configBean.getMode() eq 'staging'
					and rc.siteSortBy neq "orderno")>
					<div class="mura-actions">
						<div class="form-actions">
							<cfif rc.siteSortBy eq "orderno">
								<button type="button" class="btn mura-primary" onclick="document.form1.submit();"><i class="mi-check"></i> Update Bind Order</button>
							</cfif>
							<cfif application.configBean.getMode() eq 'staging'
									and rc.siteSortBy neq "orderno">
								<button type="button" class="btn" onclick="document.form1.submit();"><i class="mi-check"></i>Update Auto Deploy Settings</button>
							</cfif>
						</div>
					</div>
				</cfif>

				<cfoutput>
					<input type="hidden" name="siteSortBy" value="#esapiEncode('html_attr',rc.siteSortBy)#" />
					#rc.$.renderCSRFTokens(context='updatesites',format='form')#
				</cfoutput>
			</form>

				</div> <!-- /.block-content -->
			</div> <!-- /.block-bordered -->
		</div> <!-- /.tab-pane -->

		<div id="tabPlugins" class="tab-pane">

		<div class="block block-bordered">
			<!-- block header -->
		<div class="block-header">
			<h3 class="block-title">Plugins</h3>
			</div> <!-- /.block header -->
			<div class="block-content">

		<h2>Install Plugin</h2>
		<cfif application.configBean.getJavaEnabled()>
		<div class="mura-file-selector">
			<div class="mura-control-group">
				<div class="mura-control justify">
					<div class="mura-input-set" data-toggle="buttons-radio">
					  <button type="button" class="btn btn-default active" data-toggle="button" name="installType" value="Upload" id="apptypefile"><i class="mi-upload"></i> Via Upload</button>
					  <button type="button" class="btn btn-default" name="installType" value="URL" id="apptypeurl"><i class="mi-globe"></i> Via URL</button>
					</div>
				</div>
			</div>

			<div id="appzip" class="fileTypeOption">
				<form novalidate="novalidate" name="frmNewPlugin" action="./?muraAction=cSettings.deployPlugin" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);">
					<div class="mura-control-group">
						  <label>Plugin File</label>
							<input name="newPlugin" type="file" data-required="true" message="Please select a plugin file.">
					</div>
					<div class="mura-control-group">
						<div class="mura-control justify">
								<button type="submit" class="btn" /><i class="mi-bolt"></i> Deploy</button>
								<cfoutput>#rc.$.renderCSRFTokens(context='newplugin',format='form')#</cfoutput>
						</div>
					</div>
				</form>
			</div>
			<div id="appurl" class="fileTypeOption" style="display:none;">
				<form name="frmNewPluginFROMURL" action="./?muraAction=cSettings.deployPlugin" method="post" onsubmit="return validateForm(this);">
					<div class="mura-control-group">
							<label>Plugin URL</label>
							<input type="text" name="newPlugin"  type="url" data-required="true" placeholder="http://www.domain.com/plugin.zip" message="Please enter the url for your plugin file" value="">
					</div>
					<div class="mura-control-group">
						<div class="mura-control justify">
							<button type="submit" class="btn" /><i class="mi-bolt"></i> Deploy</button>
							<cfoutput>#rc.$.renderCSRFTokens(context='newplugin',format='form')#</cfoutput>
						</div>
					</div>
				</form>
				</div>
			</div>
		<script>
			$(function(){
				$("#apptypefile").click(
					function(){
							$(this).addClass("active").removeClass("focus").siblings().removeClass("active").removeClass("focus");
							$("#appurl").hide()
							$("#appzip").show()
					}
				);
				$("#apptypeurl").click(
					function(){
							$(this).addClass("active").removeClass("focus").siblings().removeClass("active").removeClass("focus");
							$("#appurl").show()
							$("#appzip").hide()
					}
				);
			})
		</script>

	   <cfelse>

    <div class="help-block-empty">
      Java is disabled. Plugin installation is unavailable.
    </div>

      </cfif>
		<cfif rc.rsPlugins.recordcount>
			<h2>Current Plugins</h2>
			<table class="mura-table-grid">
				<tr>
					<th class="actions"></th>
					<th class="var-width">Name</th>
					<th class="hidden-xs">Directory</th>
					<th>Category</th>
					<th>Version</th>
					<th>Provider</th>
					<!--- <th>Provider URL</th> --->
					<th>Plugin ID</th>
				</tr>

					<cfoutput query="rc.rsPlugins">
					<tr>
						<td class="actions">
							<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
							<div class="actions-menu hide">
								<ul class="actions-list">
									<li class="edit"><a href="./?muraAction=cSettings.editPlugin&moduleID=#rc.rsPlugins.moduleID#"><i class="mi-pencil"></i>Edit</a></li>
									<li class="delete"><a href="##" onclick="confirmDialog('Delete #esapiEncode("javascript","'#Ucase(rc.rsPlugins.name)#'")#?',function(){actionModal('./?muraAction=cSettings.deletePlugin&moduleID=#rc.rsPlugins.moduleID##rc.$.renderCSRFTokens(context=rc.rsplugins.moduleid,format='url')#')});return false;"><i class="mi-trash"></i>Delete</a></li>
								</ul>
							</div>
						</td>
						<td class="var-width"><a class="alt" title="view" href="#application.configBean.getContext()#/plugins/#rc.rsPlugins.directory#/">#esapiEncode('html',rc.rsPlugins.name)#</a></td>
						<td class="hidden-xs">#esapiEncode('html',rc.rsPlugins.directory)#</td>
						<td>#esapiEncode('html',rc.rsPlugins.category)#</td>
						<td>#esapiEncode('html',rc.rsPlugins.version)#</td>
						<td><a class="alt" href="#esapiEncode('url',rc.rsPlugins.providerurl)#" target="_blank">#esapiEncode('html',rc.rsPlugins.provider)#</a></td>
						<!--- <td><a href="#rc.rsPlugins.providerurl#" target="_blank">View</a></td> --->
						<td>#rc.rsPlugins.pluginID#</td>
					</tr>
					</cfoutput>

			</table>
			<cfelse>
				<div class="help-block-empty">
					There are currently no installed plugins.
				</div>
			</cfif>
			</div> <!-- /.block-content -->
		</div> <!-- /.block-bordered -->
	</div> <!-- /.tab-pane -->
		<div class="load-inline tab-preloader"></div>
		<script>$('.tab-preloader').spin(spinnerArgs2);</script>
		</div> <!-- /.block-content.tab-content -->
</div> <!-- /.block-constrain -->

<cfelse>
	<cftry>
		<cfif rc.$.validateCSRFTokens(context='updatecore')>
			<cfset updated=application.autoUpdater.update()>
			<cfset files=updated.files>
		<cfelse>
			<cfset files=[]>
		</cfif>

			<div class="block block-constrain">
				<div class="block block-bordered">
				  <div class="block-content">
						<div class="help-block-inline">Your core files have been updated to version
							<cfoutput>#application.configBean.getVersionFromFile()#</cfoutput>.
						</div>
						<div class="clearfix"></div>
				</div> <!-- /.block-content -->
			</div> <!-- /.block-bordered -->
		</div> <!-- /.block-constrain -->

		<cfcatch>
			<h2>An Error has occurred.</h2>
			<cfdump var="#cfcatch.message#">
			<br/>
			<br/>
			<cfdump var="#cfcatch.TagContext#">
		</cfcatch>
	</cftry>
</cfif>
