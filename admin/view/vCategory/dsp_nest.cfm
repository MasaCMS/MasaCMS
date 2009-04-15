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
 <a href="javascript:;" onmouseover="showMenu('newContentMenu',this,'#rslist.categoryid#','#attributes.siteid#');">&nbsp;</a></td>
<td class="varWidth"><ul <cfif rslist.hasKids>class="nest#variables.nestlevel#on"<cfelse>class="nest#variables.nestlevel#off"</cfif>><li class="Category#iif(rslist.restrictGroups neq '',de('Locked'),de(''))#"><a title="Edit" href="index.cfm?fuseaction=cCategory.edit&categoryID=#rslist.categoryID#&parentID=#rslist.parentID#&siteid=#attributes.siteid#">#name#</a></li></ul></td>
<td>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(isOpen)#')#</td>
<td>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(isInterestGroup)#')#</td>
<td>#application.rbFactory.getKeyValue(session.rb,'categorymanager.#yesnoformat(isActive)#')#</td>
<td class="administration"><ul class="two"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.edit')#" href="index.cfm?fuseaction=cCategory.edit&categoryID=#rslist.categoryID#&parentID=#rslist.parentID#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'categorymanager.edit')#</a></li><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'categorymanager.delete')#" href="index.cfm?fuseaction=cCategory.update&action=delete&categoryID=#rslist.categoryID#&siteid=#attributes.siteid#" onClick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'categorymanager.deleteconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'categorymanager.delete')#</a></li></ul></td>
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