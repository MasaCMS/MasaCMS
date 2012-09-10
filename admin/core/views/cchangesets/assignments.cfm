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
<h2>Change Set Content List</h2>

<cfinclude template="dsp_secondary_menu.cfm">

<h3>#application.rbFactory.getKeyValue(session.rb,'changesets.name')#</h3>
<p>#HTMLEditFormat(rc.changeset.getName())#</p>

<cfset rc.rslist=rc.siteAssignments.getQuery()>
<cfset rc.previewLink="http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?changesetID=#rc.changesetID#">
<h4>#application.rbFactory.getKeyValue(session.rb,'changesets.filterview')#</h4>
<p>#application.rbFactory.getKeyValue(session.rb,'changesets.filterviewnotice')#</p>
<form class="form-inline" novalidate="novalidate" id="assignmentSearch" name="assignmentSearch" method="get">
	<input name="keywords" value="#HTMLEditFormat(rc.keywords)#" type="text" class="text" maxlength="50" />
	<input type="button" class="submit btn" onclick="return submitForm(document.forms.assignmentSearch);" value="Search" />
	<input type="hidden" name="muraAction" value="cChangesets.assignments">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
	<input type="hidden" name="changesetID" value="#HTMLEditFormat(rc.changesetID)#">
</form>

<h4>#application.rbFactory.getKeyValue(session.rb,'changesets.previewlink')#</h4>
<p><a title="Preview" href="##" onclick="return preview('#JSStringFormat(rc.previewLink)#','');">#HTMLEditFormat(rc.previewLink)#</a></p>
<h4>#application.rbFactory.getKeyValue(session.rb,'changesets.sitearchitecture')#</h4>
 <table class="table table-striped table-condensed mura-table-grid">
    <tr> 
      <th class="var-width">Title</th>
      <th class="actions">&nbsp;</th>
    </tr>
    <cfif rc.rslist.recordcount>
     <cfloop query="rc.rslist">
		<cfsilent>
			<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid,false,rc.rslist.path)/>
			<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
		</cfsilent>
        <tr>  
          <td class="title var-width">#application.contentRenderer.dspZoom(crumbdata,rc.rsList.fileExt)#</td>
 		  <td class="actions">
		<ul class="four">
		<cfif verdict neq 'none'>
       		<li class="edit"><a title="Edit" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rsList.ContentHistID#&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&topid=#URLEncodedFormat(rc.rslist.contentID)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.rslist.moduleid#&startrow=#rc.startrow#&return=changesets">Edit</a></li> 	
			<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?changesetPreviewID=#JSStringFormat(rc.rslist.changesetID)#&linkServID=#JSStringFormat(rc.rslist.contentID)#','#rc.rsList.targetParams#');">#HTMLEditFormat(left(rc.rsList.menutitle,70))#</a></li>
		   	<li class="versionHistory"><a title="Version History" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&topid=#rc.rsList.contentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.rslist.moduleID#&startrow=#rc.startrow#"Version History</a></li>   
        <cfelse>
	        <li class="editOff">&nbsp;</li>
			<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?changesetID=#JSStringFormat(rc.rslist.changesetID)#&linkServID=#JSStringFormat(rc.rslist.contentID)#','#rc.rsList.targetParams#');">#HTMLEditFormat(left(rc.rsList.menutitle,70))#</a></li>
			<li class="versionHistoryOff"><a>Version History</a></li>
      	</cfif>
		<li class="delete"><a  title="Delete" href="index.cfm?muraAction=cChangesets.removeItem&contentHistId=#rc.rsList.contentHistID#&siteid=#URLEncodedFormat(rc.siteid)#&changesetID=#URLEncodedFormat(rc.rslist.changesetID)#&keywords=#HTMLEditFormat(rc.keywords)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'changesets.removeitemconfirm'),rc.rslist.menutitle))#',this.href)">delete</a></li>
		</ul>
		</td>
		</tr>
   		</cfloop>
      <cfelse>
      <tr> 
        <td colspan="2" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
</table>
</td></tr></table>

<cfset rc.rslist=rc.componentAssignments.getQuery()>
<h4>#application.rbFactory.getKeyValue(session.rb,'changesets.components')#</h4>
 <table class="table table-striped table-condensed mura-table-grid">
    <tr> 
      <th class="var-width">Title</th>
      <th class="actions">&nbsp;</th>
    </tr>
    <cfif rc.rslist.recordcount>
     <cfloop query="rc.rslist">
		<cfsilent>
			<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid,false,rc.rslist.path)/>
			<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
      <cfset editlink="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rsList.ContentHistID#&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.rslist.moduleid#&startrow=#rc.startrow#&return=changesets">
		</cfsilent>
        <tr>  
          <td class="title var-width"><a href="#editlink#">#HTMLEditFormat(rc.rsList.title)#</a></td>
 		  <td class="actions">
		<ul class="three">
		<cfif verdict neq 'none'>
       		<li class="edit"><a title="Edit" href="#editlink#">Edit</a></li> 	
		   	<li class="versionHistory"><a title="Version History" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.rslist.moduleID#&startrow=#rc.startrow#">Version History</a></li>   
        <cfelse>
	        <li class="editOff">Edit</li>
			<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?changesetID=#JSStringFormat(rc.rslist.changesetID)#&linkServID=#JSStringFormat(rc.rslist.contentID)#','#rc.rsList.targetParams#');">Preview</a></li>
			<li class="versionHistoryOff"><a>Version History</a></li>
      	</cfif>
		<li class="delete"><a  title="Delete" href="index.cfm?muraAction=cChangesets.removeItem&contentHistId=#rc.rsList.contentHistID#&siteid=#URLEncodedFormat(rc.siteid)#&changesetID=#URLEncodedFormat(rc.rslist.changesetID)#&keywords=#HTMLEditFormat(rc.keywords)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'changesets.removeitemconfirm'),rc.rslist.menutitle))#',this.href)">Delete</a></li>
		</ul>
		</td>
		</tr>
   		</cfloop>
      <cfelse>
      <tr> 
        <td colspan="2" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
</table>
</td></tr></table>

<cfset rc.rslist=rc.formAssignments.getQuery()>
<h4>#application.rbFactory.getKeyValue(session.rb,'changesets.forms')#</h4>
 <table class="table table-striped table-condensed mura-table-grid">
    <tr> 
      <th class="var-width">Title</th>
      <th class="actions">&nbsp;</th>
    </tr>
    <cfif rc.rslist.recordcount>
     <cfloop query="rc.rslist">
    <cfsilent>
      <cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid,false,rc.rslist.path)/>
      <cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
      <cfset editlink="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rsList.ContentHistID#&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.rslist.moduleid#&startrow=#rc.startrow#&return=changesets">
    </cfsilent>
        <tr>  
          <td class="title var-width"><a href="#editlink#">#HTMLEditFormat(rc.rsList.title)#</a></td>
      <td class="actions">
    <ul class="three">
    <cfif verdict neq 'none'>
          <li class="edit"><a title="Edit" href="#editlink#">Edit;</a></li>  
        <li class="versionHistory"><a title="Version History" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rsList.ContentID#&type=#rc.rsList.type#&parentid=#rc.rsList.parentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.rslist.moduleID#&startrow=#rc.startrow#">Version History</a></li>   
        <cfelse>
          <li class="editOff">Edit</li>
      <li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?changesetID=#JSStringFormat(rc.rslist.changesetID)#&linkServID=#JSStringFormat(rc.rslist.contentID)#','#rc.rsList.targetParams#');">Preview</a></li>
      <li class="versionHistoryOff"><a>Version History</a></li>
        </cfif>
    <li class="delete"><a  title="Delete" href="index.cfm?muraAction=cChangesets.removeItem&contentHistId=#rc.rsList.contentHistID#&siteid=#URLEncodedFormat(rc.siteid)#&changesetID=#URLEncodedFormat(rc.rslist.changesetID)#&keywords=#HTMLEditFormat(rc.keywords)#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'changesets.removeitemconfirm'),rc.rslist.menutitle))#',this.href)">Delete</a></li>
    </ul>
    </td>
    </tr>
      </cfloop>
      <cfelse>
      <tr> 
        <td colspan="2" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
</table>
</td></tr></table>
  </cfoutput>