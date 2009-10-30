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

<cffunction name="init" access="public" returntype="any" output="false">
	<cfargument name="configBean" required="true" default=""/>	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.fileDelim=arguments.configBean.getFileDelim() />
	<cfreturn this />
</cffunction>

<cffunction name="update" output="false" returntype="any" access="public">
<cfargument name="siteID" required="true" default="">
<cfset var baseDir=expandPath("/#variables.configBean.getWebRootMap()#")>
<cfset var versionDir=expandPath("/#variables.configBean.getWebRootMap()#")>
<cfset var currentVersion=getCurrentVersion(arguments.siteid)>
<cfset var updateVersion=getProductionVersion()>
<cfset var versionFileContents="">
<cfset var svnUpdateDir="/trunk/www">
<cfset var zipFileName="global">
<cfset var zipUtil=createObject("component","mura.Zip")>
<cfset var rs=queryNew("empty")>
<cfset var trimLen=len(svnUpdateDir)-1>
<cfset var fileItem="">
<cfset var currentDir=GetDirectoryFromPath(getCurrentTemplatePath())>
<cfset var diff="">
<cfset var returnStruct=structNew()>
<cfset var updatedArray=arrayNew(1)>

<cfif isUserInRole('S2')>
	<cfif updateVersion gt currentVersion>
		<cflock type="exclusive" name="autoUpdate#arguments.siteid#" timeout="600">
		<cfif len(arguments.siteID) >
			<cfset baseDir=baseDir & "#variables.fileDelim##arguments.siteid#">
			<cfset versionDir=versionDir & "/#arguments.siteid#">
			<cfset zipFileName="#arguments.siteid#">
			<cfset svnUpdateDir="/trunk/www/default">
			<cfset trimLen=len(svnUpdateDir)-1>
		<cfelse>
			<cfset versionDir=versionDir & "/config">
		</cfif>
		
		<cfhttp url="http://trac.blueriver.com/mura/changeset" result="diff" getasbinary="yes" 
		proxyUser="#variables.configBean.getProxyUser()#" proxyPassword="#variables.configBean.getProxyPassword()#"
		proxyServer="#variables.configBean.getProxyServer()#" proxyPort="#variables.configBean.getProxyPort()#">
		<cfhttpparam type="url" name="format" value="zip">
		<cfhttpparam type="url" name="old_path" value="#svnUpdateDir#">
		<cfhttpparam type="url" name="old" value="#currentVersion#">
		<cfhttpparam type="url" name="new_path" value="#svnUpdateDir#">
		<cfhttpparam type="url" name="new" value="#updateVersion#">
		</cfhttp>
	
		<cfif not IsBinary(diff.filecontent)>
			<cfthrow message="The current production version code is currently not available. Please try again later.">
		</cfif>
		
		<cffile action="write" file="#currentDir##zipFileName#.zip" output="#diff.filecontent#">
		<cffile action="readBinary" file="#currentDir##zipFileName#.zip" variable="diff">
		
		<!--- make sure that there are actually any updates--->
		<cfif len(diff)>
			<cfset rs=zipUtil.list("#currentDir##zipFileName#.zip")>
			
			<cfif directoryExists("#currentDir##zipFileName#")>
				<cfdirectory action="delete" directory="#currentDir##zipFileName#" recurse="true">
			</cfif>
			
			<cfdirectory action="create" directory="#currentDir##zipFileName#">
			
			<cfset zipUtil.extract(zipFilePath:"#currentDir##zipFileName#.zip",
								extractPath: "#currentDir##zipFileName#")>
		
			<cfif len(arguments.siteID)>
				<cfquery name="rs" dbType="query">
				select * from rs 
				where entry not like 'trunk#variables.fileDelim#www#variables.fileDelim#default#variables.fileDelim#includes#variables.fileDelim#themes%'
				and entry not like 'trunk#variables.fileDelim#www#variables.fileDelim#default#variables.fileDelim#includes#variables.fileDelim#email%'
				and entry not like 'trunk#variables.fileDelim#www#variables.fileDelim#default#variables.fileDelim#includes#variables.fileDelim#templates%'
				</cfquery>
				<cfloop query="rs">
					<cfif not listFind("contentRenderer.cfc,eventHandler.cfc,servlet.cfc,loginHandler.cfc",listLast(rs.entry,variables.fileDelim))>
						<cfset destination="#baseDir##right(rs.entry,len(rs.entry)-trimLen)#">
						<cfset destination=left(destination,len(destination)-len(listLast(destination,variables.fileDelim)))>		
						<cfif not directoryExists(destination)>
							<cfdirectory action="create" directory="#destination#">
						</cfif>
						<cffile action="move" source="#currentDir##zipFileName##variables.fileDelim##rs.entry#" destination="#destination#">
						<cfset arrayAppend(updatedArray,"#destination##listLast(rs.entry,variables.fileDelim)#")>
					</cfif>
				</cfloop>
			<cfelse>
				<cfquery name="rs" dbType="query">
				select * from rs where entry not like 'trunk#variables.fileDelim#www#variables.fileDelim#default%'
				</cfquery>
				
				<cfloop query="rs">
					<cfif not listFind("settings.ini.cfm,settings.custom.vars.cfm,settings.custom.managers.cfm,coldspring.custom.xml.cfm",listLast(rs.entry,variables.fileDelim))>
						<cfset destination="#baseDir##right(rs.entry,len(rs.entry)-trimLen)#">
						<cfset destination=left(destination,len(destination)-len(listLast(destination,variables.fileDelim)))>		
						
						<cfif not directoryExists(destination)>
							<cfdirectory action="create" directory="#destination#">
						</cfif>
						<cffile action="move" source="#currentDir##zipFileName##variables.fileDelim##rs.entry#" destination="#destination#">
						<cfset arrayAppend(updatedArray,"#destination##listLast(rs.entry,variables.fileDelim)#")>
					</cfif>
				</cfloop>
				<cfset application.appInitialized=false />
			</cfif>
			<cfdirectory action="delete" directory="#currentDir##zipFileName#" recurse="true">
		</cfif>
		
		<cffile action="delete" file="#currentDir##zipFileName#.zip" >
		<cffile action="write" file="#versionDir##variables.fileDelim#version.cfm" output="<cfabort>:#updateVersion#">
		</cflock>
	</cfif>
	
	<cfset returnStruct.currentVersion=updateVersion/>
	<cfset returnStruct.files=updatedArray>
	<cfreturn returnStruct>
	
<cfelse>
	<cfthrow message="The current user does not have permission to update Mura">
</cfif>

</cffunction>

<cffunction name="getCurrentVersion" output="false">
<cfargument name="siteid" required="true" default="">

	<cfset var versionDir=expandPath("/#variables.configBean.getWebRootMap()#")>
	<cfset var versionFileContents="">
	<cfset var currentVersion="">
	
	<cfif len(arguments.siteid)>
		<cfset versionDir=versionDir & "/#arguments.siteid#">
	<cfelse>
		<cfset versionDir=versionDir & "/config">
	</cfif>
	
	<cfif not FileExists(versionDir & "/" & "version.cfm")>
		<cffile action="write" file="#versionDir#/version.cfm" output="<cfabort>:1">
	</cfif>
	
	<cffile action="read" file="#versionDir#/version.cfm" variable="versionFileContents">
	
	<cfset currentVersion=listLast(versionFileContents,":")>
	
	<cfif not isNumeric(currentVersion)>
		<cffile action="write" file="#versionDir#/version.cfm" output="<cfabort>:1">
		<cfreturn 1>
	<cfelse>
		<cfreturn currentVersion>
	</cfif>

</cffunction>

<cffunction name="getProductionVersion" output="false">
	<cfreturn getProductionData().number>
</cffunction>

<cffunction name="getProductionData" output="false">
	<cfset var diff="">

	<cfhttp url="http://getmura.com/productionVersion.cfm" result="diff" getasbinary="no" 
	proxyUser="#variables.configBean.getProxyUser()#" proxyPassword="#variables.configBean.getProxyPassword()#"
	proxyServer="#variables.configBean.getProxyServer()#" proxyPort="#variables.configBean.getProxyPort()#">
	
	<cftry>
	<cfreturn createObject("component","mura.json").decode(diff.filecontent)>
	<cfcatch>
		<cfthrow message="The current production version data is currently not available. Please try again later.">
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="getCurrentCompleteVersion" output="false">
	<cfargument name="siteid" required="true" default="">
	
	<cfset var versionBase=variables.configBean.getVersion()>
	<cfset var currentVersion=1>
	
	<cftry>
	<cfset currentVersion=getCurrentVersion(arguments.siteid)>
	<cfcatch></cfcatch>
	</cftry>
	
	<cfif currentVersion gt 1>
		<cfset versionBase=versionBase & ".#currentVersion#">
	</cfif>
	<cfreturn versionBase>
</cffunction>

</cfcomponent>