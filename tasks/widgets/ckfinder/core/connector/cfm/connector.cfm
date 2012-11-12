<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="no">
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

<cffunction name="include" output="false" returnType="void">
	<cfargument name="template" type="string" required="true">
	<cfinclude template="../../../#template#">
</cffunction>

<cfinclude template="constants.cfm">
<cfinclude template="#constants.CKFINDER_CONNECTOR_CONFIG_FILE_PATH#">

<cfparam name="URL.command" default="">

<!--- REQUEST.config stores config defined by user --->
<cfset REQUEST.config = #config#>
<!--- REQUEST.constants stores constants used by CKFinder --->
<cfset REQUEST.constants = #constants#>
<cfset REQUEST.CheckAuthentication = CheckAuthentication>
<cfset REQUEST.oHooks = APPLICATION.CreateCFC("Core.Hooks")>

<cftry>
	<cfscript>
		oCore_Connector = APPLICATION.CreateCFC("Core.Connector");
		oCore_Connector.executeCommand(URL.command);
	</cfscript>

	<!--- actually, errors should be catched inside command handlers and this never should happen --->
	<cfcatch type="ckfinder">
		<cfscript>
			oCommandHandler_XmlCommandHandler = APPLICATION.CreateCFC("CommandHandler.XmlCommandHandlerBase").Init();
			oCommandHandler_XmlCommandHandler.sendError(#CFCATCH.ErrorCode#);
		</cfscript>
	</cfcatch>
	<!--- actually, errors should be catched inside command handlers and this never should happen --->
	<cfcatch type="any">
		<cfscript>
			oCommandHandler_XmlCommandHandler = APPLICATION.CreateCFC("CommandHandler.XmlCommandHandlerBase").Init();
			oCommandHandler_XmlCommandHandler.sendError(#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_CUSTOM_ERROR#, #CFCATCH.Message#);
		</cfscript>
	</cfcatch>
</cftry>
<cfabort>
