<cfcomponent extends="controller" output="false">

<cffunction name="setContentManager" output="false">
	<cfargument name="contentManager">
	<cfset variables.contentManager=arguments.contentManager>
</cffunction>

<cffunction name="setContentUtility" output="false">
	<cfargument name="contentUtility">
	<cfset variables.contentUtility=arguments.contentUtility>
</cffunction>

<cffunction name="setContentGateway" output="false">
	<cfargument name="contentGateway">
	<cfset variables.contentGateway=arguments.contentGateway>
</cffunction>

<cffunction name="before" output="false">
	<cfargument name="rc">
	
	<cfparam name="session.openSectionList" default=""/>
	
	<cfif not variables.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid)>
		<cfset secure(arguments.rc)>
	</cfif>

	<cfparam name="arguments.rc.ajaxrequest" default="false"/>
	<cfparam name="arguments.rc.moduleid" default="00000000000000000000000000000000000"/>
	
	<cfif not arguments.rc.ajaxrequest>
		<cfparam name="arguments.rc.return" default=""/>
		<cfparam name="arguments.rc.startrow" default="1"/>
		<cfparam name="arguments.rc.contentid" default=""/>
		<cfparam name="arguments.rc.ptype" default="Page"/>
		<cfparam name="arguments.rc.type" default="Page"/>
		<cfparam name="arguments.rc.contentHistID" default="#createuuid()#"/>
		<cfparam name="arguments.rc.notify" default=""/>
		<cfparam name="arguments.rc.preview" default="0"/>
		<cfparam name="arguments.rc.size" default="20"/>
		<cfparam name="arguments.rc.action" default=""/>
		<cfparam name="arguments.rc.closeCompactDisplay" default=""/>
		<cfparam name="arguments.rc.compactDisplay" default=""/>	
		<cfparam name="arguments.rc.returnURL" default=""/>
		<cfparam name="arguments.rc.homeID" default=""/>
		<cfparam name="arguments.rc.datasource" default="#variables.configBean.getDatasource()#"/>
		<cfparam name="arguments.rc.objectid" default=""/>
		<cfparam name="arguments.rc.locking" default="false"/>
		<cfparam name="arguments.rc.moduleAssign" default=""/>
		<cfparam name="arguments.rc.orderno" default="0"/>
		<cfparam name="arguments.rc.cancelPendingApproval" default="false"/>
		<cfparam name="session.mura.viewDepth" default="#variables.settingsManager.getSite(arguments.rc.siteid).getviewdepth()#"/>
		<cfparam name="session.mura.nextN" default="#variables.settingsManager.getSite(arguments.rc.siteid).getnextN()#"/>
		<cfparam name="session.keywords" default=""/>
		<cfparam name="arguments.rc.date1" default=""/>
		<cfparam name="arguments.rc.date2" default=""/>
		<cfparam name="arguments.rc.return" default=""/>
		<cfparam name="arguments.rc.ommitPublishingTab" default="false"/>
		<cfparam name="arguments.rc.ommitRelatedContentTab" default="false"/>
		<cfparam name="arguments.rc.ommitAdvancedTab" default="false"/>
		<cfparam name="arguments.rc.murakeepediting" default="false"/>
		<cfparam name="arguments.rc.locknode" default="false"/>

		<cfif not arguments.rc.ommitPublishingTab>
			<cfparam name="arguments.rc.isNav" default="0"/>
			<cfparam name="arguments.rc.target" default="_self"/>
			<cfparam name="arguments.rc.searchExclude" default="0"/>
			<cfparam name="arguments.rc.restricted" default="0"/>
			<cfparam name="arguments.rc.mobileExclude" default="0"/>
		</cfif>

		<cfif not arguments.rc.ommitAdvancedTab>
			<cfparam name="arguments.rc.isLocked" default="0"/>
			<cfparam name="arguments.rc.forceSSL" default="0"/>
			<cfparam name="arguments.rc.doCache" default="1"/>
			<cfparam name="arguments.rc.displayTitle" default="0"/>
		</cfif>
			
		<cfif not arguments.rc.ommitRelatedContentTab>
			<cfparam name="arguments.rc.relatedContentSetData" default=""/>
		</cfif>
		
		<cfparam name="arguments.rc.responseChart" default="0"/>
		<cfparam name="arguments.rc.parentid" default=""/>
		 
		<cfif not isDefined("arguments.rc.topid")>
			<cfparam name="session.topID" default="00000000000000000000000000000000001">
			<cfset arguments.rc.topid=session.topID>
		<cfelseif (left(arguments.rc.topID,10) neq "0000000000" or arguments.rc.topID eq "00000000000000000000000000000000001")
			and not listFindNoCase("Form,Component", arguments.rc.type)>
			<cfset session.topID=arguments.rc.topid>
		</cfif>
	</cfif>
	
</cffunction>

	<cffunction name="export" output="false">
		<cfargument name="rc" />
		<cfscript>
			var local = {};

			local.currentBean = getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid);

			if ( local.currentBean.getIsNew() ) {
				rc.moduleid = '00000000000000000000000000000000000';
				variables.fw.redirect(action='cArch.list', append='siteid,moduleid', path='./');
			} else if ( !local.currentBean.getKidsIterator().getRecordCount() ) {
				variables.fw.redirect(action='cArch.exportcontent', append='contentid,siteid', path='./');
			}

			arguments.rc.crumbdata = variables.contentManager.getCrumbList(arguments.rc.contentID,arguments.rc.siteid,true);
		</cfscript>
	</cffunction>


<cffunction name="exportcontent" output="false">
	<cfargument name="rc">

	<cfset var settingsBundle = rc.$.getBean('settingsBundle') />
	<cfset var contentBean = rc.$.getBean('content').loadBy(siteid=session.siteid,contentid=arguments.rc.contentID) />
	<cfparam name="rc.doChildrenOnly" default="0" />
	
	<cfset settingsBundle.bundle(siteid=session.siteid,parentid=arguments.rc.contentID,bundlename='export_#rereplace(contentBean.getValue('filename'),"[^[:alnum:]]{1,}","_","all")#',doChildrenOnly=rc.doChildrenOnly) />
</cffunction>

<cffunction name="importcontent" output="false">
	<cfargument name="rc">

	<cfset var contentUtility = arguments.rc.$.getBean('contentUtility') />
	<cfset var hasChangesets = rc.$.getBean('settingsManager').getSite(rc.$.event('siteID')).getValue('hasChangesets') />
	<cfset var enforceChangesets = rc.$.getBean('settingsManager').getSite(rc.$.event('siteID')).getValue('enforceChangesets') />

	<cfif (arguments.rc.import_status eq "Changeset" or enforceChangesets) and (not structKeyExists(arguments.rc,"changeset_name") or not len(arguments.rc.changeset_name))>
		<cfset arguments.rc.changeset_name = "partial_import_#dateformat(now(),"dd_mm_yyyy")#_#timeformat(now(),"hh_mm_ss")#" />
		<cfset arguments.rc.import_status = "Changeset" />
	</cfif>

	<cfif structKeyExists(arguments.rc,"newfile") and len(arguments.rc.newfile)>
		<cfset contentUtility.deployPartialBundle(siteid=session.siteid,parentid=arguments.rc.contentid,bundlefile="newFile",importstatus=rc.import_status,changesetname=rc.changeset_name) />
		<cfset variables.fw.redirect(action="cArch.list",append="siteid,moduleid",path="./")>
	<cfelse>
		<cfset variables.fw.redirect(action="cArch.import",append="contentid,moduleid,siteid",path="./")>
 	</cfif>
</cffunction>


<cffunction name="list" output="false">
	<cfargument name="rc">

	<cfset arguments.rc.rsTop=variables.contentManager.getlist(arguments.rc) />
	<cfif arguments.rc.moduleid neq '00000000000000000000000000000000000'>
		<cfset arguments.rc.nextN=variables.utility.getNextN(arguments.rc.rsTop,30,arguments.rc.startrow)/>
	</cfif>
	
</cffunction>

<cffunction name="loadsitemanager" output="false">
	<cfargument name="rc">

	<cfset arguments.rc.rsTop=variables.contentManager.getlist(arguments.rc) />
	
	<cfif arguments.rc.moduleid neq '00000000000000000000000000000000000'>
		<cfset arguments.rc.nextN=variables.utility.getNextN(arguments.rc.rsTop,30,arguments.rc.startrow)/>
	</cfif>

</cffunction>

<cffunction name="loadrepomanager" output="false">
	<cfargument name="rc">

	<cfset loadsitemanager(argumentCollection=arguments)>

</cffunction>

<cffunction name="draft" output="false">
	<cfargument name="rc">
	
	<cfset arguments.rc.rsList=variables.contentManager.getDraftList(arguments.rc.siteid) />
	
</cffunction>

<cffunction name="saveQuickEdit" output="false">
	<cfargument name="rc">
	
	<cfset var local=structNew()>
	
	<cfif rc.$.validateCSRFTokens(context=rc.contentid & "quickedit")>
		<cfset local.contentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid)> 
		<cfset local.crumbdata=variables.contentManager.getCrumbList(arguments.rc.contentID,arguments.rc.siteid)/>
		<cfset local.perm=variables.permUtility.getNodePerm(local.crumbData) />  
		<cfset local.args={}>
		<cfset local.args.approved=1>
		
		<cfif arguments.rc.attribute eq "isnav">
			<cfset local.args.isnav=arguments.rc.isnav>
		<cfelseif arguments.rc.attribute eq "display">
			<cfset local.args.display=arguments.rc.display>
			
			<cfset local.args.displayStop=arguments.rc.displayStop>
			<!---
			<cfset local.args.stopHour=arguments.rc.stopHour>
			<cfset local.args.stopMinute=arguments.rc.stopMinute>
			<cfset local.args.stopDayPart=arguments.rc.stopDayPart>
			--->
			<cfset local.args.displayStart=arguments.rc.displayStart>
			<!---
			<cfset local.args.startHour=arguments.rc.startHour>
			<cfset local.args.startMinute=arguments.rc.startMinute>
			<cfset local.args.startDayPart=arguments.rc.startDayPart>
			--->
		
		<cfelseif arguments.rc.attribute eq "template">
			<cfset local.args.template=arguments.rc.template>
			<cfset local.args.childTemplate=arguments.rc.childTemplate>
		<cfelseif arguments.rc.attribute eq "inheritObjects">
			<cfset local.args.inheritObjects=arguments.rc.inheritObjects>
		<cfelse>
			<cfabort>
		</cfif>
		
		<cfif local.perm eq "Editor" and not local.contentBean.hasDrafts()>
			<cfset local.contentBean.set(local.args)>
			<cfset local.contentBean.save()>
		</cfif>
	</cfif>
	<cfabort>
	
</cffunction>

<cffunction name="edit" output="false">
	<cfargument name="rc">

	<cfset var local=structNew()>
	
	<cfset local.currentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid)> 
	
  	<cfif local.currentBean.getIsNew()>
		<cfset arguments.rc.crumbdata=variables.contentManager.getCrumbList(arguments.rc.parentid,arguments.rc.siteid,true)/>
	 <cfelse>
		<cfset arguments.rc.crumbdata=variables.contentManager.getCrumbList(arguments.rc.contentID,arguments.rc.siteid,true)/>
	</cfif>

   <cfset arguments.rc.contentBean=variables.contentManager.getcontentVersion(arguments.rc.contenthistid,arguments.rc.siteid)/>
  
   <cfif arguments.rc.contentid neq '' and arguments.rc.contenthistid neq '' and arguments.rc.contentBean.getIsNew() eq 1>
		<cfset variables.fw.redirect(action="cArch.hist",append="contentid,siteid,startrow,moduleid,parentid,type",path="./")>
   </cfif>
   
  	<cfset arguments.rc.rsCount=variables.contentManager.getItemCount(arguments.rc.contentid,arguments.rc.siteid) />
  	<cfset arguments.rc.rsPageCount=variables.contentManager.getPageCount(arguments.rc.siteid) />
  	<cfset arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid) />
  	<cfset arguments.rc.rsTemplates=variables.contentUtility.getTemplates(arguments.rc.siteid,arguments.rc.type) />
	<cfif arguments.rc.moduleID eq '00000000000000000000000000000000000'>
		  <cfset variables.contentManager.setRequestRegionObjects(arguments.rc.contenthistid,arguments.rc.siteid) />
	</cfif>
	
	<cfif arguments.rc.locknode>
		<cfset var stats=arguments.rc.contentBean.getStats()>
		<cfif not len(stats.getLockID()) or stats.getLockID() eq session.mura.userid>
			<cfset stats.setLockID(session.mura.userID).setLockType('node').save()>
		</cfif>
	</cfif>
 	
	<!--- This is here for backward plugin compatibility--->
	<cfset appendRequestScope(arguments.rc)>

</cffunction>

<cffunction name="update" ouput="false">
	<cfargument name="rc">
	<cfset var local=structNew()>
	 
	<cfset request.newImageIDList="">

	<cfif structKeyExists(arguments.rc,'orderno') and not isNumeric(arguments.rc.orderno)>
		<cfset arguments.rc.orderno=0>
	</cfif>
	
	<cfset arguments.rc.crumbData=variables.contentGateway.getCrumblist(arguments.rc.contentID, arguments.rc.siteid) /> 
	
	<cfset local.currentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid)> 
	
	 <cfif not local.currentBean.getIsNew()>
		 <cfset arguments.rc.crumbData=variables.contentGateway.getCrumblist(arguments.rc.contentID, arguments.rc.siteid) />
		 <cfset arguments.rc.perm=variables.permUtility.getNodePerm(arguments.rc.crumbData) />  
	 </cfif>
	 
	 <cfif local.currentBean.getIsNew() and len(arguments.rc.parentID)>
		<cfset arguments.rc.crumbData=variables.contentGateway.getCrumblist(arguments.rc.parentID, arguments.rc.siteid) />
		<cfset arguments.rc.perm=variables.permUtility.getNodePerm(arguments.rc.crumbData) />  
	 </cfif>
	 
	<cfset  arguments.rc.allowAction=listFindNoCase('author,editor',arguments.rc.perm) />
	 
	 <cfif arguments.rc.allowAction and arguments.rc.action eq 'deleteall'>
	 	<cfif rc.$.validateCSRFTokens(context=rc.contentid & "deleteall")>
			<cfset arguments.rc.topid=variables.contentManager.deleteAll(arguments.rc) />
		<cfelse>

		</cfif>
	 </cfif>
  
	 <cfif arguments.rc.allowAction and arguments.rc.action eq 'deletehistall'>
	 	<cfif rc.$.validateCSRFTokens(context=rc.contentid & "deletehistall")>
	 		<cfset variables.contentManager.deletehistAll(arguments.rc) />
	 	<cfelse>

	 	</cfif>
	 </cfif>
  
	 <cfif arguments.rc.allowAction and arguments.rc.action eq 'delete'>
	 	<cfif rc.$.validateCSRFTokens(context=rc.contenthistid & "delete")>
			<cfset variables.contentManager.delete(arguments.rc) />
		<cfelse>

		</cfif>
	 </cfif>
  
	 <cfif arguments.rc.allowAction and arguments.rc.action eq 'add'>
		<cfif structKeyExists(arguments.rc,"sourceid") and isValid('UUID',arguments.rc.sourceid)>
			 <cfset arguments.rc.contentBean=getBean('content').loadBy(contentHistID=arguments.rc.sourceid, siteid=arguments.rc.siteid).set(arguments.rc) />
		<cfelseif structKeyExists(arguments.rc,"contenthistid") and isValid('UUID',arguments.rc.contenthistid)>
			 <cfset arguments.rc.contentBean=getBean('content').loadBy(contentHistID=arguments.rc.contenthistid, siteid=arguments.rc.siteid).set(arguments.rc) />
		<cfelse>
			 <cfset arguments.rc.contentBean=getBean('content').loadBy(contentID=arguments.rc.contentID, siteid=arguments.rc.siteid).set(arguments.rc) />
		</cfif>

		<cfif rc.$.validateCSRFTokens(context=arguments.rc.contentBean.getContentHistID() & "add")>
			<cfset arguments.rc.contentBean=arguments.rc.contentBean.save()>
			<cfif application.configBean.getValue(property='autopreviewimages',defaultValue=true) and not arguments.rc.ajaxrequest and len(request.newImageIDList) and not arguments.rc.murakeepediting>
				<cfset arguments.rc.fileid=request.newImageIDList>
				<cfset arguments.rc.contenthistid=arguments.rc.contentBean.getContentHistID()>
				<cfset variables.fw.redirect(action="cArch.imagedetails",append="contenthistid,siteid,fileid,compactDisplay",path="./")>
			</cfif>
		<cfelse>
			<cfset arguments.rc.contentBean.validate().getErrors().csrf='Your request contained invalid tokens'>
		</cfif>
	 </cfif>
	 
	 <cfif not arguments.rc.ajaxrequest>
		 		
		 <cfif arguments.rc.allowAction and arguments.rc.action eq 'multifileupload'>
		 		<cfparam name="session.mura.multifileupload" default="false">

		 		<cflock name="multifileupload#application.instanceid#" timeout="5">
		 			<cfset session.mura.multifileupload=rc.$.validateCSRFTokens(context=arguments.rc.parentid & "multifileupload") or session.mura.multifileupload>
		 		</cflock>

		 		<cfif session.mura.multifileupload>
			  		<cfset variables.contentManager.multiFileUpload(arguments.rc) />
			  	<cfelse>

			  	</cfif>

		 </cfif>
		 
		  <cfif arguments.rc.allowAction and arguments.rc.action eq 'add' and arguments.rc.contentID neq '00000000000000000000000000000000001'>
		      <cfif not (
			  		listFindNoCase(session.openSectionList,rc.contentBean.getParentID())
			  		and listFindNoCase(rc.contentBean.getPath(),session.topID)
			  )>
		     	 <cfset arguments.rc.topid=rc.contentBean.getParentID() />	
			  </cfif>
		  </cfif>
		 
		<cfif (arguments.rc.closeCompactDisplay neq 'true'  or arguments.rc.murakeepediting) and arguments.rc.action neq 'multiFileUpload'>
			
				<cfif len(arguments.rc.returnURL) and (arguments.rc.action eq 'delete' or arguments.rc.action eq 'deletehistall' or (arguments.rc.preview eq 0 and not arguments.rc.murakeepediting))>
					<cflocation url="#rc.returnURL#" addtoken="false"/>
				</cfif>
				
				<cfif arguments.rc.action eq 'delete' or arguments.rc.action eq 'deletehistall' or (arguments.rc.return eq 'hist' and arguments.rc.preview eq 0 and not arguments.rc.murakeepediting)>
					<cfset variables.fw.redirect(action="cArch.hist",append="contentid,siteid,startrow,moduleid,parentid,type,compactDisplay")>
				</cfif>
				
				<cfif arguments.rc.return eq 'changesets' and len(rc.contentBean.getChangesetID()) and not arguments.rc.murakeepediting>
					<cfset variables.fw.redirect(action="cChangesets.assignments",append="changesetID,siteid",path="./")>
				</cfif>
				
				<cfif structIsEmpty(rc.contentBean.getErrors())>
					<cfset structDelete(session.mura,"editBean")>
					<cfif arguments.rc.preview eq 0 and not arguments.rc.murakeepediting>
						<cfset variables.fw.redirect(action="cArch.list",append="topid,siteid,startrow,moduleid",path="./")>
					<cfelse>
						<cfset arguments.rc.parentid=rc.contentBean.getParentID()>
						<cfset arguments.rc.type=rc.contentBean.getType()>
						<cfset arguments.rc.contentid=rc.contentBean.getContentID()>
						<cfset arguments.rc.contenthistid=rc.contentBean.getContentHistID()>
						<cfset arguments.rc.preview=arguments.rc.preview>
						<cfset variables.fw.redirect(action="cArch.edit",append="contenthistid,contentid,type,parentid,topid,siteid,moduleid,preview,startrow,return,compactDisplay",path="./")>
					</cfif>
				</cfif>

		</cfif>

	 </cfif>

</cffunction>

<cffunction name="hist" ouput="false">
	<cfargument name="rc">
	<cfset arguments.rc.contentBean=variables.contentManager.getActiveContent(arguments.rc.contentid,arguments.rc.siteid) />
	<cfset arguments.rc.rsCount=variables.contentManager.getItemCount(arguments.rc.contentid,arguments.rc.siteid) />
</cffunction>

<cffunction name="audit" ouput="false">
	<cfargument name="rc">
	<cfset arguments.rc.contentBean=variables.contentManager.getActiveContent(arguments.rc.contentid,arguments.rc.siteid) />
	<cfset arguments.rc.rsCount=variables.contentManager.getItemCount(arguments.rc.contentid,arguments.rc.siteid) />
</cffunction>

<cffunction name="datamanager" ouput="false">
	<cfargument name="rc">
	<cfset arguments.rc.crumbData=variables.contentManager.getCrumbList(arguments.rc.contentid,arguments.rc.siteid) />
	<cfset arguments.rc.contentBean=variables.contentManager.getActiveContent(arguments.rc.contentid,arguments.rc.siteid) />
</cffunction>

<cffunction name="downloaddata" ouput="false">
	<cfargument name="rc">
	<cfset arguments.rc.contentBean=variables.contentManager.getActiveContent(arguments.rc.contentid,arguments.rc.siteid) />
	<cfset arguments.rc.datainfo=variables.contentManager.getDownloadselect(arguments.rc.contentid,arguments.rc.siteid) />
</cffunction>

<cffunction name="search" ouput="false">
	<cfargument name="rc">
	<cfset arguments.rc.rslist=variables.contentManager.getPrivateSearch(arguments.rc.siteid,arguments.rc.keywords) />
	<cfset session.keywords=rc.keywords/>
	<cfset arguments.rc.nextn=variables.utility.getNextN(arguments.rc.rsList,30,arguments.rc.startrow) />
</cffunction>

<cffunction name="loadNotify" ouput="false">
	<cfargument name="rc">
	<cfif arguments.rc.contentid eq ''>
		<cfset arguments.rc.crumbData=variables.contentManager.getCrumbList(arguments.rc.parentid,arguments.rc.siteid) />
	<cfelse>
		<cfset arguments.rc.crumbData=variables.contentManager.getCrumbList(arguments.rc.contentid,arguments.rc.siteid) />
	</cfif>
</cffunction>

<cffunction name="copy" ouput="false">
	<cfargument name="rc">
	<cfset variables.contentManager.copy(arguments.rc.siteid,arguments.rc.contentID,arguments.rc.parentID,arguments.rc.copyAll, true, true)  />
	<cfabort>
</cffunction>

<cffunction name="siteManagerTab" ouput="false">
	<cfargument name="rc">
	<cfparam name="session.flatViewArgs" default="#structNew()#">
	<cfif not structKeyExists(session.flatViewArgs,'#session.siteID#')>
	 	<cfset session.flatViewArgs['#session.siteID#']=structNew()>
	</cfif>
	<cfset session.flatViewArgs['#session.siteID#'].tab=arguments.rc.tab  />
	<cfabort>
</cffunction>

<cffunction name="saveCopyInfo" ouput="false">
	<cfargument name="rc">
	<cfset variables.contentManager.saveCopyInfo(arguments.rc.siteid,arguments.rc.contentID,arguments.rc.copyAll)  />
	<cfabort>
</cffunction>

<cffunction name="multiFileUpload" ouput="false">
	<cfargument name="rc">

	<cfset arguments.rc.crumbdata=variables.contentManager.getCrumbList(arguments.rc.parentid,arguments.rc.siteid)>
  	<cfset arguments.rc.rsCount=variables.contentManager.getItemCount(arguments.rc.contentid,arguments.rc.siteid)>
  	<cfset arguments.rc.rsPageCount=variables.contentManager.getPageCount(arguments.rc.siteid)>
  	<cfset arguments.rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(arguments.rc.siteid)>
	
	
</cffunction>

<cffunction name="updateObjectParams" ouput="true">
	<cfargument name="rc">
	<cfset var local=structNew()>
	
	<cfset local.versionBean=getBean("content").loadBy(contentHistID=arguments.rc.contentHistID, siteID= arguments.rc.siteid)> 
	
	<cfif not local.versionBean.getIsNew()>
		<cfset arguments.rc.crumbData=variables.contentGateway.getCrumblist(local.versionBean.getContentID(), arguments.rc.siteid) />
		<cfset arguments.rc.perm=variables.permUtility.getNodePerm(arguments.rc.crumbData) />  
	<cfelse>
		<cfabort>
	</cfif>
	
	<cfif structKeyExists(arguments.rc,"changesetid")>
		<cfset local.versionBean.setChangesetID(arguments.rc.changesetID)>
	</cfif>
	
	<cfif structKeyExists(arguments.rc,"removePreviousChangeset")>
		<cfset local.versionBean.setRemovePreviousChangeset(arguments.rc.removePreviousChangeset)>
	</cfif>

	<cfif arguments.rc.perm eq "author">
		<cfset local.versionBean.setApproved(0)>
	<cfelseif arguments.rc.perm eq "editor" >
		<cfset local.versionBean.setApproved(arguments.rc.approved)>
	<cfelse>
		<cfabort>
	</cfif>

	<cfif isJSON(arguments.rc.params)>
		<cfset local.versionBean.addDisplayObject(argumentCollection=arguments.rc)>
		<cfset versionBean.save()>
	</cfif>
	
	<cfset arguments.rc.versionBean=local.versionBean>
	
</cffunction>

<cffunction name="lockFile" ouput="false">
	<cfargument name="rc">
	
	<cfif rc.$.validateCSRFTokens(context=rc.contentid & "lockfile")>
		<cfset local.contentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid)> 
		<cfset local.crumbdata=variables.contentManager.getCrumbList(arguments.rc.contentID,arguments.rc.siteid)/>
		<cfset local.perm=variables.permUtility.getNodePerm(local.crumbData) />
		
		<cfif listFindNoCase("author,editor",local.perm)
			or listFindNoCase(session.mura.memberships,"s2")>
				<cfset local.contentBean.getStats().setLockID(session.mura.userID).setLockType('file').save()>
				<cflocation url="#variables.configBean.getContext()#/index.cfm/_api/render/file/?fileid=#local.contentBean.getFileID()#&method=attachment">
		</cfif>
	</cfif>
	<cfabort>
</cffunction>

<cffunction name="unlockFile" ouput="false">
	<cfargument name="rc">
	
	<cfif rc.$.validateCSRFTokens(context=rc.contentid & "unlockfile")>
		<cfset local.contentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid)>
		<cfset local.stats=local.contentBean.getStats()> 

		<cfif len(local.stats.getLockID())
			and (
				local.stats.getLockID() eq session.mura.userID
				or
				listFindNoCase(session.mura.memberships,"s2")
				)>
			<cfset local.stats.setLockID("").setLockType("").save()>
		
		</cfif>
	</cfif>
	<cfabort>
</cffunction>

<cffunction name="unlockNode" ouput="false">
	<cfargument name="rc">
	
	<cfif rc.$.validateCSRFTokens(context=rc.contentid & "unlocknode")>
		<cfset local.contentBean=getBean("content").loadBy(contentID=arguments.rc.contentID, siteID= arguments.rc.siteid)>
		<cfset local.stats=local.contentBean.getStats()> 

		<cfif len(local.stats.getLockID())
			and (
				local.stats.getLockID() eq session.mura.userID
				or
				listFindNoCase(session.mura.memberships,"s2")
				)>
			<cfset local.stats.setLockID("").setLockType("").save()>
		
		</cfif>
	</cfif>
	<cfabort>
</cffunction>

<cffunction name="getAuditTrail" output="true">
	<cfargument name="rc">
	<cfset var trail=[]>

	<cfset arguments.rc.item=rc.$.getBean('content').loadBy(contenthistid=arguments.rc.contenthistid,siteid=arguments.rc.siteid)>
	
	<cfloop condition="not arguments.rc.item.getIsNew()">
		<cfset arrayAppend(trail, arguments.rc.item.getContentHistID())>
		<cfset arguments.rc.item=arguments.rc.item.getSource()>
	</cfloop>
	<cfcontent type="application/json">
	<cfoutput>#createObject("component","mura.json").encode(trail)#</cfoutput>
	<cfabort>
		
</cffunction>

<cffunction name="getImageSizeURL" output="true">
	<cfargument name="rc">

	<cfcontent type="application/json">
	<cfoutput>#createObject("component","mura.json").encode(rc.$.getURLForImage(fileID=rc.fileid,size=rc.size))#</cfoutput>
	<cfabort>
		
</cffunction>


</cfcomponent>