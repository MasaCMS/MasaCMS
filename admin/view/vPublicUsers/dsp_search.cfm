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
<h2>#application.rbFactory.getKeyValue(session.rb,'user.membersearchresults')#</h2>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cPublicUsers.advancedSearch&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'user.advancedmembersearch')#</a></li>
</ul>
<form novalidate="novalidate" action="index.cfm" method="get" name="form1" id="siteSearch">
	<h3>#application.rbFactory.getKeyValue(session.rb,'user.searchformembers')#</h3>
<input id="search" name="search" value="#attributes.search#" type="text" class="text">
<input type="hidden" name="fuseaction" value="cPublicUsers.Search" />
<input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
 <input type="button" class="submit" onclick="submitForm(document.forms.form1);" value="#application.rbFactory.getKeyValue(session.rb,'user.search')#" /></form>


        <table class="mura-table-grid stripe">
          <tr> 
            <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'user.name')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'user.email')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'user.update')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'user.time')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'user.authoreditor')#</th>
            <th class="administration">&nbsp;</th>
          </tr></cfoutput>
          <cfif request.rsList.recordcount>
            <cfoutput query="request.rsList" maxrows="#request.nextN.recordsperPage#" startrow="#attributes.startrow#"> 
              <tr> 
                <td class="varWidth"><a title="Edit" href="index.cfm?fuseaction=cPublicUsers.edituser&userid=#request.rsList.UserID#&type=2&siteid=#URLEncodedFormat(attributes.siteid)#">#HTMLEditFormat(request.rsList.lname)#, #HTMLEditFormat(request.rsList.fname)# <cfif company neq ''> (#HTMLEditFormat(company)#)</cfif></a></td>
                <td><cfif request.rsList.email gt ""><a href="mailto:#HTMLEditFormat(request.rsList.email)#">#HTMLEditFormat(request.rsList.email)#</a><cfelse>&nbsp;</cfif></td>
                <td>#LSDateFormat(request.rslist.lastupdate,session.dateKeyFormat)#</td>
              <td>#LSTimeFormat(request.rslist.lastupdate,"short")#</td>
			  <td>#HTMLEditFormat(request.rsList.LastUpdateBy)#</td>
                <td class="administration"><ul class="one"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPublicUsers.edituser&userid=#request.rsList.UserID#&type=2&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li></ul></td>
              </tr>
            </cfoutput>
			
            <cfelse>
            <tr> 
              <td colspan="6" class="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.nosearchresults')#</cfoutput></td>
            </tr>
          </cfif>   
        </table>


<cfif request.nextN.numberofpages gt 1>
<cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.moreresults')#:
<cfif request.nextN.currentpagenumber gt 1> <a href="index.cfm?fuseaction=cPublicUsers.search&startrow=#request.nextN.previous#&lname=#urlencodedformat(attributes.lname)#&siteid=#URLEncodedFormat(attributes.siteid)#&search=#urlencodedformat(attributes.search)#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'user.prev')#</a></cfif>	
 <cfloop from="#request.nextN.firstPage#"  to="#request.nextN.lastPage#" index="i"><cfif request.nextN.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?fuseaction=cPublicUsers.search&startrow=#evaluate('(#i#*#request.nextN.recordsperpage#)-#request.nextN.recordsperpage#+1')#&lname=#urlencodedformat(attributes.lname)#&siteid=#URLEncodedFormat(attributes.siteid)#&search=#urlencodedformat(attributes.search)#">#i#</a> </cfif></cfloop>
<cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages><a href="index.cfm?fuseaction=cPublicUsers.search&startrow=#request.nextN.next#&lname=#urlencodedformat(attributes.lname)#&siteid=#URLEncodedFormat(attributes.siteid)#&search=#urlencodedformat(attributes.search)#">#application.rbFactory.getKeyValue(session.rb,'user.next')#&nbsp;&raquo;</a></cfif> 
</cfoutput>
</cfif>