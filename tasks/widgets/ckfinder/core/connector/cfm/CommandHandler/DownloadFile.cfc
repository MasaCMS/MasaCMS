<cfcomponent output="false" extends="CommandHandlerBase">
<!---
 * CKFinder
 * ========
 * http://cksource.com/ckfinder
 * Copyright (C) 2007-2014, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfset THIS.command = "DownloadFile" >

<cffunction name="throwError" access="public" hint="throw HTTP error" returntype="boolean" output="false" description="throw file upload error">
	<cfargument name="errorCode" type="Numeric" required="true">
	<cfargument name="errorMsg" type="String" required="false" default="">
	<cfargument name="fileName" type="String" required="false" default="">
	<cfset var er = REQUEST.constants>

	<cfif errorCode eq er.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST OR
		errorCode eq er.CKFINDER_CONNECTOR_ERROR_INVALID_NAME or
		errorCode eq er.CKFINDER_CONNECTOR_ERROR_THUMBNAILS_DISABLED or
		errorCode eq er.CKFINDER_CONNECTOR_ERROR_CONNECTOR_DISABLED or
		errorCode eq er.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED>
		<cfheader statuscode="403" statustext="Forbidden">
		<cfheader name="X-CKFinder-Error" value="#errorCode#">
	<cfelseif errorCode eq er.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED>
		<cfheader statuscode="500" statustext="Internal Server Error">
		<cfheader name="X-CKFinder-Error" value="#errorCode#">
	<cfelse>
		<cfheader statuscode="404" statustext="Not Found">
		<cfheader name="X-CKFinder-Error" value="#errorCode#">
	</cfif>

	<cfabort>
	<cfreturn true />
</cffunction>

<cffunction access="public" name="sendResponse" hint="send response" returntype="boolean" description="send response" output="false">

	<cfset var fileName = "">
	<cfset var filePath = "">
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem")>
	<cfset var currentFolderServerPath = "">
	<cfset var result = arrayNew(1) />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var er = "">
	<cfset var encodedName = "">

	<!--- TODO: create generic HTTP error handler --->
	<cftry>
		<cfset THIS.checkRequest()>
		<cfcatch type="ckfinder">
			<cfset this.throwerror(CFCATCH.ErrorCode)>
		</cfcatch>
		<cfcatch type="any">
			<cfset this.throwerror(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED)>
		</cfcatch>
	</cftry>

	<cfset currentFolderServerPath = THIS.currentFolder.getServerPath()>
	<cfset fileName = URL.FileName>
	<cfset filePath = currentFolderServerPath & fileName>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW) >
		<cfset this.throwerror(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED)>
	</cfif>

	<cfif not fileSystem.checkFileName(fileName)>
		<cfset this.throwerror(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST)>
	</cfif>

	<cfset result = THIS.currentFolder.checkExtension(URL.FileName)>
	<cfif not result[1]>
		<cfset this.throwerror(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST)>
	</cfif>

	<cfif not fileexists(filePath) or coreConfig.checkIsHiddenFile(fileName)>>
		<cfset this.throwerror(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND)>
	</cfif>

	<cfheader name="Cache-Control" value="cache, must-revalidate">
	<cfheader name="Pragma" value="public">
	<cfheader name="Expires" value="0">
	<!--- if java is not installed, just catch the exception and skip setting content-length --->
	<cftry>
		<cfheader name="Content-Length" value="#fileSystem.fileSize(filePath)#">
		<cfcatch type="any">
		</cfcatch>
	</cftry>

	<cfif structkeyexists(URL, "format") and URL.format eq "text">
		<cfcontent type="text/plain; charset=utf-8" file="#filePath#" />
	<cfelse>
		<cfset encodedName = Replace(fileName, """", """""")>
		<cfif FindNoCase('MSIE','#CGI.HTTP_USER_AGENT#') gt 0>
			<cfset encodedName = Replace(Replace(URLEncodedFormat(fileName), "+", " ", "all"), "%2E", ".", "all")>
		</cfif>
		<cfheader charset="utf-8" name="Content-Disposition" value="attachment; filename=#encodedName#">
		<cfcontent type="application/octet-stream" file="#filePath#" />
	</cfif>

	<cfreturn true>
</cffunction>

</cfcomponent>
