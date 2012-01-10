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

<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'collections')#</h2>
<h3>#application.rbFactory.getKeyValue(session.rb,'collections.localcontentindexes')#</h3>
<ul id="navTask"><li><a  title="#application.rbFactory.getKeyValue(session.rb,'collections.addocalindex')#" href="index.cfm?fuseaction=cFeed.edit&feedID=&siteid=#URLEncodedFormat(attributes.siteid)#&type=Local">#application.rbFactory.getKeyValue(session.rb,'collections.addlocalindex')#</a></li></ul>
<table class="mura-table-grid stripe"> 
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'collections.index')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'collections.language')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'collections.featuresonly')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'collections.restricted')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'collections.active')#</th>
<th>&nbsp;</th>
</tr>
<cfif request.rsLocal.recordcount>
<cfloop query="request.rsLocal">
<tr>
<td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cFeed.edit&feedID=#request.rsLocal.feedID#&siteid=#URLEncodedFormat(attributes.siteid)#&type=Local">#request.rsLocal.name#</a></td>
<td>#request.rsLocal.lang#</td>
<td>#request.rsLocal.maxItems#</td>
<td>#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(request.rsLocal.isFeaturesOnly)#')#</td>
<td>#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(request.rsLocal.restricted)#')#</td>
<td>#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(request.rsLocal.isActive)#')#</td>
<td class="administration"><ul class="rss"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.edit')#" href="index.cfm?fuseaction=cFeed.edit&feedID=#request.rsLocal.feedID#&siteid=#URLEncodedFormat(attributes.siteid)#&type=Local">#application.rbFactory.getKeyValue(session.rb,'collections.edit')#</a></li><li class="rss"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.viewrss')#" href="http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/tasks/feed/?feedID=#request.rsLocal.feedID#" target="_blank">#application.rbFactory.getKeyValue(session.rb,'collections.view')#</a></li><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.delete')#" href="index.cfm?fuseaction=cFeed.update&action=delete&feedID=#request.rsLocal.feedID#&siteid=#URLEncodedFormat(attributes.siteid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.deletelocalconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'collections.delete')#</a></li></ul></td>
</tr></cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="7">#application.rbFactory.getKeyValue(session.rb,'collections.nolocalindexes')#</td>
</tr>
</cfif>
</table>

<h3 class="divide">#application.rbFactory.getKeyValue(session.rb,'collections.remotecontentfeeds')#</h3>
<ul id="navTask"><li><a  title="#application.rbFactory.getKeyValue(session.rb,'collections.addremotefeed')#" href="index.cfm?fuseaction=cFeed.edit&feedID=&siteid=#URLEncodedFormat(attributes.siteid)#&type=Remote">#application.rbFactory.getKeyValue(session.rb,'collections.addremotefeed')#</a></li></ul>
<table class="mura-table-grid stripe"> 
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'collections.feed')#</th>
<th class="url">#application.rbFactory.getKeyValue(session.rb,'collections.url')#</th>
<th>#application.rbFactory.getKeyValue(session.rb,'collections.active')#</th>
<th>&nbsp;</th>
</tr>
<cfif request.rsRemote.recordcount>
<cfloop query="request.rsRemote">
<tr>
<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.edit')#" href="index.cfm?fuseaction=cFeed.edit&feedID=#request.rsRemote.feedID#&siteid=#URLEncodedFormat(attributes.siteid)#&type=Remote">#request.rsRemote.name#</a></td>
<td class="url">#left(request.rsRemote.channelLink,70)#</td>
<td>#yesnoFormat(request.rsRemote.isactive)#</td>
<td class="administration"><ul class="four"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.edit')#" href="index.cfm?fuseaction=cFeed.edit&feedID=#request.rsRemote.feedID#&siteid=#URLEncodedFormat(attributes.siteid)#&type=Remote">#application.rbFactory.getKeyValue(session.rb,'collections.edit')#</a></li><li class="rss"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.viewfeed')#" href="#request.rsRemote.channelLink#" target="_blank">#application.rbFactory.getKeyValue(session.rb,'collections.view')#</a></li>

<li class="import"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.import')#" href="index.cfm?fuseaction=cFeed.import1&feedID=#request.rsRemote.feedID#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'collections.import')#</a></li>

<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.delete')#" href="index.cfm?fuseaction=cFeed.update&action=delete&feedID=#request.rsRemote.feedID#&siteid=#URLEncodedFormat(attributes.siteid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'collections.deleteremoteconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'collections.delete')#</a></li></ul></td>
</tr></cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="6">#application.rbFactory.getKeyValue(session.rb,'collections.noremotefeeds')#</td>
</tr>
</cfif>
</table>
</cfoutput>