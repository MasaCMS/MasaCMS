<cfcomponent output="false" extends="XmlCommandHandlerBase">
<!---
 * CKFinder
 * ========
 * http://cksource.com/ckfinder
 * Copyright (C) 2007-2014, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, THIS file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute THIS file or part of its contents. The contents of
 * THIS file is part of the Source Code of CKFinder.
--->

<cfset THIS.command = "CopyFiles" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="true">

	<cfset var i = 0 />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var copied = 0 />
	<cfset var copiedAll = 0 />
	<cfset var checkedPaths = structNew() />
	<cfset var copyFilesNode = XMLElemNew(THIS.xmlObject, "CopyFiles") />
	<cfset var errorsNode = XMLElemNew(THIS.xmlObject, "Errors") />
	<cfset var errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_NONE />
	<cfset var maxSize = 0 />
	<cfset var options = "" />
	<cfset var name = "" />
	<cfset var type = "" />
	<cfset var path = "" />
	<cfset var result = "" />
	<cfset var currentFolder = "" />
	<cfset var resourceTypeConfig = "" />

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<cfif not THIS.currentFolder.checkAcl(bitor(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_RENAME, bitor(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_UPLOAD, REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_DELETE))) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfif structkeyexists(FORM, "copied") and FORM.copied>
		<cfset copiedAll = FORM.copied>
	</cfif>
	<cfif structkeyexists(THIS.currentFolder.resourceTypeConfig, "maxSize")>
		<cfset maxSize = APPLICATION.CreateCFC("Utils.Misc").returnBytes(THIS.currentFolder.resourceTypeConfig.maxSize) />
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
			<cfif structkeyexists(FORM, "FILES[" & iFileNum & "][OPTIONS]")>
				<cfset options = FORM["FILES[" & iFileNum & "][OPTIONS]"]>
			</cfif>
			<cfset iFileNum = iFileNum +1>
			<cfset resourceTypeConfig = structNew() >
			<cfset destinationFilePath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), name)>
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
			<!--- check #3 (extension) --->
			<cfset result = THIS.currentFolder.checkExtension(name) >
			<cfif not result[1]>
				<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION>
				<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
				<cfthrow errorcode="0" type="continue" />
			</cfif>

			<cfset currentFolder = APPLICATION.CreateCFC("Core.FolderHandler").Init(type, path)>

			<!--- check #4 (extension) - when moving to another resource type, double check extension --->
			<cfif  THIS.currentFolder.resourceTypeName neq type>
				<cfset result = currentFolder.checkExtension(name) >
				<cfif not result[1]>
					<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION>
					<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
					<cfthrow errorcode="0" type="continue" />
				</cfif>
			</cfif>
			<!--- check #5 (hidden folders, cache results) --->
			<cfif not structkeyexists(checkedPaths, path)>
				<cfset checkedPaths[path] = true>
				<cfif coreConfig.checkIsHiddenPath(currentFolder.clientPath)>
					<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
				</cfif>
			</cfif>
			<cfset currentFolderServerPath = currentFolder.getServerPath() >
			<cfset sourceFilePath = fileSystem.CombinePaths(currentFolderServerPath, name)>
			<!--- check #6 (hidden file name) --->
			<cfif coreConfig.checkIsHiddenFile(name)>
				<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
			</cfif>
			<!--- check #7 (Access Control, need file view permission to source files) --->
			<cfif not currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW) >
				<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
			</cfif>
			<!--- check #8 (invalid file name) --->
			<cfif not fileexists(sourceFilePath) or directoryexists(sourceFilePath)>
				<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND>
				<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
				<cfthrow errorcode="0" type="continue" />
			</cfif>
			<!--- check #9 (max size) --->
			<cfif  THIS.currentFolder.resourceTypeName neq type and maxSize gt 0>
				<cfdirectory name = "myDir" action="list" directory="#currentFolderServerPath#" filter="#name#">
				<cfif maxSize lt myDir.Size>
					<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UPLOADED_TOO_BIG>
					<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
					<cfthrow errorcode="0" type="continue" />
				</cfif>
			</cfif>
			<!--- protection against copying files to itself --->
			<cfif sourceFilePath eq destinationFilePath>
					<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_SOURCE_AND_TARGET_PATH_EQUAL>
					<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
					<cfthrow errorcode="0" type="continue" />
			</cfif>
			<cfif fileexists(destinationFilePath) and Find("overwrite", options) eq 0>
				<cfif Find("autorename", options) neq 0>
					<cfscript>
					fileName = name;
					fileNameWithoutExtension = fileSystem.getFileNameWithoutExtension(name);
					fileExtension = fileSystem.getFileExtension(name);

					i = 0;
					while (true)
					{
						destinationFilePath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), fileName);

						if (fileexists(destinationFilePath)) {
							i = i+1;
							fileName = fileNameWithoutExtension & "(" & i & ")" & fileExtension;
						}
						else {
							break;
						}
					}
					</cfscript>
					<cftry>
					<cffile action="copy" source="#sourceFilePath#" destination="#destinationFilePath#">
					<cfset copied = copied +1>
					<cfcatch type="any">
						<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED>
						<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
						<cfthrow errorcode="0" type="continue" />
					</cfcatch>
					</cftry>
				<cfelse>
					<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST>
					<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
					<cfthrow errorcode="0" type="continue" />
				</cfif>
			<cfelse>
				<cftry>
				<cffile action="copy" source="#sourceFilePath#" destination="#destinationFilePath#">
				<cfset copied = copied +1>
				<cfcatch type="any">
					<cfset errorCode = REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED>
					<cfset THIS.appendErrorNode(errorsNode, errorCode, name, type, path)>
					<cfthrow errorcode="0" type="continue" />
				</cfcatch>
				</cftry>
			</cfif>
		<cfcatch type="continue">
		<!--- simulate continue; --->
		</cfcatch>
		</cftry>
	</cfloop>

	<cfscript>
	copyFilesNode.xmlAttributes["copied"] = copied;
	copyFilesNode.xmlAttributes["copiedTotal"] = copied + copiedAll;
	ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, copyFilesNode);
	</cfscript>
	<cfif errorCode neq REQUEST.constants.CKFINDER_CONNECTOR_ERROR_NONE>
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, errorsNode) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_COPY_FAILED#" type="ckfinder" />
	</cfif>
	<cfreturn true>
</cffunction>

</cfcomponent>
