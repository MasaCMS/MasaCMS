<cfcomponent output="false">
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

<cfset THIS.currentFolder = APPLICATION.CreateCFC("Core.FolderHandler")>
<cfset THIS.currentFolder.Init()>
<cfset THIS.mustCheckRequest = true>
<cfset THIS.mustAddCurrentFolderNode = true>
<cfset THIS.command = "" >

<cffunction name="checkRequest" access="public" returntype="boolean">
	<cfif REFind('(/\.)|(//)|[[:cntrl:]]|([\\:\*\?\"<>])', THIS.currentFolder.clientPath)>
		<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_NAME#">
	</cfif>
	<cfif StructIsEmpty(THIS.currentFolder.resourceTypeConfig)>
		<cfthrow type="ckfinder" errorcode="#REQUEST.constants.CKFINDER_CONNECTOR_ERROR_INVALID_TYPE#">
	</cfif>

	<cfset coreConfig = APPLICATION.CreateCFC("Core.Config")>
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
