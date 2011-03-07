<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. †See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. †If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (ìGPLî) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, †the copyright holders of Mura CMS grant you permission
to combine Mura CMS †with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the †/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 †without this exception. †You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfsilent>
<cfset crumbdata=application.contentManager.getCrumbList(attributes.topid,attributes.siteid)>
<cfif isdefined('attributes.viewDepth') and attributes.viewDepth gt 0>
  <cfset session.viewDepth=attributes.viewDepth>
  <cfset session.nextN=attributes.nextN>
  <cfset attributes.startrow=1>
</cfif>
<cfif not isDefined('attributes.saveSort')>
  <cfset attributes.sortBy=request.rstop.sortBy />
  <cfset attributes.sortDirection=request.rstop.sortDirection />
</cfif>
<cfparam name="attributes.sortBy" default="#request.rstop.sortBy#" />
<cfparam name="attributes.sortDirection" default="#request.rstop.sortDirection#" />
<cfparam name="attributes.sorted" default="false" />
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">

<cfhtmlhead text='<script src="#application.configBean.getContext()#/admin/js/jquery/jquery-pulse.js?coreversion=#application.coreversion#" type="text/javascript"></script>'>

<cfif isdefined('attributes.orderperm') and (attributes.orderperm eq 'editor' or (attributes.orderperm eq 'author' and application.configBean.getSortPermission() eq "author"))>
	<cflock type="exclusive" name="editingContent#attributes.siteid#" timeout="60">
		
		<cfif attributes.sorted>
			<cfset current=application.serviceFactory.getBean("content").loadBy(contentID=attributes.topID, siteid=attributes.siteID)>
			<cfset current.setSortBy(attributes.sortBy)>
			<cfset current.setSortDirection(attributes.sortDirection)>
			<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
			<cfset variables.pluginEvent.setValue("contentBean")>
			<cfset application.pluginManager.announceEvent("onBeforeContentSort",pluginEvent)>
		</cfif>
		
		<cfif isdefined('attributes.orderid') >
			<cfloop from="1" to="#listlen(attributes.orderid)#" index="i">
				<cfset newOrderNo=(attributes.startrow+i)-1>
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
				update tcontent set orderno= #newOrderNo# where contentid ='#listgetat(attributes.orderid,i)#'
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
		
		<cfif attributes.sorted>
			<cfset application.pluginManager.announceEvent("onAfterContentSort",pluginEvent)>
		</cfif>
		
		<cfset application.settingsManager.getSite(attributes.siteid).purgeCache()>
	</cflock>
</cfif>
<cfif not len(crumbdata[1].siteid)>
  <cflocation url="index.cfm?fuseaction=cDashboard.main&siteid=#URLEncodedFormat(attributes.siteid)#&span=30" addtoken="false"/>
</cfif>
<cfset request.rowNum=0>
<cfset request.menulist=attributes.topid>
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
<cfoutput>
<script>	
<cfif session.copySiteID eq attributes.siteID>
copyContentID = '#session.copyContentID#';
copySiteID = '#session.copySiteID#';
copyAll = '#session.copyAll#';
<cfelse>
copyContentID = '';
copySiteID = '';
copyAll = 'false';
</cfif>
<cfif attributes.sortBy eq 'orderno' and perm eq 'editor'>
startrow=#int(attributes.startrow)#
jQuery(document).ready(
	function($){
		$("##sortableKids").sortable(
			{
   				stop: function(event, ui) {
   					 stripe('stripe');setAsSorted();
   					  $(ui.item).removeClass('ui-draggable-dragging');
   				 },
   				start: function(event, ui) {
   					 $(ui.item).addClass('ui-draggable-dragging');
   				 }
			}
		);
		$("##sortableKids").disableSelection();
	}
	);

</cfif>

function setAsSorted(){	
		jQuery('##sorted').val('true');	
		jQuery('##submitSort').pulse({
                opacity: [.5,1]
            }, {
                times: 999999,
                duration: 750
            });
        jQuery('##submitSort').addClass('pulse');
}
</script>
  <h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sitemanager")#</h2>
  <form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
    <h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.contentsearch")#</h3>
    <input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" align="absmiddle" />
    <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>#application.rbFactory.getKeyValue(session.rb,"sitemanager.search")#</span></a>
    <input type="hidden" name="fuseaction" value="cArch.search">
    <input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
    <input type="hidden" name="moduleid" value="#attributes.moduleid#">
  </form>
  <cfif attributes.type neq 'Component' and attributes.type neq 'Creative'  and attributes.type neq 'Form'>
    #application.contentRenderer.dspZoom(crumbdata)#
  </cfif>
  <cfset rsExtend=application.configBean.getClassExtensionManager().getExtendedAttributeList(attributes.siteid)>
  <form novalidate="novalidate" class="viewUpdate" name="viewUpdate" method="post">
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
       
       <cfif request.rstop.haskids><span class="hasChildren"></span></cfif>
        <cfif perm neq 'none'>
          <a class="#icon# title" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&siteid=#URLEncodedFormat(attributes.siteid)#&contentid=#attributes.topid#&topid=#URLEncodedFormat(attributes.topid)#&type=#request.rstop.type#&parentid=#request.rstop.parentid#&moduleid=#attributes.moduleid#">
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
            <li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#request.rstop.ContentHistID#&siteid=#URLEncodedFormat(attributes.siteid)#&contentid=#attributes.topid#&topid=#URLEncodedFormat(attributes.topid)#&type=#request.rstop.type#&parentid=#request.rstop.parentid#&moduleid=#attributes.moduleid#">#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#</a></li>
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