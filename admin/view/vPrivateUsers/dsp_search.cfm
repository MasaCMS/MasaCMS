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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'user.adminusersearchresults')#</h2>

        <table class="stripe">
          <tr> 
            <th class="varWidth">Name</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'user.email')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'user.update')#</th>
            <th>Time</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'user.authoreditor')#</th>
            <th>&nbsp;</th>
          </tr></cfoutput>
          <cfif request.rsList.recordcount>
            <cfoutput query="request.rsList" maxrows="#request.nextN.recordsperPage#" startrow="#attributes.startrow#"> 
              <tr> 
                <td class="varWidth"><a  title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPrivateUsers.edituser&userid=#request.rsList.UserID#&type=2&siteid=#attributes.siteid#">#HTMLEditFormat(lname)#, #HTMLEditFormat(fname)# <cfif company neq ''> (#HTMLEditFormat(company)#)</cfif></a></td>
                <td><cfif request.rsList.email gt ""><a href="mailto:#HTMLEditFormat(request.rsList.email)#">#HTMLEditFormat(request.rsList.email)#</a><cfelse>&nbsp;</cfif></td>
                <td>#LSDateFormat(request.rslist.lastupdate,session.dateKeyFormat)#</td>
              <td>#LSTimeFormat(request.rslist.lastupdate,"short")#</td>
			  <td>#HTMLEditFormat(request.rsList.LastUpdateBy)#</td>
                <td class="administration"><ul class="one"><li class="edit"><a  title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPrivateUsers.edituser&userid=#request.rsList.UserID#&type=2&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li></ul></td>
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
<cfif request.nextN.currentpagenumber gt 1> <a class="nextn" href="index.cfm?fuseaction=cPrivateUsers.search&startrow=#request.nextN.previous#&search=#urlencodedformat(attributes.search)#&siteid=#attributes.siteid#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'user.prev')#</a></cfif>	
<cfloop from="#request.nextN.firstPage#"  to="#request.nextN.lastPage#" index="i"><cfif request.nextN.currentpagenumber eq i> #i# <cfelse> <a class="nextn" href="index.cfm?fuseaction=cPrivateUsers.search&startrow=#evaluate('(#i#*#request.nextN.recordsperpage#)-#request.nextN.recordsperpage#+1')#&search=#urlencodedformat(attributes.search)#&siteid=#attributes.siteid#">#i#</a> </cfif></cfloop>
<cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages><a class="nextn" href="index.cfm?fuseaction=cPrivateUsers.search&startrow=#request.nextN.next#&search=#urlencodedformat(attributes.search)#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'user.next')#&nbsp;&raquo;</a></cfif> 
</cfoutput>
</cfif>
