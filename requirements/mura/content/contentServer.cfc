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

<cffunction name="forcePathDirectoryStructure" output="false" returntype="any" access="remote">
<cfargument name="cgi_path">
<cfargument name="siteID">
<cfset var qstring="">
<cfset var contentRenderer=application.settingsManager.getSite(arguments.siteID).getContentRenderer()>
<cfset var indexFileLen=0>
<cfset var last=listLast(arguments.cgi_path,"/") >
<cfset var indexFile="" >	

<cfif find(".",last)>
	<cfset indexFile=last>
</cfif>

<cfset indexFileLen=len(indexFile)>

<cfif len(arguments.cgi_path) and right(arguments.cgi_path,1) neq "/"  and (not indexFileLen or indexFileLen and (right(cgi_path,indexFileLen) neq indexFile))>
	<cfif len(cgi.query_string)>
	<cfset qstring="?" & cgi.query_string>
	<cfelse>
	<cfset qstring="" />
	</cfif>
	<cfset getBean('contentRenderer').redirect("#application.configBean.getContext()##contentRenderer.getURLStem(arguments.siteID,url.path)##qstring#")>
</cfif>
</cffunction>

<cffunction name="setCGIPath" output="false" returntype="any" access="remote">
	<cfargument name="siteID"/>
	<cfset var cgi_path="">
	<cfset var parsed_path_info = cgi.path_info>
	
	<cfscript>
	// If the cgi.path_info was empty then double check other cgi variable
	if (not len(parsed_path_info)){
		// iis6 1/ IIRF (Ionics Isapi Rewrite Filter)
		if (structKeyExists(cgi,"http_x_rewrite_url") and len(cgi.http_x_rewrite_url)){ 
			parsed_path_info = listFirst(cgi.http_x_rewrite_url,'?'); 
		} 
		// iis7 rewrite default
		else if (structKeyExists(cgi,"http_x_original_url") and len(cgi.http_x_original_url)){ 
			parsed_path_info = listFirst(cgi.http_x_original_url,"?");
		} 
		// apache default
		else if (structKeyExists(cgi,"request_uri") and len(cgi.request_uri)){ 
			parsed_path_info = listFirst(cgi.request_uri,'?'); 
		} 
		// apache fallback
		else if (structKeyExists(cgi,"redirect_url") and len(cgi.redirect_url)){ 
			parsed_path_info = listFirst(cgi.redirect_url,'?');
		} 
	}
	</cfscript>
	<cfif not len(parsed_path_info) and isDefined("url.path")>
		<cfset parsed_path_info = url.path>
	</cfif>
	<cfif len(getContextRoot()) and getContextRoot() NEQ "/">
		<cfset parsed_path_info = replace(parsed_path_info,getContextRoot(),"")/>
	</cfif>
	<cfif len(application.configBean.getContext())>
		<cfset parsed_path_info = replace(parsed_path_info,application.configBean.getContext(),"")/>
	</cfif>
	<cfif isDefined('arguments.siteid') && listFirst(parsed_path_info,"/") eq arguments.siteID>
		<cfset parsed_path_info=listRest(parsed_path_info,"/")>
	</cfif>
	<cfif listFirst(parsed_path_info,"/") eq "index.cfm">
		<cfset parsed_path_info=listRest(parsed_path_info,"/")>
	</cfif>
	<cfif parsed_path_info eq cgi.script_name>
		<cfset cgi_path=""/>
	<cfelse>
		<cfset cgi_path=parsed_path_info />
	</cfif>
	
	<cfif left(cgi_path,1) neq "/">
		<cfset cgi_path = "/" & cgi_path />
	</cfif>
	
	<cfif isDefined('arguments.siteid') && left(cgi_path,1) eq "/" and cgi_path neq "/">
		<cfset url.path=right(cgi_path,len(cgi_path)-1) />
	</cfif>
	<cfreturn cgi_path>
</cffunction>

<cffunction name="bindToDomain" output="false" returntype="any" access="remote">
	<cfargument name="isAdmin" required="true" default="false">
	<cfargument name="domain" required="true" default="#cgi.http_host#">
	<cfset var siteID= "" />
	<cfset var rsSites=application.settingsManager.getList(sortBy="orderno") />
	<cfset var site="">
	<cfset var i="">
	<cfset var lineBreak=chr(13)&chr(10)>
	<cfset var checkDomain=listFirst(arguments.domain,":")>
	
	<cfif not len(checkDomain)>
		<cfset checkDomain=cgi.server_name>
	</cfif>
	<!--- check for exact host match to find siteID --->
	<cfloop query="rsSites">
	<cfset site=application.settingsManager.getSite(rsSites.siteID)>
	<cftry>
	<cfif site.isValidDomain(domain:checkDomain, mode:"complete")>
		<cfreturn rsSites.siteid>
	</cfif>
	<cfcatch></cfcatch>
	</cftry>
	</cfloop>
	
	<!--- if not found look for a partial match and redirect--->
	<cfloop query="rssites">
	<cfset site=application.settingsManager.getSite(rsSites.siteID)>
	<cftry>
	<cfif site.isValidDomain(domain:checkDomain, mode:"partial")>
		<cfif arguments.isAdmin>
			<cfreturn rsSites.siteid>
		<cfelse>
			<cflocation addtoken="no" statuscode="301" url="#application.settingsManager.getSite(rsSites.siteID).getScheme()#://#application.settingsManager.getSite(rsSites.siteID).getDomain()##application.configBean.getContext()#">
		</cfif>
	</cfif>
	<cfcatch></cfcatch>
	</cftry>
	</cfloop>
	
	<!--- if still not found site the siteID to default --->
	<cfif checkDomain eq application.configBean.getAdminDomain()>
		<cfif arguments.isAdmin>
			<cfreturn "--none--">	
		<cfelse>
			<cfset getBean('contentRenderer').redirect("#application.configBean.getContext()#/admin/")>
		</cfif>
	<cfelse>
		<cfreturn rsSites.siteID>
	 </cfif>

</cffunction>

<cffunction name="parseURL" output="false" returntype="any" access="remote">
	<cfset var last="">
	<cfset var theStart=0>
	<cfset var trimLen=0>
	<cfset var tempfilename="">
	<cfset var indexFile="">
	<cfset var thelen=0>
	<cfset var item="">
	<cfset var n="">
	<cfset var rsRedirect="">
	
	<cfif isDefined('url.path') and url.path neq application.configBean.getContext() & application.configBean.getStub() & "/">
	
		<cfset last=listLast(url.path,"/") />
		
		<cfif not structKeyExists(request,"preformated")>
			<cfif find(".",last)>
				<cfif last eq 'index.json'>
		 			<cfset request.returnFormat="JSON">
		 		</cfif>
				<cfset indexFile=last>
			</cfif>
			<cfif last neq indexFile and right(url.path,1) neq "/">
				<cfset getBean('contentRenderer').redirect("#url.path#/")>
			</cfif>
		</cfif>
		
		<cfif isValid("UUID",last)>
			<cfquery name="rsRedirect" datasource="#application.configBean.getReadOnlyDatasource()#"  username="#application.configBean.getReadOnlyDbUsername()#" password="#application.configBean.getReadOnlyDbPassword()#">
			select * from tredirects where redirectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#last#">
			</cfquery>
			
			<cfif rsRedirect.url neq ''>
				<cflocation url="#rsRedirect.url#" addtoken="false">
			</cfif>
		</cfif>
		
		<cfset theStart = find(application.configBean.getStub(),url.path)>
		<cfif theStart>
			<cfset url.path=mid(url.path,theStart,len(url.path)) />
		</cfif>
		
		<cfset trimLen=len(application.configBean.getStub())+1 />
		<cfset tempfilename=right(url.path,len(url.path)-trimLen) />
		<cfset request.siteid=listFirst(tempfilename,"/") />
		<cfset request.currentFilename="" />
		
		<cftry>
			<cfset application.settingsManager.getSite(request.siteid) />
			<cfcatch>
				<cflocation url="/" addtoken="false">
			</cfcatch>
		</cftry>
		
		<cfif listLen(tempfilename,'/') gt 1>
			<cfset theLen=listLen(tempfilename,'/')/>
			<cfloop from="2" to="#theLen#" index="n">
			<cfset item=listgetat(tempfilename,n,"/")/>
			<cfif not find(".",item)>
				<cfset request.currentFilename=listappend(request.currentFilename,item,"/") />
			</cfif>
			</cfloop>
		</cfif>
		
		<cfif right(request.currentFilename,1) eq "/">
			<cfset request.currentFilename=left(request.currentFilename,len(request.currentFilename)-1)/>
		</cfif>
		
		<cfset request.servletEvent = createObject("component","mura.servletEvent").init() />
		
		<cfset application.pluginManager.announceEvent('onSiteRequestInit',request.servletEvent)/>
		
		<cfset parseCustomURLVars(request.servletEvent)>
		
		<cfreturn doRequest(request.servletEvent)>
		
	<cfelse>
		<cfset redirect()>
	</cfif> 
	
</cffunction>

<cffunction name="parseURLLocal" output="false" returntype="any" access="remote">
	<cfset var siteID="">
	<cfset var cgi_path="">
	<cfparam name="url.path" default="" />
	
	<cfset siteID = listGetAt(cgi.script_name,listLen(cgi.script_name,"/")-1,"/") />
	<cfset cgi_path=setCGIPath(siteId)>

	<cfset forcePathDirectoryStructure(cgi_path,siteID)>
	
	<cfif not len(cgi_path)>
		<cfset url.path="#application.configBean.getStub()#/#siteID#/" />
	<cfelse>
		<cfif not listFirst(url.path,"/") eq siteid>
			<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
		<cfelse>
			<cfset url.path="#application.configBean.getStub()#/#siteID#/" />
		</cfif>
	</cfif>
	
	<cfset request.preformated=true/>
	
	<cfreturn parseURL()>
</cffunction>

<cffunction name="parseURLRoot" output="false" returntype="any" access="remote">
	<cfset var cgi_path="">
	<cfset var siteid=bindToDomain()>
	
	<cfparam name="url.path" default="" />
	
	<cfset cgi_path=setCGIPath(siteId)>

	<cfset forcePathDirectoryStructure(cgi_path,siteID)>
	
	<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
	<cfset request.preformated=true/>

	<cfif listLast(url.path,'/') eq 'index.json'>
		<cfset request.returnFormat="JSON">
	</cfif>
	
	<cfreturn parseURL()>
</cffunction>

<cffunction name="parseURLRootStub" output="false" returntype="any" access="remote">
	<cfset var urlStem="">
	<cfset var last="">
	<cfset var siteid=bindToDomain()>
	<cfset var rtrim=0>
	<cfset var indexFile="" >
	
	<cfparam name="url.path" default="" />
	<cfset urlStem=application.configBean.getContext() & application.configBean.getStub() & "/" & siteid />

	<cfif listFind("/go,/go/",url.path)>
		<cfset getBean('contentRenderer').redirect("/")>
	</cfif>

	<cfset rtrim=len(url.path)-len(application.configBean.getContext() & application.configBean.getStub()) - 1>
	<cfif rtrim lte 0>
		<cfset url.pathIsComplete=false />
	<cfelseif left(url.path,len(urlStem)) neq urlStem>
	<cfset url.path=right(url.path,len(url.path)-len(application.configBean.getContext() & application.configBean.getStub()) - 1)>
	<cfset url.pathIsComplete=false />
	<cfelse>
	<cfset url.pathIsComplete=true />
	</cfif>
	
	<cfif len(url.path)>
		<cfset last=listLast(url.path,"/") />
		
		<cfif find(".",last)>
			<cfif last eq 'index.json'>
	 			<cfset request.returnFormat="JSON">
	 		</cfif>
			<cfset indexFile=last>
		</cfif>
		
		<cfif last neq indexFile and right(url.path,1) neq "/">
			<cfset getBean('contentRenderer').redirect("#application.configBean.getStub()#/#url.path#/")>
		</cfif>
	</cfif>
	
	<cfif not url.pathIsComplete>
	<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
	</cfif>
	
	<cfset request.preformated=true/>

<cfreturn parseURL()>
</cffunction>

<cffunction name="Redirect" output="false" returntype="any">

	<cfset var rsSites=application.settingsManager.getList(sortBy="orderno") />
	<cfset var site="">
	<cfloop query="rssites">
	<cfset site=application.settingsManager.getSite(rsSites.siteID)>
	<cftry>
	<cfif site.isValidDomain(domain:listFirst(cgi.http_host,":"))>
	<cfset getBean('contentRenderer').redirect("#site.getContext()##site.getContentRenderer().getURLStem(site.getSiteID(),"")#")>
	</cfif>
	<cfcatch></cfcatch>
	</cftry>
	</cfloop>
	
	<cfif listFirst(cgi.http_host,":") eq application.configBean.getAdminDomain()>
		<cfset getBean('contentRenderer').redirect("#application.configBean.getContext()#/admin/")>
	<cfelse>
		<cfset site=application.settingsManager.getSite(rsSites.siteID)>
		<cfset getBean('contentRenderer').redirect("#site.getWebPath(complete=1)##site.getContentRenderer().getURLStem(site.getSiteID(),'')#")>
	</cfif>
	
</cffunction>

<cffunction name="renderFilename" output="true" access="public">
	<cfargument name="filename" default="">
	<cfargument name="validateDomain" default="true">
	<cfargument name="parseURL" default="true">
	<cfset var fileoutput="">

	<cfset url.path=arguments.filename>
	<cfset var last=listLast(arguments.filename,"/")>

 	<cfif find(".",last)>
 		<cfif last eq 'index.json'>
 			<cfset request.returnFormat="JSON">
 		</cfif>
 		<cfset arguments.filename=listDeleteAt(arguments.filename,listLen(arguments.filename,"/"),"/")>
 	</cfif>
 
	<cfset request.siteid = bindToDomain()>
	<cfset request.servletEvent = createObject("component","mura.servletEvent").init() />
	<cfset request.servletEvent.setValue("muraValidateDomain",arguments.validateDomain)>
	<cfset request.servletEvent.setValue("currentfilename",arguments.filename)>
	<cfset request.servletEvent.setValue("currentfilenameadjusted",arguments.filename)>
	<cfif arguments.parseURL>
		<cfset parseCustomURLVars(request.servletEvent)>
	</cfif>
	<cfset fileOutput=doRequest(request.servletEvent)>	
	<cfcontent reset="true"><cfoutput>#fileOutput#</cfoutput>
	<cfabort>

</cffunction>

<cffunction name="render404" output="true" access="public">
	<cfheader statuscode="404" statustext="Content Not Found" />
	<!--- Must reset the linkservID to prevent recursive 404s --->
	<cfset request.linkServID=""> 
	<cfset renderFilename("404",true,false)> 
</cffunction>

<cffunction name="parseCustomURLVars" output="false">
<cfargument name="event">
	<cfset var categoryFilename="">
	<cfset var categoryBean="">
	<cfset var i="">
	<cfset var dateArray=arrayNew(1)>
	<cfset var categoryArray=arrayNew(1)>
	<cfset var refArray=arrayNew(1)>
	<cfset var fileArray=arrayNew(1)>
	<cfset var currentArrayName="fileArray">
	<cfset var currentItem="">
	<cfset var currentFilename=arguments.event.getValue('currentFilename')>	
	<cfset var currentParam="">
	
	<cfloop from="1" to="#listLen(currentFilename,'/')#" index="i">
		<cfset currentItem=listGetAt(currentFilename,i,'/')>
		<cfif listFindNoCase(application.configBean.getCustomURLVarDelimiters(),currentItem,"^")>
			<cfset currentItem="params">
		</cfif>
		<cfif listFindNoCase('date,category,params,tag,linkservid,showmeta,ref',currentItem)>
			<cfset currentArrayName="#currentItem#Array">
		<cfelseif currentArrayName eq "paramsArray">
			<cfif len(currentParam)>
				<cfset arguments.event.setValue(currentParam,currentItem)>
				<cfset currentParam="">
			<cfelse>
				<cfset currentParam=currentItem>
			</cfif>
		<cfelseif currentArrayName eq "tagArray">
			<cfset arguments.event.setValue("display","search")>
			<cfset arguments.event.setValue("newSearch","true")>
			<cfset arguments.event.setValue("tag",currentItem)>
			<cfset currentArrayName="">
		<cfelseif currentArrayName eq "linkServIDArray">
			<cfset arguments.event.setValue("linkServID",currentItem)>
			<cfset currentArrayName="">
		<cfelseif currentArrayName eq "showmetaArray">
			<cfset arguments.event.setValue("showmeta",currentItem)>
			<cfset currentArrayName="">
		<cfelseif len(currentArrayName)>
			<cfset arrayAppend(evaluate('#currentArrayName#'),currentItem)>	
		</cfif>

	</cfloop>
	
	<cfif arrayLen(refArray)>
		<cfset arguments.event.setValue("currentFilenameAdjusted",arrayToList(refArray,"/"))>
	<cfelse>
		<cfset arguments.event.setValue("currentFilenameAdjusted",arrayToList(fileArray,"/"))>
	</cfif>
	
	<cfif arrayLen(categoryArray)>
		<cfset categoryBean=getBean("category").loadBy(filename=arrayToList(categoryArray,"/"), siteID=arguments.event.getValue('siteid'))>
		<cfset arguments.event.setValue('categoryID',categoryBean.getCategoryID())>
		<cfset arguments.event.setValue('currentCategory',categoryBean)>
	</cfif>	
	
	<cfif arrayLen(dateArray)>
		<cfif arrayLen(dateArray) gte 1 and isNumeric(dateArray[1])>
			<cfset arguments.event.setValue("year",dateArray[1])>
			<cfset arguments.event.setValue("filterBy","releaseYear")>		
		</cfif>
			
		<cfif arrayLen(dateArray) gte 2 and isNumeric(dateArray[2])>
			<cfset arguments.event.setValue("month",dateArray[2])>
			<cfset arguments.event.setValue("filterBy","releaseMonth")>		
		</cfif>
			
		<cfif arrayLen(dateArray) gte 3 and isNumeric(dateArray[3])>
			<cfset arguments.event.setValue("day",dateArray[3])>	
			<cfset arguments.event.setValue("filterBy","releaseDate")>	
		</cfif>
	</cfif>

</cffunction>

<cffunction name="handleAPIRequest" output="false">
	<cfargument name="path" default="#cgi.path_info#">
	<cfset var jsonendpoint="/_api/json/v1">
	<cfset var ajaxendpoint="/_api/ajax/v1">
	<cfset var feedendpoint="/_api/feed/v1">
	<cfset var fileendpoint="/_api/render/">
	<cfset var emailendpoint="/_api/email/trackopen">
	<cfset var sitemonitorendpoint="/_api/sitemonitor">

	<cfset var legacyfeedendpoint="/tasks/feed">
	<cfset var legacyfileendpoint="/tasks/render/">
	<cfset var legacywidgetendpoint="/tasks/widgets/">

	<cfif left(path,len(jsonendpoint)) eq jsonendpoint or left(path,len(ajaxendpoint)) eq ajaxendpoint>
		<cfset request.muraAPIRequest=true>
		<cfif listLen(path,'/') gte 4>
			<cfreturn getBean('settingsManager').getSite(listGetAt(path,4,'/')).getApi('json','v1').processRequest(arguments.path)>	
		<cfelseif isDefined('form.siteid')>
			<cfreturn getBean('settingsManager').getSite(form.siteid).getApi('json','v1').processRequest(arguments.path)>	
		<cfelseif isDefined('url.siteid')>
			<cfreturn getBean('settingsManager').getSite(url.siteid).getApi('json','v1').processRequest(arguments.path)>	
		<cfelse>
			<cfreturn getBean('settingsManager').getSite('default').getApi('json','v1').processRequest(arguments.path)>	
		</cfif>
	<cfelseif isDefined('url.feedid') and (left(path,len(feedendpoint)) eq feedendpoint or left(path,len(legacyfeedendpoint)) eq legacyfeedendpoint)>
		<cfif listLen(path,'/') gte 4>
			<cfreturn getBean('settingsManager').getSite(listGetAt(path,4,'/')).getApi('feed','v1').processRequest(arguments.path)>	
		<cfelseif isDefined('form.siteid')>
			<cfreturn getBean('settingsManager').getSite(form.siteid).getApi('feed','v1').processRequest(arguments.path)>	
		<cfelseif isDefined('url.siteid')>
			<cfreturn getBean('settingsManager').getSite(url.siteid).getApi('feed','v1').processRequest(arguments.path)>	
		<cfelse>
			<cfreturn getBean('settingsManager').getSite('default').getApi('feed','v1').processRequest(arguments.path)>	
		</cfif>
	<cfelseif isDefined('url.emailid') and left(path,len(emailendpoint)) eq emailendpoint>
		<cfset application.emailManager.track(url.emailid,url.email,'emailOpen')>
		<cfset var theImg="">
		<cffile action="readbinary" variable="theImg" file="#GetDirectoryFromPath('/mura/email/')#empty.gif">
		<cfcontent type="image/gif" variable="#theImg#" reset="yes">
		<cfreturn>
	<cfelseif isDefined('url.fileid') and listLen(path,'/') gte 2 and (left(path,len(fileendpoint)) eq fileendpoint or left(path,len(legacyfileendpoint)) eq legacyfileendpoint)>
		<cfswitch expression="#listGetAt(path,3,'/')#">
			<cfcase value="file">
				<cfparam name="url.method" default="inline">
				<cfparam name="url.size" default="">
				<cfreturn application.contentRenderer.renderFile(url.fileID,url.method,url.size)>
			</cfcase>
			<cfcase value="small">
				<cfreturn application.contentRenderer.renderSmall(url.fileID)>
			</cfcase>
			<cfcase value="medium">
				<cfreturn application.contentRenderer.renderMedium(url.fileID)>
			</cfcase>
		</cfswitch>
	<cfelseif left(path,len(sitemonitorendpoint)) eq sitemonitorendpoint>
		<cfset var theTime=now()/>
		<cfset var emailList="" />
		<cfset var theemail="" />
		<cfset var site="" />
		<cfset var rsChanges="" />

		<cfparam name="application.lastMonitored" default="#dateadd('n',-1,theTime)#"/>
		<cfset var addPrev=minute(application.lastMonitored) neq minute(dateadd("n",-30,theTime))/>

		<cfif addPrev>
			<cfset application.contentManager.sendReminders(dateadd("n",-30,theTime)) />
		</cfif>

		<cfset application.contentManager.sendReminders(theTime) />

		<cfset application.emailManager.send() />

		<cfset application.changesetManager.publishBySchedule()>

		<cfloop collection="#application.settingsManager.getSites()#" item="site"> 
			<cfset theEmail = application.settingsManager.getSite(site).getMailServerUsername() />
			<cfif application.settingsManager.getSite(site).getEmailBroadcaster()>
				<cfif not listFind(emailList,theEmail)>
					<cfset application.emailManager.trackBounces(site) />
					<cfset listAppend(emailList,theEmail) />
				</cfif>
			</cfif>
			<cfif application.settingsManager.getSite(site).getFeedManager()>
				<cfset application.feedManager.doAutoImport(site)>
			</cfif>
		</cfloop>

		<cfquery name="rsChanges" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			select tcontent.siteid, tcontent.contentid from tcontent inner join tcontent tcontent2 on tcontent.parentid=tcontent2.contentid 
			where tcontent.approved=1 and tcontent.active=1 and tcontent.display=2 and tcontent2.type <> 'Calendar'
			and ((tcontent.displaystart >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#application.lastmonitored#">
			and tcontent.displaystart <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#theTime#">)
			or
			(tcontent.displaystop >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#application.lastmonitored#">
			and tcontent.displaystop <=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#theTime#">))
			group by tcontent.siteid, tcontent.contentid
		</cfquery>

		<cfif rsChanges.recordcount>
			<cfloop query="rsChanges">
				<cfset application.serviceFactory
					.getBean('contentManager')
						.purgeContentCache(
							contentBean=application.serviceFactory
								.getBean('content')
								.loadBy(
									contentID=rsChanges.contentid,
									siteid=rsChanges.siteid
								)
						)>
			</cfloop>

			<cfquery name="rsChanges" dbtype="query">
				select distinct siteid from rsChanges
			</cfquery>
			<cfloop query="rsChanges">
				<cfset application.settingsManager.getSite(rsChanges.siteid).purgeCache() />
			</cfloop>
		</cfif>

		<cfset application.clusterManager.clearOldCommands()>

		<cfset application.serviceFactory.getBean('$').announceEvent('onGlobalMonitor') />

		<cfset var rsSites=application.serviceFactory.getBean('settingsManager').getList()>

		<cfloop query="rsSites">
			<cfset application.serviceFactory.getBean('$').init(rsSites.siteid).announceEvent('onSiteMonitor') />
		</cfloop>

		<cfset application.lastMonitored=theTime/>

		<cfreturn "">
	<cfelseif left(path,len(legacywidgetendpoint)) eq legacywidgetendpoint>
		<cflocation statuscode="301" addtoken="false" url="#replaceNoCase(cgi.path_info,'/tasks/widgets/','/requirements/')#">
	</cfif>
</cffunction>

<cffunction name="handleRootRequest" output="false">
	<cfset var pageContent="">
	<cfset var path=setCGIPath()>

	<cfif listFindNoCase('_api,tasks',listFirst(path,'/'))>
		<cfreturn handleAPIRequest(path)>
	<cfelse>
		
		<cfif application.configBean.getSiteIDInURLS()>
			<cfset application.contentServer.redirect()>
		<cfelse>
			<cfif len(application.configBean.getStub())>
				<cfset pageContent = application.contentServer.parseURLRootStub()>
			<cfelse>	
				<cfset pageContent = application.contentServer.parseURLRoot()>
			</cfif>
			<cfreturn pageContent>
		</cfif> 
	</cfif>
		
</cffunction>

<cffunction name="doRequest" output="false" returntype="any">
<cfargument name="event">
	<cfset var response=""/>
	<cfset var servlet = "" />
	<cfset var previewData=""/>
	<cfset var changeset=""/>

	<cfset request.muraFrontEndRequest=true>
	<cfparam name="request.returnFormat" default="HTML">

	<cfparam name="session.siteid" default="#arguments.event.getValue('siteID')#">

	<cfif fileExists(expandPath("/#application.configBean.getWebRootMap()#/#arguments.event.getValue('siteid')#/includes/servlet.cfc"))>
		<cfset servlet=createObject("component","#application.configBean.getWebRootMap()#.#arguments.event.getValue('siteid')#.includes.servlet").init(arguments.event)>
	<cfelse>
		<cfset arguments.event.getHandler("standardSetContentRenderer").handle(arguments.event)>
	</cfif>

	<cfset arguments.event.setValue("localHandler",application.settingsManager.getSite(arguments.event.getValue('siteID')).getLocalHandler())>
	
	<cfset application.pluginManager.announceEvent('onSiteRequestStart',arguments.event)/>

	<cfif structKeyExists(url,"changesetID")>
		<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
		<cfset getBean('changesetManager').setSessionPreviewData(changesetid=url.changesetID,append=isDefined('url.append'))>
	</cfif>
	
	<cfset previewData=getCurrentUser().getValue("ChangesetPreviewData")>
	<cfset request.muraChangesetPreview=isStruct(previewData) and previewData.siteID eq arguments.event.getValue("siteID")>

	<cfif request.muraChangesetPreview>
		<cfif isdefined('previewData.showToolbar')>
			<cfset request.muraChangesetPreviewToolbar=previewData.showToolbar>
		<cfelse>
			<cfset request.muraChangesetPreviewToolbar=true>
		</cfif>

		<cfparam name="previewData.lastApplied" default="#now()#">

		<cfif isdefined('previewData.changesetIDList')>
			<cfset local.reloaded=false>
			<cfloop list="#previewData.changesetIDList#" index="local.i">
				<cfif not local.reloaded and getBean('changeset').loadBy(changesetID=local.i,siteid=previewData.siteID).getLastUpdate() gt previewData.lastApplied>
					<cfloop from="1" to="#listLen(previewData.changesetIDList)#" index="local.i2">
						<cfset getBean('changesetManager').setSessionPreviewData(changesetid=listGetAt(previewData.changesetIDList,local.i2),append=local.reloaded,showToolBar=request.muraChangesetPreviewToolbar)>	
						<cfset local.reloaded=true>
					</cfloop>	
				</cfif>
			</cfloop>
			
			<cfset request.muraOutputCacheOffset=hash(previewData.changesetIDList)>
		<cfelse>
			<cfif getBean('changeset').loadBy(changesetID=previewData.changesetid,siteid=previewData.siteID).getLastUpdate() gt previewData.lastApplied>
				<cfset getBean('changesetManager').setSessionPreviewData(changesetid=previewData.changesetid,append=isDefined('url.append'),showToolBar=request.muraChangesetPreviewToolbar)>	
			</cfif>
			<cfset request.muraOutputCacheOffset=hash(previewData.changesetid)>
		</cfif>
	</cfif>

	<cfif isdefined("servlet.onRequestStart")>
		<cfset servlet.onRequestStart()>
	</cfif>
	
	<cfif isdefined("servlet.doRequest")>
		<cfset response=servlet.doRequest()>
	<cfelse>
		<cfset arguments.event.getValidator("standardEnableLockdown").validate(arguments.event)> 
		
		<cfset arguments.event.getHandler("standardSetContent").handle(arguments.event)>
	
		<cfset arguments.event.getValidator("standardWrongDomain").validate(arguments.event)> 
		
		<cfif isdefined('request.muraJSONRedirectURL')>
			<cfset var apiUtility=application.settingsManager.getSite(request.siteid).getApi('json','v1')>
			<cfset getpagecontext().getresponse().setcontenttype('application/json; charset=utf-8')>
			<cfreturn apiUtility.getSerializer().serialize({data={redirect=request.muraJSONRedirectURL}})>
		</cfif>

		<cfset arguments.event.getValidator("standardTrackSession").validate(arguments.event)>
		
		<cfset arguments.event.getHandler("standardSetIsOnDisplay").handle(arguments.event)>
		
		<cfset arguments.event.getHandler("standardDoActions").handle(arguments.event)>

		<cfif isdefined('request.muraJSONRedirectURL')>
			<cfset var apiUtility=application.settingsManager.getSite(request.siteid).getApi('json','v1')>
			<cfset getpagecontext().getresponse().setcontenttype('application/json; charset=utf-8')>
			<cfreturn apiUtility.getSerializer().serialize({data={redirect=request.muraJSONRedirectURL}})>
		</cfif>

		<cfset arguments.event.getHandler("standardSetPermissions").handle(arguments.event)>
		
		<cfif isdefined('request.muraJSONRedirectURL')>
			<cfset var apiUtility=application.settingsManager.getSite(request.siteid).getApi('json','v1')>
			<cfset getpagecontext().getresponse().setcontenttype('application/json; charset=utf-8')>
			<cfreturn apiUtility.getSerializer().serialize({data={redirect=request.muraJSONRedirectURL}})>
		</cfif>

		<cfset arguments.event.getValidator("standardRequireLogin").validate(arguments.event)>
		
		<cfif isdefined('request.muraJSONRedirectURL')>
			<cfset var apiUtility=application.settingsManager.getSite(request.siteid).getApi('json','v1')>
			<cfset getpagecontext().getresponse().setcontenttype('application/json; charset=utf-8')>
			<cfreturn apiUtility.getSerializer().serialize({data={redirect=request.muraJSONRedirectURL}})>
		</cfif>
		
		<cfset arguments.event.getHandler("standardSetLocale").handle(arguments.event)>
		
		<cfset arguments.event.getValidator("standardMobile").validate(arguments.event)>

 		<cfset arguments.event.getHandler("standardSetCommentPermissions").handle(arguments.event)>
	 	
	 	<cfset arguments.event.getHandler("standardDoResponse").handle(arguments.event)>
		
		<cfset response=arguments.event.getValue("__MuraResponse__")>
	</cfif>

	<cfif isdefined("servlet.onRequestEnd")>
		<cfset servlet.onRequestEnd()>
	</cfif>

	<cfset application.pluginManager.announceEvent('onSiteRequestEnd',arguments.event)/>
	<cfif isDefined("session.mura.showTrace") and session.mura.showTrace and listFindNoCase(session.mura.memberships,"S2IsPrivate")>
		<cfset response=replaceNoCase(response,"</html>","#application.utility.dumpTrace()#</html>")>
	</cfif>

	<cfif isdefined('response')>
		<cfif arguments.event.getContentRenderer().getSuppressWhitespace()>
			<cfsavecontent variable="response"><cfprocessingdirective suppressWhitespace="true"><cfoutput>#response#</cfoutput></cfprocessingdirective></cfsavecontent>
		</cfif>
		<cfreturn response>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="getURLStem" access="public" output="false" returntype="string">
	<cfargument name="siteID">
	<cfargument name="filename">
	<cfargument name="siteidinurls" default="#application.configBean.getSiteIDInURLS()#">
	<cfargument name="indexfileinurls" default="#application.configBean.getIndexFileInURLS()#">
	<cfargument name="hashURLS" default="#application.configBean.getHashURLS()#">

	<cfif len(arguments.filename)>
		<cfif left(arguments.filename,1) neq "/">
			<cfset arguments.filename= "/" & arguments.filename>
		</cfif>
		<cfif not arguments.hashURLS and right(arguments.filename,1) neq "/">
			<cfset arguments.filename=  arguments.filename & "/">
		</cfif>
	</cfif>

	<cfif arguments.hashURLs>
		<cfset var filenamePrefix='/##'>
	<cfelse>
		<cfset var filenamePrefix=''>
	</cfif>

	<cfif not arguments.siteidinurls>
		<cfif arguments.filename neq ''>
			<cfif arguments.indexfileinurls and not request.muraExportHTML>
				<cfreturn "/index.cfm" & filenamePrefix & arguments.filename />
			<cfelse>
				<cfreturn filenamePrefix & arguments.filename />
			</cfif>	
		<cfelse>
			<cfreturn "/" />
		</cfif>
	<cfelse>
		<cfif arguments.filename neq ''>
			<cfif arguments.indexfileinurls>
				<cfreturn "/" & arguments.siteID & "/index.cfm" & filenamePrefix & arguments.filename />
			<cfelse>
				<cfreturn "/" & arguments.siteID & filenamePrefix & arguments.filename />
			</cfif>
		<cfelse>
			<cfreturn "/" & arguments.siteID & "/" />
		</cfif>
	</cfif>
</cffunction>

</cfcomponent>