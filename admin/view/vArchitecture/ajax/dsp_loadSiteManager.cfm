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
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">
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
        <input name="nextN" value="#session.nextN#" type="text" class="text" size="2" maxlength="4" />
      </dd>
      <dt class="viewDepth">#application.rbFactory.getKeyValue(session.rb,"sitemanager.levelsdisplayed")#</dt>
      <dd class="viewDepth">
        <input name="viewDepth" value="#session.viewDepth#" type="text" class="text" size="2" maxlength="4" />
      </dd>
      <cfif attributes.topid neq '00000000000000000000000000000000001' and perm eq 'Editor'>
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
      <dd <cfif attributes.topid neq '00000000000000000000000000000000001' and perm eq 'Editor'>class="button"</cfif>><a class="submit" href="javascript:;" id="submitSort" onclick="return submitForm(document.forms.viewUpdate);"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.update")#</span></a></dd>
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
        <dd class="feature"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.feature")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerFeature")#</span></a></dd>
      </cfif>
      <dd class="nav"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.nav")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerNav")#</span></a></dd>
      <dd class="updated"><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,"sitemanager.updated")#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.managerUpdated")#</span></a></dd>
      <dd class="admin">&nbsp;</dd>
    </dl>
    <ul id="mura-nodes">
    <!-- Begin List of Nodes -->
    <li>
      <dl id="top-node">
      <dt>
       
       <a  class="add" href="javascript:;" onmouseover="showMenu('newContentMenu',#newcontent#,this,'#request.rstop.contentid#','#attributes.topid#','#request.rstop.parentid#','#attributes.siteid#','#request.rstop.type#');">&nbsp;</a>
   
       <cfif request.rstop.haskids><span class="hasChildren" onclick="return loadSiteManager('#JSStringFormat(attributes.siteID)#','#JSStringFormat(attributes.topid)#','#JSStringFormat(attributes.moduleid)#','#JSStringFormat(attributes.sortby)#','#JSStringFormat(attributes.sortdirection)#','#JSStringFormat(request.rstop.type)#',1);"></span></cfif>
        <cfif perm neq 'none'>
          <a class="#icon# title draftprompt" data-siteid="#rc.siteid#" data-contentid="#request.rstop.contentid#" data-contenthistid="#request.rstop.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&siteid=#URLEncodedFormat(attributes.siteid)#&contentid=#attributes.topid#&topid=#URLEncodedFormat(attributes.topid)#&type=#request.rstop.type#&parentid=#request.rstop.parentid#&moduleid=#attributes.moduleid#">
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
        <dd class="objects">#application.rbFactory.getKeyValue(session.rb,"sitemanager.#lcase(request.rstop.inheritObjects)#")#</dd>
        <dd class="display<cfif request.rstop.Display eq 2 and request.rstop.approved>scheduled</cfif>">
			<cfif request.rstop.Display eq 1 and request.rstop.approved >
            	#application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#
            <cfelseif request.rstop.Display eq 2 and request.rstop.approved>
           	 	<a href="##" class="tooltip"><span>#LSDateFormat(request.rstop.displaystart,"short")#&nbsp;-&nbsp;#LSDateFormat(request.rstop.displaystop,"short")#</span></a>
            <cfelse>
           		 #application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#
         	</cfif>
		</dd>
        <dd class="feature<cfif request.rstop.isfeature eq 2> scheduled</cfif>">
			<cfif request.rstop.isfeature eq 1>
            	#application.rbFactory.getKeyValue(session.rb,"sitemanager.true")#
            <cfelseif request.rstop.isfeature eq 2>
           	 	<a href="##" class="tooltip"><span>#LSDateFormat(request.rstop.featurestart,"short")#&nbsp;-&nbsp;#LSDateFormat(request.rstop.featurestop,"short")#</span></a>
            <cfelse>
           		#application.rbFactory.getKeyValue(session.rb,"sitemanager.false")#
         	 </cfif>
		</dd>
     </cfif>
      <dd class="nav">#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(request.rstop.isnav)#")#</dd>
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
#application.pluginManager.renderScripts("onContentList",attributes.siteid,pluginEvent)# #application.pluginManager.renderScripts("on#request.rstop.type#List",attributes.siteid,pluginEvent)# #application.pluginManager.renderScripts("on#request.rstop.type##request.rstop.subtype#List",attributes.siteid,pluginEvent)#
        </ul></dd>
      </dl>
      
      <cfif request.rstop.hasKids>
        <cf_dsp_nest topid="#attributes.topid#" parentid="#attributes.topid#"  rsnest="#rsNext#" locking="#application.settingsManager.getSite(attributes.siteid).getlocking()#" nestlevel="1" perm="#perm#" siteid="#attributes.siteid#" moduleid="#attributes.moduleid#" restricted="#r#" viewdepth="#session.viewDepth#" nextn="#session.nextN#" startrow="#attributes.startrow#" sortBy="#attributes.sortBy#" sortDirection="#attributes.sortDirection#" pluginEvent="#pluginEvent#">
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