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
<cfcomponent extends="mura.cfobject">

<cffunction name="forcePathDirectoryStructure" output="false" returntype="any" access="remote">
<cfargument name="cgi_path">
<cfset var qstring="">
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
<cfset var cgi_path="">
<cfif cgi.path_info eq cgi.script_name>
	<cfset cgi_path=""/>
<cfelse>
	<cfset cgi_path=cgi.path_info />
</cfif>

<cfif left(cgi_path,1) eq "/" and cgi_path neq "/">
	<cfset url.path=right(cgi_path,len(cgi_path)-1) />
</cfif>
<cfreturn cgi_path>
</cffunction>

<cffunction name="bindToDomain" output="false" returntype="any" access="remote">
	<cfset var siteID= "" />
	<cfset var rsSites=application.settingsManager.getList() />
	
	<!--- check for exact host match to find siteID --->
	<cfloop query="rsSites">
	<cftry>
	<cfif cgi.SERVER_NAME eq application.settingsManager.getSite(rsSites.siteID).getDomain()>
	<cfset siteID = rsSites.siteID />
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
	
	<cfreturn siteid>
</cffunction>

<cffunction name="parseURL" output="false" returntype="any" access="remote">
	<cfset var last="">
	<cfset var theStart=0>
	<cfset var trimLen=0>
	<cfset var tempfilename="">
	<cfset var thelen=0>
	<cfset var item="">
	<cfset var n="">
	<cfset var rsRedirect="">
	
	<cfif isDefined('url.path') and url.path neq application.configBean.getContext() & application.configBean.getStub() & "/">
	
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
		<cfreturn createObject("component","mura.Mura").init().doRequest(request.servletEvent)>
		
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
	
	<cfset forcePathDirectoryStructure(cgi_path)>
	
	<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
	<cfset request.preformated=true/>
	
	<cfreturn parseURL()>
</cffunction>

<cffunction name="parseURLRoot" output="false" returntype="any" access="remote">
	<cfset var cgi_path="">
	<cfset var siteid=bindToDomain()>
	
	<cfparam name="url.path" default="" />
	
	<cfset cgi_path=setCGIPath()>
	<cfset forcePathDirectoryStructure(cgi_path)>
	
	<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
	<cfset request.preformated=true/>
	
	<cfreturn parseURL()>
</cffunction>

<cffunction name="parseURLRootStub" output="false" returntype="any" access="remote">
	<cfset var urlStem="">
	<cfset var last="">
	<cfset var siteid=bindToDomain()>
	
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