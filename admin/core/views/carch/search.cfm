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
<cfinclude template="ajax.cfm">
<cfset rc.perm=application.permUtility.getPerm(rc.moduleid,rc.siteid)>
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
<cfoutput>
<h2>Site Search</h2>

<h3>Keyword Search</h3>
<form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
	<input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" maxlength="50" /><input type="button" class="submit" onclick="submitForm(document.forms.siteSearch);" value="Search" />
	<input type="hidden" name="muraAction" value="cArch.search">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
	<input type="hidden" name="moduleid" value="#rc.moduleid#">
</form>
<script>
copyContentID = '#session.copyContentID#';
copySiteID = '#session.copySiteID#';
</script>
</cfoutput>
 <table class="mura-table-grid stripe">
    <tr> 
	  <th>&nbsp;</th>
      <th class="varWidth">Title</th>
      <th>Display</th>
      <th>Update</th>
      <th class="administration">&nbsp;</th>
    </tr>
    <cfif rc.rslist.recordcount>
     <cfoutput query="rc.rslist" maxrows="#rc.nextn.recordsperPage#" startrow="#rc.startrow#">
	<cfsilent>	
		<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid)/>
		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
		
		<cfif application.settingsManager.getSite(rc.siteid).getLocking() neq 'all'>
			<cfset newcontent=verdict>
		<cfelseif verdict neq 'none'>
			<cfset newcontent='read'>
		<cfelse>
			<cfset newcontent='none'>
		</cfif>
		

		<cfset deletable=((rc.rslist.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getLocking() neq 'all') or (rc.rslist.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getLocking() eq 'none')) and (verdict eq 'editor')  and rc.rslist.IsLocked neq 1>
		
	<!--- 	<cfif rc.rslist.type eq 'File'>
			<cfset icon=lcase(rc.rslist.fileExt)>
		<cfelse>
			<cfset icon=rc.rslist.type>
		</cfif> --->

	</cfsilent>
        <tr>  
			     <td class="add">
     <!---<cfif (rc.rslist.type eq 'Page') or  (rc.rslist.type eq 'Portal')  or  (rc.rslist.type eq 'Calendar') or (rc.rslist.type eq 'Gallery')>--->
		<a href="javascript:;" onmouseover="showMenu('newContentMenu','#newcontent#',this,'#rc.rslist.contentid#','#rc.rslist.contentid#','#rc.rslist.parentid#','#rc.siteid#','#rc.rslist.type#');">&nbsp;</a>
	<!---<cfelse>
		&nbsp;
	</cfif>---></td>
          <td class="title varWidth">#application.contentRenderer.dspZoom(crumbdata,rc.rsList.fileExt)#</td>
			   <td> 
	    <cfif rc.rslist.Display and (rc.rslist.Display eq 1 and rc.rslist.approved and rc.rslist.approved)>Yes<cfelseif(rc.rslist.Display eq 2 and rc.rslist.approved and rc.rslist.approved)>#LSDateFormat(rc.rslist.displaystart,session.dateKeyFormat)# - #LSDateFormat(rc.rslist.displaystop,session.dateKeyFormat)#<cfelse>No</cfif></td>
		<td>#LSDateFormat(rc.rslist.lastupdate,session.dateKeyFormat)#</td>
        
 <td class="administration"><ul class="siteSummary five"><cfif not listFindNoCase('none,read',verdict)>
       <li class="edit"><a title="Edit" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rsList.ContentHistID#&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#">&nbsp;</a></li>
	   <cfswitch expression="#rc.rsList.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,rc.rsList.filename)#','#rc.rsList.targetParams#');">#left(rc.rsList.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('#rc.rsList.filename#','#rc.rsList.targetParams#');">#left(rc.rsList.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?LinkServID=#rc.rsList.contentid#','#rc.rsList.targetParams#');">#left(rc.rsList.menutitle,70)#</a></li>
		</cfcase>
		</cfswitch>
	   <li class="versionHistory"><a title="Version History" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&topid=#rc.rsList.contentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#">&nbsp;</a></li>
        <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
          <li class="permissions"><a title="Permissions" href="index.cfm?muraAction=cPerm.main&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&topid=#rc.rsList.contentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#">&nbsp;</a></li>
        <cfelse>
		  <li class="permissionsOff"><a>Permissions</a></li>
		</cfif>
        <cfif deletable>
          <li class="delete"><a title="Delete" href="index.cfm?muraAction=cArch.update&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&action=deleteall&topid=#rc.rsList.contentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&parentid=#URLEncodedFormat(rc.parentid)#&startrow=#rc.startrow#"
			<cfif listFindNoCase("Page,Portal,Calendar,Gallery,Link,File",rc.rsList.type)>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),rc.rslist.menutitle))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"</cfif>>&nbsp;</a></li>
          <cfelseif rc.locking neq 'all'>
          <li class="deleteOff">Delete</li>
        </cfif>
        <cfelse>
        <li class="editOff">&nbsp;</li>
		<cfswitch expression="#rc.rsList.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,rc.rsList.filename)#','#rc.rsList.targetParams#');">#left(rc.rsList.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('#rc.rsList.filename#','#rc.rsList.targetParams#');">#left(rc.rsList.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?LinkServID=#rc.rsList.contentid#','#rc.rsList.targetParams#');">#left(rc.rsList.menutitle,70)#</a></li>
		</cfcase>
		</cfswitch>
		<li class="versionHistoryOff"><a>Version History</a></li>
		<li class="permissionsOff"><a>Permissions</a></li>
		<li class="deleteOff"><a>Delete</a></li>
      </cfif></ul></td>
	
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="8" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
	
    <cfif rc.nextn.numberofpages gt 1><tr> 
      <td colspan="8" class="results">More Results: <cfoutput>
	<cfif rc.nextN.currentpagenumber gt 1> <a href="index.cfm?muraAction=cArch.search&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#session.keywords#&startrow=#rc.nextn.previous#&moduleid=#rc.moduleid#">&laquo;&nbsp;Prev</a></cfif>	
	<cfloop from="#rc.nextN.firstPage#"  to="#rc.nextn.lastPage#" index="i"><cfif rc.nextn.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?muraAction=cArch.search&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#session.keywords#&startrow=#evaluate('(#i#*#rc.nextn.recordsperpage#)-#rc.nextn.recordsperpage#+1')#&moduleid=#rc.moduleid#">#i#</a> </cfif></cfloop>
	<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages><a href="index.cfm?muraAction=cArch.search&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#session.keywords#&startrow=#rc.nextn.next#&moduleid=#rc.moduleid#">Next&nbsp;&raquo;</a></cfif> 
	</td></tr>
	</cfoutput>
	</cfif> 
</table>
</td></tr></table>