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

<cfsilent><cfparam name="attributes.siteID" default="">
<cfparam name="attributes.parentID" default="">
<cfparam name="attributes.nestLevel" default="0">
<cfset rslist=application.categoryManager.getCategories(attributes.siteID,attributes.ParentID) />
<cfif attributes.nestlevel eq 0>
<cfset variables.nestLevel=""/>
<cfelse>
<cfset variables.nestLevel=attributes.nestlevel/>
</cfif>
</cfsilent>
<cfif rslist.recordcount>
<cfoutput>
<cfloop query="rslist">
<tr>
<td class="add">
 <a href="javascript:;" onmouseover="categoryManager.showMenu('newContentMenu',this,'#rslist.categoryid#','#attributes.siteid#');"><i class="icon-plus-sign"></i></a></td>
<td class="var-width"><ul <cfif rslist.hasKids>class="nest#variables.nestlevel#on"<cfelse>class="nest#variables.nestlevel#off"</cfif>><li class="Category#iif(rslist.restrictGroups neq '',de('Locked'),de(''))#"><a title="Edit" href="index.cfm?muraAction=cCategory.edit&categoryID=#rslist.categoryID#&parentID=#rslist.parentID#&siteid=#URLEncodedFormat(attributes.siteid)#">#rslist.name#</a></li></ul></td>
<td><cfif isOpen><i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isOpen)#')#"></i>
<cfelse><i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isOpen)#')#"></i></cfif>
<span>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isOpen)#')#</span></td>

<td>
	<cfif isInterestGroup>
		<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isInterestGroup)#')#"></i>
	<cfelse>
	<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isInterestGroup)#')#"></i>
	</cfif>
	<span>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isInterestGroup)#')#</span>
</td>

<td>
	<cfif isActive>
		<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isActive)#')#"></i>
	<cfelse>
	<i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isActive)#')#"></i>
	</cfif>
	<span>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(rslist.isActive)#')#</span>
</td>
<td class="actions"><ul><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.edit')#" href="index.cfm?muraAction=cCategory.edit&categoryID=#rslist.categoryID#&parentID=#rslist.parentID#&siteid=#URLEncodedFormat(attributes.siteid)#"><i class="icon-pencil"></i></a></li><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.delete')#" href="index.cfm?muraAction=cCategory.update&action=delete&categoryID=#rslist.categoryID#&siteid=#URLEncodedFormat(attributes.siteid)#" onClick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'categorymanager.deleteconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li></ul></td>
</tr>
<cf_dsp_nest siteID="#attributes.siteID#" parentID="#rslist.categoryID#" nestLevel="#evaluate(attributes.nestLevel +1)#" >
</cfloop>
</cfoutput>
<cfelseif attributes.nestlevel eq 0>
<tr>
<td class="noResults" colspan="6">
<cfoutput>#application.rbFactory.getKeyValue(session.rb,"categorymanager.nocategories")#</cfoutput></td>
</tr>
</cfif>