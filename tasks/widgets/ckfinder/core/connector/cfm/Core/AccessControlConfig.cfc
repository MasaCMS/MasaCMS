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

<cffunction name="Init" access="public" returntype="void" output="false" hint="Returns an initialized instance.">

	<cfscript>
	var folderView = false;
	var folderCreate = false;
	var folderRename = false;
	var folderDelete = false;
	var fileView = false;
	var fileUpload = false;
	var fileRename = false;
	var fileDelete = false;
	var role = "";
	var resourceType = "";
	var folder = "";
	var arrayone = arrayNew(1);
	var arraytwo = arrayNew(1);
	</cfscript>

	<cfset THIS.config = REQUEST.config />
	<cfset THIS.aclEntries = structNew() />

	<cfloop from="1" to="#arrayLen(REQUEST.config.accessControl)#" step="1" index="i">
		<cfscript>
			node = REQUEST.config.accessControl[i];

			role = "*";
			if(structkeyexists(node,"role")) {
				role = node.role;
			}

			resourceType = "*";
			if(structkeyexists(node,"resourceType")) {
				resourceType = node.resourceType;
			}

			folder = "/";
			if(structkeyexists(node,"folder")) {
				folder = node.folder;
			}

			folderView = false;
			folderCreate = false;
			folderRename = false;
			folderDelete = false;
			fileView = false;
			fileUpload = false;
			fileRename = false;
			fileDelete = false;

			if (structkeyexists(node,"folderView")) {
				folderView=node.folderView;
			}
			if (structkeyexists(node,"folderCreate")) {
				folderCreate=node.folderCreate;
			}
			if (structkeyexists(node,"folderRename")) {
				folderRename=node.folderRename;
			}
			if (structkeyexists(node,"folderDelete")) {
				folderDelete=node.folderDelete;
			}
			if (structkeyexists(node,"fileView")) {
				fileView=node.fileView;
			}
			if (structkeyexists(node,"fileUpload")) {
				fileUpload=node.fileUpload;
			}
			if (structkeyexists(node,"fileRename")) {
				fileRename=node.fileRename;
			}
			if (structkeyexists(node,"fileDelete")) {
				fileDelete=node.fileDelete;
			}

			arrayone = arrayNew(1);
			arraytwo = arrayNew(1);
		</cfscript>
		<cfloop from="1" to="8" step="1" index="i">
			<cfset arrayone[i] = 0 >
			<cfset arraytwo[i] = 0 >
		</cfloop>
		<cfscript>
			if (folderView) arrayone[1] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_VIEW;
			if (folderCreate) arrayone[2] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_CREATE;
			if (folderRename) arrayone[3] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_RENAME;
			if (folderDelete) arrayone[4] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_DELETE;
			if (fileView) arrayone[5] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW;
			if (fileUpload) arrayone[6] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_UPLOAD;
			if (fileRename) arrayone[7] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_RENAME;
			if (fileDelete) arrayone[8] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_DELETE;

			if (not folderView) arraytwo[1] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_VIEW;
			if (not folderCreate) arraytwo[2] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_CREATE;
			if (not folderRename) arraytwo[3] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_RENAME;
			if (not folderDelete) arraytwo[4] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_DELETE;
			if (not fileView) arraytwo[5] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_VIEW;
			if (not fileUpload) arraytwo[6] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_UPLOAD;
			if (not fileRename) arraytwo[7] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_RENAME;
			if (not fileDelete) arraytwo[8] = REQUEST.constants.CKFINDER_CONNECTOR_ACL_FILE_DELETE;

			THIS.addACLEntry(role, resourceType, folder, arrayone, arraytwo);
		</cfscript>
	</cfloop>
</cffunction>

<cffunction name="addACLEntry" access="public" returntype="void" output="false" hint="Add ACL entry.">
	<cfargument name="role" type="String" required="true">
	<cfargument name="resourceType" type="String" required="true">
	<cfargument name="folderPath" type="String" required="true">
	<cfargument name="allowRulesMask" type="Array" required="true">
	<cfargument name="denyRulesMask" type="Array" required="true">

	<cfscript>
		folderPath = ARGUMENTS.folderPath;

		if (not len(folderPath)) {
			folderPath = '/';
		}
		else {
			if ( left(folderPath,1) neq '/') {
				folderPath = '/' & folderPath;
			}
			if ( right(folderPath,1) neq '/') {
				folderPath = folderPath & '/';
			}
		}

		entryKey = ARGUMENTS.role & "##@##" & resourcetype;

		if (structkeyexists(THIS.aclEntries, folderPath)) {
			if (structkeyexists(THIS.aclEntries[folderPath], entryKey)) {
				rulesMasks = THIS.aclEntries[folderPath][entryKey];
				for (i = 1; i LTE arrayLen(rulesMasks[1]); i = i+1) {
					allowRulesMask[i] = bitor(allowRulesMask[i], rulesMasks[1][i]);
				}
				for (i = 1; i LTE arrayLen(rulesMasks[2]); i = i+1) {
					denyRulesMask[i] = bitor(denyRulesMask[i], rulesMasks[2][i]);
				}
			}
		}
		else {
			THIS.aclEntries[folderPath] = structNew();
		}

		THIS.aclEntries[folderPath][entryKey] = arrayNew(1);
		THIS.aclEntries[folderPath][entryKey][1] = allowRulesMask;
		THIS.aclEntries[folderPath][entryKey][2] = denyRulesMask;
	</cfscript>
</cffunction>

<cffunction access="public" name="getComputedMask" hint="Compute ACL mask" returntype="Numeric" description="Compute ACL" output="false">
	<cfargument name="resourceType" type="String" required="true">
	<cfargument name="folderPath" type="String" required="true">

	<cfscript>
		var computedMask = 0;
		var userRole = "";
		var pathParts = arrayNew(1);
		var currentPath = '/';
		var end = 0;
		var i = 0;

		if (isDefined("THIS.config.roleSessionVar") and len(THIS.config.roleSessionVar) and structkeyexists(Session, THIS.config.roleSessionVar)) {
			userRole = Session[THIS.config.roleSessionVar];
		}

		folderPath = APPLICATION.CreateCFC("Utils.Misc").TrimChar(ARGUMENTS.folderPath, '/');
		pathParts = listtoarray(folderPath, '/');
	</cfscript>

	<cfset end = arrayLen(pathParts)>
	<cfloop from="0" to="#end#" step="1" index="i">
		<cfscript>
			if (i gte 1) {
				if (i gt end) {
					continue;
				}

				if (structkeyexists(THIS.aclEntries, currentPath & "*/")) {
					computedMask = THIS.mergePathComputedMask(computedMask, ARGUMENTS.resourceType, userRole, currentPath & "*/");
				}

				currentPath = currentPath & pathParts[i] & "/";
			}
			if (structkeyexists(THIS.aclEntries, currentPath)) {
				computedMask = THIS.mergePathComputedMask(computedMask, ARGUMENTS.resourceType, userRole, currentPath);
			}
		</cfscript>
	</cfloop>
	<cfreturn computedMask>
</cffunction>

<cffunction access="public" name="mergePathComputedMask" hint="merge path computed mask" returntype="Numeric" description="merge mask" output="false">
	<cfargument name="currentMask" type="Numeric" required="true">
	<cfargument name="resourceType" type="String" required="true">
	<cfargument name="userRole" type="String" required="true">
	<cfargument name="path" type="String" required="true">

	<cfset var folderEntries = THIS.aclEntries[path] />
	<cfset var possibleEntries = arrayNew(1) />
	<cfset var rulesMasks = structNew() />

	<cfset possibleEntries[1] = "*##@##*">
	<cfset possibleEntries[2] = "*##@##" & ARGUMENTS.resourceType>

	<cfif Len(ARGUMENTS.userRole) gt 0 >
		<cfset possibleEntries[3] = ARGUMENTS.userRole & "##@##*">
		<cfset possibleEntries[4] = ARGUMENTS.userRole & "##@##" & ARGUMENTS.resourceType>
	</cfif>

	<cfloop from="1" to="#arrayLen(possibleEntries)#" step="1" index="i">
		<cfset possibleKey = possibleEntries[i]>
		<cfif structkeyexists(folderEntries, possibleKey)>
			<cfset rulesMasks = folderEntries[possibleKey]>

			<cfset currentMask = bitor(currentMask, arraysum(rulesMasks[1]))>
			<cfset currentMask = bitxor(currentMask, bitand(currentMask, arraysum(rulesMasks[2])))>
		</cfif>
	</cfloop>

	<cfreturn currentMask>
</cffunction>
</cfcomponent>
