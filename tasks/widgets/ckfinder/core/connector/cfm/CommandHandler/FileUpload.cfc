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

<cfset THIS.command = "FileUpload" >

<cffunction name="throwError" access="public" hint="throw file upload error" returntype="boolean" output="true" description="throw file upload error">
	<cfargument name="errorCode" type="Numeric" required="true">
	<cfargument name="errorMsg" type="String" required="false" default="">
	<cfargument name="fileName" type="String" required="false" default="">
	<cfif not Len(errorMsg) and errorCode >
		<cfset errorMsg = APPLICATION.CreateCFC("Utils.Misc").getErrorMessage(errorCode, fileName)>
	</cfif>
	<cfif isDefined('URL.response_type') and URL.response_type eq "txt">
		<cfcontent reset="true" type="text/plain; charset=UTF-8">
		<cfoutput>#fileName#|#errorMsg#</cfoutput>
	<cfelse>
		<cfif isDefined('URL.CKFinderFuncNum')>
			<cfcontent reset="true" type="text/html; charset=UTF-8">
			<cfif not Len(errorMsg) and errorCode >
				<cfset errorMsg = APPLICATION.CreateCFC("Utils.Misc").getErrorMessage(errorCode, fileName)>
			</cfif>
			<cfset funcNum = ReReplace(URL.CKFinderFuncNum, "[^0-9]", "", "all")>
			<cfif ARGUMENTS.errorCode eq REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_FILE_RENAMED or
			ARGUMENTS.errorCode eq REQUEST.constants.CKFINDER_CONNECTOR_ERROR_NONE>
				<cfoutput><script type="text/javascript">window.parent.CKFinder.tools.callFunction(#funcNum#, '#THIS.currentFolder.getUrl()##replace(fileName, "'", "\'")#', '#replace(errorMsg, "'", "\'")#') ;</script></cfoutput>
			<cfelse>
				<cfoutput><script type="text/javascript">window.parent.CKFinder.tools.callFunction(#funcNum#, '', '#replace(errorMsg, "'", "\'")#') ;</script></cfoutput>
			</cfif>
		<cfelse>
			<cfoutput><script type="text/javascript">window.parent.OnUploadCompleted('#replace(fileName, "'", "\'")#', '#replace(errorMsg, "'", "\'")#') ;</script></cfoutput>
		</cfif>
	</cfif>

	<cfreturn true />
</cffunction>

<cffunction access="public" name="sendResponse" hint="upload file and send response" returntype="boolean" description="upload file and send response" output="true">
	<cfset var fileName = "">
	<cfset var unsafeFileName = "">
	<cfset var fileFields = "">
	<cfset var filePath = "">
	<cfset var fileField = "">
	<cfset var maxSize = "0">
	<cfset var errorCode = "0">
	<cfset var originalFileName = "">
	<cfset var checkSizeAfterScaling = false>
	<cfset var i = "0">
	<cfset var checkResult = arrayNew(1)>
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem")>
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var fileNameWithoutExtension="">
	<cfset var fileExtension="">
	<cfset var currentFolderServerPath = THIS.currentFolder.getServerPath()>
	<cfset var sTempDir = "">
	<cfset var sServerDirectory = "">

	<!--- Settings for images --->
	<cfset var imageMaxWidth = "0">
	<cfset var imageMaxHeight = "0">
	<cfset var imageQuality = "100">

	<!--- temp directory --->
	<cfif isDefined( "REQUEST.Config.tempDirectory" )>
		<cfset sTempDir = REQUEST.Config.tempDirectory>
	<cfelse>
		<cfset sTempDir = GetTempDirectory()>
	</cfif>

	<!--- check file size after scaling? (applies to images only)--->
	<cfif isDefined( "REQUEST.Config.checkSizeAfterScaling" ) and REQUEST.Config.checkSizeAfterScaling>
		<cfset checkSizeAfterScaling = true>
	</cfif>

	<!--- maximum size of uploaded file --->
	<cfif structkeyexists(THIS.currentFolder.resourceTypeConfig, "maxSize")>
		<cfset maxSize = APPLICATION.CreateCFC("Utils.Misc").returnBytes(THIS.currentFolder.resourceTypeConfig.maxSize) />
	</cfif>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_UPLOAD) >
		<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED) />
		<cfreturn false />
	</cfif>

	<!--- upload file to temporary directory --->
	<cftry>
		<cfset THIS.checkRequest()>
		<!--- Flash sends many fieldnames during upload, so we need to use "upload" name for file input to avoid errors --->
		<cfif THIS.command eq "FileUpload" and isDefined("FORM.upload")>
			<cfset fileField = "upload">
		<cfelse>
			<cfset fileFields = ListToArray(FORM.FIELDNAMES)>
			<cfset fileField = "#fileFields[1]#">
		</cfif>
		<cfif isDefined( "REQUEST.Config.chmodFiles" ) and REQUEST.Config.chmodFiles>
			<cffile action="UPLOAD" filefield="#fileField#" destination="#sTempDir#" nameconflict="MAKEUNIQUE" mode="#REQUEST.Config.chmodFiles#" />
		<cfelse>
			<cffile action="UPLOAD" filefield="#fileField#" destination="#sTempDir#" nameconflict="MAKEUNIQUE" />
		</cfif>
		<cfcatch type="ckfinder">
			<cfset THIS.throwError(CFCATCH.ErrorCode)>
			<cfreturn false>
		</cfcatch>
		<cfcatch type="any">
			<cfset THIS.throwError(1, CFCATCH.Message)>
			<cfreturn false>
		</cfcatch>
	</cftry>


	<cfset checkResult = THIS.currentFolder.checkExtension(CFFILE.ClientFile) />
	<cfset unsafeFileName = checkResult[2] />
	<cfset fileName = reReplace(unsafeFileName, "[\:\*\?\|\/]", "_", "all") />
	<cfif isDefined( "REQUEST.Config.disallowUnsafeCharacters" ) and REQUEST.Config.disallowUnsafeCharacters>
		<cfset fileName = reReplace(fileName, "[\;]", "_", "all") />
	</cfif>
	<cfif unsafeFileName neq fileName>
		<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID_NAME_RENAMED />
	</cfif>

	<cfset sServerDirectory = replace(CFFILE.ServerDirectory, "\", "/", "all")>

	<!---file name is invalid --->
	<cfif not filesystem.checkFileName(fileName) or coreConfig.checkIsHiddenFile(fileName)>
		<cftry>
			<cffile action="DELETE" file="#sServerDirectory#/#CFFILE.ServerFile#" />
			<cfcatch type="any">
			</cfcatch>
		</cftry>
		<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME) />
		<cfreturn false />
	</cfif>

	<!---file name has invalid extension --->
	<cfif not checkResult[1]>
		<cftry>
			<cffile action="DELETE" file="#sServerDirectory#/#CFFILE.ServerFile#" />
			<cfcatch type="any">
			</cfcatch>
		</cftry>
		<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION)>
		<cfreturn false />
	</cfif>

	<!--- check file size --->
	<cfif not checkSizeAfterScaling>
		<cfif maxSize gt 0 and maxSize lt CFFILE.FileSize>
			<cftry>
				<cffile action="DELETE" file="#sServerDirectory#/#CFFILE.ServerFile#" />
				<cfcatch type="any">
				</cfcatch>
			</cftry>
			<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_TOO_BIG)>
			<cfreturn false />
		</cfif>
	</cfif>

	<!--- validate image size --->
	<cfif isDefined( "REQUEST.Config.secureImageUploads" ) and REQUEST.Config.secureImageUploads>
		<cfif not fileSystem.isImageValid( sServerDirectory & "/" & CFFILE.ServerFile, CFFILE.ClientFileExt )>
			<cftry>
				<cffile action="DELETE" file="#sServerDirectory#/#CFFILE.ServerFile#" />
				<cfcatch type="any">
				</cfcatch>
			</cftry>
			<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_CORRUPT)>
			<cfreturn false />
		</cfif>
	</cfif>

	<!--- check for suspicious HTML content --->
	<cfif isDefined( "REQUEST.Config.htmlExtensions" ) and not listFindNoCase( REQUEST.Config.htmlExtensions, CFFILE.ClientFileExt )>
		<cfif fileSystem.detectHtml( sServerDirectory & "/" & CFFILE.ServerFile )>
			<cftry>
				<cffile action="DELETE" file="#sServerDirectory#/#CFFILE.ServerFile#" />
				<cfcatch type="any">
				</cfcatch>
			</cftry>
			<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_WRONG_HTML_FILE)>
			<cfreturn false />
		</cfif>
	</cfif>

	<!--- resolve name conflicts --->
	<cfset originalFileName = fileName>
	<cfset fileNameWithoutExtension = fileSystem.getFileNameWithoutExtension(fileName)>
	<cfset fileExtension = fileSystem.getFileExtension(fileName)>
	<cfif REFindNoCase('^(AUX|COM[0-9]|CLOCK\$|CON|NUL|PRN|LPT[0-9])$', fileNameWithoutExtension)>
		<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME) />
		<cfreturn false />
	</cfif>

	<cfscript>
		while (true)
		{
			filePath = currentFolderServerPath & fileName;

			if (fileexists(filePath)) {
				i = i+1;
				fileName = fileNameWithoutExtension & "(" & i & ")" & fileExtension;
			}
			else {
				break;
			}
		}
	</cfscript>

	<!--- check if file name has been changed --->
	<cfif fileName neq originalFileName>
		<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_FILE_RENAMED />
	</cfif>

	<cftry>
		<!--- resize image if required --->
		<cfif structkeyexists(REQUEST.config, "images")>
			<cfif structkeyexists(REQUEST.config.images, "maxWidth") and REQUEST.config.images.maxWidth gte 0>
				<cfset imageMaxWidth = REQUEST.config.images.maxWidth>
			</cfif>
			<cfif structkeyexists(REQUEST.config.images, "maxHeight") and REQUEST.config.images.maxHeight gte 0>
				<cfset imageMaxHeight = REQUEST.config.images.maxHeight>
			</cfif>
			<cfif structkeyexists(REQUEST.config.images, "quality") and REQUEST.config.images.quality gte 0>
				<cfset imageQuality = REQUEST.config.images.quality>
			</cfif>
		</cfif>
>
		<cfif imageMaxWidth gt 0 and imageMaxHeight gt 0 and imageQuality gt 0>
			<cftry>
				<!--- scale image instead of copying --->
				<cfif APPLICATION.CreateCFC("Utils.Thumbnail").createThumbnail("#sServerDirectory#/#CFFILE.ServerFile#", "#currentFolderServerPath##fileName#", imageMaxWidth, imageMaxHeight, imageQuality)>
					<cftry>
						<cffile action="DELETE" file="#sServerDirectory#/#CFFILE.ServerFile#" />
						<cfcatch type="any">
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset fileSystem.moveTempFile(sServerDirectory & "/" & CFFILE.ServerFile, currentFolderServerPath & fileName)>
				</cfif>
				<cfcatch>
					<!---
					we try to create a thumbnail from each file
					if it's not an image file, we catch the exception
					and copy it to ther right place
					--->
					<cfset fileSystem.moveTempFile(sServerDirectory & "/" & CFFILE.ServerFile, currentFolderServerPath & fileName)>
				</cfcatch>
			</cftry>
		<cfelse>
			<!--- if we don't scale uploaded file, let's copy it'--->
			<cfset fileSystem.moveTempFile(sServerDirectory & "/" & CFFILE.ServerFile, currentFolderServerPath & fileName)>
		</cfif>

		<cfif checkSizeAfterScaling>
			<cfdirectory name = "myDir" action="list" directory="#currentFolderServerPath#" filter="#fileName#">
			<cfif maxSize gt 0 and maxSize lt myDir.Size>
				<cftry>
					<cffile action="DELETE" file="#currentFolderServerPath##fileName#" />
					<cfcatch type="any">
					</cfcatch>
				</cftry>
				<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_TOO_BIG)>
				<cfreturn false />
			</cfif>
		</cfif>

		<cfcatch type="any">
			<cfset THIS.throwError(1, CFCATCH.Message)>
			<cfreturn false />
		</cfcatch>
	</cftry>

	<cfset REQUEST.oHooks.run('AfterFileUpload', THIS.currentFolder, currentFolderServerPath & fileName)>

	<!--- if filename has been changed throw CKFINDER_CONNECTOR_ERROR_UPLOADED_FILE_RENAMED error --->
	<cfif (errorCode eq REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_FILE_RENAMED) or (errorCode eq REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_INVALID_NAME_RENAMED)>
		<cfset THIS.throwError(errorCode, "", fileName)>
	<!--- otherwise throw CKFINDER_CONNECTOR_ERROR_NONE to tell CKFinder that everything is fine --->
	<cfelse>
		<cfset THIS.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_NONE, "", fileName)>
	</cfif>

	<cfreturn true />
</cffunction>

</cfcomponent>
