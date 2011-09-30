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

<cfparam name="attributes.sortBy" default="">
<cfparam name="attributes.sortDirection" default="">
<cfparam name="attributes.searchString" default="">

<cfset titleDirection = "asc">
<cfset displayDirection = "asc">
<cfset lastUpdatedDirection = "desc">

<cfswitch expression="#attributes.sortBy#">
	<cfcase value="title">
		 <cfif attributes.sortDirection eq "asc">
			<cfset titleDirection = "desc">
		</cfif>
	</cfcase>
	<cfcase value="display">
		<cfif attributes.sortDirection eq "asc">
			<cfset displayDirection = "desc">
		</cfif>
	</cfcase>
	<cfcase value="lastupdate">
		<cfif attributes.sortDirection eq "desc">
			<cfset lastUpdatedDirection = "asc">
		</cfif>
	</cfcase>
</cfswitch>

<cfoutput>
<cfif attributes.moduleid eq '00000000000000000000000000000000004'>
<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.formsmanager')#</h2>
<cfelse>
<h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.componentmanager')#</h2>	
</cfif>

<ul id="navTask">
	<cfif attributes.moduleid eq '00000000000000000000000000000000003'>
	<li><a href="index.cfm?fuseaction=cArch.edit&type=Component&contentid=&topid=#URLEncodedFormat(attributes.topid)#&parentid=#attributes.topid#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.addcomponent')#</a></li>
	<cfelse>
		<li><a href="index.cfm?fuseaction=cArch.edit&type=Form&contentid=&topid=#URLEncodedFormat(attributes.topid)#&parentid=#attributes.topid#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&formType=editor">#application.rbFactory.getKeyValue(session.rb,'sitemanager.addformwitheditor')#</a></li>
	<li><a href="index.cfm?fuseaction=cArch.edit&type=Form&contentid=&topid=#URLEncodedFormat(attributes.topid)#&parentid=#attributes.topid#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&formType=builder">#application.rbFactory.getKeyValue(session.rb,'sitemanager.addformwithbuilder')#</a></li>
	</cfif>
</ul>

  <h3 class="alt">#application.rbFactory.getKeyValue(session.rb,'sitemanager.filterview')#:</h3>
  <form novalidate="novalidate" id="filterByTitle" action="index.cfm" method="get">
	  <h4>#application.rbFactory.getKeyValue(session.rb,'sitemanager.filterviewdesc')#</h4>
	  <input type="text" name="searchString" value="#HTMLEditFormat(attributes.searchString)#" class="text">
	  <input type="button" class="submit" onclick="document.getElementById('filterByTitle').submit();" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.filter')#" />
	  <input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#" />
	  <input type="hidden" name="topid" value="#attributes.topID#" />
	  <input type="hidden" name="parentid" value="#attributes.parentID#" />
	  <input type="hidden" name="moduleid" value="#attributes.moduleID#" />
	  <input type="hidden" name="sortBy" value="" />
	  <input type="hidden" name="sortDirection" value="" />
	  <input type="hidden" name="fuseaction" value="cArch.list" />
  </form>
  
  </cfoutput>
  <table class="mura-table-grid stripe">
    
	<cfoutput>
	<tr> 
      <th class="varWidth"><a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&topid=#URLEncodedFormat(attributes.topid)#&parentid=#URLEncodedFormat(attributes.parentid)#&moduleid=#attributes.moduleID#&sortBy=title&sortDirection=#titleDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.title')#</a></th>
    <!--- <cfif request.perm eq 'editor'><th class="order" width="30">Order</th></cfif>--->
      <th><a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&topid=#URLEncodedFormat(attributes.topid)#&parentid=#URLEncodedFormat(attributes.parentid)#&moduleid=#attributes.moduleID#&sortBy=display&sortDirection=#displayDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.display')#</a></th>
      <th><a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&topid=#URLEncodedFormat(attributes.topid)#&parentid=#URLEncodedFormat(attributes.parentid)#&moduleid=#attributes.moduleID#&sortBy=lastUpdate&sortDirection=#lastUpdatedDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.lastupdated')#</a></th>
      <th class="administration">&nbsp;</th>
    </tr>
	</cfoutput>
    <cfif request.rstop.recordcount>
     <cfoutput query="request.rsTop" maxrows="#request.nextn.recordsperPage#" startrow="#attributes.startrow#">
	<cfsilent><cfif request.perm neq 'editor'>
	<cfset verdict=application.permUtility.getPerm(request.rstop.contentid, attributes.siteid)>
	
	<cfif verdict neq 'deny'>
		<cfif verdict eq 'none'>
			<cfset verdict=request.perm>
		</cfif>
	<cfelse>
		<cfset verdict = "none">
	</cfif>
	
	<cfelse>
<cfset verdict='editor'>
</cfif>
</cfsilent>
        <tr>  
          <td class="varWidth"><cfif verdict neq 'none'><a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#request.rstop.contentid#" data-contenthistid="#request.rstop.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&contentid=#request.rstop.ContentID#&type=#request.rstop.type#&parentid=#request.rstop.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#">#left(request.rstop.menutitle,90)#</a><cfelse>#left(request.rstop.menutitle,90)#</cfif></td>
          <!--- <cfif verdict eq 'editor'><td nowrap class="order"><cfif request.rstop.currentrow neq 1><a href="index.cfm?fuseaction=cArch.order&contentid=#request.rstop.contentid#&parentid=#request.rstop.parentid#&direction=down&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#"><img src="images/icons/up_on.gif" width="9" height="6" border="0"></a><cfelse><img src="images/icons/up_off.gif" width="9" height="6" border="0"></cfif><cfif request.rstop.currentrow lt request.rstop.recordcount><a href="index.cfm?fuseaction=cArch.order&contentid=#request.rstop.contentid#&parentid=#request.rstop.parentid#&direction=up&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&startrow=#attributes.startrow#&moduleid=#attributes.moduleid#"><img src="images/icons/down_on.gif" width="9" height="6" border="0"></a><cfelse><img src="images/icons/down_off.gif" width="9" height="6" border="0"></cfif></td>	--->  
			   <td> 
	    <cfif request.rstop.Display and (request.rstop.Display eq 1 and request.rstop.approved and request.rstop.approved)>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#<cfelseif(request.rstop.Display eq 2 and request.rstop.approved and request.rstop.approved)>#LSDateFormat(request.rstop.displaystart,"short")# - #LSDateFormat(request.rstop.displaystop,"short")#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</cfif></td>
		<td>#LSDateFormat(request.rstop.lastupdate,session.dateKeyFormat)# #LSTimeFormat(request.rstop.lastupdate,"medium")#</td>
          <td class="administration">
			<ul class="#lcase(request.rstop.type)#">
				<cfif verdict neq 'none'>
				<li class="edit">
					<a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#request.rstop.contentid#" data-contenthistid="#request.rstop.contenthistid#"title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&contentid=#request.rstop.ContentID#&type=#request.rstop.type#&parentid=#request.rstop.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</a></li>
					<li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#" href="index.cfm?fuseaction=cArch.hist&contentid=#request.rstop.ContentID#&type=#request.rstop.type#&parentid=#request.rstop.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</a></li>
					<cfif attributes.moduleid eq '00000000000000000000000000000000004'>
						<li class="manageData"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#" href="index.cfm?fuseaction=cArch.datamanager&contentid=#request.rstop.ContentID#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&contenthistid=#request.rstop.ContentHistID#&topid=#URLEncodedFormat(attributes.topid)#&parentid=#URLEncodedFormat(attributes.parentid)#&type=Form">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</a></li>
					</cfif>
					<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
						<li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#" href="index.cfm?fuseaction=cPerm.main&contentid=#request.rstop.ContentID#&type=#request.rstop.type#&parentid=#request.rstop.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a>
					<cfelse>
						<li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li>
					</cfif>
				<cfelse>
					<li class="editOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#</li>
					<li class="versionHistoryOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</li>
					<cfif attributes.moduleid eq '00000000000000000000000000000000004'>
						<li class="manageDataOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</li>
					</cfif>
					<li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li>
				</cfif>
				<cfif ((attributes.locking neq 'all') or (attributes.parentid eq '#attributes.topid#' and attributes.locking eq 'none')) and (verdict eq 'editor') and not request.rsTop.isLocked eq 1>
					<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?fuseaction=cArch.update&contentid=#request.rstop.ContentID#&type=#request.rstop.type#&action=deleteall&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&parentid=#URLEncodedFormat(attributes.parentid)#" onClick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</a></li>
				<cfelseif attributes.locking neq 'all'>
					<li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#</li>
				</cfif>
			</ul></td></tr>
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="7" class="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.noitemsinsection')#</cfoutput></td>
      </tr>
    </cfif>
	
  <!---   <cfif request.nextn.numberofpages gt 1><tr> 
      <td colspan="7" class="noResults">More Results: <cfloop from="1"  to="#request.nextn.numberofpages#" index="i"><cfoutput><cfif request.nextn.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&topid=#URLEncodedFormat(attributes.topid)#&startrow=#evaluate('(#i#*#request.nextn.recordsperpage#)-#request.nextn.recordsperpage#+1')#&sortBy=#attributes.sortBy#&sortDirection=#attributes.sortDirection#&searchString=#attributes.searchString#">#i#</a> </cfif></cfoutput></cfloop></td></tr></cfif> --->
  </table>
</td></tr></table>

  <cfif request.nextn.numberofpages gt 1>
    <cfoutput> 
 	#application.rbFactory.getKeyValue(session.rb,'sitemanager.moreresults')#: 
		
		 <cfif request.nextN.currentpagenumber gt 1> <a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&topid=#URLEncodedFormat(attributes.topid)#&startrow=#request.nextN.previous#&sortBy=#attributes.sortBy#&sortDirection=#attributes.sortDirection#&searchString=#attributes.searchString#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.prev')#</a></cfif>
		<cfloop from="#request.nextn.firstPage#"  to="#request.nextn.lastPage#" index="i"><cfif request.nextn.currentpagenumber eq i> #i# <cfelse> <a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&topid=#URLEncodedFormat(attributes.topid)#&startrow=#evaluate('(#i#*#request.nextn.recordsperpage#)-#request.nextn.recordsperpage#+1')#&sortBy=#attributes.sortBy#&sortDirection=#attributes.sortDirection#&searchString=#attributes.searchString#">#i#</a> </cfif></cfloop>
		 <cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages><a href="index.cfm?fuseaction=cArch.list&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&topid=#URLEncodedFormat(attributes.topid)#&startrow=#request.nextN.next#&sortBy=#attributes.sortBy#&sortDirection=#attributes.sortDirection#&searchString=#attributes.searchString#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.next')#&nbsp;&raquo;</a></cfif>
		</cfoutput>
   </cfif>
<cfinclude template="draftpromptjs.cfm">
