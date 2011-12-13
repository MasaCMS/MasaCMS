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
<cfscript>
	//data=structNew();
	
	$=application.serviceFactory.getBean("MuraScope");
	
	session.flatViewArgs[rc.siteID].moduleid=$.event("moduleid");
	session.flatViewArgs[rc.siteID].sortBy=$.event("sortby");
	session.flatViewArgs[rc.siteID].sortDirection=$.event("sortdirection");
	session.flatViewArgs[rc.siteID].lockid=$.event("lockid");
	session.flatViewArgs[rc.siteID].assignments=$.event("assignments");
	session.flatViewArgs[rc.siteID].categoryid=$.event("categoryid");
	session.flatViewArgs[rc.siteID].tag=$.event("tag");
	session.flatViewArgs[rc.siteID].startrow=$.event("startrow");
	session.flatViewArgs[rc.siteID].type=$.event("type");
	session.flatViewArgs[rc.siteID].subtype=$.event("subtype");
	session.flatViewArgs[rc.siteID].report=$.event("report");
	 
	feed=$.getBean("feed");
	feed.setMaxItems(500);
	feed.setNextN(20);
	feed.setLiveOnly(0);
	feed.setShowNavOnly(0);
	
	if(len($.event("tag"))){
		feed.addParam(field="tcontent.tags",criteria=$.event("tag"),condition="in");
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
	
	if($.event('report') eq "mylockedfiles"){
		feed.addParam(field="tcontentstats.lockid",condition=">",criteria="");	
	} else if($.event('report') eq "mylockedfiles"){
		feed.addParam(field="tcontentstats.lockid",condition="=",criteria=$.currentUser("userID"));
	} else if($.event('report') eq "expires"){
		feed.addParam(field="tcontent.expires",datatype="date",condition="<=",criteria=dateAdd("m",1,now()));
		feed.addParam(field="tcontent.expires",datatype="date",condition="is not",criteria="null");		
	} else if($.event('report') eq "myexpires"){
		feed.addParam(field="tcontent.expires",datatype="date",condition="<=",criteria=dateAdd("m",1,now()));
		feed.addParam(field="tcontent.expires",datatype="date",condition="is not",criteria="null");		
		feed.addParam(relationship="and (");
		feed.addParam(field="tcontentassignments.userid",datatype="varchar",condition="=",criteria=$.currentUser("userID"));
		feed.addParam(field="tcontentassignments.type",datatype="varchar",condition="=",criteria="expires");
		feed.addParam(relationship="or",field="tcontent.lastupdatebyid",datatype="varchar",condition="=",criteria=$.currentUser("userID"));
		feed.addParam(relationship=")");
	} else if($.event('report') eq "mydrafts"){
		draftList=$.getBean("contentManager").getDraftList($.event("siteID"));
		feed.addParam(field="tcontent.contentID",datatype="varchar",condition="in",criteria=valuelist(draftList.contentID));
	}
	
	iterator=feed.getIterator();
</cfscript>
</cfsilent>
<!---<cfsavecontent variable="data.html">--->
<cfoutput>
<div class="navSort">
	<h3>Sort by:</h3>
	<ul id="navTask">
		<!---<li><a href="" data-sortby="releasedate">Release Date</a></li>--->	
		<li><a href="" data-sortby="lastupdate"<cfif $.event("sortBy") eq "lastUpate"> class="active"</cfif>>Last Updated</a></li>
		<li><a href="" data-sortby="created"<cfif $.event("sortBy") eq "created"> class="active"</cfif>>Created</a></li>
		<!---<li><a href="" data-sortby="releasedate"<cfif $.event("sortBy") eq "releasedate"> class="active"</cfif>>Release Date</a></li>--->
		<li><a href="" data-sortby="menutitle"<cfif $.event("sortBy") eq "menutitle"> class="active"</cfif>>Title</a></li>
	</ul>
</div>
<table class="mura-table-grid stripe">
	<tr>
		<th></th>
	  	<th class="item">Item</th>
		<!---<th nowrap class="administration">&nbsp;</th>--->
	</tr> 
 	<cfif iterator.hasNext()>
	<cfloop condition="iterator.hasNext()">
	<cfsilent>
	<cfset item=iterator.next()>
	<cfset crumbdata=application.contentManager.getCrumbList(item.getContentID(), item.getSiteID())/>
	<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
	<cfif application.settingsManager.getSite(item.getSiteID()).getLocking() neq 'all' and verdict neq 'none'>
		<cfset newcontent=1>
	<cfelse>
		<cfset newcontent=0>
	</cfif>
	<cfset deletable=((item.getParentID() neq '00000000000000000000000000000000001' and application.settingsManager.getSite(item.getSiteID()).getLocking() neq 'all') or (item.getParentID() eq '00000000000000000000000000000000001' and application.settingsManager.getSite(item.getSiteID()).getLocking() eq 'none')) and (verdict eq 'editor')  and item.getIsLocked() neq 1>
	</cfsilent>	
	<tr data-siteid="#item.getSiteID()#" data-contentid="#item.getContentID()#" data-contenthistid="#item.getContentHistID()#" data-sortby="#item.getSortBy()#" data-sortdirection="#item.getSortDirection()#" data-moduleid="#HTMLEditFormat(item.getModuleID())#" data-type="#item.getType()#">
		<td class="add"><a class="add" href="javascript:;" onmouseover="showMenu('newContentMenu',#newcontent#,this,'#item.getContentID()#','#item.getContentID()#','#item.getContentID()#','#item.getSiteID()#','#item.getType()#');"></a></td>
		<td class="varWidth item">
		
		<div class="admin">
			<ul class="siteSummary five">
				<cfif verdict neq 'none'>
			     <li class="edit"><a title="Edit" class="draftprompt" href="index.cfm?fuseaction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getParentID()#&topid=#URLEncodedFormat(item.getParentID())#&siteid=#URLEncodedFormat(item.getSiteid())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">&nbsp;</a></li>
				   <cfswitch expression="#item.gettype()#">
					<cfcase value="Page,Portal,Calendar,Gallery">
					<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),item.getfilename())#','#item.gettargetParams()#');">Preview</a></li>
					</cfcase>
					<cfcase value="Link">
					<li class="preview"><a title="Preview" href="javascript:preview('#item.getfilename()#','#item.gettargetParams()#');">Preview</a></li>
					</cfcase>
					<cfcase value="File">
					<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),"")#?LinkServID=#item.getcontentid()#','#item.gettargetParams()#');">Preview</a></li>
					</cfcase>
					</cfswitch>
				   <li class="versionHistory"><a title="Version History" href="index.cfm?fuseaction=cArch.hist&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#item.getcontentID()#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">&nbsp;</a></li>
			      <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(item.getSiteID()).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
			        <li class="permissions"><a title="Permissions" href="index.cfm?fuseaction=cPerm.main&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#item.getcontentID()#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">&nbsp;</a></li>
			      <cfelse>
					  <li class="permissionsOff"><a>Permissions</a></li>
					</cfif>
			      <cfif deletable>
			        <li class="delete"><a title="Delete" href="index.cfm?fuseaction=cArch.update&contentid=#item.getContentID()#&type=#item.gettype()#&action=deleteall&topid=#item.getcontentID()#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&parentid=#URLEncodedFormat(item.getParentID())#&startrow=#$.event('startrow')#"
						<cfif listFindNoCase("Page,Portal,Calendar,Gallery,Link,File",item.gettype())>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),item.getmenutitle()))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"</cfif>>&nbsp;</a></li>
			       <cfelseif attributes.locking neq 'all'>
			        <li class="deleteOff">Delete</li>
			      </cfif>
			  <cfelse>
			      <li class="editOff">&nbsp;</li>
					<cfswitch expression="#item.gettype#">
					<cfcase value="Page,Portal,Calendar,Gallery">
					<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),item.getfilename())#','#item.gettargetParams()#');">Preview</a></li>
					</cfcase>
					<cfcase value="Link">
					<li class="preview"><a title="Preview" href="javascript:preview('#item.getfilename()#','#item.gettargetParams()#');">Preview</a></li>
					</cfcase>
					<cfcase value="File">
					<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),"")#?LinkServID=#item.getcontentid()#','#item.gettargetParams()#');">Preview</a></li>
					</cfcase>
					</cfswitch>
					<li class="versionHistoryOff"><a>Version History</a></li>
					<li class="permissionsOff"><a>Permissions</a></li>
					<li class="deleteOff"><a>Delete</a></li>
			</cfif>
			</ul>
		</div> 
		

		<h3>
			<cfif verdict neq 'none'>
				<a title="Edit" class="draftprompt" href="index.cfm?fuseaction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getParentID()#&topid=#URLEncodedFormat(item.getParentID())#&siteid=#URLEncodedFormat(item.getSiteid())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">#HTMLEditFormat(item.getMenuTitle())#</a>
			<cfelse>
				#HTMLEditFormat(item.getMenuTitle())#
			</cfif>	
		</h3>
		<cfif listFindNoCase("png,jpg,jpeg,gif",item.getFileExt())>
		<div class="thumbnail"><img src="#item.getImageURL(size='small')#" /></div>
		</cfif>
			<cfif len(item.getLockID())>
				<cfset lockedBy=$.getBean("user").loadBy(item.getLockID())>
				<p class="locked-offline">The associated file is locked for offline editing by #HTMLEditFormat(lockedBy.getFName())# #HTMLEditFormat(lockedBy.getLName())#</p>
			</cfif>
			<ul class="nodeMeta">
				<li class="updated">Updated on #LSDateformat(item.getlastUpdate(),session.dateKeyFormat)# at #LSTimeFormat(item.getLastUpdate())#  by #HTMLEditFormat(item.getLastUpdateBy())#</li>
				<cfif isNumeric(item.getMajorVersion()) and item.getMajorVersion()><li class="version">Version: <strong>#item.getMajorVersion()#.#item.getMinorVersion()#</strong></li></cfif>
				<cfif isDate(item.getExpires())><li class="expiration">Expiration: <strong>#LSDateFormat(item.getExpires(),session.dateKeyFormat)#</strong></li></cfif>
				<cfif isNumeric(item.getFileSize()) and item.getFileSize()><li class="size">Size: <strong>#$.renderFileSize(item.getFileSize())#</strong></li></cfif>
				<cfset categories=item.getCategoriesIterator()>
				<cfif categories.hasNext()>
				<li class="categories">Categories: <strong>
					<cfloop condition="categories.hasNext()">
						<cfset category=categories.next()>
						#HTMLEditFormat(category.getName())#<cfif categories.hasPrevious()>, </cfif>
					</cfloop>
					</strong>
				</cfif></dd>
				<cfif len(item.getTags())><li class="tags">Tags: <strong>#item.getTags()#</strong></li></cfif>
				<li class="type">Type: <strong>#item.getType()# (#item.getSubType()#)</strong></li>
				<li class="crumblist">#application.contentRenderer.dspZoom(crumbdata,item.getFileEXT(),true)#</li>
			</ul>
			
			
			
	<!---<td class="administration">
			<ul class="siteSummary five">
			<cfif verdict neq 'none'>
		       <li class="edit"><a title="Edit" class="draftprompt" href="index.cfm?fuseaction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getParentID()#&topid=#URLEncodedFormat(item.getParentID())#&siteid=#URLEncodedFormat(item.getSiteid())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">&nbsp;</a></li>
			   <cfswitch expression="#item.gettype()#">
				<cfcase value="Page,Portal,Calendar,Gallery">
				<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),item.getfilename())#','#item.gettargetParams()#');">Preview</a></li>
				</cfcase>
				<cfcase value="Link">
				<li class="preview"><a title="Preview" href="javascript:preview('#item.getfilename()#','#item.gettargetParams()#');">Preview</a></li>
				</cfcase>
				<cfcase value="File">
				<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),"")#?LinkServID=#item.getcontentid()#','#item.gettargetParams()#');">Preview</a></li>
				</cfcase>
				</cfswitch>
			   <li class="versionHistory"><a title="Version History" href="index.cfm?fuseaction=cArch.hist&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#item.getcontentID()#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">&nbsp;</a></li>
		        <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(item.getSiteID()).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
		          <li class="permissions"><a title="Permissions" href="index.cfm?fuseaction=cPerm.main&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#item.getcontentID()#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">&nbsp;</a></li>
		        <cfelse>
				  <li class="permissionsOff"><a>Permissions</a></li>
				</cfif>
		        <cfif deletable>
		          <li class="delete"><a title="Delete" href="index.cfm?fuseaction=cArch.update&contentid=#item.getContentID()#&type=#item.gettype()#&action=deleteall&topid=#item.getcontentID()#&siteid=#URLEncodedFormat(item.getSiteID())#&moduleid=#item.getmoduleid()#&parentid=#URLEncodedFormat(item.getParentID())#&startrow=#$.event('startrow')#"
					<cfif listFindNoCase("Page,Portal,Calendar,Gallery,Link,File",item.gettype())>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),item.getmenutitle()))#',this.href)"<cfelse>onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"</cfif>>&nbsp;</a></li>
		         <cfelseif attributes.locking neq 'all'>
		          <li class="deleteOff">Delete</li>
		        </cfif>
	        <cfelse>
		        <li class="editOff">&nbsp;</li>
				<cfswitch expression="#item.gettype#">
				<cfcase value="Page,Portal,Calendar,Gallery">
				<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),item.getfilename())#','#item.gettargetParams()#');">Preview</a></li>
				</cfcase>
				<cfcase value="Link">
				<li class="preview"><a title="Preview" href="javascript:preview('#item.getfilename()#','#item.gettargetParams()#');">Preview</a></li>
				</cfcase>
				<cfcase value="File">
				<li class="preview"><a title="Preview" href="javascript:preview('http://#application.settingsManager.getSite(item.getSiteID()).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(item.getSiteID(),"")#?LinkServID=#item.getcontentid()#','#item.gettargetParams()#');">Preview</a></li>
				</cfcase>
				</cfswitch>
				<li class="versionHistoryOff"><a>Version History</a></li>
				<li class="permissionsOff"><a>Permissions</a></li>
				<li class="deleteOff"><a>Delete</a></li>
	      </cfif>
	      </ul>
		</td>--->
	</tr>
	</cfloop>
	<cfelse>
		<tr>
			<td colspan="3">Your search returned no results.</td>
		</tr>	
	</cfif>
</table>

<div class="sidebar">
	<h3>Reports</h3>
	<ul id="navReports" class="module">
		<li><a href="" data-report=""<cfif not len($.event("report"))> class="active"</cfif>>All Site Content</a></a></li>
		<li><a href="" data-report="expires"<cfif $.event("report") eq "expires"> class="active"</cfif>>All Expiring Content</a></li>
		<li><a href="" data-report="myexpires"<cfif $.event("report") eq "myexpires"> class="active"</cfif>>My Expiring Content</a></li>
		<li><a href="" data-report="mydrafts"<cfif $.event("report") eq "mydrafts"> class="active"</cfif>>My Drafts</a></li>
		<li><a href="" data-report="mylockedfiles"<cfif $.event("report") eq "mylockedfiles"> class="active"</cfif>>Files I'm Editing Offline</a></li>
	</ul>
	
	<cfset tags=$.getBean('contentGateway').getTagCloud($.event('siteID')) />
	<cfset categoryCount=$.getBean("categoryManager").getCategoryCount($.event("siteID"))>
	
	<cfif $.event("report") neq "lockedfiles" 
		or tags.recordcount 
		or categoryCount>
	<h3>Filters</h3>
	<cfif $.event("report") neq "lockedfiles">
	<div id="filters" class="module">
	<h4>Type</h4>
	<select name="contentTypeFilter" id="contentTypeFilter">
		<option value="">All</option>
		<cfloop list="#$.getBean('contentManager').TreeLevelList#" index="i">
		<option value="#i#"<cfif listfind($.event('type'),i)> selected</cfif>>#i#</option>
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
	<div class="module">
	<h4>Tags</h4>
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

	<cfif categoryCount>
	<div class="module">
	<h4>Categories</h4>
	<cf_dsp_categories_nest siteID="#$.event('siteID')#" parentID="" nestLevel="0" categoryid="#$.event('categoryid')#">
	</cfif>
	
	</div>
	<input type="button" name="filterList" value="Filter" onclick="loadSiteFlatByFilter();"/>
	</cfif>
</div>
<!---<cfdump var="#request.test#">--->
</cfoutput>
<!---</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>--->
