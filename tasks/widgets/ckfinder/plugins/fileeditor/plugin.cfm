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
<cffunction name="CKFinderPluginSaveFile" returntype="Boolean" output="true">
	<cfargument name="command" required="true" type="String">
	<cfif command neq "SaveFile">
		<cfreturn true>
	</cfif>

	<cftry>
		<cfset oObject = CreateObject("component", "SaveFile")>
		<cfset oObject.sendResponse()>
		<cfcatch type="ckfinder">
			<cfscript>
				oCommandHandler_XmlCommandHandler = APPLICATION.CreateCFC("CKFinder_Connector.CommandHandler.XmlCommandHandlerBase").Init();
				oCommandHandler_XmlCommandHandler.sendError(#CFCATCH.ErrorCode#);
			</cfscript>
		</cfcatch>
	</cftry>

	<cfreturn false>
</cffunction>

<cfset REQUEST.CKFinderPluginSaveFile = CKFinderPluginSaveFile>

<cfset hook = arrayNew(1)>
<cfif not structkeyexists(config, "plugins")>
	<cfset config.plugins = arrayNew(1)>
</cfif>
<cfif not structkeyexists(config, "hooks")>
	<cfset config.hooks = arrayNew(1)>
</cfif>
<cfset ArrayAppend(config.plugins, 'fileeditor')>
<cfset hook[1] = "BeforeExecuteCommand">
<cfset hook[2] = "CKFinderPluginSaveFile">
<cfset ArrayAppend(config.hooks, hook)>
