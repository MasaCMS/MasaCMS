<!---
This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the
same licensing model. It is, therefore, licensed under the Gnu General Public License
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing
notice set out below. That exception is also granted by the copyright holders of Masa CMS
also applies to this file and Masa CMS in general.

This file has been modified from the original version received from Mura CMS. The
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained
only to ensure software compatibility, and compliance with the terms of the GPLv2 and
the exception set out below. That use is not intended to suggest any commercial relationship
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa.

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com

Masa CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.
Masa CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>.

The original complete licensing notice from the Mura CMS version of this file is as
follows:

This file is part of Mura CMS.

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
	/core/
	/Application.cfc
	/index.cfm

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="This provides the ability to update both core and site files">

<cffunction name="init" output="false">
	<cfargument name="configBean" required="true" default=""/>
	<cfargument name="fileWriter" required="true" default=""/>
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.fileWriter=arguments.fileWriter>
	<cfset variables.fileDelim=arguments.configBean.getFileDelim() />
	<cfreturn this />
</cffunction>

<cffunction name="update" output="false">
<cfset var baseDir=expandPath("/#variables.configBean.getWebRootMap()#")>
<cfset var versionDir=expandPath("/#variables.configBean.getWebRootMap()#")>
<cfset var versionFileContents="">
<cfset var zipFileName="global">
<cfset var zipUtil=createObject("component","mura.Zip")>
<cfset var rs=queryNew("empty")>
<cfset var trimLen=0>
<cfset var trimPath=0>
<cfset var fileItem="">
<cfset var currentDir=GetDirectoryFromPath(getCurrentTemplatePath())>
<cfset var updateVersion=1>
<cfset var currentVersion=0>
<cfset var diff="">
<cfset var returnStruct={currentVersion=currentVersion,files=[]}>
<cfset var updatedArray=arrayNew(1)>
<cfset var destination="">
<cfset var autoUpdateSleep=variables.configBean.getValue("autoUpdateSleep")>

<cfsetting requestTimeout = "7200">
<cfset var sessionData=getSession()>

<cfif listFind(sessionData.mura.memberships,'S2')>
	<cfif updateVersion gt currentVersion>
		<cflock type="exclusive" name="autoUpdate#application.instanceID#" timeout="600">

		<cfhttp attributeCollection='#getHTTPAttrs(
				url="#getAutoUpdateURL()#",
				result="diff",
				getasbinary="yes")#'>
		</cfhttp>

		<cfif not IsBinary(diff.filecontent)>
			<cfthrow message="The current production version code is currently not available. Please try again later.">
		</cfif>

		<cfset variables.fileWriter.writeFile(file="#currentDir##zipFileName#.zip",output="#diff.filecontent#")>
		<cffile action="readBinary" file="#currentDir##zipFileName#.zip" variable="diff">

		<!--- make sure that there are actually any updates--->

		<cfif len(diff)>
			<cfset rs=zipUtil.list("#currentDir##zipFileName#.zip")>

			<cfif directoryExists("#currentDir##zipFileName#")>
				<cfdirectory action="delete" directory="#currentDir##zipFileName#" recurse="true">
			</cfif>

			<cfset variables.fileWriter.createDir(directory="#currentDir##zipFileName#")>

			<cfset zipUtil.extract(zipFilePath:"#currentDir##zipFileName#.zip",
								extractPath: "#currentDir##zipFileName#")>

			<cfset trimPath=listFirst(rs.entry,variables.fileDelim)>
			<cfset trimLen=len(trimPath)>

			<cfquery name="rs" dbType="query">
			select * from rs where entry not like '#trimPath##variables.fileDelim#sites#variables.fileDelim#%'
			and entry not like '#trimPath##variables.fileDelim#modules#variables.fileDelim#%'
			and entry not like '#trimPath##variables.fileDelim#themes#variables.fileDelim#%'
			and entry not like '#trimPath##variables.fileDelim#content_types#variables.fileDelim#%'
			and entry not like '#trimPath##variables.fileDelim#config#variables.fileDelim#%'
			and entry not like '#trimPath##variables.fileDelim#plugins#variables.fileDelim#%'
			</cfquery>

			<cfloop query="rs">
				<cfif not listFind("README.md,.gitignore",listLast(rs.entry,variables.fileDelim))>
					<cfset destination="#baseDir##right(rs.entry,len(rs.entry)-trimLen)#">
					<!---<cftry>--->
						<cfif fileExists(destination)>
							<cffile action="delete" file="#destination#">
						</cfif>
						<cfset destination=left(destination,len(destination)-len(listLast(destination,variables.fileDelim)))>

						<cfif variables.configBean.getAdminDir() neq "/admin">
							<cfset destination=ReplaceNoCase(destination, "#variables.fileDelim#admin#variables.fileDelim#", "#replace(variables.configBean.getAdminDir(),'/',variables.fileDelim,'all')##variables.fileDelim#" )>
						</cfif>

						<cfif not directoryExists(destination)>
							<cfset variables.fileWriter.createDir(directory="#destination#")>
						</cfif>
						<cfset variables.fileWriter.moveFile(source="#currentDir##zipFileName##variables.fileDelim##rs.entry#",destination="#destination#")>
							<!---
						<cfcatch>
							<!--- patch to make sure autoupdates do not stop for mode errors --->
							<cfif not findNoCase("change mode of file",cfcatch.message) and not listFindNoCase('jar,class',listLast(rs.entry,"."))>
								<cfrethrow>
							</cfif>
						</cfcatch>
					</cftry>--->
					<cfset arrayAppend(updatedArray,"#destination##listLast(rs.entry,variables.fileDelim)#")>
				</cfif>
			</cfloop>

			<cfif arrayLen(updatedArray)>
				<cfset application.appInitialized=false>
				<cfset application.appAutoUpdated=true>
				<cfset application.coreversion=application.configBean.getVersionFromFile()>

				<cfif isNumeric(autoUpdateSleep) and autoUpdateSleep>
					<cfset autoUpdateSleep=autoUpdateSleep*1000>
					<cfthread action="sleep" duration="#autoUpdateSleep#"></cfthread>
				</cfif>
			</cfif>

			<cfdirectory action="delete" directory="#currentDir##zipFileName#" recurse="true">
		</cfif>

		<cffile action="delete" file="#currentDir##zipFileName#.zip" >

		<cfset application.configBean.setVersion(application.configBean.getVersionFromFile())>
		<cfset returnStruct.currentVersion=application.configBean.getVersion()/>
		<cfset application.coreversion=application.configBean.getVersion()>

		<cfif len(diff)>
			<cfset returnstruct.files=updatedArray>
		</cfif>

		</cflock>
	</cfif>

	<cfif arrayLen(updatedArray)>
		<cfif server.ColdFusion.ProductName neq "Coldfusion Server">
			<cfscript>pagePoolClear();</cfscript>
		</cfif>
	</cfif>

	<!--- Do core updates --->
	<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#coreUpdates" name="rsCoreUpdates" filter="*.cfm" sort="name asc">
	<cfloop query="rsCoreUpdates">
		<cfinclude template="coreUpdates/#rsCoreUpdates.name#">
	</cfloop>

	<cfreturn returnStruct>

<cfelse>
	<cfthrow message="The current user does not have permission to update Mura">
</cfif>

</cffunction>

<cffunction name="getAutoUpdateURL" output="false">
	<cfreturn getBean('configBean').getAutoUpdateURL()>
</cffunction>

</cfcomponent>
