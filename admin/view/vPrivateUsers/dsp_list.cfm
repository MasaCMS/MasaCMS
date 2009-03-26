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

<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'user.adminusersgroups')#</h2>

		  <form action="index.cfm?fuseaction=cPrivateUsers.search&siteid=#attributes.siteid#" method="post" name="form1" id="siteSearch">
		 <h3>#application.rbFactory.getKeyValue(session.rb,'user.searchforadminuser')#</h3>
 		 <input id="search" name="search" type="text" class="text"> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1);"><span>Search</span></a><!--- <a class="submit" href="javascript:;" onclick="window.location='index.cfm?fuseaction=cPrivateUsers.advancedSearchForm&siteid=#attributes.siteid#'"><span>Advanced</span></a> --->
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
                      <a title="Edit" href="index.cfm?fuseaction=cPrivateUsers.editgroup&userid=#UserID#&siteid=#attributes.siteid#">#HTMLEditFormat(groupname)#</a>  (#counter#) 
                 </td>
                    <td> 
                      <cfif email gt "" and not request.rsgroups.perm>
                        <a href="mailto:#email#">#HTMLEditFormat(email)#</a>
                        <cfelse>&nbsp;</cfif> 
                  </td>
                    <td><cfif not request.rsgroups.perm>
                  #LSDateFormat(request.rsgroups.lastupdate,session.dateKeyFormat)# #LSTimeFormat(request.rsgroups.lastupdate,"short")# <cfelse>&nbsp;</cfif></td>
                  <td><cfif not request.rsgroups.perm>#HTMLEditFormat(LastUpdateBy)#<cfelse>&nbsp;</cfif></td>
                    <td class="administration"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPrivateUsers.editgroup&userid=#UserID#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li><cfif not request.rsgroups.perm><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" href="index.cfm?fuseaction=cPrivateUsers.update&action=delete&userid=#UserID#&type=1&siteid=#attributes.siteid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deletegroupconfirm'))#">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul>
                  </td>
                </tr>
                </cfoutput> 
          </table>