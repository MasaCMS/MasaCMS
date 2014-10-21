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
 *
 * CKFinder extension: adds watermark to uploaded images.
--->
<cffunction name="CKFinderPluginWatermark" returntype="Boolean" output="true">
	<cfargument name="currentFolder" required="true" type="any">
	<cfargument name="filePath" required="true" type="String">

	<cftry>
		<cfset imageCFC = APPLICATION.CreateCFC("ImageCFC.image")>
		<cfset imageInfo = imageCFC.getImageInfo("", ARGUMENTS.filePath)>
		<cfcatch type="any">
			<cfreturn false>
		</cfcatch>
	</cftry>

	<cfif imageInfo.height lte 0 or imageInfo.width lte 0>
		<cfreturn false>
	</cfif>

	<cfset alpha = REQUEST.config.Plugin_Watermark.transparency / 100>
	<cfset placeAtX = imageInfo.width - REQUEST.config.Plugin_Watermark.marginLeft>
	<cfset placeAtY = imageInfo.height - REQUEST.config.Plugin_Watermark.marginBottom>
	<cfif placeAtX lt 0>
		<cfset placeAtX = 0>
	</cfif>
	<cfif placeAtY lt 0>
		<cfset placeAtY = 0>
	</cfif>
	<cfset watermarkSource = REQUEST.config.Plugin_Watermark.source />
	<cfif not fileexists(watermarkSource)>
		<cfreturn false>
	</cfif>
	<cfset imageCFC.watermark("", "",
			filePath,
			watermarkSource,
			alpha,
			placeAtX,
			placeAtY,
			filePath,
			REQUEST.config.images.quality
			)>

	<cfreturn false>
</cffunction>

<cfset REQUEST.CKFinderPluginWatermark = CKFinderPluginWatermark>

<cfset hook = arrayNew(1)>
<cfif not structkeyexists(config, "hooks")>
	<cfset config.hooks = arrayNew(1)>
</cfif>
<cfset hook[1] = "AfterFileUpload">
<cfset hook[2] = "CKFinderPluginWatermark">
<cfset ArrayAppend(config.hooks, hook)>

<cfset config.Plugin_Watermark = structNew()>
<cfset config.Plugin_Watermark.source = GetDirectoryFromPath( GetCurrentTemplatePath()) & "logo.gif">
<cfset config.Plugin_Watermark.marginLeft = "162">
<cfset config.Plugin_Watermark.marginBottom = "64">
<cfset config.Plugin_Watermark.transparency = "80">
