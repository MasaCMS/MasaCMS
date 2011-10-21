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
<cfset request.rslist=request.groups.privateGroups />
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'permissions')#</h2>

<p>#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"permissions.moduletext"),request.rscontent.title)#</p>
  <form novalidate="novalidate"  method="post" name="form1" action="?fuseaction=cPerm.updatemodule&contentid=#URLEncodedFormat(attributes.contentid)#">
        <h3 class="separate">#application.rbFactory.getKeyValue(session.rb,'user.adminusergroups')#</h3>
		<table class="mura-table-grid stripe">
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
	
		<cfset request.rslist=request.groups.publicGroups />
		 <h3 class="divide">#application.rbFactory.getKeyValue(session.rb,'user.membergroups')#</h3>		<p>#application.rbFactory.getKeyValue(session.rb,'permissions.memberpermscript')#</p>
		 <table class="mura-table-grid stripe">
          <tr> 
            <th>#application.rbFactory.getKeyValue(session.rb,'permissions.allow')#</th>
            <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'permissions.group')#</th>
          </tr>
		  <cfif request.rslist.recordcount>
          <cfloop query="request.rslist"> 
            <tr> 
              <td><input type="checkbox" name="groupid" value="#request.rslist.userid#"<cfif application.permUtility.getGroupPermVerdict(attributes.contentid,request.rslist.userid,'module',attributes.siteid)>checked</cfif>></td>
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
<div id="actionButtons">
<input type="button" class="submit" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'permissions.update')#" />
</div>
<input type="hidden" name="router" value="#cgi.HTTP_REFERER#">
<input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
<input type="hidden" name="topid" value="#attributes.topid#">
<input type="hidden" name="moduleid" value="#attributes.moduleid#">
</form></cfoutput>