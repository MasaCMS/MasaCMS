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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.bean.bean" entityName="comment" table="tcontentcomments" orderby="entered asc" output="false" hint="This provides content comment functionality">
<cfproperty name="commentID" fieldType="id" type="string" default="">
<cfproperty name="content" fieldtype="many-to-one" fkcolumn="contentid" cfc="content">
<cfproperty name="kids" fieldtype="one-to-many" cfc="comment" nested=true orderby="created asc" cascade="delete">
<cfproperty name="parent" fieldtype="many-to-one" cfc="comment" fkcolumn="parentid">
<cfproperty name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID">
<cfproperty name="comments" type="string" required="true" default="">
<cfproperty name="url" type="string" default="">
<cfproperty name="name" type="string" default="">
<cfproperty name="email" required="true" validate="email" default="">
<cfproperty name="entered" type="date" default="">
<cfproperty name="subscribe" type="numeric" default="0">
<cfproperty name="isApproved" type="numeric" default="0">
<cfproperty name="userID" type="string" default="">
<cfproperty name="path" type="string" default="">
<cfproperty name="remoteID" type="string" default="">
<cfproperty name="isNew" type="numeric" default="1" persistent="false">
<cfproperty name="isSpam" type="numeric" default="0">
<cfproperty name="isDeleted" type="numeric" default="0">
<cfproperty name="flagCount" type="numeric" default="0">
<cfscript>
variables.primaryKey = 'commentid';
variables.entityName = 'comment';

function init() output=false {
	super.init(argumentCollection=arguments);
	variables.instance.commentID="";
	variables.instance.contentID="";
	variables.instance.parentID="";
	variables.instance.siteID="";
	variables.instance.comments="";
	variables.instance.url="";
	variables.instance.name="";
	variables.instance.email="";
	variables.instance.entered=now();
	variables.instance.subscribe=0;
	variables.instance.isApproved=0;
	variables.instance.isSpam=0;
	variables.instance.isDeleted=0;
	variables.instance.userID="";
	variables.instance.path="";
	variables.instance.kids=0;
	variables.instance.remoteID="";
	variables.instance.isNew=1;
	variables.instance.isSpam=0;
	variables.instance.isDeleted=0;
	variables.instance.flagCount=0;
	return this;
}

function setContentManager(contentManager) {
	variables.contentManager=arguments.contentManager;
	return this;
}

function setSettingsManager(settingsManager) {
	variables.settingsManager=arguments.settingsManager;
	return this;
}

function setTrashManager(trashManager) {
	variables.trashManager=arguments.trashManager;
	return this;
}

function setContentDAO(contentDAO) {
	variables.contentDAO=arguments.contentDAO;
	return this;
}

function setMailer(mailer) {
	variables.mailer=arguments.mailer;
	return this;
}

function setConfigBean(configBean) {
	variables.configBean=arguments.configBean;
	return this;
}

function getCommentID() output=false {
	if ( !len(variables.instance.commentID) ) {
		variables.instance.commentID=createUUID();
	}
	return variables.instance.commentID;
}

function setURL(String url) output=false {
	variables.instance.url = trim(arguments.url);
	if ( len(variables.instance.url) and
			not listFindNoCase("http:,https:",listFirst(variables.instance.url,"//")) ) {
		variables.instance.url = "#variables.settingsManager.getSite(variables.instance.siteID).getScheme()#://" & variables.instance.url;
	}
	return this;
}

function setSubscribe(subscribe) output=false {
	if ( isNumeric(arguments.subscribe) ) {
		variables.instance.subscribe = arguments.subscribe;
	}
	return this;
}

function setIsApproved(isApproved) output=false {
	if ( isNumeric(arguments.isApproved) ) {
		variables.instance.isApproved = arguments.isApproved;
	}
	return this;
}

function setIsSpam(isSpam) output=false {
	if ( isNumeric(arguments.isSpam) ) {
		variables.instance.isSpam = arguments.isSpam;
	}
	return this;
}

function setIsDeleted(isDeleted) output=false {
	if ( isNumeric(arguments.isDeleted) ) {
		variables.instance.isDeleted = arguments.isDeleted;
	}
	return this;
}

function setFlagCount(flagCount) output=false {
	if ( isNumeric(arguments.flagCount) ) {
		variables.instance.flagCount = arguments.flagCount;
	}
	return this;
}

function setEntered(entered) output=false {
	if ( isDate(arguments.entered) ) {
		variables.instance.entered = parseDateArg(arguments.entered);
	}
	return this;
}

function setKids(kids) output=false {
	if ( isNumeric(arguments.kids) ) {
		variables.instance.kids = arguments.kids;
	}
	return this;
}

function load(commentID, remoteID) output=false {
	loadBy(argumentCollection=arguments);
	return this;
}

function loadBy(commentID, remoteID) output=false {
	var rs=getQuery(argumentCollection=arguments);
	if ( rs.recordcount ) {
		variables.instance.isNew=0;
		set(rs);
	}
	return this;
}


function getCrumbIterator(required sort="asc") output=false {
	var rs=getCrumbQuery(arguments.sort);
	var it=getBean("contentCommentIterator").init();
	it.setQuery(rs);
	return it;
}

function hasParent() output=false {
	return listLen(variables.instance.path) > 1;
}

struct function getAllValues() output=false {
	return variables.instance;
}

function setAllValues(instance) output=false {
	variables.instance=arguments.instance;
	return this;
}

function clone() output=false {
	return getBean("comment").setAllValues(structCopy(getAllValues()));
}

function getPrimaryKey() output=false {
	return "commentID";
}

function setCommenter() output=false {
	var pluginEvent=createObject("component","mura.event");
	var eventArgs=structNew();
	var commenter=getBean('commenter');
	eventArgs.siteID=variables.instance.siteID;
	eventArgs.commentBean=this;
	eventArgs.commenterBean=commenter;
	structAppend(eventArgs, arguments);
	pluginEvent.init(eventArgs);
	pluginEvent.getHandler("standardSetCommenter").handle(pluginEvent);
}

function getCommenter() output=false {
	var pluginEvent=createObject("component","mura.event");
	var eventArgs=structNew();
	var commenter=getBean('commenter');
	eventArgs.siteID=variables.instance.siteID;
	eventArgs.commentBean=this;
	eventArgs.commenterBean=commenter;
	structAppend(eventArgs, arguments);
	pluginEvent.init(eventArgs);
	pluginEvent.getHandler("standardGetCommenter").handle(pluginEvent);
	return commenter;
}
</cfscript>

<cffunction name="getQuery"  output="false">
	<cfargument name="commentID">
	<cfargument name="remoteID">
	<cfset var rs=""/>

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rs')#">
	select c.contentid,c.commentid,c.parentid,c.name,c.email,c.url,c.comments,c.entered,c.siteid,c.isApproved,c.isDeleted,c.isSpam,c.subscribe, c.userID, c.path, c.remoteID, k.kids, c.flagcount, f.fileid, f.fileExt
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

<cffunction name="delete" access="remote" output="false">
	<cfif allowModuleAccess()>
		<cfset var pluginManager=getPluginManager()>
		<cfset var pluginEvent=createObject("component","mura.event")>
		<cfset var eventArgs=structNew()>

		<cfset eventArgs.siteID=variables.instance.siteID>
		<cfset eventArgs.commentBean=this>
	  <cfset eventArgs.bean=this>
		<cfset pluginEvent.init(eventArgs)>

		<cfset pluginManager.announceEvent(eventToAnnounce="onBeforeCommentDelete",currentEventObject=pluginEvent,objectid=getValue("commentid"))>

		<cfquery>
			update tcontentcomments set isDeleted = 1 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
		</cfquery>

		<cfset pluginManager.announceEvent(eventToAnnounce="onAfterCommentDelete",currentEventObject=pluginEvent,objectid=getValue("commentid"))>

		<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
	</cfif>
</cffunction>

<cffunction name="undelete" access="remote" output="false">
	<cfif allowModuleAccess()>
		<cfset var pluginManager=getPluginManager()>
		<cfset var currentEventObject=createObject("component","mura.event")>
		<cfset var eventArgs=structNew()>

		<cfset eventArgs.siteID=variables.instance.siteID>
		<cfset eventArgs.commentBean=this>
	  <cfset eventArgs.bean=this>
		<cfset currentEventObject.init(eventArgs)>

		<cfset pluginManager.announceEvent(eventToAnnounce="onBeforeCommentUndelete",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

		<cfquery>
			update tcontentcomments set isDeleted = 0 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
		</cfquery>

		<cfset pluginManager.announceEvent(eventToAnnounce="onAfterCommentUndelete",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

		<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
	</cfif>
</cffunction>

<cffunction name="flag" access="remote" output="false">
	<cfset var pluginManager=getPluginManager()>
	<cfset var currentEventObject=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>

	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
  <cfset eventArgs.bean=this>
	<cfset currentEventObject.init(eventArgs)>

	<cfset pluginManager.announceEvent(eventToAnnounce="onBeforeCommentFlag",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

	<cfquery>
		update tcontentcomments set flagCount = flagCount + 1 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
	</cfquery>

	<cfset pluginManager.announceEvent(eventToAnnounce="onAfterCommentFlag",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

	<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
</cffunction>

<cffunction name="markAsSpam" access="remote" output="false">
	<cfif allowModuleAccess()>
		<cfset var pluginManager=getPluginManager()>
		<cfset var currentEventObject=createObject("component","mura.event")>
		<cfset var eventArgs=structNew()>

		<cfset eventArgs.siteID=variables.instance.siteID>
		<cfset eventArgs.commentBean=this>
	  <cfset eventArgs.bean=this>
		<cfset currentEventObject.init(eventArgs)>

		<cfset pluginManager.announceEvent(eventToAnnounce="onBeforeCommentMarkAsSpam",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

		<cfquery>
			update tcontentcomments set	isSpam = 1 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
		</cfquery>

		<cfset pluginManager.announceEvent(eventToAnnounce="onAfterCommentMarkAsSpam",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

		<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
	</cfif>
</cffunction>

<cffunction name="unMarkAsSpam" access="remote" output="false">
	<cfif allowModuleAccess()>
		<cfset var pluginManager=getPluginManager()>
		<cfset var currentEventObject=createObject("component","mura.event")>
		<cfset var eventArgs=structNew()>

		<cfset eventArgs.siteID=variables.instance.siteID>
		<cfset eventArgs.commentBean=this>
	  <cfset eventArgs.bean=this>
		<cfset currentEventObject.init(eventArgs)>

		<cfset pluginManager.announceEvent(eventToAnnounce="onBeforeCommentUnMarkAsSpam",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

		<cfquery>
			update tcontentcomments set isSpam = 0 where commentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">
		</cfquery>

		<cfset pluginManager.announceEvent(eventToAnnounce="onAfterCommentUnMarkAsSpam",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

		<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />
	</cfif>
</cffunction>

<cffunction name="save" output="false">
	<cfargument name="script" required="true" default="" hint="I'm the script that is sent to the subscribers.">
	<cfargument name="subject" required="true" default="" hint="I'm the subject that is sent to the subscribers.">
	<cfargument name="notify" required="true" default="false" hint="I tell whether to notify subscribers.">
	<cfset var rs=""/>
	<cfset var rslist=""/>
	<cfset var path=""/>
	<cfset var pluginManager=getPluginManager()>
	<cfset var currentEventObject=createObject("component","mura.event")>
	<cfset var eventArgs=structNew()>

	<cfset eventArgs.siteID=variables.instance.siteID>
	<cfset eventArgs.commentBean=this>
  <cfset eventArgs.bean=this>
	<cfset structAppend(eventArgs, arguments)>

	<cfset currentEventObject.init(eventArgs)>

	<cfif allowModuleAccess()>
		<cfif not exists()>
			<cfset variables.instance.isapproved=1>
		</cfif>
	<cfelse>
		<cfset variables.instance.isapproved=getBean('settingsManager').getSite(variables.instance.siteid).getCommentApprovalDefault()>
	</cfif>

	<cfif len(variables.instance.parentID)>
		<cfset path=variables.contentManager.getCommentBean().setCommentID(variables.instance.parentID).load().getPath()>
	</cfif>

	<cfset path=listAppend(path, getCommentID())>

	<cfset validate()>

	<cfset pluginManager.announceEvent(eventToAnnounce="onBeforeCommentSave",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

	<cfif structIsEmpty(getErrors())>

		<cfset setCommenter()>

		<cfif getQuery().recordcount>

			<cfset pluginManager.announceEvent(eventToAnnounce="onBeforeCommentUpdate",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

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
				remoteID=<cfif len(variables.instance.remoteID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.remoteID#"/><cfelse>null</cfif>,
				isSpam=<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.isSpam#">,
				isDeleted=<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.isDeleted#">,
				flagCount=<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.flagCount#">
			where commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getCommentID()#">

			</cfquery>

			<cfset pluginManager.announceEvent(eventToAnnounce="onAfterCommentUpdate",currentEventObject=currentEventObject,objectid=getValue("commentid"))>
		<cfelse>

			<cfset pluginManager.announceEvent(eventToAnnounce="onBeforeCommentCreate",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

			<cfquery>
				insert into tcontentcomments (contentid,commentid,parentid,name,email,url,comments,entered,siteid,isApproved,subscribe,userID,path, ip, remoteID, isspam, isdeleted,flagCount)
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
				<cfif len(variables.instance.remoteID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.remoteID#"/><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.isSpam#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.isDeleted#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.flagCount#">
				)
				</cfquery>

			<cfset variables.instance.isNew=0/>

			<cfset pluginManager.announceEvent(eventToAnnounce="onAfterCommentCreate",currentEventObject=currentEventObject,objectid=getValue("commentid"))>
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

		<cfset pluginManager.announceEvent(eventToAnnounce="onAfterCommentSave",currentEventObject=currentEventObject,objectid=getValue("commentid"))>

		<cfif variables.instance.isApproved>
			<cfset saveSubscription()>
			<cfif isBoolean(currentEventObject.getValue("notify")) and currentEventObject.getValue("notify")>
				<cfset notifySubscribers(arguments.script,arguments.subject)>
			</cfif>
		</cfif>

		<cfset variables.contentManager.setCommentStat(variables.instance.contentID,variables.instance.siteID) />

	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="saveSubscription" output="false">
	<cfquery>
			update tcontentcomments set subscribe=<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.instance.subscribe#">
			where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.contentID#">
			and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.siteID#">
			and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.instance.email#">
	</cfquery>
	<cfreturn this>
</cffunction>

<cffunction name="sendNotification"  output="false">
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

<cffunction name="notifySubscribers" output="false">
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

<cffunction name="getKidsQuery" output="false">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<!---<cfif getKids()>--->
		<cfreturn variables.contentManager.readComments(variables.instance.contentID, variables.instance.siteID, arguments.isEditor, arguments.sortOrder, getCommentID() ) />
	<!---
	<cfelse>
		<cfreturn queryNew("contentid,commentid,parentid,name,email,url,comments,entered,siteid,isApproved,subscribe,userID,path,kids,fileid,fileExt")>
	</cfif>
	--->
</cffunction>

<cffunction name="getKidsIterator" output="false">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	<cfset var q=getKidsQuery(arguments.isEditor, arguments.sortOrder)>
	<cfset var it=getBean("contentCommentIterator").init()>
	<cfset it.setQuery(q)>
	<cfreturn it />
</cffunction>

<cffunction name="getParent" output="false">
	<cfset var commentBean=getBean("comment") />
	<cfif len(variables.instance.parentID)>
		<cfset commentBean.setCommentID(variables.instance.parentID) />
		<cfset commentBean.load() />
		<cfreturn commentBean>
	<cfelse>
		<cfreturn commentBean>
	</cfif>
</cffunction>

<cffunction name="getCrumbQuery" output="false">
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

<cffunction name="allowQueryParams" output="false">
	<cfargument name="params">
	<cfargument name="m">
	<cfparam name="arguments.params.isspam" default=0>
	<cfparam name="arguments.params.isdeleted" default=0>
	<cfparam name="arguments.param.isapproved" default="0">
	<cfif not allowModuleAccess()>
		<cfset arguments.params.fields="comments,links,entered,isspam,flagcount,parentid,name,isapproved,kids,isdeleted,userid,subscribe,isnew,contentid,path,siteid,id,remoteid,contenthistid">
		<cfset params.isspam=0>
		<cfset params.isdeleted=0>
		<cfset param.isapproved=1><!--- this get explicitly set in the save method --->
	<cfelse>
		<cfset arguments.params.fields="comments,email,links,entered,isspam,flagcount,parentid,name,isapproved,kids,isdeleted,userid,subscribe,isnew,contentid,path,siteid,id,remoteid,contenthistid">
	</cfif>
	<cfreturn true>
</cffunction>

<cffunction name="allowModuleAccess" output="false">
	<cfset var sessionData=getSession()>
	<cfreturn not request.muraapirequest or  (
			(listFind(sessionData.mura.memberships,'Admin;#getBean('settingsManager').getSite(get('siteid')).getPrivateUserPoolID()#;0')
			or listFind(sessionData.mura.memberships,'S2'))
			or (
				getBean('permUtility').getModulePerm('00000000000000000000000000000000015',get('siteid'))
				and getBean('permUtility').getModulePerm('00000000000000000000000000000000000',get('siteid'))
			)
		)>
</cffunction>

<cffunction name="allowSave" output="false">
	<cfif allowModuleAccess()>
		<cfreturn true>
	<cfelse>
		<cfreturn not exists()>
	</cfif>
</cffunction>

</cfcomponent>
