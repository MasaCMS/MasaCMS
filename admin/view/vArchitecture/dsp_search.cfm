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

<cfset request.perm=application.permUtility.getPerm(attributes.moduleid,attributes.siteid)>
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
<cfoutput>
<h2>Site Search</h2>

<h3>Keyword Search</h3>
<form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
	<input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" maxlength="50" /><input type="button" class="submit" onclick="submitForm(document.forms.siteSearch);" value="Search" />
	<input type="hidden" name="fuseaction" value="cArch.search">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
	<input type="hidden" name="moduleid" value="#attributes.moduleid#">
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
    <cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" maxrows="#request.nextn.recordsperPage#" startrow="#attributes.startrow#">
	<cfsilent>	
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
		
		<cfif application.settingsManager.getSite(attributes.siteid).getLocking() neq 'all' and verdict neq 'none'>
			<cfset newcontent=1>
		<cfelse>
			<cfset newcontent=0>
		</cfif>
		

		<cfset deletable=((request.rslist.parentid neq '00000000000000000000000000000000001' and application.settingsManager.getSite(attributes.siteid).getLocking() neq 'all') or (request.rslist.parentid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(attributes.siteid).getLocking() eq 'none')) and (verdict eq 'editor')  and request.rslist.IsLocked neq 1>
		
	<!--- 	<cfif request.rslist.type eq 'File'>
			<cfset icon=lcase(request.rslist.fileExt)>
		<cfelse>
			<cfset icon=request.rslist.type>
		</cfif> --->

	</cfsilent>
        <tr>  
			     <td class="add">
     <!---<cfif (request.rslist.type eq 'Page') or  (request.rslist.type eq 'Portal')  or  (request.rslist.type eq 'Calendar') or (request.rslist.type eq 'Gallery')>--->
		<a href="javascript:;" onmouseover="showMenu('newContentMenu',#newcontent#,this,'#request.rslist.contentid#','#request.rslist.contentid#','#request.rslist.parentid#','#attributes.siteid#','#request.rslist.type#');">&nbsp;</a>
	<!---<cfelse>
		&nbsp;
	</cfif>---></td>
          <td class="title varWidth">#application.contentRenderer.dspZoom(crumbdata,request.rsList.fileExt)#</td>
			   <td> 
	    <cfif request.rslist.Display and (request.rslist.Display eq 1 and request.rslist.approved and request.rslist.approved)>Yes<cfelseif(request.rslist.Display eq 2 and request.rslist.approved and request.rslist.approved)>#LSDateFormat(request.rslist.displaystart,session.dateKeyFormat)# - #LSDateFormat(request.rslist.displaystop,session.dateKeyFormat)#<cfelse>No</cfif></td>
		<td>#LSDateFormat(request.rslist.lastupdate,session.dateKeyFormat)#</td>
        
 <td class="administration"><ul class="siteSummary five"><cfif verdict neq 'none'>
       <li class="edit"><a title="Edit" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rsList.ContentHistID#&contentid=#request.rsList.ContentID#&type=#request.rsList.type#&parentid=#request.rsList.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">&nbsp;</a></li>
	   <cfswitch expression="#request.rsList.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,request.rsList.filename)#','#request.rsList.targetParams#');">#left(request.rsList.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="Preview" href="javascript:preview('#request.rsList.filename#','#request.rsList.targetParams#');">#left(request.rsList.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#request.rsList.contentid#','#request.rsList.targetParams#');">#left(request.rsList.menutitle,70)#</a></li>
		</cfcase>
		</cfswitch>
	   <li class="versionHistory"><a title="Version History" href="index.cfm?fuseaction=cArch.hist&contentid=#request.rsList.ContentID#&type=#request.rsList.type#&parentid=#request.rsList.parentID#&topid=#request.rsList.contentID#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">&nbsp;</a></li>
        <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
          <li class="permissions"><a title="Permissions" href="index.cfm?fuseaction=cPerm.main&contentid=#request.rsList.ContentID#&type=#request.rsList.type#&parentid=#request.rsList.parentID#&topid=#request.rsList.contentID#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">&nbsp;</a></li>
        <cfelse>
		  <li class="permissionsOff"><a>Permissions</a></li>
		</cfif>
        <cfif deletable>
          <li class="delete"><a title="Delete" href="index.cfm?fuseaction=cArch.update&contentid=#request.rsList.ContentID#&type=#request.rsList.type#&action=deleteall&topid=#request.rsList.contentID#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&parentid=#URLEncodedFormat(attributes.parentid)#&startrow=#attributes.startrow#"
			<cfif listFindNoCase("Page,Portal,Calendar,Gallery,Link,File",request.rsList.type)>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),request.rslist.menutitle))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"</cfif>>&nbsp;</a></li>
          <cfelseif attributes.locking neq 'all'>
          <li class="deleteOff">Delete</li>
        </cfif>
        <cfelse>
        <li class="editOff">&nbsp;</li>
		<cfswitch expression="#request.rsList.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,request.rsList.filename)#','#request.rsList.targetParams#');">#left(request.rsList.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="Preview" href="javascript:preview('#request.rsList.filename#','#request.rsList.targetParams#');">#left(request.rsList.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#request.rsList.contentid#','#request.rsList.targetParams#');">#left(request.rsList.menutitle,70)#</a></li>
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
	
    <cfif request.nextn.numberofpages gt 1><tr> 
      <td colspan="8" class="results">More Results: <cfoutput>
	<cfif request.nextN.currentpagenumber gt 1> <a href="index.cfm?fuseaction=cArch.search&siteid=#URLEncodedFormat(attributes.siteid)#&keywords=#session.keywords#&startrow=#request.nextn.previous#&moduleid=#attributes.moduleid#">&laquo;&nbsp;Prev</a></cfif>	
	<cfloop from="#request.nextN.firstPage#"  to="#request.nextn.lastPage#" index="i"><cfif request.nextn.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?fuseaction=cArch.search&siteid=#URLEncodedFormat(attributes.siteid)#&keywords=#session.keywords#&startrow=#evaluate('(#i#*#request.nextn.recordsperpage#)-#request.nextn.recordsperpage#+1')#&moduleid=#attributes.moduleid#">#i#</a> </cfif></cfloop>
	<cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages><a href="index.cfm?fuseaction=cArch.search&siteid=#URLEncodedFormat(attributes.siteid)#&keywords=#session.keywords#&startrow=#request.nextn.next#&moduleid=#attributes.moduleid#">Next&nbsp;&raquo;</a></cfif> 
	</td></tr>
	</cfoutput>
	</cfif> 
</table>
</td></tr></table>
