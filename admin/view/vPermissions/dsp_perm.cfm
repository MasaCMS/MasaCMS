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
<cfset request.groups=application.permUtility.getGroupList(attributes) />
<cfset request.rslist=request.groups.privateGroups />
<cfset request.crumbdata=application.contentManager.getCrumbList(attributes.contentid,attributes.siteid)>
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'permissions')#</h2>
<cfif attributes.moduleid eq '00000000000000000000000000000000000'>#application.contentRenderer.dspZoom(request.crumbdata,request.rsContent.fileEXT)#</cfif>
<p>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"permissions.nodetext"),request.rscontent.title)#</p>	
	
  <form method="post" name="form1" action="index.cfm?fuseaction=cPerm.update&contentid=#URLEncodedFormat(attributes.contentid)#&parentid=#URLEncodedFormat(attributes.parentid)#">
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
					<input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
					<input type="hidden" name="startrow" value="#attributes.startrow#">
		  <input type="hidden" name="topid" value="#attributes.topid#"><input type="hidden" name="moduleid" value="#attributes.moduleid#"></form></td>
  </tr>
</table></cfoutput>