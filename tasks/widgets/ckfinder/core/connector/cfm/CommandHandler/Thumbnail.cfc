<cfcomponent output="true" extends="CommandHandlerBase">
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

<cfset Init()>

<cffunction name="Init" access="public" returntype="any" output="true" hint="Returns an initialized instance.">
	<cfscript>
	THIS.maxWidth = 100;
	THIS.maxHeight = 100;
	THIS.quality = 80;
	</cfscript>
	<cfreturn THIS>
</cffunction>

<cffunction access="public" name="sendResponse" hint="send response" returntype="boolean" description="send response" output="true">

	<cfscript>
	var fileName = URL.FileName;
	var filePath = "";
	var thumbPath = "";
	var thumbName = "";
	var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem");
	var coreConfig = APPLICATION.CreateCFC("Core.Config");
	var currentFolderServerPath = "";
	var ext = "";
	var er = "";
	var etag = "";
	var fileSize = -1;
	var is304 = false;
	</cfscript>

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
	<cfset filePath = currentFolderServerPath & fileName>
	<cfset thumbPath = fileSystem.CombinePaths(THIS.currentFolder.getThumbsServerPath(), filesystem.getThumbFileName(fileName))>

	<cfif not structkeyexists(REQUEST.config.thumbnails, "enabled") or not REQUEST.config.thumbnails.enabled >
		<cfheader statuscode="403" statustext="Forbidden">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_THUMBNAILS_DISABLED#">
		<cfabort>
	</cfif>
	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW)>
		<cfheader statuscode="403" statustext="Forbidden">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#">
		<cfabort>
	</cfif>
	<cfif not fileSystem.checkFileName(fileName)>
		<cfheader statuscode="403" statustext="Forbidden">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
		<cfabort>
	</cfif>
	<cfif not fileexists(filePath) or coreConfig.checkIsHiddenFile(fileName)>
		<cfheader statuscode="404" statustext="Not Found">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND#">
		<cfabort>
	</cfif>
	<cfif not fileSystem.createDirectoryRecursively(thumbPath, true)>
		<cfheader statuscode="404" statustext="Not Found">
		<cfheader name="X-CKFinder-Error" value="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#">
		<cfabort>
	</cfif>

	<cfscript>
	if (not fileexists(thumbPath)) {
		if (structkeyexists(REQUEST.config.thumbnails, "maxWidth") and REQUEST.config.thumbnails.maxWidth gte 0) {
			THIS.maxWidth = REQUEST.config.thumbnails.maxWidth;
		}
		if (structkeyexists(REQUEST.config.thumbnails, "maxHeight") and REQUEST.config.thumbnails.maxHeight gte 0) {
			THIS.maxHeight = REQUEST.config.thumbnails.maxHeight;
		}
		if (structkeyexists(REQUEST.config.thumbnails, "quality") and REQUEST.config.thumbnails.quality gte 0 and REQUEST.config.thumbnails.quality lte 100) {
			THIS.quality = REQUEST.config.thumbnails.quality;
		}

		if (THIS.maxWidth eq 0 and THIS.maxHeight eq 0) {
			thumbPath = filePath;
		}
		else {
			APPLICATION.CreateCFC("Utils.Thumbnail").createThumbnail("#filePath#", "#thumbPath#", THIS.maxWidth, THIS.maxHeight, THIS.quality);
		}
	}
	lastModDate = fileSystem.getLastModifiedStamp(thumbPath);
	requestData = getHTTPRequestData();
	requestHeaders = requestData.headers;
	</cfscript>

	<!--- if java is not installed, just catch the exception --->
	<cftry>
		<cfset fileSize = "#fileSystem.fileSize(thumbPath)#">
		<cfcatch type="any">
			<cfset fileSize = -1>
		</cfcatch>
	</cftry>

	<cfset eTag = FormatBaseN(lastModDate, 16) & "-" & FormatBaseN(fileSize, 16)>

	<cfif structkeyexists(requestHeaders, "If-None-Match")>
		<cfif requestHeaders['If-None-Match'] eq eTag>
			<cfset is304 = true>
		</cfif>
	</cfif>

	<cfif structkeyexists(requestHeaders, "If-Modified-Since")>
		<cfset comparisonDate = APPLICATION.CreateCFC("Utils.Misc").httpTimeStringToTimestamp(requestHeaders['If-Modified-Since'])>
		<cfif DateCompare(lastModDate, comparisonDate) eq 0>
			<cfset is304 = true>
		</cfif>
	</cfif>

	<cfif is304 eq true>
		<cfheader statuscode="304" statustext="Not Modified" />
		<cfexit />
	</cfif>

	<cfheader name="Cache-Control" value="public">
	<cfheader name="Etag" value="#eTag#">
	<cfheader name="Last-Modified" value="#DateFormat(lastModDate,"ddd, dd mmm yyyy ")##TimeFormat(lastModDate," HH:mm:ss")#">
	<cfcontent type="#fileSystem.getFileMimeType(thumbPath)#" file="#thumbPath#" />
	<cfif fileSize gt 0>
		<cfheader name="Content-Length" value="#fileSize#">
	</cfif>

	<cfreturn true>
</cffunction>

</cfcomponent>
