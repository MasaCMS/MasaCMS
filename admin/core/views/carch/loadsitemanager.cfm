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

<cfset request.tabAssignments=$.getBean("user").loadBy(userID=session.mura.userID, siteID=session.mura.siteID).getContentTabAssignments()>
<cfset request.hasPublishingTab=not len(request.tabAssignments) or listFindNocase(request.tabAssignments,'Publishing')>
<cfset request.hasLayoutObjectsTab=not len(request.tabAssignments) or listFindNocase(request.tabAssignments,'Layout & Objects')>
<cfset request.rowNum=0>
<cfset request.menulist=rc.topid>
<cfset crumbdata=application.contentManager.getCrumbList(rc.topid,rc.siteid)>
<cfset perm=application.permUtility.getnodePerm(crumbdata)>
<cfset r=application.permUtility.setRestriction(crumbdata).restrict>
<cfset hasKids=application.contentManager.getKidsCount(rc.rstop.contentid,rc.rstop.siteid,false)>

<cfinclude template="dsp_nextN.cfm">

<cfif  ((rc.topid eq '00000000000000000000000000000000001' and application.settingsManager.getSite(rc.siteid).getlocking() eq 'none') or (rc.topid neq '00000000000000000000000000000000001')) and application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
  <cfset newcontent=perm>
<cfelseif perm neq 'none'>
  <cfset newcontent='read'>
<cfelse>
  <cfset newcontent='none'>
</cfif>

<cfif rc.rsTop.type eq 'File'>
  <cfset icon=application.classExtensionManager.getCustomIconClass(siteid=rc.rstop.siteid,type=rc.rstop.type,subtype=rc.rstop.subtype)>
  
  <cfif not len(icon)>
    <cfset icon=lcase(rc.rsTop.fileExt)>
  </cfif>

	<cfif r>
		<cfset icon=icon & " locked">
	</cfif>
<cfelse>
	<cfset icon=application.classExtensionManager.getCustomIconClass(siteid=rc.rstop.siteid,type=rc.rstop.type,subtype=rc.rstop.subtype)>
  <cfif not len(icon)>
    <cfset icon='icon-mura-' & rc.rstop.type>
  </cfif>
	<cfif r>
		<cfset icon="#icon# locked">
	</cfif>
	<cfset icon=icon & " " & rc.rsTop.subtype>
</cfif>
<cfset isFileIcon= rc.rsTop.type eq 'File' and listFirst(icon,"-") neq "icon">
<cfset session.flatViewArgs["#rc.siteID#"].tab=0>
<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>	
</cfsilent>

<cfsavecontent variable="data.html">
<cfoutput>
<cfif rc.type neq 'Component' and rc.type neq 'Creative'  and rc.type neq 'Form'>
    #$.dspZoom(crumbdata=crumbdata,ajax=true,class="navZoom alt")#
</cfif>
  <cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(rc.siteid)>

  <form novalidate="novalidate" class="viewUpdate clearfix" name="viewUpdate" method="post" action="./index.cfm?muraAction=cArch.list&siteid=#esapiEncode('url',rc.siteID)#&moduleid=#esapiEncode('url',rc.moduleID)#&topid=#esapiEncode('url',rc.topID)#">
  
  
  <div class="btn-group" id="sm-modify-view">
    <a class="btn dropdown-toggle" data-toggle="dropdown" href="">
      <i class="icon-eye-open"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.modifyview")#
      <span class="caret"></span>
    </a>
    <div class="dropdown-menu">
      	<!---  <h3>#application.rbFactory.getKeyValue(session.rb,'sitemanager.filterviewdesc')#</h3> --->
      	<label>#application.rbFactory.getKeyValue(session.rb,"sitemanager.rowsdisplayed")#</label>
        <cfif rc.topid neq '00000000000000000000000000000000001' 
          	  and (
          	  		perm eq 'Editor' 
        				or 
        			(perm eq 'Author' and application.configBean.getSortPermission() eq "author") 
        		  )>
            <input name="nextN" value="#session.mura.nextN#" type="text" class="input-small" size="2" maxlength="4" />
            #application.rbFactory.getKeyValue(session.rb,"sitemanager.sortnavigation")#
            <input type="hidden" name="saveSort" value="true">
              <select name="sortBy"  onchange="siteManager.setAsSorted();">
                <option value="orderno" <cfif rc.sortBy eq 'orderno'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.manual")#</option>
                <option value="releaseDate" <cfif rc.sortBy eq 'releaseDate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.releasedate")#</option>
                <option value="lastUpdate" <cfif rc.sortBy eq 'lastUpdate'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.updatedate")#</option>
                <option value="created" <cfif rc.sortBy eq 'created'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.created")#</option>
                <option value="menuTitle" <cfif rc.sortBy eq 'menuTitle'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.menutitle")#</option>
                <option value="title" <cfif rc.sortBy eq 'title'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.longtitle")#</option>
                <option value="rating" <cfif rc.sortBy eq 'rating'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.rating")#</option>
                <option value="comments" <cfif rc.sortBy eq 'comments'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.comments")#</option>
                <cfloop query="rsExtend">
                  <option value="#esapiEncode('html_attr',rsExtend.attribute)#" <cfif rc.sortBy eq rsExtend.attribute>selected</cfif>>#esapiEncode('html',rsExtend.Type)#/#esapiEncode('html',rsExtend.subType)# - #esapiEncode('html',rsExtend.attribute)#</option>
                </cfloop>
              </select>
              <select name="sortDirection"  onchange="siteManager.setAsSorted();">
                <option value="asc" <cfif rc.sortDirection eq 'asc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.ascending")#</option>
                <option value="desc" <cfif rc.sortDirection eq 'desc'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sort.descending")#</option>
              </select>
          <cfelse>
            <input name="nextN" value="#esapiEncode('html_attr',session.mura.nextN)#" type="text" class="text span4" size="2" maxlength="4" />
          </cfif>
          <!---<dd <cfif rc.topid neq '00000000000000000000000000000000001' and perm eq 'Editor'>class="button"</cfif>>--->
          <input type="button" class="btn" onclick="submitForm(document.forms.viewUpdate);" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.update")#" />
        <input type="hidden" name="startrow" value="#esapiEncode('html_attr',rc.startrow)#">
        <input type="hidden" name="orderperm" value="#perm#">
        <input type="hidden" id="sorted" name="sorted" value="false">
    </div>
  </div>

  <script>
    $(document).ready(function(){
      $('##sm-modify-view .dropdown-menu').click(function(e) {
        e.stopPropagation();
      })
    })
  </script>
  
  <cfif rc.moduleid eq '00000000000000000000000000000000000' and rc.sortBy eq 'orderno'>  
    <div class="alert" id="sitemgr-reorder" style="display:none">
  	When you're done re-ordering, click "Update." <input type="button" class="submit btn pulse" id="submitSort" onclick="submitForm(document.forms.viewUpdate);" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.update")#" />
  	</div>
  </cfif>

    <!-- Begin Grid Header -->
    <div class="mura-grid stripe<cfif rc.sortBy neq 'orderno'> no-manual-sort</cfif>">
    <dl class="mura-grid-hdr">
      <dt>
      		<span class="add"></span>
      		<a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.managerTitle"))#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.title")#</a>
      </dt>
      <cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
        <dd class="objects"><a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.managerObjects"))#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.objects")#</a></dd>
        <dd class="display"><a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.managerDisplay"))#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.display")#</a></dd>
        <dd class="template"><a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.managerTemplate"))#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.template")#</a></dd>
      </cfif>
      <dd class="nav"><a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.managerNav"))#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.nav")#</a></dd>
      <dd class="updated"><a href="##" rel="tooltip" title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.managerUpdated"))#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.updated")#</a></dd>
      <dd class="actions">&nbsp;</dd>
    </dl>
    <ul id="mura-nodes"<cfif arrayLen(crumbdata) gt 1 and crumbdata[2].type eq 'Gallery'> class="gallery"</cfif>>
    <!-- Begin List of Nodes -->
    <li data-siteid="#esapiEncode('html_attr',rc.siteid)#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#" data-moduleid="#esapiEncode('html_attr',rc.moduleid)#" data-sortby="#esapiEncode('html_attr',rc.rstop.sortby)#" data-sortdirection="#esapiEncode('html_attr',rc.rstop.sortdirection)#" class="#esapiEncode('html_attr',lcase(rc.rstop.type))# mura-node-data<cfif r> restricted</cfif>" data-csrf="#rc.$.renderCSRFTOkens(context=rc.rstop.contentid & 'quickedit',format='url')#">
     <cfif r><div class="marker"></div></cfif>
      <dl id="top-node">
      <dt>

       <a class="add" href="javascript:;" onmouseover="siteManager.showMenu('newContentMenu','#newcontent#',this,'#rc.rstop.contentid#','#rc.topid#','#rc.rstop.parentid#','#rc.siteid#','#rc.rstop.type#');"><i class="icon-plus-sign"></i></a>
      
        <cfif hasKids>
	    	<span class="hasChildren open" onclick="siteManager.loadSiteManager('#esapiEncode('javascript',rc.siteID)#','#esapiEncode('javascript',rc.topid)#','#esapiEncode('javascript',rc.moduleid)#','#esapiEncode('javascript',rc.sortby)#','#esapiEncode('javascript',rc.sortdirection)#','#esapiEncode('javascript',rc.rstop.type)#',1);"></span>
		</cfif>

      <cfsilent>
      <cfif  perm neq 'none' and listFindNoCase("jpg,jpeg,png,gif",listLast(rc.rsTop.assocfilename,"."))>
        <cfset atooltip=true>
        <cfset atitle="<img class='image-preview' src='#$.getURLForImage(fileid=rc.rsTop.fileid,size='small',siteid=rc.rsTop.siteid,fileext=rc.rsTop.fileExt)#'/>">
      <cfelse>
        <cfset atooltip=false>
        <cfset atitle=application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")>
      </cfif>
    </cfsilent>
		
        <cfif not listFindNoCase('none,read',perm)>
          <a class="<cfif isFileIcon>file #lcase(icon)#<cfelse>#lcase(icon)#</cfif> title draftprompt" title="#atitle#" href="./?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&siteid=#esapiEncode('url',rc.siteid)#&contentid=#rc.topid#&topid=#esapiEncode('url',rc.topid)#&type=#rc.rstop.type#&parentid=#rc.rstop.parentid#&moduleid=#rc.moduleid#"<cfif rc.rsTop.type eq 'File'> data-filetype="#lcase(left(rc.rsTop.fileExt,4))#"</cfif> <cfif atooltip>rel="tooltip" data-html="true"</cfif>>
        <cfelse>
		      <a class="#icon# title" <cfif rc.rsTop.type eq 'File'> data-filetype="#lcase(left(rc.rsTop.fileExt,4))#"</cfif> <cfif atooltip>rel="tooltip" data-html="true" title="#atitle#"</cfif>>
		    </cfif>
		#esapiEncode('html',left(rc.rsTop.menutitle,75))#
        <cfif len(rc.rsTop.menutitle) gt 75>&hellip;</cfif>
          </a>
        <!--- <div class="mura-title-fade"></div> --->
      </dt>
     <cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
        <!---
		<cfif rc.sortBy eq 'orderno'>
          <dd class="order">&nbsp;</dd>
        </cfif>
		--->
      <dd class="objects">
          <cfif perm eq 'editor' and request.hasLayoutObjectsTab>
            <a class="mura-quickEditItem<cfif rc.rstop.Display eq 2 and rc.rstop.approved> scheduled</cfif>" data-attribute="inheritObjects">
          </cfif>
        	<cfif rc.rstop.inheritObjects eq 'cascade'>
				<i class="icon-arrow-down" title="#rc.rstop.inheritObjects#"></i>
				<cfelseif rc.rstop.inheritObjects eq 'reject'>
					<i class="icon-ban-circle" title="#rc.rstop.inheritObjects#"></i>
				<cfelse>
					<span class="bullet" title="#rc.rstop.inheritObjects#">&bull;</span>
			</cfif>
			 <span>#rc.rstop.inheritObjects#</span>
        	
       		<cfif perm eq 'editor' and request.hasLayoutObjectsTab></a></cfif>
      </dd>
      
	    <dd class="display<cfif rc.rstop.Display eq 2 and rc.rstop.approved> scheduled</cfif>">
	    
			 <cfif perm eq 'editor' and request.hasPublishingTab>
          <a class="mura-quickEditItem<cfif rc.rstop.Display eq 2 and rc.rstop.approved> tooltip</cfif>" data-attribute="display"></cfif>
					
			<cfif rc.rstop.Display eq 1 and rc.rstop.approved >
            	<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#"></i><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#</span>
            <cfelseif rc.rstop.Display eq 2 and rc.rstop.approved>
           	 	<cfif not (perm eq 'editor' and request.hasPublishingTab)>
           	 		<a href="##" rel="tooltip" title="#esapiEncode('html_attr','#LSDateFormat(rc.rstop.displaystart,"short")#&nbsp;-&nbsp;#LSDateFormat(rc.rstop.displaystop,"short")#')#"></a>
           	 	 </cfif>
           	 	 <i class="icon-calendar"></i>
           	 	 <cfif not (perm eq 'editor' and request.hasPublishingTab)></a></cfif>
           	 <cfelse>
           		 <i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#"></i><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#</span>
           		</cfif>
			<cfif perm eq 'editor'and request.hasPublishingTab></a></cfif>
			<!--- <i class="icon-calendar"></i> --->
		</dd>
		
       <dd class="template">
	  		<cfif perm eq 'editor' and request.hasLayoutObjectsTab><a class="mura-quickEditItem<cfif len(rc.rstop.template) or len(rc.rstop.childtemplate)> template-set</cfif>" data-attribute="template"></cfif>
			<cfif len(rc.rstop.template) or len(rc.rstop.childTemplate)>
				  <i class="icon-list-alt" title="#rc.rstop.template#"></i><span>#rc.rstop.template#</span> 
			<cfelse>
				<span class="bullet" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.inherit")#">&bull;</span>
           		<span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.inherit")#</span>
         	 </cfif>
			<cfif perm eq 'editor' and request.hasLayoutObjectsTab></a></cfif>
		</dd>
     </cfif>
      <dd class="nav">
	  	<cfif perm eq 'editor' and request.hasPublishingTab><a class="mura-quickEditItem" data-attribute="isnav"></cfif>
			<cfif rc.rstop.isnav><i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(rc.rstop.isnav)#")#"></i><cfelse><i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(rc.rstop.isnav)#")#"></i></cfif>			 <span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(rc.rstop.isnav)#")#</span>
	  	<cfif perm eq 'editor' and request.hasPublishingTab></a></cfif>
	  </dd>
      <dd class="updated">#LSDateFormat(rc.rstop.lastupdate,session.dateKeyFormat)# #LSTimeFormat(rc.rstop.lastupdate,"medium")#</dd>
      <dd class="actions">
      	<ul>
          <cfif not listFindNoCase('none,read',perm)>
            <cfset isLockedBySomeoneElse=$.siteConfig('hasLockableNodes') and len(rc.rsTop.lockid) and rc.rsTop.lockid neq session.mura.userid>
            <li class="edit<cfif isLockedBySomeoneElse> disabled</cfif>"><a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="./?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&siteid=#esapiEncode('url',rc.siteid)#&contentid=#rc.topid#&topid=#esapiEncode('url',rc.topid)#&type=#rc.rstop.type#&parentid=#rc.rstop.parentid#&moduleid=#rc.moduleid#"><i class="icon-pencil"></i></a></li>
          
              <li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('#application.settingsManager.getSite(rc.siteid).getWebPath(complete=1)##$.getURLStem(rc.siteid,rc.rsTop.filename)#','#rc.rsTop.targetParams#');"><i class="icon-globe"></i></a></li>
             
            <li class="version-history"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#" href="./?muraAction=cArch.hist&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#"><i class="icon-book"></i></a></li>
            <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
              <li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#" href="./?muraAction=cPerm.main&contentid=#rc.topid#&parentid=&topid=#esapiEncode('url',rc.topid)#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rc.moduleid#&type=#rc.rstop.type#"><i class="icon-group"></i></a></li>
              <cfelse>
              <li class="permissions disabled"><a><i class="icon-group"></i></a></li>
            </cfif>
            <cfif application.settingsManager.getSite(rc.siteid).getlocking() neq 'all'>
              <li class="delete disabled"><a><i class="icon-remove-sign"></i></a></li>
            </cfif>
          <cfelse>
           <li class="edit disabled"><a><i class="icon-pencil"></i></a></li>
            <li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="##" onclick="return preview('#application.settingsManager.getSite(rc.siteid).getWebPath(complete=1)##$.getURLStem(rc.siteid,rc.rsTop.filename)#');"><i class="icon-globe"></i></a></li>
              
            <li class="version-history disabled"><a><i class="icon-book"></i></a></li>
            <li class="permissions disabled"><a><i class="icon-group"></i></a></li>
            <li class="delete disabled"><a><i class="icon-remove-sign"></i></a></li>
          </cfif>
		<cfset pluginEvent.setValue('type', rc.rstop.type)>
        <cfset pluginEvent.setValue('filename', rc.rstop.filename)>
        <cfset pluginEvent.setValue('contentid', rc.rstop.contentid)>
        <cfset pluginEvent.setValue('contenthistid', rc.rstop.contenthistid)>
		#application.pluginManager.renderScripts("onContentList",rc.siteid,pluginEvent)# #application.pluginManager.renderScripts("on#rc.rstop.type#List",rc.siteid,pluginEvent)# #application.pluginManager.renderScripts("on#rc.rstop.type##rc.rstop.subtype#List",rc.siteid,pluginEvent)#
        </ul></dd>
      </dl>
      
      <cfif hasKids>
        <cf_dsp_nest topid="#rc.topid#" parentid="#rc.topid#" locking="#application.settingsManager.getSite(rc.siteid).getlocking()#" nestlevel="1" perm="#perm#" siteid="#rc.siteid#" moduleid="#rc.moduleid#" restricted="#r#" viewdepth="1" nextn="#session.mura.nextN#" startrow="#rc.startrow#" sortBy="#rc.sortBy#" sortDirection="#rc.sortDirection#" pluginEvent="#pluginEvent#" muraScope="#rc.$#">
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
<cfcontent type="application/json; charset=utf-8" reset="true"><cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput><cfabort>

