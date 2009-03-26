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
<cfset request.groups=application.permUtility.getGroupList(attributes) />
<cfset request.rslist=request.groups.privateGroups />
<cfset request.crumbdata=application.contentManager.getCrumbList(attributes.contentid,attributes.siteid)>
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'permissions')#</h2>
<cfif attributes.moduleid eq '00000000000000000000000000000000000'>#application.contentRenderer.dspZoom(request.crumbdata,request.rsContent.fileEXT)#</cfif>
<p>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"permissions.nodetext"),request.rscontent.title)#</p>	
	
  <form method="post" name="form1" action="index.cfm?fuseaction=cPerm.update&contentid=#attributes.contentid#&parentid=#attributes.parentid#">
           <h3>#application.rbFactory.getKeyValue(session.rb,'user.adminusergroups')#</h3>
			<table class="stripe">
			<tr> 
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.editor')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.author')#</th>
			<th>#application.rbFactory.getKeyValue(session.rb,'permissions.inherit')#</th>
			<cfif attributes.moduleID eq '00000000000000000000000000000000000'><th>#application.rbFactory.getKeyValue(session.rb,'permissions.readonly')#</th></cfif>
			<th>#application.rbFactory.getKeyValue(session.rb,'permissions.deny')#</th>
            <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
          </tr>
		  <cfif request.rslist.recordcount>
          <cfloop query="request.rslist"> 
		   <cfset perm=application.permUtility.getGroupPerm(request.rslist.userid,attributes.contentid,attributes.siteid)/>
            <tr> 
              <td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="editor" <cfif perm eq 'Editor'>checked</cfif>></td>
	      <td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="author" <cfif perm eq 'Author'>checked</cfif>></td>
		   <td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="none" <cfif perm eq 'None'>checked</cfif>></td>
		    <cfif attributes.moduleID eq '00000000000000000000000000000000000'><td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="read" <cfif perm eq 'Read'>checked</cfif>></td></cfif>
		    <td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="deny" <cfif perm eq 'Deny'>checked</cfif>></td>
		<td nowrap class="varWidth">#request.rslist.GroupName#</td>
            </tr></cfloop>
		<cfelse>
		 <tr> 
              <td class="noResults" <cfif attributes.moduleID eq '00000000000000000000000000000000000'>colspan="6"<cfelse>colspan="7"</cfif>>
			#application.rbFactory.getKeyValue(session.rb,'permissions.nogroups')#
			  </td>
            </tr>
		</cfif>
		</table>
		
		<cfset request.rslist=request.groups.publicGroups />
		<h3>#application.rbFactory.getKeyValue(session.rb,'user.membergroups')#</h3>
		<p>#application.rbFactory.getKeyValue(session.rb,'permissions.memberpermscript')#
		  #application.rbFactory.getKeyValue(session.rb,'permissions.memberpermnodescript')#</p>
		<table class="stripe">
			<tr> 
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.editor')#</th>
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.author')#</th>
			<th>#application.rbFactory.getKeyValue(session.rb,'permissions.inherit')#</th>
			<cfif attributes.moduleID eq '00000000000000000000000000000000000'><th>#application.rbFactory.getKeyValue(session.rb,'permissions.readonly')#</th></cfif>
			<th>#application.rbFactory.getKeyValue(session.rb,'permissions.deny')#</th>
            <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
          </tr>
		  <cfif request.rslist.recordcount>
          <cfloop query="request.rslist"> 
		   <cfset perm=application.permUtility.getGroupPerm(request.rslist.userid,attributes.contentid,attributes.siteid)/>
            <tr> 
              <td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="editor" <cfif perm eq 'Editor'>checked</cfif>></td>
	      <td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="author" <cfif perm eq 'Author'>checked</cfif>></td>
		   <td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="none" <cfif perm eq 'None'>checked</cfif>></td>
		    <cfif attributes.moduleID eq '00000000000000000000000000000000000'><td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="read" <cfif perm eq 'Read'>checked</cfif>></td></cfif>
		    <td><input name="p#replacelist(request.rslist.userid,"-","")#" type="radio" class="checkbox" value="deny" <cfif perm eq 'Deny'>checked</cfif>></td>
		<td nowrap class="varWidth">#request.rslist.GroupName#</td>
            </tr></cfloop>
		<cfelse>
		 <tr> 
              <td class="noResults" <cfif attributes.moduleID eq '00000000000000000000000000000000000'>colspan="6"<cfelse>colspan="7"</cfif>>
			#application.rbFactory.getKeyValue(session.rb,'permissions.nogroups')#
			  </td>
            </tr>
		</cfif>
		</table>
	
		 <a class="submit" href="javascript:document.form1.submit();"><span>#application.rbFactory.getKeyValue(session.rb,'permissions.update')#</span></a>
                    <input type="hidden" name="router" value="#cgi.HTTP_REFERER#">
					<input type="hidden" name="siteid" value="#attributes.siteid#">
					<input type="hidden" name="startrow" value="#attributes.startrow#">
		  <input type="hidden" name="topid" value="#attributes.topid#"><input type="hidden" name="moduleid" value="#attributes.moduleid#"></form></td>
  </tr>
</table></cfoutput>