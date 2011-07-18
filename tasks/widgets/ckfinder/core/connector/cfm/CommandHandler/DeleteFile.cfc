<cfcomponent output="false" extends="XmlCommandHandlerBase">
<!---
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2011, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfset THIS.command = "DeleteFile" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">

	<cfset var filePath = "" />
	<cfset var thumbFilePath = "" />
	<cfset var nodeDeletedFile = XMLElemNew(THIS.xmlObject, "DeletedFile") />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_DELETE) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfif not fileSystem.checkFileName(URL.FileName) or coreConfig.checkIsHiddenFile(URL.FileName)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>

	<cfset result = THIS.currentFolder.checkExtension(URL.FileName)>
	<cfif not result[1]>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>

	<cfset filePath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), URL.FileName)>
	<cfset thumbFilePath = fileSystem.CombinePaths(THIS.currentFolder.getThumbsServerPath(), filesystem.getThumbFileName(URL.FileName))>

	<cfif not fileexists(filePath)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND#">
	</cfif>

	<cftry>
		<cffile action="delete" file="#filePath#">
		<cfcatch type="any">
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder">
		</cfcatch>
	</cftry>

	<!--- remove file with thumbnail if exists --->
	<cfif fileexists(thumbFilePath)>
		<cftry>
			<cffile action="delete" file="#thumbFilePath#">
			<!--- just handle silently this exception when deleting thumbnail fails --->
			<cfcatch>
			</cfcatch>
		</cftry>
	</cfif>

	<cfscript>
		nodeDeletedFile.xmlAttributes["name"] = URL.FileName;
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeDeletedFile);
	</cfscript>

	<cfreturn true>
</cffunction>

</cfcomponent>
