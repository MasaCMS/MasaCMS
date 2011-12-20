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

<cfoutput><form novalidate="novalidate" action="index.cfm?fuseaction=cPublicUsers.search&siteid=#URLEncodedFormat(attributes.siteid)#" method="post" name="form1" id="siteSearch">
	<!---<h3>#application.rbFactory.getKeyValue(session.rb,'user.searchformembers')#</h3>--->
<input id="search" name="search" type="text" class="text"> 
<input type="button" class="submit" onclick="submitForm(document.forms.form1);" value="#application.rbFactory.getKeyValue(session.rb,'user.search')#" />
<input type="button" class="submit" onclick="window.location='index.cfm?fuseaction=cPublicUsers.advancedSearch&siteid=#URLEncodedFormat(attributes.siteid)#&newSearch=true'" value="#application.rbFactory.getKeyValue(session.rb,'user.advanced')#" /></form><h2>#application.rbFactory.getKeyValue(session.rb,'user.sitemembersgroups')#</h2>
	<ul id="navTask"><li><a href="index.cfm?fuseaction=cPublicUsers.edituser&siteid=#URLEncodedFormat(attributes.siteid)#&userid=">#application.rbFactory.getKeyValue(session.rb,'user.addmember')#</a></li>
<li><a href="index.cfm?fuseaction=cPublicUsers.editgroup&siteid=#URLEncodedFormat(attributes.siteid)#&userid=">#application.rbFactory.getKeyValue(session.rb,'user.addgroup')#</a></li>
</ul>


<h3>#application.rbFactory.getKeyValue(session.rb,'user.usergroups')#</h3>


        <table class="mura-table-grid stripe">
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
                      <a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPublicUsers.editgroup&userid=#request.rsgroups.UserID#&siteid=#URLEncodedFormat(attributes.siteid)#">#HTMLEditFormat(request.rsgroups.groupname)#</a> (<cfif isNumeric(request.rsgroups.counter)>#request.rsgroups.counter#<cfelse>0</cfif>) </td>
                    <td> 
                      <cfif request.rsgroups.email gt "" and not request.rsgroups.perm>
                        <a href="mailto:#request.rsgroups.email#">#HTMLEditFormat(request.rsgroups.email)#</a>
                        <cfelse>&nbsp;</cfif> 
                  </td>
                    <td><cfif not request.rsgroups.perm>
                 #LSDateFormat(request.rsgroups.lastupdate,session.dateKeyFormat)# #LSTimeFormat(request.rsgroups.lastupdate,"short")#<cfelse>&nbsp;</cfif></td>
                  <td><cfif not request.rsgroups.perm>#HTMLEditFormat(request.rsgroups.LastUpdateBy)#<cfelse>&nbsp;</cfif></td>
                    <td class="administration"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPublicUsers.editgroup&userid=#request.rsgroups.UserID#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li><cfif not request.rsgroups.perm><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" href="index.cfm?fuseaction=cPublicUsers.update&action=delete&userid=#request.rsgroups.UserID#&siteid=#URLEncodedFormat(attributes.siteid)#&type=1" onclick="return confirmDialog('Delete the #jsStringFormat("'#request.rsGroups.groupname#'")# User Group?',this.href)">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul>
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
