<!---
 * CKFinder
 * ========
 * http://ckfinder.com
 * Copyright (C) 2007-2010, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfcomponent displayname="Application" output="false" hint="Pre-page processing for the application">

	<!---
	Run the pseudo constructor to set up default
	data structures.
	--->
	<cfinclude template="../../../../../../config/applicationSettings.cfm">
	<cfscript>
	THIS.mappings["/CKFinder_Connector"] = mapPrefix & BaseDir & "/tasks/widgets/ckfinder/core/connector/cfm/";
	</cfscript>


	<!--- Include the CFC creation proxy. --->
	<cfinclude template="createcfc.udf.cfm" />


	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false" hint="Pre-page processing for the page request.">
		<!---
		Store the CreateCFC method in the application
		scope.
		--->
		<cfset APPLICATION.CreateCFC = THIS.CreateCFC />
		<cfset APPLICATION.CFVersion = Left(SERVER.COLDFUSION.PRODUCTVERSION,Find(",",SERVER.COLDFUSION.PRODUCTVERSION)-1) />
		<cfinclude template="../../../../../../config/appcfc/onRequestStart_include.cfm">
		<cfinclude template="../../../../../../config/appcfc/scriptProtect_include.cfm">
		<cfreturn true />
	</cffunction>
	
	<cfinclude template="../../../../../../config/appcfc/onApplicationStart_method.cfm">
	<cfinclude template="../../../../../../config/appcfc/onRequestEnd_method.cfm">
	<cfinclude template="../../../../../../config/appcfc/onSessionStart_method.cfm">
	<cfinclude template="../../../../../../config/appcfc/onSessionEnd_method.cfm">
	<cfinclude template="../../../../../../config/appcfc/onError_method.cfm">
	<cfinclude template="../../../../../../config/appcfc/onMissingTemplate_method.cfm">

</cfcomponent>
