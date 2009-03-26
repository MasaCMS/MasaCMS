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
<cfparam name="url.path" default="" />

<cfif cgi.path_info eq cgi.script_name>
	<cfset cgi_path=""/>
<cfelse>
	<cfset cgi_path=cgi.path_info />
</cfif>

<cfset siteID = listGetAt(cgi.script_name,listLen(cgi.script_name,"/")-1,"/") />

<cfif left(cgi_path,1) eq "/" and cgi_path neq "/">
	<cfset url.path=right(cgi_path,len(cgi_path)-1) />
</cfif>


<cfif len(url.path) and right(cgi_path,1) neq "/"  and right(cgi_path,len(application.configBean.getIndexfile())) neq application.configBean.getIndexfile()>
	<cfif len(cgi.query_string)>
	<cfset qstring="?" & cgi.query_string>
	<cfelse>
	<cfset qstring="" />
	</cfif>
	<cfset application.contentRenderer.redirect("#application.configBean.getContext()#/#siteid#/#application.configBean.getIndexfile()#/#url.path#/#qstring#")>
</cfif>

<cfset url.path="#application.configBean.getStub()#/#siteID#/#url.path#" />
<cfset request.preformated=true/>
</cfsilent>
<cfinclude template="contentServer.cfm">