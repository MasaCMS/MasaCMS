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

<cffunction name="Init" access="public" returntype="any" hint="Returns an initialized instance." output="false">
	<cfargument name="type" required="false" type="String" default="" />
	<cfargument name="path" required="false" type="String" default="" />
	<cfscript>
	var sType = type;
	var sPath = path;

	THIS.resourceTypeName = "";
	THIS.clientPath = "/";
	THIS.aclMask = -1;
	THIS.allowDotFiles = false;
	THIS.allowedExtensions = arrayNew(1);
	THIS.deniedExtensions = arrayNew(1);
	THIS.checkDoubleExtension = false;

	if (structkeyexists(REQUEST.config, "allowDotFiles") and REQUEST.config.allowDotFiles) {
		THIS.allowDotFiles = true;
	}
	if (structkeyexists(REQUEST.config, "checkDoubleExtension") and REQUEST.config.checkDoubleExtension) {
		THIS.checkDoubleExtension = true;
	}

	if (Len(sType) eq 0 and structkeyexists(URL, "type")) {
		sType = URL.type;
	}
	if (Len(sPath) eq 0 and structkeyexists(URL, "currentFolder")) {
		sPath = URL.currentFolder;
	}
	if (Len(sType) gt 0) {
		THIS.resourceTypeName = sType;
		THIS.resourceTypeConfig = APPLICATION.CreateCFC("Core.Config").getResourceTypeConfig(THIS.resourceTypeName);
		if (not StructIsEmpty(THIS.resourceTypeConfig)) {
			THIS.deniedExtensions = ListToArray(THIS.resourceTypeConfig.deniedExtensions, ",");
			THIS.allowedExtensions = ListToArray(THIS.resourceTypeConfig.allowedExtensions, ",");
		}
	}
	if (Len(sPath) gt 0) {
		THIS.clientPath = APPLICATION.CreateCFC("Utils.FileSystem").FixPath(sPath, false);
	}
	</cfscript>
	<cfreturn "#THIS#">
</cffunction>

<cffunction name="getUrl" access="public" returntype="String" hint="Returns url to current folder" output="false">
	<cfset var result = "" />
	<cfif structkeyexists(THIS, "resourceTypeConfig") and structkeyexists(THIS.resourceTypeConfig, "url") >
		<cfset result = THIS.resourceTypeConfig.url />
	<cfelse>
		<cfif structkeyexists(REQUEST.config, "baseUrl")>
			<cfset result = REQUEST.config.baseUrl />
		</cfif>
	</cfif>
	<cfset result = APPLICATION.CreateCFC("Utils.FileSystem").CombinePaths(result, THIS.clientPath) />
	<cfreturn "#result#">
</cffunction>

<cffunction name="getServerPath" access="public" returntype="String" output="true" hint="Map the virtual path to the local server path">
	<cfargument name="resourceTypeConfig" required="false" default="#THIS.resourceTypeConfig#" type="Struct"/>
	<cfscript>
		var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem");
		var folderPath = "";
		if(structkeyexists(resourceTypeConfig, "directory") and Len(resourceTypeConfig.directory)) {
			folderPath = replace(resourceTypeConfig.directory,"\","/","all");
		}
		else {
			if (structkeyexists(resourceTypeConfig, "url") and Len(resourceTypeConfig.url)) {
				folderPath = replace(fileSystem.resolveUrl(resourceTypeConfig.url), "\", "/", "all");
			}
			else if(structkeyexists(REQUEST.config, "baseUrl")) {
				folderPath = replace(fileSystem.resolveUrl(REQUEST.config.baseUrl), "\", "/", "all");
			}
			else {
				folderPath = replace(fileSystem.resolveUrl("/"), "\", "/", "all");
			}
		}
		folderPath = fileSystem.combinePaths(folderPath, THIS.clientPath);
	</cfscript>
	<cfreturn "#folderPath#">
</cffunction>

<cffunction name="getAclMask" access="public" returntype="String" output="true" hint="Returns ACL mask">
	<cfscript>
		if (THIS.aclMask eq -1) {
			acl = APPLICATION.CreateCFC("Core.AccessControlConfig");
			THIS.aclMask = acl.getComputedMask(THIS.resourceTypeName, THIS.clientPath);
		}
	</cfscript>
	<cfreturn "#THIS.aclMask#">
</cffunction>

<cffunction name="checkAcl" access="public" returntype="boolean" output="false" hint="check ACL">
	<cfargument name="aclToCheck" required="true" type="Numeric" />
	<cfscript>
		var maska = THIS.getAclMask();
		var result = false;

		if (bitand(maska, ARGUMENTS.aclToCheck) eq ARGUMENTS.aclToCheck) {
			result = true;
		}
		else {
			result = false;
		}
	</cfscript>
	<cfreturn "#result#" />
</cffunction>

<cffunction name="checkExtension" output="true" returntype="Array">
	<cfargument name="fileName" required="true" type="String">

	<cfscript>
		var result = arrayNew(1);
		var pieces = arrayNew(1);
		var i = 1;

		result[1] = true;
		result[2] = fileName;
		if (not THIS.allowDotFiles and left(ARGUMENTS.fileName,1) eq ".") {
			result[1] = false;
			return result;
		}
		pieces = listToArray(ARGUMENTS.fileName, ".");
		if (arrayLen(pieces) eq 1) {
			result[1] = true;
			return result;
		}
		if (THIS.checkDoubleExtension) {
			// First, check the last extension (ex. in file.php.jpg, the "jpg").

			if (not THIS.checkSingleExtension(pieces[arrayLen(pieces)])) {
				result[1] = false;
				return result;
			}

			// Check the other extensions, rebuilding the file name. If an extension is
			// not allowed, replace the dot with an underscore.
			fileName = pieces[1] ;
			for (i=2; i lt arrayLen(pieces); i=i+1) {
				if (THIS.checkSingleExtension(pieces[i])) {
					fileName = fileName & ".";
				}
				else {
					fileName = fileName & "_";
				}
				fileName = fileName & pieces[i];
			}

			// Add the last extension to the final name.
			fileName = fileName & '.' & pieces[arrayLen(pieces)] ;
			result[2] = fileName;
		}
		else {
			// Check only the last extension (ex. in file.php.jpg, only "jpg").
			dotPos = Len(fileName) - find('.', reverse(fileName)) + 1;
			result[1] = THIS.checkSingleExtension(mid(fileName, dotPos + 1, Len(fileName)-dotPos));
		}
	</cfscript>
	<cfreturn result>
</cffunction>

<cffunction name="checkSingleExtension" output="true" returntype="boolean" access="public">
	<cfargument name="ext" required="true" type="String" />

	<cfscript>
		var i=1;
		var lcaseExt = lcase(ARGUMENTS.ext);

		if (arrayLen(THIS.deniedExtensions)) {
			for(i=1;i lte arrayLen(THIS.deniedExtensions);i=i+1) {
				if (lcase(THIS.deniedExtensions[i]) eq lcaseExt) {
					return false;
				}
			}
		}

		if (arrayLen(THIS.allowedExtensions)) {
			for(i=1;i lte arrayLen(THIS.allowedExtensions);i=i+1) {
				if (lcase(THIS.allowedExtensions[i]) eq lcaseExt) {
					return true;
				}
			}
			return false;
		}
		return true;
	</cfscript>
</cffunction>

<cffunction name="getThumbsServerPath" access="public" returntype="String" output="true">
	<cfset var folderPath = "" />
	<cfset var fileSystem = APPLICATION.CreateCFC("Utils.FileSystem") />

	<cfif (not isDefined("THIS.thumbServerPath")) >
		<cfscript>
		if(structkeyexists(REQUEST.config.thumbnails, "baseDir") and Len(REQUEST.config.thumbnails.baseDir)) {
			THIS.thumbServerPath = replace(REQUEST.config.thumbnails.baseDir,"\","/","all");
		}
		else {
			THIS.thumbServerPath = fileSystem.combinePaths(replaceNoCase(replace(getBaseTemplatePath(),"\","/","all"),CGI.script_name,""), REQUEST.config.thumbnails.url);
		}
		</cfscript>

		<cfset THIS.thumbServerPath = fileSystem.combinePaths(THIS.thumbServerPath, THIS.resourceTypeName)>
		<cfset THIS.thumbServerPath = fileSystem.combinePaths(THIS.thumbServerPath, THIS.clientPath)>

		<cfscript>
			if (not directoryexists(THIS.thumbServerPath)) {
				fileSystem.createDirectoryRecursively(THIS.thumbServerPath);
			}
		</cfscript>
	</cfif>
	<cfreturn THIS.thumbServerPath>
</cffunction>

<cffunction name="getThumbsUrl" access="public" returntype="String" hint="Returns url to thumbs folder" output="false">
	<cfset var result = "/" />
	<cfif structkeyexists(REQUEST.config.thumbnails, "url") >
		<cfset result = REQUEST.config.thumbnails.url />
	</cfif>
	<cfif right(result, 1) neq "/">
		<cfset result = result & "/">
	</cfif>
	<cfreturn result />
</cffunction>

</cfcomponent>
