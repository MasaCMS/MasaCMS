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

<cfoutput>

<form class="form-inline" novalidate="novalidate" action="index.cfm" method="get" name="form1" id="siteSearch">

	<div class="input-append">
	    <input id="search" name="search" type="text" placeholder="Search for Users" />
	    <button type="button" class="btn" onclick="submitForm(document.forms.form1);" /><i class="icon-search"></i></button>
	<button type="button" class="btn" onclick="window.location='index.cfm?muraAction=cPublicUsers.advancedSearch&siteid=#URLEncodedFormat(rc.siteid)#&newSearch=true'" value="#application.rbFactory.getKeyValue(session.rb,'user.advanced')#" />#application.rbFactory.getKeyValue(session.rb,'user.advanced')#</button>
  <input type="hidden" name='siteid' value="#HTMLEditFormat(rc.siteid)#"/>
  <input type="hidden" name='muraAction' value="cPublicUsers.search"/>
	</div>

<!---
<input id="search" name="search" type="text" class="text"> 
<input type="button" class="btn" onclick="submitForm(document.forms.form1);" value="#application.rbFactory.getKeyValue(session.rb,'user.search')#" />
<input type="button" class="btn" onclick="window.location='index.cfm?muraAction=cPublicUsers.advancedSearch&siteid=#URLEncodedFormat(rc.siteid)#&newSearch=true'" value="#application.rbFactory.getKeyValue(session.rb,'user.advanced')#" /><
--->
</form>

<h1>#application.rbFactory.getKeyValue(session.rb,'user.sitemembersgroups')#</h1>
	
<div id="nav-module-specific" class="btn-group">
<a class="btn" href="index.cfm?muraAction=cPublicUsers.edituser&siteid=#URLEncodedFormat(rc.siteid)#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'user.addmember')#</a>
<a class="btn" href="index.cfm?muraAction=cPublicUsers.editgroup&siteid=#URLEncodedFormat(rc.siteid)#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'user.addgroup')#</a>

 <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
    <a class="btn" href="index.cfm?muraAction=cPerm.module&contentid=00000000000000000000000000000000008&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=00000000000000000000000000000000008"><i class="icon-group"></i> #application.rbFactory.getKeyValue(session.rb,'user.permissions')#</a>
  </cfif>
</div>


<h2>#application.rbFactory.getKeyValue(session.rb,'user.usergroups')#</h2>

        <table class="table table-striped table-condensed table-bordered mura-table-grid">
                  <tr> 
                    <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'user.name')# (<em>#application.rbFactory.getKeyValue(session.rb,'user.members')#</em>)</th>
                    <th>#application.rbFactory.getKeyValue(session.rb,'user.email')#</th>
                    <th >#application.rbFactory.getKeyValue(session.rb,'user.update')#</th> 
                    <th>#application.rbFactory.getKeyValue(session.rb,'user.authoreditor')#</th>
                    <th class="actions">&nbsp;</th>
                  </tr></cfoutput>
				  <cfif rc.rsgroups.recordcount>
                <cfoutput query="rc.rsgroups"> 
                  <tr> 
                    <td class="var-width"> 
                      <a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?muraAction=cPublicUsers.editgroup&userid=#rc.rsgroups.UserID#&siteid=#URLEncodedFormat(rc.siteid)#">#HTMLEditFormat(rc.rsgroups.groupname)#</a> (<cfif isNumeric(rc.rsgroups.counter)>#rc.rsgroups.counter#<cfelse>0</cfif>) </td>
                    <td> 
                      <cfif rc.rsgroups.email gt "" and not rc.rsgroups.perm>
                        <a href="mailto:#rc.rsgroups.email#">#HTMLEditFormat(rc.rsgroups.email)#</a>
                        <cfelse>&nbsp;</cfif> 
                  </td>
                    <td><cfif not rc.rsgroups.perm>
                 #LSDateFormat(rc.rsgroups.lastupdate,session.dateKeyFormat)# #LSTimeFormat(rc.rsgroups.lastupdate,"short")#<cfelse>&nbsp;</cfif></td>
                  <td><cfif not rc.rsgroups.perm>#HTMLEditFormat(rc.rsgroups.LastUpdateBy)#<cfelse>&nbsp;</cfif></td>
                    <td class="actions"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?muraAction=cPublicUsers.editgroup&userid=#rc.rsgroups.UserID#&siteid=#URLEncodedFormat(rc.siteid)#"><i class="icon-pencil"></i></a></li><cfif not rc.rsgroups.perm><li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'user.delete')#" href="index.cfm?muraAction=cPublicUsers.update&action=delete&userid=#rc.rsgroups.UserID#&siteid=#URLEncodedFormat(rc.siteid)#&type=1" onclick="return confirmDialog('Delete the #jsStringFormat("'#rc.rsGroups.groupname#'")# User Group?',this.href)"><i class="icon-remove-sign"></i></a></li><cfelse><li class="delete disabled"><span><i class="icon-remove-sign"></i></span></li></cfif></ul>
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
