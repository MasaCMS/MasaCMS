<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="commentID" type="string" default="" required="true" />
<cfproperty name="contentID" type="string" default="" required="true" />
<cfproperty name="parentID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="comments" type="string" default="" required="true" />
<cfproperty name="url" type="string" default="" required="true" />
<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="email" type="string" default="" required="true" />
<cfproperty name="entered" type="date" default="" required="true" />
<cfproperty name="subscribe" type="numeric" default="0" required="true" />
<cfproperty name="isApproved" type="numeric" default="0" required="true" />
<cfproperty name="userID" type="string" default="" required="true" />
<cfproperty name="path" type="string" default="" required="true" />
<cfproperty name="kids" type="string" default="" required="true" />

<cfset variables.contentRenderer=application.contentRenderer/>

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	<cfargument name="settingsManager">
	<cfargument name="utility">
	<cfargument name="contentDAO">
	<cfargument name="contentManager">
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.utility=arguments.utility />
	<cfset variables.contentDAO=arguments.contentDAO />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfset variables.contentManager=arguments.contentManager/>
	
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

	<cfreturn this />
</cffunction>

<cffunction name="getCommentID" returntype="String" access="public" output="false">
	<cfif not len(variables.instance.commentID)>
	<cfset variables.instance.commentID=createUUID() />
	</cfif>
	<cfreturn variables.instance.commentID />
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

<cffunction name="setSubscribe" access="public" output="false">
	<cfargument name="subscribe" />
	<cfif isNumeric(arguments.subscribe)>
	<cfset variables.instance.subscribe = arguments.subscribe />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setIsApproved" access="public" output="false">
	<cfargument name="isApproved" />
	<cfif isNumeric(arguments.isApproved)>
	<cfset variables.instance.isApproved = arguments.isApproved />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setEntered" access="public" output="false">
	<cfargument name="entered" />
	<cfif isDate(arguments.entered)>
	<cfset variables.instance.entered = arguments.entered />
	</cfif>
	<cfreturn this>
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
	
	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
	<cfset pluginEvent.init(eventArgs)>
	
	<cfset getBean('trashManager').throwIn(this)>
	
	<cfset pluginManager.announceEvent("onBeforeCommentDelete",pluginEvent)>
	
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentcomments
	where path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#getCommentID()#%">
	</cfquery>
	
	<cfset pluginManager.announceEvent("onAfterCommentDelete",pluginEvent)>
	
	<cfset variables.contentManager.setCommentStat(getContentID(),variables.instance.siteID) />
</cffunction>

<cffunction name="save" access="public" output="false">
	<cfargument name="contentRenderer" default="#variables.contentRenderer#" required="true" hint="I'm the contentRenderer used to render links sent to subscribers.">
	<cfargument name="script" required="true" default="" hint="I'm the script that is sent to the subscribers.">
	<cfargument name="subject" required="true" default="" hint="I'm the subject that is sent to the subscribers.">
	<cfargument name="notify" required="true" default="false" hint="I tell whether to notify subscribers.">
	<cfset var rs=""/>
	<cfset var rslist=""/>
	<cfset var path=""/>
	<cfset var pluginManager=getPluginManager()>
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	
	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
	<cfset structAppend(eventArgs, arguments)>
	
	<cfset pluginEvent.init(eventArgs)>
	
	<cfif len(variables.instance.parentID)>
		<cfset path=variables.contentManager.getCommentBean().setCommentID(variables.instance.parentID).load().getPath()>
	</cfif>
	
	<cfset path=listAppend(path, getCommentID())>
	
	<cfset pluginManager.announceEvent("onBeforeCommentSave",pluginEvent)>
	
	<cfif getQuery().recordcount>
		
		<cfset pluginManager.announceEvent("onBeforeCommentUpdate",pluginEvent)>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentcomments set
			contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#"/>,
			name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.name#"/>,
			email=<cfif len(variables.instance.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.email#"/><cfelse>null</cfif>,
			url=<cfif len(variables.instance.url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.url#"/><cfelse>null</cfif>,
			comments=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#variables.instance.comments#"/>,
			entered=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.entered#">,
			siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#"/>,
			isApproved=#variables.instance.isApproved#,
			subscribe=<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.subscribe#">,
			userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.useriD#"/>,
			parentID=<cfif len(variables.instance.parentID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.parentID#"/><cfelse>null</cfif>,
			path=<cfqueryparam cfsqltype="cf_sql_varchar" value="#path#"/>
		where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
		</cfquery>
		
		<cfset pluginManager.announceEvent("onAfterCommentUpdate",pluginEvent)>
	<cfelse>
	
		<cfset pluginManager.announceEvent("onBeforeCommentCreate",pluginEvent)>
		
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rslist">
			insert into tcontentcomments (contentid,commentid,parentid,name,email,url,comments,entered,siteid,isApproved,subscribe,userID,path, ip)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#"/>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#"/>,
			<cfif len(variables.instance.parentID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.parentID#"/><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.name#"/>,
			<cfif len(variables.instance.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.email#"/><cfelse>null</cfif>,
			<cfif len(variables.instance.url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.url#"/><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#variables.instance.comments#"/>,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#variables.instance.entered#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#"/>,
			#variables.instance.isApproved#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.subscribe#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.userID#"/>,
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
	
	<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="saveSubscription" access="public" output="false">		
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			update tcontentcomments set subscribe=<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.subscribe#">
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
			and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
			and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.email#">
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

<cfif len(variables.settingsManager.getSite(variables.instance.siteID).getContactEmail())>
	<cfset contactEmail=variables.settingsManager.getSite(variables.instance.siteID).getContactEmail()>
<cfelse>
	<cfset contactEmail=variables.settingsManager.getSite(variables.instance.siteID).getContact()>
</cfif>

<cfif not len(arguments.script)>

<cfquery name="rsContent" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select title from tcontent 
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	and active=1
</cfquery>

<cfsavecontent variable="notifyText"><cfoutput>
A comment has been posted to "#rscontent.title#" by #gvariables.instance.name#.

COMMENT:
#getComments()#

Approve
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/#variables.instance.siteID#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL(true,"approvedcommentID=#getCommentID()#"))#

Delete
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/#variables.instance.siteID#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL(true,"deletecommentID=#getCommentID()#"))#

View 
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/#variables.instance.siteID#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL())#
</cfoutput></cfsavecontent>

<cfelse>

<cfset notifyText=arguments.script />

</cfif>

<cfset email=application.serviceFactory.getBean('mailer') />
<cfset email.sendText(notifyText,
						contactEmail,
						getName(),
						'New Comment',
						variables.instance.siteID) />
						
<cfreturn this>
</cffunction>

<cffunction name="notifySubscribers" access="public" output="false">
<cfargument name="contentRenderer" required="true" default="#application.contentRenderer#">
<cfargument name="script" required="true" default="">
<cfargument name="subject" required="true" default="">
<cfargument name="notifyAdmin" required="true" default="true">
<cfset var site=variables.settingsManager.getSite(variables.instance.siteID)>
<cfset var rsContent="">
<cfset var notifyText="">
<cfset var notifysubject=arguments.subject>
<cfset var email="">
<cfset var rsSubscribers=variables.contentDAO.getCommentSubscribers(variables.instance.contentID,variables.instance.siteID)>

<cfquery name="rsContent" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select title from tcontent 
	where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
	and active=1
</cfquery>

<cfif not len(notifySubject)>
	<cfset notifySubject="New Comment on '#rscontent.title#'">
</cfif>

<cfif not len(arguments.script)>

<cfsavecontent variable="notifyText"><cfoutput>
A comment has been posted to "#rscontent.title#" by #variables.instance.name#.

COMMENT:
#variables.instance.comments#

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
							variables.instance.siteID) />
</cfloop>

<cfif arguments.notifyAdmin and len(site.getContactEmail())>
	<cfset email.sendText(notifyText & arguments.contentRenderer.getCurrentURL(true,"commentUnsubscribe=#URLEncodedFormat(site.getContactEmail())#"),
							site.getContactEmail(),
							site.getSite(),
							notifySubject,
							variables.instance.siteID) />
</cfif>

<cfreturn this>
</cffunction>

<cffunction name="getKidsQuery" returnType="query" output="false" access="public">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfif getKids()>
		<cfreturn variables.contentManager.readComments(variables.instance.contentID, variables.instance.siteID, arguments.isEditor, arguments.sortOrder, getCommentID() ) />
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
	<cfif len(variables.instance.parentID)>
		<cfset commentBean.setCommentID(variables.instance.parentID) />
		<cfset commentBean.load() />
		<cfreturn commentBean>
	<cfelse>
		<cfthrow message="Parent comment does not exist.">
	</cfif>
</cffunction>

<cffunction name="getUser" output="false" returntype="any">
	<cfset var user=getBean("user").loadBy(userID=variables.instance.userID)>
	
	<cfif user.getIsNew()>
		<cfset user.setSiteID(variables.instance.siteID)>
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
					where parentID in (select commentID from tcontentcomments where parentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#variables.instance.path#">))
					group by parentID
				)  k on c.commentID=k.parentID
		where 
		commentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#variables.instance.path#">)
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
	<cfreturn listLen(variables.instance.path) gt 1>
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfreturn variables.instance />
</cffunction>

<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
	<cfreturn this>
</cffunction>

<cffunction name="clone" output="false">
	<cfreturn application.contentManager.getCommentBean().setAllValues(structCopy(getAllValues()))>
</cffunction>
</cfcomponent>