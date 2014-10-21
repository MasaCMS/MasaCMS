<cfcomponent output="false" extends="XmlCommandHandlerBase">
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

<cfset THIS.command = "DeleteFiles" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">

	<cfset var filePath = "" />
	<cfset var thumbFilePath = "" />
	<cfset var deleted = 0 />
	<cfset var deletedAll = 0 />
	<cfset var checkedPaths = structNew() />
	<cfset var deleteFilesNode = XMLElemNew(THIS.xmlObject, "DeleteFiles") />
	<cfset var errorsNode = XMLElemNew(THIS.xmlObject, "Errors") />
	<cfset var errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_NONE />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var name = "" />
	<cfset var type = "" />
	<cfset var path = "" />
	<cfset var result = "" />
	<cfset var currentFolder = "" />
	<cfset var resourceTypeConfig = "" />

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<cfset iFileNum = 0>
	<cfloop condition='structkeyexists(FORM, "FILES[" & iFileNum & "][TYPE]")'>
		<cftry>
			<cfset options = "" >
			<cftry>
				<cfset keyname = "FILES[" & iFileNum & "][NAME]">
				<cfset name = FORM[keyname] >
				<cfset keyname = "FILES[" & iFileNum & "][TYPE]">
				<cfset type = FORM[keyname] >
				<cfset keyname = "FILES[" & iFileNum & "][FOLDER]">
				<cfset path = FORM[keyname] >
				<cfif Len(type) eq 0>
					<cfscript>break;</cfscript>
				</cfif>
				<cfif Len(name) eq 0 or Len(path) eq 0>
					<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
				</cfif>
				<cfcatch type="any">
					<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
				</cfcatch>
			</cftry>

			<cfset iFileNum = iFileNum +1>
			<cfset resourceTypeConfig = structNew() >

			<!--- check #1 (path) --->
			<cfif not fileSystem.checkFileName(name) or REFind('(/\.)|(//)|[[:cntrl:]]|([\\:\*\?\"<>])', path)>
				<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
			</cfif>
			<!--- get resource type config for current file --->
			<cfif not structkeyexists(resourceTypeConfig, type)>
				<cfset resourceTypeConfig[type] = APPLICATION.CreateCFC("Core.Config").getResourceTypeConfig(type)>
			</cfif>
			<!--- check #2 (resource type) --->
			<cfif StructIsEmpty(resourceTypeConfig[type])>
				<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
			</cfif>

			<cfset currentFolder = APPLICATION.CreateCFC("Core.FolderHandler").Init(type, path)>

			<!--- check #3 (extension) --->
			<cfset result = currentFolder.checkExtension(name) >
			<cfif not result[1]>
				<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
			</cfif>

			<!--- check #5 (hidden folders, cache results) --->
			<cfif not structkeyexists(checkedPaths, path)>
				<cfset checkedPaths[path] = true>
				<cfif coreConfig.checkIsHiddenPath(currentFolder.clientPath)>
					<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
				</cfif>
			</cfif>

			<cfset currentFolderServerPath = currentFolder.getServerPath() >
			<cfset filePath = fileSystem.CombinePaths(currentFolderServerPath, name)>

			<!--- check #6 (hidden file name) --->
			<cfif coreConfig.checkIsHiddenFile(name)>
				<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
			</cfif>

			<!--- check #7 (Access Control, need file delete permission to source files) --->
			<cfif not currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_DELETE) >
				<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
			</cfif>

			<!--- check #8 (invalid file name) --->
			<cfif not fileexists(filePath) or directoryexists(filePath)>
				<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND>
				<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
				<cfthrow errorcode="0" type="continue" />
			</cfif>

			<cfset thumbFilePath = fileSystem.CombinePaths(currentFolder.getThumbsServerPath(), filesystem.getThumbFileName(name))>

			<cftry>
				<cffile action="delete" file="#filePath#">
				<cfset deleted = deleted +1>
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

		<cfcatch type="continue">
		<!--- simulate continue; --->
		</cfcatch>
		</cftry>
	</cfloop>

	<cfscript>
	deleteFilesNode.xmlAttributes["deleted"] = deleted;
	ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, deleteFilesNode);
	</cfscript>
	<cfif errorCode neq REQUEST.constants.CKFINDER_CONNECTOR_ERROR_NONE>
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, errorsNode) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_DELETE_FAILED#" type="ckfinder" />
	</cfif>

	<cfreturn true>
</cffunction>

</cfcomponent>
