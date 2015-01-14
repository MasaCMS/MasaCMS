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
<h1>Change Set Content List</h1>
<cfinclude template="dsp_secondary_menu.cfm">
<cfset csrftokens=rc.$.renderCSRFTokens(context=rc.changesetid,format='url')>
<cfif rc.changeset.getPublished()>
<p class="alert">#application.rbFactory.getKeyValue(session.rb,'changesets.publishednotice')#</p>
<cfelse>
  <cfset hasPendingApprovals=rc.changeset.hasPendingApprovals()>
  <cfif hasPendingApprovals>
    <div class="alert alert-error">
        #application.rbFactory.getKeyValue(session.rb,'changesets.haspendingapprovals')# 
    </div>  
  </cfif>
</cfif>

<cfif not rc.changeset.getPublished() and isDate(rc.changeset.getCloseDate())>
   <div class="alert">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"changesets.hasclosedate"),LSDateFormat(rc.changeset.getCloseDate(),session.dateKeyFormat))#
    </div> 
</cfif>
<!--- <h2>#application.rbFactory.getKeyValue(session.rb,'changesets.name')#</h2> --->
<h2>#esapiEncode('html',rc.changeset.getName())#</h2>

<cfif not rc.changeset.getPublished()>
<p><i class="icon-link"></i> <a title="Change Set Name" href="##" onclick="return preview('#esapiEncode('javascript',rc.previewLink)#','');">#esapiEncode('html',rc.previewLink)#</a></p>
</cfif>

<form class="form-inline separate" novalidate="novalidate" id="assignmentSearch" name="assignmentSearch" method="get">
	<input name="keywords" placeholder="Keywords" value="#esapiEncode('html_attr',rc.keywords)#" type="text" class="text" maxlength="50" />
	<input type="button" class="btn" onclick="return submitForm(document.forms.assignmentSearch);" value="#application.rbFactory.getKeyValue(session.rb,'changesets.filterview')#" />
	<input type="hidden" name="muraAction" value="cChangesets.assignments">
	<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
	<input type="hidden" name="changesetID" value="#esapiEncode('html_attr',rc.changesetID)#">
</form>
<!---
<h3>#application.rbFactory.getKeyValue(session.rb,'changesets.filterview')#</h3>
<p>#application.rbFactory.getKeyValue(session.rb,'changesets.filterviewnotice')#</p>
--->

<!--- <h3>#application.rbFactory.getKeyValue(session.rb,'changesets.previewlink')#</h3> --->

<h3>#application.rbFactory.getKeyValue(session.rb,'changesets.sitearchitecture')#</h3>
 <table class="mura-table-grid">
    <tr> 
      <th class="var-width"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
      <th> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.status')#</th>
      <th class="actions">&nbsp;</th>
    </tr>
    <cfif rc.siteAssignments.hasNext()>
     <cfloop condition="rc.siteAssignments.hasNext()">
		<cfsilent>
      <cfset item=rc.siteAssignments.next()>
			<cfset crumbdata=application.contentManager.getCrumbList(item.getContentID(), rc.siteid,false,item.getPath())/>
			<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
		</cfsilent>
        <tr>  
          <td class="title var-width">#$.dspZoom(crumbdata)#</td>
           <td> 
            <cfif len(item.getapprovalStatus())>
              #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.#item.getapprovalStatus()#')#
            <cfelseif item.getapproved() and item.getactive()>
               #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.published')#
            <cfelseif item.getapproved()>
                 #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.archived')#
            <cfelse>
              #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.queued')#
            </cfif>
          </td>
 		  <td class="actions">
		<ul>
		<cfif verdict neq 'none'>
      <li class="edit"><a title="Edit" href="./?muraAction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#esapiEncode('javascript',item.gettype())#&parentid=#item.getparentID()#&topid=#esapiEncode('url',item.getcontentID())#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#item.getmoduleid()#&startrow=#esapiEncode('url',rc.startrow)#&return=changesets"> <i class="icon-pencil"></i></a></li> 	
			 <li class="preview"><a title="Preview" href="##" onclick="return preview('#item.getURL(complete=1,queryString="previewid=#item.getContentHistID()#")#');"><i class="icon-globe"></i></a></li>
		   <li class="version-history"><a title="Version History" href="./?muraAction=cArch.hist&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#item.getcontentID()#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#item.getmoduleID()#&startrow=#esapiEncode('url',rc.startrow)#"><i class="icon-book"></i></a></li>
    <cfelse>
      <li class="edit disabled"><i class="icon-edit"></i></li>
      <li class="preview"><a title="Preview" href="##" onclick="return preview('#item.getURL(complete=1,queryString="previewid=#item.getContentHistID()#")#');"><i class="icon-globe"></i></a></li>
		  <li class="version-history disabled"><i class="icon-book"></i></li>
    </cfif>
		<li class="delete"><a  title="Delete" href="./?muraAction=cChangesets.removeItem&contentHistId=#item.getcontentHistID()#&siteid=#esapiEncode('url',rc.siteid)#&changesetID=#esapiEncode('url',item.getchangesetID())#&keywords=#esapiEncode('html',rc.keywords)##csrftokens#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'changesets.removeitemconfirm'),item.getmenutitle()))#',this.href)"><i class="icon-remove-sign"></i></a></li>
		</ul>
		</td>
		</tr>
   		</cfloop>
      <cfelse>
      <tr> 
        <td colspan="3" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
</table>


<cfset rc.rslist=rc.componentAssignments.getQuery()>
<h3>#application.rbFactory.getKeyValue(session.rb,'changesets.components')#</h3>
 <table class="mura-table-grid">
    <tr> 
      <th class="var-width"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
      <th> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.status')#</th>
      <th class="actions">&nbsp;</th>
    </tr>
    <cfif rc.rslist.recordcount>
     <cfloop query="rc.rslist">
		<cfsilent>
			<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid,false,rc.rslist.path)/>
			<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
      <cfset editlink="./?muraAction=cArch.edit&contenthistid=#rc.rsList.ContentHistID#&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.rslist.moduleid#&startrow=#esapiEncode('url',rc.startrow)#&return=changesets">
		</cfsilent>
        <tr>  
          <td class="title var-width"><a href="#editlink#">#esapiEncode('html',rc.rsList.title)#</a></td>
          <td> 
            <cfif len(rc.rslist.approvalStatus)>
              #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.#rc.rslist.approvalStatus#')#
            <cfelseif rc.rslist.approved and rc.rslist.active>
               #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.published')#
            <cfelseif rc.rslist.approved>
                 #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.archived')#
            <cfelse>
              #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.queued')#
            </cfif>
          </td>
 		     <td class="actions">
      		<ul>
      		<cfif verdict neq 'none'>
            <li class="edit"><a title="Edit" href="#editlink#"><i class="icon-pencil"></i></a></li> 	
      		  <li class="version-history"><a title="Version History" href="./?muraAction=cArch.hist&contentid=#rc.rsList.ContentID#&type=#esapiEncode('url',rc.rsList.type)#&parentid=#rc.rsList.parentID#&&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.rslist.moduleID#&startrow=#esapiEncode('url',rc.startrow)#"><i class="icon-book"></i></a></li>   
          <cfelse>
      	   <li class="edit disabled"><i class="icon-pencil"></i></li>
            <li class="version-history disabled"><a><i class="icon-book"></i></a></li>
          </cfif> 	
      		<li class="delete"><a  title="Delete" href="./?muraAction=cChangesets.removeItem&contentHistId=#rc.rsList.contentHistID#&siteid=#esapiEncode('url',rc.siteid)#&changesetID=#esapiEncode('url',rc.rslist.changesetID)#&keywords=#esapiEncode('html',rc.keywords)##csrftokens#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'changesets.removeitemconfirm'),rc.rslist.menutitle))#',this.href)"><i class="icon-remove-sign"></i></a></li>
      		</ul>
      	</td>
		    </tr>
   		</cfloop>
      <cfelse>
      <tr> 
        <td colspan="3" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
</table>


<cfset rc.rslist=rc.formAssignments.getQuery()>
<h3>#application.rbFactory.getKeyValue(session.rb,'changesets.forms')#</h3>
 <table class="mura-table-grid">
    <tr> 
      <th class="var-width"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.title')#</th>
      <th> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.status')#</th>
      <th class="actions">&nbsp;</th>
    </tr>
    <cfif rc.rslist.recordcount>
     <cfloop query="rc.rslist">
    <cfsilent>
      <cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid,false,rc.rslist.path)/>
      <cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
      <cfset editlink="./?muraAction=cArch.edit&contenthistid=#rc.rsList.ContentHistID#&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.rslist.moduleid#&startrow=#esapiEncode('url',rc.startrow)#&return=changesets">
    </cfsilent>
        <tr>  
          <td class="title var-width"><a href="#editlink#">#esapiEncode('html',rc.rsList.title)#</a></td>
           <td>
            <cfif len(rc.rslist.approvalStatus)>
              #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.#rc.rslist.approvalStatus#')#
            <cfelseif rc.rslist.approved and rc.rslist.active>
               #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.published')#
            <cfelseif rc.rslist.approved>
                 #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.archived')#
            <cfelse>
              #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.queued')#
            </cfif>
           </td>

           <td class="actions">
            <ul>
            <cfif verdict neq 'none'>
              <li class="edit"><a title="Edit" href="#editlink#"><i class="icon-pencil"></i></a></li>  
              <li class="version-history"><a title="Version History" href="./?muraAction=cArch.hist&contentid=#rc.rsList.ContentID#&type=#esapiEncode('url',rc.rsList.type)#&parentid=#rc.rsList.parentID#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.rslist.moduleID#&startrow=#esapiEncode('url',rc.startrow)#"><i class="icon-book"></i></a></li>   
            <cfelse>
                <li class="edit disabled"><i class="icon-pencil"></i></li>
               <li class="version-history disabled"><a><i class="icon-book"></i></a></li>
            </cfif>
            <li class="delete"><a  title="Delete" href="./?muraAction=cChangesets.removeItem&contentHistId=#rc.rsList.contentHistID#&siteid=#esapiEncode('url',rc.siteid)#&changesetID=#esapiEncode('url',rc.rslist.changesetID)#&keywords=#esapiEncode('html',rc.keywords)##csrftokens#" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'changesets.removeitemconfirm'),rc.rslist.menutitle))#',this.href)"><i class="icon-remove-sign"></i></a></li>
            </ul>
          </td>
        </tr>
      </cfloop>
      <cfelse>
      <tr> 
        <td colspan="3" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
</table>

  </cfoutput>