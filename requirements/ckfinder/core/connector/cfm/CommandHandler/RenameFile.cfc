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

<cfset THIS.command = "RenameFile" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">

	<cfset var nodeRenamedFile = XMLElemNew(THIS.xmlObject, "RenamedFile") />
	<cfset var source = THIS.currentFolder.getServerPath() & URL.fileName />
	<cfset var destination = THIS.currentFolder.getServerPath() & URL.newFileName />
	<cfset var result = arrayNew(1) />
	<cfset var thumbFile = "" />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config") />

	<cfif not structkeyexists(FORM, "CKFinderCommand") or FORM.CKFinderCommand neq "true">
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder" />
	</cfif>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_RENAME) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfscript>
		nodeRenamedFile.xmlAttributes["name"] = URL.fileName;
		result = THIS.currentFolder.checkExtension(URL.newFileName);
	</cfscript>
	<cfif not fileexists("#source#")>
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeRenamedFile)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND#" type="ckfinder">
	</cfif>
	<cfif directoryexists("#destination#") or fileexists("#destination#")>
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeRenamedFile)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ALREADY_EXIST#" type="ckfinder" />
	</cfif>
	<cfif not result[1]>
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeRenamedFile)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_EXTENSION#" type="ckfinder">
	</cfif>
	<cfif not APPLICATION.CreateCFC("Utils.FileSystem").checkFileName(URL.fileName) or coreConfig.checkIsHiddenFile(URL.fileName)>
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeRenamedFile)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>
	<cfif not APPLICATION.CreateCFC("Utils.FileSystem").checkFileName(URL.newFileName) or coreConfig.checkIsHiddenFile(URL.newFileName)>
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeRenamedFile)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME#" type="ckfinder">
	</cfif>
	<cfset result = THIS.currentFolder.checkExtension(URL.fileName)>
	<cfif not result[1]>
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeRenamedFile)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#" type="ckfinder">
	</cfif>

	<cftry>
		<cffile action="rename" source="#source#" destination="#destination#" />
		<cfset nodeRenamedFile.xmlAttributes["newName"] = URL.newFileName >
		<cfset ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeRenamedFile)>
		<cfcatch type="any">
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder">
		</cfcatch>
	</cftry>

	<cfset thumbFile = THIS.currentFolder.getThumbsServerPath() & APPLICATION.CreateCFC("Utils.FileSystem").getThumbFileName(URL.fileName) />
	<cfif fileexists(thumbFile)>
		<cftry>
			<cffile action="delete" file="#thumbFile#">
			<cfcatch type="any">
			</cfcatch>
		</cftry>
	</cfif>

	<cfreturn true>
</cffunction>

</cfcomponent>
