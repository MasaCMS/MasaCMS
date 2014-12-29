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

<cfset THIS.command = "SaveFile" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">

	<cfset var filePath = "" />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>

	<cfif not REQUEST.CheckAuthentication()>
		<cfthrow errorCode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_CONNECTOR_DISABLED#" type="ckfinder" />
	</cfif>

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<!--- Saving empty file is equal to deleting a file, that's why FILE_DELETE permissions are required --->
	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_DELETE) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfif not fileSystem.checkFileName(FORM.FileName) or coreConfig.checkIsHiddenFile(FORM.FileName)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>

	<cfset result = THIS.currentFolder.checkExtension(FORM.FileName)>
	<cfif not result[1]>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>

	<cfset filePath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), FORM.FileName)>

	<cfif not fileexists(filePath)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND#">
	</cfif>

	<cffile action="Write" file="#filePath#" output="#FORM.content#" fixnewline="true" addNewLine="false">

	<cfreturn true>
</cffunction>

</cfcomponent>
