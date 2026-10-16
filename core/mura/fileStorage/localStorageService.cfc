<!---

This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the
same licensing model. It is, therefore, licensed under the Gnu General Public License
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing
notice set out below.

Masa CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

--->
<cfcomponent
	displayname="Local Storage Service"
	implements="mura.fileStorage.IUserAssetStorageService"
	extends="mura.cfobject"
	output="false"
	hint="Local filesystem implementation of IUserAssetStorageService.

	      Can be used in two modes:

	      1. Singleton (no-arg init) — registered as the default 'fileStorageService' bean.
	         Resolves all keys relative to configBean.getFileDir(). Unified key format:
	         {siteid}/{subtype}/{filename}  (same layout as GCS/S3 bucket keys).

	      2. Per-site (basePath/baseUrl init) — still used directly by standardEventsHandler
	         for backward compatibility when the simple relative-path form is needed.">

	<cfset variables.fw       = "">
	<cfset variables.basePath = "">
	<cfset variables.baseUrl  = "">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="basePath" type="string" required="false" default=""
			hint="Absolute filesystem root. Empty = singleton mode (resolves via configBean.getFileDir()).">
		<cfargument name="baseUrl" type="string" required="false" default=""
			hint="URL prefix for assets. Empty = singleton mode (resolved per-call from settingsManager).">
		<cfset variables.basePath = arguments.basePath>
		<cfset variables.baseUrl  = arguments.baseUrl>
		<cfset variables.fw = new mura.fileWriter().init(routeUserAssets=false)>
		<cfreturn this>
	</cffunction>

	<!---
		Resolve a relative key to an absolute local path.
		- Per-site mode:  basePath is set at init → prepend it (original behaviour).
		- Singleton mode: basePath is empty → key is "{siteid}/{subtype}/…" style →
		  resolve "assets" under configBean.getAssetDir() and "cache" under configBean.getFileDir().
	--->
	<cffunction name="resolveSingletonRoot" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true">
		<cfset var normalizedPath = reReplace(replace(arguments.path, "\", "/", "ALL"), "^/+", "")>
		<cfset var subtype = "">

		<cfif listLen(normalizedPath, "/") GTE 2>
			<cfset subtype = lCase(listGetAt(normalizedPath, 2, "/"))>
		</cfif>

		<cfif subtype EQ "assets">
			<cfreturn application.configBean.getAssetDir()>
		<cfelse>
			<cfreturn application.configBean.getFileDir()>
		</cfif>
	</cffunction>

	<cffunction name="fullPath" access="private" returntype="string" output="false">
		<cfargument name="path" type="string" required="true">
		<cfset var normalizedPath = reReplace(replace(arguments.path, "\", "/", "ALL"), "^/+", "")>
		<cfif len(variables.basePath)>
			<cfreturn variables.basePath & arguments.path>
		<cfelse>
			<cfreturn resolveSingletonRoot(normalizedPath) & "/" & normalizedPath>
		</cfif>
	</cffunction>

	<!--- ==================== READ ==================== --->

	<cffunction name="readFile" access="public" returntype="string" output="false">
		<cfargument name="path" type="string" required="true">
		<cfreturn fileRead(fullPath(arguments.path))>
	</cffunction>

	<cffunction name="readFileBinary" access="public" returntype="any" output="false">
		<cfargument name="path" type="string" required="true">
		<cfreturn fileReadBinary(fullPath(arguments.path))>
	</cffunction>

	<!--- ==================== WRITE ==================== --->

	<cffunction name="writeFile" access="public" returntype="void" output="false">
		<cfargument name="path" type="string" required="true">
		<cfargument name="content" type="any" required="true">
		<cfset variables.fw.writeFile(file=fullPath(arguments.path), output=arguments.content, addNewLine=false)>
	</cffunction>

	<!--- ==================== DELETE ==================== --->

	<cffunction name="deleteFile" access="public" returntype="void" output="false">
		<cfargument name="path" type="string" required="true">
		<cfset var fp = fullPath(arguments.path)>
		<cfif fileExists(fp)>
			<cfset fileDelete(fp)>
		</cfif>
	</cffunction>

	<cffunction name="deleteDirectory" access="public" returntype="void" output="false">
		<cfargument name="path" type="string" required="true">
		<cfargument name="recurse" type="boolean" required="false" default="false">
		<cfset variables.fw.deleteDir(directory=fullPath(arguments.path), recurse=arguments.recurse)>
	</cffunction>

	<!--- ==================== EXISTS ==================== --->

	<cffunction name="fileExists" access="public" returntype="boolean" output="false">
		<cfargument name="path" type="string" required="true">
		<cfreturn fileExists(fullPath(arguments.path))>
	</cffunction>

	<cffunction name="directoryExists" access="public" returntype="boolean" output="false">
		<cfargument name="path" type="string" required="true">
		<cfreturn directoryExists(fullPath(arguments.path))>
	</cffunction>

	<!--- ==================== LIST ==================== --->

	<cffunction name="listDirectory" access="public" returntype="query" output="false">
		<cfargument name="path" type="string" required="true">
		<cfargument name="filter" type="string" required="false" default="*">
		<cfargument name="type" type="string" required="false" default="all">
		<cfreturn variables.fw.getDirectoryList(
			directory = fullPath(arguments.path),
			filter    = arguments.filter,
			type      = arguments.type
		)>
	</cffunction>

	<!--- ==================== DIRECTORIES ==================== --->

	<cffunction name="createDirectory" access="public" returntype="void" output="false">
		<cfargument name="path" type="string" required="true">
		<cfset variables.fw.touchDir(fullPath(arguments.path))>
	</cffunction>

	<!--- ==================== COPY / MOVE / RENAME ==================== --->

	<cffunction name="copyFile" access="public" returntype="void" output="false">
		<cfargument name="source" type="string" required="true">
		<cfargument name="destination" type="string" required="true">
		<cfset variables.fw.copyFile(
			source      = fullPath(arguments.source),
			destination = fullPath(arguments.destination)
		)>
	</cffunction>

	<cffunction name="moveFile" access="public" returntype="void" output="false">
		<cfargument name="source" type="string" required="true">
		<cfargument name="destination" type="string" required="true">
		<cfset variables.fw.moveFile(
			source      = fullPath(arguments.source),
			destination = fullPath(arguments.destination)
		)>
	</cffunction>

	<cffunction name="renameFile" access="public" returntype="void" output="false">
		<cfargument name="source" type="string" required="true">
		<cfargument name="destination" type="string" required="true">
		<cfset variables.fw.renameFile(
			source      = fullPath(arguments.source),
			destination = fullPath(arguments.destination)
		)>
	</cffunction>

	<!--- ==================== UPLOAD ==================== --->

	<cffunction name="uploadFile" access="public" returntype="struct" output="false">
		<cfargument name="destination" type="string" required="true">
		<cfargument name="fileField" type="string" required="true">
		<cfreturn variables.fw.uploadFile(
			filefield   = arguments.fileField,
			destination = fullPath(arguments.destination)
		)>
	</cffunction>

	<!--- ==================== LOCAL RESOLUTION (for image ops) ==================== --->

	<cffunction name="resolveToLocal" access="public" returntype="string" output="false">
		<cfargument name="path" type="string" required="true">
		<!--- Local storage: the path IS the local path already --->
		<cfreturn fullPath(arguments.path)>
	</cffunction>

	<cffunction name="writeFromLocal" access="public" returntype="void" output="false">
		<cfargument name="localPath" type="string" required="true">
		<cfargument name="remotePath" type="string" required="true">
		<!--- Local storage: move the temp file to its final destination --->
		<cfset fileMove(arguments.localPath, fullPath(arguments.remotePath))>
	</cffunction>

	<!--- ==================== URL ==================== --->

	<cffunction name="getBaseUrl" access="public" returntype="string" output="false">
		<cfargument name="siteid" type="string" required="true">
		<cfif len(variables.baseUrl)>
			<cfreturn variables.baseUrl>
		<cfelse>
			<!--- Singleton mode: look up site URL dynamically --->
			<cfreturn application.settingsManager.getSite(arguments.siteid).getFileAssetPath() & "/assets">
		</cfif>
	</cffunction>

	<!--- ==================== BINARY CACHE (used by fileDAO) ==================== --->
	<!---
		uploadBinary and deleteObject use the unified key format {siteid}/{subtype}/{path}
		and always resolve relative to configBean.getFileDir() regardless of basePath.
		They are the counterparts to the same methods on gcsStorageService / s3StorageService.
	--->

	<cffunction name="uploadBinary" access="public" returntype="void" output="false"
		hint="Write raw binary content to the local cache. key = {siteid}/cache/file/{id}.{ext}">
		<cfargument name="data" type="any" required="true">
		<cfargument name="contentType" type="string" required="true">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			var fp = application.configBean.getFileDir() & "/" & reReplace(replace(arguments.key, "\", "/", "ALL"), "^/+", "");
			variables.fw.touchDir(getDirectoryFromPath(fp));
			if (isBinary(arguments.data)) {
				fileWrite(fp, arguments.data);
			} else {
				variables.fw.writeFile(file=fp, output=arguments.data);
			}
		</cfscript>
	</cffunction>

	<cffunction name="deleteObject" access="public" returntype="void" output="false"
		hint="Delete a cached file by key. key = {siteid}/cache/file/{id}.{ext}">
		<cfargument name="key" type="string" required="true">
		<cfscript>
			var fp = application.configBean.getFileDir() & "/" & reReplace(replace(arguments.key, "\", "/", "ALL"), "^/+", "");
			if (fileExists(fp)) { fileDelete(fp); }
		</cfscript>
	</cffunction>

	<!--- ==================== STREAMING PROXY ==================== --->

	<cffunction name="streamToResponse" access="public" returntype="boolean" output="false"
		hint="Stream a local file directly to the servlet response. Returns false if the file does not exist.">
		<cfargument name="path" type="string" required="true">
		<cfargument name="method" type="string" required="false" default="inline">
		<cfscript>
			var fp = fullPath(arguments.path);
			if (!fileExists(fp)) { return false; }
			var filename      = listLast(replace(fp, "\", "/", "ALL"), "/");
			var contentType   = "";
			try {
				contentType = createObject("java", "java.nio.file.Files").probeContentType(
					createObject("java", "java.io.File").init(fp).toPath()
				);
			} catch (any e) {}
			if (isNull(contentType) || !len(contentType)) { contentType = "application/octet-stream"; }
			var response = getPageContext().getResponse();
			response.setContentType(contentType);
			response.setHeader("Content-Length", getFileInfo(fp).size);
			var disposition = (arguments.method eq "attachment") ? "attachment" : "inline";
			response.setHeader("Content-Disposition", disposition & "; filename=""" & filename & """");
			response.setHeader("Cache-Control", "max-age=86400");
			var is = createObject("java", "java.io.FileInputStream").init(fp);
			var os = response.getOutputStream();
			var buffer = createObject("java", "java.lang.reflect.Array").newInstance(
				createObject("java", "java.lang.Byte").TYPE, 65536
			);
			var bytesRead = 0;
			while (true) {
				bytesRead = is.read(buffer);
				if (bytesRead eq -1) { break; }
				os.write(buffer, 0, bytesRead);
			}
			os.flush();
			is.close();
			return true;
		</cfscript>
	</cffunction>

</cfcomponent>
