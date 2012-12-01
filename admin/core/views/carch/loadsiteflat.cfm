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
<cfset request.layout=false>
<cfset event=request.event>
<cfscript>
	//data=structNew();
	
	$=application.serviceFactory.getBean("MuraScope");
	
	session.flatViewArgs["#rc.siteID#"].moduleid=$.event("moduleid");
	session.flatViewArgs["#rc.siteID#"].sortBy=$.event("sortby");
	session.flatViewArgs["#rc.siteID#"].sortDirection=$.event("sortdirection");
	session.flatViewArgs["#rc.siteID#"].lockid=$.event("lockid");
	session.flatViewArgs["#rc.siteID#"].assignments=$.event("assignments");
	session.flatViewArgs["#rc.siteID#"].categoryid=$.event("categoryid");
	session.flatViewArgs["#rc.siteID#"].tag=$.event("tag");
	session.flatViewArgs["#rc.siteID#"].page=$.event("page");
	session.flatViewArgs["#rc.siteID#"].type=$.event("type");
	session.flatViewArgs["#rc.siteID#"].subtype=$.event("subtype");
	session.flatViewArgs["#rc.siteID#"].report=$.event("report");
	session.flatViewArgs["#rc.siteID#"].keywords=$.event("keywords");
	session.flatViewArgs["#rc.siteID#"].filtered=yesNoFormat($.event("filtered"));
	 
	feed=$.getBean("feed");
	feed.setMaxItems(500);
	feed.setNextN(10);
	feed.setLiveOnly(0);
	feed.setShowNavOnly(0);
	
	if(len($.event("tag"))){
		feed.addParam(field="tcontenttags.tag",criteria=$.event("tag"),condition="in");
	}
	
	if(len($.event("type"))){
		feed.addParam(field="tcontent.type",criteria=$.event("type"),condition="in");	
	}
	
	if(len($.event("subtype"))){
		feed.addParam(field="tcontent.subtype",criteria=$.event("subtype"));	
	}
	
	if(len($.event("categoryID"))){
		feed.setCategoryID($.event("categoryID"));	
	}
	
	if(len($.event("sortBy"))){
		feed.setSortBy($.event("sortBy"));	
	}
	
	if(len($.event("sortDirection"))){
		feed.setSortDirection($.event("sortDirection"));	
	}
	
	if($.event('report') eq "lockedfiles"){
		feed.addParam(field="tcontentstats.lockid",condition=">",criteria="");	
	} else if($.event('report') eq "mylockedfiles"){
		feed.addParam(field="tcontentstats.lockid",condition="=",criteria=$.currentUser("userID"));
	} else if($.event('report') eq "expires"){
		feed.addParam(field="tcontent.expires",datatype="date",condition="<=",criteria=dateAdd("m",1,now()));
		feed.addParam(field="tcontent.expires",datatype="date",condition=">",criteria=dateAdd("m",-12,now()));		
	} else if($.event('report') eq "myexpires"){
		subList=$.getBean("contentManager").getExpiringContent($.event("siteID"),$.currentUser("userID"));
		feed.addParam(field="tcontent.contentID",datatype="varchar",condition="in",criteria=valuelist(subList.contentID));
	} else if($.event('report') eq "mydrafts"){
		subList=$.getBean("contentManager").getDraftList($.event("siteID"));
		feed.addParam(field="tcontent.contentID",datatype="varchar",condition="in",criteria=valuelist(subList.contentID));
	}
	
	if(len($.event("keywords"))){	
		subList=$.getBean("contentManager").getPrivateSearch($.event("siteID"),$.event("keywords"));
		feed.addParam(field="tcontent.contentID",datatype="varchar",condition="in",criteria=valuelist(subList.contentID));
	}
	
	iterator=feed.getIterator();
	iterator.setPage($.event('page'));
</cfscript>

<cfsavecontent variable="pagination">
<cfoutput>
	<cfif iterator.hasNext()>
		<cfset args=arrayNew(1)>
		<cfset args[1]="#iterator.getFirstRecordOnPageIndex()#-#iterator.getLastRecordOnPageIndex()#">
		<cfset args[2]=iterator.getRecordCount()>
		
		<div class="mura-results-wrapper">
		<p class="search-showing">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#</p>
		<cfif iterator.pageCount() gt 1>
			<ul class="moreResults pagination">
				<cfif iterator.hasPrevious()><li class="navPrev"><a href="" data-page="#evaluate($.event('page')-1)#">&laquo;</a></li></cfif>
				<cfloop from="#max($.event('page')-5,1)#" to="#min($.event('page')+5,iterator.pageCount())#" index="p">
				<li<cfif $.event('page') eq p> class="active"</cfif>><a href="" data-page="#p#"<cfif $.event('page') eq p> class="active"</cfif>>#p#</a></li>
				</cfloop>
				<cfif $.event('page') lt iterator.pageCount()><li class="navNext"><a href="" data-page="#evaluate($.event('page')+1)#">&raquo;</a></li></cfif>	
			</ul>
		</cfif>
		</div>
	</cfif>	
</cfoutput>	
</cfsavecontent></cfsilent>
<!---<cfsavecontent variable="data.html">--->
<cfset hasCustomImage=structKeyExists(getMetaData($.getBean('fileManager').getValue('imageProcessor')),'getCustomImage')>

<cfoutput>
<div class="row-fluid">
<div id="main" class="span9">
	<div class="navSort">
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sortby")#:</h2>
		<ul class="navTask nav nav-pills">
			<!---<li><a href="" data-sortby="releasedate">Release Date</a></li>--->	
			<li><a href="" data-sortby="lastupdate"<cfif $.event("sortBy") eq "lastUpdate"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.lastupdated")#</a></li>
			<li><a href="" data-sortby="created"<cfif $.event("sortBy") eq "created"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.created")#</a></li>
			<!---<li><a href="" data-sortby="releasedate"<cfif $.event("sortBy") eq "releasedate"> class="active"</cfif>>Release Date</a></li>--->
			<li><a href="" data-sortby="menutitle"<cfif $.event("sortBy") eq "menutitle"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.title")#</a></li>
		</ul>
	</div>

	#pagination#

	<table class="mura-table-grid table table-striped table-bordered table-condensed">
		<tr>
			<th></th>
		  	<th class="item">#application.rbFactory.getKeyValue(session.rb,"sitemanager.item")#</th>
			<!---<th nowrap class="actions">&nbsp;</th>--->
		</tr> 
	 	<cfif iterator.hasNext()>
		<cfloop condition="iterator.hasNext()">
		<cfsilent>
		<cfset item=iterator.next()>
		<cfset crumbdata=application.contentManager.getCrumbList(item.getContentID(), item.getSiteID())/>
		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
		
		<cfif application.settingsManager.getSite(item.getSiteID()).getLocking() neq 'all'>
			<cfset newcontent=verdict>
		<cfelseif verdict neq 'none'>
	  		<cfset newcontent='read'>
		<cfelse>
	  		<cfset newcontent='none'>
		</cfif>

		<cfif item.getContentID() eq '00000000000000000000000000000000001'>
			<cfset topID=item.getContentID()>
		<cfelse>
			<cfset topID=item.getParentID()>
		</cfif>

		<cfset deletable=((item.getParentID() neq '00000000000000000000000000000000001' and application.settingsManager.getSite(item.getSiteID()).getLocking() neq 'all') or (item.getParentID() eq '00000000000000000000000000000000001' and application.settingsManager.getSite(item.getSiteID()).getLocking() eq 'none')) and (verdict eq 'editor')  and item.getIsLocked() neq 1 and item.getContentID() neq '00000000000000000000000000000000001'>

		<cfset editLink="index.cfm?muraAction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getParentID()#&topid=#URLEncodedFormat(topID)#&siteid=#URLEncodedFormat(item.getSiteid())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">
		</cfsilent>
	
		<tr data-siteid="#item.getSiteID()#" data-contentid="#item.getContentID()#" data-contenthistid="#item.getContentHistID()#" data-sortby="#item.getSortBy()#" data-sortdirection="#item.getSortDirection()#" data-moduleid="#HTMLEditFormat(item.getModuleID())#" data-type="#item.getType()#">
			<td class="add"><a class="add" href="javascript:;" onmouseover="siteManager.showMenu('newContentMenu','#newcontent#',this,'#item.getContentID()#','#item.getContentID()#','#item.getContentID()#','#item.getSiteID()#','#item.getType()#');"><i class="icon-plus-sign"></i></a></td>
			<td class="var-width item">
			
			<div class="actions">
				<ul class="siteSummary">
					<cfif not listFindNoCase('none,read',verdict)>
					 
					    <li class="edit"><a title="Edit" class="draftprompt" href="#editLink#"><i class="icon-pencil"></i></a></li>
						
						<cfswitch expression="#item.gettype()#">
							<cfcase value="Page,Folder,Calendar,Gallery">
							<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.preview')#" href="##" onclick="return preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),item.getfilename())#','#item.gettargetParams()#');"><i class="icon-globe"></i></a></li>
							</cfcase>
							<cfcase value="File,Link">
							<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.preview')#" href="##" onclick="return preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),"")#?LinkServID=#item.getcontentid()#','#item.gettargetParams()#');"><i class="icon-globe"></i></a></li>
							<cfif item.getType() eq "File">
							<li class="download"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.download')#" href="/tasks/render/file/?fileID=#item.getFileID()#&method=attachment" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm'))#',this.href)"><i class="icon-download"></i></a></li>
							</cfif>
							</cfcase>
						</cfswitch>
						 
						 <li class="version-history"><a title="Version History" href="index.cfm?muraAction=cArch.hist&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#topid#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#"><i class="icon-book"></i></a></li>
					      
					    <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(item.getSiteID()).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
					        <li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.permissions')#" href="index.cfm?muraAction=cPerm.main&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#topID#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#"><i class="icon-group"></i></a></li>
					    <cfelse>
							<li class="permissions disabled"><a><i class="icon-group"></i></a></li>
						</cfif>
					    
					    <cfif deletable>
					        <li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.delete')#" href="index.cfm?muraAction=cArch.update&contentid=#item.getContentID()#&type=#item.gettype()#&action=deleteall&topid=#topID#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&parentid=#URLEncodedFormat(item.getParentID())#&startrow=#$.event('startrow')#"<cfif listFindNoCase("Page,Portal,Calendar,Gallery,Link,File",item.gettype())>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),item.getmenutitle()))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"</cfif>>
							<i class="icon-remove-sign"></i></a></li>
					    <cfelseif rc.locking neq 'all'>
					        <li class="delete disabled"><i class="icon-remove-sign"></i></li>
					    </cfif>
					
					<cfelse>
					    <li class="edit disabled"><i class="icon-pencil"></i></li>
						<cfswitch expression="#item.gettype()#">
							<cfcase value="Page,Folder,Calendar,Gallery">
							<li class="preview"><a title="Preview" href="##" onclick="return preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),item.getfilename())#','#item.gettargetParams()#');"><i class="icon-globe"></i></a></li>
							</cfcase>
							<cfcase value="File,Link">
							<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.preview')#" href="##" onclick="return preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),"")#?LinkServID=#item.getcontentid()#','#item.gettargetParams()#');"><i class="icon-globe"></i></a></li>
							</cfcase>
						</cfswitch>
						<li class="version-history disabled"><a><i class="icon-book"></i></a></li>
						<li class="permissions disabled"><a><i class="icon-group"></i></a></li>
						<li class="delete disabled"><a><i class="icon-remove-sign"></i></a></li>
					</cfif>
					
				</ul>
			</div> 
			

			<h2>
				<cfif not listFindNoCase('none,read',verdict)>
					<a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#" class="draftprompt" href="index.cfm?muraAction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getParentID()#&topid=#URLEncodedFormat(topID)#&siteid=#URLEncodedFormat(item.getSiteid())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">#HTMLEditFormat(item.getMenuTitle())#</a>
				<cfelse>
					#HTMLEditFormat(item.getMenuTitle())#
				</cfif>	
			</h2>
			<cfif listFindNoCase("png,jpg,jpeg,gif",item.getFileExt())>
			<div class="thumbnail"><a title="Edit" class="draftprompt" href="#editLink#"><cfif hasCustomImage><img src="#item.getImageURL(height=80,width=80)#" /><cfelse><img src="#item.getImageURL(size='small')#" /></cfif></a></div>
			</cfif>
				<cfif len(item.getLockID())>
					<cfset lockedBy=$.getBean("user").loadBy(item.getLockID())>
					<p class="locked-offline">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.filelockedby"),"#HTMLEditFormat(lockedBy.getFName())# #HTMLEditFormat(lockedBy.getLName())#")#</p>
				</cfif>
				
				#application.contentRenderer.dspZoom(crumbData=crumbdata,ajax=true)#
				
				<ul class="nodeMeta">
					<cfsilent><cfset args=arrayNew(1)>
					<cfset args[1]=LSDateformat(item.getLastUpdate(),session.dateKeyFormat)>
					<cfset args[2]=LSTimeFormat(item.getLastUpdate())>
					<cfset args[3]=item.getLastUpdateBy()></cfsilent>
					<li class="updated">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.lastupdatedlong"),args)#</li>		
					<cfif isDate(item.getCreated())>
					<cfsilent><cfset args=arrayNew(1)>
					<cfset args[1]=LSDateformat(item.getCreated(),session.dateKeyFormat)>
					<cfset args[2]=LSTimeFormat(item.getCreated())></cfsilent>
					<li class="created">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.createdlong"),args)#</li>
					</cfif>
					<cfif isNumeric(item.getMajorVersion()) and item.getMajorVersion()><li class="version">#application.rbFactory.getKeyValue(session.rb,"sitemanager.version")#: <strong>#item.getMajorVersion()#.#item.getMinorVersion()#</strong></li></cfif>
					<cfif isDate(item.getExpires())><li class="expiration">#application.rbFactory.getKeyValue(session.rb,"sitemanager.expiration")#: <strong>#LSDateFormat(item.getExpires(),session.dateKeyFormat)#</strong></li></cfif>
					<cfif isNumeric(item.getFileSize()) and item.getFileSize()><li class="size">#application.rbFactory.getKeyValue(session.rb,"sitemanager.size")#: <strong>#$.renderFileSize(item.getFileSize())#</strong></li></cfif>
					<cfset categories=item.getCategoriesIterator()>
					<cfif categories.hasNext()>
					<li class="categories">#application.rbFactory.getKeyValue(session.rb,"sitemanager.categories")#: <strong>
						<cfloop condition="categories.hasNext()">
							<cfset category=categories.next()>
							#HTMLEditFormat(category.getName())#<cfif categories.hasPrevious()>, </cfif>
						</cfloop>
						</strong>
					</cfif></dd>
					<cfif len(item.getTags())><li class="tags">#application.rbFactory.getKeyValue(session.rb,"sitemanager.tags")#: <strong>#item.getTags()#</strong></li></cfif>
					<li class="type">#application.rbFactory.getKeyValue(session.rb,"sitemanager.type")#: <strong>#item.getType()# (#item.getSubType()#)</strong></li>
				</ul>
			</tr>
		</cfloop>
		<cfelse>
			<tr>
				<td colspan="3">#application.rbFactory.getKeyValue(session.rb,"sitemanager.noresults")#</td>
			</tr>	
		</cfif>
	</table>

	#pagination#

</div>


<div class="sidebar span3">
	<!---<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports")#</h2>--->
	<div class="well">
		<ul id="navReports" class="nav nav-list">
			<li><a href="" data-report=""<cfif not len($.event("report"))> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.all")#</a></li>
			<li><a href="" data-report="expires"<cfif $.event("report") eq "expires"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.expires")#</a></li>
			<li><a href="" data-report="myexpires"<cfif $.event("report") eq "myexpires"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.myexpires")#</a></li>
			<li><a href="" data-report="mydrafts"<cfif $.event("report") eq "mydrafts"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.mydrafts")#</a></li>
			<li><a href="" data-report="mylockedfiles"<cfif $.event("report") eq "mylockedfiles"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.mylockedfiles")#</a></li>
		</ul>
	</div>
	
	<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.filters")#</h2>
	
	<div id="filters" class="module well">
	<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.keywords")#</h3>
    <input class="text" id="contentKeywords" value="#HTMLEditFormat(session.flatViewArgs["#rc.siteID#"].keywords)#" type="text" size="20" />
  	</div>

    <cfif $.event("report") neq "lockedfiles">
	<div class="module well">
		<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.type")#</h3>
		<select name="contentTypeFilter" id="contentTypeFilter">
			<option value="">#application.rbFactory.getKeyValue(session.rb,"sitemanager.all")#</option>
			<cfloop list="#$.getBean('contentManager').TreeLevelList#" index="i">
			<option value="#i#"<cfif listfind($.event('type'),i)> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#i#")#</option>
			</cfloop>
		</select>
	</div>
	</cfif>
		
	<cfsilent>
		<cfset tags=$.getBean('contentGateway').getTagCloud($.event('siteID')) />
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

	<input type="button" class="btn" name="filterList" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.filter")#" onclick="siteManager.loadSiteFlatByFilter();"/>
	<cfif session.flatViewArgs["#rc.siteID#"].filtered><input type="button" class="btn" name="filterList" value="#application.rbFactory.getKeyValue(session.rb,"sitemanager.removefilter")#" onclick="flatViewArgs=jQuery.extend(initFlatViewArgs(),{report:'#JSStringFormat(session.flatViewArgs["#rc.siteID#"].report)#',sortby:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].sortby)#', 
			sortdirection:'#JSStringFormat(session.flatViewArgs["#session.siteID#"].sortdirection)#',tag:'',type:'',subtype:'',categoryid:'',keywords:'',filtered:false});siteManager.loadSiteFlat(flatViewArgs);"/></cfif>
</div>
</div>

<!---<cfdump var="#rc.test#">--->
</cfoutput>
<!---</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>--->


