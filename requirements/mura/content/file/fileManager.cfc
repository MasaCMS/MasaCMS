<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="fileDAO" type="any" required="yes"/>
		<cfargument name="configBean" type="any" required="yes"/>
		<cfargument name="settingsManager" type="any" required="yes"/>
		
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.fileDAO=arguments.fileDAO />
		<cfset variables.settingsManager=arguments.settingsManager />
		
		<cfif listLen(variables.configBean.getFileStoreAccessInfo(),"^") eq 3>
			<cfset variables.bucket=listLast(variables.configBean.getFileStoreAccessInfo(),"^") />
		<cfelse>		
			<cfset variables.bucket="sava" />
		</cfif>

		<cfif StructKeyExists(SERVER,"bluedragon") or (server.coldfusion.productname eq "ColdFusion Server" and listFirst(server.coldfusion.productversion) lt 8)>
			<cfset variables.imageProcessor=createObject("component","processImgImagecfc").init(arguments.configBean,arguments.settingsManager) />
		<cfelse>
			<cfset variables.imageProcessor=createObject("component","processImgCfimage").init(arguments.configBean,arguments.settingsManager) />
		</cfif>
		
<cfreturn this />
</cffunction>

<cffunction name="create" returntype="string" access="public" output="false">
		<cfargument name="fileObj" type="any" required="yes"/>
		<cfargument name="contentid" type="any" required="yes"/>
		<cfargument name="siteid" type="any" required="yes"/>
		<cfargument name="filename" type="any" required="yes"/>
		<cfargument name="contentType" type="string" required="yes"/>
		<cfargument name="contentSubType" type="string" required="yes"/>
		<cfargument name="fileSize" type="numeric" required="yes"/>
		<cfargument name="moduleID" type="string" required="yes"/>
		<cfargument name="fileExt" type="string" required="yes"/>
		<cfargument name="fileObjSmall" type="any" required="yes"/>
		<cfargument name="fileObjMedium" type="any" required="yes"/>
		<cfargument name="fileID" type="any" required="yes" default="#createUUID()#"/>
	
		<cfreturn variables.fileDAO.create(arguments.fileObj,arguments.contentid,arguments.siteid,arguments.filename,arguments.contentType,arguments.contentSubType,arguments.fileSize,arguments.moduleID,arguments.fileExt,arguments.fileObjSmall,arguments.fileObjMedium,arguments.fileID) />
	
</cffunction>

<cffunction name="deleteAll" returntype="void" access="public" output="false">
		<cfargument name="contentID" type="string" required="yes"/>
		
		<cfset variables.fileDAO.deleteAll(arguments.contentID) />
			
</cffunction>

<cffunction name="deleteVersion" returntype="void" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		
		<cfset variables.fileDAO.deleteVersion(arguments.fileID) />
	
</cffunction>

<cffunction name="deleteIfNotUsed" returntype="void" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfargument name="contentHistID" type="any" required="yes"/>
	
		<cfset variables.fileDAO.deleteIfNotUsed(arguments.fileID,arguments.contentHistID) />
	
</cffunction>

<cffunction name="readMeta" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
	
		<cfreturn variables.fileDAO.readMeta(arguments.fileID) />
	
</cffunction>

<cffunction name="read" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
	
		<cfreturn variables.fileDAO.read(arguments.fileID) />
	
</cffunction>

<cffunction name="readAll" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
	
		<cfreturn variables.fileDAO.readAll(arguments.fileID) />
	
</cffunction>

<cffunction name="readSmall" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
	
		<cfreturn variables.fileDAO.readSmall(arguments.fileID) />
	
</cffunction>

<cffunction name="readMedium" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
	
		<cfreturn variables.fileDAO.readMedium(arguments.fileID) />
	
</cffunction>

<cffunction name="renderFile" output="true" access="public">
<cfargument name="fileID" type="string">
<cfargument name="method" type="string" required="true" default="inline">

	<cfset var rsFileData="" />
	<cfset var delim="" />
	<cfset var theFile="" />
	<cfset var theFileLocation="" />
	<cfset var pluginManager=getBean("pluginManager")>	
	<cfset var pluginEvent = createObject("component","mura.event") />
	
	<cfif not isValid("UUID",arguments.fileID)>
		<cfdump var="Invalid fileID">
		<cfabort>
	</cfif>
	
		<cfswitch expression="#variables.configBean.getFileStore()#">	
			<cfcase value="database">
				<cfset rsFileData=read(arguments.fileid) />
				<cfset arguments.siteID=rsFileData.siteid>
				<cfset arguments.rsFile=rsFileData>
				<cfset pluginEvent.init(arguments)>
				<cfset pluginManager.announceEvent("onBeforeFileRender",pluginEvent)>
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfileData.filename#"'>
				<cfheader name="Content-Length" value="#arrayLen(rsFileData.image)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfileData.contentType#/#rsfileData.contentSubType#",rsFileData.image)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfileData.contentType#/#rsfileData.contentSubType#",rsFileData.image)>
				</cfif>
				<cfset pluginManager.announceEvent("onAfterFileRender",pluginEvent)>
			</cfcase>
			<cfcase value="filedir">
				<cfset rsFileData=readMeta(arguments.fileid) />
				<cfset arguments.siteID=rsFileData.siteid>
				<cfset arguments.rsFile=rsFileData>
				<cfset pluginEvent.init(arguments)>
				<cfset pluginManager.announceEvent("onBeforeFileRender",pluginEvent)>
				<cfset delim=variables.configBean.getFileDelim() />
				<cfset theFileLocation="#variables.configBean.getFileDir()##delim##rsFileData.siteid##delim#cache#delim#file#delim##arguments.fileID#.#rsFileData.fileExt#" />
				<cffile action="readBinary" file="#theFileLocation#" variable="theFile">
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfileData.filename#"'> 
				<cfheader name="Content-Length" value="#arrayLen(theFile)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfileData.contentType#/#rsfileData.contentSubType#",theFile)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfileData.contentType#/#rsfileData.contentSubType#",theFile)>
				</cfif>
				<cfset pluginManager.announceEvent("onAfterFileRender",pluginEvent)>
			</cfcase>
			<cfcase value="S3">	
				<cfset rsFileData=readMeta(arguments.fileid) />
				<cfset arguments.siteID=rsFileData.siteid>
				<cfset arguments.rsFile=rsFileData>
				<cfset pluginEvent.init(arguments)>
				<cfset pluginManager.announceEvent("onBeforeFileRender",pluginEvent)>	
				<cfset renderS3(fileid=arguments.fileid,method=arguments.method,size="normal") />
				<cfset pluginManager.announceEvent("onAfterFileRender",pluginEvent)>	
			</cfcase>
		</cfswitch>		

</cffunction>

<cffunction name="renderSmall" output="true" access="public">
<cfargument name="fileID" type="string">
<cfargument name="method" type="string" required="true" default="inline">

	<cfset var rsFile="" />
	<cfset var delim="" />
	<cfset var theFile="" />
	<cfset var theFileLocation="" />
	
	<cfif not isValid("UUID",arguments.fileID)>
		<cfdump var="Invalid fileID">
		<cfabort>
	</cfif>
		
		<cfswitch expression="#variables.configBean.getFileStore()#">	
			<cfcase value="database">
				<cfset rsFile=readSmall(arguments.fileid) />
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'>
				<cfheader name="Content-Length" value="#arrayLen(rsFile.imageSmall)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.imageSmall)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.imageSmall)>
				</cfif>
			</cfcase>
			<cfcase value="filedir">
				<cfset rsFile=readMeta(arguments.fileid) />
				<cfset delim=variables.configBean.getFileDelim() />
				<cfset theFileLocation="#variables.configBean.getFileDir()##delim##rsFile.siteid##delim#cache#delim#file#delim##arguments.fileID#_small.#rsFile.fileExt#" />
				<cffile action="readBinary" file="#theFileLocation#" variable="theFile">
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'> 
				<cfheader name="Content-Length" value="#arrayLen(theFile)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile)>
				</cfif>
			</cfcase>
			<cfcase value="S3">
				<cfset renderS3(fileid=arguments.fileid,method=arguments.method,size="_small") />
			</cfcase>
		</cfswitch>	
		
</cffunction>

<cffunction name="renderMedium" output="true" access="public">
<cfargument name="fileID" type="string">
<cfargument name="method" type="string" required="true" default="inline">

	<cfset var rsFile="" />
	<cfset var delim="" />
	<cfset var theFile="" />
	<cfset var theFileLocation="" />
	
	<cfif not isValid("UUID",arguments.fileID)>
		<cfdump var="Invalid fileID">
		<cfabort>
	</cfif>
		 
		<cfswitch expression="#variables.configBean.getFileStore()#">	
			<cfcase value="database">
				<cfset rsFile=readMedium(arguments.fileid) />
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'>
				<cfheader name="Content-Length" value="#arrayLen(rsFile.imageMedium)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.imageMedium)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.imageMedium)>
				</cfif>
			</cfcase>
			<cfcase value="filedir">
				<cfset rsFile=readMeta(arguments.fileid) />
				<cfset delim=variables.configBean.getFileDelim() />
				<cfset theFileLocation="#variables.configBean.getFileDir()##delim##rsFile.siteid##delim#cache#delim#file#delim##arguments.fileID#_medium.#rsFile.fileExt#" />
				<cffile action="readBinary" file="#theFileLocation#" variable="theFile">
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'> 
				<cfheader name="Content-Length" value="#arrayLen(theFile)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile)>
				</cfif>
			</cfcase>
			<cfcase value="S3">
				<cfset renderS3(fileid=arguments.fileid,method=arguments.method,size="_medium") />
			</cfcase>
		</cfswitch>	
		
</cffunction>

<cffunction name="renderMimeType" output="true" access="public">
<cfargument name="mimeType" default="" required="yes" type="string">
<cfargument name="file" default="" required="yes" type="any">

<cfswitch expression="#variables.configBean.getCompiler()#">
	<cfcase value="railo">
		<cfset createObject("component","mura.content.file.renderRailo").init(arguments.mimeType,arguments.file) />
	</cfcase>
	<cfdefaultcase>
		<cfset createObject("component","mura.content.file.renderAdobe").init(arguments.mimeType,arguments.file) />
	</cfdefaultcase>
</cfswitch>
</cffunction>

<cffunction name="Process" returnType="struct">
<cfargument name="file">
<cfargument name="siteID">

	<cfreturn variables.imageProcessor.process(arguments.file,arguments.siteID) />
		
</cffunction>		

<cffunction name="renderS3" output="true" access="public" returntype="any">
	<cfargument name="fileid" type="string" required="true" />
	<cfargument name="method" type="string" required="false" default="inline" />
	<cfargument name="size" type="string" required="false" default="" />
	<cfargument name="bucket" type="string" required="false" default="#variables.bucket#" />
	<cfargument name="debug" type="boolean" required="false" default="false" />

	<cfscript>
		var local 		= structNew();
		local.rsFile	= readMeta(arguments.fileid);
		local.theFile 	= structNew();
		local.sizeList 	= "_small^_medium";
		local.methodList = "inline^attachment";

		if ( not listFindNoCase(local.sizeList, arguments.size, "^") ) {
			local.size = "";
		} else {
			local.size = arguments.size;
		};
		
		if ( not listFindNoCase(local.methodList, arguments.method, "^") ) {
			local.method = "inline";
		} else {
			local.method = arguments.method;
		};
	</cfscript>
	<cftry>
		<cfif len(variables.configBean.getProxyServer())>
			<cfhttp getasbinary="yes" result="local.theFile" method="get" url="http://s3.amazonaws.com/#arguments.bucket#/#local.rsFile.siteid#/#arguments.fileid##local.size#.#local.rsFile.fileExt#"
			proxyUser="#variables.configBean.getProxyUser()#" proxyPassword="#variables.configBean.getProxyPassword()#"
			proxyServer="#variables.configBean.getProxyServer()#" proxyPort="#variables.configBean.getProxyPort()#"></cfhttp>
		<cfelse>
			<cfhttp getasbinary="yes" result="local.theFile" method="get" url="http://s3.amazonaws.com/#arguments.bucket#/#local.rsFile.siteid#/#arguments.fileid##local.size#.#local.rsFile.fileExt#"></cfhttp>
		</cfif>
		<cfcatch>
		</cfcatch>
	</cftry>
	<cfif arguments.debug>
		<cfdump var="#local#" label="fileManager.renderS3().local" />
		<cfabort />
	</cfif>
	<cfif structKeyExists(local.rsFile, "filename")>
		<cfheader name="Content-Disposition" value="#local.method#;filename=""#local.rsFile.filename#""" />
	</cfif>
	<cfif structKeyExists(local.theFile, "fileContent") and isArray(local.theFile.fileContent)>
		<cfheader name="Content-Length" value="#arrayLen(local.theFile.fileContent)#" />
		<cfif structKeyExists(local.rsFile, "contentType") and structKeyExists(local.rsFile, "contentSubType")>
			<cfif variables.configBean.getCompiler() neq "Railo">
				<cfset createObject("component","mura.content.file.renderAdobe").init("#local.rsFile.contentType#/#local.rsFile.contentSubType#",local.theFile.fileContent) />
			<cfelse>
				<cfset createObject("component","mura.content.file.renderRailo").init("#local.rsFile.contentType#/#local.rsFile.contentSubType#",local.theFile.fileContent) />
			</cfif>
		</cfif>
	</cfif>	
</cffunction>

<cffunction name="emulateUpload" returntype="any" output="false">
	<cfargument name="filePath" type="string" required="true" />
	<cfargument name="destinationDir" type="string" required="true" default="#variables.configBean.getTempDir()#"/>
	<cfset var local = structNew() />
	
	<!--- create a URLconnection to the file to emulate uploading --->
	<cfset local.filePath=replace(arguments.filePath,"\","/","all")>
	<cfset local.results=structNew()>
	
	<cfif not find("://",local.filePath) or  find("file://",local.filePath)>
		<cfset local.filePath=replaceNoCase(local.filePath,"file://","")>
		<cfset local.connection=createObject("java","java.net.URL").init("file://" & local.filePath).openConnection()>
		<cfset local.connection.connect()>
		<cfset local.results.contentType=listFirst(local.connection.getContentType() ,"/")>
		<cfset local.results.contentSubType=listLast(local.connection.getContentType() ,"/")>
		<!---<cfset local.results.charSet=local.connection.getContentEncoding()>--->
		<cfset local.results.fileSize=local.connection.getContentLength()>
		<cffile action="readBinary" file="#local.filePath#" variable="local.fileContent">
	<cfelse>
		<cfif len(variables.configBean.getProxyServer())>
			<cfhttp url="#local.filePath#" result="local.remoteGet" getasbinary="yes" 
			proxyUser="#variables.configBean.getProxyUser()#" proxyPassword="#variables.configBean.getProxyPassword()#"
			proxyServer="#variables.configBean.getProxyServer()#" proxyPort="#variables.configBean.getProxyPort()#">
				<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
			</cfhttp>
		<cfelse>
			<cfhttp url="#local.filePath#" result="local.remoteGet" getasbinary="yes">
				<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
			</cfhttp>
		</cfif>

		<cfset local.results.contentType=listFirst(local.remoteGet.mimeType ,"/")>
		<cfset local.results.contentSubType=listLast(local.remoteGet.mimeType ,"/")>
		<cfset local.results.fileSize=len(local.remoteGet.fileContent)>
		<cfset local.fileContent=local.remoteGet.fileContent>
			
	</cfif>

	<cfset local.results.serverFileExt=listLast(local.filePath ,".")>
	<cfset local.results.serverDirectory=arguments.destinationDir>
	<cfset local.results.serverFile=replace(listLast(local.filePath ,"/")," ","-","all")>
	<cfset local.results.clientFile=local.results.serverFile>
	<cfset local.results.serverFileName=listFirst(local.results.serverFile ,".")>
	<cfset local.results.clientFileName=listFirst(local.results.clientFile ,".")>
	<cfset local.results.clientFileExt=listLast(local.filePath ,".")>
	
	<cfif listFind("/,\",right(local.results.serverDirectory,1))>
		<cfset local.results.serverDirectory=left(local.results.serverDirectory, len(local.results.serverDirectory)-1 )>
	</cfif>
	
	<cfset local.fileuploaded=false>
	<cfset local.filecreateattempt=1>
	<cfloop condition="not local.fileuploaded">
		<cfif not fileExists("#local.results.serverDirectory#/#local.results.serverFile#")>
			<cffile action="write" file="#local.results.serverDirectory#/#local.results.serverFile#" output="#local.fileContent#" >
			<cfset local.fileuploaded=true>
		<cfelse>
			<cfset local.results.serverFile=local.results.serverFileName & local.filecreateattempt & "." & local.results.serverFileExt>
			<cfset local.filecreateattempt=local.filecreateattempt+1>
		</cfif>
	</cfloop>
	
	<cfreturn local.results>

</cffunction>

<cffunction name="isPostedFile" output="false">
<cfargument name="theFileField">
<cfreturn listFindNoCase("tmp,upload",listLast(arguments.theFileField,"."))>
</cffunction>

<cffunction name="purgeDeleted" output="false">
	<cfset variables.fileDAO.purgeDeleted()>
</cffunction>

<cffunction name="restoreVersion" output="false">
	<cfargument name="fileID">
	<cfset variables.fileDAO.restoreVersion(arguments.fileID)>
</cffunction>

</cfcomponent>