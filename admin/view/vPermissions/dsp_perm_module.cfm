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
<cfset request.rslist=request.groups.privateGroups />
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'permissions')#</h2>

<p>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"permissions.moduletext"),request.rscontent.title)#</p>
  <form  method="post" name="form1" action="?fuseaction=cPerm.updatemodule&contentid=#attributes.contentid#">
        <h3>#application.rbFactory.getKeyValue(session.rb,'user.adminusergroups')#</h3>
		<table class="stripe">
          <tr> 
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.allow')#</th>
            <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
          </tr>
		  <cfif request.rslist.recordcount>
          <cfloop query="request.rslist"> 
            <tr> 
              <td><input type="checkbox" name="groupid" value="#request.rslist.userid#"<cfif application.permUtility.getGroupPermVerdict(attributes.contentid,request.rslist.userid,'Module',attributes.siteid)>checked</cfif>></td>
	      <td class="varWidth" nowrap>#request.rslist.GroupName#</td>
			</tr>
		 </cfloop>
		<cfelse>
		 <tr> 
              <td class="noResults" colspan="2">
			 #application.rbFactory.getKeyValue(session.rb,'permissions.nogroups')#
			  </td>
            </tr>
	</cfif>
		</table
	
		<cfset request.rslist=request.groups.publicGroups />
		 <h3>#application.rbFactory.getKeyValue(session.rb,'user.membergroups')#</h3>
		 <p>#application.rbFactory.getKeyValue(session.rb,'permissions.memberpermscript')#</p>
		 <table class="stripe">
          <tr> 
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.allow')#</th>
            <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
          </tr>
		  <cfif request.rslist.recordcount>
          <cfloop query="request.rslist"> 
            <tr> 
              <td><input type="checkbox" name="groupid" value="#request.rslist.userid#"<cfif application.permUtility.getGroupPermVerdict(attributes.contentid,request.rslist.userid,'Module',attributes.siteid)>checked</cfif>></td>
	      <td class="varWidth" nowrap>#request.rslist.GroupName#</td>
			</tr>
		 </cfloop>
	<cfelse>
		 <tr> 
              <td class="noResults" colspan="2">
			 #application.rbFactory.getKeyValue(session.rb,'permissions.nogroups')#
			  </td>
            </tr>
	</cfif>
		</table>
	
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'permissions.update')#</span></a><input type="hidden" name="router" value="#cgi.HTTP_REFERER#"><input type="hidden" name="siteid" value="#attributes.siteid#"><input type="hidden" name="topid" value="#attributes.topid#"><input type="hidden" name="moduleid" value="#attributes.moduleid#"></form></cfoutput>