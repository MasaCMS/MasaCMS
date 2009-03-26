<!---
        CFFM 1.11
        Written by Rick Root (rick@webworksllc.com)
        See LICENSE.TXT for copyright and redistribution restrictions.
--->
<cfcomponent displayname="cffm" hint="Configuration data and methods for CFFM">
	<cfproperty name="includeDir" type="string" hint="Physical directory path to the main directory which CFFM has access to.">
	<cfproperty name="includeDirWeb" type="String" hint="The logical web path to the directory specified by the includeDir property.">
	<cfproperty name="disallowedExtensions" type="String" default="" hint="Extensions that are not allowed to be uploaded.  This also affects files being unzipped from a zip archive.">
	<cfproperty name="allowedExtensions" type="String" default="" hint="Extensions that are allowed to be uploaded.  Overrides disallowedExtensions for increased security.  Useful if you only want people to upload images.">
	<cfproperty name="editableExtensions" type="String" default="" hint="File extensions that specify editable files.">
	<cfproperty name="overwriteDefault" type="boolean" default="true" hint="Default value for the overwrite existing files checkbox in various CFFM forms.">
	<cfproperty name="iconPath" type="string" default="./cffmIcons" hint="Path to the icons used by CFFM.">
	<cfproperty name="debug" type="boolean" default="false" hint="Specifies whether or not debug output will be generated.">
	<cfproperty name="templateWrapperAbove" type="string" default="above.cfm" hint="File that will be cfincluded above all CFFM output.  Should include CFFM specific CSS.">
	<cfproperty name="templateWrapperBelow" type="string" default="below.cfm" hint="File that will be cfincluded below all CFFM output.">
	<cfproperty name="cffmFilename" type="string" default="cffm.cfm" hint="Filename used by the file manager, if other than #chr(34)#cffm.cfm#chr(34)#">

	<cfset this.version = "1.11">


<cffunction access="public" name="init" output="no" returntype="void">
	<cfargument name="includeDir" type="string" required="yes">
	<cfargument name="includeDirWeb" type="String" required="yes">
	<cfargument name="disallowedExtensions" type="String" required="no" default="">
	<cfargument name="allowedExtensions" type="String" required="no" default="">
	<cfargument name="editableExtensions" type="String" required="no" default="">
	<cfargument name="overwriteDefault" type="boolean" required="no" default="true">
	<cfargument name="iconPath" type="string" required="no" default="./cffmIcons">
	<cfargument name="debug" type="numeric" required="no" default="0">
	<cfargument name="templateWrapperAbove" type="string" required="no" default="above.cfm">
	<cfargument name="templateWrapperBelow" type="string" required="no" default="below.cfm">
	<cfargument name="cffmFilename" type="string" required="no" default="cffm.cfm">
	
<cfscript>
	/* see cffm.cfm for details about these */
	this.includeDir = arguments.includeDir;
	this.includeDirWeb = arguments.includeDirWeb;
	this.disallowedExtensions = arguments.disallowedExtensions;
	this.editableExtensions = arguments.editableExtensions;
	this.allowedExtensions = arguments.allowedExtensions;
	this.overwriteDefault = arguments.overwriteDefault;
	this.iconPath = arguments.iconPath;
	this.debug = arguments.debug;
	this.templateWrapperAbove = arguments.templateWrapperAbove;
	this.templateWrapperBelow = arguments.templateWrapperBelow;
	this.cffmFilename = arguments.cffmFilename;
</cfscript>
</cffunction>

<cffunction access="public" name="getPathInfo" output="no" returntype="string">
	<cfargument name="scopeCgi" type="Struct" required="yes">
		<cfif scopeCgi.path_info eq "">
			<cfreturn scopeCgi.script_name>
		<cfelse>
			<cfreturn scopeCgi.path_info>
		</cfif>
</cffunction>

<cffunction access="public" name="createVariables" output="no" returntype="Struct" hint="Sets specified variable names from form, url, or variables scoped variables, and applies a default value if the variable is undefined.">
	<cfargument name="scopeVariables" type="Struct" required="yes">
	<cfargument name="scopeForm" type="Struct" required="yes">
	<cfargument name="scopeUrl" type="Struct" required="yes">
	<cfargument name="varList" type="String" required="yes">

	<cfset var i = 0>
	<cfset var thisVar = "">
	<cfloop from="1" to="#ListLen(arguments.varList)#" index="i" step="1">
		<cfset thisVar = listGetAt(arguments.varList,i)>
		<cfif isDefined("scopeUrl.#thisVar#")>
			<cfset setVariable("scopeVariables." & thisVar, trim(evaluate("scopeUrl.#thisVar#")))>
		<cfelseif isDefined("scopeForm.#thisVar#")>
			<cfset setVariable("scopeVariables." & thisVar, trim(evaluate("scopeForm.#thisVar#")))>
		<cfelse>
			<cfset setVariable("scopeVariables." & thisVar, "")>
		</cfif>
	</cfloop>
	<cfreturn scopeVariables>
</cffunction>

<cffunction access="public" name="forceNumeric" output="no" returntype="Struct" hint="Forces specified variables within the variables scope to be numeric values.  This is required for certain variables when interacting with the java image library.">
	<cfargument name="scopeVariables" type="Struct" required="yes">
	<cfargument name="varList" type="String" required="yes">

	<cfset var i = 0>
	<cfset var thisVar = "">
	<cfloop from="1" to="#ListLen(arguments.varList)#" index="i" step="1">
		<cfset thisVar = listGetAt(varList,i)>
		<cfif not isNumeric(evaluate("scopeVariables." & thisvar))>
			<cfset setVariable("scopeVariables." & thisVar, 0)>
		</cfif>
		<cfset setVariable("scopeVariables." & thisVar,javacast("double",evaluate("scopeVariables." & thisvar)))>
	</cfloop>
	<cfreturn scopeVariables>
</cffunction>

<cffunction access="public" name="getPathType" output="no" returntype="string" hint="Determines if a string is a directory or file path.  Returns an empty string if the path does not exist.">
	<cfargument name="pathValue" type="string" required="yes">
	<cfif directoryExists(arguments.pathValue)>
		<cfreturn "directory">
	<cfelseif fileExists(arguments.pathValue)>
		<cfreturn "file">
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction access="public" name="deleteFile" output="No" returntype="struct" hint="Delete a file.">
	<cfargument name="deleteFile" required="yes" type="string">
	<cfset var retVal = StructNew()>
	<cfscript>
		if (getPathType(arguments.deleteFile) eq "")
		{
			retVal.errorCode = 1;
			retVal.errorMessage = "#this.resourceKit.errorMsg.t12#:  #variables.deleteFile#";
			return retVal;
		}
	</cfscript>
	<cftry>
		<cffile action="DELETE" file="#deleteFile#">
		<cfset retVal.errorCode = 0>
		<cfset retVal.errorMessage = "">
		<cfcatch type="any">
			<cfset retVal.errorCode = 1>
			<cfset retVal.errorMessage = "#this.resourceKit.errorMsg.t13#:  #cfcatch.message# - #cfcatch.detail#">
		</cfcatch>
	</cftry>
	<cfreturn retVal>
</cffunction>

<cffunction access="public" name="deleteDirectory" returntype="Struct" hint="Delete a directory, and optionally delete its contents.">
	<cfargument name="directory" type="string" required="yes">
	<cfargument name="Recurse" type="boolean" required="no" default="False">

	<cfset var myDirectory = "">
	<cfset var count = 0>
	<cfset var retVal = StructNew()>

	<Cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif getPathType(arguments.directory) eq "">
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "#this.resourceKit.errorMsg.t14#: #arguments.directory#">
		<Cfreturn retVal>
	<cfelseif right(Arguments.directory, 1) is not "/">
		<cfset Arguments.directory = Arguments.directory & "/">
	</cfif>
	
	<cftry>
	<cfdirectory action="LIST" directory="#Arguments.directory#"
	name="myDirectory" >
	<cfloop query="myDirectory">
		<cfif myDirectory.name is not "." AND myDirectory.name is not "..">
			<cfset count = count + 1>
			<cfswitch expression="#myDirectory.Type#">
			
				<cfcase value="dir">
					<!--- If recurse is on, move down to next level --->
					<cfif Arguments.Recurse>
						<cfset retVal = deleteDirectory(
							Arguments.directory & myDirectory.Name,
							Arguments.Recurse )>
					</cfif>
				</cfcase>
				
				<cfcase value="file">
					<!--- Copy file --->
					<cfif arguments.Recurse>
						<cffile action="delete" file="#Arguments.directory##myDirectory.Name#">
					</cfif>
				</cfcase>			
			</cfswitch>
		</cfif>
	</cfloop>
	<cfif count is 0 or arguments.recurse>
		<cfdirectory action="delete" directory="#Arguments.directory#">
	</cfif>
	<cfcatch type="any">
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = "#cfcatch.message# #cfcatch.detail#">
	</cfcatch>
	</cftry>
	<cfreturn retVal>
</cffunction>

<cffunction access="public" name="unzipFile" output="no" return="struct" hint="Unzip a specified zip file to a optionally specified output path (defaults to the same directory) and optionally overwrite existing files.">
	<cfargument name="zipFilePath" type="string" required="yes">
	<cfargument name="outputPath" type="string" required="no" default="">
	<cfargument name="overWrite" required="no" default="false">

<cfscript>
	var zipFile = ""; // ZipFile
	var entries = ""; // Enumeration of ZipEntry
	var entry = ""; // ZipEntry
	var fil = ""; //File
	var inStream = "";
	var filOutStream = "";
	var bufOutStream = "";
	var nm = "";
	var pth = "";
	var lenPth = "";
	var buffer = "";
	var l = 0;
	var retVal = StructNew();
	var ext = "";

	retVal.errorCode = 0;
	retVal.errorMessage = "";

	if (outputPath eq "") {
		outputPath = getDirectoryFromPath(zipFilePath);
	}
	if (right(outputpath,1) neq getDirectorySeparator())
	{
		outputpath = outputpath & getDirectorySeparator();
	}
	zipFile = createObject("java", "java.util.zip.ZipFile");
	zipFile.init(zipFilePath);
	
	entries = zipFile.entries();
	
	while(entries.hasMoreElements()) 
	{
		entry = entries.nextElement();
		if(NOT entry.isDirectory()) {
			nm = entry.getName(); 
			
			lenPth = len(nm) - len(getFileFromPath(nm));
			
			if (lenPth) {
			pth = outputPath & left(nm, lenPth);
		} else {
			pth = outputPath;
		}
		if (NOT directoryExists(pth)) {
			fil = createObject("java", "java.io.File");
			fil.init(pth);
			fil.mkdirs();
		}
		if (listLen(nm,".") gt 1)
		{
			ext = listlast(nm,".");
		}
		if ( checkExtension(ext) )
		{
			if ( arguments.overwrite or not fileExists(outputPath & nm) )
			{
				filOutStream = createObject(
					"java", 
					"java.io.FileOutputStream");
				
				filOutStream.init(outputPath & nm);
				
				bufOutStream = createObject(
					"java", 
					"java.io.BufferedOutputStream");
				
				bufOutStream.init(filOutStream);
				
				inStream = zipFile.getInputStream(entry);
				buffer = repeatString(" ",1024).getBytes(); 
				
				l = inStream.read(buffer);
				while(l GTE 0) {
					bufOutStream.write(buffer, 0, l);
					l = inStream.read(buffer);
				}
				inStream.close();
				bufOutStream.close();
			}
		}
		}
	}
	zipFile.close();
</cfscript>

	<cfreturn retVal>
</cffunction>

<cffunction access="public" name="viewZipFile" output="no" returntype="query" hint="View the contents of a specified zip file.">
	<cfargument name="zipFilePath" type="string" required="yes">

	<cfset var zipFile = "">
	<cfset var entries = "">
	<cfset var fil = "">
	<cfset var entry = "">
	<cfset var retVal = QueryNew("NAME,TYPE,SIZE")>

	<cfset zipFile = createObject("java", "java.util.zip.ZipFile")>
	<cfset zipFile.init(zipFilePath)>
	
	<cfset entries = zipFile.entries()>
	
	<cfloop condition="#entries.hasMoreElements()#">
		<cfset entry = entries.nextElement()>
		<cfset queryAddRow(retVal,1)>
		<cfset querySetCell(retVal,"NAME",entry.getName())>
		<cfif entry.isDirectory()>
			<cfset querySetCell(retVal,"SIZE",0)>
			<cfset querySetCell(retVal,"TYPE","dir")>
		<cfelse>
			<cfset querySetCell(retVal,"SIZE",entry.getSize())>
			<cfset querySetCell(retVal,"TYPE","file")>
		</cfif>
	</cfloop>
	<cfset zipFile.close()>
	<cfreturn retVal>
</cffunction>

<cffunction access="public" name="getDirectoryMetadata" output="no" returnType="struct" hint="Gets meta data for a directory listing - number of files and number of directories.">
	<cfargument name="dirlist" type="query" required="yes">
	
	<cfset var metadata = structNew()>
	
	<cfset metadata.fileCount = 0>
	<cfset metadata.directoryCount = 0>
	<cfset metadata.totalSize = 0>
	<cfloop query="dirlist">
	<cfif dirlist.type eq "dir">
		<cfset metadata.directoryCount = metadata.directoryCount + 1>
	<cfelse>
		<cfset metadata.fileCount = metadata.fileCount + 1>
		<cfset metadata.totalSize = metadata.totalSize + dirlist.size>
	</cfif>
	</cfloop>
	<cfreturn metadata>
</cffunction>

<!---
 Mimics the cfdirectory, action=&quot;list&quot; command.
 Updated with final CFMX var code.
 Fixed a bug where the filter wouldn't show dirs.
 
 @param directory 	 The directory to list. (Required)
 @param filter 	 Optional filter to apply. (Optional)
 @param sort 	 Sort to apply. (Optional)
 @param recurse 	 Recursive directory list. Defaults to false. (Optional)
 @return Returns a query. 
 @author Raymond Camden (ray@camdenfamily.com) 
 @version 2, April 8, 2004 
--->

<cffunction access="public" name="DirectoryListCFFM" output="true" returnType="query" HINT="List the contents of a directory, optionally recursing into subdirectories.  This was implemented due to inconsistencies between Coldfusion and Bluedragon.">
	<cfargument name="directory" type="string" required="true">
	<cfargument name="recurse" type="boolean" required="false" default="false">
	<!--- temp vars --->
	<!--- example:  list = DirectoryList(dir,"","","true"); --->
	
	<cfargument name="dirInfo" type="query" required="false">
	<cfargument name="thisDir" type="query" required="false">
	<cfset var path="">
	<cfset var temp="">

	<cfif not recurse>
		<cfdirectory name="temp" directory="#directory#">
		<cfreturn temp>
	<cfelse>
		<!--- We loop through until done recursing drive --->
		<cfif not isDefined("dirInfo")>
			<cfset dirInfo = queryNew("attributes,datelastmodified,mode,name,size,type,directory,fullPath")>
		</cfif>
		<cfset thisDir = DirectoryListCFFM(directory,false)>
		<cfif server.os.name contains "Windows">
			<cfset path = "\">
		<cfelse>
			<cfset path = "/">
		</cfif>
		<cfloop query="thisDir">
			<cfset queryAddRow(dirInfo)>
			<cfset querySetCell(dirInfo,"attributes",attributes)>
			<cfset querySetCell(dirInfo,"datelastmodified",datelastmodified)>
		<!--- 	<cfset querySetCell(dirInfo,"mode",mode)> --->
			<cfset querySetCell(dirInfo,"name",name)>
			<cfset querySetCell(dirInfo,"size",size)>
			<cfset querySetCell(dirInfo,"type",type)>
			<cfset querySetCell(dirInfo,"directory",directory)>
			<Cfset querySetCell(dirInfo,"fullPath",directory & path & name)>
			<cfif type is "dir">
				<!--- go deep! --->
				<cfset DirectoryListCFFM(directory & path & name,true,dirInfo)>
			</cfif>
		</cfloop>
		<cfreturn dirInfo>
	</cfif>
</cffunction>

<cffunction access="public" name="renameFile" output="No" returntype="struct" hint="Rename or move a file OR directory, optionally overwriting existing files/directories.">
	<cfargument name="oldFile" required="yes" type="string">
	<cfargument name="newFile" required="yes" type="string">
	<cfargument name="action" required="no" default="rename">
	<cfargument name="overWrite" required="no" default="false">

	<!--- this can also be used to move files --->
	<cfset var retVal = StructNew()>
	<cfset var extension = "">
	<cfset var filetype = "">
	<cfif ListLen(arguments.newFile,".") gt 1>
		<cfset extension = ListLast(arguments.newFile,".")>
	</cfif>
	<cfif NOT checkExtension(extension)>
		<cfset retval.errorCode = 1>
		<cfset retVal.errorMessage = "#this.resourceKit.errorMsg.t15#: #extension#">
		<cfreturn retVal>
	</cfif>
	<cfscript>
		fileType = getPathType(arguments.oldFile);
		if (fileType eq "") {
			retVal.errorCode = 1;
			retVal.errorMessage = "#this.resourceKit.errorMsg.t12#: #arguments.oldFile#";
			return retVal;
		}
		if ((arguments.action eq "rename" or arguments.action eq "move") and getPathType(arguments.newFile) eq "directory")
		{
			retVal.errorCode = 1;
			if (arguments.action eq "rename") {
				retVal.errorMessage = this.resourceKit.errorMsg.t17;
			} else if (action eq "move") {
				retVal.errorMessage = this.resourceKit.errorMsg.t16;
			}
			return retVal;
		}
	</cfscript>
	<cftry>
		<cfif fileType eq "directory" AND arguments.action eq "rename">
			<cfdirectory action="RENAME" directory="#arguments.oldFile#" newdirectory="#arguments.newFile#">
			<cfset retVal.errorCode = 0>
			<cfset retVal.errorMessage = "">
		<cfelseif fileType eq "directory" AND arguments.action eq "move">
			<!--- coldfusion can actually rename a directory into a new location, but bluedragon 6.1 could not,
			      so I chose to use the moveDirectory() function instead --->
			<cfset moveDirectory(arguments.oldFile, arguments.newFile, arguments.overWrite)>
			<cfset retVal.errorCode = 0>
			<cfset retVal.errorMessage = "">
		<cfelseif fileType eq "directory">
			<cfset copyDirectory(arguments.oldFile, arguments.newFile, "True", "True", arguments.overWrite)>
			<cfset retVal.errorCode = 0>
			<cfset retVal.errorMessage = "">
		<cfelseif fileType eq "file" AND (arguments.action eq "move" or arguments.action eq "rename")>
			<cfif arguments.overWrite or not fileExists(arguments.newfile)>
				<cffile action="RENAME" source="#arguments.oldFile#" destination="#arguments.newFile#">
			</cfif>
			<cfset retVal.errorCode = 0>
			<cfset retVal.errorMessage = "">
		<cfelse>
			<!--- it's a file, and we're just copying it --->
			<cfif arguments.overWrite or not fileExists(arguments.newfile)>
				<cffile action="COPY" source="#arguments.oldFile#" destination="#arguments.newFile#">
			</cfif>
			<cfset retVal.errorCode = 0>
			<cfset retVal.errorMessage = "">
		</cfif>
		<cfcatch type="any">
			<cfset retVal.errorCode = 1>
			<cfset retVal.errorMessage = "[ACTION=#arguments.action#] #this.resourceKit.errorMsg.t18#:  #cfcatch.message# - #cfcatch.detail#">
		</cfcatch>
	</cftry>
	<cfreturn retVal>
</cffunction>

<cffunction access="public" name="saveFile" output="No" returntype="struct" hint="Save a text file.">
	<cfargument name="filename" required="yes" type="string">
	<cfargument name="fileContent" required="yes" type="string">
	<cfset var retVal = StructNew()>
	<!--- just in case the content contained a textarea tag --->
	<cfset arguments.filecontent = replaceNoCase(arguments.filecontent,"&lt;/textarea","</textarea","ALL")>
	<cfset arguments.filecontent = replaceNoCase(arguments.filecontent,"&lt;textarea","<textarea","ALL")>
	
	<cftry>
		<cffile action="WRITE" file="#arguments.filename#" output="#arguments.fileContent#" addnewline="No">
		<cfset retVal.errorCode = 0>
		<cfset retVal.errorMessage = "">
		<cfcatch type="any">
			<cfset retVal.errorCode = 1>
			<cfset retVal.errorMessage = "#this.resourceKit.errorMsg.t19#:  #cfcatch.message# - #cfcatch.detail#">
		</cfcatch>
	</cftry>
	<cfreturn retVal>
</cffunction>

<cffunction access="public" name="readFile" output="No" returntype="struct" hint="Read the contents of a file.">
	<cfargument name="filename" required="yes" type="string">
	<cfset var retVal = StructNew()>
	
	<cftry>
		<cffile action="READ" file="#arguments.filename#" variable="retVal.filecontent">
		<!--- we're gonna put it in a textarea so make sure we convert any textarea tags --->
		<cfset retval.filecontent = replaceNoCase(retval.filecontent,"</textarea","&lt;/textarea","ALL")>
		<cfset retval.filecontent = replaceNoCase(retval.filecontent,"<textarea","&lt;textarea","ALL")>
		<cfset retVal.errorCode = 0>
		<cfset retVal.errorMessage = "">
		<cfcatch type="any">
			<cfset retVal.errorCode = 1>
			<cfset retVal.errorMessage = "#this.resourceKit.errorMsg.t20#:  #cfcatch.message# - #cfcatch.detail#">
		</cfcatch>
	</cftry>
	<cfreturn retVal>
</cffunction>

<cffunction access="public" name="createFile" output="No" returntype="struct" hint="Create a blank file or directory.">
	<cfargument name="filename" required="yes" type="string">
	<cfargument name="filetype" required="yes" type="string">
	<cfset var retVal = StructNew()>
	
	<cfset var extension = "">
	<cfif ListLen(arguments.filename,".") gt 1>
		<cfset extension = ListLast(arguments.filename,".")>
	</cfif>
	<cfif not checkExtension(extension)>
		<cfset retval.errorCode = 1>
		<cfset retVal.errorMessage = "#this.resourceKit.errorMsg.t15#: #extension#">
		<cfreturn retVal>
	</cfif>
	<cftry>
		<cfif arguments.fileType eq "file">
			<cffile action="WRITE" file="#arguments.filename#" output="" addnewline="Yes">
		<cfelse>
			<cfdirectory action="CREATE" directory="#arguments.filename#">
		</cfif>
		<cfset retVal.errorCode = 0>
		<cfset retVal.errorMessage = "">
		<cfcatch type="any">
			<cfset retVal.errorCode = 1>
			<cfset retVal.errorMessage = "#this.resourceKit.errorMsg.t21#:  #cfcatch.message# - #cfcatch.detail#">
		</cfcatch>
	</cftry>
	<cfreturn retVal>
</cffunction>

<cffunction access="public" name="checkSubdirValue" output="yes" returntype="string" hint="Make sure the subdir parameter, which determines hte current working directory, is valid and within the acceptable directory structure.">
	<cfargument name="checkValue" required="yes" type="string">
	<cfargument name="defaultValue" required="no" type="string" default="#this.includeDirWeb#">
	<cfset checkvalue = trim(checkvalue)>
	<cfif 
		ReFind("^\.+[\\\/]",checkValue) gt 0 OR
		ReFind("[\\\/]\.+$",checkValue) gt 0 OR
		ReFind("[\\\/]\.+[\\\/]",checkValue) gt 0 OR
		ReFind("^\.+$",checkValue) gt 0>
		<cfreturn arguments.defaultValue>
	<cfelse>
		<cfreturn arguments.checkValue>	
	</cfif>
</cffunction>

<cffunction access="public" name="createServerPath" output="no" returntype="string" hint="Giving a specified subdir value and a filename, generate a physical server path to the file.">
	<cfargument name="subdir" required="yes" type="string">
	<cfargument name="filename" required="no" type="string" default="">
	<cfscript>
		var tmp = "";
        tmp = this.includeDir;
        if (arguments.subdir neq "")
        {
                tmp = tmp & getDirectorySeparator() & REReplace(arguments.subdir,"[\\\/]",getDirectorySeparator(),"ALL");
        }
		if (arguments.filename neq "")
		{
			tmp = tmp & getDirectorySeparator() & arguments.filename;
		}
		return replace(tmp,getDirectorySeparator()&getDirectorySeparator(),getDirectorySeparator(),"ALL");
	</cfscript>
</cffunction>

<cffunction access="public" name="createWebPath" output="no" returntype="string" hint="Giving a specified subdir value and a filename, generate a URL link to the file.">
	<cfargument name="subdir" required="yes" type="string">
	<cfargument name="filename" required="no" type="string" default="">
	<cfscript>
		var tmp = "";
        tmp = this.includeDirWeb;
        if (arguments.subdir neq "")
        {
                tmp = tmp & "/" & arguments.subdir;
        }
		if (arguments.filename neq "")
		{
                tmp = tmp & "/" & arguments.filename;
		}
		return tmp;
	</cfscript>
</cffunction>

<cffunction access="public" name="checkExtension" output="no" returnType="boolean" hint="Checks an extension against the configured list of allowed and disallowed extensions.">
	<cfargument name="ext" type="string" required="yes">

	<cfset arguments.ext = lcase(arguments.ext)>

	<cfif this.allowedExtensions neq "" AND ListFindNoCase(this.allowedExtensions,arguments.ext)>
		<cfreturn true>
	<cfelseif this.allowedExtensions eq "" AND NOT ListFindNoCase(this.disallowedExtensions,arguments.ext)>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="getDirectorySeparator" access="public" output="no" returntype="string">
	<cfif FindNoCase("windows",server.os.name)>
		<cfreturn "\">
	<cfelse>
		<cfreturn "/">
	</cfif>
</cffunction>

<!---- PRIVATE, INTERNAL METHODS --->

<cffunction access="private" name="copyDirectory" returntype="boolean" hint="Copy a directory, optionally recursing into subdirectories and optionally overwriting existing files.">
	<cfargument name="Source" type="string" required="yes">
	<cfargument name="Destination" type="string" required="yes">
	<cfargument name="Recurse" type="boolean" required="no" default="False">
	<cfargument name="OverWrite" type="boolean" required="no" default="True">
	<cfargument name="calledItself" type="boolean" required="no" default="False">

	<cfset var myDirectory = "">
	<cfset var DoCopy = "True">

	<cfif right(Arguments.Source, 1) is not "/">
		<cfset Arguments.Source = Arguments.Source & "/">
	</cfif>
	
	<cfif right(Arguments.Destination, 1) is not "/">
		<cfset Arguments.Destination = Arguments.Destination & "/">
	</cfif>
	<cfdirectory action="LIST" directory="#Arguments.Source#"
	name="myDirectory" >
	
	<cfif not arguments.calledItself>
		<cfif not directoryExists(arguments.destination & getFileFromPath(arguments.source))>
			<cfdirectory action="create" directory="#arguments.destination##getFileFromPath(arguments.source)#">
		</cfif>
		<cfset arguments.destination = arguments.destination & getFileFromPath(arguments.source) & "/">
	<cfelse>
		<cfif not directoryExists(arguments.destination)>
			<cfdirectory action="create" directory="#arguments.destination#">
		</cfif>
	</cfif>

	<cfloop query="myDirectory">
		<cfif myDirectory.name is not "." AND myDirectory.name is not "..">
			<cfswitch expression="#myDirectory.Type#">
			
				<cfcase value="dir">
					<!--- If recurse is on, move down to next level and copy that folder --->
					<cfif Arguments.Recurse>
						<cfset copyDirectory(
							Arguments.Source & myDirectory.Name,
							Arguments.Destination & myDirectory.Name,
							Arguments.Recurse,
							Arguments.OverWrite,
							"True" )>
					</cfif>
				</cfcase>
				
				<cfcase value="file">
					<!--- Copy file --->
					<cfset DoCopy = True>
	
					<cfif NOT Arguments.OverWrite AND fileExists("#Arguments.Destination##myDirectory.Name#")>
						<cfset DoCopy = False>
					</cfif>
					<cfif DoCopy>
						<cffile action="COPY" source="#Arguments.Source##myDirectory.Name#" destination="#Arguments.Destination##myDirectory.Name#">
					</cfif>
				</cfcase>			
			</cfswitch>
		</cfif>
	</cfloop>
	<cfreturn true>
</cffunction>

<cffunction access="private" name="moveDirectory" returntype="boolean" hint="Move a directory to a new location, and optionally overwrite existing files.">
	<cfargument name="Source" type="string" required="yes">
	<cfargument name="Destination" type="string" required="yes">
	<cfargument name="OverWrite" type="boolean" required="no" default="True">

	<!--- this whole function wouldn't be necessary if bluedragon 6.1 supported renaming a directory and changing the path like Coldfusion does!  --->
	<cfset copyDirectory(
		Arguments.Source,
		Arguments.Destination,
		"TRUE",
		Arguments.OverWrite,
		"False" )>

	<cfset deleteDirectory(	Arguments.source, "TRUE" )>
	<cfreturn true>
		
</cffunction>

</cfcomponent>