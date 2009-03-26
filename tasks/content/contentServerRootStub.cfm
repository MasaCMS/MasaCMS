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

<cfsilent>
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
<!---
<cfif len(url.path) and right(url.path,1) neq "/"  and right(url.path,len(application.configBean.getIndexfile())) neq application.configBean.getIndexfile()>
	<cfif len(cgi.query_string)>
	<cfset qstring="?" & cgi.query_string>
	<cfelse>
	<cfset qstring="" />
	</cfif>
	<cfset application.contentRenderer.redirect("#application.configBean.getContext()#/#application.configBean.getIndexfile()#/#url.path#/#qstring#")>
</cfif>
--->

<cfset last=listLast(url.path,"/") />
<cfif last neq application.configBean.getIndexFile() and right(url.path,1) neq "/">
	<cfset application.contentRenderer.redirect("#url.path#/")>
</cfif>

<cfif not url.pathIsComplete>
<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
</cfif>

<cfset request.preformated=true/>
</cfsilent>
<cfinclude template="contentServer.cfm">