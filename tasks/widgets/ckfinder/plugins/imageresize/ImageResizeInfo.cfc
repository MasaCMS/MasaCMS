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

<cfset THIS.command = "ImageResizeInfo" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="false">
	<cfset var filePath = "" />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config")>
	<cfset var nodeImageInfo = XMLElemNew(THIS.xmlObject, "ImageInfo") />

	<cfif not REQUEST.CheckAuthentication()>
		<cfthrow errorCode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_CONNECTOR_DISABLED#" type="ckfinder" />
	</cfif>

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW) >
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

	<cfif not fileexists(filePath)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FILE_NOT_FOUND#">
	</cfif>

	<cftry>
		<cfset imageCFC = APPLICATION.CreateCFC("ImageCFC.image")>
		<cfset imageInfo = imageCFC.getImageInfo("", filePath)>
		<cfcatch type="any">
			<cfreturn false>
		</cfcatch>
	</cftry>

	<cfif imageInfo.height lte 0 or imageInfo.width lte 0>
		<cfreturn false>
	</cfif>

	<cfscript>
		nodeImageInfo.xmlAttributes["width"] = imageInfo.width;
		nodeImageInfo.xmlAttributes["height"] = imageInfo.height;
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeImageInfo);
	</cfscript>

	<cfreturn true>
</cffunction>

</cfcomponent>
