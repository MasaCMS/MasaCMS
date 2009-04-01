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


<cfsilent>
<cfset crumbdata=application.contentManager.getCrumbList(attributes.topid,attributes.siteid)>
<cfif isdefined('attributes.viewDepth') and attributes.viewDepth gt 0>
<cfset session.viewDepth=attributes.viewDepth><cfset session.nextN=attributes.nextN><cfset attributes.startrow=1>
</cfif>

<cfif not isDefined('attributes.saveSort')>
<cfset attributes.sortBy=request.rstop.sortBy />
<cfset attributes.sortDirection=request.rstop.sortDirection />
</cfif>

<cfparam name="attributes.sortBy" default="#request.rstop.sortBy#" />
<cfparam name="attributes.sortDirection" default="#request.rstop.sortDirection#" />
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">

<cfif isdefined('attributes.orderperm') and attributes.orderperm eq 'editor'>
<cflock type="exclusive" name="editingContent#attributes.siteid#" timeout="60">

<cfif isdefined('attributes.orderid') >
<cfloop from="1" to="#listlen(attributes.orderid)#" index="i">
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
update tcontent set orderno= #listgetat(attributes.orderno,i)# where contentid ='#listgetat(attributes.orderid,i)#'
</cfquery>
</cfloop>
</cfif>

<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
update tcontent set sortBy='#attributes.sortBy#',sortDirection='#attributes.sortDirection#' where contentid ='#attributes.topid#'
</cfquery>

<cfif attributes.sortBy eq 'orderno' and  not isdefined('attributes.orderid')>
<cfset rsSetOrder=application.contentManager.getNest('#attributes.topid#',attributes.siteid,request.rsTop.sortBy,request.rsTop.sortDirection)>
<cfloop query="rsSetOrder">
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
update tcontent set orderno= #rsSetOrder.currentrow# where contentid ='#rsSetOrder.contentID#'
</cfquery>
</cfloop>
</cfif>

<cfset application.settingsManager.getSite(attributes.siteid).purgeCache()>
</cflock>
</cfif>

<cfif not len(crumbdata[1].siteid)>
	<cflocation url="index.cfm?fuseaction=cDashboard.main&siteid=#attributes.siteID#&span=30" addtoken="false"/>
</cfif>
<cfset request.rowNum=0>
<cfset request.menulist=attributes.topid>
<cfset perm=application.permUtility.getnodePerm(crumbdata)>
<cfset r=application.permUtility.setRestriction(crumbdata).restrict>
<cfset rsNext=application.contentManager.getNest('#attributes.topid#',attributes.siteid,attributes.sortBy,attributes.sortDirection)>
	
<cfinclude template="dsp_nextn.cfm">
<cfif  ((attributes.topid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(attributes.siteid).getlocking() eq 'none') or (attributes.topid neq '00000000000000000000000000000000001')) and perm neq 'none' and application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all'><cfset newcontent=1><cfelse> <cfset newcontent=0></cfif>
<cfif r><cfset icon="#request.rsTop.type#Locked"><cfelse><cfset icon="#request.rsTop.type#"></cfif>
</cfsilent><cfoutput>
<script>
copyContentID = '#session.copyContentID#';
copySiteID = '#session.copySiteID#';
</script>
<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sitemanager")#</h2>
<form id="siteSearch" name="siteSearch" method="get"><h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.contentsearch")#</h3><input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" align="absmiddle" />  
	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.search")#</span></a>
	<input type="hidden" name="fuseaction" value="cArch.search">
	<input type="hidden" name="siteid" value="#attributes.siteid#">
	<input type="hidden" name="moduleid" value="#attributes.moduleid#">
	
</form>
<cfif attributes.type neq 'Component' and attributes.type neq 'Creative'  and attributes.type neq 'Form'>#application.contentRenderer.dspZoom(crumbdata)#</cfif>
<form id="viewUpdate" name="viewUpdate" method="post"><h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"sitemanager.modifyview")#</h3><dl class="clearfix"><dt class="rows">#application.rbFactory.getKeyValue(session.rb,"sitemanager.rowsdisplayed")#</dt><dd class="rows"><input name="nextN" value="#session.nextN#" type="text" class="text" size="2" maxlength="4" /></dd><dt class="viewDepth">#application.rbFactory.getKeyValue(session.rb,"sitemanager.levelsdisplayed")#</dt><dd class="viewDepth"><input name="viewDepth" value="#session.viewDepth#" type="text" class="text" size="2" maxlength="4" /></dd><cfif attributes.topid neq '00000000000000000000000000000000001' and perm eq 'Editor'><dt class="sort">#application.rbFactory.getKeyValue(session.rb,"sitemanager.sortnavigation")#</dt><dd class="sort">
							<input type="hidden" name="saveSort" value="true">
							<select name="sortBy" class="dropdown">
		 					<option value="orderno" <cfif attributes.sortBy eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.manual")#</option>
							<option value="releaseDate" <cfif attributes.sortBy eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.releasedate")#</option>
							<option value="lastUpdate" <cfif attributes.sortBy eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.updatedate")#</option>
							<option value="menuTitle" <cfif attributes.sortBy eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.menutitle")#</option>
							<option value="title" <cfif attributes.sortBy eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.longtitle")#</option>
							<option value="rating" <cfif attributes.sortBy eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.rating")#</option>
							<option value="comments" <cfif attributes.sortBy eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.comments")#</option>
							</select>
							<select name="sortDirection" class="dropdown">
		 					<option value="asc" <cfif attributes.sortDirection eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.ascending")#</option>
							<option value="desc" <cfif attributes.sortDirection eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.descending")#</option>
							</select></dd></cfif><dd <cfif attributes.topid neq '00000000000000000000000000000000001' and perm eq 'Editor'>class="button"</cfif>><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.viewUpdate);"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.update")#</span></a></dd></dl>
	
	<input type="hidden" name="startrow" value="#attributes.startrow#">
	<input type="hidden" name="orderperm" value="#perm#">
</cfoutput>

<table class="stripe"> 
          <tr><cfoutput>
           <th>&nbsp;</th>
            <th class="varWidth"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.title")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerTitle")#</span></a></th>
			<cfif application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all'>
             <cfif attributes.sortBy eq 'orderno'><th class="order"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.order")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerOrder")#</span></a></th></cfif>
			 <th><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.objects")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerObjects")#</span></a></th>
			<th><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.display")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerDisplay")#</span></a></th>
			<th><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.feature")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerFeature")#</span></a></th>
			</cfif>
		  <th><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.nav")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerNav")#</span></a></th>
       <th><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.updated")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerUpdated")#</span></a></th>
           <th class="administration">&nbsp;</th>
          </tr>
         
		  <tr>
           <td class="add"> <cfif (request.rstop.type eq 'Page') or  (request.rstop.type eq 'Portal')  or  (request.rstop.type eq 'Calendar')  or  (request.rstop.type eq 'Gallery')><a href="javascript:;" onmouseover="showMenu('newContentMenu',#newcontent#,this,'#request.rstop.contentid#','#attributes.topid#','#request.rstop.parentid#','#attributes.siteid#','#request.rstop.type#');">&nbsp;</a><cfelse>&nbsp;</cfif></td>
            <td class="varWidth"><ul <cfif request.rstop.hasKids gt 0>class="neston"<cfelse>class="nestoff"</cfif>>
			<li class="#icon#"><cfif perm neq 'none'><a title="Edit" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&siteid=#attributes.siteid#&contentid=#attributes.topid#&topid=#attributes.topid#&type=#request.rstop.type#&parentid=#request.rstop.parentid#&moduleid=#attributes.moduleid#"></cfif>#HTMLEditFormat(left(request.rsTop.menutitle,70))#<cfif len(request.rsTop.menutitle) gt 70>...</cfif><cfif perm neq 'none'></a></cfif></li>
			</ul></td>			
		 <cfif application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all'>
		 <cfif attributes.sortBy eq 'orderno'><td class="order">&nbsp;</td></cfif>
		 <td>#application.rbFactory.getKeyValue(session.rb,"sitemanager.#lcase(request.rstop.inheritObjects)#")#</td> 
        <td><cfif request.rstop.Display gt 0 and (request.rstop.Display eq 1 and request.rstop.approved and request.rstop.approved)>#application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#<cfelseif(request.rstop.Display eq 2 and request.rstop.approved and request.rstop.approved)>#LSDateFormat(request.rstop.displaystart,"short")#&nbsp;-&nbsp;#LSDateFormat(request.rstop.displaystop,"short")#<cfelse>#application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#</cfif></td>
		<td>#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(request.rstop.isfeature)#")#</td> 
		</cfif>
<td>#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(request.rstop.isnav)#")#</td>
<td>#LSDateFormat(request.rstop.lastupdate,session.dateKeyFormat)#</td>
<td class="administration"><ul class="siteSummary"><cfif perm neq 'none'>
        <li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&siteid=#attributes.siteid#&contentid=#attributes.topid#&topid=#attributes.topid#&type=#request.rstop.type#&parentid=#request.rstop.parentid#&moduleid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#</a></li>
		<cfswitch expression="#request.rsTop.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,request.rsTop.filename)#','#request.rsTop.targetParams#');">#HTMLEditFormat(left(request.rsTop.menutitle,70))#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('#request.rsTop.filename#','#request.rsTop.targetParams#');">#HTMLEditFormat(left(request.rsTop.menutitle,70))#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#request.rsTop.contentid#','#request.rsTop.targetParams#');">#HTMLEditFormat(left(request.rsTop.menutitle,70))#</a></li>
		</cfcase>
		</cfswitch>
		<li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#" href="index.cfm?fuseaction=cArch.hist&contentid=#request.rstop.ContentID#&type=#request.rstop.type#&parentid=#request.rstop.parentID#&topid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#</a></li>
        <cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')>
			<li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#" href="index.cfm?fuseaction=cPerm.main&contentid=#attributes.topid#&parentid=&topid=#attributes.topid#&siteid=#attributes.siteid#&moduleid=#attributes.moduleid#&type=#request.rstop.type#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
       	<cfelse>
			<li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
		 </cfif>
        <cfif application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all'>
          <li class="deleteOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.delete")#</a></li>
        </cfif>
        <cfelse>
        <li class="editOff"><a>Edit</a></li>
		<cfswitch expression="#request.rsTop.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,request.rsTop.filename)#','#request.rsTop.targetParams#');">#left(request.rsTop.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('#request.rsTop.filename#','#request.rsTop.targetParams#');">#left(request.rsTop.menutitle,70)#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#request.rsTop.contentid#','#request.rsTop.targetParams#');">#left(request.rsTop.menutitle,70)#</a></li>
		</cfcase>
		</cfswitch>
		<li class="versionHistoryOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#</a></li>
		<li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
		<li class="deleteOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.delete")#</a></li>
      </cfif></ul></td>
</tr>
		  <cfif request.rstop.hasKids>
             <cf_dsp_nest topid="#attributes.topid#" parentid="#attributes.topid#"  rsnest="#rsNext#" locking="#application.settingsManager.getSite(attributes.siteid).getlocking()#" nestlevel="1" perm="#perm#" siteid="#attributes.siteid#" moduleid="#attributes.moduleid#" restricted="#r#" viewdepth="#session.viewDepth#" nextn="#session.nextN#" startrow="#attributes.startrow#" sortBy="#attributes.sortBy#" sortDirection="#attributes.sortDirection#">
           </cfif>
          <cfif isMore>
             #pageList#
           </cfif>
	</table></cfoutput>
</form>