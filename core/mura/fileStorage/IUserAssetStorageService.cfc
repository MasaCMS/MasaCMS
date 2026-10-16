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
	      Methods take storage keys, not filesystem paths: {poolID}/{subtype}/{path}, where
	      poolID is the site's File Pool directory and subtype is 'assets' (User_Assets) or
	      'cache' (the file cache), e.g. default/assets/photo.jpg or
	      default/cache/file/{fileID}_small.png. See mura.fileStorage.storageKey.
	      Implement this interface to create a pluggable storage backend for Masa CMS
	      User_Assets. Core code never references an implementation directly: it resolves
	      the 'fileStorageService' bean, which onApplicationStart_include.cfm aliases to
	      the default 'localStorageService' singleton. To use another backend, declare it
	      as a bean and point the alias at it:
	        serviceFactory.declareBean('myStorageService', 'path.to.myStorageService', true);
	        serviceFactory.addAlias('fileStorageService', 'myStorageService');
	      This must happen before anything resolves 'fileStorageService': the factory
	      caches a singleton under the name it was requested by, so re-pointing the alias
	      afterwards has no effect until the factory is reloaded.">

	<!--- ==================== READ ==================== --->

	<cffunction name="readFile" returntype="string" access="public" output="false"
		hint="Read file content as a string. Returns: string -- same as fileRead()">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
	</cffunction>

	<cffunction name="readFileBinary" returntype="any" access="public" output="false"
		hint="Read file content as binary data. Returns: binary -- same as fileReadBinary()">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
	</cffunction>

	<!--- ==================== WRITE ==================== --->

	<cffunction name="writeFile" returntype="void" access="public" output="false"
		hint="Write string or binary content to a file. Creates parent directories if needed.">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
		<cfargument name="content" type="any" required="true" hint="String or binary content to write">
	</cffunction>

	<!--- ==================== DELETE ==================== --->

	<cffunction name="deleteFile" returntype="void" access="public" output="false"
		hint="Delete a single file. No-op if the file does not exist.">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
	</cffunction>

	<cffunction name="deleteDirectory" returntype="void" access="public" output="false"
		hint="Delete a directory. Throws if recurse=false and directory is not empty.">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
		<cfargument name="recurse" type="boolean" required="false" default="false" hint="Delete recursively">
	</cffunction>

	<!--- ==================== EXISTS ==================== --->

	<cffunction name="fileExists" returntype="boolean" access="public" output="false"
		hint="Check if a file exists. Returns: boolean -- same as fileExists()">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
	</cffunction>

	<cffunction name="directoryExists" returntype="boolean" access="public" output="false"
		hint="Check if a directory exists. Returns: boolean -- same as directoryExists()">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
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
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
		<cfargument name="filter" type="string" required="false" default="*" hint="Filename filter (e.g. '*.jpg')">
		<cfargument name="type" type="string" required="false" default="all" hint="'all', 'file', or 'dir'">
	</cffunction>

	<!--- ==================== DIRECTORIES ==================== --->

	<cffunction name="createDirectory" returntype="void" access="public" output="false"
		hint="Create a directory. Creates parent directories if needed. No-op if already exists.">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
	</cffunction>

	<!--- ==================== COPY / MOVE / RENAME ==================== --->

	<cffunction name="copyFile" returntype="void" access="public" output="false"
		hint="Copy a file. Both are storage keys.">
		<cfargument name="source" type="string" required="true" hint="Source storage key">
		<cfargument name="destination" type="string" required="true" hint="Destination storage key">
	</cffunction>

	<cffunction name="moveFile" returntype="void" access="public" output="false"
		hint="Move a file. Both are storage keys.">
		<cfargument name="source" type="string" required="true" hint="Source storage key">
		<cfargument name="destination" type="string" required="true" hint="Destination storage key">
	</cffunction>

	<cffunction name="renameFile" returntype="void" access="public" output="false"
		hint="Rename a file or directory within the same parent directory.
		      Both are storage keys.">
		<cfargument name="source" type="string" required="true" hint="Current storage key">
		<cfargument name="destination" type="string" required="true" hint="New storage key (new name, same directory)">
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
		<cfargument name="destination" type="string" required="true" hint="Storage key of the destination directory">
		<cfargument name="fileField" type="string" required="true" hint="Name of the form file field">
	</cffunction>

	<!--- ==================== LOCAL RESOLUTION (for image ops) ==================== --->

	<cffunction name="resolveToLocal" returntype="string" access="public" output="false"
		hint="Resolve a storage key to an absolute local filesystem path.
		      For local storage: returns the absolute path directly (no-op).
		      For cloud storage: downloads the file to a temp directory first.
		      Used by image operations (ImageNew, ImageRead) that require local files.
		      Callers must pass the returned path to releaseLocal() when they are done
		      with it, and must never delete it themselves: for local storage it is the
		      stored file itself.
		      Returns: string -- absolute local filesystem path">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
	</cffunction>

	<cffunction name="releaseLocal" returntype="void" access="public" output="false"
		hint="Release a path returned by resolveToLocal() once the caller is done with it.
		      For local storage: no-op.
		      For cloud storage: deletes the temp copy that resolveToLocal() downloaded.
		      Must only delete temp copies this backend created, and leave any other path
		      untouched, so callers can release unconditionally.">
		<cfargument name="localPath" type="string" required="true" hint="A path returned by resolveToLocal()">
	</cffunction>

	<cffunction name="writeFromLocal" returntype="void" access="public" output="false"
		hint="Write a local file to the storage backend, replacing any existing object at
		      remotePath (callers rely on this instead of deleting the old object first).
		      For local storage: moves the file into place.
		      For cloud storage: uploads the file then removes the local temp copy.
		      Used after image processing to persist the result back to storage.">
		<cfargument name="localPath" type="string" required="true" hint="Absolute path to the local source file">
		<cfargument name="remotePath" type="string" required="true" hint="Destination storage key">
	</cffunction>

	<!--- ==================== URL ==================== --->

	<cffunction name="getBaseUrl" returntype="string" access="public" output="false"
		hint="Get the base URL prefix for constructing public asset URLs.
		      Core doesn't call this: it builds asset URLs from the site's settings (e.g.
		      fileManager.createHREFForImage(), filebrowser's getBaseResourcePath()).
		      It's available to modules and custom code.
		      For local: returns site.getFileAssetPath() & '/assets' (no trailing slash)
		      For S3: returns https://bucket.s3-endpoint.com/prefix (no trailing slash)
		      For GCS: returns https://storage.googleapis.com/bucket/prefix (no trailing slash)
		      Returns: string -- URL prefix without trailing slash">
		<cfargument name="siteid" type="string" required="true" hint="Site identifier">
	</cffunction>

	<!--- ==================== DIRECT CORE OPERATIONS ==================== --->

	<cffunction name="streamToResponse" returntype="boolean" access="public" output="false"
		hint="Stream an object directly from storage to the current HTTP response.
		      Used by core download/render flows to avoid requiring a local file copy.
		      Returns false if the object does not exist, so the caller can fall back.">
		<cfargument name="path" type="string" required="true" hint="Storage key, e.g. default/assets/photo.jpg or default/cache/file/{fileID}.png">
		<cfargument name="method" type="string" required="false" default="inline" hint="Content-Disposition: inline or attachment">
	</cffunction>

	<cffunction name="uploadBinary" returntype="void" access="public" output="false"
		hint="Persist binary content to the storage backend.">
		<cfargument name="data" type="any" required="true" hint="Binary content to store">
		<cfargument name="contentType" type="string" required="true" hint="MIME type of the content">
		<cfargument name="key" type="string" required="true" hint="Storage key, e.g. {siteid}/cache/file/{id}.{ext}">
	</cffunction>

	<cffunction name="deleteObject" returntype="void" access="public" output="false"
		hint="Delete a stored object from the backend.">
		<cfargument name="key" type="string" required="true" hint="Storage key, e.g. {siteid}/cache/file/{id}.{ext}">
	</cffunction>

	<cffunction name="listObjects" returntype="array" access="public" output="false"
		hint="List the stored objects directly under a path whose names start with prefix (not recursive).
		      Returns an array of full storage keys (path + name), usable with deleteObject().
		      Returns an empty array if nothing matches or the path does not exist.
		      Required: fileDAO.deleteCachedFile() relies on it to remove every cached variant
		      of a file, including custom image sizes. There is no fallback, so a backend whose
		      store cannot list by prefix must handle that inside its own listObjects(), and a
		      cloud backend needs list permission (e.g. s3:ListBucket, storage.objects.list)
		      as well as delete permission.">
		<cfargument name="path" type="string" required="true" hint="Storage key of the containing directory, e.g. {siteid}/cache/file/">
		<cfargument name="prefix" type="string" required="false" default="" hint="Only include objects whose names start with this, e.g. a fileID">
	</cffunction>

</cfinterface>
