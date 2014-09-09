<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.configBean="">
<cfset variables.trashManager="">

<cffunction name="getBean" output="false">
	<cfargument name="beanName" default="changeset">
	<cfreturn super.getBean(arguments.beanName)>
</cffunction>

<cffunction name="init" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="setConfigBean" output="false">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
</cffunction>

<cffunction name="setTrashManager" output="false">
	<cfargument name="trashManager">
	<cfset variables.trashManager=arguments.trashManager>
	<cfreturn this>
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="changesetID" type="string" default=""/>
	<cfargument name="name" type="string" default=""/>
	<cfargument name="siteID" type="string" default=""/>
	<cfargument name="remoteID" type="string" default=""/>
	<cfargument name="changesetBean"  default=""/>
	<cfset var rs="">
	<cfset var rscategories="">
	<cfset var rstags="">
	<cfset var bean=arguments.changesetBean>
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("changeset")>
	</cfif>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select changesetID, siteID, name, description, created, publishDate, published, lastupdate, lastUpdateBy, lastUpdateByID, remoteID, remotePubDate, remoteSourceURL, closeDate
	from tchangesets where
	<cfif len(arguments.siteID)>
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
		<cfif len(arguments.name)>
		and	name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
		<cfelseif len(arguments.remoteID)>
		and	remoteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remoteID#">
		<cfelse>
		and changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
		</cfif>
	<cfelse>
		changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
	</cfif>
	</cfquery>

	<cfif rs.recordcount>
		<cfset bean.set(rs)>
		<cfset bean.setIsNew(0)>
	<cfelseif len(arguments.siteID)>
		<cfset bean.setSiteID(arguments.siteID)>
	</cfif>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rscategories')#">
		select categoryid from tchangesetcategoryassign 
		where changesetid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#bean.getChangesetID()#">
	</cfquery>

	<cfset bean.setCategoryID(valueList(rscategories.categoryid))>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rstags')#">
		select tag from tchangesettagassign 
		where changesetid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#bean.getChangesetID()#">
	</cfquery>

	<cfset bean.setTags(valueList(rstags.tag))>

	<cfreturn bean>

</cffunction>

<cffunction name="save" access="public" returntype="any" output="false">
	<cfargument name="bean"/>
	
	<cfset arguments.bean.validate()>

	<cfif not arguments.bean.hasErrors()>
		
	<cfset var rs="">
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
		select changesetID from tchangesets
		where changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getChangesetID()#"> 
	</cfquery>
	
	<cfif rs.recordcount>
	<cfquery>
		update tchangesets set
		siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getSiteID()#">,
		name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#">,
		description=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getDescription()#">,
		publishDate=<cfif isdate(arguments.bean.getpublishDate())> 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.bean.getpublishDate()),
												month(arguments.bean.getpublishDate()),
												day(arguments.bean.getpublishDate()),
												hour(arguments.bean.getpublishDate()),
												minute(arguments.bean.getpublishDate()),0)#">
					<cfelse>
						null
					</cfif>,
		published=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.bean.getpublished()#">,
		lastupdate=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		lastUpdateBy=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLastUpdateBy()#">,
		lastUpdateByID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLastUpdateByID()#">,
		remoteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getRemoteID()#">,
		remotePubDate=<cfif isdate(arguments.bean.getRemotePubDate())> 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.bean.getRemotePubDate()),
												month(arguments.bean.getRemotePubDate()),
												day(arguments.bean.getRemotePubDate()),
												hour(arguments.bean.getRemotePubDate()),
												minute(arguments.bean.getRemotePubDate()),0)#">
					<cfelse>
						null
					</cfif>,
		remoteSourceURL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getRemoteSourceURL()#">,
		closeDate=<cfif isdate(arguments.bean.getCloseDate())> 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.bean.getCloseDate()),
												month(arguments.bean.getCloseDate()),
												day(arguments.bean.getCloseDate()),
												hour(arguments.bean.getCloseDate()),
												minute(arguments.bean.getCloseDate()),0)#">
					<cfelse>
						null
					</cfif>
		where changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getChangesetID()#">
	</cfquery>

	<cfquery>
		delete from tchangesetcategoryassign
		where changesetid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getChangesetID()#">
	</cfquery>

	<cfquery>
		delete from tchangesettagassign
		where changesetid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getChangesetID()#">
	</cfquery>

	<cfelse>
		<cfquery>
		insert into tchangesets (changesetID, siteID, name, description, created, publishDate, 
		published, lastupdate, lastUpdateBy, lastUpdateByID,
		remoteID, remotePubDate, remoteSourceURL,closeDate)
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getChangesetID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getDescription()#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfif isdate(arguments.bean.getpublishDate())> 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.bean.getpublishDate()),
												month(arguments.bean.getpublishDate()),
												day(arguments.bean.getpublishDate()),
												hour(arguments.bean.getpublishDate()),
												minute(arguments.bean.getpublishDate()),0)#">
					<cfelse>
						null
					</cfif>,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.bean.getpublished()#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLastUpdateBy()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLastUpdateByID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getRemoteID()#">,
		<cfif isdate(arguments.bean.getRemotePubDate())> 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.bean.getRemotePubDate()),
												month(arguments.bean.getRemotePubDate()),
												day(arguments.bean.getRemotePubDate()),
												hour(arguments.bean.getRemotePubDate()),
												minute(arguments.bean.getRemotePubDate()),0)#">
					<cfelse>
						null
					</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getRemoteSourceURL()#">,
		<cfif isdate(arguments.bean.getCloseDate())> 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createDateTime(year(arguments.bean.getCloseDate()),
												month(arguments.bean.getCloseDate()),
												day(arguments.bean.getCloseDate()),
												hour(arguments.bean.getCloseDate()),
												minute(arguments.bean.getCloseDate()),0)#">
					<cfelse>
						null
					</cfif>
		)
	</cfquery>
	
	<cfset variables.trashManager.takeOut(bean)>
	
	</cfif>

	<cfif len(arguments.bean.getCategoryID())>
		<cfloop list="#arguments.bean.getCategoryID()#" index="local.i">
			<cfset getBean('changesetCategoryAssignment').loadBy(
				changesetid=arguments.bean.getChangesetID(),
				siteid=arguments.bean.getSiteid(),
				categoryid=local.i).save()>
		</cfloop>
	</cfif>

	<cfif len(arguments.bean.getTags())>
		<cfloop list="#arguments.bean.getTags()#" index="local.i">
			<cfset getBean('changesetTagAssignment').loadBy(
				changesetid=arguments.bean.getChangesetID(),
				siteid=arguments.bean.getSiteid(),
				tag=local.i).save()>
		</cfloop>
	</cfif>

	</cfif>

	<cfreturn bean>

</cffunction>

<cffunction name="delete" access="public" returntype="any" output="false">
<cfargument name="changesetID">
    <cfset var bean=read(arguments.changesetID) />
	
	<cfset variables.trashManager.throwIn(bean)>
	
	<cfquery>
	delete from tchangesets 
	where changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
	</cfquery>
	
	<cfquery>
		delete from tchangesetcategoryassign
		where changesetid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
	</cfquery>

	<cfquery>
		delete from tchangesettagassign
		where changesetid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
	</cfquery>

</cffunction>

<cffunction name="getQuery" access="public" returntype="any" output="false">
<cfargument name="siteID">
<cfargument name="published">
<cfargument name="publishDate">
<cfargument name="publishDateOnly" default="true">
<cfargument name="keywords">
<cfargument name="sortBy">
<cfargument name="openOnly">
<cfargument name="tag">

	<cfset var rsChangeSets="">
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsChangeSets')#">
	select changesetID, siteID, name, description, created, publishDate, published, lastupdate, lastUpdateBy, remoteID, remotePubDate, remoteSourceURL
	from tchangesets
	where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	<cfif structKeyExists(arguments,"published") and isNumeric(arguments.published)>
	and published =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.published#">
	</cfif>
	<cfif structKeyExists(arguments,"publishDate") and isDate(arguments.publishDate)>
		and 
		(publishDate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.publishDate#">
		<cfif structKeyExists(arguments,"publishDateOnly") and isBoolean(arguments.publishDateOnly) and not arguments.publishDateOnly>
		or publishDate is null
		</cfif>
		)
	</cfif>

	<cfif structKeyExists(arguments,"openOnly") and isBoolean(arguments.openOnly) and arguments.openOnly>
		and 
		(closeDate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		
		or closeDate is null
		)
	</cfif>
	<cfif structKeyExists(arguments,"keywords") and len(arguments.keywords)>
	and (
		name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
	
		or
		
		description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
		
		)
	</cfif>

	<cfif isdefined('arguments.tag') and len(arguments.tag)>
		and changesetid in (select changesetid fromt tchangesettagassign 
							where tag=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#">
							and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)

	</cfif>
	order by 
	<cfif structKeyExists(arguments,"sortBy") and arguments.sortBy eq "PublishDate">
	publishDate desc, name
	<cfelse>
	published, name
	</cfif>
	</cfquery>
	<cfreturn rsChangeSets>
</cffunction>

<cffunction name="getPendingByContentID" access="public" returntype="any" output="false">
<cfargument name="contentID">
<cfargument name="siteID">
	<cfset var rsPendingChangeSets="">
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPendingChangeSets')#">
	select tchangesets.changesetID, tcontent.contentID, tcontent.contenthistid, 
	tcontent.siteID, tcontent.menutitle, tchangesets.name changesetName, tapprovalrequests.status approvalStatus,tapprovalrequests.requestID,
	tcontent.lastupdate, tcontent.lastupdateby, tapprovalrequests.groupid approvalGroupID, tchangesets.publishDate, tchangesets.closeDate
	from tcontent
	inner join tchangesets on tcontent.changesetID=tchangesets.changesetID
	left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	and tcontent.contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
	and tchangesets.published=0
	</cfquery>
	<cfreturn rsPendingChangeSets>
</cffunction>

<cffunction name="publishBySchedule" access="public" returntype="any" output="false">
	<cfset var rsPendingChangeSets="">
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsPendingChangeSets',cachedwithin=CreateTimeSpan(0, 0, 5, 0))#">
	select changesetID
	from tchangesets
	where tchangesets.published=0
	and tchangesets.publishDate is not null
	and tchangesets.publishDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	order by tchangesets.publishDate asc
	</cfquery>

	<cfloop query="rsPendingChangeSets">
		<cfset publish(rsPendingChangeSets.changesetID,true)>
	</cfloop>	

</cffunction>

<cffunction name="setSessionPreviewData" access="public" returntype="any" output="false">
<cfargument name="changesetID">
<cfargument name="append" default="false">
<cfargument name="showToolbar" default="true">
<cfset local.changeset=read(arguments.changesetID)>

<cfif not local.changeset.getIsNew() and not local.changeset.getPublished()>

	<cfset local.currentUser=getCurrentUser()>

	<cfif arguments.append and isStruct(local.currentUser.getValue("ChangesetPreviewData"))>
		<cfset local.data=local.currentUser.getValue("ChangesetPreviewData")>

		<cfparam name="local.data.changesetIDList" default="">

		<cfif listFindNoCase(local.data.changesetIDList,local.changeset.getChangesetID())>
			<cfreturn false>
		</cfif>
		
		<cfset local.data.changesetIDList=listAppend(local.data.changesetIDList,local.changeset.getChangesetID())>
	<cfelse>
		<cfset local.data=structNew()>
		<cfset local.data.previewMap=structNew()>
		<cfset local.data.contentIDList="">
		<cfset local.data.contentHistIDList="">
		<cfset local.data.dependentList="">
		<cfset local.data.changesetIDList=local.changeset.getChangesetID()>
	</cfif>

	<cfparam name="local.data.showToolbar" default="false">

	<cfif arguments.showToolbar>
		<cfset local.data.showToolbar=arguments.showToolbar>
	</cfif>

	<cfif isDate(local.changeset.getPublishDate())>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='local.prereqs')#">
		select changesetID,name,publishDate
		from tchangesets
		where tchangesets.published=0
		and tchangesets.publishDate is not null
		and tchangesets.changesetID <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.changeset.getChangesetID()#">
		and (tchangesets.publishDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.changeset.getPublishDate()#">	
			<cfif arguments.append and len(local.data.prereqList)>
			or  tchangesets.changesetID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#local.data.prereqList#">)
			</cfif>
			)
		and tchangesets.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.changeset.getSiteID()#">

		order by tchangesets.publishDate asc
		</cfquery>

		<cfloop query="local.prereqs">
			<cfif not listFind(local.data.dependentList,local.prereqs.changesetid)>
				<cfset local.data.dependentList=listAppend(local.data.dependentList,local.prereqs.changesetid)>
			</cfif>

			<cfif not listFind(local.data.changesetIDList,local.prereqs.changesetid)>
				<cfset local.data.changesetIDList=listAppend(local.data.changesetIDList,local.prereqs.changesetid)>
			</cfif>

			<cfset local.assignments=getAssignmentsQuery(changesetID=local.prereqs.changesetID)>
			<cfif local.assignments.recordcount>
				<cfloop query="local.assignments">
					<cfif not structKeyExists(local.data.previewMap,local.assignments.contentID)>
						<cfset local.data.previewMap[local.assignments.contentID]=structNew()>
					</cfif>
					<cfset local.data.previewMap[local.assignments.contentID].contentID=local.assignments.contentID>
					<cfset local.data.previewMap[local.assignments.contentID].contentHistID=local.assignments.contentHistID>
					<cfset local.data.previewMap[local.assignments.contentID].changesetID=local.prereqs.changesetID>
					<cfset local.data.previewMap[local.assignments.contentID].changesetName=local.prereqs.name>
					<cfset local.data.previewMap[local.assignments.contentID].publishDate=local.prereqs.publishDate>
					<cfset local.data.previewMap[local.assignments.contentID].dependent=true>			
				</cfloop>
			</cfif>
		</cfloop>

	</cfif>
	
	<cfset local.assignments=getAssignmentsQuery(changesetID=local.changeset.getChangesetID())>
	
	<cfif local.assignments.recordcount>
		<cfloop query="local.assignments">
			<cfif not structKeyExists(local.data.previewMap,local.assignments.contentID)>
				<cfset local.data.previewMap[local.assignments.contentID]=structNew()>
			</cfif>
			<cfset local.data.previewMap[local.assignments.contentID].contentID=local.assignments.contentID>
			<cfset local.data.previewMap[local.assignments.contentID].contentHistID=local.assignments.contentHistID>
			<cfset local.data.previewMap[local.assignments.contentID].changesetID=local.changeset.getchangesetID()>
			<cfset local.data.previewMap[local.assignments.contentID].changesetName=local.changeset.getName()>
			<cfset local.data.previewMap[local.assignments.contentID].publishDate=local.changeset.getPublishDate()>
			<cfset local.data.previewMap[local.assignments.contentID].dependent=false>				
		</cfloop>
	</cfif>
	
	<cfif not structIsEmpty(local.data.previewMap)>
		<cfloop collection="#local.data.previewMap#" item="local.key">
			 <cfset local.data.contentIDList=listAppend(local.data.contentIDList,"'#local.data.previewMap[local.key].contentID#'")>
			 <cfset local.data.contentHistIDList=listAppend(local.data.contentHistIDList,"'#local.data.previewMap[local.key].contentHistID#'")>
		</cfloop>
	</cfif>

	<!--- Make sure that the order id predicatable to use is for caching context--->
	<cfset local.data.changesetIDList=listSort(local.data.changesetIDList,'text','asc')>

	<cfset structAppend(local.data,local.changeset.getAllValues())>
	<cfset local.data.lastApplied=now()>
	<cfset local.currentUser.setValue("ChangesetPreviewData",local.data)>
<cfelseif not arguments.append>
	<cfset removeSessionPreviewData()>
</cfif>

</cffunction>

<cffunction name="removeSessionPreviewData" access="public" returntype="any" output="false">
	<cfset getCurrentUser().setValue("ChangesetPreviewData","")>
	<cfset request.muraChangesetPreviewToolbar=false>
</cffunction>

<cffunction name="publish" access="public" returntype="any" output="false">
<cfargument name="changesetID">
<cfargument name="byDate" default="false">
	<cfif not hasPendingApprovals(arguments.changesetID)>
		<cfset var it=getAssignmentsIterator(argumentCollection=arguments)>
		<cfset var item="">
		<cfset var changeset=read(arguments.changesetID)>
		<cfset var requestID="">
		<cfset var contentHistID="">
		<cfset var approvalRequest="">
		<cfset var rollback="">
		<cfset var current="">
		<cfset var previous="">
		<cfset var EventArgs=changeset.getAllValues()>
		<cfset EventArgs.changesetBean=changeset>
		<cfset EventArgs.changeset=changeset>

		<cfset var pluginEvent=createObject("component","mura.MuraScope").init(EventArgs)>

		<cfset pluginEvent.announceEvent('onBeforeChangeSetPublish')>
		
		<cfif not changeset.hasErrors()>
			<cfloop condition="it.hasNext()">
				<cfset item=it.next()>
				<cfset item.setApproved(1)>
				<cfset item.setApprovalChainOverride(true)>
				<cfset item.setLastUpdateBy(item.getLastUpdateBy())>
				<cfset item.setLastUpdateByID(item.getLastUpdateByID())>
				
				<cfset current=getBean('content').loadBy(contentID=item.getContentID(),siteID=item.getSiteID())>
				<cfset requestID=item.getRequestID()>
				<cfset contentHistID=item.getContentHistID()>

				<cfset item.save()>

				<cfif len(requestID)>
					<cfset getBean('approvalRequest').loadBy(requestID=requestID).setContentHistID(item.getContentHistID()).save()>
					<cfset previous=getBean('content').loadBy(contentHistID=contentHistID,siteID=item.getSiteID())>
					
					<cfif not previous.getIsNew()>
						<cfset previous.deleteVersion()>
					</cfif>
				</cfif>

				<cfset rollback=getBean('changesetRollBack').loadBy(
						changesetHistID=item.getContentHistID(), 
						changesetID=item.getChangesetID(), 
						previousHistID=current.getContentHistID(),
						siteID=item.getSiteID()
					).save()>
			</cfloop>
			
			<cfset changeset.setPublished(1)>
			<cfset changeset.setPublishDate(now())>
			<cfset changeset.save()>

			<cfset pluginEvent.announceEvent('onAfterChangeSetPublish')>
		<cfelse>
			<cfset pluginEvent.announceEvent('onAfterChangeSetPublishFailure')>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getAssignmentsIterator" access="public" returntype="any" output="false">
<cfargument name="changesetID">
<cfargument name="keywords" default="">
	<cfset var rs=getAssignmentsQuery(argumentCollection=arguments)>
	<cfset var it=getBean("contentIterator")>
	<cfset it.setQuery(rs)>
	<cfreturn it>
</cffunction>

<cffunction name="getAssignmentsQuery" access="public" returntype="any" output="false">
<cfargument name="changesetID">
<cfargument name="keywords" default="">
<cfargument name="moduleid" default="">
	<cfset var rs="">
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select tcontent.menutitle, tcontent.siteid, tcontent.parentID, tcontent.path, tcontent.contentid, tcontent.contenthistid, tcontent.fileID, tcontent.type, tcontent.subtype, tcontent.lastupdateby, tcontent.active, tcontent.approved, tcontent.lastupdate,
	tcontent.lastupdateby, tcontent.lastupdatebyid, 
	tcontent.display, tcontent.displaystart, tcontent.displaystop, tcontent.moduleid, tcontent.isnav, tcontent.notes,tcontent.isfeature,tcontent.inheritObjects,tcontent.filename,tcontent.targetParams,tcontent.releaseDate,
	tcontent.changesetID, tfiles.fileExt, tcontent.title, tcontent.menutitle, tapprovalrequests.status approvalStatus, tapprovalrequests.status approvalStatus,tapprovalrequests.requestID
	from tcontent 
	left join tfiles on tcontent.fileID=tfiles.fileID
	left join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
	<cfif len(arguments.keywords)>
	and ( tcontent.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
		or tcontent.menutitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
		or tcontent.summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
		or tcontent.body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
		)
	</cfif>
	<cfif len(arguments.moduleid)>
		and tcontent.moduleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleid#">
	</cfif>
	order by tcontent.menutitle
	</cfquery>
	<cfreturn rs>
</cffunction>


<cffunction name="hasPendingApprovals" access="public" returntype="any" output="false">
<cfargument name="changesetID">

	<cfset var rs="">
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select tcontent.contenthistid
	from tcontent 
	inner join tapprovalrequests on (tcontent.contenthistid=tapprovalrequests.contenthistid)
	where tcontent.changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
	and tapprovalrequests.status !='Approved'
	</cfquery>
	<cfreturn rs.recordcount>
</cffunction>

<cffunction name="removeItem" access="public" returntype="any" output="false">
<cfargument name="changesetID">
<cfargument name="contentHistID">
	
	<cfquery>
	update tcontent
	set changesetID=null
	where 
	changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
	and contenthistid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenthistID#">
	</cfquery>
	
</cffunction>

<cffunction name="getIterator" access="public" returntype="any" output="false">
<cfargument name="siteID">
	<cfset var iterator=getBean("changesetIterator")>
	<cfset iterator.setQuery(getQuery(argumentCollection=arguments))>
	<cfreturn iterator>
</cffunction>

<cffunction name="getFeed" access="public" returntype="any" output="false">
<cfargument name="siteID">
	<cfreturn getBean("beanFeed").setEntityName('changeset').setTable('tchangesets')>
</cffunction>

<cffunction name="rollback" output="false">
	<cfargument name="changesetID">
	<cfset read(changesetID=arguments.changesetID).rollback()>	
	<cfreturn this>
</cffunction>

<cffunction name="getTagCloud" access="public" output="false" returntype="query">
	<cfargument name="siteID" type="String" required="true" default="">
	
	<cfset var rsTagCloud= ''/>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsTagCloud')#">
	select tag, count(tag) as tagCount	
	from tchangesettagassign 
	group by tag
	order by tag
	</cfquery>
	
	<cfreturn rsTagCloud />
</cffunction>

</cfcomponent>