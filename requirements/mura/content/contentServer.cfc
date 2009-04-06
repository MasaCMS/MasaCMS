<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->
<cfcomponent extends="mura.cfobject">

<cffunction name="doRequest" output="false" returntype="any" access="remote">	
<cfset request.servletEvent = createObject("component","mura.servletEvent").init() />
<cfset request.servletEvent.setValue('siteid',request.servletEvent.getValue('siteid'))>
<cfreturn createObject("component","mura.Mura").init().doRequest(request.servletEvent)>
</cffunction>

<cffunction name="forcePathDirectoryStructure" output="false" returntype="any" access="remote">
<cfif len(url.path) and right(cgi_path,1) neq "/"  and right(cgi_path,len(application.configBean.getIndexfile())) neq application.configBean.getIndexfile()>
	<cfif len(cgi.query_string)>
	<cfset qstring="?" & cgi.query_string>
	<cfelse>
	<cfset qstring="" />
	</cfif>
	<cfset application.contentRenderer.redirect("#application.configBean.getContext()#/#application.configBean.getIndexfile()#/#url.path#/#qstring#")>
</cfif>
</cffunction>

<cffunction name="setCGIPath" output="false" returntype="any" access="remote">
<cfif cgi.path_info eq cgi.script_name>
	<cfset cgi_path=""/>
<cfelse>
	<cfset cgi_path=cgi.path_info />
</cfif>

<cfif left(cgi_path,1) eq "/" and cgi_path neq "/">
	<cfset url.path=right(cgi_path,len(cgi_path)-1) />
</cfif>
</cffunction>

<cffunction name="bindToDomain" output="false" returntype="any" access="remote">
<cfset siteID= "" />
<cfset rsSites=application.settingsManager.getList() />

<!--- check for exact host match to find siteID --->
<cfloop query="rsSites">
<cftry>
<cfif cgi.SERVER_NAME eq application.settingsManager.getSite(rsSites.siteID).getDomain()>
<cfset variables.siteID = rsSites.siteID />
<cfbreak/>
</cfif>
<cfcatch></cfcatch>
</cftry>
</cfloop>

<!--- if not found look for a partial match and redirect--->
<cfif not len(siteID)>
<cfloop query="rssites">
<cftry>
<cfif find(cgi.SERVER_NAME,application.settingsManager.getSite(rsSites.siteID).getDomain())>
	<cflocation addtoken="no" url="http://#application.settingsManager.getSite(rsSites.siteID).getDomain()#">
</cfif>
<cfcatch></cfcatch>
</cftry>
</cfloop>
</cfif>

<!--- if still not found site the siteID to default --->
<cfif not len(siteID) >
	<cfif cgi.SERVER_NAME eq application.configBean.getAdminDomain()>
		<cfset application.contentRenderer.redirect("#application.configBean.getContext()#/admin/")>
	<cfelse>
		<cfset siteID=rsSites.siteID>
	 </cfif>
</cfif>
</cffunction>

<cffunction name="parseURL" output="false" returntype="any" access="remote">
	
<cfif isDefined('url.path') and url.path neq application.configBean.getContext() & application.configBean.getStub() & "/">
<cfsetting enablecfoutputonly="yes">


<cfset last=listLast(url.path,"/") />

<cfif not structKeyExists(request,"preformated")>
<cfif last neq application.configBean.getIndexFile() and right(url.path,1) neq "/">
	<cfset application.contentRenderer.redirect("#url.path#/")>
</cfif>
</cfif>

<cfif isValid("UUID",last)>
	<cfquery name="rsRedirect" datasource="#application.configBean.getDatasource()#"  username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
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
<cfset request.servletEvent.setValue('siteid',request.servletEvent.getValue('siteid'))>
<cfreturn createObject("component","mura.Mura").init().doRequest(request.servletEvent)>

<cfelse>
	<cfset redirect()>
</cfif> 
</cffunction>

<cffunction name="parseURLLocal" output="false" returntype="any" access="remote">

<cfparam name="url.path" default="" />

<cfset setCGIPath()>

<cfset siteID = listGetAt(cgi.script_name,listLen(cgi.script_name,"/")-1,"/") />

<cfset forcePathDirectoryStructure()>

<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
<cfset request.preformated=true/>

<cfreturn parseURL()>
</cffunction>

<cffunction name="parseURLRoot" output="false" returntype="any" access="remote">

<cfset bindToDomain()>

<cfparam name="url.path" default="" />

<cfset setCGIPath()>
<cfset forceDirectoryStructure()>

<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
<cfset request.preformated=true/>

<cfreturn parseURL()>
</cffunction>

<cffunction name="parseURLRootStub" output="false" returntype="any" access="remote">
	
<cfset bindToDomain()>

<cfparam name="url.path" default="" />
<cfset urlStem=application.configBean.getContext() & application.configBean.getStub() & "/" & siteid />

<cfif listFind("/go,/go/",url.path)>
	<cfset application.contentRenderer.redirect("/")>
</cfif>

<cfif left(url.path,len(urlStem)) neq urlStem>
<cfset url.path=right(url.path,len(url.path)-len(application.configBean.getContext() & application.configBean.getStub()) - 1)>
<cfset url.pathIsComplete=false />
<cfelse>
<cfset url.pathIsComplete=true />
</cfif>

<cfset last=listLast(url.path,"/") />
<cfif last neq application.configBean.getIndexFile() and right(url.path,1) neq "/">
	<cfset application.contentRenderer.redirect("#url.path#/")>
</cfif>

<cfif not url.pathIsComplete>
<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
</cfif>

<cfset request.preformated=true/>

<cfreturn parseURL()>
</cffunction>

<cffunction name="Redirect" output="false" returntype="any">

<cfset var rsSites=application.settingsManager.getList() />
<cfloop query="rssites">
<cftry>
<cfif find(cgi.SERVER_NAME,application.settingsManager.getSite(rsSites.siteID).getDomain())>
<cfset application.contentRenderer.redirect("#application.configBean.getContext()##application.contentRenderer.getURLStem(rsSites.siteid,"")#")>
</cfif>
<cfcatch></cfcatch>
</cftry>
</cfloop>


<cfif cgi.SERVER_NAME eq application.configBean.getAdminDomain()>
	<cfset application.contentRenderer.redirect("#application.configBean.getContext()#/admin/")>
<cfelse>
	<cfset application.contentRenderer.redirect("http://#rsSites.domain##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(rsSites.siteid,"")#")>
</cfif>
</cffunction>

</cfcomponent>