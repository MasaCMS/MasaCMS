<cfcomponent output="false" extends="CKFinder_Connector.CommandHandler.XmlCommandHandlerBase">
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

<cfset THIS.command = "ImageResize" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">

	<cfset var filePath = "" />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var newWidth = 0>
	<cfset var newHeight = 0>
	<cfset var quality = 80>
	<cfset var size = "">
	<cfset var resizeOriginal = false>
	<cfset var nameWithoutExt = "">

	<cfif not REQUEST.CheckAuthentication()>
		<cfthrow errorCode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_CONNECTOR_DISABLED#" type="ckfinder" />
	</cfif>

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<!--- Saving empty file is equal to deleting a file, that's why FILE_DELETE permissions are required --->
	<cfif not THIS.currentFolder.checkAcl(bitor(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_UPLOAD, REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_DELETE)) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfif not fileSystem.checkFileName(FORM.fileName) or coreConfig.checkIsHiddenFile(FORM.fileName)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>

	<cfset result = THIS.currentFolder.checkExtension(FORM.fileName)>
	<cfif not result[1]>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>

	<cfset filePath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), FORM.fileName)>

	<cfif not fileexists(filePath)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND#">
	</cfif>

	<cfif structkeyexists(FORM, "width") and FORM.width gt 0>
		<cfset newWidth = FORM.width>
	</cfif>
	<cfif structkeyexists(FORM, "height") and FORM.height gt 0>
		<cfset newHeight = FORM.height>
	</cfif>
	<cfif newWidth gt 0 and newHeight gt 0>
		<cfset resizeOriginal = true>
	</cfif>
	<cfif resizeOriginal>
		<cfif not REFind('^[0-9]+$', newWidth)>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
		</cfif>
		<cfif not REFind('^[0-9]+$', newHeight)>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
		</cfif>
		<cfif not structkeyexists(FORM, "newFileName") or Len(FORM.newFileName) eq 0>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME#" type="ckfinder">
		</cfif>
		<cfset newFileName = FORM.newFileName>
		<cfset result = THIS.currentFolder.checkExtension(newFileName)>
		<cfif not result[1]>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
		</cfif>
		<cfif not fileSystem.checkFileName(newFileName) or coreConfig.checkIsHiddenFile(newFileName)>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME#" type="ckfinder">
		</cfif>
		<cfif REQUEST.config.images.maxWidth gt 0 and newWidth gt REQUEST.config.images.maxWidth>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
		</cfif>
		<cfif REQUEST.config.images.maxHeight gt 0 and newHeight gt REQUEST.config.images.maxHeight>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
		</cfif>
		<cfset newFilePath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), newFileName)>
		<cfif FORM.overwrite neq "1" and fileexists(newFilePath)>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST#" type="ckfinder">
		</cfif>
		<cfset APPLICATION.CreateCFC("Utils.Thumbnail").createThumbnail("#filePath#", "#newFilePath#", newWidth, newHeight, quality)>
	</cfif>

	<cfif not structkeyexists(REQUEST.config, "Plugin_ImageResize")>
		<cfreturn true>
	</cfif>

	<cfset nameWithoutExt = reReplace(fileSystem.getFileNameWithoutExtension(fileName), "^(.+)\_\d+x\d+$", "$1", "all")>
	<cfset extension = fileSystem.getFileExtension(fileName)>
	<cfloop list="small,medium,large" index = "ListElement">
		<cfif structkeyexists(FORM, #ListElement#) and FORM[ListElement] eq "1">
			<cfset thumbName = nameWithoutExt & "_" & ListElement & extension>
			<cfset newFilePath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), thumbName)>
			<cfif structkeyexists(REQUEST.config.Plugin_ImageResize, ListElement & "Thumb")>
				<cfset size = REQUEST.config.Plugin_ImageResize[ListElement & "Thumb"]>
				<cfif Len(size) gt 0 and size neq false and size neq "false">
					<cfset sizeMatch = REFind("^(\d+)x(\d+)$", REQUEST.config.Plugin_ImageResize[ListElement & "Thumb"], 1, true) />
					<cfif sizeMatch.pos[1] neq 0>
						<cfset newWidth = Mid(size, sizeMatch.pos[2], sizeMatch.len[2])>
						<cfset newHeight = Mid(size, sizeMatch.pos[3], sizeMatch.len[3])>
						<cfset APPLICATION.CreateCFC("Utils.Thumbnail").createThumbnail("#filePath#", "#newFilePath#", newWidth, newHeight, quality)>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<cfreturn true>
</cffunction>

</cfcomponent>
