<!---

This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the
same licensing model. It is, therefore, licensed under the Gnu General Public License
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing
notice set out below.

Masa CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

--->
<cfinterface displayname="User Asset Storage Service"
	hint="Contract for User_Assets storage backends. Return types are enforced by CFML
	      at instantiation. Expected internal structures (query columns, struct keys)
	      are documented per method and match CFML native returns.
	      Implement this interface to create a pluggable storage backend for Masa CMS
	      User_Assets. Register the implementation via a module eventHandler that overrides
	      standardUserAssetActionHandler.">

	<!--- ==================== READ ==================== --->

	<cffunction name="readFile" returntype="string" access="public" output="false"
		hint="Read file content as a string. Returns: string -- same as fileRead()">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
	</cffunction>

	<cffunction name="readFileBinary" returntype="any" access="public" output="false"
		hint="Read file content as binary data. Returns: binary -- same as fileReadBinary()">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
	</cffunction>

	<!--- ==================== WRITE ==================== --->

	<cffunction name="writeFile" returntype="void" access="public" output="false"
		hint="Write string or binary content to a file. Creates parent directories if needed.">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
		<cfargument name="content" type="any" required="true" hint="String or binary content to write">
	</cffunction>

	<!--- ==================== DELETE ==================== --->

	<cffunction name="deleteFile" returntype="void" access="public" output="false"
		hint="Delete a single file. No-op if the file does not exist.">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
	</cffunction>

	<cffunction name="deleteDirectory" returntype="void" access="public" output="false"
		hint="Delete a directory. Throws if recurse=false and directory is not empty.">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
		<cfargument name="recurse" type="boolean" required="false" default="false" hint="Delete recursively">
	</cffunction>

	<!--- ==================== EXISTS ==================== --->

	<cffunction name="fileExists" returntype="boolean" access="public" output="false"
		hint="Check if a file exists. Returns: boolean -- same as fileExists()">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
	</cffunction>

	<cffunction name="directoryExists" returntype="boolean" access="public" output="false"
		hint="Check if a directory exists. Returns: boolean -- same as directoryExists()">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
	</cffunction>

	<!--- ==================== LIST ==================== --->

	<cffunction name="listDirectory" returntype="query" access="public" output="false"
		hint="List directory contents.
		      Returns: query with columns matching cfdirectory action='list':
		        name (varchar) - filename or directory name
		        directory (varchar) - full path to the containing directory
		        size (numeric) - file size in bytes (0 for directories)
		        type (varchar) - 'File' or 'Dir'
		        datelastmodified (date) - last modification timestamp">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
		<cfargument name="filter" type="string" required="false" default="*" hint="Filename filter (e.g. '*.jpg')">
		<cfargument name="type" type="string" required="false" default="all" hint="'all', 'file', or 'dir'">
	</cffunction>

	<!--- ==================== DIRECTORIES ==================== --->

	<cffunction name="createDirectory" returntype="void" access="public" output="false"
		hint="Create a directory. Creates parent directories if needed. No-op if already exists.">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
	</cffunction>

	<!--- ==================== COPY / MOVE / RENAME ==================== --->

	<cffunction name="copyFile" returntype="void" access="public" output="false"
		hint="Copy a file. Both paths are relative to the User_Assets root.">
		<cfargument name="source" type="string" required="true" hint="Source relative path">
		<cfargument name="destination" type="string" required="true" hint="Destination relative path">
	</cffunction>

	<cffunction name="moveFile" returntype="void" access="public" output="false"
		hint="Move a file. Both paths are relative to the User_Assets root.">
		<cfargument name="source" type="string" required="true" hint="Source relative path">
		<cfargument name="destination" type="string" required="true" hint="Destination relative path">
	</cffunction>

	<cffunction name="renameFile" returntype="void" access="public" output="false"
		hint="Rename a file or directory within the same parent directory.
		      Both paths are relative to the User_Assets root.">
		<cfargument name="source" type="string" required="true" hint="Current relative path">
		<cfargument name="destination" type="string" required="true" hint="New relative path (new name, same directory)">
	</cffunction>

	<!--- ==================== UPLOAD ==================== --->

	<cffunction name="uploadFile" returntype="struct" access="public" output="false"
		hint="Handle a multipart file upload from an HTTP form field.
		      Returns: struct with keys matching cffile action='upload' result:
		        serverFile (string) - final filename on server
		        serverFileName (string) - filename without extension
		        serverFileExt (string) - file extension
		        serverDirectory (string) - directory path where file was saved
		        contentType (string) - MIME type
		        contentSubType (string) - MIME subtype
		        fileSize (numeric) - size in bytes
		        clientFile (string) - original filename from client
		        clientFileName (string) - original filename without extension
		        clientFileExt (string) - original extension
		        timeCreated (date) - upload timestamp">
		<cfargument name="destination" type="string" required="true" hint="Relative destination directory within User_Assets root">
		<cfargument name="fileField" type="string" required="true" hint="Name of the form file field">
	</cffunction>

	<!--- ==================== LOCAL RESOLUTION (for image ops) ==================== --->

	<cffunction name="resolveToLocal" returntype="string" access="public" output="false"
		hint="Resolve a User_Assets path to an absolute local filesystem path.
		      For local storage: returns the absolute path directly (no-op).
		      For cloud storage: downloads the file to a temp directory first.
		      Used by image operations (ImageNew, ImageRead) that require local files.
		      Returns: string -- absolute local filesystem path">
		<cfargument name="path" type="string" required="true" hint="Relative path within User_Assets root">
	</cffunction>

	<cffunction name="writeFromLocal" returntype="void" access="public" output="false"
		hint="Write a local file to the storage backend.
		      For local storage: moves the file using fileMove (same as before).
		      For cloud storage: uploads the file then removes the local temp copy.
		      Used after image processing to persist the result back to storage.">
		<cfargument name="localPath" type="string" required="true" hint="Absolute path to the local source file">
		<cfargument name="remotePath" type="string" required="true" hint="Relative destination path within User_Assets root">
	</cffunction>

	<!--- ==================== URL ==================== --->

	<cffunction name="getBaseUrl" returntype="string" access="public" output="false"
		hint="Get the base URL prefix for constructing public asset URLs.
		      For local: returns site.getFileAssetPath() & '/assets' (no trailing slash)
		      For S3: returns https://bucket.s3-endpoint.com/prefix (no trailing slash)
		      For GCS: returns https://storage.googleapis.com/bucket/prefix (no trailing slash)
		      Returns: string -- URL prefix without trailing slash">
		<cfargument name="siteid" type="string" required="true" hint="Site identifier">
	</cffunction>

</cfinterface>
