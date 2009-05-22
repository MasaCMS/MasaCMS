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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"plugin.siteplugins")#</h2>

<table class="stripe">
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"plugin.name")#</th>
<th>Package</th>
<th>#application.rbFactory.getKeyValue(session.rb,"plugin.category")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"plugin.version")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"plugin.provider")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"plugin.providerurl")#</th>
<th>Plugin ID</th>
<th class="administration">&nbsp;</th>
</tr>
<cfset started=false>
<cfloop query="request.rslist">
<cfif application.permUtility.getModulePerm(request.rslist.moduleID,session.siteid)>
<cfset started=true>
<tr>
<td class="varWidth"><a href="#application.configBean.getContext()#/plugins/#request.rslist.directory#/">#htmlEditFormat(request.rslist.name)#</a></td>
<td>#htmlEditFormat(request.rslist.directory)#</td>
<td>#htmlEditFormat(request.rslist.category)#</td>
<td>#htmlEditFormat(request.rslist.version)#</td>
<td>#htmlEditFormat(request.rslist.provider)#</td>
<td><a href="#request.rslist.providerurl#" target="_blank">#htmlEditFormat(request.rslist.providerurl)#</a></td>
<td>#request.rslist.pluginID#</td>
<td class="administration">
<ul class="three"><li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'plugin.view')#" href="#application.configBean.getContext()#/plugins/#request.rslist.pluginID#/">#application.rbFactory.getKeyValue(session.rb,'plugin.view')#</a></li>
<cfif isUserInRole('S2')>
<li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'plugin.edit')#" href="index.cfm?fuseaction=cSettings.editPlugin&moduleID=#request.rslist.moduleID#">#application.rbFactory.getKeyValue(session.rb,'plugin.edit')#</a></li>
<cfelse>
<li class="editOff"><a>#application.rbFactory.getKeyValue(session.rb,'plugin.edit')#</a></li>
</cfif>
<cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')>
<li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,'plugin.permissions')#" href="index.cfm?fuseaction=cPerm.module&contentid=#request.rslist.moduleID#&siteid=#attributes.siteID#&moduleid=#request.rslist.moduleID#">#application.rbFactory.getKeyValue(session.rb,'plugin.permissions')#</a></li>
<cfelse>
<li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,'plugin.permissions')#</a></li>
</cfif>
</ul></td>
</tr>
</cfif>
</cfloop>
<cfif not started>
<tr>
<td colspan="8" class="noResults">#application.rbFactory.getKeyValue(session.rb,"plugin.noresults")#</td>
</tr>
</cfif>
</table>
</cfoutput>