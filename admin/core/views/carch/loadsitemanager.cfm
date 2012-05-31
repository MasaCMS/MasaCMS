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
<cfset event=request.event>
<cfset request.layout=false>
<cfset data=structNew()>

<cfif not isDefined("rc.sortby") or rc.sortby eq "">
	<cfset rc.sortBy=rc.rstop.sortBy>
</cfif>

<cfif not isDefined("rc.sortdirection") or rc.sortdirection eq "">
	<cfset rc.sortdirection=rc.rstop.sortdirection>
</cfif>

<cfparam name="rc.sortDirection" default="#rc.rstop.sortDirection#" />
<cfparam name="rc.sorted" default="false" />
<cfparam name="rc.toggle" default="true" />
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
<cfparam name="session.openSectionList" default="">

<cfset request.rowNum=0>
<cfset request.menulist=rc.topid>
<cfset crumbdata=application.contentManager.getCrumbList(rc.topid,rc.siteid)>
<cfset perm=application.permUtility.getnodePerm(crumbdata)>
<cfset r=application.permUtility.setRestriction(crumbdata).restrict>
<cfset rsNext=application.contentManager.getNest('#rc.topid#',rc.siteid,rc.sortBy,rc.sortDirection)>
<cfinclude template="dsp_nextn.cfm">

<cfif  ((rc.topid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none') or (rc.topid neq '00000000000000000000000000000000001')) and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
  <cfset newcontent=perm>
<cfelseif perm neq 'none'>
  <cfset newcontent='read'>
<cfelse>
  <cfset newcontent='none'>
</cfif>

<cfif rc.rsTop.type eq 'File'>
	<cfset icon=lcase(rc.rsTop.fileExt)>
	<cfif r>
		<cfset icon=icon & "Locked">
	</cfif>
<cfelse>
	<cfset icon=rc.rsTop.type>
	<cfif r>
		<cfset icon="#icon#Locked">
	</cfif>
	<cfset icon=icon & " " & rc.rsTop.subtype>
</cfif>
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>	
</cfsilent>

<cfsavecontent variable="data.html">
<cfoutput>
<cfif rc.type neq 'Component' and rc.type neq 'Creative'  and rc.type neq 'Form'>
    #application.contentRenderer.dspZoom(crumbdata=crumbdata,ajax=true)#
</cfif>
  <cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(rc.siteid)>
  <form novalidate="novalidate" class="viewUpdate" name="viewUpdate" method="post" action="./index.cfm?muraAction=cArch.list&siteid=#urlEncodedFormat(rc.siteID)#&moduleid=#urlEncodedFormat(rc.moduleID)#&topid=#urlEncodedFormat(rc.topID)#">
    <h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"sitemanager.modifyview")#</h3>
    <dl id="mura-view-options" class="clearfix">
      <dt class="rows">#application.rbFactory.getKeyValue(session.rb,"sitemanager.rowsdisplayed")#</dt>
      <dd class="rows">
        <input name="nextN" value="#session.mura.nextN#" type="text" class="text" size="2" maxlength="4" />
      </dd>
    <!---  <dt class="viewDepth">#application.rbFactory.getKeyValue(session.rb,"sitemanager.levelsdisplayed")#</dt>
      <dd class="viewDepth">
        <input name="viewDepth" value="#session.mura.viewDepth#" type="text" class="text" size="2" maxlength="4" />
      </dd>--->
      <cfif rc.topid neq '00000000000000000000000000000000001' 
	  	  and (
	  	  		perm eq 'Editor' 
					or 
				(perm eq 'Author' and application.configBean.getSortPermission() eq "author") 
			  )>
        <dt class="sort">#application.rbFactory.getKeyValue(session.rb,"sitemanager.sortnavigation")#</dt>
        <dd class="sort">
          <input type="hidden" name="saveSort" value="true">
          <select name="sortBy" class="dropdown" onchange="setAsSorted();">
            <option value="orderno" <cfif rc.sortBy eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.manual")#</option>
            <option value="releaseDate" <cfif rc.sortBy eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.releasedate")#</option>
            <option value="lastUpdate" <cfif rc.sortBy eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.updatedate")#</option>
            <option value="created" <cfif rc.sortBy eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.created")#</option>
            <option value="menuTitle" <cfif rc.sortBy eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.menutitle")#</option>
            <option value="title" <cfif rc.sortBy eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.longtitle")#</option>
            <option value="rating" <cfif rc.sortBy eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.rating")#</option>
            <option value="comments" <cfif rc.sortBy eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.comments")#</option>
            <cfloop query="rsExtend">
              <option value="#HTMLEditFormat(rsExtend.attribute)#" <cfif rc.sortBy eq rsExtend.attribute>selected</cfif>>#rsExtend.Type#/#rsExtend.subType# - #rsExtend.attribute#</option>
            </cfloop>
          </select>
          <select name="sortDirection" class="dropdown" onchange="setAsSorted();">
            <option value="asc" <cfif rc.sortDirection eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.ascending")#</option>
            <option value="desc" <cfif rc.sortDirection eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.descending")#</option>
          </select>
        </dd>
      </cfif>
      <dd <cfif rc.topid neq '00000000000000000000000000000000001' and perm eq 'Editor'>class="button"</cfif>><input type="button" class="submit" id="submitSort" onclick="submitForm(document.forms.viewUpdate);" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.update")#" /></dd>
    </dl>
    <input type="hidden" name="startrow" value="#rc.startrow#">
    <input type="hidden" name="orderperm" value="#perm#">
	<input type="hidden" id="sorted" name="sorted" value="false">
    
    <!-- Begin Grid Header -->
    <div class="mura-grid stripe<cfif rc.sortBy neq 'orderno'> noDrag</cfif>">
    <dl class="mura-grid-hdr">
      <dt><span class="add"></span><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.title")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerTitle")#</span></a></dt>
      <cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
        <!---
		<cfif rc.sortBy eq 'orderno'>
          <dd class="order"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.order")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerOrder")#</span></a></dd>
        </cfif>
		--->
        <dd class="objects"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.objects")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerObjects")#</span></a></dd>
        <dd class="display"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.display")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerDisplay")#</span></a></dd>
        <dd class="template"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.template")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerTemplate")#</span></a></dd>
      </cfif>
      <dd class="nav"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.nav")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerNav")#</span></a></dd>
      <dd class="updated"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.updated")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerUpdated")#</span></a></dd>
      <dd class="admin">&nbsp;</dd>
    </dl>
    <ul id="mura-nodes">
    <!-- Begin List of Nodes -->
    <li data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#" data-moduleid="#HTMLEditFormat(rc.moduleid)#" data-sortby="#rc.rstop.sortby#" data-sortdirection="#rc.rstop.sortdirection#">
      <dl id="top-node">
      <dt>
       
       <a  class="add" href="javascript:;" onmouseover="showMenu('newContentMenu','#newcontent#',this,'#rc.rstop.contentid#','#rc.topid#','#rc.rstop.parentid#','#rc.siteid#','#rc.rstop.type#');">&nbsp;</a>
   
       <cfif isNumeric(rc.rstop.haskids) and rc.rstop.haskids>
	    	<span class="hasChildren-open" onclick="loadSiteManager('#JSStringFormat(rc.siteID)#','#JSStringFormat(rc.topid)#','#JSStringFormat(rc.moduleid)#','#JSStringFormat(rc.sortby)#','#JSStringFormat(rc.sortdirection)#','#JSStringFormat(rc.rstop.type)#',1);"></span>
		</cfif>
        <cfif not listFindNoCase('none,read',perm)>
          <a class="#icon# title draftprompt" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&siteid=#URLEncodedFormat(rc.siteid)#&contentid=#rc.topid#&topid=#URLEncodedFormat(rc.topid)#&type=#rc.rstop.type#&parentid=#rc.rstop.parentid#&moduleid=#rc.moduleid#">
        <cfelse>
		  <a class="#icon# title">
		</cfif>
		#HTMLEditFormat(left(rc.rsTop.menutitle,70))#
        <cfif len(rc.rsTop.menutitle) gt 70>&hellip;</cfif>
          </a>
        <div class="mura-title-fade"></div>
      </dt>
     <cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
        <!---
		<cfif rc.sortBy eq 'orderno'>
          <dd class="order">&nbsp;</dd>
        </cfif>
		--->
        <dd class="objects">
        	<cfif perm eq 'editor'><a class="mura-quickEditItem<cfif rc.rstop.Display eq 2 and rc.rstop.approved> scheduled</cfif>" data-attribute="inheritObjects"></cfif>
        	#application.rbFactory.getKeyValue(session.rb,"sitemanager.#lcase(rc.rstop.inheritObjects)#")#</dd>
       		<cfif perm eq 'editor'></a></cfif>
	    <dd class="display<cfif rc.rstop.Display eq 2 and rc.rstop.approved> scheduled</cfif>">
			<cfif perm eq 'editor'><a class="mura-quickEditItem<cfif rc.rstop.Display eq 2 and rc.rstop.approved> tooltip</cfif>" data-attribute="display"></cfif>
			<cfif rc.rstop.Display eq 1 and rc.rstop.approved >
            	#application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#
            <cfelseif rc.rstop.Display eq 2 and rc.rstop.approved>
           	 	<cfif perm neq 'editor'><a href="##" class="tooltip"></cfif><span>#LSDateFormat(rc.rstop.displaystart,"short")#&nbsp;-&nbsp;#LSDateFormat(rc.rstop.displaystop,"short")#</span><cfif perm neq 'editor'></a></cfif>
            <cfelse>
           		 #application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#
         	</cfif>
			<cfif perm eq 'editor'></a></cfif>
		</dd>
       <dd class="template">
	  		<cfif perm eq 'editor'><a class="mura-quickEditItem" data-attribute="template"></cfif>
			<cfif len(rc.rstop.template) or len(rc.rstop.childTemplate)>
				 <img class="icon" src="images/icons/template_24x24.png" /> 
			<cfelse>
           		#application.rbFactory.getKeyValue(session.rb,"sitemanager.inherit")#
         	 </cfif>
			<cfif perm eq 'editor'></a></cfif>
		</dd>
     </cfif>
      <dd class="nav">
	  	<cfif perm eq 'editor'><a class="mura-quickEditItem" data-attribute="isnav"></cfif>
		#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(rc.rstop.isnav)#")#
	  	<cfif perm eq 'editor'></a></cfif>
	  </dd>
      <dd class="updated">#LSDateFormat(rc.rstop.lastupdate,session.dateKeyFormat)# #LSTimeFormat(rc.rstop.lastupdate,"medium")#</dd>
      <dd class="admin">
      	<ul>
          <cfif not listFindNoCase('none,read',perm)>
            <li class="edit"><a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&siteid=#URLEncodedFormat(rc.siteid)#&contentid=#rc.topid#&topid=#URLEncodedFormat(rc.topid)#&type=#rc.rstop.type#&parentid=#rc.rstop.parentid#&moduleid=#rc.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#</a></li>
            <cfswitch expression="#rc.rsTop.type#">
              <cfcase value="Page,Portal,Calendar,Gallery">
              <li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,rc.rsTop.filename)#','#rc.rsTop.targetParams#');">#HTMLEditFormat(left(rc.rsTop.menutitle,70))#</a></li>
              </cfcase>
              <cfcase value="Link">
              <li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('#rc.rsTop.filename#','#rc.rsTop.targetParams#');">#HTMLEditFormat(left(rc.rsTop.menutitle,70))#</a></li>
              </cfcase>
              <cfcase value="File">
              <li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?LinkServID=#rc.rsTop.contentid#','#rc.rsTop.targetParams#');">#HTMLEditFormat(left(rc.rsTop.menutitle,70))#</a></li>
              </cfcase>
            </cfswitch>
            <li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#</a></li>
            <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
              <li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#" href="index.cfm?muraAction=cPerm.main&contentid=#rc.topid#&parentid=&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&type=#rc.rstop.type#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
              <cfelse>
              <li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
            </cfif>
            <cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
              <li class="deleteOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.delete")#</a></li>
            </cfif>
            <cfelse>
            <li class="editOff"><a>Edit</a></li>
            <cfswitch expression="#rc.rsTop.type#">
              <cfcase value="Page,Portal,Calendar,Gallery">
              <li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,rc.rsTop.filename)#','#rc.rsTop.targetParams#');">#left(rc.rsTop.menutitle,70)#</a></li>
              </cfcase>
              <cfcase value="Link">
              <li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('#rc.rsTop.filename#','#rc.rsTop.targetParams#');">#left(rc.rsTop.menutitle,70)#</a></li>
              </cfcase>
              <cfcase value="File">
              <li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('http://#application.settingsManager.getSite(rc.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rc.siteid,"")#?LinkServID=#rc.rsTop.contentid#','#rc.rsTop.targetParams#');">#left(rc.rsTop.menutitle,70)#</a></li>
              </cfcase>
            </cfswitch>
            <li class="versionHistoryOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#</a></li>
            <li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
            <li class="deleteOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.delete")#</a></li>
          </cfif>
		<cfset pluginEvent.setValue('type', rc.rstop.type)>
        <cfset pluginEvent.setValue('filename', rc.rstop.filename)>
        <cfset pluginEvent.setValue('contentid', rc.rstop.contentid)>
        <cfset pluginEvent.setValue('contenthistid', rc.rstop.contenthistid)>
		#application.pluginManager.renderScripts("onContentList",rc.siteid,pluginEvent)# #application.pluginManager.renderScripts("on#rc.rstop.type#List",rc.siteid,pluginEvent)# #application.pluginManager.renderScripts("on#rc.rstop.type##rc.rstop.subtype#List",rc.siteid,pluginEvent)#
        </ul></dd>
      </dl>
      
      <cfif isNumeric(rc.rstop.haskids) and rc.rstop.hasKids and rsNext.recordcount>
        <cf_dsp_nest topid="#rc.topid#" parentid="#rc.topid#"  rsnest="#rsNext#" locking="#application.settingsManager.getSite(rc.siteid).getlocking()#" nestlevel="1" perm="#perm#" siteid="#rc.siteid#" moduleid="#rc.moduleid#" restricted="#r#" viewdepth="1" nextn="#session.mura.nextN#" startrow="#rc.startrow#" sortBy="#rc.sortBy#" sortDirection="#rc.sortDirection#" pluginEvent="#pluginEvent#">
      </cfif>
      </li>
      </ul>
      </div>
  </form>
  <cfif isMore>
	#pageList#
  </cfif>
</cfoutput>
</cfsavecontent>
<cfset data.perm=perm>
<cfset data.sortBy=rc.sortBy>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>

