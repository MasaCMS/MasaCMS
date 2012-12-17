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
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="contentDAO" type="any" required="yes"/>
		<cfargument name="configBean" type="any" required="yes"/>
		<cfargument name="permUtility" type="any" required="yes"/>
		<cfargument name="settingsManager" type="any" required="yes"/>
		<cfargument name="fileManager" type="any" required="yes"/>
		<cfargument name="contentRenderer" type="any" required="yes"/>
		
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.contentDAO=arguments.contentDAO />
		<cfset variables.permUtility=arguments.permUtility />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.fileManager=arguments.fileManager />
		<cfset variables.contentRenderer=arguments.contentRenderer />
		<cfset variables.filedelim=variables.configBean.getFileDelim() />
		
<cfreturn this />
</cffunction>

<cffunction name="setMailer" returntype="any" access="public" output="false">
<cfargument name="mailer"  required="true">

	<cfset variables.mailer=arguments.mailer />

</cffunction>

<cffunction name="getNotify" returntype="query" access="public" output="false">
<cfargument name="crumbData" type="array" />
	<cfset var rs = "">
	<cfset var rsprenotify = "">
	<cfset var permStruct=variables.permUtility.getnodePermGroups(arguments.crumbdata)>
	<cfset var authorLen=listlen(permStruct.authorList)>
	<cfset var authorIdx=1>
	<cfset var A=""/>
	<cfset var E=""/>
	<cfset var rsAdmin = "" />
	
	<cfquery name="rsAdmin" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT tusers.UserID
	from tusers
	WHERE perm=1 and 
	type=1 and 
	siteid='#variables.settingsManager.getSite(arguments.crumbdata[1].siteid).getPrivateUserPoolID()#'
	and groupname='Admin'
	</cfquery>
	
	<cfquery name="rsprenotify" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.Email, 'Editor' AS Type
	FROM tusers INNER JOIN tusersmemb ON tusers.UserID = tusersmemb.UserID
	WHERE tusers.Email Is Not Null 
	AND 
	(tusersmemb.GroupID In (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAdmin.userID#"/><cfloop list="#permStruct.editorList#" index="E">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#E#"/></cfloop>)
	<cfif listFind(session.mura.memberships,'S2')>or tusers.s2=1</cfif>)
	
	<cfif authorLen>
	union
	
	SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.Email, 'Author' AS Type
	FROM tusers INNER JOIN tusersmemb ON tusers.UserID = tusersmemb.UserID
	WHERE tusers.Email Is Not Null 
	and siteid='#variables.settingsManager.getSite(arguments.crumbdata[1].siteid).getPrivateUserPoolID()#'
	AND 
	tusersmemb.GroupID In (<cfloop list="#permStruct.authorList#" index="A"><cfqueryparam cfsqltype="cf_sql_varchar" value="#A#"/><cfif authorIdx lt authorLen>,<cfset authorIdx=authorIdx+1></cfif></cfloop>)
	
	and tusers.userID not in (
								SELECT tusers.UserID
								FROM tusers INNER JOIN tusersmemb ON tusers.UserID = tusersmemb.UserID
								WHERE tusers.Email Is Not Null 
								AND 
								(tusersmemb.GroupID In (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAdmin.userID#"/><cfloop list="#permStruct.editorList#" index="E">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#E#"/></cfloop>)
								<cfif listFind(session.mura.memberships,'S2')>or tusers.s2=1</cfif>)
							)
	
	</cfif>
	
	</cfquery>
	
	<cfquery name="rs" dbtype="query">
	select UserID, Fname, Lname, Email, Type from rsprenotify 
	group by UserID, Fname, Lname, Email, Type
	order by lname, fname
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getMailingLists" returntype="query" access="public" output="false">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rs = "">
		
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	Select mlid, name from tmailinglist  where 
	siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and isPublic=1 order by name 
	</cfquery>
		
		<cfreturn rs />
</cffunction>

<cffunction name="getTemplates" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">
	<cfargument name="type" type="string" required="true" default="">
	<cfreturn variables.settingsManager.getSite(arguments.siteID).getTemplates(arguments.type) />
</cffunction>

<cffunction name="getRestrictGroups" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select groupname, userid,isPublic from tusers where type=1 and 
	(
	(isPublic=1  and siteid='#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#') 
	or
	(isPublic=0  and siteid='#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#')
	)
	and groupname <> 'Admin'
	order by isPublic desc, groupname
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="doesFileExist" returntype="boolean" access="public" output="false">
		<cfargument name="siteid" type="string" required="true">
		<cfargument name="filename" type="string" required="true">
		<cfargument name="contentid" type="string" required="true">
		<cfset var rs = "">
		
		<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			Select contentid from tcontent  where 
			siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> 
			and filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#"/> and active=1 and type in ('Folder','Page','Calendar','Gallery','File','Link')
			and contentid != <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentid#"/>
		</cfquery>
		
		<cfif rs.recordcount>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>	
</cffunction>

<cffunction name="doesLoadKeyExist" returntype="boolean" access="public" output="false">
		<cfargument name="contentBean">
		<cfargument name="field">
		<cfargument name="fieldValue">
		<cfset var rs = "">
		
		<cfquery name="rs" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			Select contentid from tcontent  where 
			siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSiteID()#"/> 

			<cfswitch expression="#arguments.field#">
			<cfcase value="filename">
				and filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldValue#"/> 
				and type in ('Folder','Page','Calendar','Gallery','Link','File')
			</cfcase>
			<cfcase value="title">
				and title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldValue#"/> 
				and type in ('Folder','Page','Calendar','Gallery','File','Link','Component','Form')
			</cfcase>
			<cfcase value="urltitle">
				and urltitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldValue#"/> 
				and type in ('Folder','Page','Calendar','Gallery','File','Link')
			</cfcase>
			<cfcase value="remoteID">
				and remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldValue#"/> 
				and type in ('Folder','Page','Calendar','Gallery','File','Link','Component','Form')
			</cfcase>
			</cfswitch>
			
			and active=1 
			and contentID != <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#"/> 
		</cfquery>
	
		<cfif rs.recordcount>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>	
</cffunction>

<cffunction name="deleteFile" returntype="void" access="public" output="false">
<cfargument name="contentBean" type="any"/>
<cfset var file= replacelist(contentBean.getfilename(),"/","#variables.filedelim#") />
<cfset var tempfile= ""/>
<cfset var pass = 0 />
<cfset var oldlen="">
<cfset var trimer="">
<cfset var newlen="">
<cfset var newtrunk="">
<cfset var trimLen = 0 />
<cfset var newFile = "" />
<cfset var rsRelated = "" />
<cfset var rsParent = "" />

<cfif arguments.contentBean.gettype() eq 'File'>
<cftry>
		<cflock name="#arguments.contentBean.getfilename()##application.instanceID#" type="exclusive" timeout="500">
		<cfset variables.fileManager.deleteAll(arguments.contentBean.getcontentID(),arguments.contentBean.getFileID()) />
		</cflock>
	<cfcatch></cfcatch>
	</cftry>
<cfelseif arguments.contentBean.gettype() eq 'Page' or arguments.contentBean.gettype() eq 'Calendar' or arguments.contentBean.gettype() eq 'Folder' or arguments.contentBean.gettype() eq 'Gallery'>

		<cftry>

			<cfquery name="rsRelated" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select contentid, filename from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSiteID()#"> 
			and filename like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getfilename()#/%"/>
			and active=1 and type in ('Page','Calendar','Folder','Gallery')
			</cfquery>
			
			
			<cfquery name="rsParent" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select filename from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteID()#"/>
			and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getparentID()#"/>
			and active=1 and type in ('Page','Calendar','Folder','Gallery')
			</cfquery>

				
				<cfloop query="rsRelated">
					<cfdump var="#rsrelated.filename#" label="rsrelated">
					 <cfif listlen(rsrelated.filename,"/") eq  (listlen(arguments.contentBean.getfilename(),"/")+1)>
						<cfset trimLen=len(rsrelated.filename)-len("#arguments.contentBean.getfilename()#/")>
						<cfif arguments.contentBean.getparentid() eq '00000000000000000000000000000000001'>
							<cfset newfile='#right(rsrelated.filename,trimLen)#'>
						<cfelse>
							<cfset newfile='#rsparent.filename#/#right(rsrelated.filename,trimLen)#'>
						</cfif>
						
						<cfset tempfile=newfile>

								<cfset pass=0>
			       	
								<cfloop condition="#doesFileExist(arguments.contentBean.getsiteid(),tempfile,arguments.contentBean.getContentID())#">
									<cfset pass=pass+1>
									<cfset tempfile="#newfile##pass#">
								</cfloop>
								
								<cfif pass>
								<cfset newfile=tempfile>
								</cfif>
			       
					
					
					<cfset move(arguments.contentBean.getsiteid(),newfile,rsrelated.filename)>
					
					</cfif>
				</cfloop>
					
		<cfcatch></cfcatch>
	</cftry>
	
	<cfif listlen(arguments.contentBean.getfilename(),"/") gt 1>
	<cfset oldlen=len(arguments.contentBean.getfilename())>
	<cfset trimer=len(listlast(arguments.contentBean.getfilename(),"/"))+1>
	<cfset newlen=oldlen-trimer>
	<cfset newtrunk=left(arguments.contentBean.getfilename(),newlen)>
	<cfelse>
	<cfset newtrunk="">
	</cfif>
	
					
	<cfset movelink(arguments.contentBean.getsiteid(),newtrunk,arguments.contentBean.getfilename())>

</cfif>

</cffunction>

<cffunction name="move" returntype="void" output="false" access="public">
	<cfargument name="siteid" type="string" />
	<cfargument name="filename" type="string" />
	<cfargument name="oldfilename" type="string" />

	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontent set filename=replace(filename,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldfilename#/"/>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#/"/>) where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
	and filename like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldfilename#/%"/>
	and active=1 and type in ('Page','Calendar','Folder','Gallery','Link','File')
	</cfquery>
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontent set filename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#"/> where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
	and filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldfilename#"/>
	and active=1 and type in ('Page','Calendar','Folder','Gallery','Link','File')
	</cfquery>
	
</cffunction>

<cffunction name="movelink" returntype="void" output="false" access="public">
	<cfargument name="siteid" type="string" />
	<cfargument name="filename" type="string" />
	<cfargument name="oldfilename" type="string" />
	
	<cfset var newFile=""/>
	<cfset var rslist=""/>
	<cfset var newbody=""/>
	<cfset var newSummary=""/>
	<cfset var renderer=variables.settingsManager.getSite(arguments.siteID).getContentRenderer()>

	<cfif arguments.filename neq ''>
	<cfset newfile="#variables.configBean.getContext()##renderer.getURLStem(arguments.siteID,arguments.filename)#">
	<cfelse>
	<cfset newfile="#variables.configBean.getContext()##renderer.getURLStem(arguments.siteID,"")#">
	</cfif>

	<cfif arguments.oldfilename neq "/">
		<cfquery name="rslist" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select contenthistid, body from tcontent where type in ('Page','Calendar','Folder','Component','Form','Gallery')
		 and body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.oldfilename)#%"/>
		 and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		</cfquery>
	
		<cfif rslist.recordcount>
			<cfloop query="rslist">
				<cfset newbody=rereplace(rslist.body,"#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.oldfilename)#","#newfile#",'All')>
				<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				update tcontent set body=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newBody#"> where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contenthistID#"/>
				</cfquery>
			</cfloop>
		</cfif>
			
		<cfquery name="rslist" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		 select contenthistid, summary from tcontent where type in ('Page','Calendar','Folder','Component','Form','Gallery')
		 and summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.oldfilename)#%"/>
		 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		</cfquery>
		
		<cfif rslist.recordcount>
				<cfloop query="rslist">
				<cfset newSummary=rereplace(rslist.summary,"#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.oldfilename)#","#newfile#",'All')>
				<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				update tcontent set summary= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newSummary#"> where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contenthistid#">
				</cfquery>
				</cfloop>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="sendNotices" returntype="void" output="false" access="public">
	<cfargument name="data" type="struct" />
	<cfargument name="contentBean" type="any" />
	
	<cfset var rsUser = '' />
	<cfset var rsList = '' />
	<cfset var i = '' />
	<cfset var theLen=listLen(arguments.data.notify) />
	<cfset var reviewLink = ''/>
	<cfset var versionID = createUUID()/>
	<cfset var historyID = createUUID()/>
	<cfset var rsEmail = "" />
	<cfset var mailText="" >
	<cfset var crumbStr="" >
	<cfset var crumbData="" >
	<cfset var c = "" />	
	<cfset var sendVersionLink= variables.configBean.getNotifyWithVersionLink()>
	<cfset var versionLink="">
	<cfset var historyLink="">
	
	<cfif listFind("Folder,Page,Calendar,Gallery,Link,File",arguments.contentBean.getType()) and arguments.contentBean.getContentID() neq '00000000000000000000000000000000001'>
		<cfset crumbData=getBean('contentGateway').getCrumblist(arguments.contentBean.getParentID(),arguments.contentBean.getSiteID())>
		<cfset crumbStr=crumbData[arrayLen(crumbData)].menutitle />
		<cfif arrayLen(crumbData) gt 1>
			<cfloop from="#evaluate(arrayLen(crumbData)-1)#" to="1" index="c" step="-1">
				<cfset crumbStr=crumbStr & " > " & crumbData[c].menutitle>
			</cfloop>
		</cfif>
		<cfset crumbStr= crumbStr & " > " & arguments.contentBean.getMenuTitle()>
	<cfelseif arguments.contentBean.getContentID() eq '00000000000000000000000000000000001'>
		<cfset crumbStr=arguments.contentBean.getMenuTitle()>
	</cfif>
	
	<cfquery name="rsList" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select userID, email, fname, lname from tusers where userid
	in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(arguments.data.notify)#">
		<cfif theLen gte 2>
		<cfloop from="2" to="#theLen#" index="i">
		,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.data.notify,i)#">
		</cfloop>
		</cfif>
		)
	</cfquery>
	<cfif sendVersionLink>
	<cfif (structKeyExists(data,"CompactDisplay") and data.compactDisplay eq "true")
		or (structKeyExists(data,"closeCompactDisplay") and data.closeCompactDisplay eq "true")>
		<cfif variables.configBean.getSiteIDInURLS()>
			<cfset versionLink='http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/#arguments.data.siteid#/?contentID=#arguments.contentBean.getContentID()#&previewID=#arguments.contentBean.getContentHistID()#'>
		<cfelse>
			<cfset versionLink='http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/?contentID=#arguments.contentBean.getContentID()#&previewID=#arguments.contentBean.getContentHistID()#'>
		</cfif>
	<cfelse>
		<cfset versionLink='http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/admin/index.cfm?muraAction=cArch.edit&parentid=#arguments.data.parentid#&&topid=#arguments.data.topid#&siteid=#arguments.data.siteid#&contentid=#arguments.contentBean.getcontentid()#&contenthistid=#arguments.contentBean.getcontenthistid()#&moduleid=#arguments.data.moduleid#&type=#arguments.data.type#&ptype=#arguments.data.ptype#'>
	</cfif>
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tredirects (redirectID,URL,created) values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#versionID#" >,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#versionLink#" >,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		)
	</cfquery>
	</cfif>
	<cfset historyLink='http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()#/admin/index.cfm?muraAction=cArch.hist&parentid=#arguments.data.parentid#&&topid=#arguments.data.topid#&siteid=#arguments.data.siteid#&contentid=#arguments.contentBean.getcontentid()#&moduleid=#arguments.data.moduleid#&type=#arguments.data.type#'>
	
	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tredirects (redirectID,URL,created) values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#historyID#" >,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#historyLink#" >,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		)
	</cfquery>
		
<cfif session.mura.isLoggedIn>
<cfquery name="rsemail" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select email, fname, lname from tusers where userid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.mura.userID#">
</cfquery>
	
<cfloop query="rslist">
		
<cfset variables.contentDAO.createContentAssignment(arguments.contentBean,rsList.userID,'draft') />
		
<cfif rsList.email neq ''>

<cfsavecontent variable="mailText"><cfoutput>
#arguments.data.message#

TITLE: #arguments.contentBean.getTitle()#
TYPE: #arguments.contentBean.getType()# / #arguments.contentBean.getSubType()#<cfif len(crumbStr)>
LOCATION: #crumbStr#</cfif>
AUTHOR: #arguments.contentBean.getLastUpdateBy()#

VIEW VERSION HISTORY:
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()##variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getContentRenderer().getURLStem(arguments.contentBean.getSiteID(),historyID)#						
<cfif sendVersionLink>
VIEW EDITED VERSION:
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()##variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getContentRenderer().getURLStem(arguments.contentBean.getSiteID(),versionID)#
</cfif></cfoutput></cfsavecontent>
	
<cfset variables.mailer.sendText(mailText,
		rsList.email,
		"#rsemail.fname# #rsemail.lname#",
		"Site Content Review for #UCase(variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getDomain())#",
		contentBean.getSiteID(),
		rsemail.email) />

</cfif>

</cfloop>
		
<cfelse>
		
<cfloop query="rsList">
	
<cfset variables.contentDAO.createContentAssignment(arguments.contentBean,rsList.userID) />
		
<cfif rsList.email neq ''>

<cfsavecontent variable="mailText"><cfoutput>
#arguments.data.message#

TITLE: #arguments.contentBean.getTitle()#
TYPE: #arguments.contentBean.getType()# / #arguments.contentBean.getSubType()#<cfif len(crumbStr)>
LOCATION: #crumbStr#</cfif>
AUTHOR: #arguments.contentBean.getLastUpdateBy()#							

HISTORY LINK:
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()##variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getContentRenderer().getURLStem(arguments.contentBean.getSiteID(),historyID)#						
<cfif sendVersionLink>
VERSION LINK:
http://#listFirst(cgi.http_host,":")##variables.configBean.getServerPort()##variables.configBean.getContext()##variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getContentRenderer().getURLStem(arguments.contentBean.getSiteID(),versionID)#
</cfif></cfoutput></cfsavecontent>
<cfset variables.mailer.sendText(mailText,
		rsList.email,
		variables.settingsManager.getSite(arguments.contentBean.getsiteid()).getMailServerUsernameEmail(),
		"Site Content Review for #Ucase(variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getDomain())#",
		request.siteid) />

</cfif>

</cfloop>
	
</cfif>
	
</cffunction>

<cffunction name="formatFilename" returntype="any" output="false" access="public">
	<cfargument name="filename" type="any" />
	<cfset var wordDelim=variables.configBean.getURLTitleDelim()>

	<!--- replace some latin based unicode chars with allowable chars --->
	<cfset arguments.filename=removeUnicode(arguments.filename) />
	
	<!--- temporarily escape " " used for word separation --->
	<cfset arguments.filename=rereplace(arguments.filename," ","svphsv","ALL") />
	
	<!--- temporarily escape "-" used for word separation --->
	<cfset arguments.filename=rereplace(arguments.filename,"\#wordDelim#","svphsv","ALL") />
	
	<!--- remove all punctuation --->
	<cfset arguments.filename=rereplace(arguments.filename,"[[:punct:]]","","ALL") />
	
	<!--- escape any remaining unicode chars --->
	<cfset arguments.filename=urlEncodedFormat(arguments.filename) />
	
	<!---  put word separators " "  and "-" back in --->
	<cfset arguments.filename=rereplace(arguments.filename,"svphsv",wordDelim,"ALL") />
	
	<!--- remove an non alphanumeric chars (most likely %) --->
	<cfset arguments.filename=lcase(rereplace(arguments.filename,"[^a-zA-Z0-9\#wordDelim#]","","ALL")) />
	<cfset arguments.filename=lcase(rereplace(arguments.filename,"\#wordDelim#+",wordDelim,"ALL")) />

	<cfreturn arguments.filename>

</cffunction>	

<cffunction name="setUniqueFilename" returntype="void" output="false" access="public">
	<cfargument name="contentBean" type="any" />
	<cfset var parentBean=variables.contentDAO.readActive(arguments.contentBean.getParentID(),arguments.contentBean.getSiteID()) />
	<cfset var pass =0 />
	<cfset var tempfile = "">
	<cfset var parentFilename="">

	<cfset arguments.contentBean.setFilename(formatFilename(arguments.contentBean.getURLTitle()))>
	
	<cfif not len(arguments.contentBean.getfilename()) and arguments.contentBean.getContentID() neq  '00000000000000000000000000000000001'>
		<cfset arguments.contentBean.setfilename("-")/>
	</cfif>
	
	<cfset arguments.contentBean.setURLTitle(arguments.contentBean.getFilename())>
	
	<cfif arguments.contentBean.getparentid() neq '00000000000000000000000000000000001'>
		<cfset parentFilename=left(parentBean.getfilename(),250)>
		<cfif right(parentFilename,1) eq "/">
			<cfset parentFilename=left(parentBean.getfilename(),250)>
		</cfif>
		
		<cfset arguments.contentBean.setFilename(parentFilename & "/" & arguments.contentBean.getfilename()) />
	</cfif>
	
	<cfset tempfile=arguments.contentBean.getFilename() />
	
	<cfloop condition="#doesFileExist(arguments.contentBean.getsiteid(),tempfile,arguments.contentBean.getContentID())#" >
		<cfset pass=pass+1>
		<cfset tempfile=arguments.contentBean.getFilename() />
		<cfif len(tempfile) gt 250>
			<cfset tempfile=left(arguments.contentBean.getFilename(),250-len(pass)) />
			<cfif right(tempfile,1) eq "/">
				<cfset tempfile=replace(left(tempfile,len(tempfile)-2) & "/","//","/")>
			</cfif>
		</cfif>
		<cfset tempfile=tempfile & pass>
	</cfloop>
								
	<cfif pass>
		<cfset arguments.contentBean.setFilename(tempfile) />
		<cfset arguments.contentBean.setURLTitle(listLast(tempfile,"/"))>
	</cfif>
</cffunction>

<cffunction name="setUniqueURLTitle" returntype="void" output="false" access="public">
	<cfargument name="contentBean" type="any" />
	<cfset var pass =0 />
	<cfset var tempValue = "">
	
	<cfset tempValue=arguments.contentBean.getURLTitle() />
	
	<cfloop condition="#doesLoadKeyExist(arguments.contentBean,'urlTitle',tempValue)#" >
		<cfset pass=pass+1>
		<cfset tempValue="#arguments.contentBean.getURLTitle()##pass#" />
	</cfloop>
								
	<cfif pass>
		<cfset arguments.contentBean.setURLTitle(tempValue)>
	</cfif>
</cffunction>

<cffunction name="setUniqueTitle" returntype="void" output="false" access="public">
	<cfargument name="contentBean" type="any" />
	<cfset var pass =0 />
	<cfset var tempValue = "">
	
	<cfset tempValue=arguments.contentBean.getTitle() />
	
	<cfloop condition="#doesLoadKeyExist(arguments.contentBean,'title',tempValue)#" >
		<cfset pass=pass+1>
		<cfset tempValue="#arguments.contentBean.getTitle()##pass#" />
	</cfloop>
								
	<cfif pass>
		<cfset arguments.contentBean.setTitle(tempValue)>
	</cfif>
</cffunction>

<cffunction name="isOnDisplay" returntype="numeric" output="false" access="public">
			<cfargument name="display"  type="numeric">
			<cfargument name="displaystart"  type="string">
			<cfargument name="displaystop"  type="string">
			<cfargument name="siteid"  type="string">
			<cfargument name="parentid"  type="string">
			<cfargument name="parentType"  type="string" required="yes" default="Page">
		
			<cfset var nowAdjusted="">
			<cfset var isOn=1>
		
			<cfif request.muraChangesetPreview>
				<cfset nowAdjusted=getCurrentUser().getValue("ChangesetPreviewData").publishDate>
			</cfif>
			
			<cfif not isdate(nowAdjusted)>
				<cfset nowAdjusted=now()>
			</cfif>
		
			<cfswitch expression="#arguments.display#">
					<cfcase value="1">
						<cfset isOn=1>
					</cfcase>
					<cfcase value="0">
						<cfset isOn=0>
					</cfcase>
					<cfcase value="2">
						<cfif arguments.parentType eq 'Calendar' or (arguments.displaystart lte nowAdjusted and (arguments.displaystop gte nowAdjusted or arguments.displaystop eq ''))>
							<cfset isOn=1>
						<cfelse>
							<cfset isOn=0>
						</cfif>
					</cfcase>
			</cfswitch>
			
			<cfreturn isOn>
</cffunction>

<cffunction name="setApprovalQue" access="public" returntype="void" output="false">
<cfargument name="contentBean" type="any">
<cfargument name="email" type="string">


				<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				insert into 
				<cfif variables.configBean.getDBType() eq "Oracle">
				TCONTENTPUBLICSUBMISSIONAPPROV
				<cfelse>
				tcontentpublicsubmissionapprovals
				</cfif> 
				(contentid,isApproved,email,siteid)
				values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#"/>,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#"/>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteID()#"/>
				)
				</cfquery>
</cffunction>

<cffunction name="checkApprovalQue" access="public" returntype="void" output="false">
<cfargument name="contentBean" type="any">
<cfargument name="parentBean" type="any">

	<cfset var rsApproval=""/>
	<cfset var finder=""/>
	<cfset var mailText=""/>
	<cfset var theString=""/>
	<cfset var publicSubmissionApprovalScript=""/>
	<cfset var returnURL=""/>
	<cfset var contentName=""/>
	<cfset var parentName=""/>
	<cfset var contentType=""/>
	

	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rsApproval"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
	select * from 
	<cfif variables.configBean.getDBType() eq "Oracle">
		TCONTENTPUBLICSUBMISSIONAPPROV
	<cfelse>
		tcontentpublicsubmissionapprovals
	</cfif> 				
	where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentHistID()#"/> and isApproved=0 
	</cfquery>
				
<cfif rsApproval.recordcount>
				
				<cfset returnURL=variables.contentRenderer.createHREF(arguments.contentBean.getType(),arguments.contentBean.getFilename(),arguments.contentBean.getSiteID(),arguments.contentBean.getcontentID(),arguments.contentBean.getTarget(),arguments.contentBean.getTargetParams(),'',variables.configBean.getContext(),variables.configBean.getStub(),variables.configBean.getIndexFile(),true) />
				<cfset contentName=arguments.contentBean.getTitle()/>
				<cfset parentName=arguments.parentBean.getTitle()/>
				<cfset contentType=arguments.contentBean.getType()/>
				
<cfset publicSubmissionApprovalScript=variables.settingsManager.getSite(arguments.contentBean.getsiteid()).getpublicSubmissionApprovalScript() />

<cfif publicSubmissionApprovalScript neq ''>

	<cfset theString = publicSubmissionApprovalScript/>
	<cfset finder=refind('##.+?##',theString,1,"true")>
	<cfloop condition="#finder.len[1]#">
		<cftry>
			<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'#trim(evaluate(mid(theString, finder.pos[1], finder.len[1])))#')>
			<cfcatch>
				<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'')>
			</cfcatch>
		</cftry>
		<cfset finder=refind('##.+?##',theString,1,"true")>
	</cfloop>
	<cfset publicSubmissionApprovalScript = theString/>
	

	<cfsavecontent variable="mailText">
#publicSubmissionApprovalScript#
	</cfsavecontent>

<cfelse>
	<cfsavecontent variable="mailText">
Your content item has been posted on #variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getSite()# website. You can view the posting at:
#returnURL#
				
If you have any questions or comments about the news on #variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getSite()#, please contact us at #variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getContactPhone()# or email us at #variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getContactEmail()#
				
Sincerely,
#variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getSite()#
	</cfsavecontent>
</cfif>

		<cfset variables.mailer.sendText(mailText,
			rsApproval.email,
			variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getMailServerUsernameEmail(),
			"Your #variables.settingsManager.getSite(arguments.contentBean.getSiteID()).getSite()# Content Submission",
			arguments.contentBean.getSiteID(),
			rsemail.email) />
				
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				update 
				<cfif variables.configBean.getDBType() eq "Oracle">
				TCONTENTPUBLICSUBMISSIONAPPROV
				<cfelse>
				tcontentpublicsubmissionapprovals
				</cfif> 
				set isApproved=1
				where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getcontentID()#"/> and isApproved=0 
				</cfquery>
</cfif>
			
</cffunction>

<cffunction name="copy" returntype="any" output="true" access="public">
	<cfargument name="siteid" type="string" />
	<cfargument name="contentID" type="string" />
	<cfargument name="parentID" type="string" />
	<cfargument name="recurse" type="boolean" required="true" default="false"/>
	<cfargument name="appendTitle" type="boolean" required="true" default="true"/>
	<cfargument name="path"/>
	<cfargument name="setNotOnDisplay" type="boolean" required="true" default="false"/>
	<cfset var rs1 = "">
	<cfset var strSQL = "">
	<cfset var tableName = "">
	<cfset var counter = 0>
	<cfset var sortDirection="asc">
	<cfset var newContentID = "">
	<cfset var newContentHistID = "">
	<cfset var contentBean = "">
	<cfset var contentBeanParent = "">
	<cfset var contentHistID = "">
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments) />
	<cfset var rsKids="">
	<cfset contentBean = variables.contentDAO.readActive(arguments.contentID, arguments.siteID)>
	
	<!--- This makes sure that all extended data is loaded --->
	<cfset contentBean.getAllValues()>
	
	<!--- <cfset contentBeanParent = variables.contentDAO.readActive(arguments.parentID, arguments.siteID)>--->
	<cfset contentHistID = contentBean.getcontentHistID()>
	
	<!--- tcontent --->
	<!--- <cfif contentBeanParent.getFilename() neq "">
		<cfset contentBean.setUniqueFilename(contentBean)>
	</cfif> --->
	
	<cfset contentBean.setIsNew(1)>
	<cfset contentBean.setContentID("")>
	<cfset contentBean.setContentHistID("")>
	<cfset contentBean.setParentID(arguments.parentID)>
	<cfif arguments.appendTitle>
		<cfset contentBean.setMenuTitle(contentBean.getMenuTitle() & " - Copy")>
	<cfelse>
		<cfset contentBean.setMenuTitle(contentBean.getMenuTitle())>
	</cfif>
	
	<cfif arguments.setNotOnDisplay>
		<cfset contentBean.setDisplay(0)>
	</cfif>
	
	<cfif listFindNoCase("Page,Folder,Gallery,Calendar",contentBean.getType())>
		<cfset setUniqueFilename(contentBean)>
	</cfif>
	
	<cfif not structKeyExists(arguments,"path")>
		<cfset getBean("contentManager").setMaterializedPath(contentBean)>
	<cfelse>
		<cfset contentBean.setPath(listAppend(arguments.path,contentBean.getContentID()))>
	</cfif>
	
	<cfset contentBean.setCreated(now())>
	<cfset contentBean.save()>
	<cfset newContentHistID=contentBean.getContentHistID()>
	<cfset newContentID=contentBean.getContentID()>
	
	<!--- tcontentcategoryassign --->
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		insert into tcontentcategoryassign (contentHistID, categoryID, contentID, isFeature, orderno, siteID, featurestart,featurestop)
		select '#newContentHistID#',categoryID,'#newContentID#',isFeature,orderno,siteid,featurestart,featurestop from tcontentcategoryassign
		where siteid='#arguments.siteid#' 
		and contentID='#arguments.contentID#'
		and contentHistID='#contentHistID#'
	</cfquery>
	
	<!--- tcontentrelated --->
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		insert into tcontentrelated (contentHistID,relatedID, contentID, siteID)
		select '#newContentHistID#',relatedID,'#newContentID#',siteID from tcontentrelated 
		where siteid='#arguments.siteid#' 
		and contentID='#arguments.contentID#'
		and contentHistID='#contentHistID#'
	</cfquery>
	
	<!--- tcontentobjects --->
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		insert into tcontentobjects (contentHistID, objectID, object, contentID, name, orderno, siteid, columnid, params)
		select '#newContentHistID#',objectid, object, '#newContentID#',name,orderno,siteid,columnid, params from tcontentobjects
		where siteid='#arguments.siteid#' 
		and contentID='#arguments.contentID#'
		and contentHistID='#contentHistID#'
	</cfquery>

	<!--- tpermissions --->
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		insert into tpermissions (contentID, groupID, siteID, type)
		select '#newContentID#', groupID, siteid,type from tpermissions
		where siteid='#arguments.siteid#' 
		and contentID='#arguments.contentID#'
	</cfquery>
	
	<!--- tclassextenddata --->
	<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		insert into tclassextenddata (baseID,attributeID,siteID,attributeValue)
		select '#newContentHistID#',attributeID,siteID,attributeValue from tclassextenddata
		where baseid='#contentHistID#' 
	</cfquery>
	
	<cfset pluginEvent.setValue("contentBean",contentBean)>
	<cfset getPluginManager().announceEvent("onContentCopy",pluginEvent)>
	
	<cfif arguments.recurse>
		<cfif contentBean.getSortBy() eq "orderno">
			<cfif contentBean.getSortDirection() eq "asc">
				<cfset sortDirection="desc">
			<cfelse>
				<cfset sortDirection=contentBean.getSortDirection()>
			</cfif>
		<cfelse>
			<cfset sortDirection="asc">
		</cfif>
		
		<cfset rsKids=getBean("contentGateway").getNest(parentID=arguments.contentID, siteID=arguments.siteID, sortBy=contentBean.getSortBy(), sortDirection=sortDirection)>
			
		<cfloop query="rsKids">
			<cfset copy(arguments.siteID, rsKids.contentID, newContentID, rsKids.hasKids, false, contentBean.getPath(), arguments.setNotOnDisplay)>
		</cfloop>
	</cfif>

	<cfreturn contentBean>
</cffunction>

<cffunction name="updateGlobalMaterializedPath" returntype="any" output="false">
<cfargument name="siteID">
<cfargument name="parentID" required="true" default="00000000000000000000000000000000END">
<cfargument name="path" required="true" default=""/>
<cfargument name="datasource" required="true" default="#variables.configBean.getDatasource()#"/>

<cfset var rs="" />
<cfset var newPath = "" />
<cfset var updateDSN=arguments.datasource>
<cfset var updatePWD="">
<cfset var updateUSER="">

<cfif updateDSN eq variables.configBean.getDatasource()>
	<cfset updatePWD=variables.configBean.getDBPassword()>
	<cfset updateUSER=variables.configBean.getDBUsername()>
</cfif>

<cfquery name="rs" datasource="#updateDSN#" username="#updateUSER#" password="#updatePWD#">
select contentID from tcontent 
where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
and parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#" />
and active=1
</cfquery>

	<cfloop query="rs">
		<cfset newPath=listappend(arguments.path,rs.contentID) />
		<cfquery datasource="#updateDSN#" username="#updateUSER#" password="#updatePWD#">
		update tcontent
		set path=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newPath#" />
		where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contentID#" />
		</cfquery>
		<cfset updateGlobalMaterializedPath(arguments.siteID,rs.contentID,newPath,updateDSN) />
	</cfloop>

</cffunction>

<cffunction name="updateGlobalCommentsMaterializedPath" returntype="any" output="false">
<cfargument name="siteID">
<cfargument name="parentID" required="true" default="">
<cfargument name="path" required="true" default=""/>
<cfargument name="datasource" required="true" default="#variables.configBean.getDatasource()#"/>

<cfset var rs="" />
<cfset var newPath = "" />
<cfset var updateDSN=arguments.datasource>
<cfset var updatePWD="">
<cfset var updateUSER="">

<cfif updateDSN eq variables.configBean.getDatasource()>
	<cfset updatePWD=variables.configBean.getDBPassword()>
	<cfset updateUSER=variables.configBean.getDBUsername()>
</cfif>

<cfquery name="rs" datasource="#updateDSN#" username="#updateUSER#" password="#updatePWD#">
select commentID from tcontentcomments
where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
<cfif len(arguments.parentID)>
and parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#" />
<cfelse>
and parentID is null
</cfif>
</cfquery>

	<cfloop query="rs">
		<cfset newPath=listappend(arguments.path,rs.commentID) />
		<cfquery datasource="#updateDSN#" username="#updateUSER#" password="#updatePWD#">
		update tcontentcomments
		set path=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newPath#" />
		where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and commentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.commentID#" />
		</cfquery>
		<cfset updateGlobalCommentsMaterializedPath(arguments.siteID,rs.commentID,newPath,updateDSN) />
	</cfloop>

</cffunction>

<cffunction name="findAndReplace" returntype="void" output="false">
	<cfargument name="find" type="string" default="" required="true">
	<cfargument name="replace" type="string" default="" required="true">
	<cfargument name="siteID" type="string" default="" required="true">
	<cfset var rs ="" />
	<cfset var newSummary ="" />
	<cfset var newBody ="" />
	
	<cfif arguments.find neq "/">
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontent set filename=replace(filename,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.find#"/>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.replace#"/>) where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		and filename like <cfqueryparam value="%#arguments.find#%" cfsqltype="cf_sql_varchar">
		and active=1 and type in ('Page','Calendar','Folder','Gallery','Link','Component','Form')
		</cfquery>
		
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rs"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select contenthistid, body from tcontent where body like <cfqueryparam value="%#arguments.find#%" cfsqltype="cf_sql_varchar"> and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
			and type in ('Page','Calendar','Folder','Gallery','Link','Component','Form')
		</cfquery>
		
		<cfloop query="rs">
			<cfset newbody = replaceNoCase(BODY,"#arguments.find#","#arguments.replace#","ALL")>
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			update tcontent set body = <cfqueryparam value="#newBody#" cfsqltype="cf_sql_longvarchar"> where contenthistid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contenthistID#"/>
			</cfquery>
		</cfloop>
	
		<cfquery datasource="#variables.configBean.getReadOnlyDatasource()#" name="rs"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			select contenthistid, summary from tcontent where summary like <cfqueryparam value="%#arguments.find#%" cfsqltype="cf_sql_varchar"> and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
			and type in ('Page','Calendar','Folder','Gallery','Link','Component','Form')
		</cfquery>
		
		<cfloop query="rs">
			<cfset newSummary = replaceNoCase(summary,"#arguments.find#","#arguments.replace#","ALL")>
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			update tcontent set summary = <cfqueryparam value="#newSummary#" cfsqltype="cf_sql_longvarchar"> where contenthistid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contenthistID#"/>
			</cfquery>
		</cfloop> 
	</cfif>
</cffunction>

<cffunction name="removeUnicode" returntype="string" output="false">
	<cfargument name="str">
		
		<cfset var unicodeArray=arrayNew(2) />
		<cfset var i=0 />
		<cfset var returnStr=arguments.str />
		<!---
		 '#160':' ', '#161':'¡','#162':'¢','#163':'£','#165':'¥',
			'#167':'§','#169':'©','#171':'«','#174':'®','#177':'±','#180':'´',
			'#181':'µ','#182':'¶','#183':'·','#187':'»','#191':'¿','#192':'À',
			'#193':'Á','#194':'Â','#195':'Ã','#196':'Ä','#197':'Å','#198':'Æ',
			'#199':'Ç','#200':'È','#201':'É','#202':'Ê','#203':'Ë','#204':'',
			'#205':'Í','#206':'','#207':'Ï','#209':'Ñ','#210':'Ò','#211':'Ó',
			'#212':'Ô','#213':'Õ','#214':'Ö','#216':'Ø','#217':'Ù','#218':'Ú',
			'#219':'Û','#220':'Ü','#223':'ß','#224':'à','#225':'á','#226':'â',
			'#227':'ã','#228':'ä','#229':'å','#230':'æ','#231':'ç','#232':'è',
			'#233':'é','#234':'ê','#235':'ë','#236':'','#237':'í','#238':'',
			'#239':'ï','#241':'ñ','#242':'ò','#243':'ó','#244':'ô','#245':'õ',
			'#246':'ö','#247':'÷','#248':'ø','#249':'ù','#250':'ú','#251':'û',
			'#252':'ü','#255':'ÿ','#34':'','#38':'&','#60':'<','#62':'>',
			'#8211':'–','#8212':'—','#8364':'€','#96':'`'	
		--->	

	
		<cfset unicodeArray[1][1]=192 />
		<cfset unicodeArray[1][2]="À" />
		<cfset unicodeArray[1][3]="A" />

		<cfset unicodeArray[2][1]=193 />
		<cfset unicodeArray[2][2]="Á" />
		<cfset unicodeArray[2][3]="A" />

		<cfset unicodeArray[3][1]=194 />
		<cfset unicodeArray[3][2]="Â" />
		<cfset unicodeArray[3][3]="A" />

		<cfset unicodeArray[4][1]=195 />
		<cfset unicodeArray[4][2]="Ã" />
		<cfset unicodeArray[4][3]="A" />

		<cfset unicodeArray[5][1]=196 />
		<cfset unicodeArray[5][2]="Ä" />
		<cfset unicodeArray[5][3]="AE" />

		<cfset unicodeArray[6][1]=197 />
		<cfset unicodeArray[6][2]="Å" />
		<cfset unicodeArray[6][3]="A" />

		<cfset unicodeArray[7][1]=200 />
		<cfset unicodeArray[7][2]="È" />
		<cfset unicodeArray[7][3]="E" />

		<cfset unicodeArray[8][1]=201 />
		<cfset unicodeArray[8][2]="É" />
		<cfset unicodeArray[8][3]="E" />

		<cfset unicodeArray[9][1]=202 />
		<cfset unicodeArray[9][2]="Ê" />
		<cfset unicodeArray[9][3]="E" />

		<cfset unicodeArray[10][1]=203 />
		<cfset unicodeArray[10][2]="Ë" />
		<cfset unicodeArray[10][3]="E" />

		<cfset unicodeArray[11][1]=204 />
		<cfset unicodeArray[11][2]="" />
		<cfset unicodeArray[11][3]="I" />

		<cfset unicodeArray[12][1]=205 />
		<cfset unicodeArray[12][2]="Í" />
		<cfset unicodeArray[12][3]="I" />

		<cfset unicodeArray[13][1]=206 />
		<cfset unicodeArray[13][2]="" />
		<cfset unicodeArray[13][3]="I" />

		<cfset unicodeArray[14][1]=207 />
		<cfset unicodeArray[14][2]="Ï" />
		<cfset unicodeArray[14][3]="I" />

		<cfset unicodeArray[15][1]=209 />
		<cfset unicodeArray[15][2]="Ñ" />
		<cfset unicodeArray[15][3]="N" />

		<cfset unicodeArray[16][1]=210 />
		<cfset unicodeArray[16][2]="Ò" />
		<cfset unicodeArray[16][3]="O" />

		<cfset unicodeArray[17][1]=211 />
		<cfset unicodeArray[17][2]="Ó" />
		<cfset unicodeArray[17][3]="O" />

		<cfset unicodeArray[18][1]=212 />
		<cfset unicodeArray[18][2]="Ô" />
		<cfset unicodeArray[18][3]="O" />

		<cfset unicodeArray[19][1]=213 />
		<cfset unicodeArray[19][2]="Õ" />
		<cfset unicodeArray[19][3]="O" />

		<cfset unicodeArray[20][1]=214 />
		<cfset unicodeArray[20][2]="Ö" />
		<cfset unicodeArray[20][3]="OE" />

		<cfset unicodeArray[21][1]=216 />
		<cfset unicodeArray[21][2]="Ø" />
		<cfset unicodeArray[21][3]="O" />

		<cfset unicodeArray[22][1]=217 />
		<cfset unicodeArray[22][2]="Ù" />
		<cfset unicodeArray[22][3]="U" />

		<cfset unicodeArray[23][1]=218 />
		<cfset unicodeArray[23][2]="Ú" />
		<cfset unicodeArray[23][3]="U" />

		<cfset unicodeArray[24][1]=219 />
		<cfset unicodeArray[24][2]="Û" />
		<cfset unicodeArray[24][3]="U" />

		<cfset unicodeArray[25][1]=220 />
		<cfset unicodeArray[25][2]="Ü" />
		<cfset unicodeArray[25][3]="UE" />

		<cfset unicodeArray[26][1]=223 />
		<cfset unicodeArray[26][2]="ß" />
		<cfset unicodeArray[26][3]="ss" />

		<cfset unicodeArray[27][1]=224 />
		<cfset unicodeArray[27][2]="à" />
		<cfset unicodeArray[27][3]="a" />

		<cfset unicodeArray[28][1]=225 />
		<cfset unicodeArray[28][2]="á" />
		<cfset unicodeArray[28][3]="a" />

		<cfset unicodeArray[29][1]=226 />
		<cfset unicodeArray[29][2]="â" />
		<cfset unicodeArray[29][3]="a" />

		<cfset unicodeArray[30][1]=227 />
		<cfset unicodeArray[30][2]="ã" />
		<cfset unicodeArray[30][3]="a" />

		<cfset unicodeArray[31][1]=228 />
		<cfset unicodeArray[31][2]="ä" />
		<cfset unicodeArray[31][3]="ae" />

		<cfset unicodeArray[32][1]=229 />
		<cfset unicodeArray[32][2]="å" />
		<cfset unicodeArray[32][3]="a" />

		<cfset unicodeArray[33][1]=232 />
		<cfset unicodeArray[33][2]="è" />
		<cfset unicodeArray[33][3]="e" />

		<cfset unicodeArray[34][1]=233 />
		<cfset unicodeArray[34][2]="é" />
		<cfset unicodeArray[34][3]="e" />

		<cfset unicodeArray[35][1]=234 />
		<cfset unicodeArray[35][2]="ê" />
		<cfset unicodeArray[35][3]="e" />

		<cfset unicodeArray[36][1]=235 />
		<cfset unicodeArray[36][2]="ë" />
		<cfset unicodeArray[36][3]="e" />

		<cfset unicodeArray[37][1]=236 />
		<cfset unicodeArray[37][2]="" />
		<cfset unicodeArray[37][3]="i" />

		<cfset unicodeArray[38][1]=237 />
		<cfset unicodeArray[38][2]="í" />
		<cfset unicodeArray[38][3]="i" />

		<cfset unicodeArray[39][1]=238 />
		<cfset unicodeArray[39][2]="" />
		<cfset unicodeArray[39][3]="i" />

		<cfset unicodeArray[40][1]=239 />
		<cfset unicodeArray[40][2]="ï" />
		<cfset unicodeArray[40][3]="i" />

		<cfset unicodeArray[41][1]=241 />
		<cfset unicodeArray[41][2]="ñ" />
		<cfset unicodeArray[41][3]="n" />

		<cfset unicodeArray[42][1]=242 />
		<cfset unicodeArray[42][2]="ò" />
		<cfset unicodeArray[42][3]="o" />

		<cfset unicodeArray[43][1]=243 />
		<cfset unicodeArray[43][2]="ó" />
		<cfset unicodeArray[43][3]="o" />

		<cfset unicodeArray[44][1]=244 />
		<cfset unicodeArray[44][2]="ô" />
		<cfset unicodeArray[44][3]="o" />

		<cfset unicodeArray[45][1]=245 />
		<cfset unicodeArray[45][2]="õ" />
		<cfset unicodeArray[45][3]="o" />

		<cfset unicodeArray[46][1]=246 />
		<cfset unicodeArray[46][2]="ö" />
		<cfset unicodeArray[46][3]="oe" />

		<cfset unicodeArray[47][1]=248 />
		<cfset unicodeArray[47][2]="ø" />
		<cfset unicodeArray[47][3]="o" />

		<cfset unicodeArray[48][1]=249 />
		<cfset unicodeArray[48][2]="ù" />
		<cfset unicodeArray[48][3]="u" />

		<cfset unicodeArray[49][1]=250 />
		<cfset unicodeArray[49][2]="ú" />
		<cfset unicodeArray[49][3]="u" />

		<cfset unicodeArray[50][1]=251 />
		<cfset unicodeArray[50][2]="û" />
		<cfset unicodeArray[50][3]="u" />

		<cfset unicodeArray[51][1]=252 />
		<cfset unicodeArray[51][2]="ü" />
		<cfset unicodeArray[51][3]="ue" />

		<cfset unicodeArray[52][1]=255 />
		<cfset unicodeArray[52][2]="ÿ" />
		<cfset unicodeArray[52][3]="y" />
	
		<cfloop from="1" to="#arrayLen(unicodeArray)#" index="i">
			<cfset returnStr=rereplace(returnStr,chr(unicodeArray[i][1]),unicodeArray[i][3],"ALL")>
		</cfloop>
		
		<cfreturn returnStr />
	
</cffunction>


<cffunction name="setVersionNumbers" output="false">
<cfargument name="contentBean">
<cfargument name="versionType" default="minor">
	<cfset var rs="">
	<cfset var stats="">
	<cfset var major=0>
	<cfset var minor=0>
	
	<cfset stats=arguments.contentBean.getStats()>
	
	<cfif arguments.contentBean.getIsNew()>
		<cfset major=1>
		<cfset minor=0>
	<cfelse>

		<cfif not stats.getMajorVersion()>		
			<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">	
				select contentID, siteID, max(majorVersion) majorVersion, max(minorVersion) minorVersion
				from tcontent
				where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getContentID()#">
				and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSiteID()#">
				group by contentID, siteID
			</cfquery>
			
			<cfif rs.recordcount and rs.majorVersion>		
				<cfif arguments.versionType eq "major">
					<cfset major=rs.majorVersion + 1>
					<cfset minor=0>
				<cfelse>
					<cfset major=rs.majorVersion>
					<cfset minor=rs.minorVersion + 1>
				</cfif>
			<cfelse>
				<cfset major=1>
				<cfset minor=0>
			</cfif>
			
		<cfelse>
	
			<cfif stats.getMajorVersion()>		
				<cfif arguments.versionType eq "major">
					<cfset major=stats.getMajorVersion() + 1>
					<cfset minor=0>
				<cfelse>
					<cfset major=stats.getMajorVersion()>
					<cfset minor=stats.getMinorVersion() + 1>
				</cfif>
			<cfelse>
				<cfset major=1>
				<cfset minor=0>
			</cfif>
		
		</cfif>
	</cfif>
	
	<cfset arguments.contentBean.setMajorVersion(major)>
	<cfset arguments.contentBean.setMinorVersion(minor)>

	<cfset stats.setMajorVersion(major)>
	<cfset stats.setMinorVersion(minor)>
	<cfset stats.save()>
	
</cffunction>


	<cffunction name="duplicateExternalContent" returntype="any" output="true" >
		<cfargument name="contentID">
		<cfargument name="destinationSiteID">
		<cfargument name="sourceSiteID">
		<cfargument name="includeChildren" type="boolean" default="false">
		<cfargument name="siteSynced" type="boolean" default="false">
		<cfargument name="feedIDList" type="string" default="">
		<cfargument name="contentIDList" type="string" default="">
			
		<cfset var contentBean = "" />
		<cfset var newContentBean = "" />
		<cfset var parentBean = "" />
	
		<cfset var rsObjects = "" />
		<cfset var rsFileIDs = "" />
		<cfset var rsRelated = "" />
		
		<cfset var rsObjectParams = "" />
		<cfset var objStruct = "" />
			
		<cfset var x = "" />
		<cfset var y = "" />
	
		<cfset var extendData = "" />
		<cfset var newFileID = "" />
		<cfset var childrenIterator = "" />
		<cfset var delim = variables.configBean.getFileDelim() />
		<cfset var sourceFileLocation = "#variables.configBean.getFileDir()##delim##arguments.sourceSiteID##delim#cache#delim#file#delim#" />
		<cfset var destFileLocation = "#variables.configBean.getFileDir()##delim##arguments.destinationSiteID##delim#cache#delim#file#delim#" />
	
		<cfset var sResponse = StructNew() />

		<cfset sResponse.success = false />
	
		<cfif contentID eq '00000000000000000000000000000000001' or arguments.destinationSiteID eq arguments.sourceSiteID>
			<cfreturn sResponse />
		</cfif>
	
		<cfif not arguments.siteSynced>
			<cfset variables.configBean.getClassExtensionManager().syncDefinitions( arguments.sourceSiteID,arguments.destinationSiteID ) />
			<cfset duplicateExternalCategories( arguments.destinationSiteID,arguments.sourceSiteID ) />
			<cfset arguments.siteSynced = true />
		</cfif>
	
		<cfset newContentBean = getBean('content').loadBy(remoteID=arguments.contentID,siteID=arguments.destinationSiteID) />
		<cfset contentBean = getBean('content').loadBy(contentID=arguments.contentID,siteID=arguments.sourceSiteID ) />
	
	
				
		<!--- does source page exist? --->
		<cfif contentBean.getIsNew()>
			<cfreturn sResponse />
		</cfif>

		<!--- content does not exist --->
		<cfif newContentBean.getIsNew()>
			
			<cfset newContentBean = getBean('content') />
			<cfset sArgs = duplicate(contentBean.getAllValues()) />
			<cfset rsRelated = contentBean.getRelatedContentQuery() />
						
			<cfset StructDelete(sArgs,"ContentHistID")/>
			<cfset StructDelete(sArgs,"ContentID")/>
			<cfset StructDelete(sArgs,"ParentID")/>
			<cfset StructDelete(sArgs,"SiteID")/>
				
			<cfset newContentBean.set( content=sArgs ) />
			<cfif rsRelated.recordCount>
				<cfset newContentBean.setRelatedContentID( valueList( rsRelated.contentID ) ) />
			</cfif>
					
			<!--- see if parent exists (excluding home), using original parentID --->			
			<cfif contentBean.getParentID() neq "00000000000000000000000000000000001">
				<!--- if no parent, we create the parent --->
				<cfset parentBean = getBean('content').loadBy(remoteID=contentBean.getParentID(),siteID=arguments.destinationSiteID ) />
	
				<cfif parentBean.getIsNew()>
					<cfset duplicateExternalContent( contentBean.getParentID(),arguments.destinationSiteID,arguments.sourceSiteID,false,arguments.siteSynced,arguments.feedIDList,arguments.contentIDList ) />
					<cfset parentBean = getBean('content').loadBy(remoteID=contentBean.getParentID(),siteID=arguments.destinationSiteID ) />

					<cfset newContentBean.setParentID( parentBean.getContentID() ) />
				<cfelse>

						<!--- if parent is found, set it into the duplicated contentBean --->
					<cfset newContentBean.setParentID( parentBean.getContentID() ) />
				</cfif>
			<cfelse>
				<cfset newContentBean.setParentID( "00000000000000000000000000000000001" ) />
			</cfif>

			<cfset newContentBean.setSiteID( arguments.destinationSiteID ) />
			<cfset newContentBean.setRemoteID( arguments.contentID ) />
			<cfset newContentBean.setApproved( 1 ) />
		
			<cfif len( newContentBean.getFileID() )>
				<cfset rsfileData = getBean('fileManager').readMeta(newContentBean.getFileID())>
				<cfif rsfileData.recordCount>
					<cfif fileExists("#sourceFileLocation##rsfileData.fileID#_source.#rsfileData.fileExt#")>
						<cfset tempFile = getBean('fileManager').emulateUpload("#sourceFileLocation##rsfileData.fileID#_source.#rsfileData.fileExt#")>
					<cfelse>
						<cfset tempFile = getBean('fileManager').emulateUpload("#sourceFileLocation##rsfileData.fileID#.#rsfileData.fileExt#")>
					</cfif>
					<cfset tempFile = getBean('fileManager').emulateUpload("#sourceFileLocation##rsfileData.fileID#.#rsfileData.fileExt#")>
					
					<cfset theFileStruct = getBean('fileManager').process(tempFile,newContentBean.getSiteID()) />
					<cfset newContentBean.setFileID(getBean('fileManager').create(theFileStruct.fileObj,newContentBean.getcontentID(),newContentBean.getSiteID(),rsfileData.filename,tempFile.ContentType,tempFile.ContentSubType,tempFile.FileSize,newContentBean.getModuleID(),tempFile.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium,getBean('utility').getUUID(),theFileStruct.fileObjSource))>
				</cfif>
			</cfif>

			<cfset setCategoriesFromExternalAssignments( contentBean,newContentBean ) />

			<cfloop from="1" to="#variables.settingsManager.getSite(arguments.destinationSiteID).getcolumncount()#" index="x">
				<cfset rsObjects = contentBean.getDisplayRegion(x)>
				
				<cfif rsObjects.recordCount>
					<cfloop query="rsObjects">
						<cfset rsObjectParams = rsObjects.params />

						<cfswitch expression="#rsObjects.object#">
							<cfcase value="Component,form">	
								<cfset duplicateExternalContent(rsObjects.objectID,arguments.destinationSiteID,arguments.sourceSiteID,false,true,arguments.feedIDList,arguments.contentIDList) />
							</cfcase>
							<cfcase value="feed">	
								<cfset arguments.feedIDList = listAppend(arguments.feedIDList,rsObjects.objectID) />
							</cfcase>
							<cfcase value="plugin">	
								<cfset duplicateExternalContent(rsObjects.objectID,arguments.destinationSiteID,arguments.sourceSiteID,false,true,arguments.feedIDList,arguments.contentIDList) />
								
							
								<cfif len( rsObjects.params ) and isJSON( rsObjects.params )>
									<cfset objStruct = deserializeJSON( rsObjects.params ) />
									<cfif structKeyExists(objStruct,"siteID") and objStruct.siteID eq arguments.sourceSiteID>
										<cfset objStruct.siteID = arguments.destinationSiteID />
										<cfset rsObjectParams = serializeJSON(objStruct) />
									</cfif>								
								</cfif>
							</cfcase>
						</cfswitch> 
						
						<cfset newContentBean.addDisplayObject( regionID=x,object=rsObjects.object,objectID=rsObjects.objectID,name=rsObjects.name,params=rsObjectParams,orderNo=rsObjects.orderno )>
						<!--- components,forms,feeds--->
					</cfloop>				
				</cfif>
			</cfloop>

			<cfset rsFileIDs = getExtendFileIDs( newContentBean.getExtendedData().getAllValues(),arguments.destinationSiteID ) />
			
			<cfloop query="rsFileIDs">
				<cfif len( newContentBean.getValue(rsFileIDs.name) )>
					<!--- use the value from the contentbean rather than the extend data as the class extension hasn't been saved yet! --->
					<cfset rsfileData = getBean('fileManager').readMeta( newContentBean.getValue(rsFileIDs.name) )>
					
					<cfif rsfileData.recordCount>
						
						<cfif len(rsfileData.fileID)>
							<cfset tempFile = StructNew() />
	
							<!--- cfif  _source exists --->
	<!---
							<cfif fileExists("#sourceFileLocation##rsfileData.fileID#_source.#rsfileData.fileExt#")>
								<cfset tempFile = getBean('fileManager').emulateUpload("#sourceFileLocation##rsfileData.fileID#_source.#rsfileData.fileExt#")>
							<cfelseif fileExists("#sourceFileLocation##rsfileData.fileID#.#rsfileData.fileExt#")>
	--->
								<cfset tempFile = getBean('fileManager').emulateUpload("#sourceFileLocation##rsfileData.fileID#.#rsfileData.fileExt#")>
	<!---	
							</cfif>
	--->
							<cfif structCount(tempFile) and fileExists("#tempFile.serverDirectory##delim##tempfile.serverfile#")>
								<cfset theFileStruct = getBean('fileManager').process(tempFile,newContentBean.getSiteID()) />
								<cfset newContentBean.setValue(rsFileIDs.name,getBean('fileManager').create(theFileStruct.fileObj,newContentBean.getcontentID(),newContentBean.getSiteID(),rsfileData.filename,tempFile.ContentType,tempFile.ContentSubType,tempFile.FileSize,newContentBean.getModuleID(),tempFile.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium,getBean('utility').getUUID(),theFileStruct.fileObjSource))>
							<cfelse>
								<cfset newContentBean.setValue(rsFileIDs.name,"")>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>


			<cfset newContentBean.save() />
			<cfset arguments.contentIDList = listAppend(arguments.contentIDList,newContentBean.getContentID()) />

			<cfset sResponse.success = true />
			<cfset sResponse.contentBean = newContentBean />
			<cfset sResponse.feedIDList = arguments.feedIDList />
			<cfset sResponse.contentIDList = arguments.contentIDList />
			
			<cfreturn sResponse />
		</cfif>

		<cfif arguments.includeChildren eq true>
			<cfset childrenIterator = contentBean.getKidsIterator() />
			<cfset childrenIterator.setNextN(0) />
			<cfset childrenIterator.end() />

			<cfloop condition="childrenIterator.hasPrevious()">
				<cfset childContentBean = childrenIterator.previous() />
				
				<cfset duplicateExternalContent(childContentBean.getContentID(),arguments.destinationSiteID,arguments.sourceSiteID,true,arguments.siteSynced,arguments.feedIDList,arguments.contentIDList ) />
			</cfloop>
		</cfif>

		<cfset sRespose.success = true />

		<cfreturn sResponse />
	</cffunction>

	<cffunction name="duplicateExternalFeed" returntype="void">
		<cfargument name="feedID">
		<cfargument name="destinationSiteID">
		<cfargument name="sourceSiteID">

		<cfset var feedBean = getBean('feed').loadBy(feedID=arguments.feedID,siteID=arguments.sourceSiteID ) />
		<cfset var newFeedBean = getBean('feed').loadBy(remoteID=arguments.feedID,siteID=arguments.destinationSiteID ) />
		<cfset var sArgs = feedBean.getAllValues() />
		<cfset var contentID = "" />
		<cfset var contentBean = "" />
		<cfset var contentIDList = feedBean.getValue('contentID') /> 
		<cfset var newContentIDList = "" /> 
		
		<!--- exit if the feed exists --->
		<cfif not newFeedBean.getIsNew()>
			<cfreturn />
		</cfif>

		<cfset StructDelete(sArgs,"feedID")/>
		<cfset sArgs.siteID = arguments.destinationSiteID />
		<cfset sArgs.contentID = newContentIDList />
		<cfset sArgs.remoteID = arguments.feedID />

		<cfset newFeedBean.set( sArgs ) />
	
		<cfloop list="#contentIDList#" index="contentID">
			<cfset contentBean = getBean('content').loadBy(remoteID=contentID,siteID=arguments.destinationSiteID ) />
			<cfif not contentBean.getIsNew()>
				<cfset newFeedBean.setContentID( contentBean.getContentID(),true ) />				
			</cfif>
		</cfloop>
		
		<cfset newFeedBean.save() /> 
	</cffunction>

	<cffunction name="updateRelatedContent" returntype="void">
		<cfargument name="contentID">
		<cfargument name="destinationSiteID">
		<cfargument name="sourceSiteID">

		<cfset var contentBean = getBean('content').loadBy(contentID=arguments.contentID,siteID=arguments.destinationSiteID) />
		<cfset var relatedContentBean = "" /> 
		<cfset var contentIDList = "" /> 
		<cfset var relatedID = "" /> 
		<cfset var rsUpdate = "" />
		<cfset var rsRelated = "" />
		
		<!--- exit if the content exists --->
		<cfif contentBean.getIsNew()>
			<cfreturn />
		</cfif>

		<cfquery name="rsRelated" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
		select contenthistid,relatedid from tcontentrelated
		where contentid = <cfqueryparam value="#arguments.contentID#" cfsqltype="cf_sql_varchar">
		and siteID = <cfqueryparam value="#arguments.destinationSiteID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfloop query="rsRelated">
			<cfset relatedContentBean = getBean('content').loadBy(remoteID=rsRelated.relatedID,siteID=arguments.destinationSiteID ) />

			<cfif not relatedContentBean.getIsNew()>
				<cftry>
				<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				insert into tcontentrelated
				(contentHistID,relatedID,contentID,siteID)
				values
				(
				<cfqueryparam value="#contentBean.getContentHistID()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#relatedContentBean.getContentID()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.contentID#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.destinationSiteID#" cfsqltype="cf_sql_varchar">
				)
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="duplicateExternalSortOrder" returntype="void">
        <cfargument name="destinationSiteID">
        <cfargument name="sourceSiteID">

        <cfset var rsSortParent = "" />
        <cfset var rsSortOrder = "" />

        <cfquery name="rsSortParent" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
            SELECT
                orderNo,contentID
            FROM
                tcontent
            WHERE
                active = 1
            AND
                siteID = <cfqueryparam value="#arguments.sourceSiteID#" cfsqltype="cf_sql_varchar">
            AND
                contentID IN
                (
                SELECT remoteID FROM tcontent
                WHERE
                    remoteID != ''
                AND
                    active =1
                )
        </cfquery>
                
        <cfloop query="rsSortParent">
            <cfquery name="rsSortOrder" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
                UPDATE tcontent
                SET
                    orderNo = <cfqueryparam value="#rsSortParent.orderNo#" cfsqltype="cf_sql_integer">
                WHERE
                    remoteID = <cfqueryparam value="#rsSortParent.contentID#" cfsqltype="cf_sql_varchar" maxlength="35">
                AND
                    siteID = <cfqueryparam value="#arguments.destinationSiteID#" cfsqltype="cf_sql_varchar">
            </cfquery>
        </cfloop>
    </cffunction>


	<cffunction name="getExtendFileIDs" returntype="query">
		<cfargument name="contentExtendData">
		<cfargument name="siteID">

		<cfset var rsAttributeIDs = QueryNew('null') />
		<cfset var rsFileIDs = QueryNew('null') />

		<cfquery name="rsAttributeIDs" dbtype="query">
			SELECT
				attributeID
			FROM
				arguments.contentExtendData.definitions
			WHERE
				INPUTTYPE = 'File'
			AND
				siteID = '#arguments.siteID#'
		</cfquery>
	
		<cfif rsAttributeIDs.recordCount>
			<cfquery name="rsFileIDs" dbtype="query">
				SELECT
					*
				FROM
					arguments.contentExtendData.data
				WHERE
					attributeID IN (#ValueList(rsAttributeIDs.attributeID)#)
			</cfquery>
		</cfif>
		
		<cfreturn rsFileIDs />
	</cffunction>

	<cffunction name="duplicateExternalCategories" returntype="any">
		<cfargument name="destinationSiteID">
		<cfargument name="sourceSiteID">
		<cfargument name="categoryID" default="">
		<cfargument name="parentID" default="">
	
		<cfset var rsCategories = "" />
		<cfset var rsCategoryExists = "" />
		<cfset var newCategoryBean = "" />

		<cfset var data = StructNew() />
		<cfset var column = "" />

		<cfquery name="rsCategories" datasource="#variables.configBean.getReadOnlyDatasource()#"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
			SELECT
				*
			FROM
				tcontentcategories
			WHERE
				siteID = <cfqueryparam value="#arguments.sourceSiteID#" cfsqltype="cf_sql_varchar">
			AND
				<cfif not len(arguments.categoryID)>
				parentID IS NULL
				<cfelse>
				parentID = <cfqueryparam value="#arguments.categoryID#" cfsqltype="cf_sql_varchar">
				</cfif>
		</cfquery>
		
		<cfloop query="rsCategories">
			<cfquery name="rsCategoryExists"  username="#variables.configBean.getReadOnlyDbUsername()#" password="#variables.configBean.getReadOnlyDbPassword()#">
				SELECT
					categoryID
				FROM
					tcontentcategories
				WHERE
					siteID = <cfqueryparam value="#arguments.destinationSiteID#" cfsqltype="cf_sql_varchar">
				AND
					remoteID = <cfqueryparam value="#rsCategories.categoryID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif not rsCategoryExists.recordCount>
				<cfset data = StructNew() />

				<cfloop list="#rsCategories.columnlist#" index="column" >
					<cfset data[column] = rsCategories[column][currentRow] />
				</cfloop>
				
				<cfset data.categoryID = "" />
				<cfset data.siteID = arguments.destinationSiteID />
				<cfset data.remoteID = rsCategories.categoryID />
				<cfif not len(arguments.parentID)>
					<cfset structDelete(data,"parentID") />
				<cfelse>
					<cfset data.parentID = arguments.parentID />
				</cfif>

				<cfset data.path = "" />
				
				<cfset newCategoryBean = getBean('categoryManager').create(data) />
				<cfset duplicateExternalCategories(arguments.destinationSiteID,arguments.sourceSiteID,rsCategories['categoryID'][currentRow],newCategoryBean.getCategoryID() ) />
			<cfelse>
				<cfset duplicateExternalCategories(arguments.destinationSiteID,arguments.sourceSiteID,rsCategories['categoryID'][currentRow],rsCategoryExists.categoryID ) />
			</cfif>

		</cfloop>
	</cffunction>
	
	<cffunction name="setCategoriesFromExternalAssignments" returntype="any">
		<cfargument name="sourceContentBean">
		<cfargument name="newContentBean">

		<cfset var categoryIterator = arguments.sourceContentBean.getCategoriesIterator() />
		<cfset var categoryBean = "" />
		<cfset var newCategoryBean = "" />
		
		<cfset categoryIterator.setNextN(0) />

		<cfloop condition="#categoryIterator.hasNext()#">
			<cfset categoryBean = categoryIterator.next() />	
			<cfset newCategoryBean = getBean('category').loadBy( remoteID=categoryBean.getCategoryID(),siteID=arguments.newContentBean.getSiteID() ) />
			<cfset arguments.newContentBean.setCategory( newCategoryBean.getCategoryID(),categoryBean.getIsFeature(),categoryBean.getFeatureStart(),categoryBean.getFeatureStop() ) />
		</cfloop>
		
	</cffunction>

</cfcomponent>