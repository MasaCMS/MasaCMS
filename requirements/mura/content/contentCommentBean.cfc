<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.commentID="" />
<cfset variables.instance.contentID="" />
<cfset variables.instance.siteID=""/>
<cfset variables.instance.comments=""/>
<cfset variables.instance.url=""/>
<cfset variables.instance.name=""/>
<cfset variables.instance.email=""/>
<cfset variables.instance.entered=now()/>
<cfset variables.instance.subscribe=0/>
<cfset variables.instance.isApproved=0/>
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="configBean">
	<cfargument name="settingsManager">
	<cfargument name="utility">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.utility=arguments.utility />
	<cfset variables.dsn=variables.configBean.getDatasource()/>

	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
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
				<!--- <cfset setSubscribe(arguments.data.subscribe) /> --->
				<cfset setEntered(arguments.data.entered) />
				<cfset setIsApproved(arguments.data.isApproved) />
				<cfset setComments(arguments.data.comments) />
			</cfif>
			
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.data[prop])") />
				</cfif>
			</cfloop>
				
		</cfif>
		
		<cfset validate() />
		
</cffunction>
  
<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset variables.instance.errors=structnew() />
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
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SiteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="SiteID" type="String" />
	<cfset variables.instance.SiteID = trim(arguments.SiteID) />
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
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
			
</cffunction>

<cffunction name="getEmail" returntype="String" access="public" output="false">
	<cfreturn variables.instance.email />
</cffunction>

<cffunction name="setEmail" access="public" output="false">
	<cfargument name="email" type="String" />
	<cfset variables.instance.email = trim(arguments.email) />
</cffunction>

<cffunction name="getComments" returntype="String" access="public" output="false">
	<cfreturn variables.instance.comments />
</cffunction>

<cffunction name="setComments" access="public" output="false">
	<cfargument name="comments" type="String" />
	<cfset variables.instance.comments = trim(arguments.comments) />
</cffunction>

<cffunction name="getSubscribe" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.subscribe />
</cffunction>

<cffunction name="setSubscribe" access="public" output="false">
	<cfargument name="subscribe" />
	<cfif isNumeric(arguments.subscribe)>
	<cfset variables.instance.subscribe = arguments.subscribe />
	</cfif>
</cffunction>

<cffunction name="getIsApproved" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isApproved />
</cffunction>

<cffunction name="setIsApproved" access="public" output="false">
	<cfargument name="isApproved" />
	<cfif isNumeric(arguments.isApproved)>
	<cfset variables.instance.isApproved = arguments.isApproved />
	</cfif>
</cffunction>

<cffunction name="getEntered" returntype="string" access="public" output="false">
	<cfreturn variables.instance.entered />
</cffunction>

<cffunction name="setEntered" access="public" output="false">
	<cfargument name="entered" />
	<cfif isDate(arguments.entered)>
	<cfset variables.instance.entered = arguments.entered />
	</cfif>
</cffunction>

<cffunction name="load"  access="public" output="false" returntype="void">
	<cfset var rs=getQuery()>
	<cfif rs.recordcount>
		<cfset set(rs) />
	</cfif>
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tcontentcomments 
	where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>
	
	<cfreturn rs/>
</cffunction>

<cffunction name="delete" access="public" returntype="void">
	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentcomments
	where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>
</cffunction>

<cffunction name="save"  access="public" output="false" returntype="void">
<cfset var rs=""/>
	
	
	<cfif getQuery().recordcount>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentcomments set
			contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#"/>,
			name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getName()#"/>,
			email=<cfif len(getEmail())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getEmail()#"/><cfelse>null</cfif>,
			url=<cfif len(getURL())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getURL()#"/><cfelse>null</cfif>,
			comments=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#getComments()#"/>,
			entered=#createodbcdatetime(getEntered())#,
			siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#"/>,
			isApproved=#getIsApproved()#<!--- ,
			subscribe=#getSubscribe()#	 --->
		where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
		</cfquery>
		
	<cfelse>
	
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rslist">
			insert into tcontentcomments (contentid,commentid,name,email,url,comments,entered,siteid,isApproved<!--- ,subscribe --->)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getContentID()#"/>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#"/>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getName()#"/>,
			<cfif len(getEmail())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getEmail()#"/><cfelse>null</cfif>,
			<cfif len(getURL())><cfqueryparam cfsqltype="cf_sql_varchar" value="#getURL()#"/><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#getComments()#"/>,
			#createodbcdatetime(getEntered())#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getSiteID()#"/>,
			#getIsApproved()#<!--- ,
			#getSubscribe()# --->
			)
			</cfquery>
		
	</cfif>
	
</cffunction>

<cffunction name="sendNotification"  access="public" output="false" returntype="void">
<cfargument name="script" required="true" default="">
<cfargument name="contentRenderer" required="true" default="#application.contentRenderer#">

<cfset var rsContent="">
<cfset var notifyText="">
<cfset var email="">

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
http://#cgi.SERVER_NAME#/#getSiteID()#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL(true,"approvedcommentID=#getCommentID()#"))#

Delete
http://#cgi.SERVER_NAME#/#getSiteID()#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL(true,"deletecommentID=#getCommentID()#"))#

View 
http://#cgi.SERVER_NAME#/#getSiteID()#/index.cfm/#variables.utility.createRedirectID(arguments.contentRenderer.getCurrentURL())#
</cfoutput></cfsavecontent>

<cfelse>

<cfset notifyText=arguments.script />

</cfif>

<cfset email=application.serviceFactory.getBean('mailer') />
<cfset email.sendText(notifyText,
						variables.settingsManager.getSite(getSiteID()).getContact(),
						getName(),
						'New Comment',
						getSiteID()) />
</cffunction>

</cfcomponent>