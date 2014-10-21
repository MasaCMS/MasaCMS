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

<cfset THIS.command = "CreateFolder" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="true">

	<cfset var i =1 />
	<cfset var nodeNewFolder = XMLElemNew(THIS.xmlObject, "NewFolder") />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var newFolderPath = "" />

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_CREATE) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfif not fileSystem.checkFolderName(URL.NewFolderName) or coreConfig.checkIsHiddenFolder(URL.NewFolderName)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME#" type="ckfinder">
	</cfif>
	<cfset newFolderPath = fileSystem.CombinePaths(THIS.currentFolder.getServerPath(), URL.NewFolderName) />

	<cfif fileexists(newFolderPath) or directoryexists(newFolderPath)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST#" type="ckfinder">
	</cfif>

	<cfscript>
		nodeNewFolder.xmlAttributes["name"] = URL.newFolderName;
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeNewFolder);
	</cfscript>

	<cftry>
		<cfif isDefined( "REQUEST.Config.chmodFolders" ) and REQUEST.Config.chmodFolders>
			<cfdirectory action="create" directory="#newFolderPath#" mode="#REQUEST.Config.chmodFolders#" />
		<cfelse>
			<cfdirectory action="create" directory="#newFolderPath#" />
		</cfif>
		<cfcatch type="any">
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder">
		</cfcatch>
	</cftry>

	<cfreturn true>
</cffunction>

</cfcomponent>
