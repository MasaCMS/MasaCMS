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
<cfcomponent extends="mura.cfobject" output="false" hint="This provides site bundling functionality">

	<cffunction name="init" output="false">
		<cfset variables.configBean	= application.configBean />
		<cfset variables.dsn		= variables.configBean.getDatasource() />

		<cfset variables.data		= StructNew() />
		<cfset variables.Bundle	= "" />
		<cfset variables.zipTool	= new mura.Zip() />
		<cfset variables.fileWriter	= getBean("fileWriter")>
		<cfset variables.utility	= application.utility.getBean("utility")>
		<cfset variables.dirName	= "Bundle_#createUUID()#" />
		<cfset variables.BundleDir	= variables.dirName />
		<cfset variables.workDir	= "#expandPath('/muraWRM#variables.configBean.getAdminDir()#/')#temp/">
		<cfset variables.procDir	= "#workdir#proc/" />
		<cfset variables.unpackPath	= "#procDir##BundleDir#/" />
		<cfset variables.backupDir	= "#variables.procDir##variables.dirName#/" />
		<cfset variables.unpackPath	= "#variables.procDir##variables.BundleDir#/" />

		<cfif not directoryExists(variables.workDir)>
			<cfset variables.fileWriter.createDir(directory="#variables.workDir#")>
		</cfif>
		<cfif not directoryExists(variables.procDir)>
			<cfset variables.fileWriter.createDir(directory="#variables.procDir#")>
		</cfif>

		<cfreturn this />
	</cffunction>

	<cffunction name="restore" returntype="boolean">
		<cfargument name="BundleFile" type="string" required="yes"/>
		<cfset var rsStruct			= StructNew() />
		<cfset var importValue	= "" />
		<cfset var fname			= "" />
		<cfset var sArgs			= StructNew() />
		<cfset var rsImportFiles = "" />
		<cfset var importWDDX = "" />

		<cfset variables.Bundle	= variables.unpackPath />

		<cfsetting requestTimeout = "7200">

		<cfif fileExists( arguments.BundleFile )>
			<cfif application.settingsManager.isBundle(arguments.BundleFile)>
				<cfset variables.zipTool.Extract(zipFilePath="#arguments.BundleFile#",extractPath=variables.unpackPath, overwriteFiles=true)>
			<cfelse>
				<cffile action="delete" file="#arguments.BundleFile#">
				<cfthrow message="The submitted Bundle is not valid.">
			</cfif>
		<cfelse>
			<cfoutput>NOT FOUND!!!: #arguments.BundleFile#</cfoutput><cfabort>
			<cfreturn false />
		</cfif>

		<cfdirectory action="list" directory="#variables.unpackPath#" name="rsImportFiles" filter="*.xml">
		<!--- this is done for cf7 compatability --->
		<cfquery name="rsImportFiles" dbtype="query">
			select * from rsImportFiles where lower(type)='file'
		</cfquery>

		<cfloop query="rsImportFiles">
			<cfset fname = rereplace(rsImportFiles.name,"^wddx_(.*)\.xml","\1") />
			<cffile action="read" file="#variables.unpackPath##rsImportFiles.name#" variable="importWDDX" charset="utf-8">
			<cftry>
				<cfset importWDDX =REReplace(importWDDX,'[\x0]','','ALL')>
				<cfwddx action="wddx2cfml" input=#importWDDX# output="importValue">
			<cfcatch>
				<cfdump var="An error happened while trying to deserialize #rsImportFiles.name#.">
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
			</cftry>
			<cfset variables.data[fname] = importValue />
		</cfloop>

		<cfreturn true />
	</cffunction>

	<cffunction name="restorePartial" returntype="boolean">
		<cfargument name="BundleFile" type="string" required="yes"/>
		<cfset var rsStruct			= StructNew() />
		<cfset var importValue	= "" />
		<cfset var fname			= "" />
		<cfset var sArgs			= StructNew() />
		<cfset var rsImportFiles = "" />
		<cfset var importWDDX = "" />
		<cfset var importExtensions = "" />
		<cfset var extendManager	= getBean("extendManager") />

		<cfset variables.Bundle	= variables.unpackPath />

		<cfsetting requestTimeout = "7200">

		<cfif fileExists( arguments.BundleFile )>
			<cfif application.settingsManager.isPartialBundle(arguments.BundleFile)>
				<cfset variables.zipTool.Extract(zipFilePath="#arguments.BundleFile#",extractPath=variables.unpackPath, overwriteFiles=true)>
			<cfelse>
				<cffile action="delete" file="#arguments.BundleFile#">
				<cfthrow message="The submitted Bundle is not valid.">
			</cfif>
		<cfelse>
			<cfoutput>NOT FOUND!!!: #arguments.BundleFile#</cfoutput><cfabort>
			<cfreturn false />
		</cfif>

		<cfdirectory action="list" directory="#variables.unpackPath#" name="rsImportFiles" filter="*.xml">
		<!--- this is done for cf7 compatability --->
		<cfquery name="rsImportFiles" dbtype="query">
			select * from rsImportFiles where lower(type)='file'
		</cfquery>

		<cfloop query="rsImportFiles">
			<cfset fname = rereplace(rsImportFiles.name,"^wddx_(.*)\.xml","\1") />
			<cffile action="read" file="#variables.unpackPath##rsImportFiles.name#" variable="importWDDX" charset="utf-8">
			<cftry>
				<cfset importWDDX =REReplace(importWDDX,'[\x0]','','ALL')>
				<cfwddx action="wddx2cfml" input=#importWDDX# output="importValue">
			<cfcatch>
				<cfdump var="An error happened while trying to deserialize #rsImportFiles.name#.">
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
			</cftry>
			<cfset variables.data[fname] = importValue />
		</cfloop>

		<cfreturn true />
	</cffunction>


	<cffunction name="renameFiles">
		<cfargument name="siteID" type="string" default="" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="dsn" type="string" default="#variables.configBean.getDatasource()#" required="true">

		<cfset var filePath = variables.configBean.getValue('filedir') & '/' & arguments.siteID & '/' & "cache/file/" />
		<cfset var toName	= "" />
		<cfset var keys		= arguments.keyFactory />
		<cfset var nFileID	= "" />
		<cfset var rsNameFiles	= "" />
		<cfset var rstFiles = getValue("rstFiles") />

		<cfif not rstFiles.recordCount>
			<cfreturn>
		</cfif>

		<cfloop query="rstfiles">
			<cfset nFileID = rstfiles.fileID />
			<cfdirectory name="rsNameFiles" directory="#filePath#" filter="#nFileID#*.*">

			<cfloop query="rsNameFiles">
				<cfset toName = replace(rsNameFiles.name,nFileID,keys.get(nFileID))>
				<cfset variables.fileWriter.renameFile(source="#filePath#/#rsNameFiles.name#", destination="#filePath#/#toName#")>
			</cfloop>
		</cfloop>
	</cffunction>

	<cffunction name="bundleFiles">
		<cfargument name="siteID" type="string" default="" required="true">
		<cfargument name="includeVersionHistory" type="boolean" default="true" required="true">
		<cfargument name="includeStructuredAssets" type="boolean" default="true" required="true">
		<cfargument name="includeTrash" type="boolean" default="true" required="true">
		<cfargument name="moduleID" type="string" default="" required="true">
		<cfargument name="sinceDate" type="any" default="">
		<cfargument name="includeUsers" type="boolean" default="false" required="true">
		<cfargument name="changesetID" default="">
		<cfargument name="bundleMode" default="">

		<cfset var siteRoot = variables.configBean.getSiteDir() & '/' & arguments.siteID />
		<cfset var zipDir	= "" />
		<cfset var rstplugins = "" />
		<cfset var rsInActivefiles = "" />
		<cfset var deleteList =	"" />
		<cfset var rstfiles=getValue("rstfiles")>
		<cfset var rscheck="">
		<cfset var started=false>
		<cfset var site=getBean('settingsManager').getSite(arguments.siteid)>
		<cfset var $=getBean('$').init(arguments.siteid)>

		<!---<cfset var moduleIDSQLlist="" />--->
		<cfset var i="" />

		<cfif isDate(arguments.sinceDate)>
			<cfset arguments.includeTrash=true>
		</cfif>
	
		<!---
		<cfloop list="#arguments.moduleID#" index="i">
			<cfset moduleIDSQLlist=listAppend(moduleIDSQLlist,"'#i#'")>
		</cfloop>
		--->

		<cfif arguments.bundleMode neq 'plugin' and len(arguments.siteID)>
			<cfset getBean("fileManager").cleanFileCache(arguments.siteID)>

			<cfif NOT arguments.includeStructuredAssets>
				<cfset variables.zipTool.AddFiles(zipFilePath="#variables.backupDir#sitefiles.zip",directory=siteRoot,recurse="true",sinceDate=arguments.sinceDate,excludeDirs="assets|cache")> 
			<cfelse>
				<cfset variables.zipTool.AddFiles(zipFilePath="#variables.backupDir#sitefiles.zip",directory=siteRoot,recurse="true",sinceDate=arguments.sinceDate)>
			</cfif>

			<!--- If the theme does not live in the site directory add it from the global directory --->
			<cfif (not directoryExists(expandPath($.siteConfig().getIncludePath() & "/includes/themes/#$.siteConfig('theme')#"))
					or not directoryExists(expandPath($.siteConfig().getIncludePath() & "/themes/#$.siteConfig('theme')#"))
				) and directoryExists(expandPath($.globalConfig().getWebRoot() & "/themes/#$.siteConfig('theme')#"))>
				<cfzip action="zip" file="#variables.backupDir#sitefiles.zip" source="#expandPath($.globalConfig().getWebRoot() & '/themes/' & $.siteConfig('theme'))#" prefix="themes/#$.siteConfig('theme')#">
			</cfif>

			<cfset var filePoolID=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>
			<!--- We do not want to include files collected from mura forms --->
			<cfquery name="rsInActivefiles">
				select fileID, fileExt 
				from tfiles
				where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#filePoolID#"/>
				and moduleid in ('00000000000000000000000000000000000','00000000000000000000000000000000003','00000000000000000000000000000000099'<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.includeUsers>,'00000000000000000000000000000000008'</cfif>)
				<cfif not arguments.includeVersionHistory and rstfiles.recordcount>
					and fileID not in (#QuotedValueList(rstfiles.fileID)#)
					<cfset started=true>
				</cfif>
			</cfquery>
			<!--- If the theme does not live in the site directory add it from the global directory --->
			<cfif (not directoryExists(expandPath($.siteConfig().getIncludePath() & "/includes/themes/#$.siteConfig('theme')#"))
					or not directoryExists(expandPath($.siteConfig().getIncludePath() & "/themes/#$.siteConfig('theme')#"))
				) and directoryExists(expandPath($.globalConfig().getWebRoot() & "/themes/#$.siteConfig('theme')#"))>
				<!---<cfzip action="zip" file="#variables.backupDir#sitefiles.zip" source="#expandPath($.globalConfig().getWebRoot() & '/themes/' & $.siteConfig('theme'))#" prefix="themes/#$.siteConfig('theme')#">--->
				<cfset variables.zipTool.Extract(zipFilePath="#variables.backupDir#sitefiles.zip",extractPath=expandPath($.globalConfig().getWebRoot() & '/themes/') & $.siteConfig('theme'),  extractDirs="themes/#$.siteConfig('theme')#", overwriteFiles=true)>
			</cfif>

			<cfif arguments.includeStructuredAssets>
				<cfset var filePoolID=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>
				<!--- We do not want to include files collected from Masa CMS forms --->
				<cfquery name="rsInActivefiles">
					select fileID,fileExt from tfiles
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#filePoolID#"/>
					and moduleid in ('00000000000000000000000000000000000','00000000000000000000000000000000003','00000000000000000000000000000000099'<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.includeUsers>,'00000000000000000000000000000000008'</cfif>)
					and (

						<cfif not arguments.includeVersionHistory and rstfiles.recordcount>
							fileID not in (#QuotedValueList(rstfiles.fileID)#)
							<cfset started=true>
						</cfif>

						<cfif not arguments.includeTrash>
							<cfif started>or</cfif> deleted=1
							<cfset started=true>
						</cfif>

						<cfif not started>
							0=1
						</cfif>
					)

					<cfif isDate(arguments.sinceDate)>
						and created >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
					</cfif>
					<cfif len(site.getPlaceholderImgID())>
						or fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#site.getPlaceholderImgID()#">
					</cfif>
				</cfquery>

				<cfloop query="rsInActivefiles">
					<cfdirectory action="list" name="rscheck" directory="#variables.configBean.getValue('filedir')#/#filePoolID#/cache/file/" filter="#rsInActivefiles.fileID#*">
					<cfif rscheck.recordcount>
						<cfloop query="rscheck">
							<cfset deleteList=listAppend(deleteList,"cache/file/#rscheck.name#","|")>
						</cfloop>
					</cfif>

				</cfloop>

				<cfif variables.configBean.getValue('assetdir') neq variables.configBean.getSiteDir()>
					<cfset zipDir = variables.configBean.getValue('assetdir') & '/' & filePoolID />
					<cffile action="write" file="#zipDir#/blank.txt" output="empty file" />
					
					<!---<cfset variables.zipTool.AddFiles(zipFilePath="#variables.backupDir#assetfiles.zip",directory=zipDir,recurse="true",sinceDate=arguments.sinceDate,excludeDirs="cache")>--->
					<cfzip action="zip" source="#zipDir#" file="#variables.backupDir#assetfiles.zip" recurse="true">
					<cfzip action="delete" file="#variables.backupDir#assetfiles.zip" entryPath="cache">
				
				</cfif>
				<cfif variables.configBean.getValue('filedir') neq variables.configBean.getSiteDir()>
					<cfset zipDir = variables.configBean.getValue('filedir') & '/' & filePoolID />
					<cffile action="write" file="#zipDir#/blank.txt" output="empty file" />
					
					<!---<cfset variables.zipTool.AddFiles(zipFilePath="#variables.backupDir#filefiles.zip",directory=zipDir,recurse="true",sinceDate=arguments.sinceDate,excludeDirs="assets")>--->
					<cfzip action="zip" source="#zipDir#" file="#variables.backupDir#filefiles.zip" recurse="true">
					<cfzip action="delete" file="#variables.backupDir#filefiles.zip" entryPath="assets">
		
					<cfif len(deleteList)>
						<cfset variables.zipTool.deleteFiles(zipFilePath="#variables.backupDir#filefiles.zip",files="#deleteList#")>
					</cfif>

				<cfelse>
					<cfif len(deleteList)>
						<cfset variables.zipTool.deleteFiles(zipFilePath="#variables.backupDir#sitefiles.zip",files="#deleteList#")>
					</cfif>

				</cfif>
			</cfif>
		</cfif>

		<!--- Plugins --->

		<!--- end plugins --->

	</cffunction>

	<cffunction name="bundlePartialFiles">
		<cfargument name="siteID" type="string" default="" required="true">
		<cfargument name="moduleID" type="string" default="" required="true">
		<cfargument name="sinceDate" type="any" default="">
		<cfargument name="changesetID" default="">
		<cfargument name="parentid" default="">
		<cfset var zipDir	= "" />
		<cfset var extendManager = getBean('extendManager') />
		<cfset var rstcontent=getValue("rstcontent")>
		<cfset var rstfiles=getValue("rstfiles")>
		<cfset var rstclassextenddata = getValue('rstclassextenddata') />
		<cfset var rscheck="">
		<cfset var fileArray = [] />
		<cfset var summaryFileArray = [] />
		<cfset var extendedAttributeFileArray = [] />
		<cfset var extensions = {} />
		<cfset var extension = "" />
		<cfset var extensionsArray = [] />
		<cfset var item = "" />
		<cfset var started=false>
		<cfset var i="" />
		<cfset var backupPath = '' />
		<cfset var filePath = '' />

		<cfif not directoryExists("#variables.backupDir#/cache")>
			<cfset directoryCreate("#variables.backupDir#/cache")>
			<cfset directoryCreate("#variables.backupDir#/cache/file")>
			<cffile action="write" file="#variables.backupDir#/cache/file/empty.txt" output="Ignore" >
		</cfif>

		<cfif not directoryExists("#variables.backupDir#/assets")>
			<cfset directoryCreate("#variables.backupDir#/assets")>
			<cffile action="write" file="#variables.backupDir#/assets/empty.txt" output="Ignore" >
		</cfif>

		<cfif len(arguments.siteID)>
			<!---
			<cfset  getBean("fileManager").cleanFileCache(arguments.siteID)>
			--->
			<cfset var assetdir=variables.configBean.getValue('assetdir') & '/' & getBean('settingsManager').getSite(arguments.siteid).getFilePoolID() />
			<cfset var filedir=variables.configBean.getValue('filedir') & '/' & getBean('settingsManager').getSite(arguments.siteid).getFilePoolID() />
			<cfset var bodyFileArray=[]>
			<cfset var extensionXML="">

 			<!--- We do not want to include files collected from Masa CMS forms --->

			<cfloop query="rstfiles">
				<cfif fileExists( "#filedir#/cache/file/#rstfiles.fileid#_source.#rstfiles.fileext#" )>
					<cfset fileCopy("#filedir#/cache/file/#rstfiles.fileid#_source.#rstfiles.fileext#","#variables.backupDir#/cache/file/#rstfiles.fileid#.#rstfiles.fileext#") />
				<cfelse>
					<cfset fileCopy("#filedir#/cache/file/#rstfiles.fileid#.#rstfiles.fileext#","#variables.backupDir#/cache/file/#rstfiles.fileid#.#rstfiles.fileext#") />
				</cfif>
			</cfloop>

			<cfset variables.zipTool.AddFiles(zipFilePath="#variables.backupDir#cachefiles.zip",directory="#variables.backupDir#/cache",recurse="true",sinceDate=arguments.sinceDate)>

			<!--- Prep data for extension XML file --->
			<cfloop collection="#extensions#" item="i">
				<cfset item = ListToArray( i,"." ) >
				<cfset extension = extendManager.getSubTypeByName( item[1],item[2],arguments.siteID ) />
				<cfif not extension.getIsNew()>
					<cfset arrayAppend(extensionsArray,extension) >
				</cfif>
			</cfloop>

			<cfset extensionXML = extendManager.getSubTypesAsXML( extensionsArray,false ) />
			<cffile action="write" file="#variables.backupDir#/extensions.txt" output="#extensionXML#" >

			<cfset variables.zipTool.AddFiles(zipFilePath="#variables.backupDir#assetfiles.zip",directory="#variables.backupDir#/assets/",recurse="true",sinceDate=arguments.sinceDate)>
		</cfif>
	</cffunction>

	<cffunction name="parseFilePaths" returntype="array">
		<cfargument name="siteID">
		<cfargument name="content">

		<cfset var fileArray = [] />
		<cfset var started=false>
		<cfset var i="" />
		<cfset var pos=1 />
		<cfset var block = {} />
		<cfset var find = 1 />
		<cfset var path = "" />
		<cfset var pathlist="" />
		<cfset var pathArray = [] />
		<cfset var fileArray = [] />
		<cfset var fileItemArray = [] />
		<cfset var filePoolID =getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>
		<cfset var end="">

		<cfloop condition="find gt 0">
			<cfset find = refindNoCase('\/#filePoolID#\/assets',arguments.content,pos)>

			<cfif find>
				<cfset end = refind('\"',arguments.content,find) />
				<cfif end>
					<cfset pathlist = mid(arguments.content,find,end-find) />
					<cfloop list="#pathlist#" index="path">
						<cfset path=trim(listFirst(path,")"))>
						<cfif len(path)>
							<cfset block = {} />
							<cfset pathArray = ListToArray( path,"/" ) />
							<cfset fileItemArray = listToArray(pathArray[ArrayLen(pathArray)], '.')>
							<cfif listLen(fileItemArray[ArrayLen(fileItemArray)],' ') gt 1>
									<cfset fileItemArray[ArrayLen(fileItemArray)]=listFirst(fileItemArray[ArrayLen(fileItemArray)],' ')>
									<cfset pathArray[ArrayLen(pathArray)]=arrayToList(fileItemArray, '.')>
							</cfif>
							<cfset block['pathArray'] = pathArray />
							<cfset block['file'] = pathArray[ArrayLen(pathArray)] />
							<cfset ArrayDeleteAt( pathArray,1 ) />
							<cfset ArrayDeleteAt( pathArray,ArrayLen(pathArray) ) />
							<cfset block['path'] = arrayToList( pathArray,"/" ) />
							<cfset ArrayAppend( fileArray,block ) />
						</cfif>
					</cfloop>
				<cfelse>
					<cfset find = 0 />
				</cfif>
				<cfset pos = end />
			</cfif>
		</cfloop>

		<cfreturn fileArray />
	</cffunction>

	<cffunction name="unpackPartialFile">
		<cfargument name="siteID" type="string" default="" required="true">
		<cfargument name="fileid" type="string" required="true">
		<cfargument name="contentid" type="string" required="true">
		<cfargument name="rsfile" type="query" required="true">
		<cfargument name="dsn" type="string" default="#variables.configBean.getDatasource()#" required="true">
		<cfargument name="errors" type="any" required="true" default="#structNew()#">

		<cfset var zipPath = "" />
		<cfset var siteRoot = variables.configBean.getSiteDir() & '/' & arguments.siteID />
		<cfset var fileManager = getBean('fileManager') />
		<cfset var tmpDir = "" />
		<cfset var destDir = "" />
		<cfset var qCheck = "" />
		<cfset var rsDirectory = "" />
		<cfset var tempFile = "" />
		<cfset var theFileStruct = "" />
		<cfset var newFileID = "" />
		<cfset destDir = getBundle() & "cachefiles" />

		<cfif not directoryExists(getBundle() & "cachefiles") >
			<cfset zipPath = getBundle() & "cachefiles.zip" />
			<cfset variables.zipTool.Extract(zipFilePath="#zipPath#",extractPath=destDir, overwriteFiles=true)>
		</cfif>

		<cfset rsDirectory = directoryList(destDir,true,"query","#arguments.fileid#*.*")>
		<cfif rsDirectory.recordCount>
			<cfset tempfile = fileManager.emulateUpload( rsDirectory.directory & "/" & rsDirectory.name ) />
			<cfset theFileStruct=fileManager.process(tempFile,arguments.siteID) />
			<cfset newFileID = fileManager.create( theFileStruct.fileObj,arguments.contentid,arguments.siteid,arguments.rsfile.filename,arguments.rsfile.contenttype,arguments.rsfile.contentsubtype,
				arguments.rsfile.filesize,arguments.rsfile.moduleid,arguments.rsfile.fileext,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium,createuuid(),theFileStruct.fileObjSource,arguments.rsfile.credits,arguments.rsfile.caption,arguments.rsfile.alttext ) >
		</cfif>

		<cfreturn newFileID />
	</cffunction>

	<cffunction name="unpackPartialAssets">
		<cfargument name="siteID" type="string" default="" required="true">

		<cfset var zipPath = getBundle() & "assetfiles.zip" />
		<cfset var site=getBean('settingsManager').getSite(arguments.siteid)>
		<cfset var filePoolID=site.getFilePoolID()>
		<cfset var destDir = variables.configBean.getValue('assetdir') & '/' & filePoolID & "/assets" />

		<cfset variables.zipTool.Extract(zipFilePath="#zipPath#",extractPath=destDir, overwriteFiles=true)>
	</cffunction>

	<cffunction name="unpackFiles">
		<cfargument name="siteID" type="string" default="" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="dsn" type="string" default="#variables.configBean.getDatasource()#" required="true">
		<cfargument name="moduleID" type="string" default="" required="true">
		<cfargument name="errors" type="any" required="true" default="#structNew()#">
		<cfargument name="renderingMode" type="any" required="true" default="all">
		<cfargument name="contentMode" type="any" required="true" default="all">
		<cfargument name="pluginMode" type="any" required="true" default="all">
		<cfargument name="sinceDate" type="any" required="true" default="">
		<cfargument name="keyMode" type="string" default="copy" required="true">
		<cfargument name="hasStructuredAssets" type="boolean" default="true" required="true">
		<cfargument name="themeDir" type="string" default="" required="true">

		<cfset var zipPath = "" />
		<cfset var siteRoot = variables.configBean.getSiteDir() & '/' & arguments.siteID />
		<cfset var tmpDir = "" />
		<cfset var destDir = "" />
		<cfset var qCheck = "" />
		<cfset var isFileEmpty = false />
		<cfset var rstplugins="">
		<cfset var pluginConfig="">
		<cfset var pluginCFC="">
		<cfset var theme="">
		<cfset var pluginDir="">
		<cfset var rssite="">
		<cfset var rsFiles="">
		<cfset var filename="">

		<cfif not len( getBundle() ) or not directoryExists( getBundle() )>
			<cfreturn>
		</cfif>

		<cfif len(arguments.siteID)>
			<cfset var site=getBean('settingsManager').getSite(arguments.siteid)>
			<cfset var filePoolID=site.getFilePoolID()>

			<cfif arguments.contentMode eq "all">

				<cfif not isDate(arguments.sinceDate) and not site.getHasSharedFilePool()>
					<!---
					<cfset variables.utility.deleteDir( variables.configBean.getValue('filedir') & '/'  & filePoolID & '/' & "assets"  )>
					--->
					<cfif arguments.hasStructuredAssets>
						<cftry>
						<cfset variables.utility.deleteDir( variables.configBean.getValue('filedir') & '/'  & filePoolID & "/cache"  )>
						<cfset variables.utility.createDir( variables.configBean.getValue('filedir') & '/'  & filePoolID & "/cache"  )>
						<cfset variables.utility.createDir( variables.configBean.getValue('filedir') & '/'  & filePoolID & "/cache/file"  )>

						<cfset variables.utility.deleteDir( variables.configBean.getValue('assetdir') & '/'  & filePoolID & "/assets"  )>
						<cfset variables.utility.createDir( variables.configBean.getValue('assetdir') & '/'  & filePoolID & "/assets"  )>
						<cfcatch></cfcatch>
						</cftry>
					</cfif>
				</cfif>

				<!---
					Contains work around for
					https://luceeserver.atlassian.net/browse/LDEV-2660
				--->
				<cfset var hasFilesZip= fileExists( getBundle() & "filefiles.zip" )>
				<cfset var hasAssetsZip= fileExists( getBundle() & "assetfiles.zip" )>

				<cfif fileExists( getBundle() & "sitefiles.zip" )>
					<cfset zipPath = getBundle() & "sitefiles.zip" />
				
					<cfif not hasFilesZip or not hasAssetsZip>
						<cfset var fileDir = variables.configBean.getValue('filedir') & '/' & filePoolID />
						<cfset var assetDir = variables.configBean.getValue('assetdir') & '/' & filePoolID />
						
						<cfzip file="#zipPath#" action="list" name="rsfiles">

						<cfloop query="rsfiles">
							<cfset filename=variables.fileWriter.pathFormat(rsfiles.name)>
							<cfif not hasFilesZip and listFindNoCase('cache',listFirst(filename,"/"))>
								<cfif fileExists(fileDir & "/" & filename)>
									<cfset fileDelete(fileDir & "/" & filename)>
								</cfif>
								<cfzip file="#zipPath#" action="unzip" overwrite="false" destination="#fileDir#" entrypath="#rsfiles.directory#" filter="#listLast(filename,'/')#">
							</cfif>
							<cfif not hasAssetsZip and listFindNoCase('assets',listFirst(filename,"/"))>
								<cfif fileExists(assetDir & "/" & filename)>
									<cfset fileDelete(assetDir & "/" & filename)>
								</cfif>
								<cfzip file="#zipPath#" action="unzip" overwrite="false" destination="#assetDir#" entrypath="#rsfiles.directory#" filter="#listLast(filename,'/')#">
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
				<cfif hasAssetsZip>
					<cfset zipPath = getBundle() & "assetfiles.zip" />
					<cfset destDir = variables.configBean.getValue('assetdir') & '/' & filePoolID />
					<cfzip file="#zipPath#" action="list" name="rsfiles">
					<cfloop query="rsfiles">
						<cfset filename=variables.fileWriter.pathFormat(rsfiles.name)>
						<cfif fileExists(destDir & "/" & filename)>
							<cfset fileDelete(destDir & "/" & filename)>
						</cfif>
						<cfzip file="#zipPath#" action="unzip" overwrite="false" destination="#destDir#" entrypath="#rsfiles.directory#" filter="#listLast(filename,'/')#">
					</cfloop>
				</cfif>
				<cfif hasFilesZip>
					<cfset zipPath = getBundle() & "filefiles.zip" />
					<cfset destDir = variables.configBean.getValue('filedir') & '/' & filePoolID />
					<cfzip file="#zipPath#" action="list" name="rsfiles">
					<cfloop query="rsfiles">
						<cfset filename=variables.fileWriter.pathFormat(rsfiles.name)>
						<cfif fileExists(destDir & "/" & filename)>
							<cfset fileDelete(destDir & "/" & filename)>
						</cfif>
						<cfzip file="#zipPath#" action="unzip" overwrite="false" destination="#destDir#" entrypath="#rsfiles.directory#" filter="#listLast(filename,'/')#">
					</cfloop>
				</cfif>
			</cfif>
			<cfif arguments.renderingMode eq "all">
				<cfset zipPath = getBundle() & "sitefiles.zip" />
				
				<cfzip file="#zipPath#" action="list" name="rsfiles">

				<cfloop query="rsfiles">
					<cfset filename=variables.fileWriter.pathFormat(rsfiles.name)>
					<cfif not listFindNoCase('cache,assets',listFirst(filename,"/"))>
						<cfif fileExists(siteRoot & "/" & filename)>
							<cfset fileDelete(siteRoot & "/" & filename)>
						</cfif>
						<cfzip file="#zipPath#" action="unzip" overwrite="false" destination="#siteRoot#" entrypath="#rsfiles.directory#" filter="#listLast(filename,'/')#">
					</cfif>
				</cfloop>
				
				<!---<cfset variables.zipTool.Extract(zipFilePath="#zipPath#",extractPath=siteRoot, overwriteFiles=true, excludeDirs="cache|assets")>--->
			<cfelseif arguments.renderingMode eq "theme" and len(arguments.themeDir)>
				<cfset zipPath = getBundle() & "sitefiles.zip" />

				<cfzip file="#zipPath#" action="unzip" overwrite="true" destination="#siteRoot#" entrypath="includes/themes/#arguments.themeDir#">
				<cfzip file="#zipPath#" action="unzip" overwrite="true" destination="#siteRoot#" entrypath="themes/#arguments.themeDir#">
	
			</cfif>
		</cfif>

		<cfif arguments.pluginMode eq "all" and fileExists( getBundle() & "pluginfiles.zip" )>
			<cfset rstplugins=getValue("rstplugins")>
			<cfif len(arguments.moduleID)>
				<cfquery name="rstplugins" dbtype="query">
					select * from rstplugins
					where moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true">)
				</cfquery>
			</cfif>

			<cfif not directoryExists(getBundle() & "plugins")>
				<cfset variables.fileWriter.createDir(directory=getBundle() & "plugins")>
			</cfif>

			<cfzip file="#getBundle()#pluginfiles.zip" action="unzip" overwrite="true" destination="#getBundle()#plugins">
			<!---<cfset variables.zipTool.Extract(zipFilePath=getBundle() & "pluginfiles.zip",extractPath=getBundle() & "plugins", overwriteFiles=true)>--->

			<cfloop query="rstplugins">

				<cfif not structKeyExists(arguments.errors,rstplugins.moduleID)>
					<cfquery datasource="#arguments.dsn#" name="qCheck">
						select directory from tplugins
						where moduleID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#keyFactory.get(rstplugins.moduleID)#"/>
					</cfquery>

					<cfif qCheck.recordcount and len(qCheck.directory)>
						<cfset pluginDir=variables.configBean.getPluginDir() & '/' & qCheck.directory>
					<cfelse>
						<cfset pluginDir=variables.configBean.getPluginDir() & '/' & rstplugins.directory>
					</cfif>

					<cfset variables.utility.copyDir( getBundle() & "plugins" & '/' & rstplugins.directory, pluginDir )>

				</cfif>
			</cfloop>

			<cfset application.pluginManager.createAppCFCIncludes()>
		</cfif>
	</cffunction>

	<cffunction name="bundle">
		<cfargument name="siteID" type="string" default="" required="true">
		<cfargument name="includeVersionHistory" type="boolean" default="true" required="true">
		<cfargument name="includeTrash" type="boolean" default="true" required="true">
		<cfargument name="includeStructuredAssets" type="boolean" default="true" required="true">
		<cfargument name="includeMetaData" type="boolean" default="true" required="true">
		<cfargument name="moduleID" type="string" default="" required="true">
		<cfargument name="bundleName" type="string" default="" required="true">
		<cfargument name="sinceDate" default="">
		<cfargument name="includeMailingListMembers" type="boolean" default="false" required="true">
		<cfargument name="includeUsers" type="boolean" default="false" required="true">
		<cfargument name="includeFormData" type="boolean" default="false" required="true">
		<cfargument name="saveFile" type="boolean" default="false" required="true">
		<cfargument name="saveFileDir" type="string" default="" required="true">
		<cfargument name="changesetID" default="">
		<cfargument name="parentID" default="">
		<cfargument name="doChildrenOnly" default="1">
		<cfargument name="bundleMode" default="">

		<cfset var rstcontent=""/>
		<cfset var rstcontentstats=""/>
		<cfset var rstcontentObjects=""/>
		<cfset var rstcontentTags=""/>
		<cfset var rstsystemobjects=""/>
		<cfset var rsSettings=""/>		
		<cfset var rstcontentcategoryassign=""/>
		<cfset var rstcontentfeeds=""/>
		<cfset var rstcontentfeeditems=""/>
		<cfset var rstcontentfeedadvancedparams=""/>
		<cfset var rstcontentrelated=""/>
		<cfset var rstmailinglist=""/>
		<cfset var rstmailinglistmembers="">
		<cfset var rstfiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var rstclassextenddatauseractivity="">
		<cfset var tclassextendrcsets="">
		<cfset var rstchangesets=""/>
		<cfset var rstpluginmodules=""/>
		<cfset var rstplugins=""/>
		<cfset var rstpluginscripts=""/>
		<cfset var rstplugindisplayobjects=""/>
		<cfset var rstpluginsettings=""/>
		<cfset var rsttrash=""/>
		<cfset var rsttrashfiles=""/>
		<cfset var rstformresponsequestions=""/>
		<cfset var rstformeresponsepackets=""/>

		<cfset var rstusers=""/>
		<cfset var rstusersmemb=""/>
		<cfset var rstusersinterests=""/>
		<cfset var rstuserstags=""/>
		<cfset var rstuseraddresses=""/>
		<cfset var rstusersfavorites=""/>
		<cfset var rstpermissions=""/>
		<cfset var publicUserPoolID=application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()>
		<cfset var privateUserPoolID=application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()>

		<cfset var sArgs		= StructCopy( arguments ) />
		<cfset var rsZipFile	= "" />
		<cfset var requiredSpace=variables.configBean.getValue("BundleMinSpaceRequired")>
		<cfset var rssite	= "" />
		<cfset var rstimagesizes	= "" />
		<!---<cfset var moduleIDSqlList="">--->
		<cfset var i="">
		<cfset var availableSpace=0>
		<cfset var pluginConfig="">
		<cfset var pluginCFC="">
		
		<cfset var rstformresponsepackets="">
		<cfset var rsCleanDir="">
		<cfset var rstclassextendrcsets="">

		<cfset var rsparentids="">
		<cfset var rsthierarchy="">
		<cfsetting requestTimeout = "7200">

		<cfif len(arguments.saveFileDir) and listFind("/,\",arguments.saveFileDir)>
			<cfset arguments.saveFileDir="">
		</cfif>
		<cfif len(arguments.saveFileDir) and listFind("/,\",right(arguments.saveFileDir,1))>
			<cfset arguments.saveFileDir=left(arguments.saveFileDir, len(arguments.saveFileDir)-1 ) & "/">
		</cfif>
		<cfif len(arguments.saveFileDir) and not listFind("/,\",right(arguments.saveFileDir,1))>
			<cfset arguments.saveFileDir=arguments.saveFileDir & "/">
		</cfif>

		<!---
		<cfloop list="#arguments.moduleID#" index="i">
			<cfset moduleIDSQLlist=listAppend(moduleIDSQLlist,"'#i#'")>
		</cfloop>
		--->
		
		<cfif isDate(arguments.sinceDate)>
			<cfset arguments.includeTrash=true>
			<cfset arguments.includeUser=false>
			<cfset arguments.includeMailingListMembers=false>
		</cfif>

		<cfif not isNumeric(requiredSpace)>
			<cfset requiredSpace=1>
		</cfif>

		<cftry>
			<cfset availableSpace=variables.fileWriter.getUsableSpace(variables.backupDir) >
		<cfcatch></cfcatch>
		</cftry>

		<cfif availableSpace and availableSpace lt requiredSpace>
			<cfthrow message="The required disk space of #requiredSpace# gb is not available.  You currently only have #availableSpace# gb available.">
		</cfif>

		<cfif not directoryExists(variables.backupDir)>
			<cfdirectory action="create" directory="#variables.backupDir#">
		</cfif>

		<cfif arguments.bundleMode neq 'plugin' and len(arguments.siteID)>
			<cfquery name="rstcontent">
				select tcontent.* from tcontent
				where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				and type <>'Module'
				<cfif not arguments.includeVersionHistory>
					and (active = 1 or (changesetID is not null and approved=0))
				</cfif>
				<cfif isDate(arguments.sinceDate)>
					and lastUpdate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
				</cfif>
				<cfif len(arguments.changesetID)>
					and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
					and tcontent.active = 1
				<cfelseif len(arguments.parentid)>
					and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
					<cfif arguments.doChildrenOnly>
					and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
					</cfif>
					and tcontent.active = 1
				</cfif>
			</cfquery>

			<cfset setValue("rstcontent",rstcontent)>

			<cfquery name="rstcontentobjects">
				select * from tcontentobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				and contenthistID in
				(
					select contenthistID from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif not arguments.includeVersionHistory>
					and (active = 1 or (changesetID is not null and approved=0))
					</cfif>
					<cfif len(arguments.changesetID)>
						and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
						and tcontent.active = 1
					<cfelseif len(arguments.parentid)>
						and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
						<cfif arguments.doChildrenOnly>
						and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
						</cfif>
						and tcontent.active = 1
					</cfif>
				)
				<cfif isDate(arguments.sinceDate)>
					<cfif rstcontent.recordcount>
						and contentHistID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentHistID)#">)
					<cfelse>
						0=1
					</cfif>
				</cfif>

				<cfif not arguments.includeTrash>
				and contentID in (select distinct contentID from tcontent)
				</cfif>
			</cfquery>

			<cfset setValue("rstcontentobjects",rstcontentobjects)>

			<cfquery name="rstcontenttags">
				select * from tcontenttags where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				and contenthistID in
				(
					select contenthistID from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif not arguments.includeVersionHistory>
					and (active = 1 or (changesetID is not null and approved=0))
					</cfif>
					<cfif len(arguments.changesetID)>
						and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
						and tcontent.active = 1
					<cfelseif len(arguments.parentid)>
						and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
						<cfif arguments.doChildrenOnly>
						and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
						</cfif>
						and tcontent.active = 1
					</cfif>
				)
				<cfif isDate(arguments.sinceDate)>
					<cfif rstcontent.recordcount>
						and contentHistID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentHistID)#">)
					<cfelse>
						0=1
					</cfif>
				</cfif>
				<cfif not arguments.includeTrash>
				and contentID in (
					select distinct contentID from tcontent
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif len(arguments.changesetID)>
						and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
						and tcontent.active = 1
					<cfelseif len(arguments.parentid)>
						and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
						<cfif arguments.doChildrenOnly>
						and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
						</cfif>
						and tcontent.active = 1
					</cfif>
				)
				</cfif>
			</cfquery>

			<cfset setValue("rstcontenttags",rstcontenttags)>

			<cfif not len(arguments.changesetID) and not len(arguments.parentid)>
				<!--- tcontentcategoryassign --->
				<cfquery name="rstcontentcategoryassign">
					select * from tcontentcategoryassign where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					and contenthistID in
					(
						select contenthistID from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						<cfif not arguments.includeVersionHistory>
						and (active = 1 or (changesetID is not null and approved=0))
						</cfif>
						<cfif len(arguments.changesetID)>
							and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							and tcontent.active = 1
						<cfelseif len(arguments.parentid)>
							and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
							<cfif arguments.doChildrenOnly>
							and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
							</cfif>
							and tcontent.active = 1
						</cfif>
					)
					<cfif isDate(arguments.sinceDate)>
						<cfif rstcontent.recordcount>
							and contentHistID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentHistID)#">)
						<cfelse>
							0=1
						</cfif>
					</cfif>
					<cfif not arguments.includeTrash>
					and categoryID in (select categoryID from tcontentcategories)
					and contentID in (
						select distinct contentID from tcontent
						where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						<cfif len(arguments.changesetID)>
							and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							and tcontent.active = 1
						<cfelseif len(arguments.parentid)>
							and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
							<cfif arguments.doChildrenOnly>
							and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
							</cfif>
							and tcontent.active = 1
						</cfif>
						)
					</cfif>
				</cfquery>

				<cfset setValue("rstcontentcategoryassign",rstcontentcategoryassign)>

				<cfquery name="rstsystemobjects">
					select * from tsystemobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				</cfquery>

				<cfset setValue("rstsystemobjects",rstsystemobjects)>

				<cfif arguments.includeUsers>
					<!--- BEGIN INCLUDE USERS only supported by full bundles--->
					<cfquery name="rstpermissions">
						select * from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					</cfquery>

					<cfset setValue("rstpermissions",rstpermissions)>

					<cfquery name="rstusers">
						select * from tusers where
						(
							(
								siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
								and isPublic=0
							)

							or

							(
								siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
								and isPublic=1
							)
						)
						<!---
						<cfif isDate(arguments.sinceDate)>
							and lastUpdate>=#createODBCDateFormat(arguments.sinceDate)#
						</cfif>
						--->

					</cfquery>

					<cfset setValue("rstusers",rstusers)>

					<cfif rstusers.recordcount>
						<cfquery name="rstusersmemb">
							select * from tusersmemb where
							userID in (
										select userID from tusers where
										(
											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
												and isPublic=0
											)

											or

											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
												and isPublic=1
											)
										)
										<!---
										<cfif isDate(arguments.sinceDate)>
											and lastUpdate>=#createODBCDateFormat(arguments.sinceDate)#
										</cfif>
										--->

									)
						</cfquery>

						<cfset setValue("rstusersmemb",rstusersmemb)>

						<cfquery name="rstuseraddresses">
							select * from tuseraddresses where
							userID in (
										select userID from tusers where
										(
											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
												and isPublic=0
											)

											or

											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
												and isPublic=1
											)
										)
										<!---
										<cfif isDate(arguments.sinceDate)>
											and lastUpdate>=#createODBCDateFormat(arguments.sinceDate)#
										</cfif>
										--->
									)
						</cfquery>

						<cfset setValue("rstuseraddresses",rstuseraddresses)>

						<cfquery name="rstusersinterests">
							select * from tusersinterests where
							userID in (
										select userID from tusers where
										(
											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
												and isPublic=0
											)

											or

											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
												and isPublic=1
											)
										)

										<!---
										<cfif isDate(arguments.sinceDate)>
											and lastUpdate>=#createODBCDateFormat(arguments.sinceDate)#
										</cfif>
										--->

									)
						</cfquery>

						<cfset setValue("rstusersinterests",rstusersinterests)>

						<cfquery name="rstuserstags">
							select * from tuserstags where
							userID in (
										select userID from tusers where
										(
											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
												and isPublic=0
											)

											or

											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
												and isPublic=1
											)
										)

										<!---
										<cfif isDate(arguments.sinceDate)>
											and lastUpdate>=#createODBCDateFormat(arguments.sinceDate)#
										</cfif>
										--->

									)
						</cfquery>

						<cfset setValue("rstuserstags",rstuserstags)>

						<cfquery name="rstusersfavorites">
							select * from tusersfavorites where
							userID in (
										select userID from tusers where
										(
											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#privateUserPoolID#"/>
												and isPublic=0
											)

											or

											(
												siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#publicUserPoolID#"/>
												and isPublic=1
											)
										)

										<!---
										<cfif isDate(arguments.sinceDate)>
											and lastUpdate>=#createODBCDateFormat(arguments.sinceDate)#
										</cfif>
										--->

									)
							and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						</cfquery>

						<cfset setValue("rstusersfavorites",rstusersfavorites)>
						<!--- END INCLUDE USERS --->
					</cfif>
				</cfif>

				<!--- tcontentfeeds --->
				<cfquery name="rstcontentfeeds">
					select * from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif isDate(arguments.sinceDate)>
					and lastUpdate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
					</cfif>
				</cfquery>

				<cfset setValue("rstcontentfeeds",rstcontentfeeds)>

				<!--- tcontentfeeditems --->
				<cfquery name="rstcontentfeeditems">
					select * from tcontentfeeditems where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
					<cfif isDate(arguments.sinceDate)>
						<cfif rstcontentfeeds.recordcount>
							and feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeeds.feedID)#">)
						<cfelse>
							0=1
						</cfif>
					</cfif>
					<cfif not arguments.includeTrash>
					and feedID in (select feedID from tcontentfeeds)
					</cfif>
				</cfquery>

				<cfset setValue("rstcontentfeeditems",rstcontentfeeditems)>

				<!--- tcontentfeedadvancedparams --->
				<cfquery name="rstcontentfeedadvancedparams">
					select * from tcontentfeedadvancedparams where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
					<cfif isDate(arguments.sinceDate)>
						<cfif rstcontentfeeds.recordcount>
							and feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeeds.feedID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
					<cfif not arguments.includeTrash>
					and feedID in (select feedID from tcontentfeeds)
					</cfif>
				</cfquery>
				<cfset setValue("rstcontentfeedadvancedparams",rstcontentfeedadvancedparams)>

				<!--- tcontentrelated --->
				<cfquery name="rstcontentrelated">
					select * from tcontentrelated where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif not arguments.includeVersionHistory>
					and contenthistID in
					(
						select contenthistID from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						and (active = 1 or (changesetID is not null and approved=0))
						<cfif len(arguments.changesetID)>
							and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							and tcontent.active = 1
						<cfelseif len(arguments.parentid)>
							and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
							<cfif arguments.doChildrenOnly>
							and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
							</cfif>
							and tcontent.active = 1
						</cfif>
					)
					</cfif>
					<cfif isDate(arguments.sinceDate)>
						<cfif rstcontent.recordcount>
							and contentHistID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentHistID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
					<cfif not arguments.includeTrash>
					and contentID in (
						select distinct contentID from tcontent
						where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						<cfif len(arguments.changesetID)>
							and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							and tcontent.active = 1
						<cfelseif len(arguments.parentid)>
							and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
							<cfif arguments.doChildrenOnly>
							and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
							</cfif>
							and tcontent.active = 1
						</cfif>
					)
					and relatedID in (select distinct contentID from tcontent)
					</cfif>
				</cfquery>

				<cfset setValue("rstcontentrelated",rstcontentrelated)>
			</cfif>

			<!--- tfiles --->
			<cfquery name="rstfiles">
				select * from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				and moduleid in ('00000000000000000000000000000000000','00000000000000000000000000000000003','00000000000000000000000000000000099'<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.includeUsers>,'00000000000000000000000000000000008'</cfif><cfif arguments.includeFormData>,'00000000000000000000000000000000004'</cfif>)
				<cfif not arguments.includeVersionHistory or len(arguments.changesetid) or len(arguments.parentid)>
				and
				(
					<!--- Get files attached to active content --->
					fileID in
					(
						select fileID from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						and fileID is not null
						and (active = 1 or (changesetID is not null and approved=0))
						<cfif len(arguments.changesetID)>
							and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							and tcontent.active = 1
						<cfelseif len(arguments.parentid)>
							and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
							<cfif arguments.doChildrenOnly>
							and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
							</cfif>
							and tcontent.active = 1
						</cfif>
					)

					<!--- Get files attached to active content extended attributes --->
					or fileID in
					(
						select tclassextenddata.stringvalue from tclassextenddata
						inner join tcontent on (
							tclassextenddata.baseID=tcontent.contenthistid
							<cfif len(arguments.changesetID)>
								and tcontent.changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
								and tcontent.active = 1
							<cfelseif len(arguments.parentid)>
								and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
								<cfif arguments.doChildrenOnly>
								and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
								</cfif>
								and tcontent.active = 1
							</cfif>
							)
						inner join tclassextendattributes on (tclassextenddata.attributeid=tclassextendattributes.attributeid)
						where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						and tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						and (tcontent.active = 1 or (tcontent.changesetID is not null and tcontent.approved=0))
						and tclassextendattributes.type='File'
					)

					<cfif not len(arguments.changesetID) and not len(arguments.parentid)>
					or fileID in
					(
						select tclassextenddata.stringvalue from tclassextenddata
						inner join tclassextendattributes on (tclassextenddata.attributeid=tclassextendattributes.attributeid)
						inner join tclassextendsets on (tclassextendattributes.extendsetid=tclassextendsets.extendsetid)
						inner join tclassextend on (tclassextendsets.subtypeid=tclassextend.subtypeid)
						where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						and tclassextendattributes.type='File'
						and tclassextend.type in ('Custom','1','2','User','Group','Address','Site')
					)
						<cfif arguments.includeUsers>
						<!--- Get files attached to tusers --->
						or fileID in
						(
							select photoFileID from tusers where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						)
						</cfif>
						<cfif arguments.includeFormData>
						or moduleID='00000000000000000000000000000000004'
						</cfif>
					</cfif>
				)

				</cfif>
				<cfif not arguments.includeTrash>
					and (deleted is null or deleted != 1)
				</cfif>
				<cfif isDate(arguments.sinceDate)>
				and created >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
				</cfif>
			</cfquery>

			<cfset setValue("rstfiles",rstfiles)>
			<cfset setValue("hasstructuredassets",arguments.includeStructuredAssets)>
			<cfset setValue("hasmetadata",arguments.includeMetaData)>

			<cfif arguments.includeMetaData and not len(arguments.changesetID) and not len(arguments.parentid)>
				<cfquery name="rstcontentstats">
					select * from tcontentstats where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif isDate(arguments.sinceDate)>
						<cfif rstcontent.recordcount>
							and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontent.contentID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
					<cfif not arguments.includeTrash or len(arguments.changesetid) or len(arguments.parentid)>
					and contentID in (
						select distinct contentID from tcontent
						where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						<cfif len(arguments.changesetid)>
							and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							and tcontent.active = 1
						<cfelseif len(arguments.parentid)>
							and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
							<cfif arguments.doChildrenOnly>
							and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
							</cfif>
							and tcontent.active = 1
						</cfif>
					)
					</cfif>
				</cfquery>

				<cfset setValue("rstcontentstats",rstcontentstats)>

				<cfquery name="rstcontentcomments">
					select * from tcontentcomments where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif isDate(arguments.sinceDate)>
					and entered >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
					</cfif>
					<cfif not arguments.includeTrash or len(arguments.changesetid) or len(arguments.parentid)>
					and contentID in (
						select distinct contentID from tcontent
						where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						<cfif len(arguments.changesetid)>
							and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							and tcontent.active = 1
						<cfelseif len(arguments.parentid)>
							and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
							<cfif arguments.doChildrenOnly>
							and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
							</cfif>
							and tcontent.active = 1
						</cfif>
						)
					</cfif>
				</cfquery>

				<cfset setValue("rstcontentcomments",rstcontentcomments)>

				<cfquery name="rstcontentratings">
					select * from tcontentratings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif isDate(arguments.sinceDate)>
					and entered >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
					</cfif>
					<cfif not arguments.includeTrash>
					and contentID in (select distinct contentID from tcontent)
					</cfif>
				</cfquery>
			</cfif>

			<cfif not len(arguments.changesetID) and not len(arguments.parentid)>

				<cfquery name="rstclassextend">
					select * from tclassextend where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif not arguments.includeUsers>
					and type not in ('1','2','User','Group')
					</cfif>
				</cfquery>
				<cfset setValue("rstclassextend",rstclassextend)>

				<cfquery name="rstclassextendsets">
					select * from tclassextendsets
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif rstclassextend.recordcount>
						and subTypeID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextend.subtypeID)#" list="true">)
					<cfelse>
						and 0=1
					</cfif>
				</cfquery>
				<cfset setValue("rstclassextendsets",rstclassextendsets)>

				<cfquery name="rstclassextendrcsets">
					select * from tclassextendrcsets
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif rstclassextend.recordcount>
						and subTypeID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextend.subtypeID)#" list="true">)
					<cfelse>
						and 0=1
					</cfif>
				</cfquery>
				<cfset setValue("tclassextendrcsets",rstclassextendrcsets)>

				<cfquery name="rstclassextendattributes">
					select * from tclassextendattributes where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif rstclassextendsets.recordcount>
						and extendsetID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(rstclassextendsets.extendsetID)#" list="true">)
					<cfelse>
						and 0=1
					</cfif>
				</cfquery>
				<cfset setValue("rstclassextendattributes",rstclassextendattributes)>

				<cfquery name="rstclassextenddata">
					select
						tclassextenddata.baseID
						, tclassextenddata.attributeID
						, tclassextenddata.attributeValue
						, tclassextenddata.siteID
						, tclassextenddata.stringvalue
						, tclassextenddata.numericvalue
						, tclassextenddata.datetimevalue
						, tclassextenddata.remoteID
					from tclassextenddata
					inner join tcontent on (tclassextenddata.baseid=tcontent.contenthistid)
					where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						<cfif not arguments.includeVersionHistory>
							and (tcontent.active = 1 or (tcontent.changesetID is not null and tcontent.approved=0))
							<cfif Len(arguments.changesetid)>
								and tcontent.changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							</cfif>
						</cfif>
						<cfif isDate(arguments.sinceDate)>
							and lastUpdate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
						</cfif>
						and tclassextenddata.attributeID in (select attributeID from tclassextendattributes
							where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)

					union all

					select
						tclassextenddata.baseID
						, tclassextenddata.attributeID
						, tclassextenddata.attributeValue
						, tclassextenddata.siteID
						, tclassextenddata.stringvalue
						, tclassextenddata.numericvalue
						, tclassextenddata.datetimevalue
						, tclassextenddata.remoteID
					from tclassextenddata
					inner join tclassextendattributes on (tclassextenddata.attributeID=tclassextendattributes.attributeID)
					inner join tclassextendsets on (tclassextendattributes.extendsetid=tclassextendsets.extendsetid)
					inner join tclassextend on (tclassextendsets.subtypeid=tclassextend.subtypeid)
					where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						and tclassextend.type in ('Site','Custom')
				</cfquery>
				<cfset setValue("rstclassextenddata",rstclassextenddata)>

			<cfelse>
				<cfquery name="rstclassextenddata">
					select
						tclassextenddata.baseID
						, tclassextenddata.attributeID
						, tclassextenddata.attributeValue
						, tclassextenddata.siteID
						, tclassextenddata.stringvalue
						, tclassextenddata.numericvalue
						, tclassextenddata.datetimevalue
						, tclassextenddata.remoteID
						, tcontent.contentid
						, tclassextendattributes.name
					from tclassextenddata
					inner join tcontent on (tclassextenddata.baseid=tcontent.contenthistid)
					join tclassextendattributes on (tclassextenddata.attributeid=tclassextendattributes.attributeid)
					where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						<cfif isDate(arguments.sinceDate)>
							and lastUpdate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
						</cfif>
						and tclassextenddata.attributeID in (select attributeID from tclassextendattributes
							where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>)
						<cfif len(arguments.changesetid)>
							and tcontent.changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
							and tcontent.active = 1
						<cfelseif len(arguments.parentid)>
							and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
							<cfif arguments.doChildrenOnly>
							and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
							</cfif>
							and tcontent.active = 1
						</cfif>
				</cfquery>

				<cfset setValue("rstclassextenddata",rstclassextenddata)>
			</cfif>

			<cfif not len(arguments.changesetID) and not len(arguments.parentid)>
				<!--- tmailinglist --->
				<cfquery name="rstmailinglist">
					select * from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif isDate(arguments.sinceDate)>
					and lastUpdate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
					</cfif>
				</cfquery>

				<cfset setValue("rstmailinglist",rstmailinglist)>

				<cfif arguments.includeMailingListMembers>
					<!--- tmailinglistmembers only support for full archives--->
					<cfquery name="rstmailinglistmembers">
						select * from tmailinglistmembers where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					</cfquery>

					<cfset setValue("rstmailinglistmembers",rstmailinglistmembers)>
				</cfif>

				<cfif arguments.includeUsers>
					<cfquery name="rstclassextenddatauseractivity">
						select * from tclassextenddatauseractivity
						where siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						and attributeID in (select attributeID from tclassextendattributes)
					</cfquery>

					<cfset setValue("rstclassextenddatauseractivity",rstclassextenddatauseractivity)>
				</cfif>

				<!--- tcontentcategories --->
				<cfquery name="rstcontentcategories">
					select * from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif isDate(arguments.sinceDate)>
						and lastUpdate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
					</cfif>
				</cfquery>

				<cfset setValue("rstcontentcategories",rstcontentcategories)>

				<!--- tchangesets --->
				<cfquery name="rstchangesets">
					select * from tchangesets where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<cfif not arguments.includeVersionHistory>
					and published=0
					</cfif>
					<cfif isDate(arguments.sinceDate)>
						and lastUpdate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
					</cfif>
					<cfif len(arguments.changesetID)>
						and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
					</cfif>
				</cfquery>

				<cfset setValue("rstchangesets",rstchangesets)>

				<cfif (arguments.includeTrash or isDate(arguments.sinceDate)) and not len(arguments.changesetID)>
				<!--- ttrash --->
				<cfquery name="rsttrash">
					select * from ttrash where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
					<!--- We don't want user data in trash --->
					<cfif not arguments.includeUsers>
					and objectClass not in ('userBean','addressBean')
					</cfif>
					<cfif isDate(arguments.sinceDate)>
						and deletedDate >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sinceDate#">
					</cfif>
				</cfquery>

				<cfset setValue("rsttrash",rsttrash)>

				<!--- deleted files --->
				<cfif isDate(arguments.sinceDate)>
				<cfquery name="rsttrashfiles">
					select * from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getBean('siteManager').getSite(arguments.siteID).getFilePoolID()#"/>
					and moduleid in ('00000000000000000000000000000000000','00000000000000000000000000000000003'<cfif len(arguments.moduleID)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true"></cfif><cfif arguments.includeUsers>,'00000000000000000000000000000000008'</cfif><cfif arguments.includeFormData>,'00000000000000000000000000000000004'</cfif>)
					and deleted=1
				</cfquery>

				<cfset setValue("rsttrashfiles",rsttrashfiles)>
				</cfif>

				</cfif>

				<cfquery name="rssite">
					select domain,siteid,theme,
					largeImageWidth,largeImageHeight,
					smallImageWidth,smallImageHeight,
					mediumImageWidth,mediumImageHeight,
					columnCount,columnNames,primaryColumn,baseID,customtaggroups,
					placeholderImgID,placeholderImgExt,isremote
				    from tsettings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				</cfquery>

				<cfset setValue("rssite",rssite)>

				<cfquery name="rstimagesizes">
					select *
				    from timagesizes where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				</cfquery>

				<cfset setValue("rstimagesizes",rstimagesizes)>
				
				<cfset var site=getBean('settingsManager').getSite(arguments.siteID)>

				<cfset setValue("assetPath",application.configBean.getAssetPath())>
				<cfset setValue("fileAssetPath",site.getFileAssetPath(complete=site.get('isRemote')))>
				<cfset setValue("context",application.configBean.getContext())>
			</cfif>

			<!--- fix image paths --->
			<cfif len(arguments.changesetID) or len(arguments.parentid)>
				<cfset fixAssetPath(arguments.siteid) />
			</cfif>
		</cfif>

		<cfif arguments.bundleMode eq 'plugin' or (not len(arguments.changesetID) and not len(arguments.parentid))>
			<!--- BEGIN PLUGINS --->
			<!--- Modules--->
			<cfquery name="rstpluginmodules">
				select moduleID from tcontent where
				1=1
				<cfif len(arguments.siteID)>
					and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/> and type='Plugin'
				</cfif>
				<cfif len(arguments.moduleID)>
					and moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true">)
				<cfelse>
					and 0=1
				</cfif>
			</cfquery>

			<cfset setValue("rstpluginmodules",rstpluginmodules)>

			<!--- Plugins --->
			<cfquery name="rstplugins">
				select * from tplugins
				where
				1=1
				<cfif len(arguments.siteID)>
				 	and moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/> and type='Plugin')
				</cfif>
				<cfif len(arguments.moduleID)>
					and moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true">)
				<cfelse>
					and 0=1
				</cfif>
			</cfquery>

			<cfset setValue("rstplugins",rstplugins)>

			<cfloop query="rstplugins">
				<cfif fileExists(variables.configBean.getPluginDir() & "/#rstplugins.directory#/plugin/plugin.cfc")>
					<cfset pluginConfig=getPlugin(ID=rstplugins.moduleID, siteID="", cache=false)>
					<cfset pluginCFC= new "plugins.#rstplugins.directory#.plugin.plugin"(pluginConfig) />

					<!--- only call the methods if they have been defined --->
					<cfif structKeyExists(pluginCFC,"toBundle")>
						<cfset pluginCFC.toBundle(pluginConfig=pluginConfig,Bundle=this, siteID=arguments.siteID,includeVersionHistory=arguments.includeVersionHistory)>
					</cfif>
				</cfif>
			</cfloop>

			<!--- Scripts --->
			<cfquery name="rstpluginscripts">
				select * from tpluginscripts where
				1=1
				<cfif len(arguments.siteID)>
				 	and moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/> and type='Plugin')
				</cfif>
				<cfif len(arguments.moduleID)>
					and moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true">)
				<cfelse>
					and 0=1
				</cfif>
			</cfquery>

			<cfset setValue("rstpluginscripts",rstpluginscripts)>

			<!--- Display Objects --->
			<cfquery name="rstplugindisplayobjects">
				select * from tplugindisplayobjects where
				1=1
				<cfif len(arguments.siteID)>
				 	and moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/> and type='Plugin')
				</cfif>
				<cfif len(arguments.moduleID)>
					and moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true">)
				<cfelse>
					and 0=1
				</cfif>
			</cfquery>

			<cfset setValue("rstplugindisplayobjects",rstplugindisplayobjects)>

			<!--- Settings --->
			<cfquery name="rstpluginsettings">
				select * from tpluginsettings where
				1=1
				<cfif len(arguments.siteID)>
				 	and moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#"/> and type='Plugin')
				</cfif>
				<cfif len(arguments.moduleID)>
					and moduleID in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#" list="true">)
				<cfelse>
					and 0=1
				</cfif>
			</cfquery>

			<cfset setValue("rstpluginsettings",rstpluginsettings)>
			<!--- END PLUGINS --->

			<cfif arguments.bundleMode neq 'plugin' and len(arguments.siteID)>
				<!--- BEGIN FORM DATA --->
				<cfif arguments.includeFormData and not isDate(arguments.sinceDate)>
						<cfquery name="rstformresponsepackets">
							select * from tformresponsepackets
							where siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
						</cfquery>

						<cfset setValue("rstformresponsepackets",rstformresponsepackets)>

						<cfquery name="rstformresponsequestions">
							select * from tformresponsequestions
							where formid in (
											select distinct formID from tformresponsepackets
											where siteID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
											)
						</cfquery>

						<cfset setValue("rstformresponsequestions",rstformresponsequestions)>
				</cfif>
				<!--- END FORM DATA --->

				<!--- BEGIN BUNDLEABLE CUSTOM OBJECTS --->
				<cfif len(arguments.siteid)>
					<cfset setValue("bundleablebeans",application.objectMappings.bundleablebeans)>

					<cfif len(application.objectMappings.bundleablebeans)>
						<cfloop list="#application.objectMappings.bundleablebeans#" index="local.b">
							<cfset getBean(beanName=local.b,siteid=arguments.siteid).toBundle(bundle=this,siteid=arguments.siteid,includeVersionHistory=arguments.includeVersionHistory)>
						</cfloop>
					</cfif>
				</cfif>
				<!--- END BUNDLEABLE CUSTOM OBJECTS --->
			</cfif>

			<cfset setValue("sincedate",arguments.sincedate)>
			<cfset setValue("bundledate",now())>
			<cfif not (isdefined('url.bundleFiles') and IsBoolean(url.bundleFiles) and not url.bundleFiles)>
				<cfset BundleFiles( argumentCollection=sArgs ) />
			</cfif>
		<cfelseif arguments.bundleMode neq 'plugin'>
			<cfquery name="rsthierarchy">
				select contentid,contenthistid,filename,type,subtype,orderno,path,
				<cfif variables.configBean.getDBType() eq "MSSQL">
				len(Cast(path as varchar(1000))) depth
				<cfelse>
				length(path) depth
				</cfif>
				from tcontent
				where siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#"/>
				and active = 1
				<cfif len(arguments.changesetID)>
					and changesetid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.changesetID#">
				<cfelseif len(arguments.parentid)>
					and tcontent.path like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.parentid#%">
					<cfif arguments.doChildrenOnly>
					and tcontent.contentid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentid#">
					</cfif>
				</cfif>
				order by depth,orderno
			</cfquery>

			<cfloop query="rsthierarchy">
				<cfset rsthierarchy['depth'][rsthierarchy.currentrow] = ArrayLen( ListToArray(rsthierarchy['path'][rsthierarchy.currentrow]) ) />
			</cfloop>

			<cfset setValue("rsthierarchy",rsthierarchy)>
			<cfset sArgs.rstfiles = rstfiles />

			<cfset BundlePartialFiles( argumentCollection=sArgs ) />

			<!--- BEGIN BUNDLEABLE CUSTOM OBJECTS --->
			<cfif len(arguments.siteid) and not len(arguments.moduleID)>
				<cfset setValue("bundleablebeans",application.objectMappings.bundleablebeans)>

				<cfif len(application.objectMappings.bundleablebeans)>
					<cfloop list="#application.objectMappings.bundleablebeans#" index="local.b">
						<cfset var bean=getBean(beanName=local.b,siteid=arguments.siteid)>
						<cfset var meta=getMetaData(bean)>
						<cfif isDefined('bean.versioned') and bean.versioned>
							<cfset bean.toBundle(bundle=this,siteid=arguments.siteid,contenthistid=valuelist(rsthierarchy.contenthistid))>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<!--- END BUNDLEABLE CUSTOM OBJECTS --->
		</cfif>

		<cfset variables.zipTool.AddFiles(zipFilePath="#variables.workDir##variables.dirName#.zip",directory=#variables.backupDir#)>

		<!---
		<cfdirectory action="list" directory="#variables.procDir#" type="dir" name="rsCleanDir">

		<cfloop query="rsCleanDir">
			<cftry>
			<cfdirectory action="delete" directory="#variables.procDir##name#" recurse="true" >
			<cfcatch></cfcatch>
			</cftry>
		</cfloop>
		--->

		<cfdirectory action="delete" directory="#variables.backupDir#" recurse="true" >

		<cfif not len(arguments.bundleName)>
			<cfset arguments.bundleName="MuraBundle">
		</cfif>
		<cfif len(arguments.siteID)>
			<cfset arguments.bundleName=arguments.bundleName & "_#arguments.siteID#">
		</cfif>

		<cfset arguments.bundleName="#arguments.bundleName#_#dateformat(now(),'yyyy_mm_dd')#_#timeformat(now(),'HH_mm')#.zip">

		<cfif not arguments.saveFile>
			<cfset getBean("fileManager").streamFile(
				filePath="#variables.workDir##variables.dirName#.zip",
				filename=arguments.bundleName,
				mimetype="application/zip",
				method="attachment",
				deleteFile=true
				)>
		<cfelseif len(arguments.saveFileDir) and directoryExists(arguments.saveFileDir)>
			<cfset getBean("fileWriter").moveFile(source="#variables.workDir##variables.dirName#.zip",
											  destination="#arguments.saveFileDir##arguments.bundleName#")>
			<cfreturn "#arguments.saveFileDir##arguments.bundleName#">
		<cfelse>
			<cfset getBean("fileWriter").moveFile(source="#variables.workDir##variables.dirName#.zip",
											  destination="#variables.workDir##arguments.bundleName#")>
			<cfreturn "#variables.workDir##arguments.bundleName#">
		</cfif>

	</cffunction>

	<cffunction name="getBundle">
		<cfreturn variables.Bundle />
	</cffunction>

	<cffunction name="cleanUp">
		<cfif not len( getBundle() ) or not directoryExists( getBundle() )>
			<cfreturn>
		</cfif>

		<cftry>
			<cfdirectory action="delete" directory="#getBundle()#" recurse="true">
		<cfcatch>
		</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getValue" output="false">
		<cfargument name="name" type="string" required="true">
		<cfargument name="default">

		<cfif structKeyExists(variables.data,arguments.name)>
			<cfreturn variables.data[name] />
		<cfelse>
			<cfif structKeyExists(arguments,"default")>
				<cfreturn arguments.default>
			<cfelse>
				<cfreturn QueryNew("null") />
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="fixAssetPath">
		<cfargument name="siteID" type="string" default="" required="true">

		<cfset var content = "" />
		<cfset var extenddata = "" />

		<cffile action="read" variable="content" file="#variables.backupDir#wddx_rstcontent.xml">
		<cfset content = rereplaceNoCase( content,'src=\&quot;\/#arguments.siteID#\/assets','src=&quot;/^^siteid^^/assets','all' ) />
		<cfset content = rereplaceNoCase( content,'src="\/#arguments.siteID#\/assets','src="/^^siteid^^/assets','all' ) />
		<cfset content = rereplaceNoCase( content,'src=''\/#arguments.siteID#\/assets','src=''/^^siteid^^/assets','all' ) />

		<cffile action="write" output="#content#" file="#variables.backupDir#wddx_rstcontent.xml"  charset="utf-8">

		<cffile action="read" variable="extenddata" file="#variables.backupDir#wddx_rstclassextenddata.xml">
		<cfset extenddata = rereplaceNoCase( extenddata,'src=\&quot;\/#arguments.siteID#\/assets','src=&quot;/^^siteid^^/assets','all' ) />
		<cfset extenddata = rereplaceNoCase( extenddata,'src="\/#arguments.siteID#\/assets','src="/^^siteid^^/assets','all' ) />
		<cfset extenddata = rereplaceNoCase( extenddata,'src=''\/#arguments.siteID#\/assets','src''/^^siteid^^/assets','all' ) />

		<cffile action="write" output="#extenddata#" file="#variables.backupDir#wddx_rstclassextenddata.xml"  charset="utf-8">
	</cffunction>

	<cffunction name="setValue">
		<cfargument name="name" type="string" required="true">
		<cfargument name="value" type="any" required="true">
		<cfset var temp="">
		<cfset var i = "">

		<cfif isQuery(arguments.value) and application.configBean.getDBType() eq "Oracle">
			<cfset arguments.value=variables.utility.fixOracleClobs(arguments.value)>
		</cfif>

		<cfset variables.data["#name#"]=arguments.value>
		<cfwddx action="cfml2wddx" input="#arguments.value#" output="temp">

		<!--- replace lower, non-printable ascii chars (except for line breaks and tabs) --->
		<cfloop from="1" to="31" index="i">
			<cfif not listFind('9,10,13',i)>
				<cfset temp = replace(temp, chr(i), "", "all")>
			</cfif>
		</cfloop>


		<cffile action="write" output="#temp#" file="#variables.backupDir#wddx_#arguments.name#.xml"  charset="utf-8">
	</cffunction>

	<cffunction name="valueExists" output="false">
		<cfargument name="valueKey">
		<cfreturn structKeyExists(variables.data,arguments.valueKey) />
	</cffunction>

	<cffunction name="getAllValues" output="false">
		<cfreturn variables.data />
	</cffunction>
</cfcomponent>
