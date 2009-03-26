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

<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.settingsManager=arguments.settingsManager />
	<cfreturn this />
</cffunction>

 <cffunction name="getAdvertisersBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>
	<cfset var rs = "">
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#" name="rs"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	SELECT tusers.UserID, tusers.Company, tusers.fname,tusers.lname,tusers.email, tusers.SiteID,tusers.isPublic
	FROM tusers INNER JOIN tusersmemb ON tusers.UserID = tusersmemb.UserID INNER JOIN tusers TUsers_1 ON tusersmemb.GroupID = TUsers_1.UserID
	WHERE (TUsers_1.GroupName='Advertisers') AND (TUsers_1.isPublic=1) AND (TUsers_1.SiteID='#variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID()#')
	<cfif arguments.keywords neq ''>and tusers.company like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keywords#%" /></cfif>
	</cfquery>

	<cfreturn rs />
</cffunction>

<cffunction name="getIPWhiteListBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	
	<cfset var rs = "">
	<cfquery name="rs" datasource="#variables.instance.configBean.getDatasource()#" cachedwithin="#createTimeSpan(1,0,0,0)#"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	select ip from tadipwhitelist
	where siteid='#variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID()#'
	</cfquery>
	
	<cfreturn rs />
</cffunction>

 <cffunction name="getGroupID" returntype="string" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	
	<cfset var rs = "">
	
	<cfquery datasource="#variables.instance.configBean.getDatasource()#" name="rs"  username="#variables.instance.configBean.getDBUsername()#" password="#variables.instance.configBean.getDBPassword()#">
	SELECT tusers.UserID from tusers where type=1 and ispublic =1 and siteid='#variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID()#'
	and groupname='Advertisers'
	</cfquery>

	<cfreturn rs.userid />
</cffunction>

</cfcomponent>