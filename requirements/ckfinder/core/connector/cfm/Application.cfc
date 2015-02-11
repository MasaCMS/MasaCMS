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

<cfcomponent displayname="Application" output="false" hint="Pre-page processing for the application">

	<!---
	Run the pseudo constructor to set up default
	data structures.
	--->
	<cfinclude template="../../../../../config/applicationSettings.cfm">
	<cfinclude template="../../../../../config/mappings.cfm">
	<cfinclude template="../../../../../plugins/mappings.cfm">
	<cfscript>
	THIS.mappings["/CKFinder_Connector"] = mapPrefix & BaseDir & "/requirements/ckfinder/core/connector/cfm/";
	</cfscript>

	<!--- Include the CFC creation proxy. --->
	<cfinclude template="createcfc.udf.cfm" />

	<!--- Required by flash uloader --->
	<cffunction name="onSessionStart" access="public" returntype="void" output="false" hint="I initialize the session.">
		<cfset var requestData = GetHTTPRequestData()>
		<cfif LCase(requestData.method) eq "post">
			<!--- ColdFusion 9 does not use CFID/CFTOKEN passed in the URL, so we need to do it manually. --->
			<cfif isDefined('URL.CFID')>
				<cfcookie name="CFID" value="#URL.CFID#" httpOnly="true" secure="#application.configBean.getValue('secureCookies')#" />
			</cfif>
			<cfif isDefined('URL.CFTOKEN')>
				<cfcookie name="CFTOKEN" value="#URL.CFTOKEN#" httpOnly="true" secure="#application.configBean.getValue('secureCookies')#" />
			</cfif>
			<cfif isDefined('URL.JSESSIONID')>
				<cfcookie name="JSESSIONID" value="#URL.JSESSIONID#" httpOnly="true" secure="#application.configBean.getValue('secureCookies')#" />
			</cfif>
		</cfif>
		<cfreturn />
	</cffunction>

	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false" hint="Pre-page processing for the page request.">
		<!---
		Store the CreateCFC method in the application
		scope.
		--->
		<cfset APPLICATION.CreateCFC = THIS.CreateCFC />
		<cfset APPLICATION.CFVersion = Left(SERVER.COLDFUSION.PRODUCTVERSION,Find(",",SERVER.COLDFUSION.PRODUCTVERSION)-1) />
		<cfreturn true />
	</cffunction>

</cfcomponent>
