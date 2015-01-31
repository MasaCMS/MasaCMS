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

		<cfset variables.imageProcessor=createObject("component","processImgCfimage").init(arguments.configBean,arguments.settingsManager) />
	
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
		<cfargument name="fileObjSource" type="any" required="yes" default=""/>
		<cfargument name="credits" type="string" required="yes" default=""/>
		<cfargument name="caption" type="string" required="yes" default=""/>
		<cfargument name="alttext" type="string" required="yes" default=""/>
		<cfargument name="remoteID" type="string" required="yes" default=""/>
		<cfargument name="remoteURL" type="string" required="yes" default=""/>
		<cfargument name="remotePubDate" type="string" required="yes" default=""/>
		<cfargument name="remoteSource" default=""/>
		<cfargument name="remoteSourceURL" type="string" required="yes" default=""/>
		<!---<cfargument name="gpsaltitude" type="string" required="yes" default=""/>
		<cfargument name="gpsaltiuderef" type="string" required="yes" default=""/>
		<cfargument name="gpslatitude" type="string" required="yes" default=""/>
		<cfargument name="gpslatituderef" type="string" required="yes" default=""/>
		<cfargument name="gpslongitude" type="string" required="yes" default=""/>
		<cfargument name="gpslongituderef" type="string" required="yes" default=""/>
		<cfargument name="gpsimgdirection" type="string" required="yes" default=""/>
		<cfargument name="gpstimestamp" type="string" required="yes" default=""/>--->
		<cfargument name="exif" type="string" required="yes" default=""/>
	
		<cfset arguments.siteid=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>

		<cfreturn variables.fileDAO.create(argumentCollection=arguments) />
	
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
<cfargument name="size" type="string" required="true" default="">

	<cfset var rsFileData="" />
	<cfset var delim="" />
	<cfset var theFile="" />
	<cfset var theFileLocation="" />
	<cfset var pluginManager=getBean("pluginManager")>	
	<cfset var pluginEvent = createObject("component","mura.event") />
	<cfset var fileCheck="" />

	<cfif not len(arguments.method)>
		<cfset arguments.method="inline">
	</cfif>
	
	<cfif not isValid("UUID",arguments.fileID) or find(".",arguments.size)>
		<cfset getBean("contentServer").render404()>
	</cfif>
	
		<cfswitch expression="#variables.configBean.getFileStore()#">	
			<cfcase value="database">
				<cfset rsFileData=read(arguments.fileid) />
				<cfif not rsFileData.recordcount>
					<cfset getBean("contentServer").render404()>
				</cfif>
				<cfset arguments.siteID=rsFileData.siteid>
				<cfset arguments.rsFile=rsFileData>
				<cfset pluginEvent.init(arguments)>
				<cfset pluginManager.announceEvent("onBeforeFileRender",pluginEvent)>
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfileData.filename#"'>
				<cfheader name="Content-Length" value="#arrayLen(rsFileData.image)#">
				<cfif variables.configBean.getCompiler() eq 'Adobe'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfileData.contentType#/#rsfileData.contentSubType#",rsFileData.image)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderLucee").init("#rsfileData.contentType#/#rsfileData.contentSubType#",rsFileData.image)>
				</cfif>
				<cfset pluginManager.announceEvent("onAfterFileRender",pluginEvent)>
			</cfcase>
			<cfcase value="filedir">
				<cfset rsFileData=readMeta(arguments.fileid) />
				<cfif not rsFileData.recordcount>
					<cfset getBean("contentServer").render404()>
				</cfif>
				<cfset arguments.siteID=rsFileData.siteid>
				<cfset arguments.rsFile=rsFileData>
				<cfset pluginEvent.init(arguments)>
				<cfset pluginManager.announceEvent("onBeforeFileRender",pluginEvent)>
				
				<cfif listFindNoCase('png,jpg,jpeg,gif',rsFileData.fileExt) and len(arguments.size)>				
					<cfset theFileLocation="#variables.configBean.getFileDir()#/#rsFileData.siteid#/cache/file/#arguments.fileID#_#arguments.size#.#rsFileData.fileExt#" />
					<cfif not fileExists(theFileLocation)>
						<cfset theFileLocation="#variables.configBean.getFileDir()#/#rsFileData.siteid#/cache/file/#arguments.fileID#.#rsFileData.fileExt#" />
					</cfif>
				<cfelse>
					<cfset theFileLocation="#variables.configBean.getFileDir()#/#rsFileData.siteid#/cache/file/#arguments.fileID#.#rsFileData.fileExt#" />
				</cfif>
				
				<cfset streamFile(theFileLocation,rsfileData.filename,"#rsfileData.contentType#/#rsfileData.contentSubType#",arguments.method,rsfileData.created)>
				<cfset pluginManager.announceEvent("onAfterFileRender",pluginEvent)>
			</cfcase>
			<cfcase value="S3">	
				<cfset rsFileData=readMeta(arguments.fileid) />
				<cfif not rsFileData.recordcount>
					<cfset getBean("contentServer").render404()>
				</cfif>
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
	<cfset var theFile="" />
	<cfset var theFileLocation="" />
	<cfset var fileCheck="" />
	
	<cfif not isValid("UUID",arguments.fileID)>
		<cfset getBean("contentServer").render404()>
	</cfif>
		
		<cfswitch expression="#variables.configBean.getFileStore()#">	
			<cfcase value="database">
				<cfset rsFile=readSmall(arguments.fileid) />
				<cfif not rsFile.recordcount>
					<cfset getBean("contentServer").render404()>
				</cfif>
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'>
				<cfheader name="Content-Length" value="#arrayLen(rsFile.imageSmall)#">
				<cfif variables.configBean.getCompiler() eq 'Adobe'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.imageSmall)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderLucee").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.imageSmall)>
				</cfif>
			</cfcase>
			<cfcase value="filedir">
				<cfset rsFile=readMeta(arguments.fileid) />
				<cfif not rsFile.recordcount>
					<cfset getBean("contentServer").render404()>
				</cfif>
				<cfset theFileLocation="#variables.configBean.getFileDir()#/#rsFile.siteid#/cache/file/#arguments.fileID#_small.#rsFile.fileExt#" />
				<cfset streamFile(theFileLocation,rsFile.filename,"#rsFile.contentType#/#rsFile.contentSubType#",arguments.method,rsFile.created)>
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
	<cfset var theFile="" />
	<cfset var theFileLocation="" />
	<cfset var fileCheck="" />
	
	<cfif not isValid("UUID",arguments.fileID)>
		<cfset getBean("contentServer").render404()>
	</cfif>
		 
		<cfswitch expression="#variables.configBean.getFileStore()#">	
			<cfcase value="database">
				<cfset rsFile=readMedium(arguments.fileid) />
				<cfif not rsFile.recordcount>
					<cfset getBean("contentServer").render404()>
				</cfif>
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'>
				<cfheader name="Content-Length" value="#arrayLen(rsFile.imageMedium)#">
				<cfif variables.configBean.getCompiler() eq 'Adobe'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.imageMedium)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderLucee").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.imageMedium)>
				</cfif>
			</cfcase>
			<cfcase value="filedir">
				<cfset rsFile=readMeta(arguments.fileid) />
				<cfif not rsFile.recordcount>
					<cfset getBean("contentServer").render404()>
				</cfif>
				<cfset theFileLocation="#variables.configBean.getFileDir()#/#rsFile.siteid#/cache/file/#arguments.fileID#_medium.#rsFile.fileExt#" />
				<cfset streamFile(theFileLocation,rsFile.filename,"#rsFile.contentType#/#rsFile.contentSubType#",arguments.method,rsFile.created)>
			</cfcase>
			<cfcase value="S3">
				<cfset renderS3(fileid=arguments.fileid,method=arguments.method,size="_medium") />
			</cfcase>
		</cfswitch>	
		
</cffunction>

<cffunction name="renderMimeType" output="true" access="public" hint="deprecated in favor of streamFile">
<cfargument name="mimeType" default="" required="yes" type="string">
<cfargument name="file" default="" required="yes" type="any">

<cfswitch expression="#variables.configBean.getCompiler()#">
	<cfcase value="adobe">
		<cfset createObject("component","mura.content.file.renderAdobe").init(arguments.mimeType,arguments.file) />
	</cfcase>
	<cfdefaultcase>
		<cfset createObject("component","mura.content.file.renderLucee").init(arguments.mimeType,arguments.file) />
	</cfdefaultcase>
</cfswitch>
</cffunction>

<cffunction name="Process" returnType="struct">
<cfargument name="file">
<cfargument name="siteID">

	<cfset var fileStruct=variables.imageProcessor.process(arguments.file,arguments.siteID) />
		
	<cfif not structKeyExists(fileStruct,"fileObjSource")>
		<cfset fileStruct.fileObjSource="">
	</cfif>
	
	<cfreturn fileStruct>
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
			<cfhttp getasbinary="yes" result="local.theFile" method="get" url="http://#variables.configBean.getFileStoreEndPoint()#/#arguments.bucket#/#local.rsFile.siteid#/cache/file/#arguments.fileid##local.size#.#local.rsFile.fileExt#"
			proxyUser="#variables.configBean.getProxyUser()#" proxyPassword="#variables.configBean.getProxyPassword()#"
			proxyServer="#variables.configBean.getProxyServer()#" proxyPort="#variables.configBean.getProxyPort()#"></cfhttp>
		<cfelse>
			<cfhttp getasbinary="yes" result="local.theFile" method="get" url="http://#variables.configBean.getFileStoreEndPoint()#/#arguments.bucket#/#local.rsFile.siteid#/cache/file/#arguments.fileid##local.size#.#local.rsFile.fileExt#"></cfhttp>
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
			<cfif variables.configBean.getCompiler() eq 'adobe'>
				<cfset createObject("component","mura.content.file.renderAdobe").init("#local.rsFile.contentType#/#local.rsFile.contentSubType#",local.theFile.fileContent) />
			<cfelse>
				<cfset createObject("component","mura.content.file.renderLucee").init("#local.rsFile.contentType#/#local.rsFile.contentSubType#",local.theFile.fileContent) />
			</cfif>
		</cfif>
	</cfif>	
</cffunction>

<cffunction name="upload" output="false">
	<cfargument name="fileField">

	<cffile action="upload" result="local.results" filefield="#arguments.fileField#" nameconflict="makeunique" destination="#variables.configBean.getTempDir()#">
	
	<cfif listFindNoCase('jpg,jpeg',local.results.clientFileExt)>
		<cftry>
			<cfimage source="#local.results.serverDirectory#/#local.results.serverFile#" name="local.imageObj"> 
			<cfset local.results.exif=ImageGetEXIFMetadata(local.imageObj)>
			<cfcatch>
				<cfset local.results.exif={}>
			</cfcatch>
		</cftry>
	<cfelse>
		<cfset local.results.exif={}>
	</cfif>
	<cfreturn local.results>
</cffunction>

<cffunction name="emulateUpload" returntype="any" output="false">
	<cfargument name="filePath" type="string" required="true" />
	<cfargument name="destinationDir" type="string" required="true" default="#variables.configBean.getTempDir()#"/>
	<cfset var local = structNew() />
	
	<!--- create a URLconnection to the file to emulate uploading --->
	<cfset local.filePath=replace(arguments.filePath,"\","/","all")>
	<cfset local.results=structNew()>
	
	<cfif not find("://",local.filePath) or  find("file://",local.filePath)>
		<cfset local.isLocalFile=true>
		<cfset local.filePath=replaceNoCase(local.filePath,"file:///","")>
		<cfset local.filePath=replaceNoCase(local.filePath,"file://","")>
		
		<cfif not findNoCase("windows",server.os.name)>
			<cfset local.connection=createObject("java","java.net.URL").init("file://" & local.filePath).openConnection()>
		<cfelse>
			<cfset local.connection=createObject("java","java.net.URL").init("file:///" & local.filePath).openConnection()>
		</cfif>
		
		<cfset local.connection.connect()>
		<cfset local.results.contentType=listFirst(local.connection.getContentType() ,"/")>
		<cfset local.results.contentSubType=listLast(local.connection.getContentType() ,"/")>
		<!---<cfset local.results.charSet=local.connection.getContentEncoding()>--->
		<cfset local.results.fileSize=local.connection.getContentLength()>
		<!---<cffile action="readBinary" file="#local.filePath#" variable="local.fileContent">--->
	<cfelse>
		<cfset local.isLocalFile=false>
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
		<!---<cfset local.fileContent=local.remoteGet.fileContent>--->
			
	</cfif>

	<cfset local.results.serverFileExt=listLast(local.filePath ,".")>
	<cfset local.results.serverDirectory=arguments.destinationDir>
	<cfset local.results.serverFile=replace(listLast(local.filePath ,"/")," ","-","all")>
	<cfset local.results.clientFile=local.results.serverFile>
	<cfset local.results.serverFileName=listDeleteAt(local.results.serverFile,listLen(local.results.serverFile ,"."),".")>
	<cfset local.results.clientFileName=listDeleteAt(local.results.clientFile,listLen(local.results.clientFile ,"."),".")>
	<cfset local.results.clientFileExt=listLast(local.filePath ,".")>
	
	<cfif listFind("/,\",right(local.results.serverDirectory,1))>
		<cfset local.results.serverDirectory=left(local.results.serverDirectory, len(local.results.serverDirectory)-1 )>
	</cfif>
	
	<cfset local.fileuploaded=false>
	<cfset local.filecreateattempt=1>
	<cfloop condition="not local.fileuploaded">
		<cfif not fileExists("#local.results.serverDirectory#/#local.results.serverFile#")>
			<cfif local.isLocalFile>
				<cfif listFindNoCase('jpg,jpeg',local.results.clientFileExt)>
					<cftry>
						<cfimage source="#local.filePath#" name="local.imageObj"> 
						<cfset local.results.exif=ImageGetEXIFMetadata(local.imageObj)>
						<cfcatch>
							<cfset local.results.exif={}>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset local.results.exif={}>
				</cfif>
				<cffile action="copy" destination="#local.results.serverDirectory#/#local.results.serverFile#" source="#local.filePath#" >
			<cfelse>
				<cffile action="write" file="#local.results.serverDirectory#/#local.results.serverFile#" output="#local.remoteGet.fileContent#" >
				<cfif listFindNoCase('jpg,jpeg',local.results.clientFileExt)>
				<cftry>
					<cfimage source="#local.results.serverDirectory#/#local.results.serverFile#" name="local.imageObj"> 
					<cfset local.results.exif=ImageGetEXIFMetadata(local.imageObj)>
					<cfcatch>
						<cfset local.results.exif={}>
					</cfcatch>
				</cftry>
				<cfelse>
					<cfset local.results.exif={}>
				</cfif>
			</cfif>
			<cfset local.fileuploaded=true>
		<cfelse>
			<cfset local.results.serverFile=local.results.serverFileName & local.filecreateattempt & "." & local.results.serverFileExt>
			<cfset local.filecreateattempt=local.filecreateattempt+1>
		</cfif>
	</cfloop>
	
	<cfreturn local.results>

</cffunction>

<cffunction name="isPostedFile" output="false">
	<cfargument name="fileField">
	<cfreturn (structKeyExists(form,arguments.fileField) and listFindNoCase("tmp,upload",listLast(form['#arguments.fileField#'],"."))) or listFindNoCase("tmp,upload",listLast(arguments.fileField,"."))>
</cffunction>

<cffunction name="requestHasRestrictedFiles" output="false">
	<cfargument name="scope" default="#form#">
	<cfscript>
		var tempext='';
		var allowedExtensions=variables.configBean.getFMAllowedExtensions();
		
		if(!len(allowedExtensions)){
			return false;
		}

		for (var i in arguments.scope){
			if(structKeyExists(arguments.scope,'#i#')){
				if(isPostedFile(i)){

					temptext=listLast(getPostedClientFileName(i),'.');
					
					if(len(tempText) && len(tempText) < 4 && !listFindNoCase(allowedExtensions,temptext)){
						return true;
					}	
				}
				
				if(isValid('url',arguments.scope['#i#']) 
					&& listLen(arguments.scope['#i#'],'.')
					){
					
					tempText=listLast(arguments.scope['#i#'],'.');

					if(len(tempText) < 4 && !listFindNoCase(allowedExtensions,temptext)){
						return true;
					}	
				}
			}
		}
	
		return false;
	</cfscript>
</cffunction>

<cffunction name="getPostedClientFileName" returntype="string" output="false" hint="">
    <cfargument name="fieldName" required="true" type="string" hint="Name of the Form field" />
    <cftry>
	    <cfif variables.configBean.getCompiler() eq 'Adobe'>
		    <cfset var tmpPartsArray = Form.getPartsArray() />

		    <cfif IsDefined("tmpPartsArray")>
		        <cfloop array="#tmpPartsArray#" index="local.tmpPart">
		            <cfif local.tmpPart.isFile() AND local.tmpPart.getName() EQ arguments.fieldName> <!---   --->
		                <cfreturn local.tmpPart.getFileName() />
		            </cfif>
		        </cfloop>
		    </cfif>
	    <cfelse>
	    	<cfreturn GetPageContext().formScope().getUploadResource(arguments.fieldname).getName()>	
	    </cfif>
	    <cfcatch>
	    	<cflog type="Error" file="exception" text="#exception.stacktrace#">
		</cfcatch>
    </cftry>

    <cfreturn "" />
</cffunction>

<cffunction name="purgeDeleted" output="false">
	<cfargument name="siteid" default="">
	<cfset arguments.siteid=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>
	<cfset variables.fileDAO.purgeDeleted(arguments.siteID)>
</cffunction>

<cffunction name="restoreVersion" output="false">
	<cfargument name="fileID">
	<cfset variables.fileDAO.restoreVersion(arguments.fileID)>
</cffunction>

<cffunction name="cleanFileCache" output="false">
<cfargument name="siteID">

	<cfset arguments.siteid=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>

	<cfset var rsDB="">
	<cfset var rsDIR="">
	<cfset var rsCheck="">
	<cfset var filePath="#application.configBean.getFileDir()#/#arguments.siteID#/cache/file/">
	<cfset var check="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDB')#">
	select fileID from tfiles where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfquery>
	
	<cfdirectory action="list" name="rsDIR" directory="#filePath#">
	
	<cfloop query="rsDir">
		<cfif not find('.svn',#rsDir.name#)>
			<cfquery name="rsCheck" dbType="query">
			select * from rsDB where fileID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsDIR.name,35)#">
			</cfquery>
			
			<cfif not rsCheck.recordcount>
				<cffile action="delete" file="#filepath##rsDir.name#">
			</cfif>
		</cfif>
	</cfloop>

	<cfdirectory action="list" name="rsDIR" directory="#filePath#">
	
	<cfquery name="rsCheck" dbType="query">
	select * from rsDIR where name like '%_H%'
	</cfquery>

	<cfif rsCheck.recordcount>
		<cfloop query="rscheck">
			<cfset check=listGetAt(rsCheck.name,2,"_")>
			<cfif len(check) gt 1>
				<cfset check=mid(check,2,1)>
				<cfif isNumeric(check)>
					<cffile action="delete" file="#filepath##rsCheck.name#">
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="rebuildImageCache" output="false">
<cfargument name="siteID">
<cfargument name="size" default="">

	<cfset arguments.siteid=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>

	<cfset var rsDB="">
	<cfset var rsCheck="">
	<cfset var rsDir="">
	<cfset var currentSite=variables.settingsManager.getSite(arguments.siteID)>
	<cfset var filePath="#application.configBean.getFileDir()#/#arguments.siteID#/cache/file/">
	<cfset var check="">
	<cfset var currentSource="">
	<cfset var i="">

	<cfquery attributeCollection="#variables.configBean.getReadOnlyQRYAttrs(name='rsDB')#">
	select fileID,fileEXT from tfiles 
	where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	and fileEXT in ('jpg','jpeg','png','gif')
	</cfquery>
	
	<cfif len(arguments.size)>
		<cfset sizeList=arguments.size>
	<cfelse>
		<cfset var sizeList="small,medium,large">
		<cfset var rsSize=currentSite.getCustomImageSizeQuery()>

		<cfloop query="rsSize">
			<cfset sizeList=listAppend(sizeList,rsSize.name)>
		</cfloop>
	</cfif>

	<cfloop query="rsDB">
		<cfset currentSource=filepath & rsDB.fileID & "_source." & rsDB.fileEXT>
		<cfif not fileExists(currentSource)>
			<cfset currentSource=filepath & rsDB.fileID & "." & rsDB.fileEXT>
		</cfif>
		<cfif FileExists(currentSource)>
			<cfloop list="#sizeList#" index="i">
				<cfset cropAndScale(fileID=rsDB.fileID,size=i,siteid=arguments.siteid)>
			</cfloop>
		</cfif>
	</cfloop>
	
	<cfdirectory action="list" name="rsDIR" directory="#filePath#">
	
	<cfquery name="rsCheck" dbType="query">
		select * from rsDIR where name like '%_H%'
	</cfquery>

	<cfif rsCheck.recordcount>
		<cfset check=listGetAt(rsCheck.name,2,"_")>
		<cfif len(check) gt 1>
			<cfset check=mid(check,2,1)>
			<cfif isNumeric(check)>
				<cffile action="delete" file="#filepath##rsCheck.name#">
			</cfif>
		</cfif>
	</cfif>
	
</cffunction>

<cffunction name="streamFile" output="false">
<cfargument name="filePath">
<cfargument name="filename">
<cfargument name="mimetype">
<cfargument name="method" type="string" required="true" default="inline">
<cfargument name="lastModified" required="true" default="#now()#">
<cfargument name="deleteFile" type="boolean" required="true" default="false">
<cfset var local=structNew()>

	<cfif findNoCase("video",arguments.mimetype)>
		<cfset arguments.method = "attachment">
	</cfif>

	<cfif application.CFVersion gt 7>
		<cftry>
			<cfif structkeyexists(cgi, "http_if_modified_since")>
				<cfif parsedatetime(cgi.http_if_modified_since) gt arguments.lastModified>
				 	 <cfheader statuscode=304 statustext="Not modified"/>
				 	 <cfabort/>
			 	</cfif>
			</cfif>
			
			<cfheader name="Last-Modified" value="#gethttptimestring(arguments.lastModified)#"/>
		<cfcatch></cfcatch>
		</cftry>

		<cfheader name="Last-Modified" value="#gethttptimestring(arguments.lastModified)#"/>
		
    	<cfset local.fileCheck = FileOpen(arguments.filepath, "readBinary")>
    	<cfheader name="Content-Length" value="#listFirst(local.fileCheck.size,' ')#">
    	<cfset FileClose(local.fileCheck)>	
    </cfif>

	<cfheader name="Content-Disposition" value='#arguments.method#;filename="#arguments.filename#"'>
	<cfcontent file="#arguments.filePath#" type="#arguments.mimetype#" deletefile="#arguments.deleteFile#">

</cffunction>

<cffunction name="getCustomImage">
	<cfargument name="Image" required="true" />
	<cfargument name="Height" default="AUTO" />
	<cfargument name="Width" default="AUTO" />
	<cfargument name="size" default="" />
	<cfargument name="siteID" default="" />

	<cfset arguments.siteid=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>

	<cfreturn variables.imageProcessor.getCustomImage(argumentCollection=arguments) />
</cffunction>

<cffunction name="createHREFForImage" output="false" returntype="any">
<cfargument name="siteID">
<cfargument name="fileID">
<cfargument name="fileExt">
<cfargument name="size" required="true" default="undefined">
<cfargument name="direct" required="true" default="#this.directImages#">
<cfargument name="complete" type="boolean" required="true" default="false">
<cfargument name="height" default=""/>
<cfargument name="width" default=""/>
<cfargument name="secure" default="false">

	<cfset var imgSuffix="">
	<cfset var returnURL="">
	<cfset var begin="">

	<cfif not structKeyExists(arguments,"fileEXT")>
		<cfset arguments.fileEXT=getBean("fileManager").readMeta(arguments.fileID).fileEXT>
	</cfif>
	
	<cfif not ListFindNoCase('jpg,jpeg,png,gif', arguments.fileEXT)>
		<cfreturn ''>
	</cfif>
	
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=session.siteID>
	</cfif>

	<cfset arguments.siteid=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>
	
	<cfif arguments.complete or  arguments.secure or isDefined('variables.$') and len(variables.$.event('siteID')) and variables.$.event('siteID') neq arguments.siteID >
		<cfif arguments.secure>
			<cfset begin='https://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#'>
		<cfelse>
			<cfset begin='#application.settingsManager.getSite(arguments.siteID).getScheme()#://#application.settingsManager.getSite(arguments.siteID).getDomain()##application.configBean.getServerPort()#'>
		</cfif>
	<cfelse>
		<cfset var begin="">
	</cfif>
	
	<cfif request.muraExportHtml>
		<cfset arguments.direct=true>
	</cfif>
	
	<cfif arguments.direct and listFindNoCase("fileDir,s3",application.configBean.getFileStore())>

		<cfif arguments.size eq 'undefined'>
			<cfif (isNumeric(arguments.width) or isNumeric(arguments.height))>
				<cfset arguments.size ='Custom'>
			<cfelse>
				<cfset arguments.size ='Large'>
			</cfif>
		</cfif>

		<cfif arguments.size neq 'Custom'>			
			<cfset arguments.width="auto">
			<cfset arguments.height="auto">
		<cfelse>
			<cfif not isNumeric(arguments.width)>
				<cfset arguments.width="auto">
			</cfif>

			<cfif not isNumeric(arguments.height)>
				<cfset arguments.height="auto">
			</cfif>

			<cfif isNumeric(arguments.height) or isNumeric(arguments.width)>
				<cfset arguments.size="Custom">
			</cfif>

			<cfif arguments.size eq "Custom" and arguments.height eq "auto" and arguments.width eq "auto">
				<cfset arguments.size="small">
			</cfif>
		</cfif>
		
		<cfif listFindNoCase('small,medium,large,source',arguments.size)>
			<cfif arguments.size eq "large">
				<cfset imgSuffix="">
			<cfelse>
				<cfset imgSuffix="_" & lcase(arguments.size)>
			</cfif>
			<cfset returnURL=application.configBean.getAssetPath() & "/" & arguments.siteID & "/cache/file/" & arguments.fileID & imgSuffix & "." & arguments.fileEXT>
		<cfelseif arguments.size neq 'custom'>
			<cfset returnURL = application.configBean.getAssetPath() & "/" & arguments.siteID & "/cache/file/" & getCustomImage(image="#application.configBean.getFileDir()#/#arguments.siteid#/cache/file/#arguments.fileID#.#arguments.fileExt#",size=arguments.size,siteID=arguments.siteID)>
		<cfelse>
			<cfif not len(arguments.width)>
				<cfset arguments.width="auto">
			</cfif>
			<cfif not len(arguments.height)>
				<cfset arguments.height="auto">
			</cfif>
			<cfset returnURL = application.configBean.getAssetPath() & "/" & arguments.siteID & "/cache/file/" & getCustomImage(image="#application.configBean.getFileDir()#/#arguments.siteid#/cache/file/#arguments.fileID#.#arguments.fileExt#",height=arguments.height,width=arguments.width,siteID=arguments.siteID)>
		</cfif>
	<cfelse>
		<cfif arguments.size eq "large">
			<cfset imgSuffix="file">
		<cfelse>
			<cfset imgSuffix=arguments.size>
		</cfif>
		<cfset returnURL=application.configBean.getContext() & "/index.cfm/_api/render/#imgSuffix#/?fileID=" & arguments.fileID & "&fileEXT=" &  arguments.fileEXT>
	</cfif>
	
	<cfreturn begin & returnURL>
	
</cffunction>

<cffunction name="cropAndScale" output="false">
	<cfargument name="fileID">
	<cfargument name="size">
	<cfargument name="x">
	<cfargument name="y">
	<cfargument name="height">
	<cfargument name="width">
	<cfargument name="siteid">

	<cfset arguments.siteid=getBean('settingsManager').getSite(arguments.siteid).getFilePoolID()>

	<cfset var rsMeta=readMeta(arguments.fileID)>
	<cfset var site=variables.settingsManager.getSite(rsMeta.siteID)>
	<cfset var file="">
	<cfset var source="#application.configBean.getFileDir()#/#arguments.siteID#/cache/file/#arguments.fileID#_source.#rsMeta.fileExt#">
	<cfset var cropper=structNew()>
	<cfset var customImageSize="">

	<cfset arguments.size=lcase(arguments.size)>
	
	<cfif not fileExists(source)>
		<cfset source="#application.configBean.getFileDir()#/#arguments.siteID#/cache/file/#arguments.fileID#.#rsMeta.fileExt#">
	</cfif>

	<cfif rsMeta.recordcount and IsImageFile(source)>

		<cfif arguments.size eq "large">
			<cfset var file="#application.configBean.getFileDir()#/#arguments.siteID#/cache/file/#arguments.fileID#.#rsMeta.fileExt#">
		<cfelse>
			<cfset var file="#application.configBean.getFileDir()#/#arguments.siteID#/cache/file/#arguments.fileID#_#arguments.size#.#rsMeta.fileExt#">
		</cfif>

		<cfif fileExists(file)>
			<cfset fileDelete(file)>	
		</cfif>

		<cfset cropper=imageRead(source)>

		<cfif isDefined('arguments.x')>	
			<cfset imageCrop(cropper,arguments.x,arguments.y,arguments.width,arguments.height)>
			<cfset ImageWrite(cropper,file,variables.configBean.getImageQuality())>
			
			<cfif listFindNoCase('small,medium,large',arguments.size)>
				<cfset variables.imageProcessor.resizeImage(
					image=file,
					height=evaluate("site.get#arguments.size#ImageHeight()"),
					width=evaluate("site.get#arguments.size#ImageWidth()")
				)>
			<cfelse>
				<cfset customImageSize=getBean('imageSize').loadBy(name=arguments.size,siteID=arguments.siteID)>
				<cfset variables.imageProcessor.resizeImage(
					image=file,
					height=customImageSize.getHeight(),
					width=customImageSize.getWidth()
				)>
			</cfif>
		<cfelse>
			<cfset ImageWrite(cropper,file,variables.configBean.getImageQuality())>
			<cfif listFindNoCase('small,medium,large',arguments.size)>
				<cfset variables.imageProcessor.resizeImage(
					image=file,
					height=evaluate("site.get#arguments.size#ImageHeight()"),
					width=evaluate("site.get#arguments.size#ImageWidth()")
				)>
			<cfelse>
				<cfset customImageSize=getBean('imageSize').loadBy(name=arguments.size,siteID=arguments.siteID)>
				<cfset variables.imageProcessor.resizeImage(
					image=file,
					height=customImageSize.getHeight(),
					width=customImageSize.getWidth()
				)>
			</cfif>
		</cfif>

		<cfset cropper=imageRead(file)>
		<cfreturn ImageInfo(cropper)>
	</cfif>
</cffunction>

<cffunction name="rotate">
	<cfargument name="fileID">
	<cfargument name="degrees" default="90">

	<cfset var rsMeta=readMeta(arguments.fileID)>
	<cfset var source="#application.configBean.getFileDir()#/#rsMeta.siteID#/cache/file/#arguments.fileID#_source.#rsMeta.fileExt#">
	<cfset var myImage="">
	
	<cfif rsMeta.recordcount and IsImageFile(source)>
		<cfscript>
			myImage=imageRead(source);
			ImageRotate(myImage,arguments.degrees);
			imageWrite(myImage,source,variables.configBean.getImageQuality());
		</cfscript>
	</cfif>
</cffunction>

<cffunction name="flip">
	<cfargument name="fileID">
	<cfargument name="transpose" default="horizontal">

	<cfset var rsMeta=readMeta(arguments.fileID)>
	<cfset var source="#application.configBean.getFileDir()#/#rsMeta.siteID#/cache/file/#arguments.fileID#_source.#rsMeta.fileExt#">
	<cfset var myImage="">
	
	<cfif rsMeta.recordcount and IsImageFile(source)>
		<cfscript>
			myImage=imageRead(source);
			ImageFlip(myImage,arguments.transpose);
			imageWrite(myImage,source,variables.configBean.getImageQuality());
		</cfscript>
	</cfif>
</cffunction>

<cffunction name="touchSourceImage" output="false">
	<cfargument name="fileID">

	<cfset var rsMeta=readMeta(arguments.fileID)>
	<cfset var source="#application.configBean.getFileDir()#/#rsMeta.siteID#/cache/file/#rsMeta.fileID#_source.#rsMeta.fileExt#">

	<cfif rsMeta.recordcount and not fileExists(source)>	
		<cfset getBean('fileWriter').copyFile(source="#application.configBean.getFileDir()#/#rsMeta.siteID#/cache/file/#rsMeta.fileID#.#rsMeta.fileExt#", destination=source)>	
	</cfif>
</cffunction>

</cfcomponent>
