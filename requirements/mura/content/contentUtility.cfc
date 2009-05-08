<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (“GPL”) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception,  the copyright holders of Mura CMS grant you permission
to combine Mura CMS  with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="contentDAO" type="any" required="yes"/>
		<cfargument name="configBean" type="any" required="yes"/>
		<cfargument name="permUtility" type="any" required="yes"/>
		<cfargument name="settingsManager" type="any" required="yes"/>
		<cfargument name="fileManager" type="any" required="yes"/>
		<cfargument name="contentRenderer" type="any" required="yes"/>
		<cfargument name="mailer" type="any" required="yes"/>
		
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.contentDAO=arguments.contentDAO />
		<cfset variables.permUtility=arguments.permUtility />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.fileManager=arguments.fileManager />
		<cfset variables.contentRenderer=arguments.contentRenderer />
		<cfset variables.dsn=variables.configBean.getDatasource()/>
		<cfset variables.filedelim=variables.configBean.getFileDelim() />
		<cfset variables.mailer=arguments.mailer />
<cfreturn this />
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
	
	<cfquery name="rsAdmin" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT tusers.UserID
	from tusers
	WHERE perm=1 and 
	type=1 and 
	siteid='#variables.settingsManager.getSite(arguments.crumbdata[1].siteid).getPrivateUserPoolID()#'
	and groupname='Admin'
	</cfquery>
	
	<cfquery name="rsprenotify" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.Email, tusersmemb.GroupID, 'Editor' AS Type
	FROM tusers INNER JOIN tusersmemb ON tusers.UserID = tusersmemb.UserID
	WHERE tusers.Email Is Not Null 
	AND 
	(tusersmemb.GroupID In (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAdmin.userID#"/><cfloop list="#permStruct.editorList#" index="E">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#E#"/></cfloop>)
	<cfif isuserInRole('s2')>or tusers.s2=1</cfif>)
	
	<cfif authorLen>
	union
	
	SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.Email, tusersmemb.GroupID, 'Author' AS Type
	FROM tusers INNER JOIN tusersmemb ON tusers.UserID = tusersmemb.UserID
	WHERE tusers.Email Is Not Null 
	and siteid='#variables.settingsManager.getSite(arguments.crumbdata[1].siteid).getPrivateUserPoolID()#'
	AND 
	tusersmemb.GroupID In (<cfloop list="#permStruct.authorList#" index="A"><cfqueryparam cfsqltype="cf_sql_varchar" value="#A#"/><cfif authorIdx lt authorLen>,<cfset authorIdx=authorIdx+1></cfif></cfloop>)
	</cfif>
	
	</cfquery>
	
	<cfquery name="rs" dbtype="query">
	select * from rsprenotify order by lname, fname
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getMailingLists" returntype="query" access="public" output="false">
		<cfargument name="siteid" type="string" required="true">
		<cfset var rs = "">
		
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Select mlid, name from tmailinglist  where 
	siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and isPublic=1 order by name 
	</cfquery>
		
		<cfreturn rs />
</cffunction>

<cffunction name="getTemplates" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" required="true">

	<cfreturn variables.settingsManager.getSite(arguments.siteID).getTemplates() />
</cffunction>

<cffunction name="getRestrictGroups" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfset var rs = "">
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select groupname, userid,isPublic from tusers where type=1 and 
	(
	(isPublic=1  and siteid='#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#') 
	or
	(isPublic=0  and siteid='#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#')
	)
	and groupname != 'Admin'
	order by isPublic desc, groupname
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="doesFileExist" returntype="boolean" access="public" output="false">
		<cfargument name="siteid" type="string" required="true">
		<cfargument name="filename" type="string" required="true">
		<cfset var rs = "">
		<!--- <cfif variables.configBean.getStub() eq ''>
			<cfif directoryExists("#variables.configBean.getWebRoot()##variables.filedelim##arguments.siteid##variables.filedelim##arguments.filename#")>
				<cfreturn true />
			<cfelse>
				<cfreturn false />
			</cfif>
		
		<cfelse> --->
		
			<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			Select contentid from tcontent  where 
			siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/> and filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#"/> and active=1 and type in ('Portal','Page','Calendar','Gallery')
			</cfquery>
			
			<cfif rs.recordcount>
				<cfreturn true />
			<cfelse>
				<cfreturn false />
			</cfif>
		
	<!--- 	</cfif> --->
		
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
		<cflock name="#arguments.contentBean.getfilename()#" type="exclusive" timeout="500">
		<cfset variables.fileManager.deleteAll(arguments.contentBean.getcontentID(),arguments.contentBean.getFileID()) />
		</cflock>
	<cfcatch></cfcatch>
	</cftry>
<cfelseif arguments.contentBean.gettype() eq 'Page' or arguments.contentBean.gettype() eq 'Calendar' or arguments.contentBean.gettype() eq 'Portal' or arguments.contentBean.gettype() eq 'Gallery'>

		<cftry>

			<cfquery name="rsRelated" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select contentid, filename from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getSiteID()#"> 
			and filename like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getfilename()#/%"/>
			and active=1 and type in ('Page','Calendar','Portal','Gallery')
			</cfquery>
			
			
			<cfquery name="rsParent" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			select filename from tcontent where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getsiteID()#"/>
			and contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentBean.getparentID()#"/>
			and active=1 and type in ('Page','Calendar','Portal','Gallery')
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
			       	
								<cfloop condition="#doesFileExist(arguments.contentBean.getsiteid(),tempfile)#">
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

	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontent set filename=replace(filename,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldfilename#/"/>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#/"/>) where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
	and filename like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldfilename#/%"/>
	and active=1 and type in ('Page','Calendar','Portal','Gallery','Link')
	</cfquery>
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontent set filename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#"/> where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/>
	and filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldfilename#"/>
	and active=1 and type in ('Page','Calendar','Portal','Gallery','Link')
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
	
	<cfif arguments.filename neq ''>
	<cfset newfile="#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.filename)#">
	<cfelse>
	<cfset newfile="#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,"")#">
	</cfif>
	
	
	<cfquery name="rslist" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contenthistid, body from tcontent where type in ('Page','Calendar','Portal','Component','Form','Gallery')
	 and body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.oldfilename)#%"/>
	 and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>

	<cfif rslist.recordcount>
			<cfloop query="rslist">
			<cfset newbody=rereplace(rslist.body,"#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.oldfilename)#","#newfile#",'All')>
			<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			update tcontent set body=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newBody#"> where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contenthistID#"/>
			</cfquery>
			</cfloop>
		</cfif>
		
	<cfquery name="rslist" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select contenthistid, summary from tcontent where type in ('Page','Calendar','Portal','Component','Form','Gallery')
	 and summary like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.oldfilename)#%"/>
	 and siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	</cfquery>
	
	<cfif rslist.recordcount>
			<cfloop query="rslist">
			<cfset newSummary=rereplace(rslist.summary,"#variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.siteID,arguments.oldfilename)#","#newfile#",'All')>
			<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			update tcontent set summary= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newSummary#"> where contenthistid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rslist.contenthistid#">
			</cfquery>
			</cfloop>
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
	<cfset var redirectID = createUUID()/>
	<cfset var rsEmail = "" />
	<cfset var mailText="" >
	
	
	<cfquery name="rsList" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select userID, email, fname, lname from tusers where userid
	in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(arguments.data.notify)#">
		<cfif theLen gte 2>
		<cfloop from="2" to="#theLen#" index="i">
		,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.data.notify,i)#">
		</cfloop>
		</cfif>
		)
	</cfquery>
	
	<cfif (structKeyExists(data,"CompactDisplay") and data.compactDisplay eq "true")
		or (structKeyExists(data,"closeCompactDisplay") and data.closeCompactDisplay eq "true")>
		<cfset reviewLink='http://#cgi.SERVER_NAME##variables.configBean.getServerPort()##variables.configBean.getContext()#/#arguments.data.siteid#/?contentID=#arguments.contentBean.getContentID()#&previewID=#arguments.contentBean.getContentHistID()#'>
	<cfelse>
		<cfset reviewLink='http://#cgi.SERVER_NAME##variables.configBean.getServerPort()##variables.configBean.getContext()#/admin/index.cfm?fuseaction=cArch.edit&parentid=#arguments.data.parentid#&&topid=#arguments.data.topid#&siteid=#arguments.data.siteid#&contentid=#arguments.contentBean.getcontentid()#&contenthistid=#arguments.contentBean.getcontenthistid()#&moduleid=#arguments.data.moduleid#&type=#arguments.data.type#&ptype=#arguments.data.ptype#'>
	</cfif>
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tredirects (redirectID,URL,created) values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#redirectID#" >,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#reviewLink#" >,
		#createODBCDateTime(now())#
		)
	</cfquery>
		
<cfif getAuthuser() neq ''>
	<cfquery name="rsemail" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select email, fname, lname from tusers where userid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(getAuthUser(),"^")#">
	</cfquery>
	
	<cfloop query="rslist">
		
		<cfset variables.contentDAO.createContentAssignment(arguments.contentBean,rsList.userID) />
		
		<cfif rsList.email neq ''>
<cfsavecontent variable="mailText"><cfoutput>
#arguments.data.message#
						
Review Link:
http://#cgi.SERVER_NAME##variables.configBean.getServerPort()##variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.contentBean.getSiteID(),redirectID)#
</cfoutput></cfsavecontent>
		
		<cfset variables.mailer.sendText(mailText,
				rsList.email,
				"#rsemail.fname# #rsemail.lname#",
				"Site Content Review",
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
						
Review Link:
http://#cgi.SERVER_NAME##variables.configBean.getServerPort()##variables.configBean.getContext()##variables.contentRenderer.getURLStem(arguments.contentBean.getSiteID(),redirectID)#
</cfoutput></cfsavecontent>
		<cfset variables.mailer.sendText(mailText,
				rsList.email,
				variables.settingsManager.getSite(arguments.contentBean.getsiteid()).getMailServerUsernameEmail(),
				"Site Content Review",
				request.siteid) />
		</cfif>

		</cfloop>
	
</cfif>
	
</cffunction>

<cffunction name="setUniqueFilename" returntype="void" output="false" access="public">
	<cfargument name="contentBean" type="any" />
	<cfset var parentBean=variables.contentDAO.readActive(arguments.contentBean.getParentID(),arguments.contentBean.getSiteID()) />
	<cfset var pass =0 />
	<cfset var tempfile = "">
	
	<!--- start with the menu title --->
	<cfset arguments.contentBean.setfilename(arguments.contentBean.getMenuTitle()) />
	
	<!--- replace some latin based unicode chars with allowable chars --->
	<cfset arguments.contentBean.setfilename(removeUnicode(arguments.contentBean.getFilename())) />
	
	<!--- temporarily escape "-" used for word separation --->
	<cfset arguments.contentBean.setfilename(rereplace(arguments.contentBean.getfilename()," ","svphsv","ALL")) />
	
	<!--- remove all punctuation --->
	<cfset arguments.contentBean.setfilename(rereplace(arguments.contentBean.getfilename(),"[[:punct:]]","","ALL")) />
	
	<!--- escape any remaining unicode chars --->
	<cfset arguments.contentBean.setfilename(urlEncodedFormat(arguments.contentBean.getfilename())) />
	
	<!---  put word separator back in --->
	<cfset arguments.contentBean.setfilename(rereplace(arguments.contentBean.getfilename(),"svphsv","-","ALL")) />
	
	<!--- remove an non alphanumeric chars (most likely %) --->
	<cfset arguments.contentBean.setfilename(lcase(rereplace(arguments.contentBean.getfilename(),"[^a-zA-Z0-9\-]","","ALL"))) />
	<cfset arguments.contentBean.setfilename(lcase(rereplace(arguments.contentBean.getfilename(),"\-+","-","ALL"))) />

	<cfif not len(arguments.contentBean.getfilename()) and arguments.contentBean.getContentID() neq  '00000000000000000000000000000000001'>
		<cfset arguments.contentBean.setfilename("-")/>
	</cfif>
	<cfif arguments.contentBean.getparentid() neq '00000000000000000000000000000000001'>
		<cfset arguments.contentBean.setFilename(parentBean.getfilename() & "/" & arguments.contentBean.getfilename()) />
	</cfif>
	
	<cfset tempfile=arguments.contentBean.getFilename() />
	
			<cfloop condition="#doesFileExist(arguments.contentBean.getsiteid(),tempfile)#" >
				<cfset pass=pass+1>
				<cfset tempfile="#arguments.contentBean.getFilename()##pass#" />
			</cfloop>
								
			<cfif pass>
			<cfset arguments.contentBean.setFilename(tempfile) />
			</cfif>
</cffunction>	

<cffunction name="isOnDisplay" returntype="numeric" output="false" access="public">
			<cfargument name="display"  type="numeric">
			<cfargument name="displaystart"  type="string">
			<cfargument name="displaystop"  type="string">
			<cfargument name="siteid"  type="string">
			<cfargument name="parentid"  type="string">
			<cfargument name="parentType"  type="string" required="yes" default="Page">
		
			<cfset var isOn=1>
		
			<cfswitch expression="#arguments.display#">
					<cfcase value="1">
						<cfset isOn=1>
					</cfcase>
					<cfcase value="0">
						<cfset isOn=0>
					</cfcase>
					<cfcase value="2">
						<cfif arguments.parentType eq 'Calendar' or (arguments.displaystart lte now() and (arguments.displaystop gte now() or arguments.displaystop eq ''))>
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


				<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
	

	<cfquery datasource="#variables.dsn#" name="rsApproval"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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
				
				<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
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

<cffunction name="copy" returntype="void" output="true" access="public">
	<cfargument name="siteid" type="string" />
	<cfargument name="contentID" type="string" />
	<cfargument name="parentID" type="string" />
	
	<cfset var rs1 = "">
	<cfset var strSQL = "">
	<cfset var tableName = "">
	<cfset var counter = 0>
	<cfset var newContentID = createUUID()>
	<cfset var newContentHistID = createUUID()>
	<cfset var newOrderNo = 0>
	<cfset var contentBean = "">
	<cfset var contentBeanParent = "">
	<cfset var contentHistID = "">
	
	<cfset contentBean = variables.contentDAO.readActive(arguments.contentID, arguments.siteID)>
	<!--- <cfset contentBeanParent = variables.contentDAO.readActive(arguments.parentID, arguments.siteID)>--->
	<cfset contentHistID = contentBean.getcontentHistID()>
	
	<!--- tcontent --->
	<!--- <cfif contentBeanParent.getFilename() neq "">
		<cfset contentBean.setUniqueFilename(contentBean)>
	</cfif> --->
	<cfset contentBean.setOrderNo(0)>
	<cfset contentBean.setcontentID(newContentID)>
	<cfset contentBean.setcontentHistID(newContentHistID)>
	<cfset contentBean.setParentID(arguments.parentID)>
	<cfset contentBean.setMenuTitle(contentBean.getMenuTitle() & " - Copy")>
	<cfset setUniqueFilename(contentBean)>
	<cfset variables.contentDAO.create(contentBean)>
	
	<!--- tcontentcategoryassign --->
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentcategoryassign (contentHistID, categoryID, contentID, isFeature, orderno, siteID, featurestart,featurestop)
		select '#newContentHistID#',categoryID,'#newContentID#',isFeature,orderno,siteid,featurestart,featurestop from tcontentcategoryassign
		where siteid='#arguments.siteid#' 
		and contentID='#arguments.contentID#'
		and contentHistID='#contentHistID#'
	</cfquery>
	
	<!--- tcontentrelated --->
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentrelated (contentHistID,relatedID, contentID, siteID)
		select '#newContentHistID#',relatedID,'#newContentID#',siteID from tcontentrelated 
		where siteid='#arguments.siteid#' 
		and contentID='#arguments.contentID#'
		and contentHistID='#contentHistID#'
	</cfquery>
	
	<!--- tcontentobjects --->
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tcontentobjects (contentHistID, objectID, object, contentID, name, orderno, siteid, columnid)
		select '#newContentHistID#',objectid, object, '#newContentID#',name,orderno,siteid,columnid from tcontentobjects
		where siteid='#arguments.siteid#' 
		and contentID='#arguments.contentID#'
		and contentHistID='#contentHistID#'
	</cfquery>

	<!--- tpermissions --->
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tpermissions (contentID, groupID, siteID, type)
		select '#newContentID#', groupID, siteid,type from tpermissions
		where siteid='#arguments.siteid#' 
		and contentID='#arguments.contentID#'
	</cfquery>
	
	<!--- tclassextenddata --->
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into tclassextenddata (baseID,attributeID,siteID,attributeValue)
		select '#newContentHistID#',attributeID,siteID,attributeValue from tclassextenddata
		where baseid='#contentHistID#' 
	</cfquery>

	
</cffunction>

<cffunction name="updateGlobalMaterializedPath" returntype="any" output="false">
<cfargument name="siteID">
<cfargument name="parentID" required="true" default="00000000000000000000000000000000END">
<cfargument name="path" required="true" default=""/>

<cfset var rs="" />
<cfset var newPath = "" />

<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select contentID from tcontent 
where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
and parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#" />
and active=1
</cfquery>

	<cfloop query="rs">
		<cfset newPath=listappend(arguments.path,rs.contentID) />
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontent
		set path=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#newPath#" />
		where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
		and contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contentID#" />
		</cfquery>
		<cfset updateGlobalMaterializedPath(arguments.siteID,rs.contentID,newPath) />
	</cfloop>

</cffunction>

<cffunction name="findAndReplace" returntype="void" output="false">
	<cfargument name="find" type="string" default="" required="true">
	<cfargument name="replace" type="string" default="" required="true">
	<cfargument name="siteID" type="string" default="" required="true">
	<cfset var rs ="" />
	<cfset var newSummary ="" />
	<cfset var newBody ="" />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontent set filename=replace(filename,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.find#"/>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.replace#"/>) where siteid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
	and filename like <cfqueryparam value="%#arguments.find#%" cfsqltype="cf_sql_varchar">
	and active=1 and type in ('Page','Calendar','Portal','Gallery','Link')
	</cfquery>
	
	<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select contenthistid, body from tcontent where body like <cfqueryparam value="%#arguments.find#%" cfsqltype="cf_sql_varchar"> and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		and type in ('Page','Calendar','Portal','Gallery','Link')
	</cfquery>
	
	<cfloop query="rs">
		<cfset newbody = replaceNoCase(BODY,"#arguments.find#","#arguments.replace#","ALL")>
		<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontent set body = <cfqueryparam value="#newBody#" cfsqltype="cf_sql_longvarchar"> where contenthistid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contenthistID#"/>
		</cfquery>
	</cfloop>

	<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select contenthistid, summary from tcontent where summary like <cfqueryparam value="%#arguments.find#%" cfsqltype="cf_sql_varchar"> and siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
		and type in ('Page','Calendar','Portal','Gallery','Link')
	</cfquery>
	
	<cfloop query="rs">
		<cfset newSummary = replaceNoCase(summary,"#arguments.find#","#arguments.replace#","ALL")>
		<cfquery datasource="#variables.dsn#" name="rs"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontent set summary = <cfqueryparam value="#newSummary#" cfsqltype="cf_sql_longvarchar"> where contenthistid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.contenthistID#"/>
		</cfquery>
	</cfloop> 

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
			'#199':'Ç','#200':'È','#201':'É','#202':'Ê','#203':'Ë','#204':'Ì',
			'#205':'Í','#206':'Î','#207':'Ï','#209':'Ñ','#210':'Ò','#211':'Ó',
			'#212':'Ô','#213':'Õ','#214':'Ö','#216':'Ø','#217':'Ù','#218':'Ú',
			'#219':'Û','#220':'Ü','#223':'ß','#224':'à','#225':'á','#226':'â',
			'#227':'ã','#228':'ä','#229':'å','#230':'æ','#231':'ç','#232':'è',
			'#233':'é','#234':'ê','#235':'ë','#236':'ì','#237':'í','#238':'î',
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
		<cfset unicodeArray[11][2]="Ì" />
		<cfset unicodeArray[11][3]="I" />

		<cfset unicodeArray[12][1]=205 />
		<cfset unicodeArray[12][2]="Í" />
		<cfset unicodeArray[12][3]="I" />

		<cfset unicodeArray[13][1]=206 />
		<cfset unicodeArray[13][2]="Î" />
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
		<cfset unicodeArray[37][2]="ì" />
		<cfset unicodeArray[37][3]="i" />

		<cfset unicodeArray[38][1]=237 />
		<cfset unicodeArray[38][2]="í" />
		<cfset unicodeArray[38][3]="i" />

		<cfset unicodeArray[39][1]=238 />
		<cfset unicodeArray[39][2]="î" />
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

</cfcomponent>