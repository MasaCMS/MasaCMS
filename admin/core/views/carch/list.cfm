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
independent software modules (plugixns, themes and bundles), and to distribute these plugins, themes and bundles without 
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
<cfset event=request.event>
<cfset $=request.event.getValue('MuraScope')>
<cfinclude template="js.cfm">
<cfswitch expression="#rc.moduleID#">

<cfcase value="00000000000000000000000000000000003,00000000000000000000000000000000004">

<cfset rc.perm=application.permUtility.getPerm(rc.moduleid,rc.siteid)>

<cfparam name="rc.sortBy" default="">
<cfparam name="rc.sortDirection" default="">
<cfparam name="rc.searchString" default="">

<cfset titleDirection = "asc">
<cfset displayDirection = "asc">
<cfset lastUpdatedDirection = "desc">

<cfswitch expression="#rc.sortBy#">
	<cfcase value="title">
		 <cfif rc.sortDirection eq "asc">
			<cfset titleDirection = "desc">
		</cfif>
	</cfcase>
	<cfcase value="display">
		<cfif rc.sortDirection eq "asc">
			<cfset displayDirection = "desc">
		</cfif>
	</cfcase>
	<cfcase value="lastupdate">
		<cfif rc.sortDirection eq "desc">
			<cfset lastUpdatedDirection = "asc">
		</cfif>
	</cfcase>
</cfswitch>

<cfoutput>
<cfif rc.moduleid eq '00000000000000000000000000000000004'>
<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.formsmanager')#</h1>
<cfelse>
<h1>#application.rbFactory.getKeyValue(session.rb,'sitemanager.componentmanager')#</h1>	
</cfif>
<cfinclude template="dsp_secondary_menu.cfm">

</cfoutput>
<div class="row-fluid">
	  <div id="main" class="span9">
	  <table class="table table-striped table-condensed table-bordered mura-table-grid">
	    
		<cfoutput>
		<thead>
		<tr> 
	      <th class="var-width"><a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&topid=#URLEncodedFormat(rc.topid)#&parentid=#URLEncodedFormat(rc.parentid)#&moduleid=#rc.moduleID#&sortBy=title&sortDirection=#titleDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.title')#</a></th>
	    <!--- <cfif rc.perm eq 'editor'><th class="order" width="30">Order</th></cfif>--->
	      <th><a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&topid=#URLEncodedFormat(rc.topid)#&parentid=#URLEncodedFormat(rc.parentid)#&moduleid=#rc.moduleID#&sortBy=display&sortDirection=#displayDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.display')#</a></th>
	      <th><a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&topid=#URLEncodedFormat(rc.topid)#&parentid=#URLEncodedFormat(rc.parentid)#&moduleid=#rc.moduleID#&sortBy=lastUpdate&sortDirection=#lastUpdatedDirection#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.lastupdated')#</a></th>
	      <th class="actions">&nbsp;</th>
	    </tr>
		</thead>
		</cfoutput>
		<tbody>
	<cfif rc.rstop.recordcount>
	<cfoutput query="rc.rsTop" maxrows="#rc.nextn.recordsperPage#" startrow="#rc.startrow#">
		<cfsilent><cfif rc.perm neq 'editor'>
			<cfset verdict=application.permUtility.getPerm(rc.rstop.contentid, rc.siteid)>
			
			<cfif verdict neq 'deny'>
				<cfif verdict eq 'none'>
					<cfset verdict=rc.perm>
				</cfif>
			<cfelse>
				<cfset verdict = "none">
			</cfif>
			
			<cfelse>
		<cfset verdict='editor'>
		</cfif>
		</cfsilent>
        <tr>  
          <td class="var-width"><cfif verdict neq 'none'><a class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#">#left(rc.rstop.menutitle,90)#</a><cfelse>#left(rc.rstop.menutitle,90)#</cfif></td>
          
			   <td>
			    <cfif rc.rstop.Display and (rc.rstop.Display eq 1 and rc.rstop.approved)>
			    	<i class="icon-ok" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#"></i><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.yes')#</span>
			    <cfelseif(rc.rstop.Display eq 2 and rc.rstop.approved)>#LSDateFormat(rc.rstop.displaystart,"short")# - #LSDateFormat(rc.rstop.displaystop,"short")#
			    <cfelse>
			    <i class="icon-ban-circle" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#"></i><span>#application.rbFactory.getKeyValue(session.rb,'sitemanager.no')#</span>
			    </cfif>
			    </td>
		<td>#LSDateFormat(rc.rstop.lastupdate,session.dateKeyFormat)# #LSTimeFormat(rc.rstop.lastupdate,"medium")#</td>
          <td class="actions">
			<ul class="#lcase(rc.rstop.type)#">
				<cfif verdict neq 'none'>
				<li class="edit">
					<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" class="draftprompt" data-siteid="#rc.siteid#" data-contentid="#rc.rstop.contentid#" data-contenthistid="#rc.rstop.contenthistid#"title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.edit')#" href="index.cfm?muraAction=cArch.edit&contenthistid=#rc.rstop.ContentHistID#&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#"><i class="icon-pencil"></i></a></li>
					<li class="version-history"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#" href="index.cfm?muraAction=cArch.hist&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#"><i class="icon-book"></i></a></li>
					<cfif rc.moduleid eq '00000000000000000000000000000000004'>
						<li class="manage-data"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#" href="index.cfm?muraAction=cArch.datamanager&contentid=#rc.rstop.ContentID#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&contenthistid=#rc.rstop.ContentHistID#&topid=#URLEncodedFormat(rc.topid)#&parentid=#URLEncodedFormat(rc.parentid)#&type=Form"><i class="icon-wrench"></i></a></li>
					</cfif>
					<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
						<li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#" href="index.cfm?muraAction=cPerm.main&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&parentid=#rc.rstop.parentID#&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&startrow=#rc.startrow#"><i class="icon-group"></i></a></li>
					</cfif>
				<cfelse>
					<li class="edit disabled"><a><i class="icon-pencil"></i></a></li>
					<li class="version-history disabled"><i class="icon-book"></i></li>
					<cfif rc.moduleid eq '00000000000000000000000000000000004'>
						<li class="manage-dataOff disabled"><i class="icon-wrench"></i></li>
					</cfif>
					<li class="permissions disabled"><a><i class="icon-group"></i></a></li>
				</cfif>
				<cfif ((rc.locking neq 'all') or (rc.parentid eq '#rc.topid#' and rc.locking eq 'none')) and (verdict eq 'editor') and not rc.rsTop.isLocked eq 1>
					<li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?muraAction=cArch.update&contentid=#rc.rstop.ContentID#&type=#rc.rstop.type#&action=deleteall&topid=#URLEncodedFormat(rc.topid)#&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&parentid=#URLEncodedFormat(rc.parentid)#" onClick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"><i class="icon-remove-sign"></i></a></li>
				<cfelseif rc.locking neq 'all'>
					<li class="delete disabled"><i class="icon-remove-sign"></i></li>
				</cfif>
			</ul></td></tr>
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="7" class="noResults"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.noitemsinsection')#</cfoutput></td>
      </tr>
    </cfif>
	
  </table>
</td></tr></tbody></table>

  <cfif rc.nextn.numberofpages gt 1>
    <cfoutput> 
    	<cfset args=arrayNew(1)>
		<cfset args[1]="#rc.nextn.startrow#-#rc.nextn.through#">
		<cfset args[2]=rc.nextn.totalrecords>
		<div class="mura-results-wrapper">
		<p class="clearfix search-showing">
			#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#
		</p> 
		<ul class="pagination">
		 <cfif rc.nextN.currentpagenumber gt 1>
			
					<li>	
				 	<a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&topid=#URLEncodedFormat(rc.topid)#&startrow=#rc.nextN.previous#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'sitemanager.prev')#</a>
				 	</li>
				 </cfif>
				<cfloop from="#rc.nextn.firstPage#"  to="#rc.nextn.lastPage#" index="i">
					<cfif rc.nextn.currentpagenumber eq i> 
						<li class="active"><a href="##">#i#</a></li> 
					<cfelse> 
						<li>
						<a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&topid=#URLEncodedFormat(rc.topid)#&startrow=#evaluate('(#i#*#rc.nextn.recordsperpage#)-#rc.nextn.recordsperpage#+1')#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">#i#</a></li>
					</cfif>
				</cfloop>
				<cfif rc.nextN.currentpagenumber lt rc.nextN.NumberOfPages>
					<li>
						<a href="index.cfm?muraAction=cArch.list&siteid=#URLEncodedFormat(rc.siteid)#&moduleid=#rc.moduleid#&topid=#URLEncodedFormat(rc.topid)#&startrow=#rc.nextN.next#&sortBy=#rc.sortBy#&sortDirection=#rc.sortDirection#&searchString=#rc.searchString#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.next')#&nbsp;&raquo;</a>
					</li>
				</cfif>
				</ul>
			</div>
		</cfoutput>
			
   </cfif>
</div>
<cfoutput>
<div class="sidebar span3">
	<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.filters")#</h2>
	<form class="form-inline" novalidate="novalidate" id="filterByTitle" action="index.cfm" method="get">
    	  <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#" />
    	  <input type="hidden" name="topid" value="#rc.topID#" />
    	  <input type="hidden" name="parentid" value="#rc.parentID#" />
    	  <input type="hidden" name="moduleid" value="#rc.moduleID#" />
    	  <input type="hidden" name="sortBy" value="" />
    	  <input type="hidden" name="sortDirection" value="" />
    	  <input type="hidden" name="muraAction" value="cArch.list" />
   
		<div id="filters" class="module well">
		<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.keywords")#</h3>
	     <input type="text" name="searchString" id="searchString" value="#HTMLEditFormat(rc.searchString)#" class="text" size="20">
	  	</div>

	  	<cfsilent>
		<cfset tags=$.getBean('contentGateway').getTagCloud(siteid=$.event('siteID'),moduleID=rc.moduleID) />
		<cfset tagValueArray = ListToArray(ValueList(tags.tagCount))>
		<cfset max = ArrayMax(tagValueArray)>
		<cfset min = ArrayMin(tagValueArray)>
		<cfset diff = max - min>
		<cfset distribution = diff>
		<cfset rbFactory=$.siteConfig().getRBFactory()>
		</cfsilent>	
	
		<cfif tags.recordcount>
			<div class="module well" id="mura-filter-tags">
				<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.tags")#</h3>
				<div id="svTagCloud">
					<ol>
					<cfloop query="tags"><cfsilent>
							<cfif tags.tagCount EQ min>
							<cfset class="not-popular">
						<cfelseif tags.tagCount EQ max>
							<cfset class="ultra-popular">
						<cfelseif tags.tagCount GT (min + (distribution/2))>
							<cfset class="somewhat-popular">
						<cfelseif tags.tagCount GT (min + distribution)>
							<cfset class="mediumTag">
						<cfelse>
							<cfset class="not-very-popular">
						</cfif>
					
						<cfset args = ArrayNew(1)>
					    <cfset args[1] = tags.tagcount>
					</cfsilent><li class="#class#"><span><cfif tags.tagcount gt 1> #rbFactory.getResourceBundle().messageFormat($.rbKey('tagcloud.itemsare'), args)#<cfelse>#rbFactory.getResourceBundle().messageFormat($.rbKey('tagcloud.itemis'), args)#</cfif> tagged with </span><a class="tag<cfif listFind($.event('tag'),tags.tag)> active</cfif>">#HTMLEditFormat(tags.tag)#</a></li>
					</cfloop>
					</ol>
				</div>
			</div>

		</cfif>
	  	<cfif $.getBean("categoryManager").getCategoryCount($.event("siteID"))>
		<div class="module well" id="mura-list-tree">
		<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.categories")#</h3>
		<cf_dsp_categories_nest siteID="#$.event('siteID')#" parentID="" nestLevel="0" categoryid="#$.event('categoryid')#">
		</div>
	</cfif>
		<input type="hidden" name="tag" id="tag" value="#HTMLEditFormat($.event('tag'))#" />
	  	<input type="submit" class="btn" name="filterList" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.filter")#"/>
	  	<cfif len($.event('categoryID') & $.event('tag') & $.event('searchString'))>
	  	<input type="button" class="btn" name="removeFilter" id="removeFilter" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.removefilter")#" onclick=""/>
	  	</cfif>
  	 </form>

  	 <script> 	
	  	$('##filterByTitle').submit(
	  		function(){
		  	 	var tag=[];

		  	 	$("##svTagCloud .active").each(
					function(){
						tag.push($(this).html());
					}
				);
					
				$('##tag').val(tag.toString());
				
				return true;
	  	 	}
	  	 );	

	  	$('##removeFilter').click(
	  		function(){
		  	 	$('##tag').val('');
				$('##searchString').val('');
				$('input[name=categoryID]').attr('checked', false);
				document.getElementById('filterByTitle').submit();

	  	 	}
	  	 );	

		$("##svTagCloud a").click(
			function(event){
				event.preventDefault();
				jQuery(this).toggleClass('active');
			}
		);
	</script>
</div>
</cfoutput>
<cfinclude template="draftpromptjs.cfm">


</cfcase>

<cfcase value="00000000000000000000000000000000000">

<cfsilent>

<cfset crumbdata=application.contentManager.getCrumbList(rc.topid,rc.siteid)>

<cfif isdefined('rc.nextN') and rc.nextN gt 0>
  <cfset session.mura.nextN=rc.nextN>
  <cfset rc.startrow=1>
</cfif>

<cfif not isDefined('rc.saveSort')>
  <cfset rc.sortBy=rc.rstop.sortBy />
  <cfset rc.sortDirection=rc.rstop.sortDirection />
</cfif>

<cfparam name="rc.sortBy" default="#rc.rstop.sortBy#" />
<cfparam name="rc.sortDirection" default="#rc.rstop.sortDirection#" />
<cfparam name="rc.sorted" default="false" />
<cfparam name="rc.lockid" default="" />
<cfparam name="rc.assignments" default="false" />
<cfparam name="rc.categoryid" default="" />
<cfparam name="rc.tag" default="" />
<cfparam name="rc.type" default="" />
<cfparam name="rc.page" default="1" />
<cfparam name="rc.subtype" default="" />
<cfparam name="session.copyContentID" default="">
<cfparam name="session.copySiteID" default="">
<cfparam name="session.copyAll" default="false">

<cfparam name="session.flatViewArgs" default="#structNew()#">
<cfparam name="session.flatViewArgs" default="#structNew()#">

<cfscript>
	if(not structKeyExists(session.flatViewArgs,session.siteid)){
		session.flatViewArgs["#session.siteid#"]=structNew();
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"moduleid")){
		session.flatViewArgs["#session.siteid#"].moduleid=rc.moduleid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"sortby")){
		session.flatViewArgs["#session.siteid#"].sortby="lastupdate";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"sortdirection")){
		session.flatViewArgs["#session.siteid#"].sortdirection="desc";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"lockid")){
		session.flatViewArgs["#session.siteid#"].lockid=rc.lockid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"assignments")){
		session.flatViewArgs["#session.siteid#"].assignments=rc.assignments;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"categoryid")){
		session.flatViewArgs["#session.siteid#"].categoryid=rc.categoryid;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"tag")){
		session.flatViewArgs["#session.siteid#"].tag=rc.tag;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"page")){
		session.flatViewArgs["#session.siteid#"].page=rc.page;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"type")){
		session.flatViewArgs["#session.siteid#"].type="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"subtype")){
		session.flatViewArgs["#session.siteid#"].subtype=rc.subtype;
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"report")){
		session.flatViewArgs["#session.siteid#"].report="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"keywords")){
		session.flatViewArgs["#session.siteid#"].keywords="";
	}
	
	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"tab")){
		session.flatViewArgs["#session.siteid#"].tab=0;
	}

	if(not structKeyExists(session.flatViewArgs["#session.siteid#"],"filtered") or not isBoolean((session.flatViewArgs["#session.siteid#"].filtered))){
		session.flatViewArgs["#session.siteid#"].filtered=false;
	}
</cfscript>

<cfif not isdefined("url.activeTab")>
	<cfset rc.activeTab=session.flatViewArgs["#session.siteID#"].tab/>
</cfif>
<cfif isdefined("url.keywords")>
	<cfif session.flatViewArgs["#session.siteID#"].keywords neq url.keywords>
		<cfset session.flatViewArgs["#session.siteID#"].page=1>
	</cfif>
	<cfset session.flatViewArgs["#session.siteID#"].keywords=url.keywords/>
	<cfset session.flatViewArgs["#session.siteID#"].report=""/>
	<cfset session.keywords=url.keywords/>
</cfif>
<cfhtmlhead text='<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-pulse.js?coreversion=#application.coreversion#" type="text/javascript"></script>'>

<cfif isdefined('rc.orderperm') and (rc.orderperm eq 'editor' or (rc.orderperm eq 'author' and application.configBean.getSortPermission() eq "author"))>
	<cflock type="exclusive" name="editingContent#rc.siteid#" timeout="60">
		
		<cfif rc.sorted>
			<cfset current=application.serviceFactory.getBean("content").loadBy(contentID=rc.topID, siteid=rc.siteID)>
			<cfif rc.sortBy eq 'orderno'>
				<cfset rc.sortDirection='asc'>
			</cfif>
			<cfset current.setSortBy(rc.sortBy)>
			<cfset current.setSortDirection(rc.sortDirection)>
			<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>
			<cfset variables.pluginEvent.setValue("contentBean")>
			<cfset application.pluginManager.announceEvent("onBeforeContentSort",pluginEvent)>
		</cfif>
		
		<cfif isdefined('rc.orderid') >
			<cfloop from="1" to="#listlen(rc.orderid)#" index="i">
				<cfset newOrderNo=(rc.startrow+i)-1>
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
				update tcontent set orderno= #newOrderNo# where contentid ='#listgetat(rc.orderid,i)#'
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
		update tcontent set sortBy='#rc.sortBy#',sortDirection='#rc.sortDirection#' where contentid ='#rc.topid#'
		</cfquery>
		<cfif rc.sortBy eq 'orderno' and  not isdefined('rc.orderid')>
			<cfset rsSetOrder=application.contentManager.getNest('#rc.topid#',rc.siteid,rc.rsTop.sortBy,rc.rsTop.sortDirection)>
			<cfloop query="rsSetOrder">
				<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" >
				update tcontent set orderno= #rsSetOrder.currentrow# where contentid ='#rsSetOrder.contentID#'
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif rc.sorted>
			<cfset application.pluginManager.announceEvent("onAfterContentSort",pluginEvent)>
		</cfif>
		
		<cfset application.settingsManager.getSite(rc.siteid).purgeCache()>
	</cflock>
</cfif>
<cfif not len(crumbdata[1].siteid)>
  <cflocation url="index.cfm?muraAction=cDashboard.main&siteid=#URLEncodedFormat(rc.siteid)#&span=30" addtoken="false"/>
</cfif>
</cfsilent>

<cfoutput>
<script>	
siteID='#session.siteID#';
<cfif session.copySiteID eq rc.siteID>
copyContentID = '#session.copyContentID#';
copySiteID = '#session.copySiteID#';
copyAll = '#session.copyAll#';
<cfelse>
copyContentID = '';
copySiteID = '';
copyAll = 'false';
</cfif>
</script>
 
<h1>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sitemanager")#</h1>
<form class="form-inline" novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
	
    <div class="input-append">
	    <input name="keywords" value="#HTMLEditFormat(session.keywords)#" type="text" class="text" />
	    <button type="button" class="btn" onclick="submitForm(document.forms.siteSearch);" /><i class="icon-search"></i><!--- #application.rbFactory.getKeyValue(session.rb,"sitemanager.search")# ---></button>
    </div>
    
    <input type="hidden" name="muraAction" value="cArch.list">
	<input type="hidden" name="activetab" value="1">
    <input type="hidden" name="siteid" value="#HTMLEditFormat(rc.siteid)#">
    <input type="hidden" name="moduleid" value="#rc.moduleid#">
</form>

<div class="tabbable">
	<ul id="viewTabs" class="nav nav-tabs tabs initActiveTab">
		<li><a href="##tabArchitectural" onclick="return false;">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.architectural")#</a></li>
		<li><a href="##tabFlat" onclick="return false;">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view.flat")#</a></li>
	</ul>
	<div class="tab-content"> 
		<div id="tabArchitectural" class="tab-pane fade">
			<div id="gridContainer">
				<div class="load-inline"></div>
			</div>
		</div>
		
		<div id="tabFlat" class="tab-pane fade">
			<div id="flatViewContainer">
				<div class="load-inline"></div>
			</div>
		</div>
	</div>	
</div>

<script type="text/javascript">
var archViewLoaded=false;
var flatViewLoaded=false;
var tabsInited=false;

function initFlatViewArgs(){
	return {siteid:'#JSStringFormat(session.siteID)#', 
			moduleid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].moduleid)#', 
			sortby:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].sortby)#', 
			sortdirection:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].sortdirection)#', 
			page:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].page)#',	
			tag:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].tag)#',
			categoryid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].categoryid)#',
			lockid:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].lockid)#',
			type:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].type)#',
			subType:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].subtype)#',
			report:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].report)#',
			keywords:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].keywords)#',
			filtered: '#JSStringFormat(session.flatViewArgs["#session.siteID#"].filtered)#'
			};
}


var newContentMenuTitle='#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.selectcontenttype"))#';
var flatViewArgs=initFlatViewArgs();

function initSiteManagerTabContent(index){

	jQuery.get("./index.cfm","muraAction=carch.siteManagerTab&tab=" + index);
	
	if(!tabsInited){
		jQuery("##viewTabs a[href='##tabArchitectural']").click(function(e){
			e.preventDefault();
			initSiteManagerTabContent(0);
		});
		jQuery("##viewTabs a[href='##tabFlat']").click(function(e){
			e.preventDefault();
			initSiteManagerTabContent(1);
		});
		tabsInited=true;
	}	

	switch(index){
		case 0:
		if (!archViewLoaded) {
			siteManager.loadSiteManager('#JSStringFormat(rc.siteID)#', '#JSStringFormat(rc.topid)#', '#JSStringFormat(rc.moduleid)#', '#JSStringFormat(rc.sortby)#', '#JSStringFormat(rc.sortdirection)#', '#JSStringFormat(rc.ptype)#', '#JSStringFormat(rc.startrow)#');
			archViewLoaded = true;
			jQuery('##viewTabs a[href="##tabArchitectural"]').tab('show');
		}
		break;
		case 1:
		if (!flatViewLoaded) {
			siteManager.loadSiteFlat(flatViewArgs);
			flatViewLoaded = true;
			jQuery('##viewTabs a[href="##tabFlat"]').tab('show');
		}
	}
}


jQuery(document).ready(function(){
	initSiteManagerTabContent(#rc.activeTab#);	
});
</script>
</cfoutput>
<cfinclude template="draftpromptjs.cfm">

</cfcase>
</cfswitch>

