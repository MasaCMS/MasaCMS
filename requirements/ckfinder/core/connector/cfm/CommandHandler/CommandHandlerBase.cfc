<cfcomponent output="false">
<!---
 * CKFinder
 * ========
 * http://cksource.com/ckfinder
 * Copyright (C) 2007-2015, CKSource - Frederico Knabben. All rights reserved.
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--->

<cfset THIS.currentFolder = APPLICATION.CreateCFC("Core.FolderHandler")>
<cfset THIS.currentFolder.Init()>
<cfset THIS.mustCheckRequest = true>
<cfset THIS.mustAddCurrentFolderNode = true>
<cfset THIS.command = "" >

<cffunction name="checkCsrfToken" access="public" returntype="boolean">
	<cfif not structkeyexists(FORM, "ckCsrfToken")>
		<cfreturn false>
	</cfif>
	<cfif not structkeyexists(Cookie, "ckCsrfToken")>
		<cfreturn false>
	</cfif>
	<cfif Len(Trim(FORM.ckCsrfToken)) lt 32>
		<cfreturn false>
	</cfif>
	<cfif Trim(FORM.ckCsrfToken) eq Trim(Cookie.ckCsrfToken) >
		<cfreturn true>
	</cfif>

	<cfreturn false>
</cffunction>

<cffunction name="checkRequest" access="public" returntype="boolean">
	<cfset coreConfig = APPLICATION.CreateCFC("Core.Config")>

	<cfif structkeyexists(FORM, "CKFinderCommand") or THIS.command eq "FileUpload" or THIS.command eq "QuickUpload">
		<cfif not isDefined( "REQUEST.Config.enableCsrfProtection" ) or REQUEST.Config.enableCsrfProtection>
			<cfif not THIS.checkCsrfToken()>
				<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
			</cfif>
		</cfif>
	</cfif>

	<cfif REFind('(/\.)|(//)|[[:cntrl:]]|([\\:\*\?\"<>])', THIS.currentFolder.clientPath)>
		<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME#">
	</cfif>
	<cfif StructIsEmpty(THIS.currentFolder.resourceTypeConfig)>
		<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_TYPE#">
	</cfif>

	<cfif coreConfig.checkIsHiddenPath(THIS.currentFolder.clientPath)>
		<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_REQUEST#">
	</cfif>

	<cfif not directoryexists(THIS.currentFolder.getServerPath())>
		<cfif THIS.currentFolder.clientPath eq "/">
			<cfif isDefined( "REQUEST.Config.chmodFolders" ) and REQUEST.Config.chmodFolders>
				<cfdirectory action="create" directory="#THIS.currentFolder.getServerPath()#" mode="#REQUEST.Config.chmodFolders#">
			<cfelse>
				<cfdirectory action="create" directory="#THIS.currentFolder.getServerPath()#">
			</cfif>
		<cfelse>
			<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_FOLDER_NOT_FOUND#">
		</cfif>
	</cfif>
	<cfreturn true>
</cffunction>

</cfcomponent>
