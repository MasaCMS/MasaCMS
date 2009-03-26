<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"plugin.siteplugins")#</h2>

<table class="stripe">
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"plugin.name")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"plugin.category")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"plugin.version")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"plugin.provider")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"plugin.providerurl")#</th>
<th class="administration">&nbsp;</th>
</tr>
<cfset started=false>
<cfloop query="request.rslist">
<cfif application.permUtility.getModulePerm(request.rslist.moduleID,session.siteid)>
<cfset started=true>
<tr>
<td class="varWidth"><a href="#application.configBean.getContext()#/plugins/#request.rslist.pluginID#/">#htmlEditFormat(request.rslist.name)#</a></td>
<td>#htmlEditFormat(request.rslist.category)#</td>
<td>#htmlEditFormat(request.rslist.version)#</td>
<td>#htmlEditFormat(request.rslist.provider)#</td>
<td><a href="#request.rslist.providerurl#" target="_blank">#htmlEditFormat(request.rslist.providerurl)#</a></td>
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
<td colspan="6" class="noResults">#application.rbFactory.getKeyValue(session.rb,"plugin.noresults")#</td>
</tr>
</cfif>
</table>
</cfoutput>