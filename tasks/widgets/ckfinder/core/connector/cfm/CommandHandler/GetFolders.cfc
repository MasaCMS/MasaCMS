<cfcomponent output="true" extends="XmlCommandHandlerBase">
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

<cfset THIS.command = "GetFolders" >

<cffunction access="public" name="buildXml" hint="send XML response" returntype="boolean" description="send response" output="true">

	<cfset var i =1 />
	<cfset var aclMask = 0 />
	<cfset var nodeFolders = XMLElemNew(THIS.xmlObject, "Folders") />
	<cfset var nodeFolder = "" />
	<cfset var clientPath = "" />
	<cfset var folderPath = THIS.currentFolder.getServerPath() />
	<cfset var acl = APPLICATION.CreateCFC("Core.AccessControlConfig") />
	<cfset var utils = APPLICATION.CreateCFC("Utils.Misc") />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />
	<cfset var coreConfig = APPLICATION.CreateCFC("Core.Config") />

	<cfif not THIS.currentFolder.checkAcl(REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_VIEW) >
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_UNAUTHORIZED#" type="ckfinder" />
	</cfif>

	<cfif not directoryexists(folderPath)>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND#" type="ckfinder">
	</cfif>

	<cftry>
		<cfdirectory action="list" directory="#folderPath#" name="qDir" sort="type,name">
	<cfcatch>
		<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_ACCESS_DENIED#" type="ckfinder">
	</cfcatch>
	</cftry>

	<cfscript>
		while( i lte qDir.recordCount ) {
			if (compareNoCase( qDir.type[i], "FILE" ) and not listFind(".,..", qDir.name[i])) {

				clientPath = THIS.currentFolder.clientPath & qDir.name[i] & "/";
				aclMask = acl.getComputedMask(THIS.currentFolder.resourceTypeName, clientPath);
				if (bitAnd(aclMask, REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_VIEW) neq REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_VIEW) {
					i=i+1;
					continue;
				}
				if (coreConfig.checkIsHiddenFolder(qDir.name[i])) {
					i = i+1;
					continue;
				}

				nodeFolder = XMLElemNew(THIS.xmlObject, "Folder");
				nodeFolder.xmlAttributes["name"] = qDir.name[i];
				nodeFolder.xmlAttributes["acl"] = aclMask;
				nodeFolder.xmlAttributes["hasChildren"] = fileSystem.hasChildren(coreConfig, clientPath, folderPath & qDir.name[i] & "/", THIS.currentFolder.resourceTypeName);
				ArrayAppend(nodeFolders.xmlChildren, nodeFolder);
			}
			i=i+1;
		}
		ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeFolders);
	</cfscript>
	<cfreturn true>
</cffunction>

</cfcomponent>
