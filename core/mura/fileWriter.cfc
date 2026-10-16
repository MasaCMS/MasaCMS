<!---

This file is part of Masa CMS. Masa CMS is based on Mura CMS, and adopts the
same licensing model. It is, therefore, licensed under the Gnu General Public License
version 2 only, (GPLv2) subject to the same special exception that appears in the licensing
notice set out below. That exception is also granted by the copyright holders of Masa CMS
also applies to this file and Masa CMS in general.

This file has been modified from the original version received from Mura CMS. The
change was made on: 2021-07-27
Although this file is based on Mura™ CMS, Masa CMS is not associated with the copyright
holders or developers of Mura™CMS, and the use of the terms Mura™ and Mura™CMS are retained
only to ensure software compatibility, and compliance with the terms of the GPLv2 and
the exception set out below. That use is not intended to suggest any commercial relationship
or endorsement of Mura™CMS by Masa CMS or its developers, copyright holders or sponsors or visa versa.

If you want an original copy of Mura™ CMS please go to murasoftware.com .  
For more information about the unaffiliated Masa CMS, please go to masacms.com

Masa CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.
Masa CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Masa CMS. If not, see <http://www.gnu.org/licenses/>.

The original complete licensing notice from the Mura CMS version of this file is as
follows:

This file is part of Mura CMS.

  Mura CMS is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, Version 2 of the License.

  Mura CMS is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

  Linking Mura CMS statically or dynamically with other modules constitutes
  the preparation of a derivative work based on Mura CMS. Thus, the terms
  and conditions of the GNU General Public License version 2 ("GPL") cover
  the entire combined work.

  However, as a special exception, the copyright holders of Mura CMS grant
  you permission to combine Mura CMS with programs or libraries that are
  released under the GNU Lesser General Public License version 2.1.

  In addition, as a special exception, the copyright holders of Mura CMS
  grant you permission to combine Mura CMS with independent software modules
  (plugins, themes and bundles), and to distribute these plugins, themes and
  bundles without Mura CMS under the license of your choice, provided that
  you follow these specific guidelines:

  Your custom code

  • Must not alter any default objects in the Mura CMS database and
  • May not alter the default display of the Mura CMS logo within Mura CMS and
  • Must not alter any files in the following directories:

   	/admin/
	/core/
	/Application.cfc
	/index.cfm

  You may copy and distribute Mura CMS with a plug-in, theme or bundle that
  meets the above guidelines as a combined work under the terms of GPL for
  Mura CMS, provided that you include the source code of that other code when
  and as the GNU GPL requires distribution of source code.

  For clarity, if you create a modified version of Mura CMS, you are not
  obligated to grant this special exception for your modified version; it is
  your choice whether to do so, or to make such modified version available
  under the GNU General Public License version 2 without this exception.  You
  may, if you choose, apply this exception to your own modified versions of
  Mura CMS.
--->
<cfcomponent extends="mura.cfobject" output="false" hint="CRUD utility for the host file system. When routeUserAssets=true (default), paths inside a site's User_Assets directory are automatically routed to getBean('fileStorageService'), which is the active storage singleton (localStorageService by default; replaced by a cloud service on module load).">

	<cfset variables.useMode=true>
	<cfset variables.routeUserAssets=true>
	<cfset variables.storageKeys=new mura.fileStorage.storageKey()>

	<cffunction name="init" output="false">
		<cfargument name="useMode" required="true" default="">
		<cfargument name="tempDir" required="true" default="#application.configBean.getTempDir()#">
		<cfargument name="routeUserAssets" required="false" default="true"
			hint="Set false to disable User_Assets routing (used by localStorageService to avoid recursion)">

		<cfif findNoCase(server.os.name,"Windows")>
			<cfset variables.useMode=false>
		<cfelse>
			<cfif isBoolean(arguments.useMode)>
				<cfset variables.useMode=arguments.useMode>
			<cfelse>
				<cfset variables.useMode=application.configBean.getValue("useFileMode")>
			</cfif>
		</cfif>

		<cfset variables.tempDir=arguments.tempDir>
		<cfset variables.routeUserAssets=isBoolean(arguments.routeUserAssets) && arguments.routeUserAssets>

		<cfif isNumeric(application.configBean.getValue("defaultFileMode"))>
			<cfset variables.defaultFileMode=application.configBean.getValue("defaultFileMode")>
		<cfelse>
			<cfset variables.defaultFileMode=775>
		</cfif>

		<cfreturn this />
	</cffunction>

	<!---
		userAssetKey: the storage key for a path inside a site's User_Assets directory when
		User_Assets routing is on (e.g. "default/assets/photo.jpg"), otherwise empty.
		Each wrapper below routes to the storage service when this returns a key.
	--->
	<cffunction name="userAssetKey" access="private" output="false" returntype="string">
		<cfargument name="path" type="string" required="true">
		<cfif not variables.routeUserAssets>
			<cfreturn "">
		</cfif>
		<cfreturn variables.storageKeys.fromAssetPath(arguments.path)>
	</cffunction>

	<cffunction name="copyFile" output="false">
		<cfargument name="source">
		<cfargument name="destination">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfset var resolvedSource = "">
		<cfset var storageService = getBean('fileStorageService')>
		<cfscript>
			var srcKey = userAssetKey(arguments.source);
			var dstKey = userAssetKey(arguments.destination);
			// The storage service only takes User_Assets keys, so a copy across the
			// User_Assets boundary goes through a local file on the non-asset side.
			if (len(srcKey) && len(dstKey)) {
				storageService.copyFile(srcKey, dstKey);
				return this;
			} else if (len(dstKey)) {
				// writeFromLocal() consumes its file, so hand it a temp copy.
				var tempCopy = variables.tempDir & createUUID() & "." & listLast(arguments.source, ".");
				fileCopy(arguments.source, tempCopy);
				storageService.writeFromLocal(tempCopy, dstKey);
				return this;
			} else if (len(srcKey)) {
				resolvedSource = storageService.resolveToLocal(srcKey);
				arguments.source = resolvedSource;
			}
		</cfscript>
		<cftry>
			<cflock name="mfw#hash(arguments.source)#" type="exclusive" timeout="5">
				<cftry>
					<cfif variables.useMode >
						<cffile action="copy" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
					<cfelse>
						<cffile action="copy" source="#arguments.source#" destination="#arguments.destination#" />
					</cfif>
					<cfcatch>
						<cfset sleep(RandRange(500, 1000))>
						<cfif fileExists(arguments.destination)>
							<cfset fileDelete(arguments.destination)>
						</cfif>
						<cfif variables.useMode >
							<cffile action="copy" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
						<cfelse>
							<cffile action="copy" source="#arguments.source#" destination="#arguments.destination#" />
						</cfif>
					</cfcatch>
				</cftry>
			</cflock>
			
			<cffinally>
				<cfif len(resolvedSource)>
					<cfset storageService.releaseLocal(resolvedSource)>
				</cfif>
			</cffinally>
		</cftry>
		<cfreturn this />
	</cffunction>

	<cffunction name="moveFile" output="false">
		<cfargument name="source">
		<cfargument name="destination">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfset var movedAssetKey = "">
		<cfset var storageService = getBean('fileStorageService')>
		<cfscript>
			var srcKey = userAssetKey(arguments.source);
			var dstKey = userAssetKey(arguments.destination);
			// The storage service only takes User_Assets keys, so a move across the
			// User_Assets boundary goes through a local file on the non-asset side.
			if (len(srcKey) && len(dstKey)) {
				storageService.moveFile(srcKey, dstKey);
				return this;
			} else if (len(dstKey)) {
				storageService.writeFromLocal(arguments.source, dstKey);
				return this;
			} else if (len(srcKey)) {
				// Move a local copy of the asset below, then remove the asset itself.
				movedAssetKey = srcKey;
				arguments.source = storageService.resolveToLocal(movedAssetKey);
			}
		</cfscript>
		<cflock name="mfw#hash(arguments.source)#" type="exclusive" timeout="5">
			<cfif variables.useMode >
				<cffile action="copy" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
				<cftry><cffile action="delete" file="#arguments.source#" /><cfcatch></cfcatch></cftry>
			<cfelse>
				<cffile action="copy" source="#arguments.source#" destination="#arguments.destination#" />
				<cftry><cffile action="delete" file="#arguments.source#" /><cfcatch></cfcatch></cftry>
			</cfif>
		</cflock>
		<cfif len(movedAssetKey)>
			<cfset storageService.deleteFile(movedAssetKey)>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="renameFile" output="false">
		<cfargument name="source">
		<cfargument name="destination">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfscript>
			var srcKey = userAssetKey(arguments.source);
			if (len(srcKey)) {
				var dstKey = userAssetKey(arguments.destination);
				getBean('fileStorageService').renameFile(srcKey, len(dstKey) ? dstKey : arguments.destination);
				return this;
			}
		</cfscript>
		<cflock name="mfw#hash(arguments.source)#" type="exclusive" timeout= "5">
			<cfif variables.useMode >
				<cffile action="rename" mode="#arguments.mode#" source="#arguments.source#" destination="#arguments.destination#" />
			<cfelse>
				<cffile action="rename" source="#arguments.source#" destination="#arguments.destination#" />
			</cfif>
		</cflock>
		<cfreturn this />
	</cffunction>

	<cffunction name="writeFile" output="true">
		<cfargument name="file">
		<cfargument name="output">
		<cfargument name="addNewLine" required="true" default="true">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfargument name="charset">
		<cfset var new = "">
		<cfset var x = "">
		<cfset var counter = 0>
		<cfscript>
			var assetKey = userAssetKey(arguments.file);
			if (len(assetKey)) {
				// The storage service writes content exactly as given, so apply
				// addNewLine here, as cffile action="write" would below.
				var content = arguments.output;
				if (arguments.addNewLine && isSimpleValue(content)) {
					content &= findNoCase("Windows", server.os.name) ? chr(13) & chr(10) : chr(10);
				}
				getBean('fileStorageService').writeFile(assetKey, content);
				return this;
			}
		</cfscript>

		<cfif isDefined('arguments.output.mode')>
				<cfset new = FileOpen(arguments.file, "write")>

				<cfloop condition="!fileIsEOF( arguments.output )">
					<cfset x = FileRead(arguments.output, 10000)>
					<cfif isDefined('arguments.charset')>
						<cfset FileWrite(new, x, arguments.charset)>
					<cfelse>
						<cfset FileWrite(new, x)>
					</cfif>
					<cfset counter = counter + 1>
				</cfloop>

				<cfset FileClose(arguments.output)>
				<cfset FileClose(new)>

				<cfif fileExists(arguments.output.path)>
					<cfset FileDelete(arguments.output.path)>
				<cfelseif fileExists(arguments.output.path & "/" & arguments.output.name)>
					<cfset FileDelete(arguments.output.path & "/" & arguments.output.name)>
				</cfif>
		<cfelse>
			<cfif variables.useMode >
				<cffile action="write" mode="#arguments.mode#" file="#arguments.file#" output="#arguments.output#" addnewline="#arguments.addNewLine#"/>
			<cfelse>
				<cffile action="write" file="#arguments.file#" output="#arguments.output#" addnewline="#arguments.addNewLine#"/>
			</cfif>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="uploadFile" output="false">
		<cfargument name="filefield">
		<cfargument name="destination" required="true" default="#variables.tempDir#">
		<cfargument name="nameConflict" required="true" default="makeunique">
		<cfargument name="attributes" required="true" default="normal">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfargument name="accept" required="false" default="" />
		<cfscript>
			var assetKey = userAssetKey(arguments.destination);
			if (len(assetKey)) {
				return getBean('fileStorageService').uploadFile(assetKey, arguments.filefield);
			}
		</cfscript>

		<cfset touchDir(arguments.destination,arguments.mode) />

		<cfif variables.useMode >
			<cffile action="upload"
							fileField="#arguments.fileField#"
							destination="#arguments.destination#"
							nameConflict="#arguments.nameConflict#"
							mode="#arguments.mode#"
							attributes="#arguments.attributes#"
							result="upload"
							accept="#arguments.accept#">
		<cfelse>
			<cffile action="upload"
							fileField="#arguments.fileField#"
							destination="#arguments.destination#"
							nameConflict="#arguments.nameConflict#"
							attributes="#arguments.attributes#"
							result="upload"
							accept="#arguments.accept#">
		</cfif>
		<cfreturn upload>
	</cffunction>

	<cffunction name="appendFile" output="false">
		<cfargument name="file">
		<cfargument name="output">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cflock name="mfw#hash(arguments.file)#" type="exclusive" timeout="5">
			<cfif variables.useMode >
				<cffile action="append" mode="#arguments.mode#" file="#arguments.file#" output="#arguments.output#"/>
			<cfelse>
				<cffile action="append" file="#arguments.file#" output="#arguments.output#" />
			</cfif>
		</cflock>
		<cfreturn this />
	</cffunction>

	<cffunction name="createDir" output="false">
		<cfargument name="directory">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfscript>
			var assetKey = userAssetKey(arguments.directory);
			if (len(assetKey)) {
				var storageService = getBean('fileStorageService');
				// The storage contract makes createDirectory() a no-op for an existing
				// directory; createDir() has always thrown then, like cfdirectory does below.
				if (storageService.directoryExists(assetKey)) {
					throw(type="application", message="The specified directory [#arguments.directory#] could not be created.", detail="The directory already exists.");
				}
				storageService.createDirectory(assetKey);
				return this;
			}
		</cfscript>
		<cfif variables.useMode >
			<cfdirectory action="create" mode="#arguments.mode#" directory="#arguments.directory#"/>
		<cfelse>
			<cfdirectory action="create" directory="#arguments.directory#"/>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="touchDir" output="false">
		<cfargument name="directory">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfif Not DirectoryExists(arguments.directory)>
			<cfset createDir(arguments.directory,arguments.mode) />
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="renameDir" output="false">
		<cfargument name="directory">
		<cfargument name="newDirectory">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">
		<cfscript>
			var srcKey = userAssetKey(arguments.directory);
			if (len(srcKey)) {
				var dstKey = userAssetKey(arguments.newDirectory);
				getBean('fileStorageService').renameFile(srcKey, len(dstKey) ? dstKey : arguments.newDirectory);
				return this;
			}
		</cfscript>
		<cfif variables.useMode >
			<cfdirectory action="rename" mode="#arguments.mode#" directory="#arguments.directory#" newDirectory="#arguments.newDirectory#"/>
		<cfelse>
			<cfdirectory action="rename" directory="#arguments.directory#" newDirectory="#arguments.newDirectory#"/>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cffunction name="deleteDir" output="false">
		<cfargument name="directory">
		<cfargument name="recurse" required="true" default="true">
		<cfscript>
			var assetKey = userAssetKey(arguments.directory);
			if (len(assetKey)) {
				getBean('fileStorageService').deleteDirectory(assetKey, arguments.recurse);
				return this;
			}
		</cfscript>
		<cfdirectory action="delete" directory="#arguments.directory#" recurse="#arguments.recurse#"/>
		<cfreturn this />
	</cffunction>

	<cffunction name="copyDir" output="false">
		<cfargument name="baseDir" default="" required="true" />
		<cfargument name="destDir" default="" required="true" />
		<cfargument name="excludeList" default="" required="true" />
		<cfargument name="sinceDate" default="" required="true" />
		<cfargument name="excludeHiddenFiles" default="true" required="true" />
		<cfset var rsAll = "">
		<cfset var rs = "">
		<cfset var i="">
		<cfset var errors=arrayNew(1)>
		<cfset var copyItem="">

		<cfset arguments.baseDir=pathFormat(conditionalExpandPath(arguments.baseDir))>
		<cfset arguments.destDir=pathFormat(conditionalExpandPath(arguments.destDir))>
		<cfset arguments.excludeList=pathFormat(arguments.excludeList)>

		<cfif arguments.baseDir neq arguments.destDir>
			<cfdirectory directory="#arguments.baseDir#" name="rsAll" action="list" recurse="true" />

			<cfset rsAll=fixQueryPaths(rsAll)>

			<cfquery name="rsAll" dbtype="query">
				SELECT * FROM rsAll
				WHERE
				1=1
				<cfif arguments.excludeHiddenFiles>
					and directory NOT LIKE '%/.svn%'
					and directory NOT LIKE '%/.git%'
					and name not like '.%'
				</cfif>
				<cfif len(arguments.excludeList)>
					<cfloop list="#arguments.excludeList#" index="i">
						and directory NOT LIKE '%#i#%'
					</cfloop>
				</cfif>

				<cfif isDate(arguments.sinceDate)>
					and dateLastModified >= #createODBCDateTime(arguments.sinceDate)#
				</cfif>
			</cfquery>

			<cfset copyItem=arguments.destDir>
			<cftry>
				<cfset createDir(directory=copyItem)>
				<cfcatch><!---<cfset arrayAppend(errors,copyItem)>---></cfcatch>
			</cftry>

			<cfquery name="rs" dbtype="query">
				select * from rsAll where lower(type) = 'dir'
			</cfquery>

			<cfloop query="rs">
				<cfset copyItem="#replace('#rs.directory#/',arguments.baseDir,arguments.destDir)##rs.name#/">
				<cfif not DirectoryExists(copyItem)>
				<cftry>
					<cfset createDir(directory=copyItem)>
					<cfcatch><!---<cfset arrayAppend(errors,copyItem)>---></cfcatch>
				</cftry>
				</cfif>
			</cfloop>

			<cfquery name="rs" dbtype="query">
				select * from rsAll where lower(type) = 'file'
			</cfquery>

			<cfloop query="rs">
				<cfset copyItem="#replace('#rs.directory#/',arguments.baseDir,arguments.destDir)#">
				<cfif fileExists("#copyItem#/#rs.name#")>
					<cffile action="delete" file="#copyItem#/#rs.name#">
				</cfif>

				<cftry>
					<cfset copyFile(source="#rs.directory#/#rs.name#", destination=copyItem, sinceDate=arguments.sinceDate)>
					<cfcatch><cfset arrayAppend(errors,"#copyItem#/#rs.name#")></cfcatch>
				</cftry>
			</cfloop>
		</cfif>

		<cfreturn errors>
	</cffunction>

	<cffunction name="getFreeSpace" output="false">
		<cfargument name="file">
		<cfargument name="unit" default="gb">
		<cfset var space=createObject("java", "java.io.File").init(arguments.file).getFreeSpace()>

		<cfif arguments.unit eq "bytes">
			<cfreturn space>
		<cfelseif arguments.unit eq "kb">
			<cfreturn space /1024 >
		<cfelseif arguments.unit eq "mb">
			<cfreturn space /1024 / 1024>
		<cfelse>
			<cfreturn space /1024 / 1024 / 1024>
		</cfif>
	</cffunction>

	<cffunction name="getTotalSpace" output="false">
		<cfargument name="file">
		<cfargument name="unit" default="gb">
		<cfset var space=createObject("java", "java.io.File").init(arguments.file).getTotalSpace()>

		<cfif arguments.unit eq "byte">
			<cfreturn space>
		<cfelseif arguments.unit eq "kb">
			<cfreturn space /1024 >
		<cfelseif arguments.unit eq "mb">
			<cfreturn space /1024 / 1024>
		<cfelse>
			<cfreturn space /1024 / 1024 / 1024>
		</cfif>
	</cffunction>

	<cffunction name="getUsableSpace" output="false">
		<cfargument name="file">
		<cfargument name="unit" default="gb">
		<cfset var space=createObject("java", "java.io.File").init(arguments.file).getUsableSpace()>

		<cfif arguments.unit eq "byte">
			<cfreturn space>
		<cfelseif arguments.unit eq "kb">
			<cfreturn space /1024 >
		<cfelseif arguments.unit eq "mb">
			<cfreturn space /1024 / 1024>
		<cfelse>
			<cfreturn space /1024 / 1024 / 1024>
		</cfif>
	</cffunction>

	<cffunction name="chmod" output="false">
		<cfargument name="path">
		<cfargument name="mode" required="true" default="#variables.defaultFileMode#">

		<cfif variables.useMode>
			<cftry>
				<cfif directoryExists(arguments.path)>
					<cfset createObject("java","java.lang.Runtime").getRuntime().exec("chmod -R #arguments.mode# #arguments.path#")>
				<cfelse>
					<cfset createObject("java","java.lang.Runtime").getRuntime().exec("chmod #arguments.mode# #arguments.path#")>
				</cfif>
				<cfcatch></cfcatch>
			</cftry>
		</cfif>
	</cffunction>

	<cffunction name="PathFormat" output="no" hint="Convert path into Windows or Unix format.">
		<cfargument name="path" required="yes" type="string" hint="The path to convert.">
		<cfset arguments.path = Replace(arguments.path, "\", "/", "ALL")>
		<cfreturn arguments.path>
	</cffunction>

	<cffunction name="fixQueryPaths" output="false">
		<cfargument name="rsDir">
		<cfargument name="path" default="directory">
		<cfloop query="rsDir">
			<cfset querySetCell(rsDir,arguments.path,pathFormat(rsDir[arguments.path][rsDir.currentrow]),rsDir.currentrow)>
		</cfloop>
		<cfreturn rsDir>
	</cffunction>

	<cffunction name="getDirectoryList" output="false">
		<cfargument name="directory">
		<cfargument name="filter" default="*">
		<cfargument name="type" default="all">
		<cfscript>
			var assetKey = userAssetKey(arguments.directory);
			if (len(assetKey)) {
				return getBean('fileStorageService').listDirectory(assetKey, arguments.filter, arguments.type);
			}
		</cfscript>
		<cfset var rs="">
		<cfdirectory directory="#arguments.directory#" filter="#arguments.filter#" type="#arguments.type#" name="rs" action="list">
		<cfreturn rs>
	</cffunction>

	<cfscript>
		function conditionalExpandPath(path){
			if(find(":",arguments.path)){
				return path;
			} else {
				if(directoryExists(path)){
					return path;
				} else{
					var expandedPath=expandPath(arguments.path);
					if(directoryExists(expandedPath)){
						return expandedPath;
					} else {
						return arguments.path;
					}
				}
			}
		}
	</cfscript>

	<!--- ==================== User_Assets-aware wrappers ==================== --->

	<cffunction name="deleteFile" output="false" returntype="void">
		<cfargument name="file" type="string" required="true">
		<cfscript>
			var assetKey = userAssetKey(arguments.file);
			if (len(assetKey)) {
				getBean('fileStorageService').deleteFile(assetKey);
				return;
			}
			if (fileExists(arguments.file)) {
				fileDelete(arguments.file);
			}
		</cfscript>
	</cffunction>

	<cffunction name="readFile" output="false" returntype="string">
		<cfargument name="file" type="string" required="true">
		<cfscript>
			var assetKey = userAssetKey(arguments.file);
			if (len(assetKey)) {
				return getBean('fileStorageService').readFile(assetKey);
			}
			return fileRead(arguments.file);
		</cfscript>
	</cffunction>

	<cffunction name="readFileBinary" output="false" returntype="any">
		<cfargument name="file" type="string" required="true">
		<cfscript>
			var assetKey = userAssetKey(arguments.file);
			if (len(assetKey)) {
				return getBean('fileStorageService').readFileBinary(assetKey);
			}
			return fileReadBinary(arguments.file);
		</cfscript>
	</cffunction>

	<cffunction name="checkFileExists" output="false" returntype="boolean"
		hint="Named checkFileExists to avoid shadowing the built-in fileExists().">
		<cfargument name="file" type="string" required="true">
		<cfscript>
			var assetKey = userAssetKey(arguments.file);
			if (len(assetKey)) {
				return getBean('fileStorageService').fileExists(assetKey);
			}
			return fileExists(arguments.file);
		</cfscript>
	</cffunction>

	<cffunction name="checkDirectoryExists" output="false" returntype="boolean"
		hint="Named checkDirectoryExists to avoid shadowing the built-in directoryExists().">
		<cfargument name="directory" type="string" required="true">
		<cfscript>
			var assetKey = userAssetKey(arguments.directory);
			if (len(assetKey)) {
				return getBean('fileStorageService').directoryExists(assetKey);
			}
			return directoryExists(arguments.directory);
		</cfscript>
	</cffunction>

	<cffunction name="resolveToLocal" output="false" returntype="string"
		hint="Resolve a User_Assets path to an absolute local filesystem path. For cloud storage, downloads to temp. Pass the result to releaseLocal() when done.">
		<cfargument name="file" type="string" required="true">
		<cfscript>
			var assetKey = userAssetKey(arguments.file);
			if (len(assetKey)) {
				return getBean('fileStorageService').resolveToLocal(assetKey);
			}
			return arguments.file;
		</cfscript>
	</cffunction>

	<cffunction name="releaseLocal" output="false" returntype="void"
		hint="Release a path returned by resolveToLocal() once done with it. Safe for any path: the storage service only deletes temp copies it created.">
		<cfargument name="localPath" type="string" required="true">
		<cfif variables.routeUserAssets>
			<cfset getBean('fileStorageService').releaseLocal(arguments.localPath)>
		</cfif>
	</cffunction>

	<cffunction name="writeFromLocal" output="false" returntype="void"
		hint="Write a local file to a User_Assets path. For cloud storage, uploads and removes the local copy.">
		<cfargument name="localPath" type="string" required="true">
		<cfargument name="remotePath" type="string" required="true">
		<cfscript>
			var assetKey = userAssetKey(arguments.remotePath);
			if (len(assetKey)) {
				getBean('fileStorageService').writeFromLocal(arguments.localPath, assetKey);
				return;
			}
			fileMove(arguments.localPath, arguments.remotePath);
		</cfscript>
	</cffunction>

	<cffunction name="getAssetUrl" output="false" returntype="string"
		hint="Returns the public URL of a site's User_Assets. Resolves through the site's File Pool and honors the assetPath / fileAssetPath config, like filebrowser's getBaseResourcePath().">
		<cfargument name="siteid" type="string" required="true">
		<cfargument name="complete" required="false" default="0" hint="Return an absolute URL including the domain">
		<cfscript>
			var site = application.settingsManager.getSite(arguments.siteid);
			if (isValid('URL', application.configBean.getAssetPath())) {
				return application.configBean.getAssetPath() & "/" & site.getFilePoolID() & "/assets";
			}
			return site.getFileAssetPath(complete=arguments.complete) & "/assets";
		</cfscript>
	</cffunction>

</cfcomponent>
