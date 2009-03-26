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
	
		<cfreturn variables.fileDAO.create(arguments.fileObj,arguments.contentid,arguments.siteid,arguments.filename,arguments.contentType,arguments.contentSubType,arguments.fileSize,arguments.moduleID,arguments.fileExt,arguments.fileObjSmall,arguments.fileObjMedium) />
	
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

	<cfset var rsFile="" />
	<cfset var delim="" />
	<cfset var theFile="" />
	<cfset var theFileLocation="" />
		
		<cfswitch expression="#variables.configBean.getFileStore()#">	
			<cfcase value="database">
				<cfset rsFile=read(arguments.fileid) />
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'>
				<cfheader name="Content-Length" value="#arrayLen(rsFile.image)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.image)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfile.contentType#/#rsfile.contentSubType#",rsFile.image)>
				</cfif>
			</cfcase>
			<cfcase value="filedir">
				<cfset rsFile=readMeta(arguments.fileid) />
				<cfset delim=variables.configBean.getFileDelim() />
				<cfset theFileLocation="#variables.configBean.getFileDir()##delim##rsFile.siteid##delim#cache#delim#file#delim##arguments.fileID#.#rsFile.fileExt#" />
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
				<cfset rsFile=readMeta(arguments.fileid) />
				<cfhttp getasbinary="yes" result="theFile" method="get" url="http://s3.amazonaws.com/#variables.bucket#/#rsFile.siteid#/#arguments.fileID#.#rsFile.fileExt#"></cfhttp>
				<cfheader name="Content-Length" value="#arrayLen(theFile.fileContent)#">
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'> 
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile.fileContent)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile.fileContent)>
				</cfif>
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
				<cfset rsFile=readMeta(arguments.fileid) />
				<cfhttp getasbinary="yes" result="theFile" method="get" url="http://s3.amazonaws.com/#variables.bucket#/#rsFile.siteid#/#arguments.fileID#_small.#rsFile.fileExt#"></cfhttp>
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'> 
				<cfheader name="Content-Length" value="#arrayLen(theFile.fileContent)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile.fileContent)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile.fileContent)>
				</cfif>
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
				<cfset rsFile=readMeta(arguments.fileid) />
				<cfhttp getasbinary="yes" result="theFile" method="get" url="http://s3.amazonaws.com/#variables.bucket#/#rsFile.siteid#/#arguments.fileID#_medium.#rsFile.fileExt#"></cfhttp>
				<cfheader name="Content-Disposition" value='#arguments.method#;filename="#rsfile.filename#"'> 
				<cfheader name="Content-Length" value="#arrayLen(theFile.fileContent)#">
				<cfif variables.configBean.getCompiler() neq 'Railo'>
					<cfset createObject("component","mura.content.file.renderAdobe").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile.fileContent)>
				<cfelse>
					<cfset createObject("component","mura.content.file.renderRailo").init("#rsfile.contentType#/#rsfile.contentSubType#",theFile.fileContent)>
				</cfif>
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

</cfcomponent>