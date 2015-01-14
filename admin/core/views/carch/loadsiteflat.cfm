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
<cfset poweruser=$.currentUser().isSuperUser() or $.currentUser().isAdminUser()>
<cftry>
<cfscript>
	//data=structNew();
	
	$=application.serviceFactory.getBean("MuraScope");

	if(!listFindNoCase('myexpires,expires',$.event('report')) && $.event('sortby') == 'expiration'){
		$.event('sortby','lastupdate');
	} else if(!listFindNoCase('mysubmissions,myapprovals',$.event('report')) && $.event('sortby') == 'duedate'){
		$.event('sortby','lastupdate');
	}
	
	session.flatViewArgs["#rc.siteID#"].moduleid=$.event("moduleid");
	session.flatViewArgs["#rc.siteID#"].sortBy=$.event("sortby");
	session.flatViewArgs["#rc.siteID#"].sortDirection=$.event("sortdirection");
	session.flatViewArgs["#rc.siteID#"].lockid=$.event("lockid");
	session.flatViewArgs["#rc.siteID#"].assignments=$.event("assignments");
	session.flatViewArgs["#rc.siteID#"].categoryid=$.event("categoryid");
	session.flatViewArgs["#rc.siteID#"].tags=$.event("tags");
	session.flatViewArgs["#rc.siteID#"].page=$.event("page");
	session.flatViewArgs["#rc.siteID#"].type=$.event("type");
	session.flatViewArgs["#rc.siteID#"].subtype=$.event("subtype");
	session.flatViewArgs["#rc.siteID#"].subtype=$.event("subtype");
	session.flatViewArgs["#rc.siteID#"].report=$.event("report");
	session.flatViewArgs["#rc.siteID#"].keywords=$.event("keywords");
	session.flatViewArgs["#rc.siteID#"].filtered=yesNoFormat($.event("filtered"));
	session.flatViewArgs["#rc.siteID#"].tab=1;

	//writeDump(var=session.flatViewArgs["#rc.siteID#"],abort=true);

	if(len($.siteConfig('customTagGroups'))){
		taggrouparray=listToArray($.siteConfig('customTagGroups'));
		for(g=1;g <= arrayLen(taggrouparray);g++){
			session.flatViewArgs["#rc.siteID#"]["#taggrouparray[g]#tags"]=$.event("#taggrouparray[g]#tags");
		}
	}
	 
	feed=$.getBean("feed");
	feed.setMaxItems(500);
	feed.setNextN(10);
	feed.setLiveOnly(0);
	feed.setShowNavOnly(0);
	
	paramsStarted=false;
	tagStarted=false;

	if(len($.event("tags"))){
		tagStarted=true;
		paramsStarted=true;
		feed.addParam(relationship="and (");
		feed.addParam(field="tcontenttags.tag",criteria=$.event("tags"),condition="in");
	}

	if(len($.siteConfig('customTagGroups'))){
		tagGroupArray=listToArray($.siteConfig('customTagGroups'),'^,');
		paramsStarted=true;
 		for(g=1;g <= arrayLen(tagGroupArray); g++ ){
 			if(len($.event("#tagGroupArray[g]#tags"))){
	 			if(!tagStarted){
	 				tagStarted=true;
	 				feed.addParam(relationship="and (");
	 				feed.addParam(relationship="(",field="tcontenttags.tag",criteria=$.event("#tagGroupArray[g]#tags"),condition="in");
	 			} else {
	 				feed.addParam(relationship="or (",field="tcontenttags.tag",criteria=$.event("#tagGroupArray[g]#tags"),condition="in");
	 			}

	 			feed.addParam(relationship="and",field="tcontenttags.taggroup",criteria=tagGroupArray[g]);
	 			feed.addParam(relationship=")");
 			}
 		}
	}

	if(tagStarted){
		feed.addParam(relationship=")");
	}
	
	if(len($.event("type"))){
		paramsStarted=true;
		feed.addParam(field="tcontent.type",criteria=$.event("type"),condition="in");	
	}
	
	if(len($.event("subtype"))){
		paramsStarted=true;
		feed.addParam(field="tcontent.subtype",criteria=$.event("subtype"));	
	}
	
	if(len($.event("categoryID"))){
		paramsStarted=true;
		feed.setCategoryID($.event("categoryID"));	
	}
	
	if(!(listFindNoCase('myapprovals,mysubmissions',$.event("report")) && $.event("sortby") == 'duedate')){
		feed.setSortBy($.event("sortBy"));
	} else {
		feed.setSortBy("lastupdate");
		feed.setSortBy("desc");
	}
	
	if(len($.event("sortDirection"))){
		feed.setSortDirection($.event("sortDirection"));	
	}
	
	if($.event('report') eq "lockedfiles"){
		paramsStarted=true;
		feed.addParam(field="tcontentstats.lockid",condition=">",criteria="");	
	
	} else if($.event('report') eq "mylockedcontent"){
		paramsStarted=true;
		feed.addParam(field="tcontentstats.lockid",condition="=",criteria=$.currentUser("userID"));
	
	} else if($.event('report') eq "expires"){
		paramsStarted=true;
		feed.addParam(field="tcontent.expires",datatype="date",condition="<=",criteria=dateAdd("m",1,now()));
		feed.addParam(field="tcontent.expires",datatype="date",condition=">",criteria=dateAdd("m",-12,now()));		
	
	} else if($.event('report') eq "myexpires"){
		paramsStarted=true;
		subList=$.getBean("contentManager").getExpiringContent($.event("siteID"),$.currentUser("userID"));
		feed.addParam(field="tcontent.contentID",datatype="varchar",condition="in",criteria=valuelist(subList.contentID));
	
	} else if($.event('report') eq "mydrafts"){
		paramsStarted=true;
		drafts=$.getBean("contentManager").getDraftList(siteid=$.event("siteID"), startdate=dateAdd('m',-3,now()));
		//writeDump(var=drafts,abort=true);
		feed.addParam(field="tcontent.contentid",datatype="varchar",condition="in",criteria=valuelist(drafts.contentid));
		feed.setLiveOnly(0);
		//writeDump(var=feed.getQuery(),abort=true);
	} else if($.event('report') eq "myapprovals"){
		paramsStarted=true;
		drafts=$.getBean("contentManager").getApprovalsQuery($.event("siteID"));
		//writeDump(var=drafts,abort=true);
		feed.addParam(field="tcontent.contentid",datatype="varchar",condition="in",criteria=valuelist(drafts.contentid));
		feed.setLiveOnly(0);

	} else if($.event('report') eq "mysubmissions"){
		paramsStarted=true;
		drafts=$.getBean("contentManager").getSubmissionsQuery($.event("siteID"));
		//writeDump(var=subList,abort=true);
		feed.addParam(field="tcontent.contentid",datatype="varchar",condition="in",criteria=valuelist(drafts.contentid));
		feed.setLiveOnly(0);

	}
	
	if(len($.event("keywords"))){	
		paramsStarted=true;
		subList=$.getBean("contentManager").getPrivateSearch($.event("siteID"),$.event("keywords"));
		feed.addParam(field="tcontent.contentID",datatype="varchar",condition="in",criteria=valuelist(subList.contentID));
	}

	if(!paramsStarted ){
		if( isNumeric($.globalConfig('defaultflatviewrange')) && $.globalConfig('defaultflatviewrange') ){
			feed.addParam(field="tcontent.lastupdate",criteria=dateAdd('d',-$.globalConfig('defaultflatviewrange'),now()),condition=">=",datatype='datetime');
		}
		if( len($.globalConfig('defaultflatviewtable')) ){
			feed.setTable($.globalConfig('defaultflatviewtable'));
		}
	}
	
	iterator=feed.getIterator();

/*
	if(iterator.getRecordcount() and $.event('report') eq 'mydrafts'){
		rs=iterator.getQuery();
		//writeDump(var=drafts,abort=true);
		for(i=1;i lte rs.recordcount;i++){
			qs= new Query(dbType='query',sql='select max(lastupdate) as mostrecent from drafts where contentid= :contentID');
			qs.addParam(name='contentID',cfsqltype='cf_sql_varchar',value=rs.contentid[i]);

			rstemp=qs.execute().getResult();

			querySetCell(rs, "lastupdate", rstemp.mostrecent, i);
		}

		if($.event('sortby') eq 'lastupdate'){
			qs= new Query(dbType='query',sql="select * from rs order by lastupdate #feed.getSortDirection()#")
			.execute()
			.getResult();
		}
		iterator.setQuery(rs,feed.getNextN());
	}

	iterator.setPage($.event('page'));

*/

if(len($.siteConfig('customTagGroups'))){
	taglabel=application.rbFactory.getKeyValue(session.rb,"sitemanager.defaulttags");
} else {
	taglabel=application.rbFactory.getKeyValue(session.rb,"sitemanager.tags");
}

</cfscript>

<cfif iterator.getRecordcount()>

	<cfif listFindNoCase('mysubmissions,myapprovals',$.event('report'))>
		<cfset rs=iterator.getQuery()>

		<cfset queryAddColumn(rs, "approvalStatus", 'varchar', [])>
		<cfset queryAddColumn(rs, "duedate", 'timestamp', [])>

			<cfloop query="rs">
				<cfquery name="rstemp" dbtype="query">
					select max(lastupdate) as maxLastUpdate,max(displayStart) as maxDisplayStart,max(publishDate) as maxPublishDate from drafts 
					where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contentid#">
				</cfquery>

				<cfset querySetCell(rs, "lastupdate", rstemp.maxLastUpdate, rs.currentrow)>
				<cfset querySetCell(rs, "approvalStatus", 'Pending', rs.currentrow)>

				<cfif isDate(rstemp.maxpublishDate)>
					<cfset querySetCell(rs, "duedate", rstemp.maxpublishDate, rs.currentrow)>
				<cfelseif isDate(rstemp.maxdisplayStart)>
					<cfset querySetCell(rs, "duedate", rstemp.maxdisplayStart, rs.currentrow)>
				</cfif>
				
			</cfloop>
			<cfif $.event('sortby') eq 'lastupdate'>
				<cfquery name="rs" dbtype="query">
					select * from rs order by lastupdate #feed.getSortDirection()#
				</cfquery>
			<cfelseif $.event('sortby') eq 'duedate'>
				<cfquery name="rs" dbtype="query">
					select * from rs order by duedate #feed.getSortDirection()#, lastupdate #feed.getSortDirection()#
				</cfquery>
			</cfif>
			
			<cfset iterator.setQuery(rs,feed.getNextN())>
	<cfelseif listFindNoCase('mydrafts',$.event('report'))>
		<cfset rs=iterator.getQuery()>

		<cfloop query="rs">
			<cfquery name="rstemp" dbtype="query">
				select max(lastupdate) as mostrecent from drafts 
				where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contentid#">
			</cfquery>
			
			<cfset querySetCell(rs, "lastupdate", rstemp.mostrecent, rs.currentrow)>
				
		</cfloop>
		<cfif $.event('sortby') eq 'lastupdate'>
			<cfquery name="rs" dbtype="query">
				select * from rs order by lastupdate #feed.getSortDirection()#
			</cfquery>
		</cfif>
		
		<cfset iterator.setQuery(rs,feed.getNextN())>
	</cfif>	
</cfif>

<cfset iterator.setPage($.event('page'))>

<cfcatch>
	<cfdump var="#cfcatch#" abort="true">
</cfcatch>
</cftry>

</cfsilent>

<div class="row-fluid">
	<cfsilent>
<cfsavecontent variable="pagination">
<cfoutput>
	<cfif iterator.hasNext()>
		<cfset args=arrayNew(1)>
		<cfset args[1]="#iterator.getFirstRecordOnPageIndex()#-#iterator.getLastRecordOnPageIndex()#">
		<cfset args[2]=iterator.getRecordCount()>
		
		<div class="mura-results-wrapper">
		<p class="search-showing">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.paginationmeta"),args)#</p>
		<cfif iterator.pageCount() gt 1>
		<div class="pagination">
			<ul class="moreResults">
				<cfif $.event('page') gt 1><li class="navPrev"><a href="" data-page="#evaluate($.event('page')-1)#">&laquo;</a></li></cfif>
				<cfloop from="#max($.event('page')-5,1)#" to="#min($.event('page')+5,iterator.pageCount())#" index="p">
				<li<cfif $.event('page') eq p> class="active"</cfif>><a href="" data-page="#p#"<cfif $.event('page') eq p> class="active"</cfif>>#p#</a></li>
				</cfloop>
				<cfif $.event('page') lt iterator.pageCount()><li class="navNext"><a href="" data-page="#evaluate($.event('page')+1)#">&raquo;</a></li></cfif>	
			</ul>
		</div>
		</cfif>
		</div>
	</cfif>	
</cfoutput>	
</cfsavecontent>

<cfset hasCustomImage=structKeyExists(getMetaData($.getBean('fileManager').getValue('imageProcessor')),'getCustomImage')>
</cfsilent>
<cfoutput>
<div id="main" class="span9">
<cfif not len($.event("report"))>
<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.all")#</h2>	
<cfelseif $.event('report') eq 'mylockedcontent'>
	<cfif $.siteConfig('hasLockableNodes')>
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.mylockedcontent")#</h2>
	<cfelse>
		<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.mylockedfiles")#</h2>
	</cfif>
<cfelse>
<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.#$.event('report')#")#</h2>	
</cfif>

	<div class="navSort">
		<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.sortby")#:&nbsp;</h3>
		<ul class="navTask nav nav-pills">
			<!---<li><a href="" data-sortby="releasedate">Release Date</a></li>--->	
			<li><a href="" data-sortby="lastupdate"<cfif $.event("sortBy") eq "lastUpdate"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.lastupdated")#</a></li>
			<li><a href="" data-sortby="created"<cfif $.event("sortBy") eq "created"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.created")#</a></li>
			<!---<li><a href="" data-sortby="releasedate"<cfif $.event("sortBy") eq "releasedate"> class="active"</cfif>>Release Date</a></li>--->
			<li><a href="" data-sortby="menutitle"<cfif $.event("sortBy") eq "menutitle"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.title")#</a></li>
			<cfif listfindNoCase('mysubmissions,myapprovals',$.event('report'))>
				<li><a href="" data-sortby="duedate"<cfif $.event("sortBy") eq "duedate"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.duedate")#</a></li>
			</cfif>
			<cfif listfindNoCase('myexpires,expires',$.event('report'))>
				<li><a href="" data-sortby="expiration"<cfif $.event("sortBy") eq "expiration"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.expiration")#</a></li>
			</cfif>
		</ul>
	</div>

	#pagination#

	<table class="mura-table-grid">
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
		<cfset isLocked=$.siteConfig('hasLockableNodes') and len(item.getLockID()) and item.getLockType() eq 'node'>
		<cfset isLockedBySomeoneElse=isLocked and item.getLockID() neq session.mura.userid>
		
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

		<cfset editLink="./?muraAction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getParentID()#&topid=#esapiEncode('url',topID)#&siteid=#esapiEncode('url',item.getSiteid())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">

		<!---
		<cfif $.event('report') eq "mydrafts">
			<cfquery dbtype="query" name="rsHasPendingApprovals">
				select * from sublist 
				where 
				contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#item.getContentID()#">
				and approvalStatus='Pending'
			</cfquery>
			<cfquery dbtype="query" name="rsHasDrafts">
				select * from sublist 
				where 
				contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#item.getContentID()#">
				and approvalStatus != 'Pending'
			</cfquery>
		</cfif>
		--->
		</cfsilent>
	
		<tr data-siteid="#item.getSiteID()#" data-contentid="#item.getContentID()#" data-contenthistid="#item.getContentHistID()#" data-sortby="#item.getSortBy()#" data-sortdirection="#item.getSortDirection()#" data-moduleid="#esapiEncode('html_attr',item.getModuleID())#" data-type="#item.getType()#" class="mura-node-data">
			<td class="add"><a class="add" href="javascript:;" onmouseover="siteManager.showMenu('newContentMenu','#newcontent#',this,'#item.getContentID()#','#item.getContentID()#','#item.getContentID()#','#item.getSiteID()#','#item.getType()#');"><i class="icon-plus-sign"></i></a></td>
			<td class="var-width item">
			
			<div class="actions">
				<ul class="siteSummary">
					<cfif not listFindNoCase('none,read',verdict) or $.event('report') eq 'mydrafts'>
					 
					    <li class="edit<cfif isLockedBySomeoneElse> disabled</cfif>"><a title="Edit" class="draftprompt" href="#editLink#"><i class="icon-pencil"></i></a></li>
						
						<cfswitch expression="#item.gettype()#">
							<cfcase value="File">
							<li class="download"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.download')#" href="#application.configBean.getContext()#/index.cfm/_api/render/file/?fileID=#item.getFileID()#&method=attachment" onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm'))#',this.href)"><i class="icon-download"></i></a></li>
							</cfcase>
							<cfdefaultcase>
							<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.preview')#" href="##" onclick="return preview('#item.getURL(complete=1)#');"><i class="icon-globe"></i></a></li>
							</cfdefaultcase>
						</cfswitch>
						 
						 <li class="version-history"><a title="Version History" href="./?muraAction=cArch.hist&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#esapiEncode('url',topid)#&siteid=#esapiEncode('url',item.getSiteID())#&moduleid=#item.getmoduleid()#&startrow=#esapiEncode('url',$.event('startrow'))#"><i class="icon-book"></i></a></li>
					      
					    <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(item.getSiteID()).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
					        <li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.permissions')#" href="./?muraAction=cPerm.main&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getparentID()#&topid=#esapiEncode('url',topID)#&siteid=#esapiEncode('url',item.getSiteID())#&moduleid=#item.getmoduleid()#&startrow=#esapiEncode('url',$.event('startrow'))#"><i class="icon-group"></i></a></li>
					    <cfelse>
							<li class="permissions disabled"><a><i class="icon-group"></i></a></li>
						</cfif>
					    
					    <cfif deletable and not isLockedBySomeoneElse>
					        <li class="delete"><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.delete')#" href="./?muraAction=cArch.update&contentid=#item.getContentID()#&type=#item.gettype()#&action=deleteall&topid=#esapiEncode('url',topID)#&siteid=#esapiEncode('url',item.getSiteID())#&moduleid=#item.getmoduleid()#&parentid=#esapiEncode('url',item.getParentID())#&startrow=#esapiEncode('url',$.event('startrow'))##rc.$.renderCSRFTokens(context=item.getContentID() & 'deleteall',format='url')#"<cfif listFindNoCase("Page,Portal,Calendar,Gallery,Link,File",item.gettype())>onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),item.getmenutitle()))#',this.href)"<cfelse>onclick="return confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentconfirm'))#',this.href)"</cfif>>
							<i class="icon-remove-sign"></i></a></li>
					    <cfelseif rc.locking neq 'all'>
					        <li class="delete disabled"><i class="icon-remove-sign"></i></li>
					    </cfif>
					
					<cfelse>
					    <li class="edit disabled"><i class="icon-pencil"></i></li>
						<li class="preview"><a title="Preview" href="##" onclick="return preview('#item.getURL(complete=1)#');"><i class="icon-globe"></i></a></li>
						<li class="version-history disabled"><a><i class="icon-book"></i></a></li>
						<li class="permissions disabled"><a><i class="icon-group"></i></a></li>
						<li class="delete disabled"><a><i class="icon-remove-sign"></i></a></li>
					</cfif>
					
				</ul>
			</div> 
			
			<!---
			<cfif listFindNoCase('mysubmissions,myapprovals',$.event('report')) and isDate(item.getDueDate())>
				<p><i class="icon-calendar"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.due')#: #LSDateFormat(item.getDueDate(),session.dateKeyFormat)#</p>
			</cfif>
			--->
			<!---
			<a href="##" data-toggle="tooltip" rel="tooltip" data-html="true" title="#esapiEncode('html_attr',$.dspZoomText(crumbData=crumbdata,ajax=true))#">
				Crumblist as Tooltip</a> 
			--->
			
			<h2>
				<cfif not listFindNoCase('none,read',verdict) or listFindNoCase('myapprovals,mysubmissions',$.event('report'))>
					<a class="draftprompt" title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.edit')#" class="draftprompt"  href="./?muraAction=cArch.edit&contenthistid=#item.getContentHistID()#&contentid=#item.getContentID()#&type=#item.gettype()#&parentid=#item.getParentID()#&topid=#esapiEncode('url',topID)#&siteid=#esapiEncode('url',item.getSiteid())#&moduleid=#item.getmoduleid()#&startrow=#$.event('startrow')#">#esapiEncode('html',item.getMenuTitle())#
						<!---
						<cfif $.event('report') eq 'mydrafts'>
							(
							<cfif rsHasPendingApprovals.recordcount>
									#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.pending')#
								<cfif rsHasDrafts.recordcount>,</cfif>
							</cfif>
							<cfif rsHasDrafts.recordcount>
								#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.draft')#
							</cfif>
							)
						</cfif>	
						--->
						<cfif listFindNoCase('myapprovals,mysubmissions',$.event('report'))>
							(<cfif item.getApprovalStatus() eq 'Pending'>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.pending')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.draft')#</cfif>)
						</cfif>

					</a>
				<cfelse>
					#esapiEncode('html',item.getMenuTitle())#
					<!---
					<cfif $.event('report') eq 'mydrafts'>
						(
						<cfif rsHasPendingApprovals.recordcount>
								#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.pending')#
							<cfif rsHasDrafts.recordcount>,</cfif>
						</cfif>
						<cfif rsHasDrafts.recordcount>
							#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.draft')#
						</cfif>
						)
					</cfif>
					--->
				</cfif>	
			</h2>
			<cfif listFindNoCase("png,jpg,jpeg,gif",item.getFileExt())>
			<div class="thumbnail"><a title="Edit" class="draftprompt" href="#editLink#"><cfif hasCustomImage><img src="#item.getImageURL(height=80,width=80)#" /><cfelse><img src="#item.getImageURL(size='small')#" /></cfif></a></div>
			</cfif>
				<cfif len(item.getLockID())>
					<cfset lockedBy=$.getBean("user").loadBy(item.getLockID())>
					<cfif item.getLockType() neq 'node'>
						<p class="locked-offline"><i class="icon-lock"></i> #application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.filelockedby"),"#esapiEncode('html_attr',lockedBy.getFName())# #esapiEncode('html',lockedBy.getLName())#")#</p>
					<cfelseif $.siteConfig('hasLockableNodes')>
						<p class="locked-offline"><i class="icon-lock"></i> #application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.nodelockedby"),"#esapiEncode('html_attr',lockedBy.getFName())# #esapiEncode('html',lockedBy.getLName())#")#</p>
					</cfif>
					
				</cfif>
				
				#$.dspZoom(crumbData=crumbdata,ajax=true)#

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
					<cfif isDate(item.getDueDate())><li class="duedate">#application.rbFactory.getKeyValue(session.rb,"sitemanager.duedate")#: <strong>#LSDateFormat(item.getDueDate(),session.dateKeyFormat)#</strong></li></<cfelseif isDate(item.getExpires())><li class="expiration">#application.rbFactory.getKeyValue(session.rb,"sitemanager.expiration")#: <strong>#LSDateFormat(item.getExpires(),session.dateKeyFormat)#</strong></li></cfif>
					<cfif isNumeric(item.getFileSize()) and item.getFileSize()><li class="size">#application.rbFactory.getKeyValue(session.rb,"sitemanager.size")#: <strong>#$.renderFileSize(item.getFileSize())#</strong></li></cfif>
					<cfset categories=item.getCategoriesIterator()>
					<cfif categories.hasNext()>
					<li class="categories">#application.rbFactory.getKeyValue(session.rb,"sitemanager.categories")#: <strong>
						<cfloop condition="categories.hasNext()">
							<cfset category=categories.next()>
							#esapiEncode('html',category.getName())#<cfif categories.hasNext()>, </cfif>
						</cfloop>
						</strong>
					</cfif></dd>
					<cfif len(item.getTags())><li class="tags">#taglabel#: <strong>#item.getTags()#</strong></li></cfif>
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
			<li><a href="" data-report=""<cfif not len($.event("report"))> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.all")#<!---<span class="badge">#$.getBean('contentGateway').getPageCount(siteid=session.siteid).counter#</span>---></a></li>
			<cfset draftCount=$.getBean('contentManager').getMyDraftsCount(siteid=session.siteid, startdate=dateAdd('m',-3,now()))>
			<li><a href="" data-report="mydrafts"<cfif $.event("report") eq "mydrafts"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.mydrafts")#<cfif draftCount><span class="badge badge-important">#draftCount#</span></cfif></a></li>
			<cfset draftCount=$.getBean('contentManager').getMySubmissionsCount(session.siteid)>
			<li><a href="" data-report="mysubmissions"<cfif $.event("report") eq "mysubmissions"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.mysubmissions")#<cfif draftCount><span class="badge badge-important">#draftCount#</span></cfif></a></li>
			<cfset draftCount=$.getBean('contentManager').getMyApprovalsCount(session.siteid)>
			<li><a href="" data-report="myapprovals"<cfif $.event("report") eq "myapprovals"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.myapprovals")#<cfif draftCount><span class="badge badge-important">#draftCount#</span></cfif></a></li>
			<cfset draftCount=$.getBean('contentManager').getMyExpiresCount(session.siteid)>
			<li><a href="" data-report="myexpires"<cfif $.event("report") eq "myexpires"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.myexpires")#<cfif draftCount><span class="badge badge-important">#draftCount#</span></cfif></a></li>
			<li><a href="" data-report="expires"<cfif $.event("report") eq "expires"> class="active"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.expires")#<!---<span class="badge badge-success">13</span>---></a></li>
			<cfset draftCount=$.getBean('contentManager').getmylockedcontentCount(session.siteid)>
			<li><a href="" data-report="mylockedcontent"<cfif $.event("report") eq "mylockedcontent"> class="active"</cfif>>
				<cfif $.siteConfig('hasLockableNodes')>
					#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.mylockedcontent")#
				<cfelse>
					#application.rbFactory.getKeyValue(session.rb,"sitemanager.reports.mylockedfiles")#
				</cfif>
				<cfif draftCount><span class="badge badge-important">#draftCount#</span></cfif></a></li>
		</ul>
	</div>
	
	<h2>#application.rbFactory.getKeyValue(session.rb,"sitemanager.filters")#</h2>
	
	<div id="filters" class="module well">
	<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.keywords")#</h3>
    <input class="text" id="contentKeywords" value="#esapiEncode('html_attr',session.flatViewArgs["#rc.siteID#"].keywords)#" type="text" size="20" />
  	</div>

    <cfif $.event("report") neq "lockedfiles">
	<div class="module well">
		<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.type")#</h3>
		<cfset rsTypes=application.configBean.getClassExtensionManager().getSubTypes(session.siteid)>
		<select name="contentTypeFilter" id="contentTypeFilter">
			<option value="">#application.rbFactory.getKeyValue(session.rb,"sitemanager.all")#</option>
			<cfloop list="#$.getBean('contentManager').getTreeLevelList()#" index="i">
				<option value="#i#^Default"<cfif $.event('type') eq i and $.event('subtype') eq 'Default'> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#i#")#<!---  / Default ---></option>
				<cfquery name="rsSubTypes" dbtype="query">
					select * from rsTypes where type='#i#' and subtype!='Default'
				</cfquery>
				<cfloop query="rsSubTypes">
					<option value="#i#^#rsSubTypes.subtype#"<cfif $.event('type') eq i and $.event('subtype') eq rsSubTypes.subtype> selected</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#i#")# / #rsSubTypes.subtype#</option>
				</cfloop>
			</cfloop>
		</select>
	</div>
	</cfif>
	

	<div class="module well" id="mura-filter-tags">
		<cfif len($.siteConfig('customTagGroups'))>
   		<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.defaulttags")#</h3>
   		<cfelse>
   		<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.tags")#</h3>
   		</cfif>

		<div id="tags" class="tagSelector">
			<cfloop list="#$.event('tags')#" index="i">
				<span class="tag">
				#esapiEncode('html',i)# <a><i class="icon-remove-sign"></i></a>
				<input name="tags" type="hidden" value="#esapiEncode('html_attr',i)#">
				</span>
			</cfloop>
			<input type="text" name="tags">
		</div>
	</div>

	<cfif len($.siteConfig('customTagGroups'))>
		<cfloop list="#$.siteConfig('customTagGroups')#" index="g" delimiters="^,">
			<div class="module well" id="mura-filter-tags">
				<h3>#g# #application.rbFactory.getKeyValue(session.rb,"sitemanager.tags")#</h3>
				<div id="#g#tags" class="tagSelector">
				<cfloop list="#$.event('#g#tags')#" index="i">
					<span class="tag">
					#esapiEncode('html',i)# <a><i class="icon-remove-sign"></i></a>
					<input name="#g#tags" type="hidden" value="#esapiEncode('html_attr',i)#">
					</span>
				</cfloop>
				<input type="text" name="#g#tags">
			</div>
		</div>
		</cfloop>
	</cfif>
	
	<cfif $.getBean("categoryManager").getCategoryCount($.event("siteID"))>
		<div class="module well" id="mura-list-tree">
		<h3>#application.rbFactory.getKeyValue(session.rb,"sitemanager.categories")#</h3>
		<cf_dsp_categories_nest siteID="#$.event('siteID')#" parentID="" nestLevel="0" categoryid="#$.event('categoryid')#">
		</div>
	</cfif>

	
	<cfif session.flatViewArgs["#rc.siteID#"].filtered>
		<button type="submit" class="btn" name="filterList" onclick="siteManager.loadSiteFlatByFilter();"><i class="icon-filter"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.filter")#</button>
		<button type="submit" class="btn" name="filterList" onclick="clearFlatviewFilter()"><i class="icon-filter"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.removefilter")#</button>
	<cfelse>
		<button type="submit" class="btn btn-block" name="filterList" onclick="siteManager.loadSiteFlatByFilter();"><i class="icon-filter"></i> #application.rbFactory.getKeyValue(session.rb,"sitemanager.filter")#</button>
	</cfif>
</div>
</div>

<script>
	function clearFlatviewFilter(){
		flatViewArgs=$.extend(
			initFlatViewArgs(),
			{
					report:'#esapiEncode('javascript',session.flatViewArgs["#rc.siteID#"].report)#',
					sortby:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].sortby)#', 
					sortdirection:'#esapiEncode('javascript',session.flatViewArgs["#session.siteID#"].sortdirection)#',
					tag:'',
					type:'',
					subtype:'',
					categoryid:'',
					keywords:''
					,
					filtered:false
					<cfif len($.siteConfig('customTagGroups'))>
					<cfloop list="#$.siteConfig('customTagGroups')#" index="g" delimiters="^,">
					,#g#tags:''	
					</cfloop>	
					</cfif>

					});

		siteManager.loadSiteFlat(flatViewArgs);
	}
</script>
<!---<cfdump var="#rc.test#">--->
</cfoutput>
<!---</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>--->


