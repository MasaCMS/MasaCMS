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
<cfsilent>

<cfparam name="attributes.moduleid" default="">
<cfparam name="attributes.siteid" default="">
<cfparam name="attributes.compactDisplay" default="">
<cfparam name="attributes.rb" default="">
<cfparam name="attributes.closeCompactDisplay" default="">
<cfparam name="session.siteid" default="">
<cfparam name="session.keywords" default="">
<cfparam name="cookie.rb" default="">

<cfif len(attributes.rb)>
	<cfset session.rb=attributes.rb>
	<cfcookie name="rb" value="#session.rb#" expires="never" />
</cfif>

<cfif not application.configBean.getSessionHistory()  or application.configBean.getSessionHistory() gte 30>
	<cfparam name="session.dashboardSpan" default="30">
<cfelse>
	<cfparam name="session.dashboardSpan" default="#application.configBean.getSessionHistory()#">
</cfif>

<cfif not application.configBean.getSessionHistory()  or application.configBean.getSessionHistory() gte 30>
	<cfset session.dashboardSpan=30>
<cfelse>
	<cfset session.dashboardSpan=application.configBean.getSessionHistory()>
	
</cfif>
<cfif attributes.siteid neq ''>
	<cfset Session.siteid = attributes.siteid>
	<cfset Session.userFilesPath = "#application.configBean.getAssetPath()#/#attributes.siteid#/assets/">
</cfif>

<cfif attributes.moduleid neq ''>
	<cfset Session.moduleid = attributes.moduleid>
</cfif>

<cfif application.configBean.getAdminDomain() neq '' and application.configBean.getAdminDomain() neq cgi.SERVER_NAME and attributes.compactDisplay eq '' and attributes.closeCompactDisplay eq ''>
	<cflocation url="#application.configBean.getContext()#/" addtoken="false">
</cfif>

<cfif len(getAuthUser()) and not structKeyExists(session,"siteArray")>
	<cfset session.siteArray=arrayNew(1) />
	<cfloop collection="#application.settingsManager.getSites()#" item="site">
		<cfif application.permUtility.getModulePerm("00000000000000000000000000000000000","#site#")>
			<cfset arrayAppend(session.siteArray,site) />
		</cfif>
	</cfloop>
</cfif>

<cfif structKeyExists(session,"siteArray") and not arrayLen(session.siteArray) and not isUserInRole("S2IsPrivate")>
	<cflocation url="#application.configBean.getContext()#/" addtoken="false">
</cfif>
	
<cfparam name="session.paramArray" default="#arrayNew(1)#" />
<cfparam name="session.paramCount" default="0" />
<cfparam name="session.paramCircuit" default="" />
<cfparam name="session.paramCategories" default="" />
<cfparam name="session.paramGroups" default="" />
<cfparam name="session.inActive" default="" />
<cfparam name="session.membersOnly" default="false" />
<cfparam name="session.visitorStatus" default="All" />
<cfparam name="attributes.param" default="" />
<cfparam name="attributes.inActive" default="0" />
<cfparam name="attributes.categoryID" default="" />
<cfparam name="attributes.groupID" default="" />
<cfparam name="attributes.membersOnly" default="false" />
<cfparam name="attributes.visitorStatus" default="All" />

	<cfif attributes.param neq ''>
		<cfset session.paramArray=arrayNew(1) />
		<cfset session.paramCircuit=listFirst(attributes.fuseaction,'.') />
		<cfloop from="1" to="#listLen(attributes.param)#" index="i">
			<cfset theParam=listGetAt(attributes.param,i) />
			<cfif evaluate('attributes.paramField#theParam#') neq 'Select Field'
			and evaluate('attributes.paramField#theParam#') neq ''
			and evaluate('attributes.paramCriteria#theParam#') neq ''>
			<cfset temp=structNew() />
			<cfset temp.Field=evaluate('attributes.paramField#theParam#') />
			<cfset temp.Relationship=evaluate('attributes.paramRelationship#theParam#') />
			<cfset temp.Criteria=evaluate('attributes.paramCriteria#theParam#') />
			<cfset temp.Condition=evaluate('attributes.paramCondition#theParam#') />
			<cfset arrayAppend(session.paramArray,temp) />
			</cfif>
		</cfloop>
		<cfset session.paramCount =arrayLen(session.paramArray)/>
		<cfset session.inActive = attributes.inActive />
		<cfset session.paramCategories = attributes.categoryID />
		<cfset session.paramGroups = attributes.groupID />
		<cfset session.membersOnly = attributes.membersOnly />
		<cfset session.visitorStatus = attributes.visitorStatus />
		
	</cfif>

<cfif application.configBean.getAdminSSL() and  cgi.https eq 'Off'  and attributes.compactDisplay eq '' and attributes.closeCompactDisplay eq ''>
	<cfif cgi.query_string eq ''>
			<cfset page='#cgi.script_name#'>
	<cfelse>
			<cfset page='#cgi.script_name#?#cgi.QUERY_STRING#'>
	</cfif>
	
	<cflocation addtoken="false" url="https://#cgi.SERVER_NAME##page#">
</cfif>

<cfset application.rbFactory.setAdminLocale(session)>
</cfsilent>