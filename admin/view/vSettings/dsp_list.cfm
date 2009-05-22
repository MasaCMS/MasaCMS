<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<h2>Site Settings</h2>

<div id="page_tabView">
<div class="page_aTab">
<br/>
<form name="form1" action="index.cfm?fuseaction=csettings.list" method="post">
<table class="stripe">
<tr><th class="varWidth">Site</th>
<th>Order</th>
<cfif application.configBean.getMode() eq 'staging'><th>Batch&nbsp;Deploy</th><th>Last&nbsp;Deployment</th></cfif>
<th class="administration">&nbsp;</th></tr>
<cfoutput query="request.rsSites">
<tr><td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cSettings.editSite&siteid=#request.rsSites.siteid#">#request.rsSites.site#</a></td>
<td><select name="orderno" class="dropdown"><cfloop from="1" to="#request.rsSites.recordcount#" index="I"><option value="#I#" <cfif I eq request.rsSites.currentrow>selected</cfif>>#I#</option></cfloop></select><input type="hidden" value="#request.rsSites.siteid#" name="orderid" /></td>
<cfif application.configBean.getMode() eq 'staging'>
<td><select name="deploy" class="dropdown"><option value="1" <cfif request.rsSites.deploy eq 1>selected</cfif>>Yes</option><option value="0" <cfif request.rsSites.deploy neq 1>selected</cfif>>No</option></select></td>
<td><cfif LSisDate(request.rsSites.lastDeployment)>#LSDateFormat(request.rsSites.lastDeployment,session.dateKeyFormat)#<cfelse>Never</cfif></td>
</cfif>
<td class="administration"><ul <cfif application.configBean.getMode() eq 'Staging'>class="three"<cfelse>class="two"</cfif>><li class="edit"><a title="Edit" href="index.cfm?fuseaction=cSettings.editSite&siteid=#request.rsSites.siteid#">Edit</a></li><cfif application.configBean.getMode() eq 'Staging'><li class="deploy"><a href="?fuseaction=cSettings.list&action=deploy&siteid=#request.rsSites.siteid#" onclick="return confirm('Deploy #JSStringFormat(request.rsSites.site)# to production?');" title="Deploy">Deploy</a></li></cfif>
<cfif request.rsSites.siteid neq 'default'>
<li class="delete"><a title="Delete" href="index.cfm?fuseaction=cSettings.updateSite&action=delete&siteid=#request.rsSites.siteid#" onclick="if(confirm('Delete the #jsStringFormat("'#request.rsSites.site#'")# Site?')){return confirm('WARNING: A deleted site cannot be recovered. Are you sure that you want to continue?');} else {return false;}">Delete</a></li>
<cfelse>
<li class="deleteOff">&nbsp;</li>
</cfif><!---<li class="export"><a title="Export" href="index.cfm?fuseaction=cArch.exportHtmlSite&siteid=#request.rsSites.siteid#" onclick="return confirm('Export the #jsStringFormat("'#request.rsSites.site#'")# Site?')">Export</a></li>---></ul></td></tr>
</cfoutput>
</table>
<a class="submit" href="javascript:document.form1.submit();"><span>Save</span></a>
</form>
</div>

<div class="page_aTab">
<br/>
<form name="frmNewPlugin" action="index.cfm?fuseaction=cSettings.deployPlugin" enctype="multipart/form-data" method="post" onsubmit="return validateForm(this);">
Upload New Plugin<br/>
<input name="newPlugin" type="file" required="true" message="Please select a plugin file.">
<input type="submit" value="Deploy"/>
</form>

<table class="stripe">
<tr>
<th class="varWidth">Name</th>
<th>Package</th>
<th>Category</th>
<th>Version</th>
<th>Provider</th>
<th>Provider URL</th>
<th>Plugin ID</th>
<th class="administration">&nbsp;</th></tr>
<cfif request.rsPlugins.recordcount>
<cfoutput query="request.rsPlugins">
<tr>
<td class="varWidth"><a title="view" href="#application.configBean.getContext()#/plugins/#request.rsPlugins.directory#/">#htmlEditFormat(request.rsPlugins.name)#</a></td>
<td>#htmlEditFormat(request.rsPlugins.directory)#</td>
<td>#htmlEditFormat(request.rsPlugins.category)#</td>
<td>#htmlEditFormat(request.rsPlugins.version)#</td>
<td>#htmlEditFormat(request.rsPlugins.provider)#</td>
<td><a href="#request.rsPlugins.providerurl#" target="_blank">#htmlEditFormat(request.rsPlugins.providerurl)#</a></td>
<td>#request.rsPlugins.pluginID#</td>
<td class="administration"><ul class="two"><li class="edit"><a title="Edit" href="index.cfm?fuseaction=cSettings.editPlugin&moduleID=#request.rsPlugins.moduleID#">Edit</a></li>
<li class="delete"><a title="Delete" href="index.cfm?fuseaction=cSettings.deletePlugin&moduleID=#request.rsPlugins.moduleID#" onclick="return confirm('Delete Plugin?');">Delete</a></li>
</ul></td></tr>
</cfoutput>
<cfelse>
<tr>
<td class="noResults" colspan="8">There are currently no installed plugins.</td>
</tr>
</cfif>
</table>
</div>
<cfparam name="attributes.activeTab" default="0">
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfoutput><script type="text/javascript">
initTabs(Array("Current Sites","Plug-Ins"),#attributes.activeTab#,0,0);
</script></cfoutput>