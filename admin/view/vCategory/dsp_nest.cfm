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