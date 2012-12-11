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

<cfsilent>
<cfset rsUsage=application.contentGateway.getUsage(rc.contentID) />
</cfsilent>
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.usagereport"))/>
<cfset tabList=listAppend(tabList,"tabUsagereport")>
<cfoutput>
<div id="tabUsagereport" class="tab-pane fade">

<span id="extendset-container-tabusagereporttop" class="extendset-container"></span>

<div class="fieldset">
<div class="control-group">
<label class="control-label">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.usagedescription')#:</label>
 <table class="table table-striped table-condensed table-bordered mura-table-grid">
    <tr> 
      <th class="var-width">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#</th>
      <th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.display')#</th>
      <th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.update')#</th>
      <th class="actions">&nbsp;</th>
    </tr></cfoutput>
    <cfif rsUsage.recordcount>
     <cfoutput query="rsUsage">
		<cfset crumbdata=application.contentManager.getCrumbList(rsUsage.contentid, rc.siteid)/>
		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
        <tr>  
          <td class="var-width">#application.contentRenderer.dspZoom(crumbdata)#</td>
			   <td> 
	    <cfif rsUsage.Display and (rsUsage.Display eq 1 and rsUsage.approved)>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#<cfelseif(rsUsage.Display eq 2 and rsUsage.approved)>#LSDateFormat(rsUsage.displaystart,session.dateKeyFormat)# - #LSDateFormat(rsUsage.displaystop,session.dateKeyFormat)#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</cfif></td>
		<td>#LSDateFormat(rsUsage.lastupdate,session.dateKeyFormat)#</td>
          <td nowrap class="actions"><ul><cfif verdict neq 'none'><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.edit')#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rsUsage.ContentHistID#&contentid=#rsUsage.ContentID#&type=#rsUsage.type#&parentid=#rsUsage.parentID#&topid=#rsUsage.contentid#&siteid=#rsUsage.siteid#&moduleid=#rsUsage.moduleid#"><i class="icon-pencil"></i></a></li><li class="version-history"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#" href="index.cfm?muraAction=cArch.hist&contentid=#rsUsage.ContentID#&type=#rsUsage.type#&parentid=#rsUsage.parentID#&topid=#rsUsage.contentid#&siteid=#rsUsage.siteid#&moduleid=#rsUsage.moduleid#"><i class="icon-book"></i></a></li><cfelse><li class="edit disabled">#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#</li><li class="version-history disabled">#application.rbFactory.getKeyValue(session.rb,'sitemanager.versionhistory')#</li></cfif></ul></td></tr>
       </cfoutput>
      <cfelse>
     <cfoutput>
     <tr> 
        <td colspan="7" class="noResults">		#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.nousage'),lcase(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.contentBean.getType()#')))#
		</td>
      </tr>
    </cfoutput></cfif>
<cfoutput>
	  </table>


</div> <!--- / .control-group --->
</div> <!--- / .fieldset --->

<span id="extendset-container-usagereport" class="extendset-usagereport"></span>
<span id="extendset-container-tabusagereportbottom" class="extendset-container"></span>

</div> <!--- / .tab --->
</cfoutput>
