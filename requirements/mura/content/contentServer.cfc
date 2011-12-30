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
<cfcomponent extends="mura.cfobject">

<cffunction name="init" output="false" returntype="any">
<cfset variables.Mura=createObject("component","mura.Mura").init()>
<cfreturn this>
</cffunction>

<cffunction name="forcePathDirectoryStructure" output="false" returntype="any" access="remote">
<cfargument name="cgi_path">
<cfargument name="siteID">
<cfset var qstring="">
<cfset var contentRenderer=application.settingsManager.getSite(arguments.siteID).getContentRenderer()>
<cfset var indexFileLen=0>
<cfset var last=listLast(cgi_path,"/") >
<cfset var indexFile="" >	

<cfif find(".",last)>
	<cfset indexFile=last>
</cfif>

<cfset indexFileLen=len(indexFile)>

<cfif len(cgi_path) and right(cgi_path,1) neq "/"  and (not indexFileLen or indexFileLen and (right(cgi_path,indexFileLen) neq indexFile))>
	<cfif len(cgi.query_string)>
	<cfset qstring="?" & cgi.query_string>
	<cfelse>
	<cfset qstring="" />
	</cfif>
	<cfset application.contentRenderer.redirect("#application.configBean.getContext()##contentRenderer.getURLStem(arguments.siteID,url.path)##qstring#")>
</cfif>
</cffunction>

<cffunction name="setCGIPath" output="false" returntype="any" access="remote">
	<cfset var cgi_path="">
	<cfset var parsed_path_info = cgi.path_info>
	<cfif len(getContextRoot()) and getContextRoot() NEQ "/">
		<cfset parsed_path_info = replace(parsed_path_info,getContextRoot(),"")/>
	</cfif>
	<cfif len(application.configBean.getContext())>
		<cfset parsed_path_info = replace(parsed_path_info,application.configBean.getContext(),"")/>
	</cfif>
	<cfif parsed_path_info eq cgi.script_name>
		<cfset cgi_path=""/>
	<cfelse>
		<cfset cgi_path=parsed_path_info />
	</cfif>
	<cfif left(cgi_path,1) eq "/" and cgi_path neq "/">
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
		<cflocation addtoken="no" url="http://#application.settingsManager.getSite(rsSites.siteID).getDomain()##application.configBean.getContext()#">
	</cfif>
	<cfcatch></cfcatch>
	</cftry>
	</cfloop>
	
	<!--- if still not found site the siteID to default --->
	<cfif checkDomain eq application.configBean.getAdminDomain()>
		<cfif arguments.isAdmin>
			<cfreturn "--none--">	
		<cfelse>
			<cfset application.contentRenderer.redirect("#application.configBean.getContext()#/admin/")>
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
				<cfset indexFile=last>
			</cfif>
			<cfif last neq indexFile and right(url.path,1) neq "/">
				<cfset application.contentRenderer.redirect("#url.path#/")>
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
		
		<cfreturn variables.Mura.doRequest(request.servletEvent)>
		
	<cfelse>
		<cfset redirect()>
	</cfif> 
	
</cffunction>

<cffunction name="parseURLLocal" output="false" returntype="any" access="remote">
	<cfset var siteID="">
	<cfset var cgi_path="">
	<cfparam name="url.path" default="" />
	
	<cfset cgi_path=setCGIPath()>
	
	<cfset siteID = listGetAt(cgi.script_name,listLen(cgi.script_name,"/")-1,"/") />
	
	<cfset forcePathDirectoryStructure(cgi_path,siteID)>
	
	<cfif not len(cgi.PATH_INFO)>
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
	
	<cfset cgi_path=setCGIPath()>
	<cfset forcePathDirectoryStructure(cgi_path,siteID)>
	
	<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
	<cfset request.preformated=true/>
	
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
		<cfset application.contentRenderer.redirect("/")>
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
			<cfset indexFile=last>
		</cfif>
		
		<cfif last neq indexFile and right(url.path,1) neq "/">
			<cfset application.contentRenderer.redirect("#application.configBean.getStub()#/#url.path#/")>
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
	<cfset application.contentRenderer.redirect("#application.configBean.getContext()##application.contentRenderer.getURLStem(rsSites.siteid,"")#")>
	</cfif>
	<cfcatch></cfcatch>
	</cftry>
	</cfloop>
	
	
	<cfif listFirst(cgi.http_host,":") eq application.configBean.getAdminDomain()>
		<cfset application.contentRenderer.redirect("#application.configBean.getContext()#/admin/")>
	<cfelse>
		<cfset application.contentRenderer.redirect("http://#rsSites.domain##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rsSites.siteid,"")#")>
	</cfif>
	
</cffunction>

<cffunction name="renderFilename" output="true" access="public">
	<cfargument name="filename" default="">
	<cfargument name="validateDomain" default="true">
	<cfset var fileoutput="">
 
	<cfset request.siteid = bindToDomain()>
	<cfset request.servletEvent = createObject("component","mura.servletEvent").init() />
	<cfset request.servletEvent.setValue("muraValidateDomain",arguments.validateDomain)>
	<cfset request.servletEvent.setValue("currentfilename",arguments.filename)>
	<cfset parseCustomURLVars(request.servletEvent)>
	<cfset fileOutput=variables.Mura.doRequest(request.servletEvent)>	
	<cfoutput>#fileOutput#</cfoutput>
	<cfabort>

</cffunction>

<cffunction name="render404" output="true" access="public">
	<cfheader statuscode="404" statustext="Content Not Found" /> 
	<cfset renderFilename("404")> 
</cffunction>

<cffunction name="parseCustomURLVars" output="false">
<cfargument name="event">
	<cfset var categoryFilename="">
	<cfset var categoryBean="">
	<cfset var i="">
	<cfset var dateArray=arrayNew(1)>
	<cfset var categoryArray=arrayNew(1)>
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
		<cfif listFindNoCase('date,category,params,tag,linkservid,showmeta',currentItem)>
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
			<cfset evaluate("arrayAppend(#currentArrayName#,'#currentItem#')")>	
		</cfif>
	</cfloop>
	
	<cfset arguments.event.setValue("currentFilenameAdjusted",arrayToList(fileArray,"/"))>

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

</cfcomponent>