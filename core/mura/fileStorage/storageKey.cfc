<!---

This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the
same licensing model. It is, therefore, licensed under the Gnu General Public License
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing
notice set out below.

Masa CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

--->
<cfcomponent output="false"
	hint="Builds and parses storage keys: {poolID}/{subtype}/{path}, e.g. default/assets/photo.jpg
	      or default/cache/file/{fileID}.png. The first segment is a site's File Pool directory, the
	      second the subtype: 'assets' keys live under configBean.getAssetDir(), every other subtype
	      under configBean.getFileDir(). Keys use forward slashes and have no leading slash.">

	<cffunction name="normalize" access="public" returntype="string" output="false"
		hint="Forward slashes, no leading slash.">
		<cfargument name="key" type="string" required="true">
		<cfreturn reReplace(replace(arguments.key, "\", "/", "ALL"), "^/+", "")>
	</cffunction>

	<cffunction name="getSubtype" access="public" returntype="string" output="false"
		hint="The key's second segment, lowercased (e.g. 'assets' or 'cache'), or empty.">
		<cfargument name="key" type="string" required="true">
		<cfset var normalizedKey = normalize(arguments.key)>
		<cfif listLen(normalizedKey, "/") GTE 2>
			<cfreturn lCase(listGetAt(normalizedKey, 2, "/"))>
		</cfif>
		<cfreturn "">
	</cffunction>

	<cffunction name="cacheDirKey" access="public" returntype="string" output="false"
		hint="The key of a File Pool's file cache directory: {poolID}/cache/file">
		<cfargument name="poolID" type="string" required="true">
		<cfreturn arguments.poolID & "/cache/file">
	</cffunction>

	<cffunction name="cacheFileKey" access="public" returntype="string" output="false"
		hint="The key of a cached file: {poolID}/cache/file/{fileID}.{ext}, or with a variant
		      (e.g. 'small', 'medium', 'source', '200x100') {poolID}/cache/file/{fileID}_{variant}.{ext}">
		<cfargument name="poolID" type="string" required="true">
		<cfargument name="fileID" type="string" required="true">
		<cfargument name="fileExt" type="string" required="true">
		<cfargument name="variant" type="string" required="false" default="">
		<cfset var suffix = len(arguments.variant) ? "_" & arguments.variant : "">
		<cfreturn cacheDirKey(arguments.poolID) & "/" & arguments.fileID & suffix & "." & arguments.fileExt>
	</cffunction>

	<cffunction name="toLocalPath" access="public" returntype="string" output="false"
		hint="The absolute local filesystem path for a key.">
		<cfargument name="key" type="string" required="true">
		<cfset var normalizedKey = normalize(arguments.key)>
		<cfset var root = getSubtype(normalizedKey) EQ "assets" ? application.configBean.getAssetDir() : application.configBean.getFileDir()>
		<cfreturn root & "/" & normalizedKey>
	</cffunction>

	<cffunction name="fromAssetPath" access="public" returntype="string" output="false"
		hint="The key for an absolute path inside a site's User_Assets directory
		      ({assetDir}/{poolID}/assets/...), or empty if the path is anywhere else.
		      The key is built from the File Pool directory, so every site sharing a pool
		      gets the same key for the same file.">
		<cfargument name="path" type="string" required="true">
		<cfscript>
			var assetRoot = replace(application.configBean.getAssetDir(), "\", "/", "ALL") & "/";
			var normalizedPath = replace(arguments.path, "\", "/", "ALL");

			if (len(normalizedPath) <= len(assetRoot) || compareNoCase(left(normalizedPath, len(assetRoot)), assetRoot)) {
				return "";
			}

			var key = mid(normalizedPath, len(assetRoot) + 1, len(normalizedPath));
			if (listLen(key, "/") < 2 || getSubtype(key) != "assets") {
				return "";
			}
			// "{poolID}/assets" itself, or something inside it (not e.g. "{poolID}/assets-old").
			var poolAssets = listGetAt(key, 1, "/") & "/" & listGetAt(key, 2, "/");
			if (len(key) > len(poolAssets) && mid(key, len(poolAssets) + 1, 1) != "/") {
				return "";
			}
			if (!isFilePoolID(listGetAt(key, 1, "/"))) {
				return "";
			}
			return key;
		</cfscript>
	</cffunction>

	<cffunction name="isFilePoolID" access="private" returntype="boolean" output="false">
		<cfargument name="poolID" type="string" required="true">
		<cfscript>
			var sites = "";
			try {
				sites = application.settingsManager.getList();
			} catch (any e) {
				return false;
			}
			for (var i = 1; i <= sites.recordCount; i++) {
				try {
					if (application.settingsManager.getSite(sites.siteID[i]).getFilePoolID() == arguments.poolID) {
						return true;
					}
				} catch (any e) {}
			}
			return false;
		</cfscript>
	</cffunction>

</cfcomponent>
