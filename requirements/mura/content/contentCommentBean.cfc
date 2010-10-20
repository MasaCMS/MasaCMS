<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.commentID="" />
<cfset variables.instance.contentID="" />
<cfset variables.instance.parentID=""/>
<cfset variables.instance.siteID=""/>
<cfset variables.instance.comments=""/>
<cfset variables.instance.url=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.email=""/>
<cfset variables.instance.entered=now()/>
<cfset variables.instance.subscribe=0/>
<cfset variables.instance.isApproved=0/>
<cfset variables.contentRenderer=application.contentRenderer/>
<cfset variables.instance.userID=""/>
<cfset variables.instance.path=""/>
<cfset variables.instance.kids=0/>
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	<cfargument name="settingsManager">
	<cfargument name="utility">
	<cfargument name="contentDAO">
	<cfargument name="contentManager">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.utility=arguments.utility />
	<cfset variables.contentDAO=arguments.contentDAO />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfset variables.contentManager=arguments.contentManager/>

	<cfreturn this />
</cffunction>

<cffunction name="set" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop=""/>
		
		<cfif isquery(arguments.data)>
		
			<cfif arguments.data.recordcount>
				<cfset setContentID(arguments.data.ContentID) />
				<cfset setCommentID(arguments.data.commentID) />
				<cfset setSiteID(arguments.data.siteID) />
				<cfset setEmail(arguments.data.email) />
				<cfset setName(arguments.data.name) />
				<cfset setUrl(arguments.data.url) />
				<cfset setSubscribe(arguments.data.subscribe) />
				<cfset setEntered(arguments.data.entered) />
				<cfset setIsApproved(arguments.data.isApproved) />
				<cfset setComments(arguments.data.comments) />
				<cfset setUserID(arguments.data.userID) />
				<cfset setParentID(arguments.data.parentID) />
				<cfset setPath(arguments.data.path) />
				<cfset setFileID(arguments.data.fileID) />
				<cfset setFileExt(arguments.data.fileExt) />
				<cfset setKids(arguments.data.kids) />
			</cfif>
			
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
				<cfif structKeyExists(this,"set#prop#")>
					<cfset evaluate("set#prop#(arguments.data[prop])") />
				</cfif>
			</cfloop>
				
		</cfif>
		
		<cfset validate() />
		<cfreturn this>
</cffunction>
  
<cffunction name="validate" access="public" output="false">
	<cfset variables.instance.errors=structnew() />
	<cfreturn this>
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getContentID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.contentID />
</cffunction>

<cffunction name="setContentID" access="public" output="false">
	<cfargument name="ContentID" type="String" />
	<cfset variables.instance.ContentID = trim(arguments.ContentID) />
	<cfreturn this>
</cffunction>

<cffunction name="getCommentID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.commentID)>
	<cfset variables.instance.commentID=createUUID() />
	</cfif>
	<cfreturn variables.instance.commentID />
</cffunction>

<cffunction name="setCommentID" access="public" output="false">
	<cfargument name="commentID" type="String" />
	<cfset variables.instance.commentID = trim(arguments.commentID) />
	<cfreturn this>
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SiteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="SiteID" type="String" />
	<cfset variables.instance.SiteID = trim(arguments.SiteID) />
	<cfreturn this>
</cffunction>

<cffunction name="getParentID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.parentID />
</cffunction>

<cffunction name="setParentID" access="public" output="false">
	<cfargument name="parentID" type="String" />
	<cfset variables.instance.parentID = trim(arguments.parentID) />
	<cfreturn this>
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
	<cfreturn this>
</cffunction>

<cffunction name="getURL" returntype="String" access="public" output="false">
	<cfreturn variables.instance.url />
</cffunction>

<cffunction name="setURL" access="public" output="false">
	<cfargument name="url" type="String" />
	
	<cfset variables.instance.url = trim(arguments.url) />
		
	<cfif len(variables.instance.url) and 
			not listFindNoCase("http:,https:",listFirst(variables.instance.url,"//"))>
		<cfset variables.instance.url = "http://" & variables.instance.url />
	</cfif>
	<cfreturn this>		
</cffunction>

<cffunction name="getEmail" returntype="String" access="public" output="false">
	<cfreturn variables.instance.email />
</cffunction>

<cffunction name="setEmail" access="public" output="false">
	<cfargument name="email" type="String" />
	<cfset variables.instance.email = trim(arguments.email) />
	<cfreturn this>
</cffunction>

<cffunction name="getComments" returntype="String" access="public" output="false">
	<cfreturn variables.instance.comments />
</cffunction>

<cffunction name="setComments" access="public" output="false">
	<cfargument name="comments" type="String" />
	<cfset variables.instance.comments = trim(arguments.comments) />
	<cfreturn this>
</cffunction>

<cffunction name="getPath" returntype="String" access="public" output="false">
	<cfreturn variables.instance.path />
</cffunction>

<cffunction name="setPath" access="public" output="false">
	<cfargument name="path" type="String" />
	<cfset variables.instance.path = trim(arguments.path) />
	<cfreturn this>
</cffunction>

<cffunction name="getSubscribe" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.subscribe />
</cffunction>

<cffunction name="setSubscribe" access="public" output="false">
	<cfargument name="subscribe" />
	<cfif isNumeric(arguments.subscribe)>
	<cfset variables.instance.subscribe = arguments.subscribe />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getIsApproved" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isApproved />
</cffunction>

<cffunction name="setIsApproved" access="public" output="false">
	<cfargument name="isApproved" />
	<cfif isNumeric(arguments.isApproved)>
	<cfset variables.instance.isApproved = arguments.isApproved />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEntered" returntype="string" access="public" output="false">
	<cfreturn variables.instance.entered />
</cffunction>

<cffunction name="setEntered" access="public" output="false">
	<cfargument name="entered" />
	<cfif isDate(arguments.entered)>
	<cfset variables.instance.entered = arguments.entered />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getUserID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.userID />
</cffunction>

<cffunction name="setUserID" access="public" output="false">
	<cfargument name="userID" type="String" />
	<cfset variables.instance.userID = trim(arguments.userID) />
	<cfreturn this>
</cffunction>

<cffunction name="getFileID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.fileID />
</cffunction>

<cffunction name="setFileID" access="public" output="false">
	<cfargument name="fileID" type="String" />
	<cfset variables.instance.fileID = trim(arguments.fileID) />
	<cfreturn this>
</cffunction>

<cffunction name="getFileExt" returntype="String" access="public" output="false">
	<cfreturn variables.instance.fileExt />
</cffunction>

<cffunction name="setFileExt" access="public" output="false">
	<cfargument name="fileExt" type="String" />
	<cfset variables.instance.fileExt = trim(arguments.fileExt) />
	<cfreturn this>
</cffunction>

<cffunction name="getKids" access="public" output="false">
	<cfreturn variables.instance.kids />
</cffunction>

<cffunction name="setKids" access="public" output="false">
	<cfargument name="kids"/>
	<cfif isNumeric(arguments.kids)>
	<cfset variables.instance.kids = arguments.kids />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setContentRenderer" access="public" output="false">
	<cfargument name="contentRenderer" />
	<cfset variables.contentRenderer = arguments.contentRenderer />
	<cfreturn this>
</cffunction>

<cffunction name="load" access="public" output="false">
	<cfset var rs=getQuery()>
	<cfif rs.recordcount>
		<cfset set(rs) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select c.contentid,c.commentid,c.parentid,c.name,c.email,c.url,c.comments,c.entered,c.siteid,c.isApproved,c.subscribe, c.userID, c.path, k.kids, f.fileid, f.fileExt 
	from tcontentcomments c left join (select count(*) kids, parentID 
										from tcontentcomments where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#"> 
										group by parentID
										) k
										on c.commentID = k.parentID
	left join tusers u on c.userid=u.userid
	left join tfiles f on u.photofileid=f.fileid 
	where c.commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public">
	<cfset var pluginManager=getPluginManager()>
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	
	<cfset eventArgs.siteID=getSiteID()>
	<cfset eventArgs.commentBean=this>
	<cfset pluginEvent.init(eventArgs)>
	
	<cfset getBean('trashManager').throwIn(this)>
	
	<cfset pluginManager.announceEvent("onBeforeCommentDelete",pluginEvent)>
	
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentcomments
	where path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#getCommentID()#%">
	</cfquery>
	
	<cfset pluginManager.announceEvent("onAfterCommentDelete",pluginEvent)>
	
	<cfset variables.contentManager.setCommentStat(getContentID(),getSiteID()) />
</cffunction>

<cffunction name="save" access="public" output="false">
	<cfargument name="contentRenderer" default="#variables.contentRenderer#" required="true" hint="I'm the contentRenderer used to render links sent to subscribers.">
	<cfargument name="script" required="true" default="" hint="I'm the script that is sent to the subscribers.">
	<cfargument name="subject" required="true" default="" hint="I'm the subject that is sent to the subscribers.">
	<cfargument name="notify" required="true" default="false" hint="I tell whether to notify subscribers.">
	<cfset var rs=""/>
	<cfset var path=""/>
	<cfset var pluginManager=getPluginManager()>
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	
	<cfset eventArgs.siteID=getSiteID()>
	<cfset eventArgs.commentBean=this>
	<cfset structAppend(eventArgs, arguments)>
	
	<cfset pluginEvent.init(eventArgs)>
	
	<cfif len(getParentID())>
		<cfset path=variables.contentManager.getCommentBean().setCommentID(getParentID()).load().getPath()>
	</cfif>
	
	<cfset path=listAppend(path, getCommentID())>
	
	<cfset pluginManager.announceEvent("onBeforeCommentSave",pluginEvent)>
	
	<cfif getQuery().recordcount>
		
		<cfset pluginManager.announceEvent("onBeforeCommentUpdate",pluginEvent)>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentcomments set
			contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#"/>,
			name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getName()#"/>,
			email=<cfif len(getEmail())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getEmail()#"/><cfelse>null</cfif>,
			url=<cfif len(getURL())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getURL()#"/><cfelse>null</cfif>,
			comments=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#getComments()#"/>,
			entered=#createodbcdatetime(getEntered())#,
			siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#"/>,
			isApproved=#getIsApproved()#,
			subscribe=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getSubscribe()#">,
			userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getUserID()#"/>,
			parentID=<cfif len(getParentID())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getParentID()#"/><cfelse>null</cfif>,
			path=<cfqueryparam cfsqltype="cf_sql_varchar" value="#path#"/>
		where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
		</cfquery>
		
		<cfset pluginManager.announceEvent("onAfterCommentUpdate",pluginEvent)>
	<cfelse>
	
		<cfset pluginManager.announceEvent("onBeforeCommentCreate",pluginEvent)>
		
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rslist">
			insert into tcontentcomments (contentid,commentid,parentid,name,email,url,comments,entered,siteid,isApproved,subscribe,userID,path, ip)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#"/>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#"/>,
			<cfif len(getParentID())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getParentID()#"/><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getName()#"/>,
			<cfif len(getEmail())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getEmail()#"/><cfelse>null</cfif>,
			<cfif len(getURL())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getURL()#"/><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#getComments()#"/>,
			#createodbcdatetime(getEntered())#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#"/>,
			#getIsApproved()#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#getSubscribe()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getUserID()#"/>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#path#"/>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.remoteAddr#"/>
			)
			</cfquery>
			
		<cfset pluginManager.announceEvent("onAfterCommentCreate",pluginEvent)>
		<cfset getBean('trashManager').takeOut(this)>
	</cfif>
	
	<cfset pluginManager.announceEvent("onAfterCommentSave",pluginEvent)>
	
	<cfif getIsApproved()>
		<cfset saveSubscription()>
		<cfif isBoolean(pluginEvent.getValue("notify")) and pluginEvent.getValue("notify")>
			<cfset notifySubscribers(arguments.contentRenderer,arguments.script,arguments.subject)>
		</cfif>
	</cfif>
	
	<cfset variables.contentManager.setCommentStat(getContentID(),getSiteID()) />
	<cfreturn this>
</cffunction>

<cffunction name="saveSubscription" access="public" output="false">		
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			update tcontentcomments set subscribe=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getSubscribe()#">
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#">
			and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
			and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getEmail()#">
	</cfquery>
	<cfreturn this>
</cffunction>

<cffunction name="sendNotification"  access="public" output="false">
<cfargument name="script" required="true" default="">
<cfargument name="contentRenderer" required="true" default="#variables.contentRenderer#">

<cfset var rsContent="">
<cfset var notifyText="">
<cfset var email="">
<cfset var contactEmail="">

<cfif len(variables.settingsManager.getSite(getSiteID()).getContactEmail())>
	<cfset contactEmail=variables.settingsManager.getSite(getSiteID()).getContactEmail()>
<cfelse>
	<cfset contactEmail=variables.settingsManager.getSite(getSiteID()).getContact()>
</cfif>

<cfif not len(arguments.script)>

<cfquery name="rsContent" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select title from tcontent 
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
	and active=1
</cfquery>

<cfsavecontent variable="notifyText"><cfoutput>
A comment has been posted to "#rscontent.title#" by #getName()#.

COMMENT:
#getComments()#

Approve
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/#getSiteID()#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL(true,"approvedcommentID=#getCommentID()#"))#

Delete
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/#getSiteID()#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL(true,"deletecommentID=#getCommentID()#"))#

View 
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/#getSiteID()#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL())#
</cfoutput></cfsavecontent>

<cfelse>

<cfset notifyText=arguments.script />

</cfif>

<cfset email=application.serviceFactory.getBean('mailer') />
<cfset email.sendText(notifyText,
						contactEmail,
						getName(),
						'New Comment',
						getSiteID()) />
						
<cfreturn this>
</cffunction>

<cffunction name="notifySubscribers" access="public" output="false">
<cfargument name="contentRenderer" required="true" default="#application.contentRenderer#">
<cfargument name="script" required="true" default="">
<cfargument name="subject" required="true" default="">
<cfargument name="notifyAdmin" required="true" default="true">
<cfset var site=variables.settingsManager.getSite(getSiteID())>
<cfset var rsContent="">
<cfset var notifyText="">
<cfset var notifysubject=arguments.subject>
<cfset var email="">
<cfset var rsSubscribers=variables.contentDAO.getCommentSubscribers(getContentID(),getSiteID())>

<cfquery name="rsContent" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select title from tcontent 
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#">
	and active=1
</cfquery>

<cfif not len(notifySubject)>
	<cfset notifySubject="New Comment on '#rscontent.title#'">
</cfif>

<cfif not len(arguments.script)>

<cfsavecontent variable="notifyText"><cfoutput>
A comment has been posted to "#rscontent.title#" by #getName()#.

COMMENT:
#getComments()#

View 
#arguments.contentRenderer.getCurrentURL()#

To Unsubscribe Click Here:
</cfoutput></cfsavecontent>

<cfelse>

<cfset notifyText=arguments.script />

</cfif>

<cfset email=application.serviceFactory.getBean('mailer') />

<cfloop query="rsSubscribers">
	<cfset email.sendText(notifyText & arguments.contentRenderer.getCurrentURL(true,"commentUnsubscribe=#URLEncodedFormat(rsSubscribers.email)#"),
							rsSubscribers.email,
							site.getSite(),
							notifySubject,
							getSiteID()) />
</cfloop>

<cfif arguments.notifyAdmin and len(site.getContactEmail())>
	<cfset email.sendText(notifyText & arguments.contentRenderer.getCurrentURL(true,"commentUnsubscribe=#URLEncodedFormat(site.getContactEmail())#"),
							site.getContactEmail(),
							site.getSite(),
							notifySubject,
							getSiteID()) />
</cfif>

<cfreturn this>
</cffunction>

<cffunction name="getKidsQuery" returnType="query" output="false" access="public">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfif getKids()>
		<cfreturn variables.contentManager.readComments(getContentID(), getSiteID(), arguments.isEditor, arguments.sortOrder, getCommentID() ) />
	<cfelse>
		<cfreturn queryNew("contentid,commentid,parentid,name,email,url,comments,entered,siteid,isApproved,subscribe,userID,path,kids,fileid,fileExt")>
	</cfif>
</cffunction>

<cffunction name="getKidsIterator" returnType="any" output="false" access="public">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfset var q=getKidsQuery(arguments.isEditor, arguments.sortOrder)>
	<cfset var it=getBean("contentCommentIterator").init()>
	<cfset it.setQuery(q)>
	<cfreturn it />
</cffunction>

<cffunction name="getParent" output="false" returntype="any">
	<cfset var commentBean=getCommentBean() />
	<cfif len(getParentID())>
		<cfset commentBean.setCommentID(getParentID()) />
		<cfset commentBean.load() />
		<cfreturn commentBean>
	<cfelse>
		<cfthrow message="Parent comment does not exist.">
	</cfif>
</cffunction>

<cffunction name="getUser" output="false" returntype="any">
	<cfset var user=getBean("user").loadBy(userID=getUserID())>
	
	<cfif user.getIsNew()>
		<cfset user.setSiteID(getSiteID())>
	</cfif>
	
	<cfreturn user>
</cffunction>

<cffunction name="getCrumbQuery" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfset var rs="">
	
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select c.contentid,c.commentid,c.parentid,c.name,c.email,c.url,c.comments,c.entered,c.siteid,
		c.isApproved,c.subscribe,c.userID,c.path, 
		<cfif variables.configBean.getDBType() eq "MSSQL">
		len(Cast(c.path as varchar(1000))) depth
		<cfelse>
		length(c.path) depth
		</cfif>,
		f.fileID, f.fileExt, k.kids
		from tcontentcomments c 
		left join tusers u on (c.userid=u.userid)
		left join tfiles f on (u.photofileid=f.fileid)
		left join (select count(*) kids, parentID from tcontentcomments
					where parentID in (select commentID from tcontentcomments where parentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#getPath()#">))
					group by parentID
				)  k on c.commentID=k.parentID
		where 
		commentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#getPath()#">)
		order by depth <cfif arguments.sort eq "desc">desc<cfelse>asc</cfif>
	</cfquery>	

	<cfreturn rs>
</cffunction>

<cffunction name="getCrumbIterator" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfset var rs=getCrumbQuery(arguments.sort)>
	<cfset var it=getBean("contentCommentIterator").init()>
	<cfset it.setQuery(rs)>
	<cfreturn it>
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfargument name="commentID">
	<cfset set(arguments)>
	<cfset load()>
	<cfreturn this>
</cffunction>

<cffunction name="hasParent" output="false">
	<cfreturn listLen(getPath()) gt 1>
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfreturn variables.instance />
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfreturn this>
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >

	<cfset variables.instance["#arguments.property#"]=arguments.propertyValue />
	<cfreturn this>
</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	
	<cfif structKeyExists(variables.instance,"#arguments.property#")>
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables.instance["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables.instance["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

</cfcomponent>