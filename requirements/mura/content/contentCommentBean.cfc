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
<cfcomponent extends="mura.bean.bean" entityName="comment" table="tcontentcomments" output="false">

<cfproperty name="commentID" fieldType="id" type="string" default="" />
<cfproperty name="content" fieldtype="many-to-one" fkcolumn="contentid" cfc="content"/>
<cfproperty name="kids" fieldtype="one-to-many" cfc="comment" nested=true orderby="created asc" cascade="delete"/>
<cfproperty name="parent" fieldtype="many-to-one" cfc="comment" fkcolumn="parentid"/>
<cfproperty name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID" />
<cfproperty name="comments" type="string" default="" />
<cfproperty name="url" type="string" default=""  />
<cfproperty name="name" type="string" default=""  />
<cfproperty name="email" type="string" default="" />
<cfproperty name="entered" type="date" default="" />
<cfproperty name="subscribe" type="numeric" default="0"  />
<cfproperty name="isApproved" type="numeric" default="0" />
<cfproperty name="userID" type="string" default="" />
<cfproperty name="path" type="string" default="" />
<cfproperty name="remoteID" type="string" default=""/>
<cfproperty name="isNew" type="numeric" default="1" />

<cfset variables.primaryKey = 'commentid'>
<cfset variables.entityName = 'comment'>

<cffunction name="init" returntype="any" output="false" access="public">
	
	<cfset super.init(argumentCollection=arguments)>

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
	<cfset variables.instance.isSpam=0/>
	<cfset variables.instance.isDeleted=0/>
	<cfset variables.instance.userID=""/>
	<cfset variables.instance.path=""/>
	<cfset variables.instance.kids=0/>
	<cfset variables.instance.remoteID=""/>
	<cfset variables.instance.isNew=1/>

	<cfreturn this />
</cffunction>

<cffunction name="setContentManager">
	<cfargument name="contentManager">
	<cfset variables.contentManager=arguments.contentManager>
	<cfreturn this>
</cffunction>

<cffunction name="setSettingsManager">
	<cfargument name="settingsManager">
	<cfset variables.settingsManager=arguments.settingsManager>
	<cfreturn this>
</cffunction>

<cffunction name="setTrashManager">
	<cfargument name="trashManager">
	<cfset variables.trashManager=arguments.trashManager>
	<cfreturn this>
</cffunction>

<cffunction name="setContentDAO">
	<cfargument name="contentDAO">
	<cfset variables.contentDAO=arguments.contentDAO>
	<cfreturn this>
</cffunction>

<cffunction name="setMailer">
	<cfargument name="mailer">
	<cfset variables.mailer=arguments.mailer>
	<cfreturn this>
</cffunction>

<cffunction name="setConfigBean">
	<cfargument name="configBean">
	<cfset variables.configBean=arguments.configBean>
	<cfreturn this>
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
		<cfset variables.instance.url = "#variables.settingsManager.getSite(variables.instance.siteID).getScheme()#://" & variables.instance.url />
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
	<cfset variables.instance.entered = parseDateArg(arguments.entered) />
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

<cffunction name="load" access="public" output="false">
	<cfargument name="commentID">
	<cfargument name="remoteID">
	<cfset loadBy(argumentCollection=arguments)>
	<cfreturn this>
</cffunction>

<cffunction name="loadBy" access="public" output="false">
	<cfargument name="commentID">
	<cfargument name="remoteID">
	<cfset var rs=getQuery(argumentCollection=arguments)>
	<cfif rs.recordcount>
		<cfset variables.instance.isNew=0/>
		<cfset set(rs) />
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getQuery"  access="public" output="false" returntype="query">
	<cfargument name="commentID">
	<cfargument name="remoteID">	
	<cfset var rs=""/>
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select c.contentid,c.commentid,c.parentid,c.name,c.email,c.url,c.comments,c.entered,c.siteid,c.isApproved,c.isDeleted,c.isSpam,c.subscribe, c.userID, c.path, c.remoteID, k.kids, f.fileid, f.fileExt 
	from tcontentcomments c left join (select count(*) kids, parentID 
										from tcontentcomments where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#"> 
										group by parentID
										) k
										on c.commentID = k.parentID
	left join tusers u on c.userid=u.userid
	left join tfiles f on u.photofileid=f.fileid 
	where 
	<cfif isdefined("arguments.commentID")>
		c.commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.commentID#">
	<cfelseif isdefined("arguments.remoteID")>
		c.remoteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.remoteID#">
	<cfelse>
		c.commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfif>
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
	
	<cfset pluginManager.announceEvent("onBeforeCommentDelete",pluginEvent)>
	
	<cfquery>
		update tcontentcomments set isDeleted = 1 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>
	
	<cfset pluginManager.announceEvent("onAfterCommentDelete",pluginEvent)>
	
	<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
</cffunction>

<cffunction name="undelete" access="public">
	<cfset var pluginManager=getPluginManager()>
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	
	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
	<cfset pluginEvent.init(eventArgs)>
	
	<cfset pluginManager.announceEvent("onBeforeCommentUndelete",pluginEvent)>
	
	<cfquery>
		update tcontentcomments set isDeleted = 0 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>
	
	<cfset pluginManager.announceEvent("onAfterCommentUndelete",pluginEvent)>
	
	<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
</cffunction>

<cffunction name="flag" access="public">
	<cfset var pluginManager=getPluginManager()>
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	
	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
	<cfset pluginEvent.init(eventArgs)>
	
	<cfset pluginManager.announceEvent("onBeforeCommentFlag",pluginEvent)>
	
	<cfquery>
		update tcontentcomments set flagCount = flagCount + 1 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>
	
	<cfset pluginManager.announceEvent("onAfterCommentFlag",pluginEvent)>
	
	<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
</cffunction>

<cffunction name="markAsSpam" access="public">
	<cfset var pluginManager=getPluginManager()>
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	
	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
	<cfset pluginEvent.init(eventArgs)>
	
	<cfset pluginManager.announceEvent("onBeforeCommentMarkAsSpam",pluginEvent)>
	
	<cfquery>
		update tcontentcomments set	isSpam = 1 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>
	
	<cfset pluginManager.announceEvent("onAfterCommentMarkAsSpam",pluginEvent)>
	
	<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
</cffunction>

<cffunction name="unMarkAsSpam" access="public">
	<cfset var pluginManager=getPluginManager()>
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	
	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
	<cfset pluginEvent.init(eventArgs)>
	
	<cfset pluginManager.announceEvent("onBeforeCommentUnMarkAsSpam",pluginEvent)>
	
	<cfquery>
		update tcontentcomments set isSpam = 0 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>
	
	<cfset pluginManager.announceEvent("onAfterCommentUnMarkAsSpam",pluginEvent)>
	
	<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
</cffunction>

<cffunction name="save" access="public" output="false">
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

	<cfset validate()>

	<cfif structIsEmpty(getErrors())>	
		<cfset setCommenter()>
		
		<cfset pluginManager.announceEvent("onBeforeCommentSave",pluginEvent)>
		
		<cfif getQuery().recordcount>
			
			<cfset pluginManager.announceEvent("onBeforeCommentUpdate",pluginEvent)>
			
			<cfquery>
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
				path=<cfqueryparam cfsqltype="cf_sql_varchar" value="#path#"/>,
				remoteID=<cfif len(variables.instance.remoteID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.remoteID#"/><cfelse>null</cfif>
			where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
			</cfquery>
			
			<cfset pluginManager.announceEvent("onAfterCommentUpdate",pluginEvent)>
		<cfelse>
		
			<cfset pluginManager.announceEvent("onBeforeCommentCreate",pluginEvent)>
			
			<cfquery>
				insert into tcontentcomments (contentid,commentid,parentid,name,email,url,comments,entered,siteid,isApproved,subscribe,userID,path, ip, remoteID)
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
				<cfif isdefined("request.remoteAddr")><cfqueryparam cfsqltype="cf_sql_varchar" value="#request.remoteAddr#"/><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#"/></cfif>,
				<cfif len(variables.instance.remoteID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.remoteID#"/><cfelse>null</cfif>
				)
				</cfquery>
			
			<cfset variables.instance.isNew=0/>
				
			<cfset pluginManager.announceEvent("onAfterCommentCreate",pluginEvent)>
			<cfset getBean('trashManager').takeOut(this)>
		</cfif>

		<cfscript>
			var obj='';

			if(arrayLen(variables.instance.addObjects)){
				for(obj in variables.instance.addObjects){	
					obj.save();
				}
			}

			if(arrayLen(variables.instance.removeObjects)){
				for(obj in variables.instance.removeObjects){	
					obj.delete();
				}
			}

			variables.instance.addObjects=[];
			variables.instance.removeObjects=[];
		</cfscript>

		<cfset pluginManager.announceEvent("onAfterCommentSave",pluginEvent)>
		
		<cfif variables.instance.isApproved>
			<cfset saveSubscription()>
			<cfif isBoolean(pluginEvent.getValue("notify")) and pluginEvent.getValue("notify")>
				<cfset notifySubscribers(arguments.script,arguments.subject)>
			</cfif>
		</cfif>
		
		<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />

	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="saveSubscription" access="public" output="false">		
	<cfquery>
			update tcontentcomments set subscribe=<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.subscribe#">
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
			and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
			and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.email#">
	</cfquery>
	<cfreturn this>
</cffunction>

<cffunction name="sendNotification"  access="public" output="false">
	<cfargument name="script" required="true" default="">
	<cfset var rsContent="">
	<cfset var notifyText="">
	<cfset var email="">
	<cfset var contactEmail="">
	<cfset var serverpath="">
	<cfset var configBean=variables.configBean>
	<cfset var settingsManager=variables.settingsManager>
	<cfset var utility=getBean("utility")>
	<cfset var contentBean=getBean('content').loadBy(contentid=variables.instance.contentID)>

	<cfif len(settingsManager.getSite(variables.instance.siteID).getContactEmail())>
		<cfset contactEmail=settingsManager.getSite(variables.instance.siteID).getContactEmail()>
	<cfelse>
		<cfset contactEmail=settingsManager.getSite(variables.instance.siteID).getContact()>
	</cfif>
	<cfif not len(arguments.script)>
		<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContent')#">
			select title from tcontent 
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
			and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
			and active=1
		</cfquery>
		<cfset serverpath = "#settingsManager.getSite(variables.instance.siteID).getScheme()#://#listFirst(cgi.http_host,':')##configBean.getServerPort()##configBean.getContext()#/">
		<cfif configBean.getSiteIDInURLS()>
			<cfset serverpath &= '#variables.instance.siteID#/'>
		</cfif>
		<cfif configBean.getIndexFileInURLS()>
			<cfset serverpath &= 'index.cfm/'>
		</cfif>
<cfsavecontent variable="notifyText"><cfoutput>
A comment has been posted to "#rscontent.title#" by #variables.instance.name# (#variables.instance.email#).

URL:
#variables.instance.url#

COMMENT:
#variables.instance.comments#

Approve
#serverpath##utility.createRedirectID(contentBean.getURL(complete=true,querystring='approvedcommentID=#getCommentID()#'))#

Delete
#serverpath##utility.createRedirectID(contentBean.getURL(complete=true,querystring='deletecommentID=#getCommentID()#'))#

View
#serverpath##utility.createRedirectID(contentBean.getURL(complete=true))#
</cfoutput></cfsavecontent>
	<cfelse>
		<cfset notifyText=arguments.script />
	</cfif>
	<cfset email=variables.mailer />
	<cfset email.sendText(notifyText,contactEmail,variables.instance.name,'New Comment',variables.instance.siteID) />
	<cfreturn this>
</cffunction>

<cffunction name="notifySubscribers" access="public" output="false">
	<cfargument name="script" required="true" default="">
	<cfargument name="subject" required="true" default="">
	<cfargument name="notifyAdmin" required="true" default="true">
	<cfset var site=variables.settingsManager.getSite(variables.instance.siteID)>
	<cfset var rsContent="">
	<cfset var notifyText="">
	<cfset var notifysubject=arguments.subject>
	<cfset var email=variables.mailer>
	<cfset var rsSubscribers=variables.contentDAO.getCommentSubscribers(variables.instance.contentID,variables.instance.siteID)>
	<cfset var contentBean=getBean('content').loadBy(contentid=variables.instance.contentID)>
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsContent')#">
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
#contentBean.getURL(complete=true)#

To Unsubscribe Click Here:
</cfoutput></cfsavecontent>
	<cfelse>
		<cfset notifyText=arguments.script />
	</cfif>
	<cfloop query="rsSubscribers">
		<cfset email.sendText(notifyText & contentBean.getURL(complete=true,querystring="commentUnsubscribe=#URLEncodedFormat(rsSubscribers.email)#"),
								rsSubscribers.email,
								site.getSite(),
								notifySubject,
								variables.instance.siteID)>
	</cfloop>
	<cfif arguments.notifyAdmin and len(site.getContactEmail())>
		<cfset email.sendText(notifyText & contentBean.getURL(complete=true,querystring="commentUnsubscribe=#URLEncodedFormat(rsSubscribers.email)#"),
								site.getContactEmail(),
								site.getSite(),
								notifySubject,
								variables.instance.siteID)>
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
	<cfset var commentBean=getBean("comment") />
	<cfif len(variables.instance.parentID)>
		<cfset commentBean.setCommentID(variables.instance.parentID) />
		<cfset commentBean.load() />
		<cfreturn commentBean>
	<cfelse>
		<cfthrow message="Parent comment does not exist.">
	</cfif>
</cffunction>

<cffunction name="getCrumbQuery" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfset var rsCommentCrumbData="">
	
	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsCommentCrumbData')#">
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

	<cfreturn rsCommentCrumbData>
</cffunction>

<cffunction name="getCrumbIterator" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfset var rs=getCrumbQuery(arguments.sort)>
	<cfset var it=getBean("contentCommentIterator").init()>
	<cfset it.setQuery(rs)>
	<cfreturn it>
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
	<cfreturn getBean("comment").setAllValues(structCopy(getAllValues()))>
</cffunction>

<cffunction name="getPrimaryKey" output="false">
	<cfreturn "commentID">
</cffunction>

<cffunction name="setCommenter" output="false">
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	<cfset var commenter=getBean('commenter')>

	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
	<cfset eventArgs.commenterBean=commenter>
	<cfset structAppend(eventArgs, arguments)>

	<cfset pluginEvent.init(eventArgs)>
	<cfset pluginEvent.getHandler("standardSetCommenter").handle(pluginEvent)>
</cffunction>

<cffunction name="getCommenter" output="false">
	<cfset var pluginEvent=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>
	<cfset var commenter=getBean('commenter')>

	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
	<cfset eventArgs.commenterBean=commenter>
	<cfset structAppend(eventArgs, arguments)>

	<cfset pluginEvent.init(eventArgs)>
	<cfset pluginEvent.getHandler("standardGetCommenter").handle(pluginEvent)>

	<cfreturn commenter>
</cffunction>

</cfcomponent>