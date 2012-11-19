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
<cfinclude template="js.cfm">
<cfset rc.perm=application.permUtility.getPerm(rc.moduleid,rc.siteid)>
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
<cfoutput>
<h1>Site Search</h1>

<h2>Keyword Search</h2>
<form class="form-inline" novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
	<input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" maxlength="50" /><input type="button" class="btn" onclick="submitForm(document.forms.siteSearch);" value="Search" />
	<input type="hidden" name="muraAction" value="cArch.search">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
	<input type="hidden" name="moduleid" value="#rc.moduleid#">
</form>
<script>
siteManager.copyContentID = '#session.copyContentID#';
siteManager.copySiteID = '#session.copySiteID#';
</script>
</cfoutput>
 <table class="table table-striped table-condensed table-bordered mura-table-grid">
    <tr> 
	  <th>&nbsp;</th>
      <th class="var-width">Title</th>
      <th>Display</th>
      <th>Update</th>
      <th class="actions">&nbsp;</th>
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
     <!---<cfif (rc.rslist.type eq 'Page') or  (rc.rslist.type eq 'Folder')  or  (rc.rslist.type eq 'Calendar') or (rc.rslist.type eq 'Gallery')>--->
		<a href="javascript:;" onmouseover="showMenu('newContentMenu','#newcontent#',this,'#rc.rslist.contentid#','#rc.rslist.contentid#','#rc.rslist.parentid#','#rc.siteid#','#rc.rslist.type#');">&nbsp;</a>
	<!---<cfelse>
		&nbsp;
	</cfif>---></td>
          <td class="title var-width">#application.contentRenderer.dspZoom(crumbdata)#</td>
			   <td> 
	    <cfif rc.rslist.Display and (rc.rslist.Display eq 1 and rc.rslist.approved and rc.rslist.approved)>Yes<cfelseif(rc.rslist.Display eq 2 and rc.rslist.approved and rc.rslist.approved)>#LSDateFormat(rc.rslist.displaystart,session.dateKeyFormat)# - #LSDateFormat(rc.rslist.displaystop,session.dateKeyFormat)#<cfelse>No</cfif></td>
		<td>#LSDateFormat(rc.rslist.lastupdate,session.dateKeyFormat)#</td>
        
 <td class="actions"><ul class="siteSummary five"><cfif not listFindNoCase('none,read',verdict)>
       <li class="edit"><a title="Edit" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rsList.ContentHistID#&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#"><i class="icon-pencil"></i></a></li>
	   <cfswitch expression="#rc.rsList.type#">
		<cfcase value="Page,Folder,Calendar,Gallery">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,rc.rsList.filename)#','#rc.rsList.targetParams#');"><i class="icon-globe"></i></a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('#rc.rsList.filename#','#rc.rsList.targetParams#');"><i class="icon-globe"></i></a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?LinkServID=#rc.rsList.contentid#','#rc.rsList.targetParams#');"><i class="icon-globe"></i></a></li>
		</cfcase>
		</cfswitch>
	   <li class="version-history"><a title="Version History" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&topid=#rc.rsList.contentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#"><i class="icon-book"></i></a></li>
        <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
          <li class="permissions"><a title="Permissions" href="index.cfm?muraAction=cPerm.main&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&topid=#rc.rsList.contentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#"><i class="icon-group"></i></a></li>
        <cfelse>
		  <li class="permissions disabled"><a>Permissions</a></li>
		</cfif>
        <cfif deletable>
          <li class="delete"><a title="Delete" href="index.cfm?muraAction=cArch.update&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&action=deleteall&topid=#rc.rsList.contentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&parentid=#URLEncodedFormat(rc.parentid)#&startrow=#rc.startrow#"
			<cfif listFindNoCase("Page,Folder,Calendar,Gallery,Link,File",rc.rsList.type)><i class="icon-remove-sign"></i></a></li>
          <cfelseif rc.locking neq 'all'>
          <li class="delete disabled">Delete</li>
        </cfif>
        <cfelse>
        <li class="edit disabled">&nbsp;</li>
		<cfswitch expression="#rc.rsList.type#">
		<cfcase value="Page,Folder,Calendar,Gallery">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,rc.rsList.filename)#','#rc.rsList.targetParams#');"><i class="icon-globe"></i></a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('#rc.rsList.filename#','#rc.rsList.targetParams#');"><i class="icon-globe"></i></a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?LinkServID=#rc.rsList.contentid#','#rc.rsList.targetParams#');"><i class="icon-globe"></i></a></li>
		</cfcase>
		</cfswitch>
		<li class="version-history disabled"><a>Version History</a></li>
		<li class="permissions disabled"><a>Permissions</a></li>
		<li class="delete disabled"><a>Delete</a></li>
      </cfif></ul></td>
	
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="8" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
	</td></tr></table>
    <cfif rc.nextn.numberofpages gt 1>
    <cfoutput>
   <cfset args=arrayNew(1)>
		<cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
		<cfset args[2]=rc.nextn.totalrecords>
		<div class="mura-results-wrapper">
		<p class="clearfix search-showing">
			#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#
		</p> 
		<ul class="pagination">
		<cfif rc.nextN.currentpagenumber gt 1> 
			<li>
				<a href="index.cfm?muraAction=cArch.search&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#session.keywords#&startrow=#rc.nextn.previous#&moduleid=#rc.moduleid#">&laquo;&nbsp;Prev</a>
			</li>
		</cfif>	
		<cfloop from="#rc.nextN.firstPage#"  to="#rc.nextn.lastPage#" index="i">
			<cfif rc.nextn.currentpagenumber eq i>
				<li class="active"><a href="##">#i#</a></li>
			<cfelse> 
				<li><a href="index.cfm?muraAction=cArch.search&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#session.keywords#&startrow=#evaluate('(#i#*#rc.nextn.recordsperpage#)-#rc.nextn.recordsperpage#+1')#&moduleid=#rc.moduleid#">#i#</a></li>
			</cfif>
		</cfloop>
		<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
			<li>
				<a href="index.cfm?muraAction=cArch.search&siteid=#URLEncodedFormat(rc.siteid)#&keywords=#session.keywords#&startrow=#rc.nextn.next#&moduleid=#rc.moduleid#">Next&nbsp;&raquo;</a>
			</li>
		</cfif> 
		</cfoutput>
		</ul>
		</div>
	</cfif> 
</table>
