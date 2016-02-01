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

<cfset endpoint=rc.$.siteConfig().getApi('feed','v1').getEndpoint()>

<cfoutput><h1>#application.rbFactory.getKeyValue(session.rb,'collections')#</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<section>
	<h2>#application.rbFactory.getKeyValue(session.rb,'collections.localcontentindexes')#</h2>
	
	<table class="mura-table-grid"> 
	<tr>
	<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'collections.index')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'collections.language')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'collections.featuresonly')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'collections.restricted')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'collections.active')#</th>
	<th>&nbsp;</th>
	</tr>
	<cfif rc.rsLocal.recordcount>
	<cfloop query="rc.rsLocal">
	<tr>
	<td class="var-width"><a title="Edit" href="./?muraAction=cFeed.edit&feedID=#rc.rsLocal.feedID#&siteid=#esapiEncode('url',rc.siteid)#&type=Local">#rc.rsLocal.name#</a></td>
	<td>#rc.rsLocal.lang#</td>
	<td>#rc.rsLocal.maxItems#</td>
	<td>
		<cfif rc.rsLocal.isFeaturesOnly>
			<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.isFeaturesOnly)#')#"></i>
		<cfelse>
			<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.isFeaturesOnly)#')#"></i>
		</cfif>
		<span>#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.isFeaturesOnly)#')#</span>
	</td>
	<td>
		<cfif rc.rsLocal.restricted>
			<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.restricted)#')#"></i>
		<cfelse>
			<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.restricted)#')#"></i>
		</cfif>
		<span>#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.restricted)#')#</span>
	</td>
	<td>
	<cfif rc.rsLocal.isActive>
			<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.isActive)#')#"></i>
		<cfelse>
			<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.isActive)#')#"></i>
		</cfif>
		<span>#application.rbFactory.getKeyValue(session.rb,'collections.#yesnoFormat(rc.rsLocal.isActive)#')#</span>
	</td>
	<td class="actions"><ul><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.edit')#" href="./?muraAction=cFeed.edit&feedID=#rc.rsLocal.feedID#&siteid=#esapiEncode('url',rc.siteid)#&type=Local"><i class="icon-pencil"></i></a></li><li class="rss"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.viewrss')#" href="#endpoint#/?feedID=#rc.rslocal.feedid#" target="_blank"><i class="icon-rss"></i></a></li><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.delete')#" href="./?muraAction=cFeed.update&action=delete&feedID=#rc.rsLocal.feedID#&siteid=#esapiEncode('url',rc.siteid)##rc.$.renderCSRFTokens(context=rc.rslocal.feedid,format='url')#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'collections.deletelocalconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li></ul></td>
	</tr></cfloop>
	<cfelse>
	<tr>
	<td class="noResults" colspan="7">#application.rbFactory.getKeyValue(session.rb,'collections.nolocalindexes')#</td>
	</tr>
	</cfif>
	</table>
</section>

<section>
	<h2>#application.rbFactory.getKeyValue(session.rb,'collections.remotecontentfeeds')#</h2>
	
	<table class="mura-table-grid"> 
	<tr>
	<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'collections.feed')#</th>
	<th class="url">#application.rbFactory.getKeyValue(session.rb,'collections.url')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'collections.active')#</th>
	<th>&nbsp;</th>
	</tr>
	<cfif rc.rsRemote.recordcount>
	<cfloop query="rc.rsRemote">
	<tr>
	<td class="var-width"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.edit')#" href="./?muraAction=cFeed.edit&feedID=#rc.rsRemote.feedID#&siteid=#esapiEncode('url',rc.siteid)#&type=Remote">#rc.rsRemote.name#</a></td>
	<td class="url">#left(rc.rsRemote.channelLink,70)#</td>
	<td>#yesnoFormat(rc.rsRemote.isactive)#</td>
	<td class="actions"><ul><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.edit')#" href="./?muraAction=cFeed.edit&feedID=#rc.rsRemote.feedID#&siteid=#esapiEncode('url',rc.siteid)#&type=Remote"><i class="icon-pencil"></i></a></li><li class="rss"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.viewfeed')#" href="#rc.rsRemote.channelLink#" target="_blank"><i class="icon-rss"></i></a></li>
	
	<li class="import"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.import')#" href="./?muraAction=cFeed.import1&feedID=#rc.rsRemote.feedID#&siteid=#esapiEncode('url',rc.siteid)#"><i class="icon-download-alt"></i></a></li>
	
	<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'collections.delete')#" href="./?muraAction=cFeed.update&action=delete&feedID=#rc.rsRemote.feedID#&siteid=#esapiEncode('url',rc.siteid)##rc.$.renderCSRFTokens(context=rc.rsremote.feedid,format='url')#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'collections.deleteremoteconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li></ul></td>
	</tr></cfloop>
	<cfelse>
	<tr>
	<td class="noResults" colspan="6">#application.rbFactory.getKeyValue(session.rb,'collections.noremotefeeds')#</td>
	</tr>
	</cfif>
	</table>
</section>
</cfoutput>