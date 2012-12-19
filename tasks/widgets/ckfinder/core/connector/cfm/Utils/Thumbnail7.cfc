<cfcomponent>
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

<cffunction name="createThumbnail" access="public" returntype="boolean" output="true" hint="creates thumnbail">
	<cfargument name="filePath" required="true" type="String">
	<cfargument name="thumbPath" required="true" type="String">
	<cfargument name="maxWidth" required="true" type="String">
	<cfargument name="maxHeight" required="true" type="String">
	<cfargument name="quality" required="true" type="String">


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
	<cfif imageInfo.height lte ARGUMENTS.maxHeight and imageInfo.width lte ARGUMENTS.maxWidth>
		<cffile action="copy" source="#ARGUMENTS.filePath#" destination="#ARGUMENTS.thumbPath#">
		<cfreturn true>
	</cfif>

	<cfset imageCFC.resize("", ARGUMENTS.filePath, ARGUMENTS.thumbPath, ARGUMENTS.maxWidth, ARGUMENTS.maxHeight, "true", "false", ARGUMENTS.quality)>

	<cfreturn true>
</cffunction>

</cfcomponent>
