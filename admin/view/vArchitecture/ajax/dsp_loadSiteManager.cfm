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
<cfset data=structNew()>

<cfif not isDefined("attributes.sortby") or attributes.sortby eq "">
	<cfset attributes.sortBy=request.rstop.sortBy>
</cfif>

<cfif not isDefined("attributes.sortdirection") or attributes.sortdirection eq "">
	<cfset attributes.sortdirection=request.rstop.sortdirection>
</cfif>

<cfparam name="attributes.sortDirection" default="#request.rstop.sortDirection#" />
<cfparam name="attributes.sorted" default="false" />
<cfparam name="attributes.toggle" default="true" />
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
<cfparam name="session.openSectionList" default="">

<cfset request.rowNum=0>
<cfset request.menulist=attributes.topid>
<cfset crumbdata=application.contentManager.getCrumbList(attributes.topid,attributes.siteid)>
<cfset perm=application.permUtility.getnodePerm(crumbdata)>
<cfset r=application.permUtility.setRestriction(crumbdata).restrict>
<cfset rsNext=application.contentManager.getNest('#attributes.topid#',attributes.siteid,attributes.sortBy,attributes.sortDirection)>
<cfinclude template="dsp_nextn.cfm">
<cfif  ((attributes.topid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(attributes.siteid).getlocking() eq 'none') or (attributes.topid neq '00000000000000000000000000000000001')) and perm neq 'none' and application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all'>
  <cfset newcontent=1>
  <cfelse>
  <cfset newcontent=0>
</cfif>
<cfif request.rsTop.type eq 'File'>
	<cfset icon=lcase(request.rsTop.fileExt)>
	<cfif r>
		<cfset icon=icon & "Locked">
	</cfif>
<cfelse>
	<cfset icon=request.rsTop.type>
	<cfif r>
		<cfset icon="#icon#Locked">
	</cfif>
	<cfset icon=icon & " " & request.rsTop.subtype>
</cfif>
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>	
</cfsilent>

<cfsavecontent variable="data.html">
<cfoutput>
<cfif attributes.type neq 'Component' and attributes.type neq 'Creative'  and attributes.type neq 'Form'>
    #application.contentRenderer.dspZoom(crumbdata=crumbdata,ajax=true)#
</cfif>
  <cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(attributes.siteid)>
  <form novalidate="novalidate" class="viewUpdate" name="viewUpdate" method="post" action="./index.cfm?fuseaction=cArch.list&siteid=#urlEncodedFormat(attributes.siteID)#&moduleid=#urlEncodedFormat(attributes.moduleID)#&topid=#urlEncodedFormat(attributes.topID)#">
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
      <cfif attributes.topid neq '00000000000000000000000000000000001' 
	  	  and (
	  	  		perm eq 'Editor' 
					or 
				(perm eq 'Author' and application.configBean.getSortPermission() eq "author") 
			  )>
        <dt class="sort">#application.rbFactory.getKeyValue(session.rb,"sitemanager.sortnavigation")#</dt>
        <dd class="sort">
          <input type="hidden" name="saveSort" value="true">
          <select name="sortBy" class="dropdown" onchange="setAsSorted();">
            <option value="orderno" <cfif attributes.sortBy eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.manual")#</option>
            <option value="releaseDate" <cfif attributes.sortBy eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.releasedate")#</option>
            <option value="lastUpdate" <cfif attributes.sortBy eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.updatedate")#</option>
            <option value="created" <cfif attributes.sortBy eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.created")#</option>
            <option value="menuTitle" <cfif attributes.sortBy eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.menutitle")#</option>
            <option value="title" <cfif attributes.sortBy eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.longtitle")#</option>
            <option value="rating" <cfif attributes.sortBy eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.rating")#</option>
            <option value="comments" <cfif attributes.sortBy eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.comments")#</option>
            <cfloop query="rsExtend">
              <option value="#HTMLEditFormat(rsExtend.attribute)#" <cfif attributes.sortBy eq rsExtend.attribute>selected</cfif>>#rsExtend.Type#/#rsExtend.subType# - #rsExtend.attribute#</option>
            </cfloop>
          </select>
          <select name="sortDirection" class="dropdown" onchange="setAsSorted();">
            <option value="asc" <cfif attributes.sortDirection eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.ascending")#</option>
            <option value="desc" <cfif attributes.sortDirection eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.descending")#</option>
          </select>
        </dd>
      </cfif>
      <dd <cfif attributes.topid neq '00000000000000000000000000000000001' and perm eq 'Editor'>class="button"</cfif>><input type="button" class="submit" id="submitSort" onclick="submitForm(document.forms.viewUpdate);" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.update")#" /></dd>
    </dl>
    <input type="hidden" name="startrow" value="#attributes.startrow#">
    <input type="hidden" name="orderperm" value="#perm#">
	<input type="hidden" id="sorted" name="sorted" value="false">
    
    <!-- Begin Grid Header -->
    <div class="mura-grid stripe<cfif attributes.sortBy neq 'orderno'> noDrag</cfif>">
    <dl class="mura-grid-hdr">
      <dt><span class="add"></span><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.title")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerTitle")#</span></a></dt>
      <cfif application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all'>
        <!---
		<cfif attributes.sortBy eq 'orderno'>
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
    <li data-siteid="#rc.siteid#" data-contentid="#request.rstop.contentid#" data-contenthistid="#request.rstop.contenthistid#" data-moduleid="#HTMLEditFormat(attributes.moduleid)#" data-sortby="#request.rstop.sortby#" data-sortdirection="#request.rstop.sortdirection#">
      <dl id="top-node">
      <dt>
       
       <a  class="add" href="javascript:;" onmouseover="showMenu('newContentMenu',#newcontent#,this,'#request.rstop.contentid#','#attributes.topid#','#request.rstop.parentid#','#attributes.siteid#','#request.rstop.type#');">&nbsp;</a>
   
       <cfif request.rstop.haskids>
	    	<span class="hasChildren-open" onclick="loadSiteManager('#JSStringFormat(attributes.siteID)#','#JSStringFormat(attributes.topid)#','#JSStringFormat(attributes.moduleid)#','#JSStringFormat(attributes.sortby)#','#JSStringFormat(attributes.sortdirection)#','#JSStringFormat(request.rstop.type)#',1);"></span>
		</cfif>
        <cfif perm neq 'none'>
          <a class="#icon# title draftprompt" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&siteid=#URLEncodedFormat(attributes.siteid)#&contentid=#attributes.topid#&topid=#URLEncodedFormat(attributes.topid)#&type=#request.rstop.type#&parentid=#request.rstop.parentid#&moduleid=#attributes.moduleid#">
        <cfelse>
		  <a class="#icon# title">
		</cfif>
		#HTMLEditFormat(left(request.rsTop.menutitle,70))#
        <cfif len(request.rsTop.menutitle) gt 70>&hellip;</cfif>
          </a>
        <div class="mura-title-fade"></div>
      </dt>
     <cfif application.settingsManager.getSite(attributes.siteid).getlocking() neq 'all'>
        <!---
		<cfif attributes.sortBy eq 'orderno'>
          <dd class="order">&nbsp;</dd>
        </cfif>
		--->
        <dd class="objects">
        	<cfif perm eq 'editor'><a class="mura-quickEditItem<cfif request.rstop.Display eq 2 and request.rstop.approved> scheduled</cfif>" data-attribute="inheritObjects"></cfif>
        	#application.rbFactory.getKeyValue(session.rb,"sitemanager.#lcase(request.rstop.inheritObjects)#")#</dd>
       		<cfif perm eq 'editor'></a></cfif>
	    <dd class="display<cfif request.rstop.Display eq 2 and request.rstop.approved> scheduled</cfif>">
			<cfif perm eq 'editor'><a class="mura-quickEditItem<cfif request.rstop.Display eq 2 and request.rstop.approved> tooltip</cfif>" data-attribute="display"></cfif>
			<cfif request.rstop.Display eq 1 and request.rstop.approved >
            	#application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#
            <cfelseif request.rstop.Display eq 2 and request.rstop.approved>
           	 	<cfif perm neq 'editor'><a href="##" class="tooltip"></cfif><span>#LSDateFormat(request.rstop.displaystart,"short")#&nbsp;-&nbsp;#LSDateFormat(request.rstop.displaystop,"short")#</span><cfif perm neq 'editor'></a></cfif>
            <cfelse>
           		 #application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#
         	</cfif>
			<cfif perm eq 'editor'></a></cfif>
		</dd>
       <dd class="template">
	  		<cfif perm eq 'editor'><a class="mura-quickEditItem" data-attribute="template"></cfif>
			<cfif len(request.rstop.template) or len(request.rstop.childTemplate)>
				 <img class="icon" src="images/icons/template_24x24.png" /> 
			<cfelse>
           		#application.rbFactory.getKeyValue(session.rb,"sitemanager.inherit")#
         	 </cfif>
			<cfif perm eq 'editor'></a></cfif>
		</dd>
     </cfif>
      <dd class="nav">
	  	<cfif perm eq 'editor'><a class="mura-quickEditItem" data-attribute="isnav"></cfif>
		#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(request.rstop.isnav)#")#
	  	<cfif perm eq 'editor'></a></cfif>
	  </dd>
      <dd class="updated">#LSDateFormat(request.rstop.lastupdate,session.dateKeyFormat)# #LSTimeFormat(request.rstop.lastupdate,"medium")#</dd>
      <dd class="admin">
      	<ul>
          <cfif perm neq 'none'>
            <li class="edit"><a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#request.rstop.contentid#" data-contenthistid="#request.rstop.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&siteid=#URLEncodedFormat(attributes.siteid)#&contentid=#attributes.topid#&topid=#URLEncodedFormat(attributes.topid)#&type=#request.rstop.type#&parentid=#request.rstop.parentid#&moduleid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#</a></li>
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
            <li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#" href="index.cfm?fuseaction=cArch.hist&contentid=#request.rstop.ContentID#&type=#request.rstop.type#&parentid=#request.rstop.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#</a></li>
            <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
              <li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#" href="index.cfm?fuseaction=cPerm.main&contentid=#attributes.topid#&parentid=&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&type=#request.rstop.type#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
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
          </cfif>
		<cfset pluginEvent.setValue('type', request.rstop.type)>
        <cfset pluginEvent.setValue('filename', request.rstop.filename)>
        <cfset pluginEvent.setValue('contentid', request.rstop.contentid)>
        <cfset pluginEvent.setValue('contenthistid', request.rstop.contenthistid)>
		#application.pluginManager.renderScripts("onContentList",attributes.siteid,pluginEvent)# #application.pluginManager.renderScripts("on#request.rstop.type#List",attributes.siteid,pluginEvent)# #application.pluginManager.renderScripts("on#request.rstop.type##request.rstop.subtype#List",attributes.siteid,pluginEvent)#
        </ul></dd>
      </dl>
      
      <cfif request.rstop.hasKids and rsNext.recordcount>
        <cf_dsp_nest topid="#attributes.topid#" parentid="#attributes.topid#"  rsnest="#rsNext#" locking="#application.settingsManager.getSite(attributes.siteid).getlocking()#" nestlevel="1" perm="#perm#" siteid="#attributes.siteid#" moduleid="#attributes.moduleid#" restricted="#r#" viewdepth="1" nextn="#session.mura.nextN#" startrow="#attributes.startrow#" sortBy="#attributes.sortBy#" sortDirection="#attributes.sortDirection#" pluginEvent="#pluginEvent#">
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
<cfset data.sortBy=attributes.sortBy>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>