<cfcomponent output="false" extends="CommandHandlerBase">
<!---
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2010, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfset THIS.command = "DownloadFile" >

<cffunction access="public" name="sendResponse" hint="send response" returntype="boolean" description="send response" output="false">

	<cfset var fileName = "">
	<cfset var filePath = "">
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem")>
	<cfset var currentFolderServerPath = "">
	<cfset var result = arrayNew(1) />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var er = "">

	<!--- TODO: create generic HTTP error handler --->
	<cftry>
		<cfset THIS.checkRequest()>
		<cfcatch type="ckfinder">
			<cfset er = REQUEST.constants>
			<!--- cfswitch useless here --->
			<cfif CFCATCH.ErrorCode eq er.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST OR
				CFCATCH.ErrorCode eq er.CKFINDER_CONNECTOR_ERROR_INVALID_NAME or
				CFCATCH.ErrorCode eq er.CKFINDER_CONNECTOR_ERROR_THUMBNAILS_DISABLED or
				CFCATCH.ErrorCode eq er.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED>
				<cfheader statuscode="403" statustext="Forbidden">
				<cfheader name="X-CKFinder-Error" value="#CFCATCH.ErrorCode#">
				<cfabort>
			<cfelseif CFCATCH.ErrorCode eq er.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED>
				<cfheader statuscode="500" statustext="Internal Server Error">
				<cfheader name="X-CKFinder-Error" value="#CFCATCH.ErrorCode#">
				<cfabort>
			<cfelse>
				<cfheader statuscode="404" statustext="Not Found">
				<cfheader name="X-CKFinder-Error" value="#CFCATCH.ErrorCode#">
				<cfabort>
			</cfif>
		</cfcatch>
		<cfcatch type="any">
			<cfheader statuscode="403" statustext="Forbidden">
			<cfabort>
		</cfcatch>
	</cftry>

	<cfset currentFolderServerPath = THIS.currentFolder.getServerPath()>
	<cfset fileName = URL.FileName>
	<cfset filePath = currentFolderServerPath & fileName>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW) >
		<cfheader statuscode="403" statustext="Forbidden">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#">
		<cfabort>
	</cfif>

	<cfif not fileSystem.checkFileName(fileName)>
		<cfheader statuscode="403" statustext="Forbidden">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
		<cfabort>
	</cfif>

	<cfset result = THIS.currentFolder.checkExtension(URL.FileName)>
	<cfif not result[1]>
		<cfheader statuscode="403" statustext="Forbidden">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
		<cfabort>
	</cfif>

	<cfif not fileexists(filePath) or coreConfig.checkIsHiddenFile(fileName)>>
		<cfheader statuscode="404" statustext="Not Found">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND#">
		<cfabort>
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
		<cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
		<cfcontent type="application/octet-stream" file="#filePath#" />
	</cfif>

	<cfreturn true>
</cffunction>

</cfcomponent>
