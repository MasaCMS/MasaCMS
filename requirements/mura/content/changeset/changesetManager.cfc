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
	<cfset var bean=arguments.changesetBean>
	
	<cfif not isObject(bean)>
		<cfset bean=getBean("changeset")>
	</cfif>
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select changesetID, siteID, name, description, created, publishDate, published, lastupdate, lastUpdateBy, lastUpdateByID, remoteID, remotePubDate, remoteSourceURL
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
	
	<cfreturn bean>

</cffunction>

<cffunction name="save" access="public" returntype="any" output="false">
	<cfargument name="bean"/>
	
	<cfset var rs="">
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select changesetID from tchangesets
		where changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getChangesetID()#"> 
	</cfquery>
	
	<cfif rs.recordcount>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
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
		remoteSourceURL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getRemoteSourceURL()#">
		where changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getChangesetID()#">
	</cfquery>

	<cfelse>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
		insert into tchangesets (changesetID, siteID, name, description, created, publishDate, 
		published, lastupdate, lastUpdateBy, lastUpdateByID,
		remoteID, remotePubDate, remoteSourceURL)
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
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getRemoteSourceURL()#">
		)
	</cfquery>
	
	<cfset variables.trashManager.takeOut(bean)>
	
	</cfif>
	<cfreturn bean>

</cffunction>

<cffunction name="delete" access="public" returntype="any" output="false">
<cfargument name="changesetID">
    <cfset var bean=read(arguments.changesetID) />
	
	<cfset variables.trashManager.throwIn(bean)>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
	delete from tchangesets 
	where changesetID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
	</cfquery>

</cffunction>

<cffunction name="getQuery" access="public" returntype="any" output="false">
<cfargument name="siteID">
<cfargument name="published">
<cfargument name="publishDate">
<cfargument name="publishDateOnly" default="true">
<cfargument name="keywords">
<cfargument name="sortBy">

	<cfset var rsChangeSets="">
	<cfquery name="rsChangeSets" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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
	<cfif structKeyExists(arguments,"keywords") and len(arguments.keywords)>
	and (
		name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
	
		or
		
		description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%">
		
		)
	</cfif>
	order by 
	<cfif structKeyExists(arguments,"sortBy") and arguments.sortBy eq "PublishDate">
	publishDate asc, name
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
	<cfquery name="rsPendingChangeSets" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select tchangesets.changesetID, tcontent.contentID, tcontent.contenthistid, tcontent.siteID, tchangesets.name changesetName, tcontent.lastupdate
	from tcontent
	inner join tchangesets on tcontent.changesetID=tchangesets.changesetID
	where tcontent.siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	and tcontent.contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
	and tchangesets.published=0
	</cfquery>
	<cfreturn rsPendingChangeSets>
</cffunction>

<cffunction name="publishBySchedule" access="public" returntype="any" output="false">
	<cfset var rsPendingChangeSets="">
	
	<cfquery name="rsPendingChangeSets" cachedwithin="#CreateTimeSpan(0, 0, 5, 0)#" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
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
<cfset var local=structNew()>

<cfset local.changeset=read(arguments.changesetID)>
<cfset local.changesetPreviewMap=structNew()>
<cfset local.contentIDList="">
<cfset local.contentHistIDList="">

<cfif not local.changeset.getIsNew() and not local.changeset.getPublished()>
	<cfif isDate(local.changeset.getPublishDate())>
		<cfquery name="local.prereqs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select changesetID,name,publishDate
		from tchangesets
		where tchangesets.published=0
		and tchangesets.publishDate is not null
		and tchangesets.publishDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.changeset.getPublishDate()#">
		and tchangesets.changesetID <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.changeset.getChangesetID()#">
		and tchangesets.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.changeset.getSiteID()#">
		order by tchangesets.publishDate asc
		</cfquery>

		<cfloop query="local.prereqs">
			<cfset local.assignments=getAssignmentsQuery(changesetID=local.prereqs.changesetID)>
			<cfif local.assignments.recordcount>
				<cfloop query="local.assignments">
					<cfif not structKeyExists(local.changesetPreviewMap,local.assignments.contentID)>
						<cfset local.changesetPreviewMap[local.assignments.contentID]=structNew()>
					</cfif>
					<cfset local.changesetPreviewMap[local.assignments.contentID].contentID=local.assignments.contentID>
					<cfset local.changesetPreviewMap[local.assignments.contentID].contentHistID=local.assignments.contentHistID>
					<cfset local.changesetPreviewMap[local.assignments.contentID].changesetID=local.prereqs.changesetID>
					<cfset local.changesetPreviewMap[local.assignments.contentID].changesetName=local.prereqs.name>
					<cfset local.changesetPreviewMap[local.assignments.contentID].publishDate=local.prereqs.publishDate>			
				</cfloop>
			</cfif>
		</cfloop>

	</cfif>
	
	<cfset local.assignments=getAssignmentsQuery(changesetID=local.changeset.getChangesetID())>
	<cfif local.assignments.recordcount>
		<cfloop query="local.assignments">
			<cfif not structKeyExists(local.changesetPreviewMap,local.assignments.contentID)>
				<cfset local.changesetPreviewMap[local.assignments.contentID]=structNew()>
			</cfif>
			<cfset local.changesetPreviewMap[local.assignments.contentID].contentID=local.assignments.contentID>
			<cfset local.changesetPreviewMap[local.assignments.contentID].contentHistID=local.assignments.contentHistID>
			<cfset local.changesetPreviewMap[local.assignments.contentID].changesetID=local.changeset.getchangesetID()>
			<cfset local.changesetPreviewMap[local.assignments.contentID].changesetName=local.changeset.getName()>
			<cfset local.changesetPreviewMap[local.assignments.contentID].publishDate=local.changeset.getPublishDate()>			
		</cfloop>
	</cfif>
	
	<cfif not structIsEmpty(local.changesetPreviewMap)>
	<cfloop collection="#local.changesetPreviewMap#" item="local.key">
		 <cfset local.contentIDList=listAppend(local.contentIDList,"'#local.changesetPreviewMap[local.key].contentID#'")>
		 <cfset local.contentHistIDList=listAppend(local.contentHistIDList,"'#local.changesetPreviewMap[local.key].contentHistID#'")>
	</cfloop>
	</cfif>
	
	<cfset local.data=structNew()>
	<cfset local.data.contentIDList=local.contentIDList>
	<cfset local.data.contentHistIDList=local.contentHistIDList>
	<cfif isDefined("local.prereqs")>
		<cfset local.data.prereqs=local.prereqs>
	<cfelse>
		<cfset local.data.prereqs=queryNew("changesetID,name,publishDate")>
	</cfif>
	<cfset structAppend(local.data,local.changeset.getAllValues())>
	<cfset local.data.previewMap=local.changesetPreviewMap>
	
	<cfset local.currentUser=getCurrentUser()>
	
	<cfset local.currentUser.setValue("ChangesetPreviewData",local.data)>
<cfelse>
	<cfset removeSessionPreviewData()>
</cfif>

</cffunction>

<cffunction name="removeSessionPreviewData" access="public" returntype="any" output="false">
	<cfset getCurrentUser().setValue("ChangesetPreviewData","")>
</cffunction>

<cffunction name="publish" access="public" returntype="any" output="false">
<cfargument name="changesetID">
<cfargument name="byDate" default="false">
	<cfset var it=getAssignmentsIterator(argumentCollection=arguments)>
	<cfset var item="">
	<cfset var changeset="">
	
	<cfloop condition="it.hasNext()">
		<cfset item=it.next()>
		<cfset item.setApproved(1)>
		<cfif arguments.byDate>
			<cfset item.setLastUpdateBy("System")>
			<cfset item.setLastUpdateByID("")>
		</cfif>
		<cfset item.save()>
	</cfloop>
	
	<cfset changeset=read(arguments.changesetID)>
	<cfset changeset.setPublished(1)>
	<cfset changeset.setPublishDate(now())>
	<cfset changeset.save()>
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
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#" username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select tcontent.siteid, tcontent.parentID, tcontent.path, tcontent.contentid, tcontent.contenthistid, tcontent.fileID, tcontent.type, tcontent.subtype, tcontent.lastupdateby, tcontent.active, tcontent.approved, tcontent.lastupdate, 
	tcontent.display, tcontent.displaystart, tcontent.displaystop, tcontent.moduleid, tcontent.isnav, tcontent.notes,tcontent.isfeature,tcontent.inheritObjects,tcontent.filename,tcontent.targetParams,tcontent.releaseDate,
	tcontent.changesetID, tfiles.fileExt, tcontent.title, tcontent.menutitle
	from tcontent 
	left join tfiles on tcontent.fileID=tfiles.fileID
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

<cffunction name="removeItem" access="public" returntype="any" output="false">
<cfargument name="changesetID">
<cfargument name="contentHistID">
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDbUsername()#" password="#variables.configBean.getDbPassword()#">
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

</cfcomponent>