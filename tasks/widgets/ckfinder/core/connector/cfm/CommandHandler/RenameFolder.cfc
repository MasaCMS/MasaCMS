<cfcomponent output="false" extends="XmlCommandHandlerBase">
<!---
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2012, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfset THIS.command = "RenameFolder" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="true">
	<cfset var i =1 />
	<cfset var newClientPath="/">
	<cfset var newServerPath="/">
	<cfset var newFolderUrl="">
	<cfset var newDir="">
	<cfset var nodeRenamedFolder = XMLElemNew(THIS.xmlObject, "RenamedFolder") />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var oldClientPath = THIS.currentFolder.clientPath />
	<cfset var oldServerPath = THIS.currentFolder.getServerPath() />
	<cfset var oldThumbnailPath = THIS.currentFolder.getThumbsServerPath() />
	<cfset var oldFolderUrl = THIS.currentFolder.getUrl() />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config") />
	<cfset var utilsFolder = APPLICATION.CreateCFC("Utils.Folder") />

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_RENAME) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfif THIS.currentFolder.clientPath eq "/">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>

	<cfscript>
		newClientPath = fileSystem.CombinePaths(rereplace(oldClientPath, "^(.*/)[^/]+/$", "\1"), URL.newFolderName & "/");
		newServerPath = fileSystem.CombinePaths(rereplace(oldServerPath, "^(.*/)[^/]+/$", "\1"), URL.newFolderName & "/");
		newFolderUrl = fileSystem.CombinePaths(rereplace(oldFolderUrl, "^(.*/)[^/]+/$", "\1"), URL.newFolderName & "/");
	</cfscript>

	<cfif not fileSystem.checkFolderName(URL.newFolderName) or coreConfig.checkIsHiddenFolder(URL.NewFolderName)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME#" type="ckfinder">
	</cfif>

	<cfscript>
		nodeRenamedFolder.xmlAttributes["newName"] = URL.newFolderName;
		nodeRenamedFolder.xmlAttributes["newPath"] = fileSystem.fixPath(newClientPath);
		nodeRenamedFolder.xmlAttributes["newUrl"] = fileSystem.fixUrl(newFolderUrl);
	</cfscript>

	<cfif not directoryexists(oldServerPath)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<cfif directoryexists(newServerPath) or fileexists(mid(newServerPath, 1, Len(newServerPath)-1))>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST#" type="ckfinder" />
	</cfif>
	<cfset newDir = APPLICATION.CreateCFC("Utils.Misc").TrimChar(URL.newFolderName,"/") />

	<cftry>
		<cfdirectory action="rename" directory="#oldServerPath#" newdirectory="#newDir#">
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeRenamedFolder)>
		<cftry>
			<cfdirectory action="rename" directory="#oldThumbnailPath#" newdirectory="#newDir#">
			<cfcatch type="any">
				<cfset utilsFolder.deleteDirectory(oldThumbnailPath, true)>
			</cfcatch>
		</cftry>
		<cfcatch type="any">
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder" />
		</cfcatch>
	</cftry>

	<cfreturn true>
</cffunction>

</cfcomponent>
