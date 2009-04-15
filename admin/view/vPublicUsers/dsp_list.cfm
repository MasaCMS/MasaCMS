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

<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'user.sitemembersgroups')#</h2>
	<ul id="navTask"><li><a href="index.cfm?fuseaction=cPublicUsers.edituser&siteid=#attributes.siteid#&userid=">#application.rbFactory.getKeyValue(session.rb,'user.addmember')#</a></li>
<li><a href="index.cfm?fuseaction=cPublicUsers.editgroup&siteid=#attributes.siteid#&userid=">#application.rbFactory.getKeyValue(session.rb,'user.addgroup')#</a></li>
</ul>
<form action="index.cfm?fuseaction=cPublicUsers.search&siteid=#attributes.siteid#" method="post" name="form1" id="siteSearch">
	<h3>#application.rbFactory.getKeyValue(session.rb,'user.searchformembers')#</h3>
<input id="search" name="search" type="text" class="text"> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1);"><span>#application.rbFactory.getKeyValue(session.rb,'user.search')#</span></a><a class="submit" href="javascript:;" onclick="window.location='index.cfm?fuseaction=cPublicUsers.advancedSearch&siteid=#attributes.siteid#&newSearch=true'"><span>#application.rbFactory.getKeyValue(session.rb,'user.advanced')#</span></a></form>

<h3>#application.rbFactory.getKeyValue(session.rb,'user.usergroups')#</h3>


        <table class="stripe">
                  <tr> 
                    <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'user.name')# (<em>#application.rbFactory.getKeyValue(session.rb,'user.members')#</em>)</th>
                    <th>#application.rbFactory.getKeyValue(session.rb,'user.email')#</th>
                    <th >#application.rbFactory.getKeyValue(session.rb,'user.update')#</th> 
                    <th>#application.rbFactory.getKeyValue(session.rb,'user.authoreditor')#</th>
                    <th class="administration">&nbsp;</th>
                  </tr></cfoutput>
				  <cfif request.rsgroups.recordcount>
                <cfoutput query="request.rsgroups"> 
                  <tr> 
                    <td class="varWidth"> 
                      <a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPublicUsers.editgroup&userid=#UserID#&siteid=#attributes.siteid#">#HTMLEditFormat(groupname)#</a> (#counter#)</td>
                    <td> 
                      <cfif email gt "" and not request.rsgroups.perm>
                        <a href="mailto:#email#">#HTMLEditFormat(email)#</a>
                        <cfelse>&nbsp;</cfif> 
                  </td>
                    <td><cfif not request.rsgroups.perm>
                 #LSDateFormat(request.rsgroups.lastupdate,session.dateKeyFormat)# #LSTimeFormat(request.rsgroups.lastupdate,"short")#<cfelse>&nbsp;</cfif></td>
                  <td><cfif not request.rsgroups.perm>#HTMLEditFormat(LastUpdateBy)#<cfelse>&nbsp;</cfif></td>
                    <td class="administration"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPublicUsers.editgroup&userid=#UserID#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li><cfif not request.rsgroups.perm><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" href="index.cfm?fuseaction=cPublicUsers.update&action=delete&userid=#UserID#&siteid=#attributes.siteid#&type=1" onclick="return confirm('Delete the #jsStringFormat("'#request.rsGroups.groupname#'")# User Group?')">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul>
                  </td>
                </tr>
                </cfoutput> 
				<cfelse>
				      <tr> 
                    <td colspan="5" nowrap class="noResults"> 
                     <cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.nosearchresults')#</cfoutput> </td>
                    </tr>
				
				</cfif>
          </table>
