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

<cfset Init()>

<cffunction name="Init" access="public" output="false" returntype="any" >
	<cfset THIS.config = REQUEST.config />
	<cfreturn this />
</cffunction>

<cffunction name="getResourceTypeConfig" access="public" output="true" returntype="Struct" >
	<cfargument name="resourceTypeName" type="String" />

	<cfset var result = structNew()>

	<cfif structkeyexists(REQUEST.config, "resourceType") and arrayLen(REQUEST.config.resourceType)>
		<cfloop from="1" to="#arrayLen(REQUEST.config.resourceType)#" step="1" index="i">
			<cfif REQUEST.config.resourceType[i].name eq ARGUMENTS.resourceTypeName>
				<cfset result = REQUEST.config.resourceType[i]>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn result />
</cffunction>

<cffunction name="getHideFoldersRegex" access="public" output="true" returntype="String" >
	<cfif not isDefined("REQUEST.folderRegex")>
		<cfif isDefined("REQUEST.config.hideFolders") and arrayLen(REQUEST.config.hideFolders) gt 0>
			<cfset REQUEST.folderRegex = arrayToList(REQUEST.config.hideFolders, "|") >
			<cfset REQUEST.folderRegex = replace(REQUEST.folderRegex, "?", "__QMK__", "all") />
			<cfset REQUEST.folderRegex = replace(REQUEST.folderRegex, "*", "__AST__", "all") />
			<cfset REQUEST.folderRegex = replace(REQUEST.folderRegex, "|", "__PIP__", "all") />
			<cfif isDefined('Server.ColdFusion.AppServer') and refindnocase("bluedragon", Server.ColdFusion.AppServer)>
				<cfset REQUEST.folderRegex = reReplace(REQUEST.folderRegex, "[.*+?^${}()|[\]/\\]", "\\0", "all") />
			<cfelse>
				<cfset REQUEST.folderRegex = reReplace(REQUEST.folderRegex, "[.*+?^${}()|[\]/\\]", "\\\0", "all") />
			</cfif>
			<cfset REQUEST.folderRegex = replace(REQUEST.folderRegex, "__QMK__", ".", "all") />
			<cfset REQUEST.folderRegex = replace(REQUEST.folderRegex, "__AST__", ".*", "all") />
			<cfset REQUEST.folderRegex = replace(REQUEST.folderRegex, "__PIP__", "|", "all") />
			<cfset REQUEST.folderRegex = "^(?m)(?:" & REQUEST.folderRegex & ")$" />
		<cfelse>
			<cfset REQUEST.folderRegex = "" />
		</cfif>
	</cfif>

	<cfreturn REQUEST.folderRegex />
</cffunction>

<cffunction name="getHideFilesRegex" access="public" output="true" returntype="String" >
	<cfif not isDefined("REQUEST.fileRegex")>
		<cfif isDefined("REQUEST.config.hideFiles") and arrayLen(REQUEST.config.hideFiles) gt 0>
			<cfset REQUEST.fileRegex = arrayToList(REQUEST.config.hideFiles, "|") >
			<cfset REQUEST.fileRegex = replace(REQUEST.fileRegex, "?", "__QMK__", "all") />
			<cfset REQUEST.fileRegex = replace(REQUEST.fileRegex, "*", "__AST__", "all") />
			<cfset REQUEST.fileRegex = replace(REQUEST.fileRegex, "|", "__PIP__", "all") />
			<cfif isDefined('Server.ColdFusion.AppServer') and refindnocase("bluedragon", Server.ColdFusion.AppServer)>
				<cfset REQUEST.fileRegex = reReplace(REQUEST.fileRegex, "[.*+?^${}()|[\]/\\]", "\\0", "all") />
			<cfelse>
				<cfset REQUEST.fileRegex = reReplace(REQUEST.fileRegex, "[.*+?^${}()|[\]/\\]", "\\\0", "all") />
			</cfif>
			<cfset REQUEST.fileRegex = replace(REQUEST.fileRegex, "__QMK__", ".", "all") />
			<cfset REQUEST.fileRegex = replace(REQUEST.fileRegex, "__AST__", ".*", "all") />
			<cfset REQUEST.fileRegex = replace(REQUEST.fileRegex, "__PIP__", "|", "all") />
			<cfset REQUEST.fileRegex = "^(?m)(?:" & REQUEST.fileRegex & ")$" />
		<cfelse>
			<cfset REQUEST.fileRegex = "" />
		</cfif>
	</cfif>

	<cfreturn REQUEST.fileRegex />
</cffunction>

<cffunction name="checkIsHiddenFolder" access="public" output="true" returntype="Boolean" >
	<cfargument name="folderName" type="String" />

	<cfset var regex = THIS.getHideFoldersRegex()>
	<cfif Len(regex)>
		<cfreturn refindnocase(regex, ARGUMENTS.folderName)>
	</cfif>
	<cfreturn false />
</cffunction>

<cffunction name="checkIsHiddenFile" access="public" output="true" returntype="any" >
	<cfargument name="fileName" type="String" />

	<cfset var regex = THIS.getHideFilesRegex()>
	<cfif Len(regex)>
		<cfreturn refindnocase(regex, ARGUMENTS.fileName)>
	</cfif>
	<cfreturn false />
</cffunction>

<cffunction name="checkIsHiddenPath" access="public" output="true" returntype="any" >
	<cfargument name="path" type="String" />

	<cfif (right(path, 1) eq "/") >
		<cfset path = mid(path, 1, Len(path)-1) >
	</cfif>
	<cfif (left(path, 1) eq "/")>
		<cfset path = mid(path, 2, Len(path)-1) >
	</cfif>
	<cfset clientPathParts = listToArray(path, "/") >
	<cfif arrayLen(clientPathParts)>
		<cfset coreConfig = APPLICATION.CreateCFC("Core.Config")>
		<cfloop from="1" to="#arrayLen(clientPathParts)#" step="1" index="i">
			<cfif THIS.checkIsHiddenFolder(clientPathParts[i])>
				<cfreturn true>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn false />
</cffunction>

</cfcomponent>
