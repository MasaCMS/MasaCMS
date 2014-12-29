<cfcomponent output="true">
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

<cffunction access="public" name="executeCommand" hint="execute Command" returntype="boolean" description="Execute requested command" output="true">
	<cfargument name="command" type="String" required="true">

	<cfset var result = false />
	<cfset var oObject = "" />

	<cfif not REQUEST.oHooks.run('BeforeExecuteCommand', command)>
		<cfreturn false />
	</cfif>

	<cfswitch expression="#command#" >
		<!--- execute command that returns XML --->
		<cfcase value="CopyFiles;MoveFiles;Init;LoadCookies;GetFiles;GetFolders;RenameFile;DeleteFiles;CreateFolder;RenameFolder;DeleteFolder;Thumbnail" delimiters=";">
			<!--- check if connector is enabled --->
			<cfif not REQUEST.CheckAuthentication()>
				<cfthrow type="ckfinder" errorCode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_CONNECTOR_DISABLED#" />
			</cfif>

			<!--- execute command ---->
			<cftry>
				<cfset oObject=APPLICATION.CreateCFC("CommandHandler." & #command#)>
				<cfset result=oObject.sendResponse()>

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
		</cfcase>

		<!--- execute command that doesn't return XML --->
		<cfcase value="DownloadFile;FileUpload;QuickUpload" delimiters=";">

			<cftry>
				<cfset oObject=APPLICATION.CreateCFC("CommandHandler." & #command#)>

				<!--- check if connector is enabled --->
				<cfif not REQUEST.CheckAuthentication()>
					<cfset oObject.throwError(REQUEST.constants.CKFINDER_CONNECTOR_ERROR_CONNECTOR_DISABLED)>
					<cfreturn false />
				</cfif>

				<!--- execute command ---->
				<cfset result=oObject.sendResponse()>

				<!--- actually, errors should be catched inside command handlers and this never should happen --->
				<cfcatch type="any">
					<cfreturn false />
				</cfcatch>
			</cftry>
		</cfcase>

		<cfdefaultcase>
			<cfthrow errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_COMMAND#" type="ckfinder">
			<cfset result=false>
		</cfdefaultcase>
		</cfswitch>

	<cfreturn #result#>
</cffunction>

</cfcomponent>
