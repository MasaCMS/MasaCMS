<cfcomponent output="false">
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

<cffunction name="createThumbnail" access="public" returntype="boolean" output="false" hint="creates thumnbail">
	<cfargument name="filePath" required="true" type="String">
	<cfargument name="thumbPath" required="true" type="String">
	<cfargument name="maxWidth" required="true" type="String">
	<cfargument name="maxHeight" required="true" type="String">
	<cfargument name="quality" required="true" type="String">
	<cfargument name="preserverAspectRatio" required="false" type="Boolean" default="true">

	<cfset var iFinalWidth = ARGUMENTS.maxWidth>
	<cfset var iFinalHeight = ARGUMENTS.maxHeight>
	<cfset var oSize = structNew()>
	<cfset var destination="">
	<cfimage action="info" source="#ARGUMENTS.filePath#" structname="objImageInfo">

	<cfscript>
		if (objImageInfo.height lte 0 or objImageInfo.width lte 0) {
			return false;
		}

		if (ARGUMENTS.maxHeight eq 0) {
			iFinalHeight = objImageInfo.height;
		}
		if (ARGUMENTS.maxWidth eq 0) {
			iFinalWidth = objImageInfo.width;
		}
	</cfscript>

	<cfif objImageInfo.width lte iFinalWidth and objImageInfo.height lte iFinalHeight>
		<cffile action="copy" source="#ARGUMENTS.filePath#" destination="#ARGUMENTS.thumbPath#">
		<cfreturn true>
	</cfif>

	<cfif ARGUMENTS.preserverAspectRatio>
		<cfset oSize = THIS.GetAspectRatioSize(iFinalWidth, iFinalHeight, objImageInfo.width, objImageInfo.height )>
		<cfelse>
		<cfset oSize.Width = iFinalWidth>
		<cfset oSize.Height = iFinalHeight>
	</cfif>

	<!--- ColdFusion 9,0,0 has a bug, it cannot create a thumbnail from file with .Png extension... unless we change the name of a thumbnail to .png --->
	<cfif isDefined("server.OS.Name") and FindNoCase("windows", server.OS.Name)>
		<cfset destination="#Lcase(ARGUMENTS.thumbPath)#">
	<cfelse>
		<cfset destination="#ARGUMENTS.thumbPath#">
	</cfif>
	<cfimage action="read" source="#ARGUMENTS.filePath#" name="oImage" />
	<cfset ImageResize(oImage, oSize.Width, oSize.Height, application.configBean.getImageInterpolation())>
	<cfset quality = (quality/100)>
	<cfimage action="write" source="#oImage#" destination="#destination#" quality="#quality#" overwrite="yes">

	<cfreturn true>
</cffunction>

<cffunction name="getAspectRatioSize" access="public" returntype="Struct">
	<cfargument name="maxWidth" required="true" type="Numeric">
	<cfargument name="maxHeight" required="true" type="Numeric">
	<cfargument name="actualWidth" required="true" type="Numeric">
	<cfargument name="actualHeight" required="true" type="Numeric">

	<cfscript>
		var iFactorX = 0;
		var iFactorY = 0;
		var oSize = structNew();
		oSize.Width = ARGUMENTS.maxWidth;
		oSize.Height = ARGUMENTS.maxHeight;

		// Calculates the X and Y resize factors
		iFactorX = ARGUMENTS.maxWidth / ARGUMENTS.actualWidth;
		iFactorY = ARGUMENTS.maxHeight / ARGUMENTS.actualHeight;

		// If some dimension have to be scaled
		if (iFactorX neq 1 or iFactorY neq 1)
		{
			// Uses the lower Factor to scale the oposite size
			if (iFactorX lt iFactorY) {
				oSize.Height = round(ARGUMENTS.actualHeight * iFactorX);
			}
			else if (iFactorX gt iFactorY) {
				oSize.Width = round(ARGUMENTS.actualWidth * iFactorY);
			}
		}

		if (oSize.Height lte 0) {
			oSize.Height = 1;
		}
		if (oSize.Width lte 0) {
			oSize.Width = 1;
		}

		// Returns the Size
		return oSize;
	</cfscript>
</cffunction>

</cfcomponent>
