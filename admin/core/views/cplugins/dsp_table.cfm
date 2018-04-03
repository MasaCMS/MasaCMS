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
<cfoutput>
<cfset started=false>
<div id="tab#ucase(replace(local.category,' ','','all'))#" class="tab-pane<cfif local.category is 'Application'> active</cfif>">

	<div class="block block-bordered">
		<!-- block header -->
		<div class="block-header">
			<h3 class="block-title">#replace(local.category,' ','','all')# Plugins</h3>
		</div> <!-- /.block header -->
		<div class="block-content">


		<cfloop query="rscategorylist">
		<cfif not started>
			<table class="mura-table-grid">
			<tr>
			<th class="actions"></th>
			<th class="var-width">#application.rbFactory.getKeyValue(session.rb,"plugin.name")#</th>
			<th>#application.rbFactory.getKeyValue(session.rb,"plugin.directory")#</th>
			<th>#application.rbFactory.getKeyValue(session.rb,"plugin.category")#</th>
			<th>#application.rbFactory.getKeyValue(session.rb,"plugin.version")#</th>
			<th class="hidden-xs">#application.rbFactory.getKeyValue(session.rb,"plugin.provider")#</th>
			<!--- <th>#application.rbFactory.getKeyValue(session.rb,"plugin.providerurl")#</th> --->
			<th>Plugin ID</th>
			</tr>
		</cfif>
			<tr>
			<td class="actions">
				<a class="show-actions" href="javascript:;" <!---ontouchstart="this.onclick();"---> onclick="showTableControls(this);"><i class="mi-ellipsis-v"></i></a>
				<div class="actions-menu hide">
					<ul class="actions-list">
					<cfif listFind(session.mura.memberships,'S2')>
								<li class="edit"><a href="./?muraAction=cSettings.editPlugin&moduleID=#rscategorylist.moduleID#"><i class="mi-pencil"></i>#application.rbFactory.getKeyValue(session.rb,'plugin.edit')#</a></li>
<!--- 					<cfelse>
						<li class="edit disabled"><a>#application.rbFactory.getKeyValue(session.rb,'plugin.edit')#</a></li> --->
					</cfif>
					<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
								<li class="permissions"><a href="./?muraAction=cPerm.module&contentid=#rscategorylist.moduleID#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rscategorylist.moduleID#"><i class="mi-group"></i>#application.rbFactory.getKeyValue(session.rb,'plugin.permissions')#</a></li>
<!--- 					<cfelse>
						<li class="permissions disabled"><a>#application.rbFactory.getKeyValue(session.rb,'plugin.permissions')#</a></li> --->
					</cfif>
					</ul>
				</div>
			</td>
			<td class="var-width"><a class="alt" href="#application.configBean.getContext()#/plugins/#rscategorylist.directory#/">#esapiEncode('html',rscategorylist.name)#</a></td>
			<td>#esapiEncode('html',rscategorylist.directory)#</td>
			<td>#esapiEncode('html',rscategorylist.category)#</td>
			<td>#esapiEncode('html',rscategorylist.version)#</td>
			<td class="hidden-xs"><a class="alt" href="#rscategorylist.providerurl#" target="_blank">#esapiEncode('html',rscategorylist.provider)#</a></td>
			<td>#rscategorylist.pluginID#</td>
			</tr>
			<cfset started=true>
		</cfloop>
		<cfif started>
			</table>
		</cfif>
		<cfif not started>
			<div class="help-block-empty">#application.rbFactory.getKeyValue(session.rb,"plugin.noresults")#</div>
		</cfif>

		</div> <!-- /.block-content -->
	</div> <!-- /.block-bordered -->
</div> <!-- /.tab-pane -->
</cfoutput>
