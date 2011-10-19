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
	
	<cfquery datasource="#variables.instance.configBean.getReadOnlyDatasource()#" name="rs"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
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
	
	<cfquery datasource="#variables.instance.configBean.getReadOnlyDatasource()#" name="rs"  username="#variables.instance.configBean.getReadOnlyDbUsername()#" password="#variables.instance.configBean.getReadOnlyDbPassword()#">
	SELECT tusers.UserID from tusers where type=1 and ispublic =1 and siteid='#variables.instance.settingsManager.getSite(arguments.siteid).getAdvertiserUserPoolID()#'
	and groupname='Advertisers'
	</cfquery>

	<cfreturn rs.userid />
</cffunction>

</cfcomponent>