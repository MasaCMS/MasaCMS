<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'user.adminusersgroups')#</h2>

		  <form novalidate="novalidate" action="index.cfm?fuseaction=cPrivateUsers.search&siteid=#URLEncodedFormat(attributes.siteid)#" method="post" name="form1" id="siteSearch">
		 <h3>#application.rbFactory.getKeyValue(session.rb,'user.searchforadminuser')#</h3>
 		 <input id="search" name="search" type="text" class="text"> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1);"><span>Search</span></a><!--- <a class="submit" href="javascript:;" onclick="window.location='index.cfm?fuseaction=cPrivateUsers.advancedSearchForm&siteid=#URLEncodedFormat(attributes.siteid)#'"><span>Advanced</span></a> --->
		  </form>
		  <h3>#application.rbFactory.getKeyValue(session.rb,'user.adminusergroups')#</h3>


        <table class="stripe">
                  <tr> 
                    <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'user.name')# (#application.rbFactory.getKeyValue(session.rb,'user.members')#)</th>
                    <th>#application.rbFactory.getKeyValue(session.rb,'user.email')#</th>
                    <th>#application.rbFactory.getKeyValue(session.rb,'user.update')#</th> 
                    <th>#application.rbFactory.getKeyValue(session.rb,'user.AuthorEditor')#</th>
                    <th>&nbsp;</th>
                  </tr></cfoutput>
                <cfoutput query="request.rsgroups"> 
                  <tr> 
                    <td class="varWidth"> 
                      <a title="Edit" href="index.cfm?fuseaction=cPrivateUsers.editgroup&userid=#request.rsgroups.userID#&siteid=#URLEncodedFormat(attributes.siteid)#">#HTMLEditFormat(request.rsgroups.groupname)#</a>  (<cfif isNumeric(request.rsgroups.counter)>#request.rsgroups.counter#<cfelse>0</cfif>) 
                 </td>
                    <td> 
                      <cfif request.rsgroups.email gt "" and not request.rsgroups.perm>
                        <a href="mailto:#request.rsgroups.email#">#HTMLEditFormat(request.rsgroups.email)#</a>
                        <cfelse>&nbsp;</cfif> 
                  </td>
                    <td><cfif not request.rsgroups.perm>
                  #LSDateFormat(request.rsgroups.lastupdate,session.dateKeyFormat)# #LSTimeFormat(request.rsgroups.lastupdate,"short")# <cfelse>&nbsp;</cfif></td>
                  <td><cfif not request.rsgroups.perm>#HTMLEditFormat(request.rsgroups.LastUpdateBy)#<cfelse>&nbsp;</cfif></td>
                    <td class="administration"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPrivateUsers.editgroup&userid=#request.rsgroups.UserID#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li><cfif not request.rsgroups.perm><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" href="index.cfm?fuseaction=cPrivateUsers.update&action=delete&userid=#request.rsgroups.UserID#&type=1&siteid=#URLEncodedFormat(attributes.siteid)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deletegroupconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul>
                  </td>
                </tr>
                </cfoutput> 
          </table>