<cfcomponent>
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

<cffunction name="CombinePaths" access="public" returntype="String" output="true"
hint="This function behaves similar to System.IO.Path.Combine in C Sharp">
<cfargument name="path1" type="string" required="true" />
<cfargument name="path2" type="string" required="true" />
<cfscript>
	var result = "";
		if (not Len(path2)) {
			if (Len(path1)) {
				lastCharP1 = right(path1, 1);
				if ((lastCharP1 neq "/") and (lastCharP1 neq "\\")) {
					path1 = path1 & "/";
				}
			}
		}
		else {
			firstCharP2 = left(path2, 1);
			if (Len(path1)) {
				if (find(path1, path2) eq 1) {
					result = path2;
					break;
				}
				lastCharP1 = right(path1, 1);
				if (lastCharP1 neq "/" and lastCharP1 neq "\\" and firstCharP2 neq "/" and firstCharP2 neq "\\") {
					path1 = path1 & "/";
				}
			}
			else {
				result = path2;
			}
		}
		if (not Len(result)) {
			if (right(path1, 1) eq "/" and left(path2, 1) eq "/") {
				result = mid(path1, 1, Len(path1) - 1) & path2;
			}
			else {
				result = path1 & path2;
			}
		}
</cfscript>
<cfreturn result />
</cffunction>

<cffunction name="fixPath" access="public" returntype="String" output="false"
hint="Fix path (add trailing slashes etc.)">
<cfargument name="path" type="string" required="true" />
<cfargument name="fixBackslash" type="boolean" required="false" default="true" />
<cfscript>
	if (fixBackslash) {
		path = replace(path, "\", "/", "all");
	}
	if (Right(path, 1) neq "/") {
		path = path & "/";
	}
	if (Left(path, 1) neq "/") {
		path = "/" & path;
	}
</cfscript>
<cfreturn path />
</cffunction>

<cffunction name="fixUrl" access="public" returntype="String" output="false"
hint="Fix url (add trailing slashes etc.)">
<cfargument name="path" type="string" required="true" />
<cfscript>
	if (len(path) gte 1) {
		if ( right(path, 1) neq "/") {
			path = path & "/";
		}
	}
</cfscript>
<cfreturn path />
</cffunction>

<cffunction name="checkFileName" access="public" returntype="boolean" output="false"
hint="check if filename is valid">
<cfargument name="fileName" type="string" required="true" />
<cfscript>
	if(not Len(ARGUMENTS.fileName) or right(ARGUMENTS.fileName,1) eq "." or find("..",ARGUMENTS.fileName)) {
		return false;
	}
	if(REFindNoCase('\\|\/|\:|\?|\*|"|<|>|[[:cntrl:]]', ARGUMENTS.fileName)) {
		return false;
	}
	if (isDefined( "REQUEST.Config.disallowUnsafeCharacters" ) and REQUEST.Config.disallowUnsafeCharacters and find( ";", ARGUMENTS.fileName )) {
		return false;
	}
	return true;
</cfscript>
</cffunction>

<cffunction name="checkFolderName" access="public" returntype="boolean" output="false"
hint="check if foldername is valid">
<cfargument name="folderName" type="string" required="true" />
<cfscript>
	if (isDefined( "REQUEST.Config.disallowUnsafeCharacters" ) and REQUEST.Config.disallowUnsafeCharacters and find( ".", ARGUMENTS.folderName )) {
		return false;
	}
	return THIS.checkFileName(ARGUMENTS.folderName);
</cfscript>
</cffunction>

<cffunction name="getFileNameWithoutExtension" returntype="String" access="public" output="false">
	<cfargument name="fileName" type="String" required="true" />
	<cfset var pieces = arrayNew(1) />
	<cfset pieces = listToArray(ARGUMENTS.fileName, ".")>
	<cfreturn pieces[1]>
</cffunction>

<cffunction name="getFileExtension" returntype="String" access="public" output="false">
	<cfargument name="fileName" type="String" required="true" />
	<cfset var pieces = listToArray(ARGUMENTS.fileName, ".") />
	<cfset var extension = "" />
	<cfset var i = 1 />
	<cfset var piecesCount = arrayLen(pieces)>
	<cfif piecesCount gt 1>
		<cfscript>
			for(i=2;i lte piecesCount;i=i+1) {
				extension = extension & "." & pieces[i];
			}
		</cfscript>
	</cfif>
	<cfreturn extension>
</cffunction>

<cffunction name="fileSize" returntype="Numeric" access="public" output="false">
	<cfargument name="pathToFile" type="String" required="true">
	<cfscript>
	var fileInstance = createObject("java","java.io.File").init(toString(arguments.pathToFile));
	var fileList = "";
	var ii = 0;
	var totalSize = 0;

	//if this is a simple file, just return it's length
	if(fileInstance.isFile()){
		return fileInstance.length();
	}
	else if(fileInstance.isDirectory()) {
		fileList = fileInstance.listFiles();
		for(ii = 1; ii LTE arrayLen(fileList); ii = ii + 1){
			totalSize = totalSize + fileSize(fileList[ii]);
		}
		return totalSize;
	}
	else {
		return 0;
	}
	</cfscript>
</cffunction>

<cffunction name="resolveUrl" access="public" returntype="String" output="false">
	<cfargument name="baseUrl" required="true" type="String">
	<cfscript>
		return THIS.combinePaths(replaceNoCase(replace(getBaseTemplatePath(),"\","/","all"),CGI.script_name,""), REReplaceNoCase(ARGUMENTS.baseUrl, "^http(s)?://[^/]+", "", "ALL"));
	</cfscript>
</cffunction>

<cffunction name="createDirectoryRecursively" output="false" returnType="boolean">
	<cfargument name="fileAndPath"	  type="string"   required="true">
	<cfargument name="isPathToFile"  type="Boolean" required="false"  default="false">

	<cfset var path_array	 = ListToArray(fileAndPath, "/")>
	<cfset var this_dir_path  = path_array[1]>   <!--- first item in fileAndPath is the drive path --->
	<cfset var file_name	  = path_array[ArrayLen(path_array)]>   <!--- last item in fileAndPath is the file name --->
	<cfset var last		   = ArrayLen(path_array)-1>
	<cfset var i = 0>

	<cfif left(ARGUMENTS.fileAndPath,2) eq "//">
		<cfset this_dir_path = "//" & this_dir_path>
	<cfelseif left(ARGUMENTS.fileAndPath,1) eq "/">
		<cfset this_dir_path = "/" & this_dir_path>
	</cfif>
	<cfif not isPathToFile>
		<cfset last = last+1>
	</cfif>

	<cftry>
		<!--- lock these directories and files to prevent errors with concurrent threads --->
		<cflock timeout="30" throwontimeout="Yes" name="WriteFileAndDirectoriesLock" type="EXCLUSIVE">
			<!--- create any missing directories --->
			<cfloop index="i" from="2" to="#last#">
				<cfset this_dir_path = this_dir_path & "/" &  path_array[i]>
				<cfset createDirectory = false>
				<cftry>
					<cfif not DirectoryExists(this_dir_path)>
						<cfset createDirectory = true>
					</cfif>
					<cfcatch type="any">
					</cfcatch>
				</cftry>
				<cfif createDirectory>
					<cfif isDefined( "REQUEST.Config.chmodFolders" ) and REQUEST.Config.chmodFolders>
						<cfdirectory action="CREATE" directory="#this_dir_path#" mode="#REQUEST.Config.chmodFolders#">
					<cfelse>
						<cfdirectory action="CREATE" directory="#this_dir_path#">
					</cfif>
				</cfif>
			</cfloop>
		</cflock>

		<cfcatch type="any">
			<cfreturn false>
		</cfcatch>
	</cftry>

	<cfreturn true>
</cffunction>

<cffunction name="getFileMimeType" returntype="string" output="no">
	<cfargument name="filePath" type="string" required="yes">
	<cfreturn getPageContext().getServletContext().getMimeType(arguments.filePath)>
</cffunction>

<cffunction name="getLastModifiedStamp">
	<cfargument name="filename" required="true" type="String">
	<cfscript>
		var _File =  createObject("java","java.io.File");
		// Calculate adjustments fot timezone and daylightsavindtime
		var _Offset = ((GetTimeZoneInfo().utcHourOffset)+1)*-3600;
		_File.init(JavaCast("string", filename));
		// Date is returned as number of seconds since 1-1-1970
		return DateAdd('s', (Round(_File.lastModified()/1000))+_Offset, CreateDateTime(1970, 1, 1, 0, 0, 0));
	</cfscript>
</cffunction>

<cffunction name="getThumbFileName" access="public" returntype="String">
	<cfargument name="fileName">
	<cfscript>
		var extPos = REFindNoCase("\.([a-z]+)$", fileName);
		var ext = "";
		var thumbName = "";

		if (not extPos or APPLICATION.CFVersion gte 8) {
			return fileName;
		}

		ext = lcase(mid(fileName, extPos, Len(fileName)));

		if (ext neq ".jpg") {
			thumbName = mid(fileName, 1, extPos-1) & "_" & mid(fileName, extPos+1, Len(ext)) & ".jpg";
		}
		else {
			thumbName = fileName;
		}
		return thumbName;
	</cfscript>
</cffunction>

<cffunction name="binaryFileRead" returntype="String" output="true">
	<cfargument name="fileName" required="true" type="string">
	<cfargument name="bytes" required="true" type="Numeric">

	<cfscript>
	var chunk = "";
	var fileReaderClass = "";
	var fileReader = "";
	var file = "";
	var done = false;
	var counter = 0;
	var byteArray = "";

	if( not fileExists( ARGUMENTS.fileName ) )
	{
		return "" ;
	}

	if (APPLICATION.CFVersion gte 8)
	{
		 file  = FileOpen( ARGUMENTS.fileName, "readbinary" ) ;
		 byteArray = FileRead( file, 1024 ) ;
		 chunk = toString( toBinary( toBase64( byteArray ) ) ) ;
		 FileClose( file ) ;
	}
	else
	{
		fileReaderClass = createObject("java", "java.io.FileInputStream");
		fileReader = fileReaderClass.init(fileName);

		while(not done)
		{
			char = fileReader.read();
			counter = counter + 1;
			if ( char eq -1 or counter eq ARGUMENTS.bytes)
			{
				done = true;
			}
			else
			{
				chunk = chunk & chr(char) ;
			}
		}
	}
	</cfscript>

	<cfreturn chunk>
</cffunction>

<!---
 Detect HTML in the first KB to prevent against potential security issue with
 IE/Safari/Opera file type auto detection bug.
 Returns true if file contain insecure HTML code at the beginning.
--->
<cffunction name="detectHtml" output="false" returntype="boolean">
	<cfargument name="filePath" required="true" type="String">

	<cfset var tags = "<body,<head,<html,<img,<pre,<script,<table,<title">
	<cfset var chunk = lcase( Trim( THIS.binaryFileRead( ARGUMENTS.filePath, 1024 ) ) )>

	<cfif not Len(chunk)>
		<cfreturn false>
	</cfif>

	<cfif refind('<!doctype\W*x?html', chunk)>
		<cfreturn true>
	</cfif>

	<cfloop index = "tag" list = "#tags#">
		<cfif find( tag, chunk )>
			<cfreturn true>
		</cfif>
	</cfloop>

	<!--- type = javascript --->
	<cfif refind('type\s*=\s*[''"]?\s*(?:\w*/)?(?:ecma|java)', chunk)>
		<cfreturn true>
	</cfif> >

	<!--- href = javascript --->
	<!--- src = javascript --->
	<!--- data = javascript --->
	<cfif refind('(?:href|src|data)\s*=\s*[\''"]?\s*(?:ecma|java)script:', chunk)>
		<cfreturn true>
	</cfif>

	<!--- url(javascript --->
	<cfif refind('url\s*\(\s*[\''"]?\s*(?:ecma|java)script:', chunk)>
		<cfreturn true>
	</cfif>

	<cfreturn false>
</cffunction>

<!---
Move file from temp directory
This special function is created because ColdFusion has a bug:
moving file from one partition to other throws an exception
--->
<cffunction name="moveTempFile" returntype="void" output="false">
	<cfargument name="source" required="true" type="String">
	<cfargument name="destination" required="true" type="String">

	<cfif isDefined( "REQUEST.Config.chmodFiles" ) and REQUEST.Config.chmodFiles>
		<cffile action="copy" source="#ARGUMENTS.source#" destination="#ARGUMENTS.destination#" mode="#REQUEST.Config.chmodFiles#" attributes="normal" />
	<cfelse>
		<cffile action="copy" source="#ARGUMENTS.source#" destination="#ARGUMENTS.destination#" attributes="normal" />
	</cfif>
	<cftry>
		<!--- fail gracefully, after all it''s just a temp file  --->
		<cffile action="delete" file="#ARGUMENTS.source#">
		<cfcatch type="any">
		</cfcatch>
	</cftry>

</cffunction>

<!---
Check file content.
Currently this function validates only image files.
Returns false if file is invalid.
---->
<cffunction name="isImageValid" returntype="boolean" output="true">
	<cfargument name="filePath" required="true" type="String">
	<cfargument name="extension" required="true" type="String">

	<cfset var imageCFC = "">
	<cfset var imageInfo = "">

	<cfif not ListFindNoCase("gif,jpeg,jpg,png,psd,bmp,iff,tiff,tif,swc,jpc,jp2,jpx,jb2,xmb,wbmp", ARGUMENTS.extension)>
		<cfreturn true>
	</cfif>

	<cftry>
		<cfif APPLICATION.CFVersion gte 8>
			<cftry>
				<!--- sometimes ColdFusion is unable to read image files properly with ImageRead --->
				<cfset objImage = ImageRead(ARGUMENTS.filePath) >
				<cfset imageInfo = ImageInfo(objImage)>
				<cfcatch type="any">
					<cfset imageInfo = APPLICATION.CreateCFC("ImageCFC.image").getImageInfo("", ARGUMENTS.filePath)>
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset imageInfo = APPLICATION.CreateCFC("ImageCFC.image").getImageInfo("", ARGUMENTS.filePath)>
		</cfif>

		<cfif imageInfo.height lte 0 or imageInfo.width lte 0>
			<cfreturn false>
		</cfif>
	<cfcatch type="any">
		<cfreturn false>
	</cfcatch>
	</cftry>

	<cfreturn true>
</cffunction>

<cffunction access="public" name="hasChildren" hint="return true if given folder has subfolders" returntype="boolean" description="return true if given folder has subfolders" output="false">
	<cfargument name="config" required="true" type="any">
	<cfargument name="clientPath" required="true" type="String">
	<cfargument name="folderPath" required="true" type="String">
	<cfargument name="resourceType" required="true" type="any">

	<cfset var i =1 />
	<cfset var filename = "">
	<cfset var filetype = "">
	<cfset var acl = APPLICATION.CreateCFC("Core.AccessControlConfig") />

	<cfdirectory action="list" directory="#ARGUMENTS.folderPath#" name="qDirTemp" sort="type,name">

	<cfscript>
		while( i lte qDirTemp.recordCount ) {
			foldername = qDirTemp.name[i];
			foldertype = qDirTemp.type[i];
			i=i+1;
			if (listFind(".,..", foldername) eq 0 and compareNoCase( foldertype, "FILE" ) neq 0) {
				// skip if hidden path
				if (config.checkIsHiddenPath(clientPath & foldername & "/"))
					continue;
				aclMask = acl.getComputedMask(resourceType, clientPath & foldername & "/");
				// return true if folder found with valid folder_view permissions
				if (bitAnd(aclMask, REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_VIEW) eq REQUEST.constants.CKFINDER_CONNECTOR_ACL_FOLDER_VIEW)
					return true;
			}
		}
	</cfscript>
	<cfreturn false>
</cffunction>

</cfcomponent>
