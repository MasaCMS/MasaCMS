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
	
	<cfif not variables.permUtility.getModulePerm('00000000000000000000000000000000000',rc.siteid)>
		<cfset secure(rc)>
	</cfif>

	<cfparam name="rc.return" default=""/>
	<cfparam name="rc.startrow" default="1"/>
	<cfparam name="rc.contentHistID" default="#createuuid()#"/>
	<cfparam name="rc.notify" default=""/>
	<cfparam name="rc.preview" default="0"/>
	<cfparam name="rc.size" default="20"/>
	<cfparam name="rc.isNav" default="0"/>
	<cfparam name="rc.isLocked" default="0"/>
	<cfparam name="rc.forceSSL" default="0"/>
	<cfparam name="rc.target" default="_self"/>
	<cfparam name="rc.searchExclude" default="0"/>
	<cfparam name="rc.restricted" default="0"/>
	<cfparam name="rc.relatedcontentid" default=""/>
	<cfparam name="rc.responseChart" default="0"/>
	<cfparam name="rc.displayTitle" default="0"/>
	<cfparam name="rc.closeCompactDisplay" default=""/>
	<cfparam name="rc.compactDisplay" default=""/>
	<cfparam name="rc.doCache" default="1"/>
	<cfparam name="rc.returnURL" default=""/>
	<cfparam name="rc.homeID" default=""/>
	<cfparam name="rc.datasource" default="#variables.configBean.getDatasource()#"/>
	<cfparam name="rc.parentid" default=""/>
	<cfparam name="rc.menuTitle" default=""/>
	<cfparam name="rc.title" default=""/>
	<cfparam name="rc.action" default=""/>
	<cfparam name="rc.ptype" default="Page"/>
	<cfparam name="rc.contentid" default=""/>
	<cfparam name="rc.contenthistid" default=""/>
	<cfparam name="rc.type" default="Page"/>
	<cfparam name="rc.body" default=""/>
	<cfparam name="rc.oldbody" default=""/>
	<cfparam name="rc.oldfilename" default=""/>
	<cfparam name="rc.url" default=""/>
	<cfparam name="rc.filename" default=""/>
	<cfparam name="rc.metadesc" default=""/>
	<cfparam name="rc.metakeywords" default=""/>
	<cfparam name="rc.orderno" default="0"/>
	<cfparam name="rc.display" default="0"/>
	<cfparam name="rc.displaystart" default=""/>
	<cfparam name="rc.displaystop" default=""/>
	<cfparam name="rc.abstract" default=""/>
	<cfparam name="rc.frameid" default="0"/>
	<cfparam name="rc.abstract" default=""/>
	<cfparam name="rc.editor" default="0"/>
	<cfparam name="rc.author" default="0"/>
	<cfparam name="rc.moduleid" default="00000000000000000000000000000000000"/>
	<cfparam name="rc.objectid" default=""/>
	<cfparam name="rc.lastupdate" default=""/>
	<cfparam name="rc.siteid" default=""/>
	<cfparam name="rc.title" default=""/>
	<cfparam name="rc.topid" default="00000000000000000000000000000000001"/>
	<cfparam name="rc.startrow" default="1"/>
	<cfparam name="rc.lastupdate" default="#now()#"/>
	<cfparam name="session.viewDepth" default="#variables.settingsManager.getSite(rc.siteid).getviewdepth()#"/>
	<cfparam name="session.nextN" default="#variables.settingsManager.getSite(rc.siteid).getnextN()#"/>
	<cfparam name="session.keywords" default=""/>
	<cfparam name="rc.startrow" default="1"/>
	<cfparam name="rc.date1" default=""/>
	<cfparam name="rc.date2" default=""/>
	<cfparam name="rc.return" default=""/>
	<cfparam name="rc.forceSSL" default="0"/>
	<cfparam name="rc.closeCompactDisplay" default=""/>
	<cfparam name="rc.returnURL" default=""/>
	<cfparam name="rc.locking" default="false"/>
	

	
</cffunction>

<cffunction name="list" output="false">
	<cfargument name="rc">

	<cfset rc.rsTop=variables.contentManager.getlist(rc) />
	
	<cfif rc.moduleid neq '00000000000000000000000000000000000'>
		<cfset rc.nextN=variables.utility.getNextN(rc.rsTop,30,rc.startrow)/>
	</cfif>

</cffunction>

<cffunction name="draft" output="false">
	<cfargument name="rc">
	
	<cfset rc.rsList=variables.contentManager.getDraftList(rc.siteid) />
	
</cffunction>

<cffunction name="edit" output="false">
	<cfargument name="rc">

  	<cfif not len(rc.contentID)>
		<cfset rc.crumbdata=variables.contentManager.getCrumbList(rc.parentid,rc.siteid)/>
	 <cfelse>
		<cfset rc.crumbdata=variables.contentManager.getCrumbList(rc.contentID,rc.siteid)/>
	</cfif>

  <cfset rc.contentBean=variables.contentManager.getcontentVersion(rc.contenthistid,rc.siteid)/>
  
   <cfif rc.contentid neq '' and rc.contenthistid neq '' and rc.contentBean.getIsNew() eq 1>
		<cfset variables.fw.redirect(action="cArch.hist",append="contentid,siteid,startrow,moduleid,parentid,type",path="")>
   </cfif>
   
  	<cfset rc.rsCount=variables.contentManager.getItemCount(rc.contentid,rc.siteid) />
  	<cfset rc.rsPageCount=variables.contentManager.getPageCount(rc.siteid) />
  	<cfset rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(rc.siteid) />
  	<cfset rc.rsTemplates=variables.contentUtility.getTemplates(rc.siteid,rc.type) />
  	<cfset rc.rsCategoryAssign=variables.contentManager.getCategoriesByHistID(rc.contenthistID) />
	<cfif rc.moduleID eq '00000000000000000000000000000000000'>
		  <cfset variables.contentManager.setRequestRegionObjects(rc.contenthistid,rc.siteid) />
	</cfif>
	<cfset rc.rsRelatedContent=variables.contentManager.getRelatedContent(rc.siteid, rc.contenthistID) />
	
</cffunction>

<cffunction name="update" ouput="false">
	<cfargument name="rc">
	
	<cfif not isNumeric(rc.orderno)>
		<cfset rc.orderno=0>
	</cfif>
	
	<cfset rc.crumbData=variables.contentGateway.getCrumblist(rc.contentID, rc.siteid) />  
	
	 <cfif len(rc.contentID)>
		 <cfset rc.crumbData=variables.contentGateway.getCrumblist(rc.contentID, rc.siteid) />
		 <cfset rc.perm=variables.permUtility.getNodePerm(rc.crumbData) />  
	 </cfif>
	 
	 <cfif not len(rc.contentID) and len(rc.parentID)>
		<cfset rc.crumbData=variables.contentGateway.getCrumblist(rc.parentID, rc.siteid) />
		<cfset rc.perm=variables.permUtility.getNodePerm(rc.crumbData) />  
	 </cfif>
	 
	<cfset  rc.allowAction=listFindNoCase('author,editor',rc.perm) />
	 
	 <cfif rc.allowAction and rc.action eq 'deleteall'>
		<cfset rc.topid=variables.contentManager.deleteAll(rc) />  
	 </cfif>
  
	 <cfif rc.allowAction and rc.action eq 'deletehistall'>
	 	<cfset variables.contentManager.deletehistAll(rc) />
	 </cfif>
  
	 <cfif rc.allowAction and rc.action eq 'delete'>
		<cfset variables.contentManager.delete(rc) />
	 </cfif>
  
	 <cfif rc.allowAction and rc.action eq 'add'>
		<cfif structKeyExists(rc,"preserveID") and isValid('UUID',rc.preserveID)>
			 <cfset rc.contentBean=getBean('content').loadBy(contentHistID=rc.preserveID, siteid=rc.siteid).set(rc).save() />
		<cfelse>
			 <cfset rc.contentBean=getBean('content').loadBy(contentID=rc.contentID, siteid=rc.siteid).set(rc).save() />
		</cfif>
	 </cfif>
	 
	 <cfif rc.allowAction and rc.action eq 'multiFileUpload'>
		  <cfset variables.contentManager.multiFileUpload(rc) />
	 </cfif>
	 
	  <cfif rc.allowAction and rc.action eq 'add' and rc.contentID neq '00000000000000000000000000000000001'>
	      <cfset rc.topid=rc.contentBean.getParentID() />	
	  </cfif>
	 
	<cfif rc.closeCompactDisplay neq 'true'>
		
			<cfif len(rc.returnURL) and (rc.action eq 'delete' or rc.action eq 'deletehistall' or rc.preview eq 0)>
					<cflocation url="#rc.returnURL#" addtoken="false"/>
			</cfif>
			
			<cfif rc.action eq 'delete' or rc.action eq 'deletehistall' or (rc.return eq 'hist' and rc.preview eq 0)>
				<cfset variables.fw.redirect(action="cArch.hist",append="contentid,siteid,startrow,moduleid,parentid,type,compactDisplay",path="")>
			</cfif>
			
			<cfif rc.preview eq 0>
				<cfset variables.fw.redirect(action="cArch.list",append="topid,siteid,startrow,moduleid",path="")>
			<cfelse>
				<cfset rc.parentid=rc.contentBean.getParentID()>
				<cfset rc.type=rc.contentBean.getType()>
				<cfset rc.contentid=rc.contentBean.getContentID()>
				<cfset rc.contenthistid=rc.contentBean.getContentHistID()>
				<cfset rc.preview=1>
				<cfset variables.fw.redirect(action="cArch.edit",append="contenthistid,contentid,type,parentid,topid,siteid,moduleid,preview,startrow,return",path="")>
			</cfif>
	</cfif>

</cffunction>

<cffunction name="hist" ouput="false">
	<cfargument name="rc">
	<cfset rc.rshist=variables.contentManager.getHist(rc.contentid,rc.siteid) />
	<cfset rc.contentBean=variables.contentManager.getActiveContent(rc.contentid,rc.siteid) />
	<cfset rc.rsCount=variables.contentManager.getItemCount(rc.contentid,rc.siteid) />
</cffunction>

<cffunction name="datamanager" ouput="false">
	<cfargument name="rc">
	<cfset rc.crumbData=variables.contentManager.getCrumbList(rc.contentid,rc.siteid) />
	<cfset rc.contentBean=variables.contentManager.getActiveContent(rc.contentid,rc.siteid) />
</cffunction>

<cffunction name="downloaddata" ouput="false">
	<cfargument name="rc">
	<cfset rc.contentBean=variables.contentManager.getActiveContent(rc.contentid,rc.siteid) />
	<cfset rc.datainfo=variables.contentManager.getDownloadselect(rc.contentid,rc.siteid) />
</cffunction>

<cffunction name="search" ouput="false">
	<cfargument name="rc">
	<cfset rc.rslist=variables.contentManager.getPrivateSearch(rc.siteid,rc.keywords) />
	<cfset session.keywords=rc.keywords/>
	<cfset rc.nextn=variables.utility.getNextN(rc.rsList,30,rc.startrow) />
</cffunction>

<cffunction name="loadNotify" ouput="false">
	<cfargument name="rc">
	<cfif rc.contentid eq ''>
		<cfset rc.crumbData=variables.contentManager.getCrumbList(rc.parentid,rc.siteid) />
	<cfelse>
		<cfset rc.crumbData=variables.contentManager.getCrumbList(rc.contentid,rc.siteid) />
	</cfif>
</cffunction>

<cffunction name="copy" ouput="false">
	<cfargument name="rc">
	<cfset variables.contentManager.copy(rc.siteid,rc.contentID,rc.parentID,rc.copyAll)  />
</cffunction>

<cffunction name="saveCopyInfo" ouput="false">
	<cfargument name="rc">
	<cfset variables.contentManager.saveCopyInfo(rc.siteid,rc.contentID,rc.copyAll)  />
</cffunction>

<cffunction name="multiFileUpload" ouput="false">
	<cfargument name="rc">

	<cfset rc.crumbdata=variables.contentManager.getCrumbList(rc.parentid,rc.siteid)>
  	<cfset rc.rsCount=variables.contentManager.getItemCount(rc.contentid,rc.siteid)>
  	<cfset rc.rsPageCount=variables.contentManager.getPageCount(rc.siteid)>
  	<cfset rc.rsRestrictGroups=variables.contentUtility.getRestrictGroups(rc.siteid)>
	
	
</cffunction>

</cfcomponent>