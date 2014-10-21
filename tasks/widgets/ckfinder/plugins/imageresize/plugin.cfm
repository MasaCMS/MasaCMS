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
<cffunction name="CKFinderPluginImageResizeInit" returntype="Boolean" output="true">
	<cfargument name="xmlObject" required="true" type="any">

	<cfset var nodeImageResize = XMLElemNew(xmlObject, "imageresize") >
	<cfset nodeImageResize.xmlAttributes["smallThumb"] = REQUEST.config.Plugin_ImageResize.smallThumb >
	<cfset nodeImageResize.xmlAttributes["mediumThumb"] = REQUEST.config.Plugin_ImageResize.mediumThumb >
	<cfset nodeImageResize.xmlAttributes["largeThumb"] = REQUEST.config.Plugin_ImageResize.largeThumb >

	<cfset len = arrayLen(xmlObject["Connector"].xmlChildren)>
	<cfloop from="1" to="#len#" step="1" index="i">
		<cfif xmlObject["Connector"].xmlChildren[i].XmlName eq "PluginsInfo">
			<cfset ArrayAppend(xmlObject["Connector"].xmlChildren[i].xmlChildren, nodeImageResize) >
		</cfif>
	</cfloop>

	<cfreturn false>
</cffunction>

<cffunction name="CKFinderPluginImageResizeInfo" returntype="Boolean" output="true">
	<cfargument name="command" required="true" type="String">
	<cfif command neq "ImageResizeInfo">
		<cfreturn true>
	</cfif>

	<cftry>
		<cfset oObject = CreateObject("component", "ImageResizeInfo")>
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

<cffunction name="CKFinderPluginImageResize" returntype="Boolean" output="true">
	<cfargument name="command" required="true" type="String">
	<cfif command neq "ImageResize">
		<cfreturn true>
	</cfif>

	<cftry>
		<cfset oObject = CreateObject("component", "ImageResize")>
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

<cfset REQUEST.CKFinderPluginImageResize = CKFinderPluginImageResize>
<cfset REQUEST.CKFinderPluginImageResizeInit = CKFinderPluginImageResizeInit>
<cfset REQUEST.CKFinderPluginImageResizeInfo = CKFinderPluginImageResizeInfo>

<cfset hook = arrayNew(1)>
<cfif not structkeyexists(config, "plugins")>
	<cfset config.plugins = arrayNew(1)>
</cfif>
<cfif not structkeyexists(config, "hooks")>
	<cfset config.hooks = arrayNew(1)>
</cfif>
<cfset hook[1] = "InitCommand">
<cfset hook[2] = "CKFinderPluginImageResizeInit">
<cfset ArrayAppend(config.hooks, hook)>
<cfset hook[1] = "BeforeExecuteCommand">
<cfset hook[2] = "CKFinderPluginImageResizeInfo">
<cfset ArrayAppend(config.hooks, hook)>
<cfset hook[1] = "BeforeExecuteCommand">
<cfset hook[2] = "CKFinderPluginImageResize">
<cfset ArrayAppend(config.hooks, hook)>
<cfset ArrayAppend(config.plugins, 'imageresize')>

<cfset config.Plugin_ImageResize = structNew()>
<cfset config.Plugin_ImageResize.smallThumb = "90x90">
<cfset config.Plugin_ImageResize.mediumThumb = "120x120">
<cfset config.Plugin_ImageResize.largeThumb = "180x180">
