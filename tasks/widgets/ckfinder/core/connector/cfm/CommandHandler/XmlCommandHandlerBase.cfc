<cfcomponent output="false" extends="CommandHandlerBase">
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

<cfset Init()>

<cffunction name="Init" access="public" returntype="any" output="true" hint="Returns an initialized instance.">
	<cfset THIS.config = REQUEST.config />
	<cfxml variable="xmlObject" casesensitive="yes">
	<cfoutput><?xml version="1.0" encoding="utf-8"?><Connector><Error number="0" /></Connector></cfoutput>
	</cfxml>
	<cfset THIS.xmlObject = xmlObject>
	<cfset THIS.sendHeaders = true>
	<cfreturn THIS>
</cffunction>

<cffunction name="sendResponse" access="public" returntype="boolean" hint="send XML response" output="true">

	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />

	<cftry>
		<cfscript>
		if (THIS.mustCheckRequest) {
			THIS.checkRequest();
		}

		if (Len(THIS.currentFolder.resourceTypeName)) {
			THIS.xmlObject["Connector"].xmlAttributes["resourceType"] = THIS.currentFolder.resourceTypeName;
		}

		if (THIS.mustAddCurrentFolderNode) {
			nodeCurrentFolder = XMLElemNew(THIS.xmlObject, "CurrentFolder");
			nodeCurrentFolder.xmlAttributes["path"] = fileSystem.FixPath(THIS.currentFolder.clientPath);
			nodeCurrentFolder.xmlAttributes["url"] = fileSystem.FixUrl(THIS.currentFolder.getUrl());
			nodeCurrentFolder.xmlAttributes["acl"] = THIS.currentFolder.getAclMask();
			ArrayAppend(THIS.xmlObject["Connector"].xmlChildren, nodeCurrentFolder);
		}

		THIS.buildXml();
		</cfscript>
		<cfcatch type="ckfinder">
			<cfset THIS.sendError(CFCATCH.ErrorCode)>
			<cfreturn false>
		</cfcatch>
		<cfcatch type="any">
			<cfset THIS.sendError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR, CFCATCH.Message)>
			<cfreturn false>
		</cfcatch>
	</cftry>

	<cfif THIS.sendHeaders>
		<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
		<cfheader name="Pragma" value="no-cache">
		<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
		<cfcontent reset="true" type="text/xml; charset=UTF-8">
	</cfif>

	<cfoutput>#toString(THIS.xmlObject)#</cfoutput>
	<cfreturn true>
</cffunction>

<cffunction name="sendError" access="public" returntype="boolean" hint="send XML error response" output="true">
	<cfargument name="errorCode" type="Numeric" required="true" />
	<cfargument name="errorMsg" type="String" required="false" />
	<cfset THIS.xmlObject["Connector"]["Error"].xmlAttributes["number"] = ToString(ARGUMENTS.errorCode) />
	<cfif structkeyexists(ARGUMENTS, "errorMsg")>
		<cfset THIS.xmlObject["Connector"]["Error"].xmlAttributes["text"] = ARGUMENTS.errorMsg />
	</cfif>
	<cfif THIS.sendHeaders>
		<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
		<cfheader name="Pragma" value="no-cache">
		<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">
		<!--- No additional space after sending cfcontent due to issues with BlueDragon --->
		<cfcontent reset="true" type="text/xml; charset=UTF-8"></cfif><cfoutput>#toString(THIS.xmlObject)#</cfoutput>
	<cfreturn true>
</cffunction>

<cffunction name="appendErrorNode" access="public" returntype="boolean">
	<cfargument name="errorsNode" type="Any" required="yes">
	<cfargument name="errorCode" type="Numeric" required="yes">
	<cfargument name="name" type="String" required="yes">
	<cfargument name="type" type="String" required="yes">
	<cfargument name="path" type="String" required="yes">
	<cfset var errorNode = XMLElemNew(THIS.xmlObject, "Error") />
	<cfset errorNode.xmlAttributes["code"] = errorCode >
	<cfset errorNode.xmlAttributes["name"] = name >
	<cfset errorNode.xmlAttributes["type"] = type >
	<cfset errorNode.xmlAttributes["folder"] = path >
	<cfset ArrayAppend(errorsNode.xmlChildren, errorNode) >
	<cfreturn true>
</cffunction>

<cffunction name="buildXml" access="public" returntype="boolean" hint="build complex XML response" output="true">
	<cfreturn true>
</cffunction>

</cfcomponent>
